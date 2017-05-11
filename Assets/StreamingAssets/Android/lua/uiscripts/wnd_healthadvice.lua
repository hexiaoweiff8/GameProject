--region *.lua
--Date 20160105
--健康忠告界面
--Author Wenchuan
local class = require("common/middleclass")
wnd_healthadvice = class("wnd_healthadvice", wnd_base)


function wnd_healthadvice:initialize()
    wnd_base.initialize(self, WND.Healthadvice)
end

function wnd_healthadvice:RegStart()
    wnd_healthadvice = self
    self:Init(WND.Healthadvice, true)
end


--初始化实例
function wnd_healthadvice:OnNewInstance()
--绑定事件
end

--窗体显示完成
function wnd_healthadvice:OnShowDone()
    
    coroutine.start(function()--开场还没加载到所以用协程
        coroutine.wait(2)
        self:Hide()
        -- wnd_login:Show()
        ui_manager:show_wnd_base(wnd_login)
    end)
end

return wnd_healthadvice
