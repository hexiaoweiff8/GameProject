--wnd_recruitHero.lua
--Date
--GYT


local wnd_recruitHeroClass = class(wnd_base)

wnd_recruitHero = nil--单例
function wnd_recruitHeroClass:Start() 
	wnd_recruitHero = self
	self:Init(WND.RecruitHero)
	self.servertime = 0--服务器时间
	self.bIslistenmoney = false --金币铜币监听标记
end
--点击进入界面的武将
function wnd_recruitHeroClass:PlayerHeroData(time ,id)
	self.ID = id
	self.servertime = time
end 
function wnd_recruitHeroClass:OnShowDone()
	self:SetLabel("title_bg/txt",SData_Id2String.Get(5033))
	self:SetLabel("title_bg/title",SData_Id2String.Get(5044))
	self:SetLabel("btn_release/txt",SData_Id2String.Get(5054))
	self:SetLabel("btn_ capitulate/txt",SData_Id2String.Get(5055))
	self:callbackFunc()
	if not self.bIslistenmoney then
	    OOSyncClient.BindValueChangedEvent(Player.sid,Player:GetPath(),PlayerAttrNames.Gold,self,self.callbackFunc)
	    self.bIslistenmoney = true
    end
	self.bIs = false
	self:OnShowHeroHead()
end 
--监听金币和铜币数量变化
function wnd_recruitHeroClass:callbackFunc()
	if wnd_recruitHero.isVisible == false then 
        return 
    end 
	self:SetLabel ("gold/txt",Player:GetNumberAttr(PlayerAttrNames.Gold))
end
--按星级显示可招募的武将
function wnd_recruitHeroClass:OnShowHeroHead()
	self.heroList = Player:GetHHeros()

	local m_Item = self.instance:FindWidget("prison_Grid/hero_icon")
	for k,v in pairs (self.heroList) do
		local newItem = GameObject.InstantiateFromPreobj(m_Item,self.container)
		newItem:SetName("Hero"..k)

		local heroID = tonumber(self.heroList[k]:GetNumberAttr(HInfo.DataID))
		--设置英雄图像
		local item = self.instance:FindWidget("Hero"..k.."/hero_img")
		local pHead = item:GetComponent(CMUISprite.Name)
		pHead:SetSpriteName(SData_Hero.GetHero(heroID):HtitleHeroTitle())

		newItem:SetActive(true)

		local cmTable = self.container:GetComponent(CMUIGrid.Name)
		cmTable:Reposition()

		if self.heroList[k]:GetNumberAttr(HInfo.DataID) == self.ID then
			self:OnheroHeadClick(obj,k)
			if self.bIs == false then
				local rewardItem = self.instance:FindWidget("prison_lab/prison_srollview")
				rewardItem:SetLocalPosition(Vector3.new(rewardItem:GetLocalPosition().x,rewardItem:GetLocalPosition().y+((k-1)*44),0))
				local Panelset = rewardItem:GetComponent(CMUIPanel.Name)
				Panelset:SetClipOffset(Vector2.new( 0,-((k-1)*44)))
				self.bIs = true
			end
		end

		self:BindUIEvent("Hero"..k,UIEventType.Click,"OnheroHeadClick",k)
	end
end
----窗体被实例化时被调用
----初始化实例
function wnd_recruitHeroClass:OnNewInstance()
	self.dLeList = {}
	self.bIsjixu = false
	self.bIs = false
	self.bendijishi = 0--本地计时
	self.gameobj = self.instance:FindWidget("title_bg")
	self.Countgameobj = self.instance:FindWidget("info_bg")
	self:BindUIEvent("bg",UIEventType.Click,"OnbackClick")
--	self:GetServerTime()
	self:BindTimeCount()

    --（点击英雄）光标
    self.txtable = self.instance:FindWidget("prison_srollview/hero_selectedbg")
    --英雄类型
    self.typeicon = self.instance:FindWidget("hero_img_bg/type")
    --英雄图片
    self.Banshen = self.instance:FindWidget( "hero_img_bg/hero_img" )
    --左侧头像容器
    self.container =self.instance:FindWidget("prison_Grid")
    --金币数量
    self.lableobj = self.instance:FindWidget( "right_bg/cost_widget/txt" )

	self:BindTimeCountNum()
