local class = require("common/middleclass")
local ui_pause = class("ui_pause", wnd_base)

isQuitGame = false
function ui_pause:OnShowDone()
    isQuitGame = false
    self.pauseBg = self.transform:Find("pause")
    self.pauseBg:Find("title"):GetComponent(typeof(UILabel)).text = sdata_UILiteral:GetFieldV("Literal", 10027)
    self.pauseBg:Find("info21"):GetComponent(typeof(UILabel)).text = sdata_UILiteral:GetFieldV("Literal", 10022)
    self.pauseBg:Find("info23"):GetComponent(typeof(UILabel)).text = sdata_UILiteral:GetFieldV("Literal", 10023)
    self.pauseBg:Find("info1"):GetComponent(typeof(UILabel)).text = sdata_UILiteral:GetFieldV("Literal", 10024)
    self.pauseBg:Find("info2"):GetComponent(typeof(UILabel)).text = sdata_UILiteral:GetFieldV("Literal", 10025)
    self.pauseBg:Find("info3"):GetComponent(typeof(UILabel)).text = sdata_UILiteral:GetFieldV("Literal", 10026)
    -- 退出按钮
    self.quitBtn = self.pauseBg:Find("quitBtn")
    self.quitBtn:Find("title"):GetComponent(typeof(UILabel)).text = sdata_UILiteral:GetFieldV("Literal", 10019)
    -- 继续按钮
    self.continueBtn = self.pauseBg:Find("continueBtn")
    self.continueBtn:Find("title"):GetComponent(typeof(UILabel)).text = sdata_UILiteral:GetFieldV("Literal", 10021)
    -- 快速游戏按钮
    self.quickGameBtn = self.pauseBg:Find("quickGameBtn")
    self.quickGameBtn:Find("title"):GetComponent(typeof(UILabel)).text = sdata_UILiteral:GetFieldV("Literal", 10020)
    
    
    
    UIEventListener.Get(self.quitBtn.gameObject).onPress = function(go, args)
        if args then
            ui_manager:ShowWB(WNDTYPE.ui_quitGame)
        end
    end
    
    UIEventListener.Get(self.continueBtn.gameObject).onPress = function(go, args)
        if args then
            ui_manager:DestroyWB(self)
        end
    end
end

function ui_pause:OnHideDone()
    if isQuitGame == false then
        Event.Brocast(GameEventType.HUIFUZANTING)
    end
end
return ui_pause
