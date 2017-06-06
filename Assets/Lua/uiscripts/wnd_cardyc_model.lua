local wnd_cardyc_model={}



wnd_cardyc_model.Const={
    MAX_STAR_LV = 7,
    MAX_QUALITY_LV = 16,
    MAX_USERROLE_LV = 80,
    MAX_CARD_LV = 80,
    MAX_SKILL_LV = 16,
    MAX_ARMY_LV  = 8,
    MAX_SYNERGY_LV = 1,
    SLOT_NUM=4
}

wnd_cardyc_model.userInfo={
    --初始化角色经济属性
    goldNum = nil,      --金币
    diamond = nil,      --钻石
    totalSkPt = nil,    --技能点
    expPool = nil,      --经验池
    badgeNum = nil,     --兵牌
    tili = nil,         --体力

    --初始化角色属性
    useRoleExp = nil,
    userRoleLv= nil,
    itemList = {}       --背包
}


wnd_cardyc_model.cardInfo={
    --初始化卡牌属性
    cardId = nil,
    cardLv = nil,
    cardExp  = nil,
    starLv = nil,
    soldierLv = nil,
    qualityLv = nil,
    cardFragment = nil,
    slotState = {0,0,0,0},
    skill_Lv_Table = {},    --保存该卡片所有技能等级的表
    synergyLvTbl = {}           --协同表
}






--获取数据库信息
function wnd_cardyc_model:getDatas(cardIndex)
    print("================wnd_cardyc_model:getDatas============start===========")
    if currencyTbl == nil or cardTbl == nil or userRoleTbl == nil  then
        return false
    end 
    if not self:isHaveCard(cardIndex) then
        return false
    end 

    self.userInfo.goldNum = currencyTbl["gold"] --金币
    self.userInfo.diamond = currencyTbl["diamond"] --钻石
    self.userInfo.totalSkPt = currencyTbl["skillpt"] --技能点
    self.userInfo.expPool = currencyTbl["expPool"]--经验池
    self.userInfo.badgeNum = currencyTbl["coin"] --兵牌
    self.userInfo.tili = currencyTbl["tili"] --体力
    self.userInfo.useRoleExp = userRoleTbl["exp"]
    self.userInfo.itemList = userRoleTbl["item"]         --背包
    self.userInfo.userRoleLv= userRoleTbl["lv"]
    self.userInfo.userRoleLv= 80

    self.cardInfo.cardId =cardTbl[cardIndex].id
    self.cardInfo.cardLv = cardTbl[cardIndex].lv
    self.cardInfo.cardExp  = cardTbl[cardIndex].exp
    self.cardInfo.starLv = cardTbl[cardIndex].star
    self.cardInfo.soldierLv = cardTbl[cardIndex].slv
    self.cardInfo.qualityLv = cardTbl[cardIndex].rlv
    self.cardInfo.cardFragment = cardTbl[cardIndex].num
    self.cardInfo.slotState = cardTbl[cardIndex].slot
    self.cardInfo.skill_Lv_Table = cardTbl[cardIndex].skill
    self.cardInfo.synergyLvTbl = cardTbl[cardIndex].team--协同表
    print(cardTbl[cardIndex].team[1],cardTbl[cardIndex].team[2],cardTbl[cardIndex].team[3],cardTbl[cardIndex].team[4])
    self:init_upQualityItems()
    self:init_skillIDTable()
    
    self:init_synergyIDTbl()
    self:init_synergyStateTbl()
    print("================wnd_cardyc_model:getDatas============end===========")
    return true
    
end

--[[
    获取卡牌的基础信息
    ]]
--获取卡牌数量
function wnd_cardyc_model:getCardNum()
    return #cardTbl
end
--判断是否有卡牌
function wnd_cardyc_model:isHaveCard(cardIndex)
    -- body
    if cardTbl[cardIndex] then 
        return true
    end
    return false
end
--获取卡片信息
function wnd_cardyc_model:getCardInfo(property, cardId)
    return sdata_armycardbase_data:GetFieldV(property, cardId)
end
--获取卡牌对象
function wnd_cardyc_model:getCardByID(cardId)
    for k,v in ipairs(cardTbl) do
        if v.id == cardId then
            return v
        end
    end
    return nil
end


--获取字符串
function wnd_cardyc_model:getString( ... )
    -- body
    return sdata_UILiteral:GetV(sdata_UILiteral.I_Literal, ...)
