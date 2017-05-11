--region *.lua
--Date 20150810
--窗体跳转管理器

WndJumpManage = {}
local isHaveBase = true
--外部主要调用接口
--EventHandles.OnWndExit
--WndJumpManage:Jump(from,showWnd)
--_JumpWnd      --从这跳到
--_ActiveWnd    --这
    
function WndJumpManage:init()
		self:Reset()
        
        EventHandles.OnWndExit:AddListener(WndJumpManage,WndJumpManage.OnWndExit)
        EventHandles.OnQKNodeLinkBreak:AddListener(WndJumpManage,WndJumpManage.OnQKNodeLinkBreak)

end

--- <summary>
--- 窗体被关闭
--- </summary>
function WndJumpManage:OnWndExit(name)
    print("OnWndExit:",name)
	local jumpWnd = WND.None;
	--检查活动窗口是否满足条件
    local curr = self.m_WndOrder[#self.m_WndOrder]
    if curr == nil then 
        self:Show3(name,false,false)
        return
    end

    if curr._ActiveWnd == name then 
         local NeedClose = Wnd.Get(curr._ActiveWnd)
         local NeedVisit = Wnd.Get(curr._JumpWnd)
         self:Show3(curr._JumpWnd,true,false)
         self:Show3(curr._ActiveWnd,false,false)
         
         table.remove(self.m_WndOrder,#self.m_WndOrder)
         return 
    end

    self:Show3(name,false,false)

end

function WndJumpManage:Reset()
    self.m_BaseWnd = WND.Tuiguan
	self:CancelAllJumps()
end

--- <summary>
--- 与QKNode服务器之间的连线中断
--- </summary>
function WndJumpManage:OnQKNodeLinkBreak(_)
    self:Reset()
end

--- <summary>
---撤销所有跳转 
--- </summary>
function WndJumpManage:CancelAllJumps()
	self.m_WndOrder = {}--撤销所有的跳转 
end

function WndJumpManage:GetLastWndInfo()
	local nSize = #self.m_WndOrder
	if(nSize == 0) then return nil end
    return self.m_WndOrder[nSize]
end
--- <summary>
--- 判定某窗体是否为导航选项卡模式 
--- </summary>
function WndJumpManage:IsDaoHangTab(wnd)
    local DaoHangTab = {
        [WND.ZhaoMu]=1,
        [WND.BuZheng]=1,
        [WND.JunXuChu]=1,
        [WND.ChouJiang]=1,
        [WND.Backpack]=1, 
    }

    return ifv(DaoHangTab[wnd]~=nil,true,false)
end

function WndJumpManage:IsBaseWnd(wnd) 
     local BaseWndDefine = {
        --[WND.Main]=1,
        [WND.GuoZhan]=1,
        [WND.GuanKa]=1,
        [WND.Arena]=1, 
        [WND.DFArena]=1, 
        [WND.Tuiguan]=1, 
    }

    return ifv(BaseWndDefine[wnd]~=nil,true,false)
end

function WndJumpManage:Jump(from,showWnd)
	--if(from == WND.DaoHang) then
    --    --隐藏全部窗体
    --    Wnd.HideAll()
	--else
	--	self:Show3(from,false,true)
    --end
    --print("WndJumpManage:Jump",from,"To",showWnd)

	local isLegal = self:PushWindow(from,showWnd)
    if isLegal == false then 
        print("WndJumpManage:Jump","用户连续点击按钮，连续两次相同跳转")
        return 
    end

    local BaseCount = 0
    if self:IsBaseWnd(from) then 
        BaseCount = BaseCount + 1
    end
    if self:IsBaseWnd(showWnd) then 
        BaseCount = BaseCount + 1
    end

    if BaseCount ~= 0 then    --本次跳转涉及底层变换
        self:SpecialBase(BaseCount)
        return
    end 

    self:Show3(from,false,true)

	self:Show3(showWnd,true,true)
end

function WndJumpManage:Show2(wnd,isShow)
 		self:Show3(wnd,isShow,true)
end

 
--- <summary>
--- 自动对跳转堆栈进行剪裁，防止缓存的跳转返回过长 
--- </summary>
function WndJumpManage:AutoCut(wnd)
	local pLast = self:GetLastWndInfo()
	if(pLast==nil or pLast._ActiveWnd~=wnd) then return end

	local sum = 0
    local eachFunc = function(_,curr)
        if(curr._ActiveWnd==wnd) then sum=sum+1 end
    end
    table.foreach(self.m_WndOrder,eachFunc)

	if(sum>1) then--存在重复 
		--仅保留最后一个跳转 
		self:CancelAllJumps();
		table.insert(self.m_WndOrder,pLast)
	end
end


function WndJumpManage:PushWindow(_From,_Goto)

	local pLast = self:GetLastWndInfo();
    if pLast ~= nil then 
        if pLast._JumpWnd == _From and pLast._ActiveWnd == _Goto then
            return false    --连续跳转
        end 
    end
	

    local _Info = {}
	_Info._JumpWnd = _From;

	--两次都是平行窗口,不添加跳转 
	if(pLast~=nil and pLast._JumpWnd == WND.DaoHang and
		self:IsDaoHangTab(_Goto)
		) then
		pLast._ActiveWnd = _Goto;
	else
		_Info._ActiveWnd = _Goto; 
		table.insert(self.m_WndOrder ,_Info)
	end
    if(self:IsBaseWnd(_Goto)) then self.m_BaseWnd = _Goto end 

	--人物和每日奖励的跳转，不允许出现重复 
	self:AutoCut(WND.ZhaoMu)
	self:AutoCut(WND.HuoDong)
end

function WndJumpManage:SetBaseWnd(wnd)--强制设置底层窗口 
	self.m_BaseWnd = wnd;
end


function WndJumpManage:RemoveLastJump()
    table.remove(self.m_WndOrder,#self.m_WndOrder)
end


function WndJumpManage:UnJump(wnd)--撤销跳转 
	local needRemove = false

	 local eachFunc = function(_,curr)
        if(curr._ActiveWnd==wnd) then
			needRemove = true
        end
    end
    table.foreach(self.m_WndOrder,eachFunc)

	if(not needRemove) then return end

	--移除队尾无效跳转 
    local len = #self.m_WndOrder
    while(len>0) do
        local curr = self.m_WndOrder[len]
        local needBreak = (curr._ActiveWnd==wnd)
		table.remove(self.m_WndOrder,len)
        len=len-1
		if(needBreak) then break end
    end 
end
function WndJumpManage:BaseShow(baseWnd,isShow)
    
end

function WndJumpManage:SpecialBase(BaseCount)
    local Curr = self.m_WndOrder[#self.m_WndOrder]
    if BaseCount == 2 then 
        self:Show3(Curr._JumpWnd,false)
        self:Show3(Curr._ActiveWnd,true)
    else
        if self:IsBaseWnd(Curr._JumpWnd) then
            self:Show3(Curr._ActiveWnd,true)
        else
            self:Show3(Curr._JumpWnd,false)
        end
    end
end
 function WndJumpManage:SpecialEmbed( wnd,  isShow)
    --print("WndJumpManage:SpecialEmbed:",wnd.name,isShow)

    if(wnd.name == "ui_buzheng") then
        local EmbedWND = Wnd.Get(WND.CardCollection)
        if isShow then
            --exui_CardCollection:SetShowType(1)
            EmbedWND:Show()
        else
            EmbedWND:Hide() 
        end

    elseif(wnd.name == "ui_paiku") then
        local EmbedWND = Wnd.Get(WND.CardCollection)
        if isShow then
             --exui_CardCollection:SetShowType(2)
             EmbedWND:Show()
        else
             EmbedWND:Hide() 
        end
    
    end 
end

function WndJumpManage:Show3( wnd,  isShow,  isEnter)
	--print("WndJumpManage:Show3",wnd,isShow)
    local temp = Wnd.Get(wnd)
    if(temp~=nil) then
        if(isShow) then 
            temp:Show()
        else
            temp:Hide()
        end
    else 
        print("WndJumpManage:Show3 ERROR _Not Find WND:",wnd.name)
    end

    self:SpecialEmbed(temp,isShow)

end

--用互斥的模式显示底层面板 
function WndJumpManage:ShowBaseWnd(baseWnd)
	if(not self:IsBaseWnd(wnd)) then return end

    if(baseWnd==WND.Main) then
        Wnd.Get(WND.Main):Show()
    else
		Wnd.Get(WND.Main):Hide()
    end
	
    if(baseWnd==WND.GuoZhan) then
        Wnd.Get(WND.GuoZhan):Show()
    else
		Wnd.Get(WND.GuoZhan):Hide()
    end

    if(baseWnd==WND.GuanKa) then
        Wnd.Get(WND.GuanKa):Show()
    else
		Wnd.Get(WND.GuanKa):Hide()
    end

    if(baseWnd==WND.Arena) then
        Wnd.Get(WND.Arena):Show()
    else
		Wnd.Get(WND.Arena):Hide()
    end   

    if(baseWnd==WND.DFArena) then
        Wnd.Get(WND.DFArena):Show()
    else
		Wnd.Get(WND.DFArena):Hide()
    end   
end
--endregion
