--lua 表模拟的 csv 格式读取类
luacsv = classWC()

keytype = {
	int = 1,
	str = 2,
}

function luacsv:ctor(data)	
	self.mFieldName2Index = {}
	self.mData = data
	
	local index = 1
	--建立字段名到字段的索引
	for k, v in ipairs(self.mData.head) do
		self.mFieldName2Index[v] = index
		self["I_"..v] = index
		--print("luacsv","I_"..v,index)
		index = index+1
	end	
	
	self.keytype = data.info.keytype
end

--将字段名转换为索引号
function luacsv:Name2I(name)
	return self.mFieldName2Index[name]
end

--判断表中是否包含该字段
function luacsv:IsHaveCloumName(name)
	if self.mFieldName2Index[name] then
		return true
	end
	return false
end
--[[
function luacsv:GKey(key)
	if(self.keytype==keytype.int) then
		return "i"..key
	else
		return key
	end
	
end
--]]

--获取字段值
function luacsv:GetFieldV(cloumName,key)
	return self.mData.body[key][self:Name2I(cloumName)]
end

--获取字段值,根据列索引
function luacsv:GetV(cloumIdx,key)
	return self.mData.body[key][cloumIdx]
end

--获取整行数据
function luacsv:GetRow(key)
	return self.mData.body[key]
end

function luacsv:Foreach(func)
	local eachfunc = function(key, value)
		func(key,value)
	end
	table.foreach(self.mData.body,eachfunc)
end

---[[获取用户等级/经验对应lv
function luacsv:a(cloumIdx,num)
	for key,v in pairs(self.mData.body) do
		local num1 = self.mData.body[key][cloumIdx]
		if self.mData.body[key+1] then
			local num2 = self.mData.body[key+1][cloumIdx]
			if num1 <=num and num <num2 then
				return key
			end
		end
	end
end
--]]