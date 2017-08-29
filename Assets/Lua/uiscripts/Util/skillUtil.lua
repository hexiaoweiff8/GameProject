--[[
    技能信息表的工具类。技能表后期要改
]]

local class = require("common/middleclass")
local skillList = {}

skillUtil = class("skillUtil")

--[[
    获取技能升至该等级所需技能点
    skillLv     技能等级
]]
function skillUtil:getUpSkillNeedPoints(skillLv)
    return sdata_armycardskillcost_data:GetFieldV("SkillPt",skillLv)
end

--[[
    通过技能ID获取名称
    skillId     技能ID
]]
function skillUtil:getSkillName(skillId)
    if not skillList[skillId] then
        skillList[skillId] = SkillManager.Single:CreateSkillInfo(skillId,1)
    end
    return skillList[skillId].SkillName
end
--[[
    通过技能ID获取技能Icon
    skillId     技能ID
]]
function skillUtil:getSkillIcon(skillId)
    if not skillList[skillId] then
        skillList[skillId] = SkillManager.Single:CreateSkillInfo(skillId,1)
    end
    return skillList[skillId].Icon
end
--[[
    通过技能ID获取技能详细描述
    skillId     技能ID
    skillLV     技能等级
]]
function skillUtil:getSkillDescription(skillId,skillLv)
    skillList[skillId] = SkillManager.Single:CreateSkillInfo(skillId,skillLv)
    return skillList[skillId].Description
end

return skillUtil