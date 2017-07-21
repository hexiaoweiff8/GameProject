--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
--header
--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
wnd_cangku_view = {

	-- ui_cangku Component
	Button_back,

	-- Panel (inc Panel.panel.gameObject)
	Panel_Tab = {
		TabButtons = {},
		sTabTop,
	},
	Panel_depository = {
		ListView,
	},
	Panel_Detail_item = {
		Label_name,
		Item_count,
		Item_icon,
		Item_frame,
		Label_tips,
		Label_description,
		Button_path,--途径按钮
		Sprite_Container,--工具条背景
		Label_Container,--出售金币控件
		Label_sellCoins,--出售后所获得的金币数
		Button_jian,
		Button_jia,
		Button_max,
		Label_count,
		Button_use,
		Button_sale,
	},
	Panel_Detail_equipment = {
		Button_decomposition,
		Button_share,
		Button_commander,
		Item_icon,
		Label_name,
		Label_nextLevel,-- 下一级加成
		Label_MainAttribute,-- 主属性
		Label_ViceAttribute,-- 副属性
		Label_SuitEffect,-- 套装影响
		Label_plus_cost,-- 升级所需货币
		Button_lock,
		Button_unload,
		Button_plus,
	},
	Panel_Detail_decomposition = {
		Button_close,
		Checkbox = {
			Button_white,
			Button_green,
			Button_blue,
			Button_purple,
			Button_golden,
			Button_red,
		},
		Label_decomposition_tips,
		Label_res,
		Label_decomposition_normal_cost,
		Label_decomposition_perfect_cost,
		Button_decomposition_normal,
		Button_decomposition_perfect,
	},
	-- MessageBox
	MessageBox = {
		mBox = {
			Label,
			Button_back,
		},
		mBox_decomposition_tips = {
			Button_back,
			Button_confirm,
			Label_tips,
			Label_confirm_tips,
			Label_cost,
			Label_energy,
		},
		mBox_decomposition_detail_tips = {
			Button_back,
			Button_confirm,
			Button_perfect,
			Label_tips,
			Label_tips_2,
			Label_confirm_tips,
			Label_cost_normal,
			Label_cost_perfect,
			Label_energy_normal,
			Label_energy_perfect,
		},
		mBox_chestBox = {
			Button_back,
			Button_confirm,
			Items = {
				item_1,
				item_2,
				item_3,
				item_4,
				item_5,
			},
		},
	},-- MessageBox

	-- Panel_Tab prefabs
	pButton_yeka,
	pSprite_yekafengexian,

	-- Panel_depository prefabs
	pItem,
	pItem_empty,
	-- Panel_depository Item Component
	cItem,
	cEquipment,

	-- function
	initView,
	initCollider,--根据UI控件的Size属性，动态添加按钮碰撞
}

local this = wnd_cangku_view

local model = nil

--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
--function def
--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■

