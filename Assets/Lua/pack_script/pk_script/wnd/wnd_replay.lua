-- wnd_replay.lua 竞技场界面
--Date：2015.10
--GYT


local wnd_replayClass = class(wnd_base)

wnd_replay = nil--单例

function wnd_replayClass:Start() 
	wnd_replay = self
	self:Init(WND.Replay)
end
--窗体被实例化时被调用
--初始化实例
function wnd_replayClass:OnNewInstance()
    --绑定事件
	self.m_Item = self.instance:FindWidget("Grid/reply_singe")
	self.m_Item:SetActive(false)
	self.bIsShow = false
	self:BindUIEvent("btn_back",UIEventType.Click,"back")	
end
function wnd_replayClass:back()
   self:Hide()
end
function wnd_replayClass:FillData(reDoc)
	local lNode = reDoc:GetValue("l")
	self.fightList = {}
	local n = 1
	local fightFunc = function(_,replayInfos)
		local heroAtrrs = {}
		heroAtrrs.nm = tostring (replayInfos:GetValue("nm"))--昵称
		heroAtrrs.lwin = tonumber (replayInfos:GetValue("lwin"))--1攻击方胜  0防御方胜
		heroAtrrs.opm = tonumber (replayInfos:GetValue("opm"))--名次增量 负数代表提高，正数代表降低 例如-9代表提升了9名
		heroAtrrs.sex = tonumber (replayInfos:GetValue("sex"))--性别
		heroAtrrs.lv = tonumber (replayInfos:GetValue("lv"))--等级
		heroAtrrs.t = tonumber (replayInfos:GetValue("t"))--战报已经产生了多少时间(秒)
		heroAtrrs.id = tonumber (replayInfos:GetValue("id"))--战报id
		heroAtrrs.tx = tonumber (replayInfos:GetValue("tx"))--是否为偷袭 int #1是 0不是
        self.fightList[n] = heroAtrrs   
		n = n+1
    end
    lNode:Foreach(fightFunc)
end
function wnd_replayClass:OnShowDone()
	if self.bIsShow then
		return
	end	
	local heroPanel = self.m_Item:GetParent()
	for i = 1 ,#self.fightList do
		local itemObj = GameObject.InstantiateFromPreobj(self.m_Item,heroPanel)
		itemObj:SetLocalPosition(Vector3.new(0,-(i-1)*88,0))
		itemObj:SetName("user"..i)
		itemObj:SetActive(true)--激活对象
		local upm = GameObject.Find("user"..i.."/bg/change_num")
		local u_num = upm:GetComponent( CMUILabel.Name )--获得label组件
		local num = math.abs(self.fightList[i].opm)
		u_num:SetValue( num )
		local opended1 = self.instance:FindWidget("user"..i.."/bg/rank_change/up")
		opended1:SetActive(false)
		local opended2 = self.instance:FindWidget("user"..i.."/bg/rank_change/down")
		opended2:SetActive(false)
		if self.fightList[i].opm > 0 then
			upm:SetActive(true)
			opended2:SetActive(true)
		elseif self.fightList[i].opm < 0 then
			upm:SetActive(true)
			opended1:SetActive(true)
		end
		local uname = GameObject.Find("user"..i.."/bg/lv_bg/txt")
		local u_name = uname:GetComponent( CMUILabel.Name )--获得label组件
		u_name:SetValue(self.fightList[i].lv)
		local ufight = GameObject.Find("user"..i.."/bg/name_bg/Label")
		local u_fight = ufight:GetComponent( CMUILabel.Name )--获得label组件
		u_fight:SetValue(self.fightList[i].nm)
		local opended3 = self.instance:FindWidget("user"..i.."/bg/title_frame/win")
		opended3:SetActive(false)
		local opended4 = self.instance:FindWidget("user"..i.."/bg/title_frame/lose")
		opended4:SetActive(false)
		if self.fightList[i].lwin == 1 then
			opended3:SetActive(true)
		else
			opended4:SetActive(true)
		end
		self:BindUIEvent("user"..i.."/bg/btn_review",UIEventType.Click,"onChickReplay",self.fightList[i].id)	
		self.bIsShow = true
--		self:BindUIEvent("user"..i,UIEventType.Click,"watchToSone",self.UserInfos[i].id)	
	end
end
function wnd_replayClass:onChickReplay(gameObj,id)
	local jsonDoc = JsonParse.SendNM("VZB")
	jsonDoc:Add("i",id)
	local loader = Loader.new(jsonDoc:ToString(),0,"ReVZB")
	LoaderEX.SendAndRecall(loader,self,self.NM_ReVZB,nil)	
	print("gggggggggggggggggg")
end 
function wnd_replayClass:NM_ReVZB(reDoc)
	print("dssssssssssssssssssssss")
	wnd_replayinfo:FillData(reDoc)
	wnd_replayinfo:Show()
end 
--实例即将被丢失
function wnd_replayClass:OnLostInstance()
end 
 
return wnd_replayClass.new