--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

function math.INT(x)
	if x <= 0 then return math.ceil(x) end

	if math.ceil(x) == x then 
		x = math.ceil(x)
	else
		x = math.ceil(x) - 1
	end

	return x;
end

--endregion
