--region *.lua
--Date 20150804
--登陆界面
--作者 wenchuan
wnd_login = nil --单例
local class = require("common/middleclass")
local class_wnd_login = class("class_wnd_login", wnd_base)


function class_wnd_login:initialize()
    wnd_base.initialize(self, WND.Login)
end

local isFirstShow = true

function class_wnd_login:RegStart()
    self:Init(WND.Login)
    wnd_login = self
end


function class_wnd_login:OnShowDone()
--显示主面板
end
function class_wnd_login:OnHideFinish()
--显示主面板
end

function class_wnd_login:OnNewInstance()
    local btn_go = self.UI.transform:Find("mainpanel/btn_go").gameObject
    UIEventListener.Get(btn_go).onPress = function(btn_go, args)
        wnd_login:Hide()
        WndManage.LoadMainBaseActors()
    end
end
function class_wnd_login:OnLostInstance()
end

function class_wnd_login:Show(duration)
    
    self:_Show(duration)
end


return class_wnd_login
