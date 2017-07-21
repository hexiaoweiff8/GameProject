TimeUtil = {}

function TimeUtil:CreateLoopTimer(sec,OnTickFunc,OnKillFunc)
	local timer = Util.Timer.New(sec, true)
	return timer:OnCompleteCallback(OnTickFunc):OnKill(OnKillFunc):Start()
end
function TimeUtil:CreateTimer(sec,OnCompleteFunc)
	local timer = Util.Timer.New(sec, false)
	return timer:OnCompleteCallback(OnCompleteFunc):Start()
end
--@Dec 获取剩余时间字符串
--@Params remainTime:总秒数(s)
--@Return string (hh:mm:ss)
function TimeUtil:getRemainTime(remainTime)
	if remainTime < 0 then
        remainTime = 0
    end
    if remainTime < 86400 then --显示时分秒
        local _remainHour = math.floor(remainTime / (3600));
        remainTime = remainTime - _remainHour * 3600
        local _remianMin = math.floor(remainTime / 60);
        remainTime = remainTime - _remianMin * 60
        local _remainSec = math.floor(remainTime);
        
        return string.format("%02d", _remainHour) .. ':' .. string.format("%02d", _remianMin) .. ':' .. string.format("%02d", _remainSec)
    else --显示天时分
        local _remainDay = math.floor(remainTime / 86400);
        remainTime = remainTime - _remainDay * 86400
        local _remainHour = math.floor(remainTime / 3600);
        remainTime = remainTime - _remainHour * 3600
        local _remianMin = math.floor(remainTime / 60);
        
        return tostring(_remainDay) .. "d " .. string.format("%02d", _remainHour) .. ":" .. string.format("%02d", _remianMin)
    end
end
--@Dec 从 秒 转到 天时分秒
--@Params sec:总秒数
--@Return table { day,hour,min,sec }
function TimeUtil:Second2DaysAndMinutes(sec)

end
--@Dec 获取商店下次刷新时间字符串
--@Return string (hh:mm:ss)
function TimeUtil:getNextShopRefreshTimeStr()
	local refreshTable = require('uiscripts/shop/wnd_shop_controller').model.local_ShopRefreshTime
	-- *t  { year=xxxx, month=x, day=x, hour=x, min=x, sec=x }
	local currentTime = os.date("*t", os.time())
	local refreshTimes = {}
	for i = 1,#refreshTable do
		local Time = {}
		Time.day = currentTime.day
		Time.hour = refreshTable[i]["Time"]
		Time.min = 0
		Time.sec = 0
		table.insert(refreshTimes,Time)
	end
	do
		local Time = {}
		Time.day = currentTime.day + 1
		Time.hour = refreshTable[1]["Time"]
		Time.min = 0
		Time.sec = 0
		table.insert(refreshTimes,Time)
	end
	local targetTime = nil
	for i = 1,#refreshTimes do
		if refreshTimes[i].day > currentTime.day then
			targetTime = refreshTimes[i]
			break
		else
			-- print("比较第"..i.."个元素，"..refreshTimes[i].hour.." > "..currentTime.hour .." ?")
			if refreshTimes[i].hour > currentTime.hour then
				targetTime = refreshTimes[i]
				break
			end
		end
	end
	if targetTime then
		return string.format("%02d", targetTime.hour)..':'..string.format("%02d", targetTime.min)..':'..string.format("%02d", targetTime.sec)
	else
		error("代码有bug")
	end
end
--@Dec 获取剩余时间(s)(时分秒相对于同一天)
--@Params targetTime:目标时间str(hh:mm:ss)
--@Return number (second)
function TimeUtil:getRemainTimeSec(targetTime,_offset_day)
	local _i_hour = string.find(targetTime,':')
	local _i_min = string.find(targetTime,':',_i_hour+1)
	local _i_sec = string.find(targetTime,':',_i_min+1)

	-- print(string.sub(targetTime,1,_i_hour-1))
	-- print(string.sub(targetTime,_i_hour+1,_i_min-1))
	-- print(string.sub(targetTime,_i_min+1,_i_sec))

	local _hour = tonumber(string.sub(targetTime,1,_i_hour-1))
	local _min = tonumber(string.sub(targetTime,_i_hour+1,_i_min-1))
	local _sec = tonumber(string.sub(targetTime,_i_min+1,_i_sec))

	local currentTime = os.date("*t", os.time())
	local targetTime = { year = currentTime.year, month = currentTime.month, day = currentTime.day + _offset_day, 
						hour = _hour, min = _min, sec = _sec }

	return os.difftime(os.time(targetTime), os.time(currentTime))
end
--@Dec 获取剩余时间字符串
--@Params targetTime:目标时间str(hh:mm:ss)
--@Return string (hh:mm:ss)
function TimeUtil:getRemainTimeStr(targetTime)
	local _hour = tonumber(string.sub(targetTime,1,string.find(targetTime,':')-1))
	local _offset_day = 0
	if _hour < os.date("*t", os.time()).hour then
		_offset_day = 1
	end
	return TimeUtil:getRemainTime(TimeUtil:getRemainTimeSec(targetTime,_offset_day))
end

return TimeUtil