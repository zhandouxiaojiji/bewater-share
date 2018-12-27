local skynet    = require "skynet"
local wc        = require "bw.cms.webconsole"
local conf      = require "conf"

local M = {}
function M.init()
    wc.init({
        port = conf.webconsole.port,
        users = {
            {account = "root", password = "123"}
        },
        menu = {
            {name = "skynet", title = "Skynet", icon = "&#xe665;", children = {
                {title = "节点信息", icon = "&#xe857", href = "/cms/view/node_info"},
                {title = "所有服务", icon = "&#xe62d;", href = "/cms/view/all_service"},
                {title = "注入调试", icon = "&#xe631;", href = "/cms/view/inject"},
                {title = "GM", icon = "&#xe64e;", href = "/cms/view/gm"},
            }},
        }
    }) 
end

return M
