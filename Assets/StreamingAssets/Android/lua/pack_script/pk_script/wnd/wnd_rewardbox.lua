--wnd_rewardbox.lua 獎勵彈窗
--StartDate : 2015/11/4 17:05;
--FirstDate : 2015/11/4 21:38;
--Note : Nothing ..
--RandyL-LJX


local wnd_rewardboxClass = class(wnd_base)

wnd_rewardbox = nil


local Awards = {}


function wnd_rewardboxClass:Start ()
	wnd_rewardbox = self
	self:Init (WND.RewardBox, false)
end


function wnd_rewardboxClass:OnNewInstance ()
	self:BindUIEvent ("btn1", UIEventType.Click, "OnConfirmClick")
end


-- Hide the rewardBox :
function wnd_rewardboxClass:OnConfirmClick ()
	local gameObject

	do
		-- Set the reward's gameObject is inactive :
		gameObject = self.instance:FindWidget ("bg/reward1")
		gameObject:SetActive (false)

		gameObject = self.instance:FindWidget ("bg/reward2")
		gameObject:SetActive (false)

		gameObject = self.instance:FindWidget ("bg/reward3")
		gameObject:SetActive (false)

		gameObject = self.instance:FindWidget ("bg/reward4")
		gameObject:SetActive (false)

		gameObject = self.instance:FindWidget ("bg/reward5")
		gameObject:SetActive (false)

		gameObject = self.instance:FindWidget ("bg/reward6")
		gameObject:SetActive (false)

		gameObject = self.instance:FindWidget ("bg/reward7")
		gameObject:SetActive (false)
	end


	self:Hide ()
end


--[[
	It's below function's arguments :
	local Awards :
	[1] = spriteAward1, [2] = labelAward1,
	[3] = spriteAward2, [4] = labelAward2,
	[5] = spriteAward3, [6] = labelAward3,
	[7] = spriteAward4, [8] = labelAward4,
	Example invoke :
	One reward :
	wnd_rewardbox:ShowRewardMsg (spriteAward1, labelAward1)
	Or two reward :
	wnd_rewardbox:ShowRewardMsg (spriteAward1, labelAward1, spriteAward2, labelAward2)
	Or three reward :
	wnd_rewardbox:ShowRewardMsg (spriteAward1, labelAward1, spriteAward2, labelAward2, spriteAward3, labelAward3)
	Or four reward :
	wnd_rewardbox:ShowRewardMsg (spriteAward1, labelAward1, spriteAward2, labelAward2, spriteAward3, labelAward3, spriteAward4, labelAward4)
--]]

-- Fill the reward's info and display it :
function wnd_rewardboxClass:ShowRewardMsg (...)
	-- 可變參數賦值構造Awards
	Awards = { ... }

	self:Show ()
end


