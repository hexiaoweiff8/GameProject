----region *.lua
----Date 20150828
----断线自动重连组件

--local cm_AutoReConn = classWC()

--function cm_AutoReConn:Start()
--    --绑定掉线事件
--    EventHandles.OnDisconnected:AddListener(self,self.OnDisconnected)  
--end

----掉线回调
--function cm_AutoReConn:OnDisconnected()
--   if(not LoginSystem.IsLoginOK) then return end
--   LoginSystem.IsLoginOK = false

--   StartCoroutine(self,self.coReConn,{})--启动一个协程
--end

----断线重连协程
--function cm_AutoReConn:coReConn(parm)
--    local reConnCount = 0

--    if debug.IsDev() then reConnCount=1 end--研发模式，总是提示是否重连

--    while(self:DoReConn(reConnCount)) do reConnCount=reConnCount+1 end
--end

--function cm_AutoReConn:DoReConn(reConnCount)
--    local result = 2--默认是重新尝试

--    if(reConnCount~=0) then --不是断开后的首次重连
--        --弹出消息框，询问是否重连
--        local resultwait = MsgboxResultWait.new()
--        MsgBox.Show("网络异常，是否重连?","否","是",resultwait,resultwait.OnMsgBoxClose)
--        result = resultwait:GetResult()--取得用户选择
--    end

--    if(result==2) then--用户选择重新尝试
--	    ServerLink:ConnLast() --连接服务器
--        while(ServerLink.step == ServerLinkStep.Conning) do Yield() end--等待连接完成

--        if(ServerLink.step ~= ServerLinkStep.Logining) then return true end --连接失败了，继续询问是否重连

--        --发送重连请求
--        local qkjsonDoc = JsonParse.SendNM("clk")
--	    qkjsonDoc:Add("p", LoginSystem.lastPlatform)--平台
--        qkjsonDoc:Add("z",LoginSystem.lastZone)--分区
--        qkjsonDoc:Add("account",LoginSystem.lastUser)--账户
--        qkjsonDoc:Add("vpn",PlayerData.vpn)
--        qkjsonDoc:Add("mode",LoginSystem.lastLoginMode)

--        local loader = Loader.new(qkjsonDoc:ToString(),3,"reclk") 
--	    local reclk = LoaderEX.SendJsonAndWait(loader)

--	    if(reclk==nil)  then  return true end--网络中断或超时

--	    local isok = tonumber(reclk:GetValue("isok"))
--        if(isok~=1) then return true end--重连失败

--        PlayerData.vpn = reclk:GetValue("vpn")
--        return false--重连成功
--    else
--        Wnd.HideAll() --隐藏全部界面
--        wnd_login:Show() --退回登录界面
--		PlayerData.data = {} --清登录后的角色数据
--        return false
--    end
--end

--return cm_AutoReConn.new
----endregion
