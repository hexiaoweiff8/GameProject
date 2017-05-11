--wnd_beibao.lua 背包繫統
--StartDate : 2015/11/09 21:05; DemoEDate : 2015/11/10 21:14;
--FirstDate : 2015/11/11 11:11; FixedDara : 2015/11/16 14:39;
--Note : Nothing ..
--RandyL-LJX


local wnd_beibaoClass = class(wnd_base)

wnd_beibao = nil


-- 全局變量：控制是否刷新，取消
-- EitherRefreshBeiBao = false


--[[
	wnd_beibaoClass :
		self.m_Item		--"item_list/item_scroll/Table/item_container"
						--物品欄的容器下的預設物品框
		self.itemInfo	--"item_info"物品側邊欄

		self.lastMode	--上次顯示的選頁卡
		self.itemCount	--上次材料種類数
		self.heroCount	--上次英雄種類數
		self.armyCount	--上次兵種種類數
		self.lastCount	--上次申請協議所有物品數量
		self.destCount	--上次售空銷毀的物品種類數

--]]


-- Local bag‘s info :
-- 預定義數量16，以減少Lua-Table表的Rehash次數，以增加表的效率
wnd_beibaoClass.TagItem = {
	itemMat  = {
		[1]  = {id = -1, num = ""},
		[2]  = {id = -1, num = ""},
		[3]  = {id = -1, num = ""},
		[4]  = {id = -1, num = ""},
		[5]  = {id = -1, num = ""},
		[6]  = {id = -1, num = ""},
		[7]  = {id = -1, num = ""},
		[8]  = {id = -1, num = ""},
		[9]  = {id = -1, num = ""},
		[10] = {id = -1, num = ""},
		[11] = {id = -1, num = ""},
		[12] = {id = -1, num = ""},
		[13] = {id = -1, num = ""},
		[14] = {id = -1, num = ""},
		[15] = {id = -1, num = ""},
		[16] = {id = -1, num = ""},
		-- ......
		-- [n]  = {id = -1, num = ""},
	},
	itemHSP  = {
		[1]  = {id = -1, num = ""},
		[2]  = {id = -1, num = ""},
		[3]  = {id = -1, num = ""},
		[4]  = {id = -1, num = ""},
		[5]  = {id = -1, num = ""},
		[6]  = {id = -1, num = ""},
		[7]  = {id = -1, num = ""},
		[8]  = {id = -1, num = ""},
		[9]  = {id = -1, num = ""},
		[10] = {id = -1, num = ""},
		[11] = {id = -1, num = ""},
		[12] = {id = -1, num = ""},
		[13] = {id = -1, num = ""},
		[14] = {id = -1, num = ""},
		[15] = {id = -1, num = ""},
		[16] = {id = -1, num = ""},
		-- ......
		-- [n]  = {id = -1, num = ""},
	},
	itemASP  = {
		[1]  = {id = -1, num = ""},
		[2]  = {id = -1, num = ""},
		[3]  = {id = -1, num = ""},
		[4]  = {id = -1, num = ""},
		[5]  = {id = -1, num = ""},
		[6]  = {id = -1, num = ""},
		[7]  = {id = -1, num = ""},
		[8]  = {id = -1, num = ""},
		[9]  = {id = -1, num = ""},
		[10] = {id = -1, num = ""},
		[11] = {id = -1, num = ""},
		[12] = {id = -1, num = ""},
		[13] = {id = -1, num = ""},
		[14] = {id = -1, num = ""},
		[15] = {id = -1, num = ""},
		[16] = {id = -1, num = ""},
		-- ......
		-- [n]  = {id = -1, num = ""},
	},
}


-- 向 PopMenu 傳遞的參數表
wnd_beibaoClass.ParamItem = {
	itemI = 0 ,	--物品Id
	objID = 0 ,	--物品框Id
	sort  = 0 ,	--物品種類 : 0 nil, 1 material, 2 hero, 3 soldier
	name  = "",	--物品名稱
	icon  = "",	--物品圖標
	count = "",	--物品數量
	price = "",	--物品單價
}


function wnd_beibaoClass:Start ()
	wnd_beibao = self
	self:Init (WND.BeiBao, false)

	self.lastMode  = 0
	self.itemCount = 0
	self.heroCount = 0
	self.armyCount = 0
	self.lastCount = 0
	self.destCount = 0

	-- self.destItem  = 0	--銷毀的材料數量
	-- self.destHero  = 0	--銷毀的英雄數量
	-- self.dsetArmy  = 0	--銷毀的兵種數量
end


--[[
	-- 取消交叉初始化改爲每次打開刷新
	function wnd_beibaoClass:CrossInit ()
		EventHandles.OnLoginSuccess:AddListener (self, self.OnLoginSuccess)
	end


	-- Connect the Server : Construct local TagItem :
	function wnd_beibaoClass:OnLoginSuccess ()
		self:FirstGetTagInfo ()
	end


	-- First get the user's bag information :
	function wnd_beibaoClass:FirstGetTagInfo ()
		self:FetchTagInfo ()
	end
--]]


