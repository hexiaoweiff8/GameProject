
wnd_zhanshu_model = {

    CardDataList = {},
    local_Literal = {}

}


local this = wnd_zhanshu_model

function wnd_zhanshu_model:initModel()
    this:InitCardDataList()
end

function wnd_zhanshu_model:InitCardDataList()
    this.CardDataList = {}

    if(sdata_armycardbase_data == nil) then
        print("未获取到以下数据sdata_armycardbase_data")
    end


    for _,k in pairs(sdata_armycardbase_data.mData.body) do
        local Item = nil
        for _,v in pairs(cardModel:getCardTbl()) do
            if( k[sdata_armycardbase_data.mFieldName2Index['ArmyCardID']] == v.id) then
                Item = {}
                Item["Quality"] = v.rlv
                Item["Star"] = v.star
                Item["Level"] = v.lv
                Item["ArmyCardID"] = v.id
                Item["CardNum"] = v.num
                Item["ArmyType"] = cardUtil:getCardProp("ArmyType", v.id, v.lv)
                Item["IconID"] = cardUtil:getCardIcon(v.id)
                Item["Name"] = cardUtil:getCardName(v.id)
                Item["Des"] = cardUtil:getCardDes(v.id)
                Item["ExchangeCoin"] = sdata_armycardbase_data:GetFieldV("ExchangeCoin",v.id)
                if(v.star == Const.MAX_STAR_LV) then
                    Item["StarCost"] = sdata_armycardstarcost_data:GetFieldV("CardNum",Const.MAX_STAR_LV)
                else
                    Item["StarCost"] = sdata_armycardstarcost_data:GetFieldV("CardNum",v.star+1)
                end
                if(v.slv == Const.MAX_ARMY_LV) then
                    Item["UseLimitCost"] = sdata_armycarduselimitcost_data:GetFieldV("Card",Const.MAX_ARMY_LV)
                else
                    Item["UseLimitCost"] = sdata_armycarduselimitcost_data:GetFieldV("Card",v.slv+1)
                end
                Item["GeneralType"] = cardUtil:getCardPropValue("GeneralType",v.id,v.lv)
                Item["RangeType"] = cardUtil:getCardPropValue("RangeType",v.id,v.lv)
                Item["AimGeneralType"] = cardUtil:getCardPropValue("AimGeneralType",v.id,v.lv)
                local AllSkill = {}
                for i=1,5 do
                    local SkillInfo = {}
                    SkillInfo["SkillName"] = skillUtil:getSkillName(cardUtil:getCardProp("Skill"..tostring(i), v.id, v.lv))
                    SkillInfo["Icon"] = skillUtil:getSkillIcon(cardUtil:getCardProp("Skill"..tostring(i), v.id, v.lv))
                    SkillInfo["Des"] = skillUtil:getSkillDescription(cardUtil:getCardProp("Skill"..tostring(i), v.id, v.lv),v.skill[i])
                    SkillInfo["SkillLv"] = v.skill[i]
                    AllSkill[i] = SkillInfo
                end
                Item["AllSkill"] = AllSkill
                Item["Active"] = true
                table.insert(this.CardDataList,Item)
            end
        end
        if(Item == nil) then
            Item = {}
            local cardid = k[sdata_armycardbase_data.mFieldName2Index['ArmyCardID']]
            Item["Quality"] = 1
            Item["Star"] = k[sdata_armycardbase_data.mFieldName2Index['Rarity']]
            Item["Level"] = 1
            Item["ArmyCardID"] = cardid
            Item["CardNum"] = 0
            Item["ArmyType"] = cardUtil:getCardProp("ArmyType", cardid, 1)
            Item["IconID"] = cardUtil:getCardIcon(cardid)
            Item["Name"] = cardUtil:getCardName(cardid)
            Item["Des"] = cardUtil:getCardDes(cardid)
            Item["ExchangeCoin"] = 0
            Item["StarCost"] = 0
            Item["UseLimitCost"] = 0
            Item["GeneralType"] = cardUtil:getCardPropValue("GeneralType",cardid,1)
            Item["RangeType"] = cardUtil:getCardPropValue("RangeType",cardid,1)
            Item["AimGeneralType"] = cardUtil:getCardPropValue("AimGeneralType",cardid,1)
            local AllSkill = {}
            for i=1,5 do
                local SkillInfo = {}
                SkillInfo["SkillName"] = skillUtil:getSkillName(cardUtil:getCardProp("Skill"..tostring(i), cardid, 1))
                SkillInfo["Icon"] = skillUtil:getSkillIcon(cardUtil:getCardProp("Skill"..tostring(i), cardid, 1))
                SkillInfo["Des"] = skillUtil:getSkillDescription(cardUtil:getCardProp("Skill"..tostring(i), cardid, 1),0)
                SkillInfo["SkillLv"] = 0
                AllSkill[i] = SkillInfo
            end
            Item["AllSkill"] = AllSkill
            Item["Active"] = false
            table.insert(this.CardDataList,Item)
        end
    end
    table.sort(this.CardDataList,function(a,b)
        return a["ArmyCardID"] < b["ArmyCardID"]
    end)




    --for k,v in pairs(this.CardDataList) do
    --    print("ID----"..tostring(v["ArmyCardID"]))
    --    print("Star----"..tostring(v["Star"]))
    --    print("Quality----"..tostring(v["Quality"]))
    --    print("Level----"..tostring(v["Level"]))
    --    print("CardNum----"..tostring(v["CardNum"]))
    --    print("CardType----"..tostring(v["ArmyType"]))
    --    print("ExchangeCoin----"..tostring(v["ExchangeCoin"]))
    --    print("StarCost----"..tostring(v["StarCost"]))
    --    print("UseLimitCost----"..tostring(v["UseLimitCost"]))
    --    print("GeneralType----"..tostring(v["GeneralType"]))
    --    print("RangeType----"..tostring(v["RangeType"]))
    --    print("AimGeneralType----"..tostring(v["AimGeneralType"]))
    --end
end


return wnd_zhanshu_model