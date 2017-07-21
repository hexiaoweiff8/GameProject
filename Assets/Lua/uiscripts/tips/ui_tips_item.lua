ui_tips_item = {
	cPARENT = "UIRoot/FlyRoot",
	bIsInitialed = false,
	bIsShowing = false,
}
local m = ui_tips_item
--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
--@Des  显示一个道具Tips
--@Params itemData:仓库Model中保存的Item复合数据
--		  localPosition:显示在屏幕上的相对坐标
--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
function ui_tips_item.Show(itemData,localPosition)
	-- 参数有效性检查
	if not itemData.id and not itemData["Name"] then
		error("检查参数#1 itemData传递是否正确")
		return
	end
	localPosition = localPosition or Vector3.zero
	-- 是否已经初始化
	if not m.bIsInitialed then
		m:initView()
	elseif not m.root.activeInHierarchy then
		m.root:SetActive(true)
	end
	-- 显示层级
	local parent = UnityEngine.GameObject.Find(m.cPARENT).transform
	m.root.transform:SetParent(parent)
    m.root.transform.localPosition = localPosition
    m.root.transform.localScale = Vector3.one
    -- 界面数据适配
    -- TODO: 道具/货币显示持有
	local _Name = itemData["Name"]
	local _Count = require('uiscripts/cangku/wnd_cangku_model'):getServItemCountByItemID(itemData["ItemID"])
	local _FunctionDes = itemData["FunctionDes"]
	local _Icon = itemData["Icon"]
	local _Quality = itemData["Quality"]
	local _SaleGold = itemData["SaleGold"]

	m.Item_icon.spriteName = _Icon
	m.Item_frame.spriteName,m.Item_layer.spriteName = require('uiscripts/shop/wnd_shop_model'):getQualitySpriteStr(_Quality)
	if itemData["ComposeNum"] ~= -1 then
		m.Composite_mark:SetActive(true)
	else
		m.Composite_mark:SetActive(false)
	end
	-- 时装碎片性别显示处理
	if itemData["UseType"] == 2 then
		local Male,Female = require('uiscripts/cangku/wnd_cangku_controller'):analysisFashionFragmentStr(_Name)
		_Name = (userModel:getUserRoleTbl().sex == 0 and {Male} or {Female})[1]
	end
	m.Item_name.text = _Name
	m.Item_count.text = sdata_UILiteral.mData.body[0xFF01][sdata_UILiteral.mFieldName2Index["Literal"]].._Count
	m.Item_description.text = _FunctionDes
	
	if _SaleGold == -1 then
		m.Item_soldTools:SetActive(false)
	else
		m.Item_soldTools:SetActive(true)
		m.Item_price.text = _SaleGold
	end
	-- 标志位
	m.bIsShowing = true
end
--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
--@Des  隐藏此道具Tips实例
--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
function ui_tips_item.Hide()
	if m.root.activeInHierarchy then
		m.root:SetActive(false)
		m.bIsShowing = false
	end
end

function ui_tips_item:initView()
	self.root = GameObjectExtension.InstantiateFromPacket("ui_tips", "ui_tips_item", nil).gameObject
	self.root.name = "ui_tips_item"
	self.Item_icon = self.root.transform:Find("pItem/Icon").gameObject:GetComponent(typeof(UISprite))
	self.Item_layer = self.root.transform:Find("pItem/Icon_Layer").gameObject:GetComponent(typeof(UISprite))
	self.Item_frame = self.root.transform:Find("pItem/Icon_Frame").gameObject:GetComponent(typeof(UISprite))
	self.Composite_mark = self.root.transform:Find("pItem/Composite_mark").gameObject
	self.Item_name = self.root.transform:Find("Item_name").gameObject:GetComponent(typeof(UILabel))
	self.Item_count = self.root.transform:Find("Item_count").gameObject:GetComponent(typeof(UILabel))
	self.Item_description = self.root.transform:Find("Item_description").gameObject:GetComponent(typeof(UILabel))
	self.Item_soldTools = self.root.transform:Find("Label_Container").gameObject
	self.Item_price = self.root.transform:Find("Label_Container/Label_price").gameObject:GetComponent(typeof(UILabel))
	self.bIsInitialed = true
end

return ui_tips_item