--region *.lua
--Date  2016/8/10
--author shenhuyun
--此文件由[BabeLua]插件自动生成


local wnd_successClass = class(wnd_base)

wnd_success = nil--单例

function wnd_successClass:Start() 
	wnd_success = self
	self:Init(WND.Success)
end
function wnd_successClass:showType(t) 
	self.type = t
end
function wnd_successClass:OnShowDone()
    
    self.backObj:ResetToBeginning()
    self.backObj:PlayForward()
    self.successObj:ResetToBeginning()
    self.successObj:PlayForward()
	if self.type == 1 then--升星
		self:bIsShow(true,false,false,false,false)
		self.shengxingObj:PlayForward()
	elseif self.type == 2 then--升级
		self:bIsShow(false,true,false,false,false)
		self.shengjiObj:PlayForward()
	elseif self.type == 3 then--洗练
		self:bIsShow(false,false,true,false,false)
		self.xilianObj:PlayForward()
	elseif self.type == 4 then--洗练
		self:bIsShow(false,false,false,true,false)
		self.zhaomuObj:PlayForward()
	elseif self.type == 5 then--攻城
		self:bIsShow(false,false,false,false,true)
		self.gongchengObj:PlayForward()
	else
		--Poptip.PopMsg("错误操作",Color.red)
	end    
end

function wnd_successClass:bIsShow(b1,b2,b3,b4,b5)
	self:SetWidgetActive("success/shengxing",b1)
	self:SetWidgetActive("success/shengji",b2)
	self:SetWidgetActive("success/xilian",b3)   
	self:SetWidgetActive("success/zhaomu",b4)   
	self:SetWidgetActive("success/gongcheng",b5)   
end
--初始化实例
function wnd_successClass:OnNewInstance()
    self.back = self.instance:FindWidget("ui_success/back_btn")
    self.backObj = self.back:GetComponent(CMUITweener.Name)

    self.success = self.instance:FindWidget("back_btn/success")
    self.successObj = self.success:GetComponent(CMUITweener.Name)

    self.shengxing = self.instance:FindWidget("success/shengxing")
    self.shengxingObj = self.shengxing:GetComponent(CMUITweener.Name)

	self.shengji = self.instance:FindWidget("success/shengji")
    self.shengjiObj = self.shengji:GetComponent(CMUITweener.Name)

	self.xilian = self.instance:FindWidget("success/xilian")
    self.xilianObj = self.xilian:GetComponent(CMUITweener.Name)

	self.zhaomu = self.instance:FindWidget("success/zhaomu")
    self.zhaomuObj = self.zhaomu:GetComponent(CMUITweener.Name)

	self.gongcheng = self.instance:FindWidget("success/gongcheng")
	self.gongchengObj = self.gongcheng:GetComponent(CMUITweener.Name)

    self:SetLabel("ui_success/back_btn/txt",SData_Id2String.Get(5032))

    self:BindUIEvent("ui_success/back_btn",UIEventType.Click,"OnBackBtn")
end


--卸载窗体
function wnd_successClass:OnBackBtn()
    EventHandles.OnWndExit:Call(WND.Success)  
	if self.type == 5 then--攻城
		if wnd_tuiguan.sjt ~= nil and wnd_tuiguan.sjt ~= 0 then
			wnd_randomEvents:JLData(wnd_tuiguan.sjt,wnd_tuiguan.sjinfo,wnd_tuiguan.sjid)
			wnd_randomEvents:Show()
		end
	end 
end


--实例即将被丢失
function wnd_successClass:OnLostInstance()

end 
 
return wnd_successClass.new
 

--endregion
