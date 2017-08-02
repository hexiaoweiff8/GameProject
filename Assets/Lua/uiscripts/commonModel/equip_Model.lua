require('uiscripts/cangku/util/table_count')
EquipModel = {
	--[[
		local_Equipment{
			[EquipID] = {EquipName = string,...},
			[EquipID] = {...},
		}
	]]
	local_Equipment = {},-- 本地Equipment表
	--[[
		serv_Equipment{
			[id] = {eid = int,EquipName = string,...},
			[id] = {...},
		}
	]]
	serv_Equipment = {},-- 从服务器获取的Equipment数据

	serv_fitEquipmentList = {},-- 从服务器获取的已穿戴装备的id列表

}
----------------------------------------------------------------
--★Init
function EquipModel:initModel()
	EquipModel:initLocalEquipData()
end

function EquipModel:initLocalEquipData()
	if sdata_equip_data == nil then
		print("没获取到以下数据表：sdata_equip_data")
		return
	end	
	
	for k,v in pairs(sdata_equip_data.mData.body) do
		local Equipment = {}
		Equipment["EquipID"] = v[sdata_equip_data.mFieldName2Index['EquipID']]
		Equipment["EquipName"] = v[sdata_equip_data.mFieldName2Index['EquipName']]
		Equipment["EquipIcon"] = v[sdata_equip_data.mFieldName2Index['EquipIcon']]
		Equipment["EquipType"] = v[sdata_equip_data.mFieldName2Index['EquipType']]
		Equipment["SuitID"] = v[sdata_equip_data.mFieldName2Index['SuitID']]
		Equipment["MainAttribute"] = v[sdata_equip_data.mFieldName2Index['MainAttribute']]
		Equipment["ViceAttribute1"] = v[sdata_equip_data.mFieldName2Index['ViceAttribute1']]
		Equipment["ViceAttribute2"] = v[sdata_equip_data.mFieldName2Index['ViceAttribute2']]
		Equipment["ViceAttribute3"] = v[sdata_equip_data.mFieldName2Index['ViceAttribute3']]
		Equipment["ViceAttribute4"] = v[sdata_equip_data.mFieldName2Index['ViceAttribute4']]
		Equipment["ViceAttribute5"] = v[sdata_equip_data.mFieldName2Index['ViceAttribute5']]

		-- table.insert(EquipModel.local_Equipment,Equipment)
		EquipModel.local_Equipment[Equipment["EquipID"]] = Equipment
	end
	-- 按照EquipID从小到大排序
	table.sort(EquipModel.local_Equipment,function(a,b)
		return a["EquipID"] < b["EquipID"]
	end)

	print("read "..table.count(EquipModel.local_Equipment).." Equipments(Local).")
end
--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
--@Des 通过EquipID获取本地装备数据
--@params (number)equipmentID:装备eid
--@return (table)本地装备表数据副本
--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
function EquipModel:getLocalEquipmentDetailByEquipID(equipmentID)
	require("uiscripts/cangku/util/deepcopy")
	-- for i = 1,#EquipModel.local_Equipment do
	-- 	if EquipModel.local_Equipment[i]["EquipID"] == equipmentID then
	-- 		return table.deepcopy(EquipModel.local_Equipment[i])
	-- 	end
	-- end
	-- Debugger.LogWarning(equipmentID.." not found in EquipModel:getLocalEquipmentDetailByEquipID(equipmentID)")
	-- return nil
	return table.deepcopy(EquipModel.local_Equipment[equipmentID])
end
--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
--@Des 通过EquipID获取本地装备数据(引用)
--@params (number)equipmentID:装备eid
--@return (table*)本地装备表数据引用
--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
function EquipModel:getLocalEquipmentRefByEquipID(equipmentID)
	-- for i = 1,#EquipModel.local_Equipment do
	-- 	if EquipModel.local_Equipment[i]["EquipID"] == equipmentID then
	-- 		return EquipModel.local_Equipment[i]
	-- 	end
	-- end
	-- Debugger.LogWarning(equipmentID.." not found in EquipModel:getLocalEquipmentRefByEquipID(equipmentID)")
	-- return nil
	return EquipModel.local_Equipment[equipmentID]
