----region *.lua
----Date 20150804
----服务器列表界面
----作者 wenchuan

--wnd_serverlist = nil--单例


--local class_wnd_serverlist = class(wnd_base)

--function class_wnd_serverlist:Start()
--    self:Init(WND.SelServer)
--    wnd_serverlist = self
--    self.svrGroupItems = {}--存储克隆出的服务器组控件
--    self.Event_ZoneChanged = Event.new()
--    self.currSelZone = -1--当前选择的服务器分区号
--end

----有对象互访逻辑的初始化
--function class_wnd_serverlist:CrossInit() 
--    --绑定服务器列表变更事件
--    EventHandles.OnServerListChanged:AddListener(self,self.OnSvrListChanged) 

--    --绑定服务器状态变更事件
--    EventHandles.OnServerSTChanged:AddListener(self,self.OnSvrListChanged) 
--end

--function class_wnd_serverlist:FillSvrInfo(svrInfo,lable_zone,lable_name,lable_st,lable_date)
--    if(svrInfo~=nil) then
--        local zone,name,tm = svrInfo.zone,svrinfo.name,svrinfo.tm 
--        local st = ServerSTUpdate:GetServerST(svrInfo.zone)

--        lable_name:SetValue(name)
--        lable_zone:SetValue(zone.."服")

--        local ststr,color,ico = ServerSTUpdate:SvrST2Str(st)--获取服务器状态字符串和颜色

--        lable_st:SetValue(ststr)
--        lable_st:SetColor(color)

--        if(lable_date~=nil) then 
--            local ymdh = string.split(tm,"-")

--            local showDate = string.sformat("开服时间: {0}年{1:d2}月{2:d2}日 {3:d2}时",
--                    ymdh[1],
--                    ymdh[2],
--                    ymdh[3],
--                    ymdh[4]
--                    )
--            lable_date:SetValue(showDate) 
--        end
--    else
--        lable_name:SetValue("-")
--        lable_zone:SetValue("-")
--        lable_st:SetValue("-")

--        if(lable_date~=nil) then lable_date:SetValue("-") end
--    end 
--end

----- <summary>
----- 更新服务器组选择列表
----- </summary>
--function class_wnd_serverlist:UpdateGroupSelList()
--    local mbitem = self:GetGroupItemMB()

--    --清空之前克隆出的所有组控件
--    for _,item in pairs(self.svrGroupItems ) do 
--        item:Destroy()
--    end  
--    self.svrGroupItems = {}

--    local seldGroupID = ServerListUpdate:Zone2GroupID(self.currSelZone)

--    --服务器组
--    local showGroups = ServerListUpdate:BuildSvrGroupStrList()
--    local grpEachFunc = function (_,groupInfo)
--        --groupInfo = {gid,str}

--        local gid = groupInfo[1] 
--        local newItem = GameObject.InstantiateFromPreobj(mbitem,mbitem:GetParent())
--        newItem:SetName(string.sformat("AITEM_{0:00}",gid))--设置新组件名字
--        newItem:SetActive(true)--激活这个控件

--        local label_aitem_obj = newItem:FindChild("label")
--        local label_aitem = label_aitem_obj:GetComponent( CMUILabel.Name )--获得label组件
--        label_aitem:SetValue(groupInfo[2])--设置显示文字

--        --绑定点击事件
--        local cm_uievent = newItem:AddComponent(CMUIEvent.Name)
--        cm_uievent:Listener(newItem,UIEventType.Click,self,"OnSvrGroupClick",gid)

--        --设置选中状态
--        local  group_toggle = newItem:GetComponent(CMUIToggle.Name)
--        group_toggle:SetValue(gid == seldGroupID)

--        table.insert(self.svrGroupItems,newItem) --添加到列表
--    end
--    table.foreach(showGroups,grpEachFunc)


--    --重新布局
--    local gridObj = self.instance:FindWidget("A_ScrollView/Grid")
--    local cmgrid = gridObj:GetComponent(CMUIGrid.Name)
--    cmgrid:Reposition()
--end

----- <summary>
----- 服务器组被点击
----- </summary>
--function class_wnd_serverlist:OnSvrGroupClick(gameObj,gid)
--    local groupInfo = ServerListUpdate:GetGroup(gid)
--    local zid,zinfo = table.firstItem(groupInfo)
--    self.currSelZone = zid--设置当前选择的服务器
--    self:UpdateServerList()--刷新显示
--end


----- <summary>
----- 服务器列表被点击
----- </summary>
--function class_wnd_serverlist:OnSvrListClick(gameObj,zid)
--    self.currSelZone = zid--设置当前选择的服务器

--    --抛出服务器列表选择变更事件
--    self.Event_ZoneChanged:Call(zid)

--    self:Hide()--隐藏界面
--end

--function class_wnd_serverlist:CorrectionZone()
--    local zoneInfo = ServerListUpdate:GetZoneInfo(self.currSelZone)
--    if(zoneInfo==nil) then 
--        local defaultsvr = ServerListUpdate:GetDefaultSvr() 
--        if(defaultsvr==nil) then return false end
--        self.currSelZone = defaultsvr.zone
--    end    
--    return true
--end

----- <summary>
----- 更新服务器选单
----- </summary>
--function class_wnd_serverlist:UpdateServerList()
--    if(not self:CorrectionZone()) then return end

