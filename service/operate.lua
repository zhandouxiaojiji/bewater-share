local skynet    = require "skynet"
local cluster   = require "skynet.cluster"
local mongo     = require "db.mongo_helper"
local util      = require "util"
local opcode    = require "def.opcode"
local log       = require "log"

local trace = log.trace("operate")

local M = {}
function M:init()
    self.batch_list = mongo.get("batch_operate") or {}
    self.players = mongo.find("operate", {}) or {}
end

function M:save_batch()
    mongo.save("batch_operate", self.batch_list)
end 

function M:save_player(uid)
    local player = self.players[uid]
    if not player then return end
    return mongo.update("operate", {uid = uid}, {
        uid = player.uid,
        time = player.time,
        operate_list = player.operate_list,
    })
end

function M:remove_player(uid)
    self.players[uid] = nil
    mongo.delete("operate", {uid = uid})
end

function M:get_player(uid)
    local player = self.players[uid]
    if not player then
        local data = mongo.find_one_with_default("operate", {uid = uid}, {
            uid = uid,
            time = os.time(),
            operate_list = {},
        }) 
        player = {
            uid = data.uid,
            time = data.time,
            operate_list = data.operate_list,
        }
        self.players[uid] = player
        trace("load player:%d", uid)
    end
    return player
end

function M:online(uid, cname, agent)
    local player = self:get_player(uid)
    player.cname = cname
    player.agent = agent
    
    local operate_list = player.operate_list or {}
    player.operate_list = {}
    
    for k, v in ipairs(self.batch_list) do
        if v.time > player.time then
            table.insert(operate_list, v) 
        end
    end
    player.time = os.time()
    self:save_player(uid)
    return operate_list
end

function M:offline(uid)
    local player = self:get_player(uid)
    player.cname = nil
    player.agent = nil
end

-- 批量操作(离线&在线)
function M:batch_operate(code, ...)
    local operate = {
        code = code,
        time = os.time(),
        params = table.pack(...)
    }
    table.insert(self.batch_list, operate)
    self:save_batch()
    for _, player in pairs(self.players) do
        if player.agent then
            self:operate(player.uid, code, ...)
        end
    end
end

-- 广播(针对在线玩家, id_list空表示全服广播)
function M:broadcast_operate(id_list, code, ...)
    for _, v in pairs(id_list or self.players) do
        local player = type(v) == "table" and v or self.players[v]
        if player and player.agent then
            self:operate(player.uid, code, ...)
        end
    end
end

function M:operate(uid, code, ...)
    -- 玩家在线
	local params = table.pack(...)
    local player = self:get_player(uid)
    if player.agent then
        util.try(function()
            cluster.call(player.cname, player.agent, uid, "operate", "operate", code, table.unpack(params))
            player.time = os.time()
            self:save_player(uid)
        end)
        return
    end

    -- 玩家离线
	local operate = {
		code = code,
        time = os.time(),
		params = params
	}
	table.insert(player.operate_list, operate)
    self:save_player(uid)
end

skynet.start(function()
    skynet.dispatch("lua", function(session, source, cmd, ...)
        local f = assert(M[cmd], cmd)
        util.ret(f(M, ...))
    end)

    M:init()    

    trace("start operate")
    
    skynet.register "operate"
end)
