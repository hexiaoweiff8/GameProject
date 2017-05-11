--region *.lua
--Date 20160225
--布阵

FrmsClass = classWC()

FrmsType = {

    PuTong = 1,

}

--英雄属性名枚举
FrmsNames = {
	ZhenID = "ZhenID",
	ZhenPos = "ZhenPos",
} 

function FrmsClass:BindSyncObj(ownerPlayer,syncObj)
	self.Obj = syncObj
	self.OwnerPlayer = ownerPlayer
end

function FrmsClass:GetAttr(attr)
	return self.Obj:GetValue(attr)
end

function FrmsClass:GetNumberAttr(attr)
	return tonumber(self:GetAttr(attr))
end


--endregion
