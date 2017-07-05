local information_model = {}

--获取数据库信息
function information_model:getDatas(cardIndex)
    print("================information_model:getDatas============start===========")
    local _userRoleTbl = userModel:getUserRoleTbl()
    local _cardTbl = cardModel:getCardTbl()
    local _currencyTbl = currencyModel:getCurrentTbl()
    if _currencyTbl == nil or _cardTbl == nil or _userRoleTbl == nil  then
        return false
    end 
    if not _cardTbl[cardIndex] then
        return false
    end 
    self.goldNum = _currencyTbl["gold"] --金币
    self.badgeNum = _currencyTbl["coin"] --兵牌
    self.itemList = _userRoleTbl["item"]
    self.cardId = _cardTbl[cardIndex].id
    self.cardLv = _cardTbl[cardIndex].lv
    self.starLv = _cardTbl[cardIndex].star
    self.qualityLv = _cardTbl[cardIndex].rlv
    self.synergyLvTbl = _cardTbl[cardIndex].team--协同表
    self.slotState = _cardTbl[cardIndex].slot
    self:init_upQualityItems()
    print("================information_model:getDatas============end===========")
    return true
    
end

--[[
    卡牌进阶部分
]]

information_model.upQualityNeedItems={}--当前进阶所需的物品
information_model.upQualityHaveItems={}--当前进阶所需的物品拥有的信息
--判断卡牌是否可以进阶
function information_model:isCan_UpQuality()

    if self.qualityLv == Const.MAX_QUALITY_LV then
        print("已达最大阶品！！！！")
        tipsText = stringUtil:getString(20101)
        return tipsText
    end
    for i=1,#self.slotState do
        if self.slotState[i]==qualityUtil.EquipState.Enable_NotEnough then
            print("材料不足！！！！！")--不满足：提示缺少材料
            tipsText = stringUtil:getString(20102)
            return tipsText
        elseif self.goldNum < qualityUtil:getUpQualityNeedGold(self.qualityLv) then 
            print("金币不足！！！！！")--不满足：提示金币不足
            tipsText = stringUtil:getString(20105)
            return tipsText
        elseif self.slotState[i]==qualityUtil.EquipState.Enable_Enough then
            print("尚未激活！！！！！")--不满足：提示尚未激活
            tipsText = stringUtil:getString(20103)
            return tipsText
        end
    end
    local limitLv = qualityUtil:getLimitLvFromQualityLv(self.qualityLv + 1)
    if self.cardLv < limitLv then
        print(string.format("晋阶需要%d级", limitLv))--不满足：提示晋阶需要xx级
        tipsText = string.format(stringUtil:getString(20104), limitLv)
        return tipsText
    end
    return 0
end

--初始化进阶  所需的物品  以及  已有的物品
function information_model:init_upQualityItems()
    -- body
    if self.qualityLv >= Const.MAX_QUALITY_LV then
        return
    end
    local uid = tonumber(string.format("%d%.2d",self.cardId,self.qualityLv + 1))--通过卡牌id和军阶等级联合获取
    for i=1,#self.slotState do
        
        local needItem={}
        needItem.id = sdata_armycardquality_data:GetFieldV("ItemID"..i,uid)
        needItem.num = sdata_armycardquality_data:GetFieldV("Num"..i,uid)
        self.upQualityNeedItems[i] = needItem


        local haveItem={}
        haveItem.id = needItem.id
        haveItem.num = 0
        for _,v in pairs(self.itemList) do
            if v.id == needItem.id then 
                haveItem.num = v.num
                break
            end
        end
        self.upQualityHaveItems[i] = haveItem


        if self.slotState[i] == qualityUtil.EquipState.Enable_NotEnough then 
            if self.upQualityHaveItems[i].num >= self.upQualityNeedItems[i].num then 
                self.slotState[i] = qualityUtil.EquipState.Enable_Enough
            end
        end
    end
end

return information_model