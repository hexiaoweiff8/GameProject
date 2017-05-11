--item_popMenu.lua 背包彈窗
--StartDate : 2015/11/12 14:51; FirstDate : 2015/11/13 23:06;
--FinshData : 2015/11/18 19:27;
--Note : Nothing ..
--RandyL-LJX


local item_popMenuClass = class(wnd_base)

item_popMenu = nil


--[[
	item_popMenuClass :
		self.SelectMenu	--選擇顯示出售還是信息界面 :
							0, nil; 1, Sell_Menu; 2, Info_Menu;
		self.itemSell	--"sell_menu"物品出售界面
		self.itemInfo	--"info_menu"物品詳細信息界面

		self.sellCount	--物品出售數量，默认 1


		self.gain_Grid	--"Table/item_ObtainWays" 获取途徑
		self.forg_Grid	--"Table/item_ForgeItems" 合成物品
		self.hero_Grid	--"Table/item_HerosEquip" 裝備英雄

		self.gain_Item	--"Table/item_ObtainWays/Table/info_single"
						--獲取途徑欄中關卡框預設框
		self.forg_Item	--"Table/item_ForgeItems/Table/info_single"
						--合成物品欄中物品框預設框
		self.hero_Item	--"Table/item_HerosEquip/Table/info_single"
						--裝備英雄欄中英雄框預設框

		self.gain_Count	--動態生成關卡框的數
		self.forg_Count	--動態生成合成框的數
		self.hero_Count	--動態生成英雄框的數

		self.DefaultVec	--默認 info_Grids 尺寸
		--self.DefGridVec	--默認 info_Grids 尺寸
		--self.DefSprtVec	--默認 info_bg 背景圖尺寸

		self.get_Label	--"Table/item_ObtainWays/info_bg/txt1"
						--獲取途徑UILabel
--]]


function item_popMenuClass:Start ()
	item_popMenu = self
	self:Init (WND.PopMenu, false)

	-- Default invalid value 0 :
	self.SelectMenu	= 0
	-- Default the count of sell is 1 :
	self.sellCount	= 1

	-- Default is zero :
	self.gain_Count = 0
	self.forg_Count = 0
	self.hero_Count = 0

	self.DefaultVec = nil
	-- self.DefGridVec = nil
	-- self.DefSprtVec = nil
end


function item_popMenuClass:OnNewInstance ()
	-- the preset info_menu :
	self.itemInfo  = self.instance:FindWidget ("info_menu")

	-- the preset sell_menu :
	self.itemSell  = self.instance:FindWidget ("sell_menu")


	-- the preset of gain-grid the UITable container :
	self.gain_Grid = self.instance:FindWidget ("info_menu/info_scroll/Table/item_ObtainWays")

	-- the preset of forge-grid the UITable container :
	self.forg_Grid = self.instance:FindWidget ("info_menu/info_scroll/Table/item_ForgeItems")

	-- the preset of hero-grid the UITable container :
	self.hero_Grid = self.instance:FindWidget ("info_menu/info_scroll/Table/item_HerosEquip")


	-- the preset of getting's UILabel :
	self.get_Label = self.gain_Grid:FindChild ("info_bg/txt1")


	-- the preset of gain-items the UITable container :
	self.gain_Item = self.gain_Grid:FindChild ("Table/info_single")

	-- the preset of forge-items the UITable container :
	self.forg_Item = self.forg_Grid:FindChild ("Table/info_single")

	-- the preset of hero-items the UITable container :
	self.hero_Item = self.hero_Grid:FindChild ("Table/info_single")


	-- Set the preset is inactivity :
	-- No need set inactive info_Items and info_Grids .
	-- self.gain_Item:SetActive (false)
	-- self.forg_Item:SetActive (false)
	-- self.hero_Item:SetActive (false)
	-- self.gain_Grid:SetActive (false)
	-- self.forg_Grid:SetActive (false)
	-- self.hero_Grid:SetActive (false)



	-- Initial UILabels :
	-- 返回 9090
	self:SetLabel ("sell_menu/btn_back/txt", SData_Id2String.Get (9090))
	-- 確認出售 9089
	self:SetLabel ("sell_menu/btn_dosell/txt", SData_Id2String.Get (9089))

	-- 獲取途徑 9086
	self.gain_Grid:FindChild ("title"):GetComponent (
		CMUILabel.Name):SetValue ( SData_Id2String.Get (9086))
	-- 合成物品 9082
	self.forg_Grid:FindChild ("title"):GetComponent (
		CMUILabel.Name):SetValue ( SData_Id2String.Get (9082))
	-- 裝備武將 9083
	self.hero_Grid:FindChild ("title"):GetComponent (
		CMUILabel.Name):SetValue ( SData_Id2String.Get (9083))



	-- Bind gameObject of UIButton UIEvent :
	-- Item-Sell Panel :
	do
		self:BindUIEvent ("sell_menu/btn_dosell", UIEventType.Click, "ConfirmSell")
		self:BindUIEvent ("sell_menu/btn_back", UIEventType.Click, "CancelSell")

		-- Button of increase or decrease and maximum :
		self:BindUIEvent ("sell_menu/sell_amount/btn_increase", UIEventType.Click, "CountIncrease")
		self:BindUIEvent ("sell_menu/sell_amount/btn_decrease", UIEventType.Click, "CountDecrease")
		self:BindUIEvent ("sell_menu/sell_amount/btn_max", UIEventType.Click, "CountMaximum")

	end
	-- Item-Info Panel :
	do
		-- Just click to leave the window :
		-- self:BindUIEvent ("item_popmenu", UIEventType.Click, "JustHide")	--Can not FindChild () .
		local backGroundBtn = self.itemInfo:GetParent ()
		local cmevt_backBtn = CMUIEvent.Go(backGroundBtn,UIEventType.Click) 
		cmevt_backBtn:Listener (backGroundBtn, UIEventType.Click, self, "JustHide")

		-- Clear local
		backGroundBtn = nil
		cmevt_backBtn = nil
	end


	return nil
end


-- Display the window of item-sell
function item_popMenuClass:ShowSell ()
	self.SelectMenu = 1

	self:Show ()

	return nil
end


-- Display the window of item-info
function item_popMenuClass:ShowInfo ()
	self.SelectMenu = 2

	self:Show ()

	return nil
end


-- PS Big Changed :
-- 1. 取消了動態實例化 物品獲取/合成/裝備英雄欄
-- 2. 并同時針對性能優化 建議并實行多处预设更改
function item_popMenuClass:OnShowDone ()
	-- Control to show menu of sell or info :
	if (self.SelectMenu == 1) then
		self.itemSell:SetActive (true)
		self.itemInfo:SetActive (false)

