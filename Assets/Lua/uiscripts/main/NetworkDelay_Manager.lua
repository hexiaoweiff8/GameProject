require 'os'
NetworkDelay_Manager = {}

local subject = NetworkDelay_Manager
--[[
		Observers {
			[1] = function(networkDelay),
			[2] = {...},
		}
	]]
local Observers = {}
--[[
		RequestList {
			[ID] = sendTime,
			[ID] = {...},
		}
	]]
local RequestList = {}

--@Des 向推送列表中添加观察者
--	   当单次请求收到回执时,将网络延迟值(ms)推送给所有注册方法
--@Params handler = function(networkDelay)
--		  回调方法参数接受一个number类型的网络延迟值(ms)
function NetworkDelay_Manager:addObserver(handler)
	assert(type(handler) == 'function',"handler is not a function()")

	table.insert(Observers,handler)
end

function NetworkDelay_Manager:removeObserver(handler)
	assert(type(handler) == 'function',"handler is not a function()")

	for i = 1,#Observers do
		if Observers[i] == handler then
			table.remove(Observers,i)
			return
		end
	end
end

function NetworkDelay_Manager:removeAllObserver()
	Observers = {}
end
--@Des 记录指定ID请求的发送时间戳
function NetworkDelay_Manager:RecordSendTime(ID)
	assert(RequestList[ID] == nil,"The same elements exist in RequestList.")

	RequestList[ID] = os.clock()
end
--@Des 根据指定ID请求的回执时间戳计算出单次请求的网络延迟
function NetworkDelay_Manager:RecordReceiveTime(ID)
	if RequestList[ID] == nil then
		return
	end
	-- assert(RequestList[ID] ~= nil,"The element not exist in RequestList.")

	subject:Notify_all_Observers(os.clock() - RequestList[ID])

	RequestList[ID] = nil
end
--@Des 将单次请求的网络间隔推送给所有观察者
function NetworkDelay_Manager:Notify_all_Observers(networkDelay)
	local networkDelay_ms = tonumber(string.format("%.0f",networkDelay * 1000))
	Debugger.LogWarning("请求延迟："..networkDelay_ms..' ms')
	for i = 1,#Observers do
		Observers[i](networkDelay_ms)
	end
end

return NetworkDelay_Manager