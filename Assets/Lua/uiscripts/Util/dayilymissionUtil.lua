
--[[
任务表工具
数据说明：
ID              唯一
MissionType     类型字段
TypeID          类型ID
ChildID         子ID
Des             任务描述
Type            类型
TargetValue     目标值
UnlockLevel     开启等级
UIDefine        UI链接
Exp             经验
Gold            金币
Diamond         钻石
SkillPt         技能点
GiftType1       奖励类型1
ID1             ID1
Num1            数量1
GiftType2       奖励类型2
ID2             ID2
Num2            数量2
]]--
local class = require("common/middleclass")
dayilymissionUtil = class("missionUtil")

function dayilymissionUtil:GetMissionData()
    return sdata_dailymission_data.mData.body
end

function dayilymissionUtil:GetMissionOneDataByID(missionID)
    if dayilymissionUtil:GetMissionData()[missionID] == nil then
        print("--------没有数据ID为："..missionID.."的任务--------证明子链任务完成")
        return nil
    end
    local tb = {}
    tb.ID = sdata_dailymission_data:GetFieldV("ID",missionID)
    tb.MissionType = sdata_dailymission_data:GetFieldV("MissionType",missionID)
    tb.TypeID = sdata_dailymission_data:GetFieldV("TypeID",missionID)
    tb.ChildID = sdata_dailymission_data:GetFieldV("ChildID",missionID)
    tb.Des = sdata_dailymission_data:GetFieldV("Des",missionID)
    tb.Type = sdata_dailymission_data:GetFieldV("Type",missionID)
    tb.TargetValue = sdata_dailymission_data:GetFieldV("TargetValue",missionID)
    tb.UnlockLevel = sdata_dailymission_data:GetFieldV("UnlockLevel",missionID)
    tb.UIDefine = sdata_dailymission_data:GetFieldV("UIDefine",missionID)
    tb.Exp = sdata_dailymission_data:GetFieldV("Exp",missionID)
    tb.Gold = sdata_dailymission_data:GetFieldV("Gold",missionID)
    tb.Diamond = sdata_dailymission_data:GetFieldV("Diamond",missionID)
    tb.SkillPt = sdata_dailymission_data:GetFieldV("SkillPt",missionID)
    tb.GiftType1 = sdata_dailymission_data:GetFieldV("GiftType1",missionID)
    tb.ID1 = sdata_dailymission_data:GetFieldV("ID1",missionID)
    tb.Num1 = sdata_dailymission_data:GetFieldV("Num1",missionID)
    tb.GiftType2 = sdata_dailymission_data:GetFieldV("GiftType2",missionID)
    tb.ID2 = sdata_dailymission_data:GetFieldV("ID2",missionID)
    tb.Num2 = sdata_dailymission_data:GetFieldV("Num2",missionID)

    return tb

end

