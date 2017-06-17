--[[
Auth:Chiuan
like Unity Brocast Event System in lua.
]]

local EventLib = require "eventlib"

Event = {}
local events = {}

function Event.AddListener(event,handler)
	if not event or type(event) ~= "string" then
		error("event parameter in addlistener function has to be string, " .. type(event) .. " not right.")
	end
	if not handler or type(handler) ~= "function" then
		error("handler parameter in addlistener function has to be function, " .. type(handler) .. " not right")
	end

	if not events[event] then
		--create the Event with name
		events[event] = EventLib:new(event)
	end

	--conn this handler
	events[event]:connect(handler)
end

function Event.Brocast(event,...)
	if not events[event] then
		if ... == 3 then error("errno: " .. ... .. " 服务器异常")
		elseif ... == 4 then error("errno: " .. ... .. " 数据库操作错误")
		elseif ... == 10000 then error("errno: " .. ... .. " 参数不全")
		elseif ... == 10001 then error("errno: " .. ... .. " 用户未登录")
		elseif ... == 10002 then error("errno: " .. ... .. " 角色已存在")
		elseif ... == 10003 then error("errno: " .. ... .. " 角色不存在")
		elseif ... == 10004 then error("errno: " .. ... .. " 无可用的游戏服务器")
		elseif ... == 10005 then error("errno: " .. ... .. " 该装备不存在")
		elseif ... == 10006 then error("errno: " .. ... .. " 金币不足")
		elseif ... == 10007 then error("errno: " .. ... .. " 该装备的副属性不存在")
		elseif ... == 10008 then error("errno: " .. ... .. " 该重铸属性不存在")
		elseif ... == 10009 then error("errno: " .. ... .. " 该卡牌不存在")
		elseif ... == 10010 then error("errno: " .. ... .. " 卡牌星级已达最大")
		elseif ... == 10011 then error("errno: " .. ... .. " 卡牌数量不足")
		elseif ... == 10012 then error("errno: " .. ... .. " 兵牌不足")
		elseif ... == 10013 then error("errno: " .. ... .. " 卡牌携带数量已达最大")
		elseif ... == 10014 then error("errno: " .. ... .. " 卡牌军阶已达最大")
		elseif ... == 10015 then error("errno: " .. ... .. " 该卡牌军阶卡槽不存在")
		elseif ... == 10016 then error("errno: " .. ... .. " 所有的军阶卡槽必须激活")
		elseif ... == 10017 then error("errno: " .. ... .. " 道具材料不足")
		elseif ... == 10018 then error("errno: " .. ... .. " 技能点不足")
		elseif ... == 10019 then error("errno: " .. ... .. " 该卡牌不存在")
		elseif ... == 10020 then error("errno: " .. ... .. " 卡牌星级已达最大")
		elseif ... == 10021 then error("errno: " .. ... .. " 卡牌数量不足")
		elseif ... == 10022 then error("errno: " .. ... .. " 兵牌不足")
		elseif ... == 10023 then error("errno: " .. ... .. " 卡牌携带数量已达最大")
		elseif ... == 10024 then error("errno: " .. ... .. " 卡牌军阶已达最大")
		elseif ... == 10025 then error("errno: " .. ... .. " 该卡牌军阶卡槽不存在")
		elseif ... == 10026 then error("errno: " .. ... .. " 所有的军阶卡槽必须激活")
		elseif ... == 10027 then error("errno: " .. ... .. " 道具材料不足")
		elseif ... == 10028 then error("errno: " .. ... .. " 该协同未达到升级条件")
		else error("errno: " .. ... .. " have no event")
		end
	else
		events[event]:fire(...)
	end
end

function Event.RemoveListener(event,handler)
	if not events[event] then
		error("remove " .. event .. " has no event.")
	else
		events[event]:disconnect(handler)
	end
end

return Event