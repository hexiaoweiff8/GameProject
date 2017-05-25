local data = require("uiscripts/wnd_cardyc_model")
wnd_cardyc_view={}

local view 
function wnd_cardyc_view:init_view(arg)
    view = arg
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

    --获取右侧Panel
    self.rightPanel = view.transform:Find("right").gameObject
    self.informationBody_Panel = self.rightPanel.transform:Find("information").gameObject
    self.skillPanel = self.rightPanel.transform:Find("skill").gameObject
    self.soldierPanel = self.rightPanel.transform:Find("soldier").gameObject
    self.synergyPanel = self.rightPanel.transform:Find("synergy").gameObject


    --卡牌信息部分
    -- refresh information body
    self.information_Panel = self.informationBody_Panel.transform:Find("information_panel").gameObject
    self.infoP_liveL = self.information_Panel.transform:Find("property/p1/p1_value").gameObject--生命
    -- local msLab = go:Find("ms_Lab").gameObject --秒伤
    -- local powerLab = go:Find("power_Lab").gameObject --火力
    -- local teamLab = go:Find("team_Lab").gameObject --队伍armysum
    -- local defLab = go:Find("def_Lab").gameObject --防御
    -- local targetLab = go:Find("aimGeneralType_Lab").gameObject --目标
    -- local scLab = go:Find("sc_Lab").gameObject --射程
    -- local rangeLab = go:Find("range_Lab").gameObject --范围attacktype

    --兵种克制
    self.KZPanel = self.information_Panel.transform:Find("armykzPanel").gameObject
    self.KZP_TypeSp =  self.KZPanel.transform:Find("armyTypeSp").gameObject--兵种图
    self.KZP_TypeL =  self.KZPanel.transform:Find("desArmyTypeSp").gameObject
    self.KZP_TypeR =  self.KZPanel.transform:Find("addArmyTypeSp").gameObject

    --进阶部分
    self.upQuality_Panel = self.informationBody_Panel.transform:Find("upQuality_panel").gameObject
    self.upQualityP_btnUpQ = self.upQuality_Panel.transform:Find("upQuality_Sp").gameObject
    self.upQualityP_btnUpQ_Lab = self.upQuality_Panel.transform:Find("upQuality_Sp/upQuality_Lab").gameObject
    self.upQualityP_btnUpQ_redDot = self.upQuality_Panel.transform:Find("upQuality_Sp/redDot").gameObject
    self.upQualityP_btnEpuipAll = self.upQuality_Panel.transform:Find("equipAll_Sp").gameObject
    self.upQualityP_btnEpuipAll_Lab = self.upQuality_Panel.transform:Find("equipAll_Sp/equipAll_Lab").gameObject
    self.upQualityP_btnEpuipAll_redDot = self.upQuality_Panel.transform:Find("equipAll_Sp/redDot").gameObject
    self.upQualityP_Cost = self.upQuality_Panel.transform:Find("upQuality_Cost").gameObject
    self.upQualityP_Cost_Sp = self.upQuality_Panel.transform:Find("upQuality_Cost/cost_Sp").gameObject
    self.upQualityP_Cost_Lab = self.upQuality_Panel.transform:Find("upQuality_Cost/cost_Lab").gameObject
    self.maxUpQuality_Panel = self.informationBody_Panel.transform:Find("maxQuality_panel").gameObject
    self.maxUpQualityP_Lab = self.maxUpQuality_Panel.transform:Find("maxQuality_label").gameObject

    --技能部分
    self.skillP_btnResetPoint = self.skillPanel.transform:Find("bgSp/pointReset_Sp").gameObject
    self.skillP_pointLab = self.skillPanel.transform:Find("bgSp/pointNum_Lab").gameObject


    --兵员部分
    self.soldierP_cardNameL = self.soldierPanel.transform:Find("cardName_Lab").gameObject --卡牌名
    self.soldierP_badgeNameL = self.soldierPanel.transform:Find("badgeName_Lab").gameObject--兵牌
    self.soldierP_cardSp = self.soldierPanel.transform:Find("soldier_Sp").gameObject--卡牌图
    self.soldierP_badgeSp = self.soldierPanel.transform:Find("badge_Sp").gameObject--卡牌图
    self.soldierP_LvProLab = self.soldierPanel.transform:Find("lvProgress_Lab").gameObject
    self.soldierP_desLab = self.soldierPanel.transform:Find("des_Lab").gameObject
    self.soldierP_cardNeedL = self.soldierPanel.transform:Find("neednumLab_1").gameObject
    self.soldierP_badgeNeednumL = self.soldierPanel.transform:Find("neednumLab_2").gameObject
    self.soldierP_cardHavaLab = self.soldierPanel.transform:Find("numLab_1").gameObject
    self.soldierP_badgeHaveLab = self.soldierPanel.transform:Find("numLab_2").gameObject
    self.soldierP_btnUpSoldier = self.soldierPanel.transform:Find("Btn_soldierUpLv").gameObject
    self.soldierP_btnUpSoldier_Lab=self.soldierPanel.transform:Find("Btn_soldierUpLv/lab").gameObject
    self.soldierP_btnUpSoldier_redDot=self.soldierPanel.transform:Find("Btn_soldierUpLv/redDot").gameObject

    --协同部分
    self.synergyP_tipLab = self.synergyPanel.transform:Find("atbAddPanel/tipLab").gameObject --加成提示信息
    self.synergyP_addProperty_1 = self.synergyPanel.transform:Find("atbAddPanel/addProperty_1").gameObject --加成属性1
    self.synergyP_addProperty_2 = self.synergyPanel.transform:Find("atbAddPanel/addProperty_2").gameObject --加成属性2
    self.synergyP_addProperty_3 = self.synergyPanel.transform:Find("atbAddPanel/addProperty_3").gameObject --加成属性3

