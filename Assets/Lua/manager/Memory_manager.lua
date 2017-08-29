Memory = { }
-- 此实例的require路径
local ref_path = 'manager.Memory_manager'
-- 此类返回的实际表名
local real_tableName = 'Memory'

local MemoryList = package.loaded

--[[
	ReadMe:
		所有使用require('*/*')方式实例化的table都可以使用Memory.free('*/*')去释放,
			当下一次使用require('*/*')去实例化相同文件中的table后将会分配一块新的内存

		Example:
			require("uiscripts/shop_card/wnd_cardshop_view")
				->此时wnd_cardshop_view被分配了一块新的内存0x00000001(假定)

			在需要完全释放wnd_cardshop_view内存的地方调用
			Memory.free("uiscripts/shop_card/wnd_cardshop_view")
				->此时再执行require("uiscripts/shop_card/wnd_cardshop_view")将会在内存中分配一块新的内存0x00000010(假定)
		Issues:
			(1)当引用文件路径的文件名与实际返回的表名不一致的情况下,
				 此内存释放操作可能不会正常工作
			   例如:
			   		uiscripts/Util/equipUtil.lua:
			   			EquipUtil = {...}
			   			return EquipUtil
			   		此种情况下引用文件名equipUtil与实际返回的表名EquipUtil不一致,使用此工具可能不会正常释放驻留内存
]]
Memory.free = function(requirePATH)
	
	assert(type(requirePATH) == 'string',"Memory.free() Param #1 must be require PATH.")

	--@return 用'.'作为分割符的requirePATH,用'/'作为分割符的requirePATH
	local function processPATH(path)
		return string.gsub(path, '/', '.'),string.gsub(path, '%.', '/')
	end

	local path1,path2 = processPATH(requirePATH)

	MemoryList[path1] = nil
	MemoryList._G[path1] = nil
	MemoryList[path2] = nil
	MemoryList._G[path2] = nil
end
--@Des 释放此实例占用的资源
Memory.dispose = function()
	MemoryList[ref_path] = nil
	MemoryList._G[real_tableName] = nil
	MemoryList = nil
	Memory = nil
end

return Memory