function wnd_beibaoClass:OnNewInstance ()
	-- preset item-label :
	self.m_Item	  = self.instance:FindWidget ("item_list/item_scroll/Table/item_container")
	-- 爲減少實例化物品框減少SetActive ()調用次數
	-- 采用默認/實例化前活動，實例化物品框結束后false
	self.m_Item:SetActive (true)

	-- the preset item_info :
	self.itemInfo = self.instance:FindWidget ("item_info")
	self.itemInfo:SetActive (false)


	-- Initial uilabels :
	do
		-- 全部物品 9078
		self:SetLabel ("tabbtn_inactive/tab_all_i/Label",
			SData_Id2String.Get (9078))
		-- 英雄碎片 9080
		self:SetLabel ("tabbtn_inactive/tab_hero_i/Label",
			SData_Id2String.Get (9080))
		-- 材料碎片 9079
		self:SetLabel ("tabbtn_inactive/tab_item_i/Label",
			SData_Id2String.Get (9079))
		-- 士兵碎片 9081
		self:SetLabel ("tabbtn_inactive/tab_soldier_i/Label",
			SData_Id2String.Get (9081))

		self:SetLabel ("tabbtn_activity/tab_all/Label",
			SData_Id2String.Get (9078))
		self:SetLabel ("tabbtn_activity/tab_hero/Label",
			SData_Id2String.Get (9080))
		self:SetLabel ("tabbtn_activity/tab_item/Label",
			SData_Id2String.Get (9079))
		self:SetLabel ("tabbtn_activity/tab_soldier/Label",
			SData_Id2String.Get (9081))


		-- 出售 9087
		self:SetLabel ("item_info/btn_sell/txt", _TXT (9087))
		-- 詳細信息 9088
		self:SetLabel ("item_info/btn_ditailinfo/txt",
			SData_Id2String.Get (9088))
		-- 物品介紹 9077
		self:SetLabel ("item_info/item_ditailinfo/txt1",
			SData_Id2String.Get (9077))

	end


	-- Bind gameObject of UIAtributePage UIEvent :
	self:BindUIEvent ("tabbtn_inactive/tab_all_i", UIEventType.Click, "OnAllClick")
	self:BindUIEvent ("tabbtn_inactive/tab_hero_i", UIEventType.Click, "OnHeroClick")
	self:BindUIEvent ("tabbtn_inactive/tab_item_i", UIEventType.Click, "OnItemClick")
	self:BindUIEvent ("tabbtn_inactive/tab_soldier_i", UIEventType.Click, "OnSoldierClick")


	-- Item-Info Pabel :
	self:BindUIEvent ("item_info/btn_sell", UIEventType.Click, "GotoSellPanel")
	self:BindUIEvent ("item_info/btn_ditailinfo", UIEventType.Click, "GotoInfoPanel")



	-- Display the items' label :
	-- self:DisplayItemsAll ()
	-- self:FetchTagInfo ()

end


-- Default the UIAttributePage ActiveButton :
function wnd_beibaoClass:DefaultShow ()
	-- Find and set active botton
	-- self.instance:FindWidget ("tabbtn_inactive/tab_all_i"):SetActive (false)
	-- self.instance:FindWidget ("tabbtn_inactive/tab_hero_i"):SetActive (true)
	-- self.instance:FindWidget ("tabbtn_inactive/tab_item_i"):SetActive (true)
	-- self.instance:FindWidget ("tabbtn_inactive/tab_soldier_i/Label"):SetActive (true)

	-- self.instance:FindWidget ("tabbtn_activity/tab_all"):SetActive (true)
	-- self.instance:FindWidget ("tabbtn_activity/tab_hero"):SetActive (false)
	-- self.instance:FindWidget ("tabbtn_activity/tab_item"):SetActive (false)
	-- self.instance:FindWidget ("tabbtn_activity/tab_soldier/Label"):SetActive (false)


	-- Find UIAttributePage and set default all-button is active :
	self.instance:FindWidget ("tabbtn_inactive/tab_all_i"):GetComponent (CMUIAttributePage.Name):SetActivity ()

	-- Deault All item at every show :
	-- self:OnAllClick ()

	-- Change the lastMode = 0
	self.lastMode = 0


	return nil
end


