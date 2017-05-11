--region *.lua
--Date 20160616
--怪物随机事件
--作者 gyt

SJMClass = classWC()

SJMs = {
	ID = "ID",--事件ID
	PID = "PID",--省ID
	HeroID = "HeroID",--可招募武将
    Ltime = "Ltime",--结束时间
} 

function SJMClass:ctor(ownerPlayer)
	self.OwnerPlayer = ownerPlayer
end

function SJMClass:GetAttr(attr)
	return self.OwnerPlayer:GetValue(attr)
end
function SJMClass:ForeachSJM(callBack) 
    if(self.SJM == nil) then 
		self.SJM = OOSyncList.new( self.OwnerPlayer.PlyObj,"SJM") 
	end

   self.SJM:Foreach(callBack) 
end

SJShopsClass = classWC()

SJShopss = {
	LT = "LT",--事件ID
    iList = "iList",--结束时间
} 

function SJShopsClass:ctor(ownerPlayer)
	self.OwnerPlayer = ownerPlayer
end

function SJShopsClass:GetAttr(attr)
	return self.OwnerPlayer:GetValue(attr)
end
function SJShopsClass:ForeachSJShops(callBack) 
    if(self.SJShops == nil) then 
		self.SJShops = OOSyncList.new( self.OwnerPlayer.PlyObj,"SJShops") 
	end

   self.SJShops:Foreach(callBack) 
end