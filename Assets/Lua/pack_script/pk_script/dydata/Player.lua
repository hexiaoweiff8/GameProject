--region *.lua
--Date 20160225
--角色对象
--作者 wenchuan

PlayerClass = classWC()

--角色属性名枚举
PlayerAttrNames = {
    Probie = "Probie",--新手
	Level = "Level",
	Name = "Name",
	Gold = "Gold",
	Copper = "Copper",--铜币
	GJZQT = "GJZQT",--金币抽奖折扣结束时间点
	CJZQT = "CJZQT",--铜币抽奖折扣结束时间点
    Sex = "Sex",--性别
    FaceIndex = "FIdx",--头像索引
	id = "UCode",
	Exp = "exp",--玩家经验
	GJID = "gjid",--官阶ID
    ZDL = "zdl",
    EZDL = "ezdl",
	Tysp = "tysp",
    JunLing = "JL", --军令
	JunLingCS = "JLCS", --购买军令的次数
    JunLingMCS = "JLMCS", --每日购买军令的最大次数 与vip等级有关
    JunLingJS = "JLJS", --军令倒计时
    VIPLV = "VIPLV",
	CZLJCS = "CZLJCS",--累计充值奖励次数（即VIP等级）
	Rsum = "Rsum",--累计充值金额数
	autoAva = "autoAva",--有没有新武将
    CloudR = "CloudR",--当前开启的省
	diaJD = "diaJD",--剧情
} 

local JianghunAttrNames = {
    DataID = "DataID",--将魂数据id
    NUM = "NUM",--将魂数量
}

local SoldierPieceNames = {
    DataID = "DataID",--士兵数据id
    NUM = "NUM",--碎片数量
}

local FormationNames = {
    ID = "ZhenID",--士兵数据id
    Info = "ZhenPos",--碎片数量
}

function PlayerClass:BindSyncObj(sid)
	self.sid = sid 
	self.PlyObj = OOSyncClient.GetObject(sid,PlayerSyncBase)--取得角色对象   
end

function PlayerClass:GetAttr(attr)
	return self.PlyObj:GetValue(attr)
end

function PlayerClass:GetObject(attr)
    return OOSyncClient.GetObject(tonumber( self.sid ),tostring( attr ),true)
end

function PlayerClass:GetObjectF(attr)
    return OOSyncClient.GetObject(tonumber( self.sid ),tostring( attr ),false)
end

function PlayerClass:Delete(attr)

    local Temp = self:GetObjectF(attr)
    if Temp == nil then return end
    Temp:Delete()

end


function PlayerClass:SetAttr(attr,_Value)
	return self.PlyObj:SetValue(attr,_Value)
end

--function PlayerClass:GetChildByTag(attr)
--	return self.PlyObj:GetChildByTag(attr)
--end

function PlayerClass:GetPath()
	return self.PlyObj:GetPath()
end
function PlayerClass:GetNumberAttr(attr)
	return tonumber(self:GetAttr(attr))
end

--- <summary>
--- 获取将魂数量
--- </summary>
function PlayerClass:GetJianghunNum(heroID) 
    local objName = "jh"..heroID
    local syncJiangHun = self.PlyObj:GetChild(objName)

    if syncJiangHun~=nil then
        return tonumber(syncJiangHun:GetValue(JianghunAttrNames.NUM))
    else
        return 0;
    end 
end


--- <summary>
--- 获取士兵碎片数量
--- </summary>
function PlayerClass:GetSoldierPieceNum(soldierID) 
    local objName = "sp"..soldierID
    local syncObj = self.PlyObj:GetChild(objName)

    if syncObj~=nil then
        return tonumber(syncObj:GetValue(SoldierPieceNames.NUM))
    else
        return 0;
    end
end

--获取英雄队列
function PlayerClass:GetHerosPack()
	--local count = self.PlyObj:GetChildCount()
    --local sync
	--if count>0 then
    --    local eachFunc = function (syncHero)
    --        --print("PlayerClass:GetHerosPack====================1",syncHero:GetName())
    --        if(syncHero:GetName()=="hero") then
    --            --print("PlayerClass:GetHerosPack====================2",syncHero:GetName(),syncHero)
    --            sync = syncHero
    --        end
    --    end
    --    self.PlyObj:Foreach(eachFunc) 
	--end
	--return sync

    return self:GetObject("ply/hero")
end

