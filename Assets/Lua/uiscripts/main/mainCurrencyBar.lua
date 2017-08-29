ui_mainCurrencyBar = {
	cPARENT = "UIRoot/BackGroundRoot/ui_main_panel/ui_main",
	-- 1136x640分辨率相对坐标
	cLocalPosition = Vector3(106,293,0),
	bIsInitialed = false,
}

local m = ui_mainCurrencyBar

function ui_mainCurrencyBar.initView()
	m.root = GameObjectExtension.InstantiateFromPacket("ui_resident", "Widget_Currency", UnityEngine.GameObject.Find(m.cPARENT)).gameObject
	m.root.transform.localPosition = m.cLocalPosition
	m.root.name = "Widget_Currency"
	m.Gold = m.root.transform:Find("sGoldContainer/lGold").gameObject:GetComponent(typeof(UILabel))
	m.Diamond = m.root.transform:Find("sDiamondContainer/lDiamond").gameObject:GetComponent(typeof(UILabel))
	m.btn_Diamond = m.root.transform:Find("sDiamondContainer/bDiamond").gameObject

	local collider = m.btn_Diamond:AddComponent(typeof(UnityEngine.BoxCollider))
	collider.isTrigger = true
	collider.center = Vector3.zero
	collider.size = Vector3(collider.gameObject:GetComponent(typeof(UIWidget)).localSize.x,collider.gameObject:GetComponent(typeof(UIWidget)).localSize.y,0) 

	UIEventListener.Get(m.btn_Diamond).onClick = function()
			-- TODO: 购买钻石
		end

	m.bIsInitialed = true
end
--@Des 刷新货币显示
function ui_mainCurrencyBar.updateCurrencyView()
	m.Gold.text = currencyModel:getCurrentTbl().gold
	m.Diamond.text = currencyModel:getCurrentTbl().diamond
end
--@Des 全局入口
function ui_mainCurrencyBar.show()
	if m.bIsInitialed then
		m.root:SetActive(true)
	else
		m.initView()
		m.root:SetActive(true)
		m.updateCurrencyView()
	end
end

function ui_mainCurrencyBar.hide()
	m.root:SetActive(false)
end
--@Des 清理货币UI,释放内存
function ui_mainCurrencyBar.destroy()
	UnityEngine.GameObject.Destroy(m.root)
	ui_mainCurrencyBar = nil
end

return ui_mainCurrencyBar