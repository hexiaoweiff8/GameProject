---
--- Created by Administrator.
--- DateTime: 2017/7/17 17:27
---

local class = require("common/middleclass")
borderUtil = class("borderUtil")

function borderUtil:AddBorder(scrollV)
    local Border = require("uiscripts/commonGameObj/Border")
    local border = Border(scrollV)
end

return borderUtil