end



--[[
    兵种克制部分
]]
-- 获取卡牌兵种
function wnd_cardyc_model:getCardArmyType(cardId)
    return cardId % 101000
end
--获取克制信息
function wnd_cardyc_model:getSuppressInfo(property,ArmyType)
    return sdata_kezhi_data:GetFieldV(property, ArmyType)
end
--根据兵种类型获取兵种信息---兵种信息表不存在
-- function wnd_cardyc_model:getArmyTypeInfo(property,ArmyType)
-- end

--[[
    卡牌进阶部分
]]
wnd_cardyc_model.EquipState = {--插槽装备状态
    Enable_NotEnough= 0,  --未激活 材料不足
    Active = 1,           --已激活
    Enable_Enough = 2,    --未激活 有材料
}
wnd_cardyc_model.qualityPropName={--阶品表的属性名称
    "CardQualityAttack",
    "CardQualityHP",
    "CardQualityDefense"
}
wnd_cardyc_model.upQualityNeedItems={}--当前进阶所需的物品
wnd_cardyc_model.upQualityHaveItems={}--当前进阶所需的物品拥有的信息
--判断卡牌是否可以进阶
function wnd_cardyc_model:isCan_UpQuality()

    if self.cardInfo.qualityLv == self.Const.MAX_QUALITY_LV then
        print("已达最大阶品！！！！")
        tipsText = self:getString(20101)
        return tipsText
    end
    for i=1,#self.cardInfo.slotState do
        if self.cardInfo.slotState[i]==self.EquipState.Enable_NotEnough then
            print("材料不足！！！！！")--不满足：提示缺少材料
            tipsText = self:getString(20102)
        return tipsText
        elseif self.cardInfo.slotState[i]==self.EquipState.Enable_Enough then
            print("尚未激活！！！！！")--不满足：提示尚未激活
            tipsText = self:getString(20103)
        return tipsText
        end
    end
    local limitLv = self:getLimitLvFromQualityLv( self:GetNextQualityLv() )
    if self.cardInfo.cardLv < limitLv then
        print(string.format("晋阶需要%d级", limitLv))--不满足：提示晋阶需要xx级
        tipsText = string.format(self:getString(20104), limitLv)
        return tipsText
    end
    return 0
end
--获取卡牌进阶的属性信息
function wnd_cardyc_model:getCardQualityInfo( property ,cardId, qualityLv )
    -- body
    local uid = tonumber(string.format("%d%.2d",cardId,qualityLv))
    return sdata_armycardquality_data:GetFieldV(property, uid)
end
--获取卡牌进阶所需的金币
function wnd_cardyc_model:getUpQualityNeedGold(qualityLv)
    -- body
    return sdata_armycardqualitycost_data:GetV(sdata_armycardqualitycost_data.I_Gold, qualityLv) 
end
--初始化进阶  所需的物品  以及  已有的物品
function wnd_cardyc_model:init_upQualityItems()
    -- body
    if self.cardInfo.qualityLv >= self.Const.MAX_QUALITY_LV then
        return
    end
    -- self.cardInfo.slotState = {2,2,2,2}
    local uid = tonumber(string.format("%d%.2d",self.cardInfo.cardId,self.cardInfo.qualityLv+1))--通过卡牌id和军阶等级联合获取
    for i=1,#self.cardInfo.slotState do
        
        local needItem={}
        needItem.name = sdata_armycardquality_data:GetFieldV("CardEquip"..i,uid)
        needItem.id = sdata_armycardquality_data:GetFieldV("ItemID"..i,uid)
        needItem.num = sdata_armycardquality_data:GetFieldV("Num"..i,uid)
        self.upQualityNeedItems[i] = needItem

        local haveItem={}
        haveItem.name = needItem.name
        haveItem.id = needItem.id
        haveItem.num = 0
        for _,v in pairs(self.userInfo.itemList) do
            if v.id == needItem.id then 
                haveItem.num = v.num
            end
        end
        self.upQualityHaveItems[i] = haveItem
        if self.cardInfo.slotState[i] == self.EquipState.Enable_NotEnough then 
            if self.upQualityHaveItems[i].num >= self.upQualityNeedItems[i].num then 
                self.cardInfo.slotState[i] = self.EquipState.Enable_Enough
            end
        end
    end
