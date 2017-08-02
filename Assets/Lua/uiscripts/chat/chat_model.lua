

chat_model= {
    chatRecordList={
        --worldRecordList = {},
        --juntuanRecordList = {},

    },--世界聊天所有记录包括时间Item

    newWorldRecordList = {},--新加入的世界聊天数据
    --newJuntuanRecordList = {},--新加入的军团聊天数据
    oldWorldRecordList = {},--更旧的聊天记录信息

    bubbleRecordList = {},--气泡的信息保存地
--    -- userid,username,content,time,type(0世界，1军团，1001是时间Item)


    lastTime = 0,--最新的聊天时间
    isNoPeopleChat = false,--没人聊天，则开始计时，当有人一旦发言(从服务器那接受到任一新信息包括自己)则设置为ture


    oldLastDataTime = 0,--最旧一条数据的时间记录
    isHaveOldData = true,--是否还有更老的数据，当接收到的数据为0条的时候就把这个数据设置为false
}

local socket = require "socket"

local this = chat_model

function chat_model:initmodel()
    --向服务器发送请求获取聊天的数据
    --print("精确到秒的时间戳："..os.time().."------精确到毫秒的时间戳："..math.floor(socket.gettime()*1000))
    local nowTime = math.floor(socket.gettime()*1000)
    Message_Manager:SendPB_30002(0,nowTime)--世界类型，时间戳精确到毫秒
    --吧数据插入进chatRecordList表里面
    --chat_model:insertDate(date)

end

local testOnece = true --测试一次数据更新
--local lastNum = 0--最后一次请求所保存的数量
----数据更新请求
function chat_model:RefreshDate()
    --local lastNum = #this.chatRecordList
    --print("更新前："..lastNum)
    if testOnece then
        --向服务器发送请求拉取新的聊天数据
        --local date = this.testdate2 --测试用的数据

        --更新数据
        chat_model:insertDate(date)
    end
    testOnece = false



end

--this.chatWindow_controller = require("uiscripts/chat/chatWindow_controller")

function chat_model:insertDate(datelist)
    print("--------------"..userModel:getUserRoleTbl().rId.."---------------------")
    print("进入insertDate".."datelist长度为："..#datelist)

    if datelist == nil or #datelist==0 then
        print("datelist数量为0或者空 证明没有更久的数据了")
        this.isHaveOldData = false
        return
    end

    for key,value in ipairs(datelist) do
        local tb = {}
        tb.rid= value["rId"]
        tb.username = value["userName"]
        tb.content = value["content"]
        tb.time = value["time"]
        print(tb.rid.."---"..tb.username.."---"..tb.content.."---"..tb.time)

        if userModel:getUserRoleTbl().rId == tb.rid then
            tb.type = 1
        else
            tb.type = 2
        end
        --tb.type = value[5]
        table.insert(this.chatRecordList,tb)
        table.insert(this.newWorldRecordList,tb)
        --table.insert(this.bubbleRecordList,tb)
        --跟新最新时间
        if tb.time > this.lastTime then
            this.lastTime = tb.time
            --this.chatWindow_controller.isNoPeopleChat = true
        end
        --print("最后得到的最新时间"..this.lastTime)
    end
    --table.sort(this.bubbleRecordList, function (a,b)
    --    return a.time<b.time
    --end)
    table.sort(this.chatRecordList, function (a,b)
        return a.time<b.time
    end)
    table.sort(this.newWorldRecordList, function (a,b)
        return a.time<b.time
    end)
    this.oldLastDataTime = this.chatRecordList[1].time -- 记录最旧数据的时间
    chatWindow_controller.lookingForOldData = false

end

function chat_model:insertDateOnBack(datelist)

    if datelist == nil or #datelist==0 then
        print("datelist数量为0或者空 证明没有更久的数据了")
        this.isHaveOldData = false
        return
    end

    for key,value in ipairs(datelist) do
        local tb = {}
        tb.rid= value["rId"]
        tb.username = value["userName"]
        tb.content = value["content"]
        tb.time = value["time"]
        print(tb.rid.."---"..tb.username.."---"..tb.content.."---"..tb.time)

        if userModel:getUserRoleTbl().rId == tb.rid then
            tb.type = 1
        else
            tb.type = 2
        end
        --tb.type = value[5]
        table.insert(this.chatRecordList,tb)
        table.insert(this.oldWorldRecordList,tb)

    end
    print("开始排序老数据")
    table.sort(this.chatRecordList, function (a,b)
        return a.time<b.time
    end)
    --print("-----------"..this.chatRecordList[1].time.."-----------".."-----------"..this.chatRecordList[#this.chatRecordList].time.."-----------")
    this.oldLastDataTime = this.chatRecordList[1].time -- 记录最旧数据的时间
    chatWindow_controller.lookingForOldData = false

end

function chat_model:inserDate(rid,username,content,time)
    print("进入chat_model:inserDate(rid,username,content,time)")
    local tb = {}
    tb.rid = rid
    tb.username = username
    tb.content = content
    tb.time = time
    print("用户的Rid："..userModel:getUserRoleTbl().rId)
    if userModel:getUserRoleTbl().rId == tb.rid then
        tb.type = 1
    else
        tb.type = 2
    end
    --tb.type = type
    table.insert(this.chatRecordList,tb)
    table.insert(this.newWorldRecordList,tb)
    table.insert(this.bubbleRecordList,tb)

    --local t0 = math.floor(socket.gettime()*1000)

    print('rid:'..rid..'username:'..username..'信息：'..content..'时间戳：'..time)
    if tb.time > this.lastTime then
        this.lastTime = tb.time
        this.isNoPeopleChat = true
    end

end

function chat_model:inserTimeDate(time,content,type)
    print("进入chat_model:inserTimeDate(time,content,type)")
    local tb = {}
    tb.type = type
    tb.content = content
    tb.time = tonumber(time)

    table.insert(this.chatRecordList,tb)
end


return chat_model