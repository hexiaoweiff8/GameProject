
--wnd_randomEvents.lua
--Date 2016/10/11
--gyt

local wnd_randomEventsclass = class(wnd_base)

wnd_randomEvents = nil--单例

function wnd_randomEventsclass:Start() 
	wnd_randomEvents = self
	self:Init(WND.RandomEvents)
	self.guaiwu = true
end

function wnd_randomEventsclass:JLData(sjt,sjinfo,sjid)
	self.sjt = sjt
	self.sjinfo = sjinfo
	self.sjid = sjid

end
--窗体被实例化时被调用
--初始化实例
function wnd_randomEventsclass:OnNewInstance()
	self.BTtime = 0
	self.gameobj = self.instance:FindWidget("bg")
	self:BindTimeCount()
	self:BindUIEvent("bg",UIEventType.Click,"OnTestClick")
	self:SetLabel("continue_btn/txt",SData_Id2String.Get(5359))
	self:SetLabel("wushi_btn/txt",SData_Id2String.Get(5364))
	self:SetLabel("tiaozhan_btn/txt",SData_Id2String.Get(5365))
	self.ouyuwidget = self.instance:FindWidget("ouyu_widget")
	self.shangrenwidget = self.instance:FindWidget("shangren_widget")
end
--倒计时相关
function wnd_randomEventsclass:BindTimeCount()
	self.TimeCountCm = self.gameobj:AddComponent("component/CMUICountDown")
	self.TimeCountCm:SetTextFillFunc(self,self.TimeCountUpdate)
	self.TimeCountCm:SetCountDownEndFunc(self,self.SetCountDownEndFunc) 
end
function wnd_randomEventsclass:TimeCountUpdate(time_num,time_str)
	local txtlable = self.parentObj:FindChild("time_txt")
	local UIlable = txtlable:GetComponent(CMUILabel.Name)
	UIlable:SetValue(time_str)
end
function wnd_randomEventsclass:SetCountDownEndFunc(time_num,time_str)
	self:Hide()
end


function wnd_randomEventsclass:OnShowDone()
	local strObjName = ""
	self.parentObj = nil
	if self.sjt == 1 then 
		self.parentObj = self.ouyuwidget
		strObjName = "success_bg"
		self:BindUIEvent("continue_btn1",UIEventType.Click,"OnTestClick")
	elseif self.sjt == 2 then
		self.parentObj = self.ouyuwidget
		strObjName = "challenge_bg"
		self:BindUIEvent("wushi_btn",UIEventType.Click,"OnTestClick")
	elseif self.sjt == 3 then
		self.parentObj = self.shangrenwidget
		strObjName = "shangren_bg"
	end
--	self:BindUIEvent("back_btn",UIEventType.Click,"OnTestClick")
	self.parentObj:SetActive(true)
	self.bgObj = self.parentObj:FindChild(strObjName)
	self.bgObj:SetActive(true)
	self:OnBOXClick(self.sjt)
