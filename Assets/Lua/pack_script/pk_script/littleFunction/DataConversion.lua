--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

--获取IDString (ID)
function _TXT(i)
    --return "ID:"..i
    return SData_Id2String.Get(i)
end
 
--获取时间格式 (倒计时)
function _GetTimeFormat(intValue)
    local Second = intValue % 60
    local strSecond = ""
    if Second < 10 then 
       strSecond = string.sformat(":0{0}",Second)
    else
       strSecond = string.sformat(":{0}",Second)
    end
       
    local Minute = intValue / 60 % 60
    local strMinute = ""
    if Minute < 10 then 
       strMinute = string.sformat(":0{0}",Minute)
    else
       strMinute = string.sformat(":{0}",Minute)
    end

    local Hour = intValue / 3600 % 24
    local strHour = ""
    if Hour < 10 then 
       strHour = string.sformat("0{0}",Hour)
    else
       strHour = string.sformat("{0}",Hour)
    end
    local day = intValue / (3600 * 24)

    return string.sformat("{0}{1}{2}",strHour,strMinute,strSecond)
end 

--数归万
function ToWan(nCounts)
    if  nCounts >= 100000 then
        local nTmpCoins = math.floor(nCounts/100)/100
        local strCoins = nTmpCoins.."万"
        return strCoins
    else
        return nCounts
    end	
end

--endregion