-- All items are displayed by default :
function wnd_beibaoClass:DisplayItemsAll ()
	-- 獲取item_container的物品容器/父物體
	local Table = self.m_Item:GetParent ()

	 
	-- Instantiate and display the item box :
	for i = 1, self.lastCount do

		-- New item-box instance :
		local itemObj

		-- Instantiate items' box :
		do
			-- 實例化新的物品框
			itemObj = GameObject.InstantiateFromPreobj (self.m_Item, Table)

			-- 設物品框屬性
			-- itemObj:SetLocalPosition (Vector3.new (0, 0, 0))
			-- 因string.compare ()字符比較原則，根據數字位數
			-- 構造固定數字位數，以達到預期數字排序
			if (i < 10) then
				itemObj:SetName ("item_" .. "00" .. i)
			elseif (i < 100) then
				itemObj:SetName ("item_" .. "0" .. i)
			else
				itemObj:SetName ("item_" .. i)
			end

			-- SetActive ()非常耗性能，盡量以減少該方法的調用來實現
			-- itemObj:SetActive (true)


			-- 綁定物品信息面板事件
			local cmevt_Item = CMUIEvent.Go(itemObj,UIEventType.Click)    
			cmevt_Item:Listener (itemObj, UIEventType.Click, self, "ItemInfoPanel", i)

			-- Clear local :
			cmevt_Item = nil
		end


		-- local value :
		local itemIcon	--物品框的圖標
		local itemFram	--物品外框圖標
		local frameObj	--物品圖框物體
		local itemNum	--物品框物品数
		local tempObj	--緩存游戲物體

		tempObj  = itemObj:FindChild ("item_icon")
		itemIcon = tempObj:GetComponent (CMUISprite.Name)

		tempObj  = nil

		frameObj = itemObj:FindChild ("item_frame")
		itemFram = frameObj:GetComponent (CMUISprite.Name)

		tempObj  = itemObj:FindChild ("item_num")
		itemNum  = tempObj:GetComponent (CMUILabel.Name)

		tempObj  = nil

		-- 顯示物品圖標和數量
		if (i <= self.itemCount) then
			-- Display itemMat 材料碎片
			do
				local matIcon	--材料碎片圖片

				-- Display the sprite :
				matIcon  = sdata_equiplist:GetV (sdata_equiplist.I_Icon, self.TagItem.itemMat[i].id)

				itemIcon:SetAtlas ("ui_equip", "ui_equipAtlas")
				itemIcon:SetSpriteName (matIcon)

				-- Display the frame :
				-- frameObj:SetActive (false)

				-- Display count of the item :
				itemNum:SetValue (self.TagItem.itemMat[i].num)


				-- Clear local :
				itemIcon = nil
				itemFram = nil
				frameObj = nil
				itemNum  = nil
				matIcon  = nil
				itemObj  = nil
			end

		elseif (i <= self.heroCount + self.itemCount) then
			-- Display itemHSP 武將碎片
			do
				local heroInfo	--C#讀表英雄列

				-- Display the sprite :
				heroInfo = SData_Hero.GetHeroData (self.TagItem.itemHSP[i - self.itemCount].id)

				itemIcon:SetAtlas ("hero", "heroAtlas")
				itemIcon:SetSpriteName (heroInfo:HeroFace ())

				-- Display the frame :
				frameObj:SetActive (true)
				itemFram:SetSpriteName ("hero_frame")

				-- Display count of the item :
				itemNum:SetValue (self.TagItem.itemHSP[i - self.itemCount].num)


				-- Clear local :
				heroInfo = nil
				itemIcon = nil
				itemFram = nil
				frameObj = nil
				itemNum  = nil
				itemObj  = nil
			end

		elseif (i <= self.lastCount) then
			-- Display itemASP 士兵碎片
			do
				local armyInfo	--C#讀表士兵列

				-- Display the sprite :
				armyInfo = SData_Army.GetRow (self.TagItem.itemASP[i - self.itemCount - self.heroCount].id)

				itemIcon:SetAtlas ("ui_soldier", "soldierAtlas")
				itemIcon:SetSpriteName (armyInfo:Icon ())

				-- Display the frame :
				frameObj:SetActive (true)
				itemFram:SetSpriteName ("army_frame")

				-- Display count of the item :
				itemNum:SetValue (self.TagItem.itemASP[i - self.itemCount - self.heroCount].num)


				-- Clear local :
				armyInfo = nil
				itemIcon = nil
				itemFram = nil
				frameObj = nil
				itemNum  = nil
				itemObj  = nil
			end

		else
			-- It's error .
			print ("BeiBao count of item display is Error !!!")

			-- Clear local :
			itemIcon = nil
			itemFram = nil
			frameObj = nil
			itemNum  = nil
			itemObj  = nil
		end

	end

	self.m_Item:SetActive (false)

	-- Get the UITable :
	-- local Table		= self.m_Item:GetParent ()
	local cmUITable	= Table:GetComponent (CMUITable.Name)

	-- Sorting the UITable/item-boxs :
	cmUITable:Reposition ()


	-- Clear local :
	Table	  = nil
	cmUITable = nil

	return nil
end


function wnd_beibaoClass:OnShowDone ()
	if (not wnd_beibao.instance:IsNewInstance()) then
		-- Codes :
	end

	-- Refresh the default show :
	self:DefaultShow ()

	-- Refresh the container of item-boxs display :
	self:FetchTagInfo ()

	return nil
end