-- Show Info :
do
		-- Local value : Get the UIComponent of item :
		local iconSprite  = self:GetSprite ("sell_menu/item_icon")
		local frameObj	  = self.instance:FindWidget ("sell_menu/item_icon/item_frame")
		local frameSprite = frameObj:GetComponent (CMUISprite.Name)
		local nameLabel   = self:GetLabel ("sell_menu/item_name/txt")
		local countLabel  = self:GetLabel ("sell_menu/item_num/num")
		local priceLabel  = self:GetLabel ("sell_menu/item_price/txt2")
		local slnumLabel  = self:GetLabel ("sell_menu/item_value/txt2")
		local amountLabel = self:GetLabel ("sell_menu/sell_amount/num")


		-- Set the name of item
		nameLabel:SetValue (wnd_beibao.ParamItem.name)
		-- Set the count of item
		countLabel:SetValue (wnd_beibao.ParamItem.count)
		-- Set the price of item
		priceLabel:SetValue (wnd_beibao.ParamItem.price)

		-- Display sell number of the items
		-- Default sell count is 1 :
		slnumLabel:SetValue (self.sellCount .. "/" .. wnd_beibao.ParamItem.count)
		-- Display sell price of the items
		local amountPrice = tonumber (wnd_beibao.ParamItem.price) * self.sellCount
		amountLabel:SetValue (amountPrice)

		-- The following display depends on the item :
		-- Set the frame of item
		if (wnd_beibao.ParamItem.sort == 1) then
			-- Materials :
			frameObj:SetActive (false)
			iconSprite:SetAtlas ("ui_equip", "ui_equipAtlas")
		elseif (wnd_beibao.ParamItem.sort == 2) then
			-- Heros :
			frameObj:SetActive (true)
			frameSprite:SetSpriteName ("hero_frame")

			iconSprite:SetAtlas ("hero", "heroAtlas")
		elseif (wnd_beibao.ParamItem.sort == 3) then
			-- Soldiers :
			frameObj:SetActive (true)

			frameSprite:SetSpriteName ("army_frame")
			iconSprite:SetAtlas ("ui_soldier", "soldierAtlas")
		end

		-- Set the icon of item
		iconSprite:SetSpriteName (wnd_beibao.ParamItem.icon)


		-- Clear local value :
		iconSprite  = nil
		frameObj	= nil
		frameSprite = nil
		nameLabel   = nil
		countLabel  = nil
		priceLabel  = nil
		slnumLabel  = nil
		amountLabel = nil
end



	elseif (self.SelectMenu == 2) then
		self.itemSell:SetActive (false)
		self.itemInfo:SetActive (true)

