--协程组件

local CO = nil

--全局接口
function Yield(delay)
	CO:Yield(delay)
end

function StartCoroutine(_self,func,param)
	CO:StartCoroutine(_self,func,param)
end
 
--协程组件
local cm_coroutine = class()

function cm_coroutine:ctor()
	self.m_coattrs = {}--存储运行中的协程
	CO = self
end

 
	
function cm_coroutine:Update()
	local lcoattrs = table.shallowCopy(self.m_coattrs)
 
	 local eachfunc = function(key, value)
		value.lostT = value.lostT+Time.deltaTime()--总时间增加
		if(value.lostT>=value.delay) then
			--value.lostT=value.lostT-value.delay
			value.lostT = 0

			self.activeCO = value

            
			local _st,delay = coroutine.resume(value.co,value._self,value.pm)
			local st = coroutine.status(value.co)

			if(delay==nil) then delay=0 end
			
			if(st~="dead") 
			then
				value.delay = delay
			else
				self.m_coattrs[key] = nil
			end
		end--if(value.lostT>= ...
	end
	
	table.foreach(lcoattrs,eachfunc) 
end


function cm_coroutine:Yield(delay)
	coroutine.yield(delay)
end

--启动一个协程
function cm_coroutine:StartCoroutine(_self,func,param,delay)
	local co = coroutine.create(func)
	if(delay==nil) then delay = 0 end
			 
	local coattr = {
		co = co,
		_self = _self,
		pm = param,
		delay = delay,
		lostT = 0,
	} 
	
	self.m_coattrs[co] = coattr
end

return cm_coroutine.new