-- Hide window and then clear the values or set default :
function wnd_beibaoClass:HideThenClear ()
	-- Destroy the older item-box :
	for i = 1, (self.lastCount + self.destCount) do
		local gameObject
		-- 根據 i 位數構造查找物品框的名字
		if (i < 10) then
			gameObject = self.instance:FindWidget (
			"item_list/item_scroll/Table/item_" .. "00" .. i)
		elseif (i < 100) then
			gameObject = self.instance:FindWidget (
			"item_list/item_scroll/Table/item_" .. "0" .. i)
		else
			gameObject = self.instance:FindWidget (
			"item_list/item_scroll/Table/item_" .. i)
		end

		if (gameObject  ~= nil) then
			gameObject:Destroy ()
			gameObject	 = nil
		end
	end


	-- Clear/Default value of wnd_beibao :
	do
		-- Default Counts :
		self.lastCount = 0
		self.destCount = 0
		self.itemCount = 0
		self.heroCount = 0
		self.armyCount = 0


		-- Clear ParamItem :
		self.ParamItem.itemI = 0
		self.ParamItem.sort  = 0
		self.ParamItem.name  = ""
		self.ParamItem.icon  = ""
		self.ParamItem.count = ""
		self.ParamItem.price = ""


		-- Clear/Default TagItem :
		self.TagItem.itemMat = nil
		self.TagItem.itemHSP = nil
		self.TagItem.itemASP = nil

		self.TagItem.itemMat = {
			[1]  = {id = -1, num = ""},
			[2]  = {id = -1, num = ""},
			[3]  = {id = -1, num = ""},
			[4]  = {id = -1, num = ""},
			[5]  = {id = -1, num = ""},
			[6]  = {id = -1, num = ""},
			[7]  = {id = -1, num = ""},
			[8]  = {id = -1, num = ""},
			[9]  = {id = -1, num = ""},
			[10] = {id = -1, num = ""},
			[11] = {id = -1, num = ""},
			[12] = {id = -1, num = ""},
			[13] = {id = -1, num = ""},
			[14] = {id = -1, num = ""},
			[15] = {id = -1, num = ""},
			[16] = {id = -1, num = ""},
		}

		self.TagItem.itemHSP = {
			[1]  = {id = -1, num = ""},
			[2]  = {id = -1, num = ""},
			[3]  = {id = -1, num = ""},
			[4]  = {id = -1, num = ""},
			[5]  = {id = -1, num = ""},
			[6]  = {id = -1, num = ""},
			[7]  = {id = -1, num = ""},
			[8]  = {id = -1, num = ""},
			[9]  = {id = -1, num = ""},
			[10] = {id = -1, num = ""},
			[11] = {id = -1, num = ""},
			[12] = {id = -1, num = ""},
			[13] = {id = -1, num = ""},
			[14] = {id = -1, num = ""},
			[15] = {id = -1, num = ""},
			[16] = {id = -1, num = ""},
		}

		self.TagItem.itemASP = {
			[1]  = {id = -1, num = ""},
			[2]  = {id = -1, num = ""},
			[3]  = {id = -1, num = ""},
			[4]  = {id = -1, num = ""},
			[5]  = {id = -1, num = ""},
			[6]  = {id = -1, num = ""},
			[7]  = {id = -1, num = ""},
			[8]  = {id = -1, num = ""},
			[9]  = {id = -1, num = ""},
			[10] = {id = -1, num = ""},
			[11] = {id = -1, num = ""},
			[12] = {id = -1, num = ""},
			[13] = {id = -1, num = ""},
			[14] = {id = -1, num = ""},
			[15] = {id = -1, num = ""},
			[16] = {id = -1, num = ""},
		}

	end


	return nil
end


-- 選項卡點擊響應：
-- All Item :
function wnd_beibaoClass:OnAllClick ()
	self:ChangeShowMode (0)
end


-- Hero Item :
function wnd_beibaoClass:OnHeroClick ()
	self:ChangeShowMode (1)
end


-- Material Item :
function wnd_beibaoClass:OnItemClick ()
	self:ChangeShowMode (2)
end


-- Soldier Item :
function wnd_beibaoClass:OnSoldierClick ()
	self:ChangeShowMode (3)
end


--[[
	argument : mode		--It's means :
	0	All item show
	1	Soldier show
	2	Hero-item show
	3	Materials show
--]]

