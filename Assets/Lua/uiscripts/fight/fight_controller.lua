---
--- Created by Administrator.
--- DateTime: 2017/7/19 14:25
---
local class = require("common/middleclass")
local fight_controller = class("fight_controller", wnd_base)

local _view = require("uiscripts/fight/fight_view")
local _data = require("uiscripts/fight/fight_model")
local leftCard = require("uiscripts/fight/leftCard/leftCard_controller")
local skill = require("uiscripts/fight/skill/skill_controller")
local userInfo = require("uiscripts/fight/userInfo/userInfo_controller")
local cardInHand = require("uiscripts/fight/cardInHand/cardInHand_controller")
local power = require("uiscripts/fight/power/power_controller")
local enemyCard = require("uiscripts/fight/enemyCard/enemyCard_controller")


require("uiscripts/fight/touchControl")
require("uiscripts/fight/modelControl")
require("uiscripts/fight/AStarControl")

--function Onfs()
--    ui_manager:ShowWB(WNDTYPE.ui_fight2)
--end
local _isPause = false
function fight_controller:OnShowDone()
    ---
    ---初始化view和数据
    ---
    _view:init(self)
    _data:getDatas()

    coroutine.start(function()--开场还没加载到所以用协程
        while _view.canotRect == nil do
            coroutine.wait(0.1)
            _view.canotRect = GameObject.Find("/SceneRoot/canotRectGo")
            if _view.canotRect then
                local maxPointX = _view.canotRect.transform.position.x
                AStarControl:Init(maxPointX)
                ModelControl:Init(_data.AllCardIDtb, _data.AllCardLeveltb)
                ---
                ---初始化各部分显示
                ---
                leftCard:Init(self)
                skill:Init(self)
                userInfo:Init(self)
                cardInHand:Init(self)
                power:Init(self)
                enemyCard:Init(self)
            end
        end
    end)



    ---开始游戏倒计时
    self:StartTimer()

    self:initPause()
    ui_manager:DestroyWB(WNDTYPE.Prefight)

end



---初始化游戏暂停功能
function fight_controller:initPause()
    UIEventListener.Get(_view.btn_pause.gameObject).onPress = function(go, args)
        if args then
            _isPause = true
            Time.timeScale = 0
            ui_manager:ShowWB(WNDTYPE.ui_pause)
        end
    end
end

---战斗计时器
function fight_controller:StartTimer()
    --战斗计时器
    self.TimeTickerTb[1] = startTimer(5 * 60,
    function(timer)
        local tempInt = math.ceil(timer.OverTime)
        _view.time_txt.text = string.format("%02d", math.modf(tempInt / 60)) .. ":" .. string.format("%02d", tempInt % 60)
    end,
    function(timer)--完成回调
        _view.time_txt.text = "00:00"
    end)
end

---出牌或回收后，下一张牌替换
function fight_controller:nextCard(cardIndex)
    --牌库第一张补充到手牌
    if _data.nextCard then
        _data.nowHandpaiKutb[cardIndex] = _data.nextCard
    else
        _data.nowHandpaiKutb[cardIndex] = nil
    end
    --获取下一张卡牌
    if #_data.paiKutb > 0 then --牌库有牌
        _data.nextCard = _data.paiKutb[1]
        table.remove(_data.paiKutb, 1)
    else
        _data.nextCard = nil
    end
    -- 延迟1秒刷新显示
    local t = TimeTicker()
    t:Start(1)
    t.OnEnd = function(go)
        cardInHand:Refresh(cardIndex)
        leftCard:Refresh()
    end
end

---
function fight_controller:Update()
    if not _view.canotRect then
        return
    end
    if _isPause then
        return
    end
    ----如果拖动卡牌到边界则同时移动相机
    local touchTable = TouchControl:getTouchTbl()
    for k,_ in pairs(touchTable) do
        local touchPosition = TouchControl:getTouchPoint(k)
        if touchPosition then
            local tempX = _view.nowUICamera:ScreenToWorldPoint(touchPosition).x / Const.urlc
            if tempX < -550 then
                _view.BoxScrollObject:MoveTo(_view.PTZCameraTf.position - Vector3(10, 0, 0))
            elseif tempX > 550 then
                _view.BoxScrollObject:MoveTo(_view.PTZCameraTf.position + Vector3(10, 0, 0))
            end
        end
    end


    --费每秒增长
    if _data.nowFei < _data.allFei then
        _data.nowFei = _data.nowFei + 1
    else
        _data.nowFei = _data.allFei
    end
    power:refreshMyPower()
    cardInHand:refreshCardCD()



    --敌人费每秒增长
    if _data.enemyNowFei < _data.enemyAllFei then
        _data.enemyNowFei = _data.enemyNowFei + 1
    else
        _data.enemyNowFei = _data.enemyAllFei
    end
    enemyCard:AIDropCard()
