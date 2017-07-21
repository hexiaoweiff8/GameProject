local class = require("common/middleclass")
wnd_cardyc_controller = class("wnd_cardyc", wnd_base)
local view = require("uiscripts/cardyc/wnd_cardyc_view")
local data = require("uiscripts/cardyc/wnd_cardyc_model")


local information = require("uiscripts/cardyc/information/information_controller")
local upSkill = require("uiscripts/cardyc/upSkill/upSkill_controller")
local upSoldier = require("uiscripts/cardyc/upSoldier/upSoldier_controller")
local upSynergy = require("uiscripts/cardyc/upSynergy/upSynergy_controller")
local upLevel = require("uiscripts/cardyc/upLevel/upLevel_controller")
local upStar = require("uiscripts/cardyc/upStar/upStar_controller")

local TabControl = require("uiscripts/tabsControl")




local cardIndex = 1
local currentTab = 0
local tabBtn
local tabPanel
local tabControl

function wnd_cardyc_controller:OnShowDone()
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

    self:init_tabPanel()

    self:init_redDot()
    self:refresh_leftCard_Data()
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
        information_controller:show_cardDetailPanel(tabPanel[currentTab])
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
            self:refresh()
        else
            --无更多卡牌
            UIToast.Show(stringUtil:getString(20701), nil, UIToast.ShowType.Upwards)
        end
    end
    UIEventListener.Get(view.btn_right).onClick = function()
        if cardIndex < data:getCardNum() then
            cardIndex = cardIndex + 1
            self:refresh()
        else
            --无更多卡牌
            UIToast.Show(stringUtil:getString(20701), nil, UIToast.ShowType.Upwards)
        end
    end
end

function wnd_cardyc_controller:refresh_TabBody_Data(tabIndex)
    -- body
    if tabIndex == 1 then
        information:Refresh()

    elseif tabIndex == 2 then
        upSkill:Refresh()

    elseif tabIndex == 3 then
        upSoldier:Refresh()

    elseif tabIndex == 4 then
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
    tabControl = TabControl(tabBtn, tabPanel,self.refresh_TabBody_Data)
end



--初始化红点提示
function wnd_cardyc_controller:init_redDot()
    redDotControl:refresh_cardyc(cardIndex)
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
    self:init_redDot()
    self:refresh_leftCard_Data()
    self:refresh_TabBody_Data(tabControl:getCurrentPanelIndex())

end


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