function wnd_cangku_view:initView(root)
	self = root

	model = self.model

	--★测试用Atlas
	items_Atlas = self.transform:Find("ui_cangku_Prefabs/items_Atlas").gameObject:GetComponent(typeof(UIAtlas))
	equipment_Atlas = self.transform:Find("ui_cangku_Prefabs/equipment_Atlas").gameObject:GetComponent(typeof(UIAtlas))

	--★ui_cangku Main
	this.Button_back = self.transform:Find("Button_back").gameObject

	--★ui_cangku Panel_Tab
	this.pButton_yeka = self.transform:Find("Panel_Tab/Widget_Tab/pButton").gameObject
	this.Panel_Tab.sTabTop = self.transform:Find("Panel_Tab/Widget_Tab/sTabTop").gameObject

	--★ui_cangku Panel_depository	
	this.Panel_depository = {
		ListView = self.transform:Find("Panel_depository/ListView").gameObject,
	}
	this.Panel_depository.panel = self.transform:Find("Panel_depository").gameObject

	--★ui_cangku Panel_Detail_item
	this.Panel_Detail_item = {
		Label_name = self.transform:Find("Panel_Detail_item/Widget_DetailContainer/Label_name").gameObject,
		Item_count = self.transform:Find("Panel_Detail_item/Widget_DetailContainer/Item_count").gameObject,
		Item_icon = self.transform:Find("Panel_Detail_item/Widget_DetailContainer/Item_icon").gameObject,
		Item_frame = self.transform:Find("Panel_Detail_item/Widget_DetailContainer/Item_icon/Item_Frame").gameObject,
		Label_tips = self.transform:Find("Panel_Detail_item/Widget_DetailContainer/Label_tips").gameObject,
		Label_description = self.transform:Find("Panel_Detail_item/Widget_DetailContainer/Label_description").gameObject,
		Button_path = self.transform:Find("Panel_Detail_item/Widget_DetailContainer/Button_path").gameObject,

		Sprite_Container = self.transform:Find("Panel_Detail_item/Widget_DetailContainer/Sprite_Container").gameObject,
		Label_Container = self.transform:Find("Panel_Detail_item/Widget_DetailContainer/Label_Container").gameObject,
		Label_sellCoins = self.transform:Find("Panel_Detail_item/Widget_DetailContainer/Label_Container/Label_sellCoins").gameObject,
		Button_jian = self.transform:Find("Panel_Detail_item/Widget_DetailContainer/Sprite_Container/Button_jian").gameObject,
		Button_jia = self.transform:Find("Panel_Detail_item/Widget_DetailContainer/Sprite_Container/Button_jia").gameObject,
		Button_max = self.transform:Find("Panel_Detail_item/Widget_DetailContainer/Sprite_Container/Button_max").gameObject,
		Label_count = self.transform:Find("Panel_Detail_item/Widget_DetailContainer/Sprite_Container/Label_count").gameObject,
		Button_use = self.transform:Find("Panel_Detail_item/Widget_DetailContainer/Button_use").gameObject,
		Button_sale = self.transform:Find("Panel_Detail_item/Widget_DetailContainer/Button_sale").gameObject,
	}
	this.Panel_Detail_item.panel = self.transform:Find("Panel_Detail_item").gameObject

	--★ui_cangku Panel_Detail_equipment	
	equipDetail = require('uiscripts/commonGameObj/equipDetail/equipDetail_controller')
	equipDetail:initialize()
	local equipDetail_view = equipDetail:get_View()
	this.Panel_Detail_equipment = {
		Button_decomposition = equipDetail_view.btn_decomposition,
		Button_share = equipDetail_view.btn_share,
		Button_commander = equipDetail_view.btn_commander,
		Item_icon = equipDetail_view.equipIcon,
		Label_name = equipDetail_view.equipNameLab,
		Label_nextLevel = equipDetail_view.lab_nextLevel,
		Label_MainAttribute = equipDetail_view.lab_mainAttribute,
		Label_ViceAttribute = equipDetail_view.lab_subAttribute,
		Label_SuitEffect = equipDetail_view.lab_suitEffect,
		Label_plus_cost = equipDetail_view.costLab,
		Button_lock = equipDetail_view.btn_lock,
		Button_unload = equipDetail_view.btn_loadOrNot,
		Button_plus = equipDetail_view.btn_plus,
	}
	this.Panel_Detail_equipment.panel = self.transform:Find("Panel_Detail_equipment").gameObject

	--★ui_cangku Panel_Detail_decomposition
	this.Panel_Detail_decomposition = {
		Button_close = self.transform:Find("Panel_Detail_decomposition/Button_close").gameObject,
		Checkbox = {
			Button_white = self.transform:Find("Panel_Detail_decomposition/Widget_DetailContainer/Checkbox/Sprite_white").gameObject,
			Button_green = self.transform:Find("Panel_Detail_decomposition/Widget_DetailContainer/Checkbox/Sprite_green").gameObject,
			Button_blue = self.transform:Find("Panel_Detail_decomposition/Widget_DetailContainer/Checkbox/Sprite_blue").gameObject,
			Button_purple = self.transform:Find("Panel_Detail_decomposition/Widget_DetailContainer/Checkbox/Sprite_purple").gameObject,
			Button_golden = self.transform:Find("Panel_Detail_decomposition/Widget_DetailContainer/Checkbox/Sprite_golden").gameObject,
			Button_red = self.transform:Find("Panel_Detail_decomposition/Widget_DetailContainer/Checkbox/Sprite_red").gameObject,
		},
		Label_decomposition_tips = self.transform:Find("Panel_Detail_decomposition/Widget_DetailContainer/Label_decomposition_tips").gameObject,
		Label_res = self.transform:Find("Panel_Detail_decomposition/Widget_DetailContainer/Sprite_res/Label_res").gameObject,
		Label_decomposition_normal_cost = self.transform:Find("Panel_Detail_decomposition/Widget_DetailContainer/Sprite_decomposition_normal_cost/Label_decomposition_normal_cost").gameObject,
		Label_decomposition_perfect_cost = self.transform:Find("Panel_Detail_decomposition/Widget_DetailContainer/Sprite_decomposition_perfect_cost/Label_decomposition_perfect_cost").gameObject,
		Button_decomposition_normal = self.transform:Find("Panel_Detail_decomposition/Widget_DetailContainer/Button_decomposition_normal").gameObject,
		Button_decomposition_perfect = self.transform:Find("Panel_Detail_decomposition/Widget_DetailContainer/Button_decomposition_perfect").gameObject,
	}
	this.Panel_Detail_decomposition.panel = self.transform:Find("Panel_Detail_decomposition").gameObject

	--★ui_cangku MessageBox
	this.MessageBox.panel = self.transform:Find("MessageBox").gameObject

	this.MessageBox.mBox = {
			Label = self.transform:Find("MessageBox/mBox/Label").gameObject,
			Button_back = self.transform:Find("MessageBox/mBox/Button_back").gameObject,
		}
	this.MessageBox.mBox.panel = self.transform:Find("MessageBox/mBox").gameObject

	this.MessageBox.mBox_decomposition_tips = {
			Button_back = self.transform:Find("MessageBox/mBox_decomposition_tips/Button_back").gameObject,
			Button_confirm = self.transform:Find("MessageBox/mBox_decomposition_tips/Button_confirm").gameObject,
			Label_tips = self.transform:Find("MessageBox/mBox_decomposition_tips/Label_tips").gameObject,
			Label_confirm_tips = self.transform:Find("MessageBox/mBox_decomposition_tips/Label_confirm_tips").gameObject,
			Label_cost = self.transform:Find("MessageBox/mBox_decomposition_tips/Sprite_cost/Label_cost").gameObject,
			Label_energy = self.transform:Find("MessageBox/mBox_decomposition_tips/Container/Label_energy").gameObject,
		}
	this.MessageBox.mBox_decomposition_tips.panel = self.transform:Find("MessageBox/mBox_decomposition_tips").gameObject
	
	this.MessageBox.mBox_decomposition_detail_tips = {
			Button_back = self.transform:Find("MessageBox/mBox_decomposition_detail_tips/").gameObject,
			Button_confirm = self.transform:Find("MessageBox/mBox_decomposition_detail_tips/Button_confirm").gameObject,
			Button_perfect = self.transform:Find("MessageBox/mBox_decomposition_detail_tips/Button_perfect").gameObject,
			Label_tips = self.transform:Find("MessageBox/mBox_decomposition_detail_tips/Label_tips").gameObject,
			Label_tips_2 = self.transform:Find("MessageBox/mBox_decomposition_detail_tips/Label_tips_2").gameObject,
			Label_confirm_tips = self.transform:Find("MessageBox/mBox_decomposition_detail_tips/Label_confirm_tips").gameObject,
			Label_cost_normal = self.transform:Find("MessageBox/mBox_decomposition_detail_tips/Sprite_cost_normal/Label_cost_normal").gameObject,
			Label_cost_perfect = self.transform:Find("MessageBox/mBox_decomposition_detail_tips/Sprite_cost_perfect/Label_cost_perfect").gameObject,
			Label_energy_normal = self.transform:Find("MessageBox/mBox_decomposition_detail_tips/Container/Label_energy").gameObject,
			Label_energy_perfect = self.transform:Find("MessageBox/mBox_decomposition_detail_tips/Container_2/Label_energy").gameObject,
		}
	this.MessageBox.mBox_decomposition_detail_tips.panel = self.transform:Find("MessageBox/mBox_decomposition_detail_tips").gameObject
	
	this.MessageBox.mBox_chestBox = {
			Button_back = self.transform:Find("MessageBox/mBox_chestBox/Button_back").gameObject,
			Button_confirm = self.transform:Find("MessageBox/mBox_chestBox/Button_confirm").gameObject,
			Items = {
				item_1 = self.transform:Find("MessageBox/mBox_chestBox/Items/item_1").gameObject,
				item_2 = self.transform:Find("MessageBox/mBox_chestBox/Items/item_2").gameObject,
				item_3 = self.transform:Find("MessageBox/mBox_chestBox/Items/item_3").gameObject,
				item_4 = self.transform:Find("MessageBox/mBox_chestBox/Items/item_4").gameObject,
				item_5 = self.transform:Find("MessageBox/mBox_chestBox/Items/item_5").gameObject,
			},
		}
	this.MessageBox.mBox_chestBox.panel = self.transform:Find("MessageBox/mBox_chestBox").gameObject

	--★ui_cangku Panel_depository prefabs
	this.pItem = self.transform:Find("ui_cangku_Prefabs/pItem").gameObject
	this.pItem_empty = self.transform:Find("ui_cangku_Prefabs/pItem_empty").gameObject

	--★ui_cangku Panel_depository Item Component
	this.cItem = self.transform:Find("ui_cangku_Prefabs/Item").gameObject
	this.cEquipment = self.transform:Find("ui_cangku_Prefabs/Equipment").gameObject
	
	--★end FindView
	self = mself
