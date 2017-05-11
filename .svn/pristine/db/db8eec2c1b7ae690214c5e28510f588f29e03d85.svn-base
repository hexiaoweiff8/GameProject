--wnd_background.lua 背景界面
--Date：2015.9
--GYT

local wnd_backgroundClass = class(wnd_base)

wnd_background = nil--单例

function wnd_backgroundClass:Start() 
	wnd_background = self
	self:Init(WND.Background)
end
--退出当前窗体的执行操作
function wnd_backgroundClass:quitNowWindon(gameObj)
	local window = self:ShowOnbackground()
	window:Hide()
	if (window == wnd_beibao) then
		-- 隱藏背包物品信息側邊欄
		wnd_beibao.itemInfo:SetActive (false)
	end
	if (window == wnd_readyfight) then
		wnd_readyfight:lost()
		self:Hide()
	elseif window == self.ShowList[1] then
		self:Hide()
		wnd_main:Show()
	end
end
--将当前显示在背景上的窗体存起来
function wnd_backgroundClass:ShowListOnbackground(window)
	self.ShowList = {}
	table.insert(self.ShowList,window)
end
--得到背景上最上层窗体
function wnd_backgroundClass:ShowOnbackground()
--	if #self.ShowList == 0 then
--		wnd_main:Show()
--	else
		return self.ShowList[#self.ShowList]
--	end	
end
--初始化实例
function wnd_backgroundClass:OnNewInstance()
    --绑定背景返回按钮退出当前正显示的窗体
    self:BindUIEvent("btn_back",UIEventType.Click,"quitNowWindon")
end
--实例即将被丢失
function wnd_backgroundClass:OnLostInstance()
end 
 
return wnd_backgroundClass.new
 