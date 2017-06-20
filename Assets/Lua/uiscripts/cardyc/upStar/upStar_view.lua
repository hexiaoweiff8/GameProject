local upStar_view={}
local view 
function upStar_view:init_view(arg)
    view = arg
    
end

function upStar_view:init_UpStarPanel()
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

    self.upStarP_maxStarP = self.upStarPanel.transform:Find("maxStar").gameObject
end

function upStar_view:init_UpStar_SuccessPanel()
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

return upStar_view