--@Desc 返回表中不为空的元素个数
--@Params t 要查询的表
table.count = function(t)
	local count = 0
	for k,_ in pairs(t) do
		count = count + 1
	end 
	return count
end