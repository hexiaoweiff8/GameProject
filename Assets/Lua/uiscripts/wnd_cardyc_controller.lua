local class = require("common/middleclass")
wnd_cardyc_controller = class("wnd_cardyc", wnd_base)
local view = require("uiscripts/wnd_cardyc_view")
local data = require("uiscripts/wnd_cardyc_model")

--显示界面
TABLE_INDEX={
    INFORMATION =1,
    SKILL =2,
    SOLDIER =3,
    SYNERGY =4
}
local CurrentTabIndex = TABLE_INDEX.INFORMATION
local CardIndex = 1
local TestID = 1002 
local TestAtlas
function wnd_cardyc_controller:OnShowDone()
    --初始化view
    view:init_view(self)
    view:getView()
    TestAtlas = GameObjectExtension.InstantiateFromPacket("heroU", "hero1AtlasT", self.gameObject).transform:GetComponent("UIAtlas")
    --获取数据
    CardIndex = 1
    self:showCard(CardIndex)
end

function wnd_cardyc_controller:showCard()

    if not data:getDatas(CardIndex) then 
        return 
    end 
    self:init_leftCard_Data()
    self:init_rightBody()
    self:init_redDot()
    self:init_tabPanel()
end

function wnd_cardyc_controller:init_leftCard_Data()
    view.cardNameLab.transform:GetComponent("UILabel").text = data:getCardName_With_Quality(data.cardInfo.cardId, data.cardInfo.qualityLv)
    view.cardNameLab.transform:GetComponent("UILabel").color = data:getColor_With_Quality(data.cardInfo.qualityLv)
    view.cardLevelLab.transform:GetComponent("UILabel").text = string.format("Lv.%d",data.cardInfo.cardLv)
    view.cardNum_Lab.transform:GetComponent("UILabel").text = string.format("已有 %d 张",data.cardInfo.cardFragment)
    view.trainCostLab.transform:GetComponent("UILabel").text = data:getCardInfo("TrainCost",data.cardInfo.cardId)
    --显示星级
    for i=1,data.Const.MAX_STAR_LV do
       local starDark = view.cardStarsPanel.transform:Find("darkstar_"..i).gameObject
       local star = view.cardStarsPanel.transform:Find("star_"..i).gameObject
       starDark:SetActive(true)
       star:SetActive(true)
       if i>data.cardInfo.starLv then
           star:SetActive(false)
       end
    end
    UIEventListener.Get(view.btn_upLevel).onPress = function(btn_upLevel, args)
        if args then
            print("升级 ")
            self:show_UpLevel_Layer()
        end
    end
    UIEventListener.Get(view.btn_upStar).onPress = function(btn_upStar, args)
        if args then
        print("升星 ")
            self:show_UpStar_Layer()
        end
    end
    UIEventListener.Get(view.btn_left).onPress = function(btn_left, args)
        if args then
            print("左左左 ")
            if CardIndex > 1 then
                CardIndex = CardIndex - 1
                self:showCard()
            end
        end
    end
    UIEventListener.Get(view.btn_right).onPress = function(btn_right, args)
        if args then
            print("右右右 ")
            if CardIndex < data:getCardNum() then
                CardIndex = CardIndex + 1
                self:showCard()
            end
        end
    end
end
--初始化右侧
function wnd_cardyc_controller:init_rightBody()
    self:information_Body()
    self:skill_Body()
    self:soldier_Body()
    self:synergy_Body()
end
--根据当前显示的界面刷新右侧
function wnd_cardyc_controller:refresh_RightBody()
    print("refresh rightbody!!!!!!")
    print(CurrentTabIndex)
    if CurrentTabIndex == TABLE_INDEX.INFORMATION then
        self:information_Body()
    elseif CurrentTabIndex == TABLE_INDEX.SKILL then
        self:skill_Body()
    elseif CurrentTabIndex == TABLE_INDEX.SOLDIER then
        self:soldier_Body()
    elseif CurrentTabIndex == TABLE_INDEX.SYNERGY then
        self:synergy_Body()
    end
end


function wnd_cardyc_controller:init_redDot()
    --判断是否可以升级，并显示小红点
    view.btn_upLevel_redDot:SetActive(false)
    if data:isCan_UpLevel() then
        view.btn_upLevel_redDot:SetActive(true)
    end

    --判断是否可以升星，并显示小红点
    view.btn_upStar_redDot:SetActive(false)
    if data:isCan_UpStar() then
        view.btn_upStar_redDot:SetActive(true)
    end

    view.btn_soldier_redDot:SetActive(false)
    if data:isCan_UpSoldier() then
        view.btn_soldier_redDot:SetActive(true)
    end

    view.btn_skill_redDot:SetActive(false)
    for i = 1, 5 do
        local name = string.format("skillFrame_%d",i)
        view[name].skillItem_redDot:SetActive(false)
        if data:isCan_UpSkill(i) then
            view[name].skillItem_redDot:SetActive(true)
            view.btn_skill_redDot:SetActive(true)
        end
    end 


    view.btn_information_redDot:SetActive(false)
    if data:isCan_UpQuality() then
        view.btn_information_redDot:SetActive(true)
    end


    view.btn_synergy_redDot:SetActive(false)
    for i = 1, #data.cardInfo.synergyLvTbl do 
        local name = string.format("synergyItem_%d",i)
        view[name].synergyItem_redDot:SetActive(false)
        if data.synergyStateTbl[i] == data.SynergyState.unactive then
            view[name].synergyItem_redDot:SetActive(false)
        elseif data.synergyStateTbl[i] == data.SynergyState.activated then
            if data:isCan_UpSynergy(i) then
                view[name].synergyItem_redDot:SetActive(true)
                view.btn_synergy_redDot:SetActive(true)
            end
        elseif data.synergyStateTbl[i] == data.SynergyState.canActive then
            view[name].synergyItem_redDot:SetActive(true)
            view.btn_synergy_redDot:SetActive(true)
        end
    end
    
end


--tab切换部分
function wnd_cardyc_controller:init_tabPanel()
    self.tabBtn = {view.btn_information,view.btn_skill,view.btn_soldier,view.btn_synergy}
    self.tabPanel = {view.informationBody_Panel,view.skillPanel,view.soldierPanel,view.synergyPanel}
    self.tabPanel[CurrentTabIndex]:SetActive(true)
    self.tabBtn[CurrentTabIndex].transform:Find("lightSp").gameObject:SetActive(true)
    for i=1,#self.tabBtn do
        self.tabBtn[i].transform:Find("lab"):GetComponent("UILabel").text = data:getString(20019+i)
        UIEventListener.Get(self.tabBtn[i]).onPress = function(sender)
            if CurrentTabIndex == i then
                return
            else
                self:showTabPanel(i)
            end
        end
    end
end

function wnd_cardyc_controller:showTabPanel(tableIndex)
    if CurrentTabIndex == tableIndex then 
        return
    end
    self.tabPanel[tableIndex]:SetActive(true)
    self.tabBtn[tableIndex].transform:Find("lightSp").gameObject:SetActive(true)
    self.tabPanel[CurrentTabIndex]:SetActive(false)
    self.tabBtn[CurrentTabIndex].transform:Find("lightSp").gameObject:SetActive(false)
    CurrentTabIndex = tableIndex
    self:refresh_RightBody()
