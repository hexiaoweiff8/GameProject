
wnd_biandui_model =
{
    local_armycarduselimit = {},--本地军队卡牌使用上限数据表
    CardItemList  = {},
    DayingItemList = {},
    QianfengItemList = {},
}

local this = wnd_biandui_model

function wnd_biandui_model:initModel()
    this:initCardItemList()
end

function wnd_biandui_model:SetArmyData(battle)
    --TODO: 解析服务器读来的大营及前锋数据
    print("SetArmyData-----------------")
    print("数据数量..."..tostring(#battle))
    print("数据数量..."..tostring(#battle.gf))
    print("数据数量..."..tostring(#battle.pf))

    this.DayingItemList = {}
    if(#battle.gf>0) then
        for i=1,#battle.gf do
            local GfItem = {}
            GfItem["cardId"] = battle.gf[i]["cardId"]
            GfItem["num"] = battle.gf[i]["num"]
            table.insert(this.DayingItemList,GfItem)
        end
    end

    this.QianfengItemList = {}
    for i =1,6 do
        if(battle.pf[i] == 0) then
            this.QianfengItemList[i] = 0
        else
            this.QianfengItemList[i] = battle.pf[i]
        end
    end
end

--@Des 读取卡库中卡牌信息
function wnd_biandui_model:initCardItemList()
    this.CardItemList = {}
    for k,v in pairs(cardModel:getCardTbl()) do
        local Item = {}
        Item["Quality"] = v.rlv
        Item["Star"] = v.star
        Item["Level"] = v.lv
        Item["ArmyCardID"] = v.id
        Item["Icon"] = cardUtil:getCardIcon(v.id)
        Item["ArmyType"] = cardUtil:getCardPropValue("ArmyType", v.id, v.lv)--卡牌类型（人，妖，械）
        Item["useLimit"] = sdata_armycarduselimit_data:GetFieldV("UseLimit",tonumber(tostring(v.id).."0"..tostring(v.slv)))
        Item["TrainCost"] = sdata_armycardbase_data:GetFieldV("TrainCost",v.id)--卡牌训练费用（兵力）
        Item["Num"] = Item["useLimit"]
        table.insert(this.CardItemList,Item)
    end
end

function wnd_biandui_model:GetDayingData()
    return this.DayingItemList
end

function wnd_biandui_model:GetQianfengData()
    return this.QianfengItemList
end

return wnd_biandui_model