function wnd_rewardboxClass:OnShowDone ()
	if self.instance:IsNewInstance () then
		print ("IsNewInstance :")
	end


	-- 聲明本地變量
	local gameObject
	local sprite1
	local sprite2
	local sprite3
	local sprite4
	local label1
	local label2
	local label3
	local label4


	-- 衹有一個獎勵物品
	if (#Awards == 2) then

		do
			-- 壹 :
			-- Set the reward's gameObejct is active :
			gameObject = self.instance:FindWidget ("bg/reward7")
			gameObject:SetActive (true)

			sprite1 = self:GetSprite ("bg/reward7/icon")
			sprite1:SetSpriteName (Awards[1])

			label1  = self:GetLabel ("bg/reward7/num")
			label1:SetValue (Awards[2])

		end

	-- 兩個獎勵物品
	elseif (#Awards == 4) then

		do
			-- 壹 :
			-- Set the reward's gameObejct is active :
			gameObject = self.instance:FindWidget ("bg/reward5")
			gameObject:SetActive (true)

			sprite1 = self:GetSprite ("bg/reward5/icon")
			sprite1:SetSpriteName (Awards[1])

			label1  = self:GetLabel ("bg/reward5/num")
			label1:SetValue (Awards[2])
		end

		do
			-- 貳 :
			-- Set the reward's gameObejct is active :
			gameObject = self.instance:FindWidget ("bg/reward6")
			gameObject:SetActive (true)

			sprite2 = self:GetSprite ("bg/reward6/icon")
			sprite2:SetSpriteName (Awards[3])

			label2  = self:GetLabel ("bg/reward6/num")
			label2:SetValue (Awards[4])
		end

	-- 三個獎勵物品
	elseif (#Awards == 6) then

		do
			-- 壹 :
			-- Set the reward's gameObejct is active :
			gameObject = self.instance:FindWidget ("bg/reward1")
			gameObject:SetActive (true)

			sprite1 = self:GetSprite ("bg/reward1/icon")
			sprite1:SetSpriteName (Awards[1])

			label1  = self:GetLabel ("bg/reward1/num")
			label1:SetValue (Awards[2])
		end

		do
			-- 貳 :
			-- Set the reward's gameObejct is active :
			gameObject = self.instance:FindWidget ("bg/reward2")
			gameObject:SetActive (true)

			sprite2 = self:GetSprite ("bg/reward2/icon")
			sprite2:SetSpriteName (Awards[3])

			label2  = self:GetLabel ("bg/reward2/num")
			label2:SetValue (Awards[4])
		end

		do
			-- 叁 :
			-- Set the reward's gameObejct is active :
			gameObject = self.instance:FindWidget ("bg/reward3")
			gameObject:SetActive (true)

			sprite3 = self:GetSprite ("bg/reward3/icon")
			sprite3:SetSpriteName (Awards[5])

			label3  = self:GetLabel ("bg/reward3/num")
			label3:SetValue (Awards[6])
		end

	-- 四個獎勵物品
	elseif (#Awards == 8) then

		do
			-- 壹 :
			-- Set the reward's gameObejct is active :
			gameObject = self.instance:FindWidget ("bg/reward1")
			gameObject:SetActive (true)

			sprite1 = self:GetSprite ("bg/reward1/icon")
			sprite1:SetSpriteName (Awards[1])

			label1  = self:GetLabel ("bg/reward1/num")
			label1:SetValue (Awards[2])
		end

		do
			-- 貳 :
			-- Set the reward's gameObejct is active :
			gameObject = self.instance:FindWidget ("bg/reward2")
			gameObject:SetActive (true)

			sprite2 = self:GetSprite ("bg/reward2/icon")
			sprite2:SetSpriteName (Awards[3])

			label2  = self:GetLabel ("bg/reward2/num")
			label2:SetValue (Awards[4])
		end

		do
			-- 叁 :
			-- Set the reward's gameObejct is active :
			gameObject = self.instance:FindWidget ("bg/reward3")
			gameObject:SetActive (true)

			sprite3 = self:GetSprite ("bg/reward3/icon")
			sprite3:SetSpriteName (Awards[5])

			label3  = self:GetLabel ("bg/reward3/num")
			label3:SetValue (Awards[6])
		end

		do
			-- 肆 :
			-- Set the reward's gameObejct is active :
			gameObject = self.instance:FindWidget ("bg/reward4")
			gameObject:SetActive (true)

			sprite4 = self:GetSprite ("bg/reward4/icon")
			sprite4:SetSpriteName (Awards[7])

			label4  = self:GetLabel ("bg/reward4/num")
			label4:SetValue (Awards[8])
		end

	else

		do
			-- 錯誤參數：顯示錯誤信息 :
			-- Set the reward's gameObejct is active :
			gameObject = self.instance:FindWidget ("bg/reward7")
			gameObject:SetActive (true)

			sprite1 = self:GetSprite ("bg/reward7/icon")
			sprite1:SetSpriteName (nil)

			label1  = self:GetLabel ("bg/reward7/num")
			label1:SetValue ("未知錯誤！")

			print ("wnd_rewardboxClass:ShowRewardMsg's Awardsuments is wrong !!!")
		end

	end


	-- Clear local :
	gameObject = nil
	sprite1	   = nil
	sprite2	   = nil
	sprite3	   = nil
	sprite4	   = nil
	label1	   = nil
	label2	   = nil
	label3	   = nil
	label4	   = nil

	Awards	   = {}

	return nil
end



-- function wnd_rewardboxClass:OnLostInstance ()
-- end



return wnd_rewardboxClass.new