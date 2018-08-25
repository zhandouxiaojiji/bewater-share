local skynet = require "skynet"
local cluster   = require "skynet.cluster"
local conf   = require "conf"
local util   = require "util"

skynet.start(function()
    cluster.reload(conf.clustername)
    cluster.open(conf.cluster.name)
    skynet.register "svr"
    
    local addr = skynet.newservice("autoid")
    skynet.name(addr, "autoid")
    skynet.call(addr, "lua", "start")
end)
