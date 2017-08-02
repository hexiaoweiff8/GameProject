
wnd_qiandao_controller = {
    view,--视图层
    model,--数据层
    SignInfo = {},--签到信息
    Slidingdistance,--滑动总距离
    dis,--每一次的滑动距离
    finish,--是否完成界面滑动

    ---function----
    initListener,--添加按钮事件
    updatalocaldata,--更新本地数据
    SetRefeshTime,--设置刷新时间
    AddClickEventforRes,--为需要添加点击签到事件的图片加碰撞体
    getSlidingdistance,--获取滑动距离
    InitQiandaoResList,--初始化签到奖励信息
    ContentsInflate,--获取签到奖励信息

}
local class = require("common/middleclass")
wnd_qiandao_controller = class("wnd_qiandao_controller", wnd_base)
local this = wnd_qiandao_controller

function wnd_qiandao_controller:OnShowDone()
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
        this.view.MainPanel:SetActive(false)
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
        local item = this.view.qiandao_res_list[this.model.serv_qiandaoInfo["days"]+1].transform:Find("qiandao_res_quality").gameObject
        this:AddClickEventforRes(item)
        --TODO: 设置第N天的签到为TRUE,播放动画
        UIEventListener.Get(item).onClick = function()

            local on_10030_rec = function(body)
                print("on_10030_rec call")
                Event.RemoveListener("10030", on_10030_rec)
                --   UIToast.Show("已接收到来自服务器的签到信息.",nil,UIToast.ShowType.Queue)
                local gw2c = gw2c_pb.SignIn()
                gw2c:ParseFromString(body)
                ----   this:updateServData(gw2c.currency,nil)
                print("服务器交互后的签到状态是-----"..gw2c.sign["isSigned"])
                print("服务器交互后的累计签到天数是-----"..gw2c.sign["days"])
                if(gw2c.sign["isSigned"]) then
                    this.view.QiandaoData.QiandaoCishu:GetComponent("UILabel").text = (gw2c.sign["days"]).."次"
                    local go = item.transform:Find("qiandao_res_icon/qiandao_res_blackbg").gameObject
                    go:SetActive(true)
                    this:updatalocaldata(gw2c)
                end
            end
            print(type(on_10030_rec))
            Message_Manager:SendPB_10030(on_10030_rec)
            require('uiscripts/tips/ui_tips_equip').Show(require('uiscripts/cangku/wnd_cangku_model'):getLocalEquipmentRefByEquipID(300210),Vector3.zero)
            --require('uiscripts/tips/ui_tips_equip').Hide()
        end
    else
        this:getSlidingdistance(this.model.serv_qiandaoInfo["days"])
    end
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


function wnd_qiandao_controller:AddClickEventforRes(item)
    collider = item:AddComponent(typeof(UnityEngine.BoxCollider))
    collider.isTrigger = true
    collider.center = Vector3.zero
    collider.size = Vector3(collider.gameObject:GetComponent(typeof(UIWidget)).localSize.x,collider.gameObject:GetComponent(typeof(UIWidget)).localSize.y,0)
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


function wnd_qiandao_controller:updatalocaldata(SignIn) --将签到奖励添加到本地数据当中（更新本地数据）
    userModel:setSign(SignIn.sign)


    if(SignIn.card~=nil) then
        cardModel:addCards(SignIn.card)
    end


    if(SignIn.equip~=nil) then
        for k,v in pairs(SignIn.equip) do
            --v为所有equip
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


function wnd_qiandao_controller:OnDisable()

    print("12312312312")

end


return wnd_qiandao_controller


