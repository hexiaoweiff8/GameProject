--wnd_dailytasks.lua 每日活動窗口
--StartDate : 2015/10/29 19:20; 2015/10/30 11:22;
--FirstDate : 2015/11/02 17:20; 2015/11/05 15:29;
--FinalDate : 
--Note : It's depend on other not yet completed modules ..
--RandyL-LJX


local wnd_dailytasksClass = class(wnd_base)

wnd_dailytasks = nil


--[[
	wnd_dailytasksClass :
		self.m_Item			--"Grid/frame"
		self.moonth_card	--rlq : <当日vip奖励是否已领取 int> :
							--#0未领取/不可領取 1已领取
		self.cardLevel		--月卡/年卡/十年卡
		self.boolValue		--全局32位Integer布爾位值
--]]

-- Huodong靜態表scv對應任務次數以及BoolValue-BitPosition :
local TaskInfosKey = {
	[0]  = { key = "",		boolID = -1 },	--Always Show
	[1]  = { key = "gkCS",	boolID =  1 },
	[2]  = { key = "cjCS",	boolID =  7 },
	[3]  = { key = "qhskCS",boolID =  8 },
	[4]  = { key = "qzCS",	boolID =  2 },
	[5]  = { key = "jyCS",	boolID =  6 },
	[6]  = { key = "jjcCS",	boolID =  3 },
	[7]  = { key = "qhCS",	boolID =  4 },
--	[8]  = { key = "sjCS",	boolID =  9 },	--廢棄
	[8]  = { key = "",		boolID = -1 },	--廢棄
	[9]  = { key = "gzCS",	boolID =  5 },
--	每日攻伐：Vip獎勵協議：
-- 	tsjl : { 1:{B:1, I:22, N:200}, 2:{B:1, I:17, N:120} }
	[10] = { key = "",		boolID = 10 },
	[11] = { key = "",		boolID = -1 },	--廢棄
	[12] = { key = "slzlCS",boolID = 12 },
	[13] = { key = "qxgjCS",boolID = 11 },
--	Moonth-Card not yet had boolID ... But in Charge-Window
	[14] = { key = "lvip",	boolID = -1 },
	[15] = { key = "lvip",	boolID = -1 },
	[16] = { key = "lvip",	boolID = -1 },
	[17] = { key = "",		boolID = -1 },	--Nothing
	[18] = { key = "ldzzCS",boolID = 13 },
	[19] = { key = "dfcs",	boolID = 14 },
}


function wnd_dailytasksClass:Start ()
	wnd_dailytasks = self
	self:Init (WND.DailyTasks, false)
	self.boolValue = nil
end


function wnd_dailytasksClass:OnNewInstance ()
	-- preset task-label :
	self.m_Item = self.instance:FindWidget ("Grid/frame")
	self.m_Item:SetActive (false)

	-- Today Moonth-Card whether already get :
	-- Or Cannot get rewards :
	self.moonth_card = 0

	-- The Moonth-Card's level :
	self.cardLevel	 = 0
end


-- After NewInstance displayed
function wnd_dailytasksClass:OnShowDone ()
	-- Destroy the older task-table :
	for i = 1, 15 do
		local gameObject = self.instance:FindWidget (
			"daily_fream/dailyScroll/Grid/task" .. i)
		if (gameObject  ~= nil) then
			gameObject:Destroy ()
			gameObject	 = nil
		end
	end


	-- First : Get/Reload Moon-Card's Info :
	local jsonDoc = JsonParse.SendNM ("YKInfo")
	local loader  = Loader.new (jsonDoc:ToString(), 0, "ReYKInfo")
	LoaderEX.SendAndRecall (loader, self, self.NM_ReYKInfo, nil)
end


-- Only fetch whether already get the Moonth-Card's reward :
function wnd_dailytasksClass:NM_ReYKInfo (reDoc)
	--rlq : <当日vip奖励是否已领取 int> : #0未领取 1已领取
	self.moonth_card = tonumber (reDoc:GetValue ("rlq"))


	-- Reload tasks' info and show it :
	self:ReLoadTasksInfo ()
end


-- To Get/Reload Tasks Info :
function wnd_dailytasksClass:ReLoadTasksInfo ()
	local jsonDoc = JsonParse.SendNM ("HDWndInfo")
	local loader  = Loader.new (jsonDoc:ToString(), 0, "ReHDWndInfo")
	LoaderEX.SendAndRecall (loader, self, self.NM_ReHDWndInfo, nil)
end


--[[
	jjcs:	<竞技场剩余挑战次数 int>,
	xdl:	<国战行动力 int>,
	jyc:	<已经胜利的精英章 int>,
	jym:	<已经胜利的精英节 int>,

	CJG:	<抽奖指引是否已经完成 int>,#1完成了 0尚未完成
	zy:		<国战阵营 int>,#1蜀 2魏 3吴 <1当前没选择阵营
	csLq:	<次数领取状态 int>#布尔位记法表示 :
			1-普通关 2-钱庄兑换 3-竞技场挑战 4-强化装备 5-打国战
			6-挑战精英关 7-抽奖 8-强化技能 9-收集 10-累计冲值每日奖励
			11-群雄割据玩法 12-试炼之路玩法 13-凛冬之争 14-巅峰竞技挑战

	#每日攻伐奖励信息
	tsjl: {
		<特殊奖励id int>: {
			B:<分类 int>,#1-道具
			I:<ID int>,
			N:<数量 int>
		},
		...}
--]]

