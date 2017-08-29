local class = require("common/middleclass")
dailyMission_controller = class("dailyMission_controller",wnd_base)

local this = dailyMission_controller

local view = require("uiscripts/dailyMission/dailyMission_view")
local model = require("uiscripts/dailyMission/dailyMission_model")
local mself

function dailyMission_controller:OnShowDone()
    print("dailyMission_controller:OnShowDone")
    mself = self
    view:InitView(self)
    model:InitModel()
    this:InitBtn()

    --后面一定要在拖到数据过后再调用刷新
    this:RefershDailyMissionItem()

end

function dailyMission_controller:InitBtn()
    UIEventListener.Get(view.btn_close).onClick = function ()
        --print("每日关闭按钮")
        mself:Hide(0)
    end

    UIEventListener.Get(view.meirirenwu).onClick = function()
        this:RefershDailyMissionItem()
    end
    UIEventListener.Get(view.zhanluemubiao).onClick = function()
    this:RefershZhanlueItem()
    end

end

--刷新每日任务Item
function dailyMission_controller:RefershDailyMissionItem()
    --删除Grid下面所有子物体
    NGUITools.DestroyChildren(view.itemGrid.transform)

    if #model.dailyMissionDataList ~= 0 then


        for i = 1, #model.dailyMissionDataList do
            local missionID = model.dailyMissionDataList[i].typeid*100+model.dailyMissionDataList[i].childid
            local junduNum = model.dailyMissionDataList[i].jingdu
            local islingqu --= model.dailyMissionDataList[i].islingqu
            local localData = dayilymissionUtil:GetMissionOneDataByID(missionID)
            if localData == nil then --证明是领取过的
                islingqu = 1
                missionID = model.dailyMissionDataList[i].typeid*100+model.dailyMissionDataList[i].childid-1
                localData = dayilymissionUtil:GetMissionOneDataByID(missionID)
            else
                islingqu = 0
            end
            this:CreateItem(missionID,junduNum,localData,islingqu)

        end
        view.itemGrid.repositionNow = true
        view.itemGrid:Reposition()
        view.itemGrid.transform.parent:GetComponent("UIScrollView"):ResetPosition()
    end
end

--刷新战略任务Item
function dailyMission_controller:RefershZhanlueItem()
    --删除Grid下面所有子物体
        NGUITools.DestroyChildren(view.itemGrid.transform)

    if #model.zhanluerenwuDataList ~= 0 then
        for i = 1, #model.zhanluerenwuDataList do
            local missionID = model.zhanluerenwuDataList[i].typeid*100+model.zhanluerenwuDataList[i].childid
            local junduNum = model.zhanluerenwuDataList[i].jingdu
            local islingqu
            local localData = dayilymissionUtil:GetMissionOneDataByID(missionID)
            if localData == nil then --证明是领取过的
                islingqu = 1
                missionID = model.zhanluerenwuDataList[i].typeid*100+model.zhanluerenwuDataList[i].childid-1
                localData = dayilymissionUtil:GetMissionOneDataByID(missionID)
            else
                islingqu = 0
            end
            this:CreateItem(missionID,junduNum,localData,islingqu)

        end
        view.itemGrid.repositionNow = true
        view.itemGrid:Reposition()
        view.itemGrid.transform.parent:GetComponent("UIScrollView"):ResetPosition()
    end
end


function dailyMission_controller:CreateItem(missionID,jinduNum,localData,islingqu)

    --等级不够不开启任务

    if userModel:getUserRoleTbl().lv < localData.UnlockLevel then
        return
    end


    local item = NGUITools.AddChild(view.itemGrid.gameObject,view.missionItemPerfab)

    ----内容初始化----
    --描述初始化
    item.transform:FindChild("content"):GetComponent("UILabel").text = localData.Des
    --奖励初始化

    local index = 1
    local function useWhereGezi(where,num)
        if where > 3 then
            print("超出索引格子，奖励列表没有"..where.."个预留位")
            return
        end
        --print(where)
        local geziName = "jiangliGrid/jiangliItem00"..where
        local gezi = item.transform:FindChild(geziName).gameObject
        gezi:SetActive(true)
        gezi.transform:FindChild("num"):GetComponent("UILabel").text = "x"..num
        index = index + 1
    end
    item.transform:FindChild("jiangliGrid/jiangliItem001").gameObject:SetActive(false)
    item.transform:FindChild("jiangliGrid/jiangliItem002").gameObject:SetActive(false)
    item.transform:FindChild("jiangliGrid/jiangliItem003").gameObject:SetActive(false)
    if localData.Exp ~= -1 then useWhereGezi(index,localData.Exp) end
    if localData.Gold ~= -1 then useWhereGezi(index,localData.Gold) end
    if localData.Diamond ~= -1 then useWhereGezi(index,localData.Diamond) end
    if localData.SkillPt ~= -1 then useWhereGezi(index,localData.SkillPt) end
    if localData.Num1 ~= -1 then useWhereGezi(index,localData.Num1) end
    if localData.Num2 ~= -1 then useWhereGezi(index,localData.Num2) end


    ----内容初始化----

    ----初始化right----
    local btn_lingqu = item.transform:FindChild("right/btn_lingqu").gameObject
    local btn_qianwang = item.transform:FindChild("right/btn_qianwang").gameObject
    local jinduSlider = item.transform:FindChild("right/jinduSlider").gameObject
    local yilingquSP = item.transform:FindChild("right/yilingquSP").gameObject
    btn_lingqu:SetActive(false)
    btn_qianwang:SetActive(false)
    jinduSlider:SetActive(false)
    yilingquSP:SetActive(false)
    UIEventListener.Get(btn_lingqu).onClick = function ()
        print("ID为:"..localData.ID.."被领取")
        btn_lingqu:SetActive(false)
        jinduSlider:SetActive(false)
        yilingquSP:SetActive(true)
        --发送领取奖励协议


        for i = 1, #model.dailyMissionDataList do
            if missionID == model.dailyMissionDataList[i].id  then
                model.dailyMissionDataList[i].islingqu = 1
                return
            end
        end
    end
    UIEventListener.Get(btn_qianwang).onClick = function ()
        print("前往地下城:"..localData.UIDefine)
        --ui_manager.DestroyWB(WNDTYPE.dailyMission)
    end

    if islingqu == 0 and localData.TargetValue <= jinduNum then--完成未领取
        btn_lingqu:SetActive(true)
        jinduSlider:SetActive(true)
        local jinduLabelText = localData.TargetValue .."/"..localData.TargetValue
        jinduSlider.transform:FindChild("jindulabel"):GetComponent("UILabel").text = jinduLabelText
        jinduSlider:GetComponent("UISlider").value = 1
    elseif islingqu == 0 and localData.TargetValue > jinduNum then --未完成
        btn_qianwang:SetActive(true)
        jinduSlider:SetActive(true)
        local jinduLabelText = jinduNum .."/"..localData.TargetValue
        jinduSlider.transform:FindChild("jindulabel"):GetComponent("UILabel").text = jinduLabelText
        local jinduValue = jinduNum/localData.TargetValue
        jinduSlider:GetComponent("UISlider").value = jinduValue
    elseif islingqu == 1 then--完成已领取
        yilingquSP:SetActive(true)
    end
    ----初始化right----
end


return dailyMission_controller