upLevel_controller = {}
local view = require("uiscripts/cardyc/upLevel/upLevel_view")
local data = require("uiscripts/cardyc/upLevel/upLevel_model")

require("uiscripts/commonGameObj/cardhead")


local cardhead

local isInitUpLvLayer = false  --是否初始化升级界面
local CardIndex
function upLevel_controller:init( args )
    view:init_view(args)
end

--点击主界面升级按钮
function upLevel_controller:show_UpLevel_Layer(cardIndex)
    CardIndex = cardIndex
    if not data:getDatas(CardIndex) then 
        return 
    end 
    if not isInitUpLvLayer then--初始化升级界面
        --初始化升级界面的控件
        view:init_Uplevel_Panel()
        cardhead = CardHead(view.upLevelPanel,Vector3(-186,48,0))
        view.upLevelPanel:SetActive(false)
        isInitUpLvLayer = true
    end
    --最大等级判断
    if data.cardLv >=Const.MAX_CARD_LV then 
        view.btn_upLevelP:SetActive(false)
        view.btn_maxLevelP:SetActive(true)
    else
        view.btn_upLevelP:SetActive(true)
        view.btn_maxLevelP:SetActive(false)
    end

    --为按钮添加监听
    UIEventListener.Get(view.btn_upLevelOne).onClick = function()
        self:upLevelOne_CallBack()
    end
    UIEventListener.Get(view.btn_upLevelTen).onClick = function()
        self:upLevelTen_CallBack()
    end
    UIEventListener.Get(view.btn_upLevelBack).onClick = function()
        view.upLevelPanel:SetActive(false)
    end  
    self:refresh_UpLevel_Layar()                        --刷新界面 
    view.upLevelPanel:SetActive(true)        --显示界面
end

--刷新升级界面，更新数据
function upLevel_controller:refresh_UpLevel_Layar()
    --刷新升级界面的卡牌头像，显示默认星级
    cardhead:refresh(data.cardId, data.cardLv, data.starLv)
    local needExp = cardUtil:getNeedExp(data.cardLv + 1)--升级下一级所需经验
    view.expProLab.transform:GetComponent("UILabel").text = string.format("%d/%d",data.cardExp,needExp)
    view.uiSlide.transform:GetComponent("UISlider").value = data.cardExp/needExp
    view.cardLevLab.transform:GetComponent("UILabel").text = string.format("%s:%d",stringUtil:getString(20036),data.expPool)
end

--点击升一级按钮
function upLevel_controller:upLevelOne_CallBack()
    if data:isCan_UpLevel() ~= 0 then
        ui_manager:ShowWB(WNDTYPE.ui_tips)
        return
    end
    Message_Manager:SendPB_10009(data.cardId, 1)
    
end

--点击升十级按钮
function upLevel_controller:upLevelTen_CallBack()
    if data:isCan_UpLevel() ~= 0 then
        ui_manager:ShowWB(WNDTYPE.ui_tips)
        return
    end
    Message_Manager:SendPB_10009(data.cardId, 10)
end

--点击升级后刷新界面，在wndtz_login.lua中服务器返回数据后调用
function upLevel_controller:upLevel_refresh()
    -- body
    wnd_cardyc_controller:refresh()
    if not data:getDatas(CardIndex) then 
        return 
    end 
    self:refresh_UpLevel_Layar()
    
end

return upLevel_controller