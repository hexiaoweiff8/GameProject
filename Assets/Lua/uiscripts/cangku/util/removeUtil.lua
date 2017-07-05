function table.index(tab,value)
	local key
	for k,v in pairs(tab) do 
		if v == value then 
			key = k
			break 
		end 
	end
	return key 
end

function table.removeObject(tab,object)
	for k,v in pairs(tab) do
		if v == object then
			table.remove(tab,k)
			break
		end
	end
end