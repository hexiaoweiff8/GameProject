
 
local wnd_readyfightClass = class(wnd_base)

wnd_readyfight = nil--单例
ReadyFightType = {
    Normal = "Normal",
    Random = "Random",   
}
local ReadyFightMixed = {
    
    SelfZDL = 0,
    EnemyZDL = 0,

    City = 0,
    Mission = 0,

    isBtnVisible = true,

    RandomID,
    Type,
}
local JLItem = {}

local MissionPopUpList = {}

function wnd_readyfightClass:Start() 
	wnd_readyfight = self
	self:Init(WND.Readyfight)
end

function wnd_readyfightClass:Debug() 
    self:SetCity(ReadyFightType.Random,1)
    self:Show()
end

function wnd_readyfightClass:UpdateStaticTxt() 
    CodingEasyer:SetLabel(self.instance:FindWidget("diban_infotitle/txt"),SData_Id2String.Get(5105))
    CodingEasyer:SetLabel(self.instance:FindWidget("diban_shensefightinfo/wofang"),SData_Id2String.Get(5109))
    CodingEasyer:SetLabel(self.instance:FindWidget("diban_diaoluodi/txt"),SData_Id2String.Get(5114))
    CodingEasyer:SetLabel(self.instance:FindWidget("diban_shensefightinfo/btn_start/txt"),SData_Id2String.Get(5120))
    CodingEasyer:SetLabel(self.instance:FindWidget("diban_shensefightinfo/btn_abandon/txt"),SData_Id2String.Get(5121))
    CodingEasyer:SetLabel(self.instance:FindWidget("enemyinfo_bg/title/txt"),SData_Id2String.Get(5122))
    CodingEasyer:SetLabel(self.instance:FindWidget("enemyinfo_bg/attributes"),SData_Id2String.Get(5077))
    CodingEasyer:SetLabel(self.instance:FindWidget("enemyinfo_bg/qixue/txt"),SData_Id2String.Get(5124))
    CodingEasyer:SetLabel(self.instance:FindWidget("enemyinfo_bg/wuli/txt"),SData_Id2String.Get(5125))
    CodingEasyer:SetLabel(self.instance:FindWidget("enemyinfo_bg/tili/txt"),SData_Id2String.Get(5126))
    CodingEasyer:SetLabel(self.instance:FindWidget("enemyinfo_bg/nuqi/txt"),SData_Id2String.Get(5127))
    CodingEasyer:SetLabel(self.instance:FindWidget("enemyinfo_bg/actskill"),SData_Id2String.Get(5123))
end

function wnd_readyfightClass:SetMissionToNext()

    local Next = sdata_MissionMonster:GetNext(ReadyFightMixed.Mission)
    self:SetMission(Next)
end
function wnd_readyfightClass:SetMissionSync()

     local temp = Player:GetObjectF("ply/gkSaveFiles/0")
     if temp == nil then 
        ReadyFightMixed.Mission = 0 
        return 
     end
     local iV = temp:GetValue("g")
     self:SetMission(iV)

end
function wnd_readyfightClass:SetMission( _Mission )

    ReadyFightMixed.Mission = tonumber( _Mission )

end

function wnd_readyfightClass:GetMixed()
    return ReadyFightMixed
end

function wnd_readyfightClass:Random()
    self:BtnVisible(ReadyFightMixed.isBtnVisible)
    local Name = sdata_SuijiMonster:GetV(sdata_SuijiMonster.I_Name,ReadyFightMixed.RandomID)
    CodingEasyer:SetLabel(self.instance:FindWidget("diban_guankanote/txt"),Name)
    self.instance:FindWidget("diban_guankanote/loop"):SetActive(false)
    self.instance:FindWidget("diban_guankanote/first"):SetActive(false)
    self.instance:FindWidget("diban_guankanote/jingying"):SetActive(false)
    self.instance:FindWidget("diban_guankanote/boss"):SetActive(false)

    self.FakeInfo = sdata_SuijiMonster:GetJLItem(ReadyFightMixed.RandomID)
    for i = 1,6  do
        CodingEasyer:SetJLIcon(JLItem[i],self.FakeInfo[i])
        i = i + 1
    end
    local zhenfa = sdata_SuijiMonster:GetV(sdata_SuijiMonster.I_ZhenfaID,ReadyFightMixed.RandomID)
    self.ZhenFaView:ResetZhenFa(tonumber(zhenfa))
    self:coUpdateHeroFace(ReadyFightType.Random )
