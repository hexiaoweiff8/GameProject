local information_controller = {}
local view = require("uiscripts/cardyc/information/information_view")
local data = require("uiscripts/cardyc/information/information_model")

require("uiscripts/commonGameObj/itemSlot")

local isInitMedalItemLayer = false  --是否初始化物品内容界面
local isInitGainLayer  = false      --是否初始化获得方式界面
local isSlotInit = false            --是否初始化物品插槽
local isInitAmSLayer = false        --是否初始化晋升成功界面
local isinitDetail = false          --是否初始化卡牌信息界面

local itemSlots = {}

local success_cardhead_left
local success_cardhead_right
local detail_cardhead
function information_controller:init( args )
    -- body
    view:init_view(args)

end

function information_controller:setPropItemInfo(propItem, propsName)
    propItem.Sprite.spriteName = Const.CARD_PROP_NAME_TO_SPRITE_NAME[propsName]
    propItem.NameLab.text = cardUtil:getCardPropName(propsName)
    propItem.ValueLab.text = cardUtil:getCardPropValue(propsName, data.cardId, data.cardLv)
end

function information_controller:Refresh()
    -- body
    print("information_controller refresh!!!!")
    data:init_upQualityItems()

    self:init_InformationPanel()
    self:init_suppressPanel()
    self:init_upQualityPanel()
end


--初始化卡牌信息部分
function information_controller:init_InformationPanel()

    local propsName = {
        "HP", "ArmyType",
        "Attack1", "GeneralType",
        "Defence", "IsCreature",
        "ArmyUnit", "AimGeneralType",
        "RangeType", "AttackType",
    }
    for i = 1,#propsName do
        if not view.InfoP_propItem[i] then
            print(propsName[i])
            view.InfoP_propItem[i] = view:createPropItem(view.infoP_propP)
            view.InfoP_propItem[i].Self.transform.localPosition = Vector3(-120 + 210 * ((i - 1) % 2), 200 - 40 * math.floor((i - 1) / 2 ), 0)
        end
        self:setPropItemInfo(view.InfoP_propItem[i], propsName[i])
    end

    --for i = 1, #view.props do
    --    local propertyValue
    --    if propsName[i] == "AimGeneralType" then
    --        propertyValue = string.format( "%s", stringUtil:getString(20720 + cardUtil:getCardProperty("AimGeneralType", data.cardId, data.cardLv)))
    --    elseif propsName[i] == "AttackType" then
    --        propertyValue = string.format( "%s", stringUtil:getString(20750 + cardUtil:getCardProperty("AttackType", data.cardId, data.cardLv)))
    --    else
    --        propertyValue = string.format( "%d", cardUtil:getCardProperty(propsName[i], data.cardId, data.cardLv))
    --    end
    --    view.propertyTbl[i].transform:GetComponent("UILabel").text = propertyValue
    --    UIEventListener.Get(view.propertyTbl[i]).onPress = function(a, b)
    --        view.infoP_propTip.transform.position = a.transform.position
    --        view.infoP_propTipLab.transform:GetComponent("UILabel").text = stringUtil:getString(20002 + i)
    --        view.infoP_propTip:SetActive(b)
    --    end
    --end

end
--初始化克制关系部分
function information_controller:init_suppressPanel()

    local currentType = cardUtil:getCardArmyType(data.cardId)
    view.suppressP_armyName.transform:GetComponent("UILabel").text = currentType
    if currentType == 1 then
        view.suppressP_beSupLab.transform:GetComponent("UILabel").text = "0%"
        view.suppressP_SupLab.transform:GetComponent("UILabel").text = "0%"
    else
        local beSuppressType = cardUtil:getSuppressInfo("BeikezhiType",currentType)
        local SuppressType = cardUtil:getSuppressInfo("KezhiType",currentType)
        local SuppressNum = cardUtil:getSuppressInfo("KezhiAdd",currentType)
        view.suppressP_beSupLab.transform:GetComponent("UILabel").text = string.format("%d%%",SuppressNum * 100)
        view.suppressP_SupLab.transform:GetComponent("UILabel").text = string.format("%d%%",SuppressNum * 100)
    end



end

