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
function Model:setZhenXingData(cardIdTbl)
    ZhenXingDataList = AstarFight.setAllZhenxingList(cardIdTbl)
end



---
---创建一个UI模型
---
function Model:CreateUIModel(cardId)
    local packName, prefrabName = cardUtil:GetCreateModelParams(cardId,cardModel:getCardLv(cardId))
    local model = GameObjectExtension.InstantiateModelFromPacket(packName, prefrabName, nil).gameObject
    ---关闭自动播放动画
    model:GetComponent("Animation").wrapMode = UnityEngine.WrapMode.Loop
    model:GetComponent("Animation"):Stop()
    ---设置为UI显示的shader
    for i = 1, model.transform.childCount do
        if model.transform:GetChild(i-1):GetComponent("SkinnedMeshRenderer") then
            model.transform:GetChild(i-1):GetComponent("SkinnedMeshRenderer").material.shader = UnityEngine.Shader.Find("Unlit/Texture")
        end
    end
    return model
end

---
---创建已排好阵型的UI模型组
---
function Model:CreateUIZhenXing(cardId)
    local ZhenXingData = ZhenXingDataList[cardId]
    local zhenXing = GameObject.New().transform
    for i = 0, ZhenXingData.Length - 1, 2 do
        local model = Model:CreateUIModel(cardId)
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
    local paramTab = CreateActorParam.New(tonumber(ArmyID .. "001"))
    local unit = FightUnitFactory.CreateUnit(ObjectType, paramTab)
    local tempMod = unit.GameObj.transform

    tempMod:GetComponent("Animation").enabled = false
    tempMod:GetComponent("RanderControl").enabled = false
    tempMod:GetComponent("ClusterData").enabled = false
    tempMod:GetComponent("TriggerRunner").enabled = false

    ShadowObj.ObjAddShadow(tempMod)

    return unit
end
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

---
---销毁战斗阵型模型
---
function Model:DestroyFightZhenXing(ZhenXing, unitList)

    for i = 1, #unitList do
        FightUnitFactory.DeleteUnit(unitList[i].ClusterData.AllData.MemberData)
    end
    Object.Destroy(ZhenXing.gameObject)
end

---设置模型透明
function Model:SetTransparent(model,alpha)
    for i = 1, model.transform.childCount do
        local SkinnedMeshRenderer = model.transform:GetChild(i-1):GetComponent("SkinnedMeshRenderer")
        if SkinnedMeshRenderer then
            SkinnedMeshRenderer.material.shader = UnityEngine.Shader.Find("Legacy Shaders/Transparent/Diffuse")
            SkinnedMeshRenderer.material.color = UnityEngine.Color.New(0.7,0.7,0.7,alpha)
        end
    end
end
---设置模型不透明
function Model:SetOpaque(model)
    for i = 1, model.transform.childCount do
        local SkinnedMeshRenderer = model.transform:GetChild(i-1):GetComponent("SkinnedMeshRenderer")
        if SkinnedMeshRenderer then
            SkinnedMeshRenderer.material.shader = UnityEngine.Shader.Find("Legacy Shaders/Self-Illumin/Diffuse")
            SkinnedMeshRenderer.material.color = UnityEngine.Color.New(0.7,0.7,0.7,1)
        end
    end
end


---阵型播放动画
function Model:ZhenXingAnimPlay(ZhenXing)
    for i = 0 , ZhenXing.transform.childCount - 1 do
        ZhenXing.transform:GetChild(i).gameObject:GetComponent("Animation"):Play()
    end
end
---阵型停止动画
function Model:ZhenXingAnimStop(ZhenXing)
    for i = 0 , ZhenXing.transform.childCount - 1 do
        ZhenXing.transform:GetChild(i).gameObject:GetComponent("Animation"):Stop()
    end
end