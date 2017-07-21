---
--- Created by Administrator.
--- DateTime: 2017/7/17 15:19
---

local class = require("common/middleclass")
dotweenUtil = class("dotweenUtil")

function dotweenUtil:Move(obj, distanceVec3, onCompleteFunc)
    local sq = DG.Tweening.DOTween.Sequence()
    local tweener_move = obj.transform:DOMove(obj.transform.position + distanceVec3, 0.3, false)
    sq:Append(tweener_move)
    if onCompleteFunc then
        tweener_move:OnComplete(onCompleteFunc)
    end
end


return dotweenUtil
