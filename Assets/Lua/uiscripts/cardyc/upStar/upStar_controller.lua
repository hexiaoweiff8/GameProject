upStar_controller = {}
local view = require("uiscripts/cardyc/upStar/upStar_view")
local data = require("uiscripts/cardyc/upStar/upStar_model")

require("uiscripts/commonGameObj/cardhead")
local cardhead_left
local cardhead_right
local success_cardhead_left
local success_cardhead_right
-----------------------------------升星部分---------------------------------
local isInitUpStarLayer = false --是否初始化升星界面
local isInitUpStarSLayer = false --是否初始化升星成功界面
local CardIndex
function upStar_controller:init( args )
    view:init_view(args)
    
end

--显示升星界面
function upStar_controller:show_UpStar_Layer(cardIndex)
    CardIndex = cardIndex
    if not data:getDatas(CardIndex) then 
        return 
    end 
    if not isInitUpStarLayer then
    view:init_UpStarPanel()
    view.upStarPanel:SetActive(false)
    cardhead_left = CardHead(view.upStarPanel, Vector3(-262,0,0))
    cardhead_right = CardHead(view.upStarPanel, Vector3(-7,0,0))
    isInitUpStarLayer = true
    end

     --最大星级判断
    if data.starLv >= Const.MAX_STAR_LV then
        view.upStarP_btn_sx:SetActive(false)
        view.upStarP_maxStarP:SetActive(true)
    else 
        view.upStarP_btn_sx:SetActive(true)
        view.upStarP_maxStarP:SetActive(false)
    end

     --初始化卡牌头像，
    cardhead_left:refresh(data.cardId, data.cardLv, data.starLv)
    cardhead_right:refresh(data.cardId, data.cardLv, data.starLv + 1)

    view.upStarP_skillPanel:SetActive(false)
    if data.starLv <= 4 then
        view.upStarP_skillPanel:SetActive(true)
        view.upStarP_skillP_NameLab:GetComponent("UILabel").text = skillUtil:getSkillNameByCard(data.cardId,data.cardLv,data.starLv + 1) --解锁技能名
        UIEventListener.Get(view.upStarP_skillP_NameLab).onClick = function()
            tipsText ="弹出技能介绍框....."
            ui_manager:ShowWB(WNDTYPE.ui_tips)
        end
    end

    --兵牌    
    view.upStarP_badgeLab.transform:GetComponent("UILabel").text = stringUtil:getString(20027)
    local needCoin = starUtil:getUpStarNeedCoin(data.starLv + 1)
    view.upStarP_badgeNeedNumL.transform:GetComponent("UILabel").text = string.format("X%d",needCoin)
    local lab1 = string.format("([97ff03]%s%d[-])",stringUtil:getString(20028), data.badgeNum)
    if data.badgeNum < needCoin then
        lab1 = string.format("(%s[ff2121]%d[-])",stringUtil:getString(20028), data.badgeNum) 
    end
    view.upStarP_badgeHaveNumL.transform:GetComponent("UILabel").text = lab1


    --卡牌数量
    view.upStarP_cardNameLab.transform:GetComponent("UILabel").text = cardUtil:getCardName(data.cardId)
    local needFragment = starUtil:getUpStarNeedFragment(data.starLv + 1)
    view.upStarP_cardNeedNumL.transform:GetComponent("UILabel").text = string.format("X%d", needFragment)
    local lab2 = string.format("([97ff03]%s%d[-])",stringUtil:getString(20028),data.cardFragment)
    if data.cardFragment < needFragment then
        lab2 = string.format("(%s[ff2121]%d[-])",stringUtil:getString(20028),data.cardFragment)
    end
    view.upStarP_cardhavaNumL.transform:GetComponent("UILabel").text = lab2

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

    view.upStarPanel:SetActive(true)
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
    
    if data:isCan_UpStar() ~= 0 then
        ui_manager:ShowWB(WNDTYPE.ui_tips)
        return
    end
    --发送请求升星
    --提升星级扣道具，升星成功
    Message_Manager:SendPB_10010(data.cardId)
end
--升星成功后刷新
function upStar_controller:upStar_refresh()
    -- body
    wnd_cardyc_controller:refresh()
    if not data:getDatas(CardIndex) then 
        return 
    end 
    view.upStarPanel:SetActive(false)
    self:show_UpStar_Success()
end



return upStar_controller