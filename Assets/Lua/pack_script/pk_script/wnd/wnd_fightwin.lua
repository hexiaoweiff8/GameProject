
 
local wnd_fightwinClass = class(wnd_base)

wnd_fightwin = nil--单例

local HeroItem = {}
local JLItem = {}
--local JLListDoc = {}
local LeftDoc = {}
local RightDoc = {}
local MaxNum = {
  Heal = 0,         --最高治疗
  KillArmy = 0,     --最高杀兵
  Damage = 0,       --最高伤害
  Time = 0,         --战斗用时
}
local HeroHP = {}
local SelfItem1 = {}
local OtherItem1 = {}

local FightWinMixed = {
    Damage = "Damage",
    Heal = "Heal",
    Kill = "Kill",
}


function wnd_fightwinClass:Start() 
	wnd_fightwin = self
	self:Init(WND.Fightwin)
end
function wnd_fightwinClass:Test() 

end
function wnd_fightwinClass:OnInfoClose(obj,show)
    self.InfoWND:SetActive(show)
    self:OnTab(nil,FightWinMixed.Damage)
    if show == true then self:FillCount(FightWinMixed.Damage) end 
end

function wnd_fightwinClass:IsAllDeaths()
    
    local Mixed = wnd_tuiguan:GetMixed()
    local winState = Mixed.isWin
    
    if winState == 1 then 
        return false
    end

    local isAllDie = true
    local heros = Player:GetObjectF("ply/AHeroInfos")
	local eachFunc = function (syncObj)
        local Result = tonumber(syncObj:GetValue(AHeroinfos.State))
		if Result == 3 or Result == 5 then
			isAllDie = false
		end
	end
	heros:Foreach(eachFunc)

    print("wnd_fightwinClass:IsAllDeaths ================== ",isAllDie)
    return isAllDie
end

function wnd_fightwinClass:OnClose()
    print("wnd_fightwinClass:OnClose")
    WndManage.Show("ui_prefight",0.5)
    self:Hide()
	if wnd_buzheng.t then
		wnd_buzheng.t = false
		Battlefield.Reset()
		wnd_tuiguan:Show()
		wnd_randomEvents:guaiwuRes(self.IsWin , false)
print("wnd_fightwinClass:OnClose--------",wnd_tuiguan.sjt,wnd_tuiguan.sjinfo,wnd_tuiguan.sjid)
		wnd_randomEvents:JLData(wnd_tuiguan.sjt,wnd_tuiguan.sjinfo,wnd_tuiguan.sjid)
		wnd_randomEvents:Show()
	else 
		if self.ClickFlag == true then return print("wnd_fightwinClass:OnClose AllDie Wait") end
		
		if self:IsAllDeaths() then 
			self.ClickFlag = true
			self.Btn = "Close"

			local tuiguan = wnd_tuiguan:GetMixed()
			local City , province = sdata_MissionMonster:GetOrganization(tuiguan.ReadyFightMission)

			self:SendGiveUp()
		else 
			self:RealClose()
		end
	end

end

function wnd_fightwinClass:AfterGiveUp()

    --Poptip.PopMsg("手牌武将全部阵亡推关失败,在这播动画",Color.red)
    
    WndJumpManage:CancelAllJumps()
    if self.Btn == "Close" then 
        self:RealClose()
    else
        self:RealReFight()
    end
    wnd_tuiguanfail:Show()
end

function wnd_fightwinClass:ShowMain()
    Battlefield.Reset()
    wnd_tuiguan:Show()
end

function wnd_fightwinClass:IFCityComplate()
    local Temp = wnd_tuiguan.GetMixed()
    print("wnd_fightwinClass:IFCityComplate")
    if Temp.CurrentAttackMission == 0 and Temp.isWin == 1 then
		--type==5代表攻城成功
        print("wnd_fightwinClass:IFCityComplate ==== True")
		wnd_success:showType(5) 
		wnd_success:Show() 
    end
end

function wnd_fightwinClass:RealClose()
    self.ClickFlag = false
    self:ShowMain()
    EventHandles.OnWndExit:Call(WND.Fightwin)

    self:IFCityComplate()
end

function wnd_fightwinClass:SendGiveUp()
    wnd_tuiguan:SendGiveUpNetWork(TuiGuanGiveUpType.FightWin)
end

