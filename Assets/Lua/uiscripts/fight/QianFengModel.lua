---
--- Created by Administrator.
--- DateTime: 2017/8/10 19:59
---
local QianFengModel = {}

local modelList = {}
local unitLists = {}
function QianFengModel:Init(QianFengCardIDTbl)
    modelList = {}
    unitLists = {}
    for i = 1, 6 do
        if QianFengCardIDTbl[i] ~= 0 then
            local model,unitList = Model:CreateFightZhenXing(QianFengCardIDTbl[i])
            for i = 0, model.childCount - 1 do
                model:GetChild(i).eulerAngles = Vector3(0, 90, 0)
            end
            --model.position = Vector3(400,0,-50)
            AStarControl:setQianFengInfo(model.transform, QianFengCardIDTbl[i], i - 1)
            AStarControl:setQianFengZhangAi(Const.MyPreModelPosition[i], i - 1)
            modelList[i] = model
            unitLists[i] = unitList
        end
    end


    --ModelControl:createEnemyModel(101009)


end


function QianFengModel:Start()
    for i = 1, 6 do
        if modelList[i] and unitLists[i] then
            for childIndex = 1, modelList[i].childCount do
                local model = modelList[i]:GetChild(0).gameObject
                model:GetComponent("Animation").enabled = true
                model:GetComponent("RanderControl").enabled = true
                model:GetComponent("ClusterData").enabled = true
                model:GetComponent("TriggerRunner").enabled = true
                model:GetComponent(typeof(RanderControl)):SyncData()
                model.transform.parent = nil
                unitLists[i][childIndex].ClusterData:Begin()
            end
            Object.Destroy(modelList[i].gameObject)
        end
    end

end
return QianFengModel