---
--- Created by Administrator.
--- DateTime: 2017/7/24 11:51
---

local power_view = {}

local _view
function power_view:initView(view)
    _view = view
    ---能量值部分
    self.power = _view.transform:Find("power").gameObject
    self.power_grow = self.power.transform:Find("grow").gameObject
    --总费Label
    self.allPowerLabel = self.power_grow.transform:Find("allPowerLabel").gameObject
    --当前费Label
    self.nowPowerLabel = self.power_grow.transform:Find("nowPowerLabel").gameObject
    --进度条
    self.progress = self.power_grow.transform:Find("progress").gameObject

    --能量满
    self.power_full = self.power.transform:Find("full").gameObject

    self.powerTips = self.power.transform:Find("tip").gameObject
    self.powerTipsLab = self.powerTips.transform:Find("lab").gameObject

end

return power_view