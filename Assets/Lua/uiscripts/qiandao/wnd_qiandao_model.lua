
wnd_qiandao_model =
{
    local_checkin = {},  --本地每日奖励表
    LocalRefeshTime,
    initModel,
    initLocalRefeshTime, --读取本地每日刷新时间的数据
    initLocalCheckinData, --读本地每日奖励表数据
    getLocalAwardDataByDay, --在本地每日奖励表查找对应的Day的数据
    getQualitySpriteStr,
    serv_qiandaoInfo = {} --服务器数据10002发送的签到信息

}

local this = wnd_qiandao_model
function wnd_qiandao_model:initModel()
    this:initLocalCheckinData()
    this:initLocalRefeshTime()
end


---读本地表的function---
function wnd_qiandao_model:initLocalCheckinData()
    if sdata_checkin_data == nil then
        print("没获取到以下数据：sdata_checkin_data")
        return
    end
    for k,v in pairs(sdata_checkin_data.mData.body) do
        local Tab = {}
        Tab["Day"] = v[sdata_checkin_data.mFieldName2Index['Day']]
        Tab["AwardType"] = v[sdata_checkin_data.mFieldName2Index['AwardType']]
        Tab["ID"] = v[sdata_checkin_data.mFieldName2Index['ID']]
        Tab["Quality"] = v[sdata_checkin_data.mFieldName2Index['Quality']]
        Tab["Num"] = v[sdata_checkin_data.mFieldName2Index['Num']]
        table.insert(this.local_checkin,Tab)
    end
    table.sort(this.local_checkin,function(a,b)
        return a["Day"] < b["Day"]
    end)

end

function wnd_qiandao_model:initLocalRefeshTime()
    if sdata_systemconstant_data == nil then
        print("没获取到以下数据：sdata_systemconstant_data")
    end
    for k,v in pairs(sdata_systemconstant_data.mData.body) do
        if (v[sdata_systemconstant_data.mFieldName2Index['Name']] == "RefreshTime") then
            this.LocalRefeshTime = v[sdata_systemconstant_data.mFieldName2Index['Value']]
        end
    end
end

function wnd_qiandao_model:getLocalRefeshTime()
    return this.LocalRefeshTime
end

function wnd_qiandao_model:getLocalAwardDataByDay(Day)
    for i = 1,30 do
        if this.local_checkin[i]["Day"] == Day then
            return this.local_checkin[i]
        end
    end

    Debugger.LogWarning(Day.." not found in wnd_qiandao_model:getLocalAwardDataByDay(Day)")
    return nil
end

function wnd_qiandao_model:getQualitySpriteStr(_Quality)
    --TODO:对目前暂时的装备框和底色进行正规修改，目前仅为测试值
    local str =''
    if(_Quality == -1) then
        str = "meiriqiandao_juxingkuang_lanse"
    elseif (_Quality == 1) then
        str = "meiriqiandao_juxingkuang_hongse"
    elseif (_Quality == 2) then
        str = "meiriqiandao_juxingkuang_zise"
    elseif (_Quality == 3) then
        str = "meiriqiandao_juxingkuang_chengse"
    end
    return str
end



return wnd_qiandao_model








