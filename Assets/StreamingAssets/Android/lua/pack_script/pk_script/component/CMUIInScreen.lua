local CMUIInScreen = classWC()

function CMUIInScreen:ctor()
    self.RecallFunc = Delegate.new() --文本填充委托
end

function CMUIInScreen:Update()
    if self.gameObject == nil then return end
    local wpos = self.gameObject:GetPosition()
    self.RecallFunc:Call(wpos.x > 2.71 or wpos.x < -2.81 or wpos.y > 1.6 or wpos.y < -1.3)
end

function CMUIInScreen:SetRecallFunc(selfclass,func) 
	self.RecallFunc:SetListener(selfclass,func) 
end
 

return CMUIInScreen.new
 
--endregion
