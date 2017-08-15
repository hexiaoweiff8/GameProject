require("common/init")
require("framework/init")
require("gameEventType")
--[[
	导入inspect全局调试工具类
	Usage:
		local str = inspect(<table>)
		print(str)
]]
inspect = require 'common/inspect'

--高亮打印
function lgyPrint(log)
    if true then --控制输出log开关
        LGYLOG.Log(log .. "")
    end
end
function printe(object)
	if type(object) ~= 'table' and type(object) ~= 'userdata' and type(objec) ~= 'boolean'
			and type(object) ~= 'function' and type(object) ~= 'thread' then
		UnityEngine.Debug.Log("<size=26><color=#FF4040>" .. (object ~= nil and object or 'nil') .. "</color></size>")
	else
		print(object)
	end
end
function printw(object)
	if type(object) ~= 'table' and type(object) ~= 'userdata' and type(objec) ~= 'boolean'
			and type(object) ~= 'function' and type(object) ~= 'thread' then
		UnityEngine.Debug.Log("<size=25><color=yellow>" .. (object ~= nil and object or 'nil') .. "</color></size>")
	else
		print(object)
	end
end
function printf(object)
	if type(object) ~= 'table' and type(object) ~= 'userdata' and type(objec) ~= 'boolean'
			and type(object) ~= 'function' and type(object) ~= 'thread' then
		UnityEngine.Debug.Log("<size=25><color=cyan>" .. (object ~= nil and object or 'nil') .. "</color></size>")
	else
		print(object)
	end
end

-- string_table = require("globalization/zh/string_table")

GameObject = UnityEngine.GameObject
Object = UnityEngine.Object
Input = UnityEngine.Input
BoxCollider = UnityEngine.BoxCollider
Resources = UnityEngine.Resources
Application = UnityEngine.Application
RuntimePlatform = UnityEngine.RuntimePlatform
Debug = UnityEngine.Debug
-- SceneManager = UnityEngine.SceneManagement.SceneManager

networkMgr = LuaHelper.GetNetManager()
allTimeTickerTb = {}--贯穿整个游戏的定时器

local network_manager = require "manager/network_manager"
networkMgr:SetLuaTable(network_manager())
networkMgr:SendConnect()

require("uiscripts/wnd_base")
require("uiscripts/cm_gameinit_pan")
require("uiscripts/main/NetworkDelay_Manager")

require("uiscripts/equipP")
require("uiscripts/kejiP")
require("uiscripts/Const")
require("uiscripts/commonModel/card_Model")
require("uiscripts/commonModel/user_Model")
require("uiscripts/commonModel/item_Model")
require("uiscripts/commonModel/currency_Model")
require("uiscripts/commonModel/equip_Model")

require("uiscripts/main/ui_main_controller")

--引用工具类
require("uiscripts/Util/stringUtil")
require("uiscripts/Util/cardUtil")
require("uiscripts/Util/colorUtil")
require("uiscripts/Util/spriteNameUtil")
require("uiscripts/Util/attributeUtil")
require("uiscripts/Util/equipSuitUtil")
require("uiscripts/Util/soldierUtil")
require("uiscripts/Util/synergyUtil")
require("uiscripts/Util/skillUtil")
require("uiscripts/Util/starUtil")
require("uiscripts/Util/itemUtil")
require("uiscripts/Util/qualityUtil")
require("uiscripts/Util/equipUtil")
require("uiscripts/Util/dotweenUtil")
require("uiscripts/Util/borderUtil")
require("uiscripts.Util.dayilymissionUtil")
require("uiscripts.Util.subtlecodeUtil")


-- require('uiscripts/Util/consoleUtil')