-- Just load task's info ReCallBack-function :
function wnd_dailytasksClass:NM_ReHDWndInfo (reDoc)
	-- wnd_dailytasks:FillData (reDoc)
	-- do FillData Something :

	-- task's label count
	local n = 1

	local boolID		--32位Integer布爾位任務位bit
	local boolValue		--32位Integer布爾位讀取對象

	local alreadyNum	--任务已完成次数
	local maxConst		--任务所需次数

	-- Static-Tabel : local .scv to lua table :
	local HuodongStaticTable = require "sdata.sdata_huodong"
	local ItemStaticTable	 = require "sdata.sdata_itemdata"

	-- Construct a local 32BoolValue :
	if (self.boolValue == nil) then
		boolValue = I32BoolValue.new (tonumber (reDoc:GetValue ("csLq")))
		-- self.boolValue = I32BoolValue.new (boolValue:GetI32Value ())
	else
		boolValue = I32BoolValue.new (self.boolValue:GetI32Value ())
	end


	-- First traverse to display already complete tasks :
	for id, v in ipairs (TaskInfosKey) do
		-- just simulate the keyword continue :
		repeat
			-- Checkout whether the null task data :
			if (v.key ~= "") or (v.boolID ~= -1) then
				-- get boolID : BoolValue-BitPosition
				boolID = v.boolID


				-- If boolID == -1 : it's moonth-card awards :
				if (boolID == -1) then
					if (self.moonth_card == 0) then
						-- lvip: <可领取月卡的等级 int> :
						-- #0不可领取 1月卡 2季卡 3十年卡
						local cardLevel = tonumber (reDoc:GetValue (v.key)) + 13

						-- 爲全局cardLevel賦值
						self.cardLevel  = cardLevel

						-- If Moon-Card‘s level no match :
						if (id ~= cardLevel) then
							if (cardLevel  == 13) then
								self.moonth_card = 1
							end
							-- Clear local value :
							boolID	  = nil
							cardLevel = nil
							break
						end


						-- Show Moonth-Card's Task-Label :
						-- To load the task infomation and display :
						self:InstantiateTaskBar (n, boolID ,id, v, reDoc)

						-- Set completed's label, bar2 is active :
						local tableBt = self.instance:FindWidget ("task" .. n .. "/bar2")
						tableBt:SetActive (true)

						-- Set the "goto" button is inactive :
						local gotoBt  = self.instance:FindWidget ("task" .. n .. "/bar1/button")
						gotoBt:SetActive (false)

						-- Remove collider of the "bar1" :
						local bar1	  = self.instance:FindWidget ("task" .. n .. "/bar1")
						local colHdl  = bar1:GetComponent (CMBoxCollider.Name)
						bar1:RemoveComponent (colHdl)


						-- Clear local value :
						tableBt		= nil
						gotoBt		= nil
						bar1		= nil
						colHdl		= nil
						boolID		= nil
						cardLevel	= nil

						-- add n ( task's label count )
						n			= n + 1
						break
					else
						-- Clear local value :
						boolID		= nil
						cardLevel	= nil
						break
					end
				end


				-- If the task already get awards then to contine :
				if (boolValue:GetBool (boolID)) then
					boolID	  = nil
					break
				end


				-- If v.key == "" : it's Vip-Lev's awards :
				if (v.key == "") then
					-- If Vip-0 :
					if (reDoc:GetValue ("tsjl"):GetValue ("1"):GetValue ("N") == "0") then
						boolID = nil
						break
					end


					-- Show Vip-Lev's Task-Label :
					-- To load the task infomation and display :
					self:InstantiateTaskBar (n, boolID ,id, v, reDoc)

					-- Set completed's label, bar2 is active :
					local tableBt = self.instance:FindWidget ("task" .. n .. "/bar2")
					tableBt:SetActive (true)

					-- Set the "goto" button is inactive :
					local gotoBt  = self.instance:FindWidget ("task" .. n .. "/bar1/button")
					gotoBt:SetActive (false)

					-- Remove collider of the "bar1" :
					local bar1	  = self.instance:FindWidget ("task" .. n .. "/bar1")
					local colHdl  = bar1:GetComponent (CMBoxCollider.Name)
					bar1:RemoveComponent (colHdl)


					-- Clear local value :
					tableBt		= nil
					gotoBt		= nil
					bar1		= nil
					colHdl		= nil
					boolID		= nil

					-- add n ( task's label count )
					n			= n + 1
					break
				end


				-- Fetch the number of the task :
				maxConst   = tonumber (HuodongStaticTable:GetFieldV ("CostNum", id))
				alreadyNum = tonumber (reDoc:GetValue (v.key))

				-- Whether already completed and diaplay it :
				if (maxConst <= alreadyNum) then
					-- To load the task infomation and display :
					self:InstantiateTaskBar (n, boolID ,id, v, reDoc)

					-- Set completed's label, bar2 is active :
					local tableBt = self.instance:FindWidget ("task" .. n .. "/bar2")
					tableBt:SetActive (true)

					-- Set the "goto" button is inactive :
					local gotoBt  = self.instance:FindWidget ("task" .. n .. "/bar1/button")
					gotoBt:SetActive (false)

					-- Remove collider of the "bar1" :
					local bar1	  = self.instance:FindWidget ("task" .. n .. "/bar1")
					local colHdl  = bar1:GetComponent (CMBoxCollider.Name)
					bar1:RemoveComponent (colHdl)


					-- Clear local value :
					tableBt		= nil
					gotoBt		= nil
					bar1		= nil
					colHdl		= nil

					-- add n ( task's label count )
					n		   = n + 1
				end


				-- Clear local value :
				maxConst   = nil
				alreadyNum = nil
				boolID	   = nil
				break
			else
				break
			end
		until true
	end


	-- Always Show Const-Time-Shop :
	do
		local picSprite  = HuodongStaticTable:GetFieldV ("HuodongPic", 0)
		local nameSprite = HuodongStaticTable:GetFieldV ("HuodongName", 0)
		local txtContext = HuodongStaticTable:GetFieldV ("HuodongNote", 0)

		-- To load the task infomation and display :
		-- boolID = -1, id = 0, v = nil, reDoc = nil;
		self:InstantiateTaskBar (n, -1, 0, nil, nil, picSprite, nameSprite, txtContext)

		-- Clear local value :
		picSprite  = nil
		nameSprite = nil
		txtContext = nil

		-- add n ( task's label count )
		n		   = n + 1
	end


	-- Second traverse to display not yet complete tasks :
	for id, v in ipairs (TaskInfosKey) do
		-- just simulate the keyword continue :
		repeat
			-- Checkout whether the null task data :
			if (v.key ~= "") or (v.boolID ~= -1) then
				-- Fetch the number of the task :
				maxConst   = tonumber (HuodongStaticTable:GetFieldV ("CostNum", id))
				alreadyNum = tonumber (reDoc:GetValue (v.key))

				-- Whether already completed and diaplayed :
				-- id == 10 : alreadyNum == nil ;
				if (id ~= 10) and (maxConst <= alreadyNum) then
					maxConst   = nil
					alreadyNum = nil
					break
				end


				-- get boolID : BoolValue-BitPosition
				boolID     = v.boolID

				-- If boolID == -1 : it's moonth-card awards :
				if (boolID == -1) then
					maxConst   = nil
					alreadyNum = nil
					boolID	   = nil
					break
				end


				-- If the task already get awards then to contine :
				if (boolValue:GetBool (boolID)) then
					maxConst   = nil
					alreadyNum = nil
					boolID	   = nil
					break
				end


				-- 抽獎指引未完成
				if (id == 2) then
					local state = tonumber (reDoc:GetValue ("CJG"))
					if (state == 0) then
						maxConst   = nil
						alreadyNum = nil
						boolID	   = nil
						break
					end
					state = nil
				end


				-- 國戰未加入國家
				if (id == 9) then
					local state = tonumber (reDoc:GetValue ("zy"))
					if (state < 1) then
						maxConst   = nil
						alreadyNum = nil
						boolID	   = nil
						break
					end
					state = nil
				end


				-- If v.key == "" : it's Vip-Lev's awards :
				if (v.key == "") then
					maxConst   = nil
					alreadyNum = nil
					boolID	   = nil
					break
				end


				-- To load the task infomation and display :
				self:InstantiateTaskBar (n, boolID , id, v, reDoc)


				-- Clear local value :
				maxConst   = nil
				alreadyNum = nil
				boolID	   = nil

				-- add n ( task's label count )
				n		   = n + 1
				break
			else
				break
			end
		until true
	end

	-- Final Clear :
	n = nil
	HuodongStaticTable = nil
	ItemStaticTable	   = nil
	boolValue		   = nil
end


--[[
	It's below function's arguments :
	local arg :
	[1] = n, [2] = boolID, [3] = id, [4] = v, [5] = reDoc,
	[6] = picSprite, [7] = nameSprite, [8] = txtContext,
	Example invoke :
	self:InstantiateTaskBar (n, boolID, id, v, reDoc)
	Or :
	self:InstantiateTaskBar (n, boolID, id, v, reDoc, picSprite,
		nameSprite, txtContext)
--]]

-- Create new Task-Label :
function wnd_dailytasksClass:InstantiateTaskBar (...)
	-- 定義局部arg可變參數賦值
	local arg = { ... }

	-- Static-Tabel : local .scv to lua table :
	local HuodongStaticTable = require "sdata.sdata_huodong"
	local ItemStaticTable	 = require "sdata.sdata_itemdata"


	-- 獲取Grid任務條容器/父物體
	local Panel   = self.m_Item:GetParent ()

	-- 實例化新的任務條
	local itemObj = GameObject.InstantiateFromPreobj (self.m_Item, Panel)

	-- 設任務條屬性
	itemObj:SetLocalPosition (Vector3.new (0, - (arg[1] - 1) * 160, 0))
	itemObj:SetName ("task" .. arg[1])
	itemObj:SetActive (true)



	local picSprite		--任务图片UISprite
	local nameSprite	--名字图片UISprite
	local txtContext	--UILabel文本内容
	local alreadyNum	--任务已完成次数
	local maxConst		--任务所需次数
	local Awards    = {}--任務獎勵表
	local trueAward = {}--獎勵圖標數量表

	local bookName1		--壹獎勵圖標分類
	local bookName2		--貳獎勵圖標分類
	local bookName3		--叁獎勵圖標分類
	local itemID1		--壹獎勵圖標ID
	local itemID2		--貳獎勵圖標ID
	local itemID3		--叁獎勵圖標ID
	local awardNum1		--壹獎勵圖標數量
	local awardNum2		--貳獎勵圖標數量
	local awardNum3		--叁獎勵圖標數量


	-- 檢查函數參數
	if (#arg == 5) then
do
	-- Fetch task's data :
	if (arg[3] ~= 10) and (arg[2] ~= -1) then
	-- Not Vip-Reward or Moonth-Card's task :
	alreadyNum = arg[5]:GetValue (arg[4].key)
	maxConst   = HuodongStaticTable:GetFieldV ("CostNum", arg[3])
	end
	picSprite  = HuodongStaticTable:GetFieldV ("HuodongPic", arg[3])
	nameSprite = HuodongStaticTable:GetFieldV ("HuodongName", arg[3])
	txtContext = HuodongStaticTable:GetFieldV ("HuodongNote", arg[3])
end
	elseif (#arg == 8) then
do
	picSprite  = arg[6]
	nameSprite = arg[7]
	txtContext = arg[8]
end
	else
		print ("It's arg error!")
	end


	-- Fetch task's data in order to construct awards :
	bookName1  = HuodongStaticTable:GetFieldV ("BookName1", arg[3])
	bookName2  = HuodongStaticTable:GetFieldV ("BookName2", arg[3])
	bookName3  = HuodongStaticTable:GetFieldV ("BookName3", arg[3])
	itemID1    = HuodongStaticTable:GetFieldV ("ItemID1", arg[3])
	itemID2    = HuodongStaticTable:GetFieldV ("ItemID2", arg[3])
	itemID3    = HuodongStaticTable:GetFieldV ("ItemID3", arg[3])
	awardNum1  = HuodongStaticTable:GetFieldV ("Num1", arg[3])
	awardNum2  = HuodongStaticTable:GetFieldV ("Num2", arg[3])
	awardNum3  = HuodongStaticTable:GetFieldV ("Num3", arg[3])


	-- Construct Awards :
	if (bookName1 ~= -1) then
		Awards[1]  = { B = bookName1, I = itemID1, N = awardNum1 }

	if (bookName2 ~= -1) then
		Awards[2]  = { B = bookName2, I = itemID2, N = awardNum2 }

	if (bookName3 ~= -1) then
		Awards[3]  = { B = bookName3, I = itemID3, N = awardNum3 }
	else
		Awards[3]  = { B = nil, I = nil, N = "" }
			end
	else
		Awards[2]  = { B = nil, I = nil, N = "" }
		Awards[3]  = { B = nil, I = nil, N = "" }
		end
	else
		Awards[1]  = { B = nil, I = nil, N = "" }
		Awards[2]  = { B = nil, I = nil, N = "" }
		Awards[3]  = { B = nil, I = nil, N = "" }
	end


	-- First constructe the trueAward :
	trueAward = {
		[1] = { icon = nil, num = "" },
		[2] = { icon = nil, num = "" },
		[3] = { icon = nil, num = "" },
	}

	-- Then Awards/awardVip to true icon-Awards : trueAward :
	if (Awards[1].B == 1) then
		-- It's Awards, to read local static table :
		trueAward[1] = {
			icon = ItemStaticTable:GetFieldV ("IconBig", Awards[1].I),
			num  = Awards[1].N,
		}
	if (Awards[2].B == 1) then
		trueAward[2] = {
			icon = ItemStaticTable:GetFieldV ("IconBig", Awards[2].I),
			num  = Awards[2].N,
		}
	if (Awards[3].B == 1) then
		trueAward[3] = {
			icon = ItemStaticTable:GetFieldV ("IconBig", Awards[3].I),
			num  = Awards[3].N,
		}
			else
				-- Nothing
				-- trueAward[3] = { icon = nil, num = "" }
			end
		else
			-- Nothing
			-- trueAward[2] = { icon = nil, num = "" }
			-- trueAward[3] = { icon = nil, num = "" }
		end
	elseif (Awards[1].B == 7) then
		-- It's awardVip, to fetch server task data :
		local temp

		-- 每日攻伐獎勵
		local awardVip = arg[5]:GetValue ("tsjl")

		temp	 = awardVip:GetValue ("1")

		if (temp ~= nil) and (temp:GetValue ("B") == "1") and (temp:GetValue ("N") ~= "-1") then
			trueAward[1] = {
				icon = ItemStaticTable:GetFieldV ("IconBig",
					tonumber (temp:GetValue ("I")) ),
				num  = temp:GetValue ("N"),
			}

			temp	 = awardVip:GetValue ("2")
		if (temp ~= nil) and (temp:GetValue ("B") == "1") and (temp:GetValue ("N") ~= "-1") then
			trueAward[2] = {
				icon = ItemStaticTable:GetFieldV ("IconBig",
					tonumber (temp:GetValue ("I")) ),
				num  = temp:GetValue ("N"),
			}

			temp	 = awardVip:GetValue ("3")
		if (temp == nil) or (temp:GetValue ("B") ~= "1") or (temp:GetValue ("N") ~= "-1") then
			-- Nothing
			-- trueAward[3] = { icon = nil, num = "" }
			awardVip = nil
			temp	 = nil
				else
					-- Nothing
					-- trueAward[3] = { icon = nil, num = "" }
					awardVip = nil
					temp	 = nil
					print ("It's a 'tsjl' awardVip error !")
				end
			else
				-- Nothing
				-- trueAward[2] = { icon = nil, num = "" }
				-- trueAward[3] = { icon = nil, num = "" }
				awardVip = nil
				temp	 = nil
				print ("awardVip : 'tsjl' had one reward .")
			end
		else
			-- Nothing
			-- trueAward[1] = { icon = nil, num = "" }
			-- trueAward[2] = { icon = nil, num = "" }
			-- trueAward[3] = { icon = nil, num = "" }
			awardVip = nil
			temp	 = nil
			print ("It's a 'tsjl' awardVip error !")
		end
	else
		-- Nothing
		-- trueAward[1] = { icon = nil, num = "" }
		-- trueAward[2] = { icon = nil, num = "" }
		-- trueAward[3] = { icon = nil, num = "" }
	end



	local taskTemp		--to memory the gameObject
	local spritePic		--任務圖標
	local spriteName	--名字圖標
	local labelCount	--完成次數
	local labelInfo		--任務信息
	local spriteAward1	--壹獎勵圖標
	local spriteAward2	--貳獎勵圖標
	local spriteAward3	--叁獎勵圖標
	local labelAward1	--壹獎勵數量
	local labelAward2	--貳獎勵數量
	local labelAward3	--叁獎勵數量


	-- 任務圖標
	-- spritePic = self:GetSprite ("task" .. arg[1] .. "/bar1/icon")
	taskTemp  = itemObj:FindChild ("bar1/icon")
	spritePic = taskTemp:GetComponent (CMUISprite.Name)
	spritePic:SetSpriteName (picSprite)

	-- 名字圖標
	-- spriteName = self:GetSprite ("task" .. arg[1] .. "/bar1/titleframe/titletext")
	taskTemp   = itemObj:FindChild ("bar1/titleframe/titletext")
	spriteName = taskTemp:GetComponent (CMUISprite.Name)
	spriteName:SetSpriteName (nameSprite)


	-- 完成次數
	-- labelCount = self:GetLabel ("task" .. arg[1] .. "/bar1/titleframe/numtext")
	taskTemp   = itemObj:FindChild ("bar1/titleframe/numtext")
	labelCount = taskTemp:GetComponent (CMUILabel.Name)

	-- 任務信息
	labelInfo = self:GetLabel ("task" .. arg[1] .. "/bar1/explain")
	-- taskTemp  = itemObj:FindChild ("bar1/explain")
	-- labelInfo = taskTemp:GetComponent (CMUILabel.Name)


	-- If the task is vip or moonth-card :
	-- and Const-Time-Shop :
	if (arg[2] ~= -1) and (#arg == 5) and (arg[3] ~= 10) then
		labelCount:SetValue (alreadyNum .. "/" .. maxConst)
		labelInfo :SetValue (string.sformat (txtContext, maxConst))
	else
		labelCount:SetValue ("")
		labelInfo :SetValue (txtContext)
	end


	-- 獎勵圖標和數量：

	-- 資源/材料壹
	-- spriteAward1 = self:GetSprite ("task" .. arg[1] .. "/bar1/daily_reward 1/icon")
	taskTemp     = itemObj:FindChild ("bar1/daily_reward 1/icon")
	spriteAward1 = taskTemp:GetComponent (CMUISprite.Name)
	spriteAward1:SetSpriteName (trueAward[1].icon)

	-- labelAward1 = self:GetLabel ("task" .. arg[1] .. "/bar1/daily_reward 1/num")
	taskTemp    = itemObj:FindChild ("bar1/daily_reward 1/num")
	labelAward1 = taskTemp:GetComponent (CMUILabel.Name)
	labelAward1:SetValue (trueAward[1].num)

	-- 資源/材料貳
	-- spriteAward2 = self:GetSprite ("task" .. arg[1] .. "/bar1/daily_reward 2/icon")
	taskTemp     = itemObj:FindChild ("bar1/daily_reward 2/icon")
	spriteAward2 = taskTemp:GetComponent (CMUISprite.Name)
	spriteAward2:SetSpriteName (trueAward[2].icon)

	-- labelAward2 = self:GetLabel ("task" .. arg[1] .. "/bar1/daily_reward 2/num")
	taskTemp    = itemObj:FindChild ("bar1/daily_reward 2/num")
	labelAward2 = taskTemp:GetComponent (CMUILabel.Name)
	labelAward2:SetValue (trueAward[2].num)

	-- 資源/材料叁
	-- spriteAward3 = self:GetSprite ("task" .. arg[1] .. "/bar1/daily_reward 3/icon")
	taskTemp     = itemObj:FindChild ("bar1/daily_reward 3/icon")
	spriteAward3 = taskTemp:GetComponent (CMUISprite.Name)
	spriteAward3:SetSpriteName (trueAward[3].icon)

	-- labelAward3 = self:GetLabel ("task" .. arg[1] .. "/bar1/daily_reward 3/num")
	taskTemp    = itemObj:FindChild ("bar1/daily_reward 3/num")
	labelAward3 = taskTemp:GetComponent (CMUILabel.Name)
	labelAward3:SetValue (trueAward[3].num)


	-- Bind event listener :
	self:BindUIEvent ("task" .. arg[1] .. "/bar1/button", UIEventType.Click, "OnGotoClick", arg[3])
	self:BindUIEvent ("task" .. arg[1] .. "/bar2", UIEventType.Click, "OnGetClick", arg[3])


	-- Clear local value :
	arg			 = nil
	Panel		 = nil
	itemObj		 = nil

	picSprite	 = nil
	nameSprite	 = nil
	txtContext	 = nil
	alreadyNum	 = nil
	maxConst	 = nil
	Awards		 = nil
	trueAward	 = nil

	bookName1	 = nil
	bookName2	 = nil
	bookName3	 = nil
	itemID1		 = nil
	itemID2		 = nil
	itemID3		 = nil
	awardNum1	 = nil
	awardNum2	 = nil
	awardNum3	 = nil

	taskTemp	 = nil
	spritePic	 = nil
	spriteName	 = nil
	labelCount	 = nil
	labelInfo	 = nil
	spriteAward1 = nil
	spriteAward2 = nil
	spriteAward3 = nil
	labelAward1	 = nil
	labelAward2	 = nil
	labelAward3	 = nil

	return nil
end


-- Do something can be completed the task :
function wnd_dailytasksClass:OnGotoClick (gameObject, id)
	if (id == 0) then
		-- 定時商店
		wnd_background:quitNowWindon ()
	elseif (id ==  1) then
		-- 每日征戰
		wnd_background:quitNowWindon ()
		wnd_guanka:Show ()
	elseif (id ==  2) then
		-- 開啓寶箱
		wnd_background:quitNowWindon ()
	elseif (id ==  3) then
		-- 技能提升
		wnd_background:quitNowWindon ()
	elseif (id ==  4) then
		-- 錢莊兌換
		wnd_background:quitNowWindon ()
		wnd_qianzhuang:Show ()
	elseif (id ==  5) then
		-- 挑戰精英
		wnd_background:quitNowWindon ()
	elseif (id ==  6) then
		-- 競技挑戰
		wnd_background:quitNowWindon ()
		wnd_main:OnJingJiClick ()
	elseif (id ==  7) then
		-- 裝備強化
		wnd_background:quitNowWindon ()
	elseif (id ==  9) then
		-- 國戰
		wnd_background:quitNowWindon ()
	elseif (id == 12) then
		-- 試煉之路
		wnd_background:quitNowWindon ()
	elseif (id == 13) then
		-- 群雄割據
		wnd_background:quitNowWindon ()
	elseif (id == 18) then
		-- 澪東之爭
		wnd_background:quitNowWindon ()
	elseif (id == 19) then
		-- 挑戰王者
		wnd_background:quitNowWindon ()
	end
end


-- Do something can be handled the getting :
function wnd_dailytasksClass:OnGetClick (gameObject, id)
	-- if (id == 14) then
	-- 	-- 超值禮包/月卡
	-- elseif (id == 15) then
	-- 	-- 超值禮包/年卡
	-- elseif (id == 16) then
	-- 	-- 超值禮包/十年卡
	-- elseif (id == 10) then
	-- 	-- 每日攻伐/Vip每日獎勵
	-- elseif (id ==  1) then
	-- 	-- 每日征戰
	-- elseif (id ==  2) then
	-- 	-- 開啓寶箱
	-- elseif (id ==  3) then
	-- 	-- 技能提升
	-- elseif (id ==  4) then
	-- 	-- 錢莊兌換
	-- elseif (id ==  5) then
	-- 	-- 挑戰精英
	-- elseif (id ==  6) then
	-- 	-- 競技挑戰
	-- elseif (id ==  7) then
	-- 	-- 裝備強化
	-- elseif (id ==  9) then
	-- 	-- 國戰
	-- elseif (id == 12) then
	-- 	-- 試煉之路
	-- elseif (id == 13) then
	-- 	-- 群雄割據
	-- elseif (id == 18) then
	-- 	-- 澪東之爭
	-- elseif (id == 19) then
	-- 	-- 挑戰王者
	-- end


	if (id == 14) or (id == 15) or (id == 16) then
		-- The moon-card's reward :
		local jsonDoc = JsonParse.SendNM ("LQYKJL")
		jsonDoc:Add ("m", 2)
		-- jsonDoc:Add ("lv", id - 13)
		local loader  = Loader.new (jsonDoc:ToString(), 0, "ReLQYKJL")
		LoaderEX.SendAndRecall (loader, self, self.NM_ReLQYKJL, nil)

	else
		-- Other rewards :
		local jsonDoc = JsonParse.SendNM ("HDJL")
		jsonDoc:Add ("i", id)
		local loader  = Loader.new (jsonDoc:ToString(), 0, "ReHDJL")
		LoaderEX.SendAndRecall (loader, self, self.NM_ReHDJL, nil)
	end
end


--[[
	n:		ReHDJL,
	i:		<活动id int>,
	result:	<处理结果 int> #0-成功 1-非法领取 99-未知错误,

	#領取獎勵信息：
	JL : {
		<奖励id : nil/null !!>: {
			B:<分类 int>,#1-道具
			I:<ID int>,
			N:<数量 int>
		},
		...}
--]]

-- Callback function of the award's getting
-- And show the rewardBox :
function wnd_dailytasksClass:NM_ReHDJL (reDoc)
	local result = reDoc:GetValue ("result")
	local reward = reDoc:GetValue ("JL")
	local id	 = reDoc:GetValue ("i")

	-- The arguments' number :
	local count  = 0
	-- The arguments' table :
	local Awards = {}

	-- Static-Tabel : local .scv to lua table :
	local ItemStaticTable = require "sdata.sdata_itemdata"


	-- If it's error :
	if (result ~= "0") then
		result = nil
		reward = nil
		id	   = nil
		count  = nil
		Awards = nil
		ItemStaticTable = nil
		
		print ("the id is :" .. id .. " task is wrong !")
		self:OnShowDone ()
		return nil
	end


	-- Refresh wnd_mian displayed player's data :
	if (wnd_main.instance ~= nil) then
		wnd_main:ReLoadPlayerDataDisplay ()
	end


	-- Construct the arguments :
do
	local rewardEachFunc   = function (num, value)
		count = count + 1

		-- num == -1 means is temp value :
		if (value:GetValue ("N") ~= "-1") then
			Awards[count]	   = { icon = nil, num = "" }

			local itemID	   = tonumber (value:GetValue("I"))
			Awards[count].icon = ItemStaticTable:GetFieldV ("IconBig", itemID)
			Awards[count].num  = value:GetValue("N")

			itemID = nil
		else
			count = count - 1
		end
	end

	-- 遍歷協議返回獎勵
	reward:Foreach (rewardEachFunc)
end


	-- Show RewardBox :
	-- 檢查幾個參數
	if (count == 1) then
		wnd_rewardbox:ShowRewardMsg (Awards[1].icon, Awards[1].num)
	elseif (count == 2) then
		wnd_rewardbox:ShowRewardMsg (Awards[1].icon, Awards[1].num, Awards[2].icon, Awards[2].num)
	elseif (count == 3) then
		wnd_rewardbox:ShowRewardMsg (Awards[1].icon, Awards[1].num, Awards[2].icon, Awards[2].num, Awards[3].icon, Awards[3].num)
	elseif (count == 4) then
		wnd_rewardbox:ShowRewardMsg (Awards[1].icon, Awards[1].num, Awards[2].icon, Awards[2].num, Awards[3].icon, Awards[3].num, Awards[4].icon, Awards[4].num)
	else
		print ("The Show RewardBox's arguments is error ! :" .. tostring (count))
	end

	-- Reflash tasks' table :
	self:OnShowDone ()


	-- Clear local :
	result = nil
	reward = nil
	id	   = nil
	count  = nil
	Awards = nil
	ItemStaticTable = nil

	return nil
end


--[[
	n:		ReLQYKJL,
	m:		<领取模式 int> #1领取首次奖励 2领取本日奖励
	result:	<处理结果码> #0成功 1重复领取 99未知错误
--]]

-- Callback function of the moon-card's getting
-- (or show the msbBox) :
function wnd_dailytasksClass:NM_ReLQYKJL (reDoc)
	local result = tonumber (reDoc:GetValue ("result"))
	if (result ~= 0) then
		result = nil
		-- 暫時不知道重複領取是什麽情況 ..
		print ("the moon-card's getting is wrong !")
		self:OnShowDone ()
		return nil
	end


	-- Refresh wnd_mian displayed player's data :
	if (wnd_main.instance ~= nil) then
		wnd_main:ReLoadPlayerDataDisplay ()
	end


	if (self.cardLevel == 13) or (self.cardLevel == 0) then
		print ("It's cardLevel's error !!!")
	end


	local trueAward = {}--獎勵圖標數量表

	-- Construct rewards' arguments :
do
	-- Static-Tabel : local .scv to lua table :
	local HuodongStaticTable = require "sdata.sdata_huodong"
	local ItemStaticTable	 = require "sdata.sdata_itemdata"

	local bookName1		--壹獎勵圖標分類
	local bookName2		--貳獎勵圖標分類
	local bookName3		--叁獎勵圖標分類
	local itemID1		--壹獎勵圖標ID
	local itemID2		--貳獎勵圖標ID
	local itemID3		--叁獎勵圖標ID
	local awardNum1		--壹獎勵圖標數量
	local awardNum2		--貳獎勵圖標數量
	local awardNum3		--叁獎勵圖標數量
	local Awards    = {}--任務獎勵表


	-- Fetch task's data in order to construct awards :
	bookName1  = HuodongStaticTable:GetFieldV ("BookName1", self.cardLevel)
	bookName2  = HuodongStaticTable:GetFieldV ("BookName2", self.cardLevel)
	bookName3  = HuodongStaticTable:GetFieldV ("BookName3", self.cardLevel)
	itemID1    = HuodongStaticTable:GetFieldV ("ItemID1", self.cardLevel)
	itemID2    = HuodongStaticTable:GetFieldV ("ItemID2", self.cardLevel)
	itemID3    = HuodongStaticTable:GetFieldV ("ItemID3", self.cardLevel)
	awardNum1  = HuodongStaticTable:GetFieldV ("Num1", self.cardLevel)
	awardNum2  = HuodongStaticTable:GetFieldV ("Num2", self.cardLevel)
	awardNum3  = HuodongStaticTable:GetFieldV ("Num3", self.cardLevel)


	-- Construct Awards :
	Awards[1] = { B = bookName1, I = itemID1, N = awardNum1 }
	Awards[2] = { B = bookName2, I = itemID2, N = awardNum2 }
	if (bookName3 ~= -1) then
		Awards[3]  = { B = bookName3, I = itemID3, N = awardNum3 }
	else
		Awards[3]  = { B = nil, I = nil, N = "" }
	end


	-- First constructe the trueAward :
	trueAward = {
		[1] = { icon = nil, num = "" },
		[2] = { icon = nil, num = "" },
		[3] = { icon = nil, num = "" },
	}

	-- Then Awards/awardVip to true icon-Awards : trueAward :
	if (Awards[1].B == 1) then
		-- It's Awards, to read local static table :
		trueAward[1] = {
			icon = ItemStaticTable:GetFieldV ("IconBig", Awards[1].I),
			num  = Awards[1].N,
		}
	if (Awards[2].B == 1) then
		trueAward[2] = {
			icon = ItemStaticTable:GetFieldV ("IconBig", Awards[2].I),
			num  = Awards[2].N,
		}
	if (Awards[3].B == 1) then
		trueAward[3] = {
			icon = ItemStaticTable:GetFieldV ("IconBig", Awards[3].I),
			num  = Awards[3].N,
		}
	elseif (Awards[3].B == nil) then
		-- Nothing
		-- trueAward[3] = { icon = nil, num = "" }
			else
				print ("Moonth-Card's argument:Awards[3] wrong !!!")
			end
		else
			-- Nothing
			-- trueAward[2] = { icon = nil, num = "" }
			-- trueAward[3] = { icon = nil, num = "" }
			print ("Moonth-Card's argument : Awards[2] wrong !!!")
		end
	else
		-- Nothing
		-- trueAward[1] = { icon = nil, num = "" }
		-- trueAward[2] = { icon = nil, num = "" }
		-- trueAward[3] = { icon = nil, num = "" }
		print ("Moonth-Card's argument : Awards[1] wrong !!!")
	end


	-- Clear local :
	HuodongStaticTable = nil
	ItemStaticTable	   = nil

	bookName1 = nil
	bookName2 = nil
	bookName3 = nil
	itemID1	  = nil
	itemID2	  = nil
	itemID3	  = nil
	awardNum1 = nil
	awardNum2 = nil
	awardNum3 =	nil
	Awards	  = nil

end


	-- Show RewardBox :
do
	-- 判斷trueAward有幾個獎勵
	if (trueAward[3].icon ~= nil) then
		wnd_rewardbox:ShowRewardMsg (trueAward[1].icon, trueAward[1].num, trueAward[2].icon, trueAward[2].num, trueAward[3].icon, trueAward[3].num)
	elseif (trueAward[2].icon ~= nil) then
		wnd_rewardbox:ShowRewardMsg (trueAward[1].icon, trueAward[1].num, trueAward[2].icon, trueAward[2].num)
	elseif (trueAward[1].icon ~= nil) then
		wnd_rewardbox:ShowRewardMsg (trueAward[1].icon, trueAward[1].num)
	else
		print ("Moonth-Card is wrong !!!")
	end
end

	-- Reflash tasks' table :
	self:OnShowDone ()


	-- Clear local :
	result	  = nil
	trueAward = nil

	return nil
end



-- function wnd_dailytasksClass:OnLostInstance ()
-- end



return wnd_dailytasksClass.new