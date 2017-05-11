-- wnd_fight_info.lua 竞技场界面
--Date：2015.10
--GYT


local wnd_fight_infoClass = class(wnd_base)

wnd_fight_info = nil--单例

function wnd_fight_infoClass:Start() 
	wnd_fight_info = self
	self:Init(WND.Fight_info,true)
end
function wnd_fight_infoClass:ctor()
	self.UIFormation = exui_Formation.new()--创建阵位控件
end
--窗体被实例化时被调用
--初始化实例
function wnd_fight_infoClass:OnNewInstance()
    --绑定事件
	self:BindUIEvent("btn_back",UIEventType.Click,"back")
	self.m_ItemMB = self.instance:FindWidget( "info_bg/zw1/slot/zw1" )
    self.m_ItemMB:SetActive(false)
	--阵位实例初始化
	self.UIFormation:OnNewInstance(self.instance:FindWidget("info_bg"),self.m_ItemMB) 
end
function wnd_fight_infoClass:back()
   self:Hide()
end
function wnd_fight_infoClass:FillData(reDoc)
	self.pn = tostring (reDoc:GetValue("pn"))--玩家名
	self.zdl = tonumber (reDoc:GetValue("zdl"))--战斗力
	self.pm = tonumber (reDoc:GetValue("pm"))--排名
		
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
function wnd_fight_infoClass:OnShowDone()
	local name = GameObject.Find("info_frame/label1")
	local label_name = name:GetComponent( CMUILabel.Name )--获得label组件
	label_name:SetValue("战斗力："..self.zdl)
	local zdl = GameObject.Find("info_frame/label2")
	local label_zdl = zdl:GetComponent( CMUILabel.Name )--获得label组件
	label_zdl:SetValue(self.pn)
	local wins = GameObject.Find("info_frame/label3")
	local label_wins = wins:GetComponent( CMUILabel.Name )--获得label组件
	label_wins:SetValue("排名："..self.pm)
	self.UIFormation:SetFormation(self.formation,self.heroList) 
end 
--实例即将被丢失
function wnd_fight_infoClass:OnLostInstance()
end 
 
return wnd_fight_infoClass.new
 