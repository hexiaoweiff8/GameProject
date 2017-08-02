local class = require("common/middleclass")
chatBubble_controller = class("chatBubble_controller",wnd_base)


chatBubble_controller.heartbeat_chat_timer = 0 --聊天心跳每隔5分钟请求一次

local this = chatBubble_controller

local view = require("uiscripts/chat/chatBubble/chatBubble_View")
local model = require("uiscripts/chat/chat_model")

local socket = require "socket"
local lastContentTime = 0--math.floor(socket.gettime()*1000) --气泡最新一条信息的时间

local aniCd = 0 --气泡动画CD 1.5秒一次循环

function chatBubble_controller:OnShowDone()
    --this.view = require("uiscripts/chat/chatBubble/chatBubble_View")
    --初始化View
    view:InitView(self)
    --初始化数据
    model:initmodel()
    --初始化按钮
    this.InitBtn()

    --更新第一条数据
    --this:RefreshFirstDate()


    Message_Manager:SendPB_30001("token")--发送进入聊天心跳通知服务器客服端可以开始接收聊天数据
end

function chatBubble_controller:RefreshFirstDate()
    local username = ""
    local content = ""
    local time = 0  --时间现在做为判断先后的依据
    --print("RefreshFirstDate:"..#model.newWorldRecordList)
    if #model.bubbleRecordList ~= 0 then--证明有数据
        --for index = 1 ,#model.bubbleRecordList  do
        --    if time < model.bubbleRecordList[index].time then
        --         username = model.bubbleRecordList[index].username
        --         content = model.bubbleRecordList[index].content
        --         time = model.bubbleRecordList[index].time
        --    end
        --end
        --已经在model层做好了排序只需要取最后一条做验证就是
        username = model.bubbleRecordList[#model.bubbleRecordList].username
        content = model.bubbleRecordList[#model.bubbleRecordList].content
        time = model.bubbleRecordList[#model.bubbleRecordList].time
    end

    lastContentTime = time
    view:ShowNextMessageGrid()
    --print("RefreshFirstDate:"..username)
    --print("RefreshFirstDate:"..content)
    view.username002.text = username
    view.userMessage002.text = content

end

----展示最新的数据
function chatBubble_controller:ShowNextNewContent()

        local username = ""
        local content = ""
        local time = 0  --时间现在做为判断先后的依据
        if #model.bubbleRecordList ~= 0 then--证明有数据
            --for index = 1 ,#model.bubbleRecordList  do
            --    if time < model.bubbleRecordList[index].time then
            --        username = model.bubbleRecordList[index].username
            --        content = model.bubbleRecordList[index].content
            --        time = model.bubbleRecordList[index].time
            --        --lastContentTime = time
            --    end
            --end
            --已经在model层做好了排序只需要取最后一条做验证就是
            username = model.bubbleRecordList[#model.bubbleRecordList].username
            content = model.bubbleRecordList[#model.bubbleRecordList].content
            time = model.bubbleRecordList[#model.bubbleRecordList].time
        end
    if lastContentTime < time then--证明有新信息
        --print("RefreshFirstDate:"..username)
        --print("RefreshFirstDate:"..content)
        --print("RefreshFirstDate:"..#model.chatRecordList)

        if view.showIndex == 1 then
            view.username001.text = username
            view.userMessage001.text = content
        else
            view.username002.text = username
            view.userMessage002.text = content
        end
        lastContentTime = time
        view:ShowNextMessageGrid()
    else
        return
    end


end

function chatBubble_controller:InitBtn()

    UIEventListener.Get(view.btn_Bubble).onClick = this.btn_Bubble_call


end

function chatBubble_controller:btn_Bubble_call()
    --view:ShowNextMessageGrid()

    view.panel.transform.gameObject:SetActive(false)
    chatWindow_controller.gameObject:SetActive(true)
    --chatWindow_controller.heartbeat_chat_timer = 300

    --进入世界频道
    --chatWindow_controller:Enter_shijie()


end

local timer = 0 --心跳计时器
function chatBubble_controller:Update()
    --chatBubble_controller:HeartForRefreshChatBubble()

    --聊天心跳
    this:Heartbeat_chat()

    --有数据，新数据的时间比最新气泡的时间新，而且气泡动画是否在CD防止还没播放完就再次播放
    local ListNun = #model.bubbleRecordList
    aniCd  = aniCd + Time.deltaTime
    --print("-----------------"..ListNun)
    --print(model.bubbleRecordList[ListNun].time)
        if  ListNun~=0 and lastContentTime < model.bubbleRecordList[ListNun].time  and aniCd >=1.5  then
            chatBubble_controller:ShowNextNewContent()
            aniCd = 0
        end



end

------心跳请求为了更新气泡的
--function chatBubble_controller:HeartForRefreshChatBubble()
--    if true then
--        timer = timer + Time.deltaTime
--        if timer >= 5  then
--            model:RefreshDate()
--            --chatBubble_controller:ShowNextNewContent()
--            timer = 0
--        end
--    end
--end

function chatBubble_controller:Heartbeat_chat()--聊天心跳 当用户在聊天室界面每隔5分钟请求一次
    this.heartbeat_chat_timer = this.heartbeat_chat_timer + Time.deltaTime
    if this.heartbeat_chat_timer >=300 then
        Message_Manager:SendPB_30001("token")
        this.heartbeat_chat_timer = 0
    end
end




return chatBubble_controller