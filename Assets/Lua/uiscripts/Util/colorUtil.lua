--[[
    颜色类
]]
local class = require("common/middleclass")
COLOR = class("COLOR")
    COLOR.Gray = Color(105/255,105/255,105/255,255/255)
    COLOR.White = Color(255/255,255/255,255/255,255/255)
    COLOR.Green = Color(0/255,255/255,0/255,255/255)
    COLOR.Red = Color(255/255,0/255,0/255,255/255)
return COLOR

