--region *.lua
--Date 20160708
--装备对象
--作者 gyt

EquipClass = classWC()

--角色属性名枚举
EquipAttrNames = {
		ID = "id",--装备标识string
		DataID = "eid",--静态id
		EType = "etype",--装备类型
--        LV = "lv",--穿戴等级
		HeroID = "hid",--所属武将
        eZDL = "zdl",--战斗力
--        Wuli = "wuli",--武力
--        Nu = "nu",--怒气
--        HP = "hp",--血量
--        Tili = "tili",--体力
        SkillAttr = "skillattr",--洗练属性，需解析
        CurrSkill = "CurrSkill",--当前洗练属性
        canEq = "canEq"--是否可以操作

}



function EquipClass:ctor(ownerPlayer)
	self.OwnerPlayer = ownerPlayer
end

function EquipClass:GetAttr(attr)
	return self.OwnerPlayer:GetValue(attr)
end

function EquipClass:ForeachEquips(callBack) 
    if(self.EquipAttrNames == nil) then 
		self.EquipAttrNames = OOSyncList.new( self.OwnerPlayer.PlyObj,"Equips") 
	end

   self.EquipAttrNames:Foreach(callBack) 
end
--endregion