end

-----------------------------------升星部分---------------------------------
local isInitUpStarLayer = false
local isInitUpStarSLayer = false
--显示升星界面
function wnd_cardyc_controller:show_UpStar_Layer()
     if not isInitUpStarLayer then
        view:init_UpStarPanel()
        view.upStarPanel.name = "upStarPanel"
        view.upStarPanel:SetActive(false)
        self:create_CardHead(view.upStarPanel,"upStarP_Before_cardhead",Vector3(-262,0,0))
        self:create_CardHead(view.upStarPanel,"upStarP_After_cardhead",Vector3(-7,0,0))
        isInitUpStarLayer = true
     end
     --初始化卡牌头像，
    self:refresh_CardHead(view.upStarP_Before_cardhead,data.cardInfo.cardId,data.cardInfo.starLv)
    self:refresh_CardHead(view.upStarP_After_cardhead,data.cardInfo.cardId,data:GetNextStarLv())

    view.upStarP_skillPanel:SetActive(false)
    if data:GetNextStarLv() <= 5 then
        view.upStarP_skillPanel:SetActive(true)
        view.upStarP_skillP_NameLab:GetComponent("UILabel").text = data:getSkillInfo("Name",data.cardInfo.cardId,data.cardInfo.cardLv,data:GetNextStarLv()) --解锁技能名
        UIEventListener.Get(view.upStarP_skillP_NameLab).onPress = function(upStarP_skillP_NameLab, args)
            if args then
                -- self:show_SkillItem_UpPanel(self.nextStarlv)
                print("弹出技能介绍框....."..skillid ) --弹出技能介绍框
            end
        end
    end

    --兵牌    
    view.upStarP_badgeLab.transform:GetComponent("UILabel").text = data:getString(20027)
    local needCoin = data:getUpStarNeedCoin()
    view.upStarP_badgeNeedNumL.transform:GetComponent("UILabel").text = string.format("X%d",needCoin)
    local lab1 = string.format("([97ff03]%s%d[-])",data:getString(20028), data.userInfo.badgeNum)
    if data.userInfo.badgeNum < needCoin then
        lab1 = string.format("(%s[ff2121]%d[-])",data:getString(20028), data.userInfo.badgeNum) 
    end
    view.upStarP_badgeHaveNumL.transform:GetComponent("UILabel").text = lab1


    --卡牌数量
    view.upStarP_cardNameLab.transform:GetComponent("UILabel").text = data:getCardInfo("Name",data.cardInfo.cardId)
    local needFragment = data:getUpStarNeedFragment()
    view.upStarP_cardNeedNumL.transform:GetComponent("UILabel").text = string.format("X%d", needFragment)
    local lab2 = string.format("([97ff03]%s%d[-])",data:getString(20028),data.cardInfo.cardFragment)
    if data.cardInfo.cardFragment < needFragment then
        lab2 = string.format("(%s[ff2121]%d[-])",data:getString(20028),data.cardInfo.cardFragment)
    end
    view.upStarP_cardhavaNumL.transform:GetComponent("UILabel").text = lab2

    --为按钮添加监听
    UIEventListener.Get(view.upStarP_btn_back).onPress = function(upStarP_btn_back, args)
        if args then
            view.upStarPanel:SetActive(false)
        end
    end    
    UIEventListener.Get(view.upStarP_btn_sx).onPress = function(upStarP_btn_sx, args)
        if args then
            self:upStarPanel_btnUpStar_CallBack()
        end
    end


    view.upStarPanel:SetActive(true)
end

--点击升星界面的升星按钮
function wnd_cardyc_controller:upStarPanel_btnUpStar_CallBack()
    
    if not data:isCan_UpStar() then 
        return 
    end
    --发送请求升星
    --提升星级扣道具，升星成功
    SendPB_10010(data.cardInfo.cardId)
    
end

function wnd_cardyc_controller:upStar_refresh()
    -- body
    if not data:getDatas(CardIndex) then 
        return 
    end 
    print(string.format("controller star refresh+++starLv=====%d",data.cardInfo.starLv))
    view.upStarPanel:SetActive(false)
    self:show_UpStar_Success()
    self:init_leftCard_Data()
    self:refresh_RightBody()
    self:init_redDot()
end

--显示升星成功后的界面，属性提升。。
function wnd_cardyc_controller:show_UpStar_Success()
    if not isInitUpStarSLayer then
        view:init_UpStar_SuccessPanel()
        view.upStarSuccessPanel.transform.name = "upStarSuccess"
        self:create_CardHead(view.upStarSuccessPanel,"upStarSP_Before_cardhead",Vector3(-190,55,0))
        self:create_CardHead(view.upStarSuccessPanel,"upStarSP_After_cardhead",Vector3(190,55,0))
        view.upStarSuccessPanel:SetActive(false)
        isInitUpStarSLayer = true
    end
    --初始化升星成功后的卡牌头像
    self:refresh_CardHead(view.upStarSP_Before_cardhead,data.cardInfo.cardId,data.cardInfo.starLv-1)
    self:refresh_CardHead(view.upStarSP_After_cardhead,data.cardInfo.cardId,data.cardInfo.starLv)

    view.upStarSP_live_nameL.transform:GetComponent("UILabel").text = data:getString(20037)
    view.upStarSP_live_valueBL.transform:GetComponent("UILabel").text = data:getCardStarInfo("CardStarHP",data.cardInfo.cardId,data.cardInfo.starLv-1)
    view.upStarSP_live_valueAL.transform:GetComponent("UILabel").text = data:getCardStarInfo("CardStarHP",data.cardInfo.cardId,data.cardInfo.starLv)

    view.upStarSP_attack_nameL.transform:GetComponent("UILabel").text=data:getString(20038)
    view.upStarSP_attack_valueBL.transform:GetComponent("UILabel").text=data:getCardStarInfo("CardStarAttack",data.cardInfo.cardId,data.cardInfo.starLv-1)
    view.upStarSP_attack_valueAL.transform:GetComponent("UILabel").text=data:getCardStarInfo("CardStarAttack",data.cardInfo.cardId,data.cardInfo.starLv)

    view.upStarSP_defense_nameL.transform:GetComponent("UILabel").text=data:getString(20039)
    view.upStarSP_defense_valueBL.transform:GetComponent("UILabel").text=data:getCardStarInfo("CardStarDefense",data.cardInfo.cardId,data.cardInfo.starLv-1)
    view.upStarSP_defense_valueAL.transform:GetComponent("UILabel").text=data:getCardStarInfo("CardStarDefense",data.cardInfo.cardId,data.cardInfo.starLv)
    
    UIEventListener.Get(view.upStarSP_clickP).onPress = function(upStarSP_clickP, args)
        if args then
            view.upStarSuccessPanel:SetActive(false) 
        end
    end
    view.upStarSuccessPanel:SetActive(true) 
end

