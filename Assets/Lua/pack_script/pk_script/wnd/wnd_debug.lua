--region *.lua
--Date 20150827
--debug窗体功能实现
--Author Wenchuan

local wnd_debugClass = class(wnd_base)

wnd_debug = nil--单例

function wnd_debugClass:Start() 
	wnd_debug = self
	self:Init(WND.Debug,true)
end


--有对象互访逻辑的初始化
function wnd_debugClass:CrossInit() 
    --绑定登陆成功事件
    EventHandles.OnLoginSuccess:AddListener(self,self.OnLoginSuccess)  
end
 
--登陆成功回调处理
function wnd_debugClass:OnLoginSuccess(_)
     --显隐调试界面
    if(PlayerData.data.dbg) then 
        self:Show(1.0)
    else
        self:Hide(0)
    end
	--self:Hide(0)
end

--初始化实例
function wnd_debugClass:OnNewInstance()
	--绑定事件
    self:BindUIEvent("btn",UIEventType.Click,"OnDoCmdClick")

	local cmdeditObj = self.instance:FindWidget("cmdedit")--取出编辑框游戏对象
    local cmInput = cmdeditObj:GetComponent(CMUIInput.Name)--取出编辑组件
	cmInput:SetValue("win")
end

function  wnd_debugClass:GetText()
    local cmdeditObj = self.instance:FindWidget("cmdedit")--取出编辑框游戏对象
    local cmInput = cmdeditObj:GetComponent(CMUIInput.Name)--取出编辑组件
    local v = cmInput:GetValue()
    print(v)
    return v
end
--执行命令按钮被点击
function wnd_debugClass:OnDoCmdClick(gameObj)
    local cmdeditObj = self.instance:FindWidget("cmdedit")--取出编辑框游戏对象
    local cmInput = cmdeditObj:GetComponent(CMUIInput.Name)--取出编辑组件
    local v = cmInput:GetValue()
	print("OnDoCmdClick#1")
	if(v=="") then return end

	if debug.IsDev() and self:TempCmds(v) then return end
	print("OnDoCmdClick#2")
    if(v=="hide") then--隐藏调试窗口
        self:Hide(1.0)
    elseif(v=="win") then--战斗胜利
        Battlefield.SetFightResult(true)
    elseif(v=="fail") then--战斗失败
        Battlefield.SetFightResult(false)
    elseif(v=="offl") then--模拟掉线
        ServerLink:Close()
    elseif(v=="soffl") then--模拟软掉线
        ServerLink:SoftClose()
	elseif(v=="grid") then--显示或隐藏战斗地图格子
		Battlefield.ShowGrid()
    elseif(v=="lesson1") then--开启新手指导
		QY2LessonManager.CloseLesson(false)
    elseif(v=="lesson0") then--关闭新手指导
		QY2LessonManager.CloseLesson(true)
    elseif(string.find(v, "lesson:", 1) ~= nil) then--关闭新手指导
		local str = string.sub(v,8,string.len(v))
        QY2LessonManager.LessonStart(tonumber(str));
       
	else --服务器端作弊命令
--		local nm = QKJsonDoc.NewArray()
--		nm:Add("n","DbgCmd")
--		nm:Add("cmd",v)
--		GameConn:Send(nm:ToBytes(),0)
    end
end

