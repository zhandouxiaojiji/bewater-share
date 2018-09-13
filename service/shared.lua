local skynet        = require "skynet.manager"
local cluster       = require "skynet.cluster"
local clusterinfo   = require "clusterinfo"
local conf          = require "conf"
local util          = require "util"
local log           = require "log"

local CMD = {}
function CMD.stop()
    skynet.call("autoid", "lua", "stop")
    skynet.timeout(0, function()
        skynet.abort()
    end)
end

function CMD.node_start(cname, caddr)
    conf.cluster[cname] = caddr 
    cluster.reload(conf.cluster)
end

skynet.start(function()
    cluster.reload(conf.cluster)
    cluster.open(clusterinfo.clustername)
    skynet.register "svr"

    skynet.dispatch("lua", function(_,_, cmd, ...)
        local f = assert(CMD[cmd], ...)
        util.ret(f(...))
    end)
    
    local addr = skynet.newservice("autoid")
    skynet.call(addr, "lua", "start")
    skynet.newservice("passport")
    skynet.newservice("operate")

    log.sighup()
    skynet.dispatch("lua", function(_,_, cmd, ...)
        if cmd == "SIGHUP" then
            return CMD.stop()
        end
        local f = assert(CMD[cmd])
        util.ret(f(...))
    end)
end)