-- Show Info :
do
		-- Local value : Get the UIComponent of item :
		local iconSprite  = self:GetSprite ("info_menu/selected_item")
		local frameObj	  = self.instance:FindWidget ("info_menu/selected_item/item_frame")
		local frameSprite = frameObj:GetComponent (CMUISprite.Name)


		-- Default either active :
		if (not self.instance:IsNewInstance ()) then
			-- Set info_items is true of active :
			self.gain_Item:SetActive (true)
			self.forg_Item:SetActive (true)
			self.hero_Item:SetActive (true)

			-- Set false of get_Label's active .
			self.get_Label:SetActive (false)

			-- Set false of info_Grids's active :
			-- And no need false of gain_Grid .
			-- Or Always is active of gain_Grid .
			-- self.gain_Grid:SetActive (false)
			self.forg_Grid:SetActive (false)
			self.hero_Grid:SetActive (false)
		end


		-- Item's ID :
		local localId = wnd_beibao.ParamItem.itemI


		-- Set the frame of item
		if (wnd_beibao.ParamItem.sort == 1) then
			-- Materials :
			do
				-- 物品圖標設置
				frameObj:SetActive (false)


				-- 讀表獲得合成物品id字符串
				repeat
					local hecheng	 = sdata_equiplist:GetV (sdata_equiplist.I_Hecheng, localId)

					-- 合成物品的 id 表 ForgeItems
					local ForgeItems = {}
					-- 控制 ForgeItems 迭代賦值次數
					local forgeItemN = 0
					-- 顯示物品框行數，每行顯示兩個
					local forgeItemY = 0

					-- 拆分 hecheng 字符串匹配構造 ForgeItems
					for v in string.gmatch (hecheng, "%d+") do
						forgeItemN = forgeItemN + 1
						ForgeItems[forgeItemN] = tonumber (v)
					end


					-- 如果無有效值
					if (hecheng == "-1") then
						ForgeItems[1] = -1
					end

					-- 檢測是否無有效項
					if (forgeItemN == 1) and (ForgeItems[1] == -1) then
						-- Clear local
						hecheng    = nil
						ForgeItems = nil
						forgeItemN = nil
						forgeItemY = nil
						break
					end


					-- 激活 self.forg_Grid
					self.forg_Grid:SetActive (true)


					if (forgeItemN > 2) then
						-- 爲 forgeItemY 賦值
						if ((forgeItemN % 2) == 1) then
							-- forgeItemN 奇數
							forgeItemY = 60 * (forgeItemN - 1) / 2
						else
							-- forgeItemN 偶數
							forgeItemY = 60 * (forgeItemN - 2) / 2
						end


						-- 設置物品合成欄尺寸
						local gridWidget = self.forg_Grid:GetComponent (CMUIWidget.Name)
						local oldVector2 = gridWidget:GetSize ()
						self.DefaultVec  = oldVector2
						local newVector2 = Vector2.new (oldVector2.x, (oldVector2.y + forgeItemY))

						-- 設置新尺寸
						gridWidget:SetSize (newVector2)
						-- gridWidget:SetSize (Vector2.new (560, 114 + forgeItemY))	--按预设寫死尺寸

						-- 刷新碰撞器大小
						gridWidget:ResizeCollider ()

						-- 更改背景圖大小
						local grid_BG = self.forg_Grid:FindChild ("info_bg")
						grid_BG:GetComponent (CMUISprite.Name):SetSize (
							Vector2.new (oldVector2.x, (60 + forgeItemY)))


						-- Clear local
						gridWidget = nil
						oldVector2 = nil
						newVector2 = nil
						grid_BG    = nil
					end


					-- 實例化合成欄中的物品框
					local Table   = self.forg_Grid:FindChild ("Table")

					-- 更換圖集
					-- 已不需要更改圖集
					-- self.forg_Item:GetComponent (CMUISprite.Name):SetAtlas ("ui_equip", "ui_equipAtlas")

					-- 一共生成 forgeItemN 個物品框
					for i = 1, forgeItemN do
						local itemObj = GameObject.InstantiateFromPreobj (self.forg_Item, Table)
						-- 設物品合成欄屬性
						itemObj:SetName ("items_" .. i)

						-- 爲減少SetActive調用
						-- 采用活動預設克隆實例
						-- itemObj:SetActive (true)

						-- 顯示物品圖標和名字
						local iconSprite = itemObj:FindChild ("icon"):GetComponent (CMUISprite.Name)
						local nameLabel  = itemObj:FindChild ("name"):GetComponent (CMUILabel.Name)

						-- 設置物品圖標和名字
						iconSprite:SetSpriteName (sdata_equiplist:GetV (sdata_equiplist.I_Icon, ForgeItems[i]))
						nameLabel:SetValue (sdata_equiplist:GetV (sdata_equiplist.I_Name, ForgeItems[i]))

						-- Clear local
						itemObj    = nil
						iconSprite = nil
						nameLabel  = nil
					end

					self.forg_Item:SetActive (false)


					-- 此處之前不需要 Reposition()
					-- 因爲其容器Tabel是動態生成
					-- 即NGUI-Camera會在OnEnable/Start渲染時排序

					Table:GetComponent (CMUITable.Name):Reposition ()

					-- 用於隱藏前銷毀動態生成的框
					self.forg_Count = forgeItemN


					-- Clear local
					hecheng    = nil
					ForgeItems = nil
					forgeItemN = nil
					forgeItemY = nil
					Table      = nil
					break
				until (true)


				-- 讀表獲取裝備物品武將id
				repeat
					local heros		 = sdata_equiplist:GetV (sdata_equiplist.I_Hero, localId)

					-- 裝備武將的 id 表 EquipHeros
					local EquipHeros = {}
					-- 控制 EquipHeros 迭代賦值次數
					local equipHeroN = 0
					-- 顯示物品框行數，每行顯示兩個
					local equipHeroY = 0

					-- 拆分 heros 字符串匹配構造 EquipHeros
					for v in string.gmatch (heros, "%d+") do
						equipHeroN = equipHeroN + 1
						EquipHeros[equipHeroN] = tonumber (v)
					end


					-- 如果無有效值
					if (heros == "-1") then
						EquipHeros[1] = -1
					end

					-- 檢測是否無有效項
					if (equipHeroN == 1) and (EquipHeros[1] == -1) then
						-- Clear local
						heros      = nil
						EquipHeros = nil
						equipHeroN = nil
						equipHeroY = nil
						break
					end


					-- 激活 self.hero_Grid
					self.hero_Grid:SetActive (true)


					if (equipHeroN > 2) then
						-- 爲 equipHeroY 賦值
						if ((equipHeroN % 2) == 1) then
							-- equipHeroN 奇數
							equipHeroY = 60 * (equipHeroN - 1) / 2
						else
							-- equipHeroN 偶數
							equipHeroY = 60 * (equipHeroN - 2) / 2
						end


						-- 設置裝備英雄欄尺寸
						local gridWidget = self.hero_Grid:GetComponent (CMUIWidget.Name)
						local oldVector2 = gridWidget:GetSize ()
						self.DefaultVec  = oldVector2
						local newVector2 = Vector2.new (oldVector2.x, (oldVector2.y + equipHeroY))

						-- 設置新尺寸
						gridWidget:SetSize (newVector2)
						-- gridWidget:SetSize (Vector2.new (560, 114 + equipHeroY))	--按预设寫死尺寸

						-- 刷新碰撞器大小
						gridWidget:ResizeCollider ()

						-- 更改背景圖大小
						local grid_BG = self.hero_Grid:FindChild ("info_bg")
						grid_BG:GetComponent (CMUISprite.Name):SetSize (
							Vector2.new (oldVector2.x, (60 + equipHeroY)))


						-- Clear local
						gridWidget = nil
						oldVector2 = nil
						newVector2 = nil
						grid_BG    = nil
					end


					-- 實例化英雄欄中的物品框
					local Table   = self.hero_Grid:FindChild ("Table")

					-- 更換圖集
					-- 此处已不需動態更換圖集
					-- self.hero_Item:GetComponent (CMUISprite.Name):SetAtlas ("hero", "heroAtlas")

					-- 一共生成 equipHeroN 個英雄框
					for i = 1, equipHeroN do
						local itemObj = GameObject.InstantiateFromPreobj (self.hero_Item, Table)
						-- 設裝備英雄欄屬性
						itemObj:SetName ("items_" .. i)

						-- 爲減少SetActive調用
						-- 采用活動預設克隆實例
						-- itemObj:SetActive (true)

						-- 顯示英雄圖標和名字
						local iconSprite = itemObj:FindChild ("icon"):GetComponent (CMUISprite.Name)
						local nameLabel  = itemObj:FindChild ("name"):GetComponent (CMUILabel.Name)

						-- C# 讀表獲取 HeroInfo
						local heroRow	 = SData_Hero.GetHeroData (EquipHeros[i])
						-- 設置英雄圖標和名字
						iconSprite:SetSpriteName (heroRow:HeroFace ())
						nameLabel:SetValue (heroRow:Name ())

						-- Clear local
						itemObj    = nil
						iconSprite = nil
						nameLabel  = nil
						heroRow    = nil
					end

					self.hero_Item:SetActive (false)

					Table:GetComponent (CMUITable.Name):Reposition ()

					-- 用於隱藏前銷毀動態生成的框
					self.hero_Count = equipHeroN


					-- Clear local
					heros	   = nil
					EquipHeros = nil
					equipHeroN = nil
					equipHeroY = nil
					Table      = nil
					break
				until (true)


				-- 獲取途徑類型 1 關卡 2 合成
				repeat
					local tujing = sdata_equiplist:GetV (sdata_equiplist.I_Tujing, localId)


					-- 判斷獲取途徑
					if (tonumber (tujing) == 1) then
					-- 物品關卡獲得
					do
						local mission = sdata_equiplist:GetV (sdata_equiplist.I_Mission, localId)

						-- 獲取關卡的 id 表 MissionIds
						local MissionIds = {}
						-- 控制 MissionIds 迭代賦值次數
						local missionIdN = 0
						-- 顯示物品框行數，每行顯示兩個
						local missionIdY = 0

						-- 拆分 mission 字符串匹配構造 MissionIds
						for k, v in string.gmatch (mission, "(%d+)|(%d+)") do
							missionIdN = missionIdN + 1
							MissionIds[missionIdN] = tonumber (k .. v)
						end


						-- 如果無有效值
						if (mission == "-1") then
							MissionIds[1] = -1
						end

						-- 檢測是否無有效項
						if (missionIdN == 1) and (MissionIds[1] == -1) then
							-- Clear local
							mission    = nil
							MissionIds = nil
							missionIdN = nil
							missionIdY = nil
							break
						end



						if (missionIdN > 2) then
							-- 爲 missionIdY 賦值
							if ((missionIdN % 2) == 1) then
								-- missionIdN 奇數
								missionIdY = 60 * (missionIdN - 1) / 2
							else
								-- missionIdN 偶數
								missionIdY = 60 * (missionIdN - 2) / 2
							end


							-- 設置獲取途徑欄尺寸
							local gridWidget = self.gain_Grid:GetComponent (CMUIWidget.Name)
							local oldVector2 = gridWidget:GetSize ()
							self.DefaultVec  = oldVector2
							local newVector2 = Vector2.new (oldVector2.x, (oldVector2.y + missionIdY))

							-- 設置新尺寸
							gridWidget:SetSize (newVector2)
							-- gridWidget:SetSize (Vector2.new (560, 114 + missionIdY))	--按预设寫死尺寸

							-- 刷新碰撞器大小
							gridWidget:ResizeCollider ()

							-- 更改背景圖大小
							local grid_BG = self.gain_Grid:FindChild ("info_bg")
							grid_BG:GetComponent (CMUISprite.Name):SetSize (
								Vector2.new (oldVector2.x, (60 + missionIdY)))


							-- Clear local
							gridWidget = nil
							oldVector2 = nil
							newVector2 = nil
							grid_BG    = nil
						end


						-- 實例化途徑欄中的物品框
						local Table   = self.gain_Grid:FindChild ("Table")

						-- 更換圖集
						-- 提前更換預設圖集
						-- 不需更換 默認爲該圖集
						-- self.gain_Item:FindChild ("icon"):GetComponent (CMUISprite.Name
						-- 	):SetAtlas ("ui_guanka", "ui_guankaAtlas")

						-- 一共生成 missionIdN 個關卡框
						for i = 1, missionIdN do
							local itemObj = GameObject.InstantiateFromPreobj (self.gain_Item, Table)
							-- 設獲取途徑欄屬性
							itemObj:SetName ("items_" .. i)

							-- 爲減少SetActive調用
							-- 采用活動預設克隆實例
							-- itemObj:SetActive (true)

							-- 顯示關卡圖標和名字
							local iconSprite = itemObj:FindChild ("icon"):GetComponent (CMUISprite.Name)
							local nameLabel  = itemObj:FindChild ("name"):GetComponent (CMUILabel.Name)

							-- 設置關卡圖標和名字
							iconSprite:SetSpriteName (sdata_Mission:GetV (sdata_Mission.I__MissionChengPic, MissionIds[i]))
							nameLabel:SetValue (sdata_Mission:GetV (sdata_Mission.I_MissionName, MissionIds[i]))

							-- Clear local
							itemObj    = nil
							iconSprite = nil
							nameLabel  = nil
						end

						self.gain_Item:SetActive (false)

						Table:GetComponent (CMUITable.Name):Reposition ()

						-- 用於隱藏前銷毀動態生成的框
						self.gain_Count = missionIdN


						-- Clear local
						mission	   = nil
						MissionIds = nil
						missionIdN = nil
						missionIdY = nil
						Table      = nil
						break
					end

					elseif (tonumber (tujing) == 2) then
					-- 物品合成而成
					-- Nothing to do ..
						print ("Item is synthesis.物品合成獲得")
					else
					-- 物品無獲取途徑 ..
						print ("sdata_equiplist.Tujing is nil .")
					end

					-- Clear local
					tujing = nil
					break
				until (true)


				-- 獲取 info_Grids 容器
				local Grid   = self.gain_Grid:GetParent ()

				-- 刷新合成/裝備/獲取欄位置
				Grid:GetComponent (CMUITable.Name):Reposition ()

				local Scroll = Grid:GetParent ():GetComponent (CMUIScrollView.Name)
				-- 重置詳細信息滾輪位置/清除上次滾動位置
				Scroll:ResetPosition ()


				-- Clear local :
				Grid   = nil
				Scroll = nil
			end


		elseif (wnd_beibao.ParamItem.sort == 2) then
			-- Heros :
			do
				-- 物品圖標設置
				frameObj:SetActive (true)
				frameSprite:SetSpriteName ("hero_frame")

				iconSprite:SetAtlas ("hero", "heroAtlas")


				-- 獲取途徑類型 :
				-- 1 關卡 2 國戰 3 競技場 4 凜冬 5 珍寶閣 6 王者
				repeat
					local heroRow = SData_Hero.GetHeroData (localId)

					-- 讀表獲取類型爲int32
					local tujing = heroRow:ChanchuTujing ()


					-- 判斷獲取途徑
					if (tujing == 1) then
					-- 碎片關卡獲得
					do
						-- local mission = heroRow:HardMissionID ()

						-- 獲取關卡的 id 表 MissionIds
						local MissionIds = {}
						-- 控制 MissionIds 迭代賦值次數
						local missionIdN = 0
						-- 顯示物品框行數，每行顯示兩個
						local missionIdY = 0

						-- 拆分 mission 字符串匹配構造 MissionIds
						-- for k, v in string.gmatch (mission, "(%d+)|(%d+)") do
						-- 	missionIdN = missionIdN + 1
						-- 	MissionIds[missionIdN] = tonumber (k .. v)
						-- end

						MissionIds = heroRow:HardMissionID ()
						missionIdN = #MissionIds


						-- 如果無有效值
						-- if (mission == "-1") then
						-- 	MissionIds[1] = -1
						-- end

						-- 檢測是否無有效項
						if (missionIdN == 1) and (MissionIds[1] == -1) then
							-- Clear local
							-- mission    = nil
							MissionIds = nil
							missionIdN = nil
							missionIdY = nil
							break
						end



						if (missionIdN > 2) then
							-- 爲 missionIdY 賦值
							if ((missionIdN % 2) == 1) then
								-- missionIdN 奇數
								missionIdY = 60 * (missionIdN - 1) / 2
							else
								-- missionIdN 偶數
								missionIdY = 60 * (missionIdN - 2) / 2
							end


							-- 設置獲取途徑欄尺寸
							local gridWidget = self.gain_Grid:GetComponent (CMUIWidget.Name)
							local oldVector2 = gridWidget:GetSize ()
							self.DefaultVec  = oldVector2
							local newVector2 = Vector2.new (oldVector2.x, (oldVector2.y + missionIdY))

							-- 設置新尺寸
							gridWidget:SetSize (newVector2)
							-- gridWidget:SetSize (Vector2.new (560, 114 + missionIdY))	--按预设寫死尺寸

							-- 刷新碰撞器大小
							gridWidget:ResizeCollider ()

							-- 更改背景圖大小
							local grid_BG = self.gain_Grid:FindChild ("info_bg")
							grid_BG:GetComponent (CMUISprite.Name):SetSize (
								Vector2.new (oldVector2.x, (60 + missionIdY)))


							-- Clear local
							gridWidget = nil
							oldVector2 = nil
							newVector2 = nil
							grid_BG    = nil
						end


						-- 實例化途徑欄中的物品框
						local Table   = self.gain_Grid:FindChild ("Table")

						-- 更換圖集
						-- 實例化之前更換預設圖集
						self.gain_Item:FindChild ("icon"):GetComponent (CMUISprite.Name
							):SetAtlas ("core", "ui_guanqiaAtlas")

						-- 一共生成 missionIdN 個關卡框
						for i = 1, missionIdN do
							local itemObj = GameObject.InstantiateFromPreobj (self.gain_Item, Table)
							-- 設獲取途徑欄屬性
							itemObj:SetName ("items_" .. i)

							-- 爲減少SetActive調用
							-- 采用活動預設克隆實例
							-- itemObj:SetActive (true)

							-- 顯示關卡圖標和名字
							local iconSprite = itemObj:FindChild ("icon"):GetComponent (CMUISprite.Name)
							local nameLabel  = itemObj:FindChild ("name"):GetComponent (CMUILabel.Name)

							-- 設置關卡圖標和名字
							iconSprite:SetSpriteName (sdata_HardMission:GetV (sdata_HardMission.I__MissionChengPic, MissionIds[i]))
							nameLabel:SetValue (sdata_HardMission:GetV (sdata_HardMission.I_MissionName, MissionIds[i]))

							-- Clear local
							itemObj    = nil
							iconSprite = nil
							nameLabel  = nil
						end

						self.gain_Item:SetActive (false)

						Table:GetComponent (CMUITable.Name):Reposition ()

						-- 用於隱藏前銷毀動態生成的框
						self.gain_Count = missionIdN


						-- Clear local
						-- mission	   = nil
						MissionIds = nil
						missionIdN = nil
						missionIdY = nil
						Table      = nil
						break
					end


					elseif (tujing == 2) then
					-- 碎片國戰獲得
					do

						-- 更改獲取途徑UILabel
						-- [7024]={7024,"该武将碎片由国战产出"},
						self.get_Label:SetActive (true)
						self.get_Label:GetComponent (CMUILabel.Name):SetValue (_TXT (7024))


						-- 隱藏預設 self.gain_Item :
						self.gain_Item:SetActive (false)


						break
					end


					elseif (tujing == 3) then
					-- 碎片競技場獲得
					do

						-- 更改獲取途徑UILabel
						-- [7025]={7025,"该武将碎片由竞技场产出"},
						self.get_Label:SetActive (true)
						self.get_Label:GetComponent (CMUILabel.Name):SetValue (_TXT (7025))


						-- 隱藏預設 self.gain_Item :
						self.gain_Item:SetActive (false)


						break
					end


					elseif (tujing == 4) then
					-- 碎片凛冬獲得
					do

						-- 更改獲取途徑UILabel
						-- {7050,"该武将碎片由凛冬之征产出"},
						self.get_Label:SetActive (true)
						self.get_Label:GetComponent (CMUILabel.Name):SetValue (_TXT (7050))


						-- 隱藏預設 self.gain_Item :
						self.gain_Item:SetActive (false)


						break
					end


					elseif (tujing == 5) then
					-- 碎片珍寶閣獲得
					do

						-- 更改獲取途徑UILabel
						-- [7051]={7051,"该武将碎片由珍宝阁产出"},
						self.get_Label:SetActive (true)
						self.get_Label:GetComponent (CMUILabel.Name):SetValue (_TXT (7051))


						-- 隱藏預設 self.gain_Item :
						self.gain_Item:SetActive (false)


						break
					end


					elseif (tujing == 6) then
					-- 碎片王者競技獲得
					do

						-- 更改獲取途徑UILabel
						-- {10072,"该武将碎片由王者竞技场产出"},
						self.get_Label:SetActive (true)
						self.get_Label:GetComponent (CMUILabel.Name):SetValue (_TXT (10072))


						-- 隱藏預設 self.gain_Item :
						self.gain_Item:SetActive (false)


						break
					end


					elseif (tujing == -1) then
					-- 碎片無獲取途徑 ..
					do

						-- 隱藏預設 self.gain_Item :
						self.gain_Item:SetActive (false)


						print ("sdata_equiplist.Tujing is nil .")
						break
					end


					end

					-- Clear local
					heroRow = nil
					tujing  = nil
					break
				until (true)


				-- 獲取 info_Grids 容器
				local Grid   = self.gain_Grid:GetParent ()

				-- 刷新獲取欄位置
				Grid:GetComponent (CMUITable.Name):Reposition ()

				local Scroll = Grid:GetParent ():GetComponent (CMUIScrollView.Name)
				-- 重置詳細信息滾輪位置/清除上次滾動位置
				Scroll:ResetPosition ()


				-- Clear local :
				Grid   = nil
				Scroll = nil
			end


		elseif (wnd_beibao.ParamItem.sort == 3) then
			-- Soldiers :
			do
				-- 物品圖標設置
				frameObj:SetActive (true)

				frameSprite:SetSpriteName ("army_frame")
				iconSprite:SetAtlas ("ui_soldier", "soldierAtlas")


				-- 獲取途徑 關卡 PS : id 2000+ 兵種不通過關卡獲取
				-- 1 關卡 2 國戰 3 競技場 4 凜冬 5 珍寶閣 6 王者
				repeat
					-- C# 讀取 ArmyInfo
					local armyRow = SData_Army.GetRow (localId)


					local chanchu = armyRow:Chanchu ()

					-- 判斷獲取途徑
					if (chanchu == 1) then
						-- 關卡產出
						-- Nothing ..
						-- Just Continue execute ..
						-- else : {7052,"该士兵碎片不由关卡产出"},

					elseif (chanchu == 5) then
						-- 珍寶閣產出
						-- [7056]={7056,"该士兵碎片由珍宝阁产出"},

						-- Inactive gain_Item and active get_Label
						self.gain_Item:SetActive (false)
						self.get_Label:SetActive (true)
						self.get_Label:GetComponent (CMUILabel.Name):SetValue (_TXT (7056))

						break

					elseif (chanchu == 2) then
						-- 國戰產出
						-- [7053]={7053,"该士兵碎片由国战产出"},

						-- Inactive gain_Item and active get_Label
						self.gain_Item:SetActive (false)
						self.get_Label:SetActive (true)
						self.get_Label:GetComponent (CMUILabel.Name):SetValue (_TXT (7053))

						break

					elseif (chanchu == 3) then
						-- 競技場產出
						-- [7054]={7054,"该士兵碎片由竞技场产出"},

						-- Inactive gain_Item and active get_Label
						self.gain_Item:SetActive (false)
						self.get_Label:SetActive (true)
						self.get_Label:GetComponent (CMUILabel.Name):SetValue (_TXT (7054))

						break

					elseif (chanchu == 4) then
						-- 凜冬產出
						-- {7055,"该士兵碎片由凛冬之征产出"},

						-- Inactive gain_Item and active get_Label
						self.gain_Item:SetActive (false)
						self.get_Label:SetActive (true)
						self.get_Label:GetComponent (CMUILabel.Name):SetValue (_TXT (7055))

						break

					elseif (chanchu == 6) then
						-- 王者產出
						-- {7057,"该士兵碎片由王者竞技场产出"},

						-- Inactive gain_Item and active get_Label
						self.gain_Item:SetActive (false)
						self.get_Label:SetActive (true)
						self.get_Label:GetComponent (CMUILabel.Name):SetValue (_TXT (7057))

						break

					end


					-- 物品關卡獲得
					-- local mission = armyRow:MissionID ()

					-- 獲取關卡的 id 表 MissionIds
					local MissionIds = {}
					-- 控制 MissionIds 迭代賦值次數
					local missionIdN = 0
					-- 顯示物品框行數，每行顯示兩個
					local missionIdY = 0


					-- 如果無有效值
					-- if (mission == nil) then
					-- 	MissionIds[1] = -1
					-- else

						-- 拆分 mission 字符串匹配構造 MissionIds
						-- for k, v in string.gmatch (mission, "(%d+)|(%d+)") do
						-- 	missionIdN = missionIdN + 1
						-- 	MissionIds[missionIdN] = tonumber (k .. v)
						-- end
					-- end

					MissionIds = armyRow:MissionID ()
					missionIdN = #MissionIds


					-- 檢測是否無有效項
					if (missionIdN == 0) or (MissionIds[1] == -1) then
						-- Clear local
						-- mission    = nil
						MissionIds = nil
						missionIdN = nil
						missionIdY = nil
						break
					end



					if (missionIdN > 2) then
						-- 爲 missionIdY 賦值
						if ((missionIdN % 2) == 1) then
							-- missionIdN 奇數
							missionIdY = 60 * (missionIdN - 1) / 2
						else
							-- missionIdN 偶數
							missionIdY = 60 * (missionIdN - 2) / 2
						end


						-- 設置獲取途徑欄尺寸
						local gridWidget = self.gain_Grid:GetComponent (CMUIWidget.Name)
						local oldVector2 = gridWidget:GetSize ()
						self.DefaultVec  = oldVector2
						local newVector2 = Vector2.new (oldVector2.x, (oldVector2.y + missionIdY))

						-- 設置新尺寸
						gridWidget:SetSize (newVector2)
						-- gridWidget:SetSize (Vector2.new (560, 114 + missionIdY))	--按预设寫死尺寸

						-- 刷新碰撞器大小
						gridWidget:ResizeCollider ()

						-- 更改背景圖大小
						local grid_BG = self.gain_Grid:FindChild ("info_bg")
						grid_BG:GetComponent (CMUISprite.Name):SetSize (
							Vector2.new (oldVector2.x, (60 + missionIdY)))


						-- Clear local
						gridWidget = nil
						oldVector2 = nil
						newVector2 = nil
						grid_BG    = nil
					end


					-- 實例化途徑欄中的物品框
					local Table   = self.gain_Grid:FindChild ("Table")

					-- 更換圖集
					-- 在實例化關卡框之前更換預設圖集
					-- 不需更換 默認爲該圖集
					-- self.gain_Item:FindChild ("icon"):GetComponent (CMUISprite.Name
					-- 	):SetAtlas ("ui_guanka", "ui_guankaAtlas")

					-- 一共生成 missionIdN 個關卡框
					for i = 1, missionIdN do
						local itemObj = GameObject.InstantiateFromPreobj (self.gain_Item, Table)
						-- 設獲取途徑欄屬性
						itemObj:SetName ("items_" .. i)

						-- 爲減少SetActive調用
						-- 采用活動預設克隆實例
						-- itemObj:SetActive (true)

						-- 顯示關卡圖標和名字
						local iconSprite = itemObj:FindChild ("icon"):GetComponent (CMUISprite.Name)
						local nameLabel  = itemObj:FindChild ("name"):GetComponent (CMUILabel.Name)

						-- 設置關卡圖標和名字
						iconSprite:SetSpriteName (sdata_Mission:GetV (sdata_Mission.I__MissionChengPic, MissionIds[i]))
						nameLabel:SetValue (sdata_Mission:GetV (sdata_Mission.I_MissionName, MissionIds[i]))
						
						-- Clear local
						itemObj    = nil
						iconSprite = nil
						nameLabel  = nil
					end

					self.gain_Item:SetActive (false)

					Table:GetComponent (CMUITable.Name):Reposition ()

					-- 用於隱藏前銷毀動態生成的框
					self.gain_Count = missionIdN


					-- Clear local
					-- mission	   = nil
					chanchu    = nil
					MissionIds = nil
					missionIdN = nil
					missionIdY = nil
					Table      = nil
					break
				until (true)


				-- 獲取 info_Grids 容器
				local Grid   = self.gain_Grid:GetParent ()

				-- 刷新合成/裝備/獲取欄位置
				Grid:GetComponent (CMUITable.Name):Reposition ()

				local Scroll = Grid:GetParent ():GetComponent (CMUIScrollView.Name)
				-- 重置詳細信息滾輪位置/清除上次滾動位置
				Scroll:ResetPosition ()


				-- Clear local :
				Grid   = nil
				Scroll = nil
			end


		end

		-- Set the icon of item
		iconSprite:SetSpriteName (wnd_beibao.ParamItem.icon)


		-- Clear local value :
		iconSprite	= nil
		frameObj	= nil
		frameSprite	= nil
		localId		= nil