end 
function wnd_randomEventsclass:OnBOXClick(sjt)
	local txtlable = self.bgObj:FindChild("title/txt")
	local UIlable = txtlable:GetComponent(CMUILabel.Name)
	local mexlable = self.bgObj:FindChild("shijian_bg/txt")
	local UI_lable = mexlable:GetComponent(CMUILabel.Name)
	if sjt == 1 then 
		if tonumber(sdata_SuijiBaoxiang:GetV(sdata_SuijiBaoxiang.I_Flag,self.sjid)) == 1 then--稀有宝箱
		end

		UIlable:SetValue(sdata_SuijiBaoxiang:GetV(sdata_SuijiBaoxiang.I_Name,self.sjid))

		UI_lable:SetValue(sdata_SuijiBaoxiang:GetV(sdata_SuijiBaoxiang.I_Description,self.sjid))

		print(
		sdata_SuijiBaoxiang:GetV(sdata_SuijiBaoxiang.I_Name,self.sjid) ,
		sdata_SuijiBaoxiang:GetV(sdata_SuijiBaoxiang.I_Type,self.sjid),
		sdata_SuijiBaoxiang:GetV(sdata_SuijiBaoxiang.I_Icon,self.sjid),
		sdata_SuijiBaoxiang:GetV(sdata_SuijiBaoxiang.I_ChujiangID,self.sjid))
			
	elseif sjt == 2 then
		local challenge = self.bgObj:FindChild("challenge_widget")
		local finsh = self.bgObj:FindChild("finsh_widget")
		if self.guaiwu then
			challenge:SetActive(true)
			finsh:SetActive(false)
			UIlable:SetValue(sdata_SuijiMonster:GetV(sdata_SuijiMonster.I_Name,self.sjid))

			UI_lable:SetValue(sdata_SuijiMonster:GetV(sdata_SuijiMonster.I_Description,self.sjid))

			local challengetxt = self.bgObj:FindChild( "challenge_widget/txt" )
			local challengetxtlable = challengetxt:GetComponent(CMUILabel.Name)
			challengetxtlable:SetValue(SData_Id2String.Get(5371))
			self:BindUIEvent("tiaozhan_btn",UIEventType.Click,"OnTestFight")
			self:BindUIEvent("wushi_btn",UIEventType.Click,"OnFangqi")
			self.pid = 1
			local AHero = Player:GetSJMByFID(self.sjinfo)
			self.BTtime = AHero:GetValue(SJMs.Ltime)
			self:GetServerTime()
			local MonsterData = {} 
			for i = 1,5 do
				if sdata_SuijiMonster:GetFieldV("MonsterHeroID"..i,self.sjid) ~= 0 then
					table.insert(MonsterData,{id = i, hid= sdata_SuijiMonster:GetFieldV("MonsterHeroID"..i,self.sjid) })
				end
			end
			self.MonsterTable = self:setMonsterData(false,MonsterData)
		else
			challenge:SetActive(false)
			finsh:SetActive(true)
			local txtlable = self.parentObj:FindChild("time_txt")
			txtlable:SetActive(false)
			self:BindUIEvent("finsh_widget/continue_btn",UIEventType.Click,"OnTestClick")
			if self.bIswin == 1 then
				UI_lable:SetValue(sdata_SuijiMonster:GetV(sdata_SuijiMonster.I_Shengli,self.sjid))
			else
				UI_lable:SetValue(sdata_SuijiMonster:GetV(sdata_SuijiMonster.I_Shibai,self.sjid))
			end
			UIlable:SetValue(sdata_SuijiMonster:GetV(sdata_SuijiMonster.I_Name,self.sjid))
			local m_Item = finsh:FindChild("item_grid/item01")
			for k = 1,#self.rankList do
				local newItem = GameObject.InstantiateFromPreobj(m_Item,finsh:FindChild("item_grid"))
				newItem:SetName("award"..k)
				CodingEasyer:SetJLIcon(finsh:FindChild("item_grid/award"..k),self.rankList[k])
				newItem:SetActive(true)--激活对象
			end

			self.guaiwu = true
		end
		--半身像
		local Banshen = self.bgObj:FindChild( "hero_img" )
		local HeroBanshen = Banshen:GetComponent(CMUIHeroBanshen.Name)
		local heroid = tonumber(sdata_SuijiMonster:GetV(sdata_SuijiMonster.I_HeroBanshen,self.sjid))
		HeroBanshen:SetIcon(heroid,false)
		local NameBanshen = Banshen:FindChild( "txt" )
		local Banshenlable = NameBanshen:GetComponent(CMUILabel.Name)
		Banshenlable:SetValue(SData_Hero.GetHero(heroid):Name())

	elseif sjt == 3 then	
		UIlable:SetValue(sdata_SuijiShop:GetV(sdata_SuijiShop.I_Name,self.sjid))
		UI_lable:SetValue(sdata_SuijiShop:GetV(sdata_SuijiShop.I_Description,self.sjid))
		self:sjShop()
	end
	
