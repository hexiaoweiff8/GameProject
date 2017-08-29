local class = require("common/middleclass")
local upSkill_model=class("upSkill_model", wnd_cardyc_model)
--[[
                    技能部分
]]
--技能图标的位置
upSkill_model.skill_position_Table = {{x=0,y=91,z=0},{x=-142.5,y=-29,z=0},{x=142.5,y=-29,z=0},{x=-100.5,y=-195,z=0},{x=100.5,y=-195,z=0}}--图的位置 --100.5
upSkill_model.skill_ID_Table = {}
--初始化当前卡牌技能ID表
function upSkill_model:init_skillIDTable()
    for i=1,5 do
        local skillid = cardUtil:getSkillID(self.cardId, i)
        self.skill_ID_Table[i] = skillid
    end
end
--判断技能是否可以升级
function upSkill_model:isCan_UpSkill(index)
    local lv = self.skill_Lv_Table[index]

    if lv >= Const.MAX_SKILL_LV then
        print("已达最大等级！！！")
        return stringUtil:getString(20401)
    end
    if index > self.starLv then
        print("请先提升卡牌星级")
        return string.format(stringUtil:getString(20402), index)
    end
      --a.    技能等级<卡牌军阶  --b.  升级所需技能点≤持有技能点
    --判断技能等级<卡牌军阶
    if lv >= self.qualityLv then
        print("请先提升卡牌军阶")
        return stringUtil:getString(20403)
    end
    --判断升级所需技能点≤持有技能点
    local skcost= skillUtil:getUpSkillNeedPoints(lv + 1)--获取升级所需的技能点
    if skcost >= self.totalSkPt then
        print("技能点数不足，请前往xxx获取")
        return stringUtil:getString(20404)
    end
    return 0
end


return upSkill_model