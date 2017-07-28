local class = require("common/middleclass")
chatBubble_controller = class("chatBubble_controller",wnd_base)

local this = chatBubble_controller

local view = require("uiscripts/chat/chatBubble/chatBubble_View")
local model = require("uiscripts/chat/chat_model")
local lastContentTime = 0 --气泡最新一条信息的时间

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
    this:RefreshFirstDate()
end

function chatBubble_controller:RefreshFirstDate()
    local username = ""
    local content = ""
    local time = 0  --时间现在做为判断先后的依据
    --print("RefreshFirstDate:"..#model.newWorldRecordList)
    if #model.bubbleRecordList ~= 0 then--证明有数据
        for index = 1 ,#model.bubbleRecordList  do
            if time < model.bubbleRecordList[index].time then
                 username = model.bubbleRecordList[index].username
                 content = model.bubbleRecordList[index].content
                 time = model.bubbleRecordList[index].time
            end
        end
    end

    lastContentTime = time
    view:ShowNextMessageGrid()
    print("RefreshFirstDate:"..username)
    print("RefreshFirstDate:"..content)
    view.username002.text = username
    view.userMessage002.text = content

end

----展示最新的数据
function chatBubble_controller:ShowNextNewContent()

        local username = ""
        local content = ""
        local time = 0  --时间现在做为判断先后的依据
        if #model.bubbleRecordList ~= 0 then--证明有数据
            for index = 1 ,#model.bubbleRecordList  do
                if time < model.bubbleRecordList[index].time then
                    username = model.bubbleRecordList[index].username
                    content = model.bubbleRecordList[index].content
                    time = model.bubbleRecordList[index].time
                    --lastContentTime = time
                end
            end
        end
    if lastContentTime < time then--证明有新信息
        print("RefreshFirstDate:"..username)
        print("RefreshFirstDate:"..content)
        print("RefreshFirstDate:"..#model.chatRecordList)

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
    --print("测试按钮触发！")
    --view:ShowNextMessageGrid()

    view.panel.transform.gameObject:SetActive(false)
    chatWindow_controller.gameObject:SetActive(true)

    --进入世界频道
    --chatWindow_controller:Enter_shijie()


end

local timer = 0 --心跳计时器
function chatBubble_controller:Update()
    --chatBubble_controller:HeartForRefreshChatBubble()

end

----心跳请求为了更新气泡的
function chatBubble_controller:HeartForRefreshChatBubble()
    if true then
        timer = timer + Time.deltaTime
        if timer >= 5  then
            chatBubble_controller:RefreshNewContent()
        end
    end
end

function chatBubble_controller:RefreshNewContent()
    --刷新气泡
     model:RefreshDate()
    chatBubble_controller:ShowNextNewContent()
     timer = 0
end

return chatBubble_controller