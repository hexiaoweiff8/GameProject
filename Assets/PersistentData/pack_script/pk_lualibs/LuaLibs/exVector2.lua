--region *.lua
--Date 20150914
--扩展Vector2方法


--- <summary>
--- 原点常量
--- </summary>
--- <returns type="Vector2"></returns>
function Vector2.Zero() return Vector2.new() end

--- <summary>
--- 单位值常量
--- </summary>
--- <returns type="Vector2"></returns>
function Vector2.One() return  Vector2.new(1,1) end



--- <summary>
--- 从一个字符串初始化Vector2对象
--- v3str : string x,y
--- </summary>
--- <returns type="Vector2"></returns>
function Vector2.FromString(v2str)
	if(v2str==nil) then return nil end
	local v2array = string.split(v2str,",")
	if(v2array==nil or #v2array~=2) then return nil end
	return Vector2.new(
		tonumber(v2array[1]),
		tonumber(v2array[2])
	)
end

--endregion
