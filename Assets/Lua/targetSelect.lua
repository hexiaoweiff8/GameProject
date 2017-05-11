

TargetSelecter = {num = 0}
local json = require('json')  

-- 新建对象
function TargetSelecter:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end

-- 获取对象缓存 如果对象未缓存则缓存
function TargetSelecter:Instance()
	if self.instance == nil then
		self.instance = self:new()
	end
	return self.instance
end


-- 根据配置表获取单位被选权重值
function GetWightWithName(oneTarget1, index, typeList, searchRange)
	
	-- 权重值
	local wight = 0
	-- 硬筛选(不符合条件排除)
	if index <= 3 and index >=1 then
		
		local targetValue
		for k, v in pairs(typeList) do
			
			targetValue = oneTarget1[k]
			-- 是否是该类型
			if  targetValue ~= nil and targetValue == 1 then
				-- 该类型是否允许被选
				if v >= 0 then
					wight = wight + v;
				else
					-- 权重值为负, 该类型不能作为被选项, 返回-1
					wight = -1
					break;
				end
			end
		end
		-- 软筛选(排序不排除)
	elseif index == 4 then
		
		-- 角度 (180 - 当前夹角) / 180 * 角度权重
		if typeList.RangeMax > 0 then
			wight = wight + (180 - oneTarget1.Angle) / 180 * typeList.AngleMin
		end
		-- 血量 (最大血量 - 当前血量)/最大血量 * 生命权重
		if typeList.HealthMax > 0 then
			wight = wight + (oneTarget1.HealthMax - oneTarget1.Health) / oneTarget1.HealthMax * typeList.HealthMax
		end
		if typeList.HealthMin > 0 then
			wight = wight + oneTarget1.Health / oneTarget1.HealthMax * typeList.HealthMin
		end
		-- 距离 (最大距离 - 当前距离)/最大距离 * 距离权重
		if searchRange > 0 then
			wight = wight + (searchRange - oneTarget1.Range) / searchRange * typeList.RangeMax
		end
	end
	
	-- print(index, "权重结果:", wight)
	-- 返回权重结果
	return wight
end

-- 处理同一等级的权重列表
function GetOneLevelWightList(oneTarget, typeLevel)
	-- 遍历权重列表
	local sumWight = 0
	local nowWigth = 0
	for kForTypeLevel, vForTypeLevel in ipairs(typeLevel.typeList) do
		
		nowWigth = GetWightWithName(oneTarget, kForTypeLevel, vForTypeLevel, typeLevel.SearchRange)
		if (nowWigth < 0)then
			sumWight = -1
			break;
		end
		sumWight = sumWight + nowWigth
	end
	
	--print("权重总和:", sumWight)
	return {wight = sumWight, target = oneTarget}
end

-- 计算两点间距离
-- from  点1
-- to    点2
-- return 两点间距离
function GetDistance(from, to)
	local result = 0
	if from ~= nil and to ~= nil then
		local x = from.x - to.x
		local y = from.y - to.y
		result = math.sqrt(x*x + y*y)
	end
	return result
end