function wnd_fightwinClass:OnReFight()
    print("wnd_fightwinClass:OnReFight")
    if self.RefightFlag == true then return print("wnd_fightwinClass:OnReFight AllDie Wait") end

    if self:IsAllDeaths() then 

        self.RefightFlag = true

        self.Btn = "Refight"

        self:SendGiveUp()
        
    else 
        self:RealReFight()
    end

    
end

function wnd_fightwinClass:RealReFight()
    self.RefightFlag = false
    if self:IsAllDeaths() then 
        self:RealClose()
    else
        WndJumpManage:CancelAllJumps()
        self:ShowMain()
        self:Hide()
        WndJumpManage:Jump(WND.Readyfight,WND.BuZheng)
    end
end

function wnd_fightwinClass:SetJLList(_JLList)
    self.JLListDoc = {}
    self.JLListDoc = _JLList
    --local Func = function(k,v)
    --    print("wnd_fightwinClass:SetJLList====================",k,v)
    --end
    --self.JLListDoc:Foreach(Func)
    
end
function wnd_fightwinClass:AnalyseResult(_Doc,_Result)
    for k,v in pairs(_Doc) do 
        local Temp = {}
        Temp.Heal =  v:NursedCount()
        Temp.KillArmy =  v:KillSoldiersCount()
        Temp.Damage =  v:HitCount()
        Temp.ID =  v:StaticDataID()
        Temp.FID =  v:Fid()
        Temp.HP =  v:CurrHP()
        Temp.MaxHP =  v:MaxHP()
        if self.isLeft then 
            Temp.ReBlood = self.ReBloodRate * Temp.MaxHP + Temp.HP
        else
            Temp.ReBlood = Temp.HP
        end
        if Temp.ReBlood > Temp.MaxHP then Temp.ReBlood = Temp.MaxHP end
        Temp.XJ =  v:HeroXJ()
        Temp.LV =  v:HeroLevel()
        Temp.Army = v:AliveSoldiers()
        table.insert(_Result,Temp)

        --print("wnd_fightwinClass:AnalyseResult======================================Temp.Army:",Temp.Army)
        if Temp.Heal > MaxNum.Heal then MaxNum.Heal = Temp.Heal end
        if Temp.KillArmy > MaxNum.KillArmy then MaxNum.KillArmy = Temp.KillArmy end
        if Temp.Damage > MaxNum.Damage then MaxNum.Damage = Temp.Damage end
    end
end
function wnd_fightwinClass:GetHero(Flag, HeroID)
    --print("wnd_fightwinClass:GetHero",Flag, HeroID)
    if Flag == 1 then   --赢
        TempInfo = LeftDoc
    else                    --输
        TempInfo = RightDoc
    end

    for k,v in pairs(TempInfo) do
        if v.ID == HeroID then 
            return v
        end
    end
    return nil
end

function wnd_fightwinClass:GetHeroHP(Flag, HeroID)
    local TempInfo = self:GetHero(Flag,HeroID)
    if TempInfo == nil then return 1,1 end
    return TempInfo.HP, TempInfo.MaxHP
end
function wnd_fightwinClass:GetBattleTime()
    return tonumber(MaxNum.Time)
end
function wnd_fightwinClass:AddHeros(JsonDoc)
    local mixed = wnd_tuiguan:GetMixed()
    local TempInfo = {}
    if mixed.isWin == 1 then 
        TempInfo = LeftDoc
    else
        TempInfo = RightDoc
    end

    for i = 1, #TempInfo do 
        local value = TempInfo[i]
        local OneHero = QKJsonDoc.NewMap()
        OneHero:Add("id",value.ID)
        OneHero:Add("h",value.HP)
        OneHero:Add("an",value.Army)
        JsonDoc:Add(tostring(value.ID),OneHero)
    end
end


function wnd_fightwinClass:SetResult(_Result)
    --print("wnd_fightwinClass:SetResult1")
    local Mixed = wnd_tuiguan:GetMixed()
    self.ReBloodRate = sdata_MissionMonster:GetV(sdata_MissionMonster.I_HuifuHp,Mixed.ReadyFightMission)
    
    LeftDoc = {}
    RightDoc = {}
    MaxNum.Heal = 0
    MaxNum.KillArmy = 0
    MaxNum.Damage = 0
    MaxNum.Time = _Result:FightTime()
    local LeftTemp = _Result:LeftHeros()
    self.isLeft = true
    self:AnalyseResult(LeftTemp,LeftDoc)
    self.isLeft = false
    local RightTemp = _Result:RightHeros()
    self:AnalyseResult(RightTemp,RightDoc)
end

