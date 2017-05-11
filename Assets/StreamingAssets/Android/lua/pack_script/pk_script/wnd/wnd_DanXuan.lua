--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local wnd_DanXuanClass = class(wnd_base)
    wnd_DanXuan = nil

local CurrFrame = {
    Others = 0,      --在其他界面弹出
    LostConnect = 1, --网络断开链接
} 


function wnd_DanXuanClass:Start()
	wnd_DanXuan = self
	self:Init(WND.DanXuan)
end

function wnd_DanXuanClass:OnNewInstance()
    self.BackBtn = self.instance:FindWidget("ui_tongyong_danxuan/back_btn")
    self.WidgetAlpha = self.BackBtn:GetComponent(CMUITweener.Name)
    self.BG = self.BackBtn:FindChild("BG")
    self.DanXuan = self.BG:GetComponents(CMUITweener.Name)

    local Tittle = self.BG:FindChild("title_bg/txt")    --提示框标题
    self.TittleLabel = Tittle:GetComponent(CMUILabel.Name) 
    self.BG:FindChild("queren_Button/txt"):GetComponent(CMUILabel.Name):SetValue(SData_Id2String.Get(5089)) --确认按钮

    local mainInfo = self.BG:FindChild("Text")   --主要显示的信息
    self.MainLabel = mainInfo:GetComponent(CMUILabel.Name)
    self:BindUIEvent("back_btn/BG/queren_Button",UIEventType.Click,"OnQueRen")

    self.Type = 1
    self.TittleInfo = SData_Id2String.Get(5090)
    self.MainShowInfo = SData_Id2String.Get(5091)
end

function wnd_DanXuanClass:OnQueRen()
    print("点击确认按钮，重新连接网络(重新连接网络待补齐)")

    self.DanXuan[2]:ResetToBeginning()
    self.DanXuan[2]:PlayForward()
    self:Hide()
end

function wnd_DanXuanClass:SetLabelInfo(TittleInfo, MainShowInfo)
    self.TittleInfo = TittleInfo --用于接收传进来的标题信息
    self.MainShowInfo = MainShowInfo --用于接收传进来的主要的提示信息
end

function wnd_DanXuanClass:SetCurrFrame(Type)
    if Type == 1 then
        self.Type = CurrFrame.LostConnect;
    end
end

function wnd_DanXuanClass:OnLostInstance()
    
end

function wnd_DanXuanClass:OnShowDone()
    self.BackBtn:SetActive(true)
    self.WidgetAlpha:ResetToBeginning() 
    self.WidgetAlpha:PlayForward()
    self.DanXuan[1]:ResetToBeginning()
    self.DanXuan[1]:PlayForward()

    self.TittleLabel:SetValue(self.TittleInfo)
    self.MainLabel:SetValue(self.MainShowInfo)
end




--[[
function wnd_DanXuanClass:ReConnect()
    ServerLink:ConnLast() --连接服务器
--    while(ServerLink.step == ServerLinkStep.Conning) do Yield() end--等待连接完成

    if(ServerLink.step ~= ServerLinkStep.Logining) then 
        print("__________重新链接服务器失败")
        self:Show() --链接失败继续弹出提示框
    end --连接失败了，继续询问是否重连

    --发送重连请求
    local qkjsonDoc = JsonParse.SendNM("clk")
	qkjsonDoc:Add("p", LoginSystem.lastPlatform)--平台
    qkjsonDoc:Add("z",LoginSystem.lastZone)--分区
    qkjsonDoc:Add("account",LoginSystem.lastUser)--账户
    qkjsonDoc:Add("vpn",PlayerData.vpn)
    qkjsonDoc:Add("mode",LoginSystem.lastLoginMode)
         
    local loader = Loader.new(qkjsonDoc:ToString(),3,"reclk") 
	local reclk = LoaderEX.SendJsonAndWait(loader)
	    
	if(reclk==nil)  then  return true end--网络中断或超时
	 
	local isok = tonumber(reclk:GetValue("isok"))
    if(isok~=1) then return true end--重连失败

    PlayerData.vpn = reclk:GetValue("vpn")
    return false--重连成功

end
]]

return wnd_DanXuanClass.new

--endregion
