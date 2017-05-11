--CommItems.lua
--Date
--通用道具


CommItemsClass = classWC()
--    TongYongSuiPianA = 21,//通用士兵碎片
--    SDJuan = 22,	//扫荡卷
--角色属性名枚举
CommItemsAttrNames = {
		DataID = "DataID",--道具静态ID
		NUM = "NUM",--持有数量
}


function CommItemsClass:ctor(ownerPlayer)
	self.OwnerPlayer = ownerPlayer
end

function CommItemsClass:GetAttr(attr)
	return self.OwnerPlayer:GetValue(attr)
end

function CommItemsClass:ForeachCommItems(callBack) 
    if(self.CommItems == nil) then 
		self.CommItems = OOSyncList.new( self.OwnerPlayer.PlyObj,"CommItems") 
	end

   self.CommItems:Foreach(callBack) 
end


--endregion