end
function wnd_randomEventsclass:setMonsterData(bIsSelf,MonsterData)
	local temp = {}
	
	if bIsSelf then
		temp.Type = ArmyFlag.Attacker
		temp.Zid = wnd_buzheng.ZF
	else
		temp.Type =  ArmyFlag.Defender
		temp.Zid = sdata_SuijiMonster:GetV(sdata_SuijiMonster.I_ZhenfaID,self.sjid)
	end
    temp.Heros = {}

	for i = 1,#MonsterData do 
		local a = SData_Hero.GetHero(MonsterData[i].hid)
        local sTab = {}
        sTab.Fid = tonumber(MonsterData[i].id)
        sTab.HeroID = MonsterData[i].hid
        sTab.HeroLv = Player:GetNumberAttr(PlayerAttrNames.Level)
        sTab.HeroStar = a:MorenXing()
		local Army = SData_Army.GetRow(a:Army())
        sTab.ArmyStar = Army:MorenXing()
        sTab.ArmyNum = sdata_SuijiMonster:GetV(sdata_SuijiMonster.I_MonsterArmyNo,self.sjid)
		--技能
		local skills = a:Skills()--获得技能队列
		local skillLevels = ""--技能等级索引
		local HeroWuqi = "0"
		local HeroHuajia = "0"
		local k = 1
		for _,skillID in pairs(skills) do
			if not bIsSelf then
				if k == 2 then
					skillLevels = Player:GetNumberAttr(PlayerAttrNames.Level)
				elseif k > 2 and  k < 6 then
					skillLevels = skillLevels.."|"..Player:GetNumberAttr(PlayerAttrNames.Level)
				end			
			else
				
				local list =  Player:GetHeros()
				for n = 1,#list do
					if tonumber(list[n]:GetAttr(HeroAttrNames.DataID)) == tonumber(MonsterData[i].hid) then
						if k == 2 then
							skillLevels = list[n]:GetSkillLevelByIndex(k)
						elseif k > 2 and  k < 6 then
							skillLevels = skillLevels.."|"..list[n]:GetSkillLevelByIndex(k)
						end			
					end
				end
			end
			k = k + 1 
		end
		--装备	
		if bIsSelf then
			local list =  Player:GetHeros()
			local wujuID = nil
			local fangjuID = nil
			for n = 1,#list do
				if tonumber(list[n]:GetAttr(HeroAttrNames.DataID)) == tonumber(MonsterData[i].hid) then
					wujuID = self:ID_DataID(list[n]:GetAttr(HeroAttrNames.WuID))
					
					fangjuID =  self:ID_DataID(list[n]:GetAttr(HeroAttrNames.FangID))
				end
			end

			local Equip = Player:GetEquips()
			local eachFunc = function (syncObj)
				if syncObj:GetValue(EquipAttrNames.ID) == wujuID then
					local num = syncObj:GetValue(EquipAttrNames.CurrSkill)
					HeroWuqi = wujuID.."|"..num
				end
				if syncObj:GetValue(EquipAttrNames.ID) == fangjuID then
					local num = syncObj:GetValue(EquipAttrNames.CurrSkill)
					HeroHuajia =  fangjuID.."|"..num
				end
			end
			Equip:ForeachEquips(eachFunc)
		else
			HeroWuqi = "0"
			HeroHuajia = "0"
		end

        sTab.SkillLv = skillLevels
        sTab.HeroWuqi = HeroWuqi
        sTab.HeroHuajia = HeroHuajia

        table.insert(temp.Heros,sTab)
	end

	return temp

end

--根据装备ID获取装备静态ID
function wnd_randomEventsclass:ID_DataID(ID)
    local DataID = 0
    local list = Player:GetEquips()
	local eachFunc = function (syncObj)
        if ID == syncObj:GetValue(EquipAttrNames.ID) then
            DataID = tonumber(syncObj:GetValue(EquipAttrNames.DataID))
        end
	end
	list:ForeachEquips(eachFunc)
    return 	DataID
