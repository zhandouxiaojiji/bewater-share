local skynet        = require "skynet.manager"
local cluster       = require "skynet.cluster"
local clusterinfo   = require "bw.util.clusterinfo"
local util          = require "bw.util"
local log           = require "bw.log"
local cms           = require "cms.cms"
local conf          = require "conf"

local trace = log.trace("shared")

local CMD = {}
function CMD.stop()
    skynet.call("autoid", "lua", "stop")
    skynet.timeout(0, function()
        skynet.abort()
    end)
end

function CMD.node_start(cname, caddr)
    trace("node_start:%s, %s", cname, caddr)
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

    cms.init()

    log.sighup()
    skynet.dispatch("lua", function(_,_, cmd, ...)
        if cmd == "SIGHUP" then
            return CMD.stop()
        end
        local f = assert(CMD[cmd])
        util.ret(f(...))
    end)
end)