end

function wnd_cardyc_view:init_Uplevel_Panel()
    self.upLevelPanel = GameObjectExtension.InstantiateFromPacket("ui_cardyc", "upLevelPanel",self.gameObject).gameObject
    self.btn_upLevelOne = self.upLevelPanel.transform:Find("Btn_upLevelOne").gameObject
    self.btn_upLevelTen = self.upLevelPanel.transform:Find("Btn_upLevelTen").gameObject
    self.btn_upLevelBack = self.upLevelPanel.transform:Find("Btn_backSp").gameObject

    self.expProBar = self.upLevelPanel.transform:Find("expProgressBar_Sp").gameObject
    self.expProLab = self.upLevelPanel.transform:Find("expProgressBar_Sp/expProLab").gameObject
    self.uiSlide = self.expProBar.transform:GetComponent("UISlider").gameObject
    self.cardLevLab = self.upLevelPanel.transform:Find("allotExp_Lab").gameObject
end

function wnd_cardyc_view:init_synergyItem(parent,name)
    -- body
    if name == "synergyItem_1" then
        self.synergyItem_1={}
    elseif name == "synergyItem_2" then
        self.synergyItem_2={}
    elseif name == "synergyItem_3" then
        self.synergyItem_3={}
    elseif name == "synergyItem_4" then
        self.synergyItem_4={}
    end
    self[name].synergyItem = GameObjectExtension.InstantiateFromPacket("ui_cardyc", "itemPanel", parent).gameObject
    self[name].synergyItem_Sp = self[name].synergyItem.transform:Find("Sprite").gameObject
    self[name].synergyItem_redDot = self[name].synergyItem.transform:Find("redDot").gameObject
    self[name].synergyItem_plusSp = self[name].synergyItem.transform:Find("plusSp").gameObject
    self[name].synergyItem_upSp = self[name].synergyItem.transform:Find("upSp").gameObject
    self[name].synergyItem_nowPropL = self[name].synergyItem.transform:Find("Container/atdAddLab").gameObject
    self[name].synergyItem_nextPropL = self[name].synergyItem.transform:Find("Container/atdAddNextLab").gameObject
    
end

