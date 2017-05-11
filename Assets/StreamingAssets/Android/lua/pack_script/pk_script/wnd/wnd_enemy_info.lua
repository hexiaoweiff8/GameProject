-- wnd_enemy_info.lua 竞技场界面
--Date：2015.10
--GYT


local wnd_enemy_infoClass = class(wnd_base)

wnd_enemy_info = nil--单例

function wnd_enemy_infoClass:Start() 
	wnd_enemy_info = self
	self:Init(WND.Enemy_info,true)
end
function wnd_enemy_infoClass:ctor()
	self.UIFormation = exui_Formation.new()--创建阵位控件
end
--窗体被实例化时被调用
--初始化实例
function wnd_enemy_infoClass:OnNewInstance()
    --绑定事件
	self:BindUIEvent("btn_back",UIEventType.Click,"back")
	self.m_ItemMB = self.instance:FindWidget( "bg/zw1/slot/zw1" )
    self.m_ItemMB:SetActive(false)
	--阵位实例初始化
	self.UIFormation:OnNewInstance(self.instance:FindWidget("bg"),self.m_ItemMB) 
end
function wnd_enemy_infoClass:back()
   self:Hide()
end
function wnd_enemy_infoClass:FillData(reDoc,pm)
	
	self.pn = tostring (reDoc:GetValue("pn"))--玩家名
	self.zdl = tonumber (reDoc:GetValue("zdl"))--战斗力
	self.pm = tonumber (reDoc:GetValue("pm"))--排名
	if pm ~= nil then
		self.pm = pm
	end
	self.plv = tonumber (reDoc:GetValue("plv"))--玩家等级
	self.win = tonumber (reDoc:GetValue("win"))--胜利场数
	self.sl = tonumber (reDoc:GetValue("sl"))--所属势力ID
	self.m = tonumber (reDoc:GetValue("m"))--模式

	local zhengNode = reDoc:GetValue("F")--取得阵形节点
    self.formation = FormationCtor.FromJsonNode(zhengNode)--解析出阵型信息

	--英雄属性
	local hattrNode = reDoc:GetValue("hattr")
	self.heroList = {}
	local heroFunc = function(dyID,heroInfos)
		dyID = tonumber(dyID)
		local heroAtrrs = {}
        heroAtrrs.dyID = dyID
        heroAtrrs.level = tonumber( heroInfos:GetValue("lv") )--等级
		heroAtrrs.sid = tonumber( heroInfos:GetValue("i") )--数据id
        heroAtrrs.xj = tonumber( heroInfos:GetValue("xj") )--星级
		heroAtrrs.zs = tonumber( heroInfos:GetValue("zs") )--是否已转生
        self.heroList[dyID] = heroAtrrs   
    end
    hattrNode:Foreach(heroFunc)
end
function wnd_enemy_infoClass:OnShowDone()

	local name = GameObject.Find("info_frame/name")
	local label_name = name:GetComponent( CMUILabel.Name )--获得label组件
	label_name:SetValue(self.pn)
	local zdl = GameObject.Find("info_frame/strengh_point")
	local label_zdl = zdl:GetComponent( CMUILabel.Name )--获得label组件
	label_zdl:SetValue("战斗力："..self.zdl)
	local wins = GameObject.Find("info_frame/wins")
	local label_wins = wins:GetComponent( CMUILabel.Name )--获得label组件
	label_wins:SetValue("胜场数："..self.win)
	local country = GameObject.Find("info_frame/force")
	local label_country = country:GetComponent( CMUILabel.Name )--获得label组件
	local con = "未加入任何势力"
	if self.sl == 1 then
		con = "蜀国"
	elseif self.sl == 2 then
		con = "魏国"
	elseif self.sl == 3 then
		con = "吴国"
	end
	label_country:SetValue(con)

	local table1 = {}
	local str = tostring(self.pm)
	print(self.pm)
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
		local MSzi = GameObject.Find("info_frame/rank_num/Grid/num"..i)
		MSzi:SetLocalPosition(Vector3.new((i-1)*26-a,0,0))
		local ziSprite = MSzi:GetComponent( CMUISprite.Name )--获得Sprite组件
		ziSprite:SetSpriteName("jjc_num"..table1[i])
		MSzi:SetActive(true)
	end
	self.UIFormation:SetFormation(self.formation,self.heroList) 
end
--实例即将被丢失
function wnd_enemy_infoClass:OnLostInstance()
	
end 
 
return wnd_enemy_infoClass.new
 