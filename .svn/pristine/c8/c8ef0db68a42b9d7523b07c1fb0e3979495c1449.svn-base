----------------------------------
----服务器列表信息更新组件
--local CMServerListUpdate = classWC()


--local workst={
--    none = 1,--等待分派
--	wait = 2,--等待
--	doing = 3--任务执行中
--}

--ServerListUpdate = nil --单例

--function CMServerListUpdate:Start() 
--    ServerListUpdate = self
--	self.st = workst.none	
--    self.serverInfos = {} --服务器信息
--    self.lastServerXmlCode = ""--前一次解释到的服务器列表xml文本
--    self.serverGroups = {}--按照显示分组的服务器队列 
--end

--function CMServerListUpdate:Update()
--	if(self.st == workst.none) then
--	    self.st = workst.doing
--		local url = Application.GetRomValue("ServerListUrl")

--	    StartCoroutine(self,self.coUpdateFromUrl, url)
--	end

--	if(self.st==workst.wait) then
--	    if(os.clock()>self.waitend) then
--		    self.st = workst.none
--		end
--	end
--end


--local function Zone2GroupID(zone)
--    return math.floor((zone-1)/10) + 1
--end

--function CMServerListUpdate:BuildShowSvrGroup()
--    self.serverGroups = {}
--    local eachfunc = function(zone,svrInfo)
--        local groupID = Zone2GroupID(zone)
--        if(self.serverGroups[groupID]==nil) then self.serverGroups[groupID] = {} end
--        self.serverGroups[groupID][zone] = svrInfo
--    end
--    table.foreach(self.serverInfos,eachfunc)
--end


----- <summary>
----- 解析服务器列表
----- </summary>
--function CMServerListUpdate:ParseServerList(xmlCode)


--    if(xmlCode==self.lastServerXmlCode) then return end--文本没有变化，不解释
--    self.lastServerXmlCode = xmlCode
--    local xmlDoc = XML.Parse(xmlCode) 
--    if(xmlDoc==nil) then return end--配置文件不正确 
--    local svrs = xmlDoc:SelectNodes("xml/GameServers/a")
--    if(svrs==nil) then return end

--    local clientVer = ClientConfig.Ver
--    self.serverInfos = {}--清空服务器信息

--    local eachfunc = function(_,xmlNode)

--        --构建信息
--        svrinfo = {}
--        svrinfo.zone = xmlNode:GetAttribute("number")
--        svrinfo.name = xmlNode:GetAttribute("name") 
--        svrinfo.tm = xmlNode:GetAttribute("tm") 
--        --svrinfo.ip = xmlNode:GetAttribute("ip") 
--        --svrinfo.port = xmlNode:GetAttribute("port")
--        svrinfo.url = xmlNode:GetAttribute("url")
--        local ver = xmlNode:GetAttribute("ver")
--        local vercomp = xmlNode:GetAttribute("vercomp")

--        --严防更新人员手误导致代码错误
--        if(
--            svrinfo.zone~=nil and svrinfo.name~=nil and
--            --svrinfo.ip~=nil and svrinfo.port~=nil and
--            svrinfo.url~=nil and
--            ver~=nil and vercomp~=nil 
--        ) then 
--            if(svrinfo.tm==nil) then

--                svrinfo.tm = "1981-10-07-06"

--            else

--                local tmar = string.split(svrinfo.tm,'-')

--                if(#tmar~=4) then svrinfo.tm = "1981-10-07-06" end

--            end 

--            svrinfo.zone = tonumber(svrinfo.zone) or 0
--           -- svrinfo.port = tonumber(svrinfo.port) or 0 
--            ver =  tonumber(ver) or 0 
--            local needShow = false


--            --判定版本信息是否和客户端匹配
--            if(vercomp=="greater") then 
--                if(clientVer>ver) then needShow=true end
--            elseif(vercomp=="less")  then 
--                if(clientVer<ver) then needShow=true end
--            else 
--                if(clientVer==ver) then needShow=true end
--            end 
--            --信息加入到列表
--            if(needShow) then 
--                self.serverInfos[svrinfo.zone] = svrinfo
--            else 
--            end 
--        end 
--    end
--    --遍历所有服务器列表节点
--    table.foreach(svrs,eachfunc)

--    --按照显示需求分组服务器
--    self:BuildShowSvrGroup()

--    --抛出服务器列表变更事件
--    EventHandles.OnServerListChanged:Call(nil) 
--end

--function CMServerListUpdate:coUpdateFromUrl(url)	
--	local www = WWW.new(url)
--    debug.LogInfo(" CMServerListUpdate:coUpdateFromUrl url:{0}",url)

--    while(not www:IsDone() and www:GetError()==nil) do Yield() end		

--	if(www:GetError()==nil) then --成功完成url装载
--        self:ParseServerList(www:GetText())

--	    self.waitend = os.clock() + 5
--	    self.st = workst.wait--等待一段时间后再获取
--	else
--        debug.LogWarning("loading serverlist error. " .. url)
--	    self.st = workst.none--失败了则立即尝试重新获取
--	end
--end



----是否已经包含有可用的服务器列表
--function CMServerListUpdate:HasServerInfo()
--	return table.hasItem(self.serverInfos)
--end

----- <summary>
----- 获取上次登录成功的分区，返回<=0的值表示无效
----- </summary>
--function CMServerListUpdate:GetLastSeldSvr()
--    local zone = GameCookies.GetZone()
--    local svrInfo = self.serverInfos[zone]
--    if(svrInfo~=nil) then return svrInfo else return nil end
--end

----- <summary>
----- 获取默认分区
----- </summary>
--function CMServerListUpdate:GetDefaultSvr()
--     --自动设置当前选中的分区
--    local tjSvr = self:GetTuiJianZone()--推荐服
--    local lastSvr = self:GetLastSeldSvr()--上次登录过的分区
--    local rezone = nil
--    if(rezone==nil and lastSvr~=nil) then rezone = lastSvr end
--    if(rezone==nil) then rezone = tjSvr end
--    return rezone    
--end


----- <summary>
----- 获取推荐分区
----- </summary>
--function CMServerListUpdate:GetTuiJianZone()
--    return self.serverInfos[table.maxn(self.serverInfos)]
--end

--function CMServerListUpdate:GetZoneInfo(zone)
--    return self.serverInfos[zone]
--end

----- <summary>
----- 构建字符串形式的服务器组列表
----- ret { {groupID,showStr},...   }
----- </summary>
--function CMServerListUpdate:BuildSvrGroupStrList()
--    local re = {}
--    local eachfunc = function(groupID,svrList)
--        local s = (groupID-1)*10
--        local showstr = string.sformat("{0:d3}-{1:d3}",s + 1,s + 10)
--        table.insert(re,1,{groupID,showstr})
--    end
--    table.foreach(self.serverGroups,eachfunc)

--    --对结果进行排序
--    local sortFunc= function(a,b)
--        return a[1]>b[1]
--    end
--    table.sort(re,sortFunc)

--    return re
--end

--function CMServerListUpdate:Zone2GroupID(zone)
--    return Zone2GroupID(zone)
--end

----- <summary>
----- 根据组ID获取组信息
----- ret {<zone>={},... }
----- </summary>
--function CMServerListUpdate:GetGroup(groupID)
--    return self.serverGroups[groupID]
--end


--return CMServerListUpdate.new