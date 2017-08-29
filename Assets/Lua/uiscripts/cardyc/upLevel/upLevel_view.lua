local upLevel_view={}
local view 
function upLevel_view:init_view(arg)
    view = arg
    
end

function upLevel_view:init_Uplevel_Panel()
    self.upLevelPanel = GameObjectExtension.InstantiateFromPacket("ui_cardyc", "upLevelPanel",view.gameObject).gameObject
    self.btn_upLevelP = self.upLevelPanel.transform:Find("Btn_upLevel").gameObject
    self.btn_upLevelOne = self.upLevelPanel.transform:Find("Btn_upLevel/Btn_upLevelOne").gameObject
    self.btn_upLevelTen = self.upLevelPanel.transform:Find("Btn_upLevel/Btn_upLevelTen").gameObject
    self.btn_maxLevelP = self.upLevelPanel.transform:Find("maxLevel").gameObject
    self.btn_upLevelBack = self.upLevelPanel.transform:Find("Btn_backSp").gameObject

    self.expProBar = self.upLevelPanel.transform:Find("expProgressBar_Sp").gameObject
    self.expProLab = self.upLevelPanel.transform:Find("expProgressBar_Sp/expProLab").gameObject
    self.uiSlide = self.expProBar.transform:GetComponent("UISlider").gameObject
    self.cardLevLab = self.upLevelPanel.transform:Find("allotExp_Lab").gameObject
end

return upLevel_view