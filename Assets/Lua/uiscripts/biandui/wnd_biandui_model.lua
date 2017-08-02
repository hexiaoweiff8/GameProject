
wnd_biandui_model =
{
    local_armycardbase = {}, --本地军队卡牌基础数据表
    local_armycarduselimit = {},--本地军队卡牌使用上限数据表
    local_armybase = {},--本地军队基础表
}

local this = wnd_biandui_model

function wnd_biandui_model:initModel()
    this:initLocalArmyCardBase()
    this:initLocalArmyCardUseLimit()
    this:intiLocalArmyBase()
end

function wnd_biandui_model:initLocalArmyCardBase()
    if sdata_armycardbase_data == nil then
        print("没获取到以下数据：sdata_armycardbase_data")
        return
    end
    for k,v in pairs(sdata_armycardbase_data.mData.body) do
        local Tab = {}
        Tab["ArmyCardID"] = v[sdata_armycardbase_data.mFieldName2Index['ArmyCardID']]
        Tab["Name"] = v[sdata_armycardbase_data.mFieldName2Index['Name']]
        Tab["Des"] = v[sdata_armycardbase_data.mFieldName2Index['Des']]
        Tab["Rarity"] = v[sdata_armycardbase_data.mFieldName2Index['Rarity']]
        Tab["TrainCost"] = v[sdata_armycardbase_data.mFieldName2Index['TrainCost']]
        Tab["IconID"] = v[sdata_armycardbase_data.mFieldName2Index['IconID']]
        Tab["ModelID"] = v[sdata_armycardbase_data.mFieldName2Index['ModelID']]
        Tab["UseLimit"] = v[sdata_armycardbase_data.mFieldName2Index['UseLimit']]
        Tab["ArrayID"] = v[sdata_armycardbase_data.mFieldName2Index['ArrayID']]
        Tab["AreaLimit"] = v[sdata_armycardbase_data.mFieldName2Index['AreaLimit']]
        Tab["ArmyID"] = v[sdata_armycardbase_data.mFieldName2Index['ArmyID']]
        Tab["ArmyUnit"] = v[sdata_armycardbase_data.mFieldName2Index['ArmyUnit']]
        table.insert(this.local_armycardbase,Tab)
    end
    table.sort(this.local_armycardbase,function(a,b)
        return a["ArmyCardID"] < b["ArmyCardID"]
    end)
end

--@Des 利用ArmyCardID查找对应卡牌的图标ID
--@params ArmyCardID(number)：卡牌ID
--@return IconID:卡牌图标ID
function wnd_biandui_model:FindIconIDByArmyCardID(ArmyCardID)
    for i = 1,#this.local_armycardbase do
        if this.local_armycardbase[i]["ArmyCardID"] == ArmyCardID then
            return this.local_armycardbase[i]["IconID"]
        end
    end
    return nil
end

--@Des 利用ArmyCardID查找对应卡牌的使用费用
--@params ArmyCardID(number)：卡牌ID
--@return TrainCost:卡牌使用费用
function wnd_biandui_model:FindTrainCostbYArmyCardID(ArmyCardID)
    for i = 1,#this.local_armycardbase do
        if this.local_armycardbase[i]["ArmyCardID"] == ArmyCardID then
            return this.local_armycardbase[i]["TrainCost"]
        end
    end

    return nil
end

function wnd_biandui_model:initLocalArmyCardUseLimit()
    if sdata_armycarduselimit_data == nil then
        print("没获取到以下数据：sdata_armycarduselimit_data")
        return
    end
    for k,v in pairs(sdata_armycarduselimit_data.mData.body) do
        local Tab = {}
        Tab["UniqueID"] = v[sdata_armycarduselimit_data.mFieldName2Index['UniqueID']]
        Tab["ArmyCardID"] = v[sdata_armycarduselimit_data.mFieldName2Index['ArmyCardID']]
        Tab["UseLimitLevel"] = v[sdata_armycarduselimit_data.mFieldName2Index['UseLimitLevel']]
        Tab["UseLimit"] = v[sdata_armycarduselimit_data.mFieldName2Index['UseLimit']]
        table.insert(this.local_armycarduselimit,Tab)
    end
    table.sort(this.local_armycarduselimit,function(a,b)
        return a["UniqueID"] < b["UniqueID"]
    end)
end

--@Des 利用ArmyCardID查找对应卡牌的使用上限
--@params ArmyCardID(number):卡牌ID
--        UseLimitLevel(number):使用上限等级
--@return UseLimit:卡牌使用上限
function wnd_biandui_model:FindUseLimitByIDandLevel(ArmyCardID,UseLimitLevel)
    for i = 1,#this.local_armycarduselimit do
        if this.local_armycarduselimit[i]["ArmyCardID"] == ArmyCardID then
            if(this.local_armycarduselimit[i]["UseLimitLevel"] == UseLimitLevel) then
                return this.local_armycarduselimit[i]["UseLimit"]
            end
        end
    end
    return nil
end


function wnd_biandui_model:intiLocalArmyBase()
    if sdata_armybase_data == nil then
        print("没获取到以下数据：sdata_armycarduselimit_data")
        return
    end
    for k,v in pairs(sdata_armybase_data.mData.body) do
        local Tab = {}
        Tab["UniqueID"] = v[sdata_armybase_data.mFieldName2Index['UniqueID']]
        Tab["ArmyID"] = v[sdata_armybase_data.mFieldName2Index['ArmyID']]
        Tab["ArmyType"] = v[sdata_armybase_data.mFieldName2Index['ArmyType']]
        table.insert(this.local_armybase,Tab)
    end
    table.sort(this.local_armybase,function(a,b)
        return a["UniqueID"] < b["UniqueID"]
    end)
end

--@Des 利用ArmyCardID查找对应卡牌的卡牌类型
--@params ArmyCardID(number):卡牌ID
--@return ArmyType:卡牌类型
function wnd_biandui_model:FindArmyTypeByArmyID(ArmyCardID)
    for i = 1,#this.local_armybase do
        if this.local_armybase[i]["ArmyID"] == ArmyCardID then
            return this.local_armybase[i]["ArmyType"]
        end
    end
    return nil
end

return wnd_biandui_model