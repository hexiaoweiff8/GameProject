--wnd_replayinfo.lua
--Date：2015.10
--GYT


local wnd_replayinfoClass = class(wnd_base)

wnd_replayinfo = nil--单例

function wnd_replayinfoClass:Start() 
	wnd_replayinfo = self
	self:Init(WND.Replayinfo)
end
function wnd_replayinfoClass:ctor()
	self.UIFormationg = exui_Formation.new()--创建阵位控件
	self.UIFormationf = exui_Formation.new()
end
--窗体被实例化时被调用
--初始化实例
function wnd_replayinfoClass:OnNewInstance()
    --绑定事件
	self.m_ItemMB = self.instance:FindWidget("info_enemy/zw1/slot/zw1")
    self.m_ItemMB:SetActive(false)
	self.m_Item = self.instance:FindWidget("info_mine/zw1/slot/zw1")
    self.m_Item:SetActive(false)
--阵位实例初始化
	self.UIFormationg:OnNewInstance(self.instance:FindWidget("info_enemy"),self.m_ItemMB) 
	self.UIFormationf:OnNewInstance(self.instance:FindWidget("info_mine"),self.m_Item) 
	self:BindUIEvent("btn_back",UIEventType.Click,"back")	
end
function wnd_replayinfoClass:back()
   self:Hide()
end
function wnd_replayinfoClass:FillData(reDoc)
	local lwin = tonumber (reDoc:GetValue("lwin"))--1攻击方胜  0防御方胜
	local tx = tonumber (reDoc:GetValue("tx"))--是否为偷袭 int 1是 0不是
--#攻击方信息
	local gNode = reDoc:GetValue("g")
	self.gnm = tostring (gNode:GetValue("nm"))--昵称
	self.gzdl = tonumber (gNode:GetValue("zdl"))--战斗力
	self.gsex = tonumber (gNode:GetValue("sex"))--性别
	self.gwcon = tonumber (gNode:GetValue("wcon"))--胜场数
	self.glv = tonumber (gNode:GetValue("lv"))--等级
	self.gsl = tonumber (gNode:GetValue("sl"))--势力ID
	self.gpm = tonumber (gNode:GetValue("pm"))--排名
--英雄属性
	local hattrNode = gNode:GetValue("hero")
	self.gheroList = {}
	local heroFunc = function(dyID,heroInfos)
		dyID = tonumber(dyID)
		local heroAtrrs = {}
        heroAtrrs.dyID = dyID
        heroAtrrs.level = tonumber( heroInfos:GetValue("lv") )--等级
		heroAtrrs.sid = tonumber( heroInfos:GetValue("i") )--数据id
        heroAtrrs.xj = tonumber( heroInfos:GetValue("xj") )--星级
		heroAtrrs.zs = tonumber( heroInfos:GetValue("zs") )--是否已转生
        self.gheroList[dyID] = heroAtrrs   
    end
    hattrNode:Foreach(heroFunc)

	local zhengNode = gNode:GetValue("F")--取得阵形节点
    self.gformation = FormationCtor.FromJsonNode(zhengNode)--解析出阵型信息

--#防御方信息
	local fNode = reDoc:GetValue("f")
	self.fnm = tostring (fNode:GetValue("nm"))--昵称
	self.fzdl = tonumber (fNode:GetValue("zdl"))--战斗力
	self.fsex = tonumber (fNode:GetValue("sex"))--性别
	self.fwcon = tonumber (fNode:GetValue("wcon"))--胜场数
	self.flv = tonumber (fNode:GetValue("lv"))--等级
	self.fsl = tonumber (fNode:GetValue("sl"))--势力ID
	self.fpm = tonumber (fNode:GetValue("pm"))--排名
--英雄属性
	local fhattrNode = fNode:GetValue("hero")
	self.fheroList = {}
	local fheroFunc = function(dyID,heroInfos)
		dyID = tonumber(dyID)
		local heroAtrrs = {}
        heroAtrrs.dyID = dyID
        heroAtrrs.level = tonumber( heroInfos:GetValue("lv") )--等级
		heroAtrrs.sid = tonumber( heroInfos:GetValue("i") )--数据id
        heroAtrrs.xj = tonumber( heroInfos:GetValue("xj") )--星级
		heroAtrrs.zs = tonumber( heroInfos:GetValue("zs") )--是否已转生
        self.fheroList[dyID] = heroAtrrs   
    end
    fhattrNode:Foreach(fheroFunc)

	local fzhengNode = fNode:GetValue("F")--取得阵形节点
    self.fformation = FormationCtor.FromJsonNode(fzhengNode)--解析出阵型信息

