local class = require("common/middleclass")
ui_tips = class("ui_tips")

local tipsLabel = nil
local tip = nil
---
---初始化tips提示组件
---
function ui_tips:initialize()
    self.tipsPanel = GameObjectExtension.InstantiateFromPacket("ui_tips", "ui_tips",  self.gameObject)
    tip = self.tipsPanel.transform:Find("tip").gameObject
    tipsLabel = self.tipsPanel.transform:Find("tip/Label").gameObject
    tip:SetActive(false)
end

---
---显示tip组件，播放相应的动画
---
function ui_tips:show( tipsCode )
    if tip.activeSelf then
        return 
    end

    tipsLabel.transform:GetComponent("UILabel").text = tipsCode
    tip:SetActive(true)

    local sq = DG.Tweening.DOTween.Sequence()
    local sq1 = DG.Tweening.DOTween.Sequence()
    local tweener_move = tip.transform:DOMove(Vector3(0, 0.5, 0), 1, false)
    local tweener_fadeIn = DG.Tweening.DOTween.ToAlpha(
    function ()
        return tip.transform:GetComponent("UIWidget").color
    end,
    function (color)
        tip.transform:GetComponent("UIWidget").color = color
    end, 1, 1)
    local tweener_fadeOut = DG.Tweening.DOTween.ToAlpha(
    function ()
        return tip.transform:GetComponent("UIWidget").color
    end,
    function (color)
        tip.transform:GetComponent("UIWidget").color = color
    end, 0, 1)
    sq:Append(tweener_move)
    sq:Join(tweener_fadeIn)
    sq1:SetDelay(2.5)
    sq1:Append(tweener_fadeOut)
    tweener_fadeOut:OnComplete(
    function ()
        print("compelete")
        tip.transform.localPosition = Vector3(0, 0, 0)
        tip:SetActive(false)
    end)
end

return wnd_tips