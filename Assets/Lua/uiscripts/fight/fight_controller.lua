---
--- Created by Administrator.
--- DateTime: 2017/7/19 14:25
---
local class = require("common/middleclass")
local fight_controller = class("fight_controller", wnd_base)

local _view
local _data
local restCard
local skill
local userInfo
local cardInHand
local power
local enemyCard
local _isPause

local FPSFrames
local FPSTime

function fight_controller:OnShowDone()


    _view = require("uiscripts/fight/fight_view")
    _data = require("uiscripts/fight/fight_model")
    restCard = require("uiscripts/fight/restCard/restCard_controller")
    skill = require("uiscripts/fight/skill/skill_controller")
    userInfo = require("uiscripts/fight/userInfo/userInfo_controller")
    cardInHand = require("uiscripts/fight/cardInHand/cardInHand_controller")
    power = require("uiscripts/fight/power/power_controller")
    enemyCard = require("uiscripts/fight/enemyCard/enemyCard_controller")
    require("uiscripts/fight/QianFengModel")
    require("uiscripts/fight/touchControl")
    require("uiscripts/fight/modelControl")
    require("uiscripts/fight/AStarControl")
    require("uiscripts/fight/CanNotArea")
    require("uiscripts/commonGameObj/Model")
    _isPause = false
    FPSFrames = 0
    FPSTime = 0
    ---
    ---初始化view和数据
    ---
    _view:init(self)
    _data:getDatas()

    CanNotArea:Init()
    local maxDropX = CanNotArea:GetMaxDropX()
    AStarControl:Init(maxDropX)
    Model:setZhenXingData(_data.AllCardIDtb, _data.AllCardLeveltb)
    QianFengModel:Init(_data.QianFengCard)
    QianFengModel:Start()
    ---
    ---初始化各部分显示
    ---
    restCard:Init(self)
    skill:Init(self)
    userInfo:Init(self)
    cardInHand:Init(self)
    power:Init(self)
    enemyCard:Init(self)

    FightManager.Single:AnalysisMap()

    self:initJumpButton()
    ---开始游戏倒计时
    self:StartTimer()

    self:initPause()
end

---初始化跳转按钮
function fight_controller:initJumpButton()

    ---双方主基地
    self.myMainBuild = GameObject.Find("/BuildingParent").transform:GetChild(2)
    self.myFirstSoldier = GameObject.Find("/BuildingParent").transform:GetChild(3)
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
    local myMainBuild_UIPosition = _view.nowWorldCamera:WorldToScreenPoint(self.myMainBuild.position)

    if myMainBuild_UIPosition.x < UnityEngine.Screen.width/7 then
        if not _view.jumpToMyMain.activeSelf then
            _view.jumpToMyMain:SetActive(true)
        end
    else
        if _view.jumpToMyMain.activeSelf then
            _view.jumpToMyMain:SetActive(false)
            _view.UIFollow:Stop()
        end
    end
    ---
    ---控制跳转我的排头兵按钮的显隐
    ---
    local myFirstSoldier_UIPosition = _view.nowWorldCamera:WorldToScreenPoint(self.myFirstSoldier.position)
    if myFirstSoldier_UIPosition.x > UnityEngine.Screen.width*6/7 then
        if not _view.jumpToFirst.activeSelf then
            _view.jumpToFirst:SetActive(true)
        end
    else
        if _view.jumpToFirst.activeSelf then
            _view.jumpToFirst:SetActive(false)
            _view.UIFollow:Stop()
        end
    end


    ----如果拖动卡牌到边界则同时移动相机
    local touchTable = TouchControl:getTouchTbl()
    for k,_ in pairs(touchTable) do
        local touchPosition = TouchControl:getTouchPoint(k)
        if touchPosition then
            local tempX = touchPosition.x
            if tempX < UnityEngine.Screen.width/10 then
                _view.BoxScrollObject:MoveTo(_view.PTZCameraTf.position - Vector3(10, 0, 0))
            elseif tempX > UnityEngine.Screen.width*9/10 then
                _view.BoxScrollObject:MoveTo(_view.PTZCameraTf.position + Vector3(10, 0, 0))
            end
        end
    end

    ---我的费增长
    if _data.nowFei < _data.allFei then
        _data.nowFei = _data.nowFei + Const.FEI_GROW_SPEED * Time.deltaTime
    else
        _data.nowFei = _data.allFei
    end
    power:refreshMyPower()
    cardInHand:refreshCardCD()

    enemyCard:Update()



    ---计算FPS
    FPSFrames = FPSFrames + 1
    FPSTime = FPSTime + Time.deltaTime
    if FPSTime >= 1 then
        _view.FPSLable:GetComponent("UILabel").text = string.format("fps:%3d",FPSFrames/FPSTime)
    end
end

function fight_controller:nextCard(cardIndex)
    _data:refreshMyCards(cardIndex)
    -- 延迟1秒刷新显示
    local t = TimeTicker()
    t:Start(1)
    t.OnEnd = function(go)
        cardInHand:Refresh(cardIndex)
        restCard:Refresh()
    end
end

---自己下兵
function DROP_CARD(cardIndex)
    ModelControl:ActiveModel(cardIndex)
    _data.nowFei = _data.nowFei - cardUtil:getTrainCost(_data.nowHandpaiKutb[cardIndex].id)
    fight_controller:nextCard(cardIndex)
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
    Event.AddListener(GameEventType.DROP_CARD, DROP_CARD)
    Event.AddListener(GameEventType.RECOVERY_CARD, RECOVERY_CARD)

end
function fight_controller:OnRemoveHandler()
    Event.RemoveListener(GameEventType.HUIFUZANTING, HUIFUZANTING)
    Event.RemoveListener(GameEventType.DROP_CARD, DROP_CARD)
    Event.RemoveListener(GameEventType.RECOVERY_CARD, RECOVERY_CARD)
end


function fight_controller:OnHideDone()
    print("OnHideDone")
end
function fight_controller:OnDestroyDone()
    restCard:OnDestroyDone()
    skill:OnDestroyDone()
    userInfo:OnDestroyDone()
    cardInHand:OnDestroyDone()
    power:OnDestroyDone()
    enemyCard:OnDestroyDone()
    AStarControl:OnDestroyDone()
    CanNotArea:OnDestroyDone()
    ModelControl:OnDestroyDone()
    QianFengModel:OnDestroyDone()
    TouchControl:OnDestroyDone()
    _view = nil
    _data = nil
    restCard = nil
    skill = nil
    userInfo = nil
    cardInHand = nil
    power = nil
    enemyCard = nil
    _isPause = nil
    Memory.free("uiscripts/fight/fight_view")
    Memory.free("uiscripts/fight/fight_model")
    Memory.free("uiscripts/fight/restCard/restCard_controller")
    Memory.free("uiscripts/fight/skill/skill_controller")
    Memory.free("uiscripts/fight/userInfo/userInfo_controller")
    Memory.free("uiscripts/fight/cardInHand/cardInHand_controller")
    Memory.free("uiscripts/fight/power/power_controller")
    Memory.free("uiscripts/fight/enemyCard/enemyCard_controller")
    Memory.free("uiscripts/fight/QianFengModel")
    Memory.free("uiscripts/fight/touchControl")
    Memory.free("uiscripts/fight/modelControl")
    Memory.free("uiscripts/fight/AStarControl")
    Memory.free("uiscripts/fight/CanNotArea")
    Memory.free("uiscripts/commonGameObj/Model")
    Memory.free("uiscripts/fight/fight_controller")
    fight_controller = nil
end

return fight_controller