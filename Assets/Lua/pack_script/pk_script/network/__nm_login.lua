----region *.lua
----Date 20150828
----登录相关网络处理函数
----Author Wenchuan


--local function NM_rehello(qkJsonDoc)
--	local c = qkJsonDoc:GetValue("c")--加密公钥

--	PlayerData.svrVersion = qkJsonDoc:GetValue("v") + 0--服务器版本号
--    PlayerData.ckey = Encoding.BuildCKey(c)

--end

--local function NM_PlayerInfo(qkJsonDoc) 

--	print("NM_PlayerInfo#1")

--    PlayerData.data.dbg = (tonumber(qkJsonDoc:GetValue("dbg"))==1)--是否调试模式 
--	PlayerData.data.sid = tonumber(qkJsonDoc:GetValue("sid"))--角色所在服务器id
--	PlayerData.data.oid = tonumber(qkJsonDoc:GetValue("oid"))--角色对象id

--    --记录登陆成功的 角色名  登陆账户 登陆密码
--    if(not PlayerData.isCasual) then --只有非游客才记录
--        GameCookies.SaveLoginInfo(LoginSystem.lastUser,LoginSystem.lastPass,plyName)
--    end

--    --通知登陆系统，登陆已完成
--    LoginSystem:OnLoginDone()
--end

--local function NM_LoadArchivesOK(qkJsonDoc)

--    --账户验证已经通过，在cookie中记录当前选择的服务器
--    GameCookies.SetZone(LoginSystem.lastZone)
--    GameCookies.Save()

--     --卸下服务器列表更新组件
--    LoginCMSetup.EnableServerListUpdate(false)   

--    --卸下服务器状态更新组件
--    LoginCMSetup.EnableServerSTUpdate(false)

--    local hasPlayer = tonumber( qkJsonDoc:GetValue("hasplayer") )

--    if(hasPlayer==1) then--当前存在角色 
--    else--当前不存在角色 
--        wnd_PlayerCreate:Show()
--    end
--end


--local nmFuncs = {
--  ["rehello"] = NM_rehello,
--  ["LoadArchivesOK"] = NM_LoadArchivesOK,
--  ["PlayerInfo"] = NM_PlayerInfo,
--}



----注册网络处理函数
--NMDispatcher.RegNMFuncs(nmFuncs)
----endregion
