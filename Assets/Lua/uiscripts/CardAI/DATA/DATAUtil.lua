---
--- Created by Administrator.
--- DateTime: 2017/8/18 16:45
---
local DATAUtil = {}
local _DATA = require("uiscripts/CardAI/DATA/DATA")

local GetCostParams = {}

function DATAUtil:Init_DATA(cardTbl,cardNumTbl)


    printw("****************初始化AI数据*******************")
    self:Init_Tbls(cardTbl, cardNumTbl)
    self:Sort_Tbls()

    self:InitMaxFightCard()
    self:InitGetCostParams()

    self:InitComboFilter()

    printe("卡牌数量表")
    printf(inspect(_DATA.CARD_NUM))
    printe("总卡牌数量")
    printf(_DATA.ALL_CARD_NUM)
    printe("卡牌单费战斗力表")
    printf(inspect(_DATA.CARD_FIGHT))
    printe("总卡牌单费战斗力")
    printf(_DATA.ALL_CARD_FIGHT)
    printe("平均卡牌单费战斗力")
    printf(_DATA.AVERAGE_FIGHT)
    printe("最大单费战斗力卡牌")
    printf(_DATA.maxFightCard)
    printe("吞牌表")
    printf(inspect(_DATA.EAT_CARD))
    printe("类型卡牌表")
    printf(inspect(_DATA.TYPE_CARD))
    printe("参数表")
    printf(inspect(GetCostParams))

    printw("****************初始化AI数据****完成***************")
end

function DATAUtil:Init_Tbls(cardTbl,cardNumTbl)
    for cardId,num in pairs(cardNumTbl) do
        if cardTbl[cardId] then
            ---初始化各种类卡牌数量表
            _DATA.CARD_NUM[cardId] = num
            ---初始化各类卡牌单费战斗力
            _DATA.CARD_FIGHT[cardId] = self:ComputeCardFight(cardId,cardTbl[cardId].lv)


            ---计算卡牌种类数量
            _DATA.ALL_CARD_NUM  = _DATA.ALL_CARD_NUM  + num
            ---计算所有卡牌总单费战斗力
            _DATA.ALL_CARD_FIGHT = _DATA.ALL_CARD_FIGHT + _DATA.CARD_FIGHT[cardId] * num

            ---
            ---初始化各类型对应的卡牌表
            ---获取卡牌类型（等表）
            ---
            local typeList = sdata_unittacticdata_data:GetRow(cardId)
            for i = 2, #typeList do
                local cardType = typeList[i]
                if cardType ~= 0  then
                    if not _DATA.TYPE_CARD[cardType] then
                        _DATA.TYPE_CARD[cardType] = {}
                    end
                    table.insert(_DATA.TYPE_CARD[cardType], cardId)
                end
            end
        end
    end
    ---初始化剩余卡牌数量
    _DATA.LEFT_CARD_NUM = _DATA.ALL_CARD_NUM
    ---计算平均单费战斗力
    _DATA.AVERAGE_FIGHT = _DATA.ALL_CARD_FIGHT / _DATA.ALL_CARD_NUM
    ---遍历单费战斗力表，获取最大单费卡牌，
    for cardId,cardFight in pairs(_DATA.CARD_FIGHT) do
        if cardFight < _DATA.AVERAGE_FIGHT * 0.6 then
            table.insert(_DATA.EAT_CARD , cardId)
        end
    end
end

function DATAUtil:Sort_Tbls()
    ---类型表排序，每种类型的卡牌表按照卡牌的单费战斗力从大到小排序
    if _DATA.TYPE_CARD then
        for _,cardList in pairs(_DATA.TYPE_CARD) do
            table.sort(cardList, function(a,b)
                return _DATA.CARD_FIGHT[a] > _DATA.CARD_FIGHT[b]
            end)
        end
    end
    ---吞牌表排序
    table.sort(_DATA.EAT_CARD, function(a,b)
        return _DATA.CARD_FIGHT[a] < _DATA.CARD_FIGHT[b]
    end)
end

function DATAUtil:InitMaxFightCard()
    ---遍历单费战斗力表，获取最大单费卡牌，
    _DATA.maxFightCard = nil
    for cardId,cardFight in pairs(_DATA.CARD_FIGHT) do
        if _DATA.CARD_NUM[cardId] ~= 0 then
            if not _DATA.maxFightCard then
                _DATA.maxFightCard = cardId
            end
            if _DATA.CARD_FIGHT[_DATA.maxFightCard] < cardFight then
                _DATA.maxFightCard = cardId
            end
        end
    end
end

function DATAUtil:InitGetCostParams()
    GetCostParams = {}
    sdata_tactictype_data:Foreach(function(key,value)
        GetCostParams[key] = {}
        for i = 2, #value do
            GetCostParams[key][i-1] = value[i] == 0 and -1 or value[i]
        end
    end)

end