--    local groupID = ServerListUpdate:Zone2GroupID(self.currSelZone)
--    local groupInfo = ServerListUpdate:GetGroup(groupID)

--    local currSelItem = nil

--    local fillIndex = 1
--    local svrFillFunc = function(zone,svrInfo)
--        local itemname = string.sformat("item{0:D2}",fillIndex)
--        local itemObject = self.instance:FindWidget(itemname)
--        itemObject:SetActive(true)        

--        local itemZoneName = string.sformat("item{0:D2}/item_zone",fillIndex)
--        local zoneLable = self:GetLabel(itemZoneName)

--        local itemSvrName = string.sformat("item{0:D2}/item_svr",fillIndex)
--        local svrLable = self:GetLabel(itemSvrName)

--        local itemSTName = string.sformat("item{0:D2}/item_st",fillIndex)
--        local stLable = self:GetLabel(itemSTName)

--        zoneLable:SetValue(string.sformat( "{0}服",svrInfo.zone))--设置服务器区文字
--        svrLable:SetValue(svrInfo.name)--设置服务器名文字

--        local st = ServerSTUpdate:GetServerST(svrInfo.zone)
--        local ststr,stcolor,ico = ServerSTUpdate:SvrST2Str(st)
--        stLable:SetValue(ststr)--设置状态文字

--        --绑定点击事件
--        local uievt = itemObject:GetComponent(CMUIEvent.Name,true)--获取事件监听组件，如果不存在则自动创建
--        uievt:Listener(itemObject,UIEventType.Click,self,"OnSvrListClick",svrInfo.zone);

--        --设置颜色
--        zoneLable:SetColor(stcolor)
--        svrLable:SetColor(stcolor)
--        stLable:SetColor(stcolor)

--        fillIndex = fillIndex+1

--        --设置服务器列表选中状态
--        local cm_toggle = itemObject:GetComponent(CMUIToggle.Name)
--        cm_toggle:SetValue(zone==self.currSelZone) 
--    end
--    table.foreach(groupInfo,svrFillFunc)

--    --隐藏掉多余的服务器列表
--    for  i2=fillIndex,10 do 
--        local itemName = string.sformat("item{0:D2}",i2)
--        local itemObj = self.instance:FindWidget(itemName) 
--        itemObj:SetActive(false)        
--    end  



--    --重新布局列表
--    local tableObj = self.instance:FindWidget("svrListTable")
--    local cmtable = tableObj:GetComponent(CMUITable.Name)
--    cmtable:Reposition()
--end

----- <summary>
----- 更新选择向导
----- </summary>
--function class_wnd_serverlist:UpdateSelGuide()
--    local tjSvr = ServerListUpdate:GetTuiJianZone()--推荐服
--    local lastSvr = ServerListUpdate:GetLastSeldSvr()--上次登录过的分区

--    --显示推荐服务器信息
--    local lable_tjzone = self:GetLabel("nsv_lable02");
--    local lable_tjname = self:GetLabel("nsv_lable03");
--    local lable_tjst = self:GetLabel("nsv_lable04");
--    local lable_startdate = self:GetLabel("nsv_lable05");
--    self:FillSvrInfo(tjSvr,lable_tjzone,lable_tjname,lable_tjst,lable_startdate)

--    --显示上次登录服务器信息
--    local lable_lastzone = self:GetLabel("csv_lable02");
--    local lable_lastname = self:GetLabel("csv_lable03");
--    local lable_lastst = self:GetLabel("csv_lable04");
--    self:FillSvrInfo(lastSvr,lable_lastzone,lable_lastname,lable_lastst)
--end

--function class_wnd_serverlist:OnNewInstance()

--    --克隆出10个服务器列表Item
--    local item01 = self.instance:FindWidget("item01");    
--    for i=2,10 do 
--        local newGameObj = GameObject.InstantiateFromPreobj(item01,item01:GetParent() )
--        local itemSvrName = string.sformat("item{0:D2}",i)
--        newGameObj:SetName(itemSvrName)
--    end  

--    --自动设置当前选中的分区
--    local defaultSvr = ServerListUpdate:GetDefaultSvr()--推荐服
--    if(self.currSelZone<0) then self.currSelZone =  defaultSvr.zone  end 

--    --获得服务器组列表Item模板，并隐藏掉
--    local mbitem = self:GetGroupItemMB()
--    mbitem:SetActive(false)

--    --立即刷新界面显示
--    self:OnSvrListChanged(nil)
--end

----- <summary>
----- 服务器列表发生变更
----- </summary>
--function class_wnd_serverlist:OnSvrListChanged(_)
--    if(self.instance==nil) then  return  end
--    if(not self:CorrectionZone()) then return end
--    --更新选择向导界面
--    self:UpdateSelGuide() 

--    --更新服务器选单
--    self:UpdateServerList() 

--    --更新服务器组选择列表
--    self:UpdateGroupSelList() 
--end

----- <summary>
----- 获取服务器组选择item模板
----- </summary>
--function class_wnd_serverlist:GetGroupItemMB()
--    return self.instance:FindWidget("A_ScrollView/Grid/aitem")
--end

--function class_wnd_serverlist:OnLostInstance()
--end


--return class_wnd_serverlist.new
----endregion
