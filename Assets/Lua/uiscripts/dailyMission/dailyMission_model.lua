
dailyMission_model = {
    testData = {
        {typeid = 1,childid = 2,jingdu = 10},
        {typeid = 3,childid = 2,jingdu = 200},
        {typeid = 2,childid = 1,jingdu = 4},
        {typeid = 4,childid = 1,jingdu = 4},
        {typeid = 6,childid = 1,jingdu = 3},
        {typeid = 5,childid = 1,jingdu = 4},
        {typeid = 8,childid = 1,jingdu = 1},
        {typeid = 18,childid = 1,jingdu = 5},

    },

    dailyMissionDataList = {},
    zhanluerenwuDataList = {},

}


local this = dailyMission_model

function dailyMission_model:InitModel()
    --this.dailyMissionDataList = this.testData;
    --print(123)
    this:RefreshDailyMissionData(this.testData)

end

function dailyMission_model:RefreshDailyMissionData(dataList)
    this.dailyMissionDataList = {}

    for i = 1, #dataList do
        local tb = {}
        tb.typeid = dataList[i].typeid
        tb.childid = dataList[i].childid
        tb.jingdu = dataList[i].jingdu
        local missionID = dataList[i].typeid*100+dataList[i].childid
        local localData = dayilymissionUtil:GetMissionOneDataByID(missionID)
        if localData == nil then --证明是领取过的
            tb.islingqu = 1
        else
            tb.islingqu = 0
        end
        table.insert(this.dailyMissionDataList, tb)
    end
    this.dailyMissionDataList = this:sortDataList(this.dailyMissionDataList)
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



return dailyMission_model