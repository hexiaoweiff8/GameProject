local upSkill_model={}


--获取数据库信息
function upSkill_model:getDatas(cardIndex)
    print("================upSkill_model:getDatas============start===========")
    local _currencyTbl = currencyModel:getCurrentTbl()
    local _cardTbl = cardModel:getCardTbl()
    if _currencyTbl == nil or _cardTbl == nil then
        return false
    end 
    if not _cardTbl[cardIndex] then
        return false
    end
    self.badgeNum = _currencyTbl.coin --兵牌
    self.totalSkPt = _currencyTbl.skillpt --技能点
    self.cardId =_cardTbl[cardIndex].id
    self.cardLv =_cardTbl[cardIndex].lv
    self.starLv =_cardTbl[cardIndex].star
    self.qualityLv = _cardTbl[cardIndex].rlv
    self.skill_Lv_Table = _cardTbl[cardIndex].skill
    self:init_skillIDTable()
    print("================upSkill_model:getDatas============end===========")
    return true
    
end



--[[
                    技能部分
]]
--技能图标的位置
upSkill_model.skill_position_Table = {{x=0,y=91,z=0},{x=-142.5,y=-29,z=0},{x=142.5,y=-29,z=0},{x=-100.5,y=-195,z=0},{x=100.5,y=-195,z=0}}--图的位置 --100.5
upSkill_model.skill_ID_Table = {}
--初始化当前卡牌技能ID表
function upSkill_model:init_skillIDTable()
    for i=1,5 do
        local skillid = skillUtil:getSkillIDByCard(self.cardId, self.cardLv, i)
        self.skill_ID_Table[i] = skillid
    end
end
--判断技能是否可以升级
function upSkill_model:isCan_UpSkill(index)
    local lv =self.skill_Lv_Table[index]
    if lv >= Const.MAX_SKILL_LV then
        print("已达最大等级！！！")
        tipsText = stringUtil:getString(20401)
        return tipsText
    end
    if index > self.starLv then
        print("请先提升卡牌星级")
        tipsText = string.format(stringUtil:getString(20402), index)
        return tipsText
    end
      --a.    技能等级<卡牌军阶  --b.  升级所需技能点≤持有技能点
    --判断技能等级<卡牌军阶
    if lv >= self.qualityLv then
        print("请先提升卡牌军阶")
        tipsText = stringUtil:getString(20403)
        return tipsText
    end
    --判断升级所需技能点≤持有技能点
    local skcost= skillUtil:getUpSkillNeedPoints(lv + 1)--获取升级所需的技能点
    if skcost >= self.totalSkPt then
        print("技能点数不足，请前往xxx获取")
        tipsText = stringUtil:getString(20404)
        return tipsText
    end
    return 0
end


return upSkill_model