-- targetDataList - 传入目标列表(规格化的数据)
-- selectId - 选择类型ID
-- return - 根据数据获取被选中列表
-- 数据结构: ID, TargetSelectTypeId, 阵营类型ID,
-- type1(空地建筑), type2(坦克,载具,火炮,飞行器,步兵),
-- type3(正常, 隐形, 钻地, 嘲讽), 距离, 生命, 角度
function SelectTarget(targetDataList, selectId)
	-- 根据ID获取搜索对象的搜索参数
	local selectData = TargetSelectCacheData[selectId]
	-- 数组长度
	local len = table.getn(targetDataList)
	-- 返回列表
	local result = {}
	-- 最大权重
	local maxWight = 0
	-- 最大权重的index
	local maxWightIndex = 0
	-- 解析数据
	for i =1,len do
		-- 获取单位
		local oneTarget = targetDataList[i]
		--[[for k,v in pairs(targetDataList) do
			print(111,k,v)
		end--]]
		--print(oneTarget.Name, table.getn(targetDataList))
		-- 计算单位与选择单位的距离
		oneTarget.Range = GetDistance(selectData.selecterPos, oneTarget.Position)
		-- 分Type层进行区分过滤
		-- 求权重值
		local wightData = GetOneLevelWightList(oneTarget, selectData)
		-- 将权重与对应数据放入同一个列表
		result[i] = wightData
		-- 获取权重最大的数据
		if maxWight < wightData.wight then
			maxWight = wightData.wight
			maxWightIndex = i
		end
	end
	
	-- 将数据按照权重值从大到小排序
	table.sort(result, function (a,b)
		return a.wight > b.wight
	end)
	
	-- 有其他筛选条件
	if selectData.otherType ~= nil then
		
		-- 如果需要求目标周围半径内单位
		if  selectData.otherType.scatteringRadius ~= nill and
			selectData.otherType.scatteringRadius > 0 and
			maxWightIndex > 0 then
			
			-- 散射情况下的筛选列表
			local newResultForScattering = {}
			-- 权重值最大对象
			local maxWightItem = result[maxWightIndex]
			-- 最大权重目标位置
			local maxWightPos = maxWightItem.target.Position
			
			-- 两对象距离
			local distance
			-- 计算位置限制 搜索点不能距离当前对象低于搜索点半径的距离
			distance = GetDistance(maxWightPos, selectData.selecterPos)
			-- print(distance)
			-- print("searchedPos", maxWightPos.x, maxWightPos.y)
			-- 如果最大权重目标位置与搜索单位距离小于散射半径, 则将位置向后延伸至与散射半径相等距离
			if distance < selectData.otherType.scatteringRadius and distance > 0 then
				local x = maxWightPos.x - selectData.selecterPos.x
				local y = maxWightPos.y - selectData.selecterPos.y
				local lengthRatio = selectData.otherType.scatteringRadius / distance
				x = x * lengthRatio
				y = y * lengthRatio
				maxWightPos.x = x + selectData.selecterPos.x
				maxWightPos.y = y + selectData.selecterPos.y
			end
			-- TODO 计算精准度
			-- print("searchPos", maxWightPos.x, maxWightPos.y)
			
			-- 获得最大权重值周围的单位(所有)
			for i = 1, len do
				-- 获取单位
				local item = result[i]
				
				-- 计算单位是否在最高权重目标的范围内
				-- print(GetDistance(maxWightPos, item.target.Position))
				distance = GetDistance(maxWightPos, item.target.Position)
				if distance <= selectData.otherType.scatteringRadius then
					table.insert(newResultForScattering, item)
				end
			end
			-- 替换输出结果
			result = newResultForScattering
		end
		
		-- 获取射程内指定数量的对象
		if selectData.otherType.targetCount ~= nill and selectData.otherType.targetCount > 0 then
			
			local maxCount = selectData.otherType.targetCount
			-- 如果最大数量大于当前已选择数量 则不需要分割列表直接返回列表
			if maxCount <= len then
				
				-- 新返回列表
				local newResultForMaxCount = {}
				-- 分割列表只保留目标数量个单位
				for i = 1, selectData.otherType.targetCount do
					
					newResultForMaxCount[i] = result[i]
				end
				result = newResultForMaxCount
			end
		end
	end

	-- TODO 数据转换为单个stirng
	return json.encode(result)
end


function SearchTargetWithJson(jsonData, selectId)
	if(jsonData == nil) then
		return nil
	end
	
	--print(jsonData.jsonData)
	local data = json.decode(jsonData.jsonData)
	return SelectTarget(data.data, selectId)
end


-- TODO ------------------常态数据, 数据先传输过来, 之后解决数据保存问题--------------
TargetSelectCacheData = {
[10000] = {
id = 10000,
typeList = {
[1] = {
Surface = 100,
Air = 0,
Build = 100
},
[2] = {
Tank = 10,
LV = 10,
Cannon = 10,
Aircraft = 10,
Soldier = 10
},
[3] = {
Hide = -1,
HideZd = -1,
Taunt = 10000
},
[4] = {
RangeMin = 10,
RangeMax = 10,
HealthMin = 0,
HealthMax = 10,
AngleMin = 10
}
},
otherType = {
-- 精准度
accuracy = 0.6,
-- 散射半径
scatteringRadius = 100,
},

-- 搜索单位的位置
selecterPos = {x = 1, y = 1},
SearchRange = 100
},
[10001] = {
id = 10000,
typeList = {
[1] = {
Surface = 100,
Air = 1,
Build = 100
},
[2] = {
Tank = 10,
LV = 10,
Cannon = 10,
Aircraft = 10,
Soldier = 10
},
[3] = {
Hide = 1,
HideZd = 1,
Taunt = 10000
},
[4] = {
RangeMin = 10,
RangeMax = 10,
HealthMin = 0,
HealthMax = 10,
AngleMin = 10
}
},
otherType = {
-- 目标数量
targetCount = 10
},

-- 搜索单位的位置
selecterPos = {x = 1, y = 1},
SearchRange = 100
}
}

