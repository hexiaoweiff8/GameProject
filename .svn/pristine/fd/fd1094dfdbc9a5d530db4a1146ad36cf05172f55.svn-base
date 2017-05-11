local class = require("common/middleclass")
--装备M
equipM = class("equipM")
-- EquipUniID = 1 --装备唯一ID
-- EquipID = 10001 --装备ID
-- QiangHuaLevel = 0 --强化等级
-- EquipQuality = 0 --装备品质
-- IsBad = 0 --是否损坏 1为损坏 0为否
-- IsLock = 0 --是否锁定 1为锁定 0为否
-- MainEffectID = 0 --主属性ID
-- ViceEffect = {{0,0,0,{0,0}}... }--属性id--属性数值--是否重铸--待替换属性
function equipM:initialize(EquipUniID, EquipID, QiangHuaLevel, EquipQuality, IsBad, IsLock, MainEffectID, ViceEffect)
    self.EquipUniID = EquipUniID
    self.EquipID = EquipID
    self.QiangHuaLevel = QiangHuaLevel
    self.EquipQuality = EquipQuality
    self.IsBad = IsBad
    self.IsLock = IsLock
    self.MainEffectID = MainEffectID
    self.ViceEffect = ViceEffect
end

--装备随机属性M
equipShuXingM = class("equipShuXingM")
-- ShuXingID = 10001 --属性id
-- ShuXingNum = 0 --属性数值
-- IsChongZhu = 0 --是否重铸
--Remake ={} 待替换属性
function equipShuXingM:initialize(ShuXingID, ShuXingNum, IsChongZhu, Remake)
    self.ShuXingID = ShuXingID
    self.ShuXingNum = ShuXingNum
    self.IsChongZhu = IsChongZhu
    self.Remake = Remake
end

--待替换属性
equipShuXingRemakeM = class("equipShuXingRemakeM")
-- ShuXingID = 10001 --属性id
-- ShuXingNum = 0 --属性数值
function equipShuXingRemakeM:initialize(RemakeShuXingID, RemakeShuXingNum)
    self.RemakeShuXingID = RemakeShuXingID
    self.RemakeShuXingNum = RemakeShuXingNum
end

equipP = {}
--穿戴中的装备列表
equipP.nowEqList = {--[[1]] equipM(1, 10001, 1, 6, 0, 0, 10001, {equipShuXingM(10025, 1, 0, {equipShuXingRemakeM(10025, 1), equipShuXingRemakeM(10024, 1), equipShuXingRemakeM(10023, 1)}), equipShuXingM(10037, 1, 0), equipShuXingM(10037, 1, 0), equipShuXingM(10037, 1, 0), equipShuXingM(10037, 1, 0)}), --[[2]] 0, --[[3]] equipM(2, 10004, 2, 6, 0, 0, 10002, {equipShuXingM(10025, 1, 0), equipShuXingM(10037, 1, 0)}), --[[4]] equipM(3, 30001, 3, 3, 0, 0, 10001, {equipShuXingM(10025, 1, 0), equipShuXingM(10037, 1, 0)}), --[[5]] 0, --[[6]] 0, --[[7]] 0, --[[8]] equipM(4, 30003, 0, 3, 0, 0, 10001, {equipShuXingM(10025, 1, 0), equipShuXingM(10037, 1, 0)})}
--所有拥有但为穿戴装备列表
equipP.allEqList = {--[[1]]{equipM(5, 20001, 1, 2, 0, 0, 10001, {equipShuXingM(10025, 1, 0, {equipShuXingRemakeM(10025, 1), equipShuXingRemakeM(10024, 1), equipShuXingRemakeM(10023, 1)}), equipShuXingM(10037, 1, 0)}), equipM(6, 10002, 10, 5, 0, 0, 10001, {equipShuXingM(10025, 1, 0), equipShuXingM(10037, 1, 0)}), equipM(11, 10003, 10, 3, 0, 0, 10001, {equipShuXingM(10025, 1, 0), equipShuXingM(10037, 1, 0)}), equipM(12, 20004, 10, 6, 1, 0, 10001, {equipShuXingM(10025, 1, 0), equipShuXingM(10037, 1, 0)})}, --[[2]]{}, --[[3]]{equipM(7, 10003, 1, 2, 0, 0, 10001, {equipShuXingM(10025, 1, 0), equipShuXingM(10037, 1, 0)})}, --[[4]]{}, --[[5]]{equipM(8, 10005, 1, 2, 0, 0, 10001, {equipShuXingM(10025, 1, 0), equipShuXingM(10037, 1, 0)})}, --[[6]]{}, --[[7]]{equipM(9, 10007, 1, 3, 0, 0, 10001, {equipShuXingM(10025, 1, 0), equipShuXingM(10037, 1, 0)})}, --[[8]]{}}
-- equipP.allEqList = {{}, {}, {}, {}, {}, {}, {}, {}}
function equipP.add_nowEqList(index, value)
    equipP.nowEqList[index] = value
    Event.Brocast(GameEventType.ZUOCEZHUANGBEI, 100, index, value)
end

function equipP.remove_nowEqList(index)
    equipP.nowEqList[index] = 0
    Event.Brocast(GameEventType.ZUOCEZHUANGBEI, 0, index)
end

function equipP.change_nowEqList(index, value)
    equipP.nowEqList[index] = value
    Event.Brocast(GameEventType.ZUOCEZHUANGBEI, 200, index, value)
end

function equipP.add_allEqList(index, value)
    local v = table.insert(equipP.allEqList[index], value)
    Event.Brocast(GameEventType.YOUCEZHUANGBEI, 100, index, value)
end

function equipP.add_allEqListOfXieXia(index, value)
    local v = table.insert(equipP.allEqList[index], value)
    Event.Brocast(GameEventType.YOUCEZHUANGBEI, 101, index, value)
end

function equipP.remove_allEqList(index, value)
    local index2 = table.removebyvalue2(equipP.allEqList[index], value)
    Event.Brocast(GameEventType.YOUCEZHUANGBEI, 0, index, index2)
end

function equipP.change_allEqList(index, index2, value)
    equipP.allEqList[index][index2] = value
    Event.Brocast(GameEventType.YOUCEZHUANGBEI, 200, index, value, index2)
end

function equipP.exchange_EqList(index, value1, value2)
    local index2 = table.indexof(equipP.allEqList[index], value2)
    equipP.allEqList[index][index2] = value1
    equipP.nowEqList[index] = value2
    Event.Brocast(GameEventType.EXCHANGEZHUANGBEI, index, index2, value1, value2)
end

function equipP.getInfoByID(uniID)
    for i, v in ipairs(equipP.nowEqList) do
        if v ~= 0 and v.EquipUniID == uniID then
            return v
        end
    end
    for i, v in ipairs(equipP.allEqList) do
        for i, v in ipairs(v) do
            if v.EquipUniID == uniID then
                return v
            end
        end
    end
    return nil
end

function equipP.getIndexByID(uniID)
    for i, v in ipairs(equipP.nowEqList) do
        if v ~= 0 and v.EquipUniID == uniID then
            return i
        end
    end
    for i, v in ipairs(equipP.allEqList) do
        for j, v in ipairs(v) do
            if v.EquipUniID == uniID then
                return i, j
            end
        end
    end
    return nil
end
