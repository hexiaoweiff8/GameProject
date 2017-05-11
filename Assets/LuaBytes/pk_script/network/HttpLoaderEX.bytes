--region *.lua
--Date 20160503
--加强内核的HttpLoader
--作者 wenchuan
HttpLoaderEX = {}

--- <summary>
--- 功能 : 用loader方式发送一个协议，并等待完成，必须在协程环境运行
--- loader : Loader
--- _self(可选) : 用于接收回掉的类
--- successFunc(可选) : 发送成功时回调的类
--- failedFunc(可选) : 发送失败时回掉的类
--- ret : QKJsonDoc (成功时返回jsonDoc类型的服务器返回值，失败返回nil)
--- </summary>
--- <returns type="QKJsonDoc"></returns>
function HttpLoaderEX.Wait(loader,_self,successFunc,failedFunc) 
    print("HttpLoaderEX.Wait #1",os.clock()-ConnectTime) 
--    local PlayingNetWaitting = false --是否在播放联网动画
    wnd_NetConnectWait:Show() --显示通讯动画显示

    while(loader:GetResult()==nil and not loader:HasError()) do  
        Yield() 
--        if os.clock()-ConnectTime > 0.4 then 
--            wnd_NetConnectWait:Show() --显示通讯动画显示
--            PlayingNetWaitting = true
--        end
    end 
    print("HttpLoaderEX.Wait #2",os.clock()-ConnectTime) 
    wnd_NetConnectWait:Hide() --影藏通讯动画显示
	--Loader
	local _result = loader:GetResult()
	--ByteArray 
    local reDoc = _result

--    if PlayingNetWaitting then
--        wnd_NetConnectWait:Hide() --影藏通讯动画显示
--    end

	print("HttpLoaderEX.Wait #3  ",PlayingNetWaitting,os.clock()-ConnectTime) 
    if(_self~=nil) then--回调 
        local recallFunc = ifv(reDoc~=nil,successFunc,failedFunc)
        if(recallFunc~=nil) then
            recallFunc(_self,reDoc)
        end
    end
    print("HttpLoaderEX.Wait #4",os.clock()-ConnectTime) 

    return reDoc
end


function HttpLoaderEX:coWaitRecall(context)
	 HttpLoaderEX.Wait(context.loader,context._self,context.successFunc,context.failedFunc)
end



--- <summary>
--- 功能 : 用loader方式发送一个协议，并回掉接口，可在非协程环境运行
--- loader : Loader
--- _self(可选) : 用于接收回掉的类
--- successFunc(可选) : 发送成功时回调的类
--- failedFunc(可选) : 发送失败时回掉的类
--- ret : QKJsonDoc (成功时返回jsonDoc类型的服务器返回值，失败返回nil)
--- </summary>
--- <returns type="QKJsonDoc"></returns>
function HttpLoaderEX.WaitRecall(loader,_self,successFunc,failedFunc) 
    local context = {}
    context._self = _self
    context.successFunc = successFunc
    context.failedFunc = failedFunc
    context.loader = loader
    StartCoroutine(HttpLoaderEX,HttpLoaderEX.coWaitRecall,context)
end
 
--endregion