function wnd_fightwinClass:FillResult()
    local i = 1 
    for k,v in pairs(HeroItem) do    
        CodingEasyer:SetHero(v,LeftDoc[i])  
        local TempInfo = LeftDoc[i]
        if TempInfo ~= nil then 
            local Hp,MaxHp = self:GetHeroHP(1,TempInfo.ID)   
            local pro = v:FindChild("hp_bg")
            local proCm = pro:GetComponent(CMUIProgressBar.Name)
            proCm:SetValue(Hp/MaxHp)
            local SLv = v:FindChild("star/txt")
            CodingEasyer:SetLabel(SLv,tostring( TempInfo.XJ ) )
            local Lv = v:FindChild("level/txt")
            CodingEasyer:SetLabel(Lv,tostring( TempInfo.LV ) )
            local Die = v:FindChild("die")
            Die:SetActive( Hp == 0 )
            v.ID = TempInfo.ID
        end
        i = 1 + i
    end
end
function wnd_fightwinClass:FillIndex(_Info,_Item,FlagValue,TabString)
    _Item:SetActive(_Info ~= nil)
    if _Info == nil then return end
    local tempValue = 0
    if TabString == FightWinMixed.Heal then 
        tempValue = _Info.Heal
    elseif TabString == FightWinMixed.Kill then 
        tempValue = _Info.KillArmy
    else
        tempValue = _Info.Damage
    end
    local tempPro = _Item:FindChild("slider")
    local tempProCm = tempPro:GetComponent(CMUIProgressBar.Name)
    tempProCm:SetValue(0)
	tempProCm:SetValue(tempValue/FlagValue)
    local HeroTemp = SData_Hero.GetHero(_Info.ID)
    local cmHead = _Item:GetComponent(CMUISprite.Name)
    HeroTemp:SetHeroIcon(cmHead)

    local tempTxt = _Item:FindChild("slider/txt")
    CodingEasyer:SetLabel(tempTxt,tempValue)
    local star = _Item:FindChild("star/txt")
    CodingEasyer:SetLabel(star,_Info.XJ)
    print("wnd_fightwinClass:FillIndex End:",_Info.ID)
end
function wnd_fightwinClass:FillCount(TabString)
    print("wnd_fightwinClass:FillCount ID:",TabString)
    local FlagValue = 0
    if TabString == FightWinMixed.Heal then 
        FlagValue = MaxNum.Heal
    elseif TabString == FightWinMixed.Kill then 
        FlagValue = MaxNum.KillArmy
    else
        FlagValue = MaxNum.Damage
    end
    if FlagValue < 1 then FlagValue = 1 end
    print("wnd_fightwinClass:FillCount:",FlagValue)
    local i = 1 
    for i = 1 , 5 do 
        local Info = LeftDoc[i]
        local Item = SelfItem1[i]
        local Info2 = RightDoc[i]
        local Item2 = OtherItem1[i]
        
        self:FillIndex(Info,Item,FlagValue,TabString)
        self:FillIndex(Info2,Item2,FlagValue,TabString)
    end
end

function wnd_fightwinClass:GetJsonDoc() 
    return self.JLListDoc
end

function wnd_fightwinClass:FillJLUI()
    if self.JLListDoc == nil then return end
    local JLListTest = self.JLListDoc:GetValue("jl")
    self.JLList = {}
    if JLListTest ~= nil then
        local rankFunc = function(_,JLNode)
            local JL,isJLExist = CodingEasyer:GetJL(JLNode)
            if isJLExist == true then
                table.insert(self.JLList,JL)
            end
        end
        JLListTest:Foreach(rankFunc)
    end
    local i = 1
    for k,v in pairs(JLItem) do 
        local Info = self.JLList[i]
        v:SetActive(true)
        CodingEasyer:SetJLIcon(v,Info)
        i = i + 1
    end

    CodingEasyer:Reposition(self.m_RewardItem:GetParent())
end

function wnd_fightwinClass:UpdateStaticTxt() 

    CodingEasyer:SetLabel(self.instance:FindWidget("btn_info/txt_info"),SData_Id2String.Get(5175))
    CodingEasyer:SetLabel(self.instance:FindWidget("btn_replay/txt_info"),SData_Id2String.Get(5176))

end

function wnd_fightwinClass:GetRebloodByID(_ID)
    for k,v in pairs(HeroItem) do 
        if tonumber( v.ID )== tonumber( _ID ) then
            return v
        end
    end
end

