

require('uiscripts/tips/ui_tips_item')
require('uiscripts/tips/ui_tips_equip')

wnd_qiandao_controller = {
    view,--视图层
    model,--数据层
    Slidingdistance,--滑动总距离
    dis,--每一次的滑动距离
    finish,--是否完成界面滑动

    ---function----
    initListener,--添加按钮事件
    updatalocaldata,--更新本地数据
    SetRefeshTime,--设置刷新时间
    getSlidingdistance,--获取滑动距离
    InitQiandaoResList,--初始化签到奖励信息
    ContentsInflate,--获取签到奖励信息
    PressCtr, --玩家点击的事件处理
    QidandaoCtr, --进行点击签到的事件处理

    tipsshow = false, --tips是否已经被显示
    resneedbesign = false --选中的物体是否需要被签到处理

}
local class = require("common/middleclass")
wnd_qiandao_controller = class("wnd_qiandao_controller", wnd_base)
local this = wnd_qiandao_controller
local instance = nil

function wnd_qiandao_controller:OnShowDone()
    instance = self
    this.view = require("uiscripts/qiandao/wnd_qiandao_view")
    this.model = require("uiscripts/qiandao/wnd_qiandao_model")
    this.view:initview(self)
    this.model:initModel()
    this:initListener()
    this.qiandao_res_Ctrl()
    print("qiandao  ++++  OnShowDone")
end


function wnd_qiandao_controller:initListener()
    UIEventListener.Get(this.view.CloseBtn).onClick = function()
        instance:Hide(0)
    end

    for i = 1,#this.view.qiandao_res_list do
        UIEventListener.Get(this.view.qiandao_res_list[i].transform:Find("qiandao_res_quality").gameObject).onPress = function (go,isPressed)
            this:PressCtr(go,isPressed)
        end
    end

end

----签到到第几天的控制------
function wnd_qiandao_controller:qiandao_res_Ctrl()
    this:SetRefeshTime()
    this.InitQiandaoResList()
    this.Slidingdistance = 0
    this.dis = 0
    this.finish = false

    print("玩家没有签到之前的签到状态是-----"..this.model.serv_qiandaoInfo["isSigned"])
    print("玩家没有签到之前的累计签到天数是-----"..this.model.serv_qiandaoInfo["days"])
    for index = 1,this.model.serv_qiandaoInfo["days"] do
        local go = this.view.qiandao_res_list[index].transform:Find("qiandao_res_quality/qiandao_res_icon/qiandao_res_blackbg").gameObject
        go:SetActive(true)
    end
    this.view.QiandaoData.QiandaoCishu:GetComponent("UILabel").text = this.model.serv_qiandaoInfo["days"].."次"

    if(this.model.serv_qiandaoInfo["isSigned"] == 0) then
        this:getSlidingdistance(this.model.serv_qiandaoInfo["days"]+1)
    else
        this:getSlidingdistance(this.model.serv_qiandaoInfo["days"])
    end
end


function wnd_qiandao_controller:PressCtr(go,isPressed)
    -- 先判断press传来的物体是不是每日签到的奖励物品
    --print("父物体的名字是"..go.transform.parent.name)
    --this.OnPressTimer = TimeUtil:CreateTimer(5,OnComplete)
    --然后判断是否进行了长按，如果是长按则进行回调，回调为展示TIPS，传入相关信息。
    self.obj = go

    for index = 1,#this.view.qiandao_res_list do

        if(self.obj.transform.parent.name == this.view.qiandao_res_list[index].name) then
            print("我按到了谁-----"..this.view.qiandao_res_list[index].name)
            print("index是多少---"..index)
            godata = this.model.local_checkin[index]

            if(this.model.serv_qiandaoInfo["isSigned"] == 0 and index == this.model.serv_qiandaoInfo["days"]+1) then
                this.resneedbesign = true
            else
                this.resneedbesign = false
            end

        end
    end

    OnComplete = function()
        this.OnPressTimer:Kill()
        if(this.resneedbesign) then
            return
        end
        if godata["AwardType"] == 'item' then
            ui_tips_item.Show(require('uiscripts/cangku/wnd_cangku_model'):getLocalItemDataRefByItemID(tonumber(godata["ID"])),
            Vector3.zero)
            --this._bTipsIsShow = true
            this.tipsshow = true
        elseif godata["AwardType"] == 'equip' then
            -- DONE: 显示装备Tips
            ui_tips_equip.Show(require('uiscripts/commonModel/equip_Model'):getLocalEquipmentRefByEquipID(tonumber(godata["ID"])),
            Vector3.zero)
            --this._bTipsIsShow = true
            this.tipsshow = true
        elseif godata["AwardType"] == 'card' then
            -- DONE: 显示卡牌Tips
            --this._bTipsIsShow = true
            this.tipsshow = false
        elseif godata["AwardType"] == "currency" then
            this.tipsshow = false
        end
        print("已经完成了计时!!")
    end
    --this.OnPressTimer:Start()
    print("现在我按没按！"..tostring(isPressed))

    if isPressed then
        if this.OnPressTimer then
            if this.OnPressTimer.IsStop then
                this.OnPressTimer:Start()
            end
        else
            this.OnPressTimer = TimeUtil:CreateTimer(0.5,OnComplete)
        end
    else
        this.OnPressTimer:Kill()
        if(this.resneedbesign) then
            this:QidandaoCtr(self.obj)
            return
        end
        if(this.tipsshow) then
            if ui_tips_item.bIsShowing then
                ui_tips_item.Hide()
            elseif ui_tips_equip.bIsShowing then
                ui_tips_equip.Hide()
            end
            -- ui_tips_equip.Hide()
            this.tipsshow = false
        end
        print("我的手抬起来了！")
    end
    --如果不是长按，判断是否是今日需要签到的物品，
    --如果是，判断今天签了还是没钱，如果没签就毫无响应，如果签了，则进行点击签到的逻辑代码，如果不是，则毫无响应。