---------------------------------------升级部分---------------------
local isInitUpLvLayer = false
--点击主界面升级按钮
function wnd_cardyc_controller:show_UpLevel_Layer()
    if not isInitUpLvLayer then--初始化升级界面
        --初始化升级界面的控件
        view:init_Uplevel_Panel()
        view.upLevelPanel.name = "upLevelPanel"
        self:create_CardHead(view.upLevelPanel,"upLevelP_cardhead",Vector3(-186,48,0),20)
        view.upLevelPanel:SetActive(false)
        isInitUpLvLayer = true
    end
    --为按钮添加监听
    UIEventListener.Get(view.btn_upLevelOne).onPress = function(btn_upLevelOne, args)
        if args then
            self:upLevelOne_CallBack()
        end
    end
    UIEventListener.Get(view.btn_upLevelTen).onPress = function(btn_upLevelTen, args)
        if args then
            self:upLevelTen_CallBack()
        end
    end
    UIEventListener.Get(view.btn_upLevelBack).onPress = function(btn_upLevelBack, args)
        if args then
            view.upLevelPanel:SetActive(false)
        end
    end  
    self:refresh_UpLevel_Layar()                        --刷新界面 
    view.upLevelPanel:SetActive(true)        --显示界面
end

--刷新升级界面，更新数据
function wnd_cardyc_controller:refresh_UpLevel_Layar()
    --刷新升级界面的卡牌头像，显示默认星级
    self:refresh_CardHead(view.upLevelP_cardhead,data.cardInfo.cardId)
    local needExp = data:getCardNeedExp() --升级下一级所需经验
    view.expProLab.transform:GetComponent("UILabel").text = string.format("%d/%d",data.cardInfo.cardExp,needExp)
    view.uiSlide.transform:GetComponent("UISlider").value = data.cardInfo.cardExp/needExp
    view.cardLevLab.transform:GetComponent("UILabel").text = string.format("%s:%d",data:getString(20036),data.userInfo.expPool)
end

--点击升一级按钮
function wnd_cardyc_controller:upLevelOne_CallBack()
    if not data:isCan_UpLevel() then
        return
    end
    SendPB_10009(data.cardInfo.cardId, 1)
    
end

--点击升十级按钮
function wnd_cardyc_controller:upLevelTen_CallBack()
    if not data:isCan_UpLevel() then
        return
    end
    SendPB_10009(data.cardInfo.cardId, 10)
end

--点击升级后刷新界面，在wndtz_login.lua中服务器返回数据后调用
function wnd_cardyc_controller:upLevel_refresh(  )
    -- body

    if not data:getDatas(CardIndex) then 
        return 
    end 
    self:refresh_UpLevel_Layar()
    self:init_leftCard_Data()
    self:refresh_RightBody()
    self:init_redDot()
end

-------------------------------------------卡牌信息以及卡牌进阶部分-----
local isInitMedalItemLayer = false
local isInitGainLayer  = false
local isSlotInit = false
local isInitAmSLayer = false
--初始化卡片信息和进阶部分界面
function wnd_cardyc_controller:information_Body()
    
    self:init_InformationPanel()
    self:init_upQualityPanel()
end
--初始化卡牌信息部分
function wnd_cardyc_controller:init_InformationPanel()
    -- view.infoP_liveL.transform:Find("UILabel").text = 88
end
--初始化卡牌进阶部分
function wnd_cardyc_controller:init_upQualityPanel()
    print("init_quality")
    -- 判断卡牌的阶品否已达最大
    if data.cardInfo.qualityLv == data.Const.MAX_QUALITY_LV then
        print("已达最大阶品！！！！")
        view.upQuality_Panel:SetActive(false)
        view.maxUpQuality_Panel:SetActive(true)
    else 
        view.upQuality_Panel:SetActive(true)
        view.maxUpQuality_Panel:SetActive(false)
        --根据插槽状态的数量初始化插槽
        for i=1,#data.cardInfo.slotState do
            local name = string.format("itemHead_%d",i)
            local v3 = Vector3(-150+(i-1)*100, 40 ,0)
            if not isSlotInit then
                self:create_itemHead(view.upQuality_Panel,name,v3)           
            end
            self:refresh_itemHead(view[name],i)
            UIEventListener.Get(view[name].itemhead_itemSp).onPress = function(itemhead_itemSp, args)
                if args then
                    self:showItemInfoPanel(i)
                end
            end
        end
        isSlotInit = true


        --判断插槽是否全部激活
        local isEquipAll = false
        for i,v in ipairs(data.cardInfo.slotState) do
            if v == data.EquipState.Active then
                isEquipAll = true
            else
                isEquipAll = false
                break
            end
        end
        --如果全部激活显示进阶按钮和进阶所需的金币，否则显示一键装备按钮
        if isEquipAll then
            view.upQualityP_btnEpuipAll:SetActive(false)
            view.upQualityP_btnUpQ:SetActive(true)
            view.upQualityP_Cost:SetActive(true)
            view.upQualityP_Cost_Lab.transform:GetComponent("UILabel").text = data:getUpQualityNeedGold(data:GetNextQualityLv()) --晋升所需金币
        else
            view.upQualityP_btnUpQ:SetActive(false)
            view.upQualityP_Cost:SetActive(false)
            view.upQualityP_btnEpuipAll:SetActive(true)
        end

        --监听进阶按钮
        UIEventListener.Get(view.upQualityP_btnUpQ).onPress = function(upQualityP_btnUpQ, args)
            if args then
                self:upQualityBtn_onclick()
            end
        end

        --监听一键装备按钮
        UIEventListener.Get(view.upQualityP_btnEpuipAll).onPress = function(upQualityP_btnEpuipAll, args)
            if args then
                self:equipAllCallBack()
            end
        end
    end
end
--显示晋升成功界面
function wnd_cardyc_controller:show_upQuality_SuccessPanel()
    --如果是第一次显示，对该界面进行初始化
    if not isInitAmSLayer then
        view:init_UpQuality_SuccessPanel()
        view.upQuality_SuccessP.name = "upQualitySuccess"
        view.upQuality_SuccessP:SetActive(false)
        self:create_CardHead(view.upQuality_SuccessP,"upQualitySP_Before_cardhead",Vector3(-190,55,0),20)
        self:create_CardHead(view.upQuality_SuccessP,"upQualitySP_After_cardhead",Vector3(190,55,0),20)
        UIEventListener.Get(view.upQualitySP_clickPanel).onPress = function(upQualitySP_clickPanel, args)
            if args then
                view.upQuality_SuccessP:SetActive(false) 
            end
        end
        isInitAmSLayer = true
    end
    --刷新卡牌的头像，显示默认星级，
    self:refresh_CardHead(view.upQualitySP_Before_cardhead,data.cardInfo.cardId)
    self:refresh_CardHead(view.upQualitySP_After_cardhead,data.cardInfo.cardId)

    --显示卡牌进阶所提升的属性信息
    for i=1,#data.qualityPropName do
        view["upQualitySP_propName_"..i].transform:GetComponent("UILabel").text = data:getString(20036+i)
        view["upQualitySP_propBeValue_"..i].transform:GetComponent("UILabel").text = string.format("%.2f",data:getCardQualityInfo(data.qualityPropName[i],data.cardInfo.cardId,data.cardInfo.qualityLv-1))
        view["upQualitySP_propAfValue_"..i].transform:GetComponent("UILabel").text = string.format("%.2f",data:getCardQualityInfo(data.qualityPropName[i],data.cardInfo.cardId,data.cardInfo.qualityLv))
    end
    view.upQuality_SuccessP:SetActive(true) 
