
require("uiscripts/chat/subtlecodeUtil")

local class = require("common/middleclass")
chatWindow_controller = class("chatWindow_controller",wnd_base)

local this = chatWindow_controller
local view = require("uiscripts/chat/chatWindow_view")
local model = require("uiscripts/chat/chat_model")

local chatBubble_controller = require("uiscripts/chat/chatBubble/chatBubble_controller")

chatBubble_controller.chatType = 0 --聊天频道默认是0世界 1军团

function chatWindow_controller:OnShowDone()
    this.gameObject = self.transform.gameObject
    --初始化view
    view:InitView(self)
    ----初始化数据
    --model:initmodel()
    --初始化按钮
    this:InitBtn()



    ----先进入世界频道
    this.Enter_shijie()
    ----第一次创建得根据有没有新的数据创建时间Item
    this:pushDataToScrollViewFirst()
    this:create_timeItem(model.lastTime)

    --view.scrollView:ResetPosition()
    --view.scrollView:UpdatePosition()

    this.gameObject:SetActive(false)

    --this.testUdp()
end


function chatWindow_controller:RefreshWordWindow()
    --print("进入RefreshWordWindow")
    --print(#model.chatRecordList)
    --print(type(view.table.transform.childCount))


    --local childNum = view.table.transform.childCount
    ----print(index)
    --for i = 1, childNum do
    --    Object.Destroy(view.table.transform:GetChild(i-1).gameObject)
    --end

    for key,value in pairs(model.newWorldRecordList) do
            local uid = value.uid
            --local isSelf = (value.uid == userModel:getUserRoleTbl().uid)
            local content = value.content
            this:create_chatItem(uid,content,0)
            table.insert(model.chatRecordList,value)
    end
    model.newWorldRecordList = {}


    view.worldTable:GetComponent("UITable"):Reposition()
end


function chatWindow_controller:InitBtn()

    UIEventListener.Get(view.btn_chatBack).onClick = this.btn_chatBack_call
    UIEventListener.Get(view.btn_shijie).onClick = this.btn_shijie_call
    UIEventListener.Get(view.btn_juntuan).onClick = this.btn_juntuan_call

    UIEventListener.Get(view.btn_send).onClick = this.btn_send_call

end



function chatWindow_controller:btn_shijie_call()
    chatWindow_controller:Enter_shijie()
end

function chatWindow_controller:btn_juntuan_call()
    chatWindow_controller:Enter_juntuan()
end


function chatWindow_controller:Enter_shijie()
    --显示世界按钮光标
    this.chatType = 0
    view:ShowOneBtnSprite(this.chatType)
    --请求服务器，进入世界频道

    --更改Grid,刷新世界面板数据
    --this:RefreshWordWindow()

end

function chatWindow_controller:Enter_juntuan()
    --显示军团按钮光标
    this.chatType = 1
    view:ShowOneBtnSprite(this.chatType)
    --请求服务器，进入世界频道

    --更改Grid,刷新世界面板数据
    --this:RefreshWordWindow()

end



function chatWindow_controller:btn_send_call()
    local str = view.input_label.text
    print("send:"..str)
    --判断是不是默认输入字符串是的话直接退出
    if str == "再此输入文字 (36字)" or str == "" then
        return
    end


    --print(#subtlecodeUtil:GetTable().mData.body)]]--
    --敏感字符的检查和替换
    str = chatWindow_controller:chaekSensitive(str)
    --敏感字符的检查和替换


    --往服务器发送数据 如果是屏蔽的玩家就不往服务器发送数据但是只在自己的画板显示
    print(os.time())
    model:inserDate(userModel:getUserRoleTbl().uid,userModel:getUserRoleTbl().userName,str,os.time())

    --创建文本Item
    --this:create_chatItem(userModel:getUserRoleTbl().uid,str)
    --创建新的数据
    local td = {}
    td.uid = userModel:getUserRoleTbl().uid
    td.username = userModel:getUserRoleTbl().userName
    td.content = str
    td.time = os.time()
    td.type = 1
    model:inserDate(td.uid,td.username,td.content,td.time)
    this:pushDataToScrollViewFormTd(td)
    model.isNoPeopleChat = true
    --Table表从新排版
    --view.worldTable:GetComponent("UITable"):Reposition()

    view.input_label.text = "再此输入文字 (36字)"
    view.input_com.value = ""
    --print(view.input_com.value)



end

----敏感词替换
function chatWindow_controller:chaekSensitive(str)
    local fitStr = str
    --print("替换前:"..fitStr)
    local socket = require "socket"
    local s = os.clock()
    for index=1,#(subtlecodeUtil:GetTable().mData.body) do
        local str1 = subtlecodeUtil:GetSensitiveById(index)
        --print(str1)
        fitStr = string.gsub(fitStr, str1, "***")
    end
    local e = os.clock()
    --print("替换后:"..fitStr)
    print("替换敏感词用时："..e-s.." seconds")
    return fitStr
end

function chatWindow_controller:create_chatItem(uid,str)

    local chatItem
    if userModel:getUserRoleTbl().uid == uid then
        chatItem = GameObjectExtension.InstantiateFromPreobj(view.item_perfab.selfChatItem,view.worldTable)
    else
        chatItem = GameObjectExtension.InstantiateFromPreobj(view.item_perfab.otherChatItem,view.worldTable)
        chatItem.transform:FindChild("headImgBg/headImg").name = "headImg"..uid
        UIEventListener.Get(chatItem.transform:FindChild("headImgBg/headImg"..uid).gameObject).onClick = this.otherPlayerHead_call

    end
    local messageLabel = chatItem.transform:FindChild("messageBg/messageLabel"):GetComponent("UILabel")
    chatItem:SetActive(true)
    messageLabel.text = str
    model.isNoPeopleChat = true
end



function chatWindow_controller:otherPlayerHead_call()
    local userid = string.gsub(self.name,"headImg","")
    print("别的玩家头像被点击"..userid)
    --print(self.gameObject.name)
    --print(userModel:getUserRoleTbl().uid)
end

function chatWindow_controller:btn_chatBack_call()
    --print("btn_chatBack_call")
    --print(this.gameObject.transform.parent.gameObject)
    chatBubble_View.panel:SetActive(true)
    chatBubble_controller:RefreshNewContent()
    --Object.Destroy(this.gameObject.transform.parent.gameObject)
    --ui_manager:DestroyWB(WNDTYPE.chatWindow)
    --print(this.gameObject.name)
    this.gameObject:SetActive(false)

end

--this.testUDPGet = false
--this.timer001 = 0
--local upTime_timer = 0 --当玩家没人发言的时候的计时器,用于刷新时间Item的
this.isNoPeopleChat = false --没人聊天，则开始计时，当有人一旦发言(从服务器那接受到任一新信息包括自己)则设置为ture
function chatWindow_controller:Update()

    --if  not this.testUDPGet and this.gameObject.activeSelf then
    --    this.timer001 = this.timer001 + Time.deltaTime
    --    if this.timer001 >= 5 then
    --        this.testUdp()
    --        this.testUDPGet = true
    --    end
    --end

    if model.isNoPeopleChat then
        --upTime_timer = upTime_timer + Time.deltaTime
        if os.time() - model.lastTime >= 10 then
            this:create_timeItem(model.lastTime)
            --upTime_timer = 0
            --model.isNoPeopleChat = false
        end
    end



end


--[[
创建时间Item，每当过X时
@lastTime 最新消息的时间戳
]]--
function chatWindow_controller:create_timeItem(lastTime)
    if lastTime == 0 then
        return
    end
    --print("进入创建时间文本")
    --获取本地时间
    local NowTime = os.time()--os.date("%X")--测试时间
    local OneDayTime = os.date("%H")*3600+os.date("%M")*60+os.date("%S") --一天以前的时间戳和现在相差的时间
    local timeDifference = NowTime - lastTime
    local timeText
    if timeDifference < OneDayTime then
        timeText = os.date("%X",lastTime)
    else if timeDifference > OneDayTime and timeDifference < OneDayTime+86400 then
        timeText = "一天前"
        --print(timeDifference)
    else
        timeText = "几天前"
    end
    end

    --model:inserTimeDate(timeText,3)
    local td = {}
    --td.uid = userModel:getUserRoleTbl().uid
    --td.username = userModel:getUserRoleTbl().userName
    --td.content = str
    td.time = NowTime
    td.content = timeText
    td.type = 3
    --model:inserDate(td.time,td.type)
    model:inserTimeDate(td.time,td.content,td.type)

    --要把数据往C#前端推
    this:pushDataToScrollViewFormTd(td)

    --[[
    local timeItem = GameObjectExtension.InstantiateFromPreobj(view.item_perfab.timeItem,view.worldTable)
    timeItem:SetActive(true)
    timeItem.transform:FindChild("Label"):GetComponent("UILabel").text = timeText
    view.worldTable:GetComponent("UITable"):Reposition()
    ]]--
    model.isNoPeopleChat = false
    --print(isNoPeopleChat)
end

function chatWindow_controller:pushDataToScrollViewFirst()
    local loopSV = view.worldscrollView.gameObject:GetComponent("LoopItemScrollView")
    --print(loopSV.gameObject.name)

    if loopSV ~= nil then
        for key,value in ipairs(model.chatRecordList) do
            if value.type == 3 then
                --print(value.type .. "  "..value.time)
                loopSV:UpdateInBack(99999,"xxxxxxx",value.content,value.time,value.type)
            else
                --print(value.type .. "  "..value.content)
                loopSV:UpdateInBack(value.uid,value.username,value.content,value.time,value.type)
            end
        end
    end
end

function chatWindow_controller:pushDataToScrollViewFormTd(td)
    local loopSV = view.worldscrollView.gameObject:GetComponent("LoopItemScrollView")
    if td.type == 3 then
        --print(value.type .. "  "..value.time)
        loopSV:UpdateInBack(99999,"xxxxxxx",td.content,td.time,td.type)
    else
        --print(value.type .. "  "..value.content)
        loopSV:UpdateInBack(td.uid,td.username,td.content,td.time,td.type)
    end
    ----Void LoopItemScrollView:UpdateInBack(Int32 uid,String username,String content,String time,Int32 type)

end

function chatWindow_controller:testUdp()
    local socket = require "socket"

    local address = "192.168.1.88"
    local port = 9999
    local udp = socket.udp()

    udp:settimeout(0)
    udp:setpeername(address, port)

    require "proto/chat_pb"
    require "proto/header_pb"
    --组装message
    local chat = chat_pb:EnterChat()
    chat.token = 'chattoken'
    local msg1 = chat:SerializeToString()
    --Message_Manager:createSendPBHeader(10001, msg1)
    local header = header_pb.Header()
    header.ID = 1
    header.msgId = 30001
    header.userId = 8002--8001
    header.version = '1.0.0'
    header.errno = 0
    header.ext = 0
    if msg1 then
        header.body = msg1
    end
    local msg2 = header:SerializeToString()
    local buffer = ByteBuffer()
    buffer:WriteBuffer(msg2)


    --udp:send(buffer:ReadString())
    networkMgr:SendMessageByUDP(buffer:ToBytes())
    --组装message

    --udp:sendto("udp-test", address, port)
    --udp:send("udp-test0n")
    --udp:send("udp-test1n")
    --udp:send("udp-test2n")

    print("tank you")
end



return chatWindow_controller