end
function wnd_recruitHeroClass:OnheroHeadClick(obj,idx)
	self:SetWidgetActive("chat_bg",false)
	self:SetWidgetActive("name_bg/jueban_bg",false)
	local ItemPosition = self.instance:FindWidget("Hero"..idx):GetPosition()
	
	self.txtable:SetPosition(ItemPosition)
	self.txtable:SetActive(true)

	local MaHeroInfoList = SData_Hero.GetHero(self.heroList[idx]:GetNumberAttr(HInfo.DataID))
	self:SetLabel("name_bg/hero_name",MaHeroInfoList:Name())
	--武将所属阵营图标
	
	local typeiconUI= self.typeicon:GetComponent(CMUISprite.Name)
	typeiconUI:SetSpriteName("t"..MaHeroInfoList:TypeIcon())

	local a,b =self:getzhaomutype(MaHeroInfoList:HeroZhaomuType())

	self:SetLabel("left_bg/txt02",SData_Id2String.Get(a))
	self:SetLabel("left_bg/txt03",SData_Id2String.Get(b))

	if MaHeroInfoList:IsWushuang() then
		self:SetWidgetActive("name_bg/jueban_bg",true)
		self:SetLabel("jueban_bg/txt",SData_Id2String.Get(5034))
	end
	self:SetLabel("title",SData_Id2String.Get(5035))
	self:SetLabel("property_qixue",string.sformat(SData_Id2String.Get(5036),MaHeroInfoList:CalculationHP(1,MaHeroInfoList:MorenXing())))
	self:SetLabel("property_tili",string.sformat(SData_Id2String.Get(5037),MaHeroInfoList:CalculationTili(1,MaHeroInfoList:MorenXing())))
	self:SetLabel("property_wuli",string.sformat(SData_Id2String.Get(5038),MaHeroInfoList:CalculationWuli(1,MaHeroInfoList:MorenXing())))
	self:SetLabel("property_nuqi",string.sformat(SData_Id2String.Get(5039),MaHeroInfoList:CalculationNu(1,MaHeroInfoList:MorenXing())))
	self:SetLabel("property_yidongli",string.sformat(SData_Id2String.Get(5040),MaHeroInfoList:Speed()))
	self:SetLabel("property_gongjijuli",string.sformat(SData_Id2String.Get(5041),MaHeroInfoList:AtkRange()))
	local i = 1
	local eatchfunch = function (key,value)
		if sdata_SurrenderCost:GetV(sdata_SurrenderCost.I_SurrenderCostID,i) == MaHeroInfoList:SurrenderCostID() and self.heroList[idx]:GetNumberAttr(HInfo.HC)+1 ==  sdata_SurrenderCost:GetV(sdata_SurrenderCost.I_Time,i) then
			
			local UIlable = self.lableobj:GetComponent(CMUILabel.Name)
			UIlable:SetValue(sdata_SurrenderCost:GetV(sdata_SurrenderCost.I_Num2,i))
			if sdata_SurrenderCost:GetV(sdata_SurrenderCost.I_Num2,i) > Player:GetNumberAttr(PlayerAttrNames.Gold) then
				UIlable:SetColor(Color.red)
			else
				UIlable:SetColor(Color.white)
			end


		end
		i = i+1
	end
	sdata_SurrenderCost:Foreach(eatchfunch)
	--半身像
	
	local HeroBanshen = self.Banshen:GetComponent(CMUIHeroBanshen.Name)
	HeroBanshen:SetIcon(self.heroList[idx]:GetNumberAttr(HInfo.DataID),false)
	--星级
	self:SetLabel("starlv_bg/txt",MaHeroInfoList:MorenXing())
	--技能
	local skillTable = MaHeroInfoList:Skills()
	for k = 2 ,5 do 
		if skillTable[k] ~= -1 then
			self:SetWidgetActive("skill"..k-1,true)
			local Skills = SData_Skill.GetSkill(skillTable[k])
			local skillIcon = Skills:Icon()
			local sprite = self.instance:FindWidget( "skill"..k-1)
			local jnTB = sprite:GetComponent(CMUISprite.Name)
			jnTB:SetSpriteName( skillIcon)
			self:BindUIEvent( "skill"..k-1,UIEventType.Press,"showSTR",skillTable[k])
		else 
			self:SetWidgetActive("skill"..k-1,false)
		end
	end

	--判断是否拥有该武将
	local heroList = Player:GetHeros()
	for k,v in pairs (heroList) do
		print(tonumber (heroList[k]:GetAttr(HeroAttrNames.DataID) ),self.heroList[idx]:GetNumberAttr(HInfo.DataID))
		if tonumber (heroList[k]:GetAttr(HeroAttrNames.DataID) )== self.heroList[idx]:GetNumberAttr(HInfo.DataID) then
			local heroSP = sdata_keyvalue:GetFieldV(MaHeroInfoList:MorenXing().."xingSuipian",1)
			self:SetLabel("left_bg/txt01",string.sformat(SData_Id2String.Get(5356),heroSP,MaHeroInfoList:Name()))
			break
		else	
			self:SetLabel("left_bg/txt01",SData_Id2String.Get(5045))
		end 
	end
	--招募武将

	self:BindUIEvent("btn_ capitulate",UIEventType.Click,"recruitHero",idx)
	--释放武将
	self:BindUIEvent("btn_release",UIEventType.Click,"OnReleasrClick",idx)
	--倒计时数
	local BT = self.heroList[idx]:GetNumberAttr(HInfo.BT)
	local cha  = self.servertime - BT - self.bendijishi
	local LT = sdata_keyvalue:GetV(sdata_keyvalue.I_ZhaoxiangTime,1)-cha
	self.TimeCountCm:StartCountDown(LT)	
