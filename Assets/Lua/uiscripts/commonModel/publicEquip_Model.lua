EquipModel = {

	local_Equipment = {},-- 本地Equipment表

	serv_Equipment = {},-- 从服务器获取的Equipment数据

	serv_fitEquipmentList = {},-- 从服务器获取的已穿戴装备的id列表

	serv_CurrencyInfo = {},-- (本地，服务器)混合数据表

}

--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
--@Des 通过EquipID获取本地装备数据
--@params (number)equipmentID:装备eid
--@return (table)本地装备表数据副本
--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
function EquipModel:getLocalEquipmentDetailByEquipID(equipmentID)
	require("uiscripts/cangku/util/deepcopy")
	for i = 1,#EquipModel.local_Equipment do
		if EquipModel.local_Equipment[i]["EquipID"] == equipmentID then
			return table.deepcopy(EquipModel.local_Equipment[i])
		end
	end
	Debugger.LogWarning(equipmentID.." not found in EquipModel:getLocalEquipmentDetailByEquipID(equipmentID)")
	return nil
end
--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
--@Des 通过装备唯一id获取装备类型,用于查询装备是否重复装备
--@params id:装备唯一id
--@return (Int32)EquipType
--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
function EquipModel:getLocalEquipmentTypeByServID(id)
	for i = 1,#EquipModel.serv_Equipment do
		if EquipModel.serv_Equipment[i].id == id then
			return EquipModel.serv_Equipment[i]["EquipType"]
		end
	end
	Debugger.LogWarning(id.." not found in EquipModel:getLocalEquipmentTypeByServID(id)")
	return nil
end
--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
--@Des 刷新储存数据的表
--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
--@params user_equip:服务器装备数据
function EquipModel:updateEquipData(user_equip)
	if user_equip then
		-- 根据装备唯一id查找本地待更新数据
		for i = 1,#self.serv_Equipment do
			if self.serv_Equipment[i].id == user_equip.id then
				local equip = self.serv_Equipment[i]
				equip.eid = user_equip.eid
				equip.lv = user_equip.lv
				equip.rarity = user_equip.rarity
				equip.fst_attr = user_equip.fst_attr
				equip.sndAttr = { remake = {} }
				equip.isLock = user_equip.isLock
				equip.isBad = user_equip.isBad
				for k, v in ipairs(user_equip.sndAttr) do
					table.insert(equip.sndAttr,
					{
						id = v.id,
						val = v.val,
						isRemake = v.isRemake,
					})
					for kk, vv in ipairs(v.remake) do
						table.insert(equip.sndAttr.remake,
						{
							id = vv.id,
							val = vv.val,
						})
					end
				end
			end
		end
	end
end


return EquipModel