-- ---------------------------测试数据---------------------------
local onetarget = {
Surface = 1,
Air = 0,
Build = 0,
Tank = 0,
LV = 0,
Cannon = 1,
Aircraft = 0,
Soldier = 0,
Hide = 0,
HideZd = 0,
Taunt = 0,
Health = 1,
HealthMax = 100,
Angle = 0,
Position = {x = 0, y = 0}
}

local onetarget2 = {
Surface = 1,
Air = 0,
Build = 0,
Tank = 0,
LV = 0,
Cannon = 1,
Aircraft = 0,
Soldier = 0,
Hide = 0,
HideZd = 0,
Taunt = 0,
Health = 1,
HealthMax = 100,
Angle = 0,
Position = {x = 0, y = 10}
}

local onetarget3 = {
Surface = 1,
Air = 0,
Build = 0,
Tank = 0,
LV = 0,
Cannon = 1,
Aircraft = 0,
Soldier = 0,
Hide = 0,
HideZd = 0,
Taunt = 0,
Health = 10,
HealthMax = 100,
Angle = 0,
Position = {x = 10, y = 10}
}

testData = {}
--GetOneLevelWightList(onetarget, TargetSelectCacheData[10000])

--local targetSelecter = TargetSelecter:Instance()
--local result = SelectTarget({onetarget, onetarget2, onetarget3}, 10001)
local jsonData = {jsonData = "{'data' : [{'Name' : 1,'Surface' : 0,'Air' : 1,'Build' : 0,'Tank' : 0,'LV' : 1,'Cannon' : 0,'Aircraft' : 0,'Soldier' : 0,'HealthMax' : 10,'Health' : 2,'Angle' : 13.06557,'Position' : { 'x' : 70.07961,'y' : 63.13879}},{'Name' : 2,'Surface' : 0,'Air' : 1,'Build' : 0,'Tank' : 0,'LV' : 0,'Cannon' : 1,'Aircraft' : 0,'Soldier' : 0,'HealthMax' : 10,'Health' : 3,'Angle' : 6.497635,'Position' : { 'x' : 39.12148,'y' : 63.10413}},{'Name' : 3,'Surface' : 0,'Air' : 1,'Build' : 0,'Tank' : 0,'LV' : 1,'Cannon' : 0,'Aircraft' : 0,'Soldier' : 0,'HealthMax' : 10,'Health' : 4,'Angle' : 40.75872,'Position' : { 'x' : 82.15903,'y' : 91.01767}},{'Name' : 4,'Surface' : 0,'Air' : 1,'Build' : 0,'Tank' : 0,'LV' : 0,'Cannon' : 0,'Aircraft' : 1,'Soldier' : 0,'HealthMax' : 10,'Health' : 5,'Angle' : 19.13668,'Position' : { 'x' : 78.14133,'y' : 43.07502}},{'Name' : 6,'Surface' : 0,'Air' : 1,'Build' : 0,'Tank' : 1,'LV' : 0,'Cannon' : 0,'Aircraft' : 0,'Soldier' : 0,'HealthMax' : 10,'Health' : 2,'Angle' : 13.15622,'Position' : { 'x' : 57.07938,'y' : 95.13892}},{'Name' : 7,'Surface' : 0,'Air' : 1,'Build' : 0,'Tank' : 0,'LV' : 0,'Cannon' : 0,'Aircraft' : 1,'Soldier' : 0,'HealthMax' : 10,'Health' : 3,'Angle' : 35.13593,'Position' : { 'x' : 29.02162,'y' : 83.15854}},{'Name' : 8,'Surface' : 0,'Air' : 1,'Build' : 0,'Tank' : 0,'LV' : 0,'Cannon' : 0,'Aircraft' : 1,'Soldier' : 0,'HealthMax' : 10,'Health' : 4,'Angle' : 40.75872,'Position' : { 'x' : 46.15902,'y' : 94.01767}},{'Name' : 9,'Surface' : 0,'Air' : 1,'Build' : 0,'Tank' : 0,'LV' : 0,'Cannon' : 1,'Aircraft' : 0,'Soldier' : 0,'HealthMax' : 10,'Health' : 5,'Angle' : 38.02183,'Position' : { 'x' : 4.013609,'y' : 70.15942}}]}"}
local result = SearchTargetWithJson(jsonData, 10000)
--local decodeData = json.decode(jsonData)
print (result)
--local encodeData = json.encode(result)
--print (encodeData)
--[[for k,v in ipairs(result) do
	print(k,v.wight)
end--]]

