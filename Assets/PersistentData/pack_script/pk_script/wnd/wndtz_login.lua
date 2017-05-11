--region *.lua
--Date 20150804
--登陆界面
--作者 wenchuan

 

wnd_login = nil--单例
local class1 = require("common/middleclass")
local class_wnd_login = class1("class_wnd_login", wnd_base)


--local class_wnd_login = class(wnd_base)

local isFirstShow = true

function class_wnd_login:Start()
	self:Init(WND.Login )
	wnd_login = self	
end


function class_wnd_login:OnShowDone()
	--显示主面板
	 print("********---dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd显示主面板")
end
function class_wnd_login:OnHideFinish()
	--显示主面板
	
end

function class_wnd_login:OnNewInstance()
	local btn_go =  self.UI.transform:Find("mainpanel/btn_go").gameObject 
     UIEventListener.Get(btn_go).onPress = function(btn_go, args)
       wnd_login:Hide()
       ui_fight_in:Show()
	   WndManage.LoadMainBaseActors()
     end
    print(btn_go.name) 
end
function class_wnd_login:OnLostInstance()
 print("********---dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd OnLostInstance显示主面板")
end

function class_wnd_login:Show(duration)
	
	self:_Show(duration)
end

function class_wnd_login:Hide(duration)
	
	self:_Hide(duration)
end

return class_wnd_login

--endregion