end
--显示军功章内容
function wnd_cardyc_controller:showItemInfoPanel(index)

    --初始化军功章内容界面
    if not isInitMedalItemLayer then
        view:init_itemInfoPanel()
        view.itemInfoPanel.name = "medalItemPanel"
        view.itemInfoPanel:SetActive(false)
        isInitMedalItemLayer = true
    end
    view.itemInfoP_itemNameLab.transform:GetComponent("UILabel").text = data:getCardQualityInfo("CardEquip"..index,data.cardInfo.cardId,data.cardInfo.qualityLv)
   --[[
       判断物品信息的显示状态
   ]]
    if data.cardInfo.slotState[index] == data.EquipState.Active then--激活
        view.itemInfoP_needPanel:SetActive(false)
    else
        view.itemInfoP_haveLab.transform:GetComponent("UILabel").text = string.format("%s%d",data:getString(20043),data.upQualityHaveItems[index].num)
        view.itemInfoP_needLab.transform:GetComponent("UILabel").text = string.format("%s%d",data:getString(20044),data.upQualityNeedItems[index].num)
        view.itemInfoP_haveLab.transform:GetComponent("UILabel").color = Color(1,1,1,1)--黑
        if data.upQualityHaveItems[index].num < data.upQualityNeedItems[index].num then
            view.itemInfoP_haveLab.transform:GetComponent("UILabel").color = Color(1,0,0,1)--红  
        end
        view.itemInfoP_needPanel:SetActive(true)
    end
    --判断按钮的显示状态，并添加监听
    view.itemInfoP_btn_equip:SetActive(false)
    view.itemInfoP_btn_gain:SetActive(false)
    view.itemInfoP_btn_activate:SetActive(false)
    if data.cardInfo.slotState[index] == data.EquipState.Enable_NotEnough then 
        view.itemInfoP_btn_gain:SetActive(true)
        UIEventListener.Get(view.itemInfoP_btn_gain).onPress = function(itemInfoP_btn_gain, args)
            if args then
                print("获得，，，") --点击后跳转至军功章获取界面 获得途径界面
                self:GainWayLayer()
            end
        end
    elseif data.cardInfo.slotState[index] == data.EquipState.Enable_Enough then
        view.itemInfoP_btn_equip:SetActive(true)
        UIEventListener.Get(view.itemInfoP_btn_equip).onPress = function(itemInfoP_btn_equip, args)
            if args then
                self:equipCallBack(index)
            end
        end
    elseif data.cardInfo.slotState[index] == data.EquipState.Active then
        view.itemInfoP_btn_activate:SetActive(true)
        UIEventListener.Get(view.itemInfoP_btn_activate).onPress = function(itemInfoP_btn_activate, args)
            if args then
                print("已激活..")
            end
        end
    end
    UIEventListener.Get(view.itemInfoP_btn_back).onPress = function(itemInfoP_btn_back, args)
        if args then
            print("返回")
            view.itemInfoPanel:SetActive(false)
        end
    end
    view.itemInfoPanel:SetActive(true)
end
--获得方式界面
function wnd_cardyc_controller:GainWayLayer()
    view.itemInfoPanel:SetActive(false)
    if not isInitGainLayer then
        view:init_gainWayPanel()
        view.gainWayPanel.name = "gainWayPanel"
        view.gainWayPanel:SetActive(false)
        isInitGainLayer = true
    end
    --返回
    UIEventListener.Get(view.gainWayP_btn_back).onPress = function(gainWayP_btn_back, args)
        if args then
            view.gainWayPanel:SetActive(false)
        end
    end
    view.gainWayPanel:SetActive(true)
end
--点击晋阶按钮
function wnd_cardyc_controller:upQualityBtn_onclick()
    --判断是否可以进阶
    if not data:isCan_UpQuality() then
        return
    end
    --向服务器发送卡牌进阶消息消息
    SendPB_10012(data.cardInfo.cardId)
end
--进阶成功后刷新界面
function wnd_cardyc_controller:upQuality_refresh()
    -- body
    if not data:getDatas(CardIndex) then 
        return 
    end 
    self:show_upQuality_SuccessPanel()
    self:init_leftCard_Data()
    self:refresh_RightBody()
    self:init_redDot()
end
--点击一键装备按钮  
function wnd_cardyc_controller:equipAllCallBack()
    for i=1,#data.cardInfo.slotState do
        if data.cardInfo.slotState[i] == data.EquipState.Enable_Enough and (data.upQualityNeedItems[i].num <= data.upQualityHaveItems[i].num) then
            SendPB_10013(data.cardInfo.cardId, i-1)
        end
    end
end
--点击装备按钮
function wnd_cardyc_controller:equipCallBack(index)
    SendPB_10013(data.cardInfo.cardId, index-1)
end
--装备成功后刷新界面
function wnd_cardyc_controller:epuip_refresh()
    if not data:getDatas(CardIndex) then 
        return 
    end 
    view.itemInfoPanel:SetActive(false)
    self:init_upQualityPanel()
    self:init_redDot()
end




--[[
                                 技能部分
]]
local UpSkillIndex = 0 --保存升级的技能的index
local isInitSUpLayer = false
local isfiveSIinit = false
local isInitSptReset = false
--技能tab界面
function wnd_cardyc_controller:skill_Body()
    print("skill_body!!!!!!")
    --初始化技能点
    view.skillP_pointLab.transform:GetComponent("UILabel").text = data.userInfo.totalSkPt
    --监听重置技能点按钮
    UIEventListener.Get(view.skillP_btnResetPoint).onPress = function(skillP_btnResetPoint, args)
        if args then
            self:show_SkillPoint_Reset_Panel()
        end
    end
    --[[
        初始化技能图标
    ]]
    for i=1,5 do
        local position = Vector3(data.skill_position_Table[i].x, data.skill_position_Table[i].y, data.skill_position_Table[i].z)
        local name = string.format("skillFrame_%d",i)
        if not isfiveSIinit then
            self:create_SkillItem(view.skillPanel,name,position,1.3) --技能框
        end
        self:refresh_skillFrame(view[name],i)
    end
    isfiveSIinit = true
end
--显示技能详细信息界面
function wnd_cardyc_controller:show_SkillItem_UpPanel(index)
    --第一次进入本界面，初始化
    if not isInitSUpLayer then
        view:init_skillInfoPanel()
        view.skillInfoPanel.name = "skillItemUpLayer"
        local position = Vector3(-210,60,0)
        self:create_SkillItem(view.skillInfoPanel,"skillInfoP_skillFrame",position,1.3)
        view.skillInfoPanel:SetActive(false)
        UIEventListener.Get(view.skillInfoP_BtnBack).onPress = function(skillInfoP_BtnBack, args)
            if args then
                view.skillInfoPanel:SetActive(false)
            end
        end
        isInitSUpLayer = true
    end
    self:refresh_SkillInfo_Layer(index)--初始化/刷新界面内容
    view.skillInfoPanel:SetActive(true)