function wnd_beibaoClass:ChangeShowMode (mode)

	-- Get UITable :
	local Table		= self.m_Item:GetParent ()
	local cmUITable	= Table:GetComponent (CMUITable.Name)

	-- Get UIScrollView :
	local Scroll	= Table:GetParent ()
	local cmUIScroll= Scroll:GetComponent (CMUIScrollView.Name)


	if (mode == 0) and (self.lastMode ~= 0) then
		-- It's All item show :
		do
			-- Active all of item-box :
			for i = 1, (self.armyCount + self.heroCount + self.itemCount) do
				local gameObject
				-- 根據 i 位數構造查找物品框的名字
				if (i < 10) then
					gameObject = self.instance:FindWidget (
					"item_list/item_scroll/Table/item_" .. "00" .. i)
				elseif (i < 100) then
					gameObject = self.instance:FindWidget (
					"item_list/item_scroll/Table/item_" .. "0" .. i)
				else
					gameObject = self.instance:FindWidget (
					"item_list/item_scroll/Table/item_" .. i)
				end


				if (gameObject  ~= nil) then
					gameObject:SetActive (true)
					gameObject	 = nil
				end
			end

			-- Now reposition UITable :
			cmUITable:Reposition ()
			-- And update position of UIScrollView :
			cmUIScroll:ResetPosition ()

			-- Inactive itemInfo-Panel
			self.itemInfo:SetActive (false)

			-- Change lastMode
			self.lastMode = mode
		end

	elseif (mode == 1) and (self.lastMode ~= 1) then
		-- Hero items show :
		do
			-- Active all of hero-items :
			for i = 1, self.heroCount do
				local gameObject
				-- 根據 i 位數構造查找物品框的名字
				if ((i + self.itemCount) < 10) then
					gameObject = self.instance:FindWidget (
					"item_list/item_scroll/Table/item_" .. "00" .. (i + self.itemCount))
				elseif ((i + self.itemCount) < 100) then
					gameObject = self.instance:FindWidget (
					"item_list/item_scroll/Table/item_" .. "0" .. (i + self.itemCount))
				else
					gameObject = self.instance:FindWidget (
					"item_list/item_scroll/Table/item_" .. (i + self.itemCount))
				end


				if (gameObject  ~= nil) then
					gameObject:SetActive (true)
					gameObject	 = nil
				end
			end

			-- inactive all of other-items :
			for i = 1, self.itemCount do
				local gameObject
				-- 根據 i 位數構造查找物品框的名字
				if (i < 10) then
					gameObject = self.instance:FindWidget (
					"item_list/item_scroll/Table/item_" .. "00" .. i)
				elseif (i < 100) then
					gameObject = self.instance:FindWidget (
					"item_list/item_scroll/Table/item_" .. "0" .. i)
				else
					gameObject = self.instance:FindWidget (
					"item_list/item_scroll/Table/item_" .. i)
				end


				if (gameObject  ~= nil) then
					gameObject:SetActive (false)
					gameObject	 = nil
				end
			end

			for i = 1, self.armyCount do
				local gameObject
				-- 根據 i 位數構造查找物品框的名字
				if ((i + self.itemCount + self.heroCount) < 10) then
					gameObject = self.instance:FindWidget (
					"item_list/item_scroll/Table/item_" .. "00" .. (i + self.itemCount + self.heroCount))
				elseif ((i + self.itemCount + self.heroCount) < 100) then
					gameObject = self.instance:FindWidget (
					"item_list/item_scroll/Table/item_" .. "0" .. (i + self.itemCount + self.heroCount))
				else
					gameObject = self.instance:FindWidget (
					"item_list/item_scroll/Table/item_" .. (i + self.itemCount + self.heroCount))
				end


				if (gameObject  ~= nil) then
					gameObject:SetActive (false)
					gameObject	 = nil
				end
			end


			-- Now reposition UITable :
			cmUITable:Reposition ()
			-- And update position of UIScrollView :
			cmUIScroll:ResetPosition ()

			-- Inactive itemInfo-Panel
			self.itemInfo:SetActive (false)

			-- Change lastMode
			self.lastMode = mode
		end

	elseif (mode == 2) and (self.lastMode ~= 2) then
		-- Material items show :
		do
			-- Active all of hero-items :
			for i = 1, self.itemCount do
				local gameObject
				-- 根據 i 位數構造查找物品框的名字
				if (i < 10) then
					gameObject = self.instance:FindWidget (
					"item_list/item_scroll/Table/item_" .. "00" .. i)
				elseif (i < 100) then
					gameObject = self.instance:FindWidget (
					"item_list/item_scroll/Table/item_" .. "0" .. i)
				else
					gameObject = self.instance:FindWidget (
					"item_list/item_scroll/Table/item_" .. i)
				end


				if (gameObject  ~= nil) then
					gameObject:SetActive (true)
					gameObject	 = nil
				end
			end

			-- inactive all of other-items :
			for i = 1, (self.heroCount + self.armyCount) do
				local gameObject
				-- 根據 i 位數構造查找物品框的名字
				if ((i + self.itemCount) < 10) then
					gameObject = self.instance:FindWidget (
					"item_list/item_scroll/Table/item_" .. "00" .. (i + self.itemCount))
				elseif ((i + self.itemCount) < 100) then
					gameObject = self.instance:FindWidget (
					"item_list/item_scroll/Table/item_" .. "0" .. (i + self.itemCount))
				else
					gameObject = self.instance:FindWidget (
					"item_list/item_scroll/Table/item_" .. (i + self.itemCount))
				end


				if (gameObject  ~= nil) then
					gameObject:SetActive (false)
					gameObject	 = nil
				end
			end

			-- Now reposition UITable :
			cmUITable:Reposition ()
			-- And update position of UIScrollView :
			cmUIScroll:ResetPosition ()

			-- Inactive itemInfo-Panel
			self.itemInfo:SetActive (false)

			-- Change lastMode
			self.lastMode = mode
		end

	elseif (mode == 3) and (self.lastMode ~= 3) then
		-- Soldier items show :
		do
			-- Active all of hero-items :
			for i = 1, self.armyCount do
				local gameObject
				-- 根據 i 位數構造查找物品框的名字
				if ((i + self.itemCount + self.heroCount) < 10) then
					gameObject = self.instance:FindWidget (
					"item_list/item_scroll/Table/item_" .. "00" .. (i + self.itemCount + self.heroCount))
				elseif ((i + self.itemCount + self.heroCount) < 100) then
					gameObject = self.instance:FindWidget (
					"item_list/item_scroll/Table/item_" .. "0" .. (i + self.itemCount + self.heroCount))
				else
					gameObject = self.instance:FindWidget (
					"item_list/item_scroll/Table/item_" .. (i + self.itemCount + self.heroCount))
				end


				if (gameObject  ~= nil) then
					gameObject:SetActive (true)
					gameObject	 = nil
				end
			end

			-- inactive all of other-items :
			for i = 1, (self.heroCount + self.itemCount) do
				local gameObject
				-- 根據 i 位數構造查找物品框的名字
				if (i < 10) then
					gameObject = self.instance:FindWidget (
					"item_list/item_scroll/Table/item_" .. "00" .. i)
				elseif (i < 100) then
					gameObject = self.instance:FindWidget (
					"item_list/item_scroll/Table/item_" .. "0" .. i)
				else
					gameObject = self.instance:FindWidget (
					"item_list/item_scroll/Table/item_" .. i)
				end


				if (gameObject  ~= nil) then
					gameObject:SetActive (false)
					gameObject	 = nil
				end
			end

			-- Now reposition UITable :
			cmUITable:Reposition ()
			-- And update position of UIScrollView :
			cmUIScroll:ResetPosition ()

			-- Inactive itemInfo-Panel
			self.itemInfo:SetActive (false)

			-- Change lastMode
			self.lastMode = mode
		end

	end

	-- Clear local :
	Table	   = nil
	cmUITable  = nil
	Scroll	   = nil
	cmUIScroll = nil
