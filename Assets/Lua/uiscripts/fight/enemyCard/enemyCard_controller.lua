---
--- Created by Administrator.
--- DateTime: 2017/7/25 12:19
---

local enemyCard_controller = {}
local _view
local _data
local _CardAI
local timerTbl
local histroyHead

function enemyCard_controller:Init(view)
    _view = require("uiscripts/fight/enemyCard/enemyCard_view")
    _data = require("uiscripts/fight/enemyCard/enemyCard_model")
    _CardAI = require("uiscripts/CardAI/main")
    timerTbl = {}
    histroyHead = {}

    _view:initView(view)

    _data:InitDATA()
    ---
    ---初始化AI数据
    ---假的（读表）
    ---
    local cardNumTbl = {}
    sdata_cardplanenemy_data:Foreach(
    function (key, value)
        cardNumTbl[value[1]] = value[2]
    end)
    _CardAI:Init(cardModel:getCardTbl(), cardNumTbl, self.AIDropCard,self.EatCard)
    _CardAI:SetTestModel(true,_view)

end

---
---敌人下兵
---
function enemyCard_controller:Update()
    _CardAI:Update(_data.enemyNowFei)
    ---敌人费增长
    if _data.enemyNowFei < _data.enemyAllFei then
        _data.enemyNowFei = _data.enemyNowFei + Const.FEI_GROW_SPEED * Time.deltaTime
    else
        _data.enemyNowFei = _data.enemyAllFei
    end

end

function enemyCard_controller:AIDropCard(cardID)
    ModelControl:createEnemyModel(cardID)
    enemyCard_controller:addEnemyCardHistoryUI(cardID)
    _data.enemyNowFei = _data.enemyNowFei - cardUtil:getTrainCost(cardID)
end
function enemyCard_controller:EatCard(cardID)
    _data.enemyNowFei = _data.enemyNowFei + cardUtil:getTrainCost(cardID) * 0.5
end



---添加敌人卡牌历史记录的UI
function enemyCard_controller:addEnemyCardHistoryUI(cardID)

    if #histroyHead == 5 then
        enemyCard_controller:removeEnemyCardHistoryUI(1)
    end
    --增加敌人出牌UI
    local euc = GameObject.Instantiate(_view.enemyUsedCard)
    euc:SetActive(true)
    euc.transform.parent = _view.enemyUsedCardsGrid.transform
    euc.transform.localScale = _view.enemyUsedCard.transform.localScale
    euc.transform:Find("Sprite"):GetComponent(typeof(UISprite)).spriteName = cardUtil:getCardIcon(cardID)
    --重新排列
    _view.enemyUsedCardsGrid.transform:GetComponent(typeof(UIGrid)):Reposition()


    table.insert(histroyHead, euc)
    --敌人出牌UI几秒后消失
    local cardTimer = TimeUtil:CreateTimer(10, function ()
        enemyCard_controller:removeEnemyCardHistoryUI(1)
    end)
    table.insert(timerTbl, cardTimer)

    for i = 1, #histroyHead do
        --点击敌人出的卡牌相机跟随该敌兵
        if histroyHead[i] then
            UIEventListener.Get(histroyHead[i]).onPress = function(go, args)
                if args then
                    local model = ModelControl:getEnemyModel(i)
                    if model then
                        _view.UIFollow.Target = model
                    end
                end
            end
        end
    end

end


function enemyCard_controller:removeEnemyCardHistoryUI(index)
    Object.Destroy(histroyHead[1])
    table.remove(histroyHead,1)
    timerTbl[1]:Kill()
    table.remove(timerTbl, 1)
    ModelControl:removeEnemyModel(1)

    for i = 1, #histroyHead do
        --点击敌人出的卡牌相机跟随该敌兵
        if histroyHead[i] then
            UIEventListener.Get(histroyHead[i]).onPress = function(go, args)
                if args then
                    local model = ModelControl:getEnemyModel(i)
                    if model then
                        _view.UIFollow.Target = model
                    end
                end
            end
        end
    end
end


function enemyCard_controller:OnDestroyDone()
    _view = nil
    _data = nil
    _CardAI:OnDestroyDone()
    _CardAI = nil
    for i = 1,#timerTbl do
        if timerTbl[i] then
            timerTbl[i]:Kill()
        end
    end
    timerTbl = nil
    histroyHead = nil
    Memory.free("uiscripts/CardAI/main")
    Memory.free("uiscripts/fight/enemyCard/enemyCard_view")
    Memory.free("uiscripts/fight/enemyCard/enemyCard_model")
end
return enemyCard_controller