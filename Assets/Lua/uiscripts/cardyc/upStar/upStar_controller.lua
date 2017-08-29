local upStar_controller = {}
local view
local data
local cardhead_left
local cardhead_right
local success_cardhead_left
local success_cardhead_right
local skillItem 
-----------------------------------升星部分---------------------------------
local isInitUpStarLayer --是否初始化升星界面
local isInitUpStarSLayer --是否初始化升星成功界面
local isinitSkillItem --是否初始化升星界面的技能头像
function upStar_controller:init( args )
    view = require("uiscripts/cardyc/upStar/upStar_view")
    data = require("uiscripts/cardyc/upStar/upStar_model")
    isInitUpStarLayer = false --是否初始化升星界面
    isInitUpStarSLayer = false --是否初始化升星成功界面
    isinitSkillItem = false --是否初始化升星界面的技能头像
    view:init_view(args)
    
end

function upStar_controller:OnDestroyDone()
    Memory.free("uiscripts/cardyc/upStar/upStar_view")
    Memory.free("uiscripts/cardyc/upStar/upStar_model")
    view = nil
    data = nil
    cardhead_left = nil
    cardhead_right = nil
    success_cardhead_left = nil
    success_cardhead_right = nil
    skillItem = nil
    isInitUpStarLayer = nil
    isInitUpStarSLayer = nil
    isinitSkillItem = nil
end

--显示升星界面
function upStar_controller:show_UpStar_Layer()
    if not isInitUpStarLayer then
        view:init_UpStarPanel()
        view.upStarPanel:SetActive(false)
        cardhead_left = CardHead(view.upStarPanel, Vector3(-262,0,0))
        cardhead_right = CardHead(view.upStarPanel, Vector3(-7,0,0))
        isInitUpStarLayer = true
    end

    --为按钮添加监听
    UIEventListener.Get(view.upStarP_btn_back).onPress = function(upStarP_btn_back, args)
        if args then
            view.upStarPanel:SetActive(false)
        end
    end    
    UIEventListener.Get(view.upStarP_btn_sx).onPress = function(upStarP_btn_sx, args)
        if args then
            self:upStarPanel_btnUpStar_CallBack()
        end
    end
    self:refresh_UpStar_Layer()

    view.upStarPanel:SetActive(true)
end



function upStar_controller:refresh_UpStar_Layer()
    --初始化卡牌头像，
    cardhead_left:refresh(data.cardId, data.cardLv, data.starLv)
    cardhead_right:refresh(data.cardId, data.cardLv, data.starLv + 1)
    --设置卡牌和兵牌的名称
    view.upStarP_badgeLab.transform:GetComponent("UILabel").text = stringUtil:getString(20027)
    view.upStarP_cardNameLab.transform:GetComponent("UILabel").text = cardUtil:getCardName(data.cardId)

    view.upStarP_skillPanel:SetActive(false)
    if data.starLv <= 4 then
        local skillId = cardUtil:getSkillID(data.cardId,data.starLv + 1)
        view.upStarP_skillPanel:SetActive(true)
        view.upStarP_skillP_NameLab:GetComponent("UILabel").text = skillUtil:getSkillName(skillId) --解锁技能名
        view.upStarP_skillP_skillDes:GetComponent("UILabel").text = skillUtil:getSkillDescription(skillId,data.skill_Lv_Table[data.starLv + 1])
        if not isinitSkillItem then 
            skillItem = SkillItem(view.upStarP_skillP_skillInfo,Vector3(-230,-65,0))
            isinitSkillItem = true
        end 
        skillItem:refresh(skillId)
        UIEventListener.Get(view.upStarP_skillP_NameLab).onPress = function(a, b)
            view.upStarP_skillP_skillInfo.transform.position = a.transform.position
            view.upStarP_skillP_skillInfo:SetActive(b)
        end
    end

     --最大星级判断
    if data.starLv >= Const.MAX_STAR_LV then
        view.upStarP_btn_sx:SetActive(false)
        view.upStarP_maxStarP:SetActive(true)
        view.upStarP_badgeNeedNumL.transform:GetComponent("UILabel").text = "MAX"
        view.upStarP_badgeHaveNumL.transform:GetComponent("UILabel").text = ""
        view.upStarP_cardNeedNumL.transform:GetComponent("UILabel").text = "MAX"
        view.upStarP_cardhavaNumL.transform:GetComponent("UILabel").text = ""
        return
    end
    --显示升星所需的控件
    view.upStarP_btn_sx:SetActive(true)
    view.upStarP_maxStarP:SetActive(false)

    
    --设置需要和拥有的兵牌数量    
    local needCoin = starUtil:getUpStarNeedCoin(data.starLv)
    view.upStarP_badgeNeedNumL.transform:GetComponent("UILabel").text = string.format("X%d",needCoin)
    local lab1 = string.format("([97ff03]%s%d[-])",stringUtil:getString(20028), data.badgeNum)
    if data.badgeNum < needCoin then
        lab1 = string.format("(%s[ff2121]%d[-])",stringUtil:getString(20028), data.badgeNum) 
    end
    view.upStarP_badgeHaveNumL.transform:GetComponent("UILabel").text = lab1
    --设置需要和拥有的卡牌数量
    local needFragment = starUtil:getUpStarNeedFragment(data.starLv)
    view.upStarP_cardNeedNumL.transform:GetComponent("UILabel").text = string.format("X%d", needFragment)
    local lab2 = string.format("([97ff03]%s%d[-])",stringUtil:getString(20028),data.cardFragment)
    if data.cardFragment < needFragment then
        lab2 = string.format("(%s[ff2121]%d[-])",stringUtil:getString(20028),data.cardFragment)
    end
    view.upStarP_cardhavaNumL.transform:GetComponent("UILabel").text = lab2