end
--刷新技能详细信息界面
function wnd_cardyc_controller:refresh_SkillInfo_Layer(index)

    self:refresh_skillFrame(view["skillInfoP_skillFrame"],index)
    view.skillInfoP_lv_Lab.transform:GetComponent("UILabel").text = data:getString(20041)
    view.skillInfoP_lvProLab.transform:GetComponent("UILabel").text = string.format("[f15c03]%d[-]/%d",data.cardInfo.skill_Lv_Table[index],16)--当前技能/技能总级
    view.skillInfoP_sdes_Lab.transform:GetComponent("UILabel").text = data:getskillInfoByID("Des",data.skill_ID_Table[index])
    view.skillInfoP_btn_unlock_Label.transform:GetComponent("UILabel").text=string.format(data:getString(20049),index) 
    local skcost= data:getUpSkillNeedPoints(data:GetNextSkillLv(data.cardInfo.skill_Lv_Table[index],data.Const.MAX_SKILL_LV))--获取升级消耗技能点
    view.skillInfoP_costLab.transform:GetComponent("UILabel").text = skcost
    view.skillInfoP_costLab.transform:GetComponent("UILabel").color = Color(1,1,1,1)--红w
    if skcost > data.userInfo.totalSkPt then--判断是否足够升级，设置颜色
        view.skillInfoP_costLab.transform:GetComponent("UILabel").color = Color(255/255,0/255,0/255,255/255)--红
    end

    UIEventListener.Get(view.skillInfoP_btn_unlock).onPress = function(btn_unlock, args)
        if args then
            print("尚未解锁！！！！！")
        end
    end 
    UIEventListener.Get(view.skillInfoP_btn_upLv).onPress = function(btn_upLv, args)
        if args then
            self:skillItem_Up_CallBack(index)
        end
    end 
    --技能升级按钮显示
    view.skillInfoP_btn_unlock:SetActive(true)
    view.skillInfoP_btn_upLv:SetActive(false) 
    if index <= data.cardInfo.starLv then
        view.skillInfoP_btn_unlock:SetActive(false)
        view.skillInfoP_btn_upLv:SetActive(true)
    end
    
end

--点击技能升级按钮
function wnd_cardyc_controller:skillItem_Up_CallBack(index)
    if not data:isCan_UpSkill(index) then 
        return 
    end 
    UpSkillIndex = index
    SendPB_10014(data.cardInfo.cardId,index-1)
end
--根据升级技能的index对界面进行刷新
function wnd_cardyc_controller:upSkill_refresh()
    if not data:getDatas(CardIndex) then 
        return 
    end 
    self:refresh_RightBody()
    self:refresh_skillFrame(view["skillInfoP_skillFrame"],UpSkillIndex)
    self:refresh_SkillInfo_Layer(UpSkillIndex)
    self:init_redDot()
end
--显示重置技能点界面
function wnd_cardyc_controller:show_SkillPoint_Reset_Panel()
    print("技能点重置,,,")
    if not isInitSptReset then
        view:init_skillPointResetPanels(  )
        view.sPtRPanel.name = "sPtReset"
        self:create_CardHead(view.sPtRPanel,"resetSPt_cardhead",Vector3(-199,40,0))
        view.sPtRPanel:SetActive(false)
        isInitSptReset = true
    end
    view.sPtRP_titleL.transform:GetComponent("UILabel").text = data:getString(20029)        --描述
    view.sPtRP_desL.transform:GetComponent("UILabel").text = string.format(data:getString(20030),data:getCardInfo("Name",data.cardInfo.cardId))                 --返回按钮添加监听
    view.sPtRP_norResetCostL.transform:GetComponent("UILabel").text = 100
    view.sPtRP_perResetCostL.transform:GetComponent("UILabel").text = 300
    UIEventListener.Get(view.sPtRP_btnBack).onPress = function(sPtRP_btnBack, args)
        if args then
            view.sPtRPanel:SetActive(false)
        end
    end
    UIEventListener.Get(view.sPtRP_norResetB).onPress = function(sPtRP_norResetB, args)
        if args then
            self:normal_Reset_CallBack()
        end
    end
    UIEventListener.Get(view.sPtRP_perResetB).onPress = function(sPtRP_perResetB, args)
        if args then
            self:perfect_Reset_CallBack()
        end
    end
    --刷新技能重置界面的卡牌头像，显示默认星级
    self:refresh_CardHead(view["resetSPt_cardhead"],data.cardInfo.cardId)
    view.sPtRPanel:SetActive(true)
end
--普通重置
function wnd_cardyc_controller:normal_Reset_CallBack()
    --已解锁的技能等级变为1级，返还升级所用的技能卡数目的80%加至总技能卡中
    SendPB_10015(data.cardInfo.cardId, 100)
end
--完美重置
function wnd_cardyc_controller:perfect_Reset_CallBack()
    SendPB_10015(data.cardInfo.cardId, 300)
end
--重置技能成功后对界面进行刷新
function wnd_cardyc_controller:skillReset_refresh()
    if not data:getDatas(CardIndex) then 
        return 
    end 
    view.sPtRPanel:SetActive(false)
    self:refresh_RightBody()
    self:init_redDot()
end


--[[
    兵员部分
]]
--初始化兵员界面
local isInitAcFrame = false
function wnd_cardyc_controller:soldier_Body()

    --初始化兵员界面
    if not isInitAcFrame then
        local position = Vector3(0,136,0)
        self:create_CardHead(view.soldierPanel,"upSoldier_cardhead",position,4)
        UIEventListener.Get(view.soldierP_btnUpSoldier).onPress = function(soldierP_btnUpSoldier, args)
            if args then
            self:soldier_Up_CallBack()
            end
        end
        isInitAcFrame = true
    end

    --初始化卡牌头像，显示当前卡牌的默认星级
    self:refresh_CardHead(view["upSoldier_cardhead"],data.cardInfo.cardId)
    view.soldierP_cardNameL.transform:GetComponent("UILabel").text = data:getCardInfo("Name",data.cardInfo.cardId)
    view.soldierP_badgeNameL.transform:GetComponent("UILabel").text = data:getString(20027)
    view.soldierP_LvProLab.transform:GetComponent("UILabel").text --兵员等级上限
        = string.format("%s%d/%d",data:getString(20041),data.cardInfo.soldierLv,data.Const.MAX_ARMY_LV)--兵员等级/兵员等级上限
    view.soldierP_desLab = data:getString(20042)

    local needCardNum = data:getUpSoldierNeedGoods("Card",data.cardInfo.soldierLv)
    local needCoinNum = data:getUpSoldierNeedGoods("Coin",data.cardInfo.soldierLv)
    view.soldierP_cardNeedL.transform:GetComponent("UILabel").text = string.format("x%d",needCardNum)
    view.soldierP_badgeNeednumL.transform:GetComponent("UILabel").text = string.format("x%d",needCoinNum)
    view.soldierP_cardHavaLab.transform:GetComponent("UILabel").text = string.format("(%s%d)",data:getString(20028),data.cardInfo.cardFragment)
    view.soldierP_badgeHaveLab.transform:GetComponent("UILabel").text = string.format("(%s%d)",data:getString(20028),data.userInfo.badgeNum)

    if needCardNum > data.cardInfo.cardFragment then
        view.soldierP_cardHavaLab.transform:GetComponent("UILabel").color = Color(255/255,0/255,0/255,255/255)
    else
        view.soldierP_cardHavaLab.transform:GetComponent("UILabel").color = Color(0/255,255/255,255/255,255/255)
    end
    if needCoinNum > data.userInfo.badgeNum then
        view.soldierP_badgeHaveLab.transform:GetComponent("UILabel").color = Color(255/255,0/255,0/255,255/255)
    else
        view.soldierP_badgeHaveLab.transform:GetComponent("UILabel").color = Color(0/255,255/255,255/255,255/255)
    end