end

---添加和移除事件监听
function fight_controller:OnAddHandler()
    Event.AddListener(GameEventType.HUIFUZANTING, HUIFUZANTING)
    Event.AddListener(GameEventType.ENEMY_DROP_CARD, ENEMY_DROP_CARD)
    Event.AddListener(GameEventType.DROP_CARD, DROP_CARD)
    Event.AddListener(GameEventType.RECOVERY_CARD, RECOVERY_CARD)

end
function fight_controller:OnRemoveHandler()
    Event.RemoveListener(GameEventType.HUIFUZANTING, HUIFUZANTING)
    Event.RemoveListener(GameEventType.ENEMY_DROP_CARD, ENEMY_DROP_CARD)
    Event.RemoveListener(GameEventType.DROP_CARD, DROP_CARD)
    Event.RemoveListener(GameEventType.RECOVERY_CARD, RECOVERY_CARD)
end


---敌人下兵逻辑
function ENEMY_DROP_CARD()
    ModelControl:createEnemyModel(_data.enemyPaiKutb[1].id)
    _data.enemyNowFei = _data.enemyNowFei - _data.enemyPaiKutb[1].TrainCost
    table.remove(_data.enemyPaiKutb, 1)
end
function WANJIAXIABING(self)
    -- TODODO
    -- if 1 then
    --     return
    -- end
    ------------------------------
    if #_data.enemyPaiKutb == 0 then
        return
    end
    local tempID
    --因费不够该出的卡牌id
    if self.nextEnemyCardFei then
        tempID = self.nextEnemyCardID
    else
        tempID = _data.enemyPaiKutb[1].id
        table.remove(_data.enemyPaiKutb, 1)
    end
    --如果敌人费够
    if _data.enemyNowFei >= sdata_armycardbase_data:GetFieldV("TrainCost", tempID) then
        local ct = ModelControl:createEnemyModel(tempID)
        ----增加敌人出牌UI
        --local euc = GameObject.Instantiate(self.enemyUsedCard)
        ----点击敌人出的卡牌相机跟随该敌兵
        --UIEventListener.Get(euc.gameObject).onPress = function(go, args)
        --    if args then
        --        self.UIFollow.target = ct
        --    end
        --end
        --euc.gameObject:SetActive(true)
        --euc.parent = self.enemyUsedCardsGridTf
        --euc.localScale = self.enemyUsedCard.localScale
        --euc:Find("Sprite"):GetComponent(typeof(UISprite)).spriteName = sdata_armycardbase_data:GetFieldV("IconID", tempID)
        ----敌人出牌UI几秒后消失
        --self.enemyUsedCardsGrid:Reposition()
        --self.coroutineTb[#self.coroutineTb + 1] = coroutine.start(function()
        --    coroutine.wait(10)
        --    Object.Destroy(euc.gameObject)
        --end)
        _data.enemyNowFei = _data.enemyNowFei - sdata_armycardbase_data:GetFieldV("TrainCost", tempID)
    else --敌人费不够记录下次该出的牌和费
        self.nextEnemyCardID = tempID
        self.nextEnemyCardFei = sdata_armycardbase_data:GetFieldV("TrainCost", tempID)
    end
end
---自己下兵
function DROP_CARD(cardIndex)
    ModelControl:activeModel(cardIndex)
    _data.nowFei = _data.nowFei - cardUtil:getTrainCost(_data.nowHandpaiKutb[cardIndex].id)
    fight_controller:nextCard(cardIndex)
end
---回收卡牌
function RECOVERY_CARD(cardIndex)
    _data.nowFei = _data.nowFei + cardUtil:getTrainCost(_data.nowHandpaiKutb[cardIndex].id) * 0.5
    fight_controller:nextCard(cardIndex)
end
---暂停恢复回调方法
function HUIFUZANTING()
    _view.daojishi.gameObject:SetActive(true)
    local djsLable = _view.daojishi:GetComponent(typeof(UILabel))
    djsLable.text = "3"
    local sq = DG.Tweening.DOTween.Sequence()
    sq:SetDelay(1)
    sq:AppendCallback(function()
        local tempInt = tonumber(djsLable.text) - 1
        if tempInt == 0 then
            _view.daojishi.gameObject:SetActive(false)
            _isPause = false
            Time.timeScale = 1
        else
            djsLable.text = tempInt .. ""
        end
    end)
    sq:SetLoops(3)
    sq:SetUpdate(true)
end



return fight_controller