local skynet        = require "skynet.manager"
local cluster       = require "skynet.cluster"
local clusterinfo   = require "clusterinfo"
local conf          = require "conf"
local util          = require "util"

local CMD = {}
function CMD.stop()
    skynet.call("autoid", "lua", "stop")
    skynet.timeout(0, function()
        skynet.abort()
    end)
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

end)
