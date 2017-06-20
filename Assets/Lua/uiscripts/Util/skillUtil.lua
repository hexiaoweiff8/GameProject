--[[
    技能信息表的工具类。技能表后期要改
]]

local class = require("common/middleclass")
skillUtil = class("skillUtil")

--[[
    根据卡牌的信息获取技能ID
    cardId  卡牌id
    cardLv  卡牌等级
    index   开牌技能的index（卡牌的第几个技能）
]]
function skillUtil:getSkillIDByCard( cardId, cardLv, index )
    -- body
    local uid = tonumber(string.format("%d%.3d", cardId, cardLv))--通过卡牌id和卡牌等级联合获取
    return sdata_armybase_data:GetFieldV("Skill"..index, uid)
end

--[[
    获取技能升至该等级所需技能点
    skillLv     技能等级
]]
function skillUtil:getUpSkillNeedPoints(skillLv)
    return sdata_armycardskillcost_data:GetFieldV("SkillPt",skillLv)
end

--[[
    通过卡牌星级获取该星级解锁技能名称
    cardId  卡牌id
    cardLv  卡牌等级
    starLv  卡牌星级
]]
function skillUtil:getSkillNameByCard(cardId,cardLv,starLv)
    if starLv > 5 then 
        return
    end 
    --通过卡牌id和卡牌等级联合获取
    local uid = tonumber(string.format("%d%.3d",cardId,cardLv))
    local skillid = sdata_armybase_data:GetFieldV("Skill"..starLv, uid)
    return sdata_skill_data:GetFieldV("Name",tonumber(skillid))
end
--[[
    通过技能ID获取名称
    skillid     技能ID
]]
function skillUtil:getskillNameByID(skillid)
    return sdata_skill_data:GetFieldV("Name",skillid)
end
--[[
    通过技能ID获取技能Icon
    skillid     技能ID
]]
function skillUtil:getskillIconByID(skillid)
    return sdata_skill_data:GetFieldV("SkillIcon",skillid)
end
--[[
    通过技能ID获取技能详细描述
    skillid     技能ID
]]
function skillUtil:getskillDesByID(skillid)
    return sdata_skill_data:GetFieldV("Des",skillid)
end

return skillUtil