end
function wnd_randomEventsclass:OnFangqi()
	local jsonNM = QKJsonDoc.NewMap()	
	jsonNM:Add("n","SJMSJ")  
	jsonNM:Add("id",self.sjinfo)  
	local loader = GameConn:CreateLoader(jsonNM,0) 
	HttpLoaderEX.WaitRecall(loader,self,self.NM_RealFangqi)
end
function wnd_randomEventsclass:NM_RealFangqi(jsonDoc)
	local num = tonumber(jsonDoc:GetValue("r"))
	if num == 0 then
		self:OnTestClick()
	end
end
function wnd_randomEventsclass:OnTestClick()
	if self.sjt == 1 then 
		local jsonNM = QKJsonDoc.NewMap()	
		jsonNM:Add("n","SJB")  
		jsonNM:Add("cid",self.sjinfo)  
		local loader = GameConn:CreateLoader(jsonNM,0) 
		HttpLoaderEX.WaitRecall(loader,self,self.NM_ReallList)
	elseif self.sjt == 2 then 

		self:OnBack()
		wnd_tuiguan:showbyhero()
		local txtlable = self.parentObj:FindChild("time_txt")
		txtlable:SetActive(true)		
	elseif self.sjt == 3 then 
		self:OnBack()	
	end
end 
function wnd_randomEventsclass:OnTestFight()
	wnd_buzheng:setType(true)
	WndJumpManage:Jump(WND.RandomEvents,WND.BuZheng)
end
function wnd_randomEventsclass:setFightData()
	local structo = self.MonsterTable
    local structs = self:setMonsterData(true,wnd_buzheng:GetHeroOnZW())

	wnd_tuiguan:RandomEventEnterFight(structs,structo)	
end
function wnd_randomEventsclass:sjShop()
	local SJShops = Player:GetSJShopsByFID(self.sjinfo)
	self.BTtime = SJShops:GetValue(SJShopss.LT)
	self:GetServerTime()
	local JLstr = SJShops:GetValue(SJShopss.iList)
	self.table = self:GetJLlist(JLstr)
	local m_Item = self.bgObj:FindChild("item_panel/item_grid/item_card")
	local m_Item1 = self.bgObj:FindChild("item_panel/item_grid")
	for k = 1,#self.table do
		local newItem = GameObject.InstantiateFromPreobj(m_Item,m_Item1)
		newItem:SetName("award"..k)
		local theNEW = self.bgObj:FindChild("item_panel/item_grid/award"..k)
		CodingEasyer:SetJLIcon(theNEW,self.table[k])
		self:setshopData(theNEW,k)
--		local theNEWobj = theNEW:FindChild("sold_out")
--		local huobigold = theNEW:FindChild("price/gold")
--		local huobicopper = theNEW:FindChild("price/coin")
--		local pricetxt = theNEW:FindChild("price/txt")
--		if self.table[k].isSale == 0 then--0 没卖 1 卖了
--			theNEWobj:SetActive(false)
--		elseif self.table[k].isSale == 1 then
--			theNEWobj:SetActive(true)
--		end
--		if self.table[k].Currency == 4 then
--			huobicopper:SetActive(true)
--			huobigold:SetActive(false)
--		elseif self.table[k].Currency == 5 then
--			huobigold:SetActive(true)
--			huobicopper:SetActive(false)
--		end
--		local UIlable = pricetxt:GetComponent(CMUILabel.Name)
--		UIlable:SetValue(self.table[k].Price)
--		if tonumber(self.table[k].Price )> tonumber(Player:GetNumberAttr(PlayerAttrNames.Gold)) then
--			UIlable:SetColor(Color.red)
--		else
--			UIlable:SetColor(Color.white)
--		end
		self:BindUIEvent("award"..k,UIEventType.Click,"saleitempanle",k)
		newItem:SetActive(true)--激活对象
	end
	local cmgrid = m_Item1:GetComponent(CMUIGrid.Name)
	cmgrid:Reposition()
