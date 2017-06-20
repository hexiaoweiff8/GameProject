--[[
    字符串表的工具类
    UILiteral
]]
local class = require("common/middleclass")
stringUtil = class("stringUtil")


--[[
    根据字符串id获取相应的中文字符串
    stringCode  字符串ID
]]
function stringUtil:getString( stringCode )
    return sdata_UILiteral:GetV(sdata_UILiteral.I_Literal, stringCode)
end

return stringUtil