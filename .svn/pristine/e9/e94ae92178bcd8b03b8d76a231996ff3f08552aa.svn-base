local class = require("common/middleclass")
ui_pause = class("ui_pause", wnd_base)

function ui_pause:initialize()
    wnd_base.initialize(self, WND.pause_ui)
end


function ui_pause:OnNewInstance()
    -- pauseBg
    self.pauseBg = self.transform:Find("pause/pauseBg")
    -- 退出按钮
    self.quitBtn = self.pauseBg:Find("quitBtn")
    -- 继续按钮
    self.continueBtn = self.pauseBg:Find("continueBtn")
    -- quitBg
    self.quitBg = self.transform:Find("pause/quitBg")
    -- 取消按钮
    self.backBtn = self.quitBg:Find("backBtn")
    -- 确认退出按钮
    self.ensureBtn = self.quitBg:Find("ensureBtn")
    
    
    UIEventListener.Get(self.quitBtn.gameObject).onPress = function(go, args)
        if args then
            self.pauseBg.localScale = Vector3.zero
            self.quitBg.localScale = Vector3.one
        end
    end
    
    UIEventListener.Get(self.continueBtn.gameObject).onPress = function(go, args)
        if args then
            ui_manager:destroy_wnd_base(self.wnd_base_id, 0.1)
        end
    end
    
    UIEventListener.Get(self.backBtn.gameObject).onPress = function(go, args)
        if args then
            self.pauseBg.localScale = Vector3.one
            self.quitBg.localScale = Vector3.zero
        end
    end
    
    UIEventListener.Get(self.ensureBtn.gameObject).onPress = function(go, args)
        if args then
            Time.timeScale = 1
            ui_manager:destroy_wnd_base(ui_fight.wnd_base_id, 0.1)
            ui_manager:destroy_wnd_base(self.wnd_base_id, 0.1)
            -- ui_manager:destroy_all_shown_wnd_bases()
            --卸掉场景
            DP_Battlefield.Single:SwapScene(0, nil, nil)
            --清理战场
            DP_Battlefield.Single:Reset()
            wnd_login:Show()
        end
    end
end


function ui_pause:RegStart()
    self:Init(WND.pause_ui)
    ui_pause = self
end


function ui_pause:OnHideDone()
    ui_fight.daojishi.gameObject:SetActive(true)
    local djsLable = ui_fight.daojishi:GetComponent(typeof(UILabel))
    djsLable.text = "3"
    local sq = DG.Tweening.DOTween.Sequence()
    sq:SetDelay(1)
    sq:AppendCallback(function()
        local tempInt = tonumber(djsLable.text) - 1
        if tempInt == 0 then
            ui_fight.daojishi.gameObject:SetActive(false)
            ui_fight.ispause = false
            Time.timeScale = 1
        else
            djsLable.text = tempInt .. ""
        end
    end)
    sq:SetLoops(3)
    sq:SetUpdate(true)
end

function ui_pause:OnDestroyDone()
    if ui_manager._all_wnd_bases[self.wnd_base_id] ~= nil then
        self:OnHideDone()
    else
        ui_pause = {}
        GameInit:InitWnds2()
        WndManage.Single:DestroyHideWnds()
    end
end

return ui_pause
