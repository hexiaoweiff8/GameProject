local class = require("common/middleclass")

wnd_base_baffleType =
    {
        -- 无挡板
        NONE = 1,
        -- 普通挡板
        NORMAL = 2,
        -- 背景黑挡板
        WITHBG = 3
    }

wnd_base_type =
    {
        -- 背景层
        BACKGROUND = 1,
        -- 普通界面(UIMainMenu等)
        NORMAL = 2,
        -- 固定窗口(UITopBar等)
        FIXED = 3,
        -- 弹窗
        POPUP = 4,
        -- 游戏中需显示到弹窗上的
        ABOVE_POPUP = 5,
        -- 新手指引
        TUTORIAL = 6,
        -- loading界面
        LOADING = 7,
        -- 新手指引上的比如跑马灯新闻
        ABOVE_TUTORIAL = 8,
    }
	
local wndDepth = {2, 10, 250, 500, 750, 1000, 1250, 1500}

wnd_base = class("wnd_base")
function wnd_base:initialize(_wnd_base_id)
    -- 当前界面ID
    self.wnd_base_id = _wnd_base_id
    -- 最基本情况下此界面的上一界面id,用来应对back导航出现问题的时候
    self.pre_wnd_base_id = WNDTYPE.None
    
    --同一个预制不同界面
    local tempIndex = string.find(_wnd_base_id, "&")

    if tempIndex then
        self.wnd_base_sub_id = string.sub(_wnd_base_id, tempIndex + 1, string.len(_wnd_base_id))
        _wnd_base_id = string.sub(_wnd_base_id, 1, tempIndex - 1)
    end
    self.wnd_base_type = UiDefine:GetV(UiDefine.I_wnd_base_type, _wnd_base_id)
    self.wnd_base_baffleType = UiDefine:GetV(UiDefine.I_wnd_base_baffleType, _wnd_base_id)
    self.Resident = UiDefine:GetV(UiDefine.I_Resident, _wnd_base_id)
    self.name = self.wnd_base_id --窗体名
    _all_Reg_Wnd_list[self.name] = self
    --协程table
    self.coroutineTb = {}
    --定时器 table
    self.TimeTickerTb = {}
end

function wnd_base:Show(pre_wnd_base_id,duration)
    if duration == nil then
        duration = 0.5
    end
    self.pre_wnd_base_id = pre_wnd_base_id
    local isWithBg
    if self.wnd_base_baffleType == wnd_base_baffleType.WITHBG then
        isWithBg = true
    else
        isWithBg = false
    end
    WndManage.Single:ShowWnd(self.name, duration, isWithBg)

end

function wnd_base:Hide(duration)
    if duration == nil then
        duration = 0.5
    end
    WndManage.Single:HideWnd(self.name, duration)
end

function wnd_base:Destroy(duration)

    if duration == nil then
        duration = 0.5
    end
    WndManage.Single:DestroyWnd(self.name, duration)
end

function wnd_base:PreLoad()
    WndManage.Single:PreLoadDepend(self.name)
end

function wnd_base:_OnShowFinish(wnd)
    -- local wndGO = wnd:GetGameObject()
    -- wndGO:AddComponent(typeof(LuaBehaviour)):Init(self)
    -- local rootGameObject = ui_manager:get_wnd_base_root(self.wnd_base_type).transform
    -- local tfp = wndGO.transform.parent
    -- tfp.parent = rootGameObject
    -- if self.wnd_base_baffleType == wnd_base_baffleType.NONE then
    --     wnd.m_baffleObj:SetActive(false)
    -- end

    -- Tools.AdjustBaseWindowDepth(rootGameObject.gameObject, tfp.gameObject, wndDepth[self.wnd_base_type])

    AdjustBaseWindowDepth(wnd,self)

    --显示完成通知
    if (self.OnShowDone ~= nil) then
        self:OnShowDone()
    end
    --注册事件监听
    if (self.OnAddHandler ~= nil) then
        self:OnAddHandler()
    end
    -- 如果打开的是主界面的UI,则广播消息
    if IsMainSceneUI(self.name) then
        printe("Broadcast "..self.name..' open')
        BroadcastUIEvent(UIEventType.SHOW,self.name)
    end
end

function wnd_base:_OnHideFinish(wnd)
    --隐藏或销毁完成通知
    if (self.OnHideDone ~= nil) then
        self:OnHideDone()
    end
    -- 如果隐藏的是主界面的UI,则广播消息
    if IsMainSceneUI(self.name) then
        printe("Broadcast "..self.name..' Hide')
        BroadcastUIEvent(UIEventType.HIDE,self.name)
    end
end

function wnd_base:_OnDestroyFinish(wnd)
    for k, v in pairs(self.coroutineTb) do
        coroutine.stop(v)
    end
    for k, v in pairs(self.TimeTickerTb) do
        v:Stop()
    end
    --隐藏或销毁完成通知
    if (self.OnDestroyDone ~= nil) then
        self:OnDestroyDone()
    end
    --删除事件监听
    if (self.OnRemoveHandler ~= nil) then
        self:OnRemoveHandler()
    end
    -- 如果销毁的是主界面的UI,则广播消息
    if IsMainSceneUI(self.name) then
        printe("Broadcast "..self.name..' Destroy')
        BroadcastUIEvent(UIEventType.DESTROY,self.name)
    end