end


-- Click item-box's callback function :
function wnd_beibaoClass:ItemInfoPanel (gameObject, paramI)
	-- Active the item info-panel
	self.itemInfo:SetActive (true)


	if (paramI <= self.itemCount) then
		-- It's material item :
		self:ItemInfoPanelDisplay (1, paramI)

	elseif (paramI <= self.itemCount + self.heroCount) then
		-- It's hero item :
		self:ItemInfoPanelDisplay (2, paramI - self.itemCount)

	elseif (paramI <= self.itemCount + self.heroCount + self.armyCount) then
		-- It's soldier item :
		self:ItemInfoPanelDisplay (3, paramI - self.itemCount - self.heroCount)

	end

	return nil
end


-- Display item's info in item-info panel :
function wnd_beibaoClass:ItemInfoPanelDisplay (item, paramI)
	-- Find UI-Component :
	-- 圖標
	local itemPic = self.itemInfo:FindChild ("item_icon"):GetComponent (CMUISprite.Name)
	-- 邊框
	local framObj = self.itemInfo:FindChild ("item_frame")
	local itemFra = framObj:GetComponent (CMUISprite.Name)
	-- 名字
	local itemNam = self.itemInfo:FindChild ("item_name/txt"):GetComponent (CMUILabel.Name)
	-- 數量
	local itemNum = self.itemInfo:FindChild ("item_num/num"):GetComponent (CMUILabel.Name)
	-- 描述
	local itemDes = self.itemInfo:FindChild ("item_ditailinfo/txt2"):GetComponent (CMUILabel.Name)
	-- 價格
	local itemPrc = self.itemInfo:FindChild ("item_price/txt2"):GetComponent (CMUILabel.Name)


	if (item == 1) then
		-- Material :
		do
			-- Local value :
			local matDesc	--材料碎片描述


			-- Construct the self.ParamItem :
			self.ParamItem.itemI = self.TagItem.itemMat[paramI].id
			self.ParamItem.objID = paramI
			self.ParamItem.sort  = item

			local rowID		= self.TagItem.itemMat[paramI].id
			self.ParamItem.name	= sdata_equiplist:GetV (sdata_equiplist.I_Name, rowID)
			self.ParamItem.icon	= sdata_equiplist:GetV (sdata_equiplist.I_Icon, rowID)
			self.ParamItem.count	= self.TagItem.itemMat[paramI].num
			self.ParamItem.price	= sdata_equiplist:GetV (sdata_equiplist.I_Price, rowID)

			-- Display the sprite :
			itemPic:SetAtlas ("ui_equip", "ui_equipAtlas")
			itemPic:SetSpriteName (self.ParamItem.icon)

			-- Display the frame :
			framObj:SetActive (false)

			-- Display name of the item :
			itemNam:SetValue (self.ParamItem.name)

			-- Display describ of the item :
			matDesc = sdata_equiplist:GetV (sdata_equiplist.I_Note, rowID)    
			itemDes:SetValue (matDesc)

			-- Display price of the item :
			itemPrc:SetValue (self.ParamItem.price)

			-- Display count of the item :
			itemNum:SetValue (self.ParamItem.count)


			-- Clear local :
			rowID	= nil
			matDesc = nil 
		end

	elseif (item == 2) then
		-- Hero :
		do
			-- Get HeroInfo :
			local heroInfo = SData_Hero.GetHeroData (self.TagItem.itemHSP[paramI].id)


			-- Construct the self.ParamItem :
			self.ParamItem.itemI = self.TagItem.itemHSP[paramI].id
			self.ParamItem.objID = paramI + self.itemCount
			self.ParamItem.sort  = item
			self.ParamItem.name  = heroInfo:Name ()
			self.ParamItem.icon  = heroInfo:HeroFace ()
			self.ParamItem.count = self.TagItem.itemHSP[paramI].num
			self.ParamItem.price = sdata_keyvalue:GetV (sdata_keyvalue.I_HerosuipianPrice, 1)


			-- Display the sprite :
			itemPic:SetAtlas ("hero", "heroAtlas")
			itemPic:SetSpriteName (self.ParamItem.icon)

			-- Display the frame :
			framObj:SetActive (true)
			itemFra:SetSpriteName ("hero_frame")

			-- Display name of the item :
			itemNam:SetValue (self.ParamItem.name)

			-- Display describ of the item :
			do
				local x2num
				local defaultX = heroInfo:MorenXing ()

				if (defaultX == 1) then
					x2num = sdata_keyvalue:GetV (sdata_keyvalue.I_1xingSuipian, 1)
				elseif (defaultX == 2) then
					x2num = sdata_keyvalue:GetV (sdata_keyvalue.I_2xingSuipian, 1)
				elseif (defaultX == 3) then
					x2num = sdata_keyvalue:GetV (sdata_keyvalue.I_3xingSuipian, 1)
				elseif (defaultX == 4) then
					x2num = sdata_keyvalue:GetV (sdata_keyvalue.I_4xingSuipian, 1)
				elseif (defaultX == 5) then
					x2num = sdata_keyvalue:GetV (sdata_keyvalue.I_5xingSuipian, 1)
				elseif (defaultX == 6) then
					x2num = sdata_keyvalue:GetV (sdata_keyvalue.I_6xingSuipian, 1)
				elseif (defaultX == 7) then
					x2num = sdata_keyvalue:GetV (sdata_keyvalue.I_7xingSuipian, 1)
				elseif (defaultX == 8) then
					x2num = sdata_keyvalue:GetV (sdata_keyvalue.I_8xingSuipian, 1)
				end

				itemDes:SetValue ( string.sformat (_TXT (9075), x2num, heroInfo:Name (), heroInfo:Name (), heroInfo:Name ()) )

				x2num	 = nil
				defaultX = nil
			end

			-- Display price of the item :
			itemPrc:SetValue (self.ParamItem.price)

			-- Display count of the item :
			itemNum:SetValue (self.ParamItem.count)


			-- Clear local :
			heroInfo = nil
		end

	elseif (item == 3) then
		-- Soldier :
		do
			-- Get ArmyInfo :
			local armyInfo = SData_Army.GetRow (self.TagItem.itemASP[paramI].id)


			-- Construct the self.ParamItem :
			self.ParamItem.itemI = self.TagItem.itemASP[paramI].id
			self.ParamItem.objID = paramI + self.itemCount + self.heroCount
			self.ParamItem.sort  = item
			self.ParamItem.name  = armyInfo:Name ()
			self.ParamItem.icon  = armyInfo:Icon ()
			self.ParamItem.count = self.TagItem.itemASP[paramI].num
			self.ParamItem.price = sdata_keyvalue:GetV (sdata_keyvalue.I_ArmysuipianPrice, 1)



			-- Display the sprite :
			itemPic:SetAtlas ("ui_soldier", "soldierAtlas")
			itemPic:SetSpriteName (self.ParamItem.icon)

			-- Display the frame :
			framObj:SetActive (true)
			itemFra:SetSpriteName ("army_frame")

			-- Display name of the item :
			itemNam:SetValue (self.ParamItem.name)

			-- Display describ of the item :
			itemDes:SetValue ( string.sformat (_TXT (9076), armyInfo:Name ()) )

			-- Display price of the item :
			itemPrc:SetValue (self.ParamItem.price)

			-- Display count of the item :
			itemNum:SetValue (self.ParamItem.count)


			-- Clear local :
			armyInfo = nil
		end

	end


	-- Clear local :
	itemPic = nil
	itemFra = nil
	framObj = nil
	itemNam = nil
	itemNum = nil
	itemDes = nil
	itemPrc = nil

	return nil