function wnd_cardyc_view:init_upSynergyPanel()
    self.upSynergyP = GameObjectExtension.InstantiateFromPacket("ui_cardyc", "xtupLayer",  self.gameObject)
    self.upSynergyP_title = self.upSynergyP.transform:Find("title_Lab").gameObject

    self.upSynergyP_cardNameL = self.upSynergyP.transform:Find("xtLab").gameObject
    self.upSynergyP_desL = self.upSynergyP.transform:Find("tipLab").gameObject
    self.upSynergyP_coinL = self.upSynergyP.transform:Find("costNameLab_1").gameObject
    self.upSynergyP_goldL = self.upSynergyP.transform:Find("costNameLab_2").gameObject
    self.upSynergyP_coinSp = self.upSynergyP.transform:Find("costSp_1").gameObject
    self.upSynergyP_goldSp = self.upSynergyP.transform:Find("costSp_2").gameObject
    self.upSynergyP_coinNeedNumL = self.upSynergyP.transform:Find("neednumLab_1").gameObject
    self.upSynergyP_goldNeedNumL = self.upSynergyP.transform:Find("neednumLab_2").gameObject
    self.upSynergyP_coinHaveNumL = self.upSynergyP.transform:Find("numLab_1").gameObject
    self.upSynergyP_goldHaveNumL = self.upSynergyP.transform:Find("numLab_2").gameObject

    self.upSynergyP_btnBack = self.upSynergyP.transform:Find("Btn_backSp").gameObject
    self.upSynergyP_btnOk = self.upSynergyP.transform:Find("btn_ok").gameObject
    self.upSynergyP_btnOkL = self.upSynergyP.transform:Find("btn_ok/Label").gameObject
    self.upSynergyP_btnCancle = self.upSynergyP.transform:Find("btn_cancle").gameObject

end

function wnd_cardyc_view:init_CardHead(parent,name)
    
    if name == "upLevelP_cardhead" then  
        self.upLevelP_cardhead={}
    elseif name == "upStarP_Before_cardhead" then 
        self.upStarP_Before_cardhead={}
    elseif name == "upStarP_After_cardhead" then 
        self.upStarP_After_cardhead={}
    elseif name == "upStarSP_Before_cardhead" then 
        self.upStarSP_Before_cardhead={}
    elseif name == "upStarSP_After_cardhead" then 
        self.upStarSP_After_cardhead={}
    elseif name == "upQualitySP_Before_cardhead" then 
        self.upQualitySP_Before_cardhead={}
    elseif name == "upQualitySP_After_cardhead" then 
        self.upQualitySP_After_cardhead={}
    elseif name == "resetSPt_cardhead" then 
        self.resetSPt_cardhead={}
    elseif name == "upSoldier_cardhead" then 
        self.upSoldier_cardhead={}
    elseif name == "upSynergy_cardhead" then 
        self.upSynergy_cardhead={}
    end
    self[name].cardhead = GameObjectExtension.InstantiateFromPacket("ui_cardyc", "cardhead", parent).gameObject
    self[name].cardhead_bg = self[name].cardhead.transform:Find("bg").gameObject
    self[name].cardhead_imgSp = self[name].cardhead.transform:Find("img_Sp").gameObject--卡牌图
    self[name].cardhead_lv_bg = self[name].cardhead.transform:Find("lv_bg").gameObject--等级
    self[name].cardhead_lv_Lab = self[name].cardhead.transform:Find("lv_bg/lv_Lab").gameObject --等级
    self[name].cardhead_medalSp = self[name].cardhead.transform:Find("medal_Sp").gameObject--军阶图
    self[name].cardhead_starPanel = self[name].cardhead.transform:Find("StarPanel").gameObject   
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

