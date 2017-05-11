--wnd_achievements.lua
--Date
--此文件由[BabeLua]插件自动生成


local wnd_StorybooksClass = class(wnd_base)

wnd_Storybooks = nil--单例

function wnd_StorybooksClass:Start() 
	wnd_Storybooks = self
	self:Init(WND.Storybooks)
end
--窗体被实例化时被调用
--初始化实例
function wnd_StorybooksClass:OnNewInstance()
	self.bIsshow = false
	self:BindUIEvent("back_btn",UIEventType.Click,"OnClickChannel")

end
function wnd_StorybooksClass:OnShowDone()
	self:SetLabel("title_bg/txt",SData_Id2String.Get(5104))
	if not self.bIsshow then
		self.bIsshow = true
		self:showjuqing()
	end
end
function wnd_StorybooksClass:FillData(jsonDoc)
	local num = tonumber(jsonDoc:GetValue("r"))
	if num == 0 then
		self.ID = tonumber(jsonDoc:GetValue("diaJD"))
	else
		self.ID = 1
	end
end
function wnd_StorybooksClass:showjuqing()
--	local gkInfo = Player:GetGKInfo()
--	local eachFunc = function (syncObj)
--		local Mission = tonumber( syncObj:GetValue(GKSaveFileAttrNames.MissionID) )
--		if tonumber( syncObj:GetValue(GKSaveFileAttrNames.SFType) ) == 1 then    
--			self.ID = tonumber(syncObj:GetValue(GKSaveFileAttrNames.ProvinceID))
--		end
--	end
--	gkInfo:ForeachSaveFiles(eachFunc)
	

	local cmAttributeGird= {
		self.instance:FindWidget("undercase_bg/scrollview/inactivegrid"),
		self.instance:FindWidget("undercase_bg/scrollview/activegrid")
	}
	self:BindUIEvent("inactivity1",UIEventType.Click,"OnItemClick",1)
	self:SetLabel("inactivity1/Sprite/Label",sdata_MissionState:GetV(sdata_MissionState.I_Name,1))
	self:SetLabel("activity1/Sprite/Label",sdata_MissionState:GetV(sdata_MissionState.I_Name,1))

	local m_Item = self.instance:FindWidget("undercase_bg/scrollview/inactivegrid/inactivity1")
	local m_Item1= self.instance:FindWidget("undercase_bg/scrollview/activegrid/activity1")
	local num = 0
	local eatchfunch = function (key,value)
		if key > 1 then
			local newItem = GameObject.InstantiateFromPreobj(m_Item, cmAttributeGird[1])
			newItem:SetName("inactivity"..key)

			self:SetLabel("inactivity"..key.."/Sprite/Label",sdata_MissionState:GetV(sdata_MissionState.I_Name,key))
			local newItem = GameObject.InstantiateFromPreobj(m_Item1,cmAttributeGird[2])
			newItem:SetName("activity"..key)
			self:SetLabel("activity"..key.."/Sprite/Label",sdata_MissionState:GetV(sdata_MissionState.I_Name,key))
			local playtween = self.instance:FindWidget("inactivity"..key)
			local UIplt = playtween:GetComponent(UIPlayTween.Name)
			UIplt:SetTweenTarget(self.instance:FindWidget("activity"..key))
			local tiaozhuanCZ = self.instance:FindWidget("inactivity"..key)
			local cmAttributePage = tiaozhuanCZ:GetComponent(CMUIAttributePage.Name)
			cmAttributePage:SetActivityButton(self.instance:FindWidget("scrollview/activegrid/activity"..key))
			cmAttributePage:SetInactiveButton(self.instance:FindWidget("scrollview/inactivegrid/inactivity"..key))
			self:BindUIEvent("inactivity"..key,UIEventType.Click,"OnItemClick",key)
		end
		if key > self.ID then
			self:SetWidgetActive("inactivity"..key.."/unopened",true)
		else
			self:SetWidgetActive("inactivity"..key.."/unopened",false)
		end
		num = num + 1 
	end
	sdata_MissionState:Foreach(eatchfunch)


	local rewardItem = self.instance:FindWidget("undercase_bg/scrollview")
	local Panelset = rewardItem:GetComponent(CMUIPanel.Name)
	local jibenX1 = rewardItem:GetLocalPosition().x+90*(self.ID-1)
	local jibenX2 = Panelset:GetClipOffset().x+90*(self.ID-1)
	if jibenX1 > (90*(num-10)) then
		jibenX1 = rewardItem:GetLocalPosition().x+(90*(num-10))
		jibenX2 = Panelset:GetClipOffset().x+(90*(num-10))--改grid间距90
	end
	rewardItem:SetLocalPosition(Vector3.new(-jibenX1,rewardItem:GetLocalPosition().y,0))
	Panelset:SetClipOffset(Vector2.new( jibenX2,0))


	local tiaozhuanCZ = self.instance:FindWidget("inactivity"..self.ID)
	local cmAttributePage = tiaozhuanCZ:GetComponent(CMUIAttributePage.Name)
	cmAttributePage:SetActivity() 
	self:OnItemClick(obj,self.ID)
	for k = 1 ,	2 do
		local container = cmAttributeGird[k]
		local cmGrid = container:GetComponent(CMUIGrid.Name)
		cmGrid:Reposition()
	end	
end 
function wnd_StorybooksClass:OnItemClick(gameObj,id)
	local text = ""
	local title = ""
	local tabs = {}
	local eatchfunch = function (key,value)
		
		if key == id then
			local ID = sdata_MissionState:GetV(sdata_MissionState.I_DramaID,id)
			text = sdata_DramaData:GetV(sdata_DramaData.I_Plot,ID)
			title = sdata_DramaData:GetV(sdata_DramaData.I_Title,ID)
			table.insert(tabs,{t1 = text, t2 = title })
		end
	end
	sdata_MissionState:Foreach(eatchfunch)
	self:SetLabel("drama_bg/scrollview/txt",text)
	self:SetLabel("drama01/city_name",title)
	self:BindUIEvent("drama_bg/btn",UIEventType.Click,"OnBigItemClick",tabs)
end
function wnd_StorybooksClass:OnBigItemClick(obj,tab)
	self:SetLabel("fangda_bg/title_txt",tab[1].t2)
	self:SetLabel("fangda_scrollview/txt",tab[1].t1)
end 
function wnd_StorybooksClass:OnClickChannel()
	self:Hide()
end 
--实例即将被丢失
function wnd_StorybooksClass:OnLostInstance()
end 

return wnd_StorybooksClass.new
 

--endregion
