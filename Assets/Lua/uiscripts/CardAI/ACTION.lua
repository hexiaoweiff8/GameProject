---
--- Created by Administrator.
--- DateTime: 2017/8/1 11:12
---

function EssentialChoose(DATA)
    AITEST:printyToConsole("必选选牌*********开始*****")
    if not DATA.ENEMY_ALL_POWER or DATA.ENEMY_ALL_POWER == 0 then
        AITEST:printgToConsole("对方能量为空，无必选类型")
        AITEST:printyToConsole("必选选牌*********结束*****")
        return nil
    end


    local key = 1
    local rowValue = sdata_essentialfilter_data:GetRow(key)
    repeat
        ---获取表中数据
        local TargetTacticTypeID = rowValue[2]
        local ChooseTacticTypeID = rowValue[3]
        local ChooseCondition = rowValue[4]
        local SecondCondition = rowValue[5]
        ---判断要选择的类型是否存在
        if DATA.TYPE_CARD[ChooseTacticTypeID] then
            ---计算相应的费用
            local TargetTacticTypeCost = DATA.ENEMY_POWER[TargetTacticTypeID]
            local ChooseTacticTypeCost = DATA.ENEMY_POWER[ChooseTacticTypeID]
            local TargetTacticTypeCostScale = TargetTacticTypeCost/DATA.ENEMY_ALL_POWER
            ---判断是否满足必选条件
            if TargetTacticTypeCostScale > ChooseCondition and ChooseTacticTypeCost < TargetTacticTypeCost * SecondCondition then


                for i = 1, #DATA.TYPE_CARD[ChooseTacticTypeID] do
                    local chooseCardID = DATA.TYPE_CARD[ChooseTacticTypeID][i]
                    if DATA.CARD_NUM[chooseCardID] ~= 0 then
                        AITEST:printgToConsole("必选类型为="..ChooseTacticTypeID)
                        AITEST:printgToConsole("必选卡牌为="..chooseCardID)
                        AITEST:printyToConsole("必选选牌*********结束*****")
                        return chooseCardID
                    end
                end
            end
        end
        key = key + 1
        rowValue = sdata_essentialfilter_data:GetRow(key)
    until( not rowValue )
    AITEST:printgToConsole("没有符合条件的必选类型")
    AITEST:printyToConsole("必选选牌*********结束*****")
    return nil
end


function ExcludeChoose(DATA)
    AITEST:printyToConsole("排除选牌*********开始*****")
    local excludeList = {}
    sdata_excludefilter_data:Foreach(
    function(key,value)
        ---获取表数据
        local TargetTacticTypeID = value[2]
        local ExcludeTacticTypeID = value[3]
        local ExcludeCondition = value[4]
        ---计算敌方类型费用比例
        local EnemyTacticTypeScale = DATA.ENEMY_POWER[TargetTacticTypeID]/DATA.ENEMY_ALL_POWER
        ---如果符合条件，则确定我方排除类型
        if EnemyTacticTypeScale > ExcludeCondition then
            AITEST:printgToConsole("排除类型为="..ExcludeTacticTypeID)
            excludeList[ExcludeTacticTypeID] = 1
        end
    end)
    AITEST:printyToConsole("排除选牌*********结束*****")
    return excludeList
end

---
---
---套路选牌方法
---DATA             当前AI数据
---ExcludeList      排除类型表
---
---
function ComboChoose(DATA,ExcludeList)
    AITEST:printyToConsole("套路选牌*********开始*****")
    ---按照套路表的顺序判断是否有符合条件的套路卡牌
    for ComboIndex =1 ,#DATA.COMBO_FILTER do
        local targetCardID = DATA.COMBO_FILTER[ComboIndex][1]
        local comboCardList = DATA.COMBO_FILTER[ComboIndex][2]
        local minCostCondition = DATA.COMBO_FILTER[ComboIndex][3]
        ---计算场上目标卡牌的总费
        local nowCost = FightDataStatistical.Single:GetCostData(2,targetCardID,-1,-1,-1,-1,-1,-1,-1,-1)
        ---如果符合套路条件判断是否有可以配合的卡牌
        if nowCost > minCostCondition then
            for ChooseCardIndex = 1, #comboCardList do
                if not ExcludeList[comboCardList[ChooseCardIndex]] and DATA.CARD_NUM[comboCardList[ChooseCardIndex]] ~= 0 then
                    AITEST:printgToConsole("套路卡牌为======"..comboCardList[ChooseCardIndex])
                    AITEST:printyToConsole("套路选牌*********结束*****")
                    return comboCardList[ChooseCardIndex]
                end
            end
        end
    end
    if DATA.maxFightCard then
        AITEST:printgToConsole("无套路卡牌，选择战斗力最大的卡牌为="..DATA.maxFightCard)
        AITEST:printyToConsole("套路选牌*********结束*****")
        return DATA.maxFightCard
    end
    AITEST:printgToConsole("无套路卡牌，战斗力最大的卡牌不存在，可能是卡牌剩余数量为空")
    AITEST:printyToConsole("套路选牌*********结束*****")
    return nil
end


---
---等待出牌
---
---
function WAIT_DROP(DATA,OKCallBack)
    if DATA.NEXT_CARD and DATA.NEXT_CARD ~= 0 then
        if DATA.POOL_COST >= DATA.NEED_POWER then
            OKCallBack(_,DATA.NEXT_CARD)
            return false
        end
        return true
    end
    return false
end

---
---吞牌
---
function EAT(DATA,EATCallBack)
    if not DATA.AI_STATE_BAD then
        return
    end
    if #DATA.EAT_CARD <= 0 then
        return
    end
    if DATA.LEFT_CARD_NUM < 6 then
        return
    end
    if DATA.EAT_CARD and #DATA.EAT_CARD ~= 0 then
        if DATA.CARD_NUM[DATA.EAT_CARD[1]] and DATA.CARD_NUM[DATA.EAT_CARD[1]] ~= 0 then
            EATCallBack(_,DATA.EAT_CARD[1] )
        end
    end

end