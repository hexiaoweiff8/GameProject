----region *.lua
----Date 20150805
----安装卸载登陆组件

--local cmServerListUpdateHandel = nil --服务器列表更新组件句柄
--local cmServerSTUpdateHandel = nil --服务器状态更新组件句柄

--LoginCMSetup = {}

----- <summary>
----- 装卸服务器状态更新组件
----- </summary>
--function LoginCMSetup.EnableServerSTUpdate(enable)
--	local luacore = GameObject.Find("/luacore")
--	if(enable) then
--		if(cmServerSTUpdateHandel==nil) then
--			cmServerSTUpdateHandel = luacore:AddComponent("login.cm_serverst_update")--挂载组件
--		end
--	else
--	    if(cmServerSTUpdateHandel~=nil) then
--	        luacore:RemoveComponent(cmServerSTUpdateHandel)--移除组件
--			cmServerSTUpdateHandel = nil
--		end
--	end
--end



----endregion
