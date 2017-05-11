local class = require("common/middleclass")
local wnd_list = {}

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
        -- 新手指引上的比如跑马灯新闻
        ABOVE_TUTORIAL = 7,
    }



wnd_base = class("wnd_base")
function wnd_base:initialize(_wnd_base_id, _is_first_wnd_base)
    -- 当前界面ID
    self.wnd_base_id = _wnd_base_id
    -- 最基本情况下此界面的上一界面id,用来应对back导航出现问题的时候
    self.pre_wnd_base_id = WND.None
    self.wnd_base_type = sdata_uidefine:GetV(sdata_uidefine.I_wnd_base_type, _wnd_base_id)
    self.wnd_base_baffleType = sdata_uidefine:GetV(sdata_uidefine.I_wnd_base_baffleType, _wnd_base_id)
    self.is_first_wnd_base = _is_first_wnd_base or false
end

function wnd_base:Init(name)
    self.name = name --窗体名
    wnd_list[name] = self
    --协程table
    self.coroutineTb = {}
end

--覆写此函数来扩展功能
function wnd_base:Show(duration)
    self:_Show(duration)
end

--覆写此函数来扩展功能
function wnd_base:Hide(duration)
    self:_Hide(duration)
end

--覆写此函数来扩展功能
function wnd_base:Destroy(duration)
    self:_Destroy(duration)
end

--覆写此函数来扩展功能
function wnd_base:PreLoad()
    self:_PreLoad()
end

function wnd_base:_Show(duration)
    local isWithBg
    if self.wnd_base_baffleType == wnd_base_baffleType.WITHBG then
        isWithBg = true
    else
        isWithBg = false
    end
    
    if (duration == nil) then
        WndManage.Single:ShowWnd(self.name, 0.5, isWithBg, LuaHelper.ActionWnd(OnShowFinish))
    else
        WndManage.Single:ShowWnd(self.name, duration, isWithBg, LuaHelper.ActionWnd(OnShowFinish))
    end
end

function wnd_base:_Hide(duration)
    if (duration == nil) then
        WndManage.Single:HideWnd(self.name, 0.5, LuaHelper.ActionWnd(OnHideFinish))
    else
        WndManage.Single:HideWnd(self.name, duration, LuaHelper.ActionWnd(OnHideFinish))
    end
end


function wnd_base:_Destroy(duration)
    if (duration == nil) then
        WndManage.Single:DestroyWnd(self.name, 0.5, LuaHelper.ActionWnd(OnDestroyFinish))
    else
        WndManage.Single:DestroyWnd(self.name, duration, LuaHelper.ActionWnd(OnDestroyFinish))
    end
end

function wnd_base:_PreLoad()
    WndManage.Single:PreLoadDepend(self.name, LuaHelper.ActionWnd(OnPreLoadFinish))
end

function wnd_base:_OnShowFinish(wnd)
    self.UI = wnd:GetGameObject()
    self.UI:AddComponent(typeof(LuaBehaviour)):Init(self)
    self.UI.transform.parent.parent = ui_manager:get_wnd_base_root(self.wnd_base_type).transform
    self.UI.transform.parent:GetComponent("UIPanel").depth = ui_manager.globalZ
    
    if self.wnd_base_baffleType == wnd_base_baffleType.NONE then
        wnd.m_baffleObj:SetActive(false)
    end
    
    if (wnd.IsNewInstance) then
        if (self.OnNewInstance ~= nil) then
            self:OnNewInstance()
        end --新建实例
    end
    
    if (self.OnShowDone ~= nil) then
        self:OnShowDone()
    end --显示完成通知
    
    ui_manager.globalZ = ui_manager.globalZ + 1
end

function wnd_base:_OnHideFinish(wnd)
    ui_manager.globalZ = ui_manager.globalZ - 1
    for k, v in pairs(self.coroutineTb) do
        coroutine.stop(v)
    end
    if (self.OnHideDone ~= nil) then
        self:OnHideDone()
    end --显示完成通知
end

function wnd_base:_OnDestroyFinish(wnd)
    ui_manager.globalZ = ui_manager.globalZ - 1
    for k, v in pairs(self.coroutineTb) do
        coroutine.stop(v)
    end
    if (self.OnDestroyDone ~= nil) then
        self:OnDestroyDone()
    end --显示完成通知
end

--此函数目前主要目的是能够提前调用OnNewInstance函数
function wnd_base:_OnPreLoadFinish(wnd)
    self.UI = wnd:GetGameObject()
    if (wnd.IsNewInstance) then
        if (self.OnNewInstance ~= nil) then
            self:OnNewInstance() end --新建实例
    end
end


function OnShowFinish(wnd)
    local wndName = wnd.Name
    local wndHanel = wnd_list[wndName]
    if (wndHanel == nil) then return end
    wndHanel:_OnShowFinish(wnd)
end


function OnHideFinish(wnd)
    local wndName = wnd.Name
    local wndHanel = wnd_list[wndName]
    if (wndHanel == nil) then return end
    wndHanel:_OnHideFinish(wnd)
end

function OnDestroyFinish(wnd)
    local wndName = wnd.Name
    local wndHanel = wnd_list[wndName]
    if (wndHanel == nil) then return end
    wndHanel:_OnDestroyFinish(wnd)
end

function OnPreLoadFinish(wnd)
    local wndName = wnd.Name
    local wndHanel = wnd_list[wndName]
    if (wndHanel == nil) then return end
    wndHanel:_OnPreLoadFinish(wnd)
end
