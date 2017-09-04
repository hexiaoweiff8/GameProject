local class = require("common/middleclass")
wnd_cardyc_controller = class("wnd_cardyc", wnd_base)


local view
local data
local information
local upSkill
local upSoldier
local upSynergy
local upLevel
local upStar
local redDotControl
local cardIndex
local currentTab
local tabBtn
local tabPanel
local tabControl
local _UIModel
local TabIndex = {
    Information = 1,
    Skill = 2,
    Soldier = 3,
    Synergy = 4
}

---
---设置要显示的卡牌
---
function wnd_cardyc_controller:ShowCard(cardId)
    cardIndex = cardModel:getCardIndex(cardId)
end


function wnd_cardyc_controller:OnShowDone()
    if not cardIndex or cardIndex == 0 then
        --printe("错误：未设置要显示的卡牌")
        --return
        cardIndex = 1

    end
    view = require("uiscripts/cardyc/wnd_cardyc_view")
    data = require("uiscripts/cardyc/wnd_cardyc_model")
    information = require("uiscripts/cardyc/information/information_controller")
    upSkill = require("uiscripts/cardyc/upSkill/upSkill_controller")
    upSoldier = require("uiscripts/cardyc/upSoldier/upSoldier_controller")
    upSynergy = require("uiscripts/cardyc/upSynergy/upSynergy_controller")
    upLevel = require("uiscripts/cardyc/upLevel/upLevel_controller")
    upStar = require("uiscripts/cardyc/upStar/upStar_controller")
    redDotControl = require("uiscripts/cardyc/redDotControl")

    --初始化view
    view:init_view(self)
    view:getView()

    if not data:getDatas(cardIndex) then
        return
    end

    information:init(self)
    upSkill:init(self)
    upSoldier:init(self)
    upSynergy:init(self)
    upLevel:init(self)
    upStar:init(self)

    _UIModel = UIModel(view.UIModelPosition)
    _UIModel:showCardModel(data.cardId)
    _UIModel:setDepth(1)
    self:init_tabPanel()
    self:init_redDot(data.cardId)
    self:refresh_leftCard_Data()
    UIEventListener.Get(view.btn_Back).onClick = function(go)
        self:Hide(0)
        ui_manager:go_back()
        --self:Destroy(0)
        RefreshManager.RefreshRedDot(self.wnd_base_id)
        --if ui_manager._shown_wnd_bases[WNDTYPE.Prefight] == nil then
        --    ui_manager:ShowWB(WNDTYPE.Prefight)
        --else
        --    ui_manager._shown_wnd_bases[WNDTYPE.Prefight]:Show()
        --end
        --if ui_manager._shown_wnd_bases[WNDTYPE.ui_equip] == nil then
        --    ui_manager:ShowWB(WNDTYPE.ui_equip)
        --else
        --    ui_manager._shown_wnd_bases[WNDTYPE.ui_equip]:Show()
        --end
    end
end
---
---重新打开时回调
---
function wnd_cardyc_controller:OnReOpenDone()
    if not cardIndex or cardIndex == 0 then
        printe("错误：未设置要显示的卡牌")
        return
    end
    self:refresh()
end




--刷新左侧界面
function wnd_cardyc_controller:refresh_leftCard_Data()
    view.cardNameLab.transform:GetComponent("UILabel").text = qualityUtil:getCardName_With_Quality(data.cardId, data.qualityLv)
    view.cardNameLab.transform:GetComponent("UILabel").color = qualityUtil:getColor_With_Quality(data.qualityLv)
    view.cardLevelLab.transform:GetComponent("UILabel").text = string.format("Lv.%d",data.cardLv)
    view.cardNum_Lab.transform:GetComponent("UILabel").text = string.format(stringUtil:getString(20702),data.cardFragment)
    view.trainCostLab.transform:GetComponent("UILabel").text = cardUtil:getTrainCost(data.cardId)
    --显示星级
    for i = 1, Const.MAX_STAR_LV do
       local starDark = view.cardStarsPanel.transform:Find("darkstar_"..i).gameObject
       local star = view.cardStarsPanel.transform:Find("star_"..i).gameObject
       starDark:SetActive(true)
       star:SetActive(true)
       if i > data.starLv then
           star:SetActive(false)
       end
    end
    

    UIEventListener.Get(view.btn_detail).onClick = function()
        currentTab = tabControl:getCurrentPanelIndex()
        information:show_cardDetailPanel(tabPanel[currentTab])
    end
    UIEventListener.Get(view.btn_upLevel).onClick = function()
        upLevel:show_UpLevel_Layer(cardIndex)
    end
    UIEventListener.Get(view.btn_upStar).onClick = function()
        upStar:show_UpStar_Layer()
    end
    UIEventListener.Get(view.btn_left).onClick = function()
        if cardIndex > 1 then
            cardIndex = cardIndex - 1
        else
            cardIndex = cardModel:getCardTblLength()
        end
        self:refresh()
    end
    UIEventListener.Get(view.btn_right).onClick = function()
        if cardIndex < cardModel:getCardTblLength() then
            cardIndex = cardIndex + 1
        else
            cardIndex = 1
        end
        self:refresh()
    end
end