end

	else
		print ("item_popMenu:OnShowDone (); self.SelectMenu is invalid value !!!")
	end

	return nil
end


-- 確認出售
function item_popMenuClass:ConfirmSell ()
	local jsonDoc = JsonParse.SendNM ("SellItem")
	jsonDoc:Add ("t", wnd_beibao.ParamItem.sort)
	jsonDoc:Add ("i", wnd_beibao.ParamItem.itemI)
	jsonDoc:Add ("num", self.sellCount)
	local loader  = Loader.new (jsonDoc:ToString(), 0, "ReSellItem")
	LoaderEX.SendAndRecall (loader, self, self.NM_ReSellItem, nil)
end


-- 取消/返回
function item_popMenuClass:CancelSell ()
	-- 恢復默認出售數量顯示
	self.sellCount = 1

	self:Hide ()
end


-- 成功出售響應
function item_popMenuClass:NM_ReSellItem (reDoc)
	if (reDoc:GetValue ("result") == "0") then
		do
			-- 物品框的游戲物體id
			local item_I = 0

			local changedCount = tonumber (wnd_beibao.ParamItem.count) - self.sellCount


			-- 如果該物品賣完
			if (changedCount == 0) then
				-- Destroy the sell out item :
				if (wnd_beibao.ParamItem.objID < 10) then
					wnd_beibao.instance:FindWidget("item_list/item_scroll/Table/item_" .. "00" .. wnd_beibao.ParamItem.objID):Destroy ()
				elseif (wnd_beibao.ParamItem.objID < 100) then
					wnd_beibao.instance:FindWidget("item_list/item_scroll/Table/item_" .. "0" .. wnd_beibao.ParamItem.objID):Destroy ()
				else
					wnd_beibao.instance:FindWidget("item_list/item_scroll/Table/item_" .. wnd_beibao.ParamItem.objID):Destroy ()
				end


				-- Get UITable :
				local Table		 = wnd_beibao.m_Item:GetParent ()
				local cmUITable	 = Table:GetComponent (CMUITable.Name)

				-- Get UIScrollView :
				local cmUIScroll = Table:GetParent ():GetComponent (CMUIScrollView.Name)


				-- Now reposition UITable : 刷新物品框排列
				cmUITable:Reposition ()
				-- And update position of UIScrollView :
				-- 并返回該物品種類欄的頂端
				cmUIScroll:ResetPosition ()


				-- Reduse the count of the sell out item
				-- 未減少 itemCount heroCount armyCount 因：
				-- 未刷新前需要該三個變量來控制查找物體
				-- 當物品框全新刷新时，該三個變量重新複製
				wnd_beibao.lastCount = wnd_beibao.lastCount - 1
				wnd_beibao.destCount = wnd_beibao.destCount + 1

				-- 根據物品種類，清空該物品 TagItem :
				if (wnd_beibao.ParamItem.sort == 1) then
					item_I = wnd_beibao.ParamItem.objID
					wnd_beibao.TagItem.itemMat[item_I].num = ""
					wnd_beibao.TagItem.itemMat[item_I].id = -1

					-- 增加相應的物品種類的銷毀數量+1
					-- wnd_beibao.destItem = wnd_beibao.destItem + 1
				elseif (wnd_beibao.ParamItem.sort == 2) then
					item_I = wnd_beibao.ParamItem.objID - wnd_beibao.itemCount
					wnd_beibao.TagItem.itemMat[item_I].num = ""
					wnd_beibao.TagItem.itemMat[item_I].id = -1

					-- 增加相應的物品種類的銷毀數量+1
					-- wnd_beibao.destHero = wnd_beibao.destHero + 1
				elseif (wnd_beibao.ParamItem.sort == 3) then
					item_I = wnd_beibao.ParamItem.objID - wnd_beibao.itemCount - wnd_beibao.heroCount
					wnd_beibao.TagItem.itemMat[item_I].num = ""
					wnd_beibao.TagItem.itemMat[item_I].id = -1

					-- 增加相應的物品種類的銷毀數量+1
					-- wnd_beibao.destArmy = wnd_beibao.destArmy + 1
				end

				-- Hide the itemInfo-Panel :
				wnd_beibao.itemInfo:SetActive (false)

				-- Hide the sell window
				self:CancelSell ()

				-- 刷新主界面銅幣顯示
				wnd_main:ReLoadPlayerDataDisplay ()


				-- Clear local :
				changedCount = nil
				item_I		 = nil
				Table		 = nil
				cmUITable	 = nil
				Scroll		 = nil
				cmUIScroll	 = nil

				return nil
			end


			-- 以防在同一物體側邊欄再次點開出售該物品的顯示錯誤
			wnd_beibao.ParamItem.count = tostring (changedCount)

			-- 判斷物品種類來更改 wnd_beibao.TagItem :
			if (wnd_beibao.ParamItem.sort == 1) then
				item_I = wnd_beibao.ParamItem.objID
				wnd_beibao.TagItem.itemMat[item_I].num = tostring (changedCount)
			elseif (wnd_beibao.ParamItem.sort == 2) then
				item_I = wnd_beibao.ParamItem.objID - wnd_beibao.itemCount
				wnd_beibao.TagItem.itemHSP[item_I].num = tostring (changedCount)
			elseif (wnd_beibao.ParamItem.sort == 3) then
				item_I = wnd_beibao.ParamItem.objID - wnd_beibao.itemCount - wnd_beibao.heroCount
				wnd_beibao.TagItem.itemASP[item_I].num = tostring (changedCount)
			end


			-- Display the changed number of the sell item :
			wnd_beibao:SetLabel ("item_info/item_num/num", changedCount)
			if (wnd_beibao.ParamItem.objID < 10) then
				wnd_beibao:SetLabel ("item_list/item_scroll/Table/item_"
				.. "00" .. wnd_beibao.ParamItem.objID .. "/item_num", changedCount)
			elseif (wnd_beibao.ParamItem.objID < 100) then
				wnd_beibao:SetLabel ("item_list/item_scroll/Table/item_"
				.. "0" .. wnd_beibao.ParamItem.objID .. "/item_num", changedCount)
			else
				wnd_beibao:SetLabel ("item_list/item_scroll/Table/item_"
				.. wnd_beibao.ParamItem.objID .. "/item_num", changedCount)
			end

			-- 出售成功，隱藏出售窗口
			self:CancelSell ()


			-- 刷新主界面銅幣顯示
			wnd_main:ReLoadPlayerDataDisplay ()


			-- Clear local :
			changedCount = nil
			item_I		 = nil
		end

	else
		print ("The item sell is false !!!")
	end

