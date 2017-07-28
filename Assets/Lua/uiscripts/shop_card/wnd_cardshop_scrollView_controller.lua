--[[
	Rev.2017-07-25
	wnd_cardshop_ScrollView_controller:
		variable:
			_scrollView
			_scrollViewItem
			currentList -- table* scrollview内容表指针

		function:
			init() 初始化scrollview界面
			HandleOnItemLoadedHandler() 回调，加载列表项时被执行
			ToggleIndicator() 切换升级指示器显示
]]
wnd_cardshop_ScrollView_controller = {}

local this = wnd_cardshop_ScrollView_controller
local ctrl,model,view

this.currentList = {}
this.tweeningList = {}

--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
--function def
--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
function wnd_cardshop_ScrollView_controller:init(Ctrl)
	ctrl = Ctrl
	model = Ctrl.model
	view = Ctrl.view

	_scrollView = view.Panel_ShoppingList:GetComponent(typeof(UIScrollViewAdapter))	
	_scrollViewItem = this:initScrollViewItem()

	_scrollView.onItemLoaded = function(go)
		this:HandleOnItemLoadedHandler(go)
	end

	_scrollView:Create(0,_scrollViewItem)

	_scrollViewItem.gameObject:SetActive(false)
end

function wnd_cardshop_ScrollView_controller:initScrollViewItem()
	local Item = view.pShopItem:AddComponent(typeof(UIScrollViewItemBase))

	Item._widgetTransform = view.pShopItem:GetComponent(typeof(UIWidget))

	Item.gameObject:AddComponent(typeof(UIDragScrollView))
	Item.transform.localPosition = Vector3(0,0,0)

	local btn_buy_sprite = Item.transform:Find("btn_buy").gameObject:GetComponent(typeof(UISprite))

	local collider = btn_buy_sprite.gameObject:AddComponent(typeof(UnityEngine.BoxCollider))

	collider.isTrigger = true
	collider.center = Vector3.zero
	collider.size = Vector3(btn_buy_sprite.localSize.x,btn_buy_sprite.localSize.y,0)

	local btn_info_sprite = Item.transform:Find("Item_info").gameObject:GetComponent(typeof(UISprite))

	local collider = btn_info_sprite.gameObject:AddComponent(typeof(UnityEngine.BoxCollider))

	collider.isTrigger = true
	collider.center = Vector3.zero
	collider.size = Vector3(btn_info_sprite.localSize.x,btn_info_sprite.localSize.y,0)

	return Item 
end

