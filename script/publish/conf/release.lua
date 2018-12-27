local util = require "bw.util"
local conf = require "conf"
conf = util.clone(conf)
conf.desc = "share(正式服)"
conf.remote_host = "www@kid.xqw369.com"
conf.remote_port = 22
conf.remote_path = "/mnt/data/server/share"
conf.etcname = "shared"
conf.clustername = "share"
conf.cluster = {
    share   = "127.0.0.1:19801",
}
conf.mongo = {
    host = "127.0.0.1",
    name = "xqw_beta",
    port = 19800,
    user = "xqw",
    password = "1qaz2wsx",
}
conf.webconsole = {
    host = "kid.xqw369.com",
    port = 9895,
}
conf.debug_console = {
    host = "kid.xqw369.com",
    port = 9894,
}
conf.alert.enable = true
return conf
