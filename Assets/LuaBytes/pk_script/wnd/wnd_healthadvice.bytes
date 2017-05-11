--region *.lua
--Date 20160105
--健康忠告界面
--Author Wenchuan
local wnd_healthadviceClass = class(wnd_base)

wnd_healthadvice = nil--单例

function wnd_healthadviceClass:Start() 
	wnd_healthadvice = self
	self:Init(WND.Healthadvice,true)
end

  
--初始化实例
function wnd_healthadviceClass:OnNewInstance()
	--绑定事件
    
end

--窗体显示完成
function wnd_healthadviceClass:OnShowDone()
	StartCoroutine(self,self.coHide,{})
end
  
function wnd_healthadviceClass:coHide(param)
	local t = 2.0--ifv(debug.IsDev(),0.1,2.0)
	local now = DateTime.Now()
	while(t>0) do   
		Yield(0.1)
		local new_now = DateTime.Now()
		t=t-(new_now - now):TotalSeconds()--Time.deltaTime()	
		now = new_now
	end
	self:Hide()
end
 
return wnd_healthadviceClass.new

--endregion