end
function wnd_randomEventsclass:setshopData(theNEW,k)
	local theNEWobj = theNEW:FindChild("sold_out")
	local huobigold = theNEW:FindChild("price/gold")
	local huobicopper = theNEW:FindChild("price/coin")
	local pricetxt = theNEW:FindChild("price/txt")
	local UIlable = pricetxt:GetComponent(CMUILabel.Name)
	UIlable:SetValue(self.table[k].Price)
	if self.table[k].isSale == 0 then--0 没卖 1 卖了
		theNEWobj:SetActive(false)
	elseif self.table[k].isSale == 1 then
		theNEWobj:SetActive(true)
	end
	if self.table[k].Currency == 4 then
		huobicopper:SetActive(true)
		huobigold:SetActive(false)
		if tonumber(self.table[k].Price )> tonumber(Player:GetNumberAttr(PlayerAttrNames.Copper)) then
			UIlable:SetColor(Color.red)
		else
			UIlable:SetColor(Color.white)
		end
	elseif self.table[k].Currency == 5 then
		huobigold:SetActive(true)
		huobicopper:SetActive(false)
		if tonumber(self.table[k].Price )> tonumber(Player:GetNumberAttr(PlayerAttrNames.Gold)) then
			UIlable:SetColor(Color.red)
		else
			UIlable:SetColor(Color.white)
		end
	end
end
function wnd_randomEventsclass:saleitempanle(obj,k)
	self:SetJLIcon(self.bgObj:FindChild("item_panel/info_widget/info_bg/item_img"),self.table[k])
	local jlName = self.bgObj:FindChild("item_panel/info_widget/info_bg/name_txt")
	local UIlable = jlName:GetComponent(CMUILabel.Name)
	UIlable:SetValue(CodingEasyer:GetJLName(self.table[k]))

	local jlNote = self.bgObj:FindChild("item_panel/info_widget/info_bg/txt_bg/info_txt")
	local UIlable1 = jlNote:GetComponent(CMUILabel.Name)
	UIlable1:SetValue(CodingEasyer:GetJLNote(self.table[k]))

	self:SetLabel("shuliang_bg/txt",self.table[k].Num)
	self:SetLabel("info_bg/num_txt",string.sformat(SData_Id2String.Get(5369),self:SetJLData(self.table[k])))
	local theNEW = self.bgObj:FindChild("item_panel/info_widget/info_bg/buy_btn")
	local huobigold = theNEW:FindChild("gold")
	local huobicopper = theNEW:FindChild("coin")
	local pricetxt = theNEW:FindChild("txt")
	local cointype = 0
	if self.table[k].Currency == 4 then
		huobicopper:SetActive(true)
		huobigold:SetActive(false)
		cointype = Player:GetNumberAttr(PlayerAttrNames.Copper)
	elseif self.table[k].Currency == 5 then
		huobigold:SetActive(true)
		huobicopper:SetActive(false)
		cointype = Player:GetNumberAttr(PlayerAttrNames.Gold)
	end
	local UIlable2 = pricetxt:GetComponent(CMUILabel.Name)
	UIlable2:SetValue(self.table[k].Price)
	if tonumber(self.table[k].Price )> tonumber(cointype) then
		UIlable2:SetColor(Color.red)
	else
		UIlable2:SetColor(Color.white)
	end

	self:BindUIEvent("buy_btn",UIEventType.Click,"saleitem",k)
end
function wnd_randomEventsclass:saleitem(obj,k)
	self.idx = k
	local jsonNM = QKJsonDoc.NewMap()	
	jsonNM:Add("n","SJSBuy")
	jsonNM:Add("pid",self.sjinfo)
	jsonNM:Add("pos",k)
	local loader = GameConn:CreateLoader(jsonNM,0) 
	HttpLoaderEX.WaitRecall(loader,self,self.NM_ReGetitem)	
