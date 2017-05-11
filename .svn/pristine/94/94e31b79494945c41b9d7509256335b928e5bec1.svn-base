----region *.lua
----Date 20150806
----加强内核的loader
----作者 wenchuan
--LoaderEX = {}

----- <summary>
----- 功能 : 用loader方式发送一个协议，并等待完成，必须在协程环境运行
----- loader : Loader
----- _self(可选) : 用于接收回掉的类
----- successFunc(可选) : 发送成功时回调的类
----- failedFunc(可选) : 发送失败时回掉的类
----- ret : QKJsonDoc (成功时返回jsonDoc类型的服务器返回值，失败返回nil)
----- </summary>
----- <returns type="QKJsonDoc"></returns>
--function LoaderEX.SendJsonAndWait(loader,_self,successFunc,failedFunc) 

--    loader:Send() 
--    while(loader:GetResult()==nil and not loader:HasError()) do  
--        Yield() 
--    end 

--	--Loader
--	local _result = loader:GetResult()
--	--ByteArray 

--    local reDoc = nil
--    if(_result~=nil) then 
--        local nmfmt,nm = NMDispatcher.ParseNM(_result) 
--		reDoc = nm 
--    end    

--    if(_self~=nil) then--回调 
--        local recallFunc = ifv(reDoc~=nil,successFunc,failedFunc)
--        if(recallFunc~=nil) then
--            recallFunc(_self,reDoc)
--        end
--    end

--    return reDoc
--end



--function LoaderEX:coSendJsonAndRecall(context)
--	 LoaderEX.SendJsonAndWait(context.loader,context._self,context.successFunc,context.failedFunc)
--end



----- <summary>
----- 功能 : 用loader方式发送一个协议，并回掉接口，可在非协程环境运行
----- loader : Loader
----- _self(可选) : 用于接收回掉的类
----- successFunc(可选) : 发送成功时回调的类
----- failedFunc(可选) : 发送失败时回掉的类
----- ret : QKJsonDoc (成功时返回jsonDoc类型的服务器返回值，失败返回nil)
----- </summary>
----- <returns type="QKJsonDoc"></returns>
--function LoaderEX.SendAndRecall(loader,_self,successFunc,failedFunc) 
--    local context = {}
--    context._self = _self
--    context.successFunc = successFunc
--    context.failedFunc = failedFunc
--    context.loader = loader
--    StartCoroutine(LoaderEX,LoaderEX.coSendAndRecall,context)
--end

----endregion