---刷新右侧窗体
function wnd_cardyc_controller:refresh_TabBody_Data(tabIndex)
    if tabIndex == TabIndex.Information then
        information:Refresh()
    elseif tabIndex == TabIndex.Skill then
        upSkill:Refresh()
    elseif tabIndex == TabIndex.Soldier then
        upSoldier:Refresh()
    elseif tabIndex == TabIndex.Synergy then
        upSynergy:Refresh()
    end
end


--tab切换部分
function wnd_cardyc_controller:init_tabPanel()
    print("init_tabs")
    tabBtn = {view.btn_information,view.btn_skill,view.btn_soldier,view.btn_synergy}
    for i=1,#tabBtn do
        tabBtn[i].transform:Find("lab"):GetComponent("UILabel").text = stringUtil:getString(20019+i)
    end
    tabPanel = {view.informationBody_Panel,view.skillPanel,view.soldierPanel,view.synergyPanel}
    tabControl = TabsControl(tabBtn, tabPanel,self.refresh_TabBody_Data)
end



--初始化红点提示
function wnd_cardyc_controller:init_redDot(cardId)
    redDotControl:refresh_cardyc(cardId,cardIndex)
    --判断是否可以升级，并显示小红点
    view.btn_upLevel_redDot:SetActive(false)
    if redDotFlag.RD_UPLEVEL then
        view.btn_upLevel_redDot:SetActive(true)
    end

    --判断是否可以升星，并显示小红点
    view.btn_upStar_redDot:SetActive(false)
    if redDotFlag.RD_UPSTAR then
        view.btn_upStar_redDot:SetActive(true)
    end

    view.btn_soldier_redDot:SetActive(false)
    if redDotFlag.RD_SOLDIER then
        view.btn_soldier_redDot:SetActive(true)
    end


    view.btn_skill_redDot:SetActive(false)
    if redDotFlag.RD_SKILL then
        view.btn_skill_redDot:SetActive(true)
    end

    view.btn_information_redDot:SetActive(false)
    if redDotFlag.RD_INFORMATION then
        view.btn_information_redDot:SetActive(true)
    end

    view.btn_synergy_redDot:SetActive(false)
    if redDotFlag.RD_SYNERGY then
        view.btn_synergy_redDot:SetActive(true)
    end
end


--刷新
function wnd_cardyc_controller:refresh()
    if not data:getDatas(cardIndex) then
        return
    end
    self:init_redDot(data.cardId)
    if _UIModel:GetCurrentCardID() ~= data.cardId then
        _UIModel:showCardModel(data.cardId)
    end
    self:refresh_leftCard_Data()
    self:refresh_TabBody_Data(tabControl:getCurrentPanelIndex())

end

---刷新事件回调方法
function wnd_cardyc_controller:upStar_Refresh()
    self:refresh()
    upStar:upStar_Success()
end
function wnd_cardyc_controller:upLevel_Refresh()
    self:refresh()
    upLevel:upLevel_Success()
end
function wnd_cardyc_controller:upSkill_Refresh()
    self:refresh()
    upSkill:upSkill_Success()
end
function wnd_cardyc_controller:SkillPointReset_Refresh()
    self:refresh()
    upSkill:skillReset_Success()
end
function wnd_cardyc_controller:upSoldier_Refresh()
    self:refresh()
end
function wnd_cardyc_controller:upQuality_Refresh()
    self:refresh()
    information:upQuality_Success()
end
function wnd_cardyc_controller:equipSlot_Refresh()
    self:refresh()
    information:equipSlot_Success()
end
function wnd_cardyc_controller:upSynergy_Refresh()
    self:refresh()
    upSynergy:upSynergy_Success()
end

---
---界面销毁回调
---
function wnd_cardyc_controller:OnDestroyDone()

    information:OnDestroyDone()
    upSkill:OnDestroyDone()
    upSoldier:OnDestroyDone()
    upSynergy:OnDestroyDone()
    upLevel:OnDestroyDone()
    upStar:OnDestroyDone()
    redDotControl:OnDestroyDone()
    Memory.free("uiscripts/cardyc/wnd_cardyc_view")
    Memory.free("uiscripts/cardyc/wnd_cardyc_model")
    Memory.free("uiscripts/cardyc/information/information_controller")
    Memory.free("uiscripts/cardyc/upSkill/upSkill_controller")
    Memory.free("uiscripts/cardyc/upSoldier/upSoldier_controller")
    Memory.free("uiscripts/cardyc/upSynergy/upSynergy_controller")
    Memory.free("uiscripts/cardyc/upLevel/upLevel_controller")
    Memory.free("uiscripts/cardyc/upStar/upStar_controller")
    Memory.free("uiscripts/cardyc/redDotControl")
    view = nil
    data = nil
    information = nil
    upSkill = nil
    upSoldier = nil
    upSynergy = nil
    upLevel = nil
    upStar = nil
    redDotControl = nil
    cardIndex = nil
    currentTab = nil
    tabBtn = nil
    tabPanel = nil
    tabControl = nil
    _UIModel:Destroy()
    _UIModel = nil
end
---
---界面隐藏时重置要显示卡牌为空
---
function wnd_cardyc_controller:OnHideDone()
    cardIndex = 0
end
return wnd_cardyc_controller