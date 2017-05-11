--场景跳转器
local sceneJumpClass = classWC()

function sceneJumpClass:ctor()	
	   
end
 
function sceneJumpClass:Jump(sceneName,dependPacks,recallSelf,complateFunc,progressFunc) 
	local OnPacketDone = function(isDone) 
		SceneManage.LoadSingle(sceneName,recallSelf,complateFunc,progressFunc)  
	end 
	local packetLoader = PacketLoader.new()--创建一个包加载器
	packetLoader:Start(dependPacks,self,OnPacketDone)--加载资源包 
end


function sceneJumpClass:LoadAdditive(sceneName,dependPacks,recallSelf,complateFunc,progressFunc)

	local OnPacketDone = function(isDone)
		SceneManage.LoadAdditive(sceneName,recallSelf,complateFunc,progressFunc)  
	end
	local packetLoader = PacketLoader.new()--创建一个包加载器
	packetLoader:Start(dependPacks,self,OnPacketDone)--加载资源包
end



SceneJump = sceneJumpClass.new()