function PlayerClass:GetHeros()
    
    local re = {}
	local Node = self:GetHerosPack()
    local eachFunc = function (syncHero)
        local hero = HeroClass.new()
        hero:BindSyncObj(self, syncHero)
		table.insert(re,hero)
    end
    Node:Foreach(eachFunc)	

	return re

end

function PlayerClass:GetHeroByID( _HeroSDataID )
	local TempHero = {}
    local PlayerHeros = self:GetHeros()

    for k,v in pairs ( PlayerHeros ) do 
        if tonumber ( v:GetAttr(HeroAttrNames.DataID) )  == _HeroSDataID then 
           return v
        end 
    end
    return nil
end

--获取牌库英雄队列
function PlayerClass:GetAvaHerosPack()
	--local count = self.PlyObj:GetChildCount()
    --
	--if count>0 then
    --    local eachFunc = function (syncHero)
    --        print("PlayerClass:GetAvaHerosPack=================",syncHero:GetName())
    --        if(syncHero:GetName() == "avaHero" ) then
	--		    return syncHero
    --        end
    --    end
    --    self.PlyObj:Foreach(eachFunc)	
	--end
	--return nil

    return self:GetObject("ply/avaHero")
end

function PlayerClass:GetAvaHeros()
    local re = {}
	local Node = self:GetAvaHerosPack()
    --print("PlayerClass:GetAvaHeros1",Node)
    local eachFunc = function (syncHero)
        --print("PlayerClass:GetAvaHeros2",syncHero:GetPath())
        local Avahero = AvaHeroClass.new()
		Avahero:BindSyncObj(self, syncHero)
		table.insert(re,Avahero)
    end
    Node:Foreach(eachFunc)	

	return re
end
--获取玩家阵型队列
function PlayerClass:GetFrmsPack()
    return self:GetObject("ply/Frms")
end

--获取玩家阵型队列
function PlayerClass:GetFrms()
	--local  re = {}
	--local count = self.PlyObj:GetChildCount()
    --
	--if count>0 then
    --    local eachFunc = function (syncHero)
    --        print("PlayerClass:GetFrms============================================",syncHero:GetPath())
    --        if(string.sub(syncHero:GetName(),0,4)=="Frms") then               
    --            local Frms = FrmsClass.new()
	--		    Frms:BindSyncObj(self, syncHero)
	--		    table.insert(re,Frms )
    --        end
    --    end
    --    self.PlyObj:Foreach(eachFunc)         
	--end
    --
	--return re

    local re = {}
	local Node = self:GetFrmsPack()
    local eachFunc = function (syncHero)
        local Frms = FrmsClass.new()
		Frms:BindSyncObj(self, syncHero)
		table.insert(re,Frms)
    end
    Node:Foreach(eachFunc)	
    
	return re


end
--获取武将招募英雄队列
function PlayerClass:GetHHeros()
	local  re = {}
	local count = self.PlyObj:GetChildCount()
	if count>0 then
        local eachFunc = function (syncHero)
             if(string.sub(syncHero:GetName(),0,5)=="HHero") then               
                local Hhero = HHeroClass.new()
			    Hhero:BindSyncObj(self, syncHero)
			    table.insert(re,Hhero )
            end
        end
        self.PlyObj:Foreach(eachFunc)		 
	end
	return re
end
--获取随机事件怪物队列
function PlayerClass:GetSJM()
    if self.SJM==nil then self.SJM = SJMClass.new(self) end 
    return self.SJM
end
--获取随机事件怪物队列
function PlayerClass:GetSJShops()
    if self.SJShops == nil then self.SJShops = SJShopsClass.new(self) end 
    return self.SJShops
end
--获取随机事件怪物队列
function PlayerClass:GetSJMByFID(_ID)
    return self:GetObjectF("ply/SJM/".._ID)
end
--获取随机事件商店
function PlayerClass:GetSJShopsByFID(_ID)
    return self:GetObjectF("ply/SJShops/".._ID)
end
--获取关卡信息
function PlayerClass:GetGKInfo()

    --如果没有创建管卡信息，则创建之
    if self.GKInfo==nil then self.GKInfo = GKInfoClass.new(self) end 
    return self.GKInfo
end
--获取牌组信息
function PlayerClass:GetAHeroinfoByID(_ID)
    return self:GetObject(PlayerSyncBase.."/"..PlayerTags.AHeroInfos.."/".._ID)
end

