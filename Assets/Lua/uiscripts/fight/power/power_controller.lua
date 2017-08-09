---
--- Created by Administrator.
--- DateTime: 2017/7/24 11:51
---
local power_controller = {}
local _view = require("uiscripts/fight/power/power_view")
local _data = require("uiscripts/fight/power/power_model")



function power_controller:Init(view)
    _view:initView(view)
    _view.powerTips:SetActive(false)
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

---控制可回收能量的加减
local recyclePower = 0
function power_controller:addRecyclePower(trainCost)
    recyclePower = recyclePower + trainCost / 2
end
function power_controller:subRecyclePower(trainCost)
    recyclePower = recyclePower - trainCost / 2
end

---
---控制回收能量提示的显隐
---
function power_controller:showRecycleTips()
    if _data.nowFei >= _data.allFei then
        _view.powerTipsLab:GetComponent("UILabel").text = "能量已满不可回收！！"
    else
        _view.powerTipsLab:GetComponent("UILabel").text = "可回收能量为"..recyclePower
    end
    _view.powerTips:SetActive(true)
end
function power_controller:hideRecycleTips()
    _view.powerTips:SetActive(false)
end

return power_controller