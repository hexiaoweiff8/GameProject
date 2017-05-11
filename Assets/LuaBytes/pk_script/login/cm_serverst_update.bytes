----region *.lua
----Date
----服务器状态更新组件
--local CMServerSTUpdate = class()

--ServerSTUpdate = nil --单例

--local SvrST = {
--    Normal = 1,--正常 
--    WeiHu = 2,--维护中 
--    BaoMan = 3,--爆满 
--    FanMang = 4,--繁忙 
--    LiuChang = 5,--流畅 
--    XinFu = 6, --新服 
--    TuiJian = 7 --推荐 
--}

--local workst={
--    none = 1,--等待分派
--	wait = 2,--等待
--	doing = 3--任务执行中
--}

--function CMServerSTUpdate:Start() 
--    ServerSTUpdate = self
--	self.st = workst.none	
--    self.serverSTs = {} --服务器状态
--    self.TotalSvrST = SvrST.WeiHu--总服务器状态
--    self.lastXmlCode = ""--前一次解释到的服务器状态列表xml文本
--    self.errorCount = 0--获取失败次数
--    self.hasInfo = false--是否已经包含有效状态信息
--end

--function CMServerSTUpdate:Update()
--	if(self.st == workst.none) then
--	    self.st = workst.doing
--		local url = Application.GetRomValue("ServerSTUrl")

--	    StartCoroutine(self,self.coUpdateFromUrl, url)
--	end

--	if(self.st==workst.wait) then
--	    if(os.clock()>self.waitend) then
--		    self.st = workst.none
--		end
--	end
--end


----- <summary>
----- 解析服务器状态
----- </summary>
--function CMServerSTUpdate:ParseServerST(xmlCode)
--    if(xmlCode==self.lastXmlCode) then return end--文本没有变化，不解释
--    self.lastXmlCode = xmlCode
--    local xmlDoc = XML.Parse(xmlCode)
--    if(xmlDoc==nil) then return end --xml解释出错
--    local xmlnode = xmlDoc:SelectSingleNode("xml")
--    if(xmlnode==nil) then return end

--    local tstattr = xmlnode:GetAttribute("st")
--    if(tstattr==nil) then return end
--    self.TotalSvrST = tstattr +0

--    local svrs = xmlDoc:SelectNodes("xml/a")
--    if(svrs==nil) then return end
--    self.serverSTs = {}--清空服务器状态
--    local eachfunc = function(_,xmlNode)

--        --构建信息
--        local st = xmlNode:GetAttribute("st") 
--        local zone = xmlNode:GetAttribute("id")

--        --严防更新人员手误导致代码错误
--        if(st~=nil and zone~=nil) then
--            self.serverSTs[zone+0] = st+0
--        end
--    end

--    --遍历所有服务器列表节点
--    table.foreach(svrs,eachfunc)

--    self.hasInfo = true

--    --抛出服务器列表变更事件
--    EventHandles.OnServerSTChanged:Call(nil)

--end 

--function CMServerSTUpdate:coUpdateFromUrl(url)	
--	local www = WWW.new(url)

--     debug.LogInfo(" CMServerSTUpdate:coUpdateFromUrl url:{0}",url)
--    while(not www:IsDone() and www:GetError()==nil) do Yield() end		

--	if(www:GetError()==nil) then --成功完成url装载

--        self.errorCount = 0--重置错误次数
--        self:ParseServerST(www:GetText())

--	    self.waitend = os.clock() + 5
--	    self.st = workst.wait--等待一段时间后再获取
--	else
--        self.errorCount=self.errorCount+5

--        debug.LogError(www:GetError())
--        debug.LogError("loading svrst error")
--        --连续3次获取失败
--        if(self.errorCount>3) then 
--            self.errorCount = 0
--            --清空服务器状态信息
--            self.serverSTs = {}
--            self.TotalSvrST = SvrST.WeiHu
--            self.lastXmlCode = ""
--            self.hasInfo = false
--            EventHandles.OnServerSTChanged:Call(nil) --通知服务器状态已改变
--        end
--	    self.st = workst.none--失败了则立即尝试重新获取
--	end
--end


----获取服务器状态
--function CMServerSTUpdate:GetServerST(zone)
--    if(self.TotalSvrST==SvrST.WeiHu) then return self.TotalSvrST  end
--    return self.serverSTs[zone] or self.TotalSvrST 
--end

--function CMServerSTUpdate:HasInfo()  return self.hasInfo end

--function CMServerSTUpdate:CanLogin(zone)
--    local re = (self:GetServerST(zone)~=SvrST.WeiHu)
--    return re
--end


--function CMServerSTUpdate:SvrST2Str(st)
--    local SvrSTStr = {
--        [1] = {n = "正常",c=Color.green,ico="st_zhengchang"} ,
--        [2] = {n ="维护",c=Color.red,ico="st_weihu"} ,
--        [3] = {n ="爆满",c=Color.red,ico="st_huobao"} ,
--        [4] = {n ="繁忙",c=Color.red,ico="st_fanmang"} ,
--        [5] = {n ="流畅",c=Color.cyan,ico="st_liuchang"} ,
--        [6] = {n ="新服",c=Color.blue,ico="st_xinfu"} ,
--        [7] = {n ="推荐",c=Color.yellow,ico="st_tuijian"} , 
--    }
--    local re = SvrSTStr[st]
--    if(re==nil) then  re = SvrSTStr[SvrST.WeiHu] end


--    return re.n,re.c,re.ico
--end



--return CMServerSTUpdate.new
----endregion
