upSoldier_controller = {}
require("uiscripts/commonGameObj/cardhead")
local view = require("uiscripts/cardyc/upSoldier/upSoldier_view")
local data = require("uiscripts/cardyc/upSoldier/upSoldier_model")

local cardhead
function upSoldier_controller:init( args )

    view:init_view(args)
    local position = Vector3(0,136,0)
    cardhead = CardHead(view.soldierPanel,position)
    UIEventListener.Get(view.soldierP_btnUpSoldier).onPress = function(soldierP_btnUpSoldier, args)
        if args then
            self:soldier_Up_CallBack()
        end
    end
    self:Refresh()
end



function upSoldier_controller:Refresh()
    -- body
    print("upSoldier_controller refresh!!!!")

    --刷新卡牌头像，显示当前卡牌的默认星级
    if cardhead then
        cardhead:refresh(data.cardId,data.cardLv,data.starLv)
    end
    --显示兵员等级（兵员等级/兵员等级上限）
    view.soldierP_LvProLab.transform:GetComponent("UILabel").text
    = string.format("%s%d/%d",stringUtil:getString(20041),data.soldierLv,Const.MAX_ARMY_LV)

    --判断是否达到最大兵员等级，设置界面显示内容
    if data.soldierLv >= Const.MAX_ARMY_LV then
        view.soldierP_btnUpSoldier:SetActive(false)
        view.soldierP_cost:SetActive(false)
        view.soldierP_maxSoldierP:SetActive(true)
        --显示兵员等级达到最大时的可携带兵员数量
        view.soldierP_desLab.transform:GetComponent("UILabel").text
        = string.format(stringUtil:getString(20504)
        ,data:getSoldierLimit(data.soldierLv))
        return
    end

    --未达兵员等级上限设置界面显示
    view.soldierP_btnUpSoldier:SetActive(true)
    view.soldierP_cost:SetActive(true)
    view.soldierP_maxSoldierP:SetActive(false)

    view.soldierP_cardNameL.transform:GetComponent("UILabel").text = cardUtil:getCardName(data.cardId)
    view.soldierP_badgeNameL.transform:GetComponent("UILabel").text = stringUtil:getString(20027)

    --显示兵员当前和下一等级可携带兵员数量
    view.soldierP_desLab.transform:GetComponent("UILabel").text
         =  string.format(stringUtil:getString(20503)
            ,data:getSoldierLimit(data.soldierLv)
            ,data:getSoldierLimit(data.soldierLv + 1))
    --设置兵员升级消耗显示
    local needCardNum = data:getUpSoldierNeedGoods("Card",data.soldierLv + 1)
    local needCoinNum = data:getUpSoldierNeedGoods("Coin",data.soldierLv + 1)
    view.soldierP_cardNeedL.transform:GetComponent("UILabel").text = string.format("x%d",needCardNum)
    view.soldierP_badgeNeednumL.transform:GetComponent("UILabel").text = string.format("x%d",needCoinNum)
    view.soldierP_cardHavaLab.transform:GetComponent("UILabel").text = string.format("(%s%d)",stringUtil:getString(20028),data.cardFragment)
    view.soldierP_badgeHaveLab.transform:GetComponent("UILabel").text = string.format("(%s%d)",stringUtil:getString(20028),data.badgeNum)

    if needCardNum > data.cardFragment then
        view.soldierP_cardHavaLab.transform:GetComponent("UILabel").color = Color(255/255,0/255,0/255,255/255)
    else
        view.soldierP_cardHavaLab.transform:GetComponent("UILabel").color = Color(0/255,255/255,255/255,255/255)
    end
    if needCoinNum > data.badgeNum then
        view.soldierP_badgeHaveLab.transform:GetComponent("UILabel").color = Color(255/255,0/255,0/255,255/255)
    else
        view.soldierP_badgeHaveLab.transform:GetComponent("UILabel").color = Color(0/255,255/255,255/255,255/255)
    end
end

--点击兵员升级按钮
function upSoldier_controller:soldier_Up_CallBack()
    --判断是否可以刷新界面
    local isCan_UpSoldier = data:isCan_UpSoldier()
    if isCan_UpSoldier ~= 0 then
        UIToast.Show(isCan_UpSoldier, nil, UIToast.ShowType.Upwards)
        return
    end
    --发消息,提升等级,刷新界面
    Message_Manager:SendPB_UpSoldier(data.cardId)
end



return upSoldier_controller