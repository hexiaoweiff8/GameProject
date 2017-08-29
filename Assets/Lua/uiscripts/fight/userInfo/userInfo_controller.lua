---
--- Created by Administrator.
--- DateTime: 2017/7/20 12:56
---

local userInfo_controller = {}
local _view = require("uiscripts/fight/userinfo/userInfo_view")
local _data = require("uiscripts/fight/userinfo/userInfo_model")

local curHP = 100
local maxHP = 100

local myHpLast = 100
local myMaxHpLast = 100

local enenmycurHp = 100
local enenmymaxHp = 100


local beHit_Timer
local lowBlood_Timer
local time = 0
function userInfo_controller:Init(view)
    _view = require("uiscripts/fight/userinfo/userInfo_view")
    _data = require("uiscripts/fight/userinfo/userInfo_model")
    curHP = 100
    maxHP = 100
    myHpLast = 100
    myMaxHpLast = 100
    enenmycurHp = 100
    enenmymaxHp = 100
    time = 0
    
    _view:initView(view)

    local infoCoroutine
    local infoFunc = function(go, args)
        if args then -- 开启协程
            local InfoTransform = go.transform:Find("Info").transform
            infoCoroutine = coroutine.start(function()
                coroutine.wait(0.5)
                _view.userInfo.transform.parent = InfoTransform
                _view.userInfo.transform.localPosition = Vector3.zero
                _view.userInfo:SetActive(true)

            end)
        else -- 停止协程
            _view.userInfo:SetActive(false)
            coroutine.stop(infoCoroutine)
        end
    end

    UIEventListener.Get(_view.myGameInfo).onPress = infoFunc
    UIEventListener.Get(_view.enemyGameInfo).onPress = infoFunc
end


function userInfo_controller:refreshHP()

    ---基地血条掉血和加血效果
    local myfillAmount = curHP / maxHP
    _view.MyHPSp.fillAmount = myfillAmount
    local animHP_myFillAmount = _view.MyAnimHPSp.fillAmount
    if animHP_myFillAmount > myfillAmount then
        _view.MyAnimHPSp.fillAmount = animHP_myFillAmount - 0.01
    elseif animHP_myFillAmount < myfillAmount then
        _view.MyAnimHPSp.fillAmount = myfillAmount
    end

    ---敌方基地血条掉血和加血效果
    local enemyfillAmount = enenmycurHp / enenmymaxHp
    _view.EnenmyHPSp.fillAmount = enemyfillAmount
    local animHP_enemyFillAmount =_view.EnenmyAnimHPSp.fillAmount
    if animHP_enemyFillAmount > enemyfillAmount then
        _view.EnenmyAnimHPSp.fillAmount = animHP_enemyFillAmount - 0.01
    elseif animHP_enemyFillAmount < enemyfillAmount then
        _view.EnenmyAnimHPSp.fillAmount = enemyfillAmount
    end


    ---基地低血量提示
    if myfillAmount >= 0.2 then
        _view.lowBloodTips:SetActive(false)
        if lowBlood_Timer then
            lowBlood_Timer:Kill()
            lowBlood_Timer = nil
        end
    end
    if myfillAmount < 0.2 and not lowBlood_Timer then
        _view.lowBloodTips:SetActive(true)
        lowBlood_Timer = TimeUtil:CreateTimer(3,
        function()
            _view.lowBloodTips:SetActive(false)
        end)
    end
end

--基地的类型 1为我方基地 2为敌方基地  cHp当前生命，mHp最大生命
function userInfo_controller.changeJiDiHP(jdType,cHp,mHp)

    ---判断被击基地类型
    if jdType == 1 then --我方基地
        ---获取当前血量
        curHP = cHp
        maxHP = mHp
        ---判断是否显示被击提示
        if curHP/maxHP < myHpLast/myMaxHpLast then
            ---基地被攻击提示，时间3秒，10秒后才能触发下一次提示。
            if not beHit_Timer then
                _view.BeHitTips:SetActive(true)
                beHit_Timer = TimeUtil:CreateLoopTimer(1,
                function()
                    time = time + 1
                    if time == 3 then
                        _view.BeHitTips:SetActive(false)
                    end
                    if time >= 10 then
                        beHit_Timer:Kill()
                    end
                end,
                function()
                    time = 0
                    beHit_Timer = nil
                end)
            end
        end
        ---记录当前血量
        myHpLast = cHp
        myMaxHpLast = mHp
    elseif jdType == 2 then --敌方基地
        print(cHp,mHp)
        enenmycurHp = cHp
        enenmymaxHp = mHp
    end


end


function userInfo_controller:OnDestroyDone()
    _view = nil
    _data = nil
    curHP = nil
    maxHP = nil
    myHpLast = nil
    myMaxHpLast = nil
    enenmycurHp = nil
    enenmymaxHp = nil
    if beHit_Timer then
        beHit_Timer:Kill()
    end
    beHit_Timer = nil
    if lowBlood_Timer then
        lowBlood_Timer:Kill()
    end
    lowBlood_Timer = nil
    time = nil
    Memory.free("uiscripts/fight/userinfo/userInfo_view")
    Memory.free("uiscripts/fight/userinfo/userInfo_model")
end
return userInfo_controller