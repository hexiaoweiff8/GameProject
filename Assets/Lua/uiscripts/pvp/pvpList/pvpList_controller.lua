local class = require("common/middleclass")
pvpList_controller = class("pvpList_controller",wnd_base)

local this = pvpList_controller

local view = require("uiscripts/pvp/pvpList/pvpList_view")
--local model = require("uiscripts/chat/chat_model")

local model

local pindaoType = 0 local zipindaoType = 0 --主频道和子频道的选择--第一次进游戏默认是11，点击任一主频道都会跳到子频道1 当前主频道是本身除外

function pvpList_controller:OnShowDone()
    print("chatBubble_controller:OnShowDone")
    view:InitView(self)
    
    this:InitBtn()

    this:ChosePindao(1)

    this:PushData()

    model = UIModel(view.modeParent)
    --this:InitMode()
end

function pvpList_controller:InitMode()

    --model:initialize(view.modeParent)
    --model:show3DModel()
end

function pvpList_controller:InitBtn()
    UIEventListener.Get(view.pindao_toggle.jingjibiwu).onClick = function ()
        this:ChosePindao(1)
    end
    UIEventListener.Get(view.pindao_toggle.jingjibiwu2).onClick = function ()
        this:ChosePindao(2)
    end
    UIEventListener.Get(view.pindao_toggle.jingjibiwu_benqu).onClick = function ()
        this:ChoseziPindao(1,1)
    end
    UIEventListener.Get(view.pindao_toggle.jingjibiwu_quanfu).onClick = function ()
        this:ChoseziPindao(1,2)
    end
    UIEventListener.Get(view.pindao_toggle.jingjibiwu_weiwang).onClick = function ()
        this:ChoseziPindao(1,3)
    end
    UIEventListener.Get(view.pindao_toggle.jingjibiwu_lingdi).onClick = function ()
        this:ChoseziPindao(1,4)
    end

end

function pvpList_controller:ChosePindao(type)
    if pindaoType == type then
        return
    end

    view:ShowPindao(type)
    this:ChoseziPindao(type,1)
end

function pvpList_controller:ChoseziPindao(pdType,zipdType)--频道 和 子频道类型

    if pdType == 1 then
        if zipdType == 1 then
            view.pindao_toggle.jingjibiwu_benqu:GetComponent("UIToggle").value = true
        elseif zipdType == 2 then
            view.pindao_toggle.jingjibiwu_quanfu:GetComponent("UIToggle").value = true
        elseif zipdType == 3 then
            view.pindao_toggle.jingjibiwu_weiwang:GetComponent("UIToggle").value = true
        elseif zipdType == 4 then
            view.pindao_toggle.jingjibiwu_lingdi:GetComponent("UIToggle").value = true
        else
            print("没有此频道1的"..zipdType.."频道")
            return
        end
    elseif pdType == 2 then
        if zipdType == 1 then
            view.pindao_toggle.jingjibiwu2_benqu:GetComponent("UIToggle").value = true
        elseif zipdType == 2 then
            view.pindao_toggle.jingjibiwu2_quanfu:GetComponent("UIToggle").value = true
        elseif zipdType == 3 then
            view.pindao_toggle.jingjibiwu2_weiwang:GetComponent("UIToggle").value = true
        elseif zipdType == 4 then
            view.pindao_toggle.jingjibiwu2_lingdi:GetComponent("UIToggle").value = true
        else
            print("没有此频道2的"..zipdType.."频道")
            return
        end
    end
    pindaoType = pdType
    zipindaoType = zipdType
    --做信息请求

end

function pvpList_controller:PushData()--吧数据推送到C#端
    local pvpLoopGrid = view.pvpScollerView_Grid:GetComponent("PVPloopGrid")


    --local socket = require "socket"
    --local t0 = socket.gettime()
    --
    --pvpLoopGrid:insertdateInBack(tb)
    --
    --local t1 = socket.gettime()
    --print("花费时间"..t1-t0.."ms")

end

return pvpList_controller