end

function wnd_readyfightClass:Normal()
    if ReadyFightMixed.Mission == 0  then 
        ReadyFightMixed.Mission = sdata_MissionCity:GetFirst(ReadyFightMixed.City)
    end
    wnd_tuiguan:ReadyFightMission(ReadyFightMixed.Mission)
    self:CreateListTxt()
    self:UpdateUI()
    self:UpdateSaoDang()
    self:UpdateStaticTxt()
    self:BtnVisible(ReadyFightMixed.isBtnVisible)
    self:BtnVisibleBool(true)
end

function wnd_readyfightClass:OnShowDone()


   self:BindHeroFacePress()
   if ReadyFightMixed.Type == ReadyFightType.Normal then
       self:Normal()
   elseif ReadyFightMixed.Type == ReadyFightType.Random then
       self:Random()
   else
   end
   
end

function wnd_readyfightClass:ClearListTxt()
    if self.MissionsText == nil then return end

    for k,v in pairs(self.MissionsText) do 
        v:Destroy()
    end

    self.MissionsText = {}
    self.MissionsTextInfo = {}
end

function wnd_readyfightClass:CreateListTxt()
    self:ClearListTxt()
    self.MissionsTextInfo = {}
    self.MissionsTextInfo = sdata_MissionMonster:GetMissionsInCity(ReadyFightMixed.City)
    if self.MissionsTextInfo == nil then return end
    if self.MissionsText == nil then self.MissionsText = {} end
    self.MissionText:SetActive(true)
    local Mixed = wnd_tuiguan:GetMixed()
    local Next = sdata_MissionMonster:GetNext(Mixed.CurrentWinMission)
    local i = 1
    for k,v in pairs(self.MissionsTextInfo) do
        local itemObj = GameObject.InstantiateFromPreobj(self.MissionText,self.MissionText:GetParent())
        itemObj:SetName("CreateListTxt"..k)
        self:BindUIEvent (itemObj:GetName(), UIEventType.Click, "OnClickMissionText",k)--点击的省
        local MisName = sdata_MissionMonster:GetV(sdata_MissionMonster.I_Name,v)
        CodingEasyer:SetLabel(itemObj:FindChild("txt"),"第"..i.."关  "..MisName )

        local Curr = itemObj:FindChild("first")
        local Pass = itemObj:FindChild("loop")
        --v 选择列表 CurrentWinMission 最佳战绩
        Curr:SetActive( v == Next )
        Pass:SetActive( v <= Mixed.CurrentWinMission )
        table.insert(self.MissionsText,itemObj)


        i = 1 + i
    end
    self.MissionText:SetActive(false)
    CodingEasyer:Reposition(self.MissionText:GetParent())
end


function wnd_readyfightClass:OnClickMissionText(obj,key)
    print("wnd_readyfightClass:OnClickMissionText",key)

    local temp = wnd_tuiguan:GetMixed()
    
    local popString = self:GetTipString()

    local should
    if temp.CurrentAttackMission == 0 then
        Should = sdata_MissionCity:GetFirst(ReadyFightMixed.City)
    else
        Should = temp.CurrentAttackMission
    end    
    local ClickMission = tonumber( self.MissionsTextInfo[key] )
    local ShouldMission = tonumber( Should )
    print("================================wnd_readyfightClass:OnClickMissionText1",ClickMission,ShouldMission,temp.CurrentAttackMission)
    if ClickMission ~= ShouldMission then 
         Poptip.PopMsg(popString,Color.red)
         return 
    end    
    self:UpdateUI()
end

function wnd_readyfightClass:BtnVisibleBool(isv)
    ReadyFightMixed.isBtnVisible = isv   
end

function wnd_readyfightClass:BtnVisible(isv)
    local Left = self.instance:FindWidget("btn_abandon")
    local Right = self.instance:FindWidget("btn_start")

    Left:SetActive(isv)
    Right:SetActive(isv)

end


function wnd_readyfightClass:TestChangHao()
    self.ZhenFaView:ResetZhenFa(1)
end

function wnd_readyfightClass:GetReadyWNDMissionStr()
    return self.TitleMission
end

function wnd_readyfightClass:SetCity(_Type,id) 
    ReadyFightMixed.Type = _Type

    if _Type == ReadyFightType.Normal then 
        ReadyFightMixed.City = id
    else
        ReadyFightMixed.RandomID = id
    end
	
