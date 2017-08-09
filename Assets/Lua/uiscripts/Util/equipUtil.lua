require('uiscripts/cangku/util/table_count')
EquipUtil = {}
--@Des 混合本地/服务器数据
--	   调用顺序:
--		1.initModel()方法初始化公用Model的local_Equipment表
--		2.getEquipData()存储服务器装备表数据到公用Model的serv_Equipment表
--@params user_equip:服务器装备表数据
--@return (table)混合了本地装备表信息的服务器装备表副本
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
			equip.sndAttr = {}
			equip.isLock = v.isLock
			equip.isBad = v.isBad
			for k, v in ipairs(v.sndAttr) do
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
	        -- NOTE: 2017-07-28尝试更改equip数据存储格式
			--[[
				由原来的table.insert改为根据装备唯一id字段存储以提升增删改性能
			]]
			-- table.insert(Processed_Equipment,equip)
			Processed_Equipment[equip.id] = equip
		end
		equip = {}
    end

    return Processed_Equipment
end
--@Obsolete 由于装备表结构修改,该排序方法已弃用
--@Des 对传入的装备表根据给定规则排序
--@params Equipment(table*):装备列表引用
function EquipUtil:sortEquipment(Equipment)
	if Equipment == nil or table.count(Equipment) == 0 then
		return
	end
	table.sort(Equipment,
		function(a,b)
			if a.isBad ~= b.isBad then
				return (a.isBad == 1 and {true} or {false})[1] -- 损坏度,坏的在前
			elseif a.lv ~= b.lv then
				return a.lv > b.lv -- lv大的在前
			elseif a.rarity ~= b.rarity then
				return a.rarity > b.rarity -- 装备品质高的在前
			else
				return a.id < b.id -- id小的在前
			end
		end)
end


--@Des 获取装备主属性字符串
--@params EquipID(number):装备ID
--		  AttributeID(number):属性ID(从服务器获取)
--		  lv(number):装备等级
--@return (string)装备主属性字符串
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

--@Des 获取装备主属性数值
--@params equip:装备Data(混合数据)
--@return 装备主属性数值
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

--@Des 获取装备副属性字符串
--@params equip*:装备Data(混合数据)
--@return (string)装备副属性字符串
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

		---换行
		if i > 1 then
			str = str.."\n "
		end
		if equip.sndAttr[i] ~= nil then
			_AttributeID = equip.sndAttr[i].id
			local AttributeName = sdata_attribute_data.mData.body[_AttributeID][sdata_attribute_data.mFieldName2Index['AttributeName']]
			local Symbol = sdata_attribute_data.mData.body[_AttributeID][sdata_attribute_data.mFieldName2Index['Symbol']]

			if AttributeName == nil then
				Debugger.LogWarning("没找到副属性,AttributeID = ".._AttributeID)
				return
			end

			str = str..AttributeName.."+"..equip.sndAttr[i].val..Symbol
		else
			str = str.."[s][707070]  强化等级+"..(i * cint.SUBATTR_NEED).."解锁  [-][/s]"
		end
	end
	for i = 1,(cint.EQUIPMENT_MAXLEVEL / cint.SUBATTR_NEED) - math.floor(EquipUtil:getEquipmentPlusMAXLevel(equip.rarity) / cint.SUBATTR_NEED) do
		str = str.."\n ".."[s][707070]    无法激活    [-][/s]"
	end 
	return str
end

--@Des 获取装备副属性字符串表
--@params equip*:装备Data(混合数据)
--@return （table）副属性字符串表
function EquipUtil:getEquipmentSubAttributeStrList(equip)
	local _AttributeID
	local _lv = equip.lv
	local _UniqueID
	local strList = {}
	for i = 1,math.floor(EquipUtil:getEquipmentPlusMAXLevel(equip.rarity) / cint.SUBATTR_NEED) do

		if equip.sndAttr[i] ~= nil then
			_AttributeID = equip.sndAttr[i].id

			local AttributeName = sdata_attribute_data.mData.body[_AttributeID][sdata_attribute_data.mFieldName2Index['AttributeName']]
			local Symbol = sdata_attribute_data.mData.body[_AttributeID][sdata_attribute_data.mFieldName2Index['Symbol']]

			if AttributeName == nil then
				Debugger.LogWarning("没找到副属性,AttributeID = ".._AttributeID)
				return
			end
			table.insert(strList, AttributeName.."+"..equip.sndAttr[i].val..Symbol)
		end
	end
	return strList
end

