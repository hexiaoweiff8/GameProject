local upSynergy_controller = {}
local view = require("uiscripts/cardyc/upSynergy/upSynergy_view")
local data = require("uiscripts/cardyc/upSynergy/upSynergy_model")

require("uiscripts/commonGameObj/synergyItem")
require("uiscripts/commonGameObj/cardhead")

local UpSynergyIndex = 0        --保存所选中的协同选项
local isAttrItemInit = false    --是否初始化协同选项
local isInitxtLayer = false     --是否初始化协同详细信息界面

local synergyItems = {}
local cardHead
function upSynergy_controller:init( args )
    view:init_view(args)
end

function upSynergy_controller:Refresh()
    print("upSynergy_controller refresh!!!!")
    data:init_synergyIDTbl()
    data:init_synergyStateTbl()
    self:synergy_Body()
end



--刷新协同部分
function upSynergy_controller:synergy_Body()

    if not isAttrItemInit then 
        for i=1 ,#data.synergyLvTbl do
            synergyItems[i] = SynergyItem(view.synergyPanel,i,self.show_synergyItemInfo)
        end
        isAttrItemInit = true
    end

    --刷新协同选项
    for i=1 ,#data.synergyLvTbl do
        print(data.synergyIDTbl[i], data.synergyStateTbl[i],data:isCan_UpSynergy(i))
        synergyItems[i]:refresh(data.synergyIDTbl[i], data.synergyStateTbl[i],data:isCan_UpSynergy(i),i)
    end

    --计算解锁的协同卡牌数量
    local count = 0
    for i=1,#data.synergyStateTbl do
        if data.synergyStateTbl[i] == data.SynergyState.activated then
            count = count+1
        end
    end
    --根据协同选项的数量解锁协同额外属性
    for i = 1, 3 do 
        --设置显示的属性信息
        local attributeName = attributeUtil:getAttributeName(synergyUtil:getSynergyAttributeAdd(data.cardId,i))
        local attributePoint = synergyUtil:getSynergyAddPoint(data.cardId,i)
        local attributeSymbol = attributeUtil:getAttributeSymbol(synergyUtil:getSynergyAttributeAdd(data.cardId,i))


        view["synergyP_addProperty_"..i]:GetComponent("UILabel").text =
            string.format("%s+%d%s", attributeName, attributePoint, attributeSymbol)
        --[[激活2,3,4张协同卡牌时解锁相应的属性]]
        if count - 1 >= i then  
            view["synergyP_addProperty_"..i].transform:GetComponent("UILabel").color= COLOR.Green
        else
            view["synergyP_addProperty_"..i].transform:GetComponent("UILabel").color= COLOR.White
        end
    end 
