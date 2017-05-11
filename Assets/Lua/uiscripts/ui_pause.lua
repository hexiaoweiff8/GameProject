local class = require("common/middleclass")
local ui_pause = class("ui_pause", wnd_base)

isQuitGame = false
function ui_pause:OnShowDone()
    isQuitGame = false
    if self.wnd_base_id == WNDTYPE.ui_pause then -------------------------------------------------------------------------------pause_ui
        -- pauseBg
        self.pauseBg = self.transform:Find("pause/pauseBg")
        -- 退出按钮
        self.quitBtn = self.pauseBg:Find("quitBtn")
        -- 继续按钮
        self.continueBtn = self.pauseBg:Find("continueBtn")
        
        UIEventListener.Get(self.quitBtn.gameObject).onPress = function(go, args)
            if args then
                -- ui_manager:ShowWB(_all_Reg_Wnd_list[WNDTYPE.quiteEnsure_ui])
                ui_manager:ShowWB(require("uiscripts/ui_pause")(WNDTYPE.ui_pause .. "&10001"))
            end
        end
        
        UIEventListener.Get(self.continueBtn.gameObject).onPress = function(go, args)
            if args then
                ui_manager:DestroyWB(self)
            end
        end
    elseif self.wnd_base_id == WNDTYPE.quiteEnsure_ui then -------------------------------------------------------------------------------quiteEnsure_ui
        -- quitBg
        self.quitBg = self.transform:Find("pause/quitBg")
        -- 取消按钮
        self.backBtn = self.quitBg:Find("backBtn")
        -- 确认退出按钮
        self.ensureBtn = self.quitBg:Find("ensureBtn")
        -- 确认退出
        UIEventListener.Get(self.backBtn.gameObject).onPress = function(go, args)
            if args then
                ui_manager:DestroyWB(self)
            end
        end
        UIEventListener.Get(self.ensureBtn.gameObject).onPress = function(go, args)
            if args then
                isQuitGame = true
                Time.timeScale = 1
                --卸掉场景
                DP_Battlefield.Single:SwapScene(0, nil, nil)
                --清理战场
                DP_Battlefield.Single:Reset()
                ui_manager:ShowWB(WNDTYPE.Login)
            end
        end
    elseif self.wnd_base_sub_id == "10001" then -------------------------------------------------------------------------------10001
        -- pauseBg
        self.pauseBg = self.transform:Find("pause/pauseBg")
        -- 退出按钮
        self.quitBtn = self.pauseBg:Find("quitBtn")
        -- 继续按钮
        self.continueBtn = self.pauseBg:Find("continueBtn")
        
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
end

function ui_pause:OnDestroyDoneEnd()
    if self.wnd_base_id == WNDTYPE.ui_pause then -------------------------------------------------------------------------------pause_ui
        if isQuitGame == false then
            Event.Brocast(GameEventType.HUIFUZANTING)
        end
    elseif self.wnd_base_id == WNDTYPE.quiteEnsure_ui then -------------------------------------------------------------------------------quiteEnsure_ui
        lgyPrint("")
    elseif self.wnd_base_sub_id == "10001" then -------------------------------------------------------------------------------10001
        if isQuitGame then
            Time.timeScale = 1
            --卸掉场景
            DP_Battlefield.Single:SwapScene(0, nil, nil)
            --清理战场
            DP_Battlefield.Single:Reset()
            ui_manager:ShowWB(WNDTYPE.Login)
            WndManage.Single:DestroyHideWnds()
        end
    end
end
return ui_pause
