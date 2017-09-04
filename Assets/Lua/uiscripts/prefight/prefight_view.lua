---
--- Created by Administrator.
--- DateTime: 2017/8/29 19:24
---

local prefight_view = {}
local _view
function prefight_view:InitView(view)
    _view = view
    self.OnLineButton = _view.transform:Find("onlineButton").gameObject	    -- 在线战斗
    self.OffLineButton = _view.transform:Find("offlineButton").gameObject	-- 离线战斗
    self.tip = _view.transform:Find("tip").gameObject
    self.tip:SetActive(false)
end

return prefight_view