end
--显示升星成功后的界面，属性提升
function upStar_controller:show_UpStar_Success()

    if not isInitUpStarSLayer then
        view:init_UpStar_SuccessPanel()
        view.upStarSuccessPanel.transform.name = "upStarSuccess"
        success_cardhead_left = CardHead(view.upStarSuccessPanel, Vector3(-190,55,0))
        success_cardhead_right = CardHead(view.upStarSuccessPanel, Vector3(190,55,0))
        view.upStarSuccessPanel:SetActive(false)
        isInitUpStarSLayer = true
    end
    --初始化升星成功后的卡牌头像
    success_cardhead_left:refresh(data.cardId, data.cardLv, data.starLv - 1)
    success_cardhead_right:refresh(data.cardId, data.cardLv, data.starLv)

    view.upStarSP_live_nameL.transform:GetComponent("UILabel").text = stringUtil:getString(20037)
    view.upStarSP_live_valueBL.transform:GetComponent("UILabel").text = starUtil:getCardStarHP(data.cardId, data.starLv - 1)
    view.upStarSP_live_valueAL.transform:GetComponent("UILabel").text = starUtil:getCardStarHP(data.cardId, data.starLv)

    view.upStarSP_attack_nameL.transform:GetComponent("UILabel").text = stringUtil:getString(20038)
    view.upStarSP_attack_valueBL.transform:GetComponent("UILabel").text = starUtil:getCardStarAttack(data.cardId, data.starLv - 1)
    view.upStarSP_attack_valueAL.transform:GetComponent("UILabel").text = starUtil:getCardStarAttack(data.cardId, data.starLv)

    view.upStarSP_defense_nameL.transform:GetComponent("UILabel").text = stringUtil:getString(20039)
    view.upStarSP_defense_valueBL.transform:GetComponent("UILabel").text = starUtil:getCardStarDefense(data.cardId, data.starLv - 1)
    view.upStarSP_defense_valueAL.transform:GetComponent("UILabel").text = starUtil:getCardStarDefense(data.cardId, data.starLv)
    
    UIEventListener.Get(view.upStarSP_clickP).onClick = function()
        view.upStarSuccessPanel:SetActive(false) 
    end
    view.upStarSuccessPanel:SetActive(true) 
end


--点击升星界面的升星按钮
function upStar_controller:upStarPanel_btnUpStar_CallBack()
    local isCan_UpStar = data:isCan_UpStar(data.cardId)
    if isCan_UpStar ~= 0 then
        UIToast.Show(isCan_UpStar)
        return
    end
    --发送请求升星
    --提升星级扣道具，升星成功
    Message_Manager:SendPB_UpStar(data.cardId)
end
--升星成功后刷新
function upStar_controller:upStar_Success()
    -- body
    view.upStarPanel:SetActive(false)
    self:show_UpStar_Success()
end



return upStar_controller