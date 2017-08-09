---
--- Created by Administrator.
--- DateTime: 2017/7/22 11:19
---

ModelControl = {}
local enemyModelList = {}

--
-----
-----初始化模型控制
-----
--function ModelControl:Init(paiKutb,paiKuLeveltb)
--    self.allrenderZhenxingList = AStarControl:getAllZhengXingList(paiKutb, paiKuLeveltb)
--    self.UnitWidth = AStarControl:getUnitWidth()
--    self.MapWidth = AStarControl:getMapWidth()
--end
--
-----
-----初始化我的手牌模型
-----
--function ModelControl:InitMyModels(cardlist)
--    for i = 1,#cardlist do
--        if cardlist[i] then
--            if not handCardsList[i] or handCardsList[i] ~= cardlist[i].id then
--                handCardsList[i] = cardlist[i].id
--                --self:destroyMyModel(i)
--                myModelList[i] = self:createModel(handCardsList[i],i)
--                self:hideMyModel(i)
--            end
--        else
--            myModelList[i] = nil
--        end
--    end
--end
--function ModelControl:RefreshMyModels(card,cardIndex)
--    if card and cardIndex then
--        handCardsList[cardIndex] = card.id
--        myModelList[cardIndex] = self:createModel(handCardsList[cardIndex],cardIndex)
--        self:hideMyModel(cardIndex)
--    end
--end
--
-----
-----获取我我的手牌额模型的
-----
--function ModelControl:getMyModel(index)
--    if myModelList[index] then
--        myModelList[index].gameObject:SetActive(true)
--        return myModelList[index]
--    end
--end
-----显示模型
--function ModelControl:showMyModel(index)
--    if myModelList[index] then
--        myModelList[index].gameObject:SetActive(true)
--    end
--end
--
-----移动模型至目标位置
--function ModelControl:moveMyModel(position, index)
--    if myModelList[index] then
--        myModelList[index].gameObject:SetActive(true)
--        AStarControl:setZhangAi(position, index)
--    end
--end
-----隐藏模型
--function ModelControl:hideMyModel(index)
--    if myModelList[index] then
--        myModelList[index].transform.position = Vector3(1000,1000,1000)
--        for i = 0,myModelList[index].childCount - 1 do
--            myModelList[index]:GetChild(i).transform.localPosition = Vector3(0,0,0)
--        end
--        myModelList[index].gameObject:SetActive(false)
--    end
--end
--
-----
-----激活模型
-----
--function ModelControl:activeModel(index)
--    --从父物体中移除（加入父物体是为了移动的时候只移动父物体）
--    for i = 1,myModelList[index].childCount do
--        myModelList[index]:GetChild(0).gameObject:GetComponent(typeof(RanderControl)):SyncData()
--        myModelList[index]:GetChild(0).parent = nil
--    end
--
--    --玩家下兵寻路网格位置(敌人下兵平行位置)
--    self.ctPosition = AStarControl:getAStarPosition(myModelList[index].position)
--    --删除父物体
--    Object.Destroy(myModelList[index].gameObject)
--end
--
-----销毁模型
--function ModelControl:destroyMyModel(index)
--    if myModelList[index] then
--        Object.Destroy(myModelList[index])
--    end
--end



---
---创建模型
---
local modelList = {}
local unitList = {}
----==============================--
----desc:获取模型
----time:2017-05-03 08:20:10
----@id:卡牌ID
----@index:为5时为敌人下兵
----@objectType[[我方基地1
--敌方基地2
--我方普通士兵3
--敌方普通士兵4
--我方机甲单位5
--敌方机甲单位6
--我方障碍物 如 我放电网7
--敌方障碍物8
---中立障碍物 可能有血条 但没有阵营9]]
----return
----==============================--
function ModelControl:CreateModel(id, index)

    --if modelList[index] then
    --    self:DestroyModel(index)
    --end
    modelList[index], unitList[index] = Model:CreateFightZhenXing(id)
    for i = 0, modelList[index].childCount - 1 do
        modelList[index]:GetChild(i).eulerAngles = Vector3(0, 90, 0)
    end
    AStarControl:setZhenxingInfo(modelList[index], id, index - 1)

    modelList[index].gameObject:SetActive(false)
end

---
---显示模型
---
function ModelControl:ShowModel(Index)
    if not modelList[Index].gameObject.activeSelf then
        modelList[Index].gameObject:SetActive(true)
    end
end

---
---移动模型
---
function ModelControl:MoveModel(position, Index)
    AStarControl:setZhangAi(position, Index - 1 )--前0-3个对应自己的4张卡牌，4为敌人序号
end
---
---激活模型
---
function ModelControl:ActiveModel(index)
    --从父物体中移除（加入父物体是为了移动的时候只移动父物体）
    for i = 1, #unitList[index] do
        modelList[index].transform:GetChild(0).gameObject:GetComponent("RanderControl").enabled = true
        modelList[index].transform:GetChild(0).gameObject:GetComponent("ClusterData").enabled = true
        modelList[index].transform:GetChild(0).gameObject:GetComponent("TriggerRunner").enabled = true
        modelList[index].transform:GetChild(0).gameObject:GetComponent(typeof(RanderControl)):SyncData()
        modelList[index].transform:GetChild(0).parent = nil
        unitList[index][i].ClusterData:Begin()
    end
    --删除父物体
    Object.Destroy(modelList[index].gameObject)
end
---
---隐藏模型
---
function ModelControl:HideModel(Index)
    if modelList[Index].gameObject.activeSelf then
        modelList[Index].gameObject:SetActive(false)
    end
end
---
---销毁模型
---
function ModelControl:DestroyModel(Index)
    Model:DestroyFightZhenXing(modelList[Index], unitList[Index])
end




---添加敌人模型
function ModelControl:addEnemyModel(cardID, model)
    enemyModelList[cardID] = model
end
---获取敌人模型
function ModelControl:getEnemyModel(cardID)
    if enemyModelList[cardID] then
        return enemyModelList[cardID]
    else
        return nil
    end
end
---
---创建敌人模型并激活
---
function ModelControl:createEnemyModel(id)

    local ZhenXingModel,unitList = Model:CreateFightZhenXing(id,4)

    AStarControl:setZhenxingInfo(ZhenXingModel, id, 4)
    local ctPosition = Vector3(25 + math.random(40), 0, 10 + math.random(40))
    ctPosition.x = AStarControl:getMapWidth() - ctPosition.x
    AStarControl:setZhangAi(ctPosition, 4)--前0-3个对应自己的4张卡牌，4为敌人序号

    local model
    for i = 1, #unitList do

        ---获取模型
        model = ZhenXingModel:GetChild(0).gameObject
        ---旋转
        model.transform.eulerAngles = Vector3(0, -90, 0)
        ---删除父物体
        model.transform.parent = nil
        ---激活模型

        model:GetComponent("RanderControl").enabled = true
        model:GetComponent("ClusterData").enabled = true
        model:GetComponent("TriggerRunner").enabled = true
        local mt = model:GetComponent(typeof(RanderControl))
        mt.isEnemy = true
        mt:SyncData()
        unitList[i].ClusterData:Begin()
    end
    Object.Destroy(ZhenXingModel.gameObject)
    self:addEnemyModel(id, model.transform)
end

return ModelControl