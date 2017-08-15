---
--- Created by Administrator.
--- DateTime: 2017/8/4 16:00
---


Model = {}

---渲染模式
local RenderingMode = {
    Opaque = 1,
    Cutout = 2,
    Fade = 3,
    Transparent = 4,

}
local BlendMode = {
    Zero = 0,
    One = 1,
    DstColor = 2,
    SrcColor = 3,
    OneMinusDstColor = 4,
    SrcAlpha = 5,
    OneMinusSrcColor = 6,
    DstAlpha = 7,
    OneMinusDstAlpha = 8,
    SrcAlphaSaturate = 9,
    OneMinusSrcAlpha = 10
}
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

    tempMod:GetComponent("Animation").enabled = false
    tempMod:GetComponent("RanderControl").enabled = false
    tempMod:GetComponent("ClusterData").enabled = false
    tempMod:GetComponent("TriggerRunner").enabled = false

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


---设置渲染模式
function Model:SetMaterialRenderingMode (material,renderingMode)
    if renderingMode == RenderingMode.Opaque then
        material:SetInt ("_SrcBlend", BlendMode.One)
        material:SetInt ("_DstBlend", BlendMode.Zero)
        material:SetInt ("_ZWrite", 1)
        material:DisableKeyword ("_ALPHATEST_ON")
        material:DisableKeyword ("_ALPHABLEND_ON")
        material:DisableKeyword ("_ALPHAPREMULTIPLY_ON")
        material.renderQueue = -1
    elseif renderingMode == RenderingMode.Cutout then
        material:SetInt ("_SrcBlend", BlendMode.One)
        material:SetInt ("_DstBlend", BlendMode.Zero)
        material:SetInt ("_ZWrite", 1)
        material:EnableKeyword ("_ALPHATEST_ON")
        material:DisableKeyword ("_ALPHABLEND_ON")
        material:DisableKeyword ("_ALPHAPREMULTIPLY_ON")
        material.renderQueue = 2450
    elseif renderingMode == RenderingMode.Fade then
        material:SetInt ("_SrcBlend", BlendMode.SrcAlpha)
        material:SetInt ("_DstBlend", BlendMode.OneMinusSrcAlpha)
        material:SetInt ("_ZWrite", 0)
        material:DisableKeyword ("_ALPHATEST_ON")
        material:EnableKeyword ("_ALPHABLEND_ON")
        material:DisableKeyword ("_ALPHAPREMULTIPLY_ON")
        material.renderQueue = 3000
    elseif renderingMode == RenderingMode.Transparent then
        material:SetInt ("_SrcBlend", BlendMode.One)
        material:SetInt ("_DstBlend", BlendMode.OneMinusSrcAlpha)
        material:SetInt ("_ZWrite", 0)
        material:DisableKeyword ("_ALPHATEST_ON")
        material:DisableKeyword ("_ALPHABLEND_ON")
        material:EnableKeyword ("_ALPHAPREMULTIPLY_ON")
        material.renderQueue = 3000
    end

end
---设置模型透明
function Model:SetTransparent(model,alpha)
    for i = 1, model.transform.childCount do
        local SkinnedMeshRenderer = model.transform:GetChild(i-1):GetComponent("SkinnedMeshRenderer")
        if SkinnedMeshRenderer then
            SkinnedMeshRenderer.material.shader = UnityEngine.Shader.Find("Standard")
            SkinnedMeshRenderer.material.color = UnityEngine.Color.New(1,1,1,alpha)
            self:SetMaterialRenderingMode (SkinnedMeshRenderer.material,RenderingMode.Transparent)
        end
    end
end
---设置模型不透明
function Model:SetOpaque(model)
    for i = 1, model.transform.childCount do
        local SkinnedMeshRenderer = model.transform:GetChild(i-1):GetComponent("SkinnedMeshRenderer")
        if SkinnedMeshRenderer then
            SkinnedMeshRenderer.material.shader = UnityEngine.Shader.Find("Standard")
            SkinnedMeshRenderer.material.color = UnityEngine.Color.New(1,1,1,1)
            self:SetMaterialRenderingMode (SkinnedMeshRenderer.material,RenderingMode.Opaque)
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