--事件
Event = classWC()


function Event:ctor()
	self.m_Listeners = {}--监听者队列
end


--增加监听者
function Event:AddListener(obj,func)
	local listenerInfo = {
		obj = obj,
		func = func
	}
	self.m_Listeners[listenerInfo] = listenerInfo
end

--移除监听者
function Event:RemoveListener(obj,func)
	for _,listenerInfo  in pairs(self.m_Listeners) do 
		if(listenerInfo.obj==obj and listenerInfo.func==func) then
			self.m_Listeners[listenerInfo] = nil
			return 
		end
	end
end

--触发事件
function Event:Call(param,param1,param2,param3)
	local clond = table.shallowCopy(self.m_Listeners) 
 
	local eachfunc = function(key, value)
        local func = value.func
		func(value.obj,param,param1,param2,param3)
	end
	
	table.foreach(clond,eachfunc) 
end