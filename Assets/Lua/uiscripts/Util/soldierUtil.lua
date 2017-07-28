---
--- Created by Administrator.
--- DateTime: 2017/7/24 12:40
---


local class = require("common/middleclass")
soldierUtil = class("soldierUtil")



--[[
    获取兵员升级所需的卡牌数量
    soldierlv     当前兵员等级
]]
function soldierUtil:getUpSoldierNeedCardNum(soldierLv)
    if soldierLv >= Const.MAX_ARMY_LV then
        Debugger.LogWarning("已达最大兵员等级")
        return
    end
    return sdata_armycarduselimitcost_data:GetFieldV("Card",soldierLv + 1)
end

--[[
    获取兵员升级所需的兵牌数量
    soldierlv     当前兵员等级
]]
function soldierUtil:getUpSoldierNeedCoinNum(soldierLv)
    if soldierLv >= Const.MAX_ARMY_LV then
        Debugger.LogWarning("已达最大兵员等级")
        return
    end
    return sdata_armycarduselimitcost_data:GetFieldV("Coin",soldierLv + 1)
end

--[[
    获取兵员升级的携带上限
    cardId        卡牌id
    soldierlv     当前兵员等级
]]
function soldierUtil:getSoldierLimit(cardId, soldierLv)
    local uid = tonumber(string.format("%d%.2d",cardId,soldierLv))
    return sdata_armycarduselimit_data:GetFieldV("UseLimit",uid)
end

return soldierUtil