end
--根据卡牌的阶品获取卡牌的限制等级
function wnd_cardyc_model:getLimitLvFromQualityLv(qualityLv)
    -- body
    return sdata_armycardqualityshow_data:GetFieldV("CardLevel", qualityLv)
end
--获取下一品阶等级
function wnd_cardyc_model:GetNextQualityLv()
    if self.cardInfo.qualityLv  then
        if self.cardInfo.qualityLv < self.Const.MAX_QUALITY_LV then
            return self.cardInfo.qualityLv+1
        end
        return self.Const.MAX_QUALITY_LV
    end
end
--获得卡牌名(名+品质)
function wnd_cardyc_model:getCardName_With_Quality(cardId, qualityLv)
    --cardId is not nil
    local name = self:getCardInfo("Name",cardId)
    if qualityLv ~= nil then
        local plusNum = sdata_armycardqualityshow_data:GetFieldV("PlusNum", qualityLv)--@1
        if plusNum>0 then 
            name = string.format("%s+%d",name,plusNum)
        end
    end
    return name
end
--根据品阶获得颜色
function wnd_cardyc_model:getColor_With_Quality(qualityLv)
    local colorType = sdata_armycardqualityshow_data:GetFieldV("QualityColor", qualityLv)
    if colorType == 1 then
        Color = Color(255/255,255/255,255/255,255/255)--白
    elseif  colorType == 2 then
         Color = Color(0/255,128/255,0/255,255/255)--绿
    elseif  colorType == 3 then
         Color = Color(0/255,0/255,255/255,255/255)--蓝
    elseif  colorType == 4 then
         Color = Color(128/255,0/255,128/255,255/255)--紫
    elseif  colorType == 5 then
         Color = Color(255/255,165/255,0/255,255/255)--橙
    elseif  colorType == 6 then
         Color = Color(255/255,0/255,0/255,255/255)--红
    end
    return Color
end


--[[
                    卡牌升级部分

]]
--判断是否可以升级
function wnd_cardyc_model:isCan_UpLevel()
    if self.cardInfo == self.Const.MAX_CARD_LV then
        print("已达最大卡牌等级")
        tipsText = self:getString(20201)
        return tipsText
    end
    if self.userInfo.expPool == 0 then
        print("可分配经验不足") 
        tipsText = self:getString(20202)
        return tipsText
    end
    local needExp = self:getCardNeedExp() --升级下一级所需经验
    if self.cardInfo.cardLv >= self.userInfo.userRoleLv then
        print("卡牌等级不能超过角色等级，请先提升角色等级")
        tipsText = self:getString(20203)
        return tipsText
    end
    return 0
end
--获取卡牌下一等级
function wnd_cardyc_model:getCardNextLv()
    if self.cardInfo.cardLv then
        if self.cardInfo.cardLv < self.Const.MAX_CARD_LV then
            return self.cardInfo.cardLv+1
        end
        return self.Const.MAX_CARD_LV
    end
end
--获取卡牌升级所需的经验值
function wnd_cardyc_model:getCardNeedExp()
    return sdata_armycardexp_data:GetFieldV("CardExp",self:getCardNextLv())
end



--[[

                    卡牌升星部分

]]
--判断是否可以升星
function wnd_cardyc_model:isCan_UpStar()
    --是否达到最大星级
    if self.cardInfo.starLv ==self.Const.MAX_STAR_LV then
        print("卡牌已达最大星级")
        tipsText = self:getString(20301)
        return tipsText
    end
    --所需碎片是否足够
    if self:getUpStarNeedFragment() > self.cardInfo.cardFragment then
        print("卡牌升星所需碎片不足")
        tipsText = self:getString(20302)
        return tipsText
    end
    --所需兵牌是否足够
    if self:getUpStarNeedCoin() > self.userInfo.badgeNum then
        print("卡牌升星所需兵牌不足")
        tipsText = self:getString(20303)
        return tipsText
    end
    return 0
end
function wnd_cardyc_model:GetNextStarLv()
    if self.cardInfo.starLv  then
        if self.cardInfo.starLv < self.Const.MAX_STAR_LV then
            return self.cardInfo.starLv+1
        end
        return self.Const.MAX_STAR_LV
    end
end
function wnd_cardyc_model:getCardStarInfo( property ,cardId, starLv )
    -- body
    local uid = tonumber(string.format("%d%.2d",cardId,starLv))
    return sdata_armycardstar_data:GetFieldV(property, uid)