end

function wnd_base:_OnShowFinishEnd(wnd)
    --显示完成通知
    if (self.OnShowDoneEnd ~= nil) then
        self:OnShowDoneEnd()
    end
end

function wnd_base:_OnDestroyFinishEnd(wnd)
    --隐藏或销毁完成通知
    if (self.OnDestroyDoneEnd ~= nil) then
        self:OnDestroyDoneEnd()
    end
    local id = self.wnd_base_id
    --清空表
    self = {}
    local eachfunc = function(_, wndInfo)
        if wndInfo.name == id then
            require(wndInfo.cm)(wndInfo.name)
            return
        end
    end
    table.foreach(GameInit.wndlist, eachfunc)
end

function wnd_base:_OnPreLoadFinish(wnd)
    --预加载完成通知
    if (self.OnPreLoadDone ~= nil) then
        self:OnPreLoadDone()
    end
end

function OnShowFinish(wnd)
    local wndName = wnd.Name
    local wnd_base = _all_Reg_Wnd_list[wndName]
    if (wnd_base == nil) then return end
    wnd_base:_OnShowFinish(wnd)
end

function OnHideFinish(wnd)
    local wndName = wnd.Name
    local wnd_base = _all_Reg_Wnd_list[wndName]
    if (wnd_base == nil) then return end
    wnd_base:_OnHideFinish(wnd)
end

function OnDestroyFinish(wnd)
    local wndName = wnd.Name
    local wnd_base = _all_Reg_Wnd_list[wndName]
    if (wnd_base == nil) then return end
    wnd_base:_OnDestroyFinish(wnd)
end

function OnShowFinishEnd(wnd)
    local wndName = wnd.Name
    local wnd_base = _all_Reg_Wnd_list[wndName]
    if (wnd_base == nil) then return end
    wnd_base:_OnShowFinishEnd(wnd)
end

function wnd_base:_OnReOpenWnd(wnd)
    AdjustBaseWindowDepth(wnd,self)
    if (self.OnReOpenDone ~= nil) then
        self:OnReOpenDone()
    end
    -- 如果重新打开的是主界面的UI,则广播消息
    if IsMainSceneUI(self.name) then
        printe("Broadcast "..self.name..' ReOpen')
        BroadcastUIEvent(UIEventType.SHOW,self.name)
    end
end

function OnReOpenWnd(wnd)
    local wndName = wnd.Name
    local wnd_base = _all_Reg_Wnd_list[wndName]
    if (wnd_base == nil) then return end
    wnd_base:_OnReOpenWnd(wnd)
end

function OnDestroyFinishEnd(wnd)
    local wndName = wnd.Name
    local wnd_base = _all_Reg_Wnd_list[wndName]
    if (wnd_base == nil) then return end
    wnd_base:_OnDestroyFinishEnd(wnd)
end

function OnPreLoadFinish(wnd)
    local wndName = wnd.Name
    local wnd_base = _all_Reg_Wnd_list[wndName]
    if (wnd_base == nil) then return end
    wnd_base:_OnPreLoadFinish(wnd)
end

function AdjustBaseWindowDepth(wnd,instance)
    local wndGO = wnd:GetGameObject()
    if wndGO:GetComponent(typeof(LuaBehaviour)) == nil then
        wndGO:AddComponent(typeof(LuaBehaviour)):Init(instance)
    end
    local rootGameObject = ui_manager:get_wnd_base_root(instance.wnd_base_type).transform
    local tfp = wndGO.transform.parent
    tfp.parent = rootGameObject
    if instance.wnd_base_baffleType == wnd_base_baffleType.NONE then
        wnd.m_baffleObj:SetActive(false)
    end

    Tools.AdjustBaseWindowDepth(rootGameObject.gameObject, tfp.gameObject, wndDepth[instance.wnd_base_type])
end
-----------------------------------------------
--添加 测试交互代码
--判断该UI是否会影响主场景相机的控制
function IsMainSceneUI(wnd_base_id)
    if wnd_base_id == WNDTYPE.ui_equip or
    wnd_base_id == WNDTYPE.ui_chongzhu or
    wnd_base_id == WNDTYPE.Cangku or
    wnd_base_id == WNDTYPE.Shop or
    wnd_base_id == WNDTYPE.Zhanshu or
    wnd_base_id == WNDTYPE.mail or
    wnd_base_id == WNDTYPE.CardShop or
    wnd_base_id == WNDTYPE.chatWindow or
    wnd_base_id == WNDTYPE.dailyMission or
    wnd_base_id == WNDTYPE.QianDao then
        return true
    else return false end
end
--推送UI打开/关闭/销毁事件
function BroadcastUIEvent(uiEventType,wnd_base_id)
    Event.Brocast(uiEventType,wnd_base_id)
end