--初始化卡牌进阶部分
function information_controller:init_upQualityPanel()
    -- 判断卡牌的阶品否已达最大
    if data.qualityLv == Const.MAX_QUALITY_LV then
        view.upQuality_Panel:SetActive(false)
        view.maxUpQuality_Panel:SetActive(true)
        return
    end
    view.upQuality_Panel:SetActive(true)
    view.maxUpQuality_Panel:SetActive(false)
    --根据插槽状态的数量初始化插槽
    for i=1,#data.slotState do
        local position = Vector3(-150+(i-1)*100, 40 ,0)
        if not isSlotInit then
            itemSlots[i] = ItemSlot(view.upQuality_Panel, position, i, self.showItemInfoPanel)
        end
        itemSlots[i]:refresh(
        qualityUtil:getItemID(i,data.cardId,data.qualityLv)
        , data.upQualityHaveItems[i].num
        , data.upQualityNeedItems[i].num
        , data.slotState[i])
    end
    isSlotInit = true


    --判断插槽是否全部激活
    local isAllSlotActive = false
    for i,v in ipairs(data.slotState) do
        if v == qualityUtil.EquipState.Active then
            isAllSlotActive = true
        else
            isAllSlotActive = false
            break
        end
    end
    --如果全部激活显示进阶按钮和进阶所需的金币，否则显示一键装备按钮
    if isAllSlotActive then
        view.upQualityP_btnEpuipAll:SetActive(false)
        view.upQualityP_btnUpQ:SetActive(true)
        view.upQualityP_Cost:SetActive(true)
        view.upQualityP_Cost_Lab.transform:GetComponent("UILabel").text = qualityUtil:getUpQualityNeedGold(data.qualityLv + 1) --晋升所需金币
    else
        view.upQualityP_btnUpQ:SetActive(false)
        view.upQualityP_Cost:SetActive(false)
        view.upQualityP_btnEpuipAll:SetActive(true)
    end

    --监听进阶按钮
    UIEventListener.Get(view.upQualityP_btnUpQ).onClick = function()
        self:upQualityBtn_onclick()
    end

    --监听一键装备按钮
    UIEventListener.Get(view.upQualityP_btnEpuipAll).onClick = function()
        self:equipAllCallBack()
    end
end

