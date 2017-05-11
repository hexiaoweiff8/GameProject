--region *.lua
--Date 20151119
--Author Wenchuan
--界面倒计时组件

local CMUICountDown = classWC()

function CMUICountDown:ctor()
	self.m_TextFillFunc = Delegate.new() --文本填充委托
	self.m_CountDownEndFunc = Delegate.new() --倒计时结束委托
	self.m_Doing = false; --当前是否正在工作
end

--- <summary>
--- 开始倒计时
--- t int 倒计时秒数
--- </summary> 
function CMUICountDown:StartCountDown(t) 
	self:SetEnable(true) --启用本组件
	self.m_Doing = true; --置是否正在工作标记
	local startTime = DateTime.Now()--开始记时的时间点
	self.m_EndTime = startTime + TimeSpan.new(0,0,0,t,0)--计算出终止时间 
	self.lostTime = 0
end

--- <summary>
--- 设置文本填充函数
--- selfclass 回调接收类
--- func( time_num,time_str ) 回调接收函数
--- </summary> 
function CMUICountDown:SetTextFillFunc(selfclass,func) 
	self.m_TextFillFunc:SetListener(selfclass,func) 
end


---组件被禁用
function CMUICountDown:OnDisable()
	self.m_Doing = false --下次启用时，不再继续工作
end

--- <summary>
--- 设置倒计时结束的回调函数
--- selfclass 回调接收类
--- func() 回调接收函数
--- </summary> 
function CMUICountDown:SetCountDownEndFunc(selfclass,func) 
	self.m_CountDownEndFunc:SetListener(selfclass,func) 
end


function CMUICountDown:Update()
	if(not self.m_Doing) then  --组件在不需要工作时，自动禁用
		self:SetEnable(false) --禁用本组件，组件被禁用Update将不会被调用，提高效率
		return 
	end

	
	self.lostTime = self.lostTime+Time.deltaTime()--累加帧耗时
	if(self.lostTime<0.5) then  return end--控制刷新频率，0.5秒以上间隔才允许刷新，大约每秒2帧
	self.lostTime = 0--清累计的耗时
	  
	local timeSpan = self.m_EndTime - DateTime.Now() --计算出剩余的时间间隔 

	local surplusTime = timeSpan:TotalSeconds();--剩余秒数
	if(surplusTime<0) then surplusTime = 0 end--纠错，防止显示错误

	local timestr = _GetTimeFormat(surplusTime);--当前时间的字符串形式
	self.m_TextFillFunc:Call(surplusTime,timestr) --刷新显示文本，逻辑层也可以在函数里做一些高级操作
	 
	if(surplusTime<=0) then  --倒计时结束
		self.m_Doing = false --置是否正在工作标记
		self.m_CountDownEndFunc:Call() --回调
	end
end
 

return CMUICountDown.new
 
--endregion
