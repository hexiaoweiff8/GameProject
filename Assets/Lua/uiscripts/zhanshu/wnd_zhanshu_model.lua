
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
    for k,v in pairs(cardModel:getCardTbl()) do
        local Item = {}
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
        table.insert(this.CardDataList,Item)
    end
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