end

function wnd_cangku_view:initCollider()

	local colliders = {}

	table.insert(colliders,this.Button_back)

	for i = 1,model.DepositoryTab_Count do
		table.insert(colliders,this.Panel_Tab.TabButtons[i])
	end

	table.insert(colliders,this.Panel_depository.Button_decomposition)

	table.insert(colliders,this.Panel_Detail_item.Button_path)
	table.insert(colliders,this.Panel_Detail_item.Button_jian)
	table.insert(colliders,this.Panel_Detail_item.Button_jia)
	table.insert(colliders,this.Panel_Detail_item.Button_max)
	table.insert(colliders,this.Panel_Detail_item.Button_use)
	table.insert(colliders,this.Panel_Detail_item.Button_sale)

	table.insert(colliders,this.Panel_Detail_equipment.Button_decomposition)
	table.insert(colliders,this.Panel_Detail_equipment.Button_share)
	table.insert(colliders,this.Panel_Detail_equipment.Button_commander)
	table.insert(colliders,this.Panel_Detail_equipment.Button_lock)
	table.insert(colliders,this.Panel_Detail_equipment.Button_unload)
	table.insert(colliders,this.Panel_Detail_equipment.Button_plus)

	table.insert(colliders,this.Panel_Detail_decomposition.Button_close)
	table.insert(colliders,this.Panel_Detail_decomposition.Checkbox.Button_white)
	table.insert(colliders,this.Panel_Detail_decomposition.Checkbox.Button_green)
	table.insert(colliders,this.Panel_Detail_decomposition.Checkbox.Button_blue)
	table.insert(colliders,this.Panel_Detail_decomposition.Checkbox.Button_purple)
	table.insert(colliders,this.Panel_Detail_decomposition.Checkbox.Button_golden)
	table.insert(colliders,this.Panel_Detail_decomposition.Checkbox.Button_red)
	table.insert(colliders,this.Panel_Detail_decomposition.Button_decomposition_normal)
	table.insert(colliders,this.Panel_Detail_decomposition.Button_decomposition_perfect)

	table.insert(colliders,this.MessageBox.mBox_decomposition_tips.Button_back)
	table.insert(colliders,this.MessageBox.mBox_decomposition_tips.Button_confirm)

	table.insert(colliders,this.MessageBox.mBox_decomposition_detail_tips.Button_back)	
	table.insert(colliders,this.MessageBox.mBox_decomposition_detail_tips.Button_confirm)
	table.insert(colliders,this.MessageBox.mBox_decomposition_detail_tips.Button_perfect)

	table.insert(colliders,this.MessageBox.mBox_chestBox.Button_back)
	table.insert(colliders,this.MessageBox.mBox_chestBox.Button_confirm)
	table.insert(colliders,this.MessageBox.mBox_chestBox.Items.Button_back)
	table.insert(colliders,this.MessageBox.mBox_chestBox.Items.item_1)
	table.insert(colliders,this.MessageBox.mBox_chestBox.Items.item_2)
	table.insert(colliders,this.MessageBox.mBox_chestBox.Items.item_3)
	table.insert(colliders,this.MessageBox.mBox_chestBox.Items.item_4)
	table.insert(colliders,this.MessageBox.mBox_chestBox.Items.item_5)

	table.insert(colliders,this.MessageBox.mBox.Button_back)

	for index,button in pairs(colliders) do

		collider = button:AddComponent(typeof(UnityEngine.BoxCollider))

		collider.isTrigger = true
		collider.center = Vector3.zero
		collider.size = Vector3(collider.gameObject:GetComponent(typeof(UIWidget)).localSize.x,collider.gameObject:GetComponent(typeof(UIWidget)).localSize.y,0) 

	end

end

return wnd_cangku_view