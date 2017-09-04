---
--- Created by Administrator.
--- DateTime: 2017/7/25 12:19
---
local class = require("common/middleclass")
local enemyCard_model = class("enemyCard_model", fight_model)

function enemyCard_model:InitDATA()
    --敌人总费
    self.enemyAllFei = Const.MAX_FEI
    --敌人当前费
    self.enemyNowFei = Const.START_FEI

    self.enemyAllCardInfo = BattleRoleModel:GetCardTbl()

    self.enemyDaYingCardTbl = BattleRoleModel:GetDaYingCardTbl()

    self.enemyQianFengCardTbl = BattleRoleModel:GetQianFengCardTbl()


end

return enemyCard_model



