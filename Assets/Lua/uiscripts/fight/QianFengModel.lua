---
--- Created by Administrator.
--- DateTime: 2017/8/10 19:59
---
QianFengModel = {}

local modelList
local unitLists
function QianFengModel:Init(QianFengCardIDTbl)
    modelList = {}
    unitLists = {}
    for i = 1, 6 do
        if QianFengCardIDTbl[i] ~= 0 then
            local model,unitList = Model:CreateFightZhenXing(QianFengCardIDTbl[i])
            for i = 0, model.childCount - 1 do
                model:GetChild(i).eulerAngles = Vector3(0, 90, 0)
            end
            local GridX = math.floor(LoadMap.Single.MapWidth/5)*((i-1)%2+1)
            local GridY = math.floor(LoadMap.Single.MapHeight/4*(3-math.floor((i-1)/2)))
            local position = Utils.NumToPosition(LoadMap.Single.transform:GetChild(0).position,Vector2(GridX,GridY),LoadMap.Single.UnitWidth,LoadMap.Single.MapWidth,LoadMap.Single.MapHeight)
            model.transform.position = position

            --AStarControl:setQianFengInfo(model.transform, QianFengCardIDTbl[i], i - 1)
            --AStarControl:setQianFengZhangAi(position, i - 1)
            modelList[i] = model
            unitLists[i] = unitList
        end
    end

end


function QianFengModel:Start()
    for i = 1, 6 do
        if modelList[i] and unitLists[i] then
            for childIndex = 1, modelList[i].childCount do
                local model = modelList[i]:GetChild(0).gameObject
                ---取消模型半透效果
                Model:SetOpaque(model)
                model:GetComponent("Animation").enabled = true
                model:GetComponent("RanderControl").enabled = true
                model:GetComponent("ClusterData").enabled = true
                model:GetComponent("TriggerRunner").enabled = true
                model:GetComponent("RanderControl"):SyncData()
                model.transform.parent = nil
                unitLists[i][childIndex].ClusterData:Begin()
            end
            Object.Destroy(modelList[i].gameObject)
        end
    end

end

function QianFengModel:OnDestroyDone()
    modelList = nil
    unitLists = nil
    QianFengModel = nil
end
return QianFengModel