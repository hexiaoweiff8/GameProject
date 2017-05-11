--region *.lua
--Date 游戏服务器链接类
--此文件由[BabeLua]插件自动生成

--

local GameConn_Class = classWC() 

ConnectTime = 0
hadJumpedToTuiguan = false --是否进入推关界面

function GameConn_Class:ctor() 
	
end

function GameConn_Class:Init()
    self.PlayingWaitting = false
    self.ShowLockCount = 0;
	GamePlatformLogic.EvtLoginExpired():AddCallback(self,self.OnLoginExpired);
    GamePlatformLogic.EvtRequestSending():AddCallback(self,self.OnRequestSending);
    GamePlatformLogic.EvtRequestFinished():AddCallback(self,self.OnRequestFinished);
    GamePlatformLogic.EvtConnectBroken():AddCallback(self,self.OnConnectBroken);

end

function GameConn_Class:OnLoginExpired(_) 
	Poptip.PopMsg("登录过期，需要重新登录",Color.red)
end

function GameConn_Class:OnRequestSending(_) 
--    print("-------------------------------- 请求开始 ")
    ConnectTime = os.clock()
    if not hadJumpedToTuiguan then
        --wnd_NetConnectWait:Show()
        self.PlayingWaitting = true
    end
--   self:ShowLockScreen(true)
end

function GameConn_Class:OnRequestFinished(_) 
--    print("-------------------------------- 请求结束",os.clock() - ConnectTime)
    if self.PlayingWaitting then
        --wnd_NetConnectWait:Hide()
        self.PlayingWaitting = false
    end
--    self:ShowLockScreen(false)
end

function GameConn_Class:OnConnectBroken(_) 
	Poptip.PopMsg("与服务器通讯失败，请尽快重新登录",Color.red)
    --wnd_NetConnectWait:Hide()
end


function GameConn_Class:CreateLoader(jsonDoc,flag)
    print("CreateLoader....")
	return YQ2GameConn:CreateLoader(jsonDoc,flag)
end

--function GameConn_Class:ShowLockScreen(v)

--    if  v then
--        self.ShowLockCount = self.ShowLockCount + 1
----        wnd_NetConnectWait:Show()
--    else
--        self.ShowLockCount = self.ShowLockCount - 1
--        if self.ShowLockCount <= 0 then
--            self.ShowLockCount = 0
--        end
--    end
--end

GameConn = GameConn_Class.new() --单例

--endregion