function DATAUtil:InitComboFilter()
    _DATA.COMBO_FILTER = {}
    sdata_combofilter_data:Foreach(function(key,value)
        if _DATA.CARD_NUM[value[2]] then
            local cardIDList = {}
            string.gsub(value[3], '([^;]+)', function(str)
                local cardId = tonumber(str)
                if _DATA.CARD_NUM[cardId] then
                    table.insert(cardIDList, cardId)
                end
            end)
            table.sort(cardIDList, function(a,b)
                return _DATA.CARD_FIGHT[a] > _DATA.CARD_FIGHT[b]
            end)
            table.insert(_DATA.COMBO_FILTER, {value[2],cardIDList,value[4]})
        end
    end)

    table.sort(_DATA.COMBO_FILTER, function(a,b)
        return _DATA.CARD_FIGHT[a[1]] > _DATA.CARD_FIGHT[b[1]]
    end)
    printe("套路表")
    printf(inspect(_DATA.COMBO_FILTER))
end


function DATAUtil:ComputeCardFight(cardId,cardLv)
    local HP = cardUtil:getCardProp("HP",cardId,cardLv)
    local DEFENCE = cardUtil:getCardProp("Defence", cardId, cardLv)
    local ATTACK = cardUtil:getCardProp("Attack1", cardId, cardLv)
    local CLIPSIZE = cardUtil:getCardProp("Clipsize1", cardId, cardLv)
    local ATTACKRATE = cardUtil:getCardProp("AttackRate1", cardId, cardLv)
    local RELOADTIME = cardUtil:getCardProp("ReloadTime1", cardId, cardLv)
    local HIT = cardUtil:getCardProp("Hit", cardId, cardLv)
    local CRIT = cardUtil:getCardProp("Crit", cardId, cardLv)
    local CRITDAMAGE = cardUtil:getCardProp("CritDamage", cardId, cardLv)
    local ARMYUNIT = cardUtil:getCardArmyUnit(cardId)
    local fight = HP/(1-DEFENCE/(DEFENCE+2000))*(ATTACK*CLIPSIZE/(ATTACKRATE*CLIPSIZE+RELOADTIME))*HIT*(1+CRIT*(CRITDAMAGE-1))*ARMYUNIT
    print(cardId,HP,DEFENCE,ATTACK,CLIPSIZE,ATTACKRATE,RELOADTIME,HIT,CRIT,CRITDAMAGE,ARMYUNIT,fight)
    return fight
end

function DATAUtil:RefreshEnemyPower()
    _DATA.ENEMY_POWER = {}
    for k,v in pairs(GetCostParams) do
        _DATA.ENEMY_POWER[k] = FightDataStatistical.Single:GetCostData(1,-1,v[1],v[2],v[3],v[4],v[5],v[6],v[7],v[8])
    end
    _DATA.ENEMY_ALL_POWER = FightDataStatistical.Single:GetCostData(1,-1,-1,-1,-1,-1,-1,-1,-1,-1)
end

function DATAUtil:RefreshAIPower()
    _DATA.AI_POWER = {}
    for k,v in pairs(GetCostParams) do
        _DATA.AI_POWER[k] = FightDataStatistical.Single:GetCostData(2,-1,v[1],v[2],v[3],v[4],v[5],v[6],v[7],v[8])
    end
    _DATA.AI_ALL_POWER = FightDataStatistical.Single:GetCostData(2,-1,-1,-1,-1,-1,-1,-1,-1,-1)
end

function DATAUtil:SetNextCard(cardId)
    _DATA.NEXT_CARD = cardId
    _DATA.NEED_POWER = cardUtil:getTrainCost(cardId)
end

function DATAUtil:RefreshAIState()
    if _DATA.ENEMY_ALL_POWER - _DATA.AI_ALL_POWER >= 5 * Const.COSTUNIT then
        _DATA.AI_STATE_BAD = true
        return
    end
    _DATA.AI_STATE_BAD = false
end

function DATAUtil:DropCardRefreshDATA(cardId)
    if not _DATA.CARD_NUM[cardId] then
        printe("卡牌数量错误")
        return
    end
    _DATA.CARD_NUM[cardId] = _DATA.CARD_NUM[cardId] - 1
    _DATA.LEFT_CARD_NUM = _DATA.LEFT_CARD_NUM - 1
    if _DATA.CARD_NUM[cardId] == 0 then
        if cardId == _DATA.maxFightCard then
            self:InitMaxFightCard()
        end
    end
    _DATA.NEXT_CARD = 0
end

function DATAUtil:EatCardRefreshDATA(cardId)
    if not _DATA.CARD_NUM[cardId] then
        printe("卡牌数量错误")
        return
    end
    _DATA.CARD_NUM[cardId] = _DATA.CARD_NUM[cardId] - 1
    _DATA.LEFT_CARD_NUM = _DATA.LEFT_CARD_NUM - 1
    if _DATA.CARD_NUM[cardId] == 0 then
        table.remove(_DATA.EAT_CARD, 1)
        if cardId == _DATA.maxFightCard then
            self:InitMaxFightCard()
        end
    end
    if #_DATA.EAT_CARD <= 0 then
        AITEST:printToResult("[ffffff]无可吞卡牌，不再吞牌[-]")
        return
    end
    if _DATA.LEFT_CARD_NUM < 6 then
        AITEST:printToResult("[ffffff]卡牌数量小于6，不再吞牌[-]")
        return
    end
end


return DATAUtil