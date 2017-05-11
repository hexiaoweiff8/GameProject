--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local wnd_ReadyToFightClass = class(wnd_base)
    wnd_ReadyToFight = nil


function wnd_ReadyToFightClass:Start()
    print("wnd_ReadyToFightClass:Start")
	wnd_ReadyToFight = self
	self:Init(WND.ReadyToFight)
end

function wnd_ReadyToFightClass:OnNewInstance()

end

function wnd_ReadyToFightClass:OnLostInstance()
    
end

function wnd_ReadyToFightClass:OnShowDone()

end


--[[
    
--
function wnd_ReadyToFightClass:()
    print("wnd_ReadyToFightClass:")
end

]]

 return wnd_ReadyToFightClass.new

--endregion