end


-- 增加出售數量
function item_popMenuClass:CountIncrease ()
	-- Get the UIComponent :
	local slnumLabel  = self:GetLabel ("sell_menu/item_value/txt2")
	local amountLabel = self:GetLabel ("sell_menu/sell_amount/num")

	-- If greater than the maximum value :
	if (self.sellCount < tonumber (wnd_beibao.ParamItem.count)) then
		self.sellCount = self.sellCount + 1
		slnumLabel:SetValue (self.sellCount .. "/" .. wnd_beibao.ParamItem.count)

		local amountPrice = tonumber (wnd_beibao.ParamItem.price) * self.sellCount
		amountLabel:SetValue (amountPrice)

		amountPrice = nil
	end

	-- Clear local :
	slnumLabel  = nil
	amountLabel = nil

	return nil
end


-- 減少出售數量
function item_popMenuClass:CountDecrease ()
	-- Get the UIComponent :
	local slnumLabel  = self:GetLabel ("sell_menu/item_value/txt2")
	local amountLabel = self:GetLabel ("sell_menu/sell_amount/num")

	-- If more than one :
	if (self.sellCount > 1) then
		self.sellCount = self.sellCount - 1
		slnumLabel:SetValue (self.sellCount .. "/" .. wnd_beibao.ParamItem.count)

		local amountPrice = tonumber (wnd_beibao.ParamItem.price) * self.sellCount
		amountLabel:SetValue (amountPrice)

		amountPrice = nil
	end

	-- Clear local :
	slnumLabel  = nil
	amountLabel = nil

	return nil
