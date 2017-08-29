local class = require("common/middleclass")

local Card = class("Card")
--id,经验,星级,兵员等级,军阶等级,卡牌数量,插槽状态表,技能表,协同表，卡牌等级
function Card:initialize(id,exp,star,slv,rlv,num,slot,skill,team,lv,buy)
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
    self.buy = buy
end



cardModel = {}
local cardTbl = {}
local cardSortTbl = {}
local cardTbl_Length = 0
---
---从服务器获取卡牌数据
---
function cardModel:initCardTbl(cards)
    cardTbl_Length = 0
    for k, v in ipairs(cards) do
        --卡牌ID -经验 -星级 -兵员等级 -军阶等级 -数量
        print( string.format("card==> id:%d, exp:%d, star:%d, slv:%d, rlv:%d, num:%d, buy:%d",v.id, v.exp, v.star, v.slv, v.rlv, v.num,v.lv,v.buy) )
        print( string.format("teamNum:%d, skillNum:%d, slotNum:%d", #v.team, #v.skill,  #v.slot) )
        --print(v.skill[1])
        cardTbl_Length = cardTbl_Length + 1
        cardTbl[v.id] = Card(v.id, v.exp, v.star, v.slv, v.rlv, v.num, v.slot, v.skill, v.team,v.lv,v.buy)
        table.insert(cardSortTbl, v.id)
    end
    table.sort(cardSortTbl, function (a,b)
        return a < b
    end)
end

---
---添加多张卡牌
---
function cardModel:addCards(cards)
    for _, v in ipairs(cards) do
       self:addCard(v)
    end
end
---
---添加一张卡牌
---
function cardModel:addCard(card)
    if cardTbl[card.id] then
        cardTbl[card.id].num = cardTbl[card.id].num + card.num
    else
        cardTbl_Length = cardTbl_Length + 1
        cardTbl[card.id] = Card(card.id, card.exp, card.star, card.slv, card.rlv, card.num, card.slot, card.skill, card.team,card.lv, card.buy)
        table.insert(cardSortTbl, card.id)
    end
    table.sort(cardSortTbl, function (a,b)
        return a < b
    end)
end


---
---改变某张卡牌的属性
---
function cardModel:setCardInfo(card)
    if cardTbl[card.id] then
        cardTbl[card.id].exp = card.exp
        cardTbl[card.id].star = card.star
        cardTbl[card.id].slv = card.slv
        cardTbl[card.id].rlv = card.rlv
        cardTbl[card.id].num = card.num
        cardTbl[card.id].slot = card.slot
        cardTbl[card.id].skill = card.skill
        cardTbl[card.id].team = card.team
        cardTbl[card.id].lv = card.lv
        cardTbl[card.id].buy = card.buy
    else
        Debugger.LogWarning("要修改信息卡牌不存在！！！！")
    end
end

---
---根据ID获取某张卡牌
---cardId   卡牌Id
---
function cardModel:getCardByID(cardId)

    if cardTbl[cardId] then
        return cardTbl[cardId]
    else
        Debugger.LogWarning("卡牌不存在！！！！")
        return nil
    end
end

---
---获取某张卡牌的数量
---cardId   卡牌Id
---
function cardModel:getCardNum(cardId)
    if cardTbl[cardId] then
        return cardTbl[cardId].num
    else
        Debugger.LogWarning("卡牌不存在！！！！")
        return nil
    end
end
---
---获取某张卡牌的等级
---cardId   卡牌Id
---
function cardModel:getCardLv(cardId)
    if cardTbl[cardId] then
        return cardTbl[cardId].lv
    else
        Debugger.LogWarning("卡牌不存在！！！！")
        return nil
    end
end


---
---获取卡牌的购买次数
---
function cardModel:getCardBuy(cardId)
    if cardTbl[cardId] then
        return cardTbl[cardId].buy
    else
        return 0
    end
end

---
---获取卡牌列表
---
function cardModel:getCardTbl()
    return cardTbl
end
---
---获取卡牌种类数量
---
function cardModel:getCardTblLength()
    return cardTbl_Length
end

---
---获取卡牌排序列表
---
function cardModel:getCardSortTbl()
    return cardSortTbl
end

---
---获取卡牌在排序列表中的次序
---
function cardModel:getCardIndex(cardId)
    for index,value in pairs(cardSortTbl) do
        if value == cardId then
            return index
        end
    end
    printe("错误：卡牌不存在")
    return nil
end