local upLevel_controller = {}
local view
local data
local cardhead
local isInitUpLvLayer  --是否初始化升级界面
function upLevel_controller:init( args )
    view = require("uiscripts/cardyc/upLevel/upLevel_view")
    data = require("uiscripts/cardyc/upLevel/upLevel_model")
    isInitUpLvLayer = false  --是否初始化升级界面
    view:init_view(args)
end
function upLevel_controller:OnDestroyDone()
    Memory.free("uiscripts/cardyc/upLevel/upLevel_view")
    Memory.free("uiscripts/cardyc/upLevel/upLevel_model")
    view = nil
    data = nil
    isInitUpLvLayer = nil
end
--点击主界面升级按钮
function upLevel_controller:show_UpLevel_Layer()
    if not isInitUpLvLayer then--初始化升级界面
        --初始化升级界面的控件
        view:init_Uplevel_Panel()
        cardhead = CardHead(view.upLevelPanel,Vector3(-186,48,0))
        view.upLevelPanel:SetActive(false)
        isInitUpLvLayer = true
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

    view.cardLevLab.transform:GetComponent("UILabel").text = string.format("%s:%d",stringUtil:getString(20036),data.expPool)
    --最大等级判断
    if data.cardLv >=Const.MAX_CARD_LV then
        view.btn_upLevelP:SetActive(false)
        view.btn_maxLevelP:SetActive(true)
        view.uiSlide.transform:GetComponent("UISlider").value = 1
        view.expProLab.transform:GetComponent("UILabel").text = "MAX"
        return
    end
    view.btn_upLevelP:SetActive(true)
    view.btn_maxLevelP:SetActive(false)
    local needExp = cardUtil:getNeedExp(data.cardLv + 1)--升级下一级所需经验
    view.expProLab.transform:GetComponent("UILabel").text = string.format("%d/%d",data.cardExp,needExp)
    view.uiSlide.transform:GetComponent("UISlider").value = data.cardExp/needExp
end

--点击升一级按钮
function upLevel_controller:upLevelOne_CallBack()
    local isCan_UpLevel = data:isCan_UpLevel()
    if isCan_UpLevel ~= 0 then
        UIToast.Show(isCan_UpLevel)
        return
    end
    Message_Manager:SendPB_CardUpLevel(data.cardId, 1)

end

--点击升十级按钮
function upLevel_controller:upLevelTen_CallBack()
    local isCan_UpLevel = data:isCan_UpLevel()
    if isCan_UpLevel ~= 0 then
        UIToast.Show(isCan_UpLevel)
        return
    end
    Message_Manager:SendPB_CardUpLevel(data.cardId, 10)
end

--点击升级后刷新界面，在wndtz_login.lua中服务器返回数据后调用
function upLevel_controller:upLevel_Success()
    -- body
    self:refresh_UpLevel_Layar()
end

return upLevel_controller