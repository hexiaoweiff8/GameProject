---
--- Created by Administrator.
--- DateTime: 2017/8/1 11:06
---

local AIMain = {}
local _DATAUtil
local _DATA
local DROPCARD_CALLBACK
local EATCARD_CALLBACK
local time

function AIMain:Init(cardTbl,cardNumTbl,DropCardCallBack,EatCardCallBack)

    printf(inspect(cardTbl))
    printf(inspect(cardNumTbl))


    require("uiscripts/CardAI/ACTION")
    require("uiscripts/CardAI/TEST")
    _DATAUtil = require("uiscripts/CardAI/DATA/DATAUtil")
    _DATA = require("uiscripts/CardAI/DATA/DATA")
    time = 0
    _DATAUtil:Init_DATA(cardTbl,cardNumTbl)
    DROPCARD_CALLBACK = DropCardCallBack
    EATCARD_CALLBACK = EatCardCallBack
end


function AIMain:Update(nowCostPool)

    AITEST:Update()

    if _DATA.LEFT_CARD_NUM <= 0 then
        return
    end
    _DATA.POOL_COST = nowCostPool
    time = time +Time.deltaTime
    if time > 2 then
        time = 0
        self:ChooseCard()
    end
    local isWait = WAIT_DROP(_DATA,self.DROP)
    if isWait then
        EAT(_DATA,self.EAT)
    end

end

---
---设置是否为测试模式
---
function AIMain:SetTestModel(isTest,view)
    AITEST.IS_TEST = isTest
    AITEST.VIEW = view
end

local chooseTime = 0
function AIMain:ChooseCard()
    AITEST.consoleStr = ""
    chooseTime = chooseTime + 1
    AITEST:printrToConsole("选牌开始,第 "..chooseTime .." 次选牌")

    _DATAUtil:RefreshEnemyPower()
    _DATAUtil:RefreshAIPower()
    _DATAUtil:RefreshAIState()
    ---进行必选选牌
    local essentialCard = EssentialChoose(_DATA)
    if essentialCard then
        _DATAUtil:SetNextCard(essentialCard)
        AITEST:printrToConsole("选牌结束，结果为："..essentialCard)
        return
    end

    ---进行排除选牌
    local excludeCardList = ExcludeChoose(_DATA)
    ---进行套路选牌
    local comboCard = ComboChoose(_DATA, excludeCardList)
    if comboCard then
        _DATAUtil:SetNextCard(comboCard)
    end
    AITEST:printrToConsole("选牌结束，结果为："..comboCard)

end


local dropCardTime = 0
function AIMain:DROP(cardId)
    dropCardTime = dropCardTime + 1
    AITEST:printToResult("[ff0000]DropCard = "..cardId..",第 "..dropCardTime .." 次出牌[-]")
    DROPCARD_CALLBACK(_,cardId)
    _DATAUtil:DropCardRefreshDATA(cardId)
end

local eatCardTime = 0
function AIMain:EAT(cardId)
    eatCardTime = eatCardTime + 1
    AITEST:printToResult("[ffff00]EATCard = "..cardId..",第 "..eatCardTime .." 次吞牌[-]")
    EATCARD_CALLBACK(_,cardId)
    _DATAUtil:EatCardRefreshDATA(cardId)
end



function AIMain:OnDestroyDone()
    _DATA = nil
    _DATAUtil = nil
    Memory.free("uiscripts/CardAI/DATA/DATAUtil")
    Memory.free("uiscripts/CardAI/DATA/DATA")
    Memory.free("uiscripts/CardAI/ACTION")
    Memory.free("uiscripts/CardAI/TEST")
end

return AIMain