end
--窗体被实例化时被调用
--初始化实例
function wnd_readyfightClass:OnNewInstance()
    JLItem = {}
    self.m_RewardItem = self.instance:FindWidget("item_widget/item_grid/item1")
    for i = 1,6 do 
        local Temp = GameObject.InstantiateFromPreobj(self.m_RewardItem,self.m_RewardItem:GetParent())
        Temp:SetName("CreateItem"..i)
        self:BindUIEvent("CreateItem"..i , UIEventType.Press,"OnItemPress",i)
        JLItem[i] = Temp
    end
    self.m_RewardItem:SetActive(false)
    CodingEasyer:Reposition(self.m_RewardItem:GetParent())
    self:BindUIEvent("btn_start",UIEventType.Click,"OnBuZhen")
    self:BindUIEvent("ui_ready",UIEventType.Click,"OnClose")
    self:BindUIEvent("close_btn",UIEventType.Click,"OnClose")
    self:BindUIEvent("btn_abandon",UIEventType.Click,"OnGiveUpCity")
    self:BindUIEvent("diban_guankanote/list/mask",UIEventType.Click,"OnMask")    
    self:BindUIEvent("saodang_widget/saodang_btn",UIEventType.Click,"OnSaoDang")
    --
    local ZFobj = self.instance:FindWidget("zhenxing_widget/zhenxing1")
    self.ZhenFaView = ZFobj:GetComponent(CMUIZhenFaView.Name)
    
    local PUobj = self.instance:FindWidget("diban_guankanote")
    self.MissionText = self.instance:FindWidget("scrollview/grid/mission1")
    
    self.isAlreadyReposition = false
end
function wnd_readyfightClass:OnItemPress(obj,isPress,UserIndex)
    if isPress == false then return end
    print("wnd_readyfightClass:OnItemPress",obj,UserIndex)
    local TempJL = self.FakeInfo[UserIndex]
    
    local txtW = obj:FindChild("info_txt")
    
    local Note = CodingEasyer:GetJLNote(TempJL)
    CodingEasyer:SetLabel(txtW,Note)

    local NameW = obj:FindChild("info_txt/name")
    local Name = CodingEasyer:GetJLName(TempJL)
    print("wnd_readyfightClass:OnItemPress1",NameW,Name)
    CodingEasyer:SetLabel(NameW,Name)

    
end
function wnd_readyfightClass:OnHeroPress_Final(ID,LV)
    local HeroTemp = SData_Hero.GetHero(ID)
    if HeroTemp == nil then return end
    local MoRenXJ = HeroTemp:MorenXing()
    local ZhenYing = HeroTemp:HeroZhenying()
    local HeroFace = self.instance:FindWidget("enemyinfo_bg/img_bg/img")
    local cmHead = HeroFace:GetComponent(CMUISprite.Name)
    HeroTemp:SetHeroIcon(cmHead)

    local typeicon = self.instance:FindWidget("enemyinfo_bg/country")
    local typeiconUI= typeicon:GetComponent(CMUISprite.Name)
    local typeString = HeroTemp:Type()
    local FinalTypeString = "t"..tostring( typeString )
    typeiconUI:SetSpriteName(typeString)
    --print("wnd_readyfightClass:OnHeroPress=============",typeString)
    CodingEasyer:SetLabel(self.instance:FindWidget("enemyinfo_bg/name"),HeroTemp:Name())
    CodingEasyer:SetGongYongMeng(self.instance:FindWidget("enemyinfo_bg/type"),ID)
    local Skills = HeroTemp:Skills()
    local PositiveSkillID = Skills[2]
    local TempSkill = SData_Skill.GetSkill(PositiveSkillID)
    CodingEasyer:SetLabel(self.instance:FindWidget("enemyinfo_bg/skillname"),TempSkill:Name())
    CodingEasyer:SetLabel(self.instance:FindWidget("enemyinfo_bg/skillinfo"),TempSkill:SkillNoteMin())

    CodingEasyer:SetLabel(self.instance:FindWidget("enemyinfo_bg/qixue/txt"),HeroTemp:CalculationHP(LV,MoRenXJ))
    CodingEasyer:SetLabel(self.instance:FindWidget("enemyinfo_bg/wuli/txt"),HeroTemp:CalculationWuli(LV,MoRenXJ))
    CodingEasyer:SetLabel(self.instance:FindWidget("enemyinfo_bg/tili/txt"),HeroTemp:CalculationTili(LV,MoRenXJ))
    CodingEasyer:SetLabel(self.instance:FindWidget("enemyinfo_bg/nuqi/txt"),HeroTemp:CalculationNu(LV,MoRenXJ))
    --HeroTemp:CalculationZhili(LV,MoRenXJ)
    --HeroTemp:CalculationJingshen(LV,MoRenXJ)
    CodingEasyer:SetLabel(self.instance:FindWidget("enemyinfo_bg/zhili/txt"),HeroTemp:CalculationZhili(LV,MoRenXJ))
    CodingEasyer:SetLabel(self.instance:FindWidget("enemyinfo_bg/jingshen/txt"),HeroTemp:CalculationJingshen(LV,MoRenXJ))