function wnd_cardshop_ScrollView_controller:HandleOnItemLoadedHandler(item)

	if item.Index + 1 <= #this.currentList then
		local isEnabled = (cardModel:getCardNum(this.currentList[item.Index + 1]['ArmyCardID']) == nil and {false} or {true})[1]

		item.gameObject.name = this.currentList[item.Index + 1]['ArmyCardID']

		-- DONE: 如果该卡牌未激活,显示为灰色
		if cardModel:getCardByID(this.currentList[item.Index + 1]['ArmyCardID']) == nil then
			item.transform:Find("Item_Inactived").gameObject:GetComponent(typeof(UISprite)).spriteName
			 = cstr.CARD_INACTIVE
			item.transform:Find("Process").gameObject:SetActive(false)
		else
			item.transform:Find("Item_Inactived").gameObject:GetComponent(typeof(UISprite)).spriteName
			 = 'nil'
			 item.transform:Find("Process").gameObject:SetActive(true)
		end
		
		item.transform:Find("Item_icon").gameObject:GetComponent(typeof(UISprite)).spriteName
			 = this.currentList[item.Index + 1]['IconID']
		item.transform:Find("Item_name").gameObject:GetComponent(typeof(UILabel)).text
			 = this.currentList[item.Index + 1]['Name']
		-- 计算累计增长的价格
		-- DONE: 如果价格大于当前货币,则显示为红色
		this:RefreshPriceDisplay(item)
		-- 货币类型图标显示,根据Type(Field)字段查询Currency表
		item.transform:Find("Item_value/sCoin").gameObject:GetComponent(typeof(UISprite)).spriteName
			 = wnd_shop_model:getShopCurrencyIconByField(this.currentList[item.Index + 1]['Type'])

		local btn_buy = item.transform:Find("btn_buy").gameObject
		UIEventListener.Get(btn_buy).onClick = function(go)
			-- 如果卡牌处于激活状态
			if isEnabled then
				local price = this.currentList[item.Index + 1]['BasePrice'] + this.currentList[item.Index + 1]['UpPrice'] * 
					 cardModel:getCardBuy(this.currentList[item.Index + 1]['ArmyCardID'])
				if ctrl:HaveEnoughMoney2Buy(price,this.currentList[item.Index + 1]['Type']) then
					ctrl:BuyCard(this.currentList[item.Index + 1]['ArmyCardID'],item)
				else
					UIToast.Show("点数不足,无法购买",nil,UIToast.ShowType.Upwards)
				end
			else
				UIToast.Show("卡牌未激活,无法购买",nil,UIToast.ShowType.Upwards)
			end
		end
		-- TODO: info按钮功能未定义
		local btn_info = item.transform:Find("Item_info").gameObject
		UIEventListener.Get(btn_info).onClick = function(go)
			print('显示id:'..go.name.."相关信息")
		end
	end
