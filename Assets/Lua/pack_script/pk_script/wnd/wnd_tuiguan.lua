local wnd_tuiguanClass = class(wnd_base)

wnd_tuiguan = nil--单例

TuiGuanGiveUpType = {
TuiGuan = 0,
FightWin = 1,
}

TuiGuanEnum = {
Normal = 0,     --普通模式
Hard = 1,       --难度模式
}
--省状态
local ProvincesState = {

Unlock = 1, --已解锁
Locked = 2, --未解锁
Attack = 3, --攻打中
Occupy = 4, --已占领
Betray = 5, --暴乱

}

--省信息表 包括当前状态
local ProvincesInfo = {
{ID = 1,State = 2}
}
local TuiGuanMixed = {
CurrentAttackMission = 0,       --当前关

isWin = 1,                    --战斗结果

isNeedCreate = true,           --是否需要创建
isLostInstance = true,          --是否丢失实例

GiveUpType = 0,                 --放弃推关

OpenProvince = 1,               --开放的省

isAlreadyRandomCard = false,    --是否随机出手牌
isJustWin = false,              --是否刚刚出战场
}
local TuiGuanCitysShadow = {}
local TuiGuanCitys = {}
local TuiGuanProvinces = {}

local TuiGuanTreasure = {}
local TuiGuanTreasureItem = {}
local TuiGuanProvinceTreasure = {}

function wnd_tuiguanClass:Start()
	wnd_tuiguan = self
	self:Init(WND.Tuiguan)
	EventHandles.OnTopWndChanged:AddListener(self,self.OnTopWndChanged)
	self.bIslistenmoney = false --金币铜币监听标记
	self.TuiGuanClouds = {}
	self.TuiGuanBaoXiang = nil;
end

--窗体被实例化时被调用
--初始化实例
function wnd_tuiguanClass:OnNewInstance()
	self.TargetVisible = true
	self.bIsBuyhero = false
	print("wnd_tuiguanClass:OnNewInstance")
	
	self.m_enlarge = self.instance:FindWidget("enlarge")
	
	self.m_CityBase = self.instance:FindWidget("stateandcity/city")
	self.m_ProvincesBase = self.instance:FindWidget("stateandcity/state")
	
	self.gameobj = self.instance:FindWidget("enlarge")
	
	self.content = self.instance:FindWidget("content")
	self.content:AddComponent(CMUIZoomScale.Name)
	self.m_ZoomScale = self.content:GetComponent(CMUIZoomScale.Name)
	local evthandle = self.m_ZoomScale:BindEvent()
	--self.m_ZoomScale:SetInfo(1000,200,-100,500,0,10)
	self.m_ZoomScale:SetInfo(1500,700,400,1100,500,30)
	self.m_ZoomScale:SetSizeInfo(5000,2000,3000,800)
	StartCoroutine(self, self.CreateAllCityUI,{})
	self.FirstShowPaikuZhengying = 0 --用于保存当前显示的阵营
	
	self.bisWin = 0
end

function wnd_tuiguanClass:OnTopWndChanged(wnd)
	
	if self.m_ZoomScale == nil then return end
	if wnd ~= nil then
		local n = ifv(wnd == "ui_tuiguan",1,0)
		self.m_ZoomScale:SetControl(tonumber( n ))
	end
end

function wnd_tuiguanClass:IsNeedPostCard()
	print("wnd_tuiguanClass:IsNeedPostCard")
	local temp = Player:GetObjectF("ply/gkSaveFiles/0")
	if temp == nil then
		TuiGuanMixed.isAlreadyRandomCard = false
		return
	end
	local isc = temp:GetValue("isC")
	local tVa = tonumber( isc )
	
	TuiGuanMixed.isAlreadyRandomCard = (tVa == 1)
end

function wnd_tuiguanClass:AutoZPosition()
	
	local nCity,nProvince = sdata_MissionMonster:GetOrganization(TuiGuanMixed.CurrentAttackMission)
	local p = self.content:GetLocalPosition()
	
	if self.ContentZ ~= nil then
		self.m_ZoomScale:Move(self.ContentZ)
	else
		self.m_ZoomScale:Move(550)
	end