end

function wnd_readyfightClass:OnHeroPress_Random(UserIndex)
    local IntIndex = tonumber( UserIndex )
    local ID = sdata_SuijiMonster:GetHero(IntIndex,ReadyFightMixed.RandomID)
    local LV = Player:GetAttr(PlayerAttrNames.Level)
    self:OnHeroPress_Final(ID,LV)
end
function wnd_readyfightClass:OnHeroPress_Normal(UserIndex)
    local IntIndex = tonumber( UserIndex )
    local ID = sdata_MissionMonster:GetHero(IntIndex,ReadyFightMixed.Mission)
    local LV = sdata_MissionMonster:GetV(sdata_MissionMonster.I_MonsterLv,ReadyFightMixed.Mission)
    self:OnHeroPress_Final(ID,LV)
end

function wnd_readyfightClass:OnHeroPress(obj,isPress,UserIndex)
    if isPress == false then return end


    if ReadyFightMixed.Type == ReadyFightType.Normal then
        self:OnHeroPress_Normal(UserIndex)
    elseif ReadyFightMixed.Type == ReadyFightType.Random then
        self:OnHeroPress_Random(UserIndex)
    else
        
    end
end 

function wnd_readyfightClass:BindHeroFacePress()
    for i = 1, 5 do 
        self:BindUIEvent("zhenxing1/pic_zw"..i , UIEventType.Press,"OnHeroPress",i)
    end
end 

function wnd_readyfightClass:OnMask()
end 

function wnd_readyfightClass:OnGiveUpCity()
    print("wnd_readyfightClass:OnGiveUpCity")
    
    local Mixed = wnd_tuiguan:GetMixed()
    if Mixed.CurrentAttackMission == 0 then return end
    local name = sdata_MissionMonster:GetV(sdata_MissionMonster.I_Name,Mixed.CurrentAttackMission)
    local temp = string.sformat(SData_Id2String.Get(5318),name)
    MsgBox.SetTitle(SData_Id2String.Get(5350))
    MsgBox.Show(temp,"否","是",self,self.MessageBoxCallBack)
end 

function wnd_readyfightClass:MessageBoxCallBack(id)
  print("MessageBoxCallBack",id) --id：2 True  --id：1 False
    if id == 2 then
        self:ClearListTxt()
        self:Hide()
        
        wnd_tuiguan:SendGiveUpNetWork(TuiGuanGiveUpType.TuiGuan)
    end     
end

