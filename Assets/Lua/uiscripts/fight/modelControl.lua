---
--- Created by Administrator.
--- DateTime: 2017/7/22 11:19
---

ModelControl = {}
---
---创建模型
---
local modelList = {}
local unitList = {}
--==============================--
--desc:获取模型
--time:2017-05-03 08:20:10
--@id:卡牌ID
--@index:为5时为敌人下兵
--@objectType[[我方基地1
--敌方基地2
--我方普通士兵3
--敌方普通士兵4
--我方机甲单位5
--敌方机甲单位6
--我方障碍物 如 我放电网7
--敌方障碍物8
--中立障碍物 可能有血条 但没有阵营9
--return
--==============================--
function ModelControl:CreateModel(id, index)
    modelList[index], unitList[index] = Model:CreateFightZhenXing(id)
    for i = 0, modelList[index].childCount - 1 do
        modelList[index]:GetChild(i).eulerAngles = Vector3(0, 90, 0)
        ---设置模型半透明
        Model:SetTransparent(modelList[index]:GetChild(i), 0.1)
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
    for i = 1, #unitList[index] do
        local model = modelList[index]:GetChild(0)
        ---取消模型半透效果
        Model:SetOpaque(model)
        ---激活模型
        model.gameObject:GetComponent("Animation").enabled = true
        model.gameObject:GetComponent("RanderControl").enabled = true
        model.gameObject:GetComponent("ClusterData").enabled = true
        model.gameObject:GetComponent("TriggerRunner").enabled = true
        model.gameObject:GetComponent(typeof(RanderControl)):SyncData()
        unitList[index][i].ClusterData:Begin()
        ---将模型从父物体中删除
        model.parent = nil
    end
    ---删除父物体，完成下兵（加入父物体是为了移动的时候只移动父物体）
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



---敌人模型列表
local enemyHistoryModelList = {}
---添加敌人模型
function ModelControl:addEnemyModel(model)
    if #enemyHistoryModelList == 5 then
        table.remove(enemyHistoryModelList,1)
    end
    table.insert(enemyHistoryModelList, model)
end
---获取敌人模型
function ModelControl:getEnemyModel(Index)
    if enemyHistoryModelList[Index] then
        return enemyHistoryModelList[Index]
    else
        return nil
    end
end
---删除敌人模型
function ModelControl:remove(Index)
    if enemyHistoryModelList[Index] then
        table.remove(enemyHistoryModelList, Index)
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
        model:GetComponent("Animation").enabled = true
        model:GetComponent("RanderControl").enabled = true
        model:GetComponent("ClusterData").enabled = true
        model:GetComponent("TriggerRunner").enabled = true
        local mt = model:GetComponent(typeof(RanderControl))
        mt.isEnemy = true
        mt:SyncData()
        unitList[i].ClusterData:Begin()
    end
    Object.Destroy(ZhenXingModel.gameObject)
    self:addEnemyModel(model.transform)
end

return ModelControl