function wnd_cardyc_view:init_skillItem(parent,name)
    -- body
    if name == "skillFrame_1" then
        self.skillFrame_1={}
    elseif name == "skillFrame_2" then
        self.skillFrame_2={}
    elseif name == "skillFrame_3" then
        self.skillFrame_3={}
    elseif name == "skillFrame_4" then
        self.skillFrame_4={}
    elseif name == "skillFrame_5" then
        self.skillFrame_5={}
    elseif name == "skillInfoP_skillFrame" then
        self.skillInfoP_skillFrame={}
    end
    self[name].skillItem = GameObjectExtension.InstantiateFromPacket("ui_cardyc", "skillFrame", parent).gameObject
    self[name].skillItem_bg = self[name].skillItem.transform:Find("bg").gameObject --
    self[name].skillItem_lv_bg = self[name].skillItem.transform:Find("bg/lv_bg").gameObject --
    self[name].skillItem_imgSp = self[name].skillItem.transform:Find("img_Sp").gameObject --技能图
    self[name].skillItem_name_Lab = self[name].skillItem.transform:Find("name_Lab").gameObject --技能名
    self[name].skillItem_lv_Lab = self[name].skillItem.transform:Find("lv_Lab").gameObject --
    self[name].skillItem_redDot = self[name].skillItem.transform:Find("redDot").gameObject --
    self[name].skillItem_bklockSp = self[name].skillItem.transform:Find("bklockSp").gameObject
    self[name].skillItem_bklockSp_Sprite = self[name].skillItem_bklockSp.transform:Find("Sprite").gameObject
    self[name].skillItem_bklockSp_LockSp = self[name].skillItem_bklockSp.transform:Find("lockSp").gameObject
end

function wnd_cardyc_view:init_skillPointResetPanels()
    -- body
    self.sPtRPanel = GameObjectExtension.InstantiateFromPacket("ui_cardyc", "sPtReset",  self.gameObject)
    self.sPtRP_titleL = self.sPtRPanel.transform:Find("title_Lab").gameObject
    self.sPtRP_desL = self.sPtRPanel.transform:Find("des_Lab").gameObject
    self.sPtRP_btnBack = self.sPtRPanel.transform:Find("Btn_backSp").gameObject
    self.sPtRP_norResetCostL = self.sPtRPanel.transform:Find("Sprite/comCostNumLab")
    self.sPtRP_perResetCostL = self.sPtRPanel.transform:Find("Sprite/perCostNumLab")
    self.sPtRP_norResetB = self.sPtRPanel.transform:Find("Btn_comReset").gameObject
    self.sPtRP_perResetB = self.sPtRPanel.transform:Find("Btn_perReset").gameObject

end

function wnd_cardyc_view:init_skillInfoPanel()
    -- body
    self.skillInfoPanel = GameObjectExtension.InstantiateFromPacket("ui_cardyc", "skillItemUpLayer",  self.gameObject)
    self.skillInfoP_BtnBack = self.skillInfoPanel.transform:Find("Btn_backSp").gameObject
    self.skillInfoP_lv_Lab = self.skillInfoPanel.transform:Find("lv_Lab").gameObject
    self.skillInfoP_lvProLab = self.skillInfoPanel.transform:Find("lvProgress_Lab").gameObject
    self.skillInfoP_sdes_Lab = self.skillInfoPanel.transform:Find("skilldes_Lab").gameObject--说明描述
    self.skillInfoP_btn_unlock = self.skillInfoPanel.transform:Find("Btn_unLockSp").gameObject 
    self.skillInfoP_btn_unlock_Label = self.skillInfoP_btn_unlock.transform:Find("unlock_Lab").gameObject
    self.skillInfoP_btn_upLv = self.skillInfoPanel.transform:Find("Btn_updateSp").gameObject
    self.skillInfoP_costLab = self.skillInfoP_btn_upLv.transform:Find("skillPtNum_Lab").gameObject--
end

