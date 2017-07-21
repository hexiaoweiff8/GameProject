ui_tips_equip = {
	cPARENT = "UIRoot/FlyRoot",
	bIsInitialed = false,
	bIsShowing = false,
}
local m = ui_tips_equip
--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
--@Des  显示一个装备Tips
--@Params equipData:公用装备Model中保存的Equip复合数据
--		  localPosition:显示在屏幕上的相对坐标
--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
function ui_tips_equip.Show(equipData,localPosition)
	-- 参数有效性检查
	if not equipData.id and not equipData["EquipID"] then
		error("检查参数#1 equipData传递是否正确")
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
	local _Name = equipData["EquipName"]
	local _Icon = equipData["EquipIcon"]
	local _Quality = require('uiscripts/shop/wnd_shop_model'):getShopCommodityQualityByDropID(tostring(equipData["EquipID"]))
	local _MainAttr = m:getRandomMainAttrStr(equipData["MainAttribute"])
	local _SuitEffect = '[f15c03]'..
		sdata_equipsuit_data.mData.body[equipData["SuitID"]][sdata_equipsuit_data.mFieldName2Index['SuitName']]..
		'[-]:\n'..
		require('uiscripts/Util/equipUtil'):getEquipmentSuitEffectNormalStr(equipData["SuitID"])

	m.Equip_icon.spriteName = _Icon
	m.Equip_frame.spriteName,m.Equip_layer.spriteName = require('uiscripts/shop/wnd_shop_model'):getQualitySpriteStr(_Quality)
	
	m.Equip_name.text = _Name
	m.Equip_mainAttr.text = _MainAttr
	m.Equip_suitEffect.text = _SuitEffect

	-- 标志位
	m.bIsShowing = true
end
--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
--@Des  隐藏此装备Tips实例
--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
function ui_tips_equip.Hide()
	if m.root.activeInHierarchy then
		m.root:SetActive(false)
		m.bIsShowing = false
	end
end

function ui_tips_equip:initView()
	self.root = GameObjectExtension.InstantiateFromPacket("ui_tips", "ui_tips_equip", nil).gameObject
	self.root.name = "ui_tips_equip"
	self.Equip_icon = self.root.transform:Find("pEquip/Icon").gameObject:GetComponent(typeof(UISprite))
	self.Equip_layer = self.root.transform:Find("pEquip/Icon_Layer").gameObject:GetComponent(typeof(UISprite))
	self.Equip_frame = self.root.transform:Find("pEquip/Icon_Frame").gameObject:GetComponent(typeof(UISprite))
	self.Equip_name = self.root.transform:Find("Equip_name").gameObject:GetComponent(typeof(UILabel))
	self.Equip_mainAttr = self.root.transform:Find("Equip_MainAttr").gameObject:GetComponent(typeof(UILabel))
	self.Equip_suitEffect = self.root.transform:Find("Equip_SuitEffect").gameObject:GetComponent(typeof(UILabel))
	self.bIsInitialed = true
end

--@Params PlanID(I32$MainAttribute)
function ui_tips_equip:getRandomMainAttrStr(PlanID)
	local AttributeIDArray = require('uiscripts/tips/ui_tips_model'):getEquipmentAttributeIDArrayByPlanID(PlanID)
	local AttributeNameArray = {}
	for i = 1,#AttributeIDArray do
		table.insert(AttributeNameArray,sdata_attribute_data.mData.body[AttributeIDArray[i]][sdata_attribute_data.mFieldName2Index['AttributeName']])
	end
	local _str = ''
	local _attrToShowCount = 12
	for i = 1,_attrToShowCount do
		if AttributeNameArray[i] then
			_str = _str..'【[30D6FF]'..AttributeNameArray[i]..'[-]】'
		end
	end
	return string.format(sdata_UILiteral.mData.body[0xFC01][sdata_UILiteral.mFieldName2Index["Literal"]],_str)
end

return ui_tips_equip