end
function wnd_randomEventsclass:NM_ReGetitem(jsonDoc)
	local num  = tonumber(jsonDoc:GetValue("r"))
	if num == 0 then
		Poptip.PopMsg("购买成功",Color.green)
		self.table[self.idx].isSale = 1
		self.bgObj:FindChild("item_panel/item_grid/award"..self.idx.."/sold_out"):SetActive(true)

		local m_Item = self.bgObj:FindChild("item_panel/info_widget/info_bg")
		local pageObj = m_Item:GetComponent(CMUITweener.Name)
		pageObj:ResetToBeginning()
		pageObj:PlayReverse()

		local bIsSale = false
		for i = 1 ,#self.table do--全部售罄
			local theNEW = self.bgObj:FindChild("item_panel/item_grid/award"..i)
			self:setshopData(theNEW,i)
			if self.table[i].isSale == 0 then
				bIsSale = true
			end
		end
		if not bIsSale then
			self:OnBack()
		end
	elseif num == 10 then
		Poptip.PopMsg("商店已关闭",Color.red)
	elseif num == 11 then
		Poptip.PopMsg("您购买的商品有错误",Color.red)
	elseif num == 21 then
		if self.table[self.idx].Currency == 4 then
			Poptip.PopMsg("铜币不足",Color.red)
		elseif self.table[self.idx].Currency == 5 then
			local temp = SData_Id2String.Get(5328)
			MsgBox.Show(temp,"否","是",self,self.MessageBoxCallBack)		
		end
	else
		Poptip.PopMsg("未知错误",Color.red)
	end
end
function wnd_randomEventsclass:MessageBoxCallBack(id)
	if id == 2 then
        wnd_chongzhi:Show()
    end    
end
function wnd_randomEventsclass:GetJLlist(str)
	local jllist = {}
	local JLstr1 = {}
	local a = 1 
	local JLstr = string.split(str,',')
	for k,v in pairs(JLstr)do
		JLstr1 = string.split(v ,':')
		for n,m in pairs(JLstr1)do
			local rank = {}
			rank.isSale = tonumber(JLstr1[1])
			rank.Currency = tonumber(JLstr1[2])
			rank.Price = JLstr1[3]
			rank.BookName = JLstr1[4]
			rank.SubType = JLstr1[5]
			rank.Num = JLstr1[6]
			jllist[a] = rank
		end	
		a = a + 1
	end
	return jllist
end
function wnd_randomEventsclass:setMonsterJL(jsonDoc)
	local n = 1
	self.rankList = {}

	local rank = jsonDoc:GetValue("jl")
	local rankFunc = function(id,mailInfos)
        local rank = {}
        rank.BookName = tonumber( mailInfos:GetValue("b") )
        rank.SubType = tonumber( mailInfos:GetValue("i") )
        rank.Num = tostring( mailInfos:GetValue("n") )
		self.rankList[n] = rank   
		n = n + 1 
    end
    rank:Foreach(rankFunc)
end
function wnd_randomEventsclass:OnBack()
	self.parentObj:SetActive(false)
	self.bgObj:SetActive(false)	
	wnd_tuiguan.sjt = 0
	self:Hide()	
end
function wnd_randomEventsclass:NM_ReallList(jsonDoc)
	self:OnBack()
	local num = tonumber(jsonDoc:GetValue("r"))
	if num == 0 then
		local TempJL = {}
		local n = 1
		local njl = jsonDoc:GetValue("jl")
		local rankFunc = function(_,v)
			local rank = {}
			rank.BookName = tonumber( v:GetValue("b") )
			rank.SubType = tonumber( v:GetValue("i") )
			rank.Num = tonumber( v:GetValue("n") )
			TempJL[n] = rank   
			n = n + 1 
		end
		njl:Foreach(rankFunc)
		wnd_itemget:Fdata(TempJL,"wnd_Mail")
		wnd_itemget:Show()
	end


end 
function wnd_randomEventsclass:guaiwuRes(bIswin,bIs)
	self.guaiwu = bIs
	self.bIswin = bIswin
	
end 
function wnd_randomEventsclass:GetServerTime()
	local jsonNM = QKJsonDoc.NewMap()	
	jsonNM:Add("n","Gt") 
	local loader = GameConn:CreateLoader(jsonNM,0) 
	HttpLoaderEX.WaitRecall(loader,self,self.NM_ReGetServerTime)