function wnd_cardyc_view:init_UpStarPanel()
    -- body 
    self.upStarPanel = GameObjectExtension.InstantiateFromPacket("ui_cardyc", "upStarPanel",  self.gameObject)
    self.upStarP_skillPanel = self.upStarPanel.transform:Find("skillPanel").gameObject
    self.upStarP_skillP_NameLab = self.upStarPanel.transform:Find("skillPanel"):Find("skillNameLab").gameObject

    self.upStarP_badgeLab = self.upStarPanel.transform:Find("costNameLab_1").gameObject
    self.upStarP_badgeSp = self.upStarPanel.transform:Find("costSp_1").gameObject
    self.upStarP_badgeNeedNumL = self.upStarPanel.transform:Find("neednumLab_1").gameObject
    self.upStarP_badgeHaveNumL = self.upStarPanel.transform:Find("numLab_1").gameObject

    self.upStarP_cardNameLab = self.upStarPanel.transform:Find("costNameLab_2").gameObject
    self.upStarP_cardSp = self.upStarPanel.transform:Find("costSp_2").gameObject
    self.upStarP_cardNeedNumL = self.upStarPanel.transform:Find("neednumLab_2").gameObject
    self.upStarP_cardhavaNumL = self.upStarPanel.transform:Find("numLab_2").gameObject

    self.upStarP_btn_back = self.upStarPanel.transform:Find("Btn_backSp").gameObject
    self.upStarP_btn_sx = self.upStarPanel.transform:Find("Btn_sx").gameObject
end

function wnd_cardyc_view:init_UpStar_SuccessPanel()
    self.upStarSuccessPanel = GameObjectExtension.InstantiateFromPacket("ui_cardyc", "upStarSuccess",self.gameObject)
    self.upStarSP_titleL=self.upStarSuccessPanel.transform:Find("title_Lab").gameObject
    self.upStarSP_live_nameL=self.upStarSuccessPanel.transform:Find("property/livegrow/nameLab").gameObject
    self.upStarSP_live_valueBL=self.upStarSuccessPanel.transform:Find("property/livegrow/value_1").gameObject
    self.upStarSP_live_valueAL=self.upStarSuccessPanel.transform:Find("property/livegrow/value_2").gameObject

    self.upStarSP_attack_nameL=self.upStarSuccessPanel.transform:Find("property/attackgrow/nameLab").gameObject
    self.upStarSP_attack_valueBL=self.upStarSuccessPanel.transform:Find("property/attackgrow/value_1").gameObject
    self.upStarSP_attack_valueAL=self.upStarSuccessPanel.transform:Find("property/attackgrow/value_2").gameObject

    self.upStarSP_defense_nameL=self.upStarSuccessPanel.transform:Find("property/defensegrow/nameLab").gameObject
    self.upStarSP_defense_valueBL=self.upStarSuccessPanel.transform:Find("property/defensegrow/value_1").gameObject
    self.upStarSP_defense_valueAL=self.upStarSuccessPanel.transform:Find("property/defensegrow/value_2").gameObject

    self.upStarSP_clickP=self.upStarSuccessPanel.transform:Find("clickPanel").gameObject

end

function wnd_cardyc_view:init_UpQuality_SuccessPanel()
    self.upQuality_SuccessP = GameObjectExtension.InstantiateFromPacket("ui_cardyc", "adSuccess",  self.gameObject)
    self.upQualitySP_clickPanel = self.upQuality_SuccessP.transform:Find("clickPanel").gameObject
    self.upQualitySP_titleL = self.upQuality_SuccessP.transform:Find("title_Lab").gameObject
    for i=1,#data.qualityPropName do
        self["upQualitySP_propSp_"..i] = self.upQuality_SuccessP.transform:Find("upsSp_"..i).gameObject
        self["upQualitySP_propName_"..i] = self.upQuality_SuccessP.transform:Find("desLab_"..i).gameObject
        self["upQualitySP_propBeValue_"..i] = self.upQuality_SuccessP.transform:Find("Label_a"..i).gameObject
        self["upQualitySP_propAfValue_"..i] = self.upQuality_SuccessP.transform:Find("Label_b"..i).gameObject
    end
    
end


