local wnd_daohangClass = class(wnd_base)

wnd_daohang = nil--单例


local ShowMode = {
    Pop = 1,--弹出样式的导航
    Pack = 2--收缩样式的导航
}

function wnd_daohangClass:Start() 

	wnd_daohang = self
	self:Init(WND.DaoHang,true)

    --需要显示导航的窗体
    self.NeedShowDaohangWnds = {
        --[WND.Main] = ShowMode.Pop,
        [WND.GuanKa] = ShowMode.Pack,
        [WND.BuZheng] = ShowMode.Pack,
    }
     
    --监听顶层窗体变更事件
    EventHandles.OnTopWndChanged:AddListener(self,self.OnTopWndChanged)
end

function wnd_daohangClass:OnTopWndChanged(wnd)
    local mode = self.NeedShowDaohangWnds[wnd] 
    if(mode~=nil) then self:Show() else  self:Hide() end 
    if(self.PopMenu ==nil) then return end --窗体尚未实例化
     
    if(mode==ShowMode.Pop) then
        self.PopMenu:Pop()
    else
        self.PopMenu:Pack()
    end
end
--抽奖协议返回
function wnd_daohangClass:NM_ReChouJiangInfo(reDoc) 
    --reDoc对象是所有协议公用的，为了防止被别的调用冲掉内容
    --必须立即解释出内容，并缓存在类中

    --填充数据
    print("----------------------------------NM_ReChouJiangInfo---------------------------")
    
	--wnd_ChouJiang:FillData(reDoc)
    local test = {}
    wnd_ChouJiang:FillData(test)
    --显示窗口
    wnd_background:Show() 
    print("wnd_background:Show()")
    wnd_ChouJiang:Show()  
    print("wnd_ChouJiang:Show()")
    wnd_background:ShowListOnbackground(wnd_ChouJiang)

    
end 
--布阵协议返回
function wnd_daohangClass:NM_ReBuZhengInfo(reDoc) 
    --reDoc对象是所有协议公用的，为了防止被别的调用冲掉内容
    --必须立即解释出内容，并缓存在类中

    --填充数据
    wnd_buzheng:FillData(reDoc)

    --显示窗口
    wnd_buzheng:Show()    
end 
--抽奖按钮被点击
function wnd_daohangClass:OnChouJiangClick(gameObj)
    --local jsonDoc = JsonParse.SendNM("CJWndInfo")
    --local loader = Loader.new(jsonDoc:ToString(),0,"ReCJWndInfo")
    --LoaderEX.SendAndRecall(loader,self,self.NM_ReChouJiangInfo,nil)
    self.NM_ReChouJiangInfo(gameObj)
end
--布阵按钮被点击
function wnd_daohangClass:OnBuzhengClick(gameObj)
    local jsonDoc = JsonParse.SendNM("GetBuZhengInfo")
    jsonDoc:Add("t","5")--通用阵

    local loader = Loader.new(jsonDoc:ToString(),0,"ReBuZhengInfo")
    LoaderEX.SendAndRecall(loader,self,self.NM_ReBuZhengInfo,nil)
end

--窗体被实例化时被调用
--初始化实例
function wnd_daohangClass:OnNewInstance()
    local itemlistobj = self.instance:FindWidget("itemlist") 
    self.PopMenu = itemlistobj:GetComponent(CMUIPopMenu.Name)

    --绑定事件
    self:BindUIEvent("btn_bz",UIEventType.Click,"OnBuzhengClick")
    --绑定事件
    --self:BindUIEvent("btn_kbx",UIEventType.Click,"OnChouJiangClick")

    self:BindUIEvent ("btn_dt", UIEventType.Click, "OnDailyTasksClick") --點擊導航-每日活動
    self:BindUIEvent ("btn_bb", UIEventType.Click, "OnBeiBaoSystemClick") --點擊導航-背包繫統
    
    --立即刷新显示状态
    self:OnTopWndChanged(Wnd.GetTopWnd())
end

------------------------------每日活動相關------------------------------
function wnd_daohangClass:OnDailyTasksClick ()
    wnd_background:Show ()
    wnd_dailytasks:Show ()
    wnd_background:ShowListOnbackground (wnd_dailytasks)
end

------------------------------背包繫統相關------------------------------
function wnd_daohangClass:OnBeiBaoSystemClick ()
    wnd_background:Show ()
    wnd_beibao:Show ()
    wnd_background:ShowListOnbackground (wnd_beibao)
end



--实例即将被丢失
function wnd_daohangClass:OnLostInstance() 
    self.PopMenu = nil
end 


 
return wnd_daohangClass.new
 