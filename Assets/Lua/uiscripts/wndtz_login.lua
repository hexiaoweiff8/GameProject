--region *.lua
--Date 20150804
--登陆界面
--作者 wenchuan
local class = require("common/middleclass")
local class_wnd_login = class("class_wnd_login", wnd_base)
require("manager/Message_Manager")
Message_Manager = Message_Manager()
require("uiscripts/redDotControl")
redDotControl = redDotControl()

function class_wnd_login:OnShowDone()
    local btn_go = self.transform:Find("mainpanel/btn_go").gameObject
    UIEventListener.Get(btn_go).onPress = function(btn_go, args)
        if args then
             --ui_manager:ShowWB(WNDTYPE.ui_equip)
			 ui_manager:ShowWB(WNDTYPE.Prefight)
            -- ui_manager:ShowWB(WNDTYPE.ui_kejitree)
            --TODODO
            --
            -- Message_Manager.SendPB_10004(equipP.allEqList[1][1].EquipUniID)
            -- Message_Manager.SendPB_10005(equipP.allEqList[1][1].EquipUniID, 1 - equipP.allEqList[1][1].IsLock)
            -- Message_Manager.SendPB_10006(equipP.allEqList[1][1].EquipUniID)
            -- Message_Manager.SendPB_10007(equipP.allEqList[1][1].EquipUniID, 5)
            -- Message_Manager.SendPB_10008(equipP.allEqList[1][1].EquipUniID, 5, 3)
                    
			--jyp cardyc测试
           
	        -- 
            -- ui_manager:ShowWB(WNDTYPE.Cardyc)
        end
    end
end


function class_wnd_login:OnAddHandler()
    Message_Manager.SendPB_10001()
    Message_Manager:OnAddHandler()
end
return class_wnd_login
