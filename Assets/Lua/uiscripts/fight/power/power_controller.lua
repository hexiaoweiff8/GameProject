---
--- Created by Administrator.
--- DateTime: 2017/7/24 11:51
---
local power_controller = {}
local _view = require("uiscripts/fight/power/power_view")
local _data = require("uiscripts/fight/power/power_model")



function power_controller:Init(view)
    _view:initView(view)
end


function power_controller:refreshMyPower()
    _view.allPowerLabel:GetComponent("UILabel").text = _data.allFei
    _view.nowPowerLabel:GetComponent("UILabel").text = math.round(_data.nowFei)

    _view.progress:GetComponent("UISprite").fillAmount = _data.nowFei / _data.allFei

    if _data.nowFei >= _data.allFei then
        _view.power_full:SetActive(true)
        _view.power_grow:SetActive(false)
    else
        _view.power_full:SetActive(false)
        _view.power_grow:SetActive(true)
    end
end


return power_controller