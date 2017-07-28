---
--- Created by Administrator.
--- DateTime: 2017/7/20 12:56
---

local userInfo_controller = {}
local _view = require("uiscripts/fight/userinfo/userInfo_view")
local _data = require("uiscripts/fight/userinfo/userInfo_model")

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
            end)
        else -- 停止协程
            _view.userInfo:SetActive(false)
            coroutine.stop(infoCoroutine)
        end
    end

    UIEventListener.Get(_view.myGameInfo).onPress = infoFunc
    UIEventListener.Get(_view.enemyGameInfo).onPress = infoFunc

end


return userInfo_controller