end


-- 最大出售數量
function item_popMenuClass:CountMaximum ()
	-- Get the UIComponent :
	local slnumLabel  = self:GetLabel ("sell_menu/item_value/txt2")
	local amountLabel = self:GetLabel ("sell_menu/sell_amount/num")

	-- If not the maximum :
	if (self.sellCount ~= tonumber (wnd_beibao.ParamItem.count)) then
		self.sellCount = tonumber (wnd_beibao.ParamItem.count)
		slnumLabel:SetValue (self.sellCount .. "/" .. wnd_beibao.ParamItem.count)

		local amountPrice = tonumber (wnd_beibao.ParamItem.price) * self.sellCount
		amountLabel:SetValue (amountPrice)

		amountPrice = nil
	end

	-- Clear local :
	slnumLabel  = nil
	amountLabel = nil

	return nil
end


-- 點擊popMenu背景圖隱藏popMenu
function item_popMenuClass:JustHide ()
	if (self.SelectMenu == 1) then
		-- 物品出售返回
		self:CancelSell ()
	elseif (self.SelectMenu == 2) then
		-- 詳細信息面板返回
		-- Destroy older items :
		-- 取消預設生成，故取消銷毀 info_Grids
		-- 但需銷毀:：動態生成的 infoGrids/Table
		-- 容器下的：物品合成/裝備武將/獲取關卡
		local gameObject

		-- 獲取途徑，動態生成的關卡框銷毀
		for i = 1, self.gain_Count do
			gameObject = self.gain_Grid:FindChild ( "Table/items_" .. i)
			if (gameObject  ~= nil) then
				gameObject:Destroy ()
				gameObject	 = nil
			end
		end

		-- 恢復默認 info_Grids UIWidget Collider
		-- 以及info_bg 尺寸
		if (self.DefaultVec ~= nil) then
			local gridWidget = self.gain_Grid:GetComponent (
				CMUIWidget.Name)

			gridWidget:SetSize (self.DefaultVec)
			gridWidget:ResizeCollider ()

			self.gain_Grid:FindChild ("info_bg"):GetComponent (
				CMUISprite.Name):SetSize (Vector2.new (self.DefaultVec.x, 60))

			gridWidget = nil
		end


		-- -- 如果是材料/碎片
		if (wnd_beibao.ParamItem.sort == 1) then
			-- 合成裝備，動態生成的合成物品框銷毀
			for i = 1, self.forg_Count do
				gameObject = self.forg_Grid:FindChild ( "Table/items_" .. i)
				if (gameObject  ~= nil) then
					gameObject:Destroy ()
					gameObject	 = nil
				end
			end

			-- 恢復默認 info_Grids UIWidget Collider
			-- 以及info_bg 尺寸
			if (self.DefaultVec ~= nil) then
				local gridWidget = self.forg_Grid:GetComponent (
					CMUIWidget.Name)

				gridWidget:SetSize (self.DefaultVec)
				gridWidget:ResizeCollider ()

				self.forg_Grid:FindChild ("info_bg"):GetComponent (
					CMUISprite.Name):SetSize (Vector2.new (self.DefaultVec.x, 60))

				gridWidget = nil
			end


			-- 裝備武將，動態生成的裝備武將框銷毀
			for i = 1, self.hero_Count do
				gameObject = self.hero_Grid:FindChild ( "Table/items_" .. i)
				if (gameObject  ~= nil) then
					gameObject:Destroy ()
					gameObject	 = nil
				end
			end

			-- 恢復默認 info_Grids UIWidget Collider
			-- 以及info_bg 尺寸
			if (self.DefaultVec ~= nil) then
				local gridWidget = self.hero_Grid:GetComponent (
					CMUIWidget.Name)

				gridWidget:SetSize (self.DefaultVec)
				gridWidget:ResizeCollider ()

				self.hero_Grid:FindChild ("info_bg"):GetComponent (
					CMUISprite.Name):SetSize (Vector2.new (self.DefaultVec.x, 60))

				gridWidget = nil
			end

		elseif (wnd_beibao.ParamItem.sort == 2) then
			-- 如果是英雄碎片 則還原默認關卡圖集
			self.gain_Item:FindChild ("icon"):GetComponent (
				CMUISprite.Name):SetAtlas ("ui_guanka", "ui_guankaAtlas")
		end

		self:Hide ()

	else
		print ("It's error show and hide of PopMenu !!!")
	end
end



-- function item_popMenuClass:OnLostInstance ()
-- end



return item_popMenuClass.new