end
--点击兵员升级按钮
function wnd_cardyc_controller:soldier_Up_CallBack()
    --判断是否可以刷新界面
    if not data:isCan_UpSoldier() then
        return
    end
    --发消息,提升等级,刷新界面
    SendPB_10011(data.cardInfo.cardId)
    
    
end
--兵员升级成功后刷新
function wnd_cardyc_controller:upSoldier_refresh()
    if not data:getDatas(CardIndex) then 
        return 
    end 
    self:refresh_RightBody()
    self:init_redDot()
end

--[[
    协同部分
]]
local UpSynergyIndex = 0
local isAttrItemInit = false
local isInitxtLayer = false
--刷新协同部分
function wnd_cardyc_controller:synergy_Body()

    if not isAttrItemInit then 
        for i=1 ,#data.cardInfo.synergyLvTbl do
            local name = string.format("synergyItem_%d",i)
            self:create_synergyItem(view.synergyPanel,name,i)
        end
        isAttrItemInit = true
    end

    --刷新协同选项
    for i=1 ,#data.cardInfo.synergyLvTbl do
        local name = string.format("synergyItem_%d",i)
        self:refresh_synergyItem(view[name],i)
    end

    --计算解锁的协同卡牌数量
    local count = 0
    for i=1,#data.synergyStateTbl do
        if data.synergyStateTbl[i] == data.SynergyState.activated then
            count = count+1
        end
    end

    print(string.format( "count::::%d",count))
    --根据协同选项的数量解锁协同额外属性
    view.synergyP_addProperty_1.transform:GetComponent("UILabel").text = "property1"
    view.synergyP_addProperty_2.transform:GetComponent("UILabel").text = "property2"
    view.synergyP_addProperty_3.transform:GetComponent("UILabel").text = "property3"
    view.synergyP_addProperty_1.transform:GetComponent("UILabel").color= Color(1,1,1,1)
    view.synergyP_addProperty_2.transform:GetComponent("UILabel").color= Color(1,1,1,1)
    view.synergyP_addProperty_3.transform:GetComponent("UILabel").color= Color(1,1,1,1)
    if count > 0 then 
        view.synergyP_addProperty_1.transform:GetComponent("UILabel").color= Color(0,1,0,1)
    end
    if count > 1 then 
        view.synergyP_addProperty_2.transform:GetComponent("UILabel").color= Color(0,1,0,1)
    end
    if count > 2 then 
        view.synergyP_addProperty_3.transform:GetComponent("UILabel").color= Color(0,1,0,1)
    end

        -- local atbAddLab = atbAddPanel.transform:Find("atbAddLab_"..i):GetComponent("UILabel")
        -- --UnionAttributeAdd1  AddPoint1
        -- local utadd = sdata_armycardunion_data:GetFieldV("UnionAttributeAdd"..i, auid)
        -- local addpoint = sdata_armycardunion_data:GetFieldV("AddPoint"..i,auid)
        -- atbAddLab.text = string.format("type%d+%d (have %d xt)",utadd,addpoint*100,i+1)  --类型+加成

        -- if count >= i+1 then
        --     atbAddLab.text = string.format("[00ff00]type%d+%d[-]",utadd,addpoint*100)  --类型+加成
        -- end

    
end
--点击协同选项
function wnd_cardyc_controller:synergyItem_onClicked(index)

     --初始化协同升级界面
    if not isInitxtLayer then
        view:init_upSynergyPanel()
        view.upSynergyP.name = "xtPanel"
        self:create_CardHead(view.upSynergyP,"upSynergy_cardhead",Vector3(-220,20,0))
        isInitxtLayer = true
        UIEventListener.Get(view.upSynergyP_btnBack).onPress = function(upSynergyP_btnBack, args)
            if args then
                view.upSynergyP:SetActive(false)
            end
        end
        UIEventListener.Get(view.upSynergyP_btnCancle).onPress = function(upSynergyP_btnCancle, args)
            if args then
                view.upSynergyP:SetActive(false)
            end
        end
        UIEventListener.Get(view.upSynergyP_btnOk).onPress = function(upSynergyP_btnOk, args)
            if args then
                self:upSynergyP_btnOk_onClicked(index)
            end
        end
    end
    view.upSynergyP:SetActive(false)

    --初始化协同卡牌的图标,显示相应的卡牌信息
    self:refresh_CardHead(view["upSynergy_cardhead"],data.synergyIDTbl[index])
    --设置界面标题
    if data.synergyStateTbl[index] == data.SynergyState.activated then --已激活
         view.upSynergyP_title.transform:GetComponent("UILabel").text = data:getString(20035)
         view.upSynergyP_btnOkL.transform:GetComponent("UILabel").text = data:getString(20002)
         view.upSynergyP_btnOk:SetActive(true)
    elseif data.synergyStateTbl[index] ==data.SynergyState.canActive then --可激活
         view.upSynergyP_title.transform:GetComponent("UILabel").text = data:getString(20034)
         view.upSynergyP_btnOkL.transform:GetComponent("UILabel").text = data:getString(20051)
         view.upSynergyP_btnOk:SetActive(true)
    elseif data.synergyStateTbl[index] ==data.SynergyState.unactive then --可激活
         view.upSynergyP_title.transform:GetComponent("UILabel").text = data:getString(20034)
         view.upSynergyP_btnOk:SetActive(false)
         
    end
    --设置卡牌的名称
    view.upSynergyP_cardNameL.transform:GetComponent("UILabel").text = string.format(data:getString(20050),data:getCardInfo("Name",data.cardInfo.cardId),data:getCardInfo("Name",data.synergyIDTbl[index]))

    --从表中获取显示的信息
    view.upSynergyP_desL.transform:GetComponent("UILabel").text = data:getString(20032)
    view.upSynergyP_coinL.transform:GetComponent("UILabel").text = data:getString(20027)
    view.upSynergyP_goldL.transform:GetComponent("UILabel").text = data:getString(20033)

    
    --获取协同升级所需的材料数量
    local needCoinNum = data:getUpSynergyCostInfo("Coin",data:getNextSynergylevel(data.cardInfo.synergyLvTbl[index],data.Const.MAX_SYNERGY_LV))
    local needGoldNum = data:getUpSynergyCostInfo("Gold",data:getNextSynergylevel(data.cardInfo.synergyLvTbl[index],data.Const.MAX_SYNERGY_LV))
    view.upSynergyP_coinNeedNumL.transform:GetComponent("UILabel").text = string.format("X%d", needCoinNum)
    view.upSynergyP_goldNeedNumL.transform:GetComponent("UILabel").text = string.format("X%d", needGoldNum)
    
    --获取拥有的材料数量
    local haveCoinNum = data.userInfo.badgeNum
    local haveGoldNum = data.userInfo.goldNum
    
    print("--------------------------------")
    print(needCoinNum,haveCoinNum)
    print(needGoldNum,haveGoldNum)
    
    local coinNumColor = "FF2121" 
    local goldNumColor = "FF2121" 
    if haveCoinNum >= needCoinNum then 
        coinNumColor = "21FF21"
    end
    if haveGoldNum >= needGoldNum then
        goldNumColor = "21FF21"
    end
    view.upSynergyP_coinHaveNumL.transform:GetComponent("UILabel").text = string.format("([%s]%s%d[-])", coinNumColor,data:getString(20028), data.userInfo.badgeNum) 
    view.upSynergyP_goldHaveNumL.transform:GetComponent("UILabel").text = string.format("([%s]%s%d[-])", goldNumColor,data:getString(20028), data.userInfo.goldNum) 
    
    view.upSynergyP:SetActive(true)
