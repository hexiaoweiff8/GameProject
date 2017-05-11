--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local wnd_NewCardClass = class(wnd_base)
    wnd_NewCard = nil


function wnd_NewCardClass:Start()
	wnd_NewCard = self
	self:Init(WND.NewCard)
end

function wnd_NewCardClass:OnNewInstance()
    self:BindUIEvent("newcard_panel/card_widget",UIEventType.Click,"OnClick")

    self.NewCardPanel = self.instance:FindWidget("newcard_panel")
    self.NewCardPanel:SetActive(false)
    self.HeroBG = self.NewCardPanel:FindChild("hero_bg")

    self.newCard = self.NewCardPanel:FindChild("")

end

function wnd_NewCardClass:OnClick()
    self.NewCardPanel:SetActive(false)
    self:Hide()
end

function wnd_NewCardClass:SetHeroID(HeroID)
    self.CardID = HeroID
end

function wnd_NewCardClass:OnShowDone()
    self.NewCardPanel:SetActive(true)
    local heroData = SData_Hero.GetHero(self.CardID) 

    self.NewCardPanel:SetActive(true)
    local NewPanel = self.NewCardPanel:GetComponent(CMUITweener.Name)
    NewPanel:ResetToBeginning() 
    NewPanel:PlayForward()

    local NewCardBG = self.HeroBG:GetComponent(CMUITweener.Name)
    NewCardBG:ResetToBeginning() 
    NewCardBG:PlayForward()

	local Banshen = self.HeroBG:FindChild( "hero_img" )
	local HeroBanshen = Banshen:GetComponent(CMUIHeroBanshen.Name)
	HeroBanshen:SetIcon(self.CardID,false)
    local heroStar = self.HeroBG:FindChild("starlv/txt")
    local StarLabel = heroStar:GetComponent(CMUILabel.Name) 
    local starNum = heroData:MorenXing()
    StarLabel:SetValue(starNum)
    
end


function wnd_NewCardClass:OnLostInstance()
    
end

return wnd_NewCardClass.new

--endregion


--endregion
