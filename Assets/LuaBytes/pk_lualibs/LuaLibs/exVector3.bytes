--region *.lua
--Date 20150813
--扩展Vector3方法

--- <summary>
--- 原点常量
--- </summary>
--- <returns type="Vector3"></returns>
function Vector3.Zero() return Vector3.new() end

--- <summary>
--- 单位值常量
--- </summary>
--- <returns type="Vector3"></returns>
function Vector3.One() return Vector3.new(1,1,1) end


--- <summary>
--- 从一个字符串初始化Vector3对象
--- v3str : string x,y,z
--- </summary>
--- <returns type="Vector3"></returns>
function Vector3.FromString(v3str)
	if(v3str==nil) then return nil end
	local v3array = string.split(v3str,",")
	if(v3array==nil or #v3array~=3) then return nil end
	return Vector3.new(
		tonumber(v3array[1]),
		tonumber(v3array[2]),
		tonumber(v3array[3])
	)
end
--endregion