end
function wnd_randomEventsclass:NM_ReGetServerTime(jsonDoc)
	local servertime  = tonumber(jsonDoc:GetValue("ST"))
	if self.BTtime ~= 0 then
		local cha  = self.BTtime-servertime
		self.TimeCountCm:StartCountDown(cha)
	else
		return
	end

end

function wnd_randomEventsclass:SetJLData(tab)
	local num = 0
	if tonumber(tab.BookName) == 1 then
		if tonumber(tab.SubType) == 15 then--经验
			num = Player:GetNumberAttr(PlayerAttrNames.Exp)
		elseif tonumber(tab.SubType) == 17 then--体力
			num = Player:GetNumberAttr(PlayerAttrNames.JunLing)
		elseif tonumber(tab.SubType) == 20 then--通用武将碎片
			num = Player:GetNumberAttr(PlayerAttrNames.Tysp)
		else 
			num = Player:GetCommItemsNum(tonumber(tab.SubType))
		end
	elseif tonumber(tab.BookName) == 2 then--武将
		local list =  Player:GetHeros()
		local bis = false
		for i = 1,#list do
			if tonumber(list[i]:GetAttr(HeroAttrNames.DataID)) == tonumber(tab.SubType) then
				bis = true
			end
		end
		if bis then
			num = 1
		else
			num = 0
		end
	elseif tonumber(tab.BookName) == 5 then--武将碎片
		num = Player:GetJianghunNum(tab.SubType)
	elseif tonumber(tab.BookName) == 6 then
		num = Player:GetSoldierPieceNum(tab.SubType)
	elseif tonumber(tab.BookName) == 21 then
		local b = 0
		local a = Player:GetEquips()
		local eachFunc = function (syncObj)
			if tonumber(syncObj:GetValue(EquipAttrNames.DataID)) == tonumber(tab.SubType) then
				b = b + 1
			end
		end
	    a:ForeachEquips(eachFunc)
		num = b 
	elseif tonumber(tab.BookName) == 22 then
		local e = Player:GetEquipMaterials()
		local eachFunc = function (syncObj)
			if tonumber(syncObj:GetValue(EquipMaterialsAttrNames.DataID)) == tonumber(tab.SubType) then
				num = syncObj:GetValue(EquipMaterialsAttrNames.NUM)
			end
		end
		e:ForeachEquipMaterials(eachFunc)
	end
	return num
end 
function wnd_randomEventsclass:SetJLIcon(GameObj,JL)
    GameObj:SetActive(true)
    local sprite = GameObj:GetComponent(CMUISprite.Name)
    local BookName = tonumber( JL.BookName )
    local SubType = tonumber( JL.SubType )
    local Number = tostring( JL.Num )
    local SkinName = ""
   
    if BookName == 1 then --道具  
       sprite:SetAtlas("core","itemAtlas")
       SkinName = sdata_itemdata:GetV(sdata_itemdata.I_HuobiIcon,SubType)
    elseif BookName == 2 or BookName == 5 then -- 英雄 
       sprite:SetAtlas("hero","hero1Atlas")
       local HeroStruct = SData_Hero.GetHero(SubType)
       HeroStruct:SetHeroIcon(sprite)
       return
    elseif BookName == 3  or BookName == 6 then -- 士兵 
       sprite:SetAtlas("")
       SkinName = ""
    elseif BookName == 11 then
       sprite:SetAtlas("")
       SkinName = "限时头像"
    elseif BookName == 21 then
       sprite:SetAtlas("ui_equip","ui_equipAtlas")
       SkinName = sdata_EquipData:GetV(sdata_EquipData.I_Icon,SubType)
    elseif BookName == 22 then
       sprite:SetAtlas("ui_equip","ui_equipAtlas")
       SkinName = sdata_XilianshiData:GetV(sdata_XilianshiData.I_Icon,SubType)
    end
    sprite:SetSpriteName( SkinName )
end

--实例即将被丢失
function wnd_randomEventsclass:OnLostInstance()
end 
 
return wnd_randomEventsclass.new
 