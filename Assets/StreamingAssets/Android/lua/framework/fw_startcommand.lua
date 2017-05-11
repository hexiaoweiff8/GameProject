-- region *.lua
-- Date
-- 此文件由[BabeLua]插件自动生成
local class = require("common/middleclass")

local network_manager = require "manager/network_manager"

local fw_command = require "framework/fw_command"

local fw_startcommand = class("fw_startcommand", fw_command)
function fw_startcommand:initialize()
end

function fw_startcommand:execute(msg)
    print("fw_startcommand")
    fw_facade:instance():add_mgr(mgr_name.NET_MGR, network_manager:instance())
    UNetworkManager:SetLuaTable(network_manager())
end

return fw_startcommand
