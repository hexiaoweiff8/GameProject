local class = require("common/middleclass")

local Card = class("Card")
--id,经验,星级,兵员等级,军阶等级,卡牌数量,插槽状态表,技能表,协同表，卡牌等级
function Card:initialize(id,exp,star,slv,rlv,num,slot,skill,team,lv)
    self.id = id
    self.exp = exp
    self.star = star
    self.slv = slv 
    self.rlv = rlv
    self.num = num
    self.slot = slot
    self.skill = skill
    self.team = team
    self.lv = lv
end



cardModel = {}
local cardTbl = {}

function cardModel:setCardTbl(cards)
    for k, v in ipairs(cards) do
        --卡牌ID -经验 -星级 -兵员等级 -军阶等级 -数量
        -- print( string.format("card==> id:%d, exp:%d, star:%d, slv:%d, rlv:%d, num:%d",v.id, v.exp, v.star, v.slv, v.rlv, v.num,v.lv) )
        --    print( string.format("teamNum:%d, skillNum:%d, slotNum:%d", #v.team, #v.skill,  #v.slot) )
        --    print(v.skill[1])
        cardTbl[k] = Card(v.id, v.exp, v.star, v.slv, v.rlv, v.num, v.slot, v.skill, v.team,v.lv)
    end
end

function cardModel:setCardInfo(card)
    for k, v in ipairs(cardTbl) do
        if v.id == card.id then
            v.exp = card.exp
            v.star = card.star
            v.slv = card.slv
            v.rlv = card.rlv
            v.num = card.num
            v.slot = card.slot
            v.skill = card.skill
            v.team = card.team
            v.lv = card.lv
        end
    end
end
function cardModel:getCardTbl()
    return cardTbl
end