end


-- 前往出售物品界面
function wnd_beibaoClass:GotoSellPanel ()
	item_popMenu:ShowSell ()
end


-- 前往物品詳細信息界面
function wnd_beibaoClass:GotoInfoPanel ()
	item_popMenu:ShowInfo ()
end


-- Fetch the user's bag infor and construct self.TagItem :
function wnd_beibaoClass:FetchTagInfo ()
	-- First : Get/Reload bag's Info :
	local jsonDoc = JsonParse.SendNM ("ItemView")
	local loader  = Loader.new (jsonDoc:ToString(), 0, "ReItemView")
	LoaderEX.SendAndRecall (loader, self, self.NM_ReItemView, nil)
end


-- the ReCallFunction : to construct self.TagItem :
function wnd_beibaoClass:NM_ReItemView (reDoc)
	-- 材料
	local itemMat = reDoc:GetValue ("mat")
	-- 武將碎片
	local itemHSP = reDoc:GetValue ("hsp")
	-- 士兵碎片
	local itemASP = reDoc:GetValue ("asp")

	-- self.TagItem[count] :
	local count   = 0


	-- Construct the self.TagItem :
	do
		-- Construct self.TagItem.itemASP :
		local aspEachFunc = function (id, num)
			count = count + 1

			self.TagItem.itemASP[count]	    = { id = -1, num = "" }

			self.TagItem.itemASP[count].id  = tonumber (id)
			self.TagItem.itemASP[count].num = tostring (num)
		end

		-- Construct self.TagItem.itemHSP :
		local hspEachFunc = function (id, num)
			count = count + 1

			self.TagItem.itemHSP[count]	    = { id = -1, num = "" }

			self.TagItem.itemHSP[count].id  = tonumber (id)
			self.TagItem.itemHSP[count].num = tostring (num)
		end

		-- Construct self.TagItem.itemMat :
		local matEachFunc = function (id, num)
			count = count + 1

			self.TagItem.itemMat[count]	    = { id = -1, num = "" }

			self.TagItem.itemMat[count].id  = tonumber (id)
			self.TagItem.itemMat[count].num = tostring (num)
		end

		itemMat:Foreach (matEachFunc)
		self.itemCount = count
		count = 0

		itemHSP:Foreach (hspEachFunc)
		self.heroCount = count
		count = 0

		itemASP:Foreach (aspEachFunc)
		self.armyCount = count
		count = nil

		self.lastCount = self.armyCount + self.itemCount + self.heroCount

	end

	-- Set EitherRefreshBeiBao is false : means already refresh .
	-- EitherRefreshBeiBao = false


	-- If the instance ~= nil : then to refresh the display :
	if (self.instance ~= nil) then
		self:DisplayItemsAll ()
	end

	-- Clear local :
	itemASP	= nil
	itemHSP	= nil
	itemMat	= nil

	return nil
