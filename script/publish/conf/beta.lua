local util = require "bw.util"
local conf = require "conf"
conf = util.clone(conf)
conf.desc = "share(测试服)"
conf.remote_host = "www@coding1024.com"
conf.remote_port = 22
conf.remote_path = "/mnt/dev/server/share"
conf.etcname = "shared"
conf.clustername = "share"
conf.cluster = {
    share   = "127.0.0.1:19901",
}
conf.mongo = {
    host = "127.0.0.1",
    name = "xqw_beta",
    port = 19900,
    user = "xqw",
    password = "1qaz2wsx",
}
conf.webconsole = {
    host = "coding1024.com",
    port = 9997,
}
conf.debug_console = {
    host = "coding1024.com",
    port = 9996,
}
conf.alert.enable = true
return conf
