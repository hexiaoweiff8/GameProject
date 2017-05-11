--region *.lua
--Date 20151009
--关卡静态数据

local data = require "HardMission"
local class_sdata_HardMission = classWC(luacsv) 


--- <summary>
--- 构造函数
--- </summary>
function class_sdata_HardMission:Init()	
	local IJuanID =  self:Name2I("_JuanID") 
	self.JuanInfo = {} 

	--取出最大的卷
	local maxVolume = 0
	local findMaxVolume = function(id,attr) 
		local currJuan = attr[IJuanID]
		if(currJuan>maxVolume) then maxVolume = currJuan end

		if( self.JuanInfo[currJuan]==nil) then self.JuanInfo[currJuan] = {} end

		table.insert(self.JuanInfo[currJuan],attr)
	end
	self:Foreach(findMaxVolume)

	--保存最大卷信息
	self.maxVolume = maxVolume  
end
 
function class_sdata_HardMission:GetMissionsByJuanID(juanID)
	return self.JuanInfo[juanID]
end

function class_sdata_HardMission:GetNextGK(c)
	for currC = c+1,self.maxVolume do
		local nextid = currC*10+6
		local nextData = self:GetRow(nextid)
		if(nextData~=nil) then return currC,6 end
	end

	return 0,0
end

function class_sdata_HardMission:IsWin(c,m)
	if(PlayerData.data.JYCID<1 or PlayerData.data.JYMID<1) then 
		return false
	end

	if(c>PlayerData.data.JYCID) then  return true end
	if(c<PlayerData.data.JYCID) then   return false end 
	return (m>=PlayerData.data.JYMID)
end

sdata_HardMission =  class_sdata_HardMission.new(data)
sdata_HardMission:Init()
--endregion
