wnd_base = class()

local wnd_list = {}

local ShowingWndManage = {} --当前显示中的窗体管理器
ShowingWndManage.showingList = {}--显示中的列表

--通知显示
function ShowingWndManage:NotifyShow(wnd)
    self:NotifyHide(wnd,false)
    table.insert(self.showingList,wnd)

    EventHandles.OnTopWndChanged:Call(self:GetTopWnd())
end

--通知隐藏
function ShowingWndManage:NotifyHide(wnd,needNotify)
    --从列表中删除所有和这窗体名字一样的
    local newList = {}
    local eachFunc = function(k,v)
        if(v~=wnd) then 
            table.insert(newList,v)
        end
    end
    
    table.foreach(self.showingList,eachFunc)
    self.showingList = newList

    if(needNotify) then
        EventHandles.OnTopWndChanged:Call(self:GetTopWnd())
    end
end

function ShowingWndManage:Reset()
    self.showingList = {}
    EventHandles.OnTopWndChanged:Call(self:GetTopWnd())
end

--- <summary>
--- 获取当前处于顶层的窗体
--- </summary>
function ShowingWndManage:GetTopWnd()
    return self.showingList[#self.showingList]
end

function wnd_base:ctor()
    self.instance = nil --窗体实例
	self.isVisible = false 
	self.lastHideDuration = nil
end

--- <summary>
--- isSysWnd : bool 是否为系统窗口，如果值为true,将不会影响导航系统的显隐
--- </summary>
function wnd_base:Init(name,isSysWnd)
	self.name = name --窗体名
    self.isSysWnd = (isSysWnd~=nil)
	wnd_list[name] = self
end

function wnd_base:Show(duration)
	self:_Show(duration)
end

function wnd_base:Hide(duration)
	self:_Hide(duration)
end
function wnd_base:PreLoad()
	self:_PreLoad()
end

function wnd_base:BindUIEvent(objName,uiEventType,funcName,userParam)
   local zoneSelBtn = self:FindWidget(objName)
   local cmevt_zoneSelBtn =  CMUIEvent.Go(zoneSelBtn,uiEventType)
   cmevt_zoneSelBtn:Listener(zoneSelBtn,uiEventType,self,funcName,userParam)
end

function wnd_base:_Show(duration) 
    if(not self.isSysWnd) then
        ShowingWndManage:NotifyShow( self.name )
    end

    self.isVisible = true
	if(duration==nil) then
	    WndManage.Show(self.name)
	else
		WndManage.Show(self.name,duration)
	end 
end

function wnd_base:_Hide(duration) 

    if(not self.isSysWnd) then
        ShowingWndManage:NotifyHide( self.name,true )
    end

    self.isVisible = false
    --[[
	self.lastHideDuration = duration

     if(self.instance==nil) then 
        return 
    end
	
	if(duration==nil) then
	    self.instance:Hide()
	else
		self.instance:Hide(duration)
	end
    --]] 
    if(duration==nil) then
	    WndManage.Hide(self.name)
	else
		WndManage.Hide(self.name,duration)
	end 
end
function wnd_base:_PreLoad() 
	WndManage.PreLoadDepend(self.name)
end
function wnd_base:_OnLostInstance(wnd)
    if(self.instance==nil) then   return    end
	 
	
	if(self.OnLostInstance~=nil) then 
        self:OnLostInstance() 
    end

	self.instance = nil
end

function wnd_base:_OnShowFinish(wnd)
    self.instance = wnd

	if(wnd:IsNewInstance()) then
	    if(self.OnNewInstance~=nil) then 
            self:OnNewInstance() 
        end--新建实例
	end
	
    if(self.OnShowDone~=nil) then 
        self:OnShowDone() 
    end--显示完成通知

	--if(not self.isVisible) then self:Hide(self.lastHideDuration) end
end

function wnd_base:_OnHideFinish(wnd)
    
end
--此函数目前主要目的是能够提前调用OnNewInstance函数
function wnd_base:_OnPreLoadFinish(wnd)
    self.instance = wnd
	if(wnd:IsNewInstance()) then
	    if(self.OnNewInstance~=nil) then 
        self:OnNewInstance() end--新建实例
	end
end
--- <summary>
--- 设置文本
--- </summary>
function wnd_base:SetLabel(widgetName,Text)

    local gameObject = self:GetLabel(widgetName)
    if gameObject ~= nil then
       gameObject:SetValue(Text)
    end
end

--- <summary>
--- 获取CMUILabel组件
--- </summary>
--- <returns type="CMUILabel"></returns>
function wnd_base:GetLabel(widgetName)
    
    local gameObject = self:FindWidget(widgetName)
    if(gameObject==nil) then
        debug.LogError("wnd_base:GetLabel error. "..widgetName)
        return nil
    end
    return gameObject:GetComponent(CMUILabel.Name)
end

--- <summary>
--- 设置控件的显隐
--- </summary>
function wnd_base:SetWidgetActive(widgetName,isActive)

    local gameObject = self:FindWidget(widgetName)
    if gameObject ~= nil then
       gameObject:SetActive(isActive)
    end
end
--- <summary>
--- 获取CMUISprite组件
--- </summary>
--- <returns type="CMUISprite"></returns>
function wnd_base:GetSprite(widgetName)
    local gameObject = self:FindWidget(widgetName)
    if(gameObject==nil) then
        debug.LogError("wnd_base:GetSprite error. "..widgetName)
        return nil
    end
    return gameObject:GetComponent(CMUISprite.Name)
end

--- <summary>
--- 获取CMUIInput组件
--- </summary>
--- <returns type="CMUIInput"></returns>
function wnd_base:GetInput(widgetName)    
    local gameObject = self:FindWidget(widgetName)
    if(gameObject==nil) then
        debug.LogError("wnd_base:GetInput error. "..widgetName)
        return nil
    end
    return gameObject:GetComponent(CMUIInput.Name)
end 


--- <summary>
--- 查询控件
--- widgetName:string 控件名，例如 head/icon
--- ret:GameObject
--- </summary>
--- <returns type="GameObject"></returns>
function wnd_base:FindWidget(widgetName)
    local gameObject = self.instance:FindWidget(widgetName)
    if(gameObject==nil) then
        debug.LogError("wnd_base:FindWidget 不存在的控件 widgetName:"..widgetName)
        return nil
    end
    return gameObject
end



--- <summary>
--- 判定某窗体是否存在，存在则表示组件已经初始化完成
--- </summary>
function Wnd.Has(name) 
    if(wnd_list[name] ~= nil) then return true else return false end
end

function Wnd.Get(name)
    return wnd_list[name]
end

function Wnd.HideAll()
    local eachFunc = function(_,wnd)
        if not wnd.isSysWnd then wnd:Hide() end--只有非系统窗体可以被隐藏
    end
    table.foreach(wnd_list,eachFunc)
    ShowingWndManage:Reset()
end

function Wnd.GetTopWnd()
    return ShowingWndManage:GetTopWnd()
end
 
local class_wnd_event_listener = class()

--绑定内核事件
function class_wnd_event_listener:BindCoreEvt()
    WndManage.OnPreLoadFinish:AddCallback(self,self.OnPreLoadFinish)
	WndManage.OnShowFinish:AddCallback(self,self.OnShowFinish)
    WndManage.OnLostInstance:AddCallback(self,self.OnLostInstance)    
    WndManage.OnHideFinish:AddCallback(self,self.OnHideFinish)    
end

function class_wnd_event_listener:OnShowFinish(wndInstance)
	local wndName = wndInstance:GetName()
	local wndHanel = wnd_list[wndName]
	if(wndHanel==nil) then return end
	wndHanel:_OnShowFinish(wndInstance)
end


function class_wnd_event_listener:OnHideFinish(wndInstance)
	local wndName = wndInstance:GetName()
	local wndHanel = wnd_list[wndName]
	if(wndHanel==nil) then return end
	wndHanel:_OnHideFinish(wndInstance)
end

function class_wnd_event_listener:OnLostInstance(wndInstance)
	local wndName = wndInstance:GetName()
	local wndHanel = wnd_list[wndName]
	if(wndHanel==nil) then return end
	wndHanel:_OnLostInstance(wndInstance)
end

function class_wnd_event_listener:OnPreLoadFinish(wndInstance)
	local wndName = wndInstance:GetName()
	local wndHanel = wnd_list[wndName]
	if(wndHanel==nil) then return end
	wndHanel:_OnPreLoadFinish(wndInstance)
end
wnd_event_listener = class_wnd_event_listener.new()