--@Des 获取套装效果字符串,该方法使用储存在公用Model的serv_fitEquipmentList表查询已穿戴的装备
--@params SuitID:套装id
--@return	list = { suitAttr }
--	suitAttr = {
--		str,        --套装属性字符串
--		actNum      --属性激活次数
--	}
function EquipUtil:getSuitAttrbuteList(SuitID)
	local list = {}
	local suitNumList = equipSuitUtil:getSuitNumList(SuitID)
	local suitAttrStrList = equipSuitUtil:getEquipSuitAttrbuteStringList(SuitID)
	local suitCount = EquipModel:getSuitEquipNum(SuitID)

	for i = 1, #suitNumList do
		local suitAttr = {
			str = "",       --套装属性字符串
			actNum = 0     	--属性激活次数
		}
		if suitCount >= suitNumList[i] then
			suitAttr.str = suitAttrStrList[i]
			local actNum= math.modf(suitCount / suitNumList[#suitNumList])
			local L = suitCount % suitNumList[#suitNumList]
			if L >= suitNumList[i] then
				actNum = actNum + 1
			end
			suitAttr.actNum = actNum
		else
			suitAttr.str = "[707070]"..suitAttrStrList[i].."[-]"
		end
		table.insert(list, suitAttr)
	end
	return list
end

--@Des 获取套装效果字符串,不受已穿戴的装备数量的影响
--@params SuitID:套装id
--@return (string)套装效果字符串
function EquipUtil:getEquipmentSuitEffectNormalStr(SuitID)

	local str = ''
	local suitNumList = equipSuitUtil:getSuitNumList(SuitID)

	for i = 1, #suitNumList do

		local suitAttrID = equipSuitUtil:getSuitAttributeID(SuitID, suitNumList[i])
		local suitAttrPoint = equipSuitUtil:getSuitAttributeValue(SuitID, suitNumList[i])
		local suitName = attributeUtil:getAttributeName(suitAttrID)
		local suitSymbol = attributeUtil:getAttributeSymbol(suitAttrID)

		local suitStr = string.format(stringUtil:getString(0xFE19), suitNumList[i])
		.."[30D6FF]"..suitName.."[-]+"..suitAttrPoint..suitSymbol
		str = str .. suitStr .. "\n"
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

--@Des 获取装备最高强化等级
--@params Quality:装备品质
--@return (int)装备最高强化等级
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

--@Des 获取强化到下一等级所需要的能量点
--@params currentLV:装备当前等级
--		  Quality:装备品质
--@return (int or Str)强化到下一等级所需要的能量点
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
function EquipUtil:getEquipmentFixCost(currentLV, Quality)
	if sdata_equippower_data == nil then
		print("sdata_equippower_data")
		return
	end
	return math.ceil(sdata_equippower_data:GetFieldV('Quality'..Quality,currentLV) / 10)
end

--@Des 获取强化到下一等级提升数值
--@params equip:装备Data
--@return 强化到下一等级提升数值
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

--@Des 获取套装id通过装备唯一id
--@params id:装备唯一id
--@return (int)装备SuitID
function EquipUtil:getEquipmentSuitIDByID(id)
	-- for i = 1,#EquipModel.serv_Equipment do
	-- 	if EquipModel.serv_Equipment[i].id == id then
	-- 		return EquipModel.serv_Equipment[i]["SuitID"]
	-- 	end
	-- end
	-- Debugger.LogWarning(id.." not found in EquipUtil:getEquipmentSuitIDByID(id)")
	-- return nil
	return EquipModel.serv_Equipment[id]["SuitID"]
end

--@Des 通过装备唯一id查询装备是否已装备
--@params id:装备唯一id
--@return bool
function EquipUtil:whetherHasBeenEquipped(id)
	for k,v in ipairs(EquipModel.serv_fitEquipmentList) do
		if v == id then
			return true
		end
	end
	return false
end

--@Des 检查是否存在重复装备
--@params equip:混合数据
--@return (bool)equipped,(int)index(重复装备在serv_fitEquipmentList表中的索引)
function EquipUtil:whetherRepeatEquipped(equip)
	for i = #EquipModel.serv_fitEquipmentList,1,-1 do
		local _EquipType = EquipModel:getLocalEquipmentTypeByServID(EquipModel.serv_fitEquipmentList[i])
		if _EquipType == equip["EquipType"] then
			return true,i
		end
	end
	return false,nil
end

--[[
     获取属性重铸所需材料的id
     equipRarity	装备品质
     index  		第几条重铸属性
]]
function EquipUtil:getEquipRemakeItemID(equipRarity, index)
	return sdata_equiprecast_data:GetFieldV("Item"..index, equipRarity)
end

--[[
     获取重铸所需材料的数量
     equipRarity	装备品质
     index  		第几条重铸属性
]]
function EquipUtil:getEquipRemakeItemNum(equipRarity, index)
	return sdata_equiprecast_data:GetFieldV("Num"..index, equipRarity)
end

return EquipUtil