function wnd_fightwinClass:TweenHp()

    for k,v in pairs(self.RebloodID) do 
        local temp = self:GetRebloodByID(v)
        local HpPro = temp:FindChild("hp_bg")
        local HpCm = HpPro:GetComponent(CMUIProgressBar.Name)
        local Cur = HpCm:GetValue()
        HpCm:SetValue(Cur + self.ReBloodRate / 20)
    end
    
end


function wnd_fightwinClass:Reblood()
    --Temp.ID

    self.RebloodID = {}
    for k,v in pairs(LeftDoc) do 
        
        if v.HP ~= 0 then 
            local temp = self:GetRebloodByID(v.ID)
            local ReTxt = temp:FindChild("huifu_txt")
            local HpValue = math.floor(v.ReBlood - v.HP)
            if HpValue ~= 0 then
                CodingEasyer:SetLabel(ReTxt,"+"..tostring( HpValue ))
                local Tweeners = ReTxt:GetComponents(CMUITweener.Name)
                Tweeners[1]:ResetToBeginning()
                Tweeners[1]:PlayForward()
                Tweeners[2]:ResetToBeginning()
                Tweeners[2]:PlayForward()
                table.insert(self.RebloodID,v.ID)
            end
        end 
    end

    local Times = 20
    for i = 1 , Times do 
        local sequencem = Sequence.new()
        sequencem:InsertCallback(i * 1.0/Times,self,self.TweenHp)
    end
end
function wnd_fightwinClass:SetReblood(_Value)
    self.IsNeedReblood = _Value
end

function wnd_fightwinClass:SetWinState(_Value)
	print("66666666666666666",_Value)
    self.IsWin = _Value
end

function wnd_fightwinClass:OnShowDone()
    self.ClickFlag = false
    self.RefightFlag = false
    local TuiguanMixed = wnd_tuiguan:GetMixed()
        
    local win = self.instance:FindWidget("win_tx")
    local lost = self.instance:FindWidget("los_tx")

    win:SetActive(self.IsWin == 1)
    lost:SetActive(self.IsWin == 0)

    local ReFight = self.instance:FindWidget("btn_replay")
    ReFight:SetActive(self.IsWin == 0)

    self:UpdateStaticTxt()
    self:CreateUI()
    self:FillJLUI()
    self:FillResult()

    if self.IsNeedReblood then 
        local sequencem = Sequence.new()
        sequencem:InsertCallback(1.0,self,self.Reblood)
        StartCoroutine(self,self.LoadNextWnd,{})
    else
        
    end

end
function wnd_fightwinClass:LoadNextWnd(param)
    Yield(0.3)
    wnd_tuiguan:PreLoad();
    Yield(0.1)
    if(TuiguanMixed.isWin == 0)then
        wnd_tuiguanfail.PreLoad();
    else
        wnd_readyfight.PreLoad();
    end
    
end
--窗体被实例化时被调用
--初始化实例
function wnd_fightwinClass:CreateUI()
    for k,v in pairs(JLItem) do 
        v:Destroy()
    end
    JLItem = {}

    self.m_RewardItem:SetActive(true)
    for i = 1 , 5 do 
        local itemObj = GameObject.InstantiateFromPreobj(self.m_RewardItem,self.m_RewardItem:GetParent())
		itemObj:SetName("CreateReward"..i)
        self:BindUIEvent("CreateReward"..i , UIEventType.Press,"OnItemPress",i)        
        JLItem[i] = itemObj
        itemObj:SetActive(false)
    end
    CodingEasyer:Reposition(self.m_RewardItem:GetParent())
    self.m_RewardItem:SetActive(false)
end

function wnd_fightwinClass:OnItemPress(obj,isPress,UserIndex)

    if isPress == false then return end
    print("wnd_fightwinClass:OnItemPress",obj,UserIndex)

    local TempJL = self.JLList[UserIndex]
    
    local txtW = obj:FindChild("info_txt")
    
    local Note = CodingEasyer:GetJLNote(TempJL)
    CodingEasyer:SetLabel(txtW,Note)
    
    local NameW = obj:FindChild("info_txt/name")
    local Name = CodingEasyer:GetJLName(TempJL)
    print("wnd_readyfightClass:OnItemPress1",NameW,Name)
    CodingEasyer:SetLabel(NameW,Name)

    
end

