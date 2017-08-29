local class = require("common/middleclass")
local ui_quitGame = class("ui_quitGame", wnd_base)

function ui_quitGame:OnShowDone()
    -- pauseBg
    self.pauseBg = self.transform:Find("bg")
    self.pauseBg:Find("title"):GetComponent(typeof(UILabel)).text = sdata_UILiteral:GetFieldV("Literal", 10019)
    self.pauseBg:Find("info1"):GetComponent(typeof(UILabel)).text = sdata_UILiteral:GetFieldV("Literal", 10029)
    self.pauseBg:Find("info2"):GetComponent(typeof(UILabel)).text = sdata_UILiteral:GetFieldV("Literal", 10030)
    -- 退出按钮
    self.quitBtn = self.pauseBg:Find("quitBtn")
    self.quitBtn:Find("title"):GetComponent(typeof(UILabel)).text = sdata_UILiteral:GetFieldV("Literal", 10028)
    -- 继续按钮
    self.continueBtn = self.pauseBg:Find("continueBtn")
    self.continueBtn:Find("title"):GetComponent(typeof(UILabel)).text = sdata_UILiteral:GetFieldV("Literal", 10021)
    
    UIEventListener.Get(self.quitBtn.gameObject).onPress = function(go, args)
        if args then
            isQuitGame = true
            ui_manager:destroy_all_shown_pop()
        end
    end
    
    UIEventListener.Get(self.continueBtn.gameObject).onPress = function(go, args)
        if args then
            ui_manager:DestroyWB(self)
        end
    end
end
function ui_quitGame:OnDestroyDone()
    if isQuitGame then
        Time.timeScale = 1
        FightManager.Single:EndFight()
        --清理战场
        DP_Battlefield.Single:Reset()
        --卸掉场景
        DP_Battlefield.Single:SwapScene(0, nil, nil)

        -- ui_manager:ShowWB(WNDTYPE.BianDui)
        --ui_manager:ShowWB(WNDTYPE.Main)
        --ui_manager:ShowWB(WNDTYPE.ui_equip)
        --WndManage.Single:DestroyHideWnds()
        if ui_manager._shown_wnd_bases[WNDTYPE.Main] == nil then
            ui_manager:ShowWB(WNDTYPE.Main)
        else
            ui_manager._shown_wnd_bases[WNDTYPE.Main]:Show()
        end
    end
end
return ui_quitGame