end


function wnd_tuiguanClass:OnShowDone()
	StartCoroutine(self, self.WaitLoadFinishToOnShowDone,{})
end

function wnd_tuiguanClass:WaitLoadFinishToOnShowDone()
	while TuiGuanMixed.isNeedCreate do
		Yield()
	end
	print("wnd_tuiguanClass:OnShowDone")
	hadJumpedToTuiguan = true
	--wnd_buzheng:NM_ReBuZhenInfo()
	
	if not self.bIslistenmoney then
		self.bIslistenmoney = true
	end
	self:FillContent()
	
	local sequencem = Sequence.new()
	sequencem:InsertCallback(1.0,self,self.AutoZPosition)
	
	WndManage.Hide("ui_prefight",0.5)
	
	print("wnd_tuiguanClass:OnShowDone End")
end


--实例即将被丢失
function wnd_tuiguanClass:OnLostInstance()
	print("wnd_tuiguanClass:OnLostInstance")
	self:ClearAllCityUI()
	TuiGuanMixed.isLostInstance = true
	self.TuiGuanBaoXiang = nil;
end


function wnd_tuiguanClass:ClearAllCityUI()
	local temp = 1
	for k,v in pairs (TuiGuanCitys) do
		v:Destroy()
		temp = temp + 1
	end
	temp = 1
	TuiGuanCitysShadow = {}
	TuiGuanCitys = {}
	
	for k,v in pairs (TuiGuanProvinces) do
		v:Destroy()
		temp = temp + 1
	end
	TuiGuanProvinces = {}
	for k,v in pairs (self.TuiGuanClouds) do
		v:Destroy()
	end
	self.TuiGuanClouds = {};
	
	TuiGuanMixed.isNeedCreate = true
end


function wnd_tuiguanClass:CreateAllCityUI()--加载城、省、云
	
	if TuiGuanMixed.isNeedCreate == false then
		return
	end
	
	TuiGuanMixed.isNeedCreate = false
end


function wnd_tuiguanClass:Routine()
	print("wnd_tuiguanClass:Routine")
	
	--self:UpdateCloud();
end


function wnd_tuiguanClass:FillContent()
	self:Routine()
end


function wnd_tuiguanClass:SyncFakeGK()
	print("wnd_tuiguanClass:SyncFakeGK",Player)
	--self.isPerformance = tonumber( Player:GetAttr(PlayerAttrNames.Probie) )
	self.isPerformance = 1
	print("wnd_tuiguanClass:SyncFakeGK1",self.isPerformance)
	wnd_tuiguan:Show()
	print("wnd_tuiguanClass:SyncFakeGK End")
end


function wnd_tuiguanClass:UpdateCloud()
	
	local proID =  1;
	--print ("wnd_tuiguanClass:UpdateCloud ========= ProID:",proID)
	local eatchfunch = function (key,value)
		local itemObj = value
		if (itemObj == nil)then
			return;
		end
		local quad = itemObj:GetComponent(QKUIQuad.Name);
		if (quad ~= nil)then
			--print ("wnd_tuiguanClass:UpdateCloud ============= key"  ,key ,curV)
			if (curV == 2  and key > proID)then
				itemObj:SetActive(true);
				quad:SetColliderEnable(true);
				quad:SetOutLine(true);
			elseif (curV == 4 )then
				itemObj:SetActive(true);
				quad:SetColliderEnable(false);
				quad:SetOutLine(false);
			else
				itemObj:SetActive(false);
				quad:SetColliderEnable(false);
				quad:SetOutLine(false);
			end
		end
	end
	table.foreach(self.TuiGuanClouds,eatchfunch)
	self:SetProvinceCloud();
	
end
--主要用来设置底层的云层更新的
function wnd_tuiguanClass:SetProvinceCloud()
	local Province = Player:GetOpenProvinceID();
	QKUIQuad.SetProID(Province);
end

return wnd_tuiguanClass.new