end
--点击协同升级按钮
function wnd_cardyc_controller:upSynergyP_btnOk_onClicked(index)
    --判断当前是否可以协同升级
    if not data:isCan_UpSynergy(index) then
        return 
    end
    UpSynergyIndex = index
    --向服务器发送升级协同数据
    SendPB_10018(data.cardInfo.cardId,index-1)
    
end

function wnd_cardyc_controller:upSynergy_refresh()
    print("upSynergy_refresh!!!")
    --获取数据
    if not data:getDatas(CardIndex) then 
        return 
    end 
    self:refresh_RightBody()
    --刷新协同升级界面
    self:synergyItem_onClicked(UpSynergyIndex)
    self:init_redDot()
end




function wnd_cardyc_controller:create_synergyItem(parent,name,index)
    -- body
    view:init_synergyItem(view.synergyPanel,name)
    view[name].synergyItem.name = string.format("synergyItem_%d",index)
    view[name].synergyItem.transform.localPosition = Vector3(0, 180-104*(index-1))

    UIEventListener.Get(view[name].synergyItem).onPress = function(synergyItem, args)
        if args then
            self:synergyItem_onClicked(index)
        end
    end

end
function wnd_cardyc_controller:refresh_synergyItem(synergyItem,index)
    --c初始化协同选项
    --设置卡牌头像图片
    synergyItem.synergyItem_Sp.transform:GetComponent("UISprite").atlas = TestAtlas
    synergyItem.synergyItem_Sp.transform:GetComponent("UISprite").spriteName = data:getCardInfo("IconID",data.synergyIDTbl[index])
    synergyItem.synergyItem_Sp.transform:GetComponent("UISprite").color = Color(105/255,105/255,105/255,105/255)
    synergyItem.synergyItem_itemBg.transform:GetComponent("UISprite").color = Color(105/255,105/255,105/255,105/255)
    synergyItem.synergyItem_upSp:SetActive(false)
    synergyItem.synergyItem_plusSp:SetActive(false)
    synergyItem.synergyItem_nowPropL.transform:GetComponent("UILabel").text = string.format("%s",data:getCardInfo("Name",data.synergyIDTbl[index]))
    synergyItem.synergyItem_nowPropL.transform:GetComponent("UILabel").color = Color(105/255,105/255,105/255,105/255)
    synergyItem.synergyItem_nextPropL.transform:GetComponent("UILabel").text = string.format("%s",data:getCardInfo("Name",data.synergyIDTbl[index]))
    synergyItem.synergyItem_nextPropL.transform:GetComponent("UILabel").color = Color(105/255,105/255,105/255,105/255)

    
    --如果可以激活显示激活加号图标
    if data.synergyStateTbl[index] == data.SynergyState.canActive  then
        if data.cardInfo.synergyLvTbl[index] == 0 then
            synergyItem.synergyItem_plusSp:SetActive(true)
        else
            synergyItem.synergyItem_upSp:SetActive(true)
        end
    --如果已经激活字体和图片颜色变亮
    elseif data.synergyStateTbl[index] == data.SynergyState.activated  then
        synergyItem.synergyItem_Sp.transform:GetComponent("UISprite").color = Color(255/255,255/255,255/255,255/255)
        synergyItem.synergyItem_itemBg.transform:GetComponent("UISprite").color = Color(255/255,255/255,255/255,255/255)
        synergyItem.synergyItem_nowPropL.transform:GetComponent("UILabel").color = Color(255/255,255/255,255/255,255/255)
        synergyItem.synergyItem_nextPropL.transform:GetComponent("UILabel").color = Color(255/255,255/255,255/255,255/255)
    end
end



function wnd_cardyc_controller:create_itemHead(parent,name,Vector3)
    view:init_itemHead(parent,name)
    local depthNum = parent.transform:GetComponent("UIWidget").depth
    view[name].itemhead.name = name
    view[name].itemhead.transform.localPosition = Vector3
    view[name].itemhead_Sprite.transform:GetComponent("UISprite").depth = depthNum + 1
    view[name].itemhead_lockSp.transform:GetComponent("UISprite").depth = depthNum + 2
    view[name].itemhead_itemSp.transform:GetComponent("UISprite").depth = depthNum + 3
    view[name].itemhead_plusSp.transform:GetComponent("UISprite").depth = depthNum + 4
    view[name].itemhead_numLab.transform:GetComponent("UILabel").depth = depthNum + 5
    view[name].itemhead_plusSp:SetActive(false)
end

function wnd_cardyc_controller:refresh_itemHead(itemHead,index)
    itemHead.itemhead_numLab.transform:GetComponent("UILabel").text = string.format("%d/%d",data.upQualityHaveItems[index].num,data.upQualityNeedItems[index].num)    
    itemHead.itemhead_Sprite:SetActive(true)
    itemHead.itemhead_lockSp:SetActive(false)
    if data.cardInfo.slotState[index] == data.EquipState.Enable_NotEnough then
        itemHead.itemhead_itemSp.transform:GetComponent("UISprite").color = Color(123/255,123/255,123/255,123/255)
        itemHead.itemhead_plusSp:SetActive(false)
        itemHead.itemhead_Sprite:SetActive(false)
        itemHead.itemhead_lockSp:SetActive(true)
        itemHead.itemhead_numLab:SetActive(true)
    elseif data.cardInfo.slotState[index] == data.EquipState.Enable_Enough then
        itemHead.itemhead_itemSp.transform:GetComponent("UISprite").color = Color(255/255,255/255,255/255,255/255)
        itemHead.itemhead_plusSp:SetActive(true)
        itemHead.itemhead_numLab:SetActive(true)
    elseif data.cardInfo.slotState[index] == data.EquipState.Active then
        itemHead.itemhead_plusSp:SetActive(false)
        itemHead.itemhead_numLab:SetActive(false)
        itemHead.itemhead_itemSp.transform:GetComponent("UISprite").color = Color(255/255,255/255,255/255,255/255)
    end