--显示卡牌的详细信息
function information_controller:show_cardDetailPanel(CurrentTab)
    -- body

    local propsName = {
        "Name",
        "AimGeneralType",
        "DeployTime",
        "GeneralType",  "ArmyType",
        "Attack1",      "Attack2",
        "Clipsize1",    "Clipsize2",
        "AttackRate1",  "AttackRate2",
        "ReloadTime1",  "ReloadTime1",
        "Accuracy",     "SpaceSet",
        "SpreadRange",  "Defence",
        "HP",           "MoveSpeed",
        "Dodge",        "Hit",
        "AntiArmor",    "Armor",
        "AntiCrit",     "Crit",
        "CritDamage",   "BulletType",
        "BulletModel",  "MuzzleFlash",
        "SightRange",   "IsHide",
        "IsAntiHide",   "LifeTime",
    }
    if not isinitDetail then
        view:init_cardDetailView()
        detail_cardhead = CardHead(view.scrollView, Vector3(-90,-75,0))
        isinitDetail = true
    end
    detail_cardhead:refresh(data.cardId, data.cardLv, data.starLv)
    for i = 1, #propsName do
        local propertyValue
        if propsName[i] == "AimGeneralType" then
            propertyValue = string.format( "%s", stringUtil:getString(20720 + cardUtil:getCardPropValue("AimGeneralType", data.cardId, data.cardLv)))
        elseif propsName[i] == "AttackType" then
            propertyValue = string.format( "%s", stringUtil:getString(20750 + cardUtil:getCardPropValue("AttackType", data.cardId, data.cardLv)))
        else
            propertyValue = string.format( "%s", cardUtil:getCardPropValue(propsName[i], data.cardId, data.cardLv))
        end
        view.cardDetailTbl[i] = GameObjectExtension.InstantiateFromPacket("ui_cardyc", "propertyItem", view.scrollView).gameObject
        if i <= 3 then
            view.cardDetailTbl[i].transform.localPosition = Vector3(75, 25-50*i, 0)
        else
            if i % 2==0 then
                view.cardDetailTbl[i].transform.localPosition = Vector3(-150, 25-50*((i-4)/2+4), 0)
            else
                view.cardDetailTbl[i].transform.localPosition = Vector3(75, 25-50*((i-3)/2+3), 0)
            end
        end

        view.cardDetailTbl[i].transform:Find("value"):GetComponent("UILabel").text = propertyValue
        UIEventListener.Get(view.cardDetailTbl[i].transform:Find("value").gameObject).onPress = function(a, b)
            view.cardDetail_Tip.transform.position = a.transform.position
            view.cardDetail_TipLab.transform:GetComponent("UILabel").text = "属性"..i
            view.cardDetail_Tip:SetActive(b)
        end
    end

    if #propsName%2 == 0 then
        view.scrollView.transform:GetComponent("BoxCollider").center = Vector3(0,-25*((#propsName-4)/2+4),0)
        view.scrollView.transform:GetComponent("BoxCollider").size = Vector3(440,50*((#propsName-4)/2+4),0)
    else
        view.scrollView.transform:GetComponent("BoxCollider").center = Vector3(0,-25*((#propsName-3)/2+3),0)
        view.scrollView.transform:GetComponent("BoxCollider").size = Vector3(440,50*((#propsName-3)/2+3),0)
    end
    UIEventListener.Get(view.cardDetail_maskPanel).onClick = function()
        view.cardDetail:SetActive(false)
        CurrentTab:SetActive(true)
    end
    view.cardDetail:SetActive(true)
    CurrentTab:SetActive(false)
    view.scrollView.transform:GetComponent("UIScrollView"):ResetPosition()
end


--显示晋升成功界面
function information_controller:show_upQuality_SuccessPanel()
    --如果是第一次显示，对该界面进行初始化
    if not isInitAmSLayer then
        view:init_UpQuality_SuccessPanel()
        view.upQuality_SuccessP:SetActive(false)
        success_cardhead_left = CardHead(view.upQuality_SuccessP, Vector3(-190,55,0))
        success_cardhead_right = CardHead(view.upQuality_SuccessP, Vector3(190,55,0))
        UIEventListener.Get(view.upQualitySP_clickPanel).onClick = function()
            view.upQuality_SuccessP:SetActive(false)
        end
        isInitAmSLayer = true
    end
    --刷新卡牌的头像，显示默认星级，
    success_cardhead_left:refresh(data.cardId, data.cardLv, data.starLv)
    success_cardhead_right:refresh(data.cardId, data.cardLv, data.starLv)

    --显示卡牌进阶所提升的属性信息
    for i=1,#qualityUtil.qualityPropName do
        view["upQualitySP_propName_"..i].transform:GetComponent("UILabel").text = stringUtil:getString(20110+i)
        view["upQualitySP_propBeValue_"..i].transform:GetComponent("UILabel").text
        = string.format("%d",qualityUtil:getUpQualityAttribute(qualityUtil.qualityPropName[i],data.cardId,data.qualityLv-1))
        view["upQualitySP_propAfValue_"..i].transform:GetComponent("UILabel").text
        = string.format("%d",qualityUtil:getUpQualityAttribute(qualityUtil.qualityPropName[i],data.cardId,data.qualityLv))
    end
    view.upQuality_SuccessP:SetActive(true)
end

--显示军功章内容
function information_controller:showItemInfoPanel(index)

    --初始化军功章内容界面
    if not isInitMedalItemLayer then
        view:init_itemInfoPanel()
        view.itemInfoPanel:SetActive(false)
        isInitMedalItemLayer = true
    end

    local itemID = qualityUtil:getItemID(index,data.cardId,data.qualityLv)
    local itemName = itemUtil:getItemName(itemID)
    local itemSpriteName = itemUtil:getItemIcon(itemID)

    local attributeID = qualityUtil:getSlotAttributeID(index,data.cardId,data.qualityLv)
    local attributeName = attributeUtil:getAttributeName(attributeID)
    local attributePoint = qualityUtil:getSlotAttributePoint(index,data.cardId,data.qualityLv)
    local attributeSymbol = attributeUtil:getAttributeSymbol(attributeID)

    view.itemInfoP_itemNameLab.transform:GetComponent("UILabel").text = itemName
    view.itemInfoP_addDesLab.transform:GetComponent("UILabel").text
    = string.format( "%s+%d%s", attributeName, attributePoint,attributeSymbol)
    view.itemInfoP_itemImg.transform:GetComponent("UISprite").spriteName = itemSpriteName
    --[[
        判断物品信息的显示状态
    ]]
    if data.slotState[index] == qualityUtil.EquipState.Active then--激活
        view.itemInfoP_needPanel:SetActive(false)
    else
        view.itemInfoP_haveLab.transform:GetComponent("UILabel").text
        = string.format("%s%d",stringUtil:getString(20043),data.upQualityHaveItems[index].num)
        view.itemInfoP_needLab.transform:GetComponent("UILabel").text
        = string.format("%s%d",stringUtil:getString(20044),data.upQualityNeedItems[index].num)
        view.itemInfoP_haveLab.transform:GetComponent("UILabel").color = COLOR.White
        if data.upQualityHaveItems[index].num < data.upQualityNeedItems[index].num then
            view.itemInfoP_haveLab.transform:GetComponent("UILabel").color = COLOR.Red
        end
        view.itemInfoP_needPanel:SetActive(true)
    end

    --判断按钮的显示状态，并添加监听
    view.itemInfoP_btn_equip:SetActive(false)
    view.itemInfoP_btn_gain:SetActive(false)
    view.itemInfoP_btn_activate:SetActive(false)
    if data.slotState[index] == qualityUtil.EquipState.Enable_NotEnough then
        view.itemInfoP_btn_gain:SetActive(true)
        UIEventListener.Get(view.itemInfoP_btn_gain).onClick = function()
            information_controller:GainWayLayer()
        end
    elseif data.slotState[index] == qualityUtil.EquipState.Enable_Enough then
        view.itemInfoP_btn_equip:SetActive(true)
        UIEventListener.Get(view.itemInfoP_btn_equip).onClick = function()
            information_controller:equipSlotByIndex(index)
        end
    elseif data.slotState[index] == qualityUtil.EquipState.Active then
        view.itemInfoP_btn_activate:SetActive(true)
        UIEventListener.Get(view.itemInfoP_btn_activate).onClick = function()
            print("已激活..")
        end
    end
    UIEventListener.Get(view.itemInfoP_btn_back).onClick = function()
        view.itemInfoPanel:SetActive(false)
    end
    view.itemInfoPanel:SetActive(true)
end
--获得方式界面
function information_controller:GainWayLayer()
    view.itemInfoPanel:SetActive(false)
    if not isInitGainLayer then
        view:init_gainWayPanel()
        view.gainWayPanel:SetActive(false)
        isInitGainLayer = true
    end
    --返回
    UIEventListener.Get(view.gainWayP_btn_back).onClick = function()
        view.gainWayPanel:SetActive(false)
    end
    view.gainWayPanel:SetActive(true)
end
--点击晋阶按钮
function information_controller:upQualityBtn_onclick()
    --判断是否可以进阶
    local isCan_UpQuality = data:isCan_UpQuality()
    if isCan_UpQuality ~= 0 then
        UIToast.Show(isCan_UpQuality)
        return
    end
    --向服务器发送卡牌进阶消息消息
    Message_Manager:SendPB_UpQuality(data.cardId)
end
--进阶成功后刷新界面
function information_controller:upQuality_Success()
    self:show_upQuality_SuccessPanel()
end


--点击一键装备按钮  
function information_controller:equipAllCallBack()
    local slotList = {}
    for i=1,#data.slotState do
        if data.slotState[i] == qualityUtil.EquipState.Enable_Enough and data.upQualityNeedItems[i].num <= data.upQualityHaveItems[i].num then
            table.insert(slotList, i - 1)
        end
    end
    if #slotList == 0 then
        --提示：没有可激活插槽
        UIToast.Show(stringUtil:getString(20106))
    else
        Message_Manager:SendPB_EquipAllSlot(data.cardId, slotList)
    end
end


--根据插槽index装备物品
function information_controller:equipSlotByIndex(index)
    if data.slotState[index] == qualityUtil.EquipState.Enable_Enough and data.upQualityNeedItems[index].num <= data.upQualityHaveItems[index].num then
        Message_Manager:SendPB_EquipSlot(data.cardId, index-1)
        return
    end
    --提示：没有可激活插槽
    UIToast.Show(stringUtil:getString(20106))
end


--装备成功后刷新界面
function information_controller:equipSlot_Success()
    if view.itemInfoPanel then
        view.itemInfoPanel:SetActive(false)
    end
end

return information_controller