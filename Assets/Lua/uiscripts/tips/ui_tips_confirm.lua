---
--- Created by Administrator.
--- DateTime: 2017/7/15 16:34
---

ui_tips_confirm = {
    cPARENT = "UIRoot/FlyRoot",
    bIsInitialed = false,
    bIsShowing = false,
    confirmCallback = nil,
    isInit = false
}
function ui_tips_confirm:Show(content, func)
    if not self.isInit then
        self:initView()
        self.isInit = true
    end
    self:addListener()
    self.content:GetComponent("UILabel").text = content
    self.confirmCallback = func
    self.ConfirmPanel:SetActive(true)
end

function ui_tips_confirm:addListener()
    UIEventListener.Get(self.btn_Close).onClick = function()
        print("close")
        self.ConfirmPanel:SetActive(false)
    end
    UIEventListener.Get(self.mask).onClick = function()
        print("mask")
        self.ConfirmPanel:SetActive(false)
    end
    UIEventListener.Get(self.btn_Confirm).onClick = function()
        print("confirm")
        self.confirmCallback()
        self.ConfirmPanel:SetActive(false)
    end

end
function ui_tips_confirm:initView()
    local parent = UnityEngine.GameObject.Find(self.cPARENT)
    self.ConfirmPanel = GameObjectExtension.InstantiateFromPacket("ui_tips", "ui_tips_confirm", parent).gameObject
    self.title = self.ConfirmPanel.transform:Find("bg/title").gameObject
    self.content = self.ConfirmPanel.transform:Find("content").gameObject
    self.btn_Close = self.ConfirmPanel.transform:Find("btn_close").gameObject
    self.btn_Confirm = self.ConfirmPanel.transform:Find("btn_confirm").gameObject
    self.mask = self.ConfirmPanel.transform:Find("mask").gameObject


end


return ui_tips_confirm