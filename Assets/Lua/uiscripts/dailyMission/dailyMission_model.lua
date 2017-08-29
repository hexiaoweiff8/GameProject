
dailyMission_model = {


    dailyMissionDataList = {},
    zhanluerenwuDataList = {},

    canRecevieNum = 0,--完成任务可领取数量
}


local this = dailyMission_model

function dailyMission_model:InitModel()
    --this.dailyMissionDataList = this.testData;
    --print(123)
    --this:RefreshDailyMissionData(this.testData)

end

function dailyMission_model:RefreshDailyMissionData(dataList)
    --print("开始刷新每日任务数据，长度为："..#dataList)
    this.dailyMissionDataList = {}
    for i = 1, #dataList do
        local tb = {}
        tb.typeid = dataList[i].id
        tb.childid = dataList[i].lv
        tb.jingdu = dataList[i].val
        print(tb.typeid.."   "..tb.childid.."  "..tb.jingdu)
        local missionID = tb.typeid * 100 + tb.childid
        local localData = dayilymissionUtil:GetMissionOneDataByID(missionID)
        if localData == nil and dayilymissionUtil:GetMissionOneDataByID(missionID-1) ~= nil then --证明是领取过的
            tb.islingqu = 1
        else 
            tb.islingqu = 0
        end

        if localData == nil and dayilymissionUtil:GetMissionOneDataByID(missionID-1) ~= nil then
            table.insert(this.dailyMissionDataList, tb)
        elseif localData ~= nil then
            table.insert(this.dailyMissionDataList, tb)
        end

    end

    this.dailyMissionDataList = this:sortDataList(this.dailyMissionDataList)
    this:RefreshCanRcevieNum()
    print(this:GetCanRecevieNum())
end

--任务排序1.默认先排序排序完成置下和未完成任务至上2.未完成的优先进度百分比，否则按ID排序
function dailyMission_model:sortDataList(dataList)
    local completeTaskList = {}--完成任务表（指领过的）
    local noCompleteTaskList = {}--未完成任务表（没领也算未完成）
    for i = 1, #dataList do
        if dataList[i].islingqu == 0 then
            table.insert(noCompleteTaskList, dataList[i])
        else
            table.insert(completeTaskList, dataList[i])
        end
    end
    table.sort(completeTaskList, function (a,b)
        return a.typeid < b.typeid
    end)
    table.sort(noCompleteTaskList, function (a,b)
        return a.typeid < b.typeid
    end)
    table.sort(noCompleteTaskList, function (a,b)
        local localAData = dayilymissionUtil:GetMissionOneDataByID(a.typeid*100+a.childid)
        local localBData = dayilymissionUtil:GetMissionOneDataByID(b.typeid*100+b.childid)
        local r
        if (a.jingdu/localAData.TargetValue)==(b.jingdu/localBData.TargetValue) then
            r = a.typeid < b.typeid
        else
            r = (a.jingdu/localAData.TargetValue)>(b.jingdu/localBData.TargetValue)
        end
        return r
    end)
    for i = 1, #completeTaskList do
        table.insert(noCompleteTaskList, completeTaskList[i])
    end
    return noCompleteTaskList
end

--刷新可领取任务奖励的数量
function dailyMission_model:RefreshCanRcevieNum()
    local num = 0
    for i = 1, #this.dailyMissionDataList do
        local missionID = this.dailyMissionDataList[i].typeid * 100 + this.dailyMissionDataList[i].childid
        local localData = dayilymissionUtil:GetMissionOneDataByID(missionID)
        if localData ~= nil then --证明是未领取过的
            if this.dailyMissionDataList[i].jingdu >= localData.TargetValue then
                num = num + 1
            end
        end
    end
    for i = 1, #this.zhanluerenwuDataList do
        local missionID = this.zhanluerenwuDataList[i].typeid * 100 + this.zhanluerenwuDataList[i].childid
        local localData = dayilymissionUtil:GetMissionOneDataByID(missionID)
        if localData ~= nil then --证明是未领取过的
            if this.zhanluerenwuDataList[i].jingdu >= localData.TargetValue then
                num = num + 1
            end
        end
    end

    this.canRecevieNum = num
end

function dailyMission_model:GetCanRecevieNum()
    return this.canRecevieNum
end

return dailyMission_model