end
function wnd_cardyc_model:getUpStarNeedFragment()
    -- body
    return sdata_armycardstarcost_data:GetFieldV("CardNum", self:GetNextStarLv()) 
end
function wnd_cardyc_model:getUpStarNeedCoin()
    -- body
    return sdata_armycardstarcost_data:GetFieldV("Coin", self:GetNextStarLv()) 
end


--[[
                    技能部分
]]
--技能图标的位置
wnd_cardyc_model.skill_position_Table = {{x=0,y=91,z=0},{x=-142.5,y=-29,z=0},{x=142.5,y=-29,z=0},{x=-100.5,y=-195,z=0},{x=100.5,y=-195,z=0}}--图的位置 --100.5
wnd_cardyc_model.skill_ID_Table = {}
--初始化当前卡牌技能ID表
function wnd_cardyc_model:init_skillIDTable()
    self.skill_ID_Table={}
    local uid = tonumber(string.format("%d%.3d",self.cardInfo.cardId,self.cardInfo.cardLv))--通过卡牌id和卡牌等级联合获取
    for i=1,5 do
        local skillid = sdata_armybase_data:GetFieldV("Skill"..i, uid)
        table.insert(self.skill_ID_Table, skillid)
    end
end
--判断技能是否可以升级
function wnd_cardyc_model:isCan_UpSkill(index)
    local lv =self.cardInfo.skill_Lv_Table[index]
    if lv >= self.Const.MAX_SKILL_LV then
        print("已达最大等级！！！")
        tipsText = self:getString(20401)
        return tipsText
    end
    if index > self.cardInfo.starLv then
        print("请先提升卡牌星级")
        tipsText = string.format(self:getString(20402), index)
        return tipsText
    end
      --a.    技能等级<卡牌军阶  --b.  升级所需技能点≤持有技能点
    --判断技能等级<卡牌军阶
    if self:GetNextSkillLv(lv,self.Const.MAX_SKILL_LV) > self.cardInfo.qualityLv then
        print("请先提升卡牌军阶")
        tipsText = self:getString(20403)
        return tipsText
    end
    --判断升级所需技能点≤持有技能点
    local skcost= self:getUpSkillNeedPoints(self:GetNextSkillLv(lv ,self.Const.MAX_SKILL_LV))--获取升级所需的技能点
    if skcost >= self.userInfo.totalSkPt then
        print("技能点数不足，请前往xxx获取")
        tipsText = self:getString(20404)
        return tipsText
    end
    return 0
end
--获取技能升级所需技能点
function wnd_cardyc_model:getUpSkillNeedPoints(skillLv)

    return sdata_armycardskillcost_data:GetFieldV("SkillPt",skillLv)

end
--获取下一技能等级
function wnd_cardyc_model:GetNextSkillLv(lv, maxlv)
    if lv  then
        if lv < maxlv then
            return lv+1
        end
        return maxlv
    end
end
--通过卡牌信息获取技能信息
function wnd_cardyc_model:getSkillInfo(skillPropoty,cardId,cardLv,starLv)
    if starLv > 5 then 
        return
    end 
    --通过卡牌id和卡牌等级联合获取
    local uid = tonumber(string.format("%d%.3d",cardId,cardLv))
    local skillid = sdata_armybase_data:GetFieldV("Skill"..starLv, uid)
    return sdata_skill_data:GetFieldV(skillPropoty,tonumber(skillid))
end
--通过技能ID获取技能信息
function wnd_cardyc_model:getskillInfoByID(property, skillid)
    -- body
    return sdata_skill_data:GetFieldV(property,skillid)
end

--[[
                        兵员部分
]]
--判断是否可以提升兵员等级
function wnd_cardyc_model:isCan_UpSoldier()
    --判断等级
    if self.cardInfo.soldierLv >= self.Const.MAX_ARMY_LV then
        print("兵员等级已达上限，不可提升")
        tipsText = self:getString(20501)
        return tipsText
    end
    --判断卡牌碎片是否足够
    if self:getUpSoldierNeedGoods("Card",self.cardInfo.soldierLv) > self.cardInfo.cardFragment then
        print("卡牌碎片不足")
        tipsText = self:getString(20502)
        return tipsText
    end
    --判断兵牌是否足够
    if self:getUpSoldierNeedGoods("Coin",self.cardInfo.soldierLv) > self.userInfo.badgeNum then
        print("兵牌碎片不足")
        tipsText = self:getString(20503)
        return tipsText
    end
    return 0
