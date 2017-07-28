---
--- Created by Administrator.
--- DateTime: 2017/7/22 11:19
---

ModelControl = {}

local handCardsList = {}
local myModelList = {}

local enemyModelList = {}


---
---初始化模型控制
---
function ModelControl:Init(paiKutb,paiKuLeveltb)
    self.allrenderZhenxingList = AStarControl:getAllZhengXingList(paiKutb, paiKuLeveltb)
    self.UnitWidth = AStarControl:getUnitWidth()
    self.MapWidth = AStarControl:getMapWidth()
end

---
---初始化我的手牌模型
---
function ModelControl:InitMyModels(cardlist)
    for i = 1,#cardlist do
        if cardlist[i] then
            if not handCardsList[i] or handCardsList[i] ~= cardlist[i].id then
                handCardsList[i] = cardlist[i].id
                --self:destroyMyModel(i)
                myModelList[i] = self:createModel(handCardsList[i],i)
                myModelList[i].gameObject:SetActive(false)
            end
        else
            myModelList[i] = nil
        end
    end
end

---
---获取我我的手牌额模型的
---
function ModelControl:getMyModel(index)
    if myModelList[index] then
        myModelList[index].gameObject:SetActive(true)

        return myModelList[index]
    end
end

function ModelControl:activeModel(index)
    --从父物体中移除（加入父物体是为了移动的时候只移动父物体）
    for i = 1,myModelList[index].childCount do
        myModelList[index]:GetChild(0).gameObject:GetComponent(typeof(RanderControl)):SyncData()
        myModelList[index]:GetChild(0).parent = nil
    end

    --玩家下兵寻路网格位置(敌人下兵平行位置)
    self.ctPosition = AStarControl:getAStarPosition(myModelList[index].position)
    --删除父物体
    Object.Destroy(myModelList[index].gameObject)
end

function ModelControl:destroyMyModel(index)
    if myModelList[index] then
        Object.Destroy(myModelList[index])
    end
end







function ModelControl:addEnemyModel(cardID, model)
    enemyModelList[cardID] = model
end

function ModelControl:getEnemyModel(cardID)
    if enemyModelList[cardID] then
        return enemyModelList[cardID]
    else
        return nil
    end
end

function ModelControl:destroyEnemyModel(cardID)
    if enemyModelList[cardID] then
        Object.Destroy(enemyModelList[cardID])
    end
end

--==============================--
--desc:获取模型
--time:2017-05-03 08:20:10
--@id:卡牌ID
--@index:为5时为敌人下兵
--[[我方基地1
敌方基地2
我方普通士兵3
敌方普通士兵4
我方机甲单位5
敌方机甲单位6
我方障碍物 如 我放电网7
敌方障碍物8
-中立障碍物 可能有血条 但没有阵营9]]
--
--return
--==============================--
function ModelControl:createModel(id, index)
    local renderZhenxing = self.allrenderZhenxingList[id]
    local ArmyID = sdata_armycardbase_data:GetFieldV("ArmyID", id)
    local go = GameObject.New().transform
    local tempMod
    print("阵型长度"..renderZhenxing.Length)

    for i = 0, renderZhenxing.Length - 1, 2 do
        local paramTab = CreateActorParam(sdata_soldierRender_data:GetV(sdata_soldierRender_data.I_CmType, ArmyID),
        sdata_soldierRender_data:GetV(sdata_soldierRender_data.I_ColorMat, ArmyID) == 1,
        sdata_soldierRender_data:GetV(sdata_soldierRender_data.I_FlagColorIdx, ArmyID),
        sdata_soldierRender_data:GetV(sdata_soldierRender_data.I_MeshPackName, ArmyID),
        sdata_soldierRender_data:GetV(sdata_soldierRender_data.I_TexturePackName, ArmyID),
        sdata_soldierRender_data:GetV(sdata_soldierRender_data.I_IsHero, ArmyID) == 1, tonumber(ArmyID .. "001"), id)
        selectedCardItem = FightUnitFactory.CreateUnit(3, paramTab)
        --print(selectedCardItem.ClusterData.MemberData.ObjID)
        tempMod = selectedCardItem.GameObj.transform
        tempMod.gameObject:SetActive(true)
        tempMod.parent = go
        tempMod.eulerAngles = Vector3(0, 90, 0)
        tempMod.position = Vector3(renderZhenxing[i], 0, renderZhenxing[i + 1]) * self.UnitWidth

        tempMod:GetComponent(typeof(MFAModelRender)).speedScale = 0
        tempMod:GetComponent(typeof(UnityEngine.MeshRenderer)).material.shader = PacketManage.Single:GetPacket("rom_share"):Load("Transparent_Colored_Gray.shader", FileSystem.RES_LOCATION.auto)
    end

    AStarControl:setZhenxingInfo(go, id, index)
    return go
end



function ModelControl:createEnemyModel(id)
    local renderZhenxing = self.allrenderZhenxingList[id]
    local ArmyID = sdata_armycardbase_data:GetFieldV("ArmyID", id)
    local go = GameObject.New().transform
    local tempMod

    for i = 0, renderZhenxing.Length - 1, 2 do
        local paramTab = CreateActorParam(sdata_soldierRender_data:GetV(sdata_soldierRender_data.I_CmType, ArmyID),
        sdata_soldierRender_data:GetV(sdata_soldierRender_data.I_ColorMat, ArmyID) == 1,
        sdata_soldierRender_data:GetV(sdata_soldierRender_data.I_FlagColorIdx, ArmyID),
        sdata_soldierRender_data:GetV(sdata_soldierRender_data.I_MeshPackName, ArmyID),
        sdata_soldierRender_data:GetV(sdata_soldierRender_data.I_TexturePackName, ArmyID),
        sdata_soldierRender_data:GetV(sdata_soldierRender_data.I_IsHero, ArmyID) == 1, tonumber(ArmyID .. "001"), id)
        selectedCardItem = FightUnitFactory.CreateUnit(4, paramTab)
        tempMod = selectedCardItem.GameObj.transform
        tempMod.gameObject:SetActive(true)
        tempMod.parent = go

        tempMod.position = Vector3(-renderZhenxing[i], 0, renderZhenxing[i + 1]) * self.UnitWidth
        tempMod.eulerAngles = Vector3(0, -90, 0)
        local mt = tempMod.gameObject:GetComponent(typeof(RanderControl))
        mt.isEnemy = true
        mt:SyncData()
        tempMod:GetComponent(typeof(MFAModelRender)).speedScale = 0
        tempMod:GetComponent(typeof(UnityEngine.MeshRenderer)).material.shader = PacketManage.Single:GetPacket("rom_share"):Load("Transparent_Colored_Gray.shader", FileSystem.RES_LOCATION.auto)

    end
    AStarControl:setZhenxingInfo(go, id, 5)
    self.ctPosition = Vector3(25 + math.random(40), 0, 10 + math.random(40))
    self.ctPosition.x = self.MapWidth - self.ctPosition.x
    AStarControl:setZhangAi(self.ctPosition, 5)--前4个对应自己的4张卡牌，5为敌人序号
    for i = 1, go.childCount do
        go:GetChild(0).parent = nil
    end
    Object.Destroy(go.gameObject)
    self:addEnemyModel(id, tempMod)
    return tempMod
end

return ModelControl