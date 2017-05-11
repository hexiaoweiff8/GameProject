--local cm_serverlink = classWC()

--ServerLink = nil

--ServerLinkStep = {
--    None = 1,
--	Conning = 2,
--	Logining = 3,
--	Gameing =4
--}

--function cm_serverlink:ctor()	
--	self.step=ServerLinkStep.None

--	--获取QKNode连接组件
--	local gamePlatformObj = GameObject.Find("GamePlatform")
--	self.Client = gamePlatformObj:GetComponent(CMQKNodeClient.Name,false)
--end 

--function cm_serverlink:Start() 
--	ServerLink = self 

--	--绑定各种事件
--	self.Client.OnConn:AddCallback(self,self.OnQKNodeConn)
--	self.Client.OnDisconnected:AddCallback(self,self.OnQKNodeDisconnected)
--	self.Client.OnEnableCtrl:AddCallback(self,self.OnQKNodeEnableCtrl) 
--	self.Client.OnRecvBin:AddCallback(self,self.OnQKNodeRecvBin)
--	self.Client.OnSoftConn:AddCallback(self,self.OnQKNodeSoftConn)
--	self.Client.OnSoftDisconnected:AddCallback(self,self.OnQKNodeSoftDisconnected)
--end

--function cm_serverlink:Conn(ip,port) 
--	if(self.step~=ServerLinkStep.None) then return end  
--	self.step = ServerLinkStep.Conning 
--    self.lastIP = ip 
--    self.lastPort = port 
--	self.Client.Conn(ip,port)   
--end

--function cm_serverlink:ConnLast() 
--    self:Conn(self.lastIP,self.lastPort) 
--end

--function cm_serverlink:OnLoginOK(ip,port)
--	if(self.step~=ServerLinkStep.Logining) then return end
--	self.step = ServerLinkStep.Gameing
--end

--function cm_serverlink:Send(msg,flag)
--	self.Client.Send(msg,flag)
--end

--function cm_serverlink:ResultTimeout()
--    self.Client.ResultTimeout()
--end

--function cm_serverlink:Close()
--    self.Client.Close()
--end

--function cm_serverlink:SoftClose()
--     self.Client.SoftClose()
--end

----连接QKNode成功
--function cm_serverlink:OnQKNodeConn(_) 
--	self.step = ServerLinkStep.Logining
--end

----QKNode掉线
--function cm_serverlink:OnQKNodeDisconnected(_) 
--	if(self.step== ServerLinkStep.None) then return end
--	self.step = ServerLinkStep.None 

--	--抛出掉线事件
--    EventHandles.OnDisconnected:Call(nil)
--end


----QKNode禁用/启用用户控制
--function cm_serverlink:OnQKNodeEnableCtrl(enable)
--        App.LockScreen(not enable)
--end



--function cm_serverlink:OnQKNodeRecvBin(binnm)

--    print("OnQKNodeRecvBin ")

--	--通知逻辑层

--end

----QKNode软连接成功
--function cm_serverlink:OnQKNodeSoftConn(_)
--	LoaderManage.SetEnable(true)
--end

----QKNode软连接掉线
--function cm_serverlink:OnQKNodeSoftDisconnected(_)
--	LoaderManage.SetEnable(false)
--end

--return cm_serverlink.new