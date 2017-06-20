local wnd_cardyc_view={}
local data
local view 
function wnd_cardyc_view:init_view(arg)
    view = arg
    data = arg.data
end

function wnd_cardyc_view:getView()

    
    --leftcardPanel
    self.leftPanel = view.transform:Find("left").gameObject
    self.btn_detail = self.leftPanel.transform:Find("card/Btn_details").gameObject
    self.btn_upStar = self.leftPanel.transform:Find("Btn_upStar").gameObject
    self.btn_upStar_redDot = self.leftPanel.transform:Find("Btn_upStar/redDot").gameObject
    self.btn_upLevel = self.leftPanel.transform:Find("Btn_upLevel").gameObject
    self.btn_upLevel_redDot = self.leftPanel.transform:Find("Btn_upLevel/redDot").gameObject
    self.btn_left = self.leftPanel.transform:Find("Btn_left").gameObject
    self.btn_right = self.leftPanel.transform:Find("Btn_right").gameObject
    --cardPanel
    self.cardPanel = self.leftPanel.transform:Find("card").gameObject
    self.cardImgSp = self.cardPanel.transform:Find("cardImg_Sp").gameObject--卡牌图
    self.cardNameLab = self.cardPanel.transform:Find("cardName_Lab").gameObject --卡牌名+品质
    self.cardLevelLab = self.cardPanel.transform:Find("cardLevel_Lab").gameObject--卡牌等级
    self.cardNum_Lab = self.cardPanel.transform:Find("cardNum_lab").gameObject --卡牌数量
    self.trainCostLab = self.cardPanel.transform:Find("costBgSp/trainCost_Lab").gameObject--卡牌费用
    self.cardStarsPanel = self.cardPanel.transform:Find("Stars_widget").gameObject --星星panel


    --获取右侧按钮
    self.btnTabPanel = view.transform:Find("Btn_tab").gameObject
    self.btn_information = self.btnTabPanel.transform:Find("Btn_information").gameObject
    self.btn_information_redDot = self.btnTabPanel.transform:Find("Btn_information/redDot").gameObject
    self.btn_skill = self.btnTabPanel.transform:Find("Btn_skill").gameObject
    self.btn_skill_redDot = self.btnTabPanel.transform:Find("Btn_skill/redDot").gameObject
    self.btn_soldier = self.btnTabPanel.transform:Find("Btn_soldier").gameObject
    self.btn_soldier_redDot = self.btnTabPanel.transform:Find("Btn_soldier/redDot").gameObject
    self.btn_synergy = self.btnTabPanel.transform:Find("Btn_synergy").gameObject
    self.btn_synergy_redDot = self.btnTabPanel.transform:Find("Btn_synergy/redDot").gameObject

    self.soldierPanel = view.transform:Find("right/soldier").gameObject
    self.synergyPanel = view.transform:Find("right/synergy").gameObject
    self.informationBody_Panel = view.transform:Find("right/information").gameObject
    self.skillPanel = view.transform:Find("right/skill").gameObject
end



function wnd_cardyc_view:init_itemHead(parent,name)
    -- body
    if name == "itemHead_1" then
        self.itemHead_1={}
    elseif name == "itemHead_2" then
        self.itemHead_2={}
    elseif name == "itemHead_3" then
        self.itemHead_3={}
    elseif name == "itemHead_4" then
        self.itemHead_4={}
    end
    self[name].itemhead = GameObjectExtension.InstantiateFromPacket("ui_cardyc", "armyMedalPanel", parent).gameObject
    self[name].itemhead_Sprite = self[name].itemhead.transform:Find("Sprite").gameObject
    self[name].itemhead_lockSp = self[name].itemhead.transform:Find("lockSp").gameObject
    self[name].itemhead_itemSp = self[name].itemhead.transform:Find("itemSp").gameObject
    self[name].itemhead_plusSp = self[name].itemhead.transform:Find("plusSp").gameObject
    self[name].itemhead_numLab = self[name].itemhead.transform:Find("label").gameObject
end





return wnd_cardyc_view