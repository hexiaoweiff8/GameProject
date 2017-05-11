--wnd_achievements.lua
--Date
--此文件由[BabeLua]插件自动生成


local wnd_gainmethodClass = class(wnd_base)

wnd_gainmethod = nil--单例
local gainmethodType = {
	wndhero = 1,--武将界面
	wndheroperview = 2,--武将预览界面
    getHero = 3, --未知武将获取
}
function wnd_gainmethodClass:Start() 
	wnd_gainmethod = self
	self:Init(WND.Gainmethod)
end
--窗体被实例化时被调用
--初始化实例
function wnd_gainmethodClass:OnNewInstance()
	self.bIsShow = false
	self:BindUIEvent("btn_gain",UIEventType.Click,"OnClick")
	self:BindUIEvent("ui_gainmethod/bg",UIEventType.Click,"OnBackClick")
	self:BindUIEvent("method_change/btn_one",UIEventType.Click,"changesuipian",1)
	self:BindUIEvent("method_change/btn_ten",UIEventType.Click,"changesuipian",10)
end
function wnd_gainmethodClass:ShowData(wndType,heroOrshibingType,hid)
	self.Type = wndType
	self.huoqutype = heroOrshibingType
	self.HID = hid--武将id
	self:GetData()
end 
function wnd_gainmethodClass:GetData()
	if self.Type == 1 then
			local num = 0
			local bili = 0
			self.tit = 0
			local tyPe = 0
			local herolist = SData_Hero.GetHero(self.HID)
			if self.huoqutype == 1 then 
				num = Player:GetNumberAttr(PlayerAttrNames.Tysp)
				bili = herolist:TongYongSuiPian()
				self.tit = 5185
				tyPe = 5189
			elseif self.huoqutype == 2 then 
				num = Player:GetCommItemsNum(21) 
				self.SHID = herolist:Army()
				local Army = SData_Army.GetRow(herolist:Army())
				bili = Army:TongYongSuiPian()
				self.tit = 5196
				tyPe = 5195	
			end	
			self.strnum = string.sformat(SData_Id2String.Get(tyPe),num)
			self.strbili = string.sformat(SData_Id2String.Get(5188),bili)
		end
end
function wnd_gainmethodClass:OnShowDone()
	if self.bIsShow  then
		self:GetData()
	else
		self.bIsShow = true
	end
	self:SetLabel("title_bg/txt",SData_Id2String.Get(5183))
	self:SetLabel("method_single/method_name",SData_Id2String.Get(5001))
	self:SetLabel("btn_gain/txt",SData_Id2String.Get(5184))
	self:SetWidgetActive("method_single",false)
	if self.Type == 1 then
		self:SetLabel("method_change/method_name",SData_Id2String.Get(self.tit))
		self:SetLabel("method_change/proportion",self.strbili)
		self:SetLabel("method_change/amount",self.strnum)
		self:SetLabel("btn_one/txt",SData_Id2String.Get(5186))--兑换一个
		self:SetLabel("btn_ten/txt",SData_Id2String.Get(5187))--兑换十个

		self:SetWidgetActive("method_change",true)	
	else 
		self:SetWidgetActive("method_change",false)	
	end	
	local container = self.instance:FindWidget("methodgrid")
	local cmGrid = container:GetComponent(CMUIGrid.Name)
	cmGrid:Reposition()	
end 
function wnd_gainmethodClass:changesuipian(obj,t)
--n:csp,
--t:<碎片类型 int>,
--id:<对应id int>,
--num:<兑换数量 int>
	local id = 0
	if self.huoqutype == 1 then
		id = self.HID
	elseif self.huoqutype == 2 then
		id = self.SHID
	end
	self.duihuanNum = t
	local jsonNM = QKJsonDoc.NewMap()	
    jsonNM:Add ("n","csp")
	jsonNM:Add ("t",self.huoqutype)    
	jsonNM:Add ("id",id)  
	jsonNM:Add ("num",t)  
    local loader = GameConn:CreateLoader(jsonNM,0)
    HttpLoaderEX.WaitRecall(loader,self,self.nm_PerformanceCallBack)
end 
function wnd_gainmethodClass:nm_PerformanceCallBack(jsonDoc)
	local num = tonumber (jsonDoc:GetValue("r"))
	if num == 0 then
		Poptip.PopMsg(SData_Id2String.Get(3124),Color.green)
		if self.huoqutype == 1 then--武将
			self:SetLabel("method_change/amount",string.sformat(SData_Id2String.Get(3129),Player:GetNumberAttr(PlayerAttrNames.Tysp)) )--self.duihuanNum
		elseif self.huoqutype == 2 then--士兵
			self:SetLabel("method_change/amount",string.sformat(SData_Id2String.Get(3106),Player:GetCommItemsNum(21)) )--self.duihuanNum
		end
		wnd_heroinfo:duihuanrefresh(self.huoqutype)
	elseif num == 1 then
		Poptip.PopMsg(SData_Id2String.Get(3125),Color.red)
	else
		Poptip.PopMsg(SData_Id2String.Get(5000),Color.red)
	end

end

function wnd_gainmethodClass:OnClick()
	if self.Type == 1 then 
		WndJumpManage:Jump(WND.Gainmethod,WND.ChouJiang)
	elseif  self.Type == 2 then 
		WndJumpManage:Jump(WND.HeroPerview,WND.ChouJiang)
    elseif self.Type == 3 then 
	    WndJumpManage:Jump(WND.Gainmethod,WND.ChouJiang)
	end
	--self:Hide()
end 
function wnd_gainmethodClass:OnBackClick()
	self:Hide()
end 
--实例即将被丢失
function wnd_gainmethodClass:OnLostInstance()
end 

return wnd_gainmethodClass.new
 

--endregion
