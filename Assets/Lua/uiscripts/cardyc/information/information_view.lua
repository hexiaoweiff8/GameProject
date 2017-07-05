local information_view={}
local view 
function information_view:init_view(arg)
    view = arg

    self.informationBody_Panel = view.transform:Find("right/information").gameObject

     --卡牌信息部分
    -- refresh information body
    self.information_Panel = self.informationBody_Panel.transform:Find("information_panel").gameObject
    self.propertyTbl={} --注意顺序
    table.insert( self.propertyTbl, self.information_Panel.transform:Find("property/health/value").gameObject )--生命
    table.insert( self.propertyTbl, self.information_Panel.transform:Find("property/damagePSecond/value").gameObject )--秒伤
    table.insert( self.propertyTbl, self.information_Panel.transform:Find("property/attack/value").gameObject )--火力
    table.insert( self.propertyTbl, self.information_Panel.transform:Find("property/team/value").gameObject )--队伍
    table.insert( self.propertyTbl, self.information_Panel.transform:Find("property/defence/value").gameObject )--防御
    table.insert( self.propertyTbl, self.information_Panel.transform:Find("property/aimGeneralType/value").gameObject )--目标
    table.insert( self.propertyTbl, self.information_Panel.transform:Find("property/shotDistance/value").gameObject )--射程
    table.insert( self.propertyTbl, self.information_Panel.transform:Find("property/attackType/value").gameObject )--范围
    self.infoP_propTip = self.information_Panel.transform:Find("property/propTip").gameObject
    self.infoP_propTipLab = self.information_Panel.transform:Find("property/propTip/lab").gameObject


    --兵种克制
    self.suppressPanel = self.information_Panel.transform:Find("suppressPanel").gameObject
    self.suppressP_armyName =  self.suppressPanel.transform:Find("armyName").gameObject--兵种图
    self.suppressP_currentTypeSp =  self.suppressPanel.transform:Find("currentTypeSp").gameObject--兵种图
    self.suppressP_beSupSp =  self.suppressPanel.transform:Find("beSuppressSp").gameObject
    self.suppressP_SupSp =  self.suppressPanel.transform:Find("suppressSp").gameObject
    self.suppressP_beSupLab =  self.suppressPanel.transform:Find("beSuppressLab").gameObject
    self.suppressP_SupLab =  self.suppressPanel.transform:Find("suppressLab").gameObject


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
end

function information_view:init_cardDetailView()
    self.cardDetail = view.transform:Find("right/cardDetail").gameObject
    self.scrollView = self.cardDetail.transform:Find("property").gameObject
    self.cardDetail_Tip = self.cardDetail.transform:Find("property/propTip").gameObject
    self.cardDetail_TipLab = self.cardDetail.transform:Find("property/propTip/lab").gameObject
    self.cardDetailTbl={}
    self.cardDetail_maskPanel = self.cardDetail.transform:Find("MaskPanle").gameObject

end



function information_view:init_UpQuality_SuccessPanel()
    self.upQuality_SuccessP = GameObjectExtension.InstantiateFromPacket("ui_cardyc", "adSuccess",  self.gameObject)
    self.upQualitySP_clickPanel = self.upQuality_SuccessP.transform:Find("clickPanel").gameObject
    self.upQualitySP_titleL = self.upQuality_SuccessP.transform:Find("title_Lab").gameObject
    for i=1,#qualityUtil.qualityPropName do
        self["upQualitySP_propSp_"..i] = self.upQuality_SuccessP.transform:Find("upsSp_"..i).gameObject
        self["upQualitySP_propName_"..i] = self.upQuality_SuccessP.transform:Find("desLab_"..i).gameObject
        self["upQualitySP_propBeValue_"..i] = self.upQuality_SuccessP.transform:Find("Label_a"..i).gameObject
        self["upQualitySP_propAfValue_"..i] = self.upQuality_SuccessP.transform:Find("Label_b"..i).gameObject
    end
    
end

function information_view:init_itemInfoPanel()
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

function information_view:init_gainWayPanel()
    self.gainWayPanel = GameObjectExtension.InstantiateFromPacket("ui_cardyc", "gainLayer",  self.gameObject)
    self.gainWayP_btn_back = self.gainWayPanel.transform:Find("Btn_backSp").gameObject 

end

return information_view