function wnd_cardyc_view:init_itemInfoPanel()
    self.itemInfoPanel = GameObjectExtension.InstantiateFromPacket("ui_cardyc", "medalItemPanel", self.gameObject)
    self.itemInfoP_itemImg = self.itemInfoPanel.transform:Find("ItemBk/itemImg_Sp").gameObject--物品图
    self.itemInfoP_itemNameLab =self.itemInfoPanel.transform:Find("itemName_Lab").gameObject --物品名
    self.itemInfoP_addDesLab = self.itemInfoPanel.transform:Find("addDes_Lab").gameObject --属性加成
    self.itemInfoP_needLab = self.itemInfoPanel.transform:Find("Sprite/need_Lab").gameObject --需要
    self.itemInfoP_haveLab = self.itemInfoPanel.transform:Find("Sprite/xy_Lab").gameObject--现有
    self.itemInfoP_btn_equip = self.itemInfoPanel.transform:Find("Btn_equip").gameObject  --装备
    self.itemInfoP_btn_gain = self.itemInfoPanel.transform:Find("Btn_gain").gameObject--获得
    self.itemInfoP_btn_activate = self.itemInfoPanel.transform:Find("Btn_activate").gameObject --已激活
    self.itemInfoP_btn_back = self.itemInfoPanel.transform:Find("Btn_backSp").gameObject
    self.itemInfoP_needPanel = self.itemInfoPanel.transform:Find("Sprite").gameObject
end

function wnd_cardyc_view:init_gainWayPanel()
    self.gainWayPanel = GameObjectExtension.InstantiateFromPacket("ui_cardyc", "gainLayer",  self.gameObject)
    self.gainWayP_btn_back = self.gainWayPanel.transform:Find("Btn_backSp").gameObject 

end

function wnd_cardyc_view:init_cardycPanel()
    -- view.bgFramePanel = view.transform:Find("bgframe"):GetComponent("UIWidget")
    -- view.btn_back = view.transform:Find("bgframe/Btn_back").gameObject
    
    -- view.rightPanel = view.transform:Find("right"):GetComponent("UIWidget")
    -- view.btnTabPanel = view.transform:Find("Btn_tab"):GetComponent("UIWidget")
    
    -- view.btn_information = view.btnTabPanel.transform:Find("Btn_information").gameObject
    -- view.btn_skill = view.btnTabPanel.transform:Find("Btn_skill").gameObject
    -- view.btn_soldier = view.btnTabPanel.transform:Find("Btn_soldier").gameObject
    -- view.btn_synergy = view.btnTabPanel.transform:Find("Btn_synergy").gameObject
    -- view.informationBody_Panel = view.rightPanel.transform:Find("information").gameObject
    -- view.skillPanel = view.rightPanel.transform:Find("skill").gameObject
    -- view.soldierPanel = view.rightPanel.transform:Find("soldier").gameObject
    -- view.synergyPanel = view.rightPanel.transform:Find("synergy").gameObject


    -- view.upStarPanel = nil  --升星界面
    view.upLevelPanel = nil  --升级界面
    -- view.skill_Information_Panel = nil --技能详细信息界面
    -- view.sPtRPanel = nil --重置技能界面


    view.isInitUpLvLayer = false
    -- view.isInitUpStarLayer = false
    -- view.isSlotInit = false
    -- view.isfiveSIinit = false
    -- view.isAttrItemInit = false
    -- view.isInitCardHead = false
    -- view.isInitxtLayer = false
    -- view.isInitMedalItemLayer = false--
    -- view.initGainLayer  = false--是否显示过获取方式界面    
    -- view.isInitAmSLayer = false--晋阶成功界面
    
    -- view.children = {view.btn_information,view.btn_skill,view.btn_soldier,view.btn_synergy}
    -- view.bodyNodes = {view.informationBody_Panel,view.skillPanel,view.soldierPanel,view.synergyPanel}
    -- view.tabTable = {{view.btn_information, view.informationBody_Panel},
    --                 {view.btn_skill, view.skillPanel},
    --                 {view.btn_soldier, view.soldierPanel},
    --                 {view.btn_synergy, view.synergyPanel}}
    -- for i=1,#view.children do               --初始化tab按钮的文字显示
    --     local tabLab =  view.children[i].transform:Find("lab").gameObject
    --     tabLab.text = sdata_UILiteral:GetV(sdata_UILiteral.I_Literal, 20019+i) 
    -- end
    -- view.tabIndex = TABLE_INDEX.INFORMATION
end 

return wnd_cardyc_view