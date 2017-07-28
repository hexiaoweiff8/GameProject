

chat_model= {
    chatRecordList={
        --worldRecordList = {},
        --juntuanRecordList = {},

    },

    newWorldRecordList = {},--新加入的世界聊天数据
    --newJuntuanRecordList = {},--新加入的军团聊天数据

    bubbleRecordList = {},--气泡的信息保存地
    -- userid,username,content,time,type(0世界，1军团，1001是时间Item)
    testdate1 = {

        {8001,"jb","123321",1499928830},
        {8002,"jb2","asdsadsa",1499928820},
        {8003,"jb3","41414341",1499928810},
        {8004,"一根藤上七个娃","一根藤上七个娃一根藤上七个娃一根藤上七个娃一根藤上七个娃一根藤上七个娃1231123",1499928833},
        {8005,"jb5","23214543",1499928200},
        {8006,"jb6","fdnbgfngfdn",1499928100},
        {8007,"jb7","我是你爸爸",1499928202},
        {8008,"jb8","真的老子服了",1499928455},
},
    testdate2 = {
        {8009,"jb11","测试语句22",1499928899},
        {8011,"jb12","测试语句3",1499928888},
        {8012,"jb13","测试语句4",1499928877},
        {8013,"jb14","测试语句5",1499928866},
        {8014,"jb15","测试语句6",1499929000},
        {8015,"jb16","测试语句7",1499929111},
        {8016,"jb17","测试语句8",1499929222},
        {8017,"jb18","测试语句10",os.time()},
    },
    olddate = {

        {8001,"jb","123321",1499925000},
        {8002,"jb2","asdsadsa",1499925111},
        {8003,"jb3","41414341",1499925222},
        {8004,"一根藤上七个娃","一根藤上七个娃一根藤上七个娃一根藤上七个娃一根藤上七个娃一根藤上七个娃1231123",1499925333},
        {8005,"jb5","23214543",1499925444},
        {8006,"jb6","fdnbgfngfdn",1499925555},
        {8007,"jb7","我是你爸爸",1499925666},
        {8008,"jb8","真的老子服了",1499925777},
    },

    lastTime = 0,--最新的聊天时间
    isNoPeopleChat = false,--没人聊天，则开始计时，当有人一旦发言(从服务器那接受到任一新信息包括自己)则设置为ture
}



local this = chat_model

function chat_model:initmodel()
    --向服务器发送请求获取聊天的数据
    local date = this.testdate1 --测试用的数据

    --吧数据插入进chatRecordList表里面
    chat_model:insertDate(date)

end

local testOnece = true --测试一次数据更新
--local lastNum = 0--最后一次请求所保存的数量
----数据更新请求
function chat_model:RefreshDate()
    --local lastNum = #this.chatRecordList
    --print("更新前："..lastNum)
    if testOnece then
        --向服务器发送请求拉取新的聊天数据
        local date = this.testdate2 --测试用的数据

        --更新数据
        chat_model:insertDate(date)
    end
    testOnece = false



end

--this.chatWindow_controller = require("uiscripts/chat/chatWindow_controller")

function chat_model:insertDate(datelist)
    --print("进入insertDate".."datelist长度为："..#datelist)


    for key,value in pairs(datelist) do
        --print("key:"..key.."----value"..#value)
        local tb = {}
        tb.uid = value[1]
        tb.username = value[2]
        tb.content = value[3]
        tb.time = value[4]
        if userModel:getUserRoleTbl().uid == tb.uid then
            tb.type = 1
        else
            tb.type = 2
        end
        --tb.type = value[5]
        table.insert(this.chatRecordList,tb)
        --table.insert(this.newWorldRecordList,tb)
        table.insert(this.bubbleRecordList,tb)
        --跟新最新时间
        if tb.time > this.lastTime then
            this.lastTime = tb.time
            --this.chatWindow_controller.isNoPeopleChat = true

        end
        --print("最后得到的最新时间"..this.lastTime)
    end
    table.sort(this.chatRecordList, function (a,b)
        return a.time<b.time
    end)
    --print("this.lastTime:"..this.lastTime)
    --table.sort(chat_model.chatRecordList)
    --for key,v in ipairs(this.chatRecordList) do
    --    for key1 , v1 in pairs(v) do
    --        print("key:"..key.."---key1:"..key1.."---- value："..v1)
    --    end
    --end
end

function chat_model:inserDate(uid,username,content,time)
    local tb = {}
    tb.uid = uid
    tb.username = username
    tb.content = content
    tb.time = time
    if userModel:getUserRoleTbl().uid == tb.uid then
        tb.type = 1
    else
        tb.type = 2
    end
    --tb.type = type
    table.insert(this.chatRecordList,tb)
    table.insert(this.bubbleRecordList,tb)
    if tb.time > this.lastTime then
        this.lastTime = tb.time

        --this.chatWindow_controller.isNoPeopleChat = true
    end

end

function chat_model:inserTimeDate(time,content,type)
    local tb = {}
    tb.type = type
    tb.content = content
    tb.time = tonumber(time)

    table.insert(this.chatRecordList,tb)
end


return chat_model