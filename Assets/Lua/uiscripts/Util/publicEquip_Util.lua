require('uiscripts/commonModel/publicEquip_Model')
EquipUtil = {}

--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
--@Des 读取本地装备表
--@return (table)本地装备表副本
--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
function EquipUtil:getLocalEquipData()
	if sdata_equip_data == nil then
		print("没获取到以下数据表：sdata_equip_data")
		return
	end	
	local local_Equipment = {}
	local Equipment = {}

	for k,v in pairs(sdata_equip_data.mData.body) do

		Equipment["EquipID"] = v[sdata_equip_data.mFieldName2Index['EquipID']]
		Equipment["EquipName"] = v[sdata_equip_data.mFieldName2Index['EquipName']]
		Equipment["EquipIcon"] = v[sdata_equip_data.mFieldName2Index['EquipIcon']]
		Equipment["EquipType"] = v[sdata_equip_data.mFieldName2Index['EquipType']]
		Equipment["SuitID"] = v[sdata_equip_data.mFieldName2Index['SuitID']]
		Equipment["MainAttribute"] = v[sdata_equip_data.mFieldName2Index['MainAttribute']]
	
		table.insert(local_Equipment,Equipment)

		Equipment = {}
	end
	-- 按照EquipID从小到大排序
	table.sort(local_Equipment,function(a,b)
		return a["EquipID"] < b["EquipID"]
	end)

	print("read "..#local_Equipment.." Equipments(Local).")

	return local_Equipment
end

--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
--@Des 混合本地/服务器数据
--	   调用顺序:
--		1.使用getLocalEquipData()方法存储本地表数据到公用Model的local_Equipment表
--		2.getEquipData()存储服务器装备表数据到公用Model的serv_Equipment表
--@params user_equip:服务器装备表数据
--@return (table)混合了本地装备表信息的服务器装备表副本
--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
function EquipUtil:getEquipData(user_equip)
	
	local Processed_Equipment = {}

	for k, v in ipairs(user_equip) do
		
		local equip = {}
		equip = EquipModel:getLocalEquipmentDetailByEquipID(v.eid)
		if equip ~= nil then
			-- 添加选中属性
			equip.selected = false
			-- 添加是否穿戴属性
			equip.equipped = self:whetherHasBeenEquipped(v.id)
			equip.id = v.id
			equip.eid = v.eid
			equip.lv = v.lv
			equip.rarity = v.rarity
			equip.fst_attr = v.fst_attr
			equip.sndAttr = { remake = {} }
			equip.isLock = v.isLock
			equip.isBad = v.isBad
			for k, v in ipairs(v.sndAttr) do
	           	table.insert(equip.sndAttr,
	           	{
	           		id = v.id,
					val = v.val,
					isRemake = v.isRemake,
		        })
	            for k, v in ipairs(v.remake) do
	                table.insert(equip.sndAttr.remake,
	                {
						id = v.id,
						val = v.val,
	                })
	            end
	        end
			table.insert(Processed_Equipment,equip)
		end
		equip = {}
    end

    return Processed_Equipment
end

--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
--@Des 对传入的装备表根据给定规则排序
--@params Equipment(table):装备列表引用
--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
function EquipUtil:sortEquipment(Equipment)
	if Equipment == nil or #Equipment == 0 then
		return
	end
	table.sort(Equipment,
		function(a,b)
			if a.id ~= b.id then
				return a.id < b.id -- 装备专有ID小的在前
			elseif a.lv ~= b.lv then
				return a.lv > b.lv -- lv大的在前
			elseif a.rarity	 ~= b.rarity then
				return a.rarity > b.rarity -- rarity大的在前
			elseif a.isBad ~= 0 then
				return false -- 损坏度
			end	
		end)
end

--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
--@Des 获取装备主属性字符串
--@params EquipID(number):装备ID，AttributeID(number):属性ID(从服务器获取),lv(number):装备等级
--@return (string)装备主属性字符串
--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
function EquipUtil:getEquipmentMainAttributeStr(EquipID,AttributeID,lv)
	local _PlanID = EquipModel:getLocalEquipmentDetailByEquipID(EquipID)["MainAttribute"]
	local _AttributeID = AttributeID
	local _lv = lv
	local _UniqueID = tostring(_PlanID)..tostring(_AttributeID)

	if sdata_attributeplan_data.mData.body[tonumber(_UniqueID)] == nil then
		Debugger.LogWarning("没找到主属性,UniqueID = ".._UniqueID)
		return
	end

	local _AttributeMin = sdata_attributeplan_data.mData.body[tonumber(_UniqueID)][sdata_attributeplan_data.mFieldName2Index['Min']]
	local _GrowthValue = sdata_attributeplan_data.mData.body[tonumber(_UniqueID)][sdata_attributeplan_data.mFieldName2Index['up']]
	-- 主属性值 = 最小值 + 装备等级 * 成长系数
	local _AttributeValue = _AttributeMin + _lv * _GrowthValue

	local AttributeName = sdata_attribute_data.mData.body[_AttributeID][sdata_attribute_data.mFieldName2Index['AttributeName']]
	local Symbol = sdata_attribute_data.mData.body[_AttributeID][sdata_attribute_data.mFieldName2Index['Symbol']]

	local str = AttributeName.."+".._AttributeValue..Symbol

	return str
end

--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
--@Des 获取装备主属性数值
--@params equip:装备对象
--@return 装备主属性数值
--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
function EquipUtil:getMainAttributeValue(equip)
	local _PlanID = equip.MainAttribute
	local _AttributeID = equip.fst_attr
	local _UniqueID = tostring(_PlanID)..tostring(_AttributeID)

	local _AttributeMin = sdata_attributeplan_data.mData.body[tonumber(_UniqueID)][sdata_attributeplan_data.mFieldName2Index['Min']]
	local _GrowthValue = sdata_attributeplan_data.mData.body[tonumber(_UniqueID)][sdata_attributeplan_data.mFieldName2Index['up']]
	-- 主属性值 = 最小值 + 装备等级 * 成长系数
	local _AttributeValue = _AttributeMin + equip.lv * _GrowthValue

	return _AttributeValue
end
--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
--@Des 获取装备副属性字符串
--@params equip:装备Data(混合数据)
--@return (string)装备副属性字符串
--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
function EquipUtil:getEquipmentSubAttributeStr(equip)
	local _AttributeID 
	local _lv = equip.lv
	local _UniqueID 

	local str = ""

	-- for i = 1,math.floor(_lv / cint.SUBATTR_NEED) do

	-- 	_AttributeID = equip.sndAttr[i].id

	-- 	local AttributeName = sdata_attribute_data.mData.body[_AttributeID][sdata_attribute_data.mFieldName2Index['AttributeName']]
	-- 	local Symbol = sdata_attribute_data.mData.body[_AttributeID][sdata_attribute_data.mFieldName2Index['Symbol']]

	-- 	if AttributeName == nil then
	-- 		Debugger.LogWarning("没找到副属性,AttributeID = ".._AttributeID)
	-- 		return
	-- 	end

	-- 	str = str..AttributeName.."+"..equip.sndAttr[i].val..Symbol.."\n"
	-- end
	for i = 1,math.floor(EquipUtil:getEquipmentPlusMAXLevel(equip.rarity) / cint.SUBATTR_NEED) do

		if equip.sndAttr[i] ~= nil then
			_AttributeID = equip.sndAttr[i].id

			local AttributeName = sdata_attribute_data.mData.body[_AttributeID][sdata_attribute_data.mFieldName2Index['AttributeName']]
			local Symbol = sdata_attribute_data.mData.body[_AttributeID][sdata_attribute_data.mFieldName2Index['Symbol']]

			if AttributeName == nil then
				Debugger.LogWarning("没找到副属性,AttributeID = ".._AttributeID)
				return
			end

			str = str..AttributeName.."+"..equip.sndAttr[i].val..Symbol.."\n"
		else
			str = str.."[s][707070]  强化等级+"..(i * cint.SUBATTR_NEED).."解锁  [-][/s]".."\n"
		end
	end
	for i = 1,(cint.EQUIPMENT_MAXLEVEL / cint.SUBATTR_NEED) - math.floor(EquipUtil:getEquipmentPlusMAXLevel(equip.rarity) / cint.SUBATTR_NEED) do
		str = str.."[s][707070]    无法激活    [-][/s]".."\n"
	end

	return str
end
--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
--@Des 获取套装效果字符串,该方法使用储存在公用Model的serv_fitEquipmentList表查询已穿戴的装备
--@params SuitID:套装id
--@return (string)套装效果字符串
--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
function EquipUtil:getEquipmentSuitEffectStr(SuitID)
	local nilValue = -1
	local SuitEffect_2_AttributeID = sdata_equipsuit_data.mData.body[SuitID][sdata_equipsuit_data.mFieldName2Index['SuitEffect2']]
	local SuitEffect_3_AttributeID = sdata_equipsuit_data.mData.body[SuitID][sdata_equipsuit_data.mFieldName2Index['SuitEffect3']]
	local SuitEffect_5_AttributeID = sdata_equipsuit_data.mData.body[SuitID][sdata_equipsuit_data.mFieldName2Index['SuitEffect5']]
	local SuitCount = 0
	local str = ""

	for i = 1,#EquipModel.serv_fitEquipmentList do
		if self:getEquipmentSuitIDByID(EquipModel.serv_fitEquipmentList[i]) == SuitID then
			SuitCount = SuitCount + 1
		end
	end
	-- gray #707070
	if SuitEffect_2_AttributeID ~= nilValue then
		local SuitEffect_2_AttributeName = sdata_attribute_data.mData.body[SuitEffect_2_AttributeID][sdata_attribute_data.mFieldName2Index['AttributeName']]
		local SuitEffect_2_AttributePoint = sdata_equipsuit_data.mData.body[SuitID][sdata_equipsuit_data.mFieldName2Index['Effect2Point']]
		local Symbol = sdata_attribute_data.mData.body[SuitEffect_2_AttributeID][sdata_attribute_data.mFieldName2Index['Symbol']]
		if SuitCount >= 2 then 
			str = str..
				sdata_UILiteral.mData.body[0xFE13][sdata_UILiteral.mFieldName2Index["Literal"]]..
				SuitEffect_2_AttributeName.."+"..
				SuitEffect_2_AttributePoint..Symbol.."\n"
		else
			str = str.."[707070]"..
				sdata_UILiteral.mData.body[0xFE13][sdata_UILiteral.mFieldName2Index["Literal"]]..
				SuitEffect_2_AttributeName.."+"..
				SuitEffect_2_AttributePoint..Symbol.."[-]".."\n"
		end
	end
	if SuitEffect_3_AttributeID ~= nilValue then
		local SuitEffect_3_AttributeName = sdata_attribute_data.mData.body[SuitEffect_3_AttributeID][sdata_attribute_data.mFieldName2Index['AttributeName']]
		local SuitEffect_3_AttributePoint = sdata_equipsuit_data.mData.body[SuitID][sdata_equipsuit_data.mFieldName2Index['Effect3Point']]
		local Symbol = sdata_attribute_data.mData.body[SuitEffect_3_AttributeID][sdata_attribute_data.mFieldName2Index['Symbol']]
		if SuitCount >= 3 then 
			str = str..
				sdata_UILiteral.mData.body[0xFE14][sdata_UILiteral.mFieldName2Index["Literal"]]..
				SuitEffect_3_AttributeName.."+"..
				SuitEffect_3_AttributePoint..Symbol.."\n"
		else
			str = str.."[707070]"..
				sdata_UILiteral.mData.body[0xFE14][sdata_UILiteral.mFieldName2Index["Literal"]]..
				SuitEffect_3_AttributeName.."+"..
				SuitEffect_3_AttributePoint..Symbol.."[-]".."\n"
		end
	end
	if SuitEffect_5_AttributeID ~= nilValue then
		local SuitEffect_5_AttributeName = sdata_attribute_data.mData.body[SuitEffect_5_AttributeID][sdata_attribute_data.mFieldName2Index['AttributeName']]
		local SuitEffect_5_AttributePoint = sdata_equipsuit_data.mData.body[SuitID][sdata_equipsuit_data.mFieldName2Index['Effect5Point']]
		local Symbol = sdata_attribute_data.mData.body[SuitEffect_5_AttributeID][sdata_attribute_data.mFieldName2Index['Symbol']]
		if SuitCount >= 5 then 
			str = str..
				sdata_UILiteral.mData.body[0xFE15][sdata_UILiteral.mFieldName2Index["Literal"]]..
				SuitEffect_5_AttributeName.."+"..
				SuitEffect_5_AttributePoint..Symbol.."\n"
		else
			str = str.."[707070]"..
				sdata_UILiteral.mData.body[0xFE15][sdata_UILiteral.mFieldName2Index["Literal"]]..
				SuitEffect_5_AttributeName.."+"..
				SuitEffect_5_AttributePoint..Symbol.."[-]".."\n"
		end
	end

	return str
end
--@Des 根据品质获取品质框精灵图字符串
--@params Quality:品质
function EquipUtil:getQualitySpriteStr(Quality)
	require('uiscripts/cangku/const/wnd_cangku_Const')
	if Quality == 1 then
		return cstr.QUALITY_WHITE
	elseif Quality == 2 then
		return cstr.QUALITY_GREEN
	elseif Quality == 3 then
		return cstr.QUALITY_BLUE
	elseif Quality == 4 then
		return cstr.QUALITY_PURPLE
	elseif Quality == 5 then
		return cstr.QUALITY_ORANGE
	else return cstr.QUALITY_RED end
end

--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
--@Des 获取装备最高强化等级
--@params Quality:装备品质
--@return (int)装备最高强化等级
--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
function EquipUtil:getEquipmentPlusMAXLevel(Quality)
	require('uiscripts/cangku/const/wnd_cangku_Const')
	if Quality == 1 then
		return cint.QUALITY_1_MAXLEVEL
	elseif Quality == 2 then
		return cint.QUALITY_2_MAXLEVEL
	elseif Quality == 3 then
		return cint.QUALITY_3_MAXLEVEL
	elseif Quality == 4 then
		return cint.QUALITY_4_MAXLEVEL
	elseif Quality == 5 then
		return cint.QUALITY_5_MAXLEVEL	
	else
		return cint.QUALITY_6_MAXLEVEL end
end
--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
--@Des 获取强化到下一等级所需要的能量点
--@params currentLV:装备当前等级,Quality:装备品质
--@return (int or Str)强化到下一等级所需要的能量点
--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
function EquipUtil:getEquipmentPlusCost(currentLV,Quality)
	if sdata_equippower_data == nil then
		print("sdata_equippower_data")
		return
	end
	if currentLV + 1 <= self:getEquipmentPlusMAXLevel(Quality) then
		return sdata_equippower_data.mData.body[currentLV + 1][sdata_equippower_data.mFieldName2Index['Quality'..Quality]] - 
			sdata_equippower_data.mData.body[currentLV][sdata_equippower_data.mFieldName2Index['Quality'..Quality]]
	else
		return "no pls"
	end
end
--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
--@Des 获取强化到下一等级提升数值
--@params equip:装备Data
--@return 强化到下一等级提升数值
--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
function EquipUtil:getEquipmentLevelUpOffsetStr(equip)
	local _PlanID = equip["MainAttribute"]
	local _AttributeID = equip.fst_attr
	local _UniqueID = tostring(_PlanID)..tostring(_AttributeID)
	local _GrowthValue = sdata_attributeplan_data.mData.body[tonumber(_UniqueID)][sdata_attributeplan_data.mFieldName2Index['up']]
	local Symbol = sdata_attribute_data.mData.body[_AttributeID][sdata_attribute_data.mFieldName2Index['Symbol']]
	local str = nil
	if equip.lv + 1 <= self:getEquipmentPlusMAXLevel(equip.rarity) then
		str = "+".._GrowthValue..Symbol
		return str
	else
		str = "+0"
		return str
	end
end
--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
--@Des 获取套装id通过装备唯一id
--@params id:装备唯一id
--@return (int)装备SuitID
--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
function EquipUtil:getEquipmentSuitIDByID(id)
	
	for i = 1,#EquipModel.serv_Equipment do
		if EquipModel.serv_Equipment[i].id == id then
			return EquipModel.serv_Equipment[i]["SuitID"]
		end
	end
	Debugger.LogWarning(id.." not found in EquipUtil:getEquipmentSuitIDByID(id)")
	return nil
end
--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
--@Des 通过装备唯一id查询装备是否已装备
--@params id:装备唯一id
--@return bool
--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
function EquipUtil:whetherHasBeenEquipped(id)
	for k,v in ipairs(EquipModel.serv_fitEquipmentList) do
		if v == id then
			return true
		end
	end
	return false
end
--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
--@Des 检查是否存在重复装备
--@params equip:混合数据
--@return (bool)equipped,(int)index(重复装备在serv_fitEquipmentList表中的索引)
--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
function EquipUtil:whetherRepeatEquipped(equip)
	for i = #EquipModel.serv_fitEquipmentList,1,-1 do
		local _EquipType = EquipModel:getLocalEquipmentTypeByServID(EquipModel.serv_fitEquipmentList[i])
		if _EquipType == equip["EquipType"] then
			return true,i
		end
	end
	return false,nil
end


return EquipUtil