end

function wnd_cardyc_controller:create_SkillItem(parent,name,position,scale) --技能框
    depthNum=parent.transform:GetComponent("UIWidget").depth
    view:init_skillItem(parent,name)
    view[name].skillItem.name = name
    view[name].skillItem.transform:GetComponent("UIWidget").depth = depthNum
    view[name].skillItem.transform.localPosition = position
    view[name].skillItem.transform.localScale = Vector3(scale, scale, scale)

    view[name].skillItem_bg.transform:GetComponent("UISprite").depth = depthNum + 1
    view[name].skillItem_lv_bg.transform:GetComponent("UISprite").depth = depthNum + 3
    view[name].skillItem_imgSp.transform:GetComponent("UISprite").depth = depthNum + 2
    view[name].skillItem_name_Lab.transform:GetComponent("UILabel").depth = depthNum + 1
    view[name].skillItem_lv_Lab.transform:GetComponent("UILabel").depth = depthNum + 3
    view[name].skillItem_redDot.transform:GetComponent("UISprite").depth = depthNum + 3
    view[name].skillItem_bklockSp.transform:GetComponent("UISprite").depth = depthNum + 4
    view[name].skillItem_bklockSp_Sprite.transform:GetComponent("UISprite").depth = depthNum + 5
    view[name].skillItem_bklockSp_LockSp.transform:GetComponent("UISprite").depth = depthNum + 5
    

    view[name].skillItem_bg:SetActive(true)
    view[name].skillItem_bklockSp:SetActive(false)
end

function wnd_cardyc_controller:refresh_skillFrame(skillItem,index)
    if skillItem.name ~= "skillInfoP_skillFrame" then
        UIEventListener.Get(skillItem.skillItem_imgSp).onPress = function(skillItem_imgSp, args)
            if args then
                self:show_SkillItem_UpPanel(index)
            end
        end
    end 
    skillItem.skillItem_imgSp.transform:GetComponent("UISprite").atlas = TestAtlas
    skillItem.skillItem_imgSp.transform:GetComponent("UISprite").spriteName = data:getskillInfoByID("SkillIcon",data.skill_ID_Table[index])
    if index > data.cardInfo.starLv then
        skillItem.skillItem_bg:SetActive(false)
        skillItem.skillItem_bklockSp:SetActive(true)
        skillItem.skillItem_lv_Lab.transform:GetComponent("UILabel").text = "0"
        --根据index显示该技能解锁的星级 
        skillItem.skillItem_name_Lab.transform:GetComponent("UILabel").text = data:getString(20043 + index)
        skillItem.skillItem_imgSp.transform:GetComponent("UISprite").color = Color(123/255,123/255,123/255,123/255)
        return
    end
    --根据当前星级设置该技能的显示状态
    skillItem.skillItem_bg:SetActive(true)
    skillItem.skillItem_bklockSp:SetActive(false)
    skillItem.skillItem_imgSp.transform:GetComponent("UISprite").color= Color(1,1,1,1)
    skillItem.skillItem_lv_Lab.transform:GetComponent("UILabel").text = data.cardInfo.skill_Lv_Table[index]
    skillItem.skillItem_name_Lab.transform:GetComponent("UILabel").text =data:getskillInfoByID("Name",data.skill_ID_Table[index])   --解锁技能名
end

--创建卡牌头像
function wnd_cardyc_controller:create_CardHead(parent,name,Vector3)
    --初始化卡牌头像控件
    view:init_CardHead(parent,name)
    local depthNum = parent.transform:GetComponent("UIWidget").depth
    --初始化卡牌名称以及显示信息
    view[name].cardhead.transform.name = name
    view[name].cardhead.transform.localPosition = Vector3
    view[name].cardhead_lv_Lab.transform:GetComponent("UILabel").text = data.cardInfo.cardLv
    for i=1 , data.Const.MAX_STAR_LV do
        view[name].cardhead_starPanel.transform:Find("star_"..i).gameObject:GetComponent("UISprite").depth=depthNum+3
    end
    --设置各个控件的层级
    view[name].cardhead.transform:GetComponent("UIWidget").depth = depthNum
    view[name].cardhead_bg.transform:GetComponent("UISprite").depth =depthNum
    view[name].cardhead_imgSp.transform:GetComponent("UISprite").depth = depthNum+1
    view[name].cardhead_lv_bg.transform:GetComponent("UISprite").depth =depthNum+2
    view[name].cardhead_lv_Lab.transform:GetComponent("UILabel").depth =depthNum+2
    view[name].cardhead_medalSp.transform:GetComponent("UISprite").depth = depthNum+2
    view[name].cardhead_starPanel.transform:GetComponent("UIWidget").depth = depthNum+3
end

--[[
        刷新卡牌头像信息
    当showStarNum参数为nil时表示显示该卡牌的默认星级
]]
function wnd_cardyc_controller:refresh_CardHead(cardHead,cardId,showStarNum)
    -- if not cardHead then--如果卡牌头像不存在
    --     return
    -- end
    local card = nil
    local cardLv = 1
    local cardStarLv = 1
    if cardId == data.cardInfo.cardId then --判断是否要显示当前卡牌的信息
        cardLv = data.cardInfo.cardLv
        cardStarLv = data.cardInfo.starLv
    else
        card = data:getCardByID(cardId) --根据id获取卡牌的等级
        if card then   --判断卡牌是否存在
            cardLv = card.lv
            cardStarLv = card.star
        end
    end 
    
    if showStarNum then --判读是否自定义显示星级
        cardStarLv = showStarNum
    end

    --设置级数
    cardHead.cardhead_lv_Lab.transform:GetComponent("UILabel").text = cardLv
    --设置卡牌头像图片
    cardHead.cardhead_imgSp.transform:GetComponent("UISprite").atlas = TestAtlas
    cardHead.cardhead_imgSp.transform:GetComponent("UISprite").spriteName = data:getCardInfo("IconID",cardId)
    --设置卡牌星级显示
    for i=1,data.Const.MAX_STAR_LV do
        local star = cardHead.cardhead_starPanel.transform:Find("star_"..i).gameObject
        star:SetActive(true)
        if i > cardStarLv then
            star:SetActive(false)
        end
    end
end





function wnd_cardyc_controller:OnHideFinish()
	print("wnd_cardyc_controller:OnHideFinish.......")--隐藏主面板
end

function wnd_cardyc_controller:RegStart()
	print("wnd_cardyc_controller:RegStart.......")
    wnd_cardyc_controller = self
end

function wnd_cardyc_controller:OnLostInstance()
	print("wnd_cardyc_controller:OnLostInstance.......")
end

return wnd_cardyc_controller