end
--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
--@Des 通过装备唯一id获取装备类型,用于查询装备是否重复装备
--@params id:装备唯一id
--@return (Int32)EquipType
--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
function EquipModel:getLocalEquipmentTypeByServID(id)
	-- for i = 1,#EquipModel.serv_Equipment do
	-- 	if EquipModel.serv_Equipment[i].id == id then
	-- 		return EquipModel.serv_Equipment[i]["EquipType"]
	-- 	end
	-- end
	-- Debugger.LogWarning(id.." not found in EquipModel:getLocalEquipmentTypeByServID(id)")
	-- return nil
	return EquipModel.serv_Equipment[id]["EquipType"]
end
--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
--@Des 刷新储存数据的表
--@params user_equip:服务器装备数据
--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
function EquipModel:updateEquipData(user_equip)
	if user_equip then
		-- -- 根据装备唯一id查找本地待更新数据
		-- for i = 1,#self.serv_Equipment do
		-- 	if self.serv_Equipment[i].id == user_equip.id then
		-- 	end
		-- end

		local equip = self.serv_Equipment[user_equip.id]
		if equip == nil then
			Debugger.LogWarning("本地不存在该装备 id ="..user_equip.id.." 是否要使用插入方法？")
			return
		end
			equip.eid = user_equip.eid
			equip.lv = user_equip.lv
			equip.rarity = user_equip.rarity
			equip.fst_attr = user_equip.fst_attr
			equip.sndAttr = { }
			equip.isLock = user_equip.isLock
			equip.isBad = user_equip.isBad
			for k, v in ipairs(user_equip.sndAttr) do
				table.insert(equip.sndAttr,
				{
					id = v.id,
					val = v.val,
					isRemake = v.isRemake,
					remake = {} 
				})
				for _, vv in ipairs(v.remake) do
					table.insert(equip.sndAttr[k].remake,
					{
						id = vv.id,
						val = vv.val,
					})
				end
			end
	end
end
--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
--@Des 添加equip数据
--@Params 服务器传回的Equip数据
--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
function EquipModel:addEquipData(gw2c_equip)
	for _,eq in ipairs(gw2c_equip) do
		local equip = self:getLocalEquipmentDetailByEquipID(eq.eid)
		equip.id = eq.id
		equip.eid = eq.eid
		equip.lv = eq.lv
		equip.rarity = eq.rarity
		equip.fst_attr = eq.fst_attr
		equip.sndAttr = {}
		equip.isLock = eq.isLock
		equip.isBad = eq.isBad
		for k, v in ipairs(eq.sndAttr) do
           	table.insert(equip.sndAttr,
           	{
           		id = v.id,
				val = v.val,
				isRemake = v.isRemake,
				remake = {},
	        })
            for _, vv in ipairs(v.remake) do
                table.insert(equip.sndAttr[k].remake,
                {
					id = vv.id,
					val = vv.val,
                })
            end
        end
        -- table.insert(self.serv_Equipment,equip)
        self.serv_Equipment[equip.id] = equip
	end
	-- 插入装备不需要排序
	-- require("uiscripts/Util/equipUtil"):sortEquipment(self.serv_Equipment)
	-- require('uiscripts/cangku/wnd_cangku_model').Processed_Items = {}
	-- require('uiscripts/cangku/wnd_cangku_controller'):mergeServData()
end

---
---根据装备的ID获取装备对象
---equipID  装备ID
---
function EquipModel:getEquipByOnlyID(equipOnlyID)
	-- for k, v in ipairs(EquipModel.serv_Equipment) do
	-- 	if v.id == equipOnlyID then
	-- 		return v
	-- 	end
	-- end
	-- return nil
	-- NOTE: 2017-07-31 修改查询方法
	return EquipModel.serv_Equipment[equipOnlyID]
end

---
---获取穿戴中的套装装备的数量
---
function EquipModel:getSuitEquipNum(SuitID)
	local suitCount = 0
	for i = 1,#EquipModel.serv_fitEquipmentList do
		local equip = EquipModel:getEquipByOnlyID(EquipModel.serv_fitEquipmentList[i])
		if equip.SuitID == SuitID and equip.isBad ~= 1 then
			suitCount = suitCount + 1
		end
	end
	return suitCount
end
return EquipModel