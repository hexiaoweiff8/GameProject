---
--- Created by Administrator.
--- DateTime: 2017/7/19 14:25
---
local class = require("common/middleclass")
local fight_controller = class("fight_controller", wnd_base)

local _view = require("uiscripts/fight/fight_view")
local _data = require("uiscripts/fight/fight_model")
local restCard = require("uiscripts/fight/restCard/restCard_controller")
local skill = require("uiscripts/fight/skill/skill_controller")
local userInfo = require("uiscripts/fight/userInfo/userInfo_controller")
local cardInHand = require("uiscripts/fight/cardInHand/cardInHand_controller")
local power = require("uiscripts/fight/power/power_controller")
local enemyCard = require("uiscripts/fight/enemyCard/enemyCard_controller")
local qianFengModel = require("uiscripts/fight/QianFengModel")

require("uiscripts/fight/touchControl")
require("uiscripts/fight/modelControl")
require("uiscripts/fight/AStarControl")
local CanNotArea = require("uiscripts/fight/CanNotArea")
require("uiscripts/commonGameObj/Model")
function Onfs()
    ui_manager:ShowWB(WNDTYPE.ui_fight)
end
local _isPause = false
function fight_controller:OnShowDone()
    ---
    ---初始化view和数据
    ---
    _view:init(self)
    _data:getDatas()

    local fun = function()--开场还没加载到所以用协程
        while not CanNotArea.cannotRect do
            coroutine.wait(0.1)
            CanNotArea:Init()
            if CanNotArea.cannotRect then
                local maxDropX = CanNotArea:GetMaxDropX()
                AStarControl:Init(maxDropX)
                Model:setZhenXingData(_data.AllCardIDtb, _data.AllCardLeveltb)
                qianFengModel:Init(_data.QianFengCard)
                qianFengModel:Start()
                ---
                ---初始化各部分显示
                ---
                restCard:Init(self)
                skill:Init(self)
                userInfo:Init(self)
                cardInHand:Init(self)
                power:Init(self)
                enemyCard:Init(self)
                self:initJumpButton()
                ---开始游戏倒计时
                self:StartTimer()
            end
        end
    end
    coroutine.start(fun)

    self:initPause()
    ui_manager:DestroyWB(WNDTYPE.Prefight)
end

---初始化跳转按钮
function fight_controller:initJumpButton()

    ---双方主基地
    self.myMainBuild = GameObject.Find("/BuildingParent").transform:GetChild(3)
    self.myFirstSoldier = GameObject.Find("/BuildingParent").transform:GetChild(2)
    UIEventListener.Get(_view.jumpToMyMain).onPress = function (go, args)
        if args then
            if self.myMainBuild then
                _view.UIFollow.Target = self.myMainBuild
            end
        end
    end
    UIEventListener.Get(_view.jumpToFirst).onPress = function (go, args)
        if args then
            if self.myFirstSoldier then
                _view.UIFollow.Target = self.myFirstSoldier
            end
        end
    end
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


function fight_controller:Update()
    if not CanNotArea.cannotRect then
        return
    end
    if _isPause then
        return
    end

    ---
    ---刷新UI中的基地血条
    ---
    userInfo:refreshHP()


    ---
    ---控制跳转我的主基地按钮的显隐
    ---
    local myMainBuild_UIPosition = _data:UIWorldPosition_From_3DWorldPosition(_view.nowWorldCamera,self.myMainBuild.position)
    if myMainBuild_UIPosition.x < -2 then
        _view.jumpToMyMain:SetActive(true)
    else
        _view.jumpToMyMain:SetActive(false)
    end
    ---
    ---控制跳转我的排头兵按钮的显隐
    ---
    local myFirstSoldier_UIPosition = _data:UIWorldPosition_From_3DWorldPosition(_view.nowWorldCamera,self.myFirstSoldier.position)
    if myFirstSoldier_UIPosition.x > 2 then
        _view.jumpToFirst:SetActive(true)
    else
        _view.jumpToFirst:SetActive(false)
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

    ---我的费增长
    if _data.nowFei < _data.allFei then
        _data.nowFei = _data.nowFei + 10
    else
        _data.nowFei = _data.allFei
    end
    power:refreshMyPower()
    cardInHand:refreshCardCD()

    ---敌人费增长
    if _data.enemyNowFei < _data.enemyAllFei then
        _data.enemyNowFei = _data.enemyNowFei + 10
    else
        _data.enemyNowFei = _data.enemyAllFei
    end
    enemyCard:AIDropCard()



    ---测试数据---
    if Input.GetKeyDown(UnityEngine.KeyCode.F1) then
        _view.TEST_ENEMYINFO:SetActive(not _view.TEST_ENEMYINFO.activeSelf)
    end
    if _data.enemyNextCard then
        _view.TEST_ENEMYINFO:GetComponent("UILabel").text =
        string.format("敌人剩余卡数：%d\n敌人总能量：%d\n等待卡ID：%d\n所需能量：%d",
        _data.enemyCardNum,_data.enemyNowFei,_data.enemyNextCard.id,_data.enemyNextCard.TrainCost)
    else
        _view.TEST_ENEMYINFO:GetComponent("UILabel").text =
        string.format("敌人剩余卡数：%d\n",_data.enemyCardNum)
    end

end




---敌人下兵逻辑
function ENEMY_DROP_CARD()
    ModelControl:createEnemyModel(_data.enemyNextCard.id)
    _data.enemyNowFei = _data.enemyNowFei - _data.enemyNextCard.TrainCost
    _data:refreshEnemyCard()
end
---自己下兵
function DROP_CARD(cardIndex)
    ModelControl:ActiveModel(cardIndex)
    _data.nowFei = _data.nowFei - cardUtil:getTrainCost(_data.nowHandpaiKutb[cardIndex].id)
    _data:refreshMyCards(cardIndex)
    -- 延迟1秒刷新显示
    local t = TimeTicker()
    t:Start(1)
    t.OnEnd = function(go)
        cardInHand:Refresh(cardIndex)
        restCard:Refresh()
    end
end
---回收卡牌
function RECOVERY_CARD(cardIndex)
    _data.nowFei = _data.nowFei + cardUtil:getTrainCost(_data.nowHandpaiKutb[cardIndex].id) * 0.5
    if _data.nowFei > _data.allFei then
        _data.nowFei = _data.allFei
    end
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

return fight_controller