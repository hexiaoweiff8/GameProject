--[[
local cm_loginsys = class()

LoginSystem = nil --单例
local LoginResult = {
    success = 0,--成功
    connfaild = 1,--连线失败
    erroruser = 2,--用户名或密码错误
    disable = 3,--账户被封停
    weihu = 4,--服务器维护中
    vererror = 5,--客户端版本过低，需要大退
    none = 99,--未知原因
}

local LoginResultStr = {
    [1]="无法连接服务器",
    [2]="用户名或密码错误",
    [3]="账户被封停",
    [4]="服务器维护中",
    [5]="客户端版本过低需要大退",
    [99] = "未知错误"
}

function cm_loginsys:coShowMsgAndExit(msg)
    local resultwait = MsgboxResultWait.new()
	MsgBox.Show(msg,"","退出",resultwait,resultwait.OnMsgBoxClose)--显示消息框并等待用户确认
    Application.Quit()
    while(true) do Yield() end--编辑器模式无法执行退出逻辑，因此用这行阻挡后面的逻辑
end

function cm_loginsys:onLoginFailed(errid)
    debug.LogInfo("cm_loginsys:onLoginFailed errid:{0}",errid )
    App.LockScreen(false)--隐藏锁屏

    local errormsg = LoginResultStr[errid] or LoginResultStr[99]

    if(errid==LoginResult.vererror) then    --客户端版本和服务器不匹配
        StartCoroutine(self,self.coShowMsgAndExit,errormsg)--启动一个协程来显示消息框
    else
        Application.PopTip(errormsg,Color.red)
        wnd_login:ShowLoginWnd() --显示登陆界面
    end 
end

function cm_loginsys:Start()
    self.IsLoginOK = false
    LoginSystem = self
	LoginFramework.OnLogin:AddCallback(self,self.OnLogin)--绑定登陆框架的登陆事件
    LoginFramework.OnShowLoginMain:AddCallback(self,self.OnShowLoginMain)--绑定登陆框架的显示主面板事件
	LoginFramework.SelectGamePlatform(GamePlatform.QK)--选择登陆平台
end

function cm_loginsys:sendHello() 
    
	 --发送hello
	local loader = Loader.new("n:hello",3,"rehello") 
	local rehelloNM = LoaderEX.SendJsonAndWait(loader)
	--网络中断或超时
	if(rehelloNM==nil)  then  return LoginResult.connfaild end
	 
	local c = rehelloNM:GetValue("c")--加密公钥
    local ver = rehelloNM:GetValue("v") + 0--服务器版本号
    if(PlayerData.svrVersion~=nil and PlayerData.svrVersion~=ver) then
          return LoginResult.vererror
    end
    PlayerData.svrVersion = ver
    PlayerData.ckey = Encoding.BuildCKey(c)

	return LoginResult.success
end

function cm_loginsys:sendLK(context)
    --记录是否为游客标志
    PlayerData.isCasual = context.casual 

    self.lastUser = context.userid
    self.lastPass = context.pass
    self.lastZone = wnd_login.currzone
    self.lastPlatform = LoginFramework.GetPlatformID()
	 --发送lk
	
	local qkjsonDoc = JsonParse.SendNM("lk")
	qkjsonDoc:Add("account",context.userid)
	qkjsonDoc:Add("z",self.lastZone)--区
	qkjsonDoc:Add("pass",context.pass )
	qkjsonDoc:Add("p",self.lastPlatform)--平台
	
	local mode 
	if context.casual then mode = 0 else mode=1 end

    self.lastLoginMode = mode

	qkjsonDoc:Add("mode",mode)
	qkjsonDoc:Add("ckey",PlayerData.ckey)
	
    local loader = Loader.new(qkjsonDoc:ToString(),3,"relk")
	local jsonNM = LoaderEX.SendJsonAndWait(loader)
    
	--网络中断或超时
	if(jsonNM==nil) then return LoginResult.connfaild end
	 
	local result = jsonNM:GetValue("result")+0
	if(result==2) then--账户或密码错
        return LoginResult.erroruser
	else
	    if(result==4) then--权限不足
            return LoginResult.disable
		else
		    if(result==0) then--登陆成功
			    PlayerData.userid = jsonNM:GetValue("u")
				PlayerData.vpn = jsonNM:GetValue("vpn")
				return LoginResult.success
			end
		end
	end
	
	return LoginResult.none
end

function cm_loginsys:coLogin(context)
    App.LockScreen(true)--显示锁屏

    local zoneInfo = wnd_login:GetCurrZoneInfo()
     
    
    --检查服务器状态
    if(not ServerSTUpdate:CanLogin(zoneInfo.zone)) then
        self:onLoginFailed(LoginResult.weihu)
        return
    end
      
	if(ServerLink.step == ServerLinkStep.None) then
	    ServerLink:Conn(zoneInfo.ip,zoneInfo.port)--连接服务器
	end
     
    App.LockScreen(true)--显示锁屏
	 

	while(ServerLink.step ~= ServerLinkStep.Logining) do 
	
	    --连接服务器失败了
	    if(ServerLink.step==ServerLinkStep.None) then
			self:onLoginFailed(LoginResult.connfaild )
		    return
		end
		
    	Yield() --继续等待连接
	end	
	    
    local helloResult = self:sendHello()
    if  helloResult~=LoginResult.success  then self:onLoginFailed(helloResult) return end
	 
	local lkresult = self:sendLK(context)
	if lkresult~=LoginResult.success  then self:onLoginFailed(lkresult) return end

    App.LockScreen(false)--隐藏锁屏

    --隐藏登陆面板
    wnd_login:Hide()  
end

function cm_loginsys:OnShowLoginMain()
    wnd_login:ShowLoginMain()
end

--- <summary>
--- 登陆完成时被调用，登陆完成是指已经获取到完整的主界面显示所需信息
--- </summary>
function cm_loginsys:OnLoginDone()
    wnd_main:Show()
    self.IsLoginOK = true

    --抛出登陆完成事件
    EventHandles.OnLoginSuccess:Call(nil)
end

function cm_loginsys:OnLogin()
	--显示锁屏
	
    local context = LoginFramework.GetLoginContext()
	self:Login(context);
end

 

function cm_loginsys:Login(context)
    StartCoroutine(self,self.coLogin,context)--启动一个协程来完成登陆操作
end

function cm_loginsys:LoginUserPass(user,pass,casual)
    local context = {}
    context.userid = user
    context.pass = pass
    context.casual = casual 
    self:Login(context)
end

return cm_loginsys.new
--]]