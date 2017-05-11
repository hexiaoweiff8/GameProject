--wnd_achievements.lua
--Date
--此文件由[BabeLua]插件自动生成


local wnd_GuankaJuqinClass = class(wnd_base)

wnd_GuankaJuqing = nil--单例

function wnd_GuankaJuqinClass:Start() 
	wnd_GuankaJuqing = self
	self:Init(WND.GuankaJuqing)
end
function wnd_GuankaJuqinClass:CurrentGuan(GKID,Type)
	self.Type = Type
	self.GKid = GKID
	
end
--窗体被实例化时被调用
--初始化实例
function wnd_GuankaJuqinClass:OnNewInstance()
	self:BindUIEvent("skip_btn",UIEventType.Click,"OnClose")
end
function wnd_GuankaJuqinClass:OnShowDone()
	self.Self = 1
	self.Amry = true
	self:ShowJuQing()
end
function wnd_GuankaJuqinClass:ShowJuQing()
	local linId = 0
	if  self.Type == 4 then
		linId = self.GKid
	else
		linId = sdata_MissionMonster:GetV(sdata_MissionMonster.I_LineID,self.GKid)
	end
	local SelfTable = ""
	local AmryTable = ""
	local selfID = 0
	local AmryID = 0
	if self.Type == 2 or self.Type == 4 then
		SelfTable = sdata_DialogueData:GetV(sdata_DialogueData.I_TalkSelf,linId)
		selfID =  sdata_DialogueData:GetV(sdata_DialogueData.I_SelfHeadID,linId)
		AmryTable = sdata_DialogueData:GetV(sdata_DialogueData.I_TalkEnemy,linId)
		AmryID = sdata_DialogueData:GetV(sdata_DialogueData.I_EnemyHeadID,linId)
	elseif self.Type == 3 then
		SelfTable = sdata_DialogueData:GetV(sdata_DialogueData.I_AsideSelf,linId)
		selfID =  sdata_DialogueData:GetV(sdata_DialogueData.I_AsideSelfHeadID,linId)
		AmryTable = sdata_DialogueData:GetV(sdata_DialogueData.I_AsideEnemy,linId)
		AmryID = sdata_DialogueData:GetV(sdata_DialogueData.I_AsideEnemyHeadID,linId)
	end
	self.selfchat = self:tablechat(SelfTable)
	self.Amrychat = self:tablechat(AmryTable)

	if selfID ~= -1 then
		self:SetWidgetActive("ourhero_widget",true)
		local MaHeroInfoList1 = SData_Hero.GetHero(selfID)
		self:SetLabel("ourhero_widget/name",MaHeroInfoList1:Name())
		local selfHead = self.instance:FindWidget("ourhero_widget/img" )
		local tex1 = selfHead:GetComponent(CMUIHeroBanshen.Name)
		tex1:SetIcon(selfID,false)
	else
		self:SetWidgetActive("ourhero_widget",false)
	end
	if AmryID ~= -1 then
		self:SetWidgetActive("enemy_widget",true)
		local MaHeroInfoList2 = SData_Hero.GetHero(AmryID)
		self:SetLabel("enemy_widget/name",MaHeroInfoList2:Name())
		local AmryHead = self.instance:FindWidget("enemy_widget/img" )
		local tex2 = AmryHead:GetComponent(CMUIHeroBanshen.Name)
		tex2:SetIcon(AmryID,false)
	else
		self:SetWidgetActive("enemy_widget",false)
	end

	if self.selfchat[1] ~= "nil"and self.selfchat[1] ~= "-1" then
		self:SetWidgetActive("enemy_widget/mask",true)
		self.Self = 1
		self:SetLabel("undercase_widget/dialog_bg/txt",self.selfchat[1])
	else
		if self.Amrychat[1] ~= "nil"and self.Amrychat[1] ~= "-1" then
			self.Self = 1
			self.Amry = false
			self:SetWidgetActive("ourhero_widget/mask",true)
			self:SetLabel("undercase_widget/dialog_bg/txt",self.Amrychat[1])
		else
			self:OnClose()
		end
	end
	self:BindUIEvent("next_btn",UIEventType.Click,"Playtalk")
end
function wnd_GuankaJuqinClass:tablechat(str)
	local table = string.split(str ,"/")
	return table
end
function wnd_GuankaJuqinClass:Playtalk()--(table1,table2)
	if self.Amry then--下一句应该显示敌人的
		self.Amry = false
		if self.Amrychat[self.Self] == "-1" or self.Amrychat[self.Self] == nil then
			self:OnClose()
			return
		end
		if self.Amrychat[self.Self] ~= "nil" then
			self:SetWidgetActive("ourhero_widget/mask",true)
			self:SetWidgetActive("enemy_widget/mask",false)
			self:SetLabel("undercase_widget/dialog_bg/txt",self.Amrychat[self.Self])
		else
			self:Playtalk()
		end
	else--下一句显示自己
		self.Amry = true
		self.Self = self.Self+1
		if self.selfchat[self.Self] == "-1" or self.selfchat[self.Self] == nil then
			self:OnClose()
			return
		end
		if self.selfchat[self.Self] ~= "nil" then
			self:SetWidgetActive("enemy_widget/mask",true)
			self:SetWidgetActive("ourhero_widget/mask",false)
			self:SetLabel("undercase_widget/dialog_bg/txt",self.selfchat[self.Self])
		else 
			self:Playtalk()
		end
	end

end
function wnd_GuankaJuqinClass:OnClose()
	self:Hide()
	if self.Type == 2 then
		Battlefield.Charge()
	elseif self.Type == 3 then
		wnd_tuiguan:SendEndGKNetWork()
	elseif( self.Type == 4  or self.Type == 5 )then
        QY2LessonManager:JuQingClose(self.GKid,self.Type);
	end
	
end
--实例即将被丢失
function wnd_GuankaJuqinClass:OnLostInstance()
end 

return wnd_GuankaJuqinClass.new
 

--endregion
