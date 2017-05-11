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
	for k, v in pairs(self.mData.head) do
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