function wnd_readyfightClass:GetTipString()
    for i = 1,#self.MissionIndex do
        local id = self.MissionIndex[i]
        if id == ReadyFightMixed.Mission then
            local txt = "当前可攻打 第"..i.."关"
            return txt
        end
    end
    return self.MissionIndex[#self.MissionIndex]
end

function wnd_readyfightClass:SetLabelZDL(zdl)
    CodingEasyer:SetLabel(self.instance:FindWidget("wofang/txt"),zdl)
end

function wnd_readyfightClass:SetZDL(zdl)
    ReadyFightMixed.SelfZDL = tonumber( zdl )
    self.isUseBuZhenZDL = true
end
function wnd_readyfightClass:GetZDL()
    if self.isUseBuZhenZDL == true then 

        self.isUseBuZhenZDL = false
        return
    end
    local ZDLList = Player:GetAttr(PlayerAttrNames.ZDL)
    local ZDLPairs = string.split(ZDLList,',')--1:xxx,2:xxx
    local ZDLNode = string.split(ZDLPairs[1],':')--1:xxx 
    local ZDLTemp = ZDLNode[2]--xxx
    if ZDLTemp == nil then ZDLTemp = 0 end
    ReadyFightMixed.SelfZDL = tonumber( math.ceil( ZDLTemp/100) )
    if ReadyFightMixed.SelfZDL == nil then 
        ReadyFightMixed.SelfZDL = 0
    end
end

function wnd_readyfightClass:UpdateUI()
    local name = sdata_MissionMonster:GetV(sdata_MissionMonster.I_Name,ReadyFightMixed.Mission)
    local note = sdata_MissionMonster:GetV(sdata_MissionMonster.I_Note,ReadyFightMixed.Mission)
    local zhenfa =  tonumber(sdata_MissionMonster:GetV(sdata_MissionMonster.I_ZhenfaID,ReadyFightMixed.Mission))
    local buzheninfo = SData_Zhenfa.Get( tonumber(zhenfa) )
    local Name = sdata_MissionMonster:GetV(sdata_MissionMonster.I_Name,ReadyFightMixed.Mission)    
    self:GetZDL()
    CodingEasyer:SetLabel(self.instance:FindWidget("wofang/txt"),ReadyFightMixed.SelfZDL)
    CodingEasyer:SetLabel(self.instance:FindWidget("zhenxing1/txt"),buzheninfo:ZhenName())
    self.FakeInfo = {}
    local EXPNum = tonumber( sdata_MissionMonster:GetV(sdata_MissionMonster.I_ExpDiaoluo,ReadyFightMixed.Mission) )
    local CopperNum = tonumber( sdata_MissionMonster:GetV(sdata_MissionMonster.I_MoneyDiaoluo,ReadyFightMixed.Mission) )
  
    local EXP = CodingEasyer:GetJLByNumber(1,15,EXPNum)
    EXP.DiaoLuo = 11
    local Copper =  CodingEasyer:GetJLByNumber(1,4,CopperNum)
    Copper.DiaoLuo = 11
    self.FakeInfo[1] = EXP
    self.FakeInfo[2] = Copper
    for i = 1 ,3 do
        local v = sdata_MissionMonster:GetItem(i,ReadyFightMixed.Mission)
        self.FakeInfo[i+2] = v
    end
    
    local Mixed = wnd_tuiguan:GetMixed()
    for i = 1,6  do
        CodingEasyer:SetJLIcon(JLItem[i],self.FakeInfo[i])
        local tempObj = JLItem[i]
        local tempInfo = self.FakeInfo[i]
        if tempInfo ~= nil then 
            
            local DiaoLuo = sdata_DiaoluoType:GetV(sdata_DiaoluoType.I_DiaoluoType1,tempInfo.DiaoLuo)
            local isPass = Mixed.CurrentWinMission >= ReadyFightMixed.Mission

            tempObj:SetActive( 
                (isPass and DiaoLuo == 3) or
                (not isPass and DiaoLuo == 2)  or
                DiaoLuo == 1
                )
        end
       
        
        i = i + 1
    end

    CodingEasyer:Reposition(self.m_RewardItem:GetParent())

    self.ZhenFaView:ResetZhenFa(tonumber(zhenfa))
    self:coUpdateHeroFace(ReadyFightType.Normal )
    self.Missions,self.MissionIndex = sdata_MissionCity:GetMissions(ReadyFightMixed.City)   

    local k = sdata_MissionMonster:GetMissionOrder(ReadyFightMixed.City,ReadyFightMixed.Mission)
    self.TitleMission = string.sformat(SData_Id2String.Get(5106),k)
    CodingEasyer:SetLabel(self.instance:FindWidget("diban_guankanote/txt"),string.sformat(SData_Id2String.Get(5106),k) )
    CodingEasyer:SetLabel(self.instance:FindWidget("mission1/txt"),string.sformat(SData_Id2String.Get(5106),k) )

    self:UpdateRefightFlag()

end
function wnd_readyfightClass:UpdateRefightFlag()

    local Mixed = wnd_tuiguan:GetMixed()
    local Frist = self.instance:FindWidget("diban_diaoluodi/first")
    local Pass = self.instance:FindWidget("diban_diaoluodi/loop")

    local isPass = Mixed.CurrentWinMission >= ReadyFightMixed.Mission
    Frist:SetActive(not isPass)
    Pass:SetActive(isPass)

    local Frist2 = self.instance:FindWidget("diban_guankanote/first")
    local Pass2 = self.instance:FindWidget("diban_guankanote/loop")

    Frist2:SetActive(not isPass)
    Pass2:SetActive(isPass)

    local Diff = sdata_MissionMonster:GetV(sdata_MissionMonster.I_Difficulty,ReadyFightMixed.Mission)

    local JY = self.instance:FindWidget("diban_guankanote/jingying")
    local Boss = self.instance:FindWidget("diban_guankanote/boss")
    JY:SetActive(Diff == 1)
    Boss:SetActive(Diff == 2)
end 

function wnd_readyfightClass:UpdateHeroFace(_)
     --StartCoroutine(self,self.coUpdateHeroFace,{})
end 

function wnd_readyfightClass:HeroStructVisible(index,isVisible)
    --print("wnd_readyfightClass:HeroStructVisible",index,isVisible)
    local img = self.instance:FindWidget("zhenxing_widget/zhenxing1/pic_zw"..index.."/img")
    local Htype = self.instance:FindWidget("zhenxing_widget/zhenxing1/pic_zw"..index.."/type")
    local star = self.instance:FindWidget("zhenxing_widget/zhenxing1/pic_zw"..index.."/star")
    local hp_bg = self.instance:FindWidget("zhenxing_widget/zhenxing1/pic_zw"..index.."/hp_bg")
    local mask = self.instance:FindWidget("zhenxing_widget/zhenxing1/pic_zw"..index.."/mask")

    mask:SetActive(isVisible == false)
    img:SetActive(isVisible)
    Htype:SetActive(isVisible)
    star:SetActive(isVisible)
    hp_bg:SetActive(isVisible)
end

function wnd_readyfightClass:coUpdateHeroFace(_Type)
    local mixed = wnd_tuiguan:GetMixed()
    for i = 1 ,5 do 
        local Hero = 0
        if _Type == ReadyFightType.Normal then
            Hero = tonumber( sdata_MissionMonster:GetHero(i,ReadyFightMixed.Mission) )
        elseif _Type == ReadyFightType.Random then
            Hero = tonumber( sdata_SuijiMonster:GetHero(i,ReadyFightMixed.RandomID) )
        else
        end
        --print("wnd_readyfightClass:coUpdateHeroFace ==== ",Hero)
        if Hero == 0 or Hero == nil then 
            self:HeroStructVisible(i,false)
        else
            self:HeroStructVisible(i,true)

            local widget = self.instance:FindWidget("zhenxing_widget/zhenxing1/pic_zw"..i.."/img")
            local cmHead = widget:GetComponent(CMUISprite.Name)
            local HP = self.instance:FindWidget("zhenxing_widget/zhenxing1/pic_zw"..i.."/hp_bg")
            local HpCm = HP:GetComponent(CMUIProgressBar.Name)

            local HPValue = tonumber( wnd_tuiguan:GetEnemyHP(Hero) )
            local TempHero = SData_Hero.GetHero(Hero)
            TempHero:SetHeroIcon(cmHead)
            
            local typeicon = self.instance:FindWidget("zhenxing_widget/zhenxing1/pic_zw"..i.."/type")
	        local typeiconUI= typeicon:GetComponent(CMUISprite.Name)
            local typeString = TempHero:TypeIcon()
            local FinalTypeString = "t"..typeString
            typeiconUI:SetSpriteName(FinalTypeString)

            local HeroLv = 1
            if _Type == ReadyFightType.Normal then
                HeroLv = tonumber( sdata_MissionMonster:GetV(sdata_MissionMonster.I_MonsterLv,ReadyFightMixed.Mission) )
            elseif _Type == ReadyFightType.Random then
                HeroLv = tonumber( Player:GetAttr(PlayerAttrNames.Level) )
            else
            end
         
            
            local MaxHp = tonumber( TempHero:CalculationHP(HeroLv,1) )
            HpCm:SetValue(HPValue/MaxHp)
            if  HPValue == -1 then
                HPValue = 1
                MaxHp = 1
                HpCm:SetValue(1)
            end
            local Dead = self.instance:FindWidget("zhenxing_widget/zhenxing1/pic_zw"..i.."/dead")
            Dead:SetActive(HPValue==0)
            
        end
    end
end

function wnd_readyfightClass:UpdateSaoDang()
    
    local city,province = sdata_MissionMonster:GetOrganization(ReadyFightMixed.Mission)
    local Final = sdata_MissionCity:GetFinal(city)


    local Count = sdata_MissionMonster:HowManyAfterMissionInCity(tonumber( ReadyFightMixed.Mission ))
    local Cost = tonumber( sdata_keyvalue:GetV(sdata_keyvalue.I_LingXiaohao,1) )
    self.SaoDangNeedJunLing = ( Count + 1 )* Cost
    local JL = tonumber( Player:GetAttr(PlayerAttrNames.JunLing) )
    CodingEasyer:SetLabel(self.instance:FindWidget("point_txt"),self.SaoDangNeedJunLing)
    local JLColor = ifv(self.SaoDangNeedJunLing > JL,Color.red,Color.white)

    CodingEasyer:SetLabelColor(self.instance:FindWidget("point_txt"),JLColor)
    local GFL = tonumber( Player:GetObjectF("ply/CommItems/22"))
    CodingEasyer:SetLabel(self.instance:FindWidget("ticket_txt"),1)
    if GFL == nil then 
        CodingEasyer:SetLabelColor(self.instance:FindWidget("ticket_txt"),Color.red) 
    else
        if GFL < 1 then 
            CodingEasyer:SetLabelColor(self.instance:FindWidget("ticket_txt"),Color.red) 
        else
            CodingEasyer:SetLabelColor(self.instance:FindWidget("ticket_txt"),Color.white) 
        end
    end
    
        
    local Visible = wnd_tuiguan:IsPerfectPass(city)
    local SaoDang = self.instance:FindWidget("saodang_widget")
    SaoDang:SetActive(Visible)
end 

function wnd_readyfightClass:OnSaoDang()
    local GFL = tonumber( Player:GetObjectF("ply/CommItems/22"))
    if GFL == nil then GFL = 0 end

    local JL = Player:GetAttr(PlayerAttrNames.JunLing)
    if tonumber( self.SaoDangNeedJunLing ) > tonumber( JL ) then
        wnd_tuiguan:JunLingBtn()
    elseif GFL < 1 then 
        Poptip.PopMsg(SData_Id2String.Get(5315),Color.red)
    else 
        self:SendSaoDangNetWork(ReadyFightMixed.Mission)   
    end
end 
function wnd_readyfightClass:SendSaoDangNetWork(_Mission)
    local jsonNM = QKJsonDoc.NewMap()
    jsonNM:Add("n","GKSD")
    local city,province = sdata_MissionMonster:GetOrganization(_Mission)
    jsonNM:Add("c",city)
    jsonNM:Add("g",_Mission)
    local loader = GameConn:CreateLoader(jsonNM,0) 
	HttpLoaderEX.WaitRecall(loader,self,self.NM_SaoDang)
end

function wnd_readyfightClass:NM_SaoDang( _JsonDoc )
    local Result = tonumber(_JsonDoc:GetValue("r"))
    if Result ~= 0 then
        print("wnd_readyfightClass:NM_SaoDang:",Result)
        --21扫荡卷 22体力不足
        --11关不对
        return
    end

    local SaoDangJL ={}
    local JL = _JsonDoc:GetValue("jl")
    if JL ~= nil then
        local rankFunc = function(_,JLNode)
            local JL,isJLExist = CodingEasyer:GetJL(JLNode)
            if isJLExist == true then
                table.insert(SaoDangJL,JL)
            end
        end
        JL:Foreach(rankFunc)
    end

    self:UpdateSaoDang()

    wnd_itemget:Fdata(SaoDangJL,"wnd_Mail")
    wnd_itemget:Show()

    self:Hide()
    wnd_tuiguan:SyncMission()
    wnd_tuiguan:UpdateCurrentAttackFlag()
    wnd_tuiguan:UpdateNextCityFlag()
end


function wnd_readyfightClass:OnBuZhen()
    if wnd_tuiguan:isHaveAHero() == false then return Poptip.PopMsg("没有手牌",Color.red) end
    self:ClearListTxt()
    wnd_tuiguan:SendEnterGKNetWork()

end 

function wnd_readyfightClass:AutoMission()
    local Mixed = wnd_tuiguan:GetMixed()

    if Mixed.CurrentAttackMission == 0 then
        self:SetMission(0)
    end

end 

function wnd_readyfightClass:OnClose()
    wnd_tuiguan:ShowOrHidePaikuTips() --推关界面，牌库上的红点提示
    self:AutoMission()
    self:ClearListTxt()
    self:Hide()
end 
function wnd_readyfightClass:OnLostInstance()
    self.isAlreadyReposition = false
end 
 
return wnd_readyfightClass.new
 