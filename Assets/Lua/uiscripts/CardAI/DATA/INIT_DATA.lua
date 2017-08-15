---
--- Created by Administrator.
--- DateTime: 2017/8/1 11:16
---
local INIT_DATA = {}
local _DATA = require("uiscripts/CardAI/DATA/DATA")

function INIT_DATA:Init_DATA(cardTbl,cardNumTbl)

    local cardtblLength = 0
    local allFight = 0
    for cardId,num in pairs(cardNumTbl) do
        ---初始化卡牌数量
        _DATA.CARD_NUM[cardId] = num
        ---初始化卡牌单费战斗力
        _DATA.CARD_FIHGT[cardId] = (cardTbl[cardId].lv + cardTbl[cardId].rlv + cardTbl[cardId].star) / cardUtil:getTrainCost(cardId)

        ---计算卡牌种类数量
        cardtblLength = cardtblLength + 1
        ---计算卡牌单费战斗力
        allFight = allFight + _DATA.CARD_FIHGT[cardId]

        ---
        ---初始化类型表
        ---类型对应的卡牌
        ---
        ---获取卡牌类型（等表）
        ---
        local cardType = cardId
        if not _DATA.CARD_TYPE[cardType] then
            _DATA.CARD_TYPE[cardType] = {}
        end
        table.insert(_DATA.CARD_TYPE[cardType], cardId)
    end

    ---类型表排序，每种类型的卡牌表按照卡牌的单费战斗力从大到小排序
    for cardType,cardList in pairs(_DATA.CARD_TYPE) do
        table.sort(cardList, function(a,b)
            return _DATA.CARD_FIHGT[a] >= _DATA.CARD_FIHGT[b]
        end)
    end

    ---计算平均单费战斗力
    _DATA.AVERAGE_FIGHT = allFight / cardtblLength


    ---遍历单费战斗力表，获取最大单费卡牌，
    for cardId,cardFight in pairs(_DATA.CARD_FIHGT) do
        if not _DATA.maxFightCard then
            _DATA.maxFightCard = cardId
        end
        if _DATA.CARD_FIHGT[_DATA.maxFightCard] < cardFight then
            _DATA.maxFightCard = cardId
        end
        if cardFight < _DATA.AVERAGE_FIGHT * 0.6 then
            table.insert(_DATA.CARD_EAT , cardId)
        end
    end
    table.sort(_DATA.CARD_EAT, function(a,b)
        return _DATA.CARD_FIHGT[a] < _DATA.CARD_FIHGT[b]
    end)



    --printf("_DATA.CARD_NUM")
    --printf(inspect(_DATA.CARD_NUM))
    --printf("_DATA.CARD_FIHGT")
    --printf(inspect(_DATA.CARD_FIHGT))
    --printf("_DATA.CARD_TYPE")
    --printf(inspect(_DATA.CARD_TYPE))
    --printf("_DATA.CARD_EAT")
    --printf(inspect(_DATA.CARD_EAT))
    --printf("_DATA.AVERAGE_FIGHT")
    --printf(_DATA.AVERAGE_FIGHT)
    --printf("_DATA.maxFightCard")
    --printf(_DATA.maxFightCard)


end

return INIT_DATA