end



-- Clear value of wnd_beibao in the HideThenClear .
function wnd_beibaoClass:OnLostInstance ()
	-- -- Clear value of wnd_beibao :
	-- self.ParamItem.itemI = 0
	-- self.ParamItem.sort  = 0
	-- self.ParamItem.name  = ""
	-- self.ParamItem.icon  = ""
	-- self.ParamItem.count = ""
	-- self.ParamItem.price = ""


	-- -- Clear TagItem :
	-- self.TagItem.itemMat = nil
	-- self.TagItem.itemHSP = nil
	-- self.TagItem.itemASP = nil

	-- self.TagItem.itemMat = {
	-- 	[1]  = {id = -1, num = ""},
	-- 	[2]  = {id = -1, num = ""},
	-- 	[3]  = {id = -1, num = ""},
	-- 	[4]  = {id = -1, num = ""},
	-- 	[5]  = {id = -1, num = ""},
	-- 	[6]  = {id = -1, num = ""},
	-- 	[7]  = {id = -1, num = ""},
	-- 	[8]  = {id = -1, num = ""},
	-- 	[9]  = {id = -1, num = ""},
	-- 	[10] = {id = -1, num = ""},
	-- 	[11] = {id = -1, num = ""},
	-- 	[12] = {id = -1, num = ""},
	-- 	[13] = {id = -1, num = ""},
	-- 	[14] = {id = -1, num = ""},
	-- 	[15] = {id = -1, num = ""},
	-- 	[16] = {id = -1, num = ""},
	-- }

	-- self.TagItem.itemHSP = {
	-- 	[1]  = {id = -1, num = ""},
	-- 	[2]  = {id = -1, num = ""},
	-- 	[3]  = {id = -1, num = ""},
	-- 	[4]  = {id = -1, num = ""},
	-- 	[5]  = {id = -1, num = ""},
	-- 	[6]  = {id = -1, num = ""},
	-- 	[7]  = {id = -1, num = ""},
	-- 	[8]  = {id = -1, num = ""},
	-- 	[9]  = {id = -1, num = ""},
	-- 	[10] = {id = -1, num = ""},
	-- 	[11] = {id = -1, num = ""},
	-- 	[12] = {id = -1, num = ""},
	-- 	[13] = {id = -1, num = ""},
	-- 	[14] = {id = -1, num = ""},
	-- 	[15] = {id = -1, num = ""},
	-- 	[16] = {id = -1, num = ""},
	-- }

	-- self.TagItem.itemASP = {
	-- 	[1]  = {id = -1, num = ""},
	-- 	[2]  = {id = -1, num = ""},
	-- 	[3]  = {id = -1, num = ""},
	-- 	[4]  = {id = -1, num = ""},
	-- 	[5]  = {id = -1, num = ""},
	-- 	[6]  = {id = -1, num = ""},
	-- 	[7]  = {id = -1, num = ""},
	-- 	[8]  = {id = -1, num = ""},
	-- 	[9]  = {id = -1, num = ""},
	-- 	[10] = {id = -1, num = ""},
	-- 	[11] = {id = -1, num = ""},
	-- 	[12] = {id = -1, num = ""},
	-- 	[13] = {id = -1, num = ""},
	-- 	[14] = {id = -1, num = ""},
	-- 	[15] = {id = -1, num = ""},
	-- 	[16] = {id = -1, num = ""},
	-- }


	return nil
end



return wnd_beibaoClass.new