end
function wnd_recruitHeroClass:showSTR(obj,isPress,i)
	if isPress == false then return end
	local Skills = SData_Skill.GetSkill(i)
	local strnore = self:returnjinengstr(Skills:SkillNote())
	self:SetLabel("skillinfo/txt",Skills:Name().."\n"..strnore)
end 
function wnd_recruitHeroClass:OnReleasrClick(obj,i)
	self:SetLabel("bg/title",SData_Id2String.Get(5056))
	self:SetLabel("btn_cancel/txt",SData_Id2String.Get(5058))
	self:SetLabel("btn_confirme/txt",SData_Id2String.Get(5031))
	local str = ""
	local time = self.heroList[i]:GetNumberAttr(HInfo.HC)
	if time > 0 then
		str = sdata_SurrenderCost:GetV(sdata_SurrenderCost.I_ShifangPaid,i)
	else
		str = sdata_SurrenderCost:GetV(sdata_SurrenderCost.I_ShifangUnpaid,i)	
	end
	self:SetLabel("relase_bg/bg/note",str)
	self:BindUIEvent("btn_confirme",UIEventType.Click,"OnClickSrue",i)

end 
function wnd_recruitHeroClass:getzhaomutype(id)
	if id == 1 then--忠厚武将
		return 5046,5050
	elseif id == 2 then--刚义武将
		return 5047,5051
	elseif id == 3 then--浪子武将
		return 5049,5053
	elseif id == 4 then--仁德武将
		return 5048,5052
	else
	end

end 
function wnd_recruitHeroClass:recruitHero(obj,i)
	self.idx = i
	local jsonNM = QKJsonDoc.NewMap()	
	jsonNM:Add("n","HH")  
	jsonNM:Add("hid",self.heroList[self.idx]:GetNumberAttr(HInfo.DataID))  
	local loader = GameConn:CreateLoader(jsonNM,0) 
	HttpLoaderEX.WaitRecall(loader,self,self.NM_Rezhaomu)
end
function wnd_recruitHeroClass:NM_Rezhaomu(jsonDoc)
	local num = tonumber(jsonDoc:GetValue("r"))
	if num == 0 then
		self:theResultofRecruitHero(self.heroList[self.idx]:GetNumberAttr(HInfo.HC),num)-- (武将招募类型，次数，返回结果)
		--type==4代表升星
		wnd_success:showType(4) 
		wnd_success:Show()
		self:ReflashHero(self.idx) 
	elseif num == 10 then
		Poptip.PopMsg("武将不存在~",Color.red)
	elseif num == 11 then
		Poptip.PopMsg("武将不在可招募列表~",Color.red)
	elseif num == 12 then
		Poptip.PopMsg("已超过可招募时间~",Color.red)
	elseif num == 13 then
		Poptip.PopMsg("获取武将处置信息错误~",Color.red)
	elseif num == 20 then
		local temp = SData_Id2String.Get(5328)
		MsgBox.Show(temp,"否","是",self,self.MessageBoxCallBack)		
		Poptip.PopMsg("资源不足~",Color.red)
	elseif num == 30 then
		self:theResultofRecruitHero(self.heroList[self.idx]:GetNumberAttr(HInfo.HC),num)-- (武将招募类型，次数，返回结果)
	end
end
function wnd_recruitHeroClass:MessageBoxCallBack(id)
	if id == 2 then
        wnd_chongzhi:Show()
    end    
end
function wnd_recruitHeroClass:OnClickSrue(obj,i)

	self:OnReleasrTrueClick(i)
