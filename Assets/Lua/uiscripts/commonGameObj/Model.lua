---
--- Created by Administrator.
--- DateTime: 2017/8/4 16:00
---


Model = {}

---阵型数据数组
local ZhenXingDataList
---
---初始化，获取卡牌阵型数据
---cardIdTbl    要显示的模型对应的卡牌ID
---cardLvTbl    卡牌对应的等级
---
function Model:setZhenXingData(cardIdTbl, cardLvTbl)
    ZhenXingDataList = AstarFight.setAllZhenxingList(cardIdTbl, cardLvTbl)
end



---
---创建一个UI模型
---
function Model:CreateUIModel(cardId)
    local ArmyID = sdata_armycardbase_data:GetFieldV("ArmyID", cardId)
    local paramTab = CreateActorParam(sdata_soldierRender_data:GetV(sdata_soldierRender_data.I_CmType, ArmyID),
    sdata_soldierRender_data:GetV(sdata_soldierRender_data.I_ColorMat, ArmyID) == 1,
    sdata_soldierRender_data:GetV(sdata_soldierRender_data.I_FlagColorIdx, ArmyID),
    sdata_soldierRender_data:GetV(sdata_soldierRender_data.I_MeshPackName, ArmyID),
    sdata_soldierRender_data:GetV(sdata_soldierRender_data.I_TexturePackName, ArmyID),
    sdata_soldierRender_data:GetV(sdata_soldierRender_data.I_IsHero, ArmyID) == 1, tonumber(ArmyID .. "001"), cardId)
    local model = DP_FightPrefabManage.InstantiateAvatar(paramTab)
    return model
end

---
---创建已排好阵型的UI模型组
---
function Model:CreateUIZhenXing(cardId)
    local ZhenXingData = ZhenXingDataList[cardId]
    local zhenXing = GameObject.New().transform
    for i = 0, ZhenXingData.Length - 1, 2 do
        local model = Model:setZhenXingData(cardId)
        model.transform.parent = zhenXing
        model.transform.position = Vector3(-ZhenXingData[i], 0, ZhenXingData[i + 1]) * AstarFight.UnitWidth
    end
    return zhenXing
end


---
---创建一个战斗模型
---id           模型ID
---ObjectType   模型类型
---
function Model:CreateFightUnit(cardId,ObjectType)
    if not ObjectType then
        ObjectType = 3
    end
    local ArmyID = sdata_armycardbase_data:GetFieldV("ArmyID", cardId)
    local paramTab = CreateActorParam(sdata_soldierRender_data:GetV(sdata_soldierRender_data.I_CmType, ArmyID),
    sdata_soldierRender_data:GetV(sdata_soldierRender_data.I_ColorMat, ArmyID) == 1,
    sdata_soldierRender_data:GetV(sdata_soldierRender_data.I_FlagColorIdx, ArmyID),
    sdata_soldierRender_data:GetV(sdata_soldierRender_data.I_MeshPackName, ArmyID),
    sdata_soldierRender_data:GetV(sdata_soldierRender_data.I_TexturePackName, ArmyID),
    sdata_soldierRender_data:GetV(sdata_soldierRender_data.I_IsHero, ArmyID) == 1, tonumber(ArmyID .. "001"), cardId)

    local unit = FightUnitFactory.CreateUnit(ObjectType, paramTab)
    local tempMod = unit.GameObj.transform
    tempMod:GetComponent(typeof(MFAModelRender)).speedScale = 0
    tempMod:GetComponent(typeof(UnityEngine.MeshRenderer)).material.shader = PacketManage.Single:GetPacket("rom_share"):Load("Transparent_Colored_Gray.shader", FileSystem.RES_LOCATION.auto)

    tempMod:GetComponent("RanderControl").enabled = false
    tempMod:GetComponent("ClusterData").enabled = false
    tempMod:GetComponent("TriggerRunner").enabled = false

    return unit
end
---
---创建已排好阵型的战斗模型组
---id           模型ID
---ObjectType   模型类型
---
function Model:CreateFightZhenXing(cardId, ObjectType)
    local unitList = {}
    local ZhenXingData = ZhenXingDataList[cardId]
    local zhenXing = GameObject.New().transform
    for i = 0, ZhenXingData.Length - 1, 2 do
        local unit = Model:CreateFightUnit(cardId , ObjectType)
        table.insert(unitList, unit)
        local model = unit.GameObj
        model.transform.parent = zhenXing
        model.transform.position = Vector3(-ZhenXingData[i], 0, ZhenXingData[i + 1]) * AstarFight.UnitWidth
    end
    return zhenXing, unitList
end


function Model:DestroyFightZhenXing(ZhenXing, unitList)

    for i = 1, #unitList do
        FightUnitFactory.DeleteUnit(unitList[i].ClusterData.AllData.MemberData)
    end
    Object.Destroy(ZhenXing.gameObject)
end
