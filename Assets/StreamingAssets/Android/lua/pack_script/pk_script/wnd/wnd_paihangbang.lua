
local wnd_paihangbangClass = class(wnd_base)

wnd_paihangbang = nil--单例


function wnd_paihangbangClass:Start() 
	wnd_paihangbang = self
	self:Init(WND.Paihangbang)
end

--窗体被实例化时被调用
--初始化实例
function wnd_paihangbangClass:OnNewInstance()
	self.numitems = 0

	self:BindUIEvent("btn_back",UIEventType.Click,"OnBackChick")
end
--服务器返回协议内容
function wnd_paihangbangClass:FillData(reDoc)
	local n = 1
	self.rankList = {}

	local rank = reDoc:GetValue("ranklist")
	local rankFunc = function(id,mailInfos)
        local rank = {}
        rank.pm = tonumber( mailInfos:GetValue("pm") )
        rank.lv = tonumber( mailInfos:GetValue("lv") )
        rank.name = tostring( mailInfos:GetValue("name") )
		rank.face = tostring( mailInfos:GetValue("faceIdx") )
		self.rankList[n] = rank   
		n = n + 1 
    end
    rank:Foreach(rankFunc)
end
function wnd_paihangbangClass:OnShowDone()
	local m_Item = self.instance:FindWidget("Grid/ph_single")

	for i = 1,#self.rankList do
		local newItem = GameObject.InstantiateFromPreobj(m_Item,self.instance:FindWidget("ph_scroll/Grid"))
		newItem:SetLocalPosition(Vector3.new(-(#self.rankList-i),0,0))--位置出生位置
		newItem:SetName("rank"..i)

		newItem:SetActive(true)

		self:SetLabel("rank"..i.."/ID",self.rankList[i].pm)
		self:SetLabel("rank"..i.."/name_bg/txt",self.rankList[i].name)
		self:SetLabel("rank"..i.."/score",self.rankList[i].lv)


		local each_func = function(key,row)
			if row[sdata_NormalHead.I_ID] == tonumber(self.rankList[i].face) then
				local faceHead = self.instance:FindWidget("rank"..i.."/head")
				local faceHeadSprite = faceHead:GetComponent( CMUISprite.Name )--获得Sprite组件
				faceHeadSprite:SetAtlas(row[sdata_NormalHead.I_PackageName], row[sdata_NormalHead.I_AtlasName])
				faceHeadSprite:SetSpriteName(row[sdata_NormalHead.I_Skin])
			end
		end
		sdata_NormalHead:Foreach(each_func)

		self:BindUIEvent("rank"..i.."/bg",UIEventType.Click,"OnClickitem",i)
		self:BindUIEvent("rank"..i.."/btn_detailinfo",UIEventType.Click,"OnClickitem",i)

	end
	local gridObj = self.instance:FindWidget("ph_scroll/Grid")
	local cmgrid = gridObj:GetComponent(CMUIGrid.Name)
	cmgrid:Reposition()
end
function wnd_paihangbangClass:OnBackChick()
	for i  = 1 ,#self.rankList do 
		if self.instance:FindWidget("rank"..i) then
			local Item = self.instance:FindWidget("rank"..i)
			Item:Destroy()
		end
	end				
	self:Hide()
end
function wnd_paihangbangClass:OnClickitem(gameObj,id)
	local Item1 = self.instance:FindWidget("ph_playerinfo")
	Item1:SetActive(true)
	self:SetLabel ("bg/name_bg/txt",self.rankList[id].name)
	self:SetLabel ("score_icon/score",self.rankList[id].lv)
	
	local each_func = function(key,row)
	
		if row[sdata_NormalHead.I_ID] == tonumber(self.rankList[id].face) then
			local faceHead = self.instance:FindWidget("bg/head")
			local faceHeadSprite = faceHead:GetComponent( CMUISprite.Name )--获得Sprite组件
			faceHeadSprite:SetAtlas(row[sdata_NormalHead.I_PackageName], row[sdata_NormalHead.I_AtlasName])
			faceHeadSprite:SetSpriteName(row[sdata_NormalHead.I_Skin])
		end
	end
	sdata_NormalHead:Foreach(each_func)

--	self:setUserHero(self:GetwanjiaHERO(id).Hero)--玩家英雄
--	self:BindUIEvent("btn_1",UIEventType.Click,"Onjiahaoyou")--加好友
	self:BindUIEvent("ph_playerinfo/back",UIEventType.Click,"Onback")
end 
function wnd_paihangbangClass:Onback()
	local Item1 = self.instance:FindWidget("ph_playerinfo")
	Item1:SetActive(false)
end
--function wnd_paihangbangClass:Onjiahaoyou()
--	StartCoroutine(self,self.cojiahaoyou,{})--启动一个协程
--end
--function wnd_paihangbangClass:cojiahaoyou(gameObj)	
--	local resultwait = MsgboxResultWait.new()
--	MsgBox.Show("是否确定加好友?","否","是",resultwait,resultwait.OnMsgBoxClose)
--	local result = resultwait:GetResult()--读取对话框返回结果
--	if(result == 2) then--用户加好友
--	end	
--end
--function wnd_paihangbangClass:setUserHero(table)
--	self.hero_head = self.instance:FindWidget("hero_scorll/Grid/hero_0")
--	self.hero_head:SetActive(false)
--	local heroPanel = self.hero_head:GetParent()--获得容器
--	for i = 1,#table do
--		local itemObj = GameObject.InstantiateFromPreobj(self.hero_head,heroPanel)
--		itemObj:SetName("level"..i)
--		itemObj:SetActive(true)
--		print(table[i].id)
--		--local heroInfo = SData_Hero.GetHeroData (table[i].id)
--		--print(heroInfo)
--	end
--end


--实例即将被丢失
function wnd_paihangbangClass:OnLostInstance()
end 

return wnd_paihangbangClass.new

