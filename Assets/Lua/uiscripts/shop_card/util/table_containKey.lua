--@Desc 表中是否包含指定键(浅度遍历)
--@Params t 要查询的表
--		  key 待查询的键
table.containKey = function(t,key)
	for k,_ in pairs(t) do
		if k == key then
			return true
		end
	end 
	return false
end