end
function wnd_recruitHeroClass:OnClickback(obj,str)
	self:SetWidgetActive(str,false)

end
function wnd_recruitHeroClass:OnbackClick()
	self:Hide()
	wnd_tuiguan:showbyhero()
	for k = 1,#self.heroList+1 do
		if self.instance:FindWidget( "Hero"..k ) ~= nil then
			self.instance:FindWidget( "Hero"..k ):Destroy()
		end
	end
end 
--进入招募界面总计时
function wnd_recruitHeroClass:BindTimeCountNum()
	self.TimeCount = self.Countgameobj:AddComponent("component/CMUICountDown")
	self.TimeCount:SetTextFillFunc(self,self.TimeCountsUpdate)
end
function wnd_recruitHeroClass:TimeCountsUpdate(time_num,time_str)
	self.bendijishi = math.floor(86400 - time_num)
end
--武将招募时间倒计时
function wnd_recruitHeroClass:BindTimeCount()
	self.TimeCountCm = self.gameobj:AddComponent("component/CMUICountDown")
	self.TimeCountCm:SetTextFillFunc(self,self.TimeCountUpdate)
	self.TimeCountCm:SetCountDownEndFunc(self,self.SetCountDownEndFunc) 
end
function wnd_recruitHeroClass:TimeCountUpdate(time_num,time_str)
	 self:SetLabel("time_bg/txt",string.sformat(SData_Id2String.Get(5042),time_str))
end
function wnd_recruitHeroClass:SetCountDownEndFunc(time_num,time_str)
--刷新在押武将
	self:ReflashHero(self.idx)

end
function wnd_recruitHeroClass:OnReleasrTrueClick(i)
	self.idx = i
	local jsonNM = QKJsonDoc.NewMap()	
	jsonNM:Add("n","SFHH")  
    jsonNM:Add("hid",self.heroList[i]:GetNumberAttr(HInfo.DataID))  
	local loader = GameConn:CreateLoader(jsonNM,0) 
	HttpLoaderEX.WaitRecall(loader,self,self.ReleasrTrueClick)
end 
function wnd_recruitHeroClass:ReleasrTrueClick(jsonDoc)
	local num = tonumber(jsonDoc:GetValue("r"))
	if num == 0 then
		self:ReflashHero(self.idx)
		Poptip.PopMsg("释放成功",Color.green)
	elseif num == 2 then
		Poptip.PopMsg("释放失败",Color.red)
	elseif num == 10 then
		Poptip.PopMsg("武将不存在",Color.red)
	elseif num == 11 then
		Poptip.PopMsg("武将不在可招募列表",Color.red)
	end
end
function wnd_recruitHeroClass:ReflashHero(i)
	for k = 1 ,#self.heroList do 
		if k == i then
			self:SetWidgetActive("Hero"..i,false)
		end
	end
	local cmTable = self.container:GetComponent(CMUIGrid.Name)
	cmTable:Reposition()

	local flag = false
	if i == #self.heroList then
		for k = 1 ,#self.heroList do
			if self.heroList[i-k] and self.heroList[i-k] ~= -1 then
				self:OnheroHeadClick(obj,i-k)
				flag = true
				break
			end
		end
		if not flag  then
			self:OnbackClick()
		end
	else
		for k = 1 ,#self.heroList do
			if self.heroList[i+k] and self.heroList[i+k] ~= -1 then
				self:OnheroHeadClick(obj,i+k)
				flag = true
				break
			end		
		end
		if not flag then
			for k = 1 ,#self.heroList do
				if self.heroList[i-k] and self.heroList[i-k] ~= -1 then
					self:OnheroHeadClick(obj,i-k)
					flag = true
					break
				end
			end
		end
		if not flag  then
			self:OnbackClick()
		end
	end
