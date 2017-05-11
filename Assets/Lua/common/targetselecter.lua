-- 目标选择器

local targetSelecter = {}

-- targetDataList - 传入目标列表(规格化的数据)
-- return - 根据数据获取被选中列表
function SelectTarget(targetDataList)
	for i, target in targetDataList
		do
		pring(i, target)
	end
end
fruits = {"banana","orange","apple"}
SelectTarget(fruits)
