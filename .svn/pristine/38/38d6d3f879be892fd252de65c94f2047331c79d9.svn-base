--region *.lua
--Date 20160225
--英雄对象
--作者 wenchuan

HeroClass = classWC()

--英雄属性名枚举
HeroAttrNames = {
	LV = "LV",
	XJ = "XJ",
    SXJ = "SXJ",
    SkillLevels = "SkillLevels",
	DataID = "DataID",
	ZDL = "ZDL",
	WuID = "WuID",
	FangID = "FangID",
	aZDL = "aZDL"
} 

function HeroClass:BindSyncObj(ownerPlayer,syncObj)
	self.Obj = syncObj
	self.OwnerPlayer = ownerPlayer
end

function HeroClass:GetAttr(attr)
	return self.Obj:GetValue(attr)
end

function HeroClass:GetNumberAttr(attr)
	return tonumber(self:GetAttr(attr))
end

function HeroClass:GetNu()
    local hero = SData_Hero.GetHero(self:GetAttr(HeroAttrNames.DataID))
    return hero:CalculationNu(self.OwnerPlayer:GetAttr(PlayerAttrNames.Level) ,self:GetAttr(HeroAttrNames.XJ) )
end
 
--- <summary>
--- 获取技能等级
--- ret {等级1,等级2,等级n}
--- </summary>
function HeroClass:GetSkillLevels()
    local levels = {}
    local jsonstr = self:GetAttr(HeroAttrNames.SkillLevels) 
    local jsonDoc = QKJsonDoc.NewArray()
    jsonDoc:Parse(jsonstr)

    local eachFunc = function(key,value) table.insert(levels, tonumber(key)) end
    jsonDoc:Foreach(eachFunc)
    return levels;
end

function HeroClass:GetSkillLevelByIndex(_Index)
    local levels = self:GetSkillLevels()
    --print("HeroClass:GetSkillLevelByIndex",levels[_Index])
    return levels[_Index]
end

--- <summary>
--- 根据技能id获取技能等级
--- levels 用GetSkillLevels方法获取的等级数组
--- skillID 技能id
--- </summary>
function HeroClass:GetSillLevel(levels,skillID)
     local hero = SData_Hero.GetHero(self:GetAttr(HeroAttrNames.DataID))
     local idx = hero:GetSkillIndex(skillID)
     if idx<0 then return 0 end --未知的技能id
     return levels[idx+1]
end

function HeroClass:GetTili()
    local hero = SData_Hero.GetHero(self:GetAttr(HeroAttrNames.DataID))
    return hero:CalculationTili(self.OwnerPlayer:GetAttr(PlayerAttrNames.Level) ,self:GetAttr(HeroAttrNames.XJ) )
end

function HeroClass:GetWuli()
    local hero = SData_Hero.GetHero(self:GetAttr(HeroAttrNames.DataID))
    return hero:CalculationWuli(self.OwnerPlayer:GetAttr(PlayerAttrNames.Level) ,self:GetAttr(HeroAttrNames.XJ) )
end

function HeroClass:GetHP()
    local hero = SData_Hero.GetHero(self:GetAttr(HeroAttrNames.DataID))
    return hero:CalculationHP(self.OwnerPlayer:GetAttr(PlayerAttrNames.Level) ,self:GetAttr(HeroAttrNames.XJ) )
end



function HeroClass:GetNextXJNu()
    local hero = SData_Hero.GetHero(self:GetAttr(HeroAttrNames.DataID))
    return hero:CalculationNu(self.OwnerPlayer:GetAttr(PlayerAttrNames.Level) ,self:GetAttr(HeroAttrNames.XJ)+1 )
end

function HeroClass:GetNextXJTili()
    local hero = SData_Hero.GetHero(self:GetAttr(HeroAttrNames.DataID))
    return hero:CalculationTili(self.OwnerPlayer:GetAttr(PlayerAttrNames.Level) ,self:GetAttr(HeroAttrNames.XJ)+1 )
end

function HeroClass:GetNextXJWuli()
    local hero = SData_Hero.GetHero(self:GetAttr(HeroAttrNames.DataID))
    return hero:CalculationWuli(self.OwnerPlayer:GetAttr(PlayerAttrNames.Level) ,self:GetAttr(HeroAttrNames.XJ)+1 )
end

function HeroClass:GetNextXJHP()
    local hero = SData_Hero.GetHero(self:GetAttr(HeroAttrNames.DataID))
    return hero:CalculationHP(self.OwnerPlayer:GetAttr(PlayerAttrNames.Level) ,self:GetAttr(HeroAttrNames.XJ)+1 )
end






function HeroClass:GetArmyNu()
    local hero = SData_Hero.GetHero(self:GetAttr(HeroAttrNames.DataID))
    local army = SData_Army.GetRow( hero:Army())
    return army:CalculationNu(self.OwnerPlayer:GetAttr(PlayerAttrNames.Level) ,self:GetAttr(HeroAttrNames.SXJ) )
end

function HeroClass:GetArmyTili()
    local hero = SData_Hero.GetHero(self:GetAttr(HeroAttrNames.DataID))
    local army = SData_Army.GetRow( hero:Army())
    return army:CalculationTili(self.OwnerPlayer:GetAttr(PlayerAttrNames.Level) ,self:GetAttr(HeroAttrNames.SXJ) )
end

function HeroClass:GetArmyWuli()
    local hero = SData_Hero.GetHero(self:GetAttr(HeroAttrNames.DataID))
    local army = SData_Army.GetRow( hero:Army())
    return army:CalculationWuli(self.OwnerPlayer:GetAttr(PlayerAttrNames.Level) ,self:GetAttr(HeroAttrNames.SXJ) ) 
end

function HeroClass:GetArmyHP()
     local hero = SData_Hero.GetHero(self:GetAttr(HeroAttrNames.DataID))
    local army = SData_Army.GetRow( hero:Army())
    return army:CalculationHP(self.OwnerPlayer:GetAttr(PlayerAttrNames.Level) ,self:GetAttr(HeroAttrNames.SXJ) )  
end



function HeroClass:GetArmyNextXJNu()
   local hero = SData_Hero.GetHero(self:GetAttr(HeroAttrNames.DataID))
    local army = SData_Army.GetRow( hero:Army())
    return army:CalculationNu(self.OwnerPlayer:GetAttr(PlayerAttrNames.Level) ,self:GetAttr(HeroAttrNames.SXJ) +1 )
end

function HeroClass:GetArmyNextXJTili()
    local hero = SData_Hero.GetHero(self:GetAttr(HeroAttrNames.DataID))
    local army = SData_Army.GetRow( hero:Army())
    return army:CalculationTili(self.OwnerPlayer:GetAttr(PlayerAttrNames.Level) ,self:GetAttr(HeroAttrNames.SXJ)+1 )
end

function HeroClass:GetArmyNextXJWuli()
     local hero = SData_Hero.GetHero(self:GetAttr(HeroAttrNames.DataID))
    local army = SData_Army.GetRow( hero:Army())
    return army:CalculationWuli(self.OwnerPlayer:GetAttr(PlayerAttrNames.Level) ,self:GetAttr(HeroAttrNames.SXJ)+1 ) 
end

function HeroClass:GetArmyNextXJHP()
    local hero = SData_Hero.GetHero(self:GetAttr(HeroAttrNames.DataID))
    local army = SData_Army.GetRow( hero:Army())
    return army:CalculationHP(self.OwnerPlayer:GetAttr(PlayerAttrNames.Level) ,self:GetAttr(HeroAttrNames.SXJ)+1 )  
end



--endregion
