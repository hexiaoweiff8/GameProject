--region *.lua
--Date 20151014
--委托

Delegate = classWC()


function Delegate:ctor()
	self.obj = nil
	self.func = nil
end


--设置监听者
function Delegate:SetListener(obj,func)
	self.obj = obj
	self.func = func 
end

function Delegate:IsEmpty()
	local re = (self.obj==nil or self.func==nil) 
	return re
end
 

--触发事件
function Delegate:Call(...)
	if self:IsEmpty() then return nil end 
	return self.func(self.obj,...) 
end

function Delegate_Call(obj,func,...)
	func(obj,...) 
end

--endregion