local TestInt = 0
local TestNM = QKJsonDoc.NewMap()	
local ItemsString 
local Items = {}
--这里添加开发期间用的临时命令
function wnd_debugClass:TempCmds(cmd)
	print("OnDoCmdClick#3")
    local teststring = string.split(cmd,':')
    if cmd~="send" and #teststring == 2 then 
        TestNM:Add(teststring[1],teststring[2])  
        print("添加Key："..teststring[1],"添加Value："..teststring[2])  
    end
    Items = {}
    Items = string.split(cmd,';')
    --print("wnd_debugClass:TempCmds Items:",#Items)
    if cmd=="fight099888" then --测试战斗
        require "TestFight"--用于测试的临时用法，正式代码不能这么干
		StartFight()
		return true  
    elseif cmd == "fightwin" then 
        wnd_fightwin:Show()
        return true
    elseif cmd == "pkc" then
        wnd_CardHouse:OnClickHeroNationality(nil,TestInt)
        TestInt = TestInt +1
        if TestInt >3 then TestInt = 0 end 
    elseif cmd == "apt" then
        exui_AlphaTip:Show()
    elseif cmd == "jq" then
		wnd_GuankaJuqing:Show()
        --WndJumpManage:Jump(WND.Main,WND.CardHouse)
        --wnd_CardHouse:Show()
        --exui_CardCollection:Show()
    elseif cmd == "ChouJiang" then
        wnd_ChouJiang:Debug()
    elseif cmd == "cj" then
		wnd_randomEvents:JLData(3,1,1)
		wnd_randomEvents:Show()
--        wnd_ChouJiang:Test()
    elseif cmd == "ml" then
        wnd_Mail:Show() 
    elseif cmd == "changhao" then
        wnd_readyfight:TestChangHao()
	elseif cmd == "changhao2" then
        wnd_buzheng:TestChangHao1()
	elseif cmd == "changhao3" then
        wnd_buzheng:TestChangHao2()
    elseif cmd == "ph" then
		local jsonNM = QKJsonDoc.NewMap()	
		jsonNM:Add("n","RankList")  
		local loader = GameConn:CreateLoader(jsonNM,2) 
		HttpLoaderEX.WaitRecall(loader,self,self.NM_ReGetPaiHangBangList)
	elseif cmd == "sd" then
		BackgroundMusicManage.SetVolume(0)
		QKGameSetting.SetVolume(0)
	elseif cmd == "ds" then
		BackgroundMusicManage.SetVolume(1)
		QKGameSetting.SetVolume(1)
	elseif cmd == "by" then
		wnd_recruitHero:Show()
		wnd_recruitHero:PlayerHeroData(1014) 
	elseif cmd == "zcj"  then 
		OOSyncClient.BindValueChangedEvent(Player.sid,Player:GetPath(),PlayerAttrNames.Gold,self,self.callbackFunc) 
    elseif cmd == "tuiguan" then 
        wnd_tuiguan:Debug()

    elseif cmd=="send" then --测试服务器
	    local loader = GameConn:CreateLoader(TestNM,0) 
        print(TestNM:ToString())
	    HttpLoaderEX.WaitRecall(loader,self,self.NM_TestFunction)
        TestNM = {}
        TestNM = QKJsonDoc.NewMap()	
--		heroList
    elseif #Items == 3 or #Items == 2 or cmd == "lv1" or cmd == "lv5" then 
        if Items[1] == "Move" then
            local MoveValue = tonumber( Items[2] )
            wnd_tuiguan.m_ZoomScale:Move(MoveValue)
            return false
        end
        if Items[1] == "Volum" then
            local Value = tonumber( Items[2] )
            BackgroundMusicManage.SetVolume(Value)
            return false
        end
        if Items[1] == "Nbjjc" then
            wnd_tuiguan:TestJJC(cmd)
            return
        end
        Poptip.PopMsg(cmd,Color.red)
        local ItemNM3 = QKJsonDoc.NewMap()	
        ItemsString = cmd
        ItemNM3:Add("n","dbgcmd")
        ItemNM3:Add("debug",cmd)
        local loader = GameConn:CreateLoader(ItemNM3,0) 
	    HttpLoaderEX.WaitRecall(loader,self,self.NM_ItemsFunction)
	end	
     
	return false
end
function wnd_debugClass:callbackFunc()
	print(Player:GetNumberAttr(PlayerAttrNames.Gold))
	print("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&")
end

function wnd_debugClass:NM_ItemsFunction(jsonDoc)
	local Result = tonumber(jsonDoc:GetValue("r"))
        local temp = {}
        temp.BookName = Items[1]
        temp.SubType = Items[2]
        temp.Num = Items[3]
        local Name = CodingEasyer:GetJLName(temp)
    print("Result:"..Result)
    if Result == 0 then 
        Poptip.PopMsg(ItemsString.."成功",Color.white)
    else 
        Poptip.PopMsg(ItemsString.."失败",Color.white)
    end
end 

function wnd_debugClass:DoEndChouJiang(jsonDoc)
	local num = tonumber(jsonDoc:GetValue("r"))
end 
function wnd_debugClass:NM_ReGetPaiHangBangList(jsonDoc)
	wnd_paihangbang:FillData(jsonDoc)
	wnd_paihangbang:Show()
end 
--实例即将被丢失
function wnd_debugClass:OnLostInstance()
end 

function wnd_debugClass:NM_TestFunction(jsonDoc)
    print(jsonDoc:ToString())
end     

return wnd_debugClass.new
 

--endregion
