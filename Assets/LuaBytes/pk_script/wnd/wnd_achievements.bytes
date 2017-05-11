--wnd_achievements.lua
--Date
--此文件由[BabeLua]插件自动生成


local wnd_achievementsClass = class(wnd_base)

wnd_achievements = nil--单例
local chengjiuType = {
	all = 1,
    type1 = 2,
    type2 = 3,
	type3 = 4,
	type4 = 5,
}
local table ={
	{type = 1 , jindu = 10},
	{type = 2 , jindu = 14},
	{type = 3 , jindu = 56},
	{type = 4 , jindu = 46},
	{type = 5 , jindu = 98},
}
function wnd_achievementsClass:Start() 
	wnd_achievements = self
	self:Init(WND.Achievements)
end
--窗体被实例化时被调用
--初始化实例
function wnd_achievementsClass:OnNewInstance()
	self:BindUIEvent("tab_sj",UIEventType.Click,"OnClickChannel",chengjiuType.all)
	self:BindUIEvent("tab_gz",UIEventType.Click,"OnClickChannel",chengjiuType.type1)
	self:BindUIEvent("tab_sl",UIEventType.Click,"OnClickChannel",chengjiuType.type2)
	self:BindUIEvent("tab_gz",UIEventType.Click,"OnClickChannel",chengjiuType.type3)
	self:BindUIEvent("tab_sl",UIEventType.Click,"OnClickChannel",chengjiuType.type4)
--	self:SetLabel("title/txt1","个人信息")

--	self:BindUIEvent ("btn_1", UIEventType.Click, "OnheadClick")
end
function wnd_achievementsClass:OnClickChannel(Type)
	if Type == 1 then
		self:chooseAll()
	elseif Type == 2 then
		self:choosetype1()
	elseif Type == 3 then
		self:choosetype2()
	elseif Type == 4 then
		self:choosetype3()
	elseif Type == 5 then
		self:choosetype4()
	end
end 
function wnd_achievementsClass:chooseAll()
	
end 
function wnd_achievementsClass:choosetype1()
end 
function wnd_achievementsClass:choosetype2()
end 
function wnd_achievementsClass:choosetype3()
end 
function wnd_achievementsClass:choosetype4()

end 
--实例即将被丢失
function wnd_achievementsClass:OnLostInstance()
end 

return wnd_achievementsClass.new
 

--endregion