end
--@Desc 切换商店列表
function wnd_cardshop_ScrollView_controller:filterBy(ShopType)
	if not table.containKey(model.local_ShoppingList,ShopType) then
		error("该商品类型列表为nil ShopType:"..ShopType)
	end
	this.currentList = model.local_ShoppingList[ShopType]
	_scrollView:Reload(#this.currentList)

	-- this:ToggleIndicator()
end
--@Desc 刷新卡牌货币显示
function wnd_cardshop_ScrollView_controller:RefreshPriceDisplay(item)
	-- print("购买次数："..cardModel:getCardBuy(this.currentList[item.Index + 1]['ArmyCardID']))
	local price = this.currentList[item.Index + 1]['BasePrice'] + this.currentList[item.Index + 1]['UpPrice'] * 
			 cardModel:getCardBuy(this.currentList[item.Index + 1]['ArmyCardID'])
	if ctrl:HaveEnoughMoney2Buy(price,this.currentList[item.Index + 1]['Type']) then
		item.transform:Find("Item_value/Item_cost").gameObject:GetComponent(typeof(UILabel)).text
			 = '[FFFFFF]'..price..'[-]'
	else 
		item.transform:Find("Item_value/Item_cost").gameObject:GetComponent(typeof(UILabel)).text
			 = '[FF0000]'..price..'[-]'
	end
end
--@Desc 切换升级指示器显示
function wnd_cardshop_ScrollView_controller:ToggleIndicator()
	local Contents = ctrl.transform:Find("Panel_ShopList/ListView/Contents")
	for i = 0,Contents.childCount - 1,1 do
		local indicator = Contents:GetChild(i):Find("Process/LevelUp_Indicator").gameObject:GetComponent(typeof(UISprite))
		local processBar = Contents:GetChild(i):Find("Process/ProcessBar/foreground").gameObject:GetComponent(typeof(UISprite))
		local slider = Contents:GetChild(i):Find("Process/ProcessBar").gameObject:GetComponent(typeof(UISlider))
		local process = Contents:GetChild(i):Find("Process/ProcessBar/lProcess").gameObject:GetComponent(typeof(UILabel))

		local cardData = cardModel:getCardByID(tonumber(Contents:GetChild(i).name))

		if indicator.spriteName == cstr.FLAG_STAR or 
			indicator.spriteName == cstr.FLAG_STAR_ENOUGH then
			if cardData ~= nil then
				-- 从升星切换到升卡牌
				local cardUpNeed = soldierUtil:getUpSoldierNeedCardNum(cardData.slv)
				-- 图标
				if cardData.num >= cardUpNeed then
					indicator.spriteName = cstr.FLAG_CARD_ENOUGH
				else
					indicator.spriteName = cstr.FLAG_CARD
				end
				-- 进度条
				processBar.spriteName = cstr.CARD_LEVELUP
				-- 进度条值
				slider.value = cardData.num / cardUpNeed
				-- 进度文本
				process.text = cardData.num..'/'..cardUpNeed
			else
				-- 解决状态不同步问题
				indicator.spriteName = cstr.FLAG_CARD
			end
		else
			if cardData ~= nil then
				-- 从升卡牌切换到升星
				local starUpNeed = starUtil:getUpStarNeedFragment(cardData.star)
				-- 图标
				if cardData.num >= starUpNeed then
					indicator.spriteName = cstr.FLAG_STAR_ENOUGH
				else
					indicator.spriteName = cstr.FLAG_STAR
				end
				-- 进度条
				processBar.spriteName = cstr.STAR_LEVELUP
				-- 进度条值
				slider.value = cardData.num / starUpNeed
				-- 进度文本
				process.text = cardData.num..'/'..starUpNeed
			else
				indicator.spriteName = cstr.FLAG_STAR
			end
		end
	end
end
----------------------------------------------------------------
--★AnimeControl
--@Desc 绑定所有淡入淡出动画
function wnd_cardshop_ScrollView_controller:BindingAll()
	local Contents = ctrl.transform:Find("Panel_ShopList/ListView/Contents")
	for i = 0,Contents.childCount - 1,1 do
		local indicator = Contents:GetChild(i):Find("Process/LevelUp_Indicator").gameObject:GetComponent(typeof(UIWidget))
		local processBar = Contents:GetChild(i):Find("Process/ProcessBar/foreground").gameObject:GetComponent(typeof(UIWidget))
		local slider = Contents:GetChild(i):Find("Process/ProcessBar").gameObject:GetComponent(typeof(UIWidget))
		local process = Contents:GetChild(i):Find("Process/ProcessBar/lProcess").gameObject:GetComponent(typeof(UIWidget))

		this:BindingToggleAnime(indicator)
		this:BindingToggleAnime(processBar)
		this:BindingToggleAnime(slider)
		this:BindingToggleAnime(process)
	end
end

function wnd_cardshop_ScrollView_controller:BindingToggleAnime(widget)
	widget.alpha = 0
	local sq = DG.Tweening.DOTween.Sequence()
    local splashTweener = DG.Tweening.DOTween.ToAlpha(
    	function() return widget.color end,
    	 function(color) widget.color = color end,
    	  1, 0.5)
    local fadeTweener = DG.Tweening.DOTween.ToAlpha(
    	function() return widget.color end,
     function(color) widget.color = color end,
	      0, 0.5)

    sq:Append(splashTweener)
    sq:AppendInterval(3)
    sq:Append(fadeTweener)
    -- FIXED:仅在第一个动画过后绑定切换状态回调,而不是所有
    -- TODO:使用number类型代替获取表长度,可能提高绑定执行效率
    if #this.tweeningList == 0 then
    	sq:OnComplete(function() this:ToggleIndicator() sq:Restart(true) end)
    else
    	sq:OnComplete(function() sq:Restart(true) end)
    end
    sq:Pause()

    table.insert(this.tweeningList,sq)
end

function wnd_cardshop_ScrollView_controller:StartAllToggleAnime()
	for _,v in ipairs(this.tweeningList) do
		v:Play()
	end
end

function wnd_cardshop_ScrollView_controller:KillAllToggleAnime()
	for _,v in ipairs(this.tweeningList) do
		v:Kill()
	end
end

return wnd_cardshop_ScrollView_controller