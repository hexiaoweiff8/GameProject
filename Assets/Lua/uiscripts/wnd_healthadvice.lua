--region *.lua
--Date 20160105
--健康忠告界面
--Author Wenchuan
local class = require("common/middleclass")
local wnd_healthadvice = class("wnd_healthadvice", wnd_base)

--窗体显示完成
function wnd_healthadvice:OnShowDone()
    coroutine.start(function()--开场还没加载到所以用协程
        coroutine.wait(2)
        --TODODO
        ui_manager:ShowWB(WNDTYPE.Login)
        -- ui_manager:ShowWB(WNDTYPE.ui_equip)
        -- ui_manager:ShowWB(WNDTYPE.ui_chongzhu)
        -- ui_manager:DestroyWB(self)
    -- ui_manager:ShowWB(WNDTYPE.ui_kejitree)
    end)
end


return wnd_healthadvice
