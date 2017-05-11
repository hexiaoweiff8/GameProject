--region *.lua
--Date 20160816
--洗练对象
--作者 zxy


JLBagClass = classWC()

--角色属性名枚举
JLBagAttrNames = {
   		DataID = "DataID",--ID
		NUM = "NUM",--数量
}


function JLBagClass:ctor(ownerPlayer)
	self.OwnerPlayer = ownerPlayer
end

function JLBagClass:GetAttr(attr)
	return self.OwnerPlayer:GetValue(attr)
end

function JLBagClass:ForeachJLBag(callBack) 
    if(self.JLBag == nil) then 
		self.JLBag = OOSyncList.new( self.OwnerPlayer.PlyObj,"JLbag") 
	end
    self.JLBag:Foreach(callBack) 
end