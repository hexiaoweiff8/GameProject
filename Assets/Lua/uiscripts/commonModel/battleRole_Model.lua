---
--- Created by Administrator.
--- DateTime: 2017/8/29 12:31
---
local class = require("common/middleclass")
local BattleRole = class("BattleRole")

function BattleRole:initialize(battleRole)

    self.lv = battleRole.lv
    self.card = {}
    for k,v in ipairs(battleRole.card) do
        local cardInfo = {}
        cardInfo.id = v.id
        cardInfo.lv = v.lv
        cardInfo.star = v.star
        cardInfo.slv = v.slv
        cardInfo.rlv = v.rlv
        cardInfo.slot = {}
        cardInfo.skill = {}
        for _,slotLv in ipairs(v.slot)do
            table.insert(cardInfo.slot, slotLv)
        end
        for _,skillLv in ipairs(v.skill)do
            table.insert(cardInfo.skill, skillLv)
        end
        self.card[v.id] = cardInfo
    end
    self.equip = {}
    for k,v in ipairs(battleRole.equip) do
        local equipInfo = {}
        equipInfo.eid = v.eid
        equipInfo.lv = v.lv
        equipInfo.rarity = v.rarity
        equipInfo.fst_attr = v.fst_attr
        equipInfo.sndAttr = {}
        for k, v in ipairs(v.sndAttr) do
            local sndAttr = {
                id = v.id,
                val = v.val
            }
            table.insert(equipInfo.sndAttr,sndAttr)
        end
        table.insert(self.equip, equipInfo)
    end
    self.sci = {}
    for k,v in ipairs(battleRole.sci) do
        local sciInfo = {
            id = v.id,
            lv = v.lv,
            due = v.due
        }
        table.insert(self.sci, sciInfo)
    end

    self.battle = {}
    self.battle.pf = {}
    for _,cardId in ipairs(battleRole.battle.pf)do
        table.insert(self.battle.pf, cardId)
    end
    self.battle.gf = {}
    for _,gfCard in ipairs(battleRole.battle.gf) do
        local card = {
            cardId = gfCard.cardId,
            num = gfCard.num
        }
        table.insert(self.battle.gf, card)
    end

    self.battle.avoid = battleRole.battle.avoid
    self.battle.win = battleRole.battle.win
    self.battle.npc = battleRole.battle.npc
    self.battle.score = battleRole.battle.score

end


BattleRoleModel = {}

local CurBattleRole
local _isLoadDone = false
function BattleRoleModel:InitCurBattleRole(battleRole)

    CurBattleRole = BattleRole(battleRole)
    print("敌方等级："..CurBattleRole.lv)
    print("敌方卡牌："..inspect(CurBattleRole.card))
    print("敌方装备："..inspect(CurBattleRole.equip))
    print("敌方科技："..inspect(CurBattleRole.sci))
    print("敌方阵容："..inspect(CurBattleRole.battle))
    _isLoadDone = true
end

function BattleRoleModel:GetDaYingCardTbl()
    if not CurBattleRole.battle.gf then
        printe("错误：敌方大营信息不存在")
        return nil
    end
    return CurBattleRole.battle.gf
end
function BattleRoleModel:GetQianFengCardTbl()
    if not CurBattleRole.battle.pf then
        printe("错误：敌方前锋信息不存在")
        return nil
    end
    return CurBattleRole.battle.pf
end
function BattleRoleModel:GetCardTbl()
    if not CurBattleRole.card then
        printe("错误：敌方卡牌信息不存在")
        return nil
    end
    return CurBattleRole.card
end
function BattleRoleModel:GetisLoadDone()
    return _isLoadDone
end
function BattleRoleModel:ClearCurBattleRole()
    CurBattleRole = nil
    _isLoadDone = false
end