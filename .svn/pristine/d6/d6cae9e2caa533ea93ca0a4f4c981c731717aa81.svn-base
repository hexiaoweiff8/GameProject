local wnd_gameinitClass = class(wnd_base)

wnd_gameinit = nil--单例

function wnd_gameinitClass:Start()  
	wnd_gameinit = self
    self:Init(WND.GameInit)		 
	self.jdvalue = 0--进度条当前值 
end


--初始化实例
function wnd_gameinitClass:OnNewInstance()
	local gameObject = self.instance:FindWidget("ui_gameinit_jd")--获取进度条对象
	self.cmUISlider = gameObject:GetComponent(CMUISlider.Name)--获取进度条组件
	
	self:SetJD(self.jdvalue)--设置界面当前进度
end
 
--实例即将被丢失
function wnd_gameinitClass:OnLostInstance()
	self.cmUISlider = nil
end 

function wnd_gameinitClass:SetJD(v)
	self.jdvalue = v
	if(self.cmUISlider == nil) then return end
	self.cmUISlider:SetValue(self.jdvalue)--设置界面当前进度
end

function wnd_gameinitClass:GetJD()
	return self.jdvalue
end
 
return wnd_gameinitClass.new
 