end

function wnd_qiandao_controller:Update()
    if(not this.finish) then
        for index = 1,40 do
            this.dis = this.dis+1
            if this.dis<=this.Slidingdistance then
                this.view.qiandao_res_panel:GetComponent("UIScrollView"):MoveRelative(Vector3(0,1,0))
            else
                this.finish = true
            end
        end
    end
end

function wnd_qiandao_controller:SetRefeshTime()
    this.view.QiandaoData.Time:GetComponent("UILabel").text = "每日"..tostring(this.model:getLocalRefeshTime())..":00"
end


function wnd_qiandao_controller:getSlidingdistance(days)
    if (days>=1 and days<=5) then
        this.Slidingdistance =  0
    elseif (days and days<=10) then
        this.Slidingdistance =  117
    elseif (days>10 and days<=15) then
        this.Slidingdistance =  225
    elseif (days>15 and days<=20) then
        this.Slidingdistance =  342
    elseif (days >20 and days<=30) then
        this.Slidingdistance =  425
    end
end

function wnd_qiandao_controller:InitQiandaoResList()
    for index = 1,30 do
        this:ContentsInflate(this.view.qiandao_res_list[index],index)
    end
end

function wnd_qiandao_controller:ContentsInflate(qiandaoListItem,Day)
    local _AwardData = this.model:getLocalAwardDataByDay(tonumber(Day))
    local _ItemData = nil
    local _Icon = nil
    local _Quality = _AwardData["Quality"]
    local _Number = _AwardData["Num"]

    if _AwardData["AwardType"] == "item" then
        _ItemData = require("uiscripts/cangku/wnd_cangku_model"):getLocalItemDataRefByItemID(tonumber(_AwardData["ID"]))
        _Icon = _ItemData["Icon"]
    elseif _AwardData["AwardType"] == "equip" then
        _ItemData = require("uiscripts/commonModel/equip_Model"):getLocalEquipmentDetailByEquipID(tonumber(_AwardData["ID"]))
        _Icon = _ItemData["EquipIcon"]
    elseif _AwardData["AwardType"] == "currency" then
        _ItemData = require("uiscripts/shop/wnd_shop_model"):getShopCurrencyDataRefByField(_AwardData["ID"])
        _Icon = _ItemData["Icon"]
    elseif _AwardData["AwardType"] == "card" then
        _ItemData = nil
        _Icon = cardUtil:getCardIcon(tonumber(_AwardData["ID"]))
    end

    -- 处理品质值为空的情况
    _Quality = _Quality or 1
    qiandaoListItem.transform:Find("qiandao_res_quality/qiandao_res_icon").gameObject:GetComponent(typeof(UISprite)).spriteName =_Icon
    qiandaoListItem.transform:Find("qiandao_res_quality").gameObject:GetComponent(typeof(UISprite)).spriteName = this.model:getQualitySpriteStr(_Quality)
    qiandaoListItem.transform:Find("number").gameObject:GetComponent("UILabel").text = "x".._Number
end


function wnd_qiandao_controller:QidandaoCtr(item)

    --local on_10030_rec = function(body)
    --    print("on_10030_rec call")
    --    Event.RemoveListener("10030", on_10030_rec)
    --    --   UIToast.Show("已接收到来自服务器的签到信息.",nil,UIToast.ShowType.Queue)
    --    local gw2c = gw2c_pb.SignIn()
    --    gw2c:ParseFromString(body)
    --    ----   this:updateServData(gw2c.currency,nil)
    --    print("服务器交互后的签到状态是-----"..gw2c.sign["isSigned"])
    --    print("服务器交互后的累计签到天数是-----"..gw2c.sign["days"])
    --    if(gw2c.sign["isSigned"]) then
    --        this.view.QiandaoData.QiandaoCishu:GetComponent("UILabel").text = (gw2c.sign["days"]).."次"
    --        local go = item.transform:Find("qiandao_res_icon/qiandao_res_blackbg").gameObject
    --        go:SetActive(true)
    --        this:updatalocaldata(gw2c)
    ---------需要更新本地的签到信息---------
    --    end
    --end
    --Message_Manager:SendPB_10030(on_10030_rec)


    local go = item.transform:Find("qiandao_res_icon/qiandao_res_blackbg").gameObject
    go:SetActive(true)
    this.model.serv_qiandaoInfo["isSigned"] = 1

end


function wnd_qiandao_controller:updatalocaldata(SignIn) --将签到奖励添加到本地数据当中（更新本地数据）
    userModel:setSign(SignIn.sign)
    if(SignIn.card~=nil) then
        cardModel:addCards(SignIn.card)
    end

    if(SignIn.equip~=nil) then
        for k,v in pairs(SignIn.equip) do
            require("uiscripts/commonModel/equip_Model"):addEquipData(v)
        end
    end

    if(SignIn.currency~=nil) then
        currencyModel:addCoin(SignIn.currency)
    end

    if(SignIn.item~=nil) then
        itemModel:addItems(SignIn.item)
    end

    
end


return wnd_qiandao_controller