end
function wnd_cardyc_model:getUpSoldierNeedGoods(property,soldierLv)

    return sdata_armycarduselimitcost_data:GetFieldV(property,soldierLv)
end

--[[
                        协同部分
]]
wnd_cardyc_model.SynergyState = { --协同状态
    unactive = 0,--未激活
    canActive = 1,--可激活
    activated = 2,--已解锁
}
wnd_cardyc_model.synergyStateTbl = {}        --协同状态
wnd_cardyc_model.synergyIDTbl={}   -----协同ID
function wnd_cardyc_model:init_synergyStateTbl()
    -- body
    self.synergyStateTbl = {}
    for i = 1,#self.cardInfo.synergyLvTbl do
        if self.cardInfo.synergyLvTbl[i] > 0 then 
            table.insert( self.synergyStateTbl, self.SynergyState.activated )
        else 
            if self:isCan_UpSynergy(i) == 0 then 
                table.insert( self.synergyStateTbl, self.SynergyState.canActive )
            else 
                table.insert( self.synergyStateTbl, self.SynergyState.unactive )
            end
        end
    end 
end
function wnd_cardyc_model:init_synergyIDTbl()
    for i = 1,#self.cardInfo.synergyLvTbl do
        self.synergyIDTbl[i] = 101001+i
    end 
end 
function wnd_cardyc_model:isCan_UpSynergy(index)

    local isCardCan = false
    for k,v in ipairs(cardTbl) do 
        if self.synergyIDTbl[index] == v.id then 
            if v.star < self:getSynergyItemInfo("RequireCardStar",index) then 
                print("协同---卡牌星级不足！！！")
                tipsText = self:getString(20601)
                return tipsText
            end
            if v.lv < self:getSynergyItemInfo("RequireCardLevel",index) then 
                print("协同---卡牌等级不足！！！")
                tipsText = self:getString(20602)
                return tipsText
            end
            if v.rlv < self:getSynergyItemInfo("RequireCardQuality",index) then 
                print("协同---卡牌阶品不足！！！")
                tipsText = self:getString(20603)
                return tipsText
            end
            isCardCan = true
        end 
    end
    if not isCardCan then 
        print("协同---卡牌不存在！！！")
        tipsText = self:getString(20604)
        return tipsText
    end 
    if self.cardInfo.synergyLvTbl[index] >= self.Const.MAX_SYNERGY_LV then
        print("协同---已达最大等级")
        tipsText = self:getString(20605)
        return tipsText
    end
    --兵牌
    local needCoin = self:getUpSynergyCostInfo("Coin",self:getNextSynergylevel(self.cardInfo.synergyLvTbl[index],self.Const.MAX_SYNERGY_LV))
    if self.userInfo.badgeNum < needCoin then
        print("协同---不够..")
        tipsText = self:getString(20606)
        return tipsText
    end
    
    --金币
    local needgold = self:getUpSynergyCostInfo("Gold",self:getNextSynergylevel(self.cardInfo.synergyLvTbl[index],self.Const.MAX_SYNERGY_LV))
    print(needgold,self.userInfo.goldNum)

    if self.userInfo.goldNum < needgold then
        print("协同---金币不够..")
        tipsText = self:getString(20607)
        return tipsText
    end
    
    -- --等级限制
    -- if self.cardInfo.synergyLvTbl[index] >= self.cardInfo.cardLv then
    --     print("协同---请先提升卡牌等级..")
    --     return false 
    -- end

    return 0
end
function wnd_cardyc_model:getSynergyItemInfo(property,index)
    local uid = tonumber(string.format("%d%.2d",self.cardInfo.cardId,1))--通过卡牌id和协同等级联合获取协同ID
    return sdata_armycardunion_data:GetFieldV(string.format("%s%s", property, index),uid)
end
function wnd_cardyc_model:getUpSynergyCostInfo(property,unionLv)
    return sdata_armycardunioncost_data:GetFieldV(property,unionLv)
end
function wnd_cardyc_model:getNextSynergylevel(lv, maxlv)
    if lv  then
        if lv < maxlv then
            return lv+1
        end
        return maxlv
    end
end







return wnd_cardyc_model