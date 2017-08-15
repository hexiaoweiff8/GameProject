---
--- Created by Administrator.
--- DateTime: 2017/7/20 12:56
---

local userInfo_controller = {}
local _view = require("uiscripts/fight/userinfo/userInfo_view")
local _data = require("uiscripts/fight/userinfo/userInfo_model")

local curHP = 100
local maxHP = 100


local beHit_Timer
local lowBlood_Timer
local time = 0
function userInfo_controller:Init(view)

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
                curHP = 100
            end)
        else -- 停止协程
            _view.userInfo:SetActive(false)
            coroutine.stop(infoCoroutine)
        end
    end

    UIEventListener.Get(_view.myGameInfo).onPress = infoFunc
    UIEventListener.Get(_view.enemyGameInfo).onPress = infoFunc


    UIEventListener.Get(_view.myGameInfo).onClick = function ()
        curHP = curHP - 30

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

end

function userInfo_controller:refreshHP()

    ---基地血条掉血效果
    local fillAmount = curHP / maxHP
    _view.MyHP:GetComponent("UISprite").fillAmount = fillAmount
    local animHP_FillAmount = _view.MyAnimHP:GetComponent("UISprite").fillAmount
    if animHP_FillAmount >=  fillAmount + 0.015 then
        _view.MyAnimHP:GetComponent("UISprite").fillAmount = animHP_FillAmount - 0.015
    elseif animHP_FillAmount < fillAmount then
        _view.MyAnimHP:GetComponent("UISprite").fillAmount = fillAmount
    end

    ---基地低血量提示
    if fillAmount >= 0.2 then
        _view.lowBloodTips:SetActive(false)
        lowBlood_Timer = nil
    end
    if fillAmount < 0.2 and not lowBlood_Timer then
        _view.lowBloodTips:SetActive(true)
        --lowBlood_Timer = TimeUtil:CreateTimer(3,
        --function()
        --    _view.lowBloodTips:SetActive(false)
        --    lowBlood_Timer:KIll()
        --end)
    end
end


return userInfo_controller