local skynet = require "skynet.manager"
local mongo = require "db.mongo_helper"
local util = require "util"

local RESERVE_COUNT = 100

local reserve_id
local id

local CMD = {}
function CMD.start()
    id = mongo.get("autoid", 10000000)
    reserve_id = id + RESERVE_COUNT
end

function CMD.stop()
    mongo.set("autoid", id)
end

function CMD.create(count)
    count = count or 1
    local start_id = id
    id = id + count
    if id > reserve_id then
        reserve_id = id + RESERVE_COUNT
        mongo.set("autoid", reserve_id)
    end
    return start_id, count
end

skynet.start(function()
    skynet.dispatch("lua", function(_,_, cmd, ...)
        local f = assert(CMD[cmd], cmd)
        util.ret(f(...))
    end)
    skynet.register "autoid"
end)