function wnd_fightwinClass:OnNewInstance()
    self:BindUIEvent ("button", UIEventType.Click, "OnClose")
    self:BindUIEvent ("btn_replay", UIEventType.Click, "OnReFight")
    self.m_HeroItem = self.instance:FindWidget("hero_grid/hero1") 
    self.m_HeroItem:SetActive(true)
    for i = 1 , 5 do 
        local itemObj = GameObject.InstantiateFromPreobj(self.m_HeroItem,self.m_HeroItem:GetParent())
		itemObj:SetName("hero_frame"..i)
        HeroItem[i] = itemObj
    end
    self.m_HeroItem:SetActive(false)
    CodingEasyer:Reposition(self.m_HeroItem:GetParent())
    --self:Reposition("hero_info")
    self.m_RewardItem = self.instance:FindWidget("reward_info/reward_grid/reward1")

    self.InfoWND = self.instance:FindWidget("bg_count") 
    self:BindUIEvent ("bg_count", UIEventType.Click, "OnInfoClose",false)
    self:BindUIEvent ("btn_info", UIEventType.Click, "OnInfoClose",true)


    self:BindUIEvent ("btn_norhit", UIEventType.Click, "OnTab",FightWinMixed.Damage) --造成的伤害
    self:BindUIEvent ("btn_nornai", UIEventType.Click, "OnTab",FightWinMixed.Heal) --造成的治疗
    self:BindUIEvent ("btn_norbing", UIEventType.Click, "OnTab",FightWinMixed.Kill) --杀死的士兵数

    self.tabSelfHero1 = self.instance:FindWidget("pic_ourhero1") 
    self.tabOtherHero1 = self.instance:FindWidget("pic_dihero1") 
    
    for i = 1 ,5 do
        local tempSelfHero1 = GameObject.InstantiateFromPreobj(self.tabSelfHero1,self.tabSelfHero1:GetParent())
		tempSelfHero1:SetName("CreateMyInfo"..i)
        SelfItem1[i] = tempSelfHero1

        local tempOtherHero1 = GameObject.InstantiateFromPreobj(self.tabOtherHero1,self.tabOtherHero1:GetParent())
		tempOtherHero1:SetName("CreateEnemyInfo"..i)
        OtherItem1[i] = tempOtherHero1
    end
    self.tabSelfHero1:SetActive(false)
    self.tabOtherHero1:SetActive(false) 
    CodingEasyer:Reposition(self.instance:FindWidget("pic_info1/ourgrid1"))
    CodingEasyer:Reposition(self.instance:FindWidget("pic_info1/digrid1"))

    --JLListDoc = nil
    --我方数据
    self.ourhit = self.instance:FindWidget("txt_ourhit1")
    self.ourhitValue = self.instance:FindWidget("txt_ourhit1/txt")
    --敌方数据
    self.enemyhit = self.instance:FindWidget("txt_dihit1")
    self.enemyhitValue = self.instance:FindWidget("txt_dihit1/txt")
end

function wnd_fightwinClass:GetTotalCount(TempDoc,_type)
    local Count = 0
    print("wnd_fightwinClass:GetTotalCount:",TempDoc,_type)
    for k,v in pairs(TempDoc) do 
        if _type == FightWinMixed.Heal then
            Count = Count + v.Heal
        elseif _type == FightWinMixed.Damage then
            Count = Count + v.Damage
        else
            Count = Count + v.KillArmy
        end
    end

    return Count
end

function wnd_fightwinClass:OnTab(obj,_type)
    local SelfString 
    local EnamyString 

   print("wnd_fightwinClass:OnTab:",_type)

    if _type == FightWinMixed.Heal then
        SelfString = SData_Id2String.Get(5319)
        EnamyString = SData_Id2String.Get(5320)
    elseif _type == FightWinMixed.Damage then
        SelfString = SData_Id2String.Get(5181)
        EnamyString = SData_Id2String.Get(5182)
    else
        SelfString = SData_Id2String.Get(5321)
        EnamyString = SData_Id2String.Get(5322)
    end

    CodingEasyer:SetLabel(self.ourhit,SelfString)
    CodingEasyer:SetLabel(self.enemyhit,EnamyString)

    local SelfCount = self:GetTotalCount(LeftDoc,_type)
    local EnamyCount = self:GetTotalCount(RightDoc,_type)

    CodingEasyer:SetLabel(self.ourhitValue,tostring( SelfCount ))
    CodingEasyer:SetLabel(self.enemyhitValue,tostring( EnamyCount ))

    self:FillCount(_type)
end 

function wnd_fightwinClass:OnLostInstance()
 

end 

return wnd_fightwinClass.new
 