end 
function wnd_recruitHeroClass:theResultofRecruitHero(time,resul)-- (武将招募类型，次数，返回结果)
	local MaHeroInfoList = SData_Hero.GetHero(self.heroList[self.idx]:GetNumberAttr(HInfo.DataID))
	self:bIsQIPAO()
	local i = 1
	local eatchfunch = function (key,value)
		if sdata_SurrenderCost:GetV(sdata_SurrenderCost.I_SurrenderCostID,i) == MaHeroInfoList:SurrenderCostID() and tonumber(time) ==  sdata_SurrenderCost:GetV(sdata_SurrenderCost.I_Time,i) then
			local lable = ""
			if tonumber(resul) == 0 then
				lable = sdata_SurrenderCost:GetV(sdata_SurrenderCost.I_SuccessChatNote,i)

			elseif tonumber(resul) == 30 then 
				lable = sdata_SurrenderCost:GetV(sdata_SurrenderCost.I_FailChatNote,i)
				print(sdata_SurrenderCost:GetV(sdata_SurrenderCost.I_FailChatNote,i),i)
			end

			local UIlable = self.lableobj:GetComponent(CMUILabel.Name)
			UIlable:SetValue(sdata_SurrenderCost:GetV(sdata_SurrenderCost.I_Num2,i))
			if sdata_SurrenderCost:GetV(sdata_SurrenderCost.I_Num2,i) > Player:GetNumberAttr(PlayerAttrNames.Gold) then
				UIlable:SetColor(Color.red)
			else
				UIlable:SetColor(Color.white)
			end
			self:SetLabel("chat_bg/txt",lable)
		end
		i = i+1
	end
	sdata_SurrenderCost:Foreach(eatchfunch)	

end 
--显示武将招募结果气泡
function wnd_recruitHeroClass:bIsQIPAO()
	local m_Item = self.instance:FindWidget("chat_bg")
	m_Item:SetActive(true)
    local pageObj = m_Item:GetComponent(CMUITweener.Name)
	pageObj:ResetToBeginning()
	pageObj:PlayForward()
end
function wnd_recruitHeroClass:GetServerTime()
	local jsonNM = QKJsonDoc.NewMap()	
	jsonNM:Add("n","Gt") 
	local loader = GameConn:CreateLoader(jsonNM,0) 
	HttpLoaderEX.WaitRecall(loader,self,self.NM_ReGetServerTime)
end
function wnd_recruitHeroClass:NM_ReGetServerTime(jsonDoc)
	self.TimeCount:StartCountDown(86400)	
	self.servertime  = tonumber(jsonDoc:GetValue("ST"))
end
--function wnd_recruitHeroClass:NM_ReGetServerTime(jsonDoc)
--	local servertime  = tonumber(jsonDoc:GetValue("ST"))
--	local list = Player:GetHHeros()
--	local BT = list[self.nowidx]:GetNumberAttr(HInfo.BT)
--	local cha  = servertime-BT
--	local LT = sdata_keyvalue:GetV(sdata_keyvalue.I_ZhaoxiangTime,1)-cha
--	self.TimeCountCm:StartCountDown(LT)	
--end
function wnd_recruitHeroClass:returnjinengstr(note)
	local table1 = {}
	for k = 1 ,#note do
		table1[k] = string.sub(note,k,k)
	end
	local list = {}
	for k = 1 ,#table1 do
		if table1[k] == "{" then
			if table1[k+1] ~= "}" then
				local str = ""
				for i = k ,#table1 do
					if table1[i] == "}" then
						table.insert(list,#list+1,str)
						break
					else
						str = str..table1[i]
						table.insert(table1,i,"|")
						table.remove(table1,i+1)		
					end
				end
			end 
		end
	end
	local str1 = ""
	for k = 1 ,#list do
		str1 =str1..list[k]
	end
	local v2array = string.split(str1,"{")
	local table2 = {}
	for k = 1 ,#v2array do
		local w = string.split(v2array[k],";")
		if w[1] ~= "" then
			local skilleff = SData_Skill.GetSkillEffect(tonumber( w[1]))
			if tonumber( w[2]) == 1 then--A1
				table2[#table2+1] = math.floor(skilleff:GetHitPercent(1)*100)
			elseif tonumber( w[2]) == 2 then--A2
				table2[#table2+1] = skilleff:GetSkillHit(1)
			elseif tonumber( w[2]) == 3 then--B1
				table2[#table2+1] = skilleff:GetEditAttrV(1)
			elseif tonumber( w[2]) == 4 then--C1
				table2[#table2+1] = skilleff:Float3rdTriggerEnd_Lv(1)
			end
		end
	end
	local table3 = {}
	for k = 1 ,#table1 do
		if table1[k] ~= "|" then
			table3[#table3+1] = table1[k]
		end
	end
	local m = 1
	for k = 1 ,#table3 do
		if table3[k] == "}" then
			if table3[k-1] and table3[k-1] ~= "{" then
				table3[k] = table2[m]
				m = m + 1
			end			
		end
	end
	local strs = ""
	for k = 1 ,#table3 do
		strs = strs..table3[k]
	end
	return strs
end
--实例即将被丢失
function wnd_recruitHeroClass:OnLostInstance()
end 

return wnd_recruitHeroClass.new


--endregion

