----Date 20150828
----网络封包分发
----Author Wenchuan

--NMDispatcher = {}

--NMDispatcher.action = {}

----封包格式枚举
--NMFormat = {
--	["Json"] = 1,
--	["Bin"] = 2,
--	["Other"] = 3,
--} 

----- <summary>
----- 解释网络封包，区分出 二进制 json包，如果是压缩包则自动解压缩
----- </summary>
--function NMDispatcher.ParseNM(bytes) 

--	local isok,bytev = bytes:ReadByte()
--	if(isok and bytev==35) then --这是一个压缩格式的包 
--		bytes = ProtoZip.DecompressProto(bytes) --解压
--	else
--		bytes:SeekReadPoint(SeekMode.Head,0)--读指针移动到头部
--	end 
--	local isok,bytev = bytes:ReadByte() 
--	bytes:SeekReadPoint(SeekMode.Head,0)--读指针移动到头部 
--	if(isok and bytev==42) then --这是一个二进制包
--		return NMFormat.Bin,bytes
--	else --这是一个json包 
--		if OOSyncClient.DoDispatcher(bytes) then --自动同步对象的指令
--			return NMFormat.Other,nil
--		end
--		local jsonDoc = QKJsonDoc.NewMap()
--		jsonDoc:Parse(bytes) 

--		if debug.IsDev() then debug.LogDebug("{0}",jsonDoc:ToString()) end
--		return NMFormat.Json,jsonDoc
--	end

--end

--function NMDispatcher.DoJson(qkJsonDoc)
--	local n = qkJsonDoc:GetValue("n")
--	local func = NMDispatcher.action[n]

--	if(func==nil) then  return  end --未定义处理接口 
--	func(qkJsonDoc)
--end

--function NMDispatcher.DoBin(binNM)

--end

----- <summary>
----- 注册网络处理函数
----- </summary>
--function NMDispatcher.RegNMFuncs(funcs) 
--    for nmhead,func in pairs(funcs) do NMDispatcher.action[nmhead] = func end   
--end