end
function wnd_replayinfoClass:OnShowDone()
	local name = GameObject.Find("info_enemy/info_frame/name")
	local label_name = name:GetComponent( CMUILabel.Name )--获得label组件
	label_name:SetValue(self.gnm)
	local zdl = GameObject.Find("info_enemy/info_frame/strengh_point")
	local label_zdl = zdl:GetComponent( CMUILabel.Name )--获得label组件
	label_zdl:SetValue("战斗力："..self.gzdl)
	local wins = GameObject.Find("info_enemy/info_frame/wins")
	local label_wins = wins:GetComponent( CMUILabel.Name )--获得label组件
	label_wins:SetValue("胜场数："..self.gwcon)
	local country = GameObject.Find("info_enemy/info_frame/force")
	local label_country = country:GetComponent( CMUILabel.Name )--获得label组件
	local con = "未加入任何势力"
	if self.gsl == 1 then
		con = "蜀国"
	elseif self.gsl == 2 then
		con = "魏国"
	elseif self.gsl == 3 then
		con = "吴国"
	end
	label_country:SetValue(con)
	local table1 = {}
	local str = tostring(self.gpm)
	for k = 1 ,#str do
		table1[k] = string.sub(str,k,k)
	end
	for i = 1 ,#table1 do
		local a = 0
		if #table1 == 2 then
			a = 13
		elseif #table1 == 3 then
			a = 26
		elseif #table1 == 4 then
			a = 39
		elseif #table1 == 5 then
			a = 52
		end
		local MSzi = GameObject.Find("info_enemy/info_frame/rank_num/Grid/num"..i)
		MSzi:SetLocalPosition(Vector3.new((i-1)*26-a,0,0))
		local ziSprite = MSzi:GetComponent( CMUISprite.Name )--获得label组件
		ziSprite:SetSpriteName("jjc_num"..table1[i])
		MSzi:SetActive(true)
	end

	local fname = GameObject.Find("info_mine/info_frame/name")
	local label_fname = fname:GetComponent( CMUILabel.Name )--获得label组件
	label_fname:SetValue(self.fnm)
	local fzdl = GameObject.Find("info_mine/info_frame/strengh_point")
	local label_fzdl = fzdl:GetComponent( CMUILabel.Name )--获得label组件
	label_fzdl:SetValue("战斗力："..self.fzdl)
	local fwins = GameObject.Find("info_mine/info_frame/wins")
	local label_fwins = fwins:GetComponent( CMUILabel.Name )--获得label组件
	label_fwins:SetValue("胜场数："..self.fwcon)
	local fcountry = GameObject.Find("info_mine/info_frame/force")
	local label_fcountry = fcountry:GetComponent( CMUILabel.Name )--获得label组件
	local fcon = "未加入任何势力"
	if self.fsl == 1 then
		fcon = "蜀国"
	elseif self.fsl == 2 then
		fcon = "魏国"
	elseif self.fsl == 3 then
		fcon = "吴国"
	end
	label_fcountry:SetValue(fcon)
	local table1 = {}
	local str = tostring(self.fpm)
	for k = 1 ,#str do
		table1[k] = string.sub(str,k,k)
	end
	for i = 1 ,#table1 do
		local a = 0
		if #table1 == 2 then
			a = 13
		elseif #table1 == 3 then
			a = 26
		elseif #table1 == 4 then
			a = 39
		elseif #table1 == 5 then
			a = 52
		end
		local MSzi = GameObject.Find("info_mine/info_frame/rank_num/Grid/num"..i)
		MSzi:SetLocalPosition(Vector3.new((i-1)*26-a,0,0))
		local ziSprite = MSzi:GetComponent( CMUISprite.Name )--获得label组件
		ziSprite:SetSpriteName("jjc_num"..table1[i])
		MSzi:SetActive(true)
	end
	self.UIFormationg:SetFormation(self.gformation,self.gheroList)
	self.UIFormationf:SetFormation(self.fformation,self.fheroList)
end
--function wnd_replayClass:onChickReplay(gameObj,id)
--	print("显示另一个窗体")
--end 
--实例即将被丢失
function wnd_replayinfoClass:OnLostInstance()
end 
 
return wnd_replayinfoClass.new


--endregion
