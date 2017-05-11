----wnd_chat.lua
----Date 2015.9
----聊天相关网络处理函数
----GYT

--	local sjSpeak = {}
--	local gzSpeak = {}
--	local slSpeak = {}
--local function NM_SomeOneSpeak(qkJsonDoc)
----n:SMsg,
----msg:[
---- :{
----  t:<频道 int>,#1-世界 2-国战 3-系统 4-私聊
----  name:<发言人名称 string>,
----  sex:<发言人性别 int>,#1男 2女
----  lv:<发言人等级 int>,
----  f:<发言人所属势力 int>,#1蜀 2魏 3吴 <=0表示未加入势力
----  nr:<发言内容 string>,
----  h:<发言时间 时 int>,
----  m:<发言时间 分 int>,
----  s:<发言时间 秒 int>,
----  on:<目标昵称 string>#私聊有效
---- }
---- ...
----]
--	local plyName = qkJsonDoc:GetValue("msg")
--    local MailInfos = {}

--	local i = 1
--    --遍历取得每个邮件的信息
--    local chatFunc = function(_,mailInfos)

--        local personInof = {}
--		personInof.ID = i
--		personInof.t = tonumber( mailInfos:GetValue("t") )
--        personInof.name = tostring( mailInfos:GetValue("name") )
--        personInof.sex = tonumber( mailInfos:GetValue("sex") )
--        personInof.lv = tonumber( mailInfos:GetValue("lv") )
--        personInof.f = tonumber( mailInfos:GetValue("f") )
--        personInof.nr = tostring( mailInfos:GetValue("nr") )
--        personInof.h = tonumber( mailInfos:GetValue("h") )
--		personInof.m = tonumber( mailInfos:GetValue("m") )
--		personInof.s = tonumber( mailInfos:GetValue("s") )
--		--print("fffffffffffffffffffffffffffffffffffffffffffff",personInof.on)
--		if personInof.t == 1 then
--			table.insert(sjSpeak,1, personInof)
--		elseif personInof.t == 2 then
--			table.insert(gzSpeak,1,personInof)
--		elseif	personInof.t == 3 then 
--			print ("系统发布聊天内容")	
--		else
--			personInof.on = tostring( mailInfos:GetValue("on") )
--			table.insert(slSpeak,1,personInof)
--		end
--        MailInfos[i] = personInof    
--		i = i+1 
--    end
--    plyName:Foreach(chatFunc)
--	wnd_chat:NM_SomeOneSpeak(sjSpeak,gzSpeak,slSpeak)
--end

--local function NM_LoadArchivesOK(qkJsonDoc)
--	local Join =  tostring(qkJsonDoc:GetValue("JOIF"))
--end



--local nmFuncs = {
--  ["SMsg"] = NM_SomeOneSpeak,
--  ["JOLF"] = NM_LoadArchivesOK,
--}


----注册网络处理函数
--NMDispatcher.RegNMFuncs(nmFuncs)
----endregion
