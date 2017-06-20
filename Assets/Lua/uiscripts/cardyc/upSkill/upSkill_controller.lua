upSkill_controller = {}
local view = require("uiscripts/cardyc/upSkill/upSkill_view")
local data = require("uiscripts/cardyc/upSkill/upSkill_model")
require("uiscripts/commonGameObj/skillItem")
require("uiscripts/commonGameObj/cardhead")

local UpSkillIndex = 0          --保存升级的技能的index
local isInitSUpLayer = false    --是否初始化技能详细信息界面
local isfiveSIinit = false      --是否初始化技能选项
local isInitSptReset = false    --是否初始化技能重置界面

local skillItems = {}
local skillInfoItem
local cardhead
local CardIndex
function upSkill_controller:init( args )
    view:init_view(args)
    
end

function upSkill_controller:refresh(cardIndex)
    -- body
    print("upSkill_controller refresh!!!!")
    CardIndex = cardIndex
    if not data:getDatas(CardIndex) then 
        return 
    end 
    self:skill_Body()
end


--技能tab界面
function upSkill_controller:skill_Body()
    --初始化技能点
    view.skillP_pointLab.transform:GetComponent("UILabel").text = data.totalSkPt
    --监听重置技能点按钮
    UIEventListener.Get(view.skillP_btnResetPoint).onClick = function()
        self:show_SkillPoint_Reset_Panel()
    end
    --[[
        初始化技能图标
    ]]
    for i=1,5 do
        local position = Vector3(data.skill_position_Table[i].x, data.skill_position_Table[i].y, data.skill_position_Table[i].z)
        if not isfiveSIinit then
            skillItems[i] = SkillItem(view.skillPanel, position, i, self.show_SkillItem_UpPanel)
        end
        skillItems[i]:refresh(data.skill_ID_Table[i], data.skill_Lv_Table[i], data.starLv, i)
    end
    isfiveSIinit = true
end


--显示技能详细信息界面
function upSkill_controller:show_SkillItem_UpPanel(index)
    --第一次进入本界面，初始化
    if not isInitSUpLayer then
        view:init_skillInfoPanel()
        local position = Vector3(-210,60,0)
        skillInfoItem = SkillItem(view.skillInfoPanel, position)
        view.skillInfoPanel:SetActive(false)
        UIEventListener.Get(view.skillInfoP_BtnBack).onClick = function()
            view.skillInfoPanel:SetActive(false)
        end
        isInitSUpLayer = true
    end

    skillInfoItem:refresh(data.skill_ID_Table[index], data.skill_Lv_Table[index], data.starLv, index)

    view.skillInfoP_lv_Lab.transform:GetComponent("UILabel").text 
        = stringUtil:getString(20041)
    view.skillInfoP_lvProLab.transform:GetComponent("UILabel").text 
        = string.format("[f15c03]%d[-]/%d",data.skill_Lv_Table[index],Const.MAX_SKILL_LV)--当前技能/技能总级
    view.skillInfoP_sdes_Lab.transform:GetComponent("UILabel").text 
        = skillUtil:getskillDesByID(data.skill_ID_Table[index])
    view.skillInfoP_btn_unlock_Label.transform:GetComponent("UILabel").text
        = string.format(stringUtil:getString(20049),index) 
        
    local skcost = skillUtil:getUpSkillNeedPoints(data.skill_Lv_Table[index] + 1)--获取升级消耗技能点
    view.skillInfoP_costLab.transform:GetComponent("UILabel").text = skcost
    view.skillInfoP_costLab.transform:GetComponent("UILabel").color = COLOR.White
    if skcost > data.totalSkPt then--判断是否足够升级，设置颜色
        view.skillInfoP_costLab.transform:GetComponent("UILabel").color = COLOR.Red
    end

    UIEventListener.Get(view.skillInfoP_btn_unlock).onClick = function()
        print("尚未解锁！！！！！")
    end 
    UIEventListener.Get(view.skillInfoP_btn_upLv).onClick = function()
        upSkill_controller:skillItem_Up_CallBack(index)
    end 
    --技能升级按钮显示
    view.skillInfoP_btn_unlock:SetActive(true)
    view.skillInfoP_btn_upLv:SetActive(false)
    view.skillInfoP_maxSkillLv:SetActive(false)
    if index <= data.starLv then
        view.skillInfoP_btn_unlock:SetActive(false)
        view.skillInfoP_btn_upLv:SetActive(true)
    end
    --判断是否达到最大技能等级
    if data.skill_Lv_Table[index] >= Const.MAX_STAR_LV then 
        view.skillInfoP_btn_unlock:SetActive(false)
        view.skillInfoP_btn_upLv:SetActive(false) 
        view.skillInfoP_maxSkillLv:SetActive(true)
    end
    view.skillInfoPanel:SetActive(true)
end

--点击技能升级按钮
function upSkill_controller:skillItem_Up_CallBack(index)
    if data:isCan_UpSkill(index) ~= 0 then
        ui_manager:ShowWB(WNDTYPE.ui_tips)
        return
    end
    UpSkillIndex = index
    Message_Manager:SendPB_10014(data.cardId,index-1)
end
--根据升级技能的index对界面进行刷新
function upSkill_controller:upSkill_refresh()
    wnd_cardyc_controller:refresh()
    self:show_SkillItem_UpPanel(UpSkillIndex)
    
end





--显示重置技能点界面
function upSkill_controller:show_SkillPoint_Reset_Panel()
    if not isInitSptReset then
        view:init_skillPointResetPanels()
        cardhead = CardHead(view.sPtRPanel,Vector3(-199,40,0))
        view.sPtRPanel:SetActive(false)
        isInitSptReset = true
    end
    view.sPtRP_titleL.transform:GetComponent("UILabel").text = stringUtil:getString(20029)        --描述
    view.sPtRP_desL.transform:GetComponent("UILabel").text = string.format(stringUtil:getString(20030),cardUtil:getCardName(data.cardId))                 --返回按钮添加监听
    view.sPtRP_norResetCostL.transform:GetComponent("UILabel").text = 100
    view.sPtRP_perResetCostL.transform:GetComponent("UILabel").text = 300
    UIEventListener.Get(view.sPtRP_btnBack).onClick = function()
        view.sPtRPanel:SetActive(false)
    end
    UIEventListener.Get(view.sPtRP_norResetB).onClick = function()
        self:normal_Reset_CallBack()
    end
    UIEventListener.Get(view.sPtRP_perResetB).onClick = function()
        self:perfect_Reset_CallBack()
    end
    --刷新技能重置界面的卡牌头像，显示默认星级
    cardhead:refresh(data.cardId,data.cardLv,data.starLv)
    view.sPtRPanel:SetActive(true)
end
--普通重置
function upSkill_controller:normal_Reset_CallBack()
    --已解锁的技能等级变为1级，返还升级所用的技能卡数目的80%加至总技能卡中
    Message_Manager:SendPB_10015(data.cardId, 100)
end
--完美重置
function upSkill_controller:perfect_Reset_CallBack()
    Message_Manager:SendPB_10015(data.cardId, 300)
end
--重置技能成功后对界面进行刷新
function upSkill_controller:skillReset_refresh()
    wnd_cardyc_controller:refresh()
    view.sPtRPanel:SetActive(false)
end
return upSkill_controller