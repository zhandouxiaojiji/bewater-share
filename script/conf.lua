local skynet = require "skynet"
local conf = {
    workspace = skynet.getenv('workspace'),

    proj = "share",
    desc = "数据共享中心(开发服)",
    webconsole = {
        host = "huangjx.top",
        port = 9995,
    },
    debug_console = {
        host = "huangjx.top",
        port = 9994,
    },

    mongo = {
        host = "127.0.0.1",
        name = "xqw_alpha",
        port = 19900,
        user = "xqw",
        password = "1qaz2wsx",
    },
    --whitelist = true,

    -- 通用节点
    cluster = {
        share   = "127.0.0.1:19901",
    },
    clustername = skynet.getenv "clustername",

    alert = { 
        enable      = true,
        corpid      = 'dingbf0f32a0c5a10f0735c2f4657eb6378f',
        corpsecret  = 'AcAsZghgptCKZb-_6g2sV_e96A63Dn7T2v3M41QPU9euHodRDpwpezZUaPLwGqlX',
        sender      = 'manager3375',
        chatid      = 'chatc342986381ccae6028a690369580d9d0',
    },

    MAX_LOGINING = 10,
}

return conf