end
--点击协同选项
function upSynergy_controller:show_synergyItemInfo(index)

     --初始化协同升级界面
    if not isInitxtLayer then
        view:init_upSynergyPanel()
        cardHead = CardHead(view.upSynergyP, Vector3(-220,20,0))
        isInitxtLayer = true
        UIEventListener.Get(view.upSynergyP_btnBack).onPress = function(upSynergyP_btnBack, args)
            if args then
                view.upSynergyP:SetActive(false)
            end
        end
        UIEventListener.Get(view.upSynergyP_btnCancle).onPress = function(upSynergyP_btnCancle, args)
            if args then
                view.upSynergyP:SetActive(false)
            end
        end
    end
    UIEventListener.Get(view.upSynergyP_btnOk).onPress = function(upSynergyP_btnOk, args)
        if args then
            upSynergy_controller:upSynergyP_btnOk_onClicked(index)
        end
    end
    view.upSynergyP:SetActive(false)

    --初始化协同卡牌的图标,显示相应的卡牌信息
    local synergyCardId = data.synergyIDTbl[index]
    local synergyCardLv = 1
    local synergyCardStarLv = 1
    if data:getCardByID(synergyCardId) then 
        synergyCardLv = data:getCardByID(synergyCardId).lv
        synergyCardStarLv = data:getCardByID(synergyCardId).star
    end
    cardHead:refresh(synergyCardId, synergyCardLv, synergyCardStarLv)

    --判断协同是否已经激活
    if data.synergyStateTbl[index] == data.SynergyState.activated then 
        view.upSynergyP_title.transform:GetComponent("UILabel").text = stringUtil:getString(20035)--[[20035"协同升级"]]
         --判断是否达到最大等级，显示最大等级提示
        if data.synergyLvTbl[index] >= Const.MAX_SYNERGY_LV then
            view.upSynergyP_btnP:SetActive(false)
            view.upSynergyP_maxSynergyP:SetActive(true)
        else
            view.upSynergyP_btnOkL.transform:GetComponent("UILabel").text = stringUtil:getString(20002)--[[20002"升级""]]
        end
    else --如果协同尚未激活,设置标题和按钮的内容，并显示激活按钮
        view.upSynergyP_title.transform:GetComponent("UILabel").text = stringUtil:getString(20034)--[[20034"协同作战"]]
        view.upSynergyP_btnOkL.transform:GetComponent("UILabel").text = stringUtil:getString(20051)--[[20051"激活"]]
        view.upSynergyP_btnP:SetActive(true)
        view.upSynergyP_maxSynergyP:SetActive(false)
    end

    --设置卡牌的名称
    view.upSynergyP_cardNameL.transform:GetComponent("UILabel").text 
        = string.format(stringUtil:getString(20050)
            ,cardUtil:getCardName(data.cardId)
            ,cardUtil:getCardName(synergyCardId))

    --从表中获取显示的信息
    view.upSynergyP_desL.transform:GetComponent("UILabel").text = stringUtil:getString(20032)
    view.upSynergyP_coinL.transform:GetComponent("UILabel").text = stringUtil:getString(20027)
    view.upSynergyP_goldL.transform:GetComponent("UILabel").text = stringUtil:getString(20033)

    
    --获取协同升级所需的材料数量
    local needCoinNum = synergyUtil:getNeedCoin(data.synergyLvTbl[index] + 1)
    local needGoldNum = synergyUtil:getNeedGold(data.synergyLvTbl[index] + 1)
    view.upSynergyP_coinNeedNumL.transform:GetComponent("UILabel").text = string.format("X%d", needCoinNum)
    view.upSynergyP_goldNeedNumL.transform:GetComponent("UILabel").text = string.format("X%d", needGoldNum)
    
    --获取拥有的材料数量
    local haveCoinNum = data.badgeNum
    local haveGoldNum = data.goldNum
    local coinNumColor = "FF2121" 
    local goldNumColor = "FF2121" 
    if haveCoinNum >= needCoinNum then 
        coinNumColor = "21FF21"
    end
    if haveGoldNum >= needGoldNum then
        goldNumColor = "21FF21"
    end
    view.upSynergyP_coinHaveNumL.transform:GetComponent("UILabel").text = string.format("([%s]%s%d[-])", coinNumColor,stringUtil:getString(20028), data.badgeNum) 
    view.upSynergyP_goldHaveNumL.transform:GetComponent("UILabel").text = string.format("([%s]%s%d[-])", goldNumColor,stringUtil:getString(20028), data.goldNum) 
    
    view.upSynergyP:SetActive(true)
end
--点击协同升级按钮
function upSynergy_controller:upSynergyP_btnOk_onClicked(index)
    --判断当前是否可以协同升级
    local isCan_UpSynergy = data:isCan_UpSynergy(index)
    if isCan_UpSynergy ~= 0 then
        UIToast.Show(isCan_UpSynergy)
        return
    end
    UpSynergyIndex = index
    --向服务器发送升级协同数据
    Message_Manager:SendPB_UpSynergy(data.cardId,index-1)
    
end
--协同升级成功后刷新界面
function upSynergy_controller:upSynergy_refresh()
    --刷新协同升级界面
    self:show_synergyItemInfo(UpSynergyIndex)
end

return upSynergy_controller