--获取牌组信息
function PlayerClass:GetAHeroinfos()

    if self.AHeroinfos==nil then self.AHeroinfos = AHeroinfosClass.new(self) end 
    return self.AHeroinfos
end
--获取装备信息
function PlayerClass:GetEquips()

    if self.Equips==nil then self.Equips = EquipClass.new(self) end 
    return self.Equips
end
--获取洗练信息
function PlayerClass:GetEquipMaterials()

    if self.EquipMaterials==nil then self.EquipMaterials = EquipMaterialsClass.new(self) end 
    return self.EquipMaterials
end
--获取通用道具信息
function PlayerClass:GetCommItems()

    if self.CommItems==nil then self.CommItems = CommItemsClass.new(self) end 
    return self.CommItems
end
--获取洗练信息
function PlayerClass:GetJLBag()

    if self.JLBag == nil then self.JLBag = JLBagClass.new(self) end 
    return self.JLBag
end


--获取武将在阵信息
function PlayerClass:GetHeroAheroinfo()
	local t1= {}
	local t2= {}
	local t3= {}
	local heros = self:GetAHeroinfos()
		local eachFunc = function (syncObj)
			if tonumber(syncObj:GetValue(AHeroinfos.State)) == 5 or tonumber(syncObj:GetValue(AHeroinfos.State)) == 3 then
				print(syncObj:GetValue(AHeroinfos.id))
				table.insert(t1,syncObj:GetValue(AHeroinfos.id))				
			elseif tonumber(syncObj:GetValue(AHeroinfos.State)) == 4 or tonumber(syncObj:GetValue(AHeroinfos.State)) == 2 then
				table.insert(t2,syncObj:GetValue(AHeroinfos.id))				
			elseif tonumber(syncObj:GetValue(AHeroinfos.State)) == 1 then
				table.insert(t3,syncObj:GetValue(AHeroinfos.id))
			end
		end
	heros:ForeachAHeroinfos(eachFunc)

	return self:GetXJ(t1),self:GetXJ(t2),self:GetXJ(t3)
end
function PlayerClass:GetXJ(tel)
    local PlayerHeroInfo = Player:GetHeros() 
    local tmpList = {}
    for _,v in pairs(PlayerHeroInfo) do
		if tel ~= nil then  
			local id = v:GetNumberAttr(HeroAttrNames.DataID)
			for k,i in pairs (tel)do
				if tonumber(i) == tonumber(id) then
					table.insert(tmpList,{ID = id, XJ=v:GetAttr(HeroAttrNames.XJ) })
				end
			end
		end
    end

    local function sortfunc(item1, item2) 
        if item1.XJ == item2.XJ then
             return item1.ID < item2.ID
        else
            return item1.XJ > item2.XJ
        end 
    end
	if tmpList ~= nil then  
		table.sort(tmpList, sortfunc) 
	end
	return tmpList
end
--
function PlayerClass:GetCommItemsNum(DID) 
	local num = 0
    local b = self:GetCommItems()
	local eachFunc = function (syncObj)
		if tonumber(syncObj:GetValue(CommItemsAttrNames.DataID)) == DID then
			num = syncObj:GetValue(CommItemsAttrNames.NUM)
		end
	end
	b:ForeachCommItems(eachFunc)
	return num
end
function PlayerClass:GetOpenProvinceID() 
	local provinceID = self:GetNumberAttr(PlayerAttrNames.CloudR);
    if(provinceID == nil or tonumber(provinceID) < 1)then
        return 1
    end
	return  tonumber(provinceID) ;
end

function PlayerClass:SetSyncMission(CurrMission,BestMission) 
    local gkCur = Player:GetObjectF("ply/gkSaveFiles/0")
    local gkWin = Player:GetObjectF("ply/gkSaveFiles/1")

    --print("PlayerClass:SetSyncMission======================66666666==========",gkCur,gkWin)
    --print("PlayerClass:SetSyncMission======================66666666==========",CurrMission,BestMission)

    if gkCur ~= nil then 
        gkCur:SetValue(GKSaveFileAttrNames.MissionID,tostring( CurrMission ))
    end

    if gkWin ~= nil then 
        gkWin:SetValue(GKSaveFileAttrNames.MissionID,tostring( BestMission ))
    end
    
end
--endregion

PlayerSyncBase =  "ply"
PlayerTags = 
{
    gkSaveFiles = "gkSaveFiles",
    gkTargets = "gkTargets",
    Frms = "Frms",
    AHeroInfos = "AHeroInfos",
}
