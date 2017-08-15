local class = require("common/middleclass")
Message_Manager = class("Message_Manager")

require "proto/role_pb"
require "proto/gw2c_pb"
require "proto/c2gw_pb"
require "proto/header_pb"
require "proto/chat_pb"


-- 测试发送PBLUA--
function Message_Manager:SendPB_10001()
    local c2gw = c2gw_pb:LoginGame()
    c2gw.token = 'token'
    c2gw.hostId = 101
    local msg1 = c2gw:SerializeToString()
    Message_Manager:createSendPBHeader(10001, msg1)
end

function MSGID_10001(body)
    Message_Manager:SendPB_10002()
end


function Message_Manager:SendPB_10002()
    Message_Manager:createSendPBHeader(10002)
end

function MSGID_10002(body)
    local gw2c = gw2c_pb.SelectRole()
    gw2c:ParseFromString(body);
    Message_Manager:getAllData(gw2c)
    -- for k, v in ipairs(gw2c.user.currency) do
    --     lgyPrint('gw2c.user.currency.gold==>' .. v.gold);
    -- end
    -- for k, v in ipairs(gw2c.user.equip) do
    --     lgyPrint('gw2c.user.equip.id==>' .. v.eid);
    -- end
    -- for k, v in ipairs(gw2c.user.card) do
    --     lgyPrint('gw2c.user.card.id==>' .. v.id);
    -- end
    -- for k, v in ipairs(gw2c.user.item) do
    --     lgyPrint('gw2c.user.item.id==>' .. v.id);
    -- end
end


function Message_Manager:SendPB_10003()
    local c2gw = c2gw_pb:RegisterRole()
    c2gw.userName = 'lgy'
    local msg1 = c2gw:SerializeToString()
    Message_Manager:createSendPBHeader(10003, msg1)
end

function MSGID_10003(body)

end
--================================================================
--@Des 发送升级装备请求
--@params id:装备唯一id,CallBack:服务器返回数据时调用
--================================================================
function Message_Manager:SendPB_10004(id,CallBack)
    local c2gw = c2gw_pb:EquipLvlup()
    c2gw.equipId = id
    local msg1 = c2gw:SerializeToString()
    Message_Manager:createSendPBHeader(10004, msg1)
    
    if CallBack then
        Event.AddListener("10004",CallBack)
    end
end


function MSGID_10004(body)

    local gw2c = gw2c_pb.EquipLvlup()
    gw2c:ParseFromString(body)
    --装备数据
    local v = gw2c.equip  
    local tempTB1 = {}
    for k, v in ipairs(v.sndAttr) do    
        local tempTB2 = {}
        for k, v in ipairs(v.remake) do
            tempTB2[k] = equipShuXingRemakeM(v.id, v.val)
        end
        tempTB1[k] = equipShuXingM(v.id, v.val, v.isRemake, tempTB2)
    end
    
    local value = equipM(v.id, v.eid, v.lv, v.rarity + 1, v.isBad, v.isLock, v.fst_attr, tempTB1)
    local index, index2 = equipP.getIndexByID(v.id)
    if index2 then
        equipP.change_allEqList(index, index2, value)
    else
        equipP.change_nowEqList(index, value)
    end
end

function Message_Manager:sendPB_EquipPlus(id)
    Event.AddListener("10004", MSGID_EquipPlus)
    local c2gw = c2gw_pb:EquipLvlup()
    c2gw.equipId = id
    local msg1 = c2gw:SerializeToString()

    Message_Manager:createSendPBHeader(10004, msg1)
end
function MSGID_EquipPlus(body)
    local gw2c = gw2c_pb.EquipLvlup()
    gw2c:ParseFromString(body)
    currencyModel:setPower(gw2c.currency)
    EquipModel:updateEquipData(gw2c.equip)
    equip_controller:normalRefresh()
    Event.RemoveListener("10004", MSGID_EquipPlus)
end
 
--================================================================
--@Des 发送锁定/解锁装备请求
--@params eid(number):装备Id
--        isLock(number):是否上锁(0不上锁,1上锁)
--================================================================
function Message_Manager:SendPB_10005(eid, isLock, CallBack)
    lgyPrint('isLock==>' .. isLock);
    local c2gw = c2gw_pb:EquipLock()
    c2gw.equipId = eid
    c2gw.isLock = isLock
    local msg1 = c2gw:SerializeToString()
    Message_Manager:createSendPBHeader(10005, msg1)

    if CallBack then
        Event.AddListener("10005",CallBack)
    end
end

function MSGID_10005(body)
    local gw2c = gw2c_pb.EquipLock()
    gw2c:ParseFromString(body);
    --装备数据
    local v = gw2c.equip
    local tempTB1 = {}
    for k, v in ipairs(v.sndAttr) do
        local tempTB2 = {}
        for k, v in ipairs(v.remake) do
            tempTB2[k] = equipShuXingRemakeM(v.id, v.val)
        end
        tempTB1[k] = equipShuXingM(v.id, v.val, v.isRemake, tempTB2)
    end
    local value = equipM(v.id, v.eid, v.lv, v.rarity + 1, v.isBad, v.isLock, v.fst_attr, tempTB1)
    local index, index2 = equipP.getIndexByID(v.id)
    if index2 then
        equipP.change_allEqList(index, index2, value)
    else
        equipP.change_nowEqList(index, value)
    end
end

function Message_Manager:SendPB_lock(equipId, isLock)
    Event.AddListener("10005",MSGID_lock)
    local c2gw = c2gw_pb:EquipLock()
    c2gw.equipId = equipId
    c2gw.isLock = isLock
    local msg1 = c2gw:SerializeToString()
    Message_Manager:createSendPBHeader(10005, msg1)
end
function MSGID_lock(body)
    local gw2c = gw2c_pb.EquipLock()
    gw2c:ParseFromString(body)
    EquipModel:updateEquipData(gw2c.equip)
    equip_controller:normalRefresh()
    Event.RemoveListener("10005", MSGID_lock)
end


---
---装备修理
---
function Message_Manager:SendPB_10006(id)

    local c2gw = c2gw_pb:EquipRepair()
    c2gw.equipId = id
    local msg1 = c2gw:SerializeToString()
    Message_Manager:createSendPBHeader(10006, msg1)
end
function MSGID_10006(body)

    local gw2c = gw2c_pb.EquipRepair()
    gw2c:ParseFromString(body);
    --装备数据
    local v = gw2c.equip
    local tempTB1 = {}
    for k, v in ipairs(v.sndAttr) do

        local tempTB2 = {}
        for k, v in ipairs(v.remake) do

            tempTB2[k] = equipShuXingRemakeM(v.id, v.val)
        end
        tempTB1[k] = equipShuXingM(v.id, v.val, v.isRemake, tempTB2)
    end

    local value = equipM(v.id, v.eid, v.lv, v.rarity + 1, v.isBad, v.isLock, v.fst_attr, tempTB1)
    local index, index2 = equipP.getIndexByID(v.id)
    if index2 then
        equipP.change_allEqList(index, index2, value)
    else
        equipP.change_nowEqList(index, value)
    end
end



---
---修理穿戴的所有装备
---
local equipsTofix
function Message_Manager:SendPB_EquipFixAll(equipList)
    if equipList and #equipList >= 1 then
        equipsTofix = equipList
        Event.AddListener("10006", MSGID_EquipFixAll)
        local c2gw = c2gw_pb:EquipRepair()
        c2gw.equipId = equipsTofix[1].id
        local msg1 = c2gw:SerializeToString()
        Message_Manager:createSendPBHeader(10006, msg1)
    end
end

function MSGID_EquipFixAll(body)
    local gw2c = gw2c_pb.EquipRepair()
    gw2c:ParseFromString(body)
    EquipModel:updateEquipData(gw2c.equip)
    currencyModel:setPower(gw2c.currency)
    Event.RemoveListener("10006",MSGID_EquipFixAll)

    if equipsTofix and #equipsTofix > 1 then
        table.remove(equipsTofix, 1)
        Message_Manager:SendPB_EquipFixAll(equipsTofix)
        return
    end
    equip_controller:equipFixRefreshAll()
    equipsTofix = nil

end

---
---修理一件装备
---
function Message_Manager:SendPB_EquipFix(id)
    Event.AddListener("10006", MSGID_EquipFix)
    local c2gw = c2gw_pb:EquipRepair()
    c2gw.equipId = id
    local msg1 = c2gw:SerializeToString()
    Message_Manager:createSendPBHeader(10006, msg1)
end
function MSGID_EquipFix(body)
    local gw2c = gw2c_pb.EquipRepair()
    gw2c:ParseFromString(body)
    EquipModel:updateEquipData(gw2c.equip)
    currencyModel:setPower(gw2c.currency)
    equip_controller:normalRefresh()
    Event.RemoveListener("10006",MSGID_EquipFix)
end


---
---装备重铸
---
-- 测试发送PBLUA--
local RemakePanel
function Message_Manager:SendPB_EquipRemake(id, viceId, remakePanel)
    Event.AddListener("10007", MSGID_EquipRemake)
    RemakePanel = remakePanel
    local c2gw = c2gw_pb:EquipRemake()
    c2gw.equipId = id
    c2gw.viceId = viceId - 1
    local msg1 = c2gw:SerializeToString()
    Message_Manager:createSendPBHeader(10007, msg1)
end
function MSGID_EquipRemake(body)
    local gw2c = gw2c_pb.EquipRemake()
    gw2c:ParseFromString(body)
    EquipModel:updateEquipData(gw2c.equip)
    itemModel:setItems(gw2c.item)
    RemakePanel:remakeRefresh()
    Event.RemoveListener("10007", MSGID_EquipRemake)
end

---
---重铸属性替换
---
-- 测试发送PBLUA--
function Message_Manager:SendPB_RemakeExchange(id, viceId, indexId, remakePanel)
    RemakePanel = remakePanel
    Event.AddListener("10008", MSGID_RemakeExchange)
    local c2gw = c2gw_pb:EquipConfirmRemake()
    c2gw.equipId = id
    c2gw.viceId = viceId - 1
    c2gw.indexId = indexId - 1
    local msg1 = c2gw:SerializeToString()
    Message_Manager:createSendPBHeader(10008, msg1)
end

function MSGID_RemakeExchange(body)
    local gw2c = gw2c_pb.EquipConfirmRemake()
    gw2c:ParseFromString(body)
    EquipModel:updateEquipData(gw2c.equip)
    RemakePanel:exchangeRefresh()
    Event.RemoveListener("10008", MSGID_RemakeExchange)
end

---
---卡牌升级
---
function Message_Manager:SendPB_CardUpLevel(id,lv)
    Event.AddListener("10009", MSGID_CardUpLevel)
    print("SendPB_10009")
    local c2gw = c2gw_pb:CardFeed()
    c2gw.cardId	 = id
    c2gw.lvs	 = lv
    local msg = c2gw:SerializeToString()
    Message_Manager:createSendPBHeader(10009, msg)

end

function MSGID_CardUpLevel(body)
    print("MSGID_10009..")
    local gw2c = gw2c_pb.CardFeed()
    gw2c:ParseFromString(body)

    cardModel:setCardInfo(gw2c.card)
    currencyModel:setExpPool(gw2c.currency)
    wnd_cardyc_controller:upLevel_Refresh()
    Event.RemoveListener("10009", MSGID_CardUpLevel)
end

---
---卡牌升星
---
function Message_Manager:SendPB_UpStar(id)
    Event.AddListener("10010", MSGID_UpStar)
    print("SendPB_UpStar..")
    local c2gw = c2gw_pb:CardStarup()
    c2gw.cardId	 = id
    local msg = c2gw:SerializeToString()
    Message_Manager:createSendPBHeader(10010, msg)
end

function MSGID_UpStar(body)
    print("MSGID_UpStar..")
    local gw2c = gw2c_pb.CardStarup()
    gw2c:ParseFromString(body)
    cardModel:setCardInfo(gw2c.card)
    currencyModel:setCoin(gw2c.currency)
    wnd_cardyc_controller:upStar_Refresh()
    print("MSGID_UpStar..2")
    Event.RemoveListener("10010", MSGID_UpStar)
    print("MSGID_UpStar..3")
end

---
---卡牌携带等级
---
function Message_Manager:SendPB_UpSoldier(id)
    Event.AddListener("10011", MSGID_UpSoldier)
    local c2gw = c2gw_pb:CardCarryup()
    c2gw.cardId	 = id
    local msg = c2gw:SerializeToString()
    Message_Manager:createSendPBHeader(10011, msg)
end

function MSGID_UpSoldier(body)
    print("MSGID_10011..")
    local gw2c = gw2c_pb.CardCarryup()
    gw2c:ParseFromString(body)
    cardModel:setCardInfo(gw2c.card)
    currencyModel:setCoin(gw2c.currency)
    wnd_cardyc_controller:upSoldier_Refresh()
    Event.RemoveListener("10011", MSGID_UpSoldier)

end

---
---卡牌军阶
---
function Message_Manager:SendPB_UpQuality(id)
    Event.AddListener("10012", MSGID_UpQuality)
    local c2gw = c2gw_pb:CardRankup()
    c2gw.cardId	 = id
    local msg = c2gw:SerializeToString()
    Message_Manager:createSendPBHeader(10012, msg)
end

function MSGID_UpQuality(body)
    print("MSGID_UpQuality..")
    local gw2c = gw2c_pb.CardRankup()
    gw2c:ParseFromString(body)
    cardModel:setCardInfo(gw2c.card)
    currencyModel:setGold(gw2c.currency)
    wnd_cardyc_controller:upQuality_Refresh()
    Event.RemoveListener("10012", MSGID_UpQuality)

end

---
---卡牌激活军功章槽位
---
function Message_Manager:SendPB_EquipSlot(id,slotId)
    Event.AddListener("10013", MSGID_EquipSlot)

    print("SendPB_10013..")
    local c2gw = c2gw_pb:CardTakeMedal()
    c2gw.cardId	 = id
    c2gw.slotId = slotId
    local msg = c2gw:SerializeToString()
    Message_Manager:createSendPBHeader(10013, msg)
end

function MSGID_EquipSlot(body)
    print("MSGID_EquipSlot..")
    local gw2c = gw2c_pb.CardTakeMedal()
    gw2c:ParseFromString(body)
    cardModel:setCardInfo(gw2c.card)
    itemModel:setItems(gw2c.item)
    wnd_cardyc_controller:equipSlot_Refresh()
    Event.RemoveListener("10013", MSGID_EquipSlot)

end

local slotList
local cardId
function Message_Manager:SendPB_EquipAllSlot(id,List)
    cardId = id
    slotList = List
    Event.AddListener("10013", MSGID_EquipAllSlot)

    print("SendPB_EquipAllSlot..")
    local c2gw = c2gw_pb:CardTakeMedal()
    c2gw.cardId	 = cardId
    c2gw.slotId = slotList[1]
    local msg = c2gw:SerializeToString()
    Message_Manager:createSendPBHeader(10013, msg)

end
function MSGID_EquipAllSlot(body)
    print("MSGID_EquipAllSlot..")
    local gw2c = gw2c_pb.CardTakeMedal()
    gw2c:ParseFromString(body)
    cardModel:setCardInfo(gw2c.card)
    itemModel:setItems(gw2c.item)
    Event.RemoveListener("10013", MSGID_EquipAllSlot)

    if slotList and #slotList > 1 then
        table.remove(slotList, 1)
        Message_Manager:SendPB_EquipAllSlot(cardId, slotList)
        return
    end
    wnd_cardyc_controller:equipSlot_Refresh()
    cardId = nil
    slotList = nil
end


---
---卡牌技能升级
---
function Message_Manager:SendPB_UpSkill(id,skillIndex)
    Event.AddListener("10014", MSGID_UpSkill)

    print("SendPB_UpSkill..")
    local c2gw = c2gw_pb:SkillLevelup()
    c2gw.cardId	 = id
    c2gw.skillId = skillIndex
    local msg = c2gw:SerializeToString()
    Message_Manager:createSendPBHeader(10014, msg)
end

function MSGID_UpSkill(body)
    print("MSGID_UpSkill..")
    local gw2c = gw2c_pb.SkillLevelup()
    gw2c:ParseFromString(body)
    cardModel:setCardInfo(gw2c.card)
    currencyModel:setSkillPt(gw2c.currency)
    wnd_cardyc_controller:upSkill_Refresh()
    Event.RemoveListener("10014", MSGID_UpSkill)
end

---
---卡牌技能点重置
---
function Message_Manager:SendPB_SkillPointReset(id,cost)
    Event.AddListener("10015", MSGID_SkillPointReset)

    local c2gw = c2gw_pb:SkillReset()
    c2gw.cardId	 = id
    c2gw.cost	 = cost
    local msg = c2gw:SerializeToString()
    Message_Manager:createSendPBHeader(10015, msg)
end

function MSGID_SkillPointReset(body)
    print("MSGID_10015..")
    local gw2c = gw2c_pb.SkillReset()
    gw2c:ParseFromString(body)
    cardModel:setCardInfo(gw2c.card)
    currencyModel:setSkillPt(gw2c.currency)
    currencyModel:setDiamond(gw2c.currency)
    wnd_cardyc_controller:SkillPointReset_Refresh()
    Event.RemoveListener("10015", MSGID_SkillPointReset)

end

---
---协同升级
---
function Message_Manager:SendPB_UpSynergy(cardId,synergyId)
    Event.AddListener("10018", MSGID_UpSynergy)

    print("SendPB_UpSynergy..")
    local c2gw = c2gw_pb:CardUnionLvlup()
    c2gw.cardId	= cardId
    c2gw.unionId = synergyId
    local msg = c2gw:SerializeToString()
    Message_Manager:createSendPBHeader(10018, msg)
end

function MSGID_UpSynergy(body)
    print("MSGID_UpSynergy..")
    local gw2c = gw2c_pb.CardUnionLvlup()
    gw2c:ParseFromString(body)
    cardModel:setCardInfo(gw2c.card)
    currencyModel:setCoin(gw2c.currency)
    currencyModel:setGold(gw2c.currency)
    wnd_cardyc_controller:upSynergy_Refresh()
    Event.RemoveListener("10018", MSGID_UpSynergy)

end

--================================================================
--@Des 发送已装备列表
--@params idList:装备唯一id列表
--================================================================
function Message_Manager:SendPB_10021(idList, CallBack)
    local c2gw = c2gw_pb:EquipFit()
    for k,v in ipairs(idList) do
        table.insert(c2gw.lst,v)
    end
    local msg = c2gw:SerializeToString()
    Message_Manager:createSendPBHeader(10021, msg)

    if CallBack then
        Event.AddListener("10021",CallBack)
    end
end

---================================================================
---@        高鑫
---@Des 发送已装备列表
---@params idList:装备唯一id列表
--================================================================
function Message_Manager:SendPB_loadOrNot(idList)
    Event.AddListener("10021", MSGID_loadOrNot)
    local c2gw = c2gw_pb:EquipFit()
    for k,v in ipairs(idList) do
        table.insert(c2gw.lst,v)
    end
    local msg = c2gw:SerializeToString()
    Message_Manager:createSendPBHeader(10021, msg)
end
function MSGID_loadOrNot(body)
    local gw2c = gw2c_pb.EquipFit()
    gw2c:ParseFromString(body)
    EquipModel.serv_fitEquipmentList = gw2c.lst
    for k, v in ipairs(EquipModel.serv_Equipment) do
        v.equipped = EquipUtil:whetherHasBeenEquipped(v.id)
    end
    equip_controller:equipLoadOrNotRefresh()
    Event.RemoveListener("10021", MSGID_loadOrNot)
end

function Message_Manager:SendPB_loadBest(idList)
    Event.AddListener("10021", MSGID_loadBest)
    local c2gw = c2gw_pb:EquipFit()
    for k,v in ipairs(idList) do
        table.insert(c2gw.lst,v)
    end
    local msg = c2gw:SerializeToString()
    Message_Manager:createSendPBHeader(10021, msg)

end
function MSGID_loadBest(body)
    local gw2c = gw2c_pb.EquipFit()
    gw2c:ParseFromString(body)
    EquipModel.serv_fitEquipmentList = gw2c.lst
    for k, v in ipairs(EquipModel.serv_Equipment) do
        v.equipped = EquipUtil:whetherHasBeenEquipped(v.id)
    end
    equip_controller:equipLoadBestRefresh()
    Event.RemoveListener("10021", MSGID_loadBest)
end

--================================================================
--@Des 出售物品
--@params itemList:物品列表{{id,num},...}
--================================================================
function Message_Manager:SendPB_10022(itemList,CallBack)
    local c2gw = c2gw_pb:SellItem()

    for k,v in pairs(itemList) do
        local c2gw_item = c2gw.item:add()
        c2gw_item.id = v.id
        c2gw_item.num = v.num
    end

    local msg = c2gw:SerializeToString()
    Message_Manager:createSendPBHeader(10022, msg)
    if CallBack then
        Event.AddListener("10022",CallBack)
    end
end
--================================================================
--@Des 装备分解
--@params sellType:分解方式(0：金币 1：钻石)
--        equipList:装备唯一id列表{id,...}
--================================================================
function Message_Manager:SendPB_10023(sellType,equipList,CallBack)
    local c2gw = c2gw_pb:SellEquip()

    c2gw.sellType = sellType

    for k,v in pairs(equipList) do
        -- table.insert(c2gw.item,{id = v.id,num = v.num})
        table.insert(c2gw.equip,v)
        print(k.." "..type(v))
    end

    local msg = c2gw:SerializeToString()
    Message_Manager:createSendPBHeader(10023, msg)

    if CallBack then
        Event.AddListener("10023",CallBack)
    end
end
--================================================================
--@Des 碎片合成
--@params itemId:碎片ID
--================================================================
function Message_Manager:SendPB_10024(itemId,CallBack)
    local c2gw = c2gw_pb:ComposeEquip()

    c2gw.itemId = itemId

    local msg = c2gw:SerializeToString()
    Message_Manager:createSendPBHeader(10024, msg)

    if CallBack then
        Event.AddListener("10024",CallBack)
    end
end
--================================================================
--@Des 拉取商店商品列表
--@params shopId:商店ID
--================================================================
function Message_Manager:SendPB_10027(shopId,CallBack)
    local c2gw = c2gw_pb:GetShopDetail()

    c2gw.shopId = shopId

    local msg = c2gw:SerializeToString()
    Message_Manager:createSendPBHeader(10027, msg)

    if CallBack then
        Event.AddListener("10027",CallBack)
    end
end
--================================================================
--@Des 刷新商店商品列表
--@params shopId:商店ID
--================================================================
function Message_Manager:SendPB_10028(shopId,CallBack)
    local c2gw = c2gw_pb:RefreshShop()

    c2gw.shopId = shopId

    local msg = c2gw:SerializeToString()
    Message_Manager:createSendPBHeader(10028, msg)

    if CallBack then
        Event.AddListener("10028",CallBack)
    end
end
--================================================================
--@Des 购买商店商品
--@params shopId  int32   商店ID
--        goodId  int32   商品槽位ID
--        commId  int32   商品ID（GoodItem中的id）
--================================================================
function Message_Manager:SendPB_10029(shopId,goodId,commId,CallBack)
    local c2gw = c2gw_pb:BuyShopGood()

    c2gw.shopId = shopId
    c2gw.goodId = goodId
    c2gw.commId = commId

    print("shopId = "..shopId.." type "..type(shopId))
    print("goodId = "..goodId.." type "..type(goodId))
    print("commId = "..commId.." type "..type(commId))
    print(type(CallBack))

    local msg = c2gw:SerializeToString()
    Message_Manager:createSendPBHeader(10029, msg)

    if CallBack then
        Event.AddListener("10029",CallBack)
    end
end
--================================================================
--@Des 签到界面
--@params 无
--================================================================
function Message_Manager:SendPB_10030(CallBack)
    Message_Manager:createSendPBHeader(10030)
    if CallBack then
        Event.AddListener("10030",CallBack)
    end
end
--================================================================
--@Des 购买卡牌
--@params cardId 卡牌id
--================================================================
function Message_Manager:SendPB_10031(cardId,CallBack)
    local c2gw = c2gw_pb:BuyCard()

    c2gw.cardId = cardId

    local msg = c2gw:SerializeToString()

    Message_Manager:createSendPBHeader(10031,msg)
    if CallBack then
        Event.AddListener("10031",CallBack)
    end
end
--================================================================
--@Des 购买免战时间
--@params id 免战唯一id
--================================================================
function Message_Manager:SendPB_10032(id,CallBack)
    local c2gw = c2gw_pb:BuyAvoidTime()

    c2gw.id = id

    local msg = c2gw:SerializeToString()

    Message_Manager:createSendPBHeader(10032,msg)
    if CallBack then
        Event.AddListener("10032",CallBack)
    end
end
--================================================================
--@Des 设置卡牌大营
--@params 大营卡牌信息列表
--================================================================
function Message_Manager:SendPB_10035(GfItemlst,CallBack)
    local c2gw = c2gw_pb:SetCardGf()
    for i=1,#GfItemlst do
        local GfItem = {}
        GfItem =  c2gw.lst:add()

        GfItem.cardId = GfItemlst[i]["cardId"]
        GfItem.num = GfItemlst[i]["num"]
    end

    local msg = c2gw:SerializeToString()
    Message_Manager:createSendPBHeader(10035,msg)

    if CallBack then
        Event.AddListener("10035",CallBack)
    end
end
--================================================================
--@Des 设置卡牌前锋
--@params 前锋卡牌信息列表
--================================================================
function Message_Manager:SendPB_10036(PfItemlst,CallBack)
    local c2gw = c2gw_pb:SetCardPf()
    for i=1,6 do
            table.insert(c2gw.lst,PfItemlst[i])
    end

    for k=1,#c2gw.lst do

        print(tostring(c2gw.lst[k]))

    end

    local msg = c2gw:SerializeToString()
    Message_Manager:createSendPBHeader(10036,msg)

    if CallBack then
        Event.AddListener("10036",CallBack)
    end
end

local _headerIDCounter = 0

function Message_Manager:createSendPBHeader(msgId, body)
    local header = header_pb.Header()
    header.ID = _headerIDCounter
    header.msgId = msgId
    header.userId = 8003--8001
    header.version = '1.0.0'
    header.errno = 0
    header.ext = 0

    if body then
        header.body = body
    end

    local msg2 = header:SerializeToString()
    local buffer = ByteBuffer()
    buffer:WriteBuffer(msg2)
    networkMgr:SendMessage(buffer)
    -- 2017-08-04 加入记录请求时间
    NetworkDelay_Manager:RecordSendTime(header.ID)
    _headerIDCounter = _headerIDCounter + 1
end

function Message_Manager:createSendPBHeaderByUdp(msgId, body)
    local header = header_pb.Header()
    header.ID = 1
    header.msgId = msgId
    header.userId = 8003--8001
    header.version = '1.0.0'
    header.errno = 0
    header.ext = 0
    if body then
        header.body = body
    end
    local msg2 = header:SerializeToString()
    local buffer = ByteBuffer()
    buffer:WriteBuffer(msg2)
    --networkMgr:SendMessage(buffer)
    networkMgr:SendMessageByUDP(buffer:ToBytes())
end

function Message_Manager:getAllData(gw2c)
    --保存角色信息
    userModel:initUserRoleTbl(gw2c.user)
    --保存货币信息
    currencyModel:initCurrencyTbl(gw2c.user.currency)
    --保存卡牌信息
    cardModel:initCardTbl(gw2c.user.card)
    --保存物品信息
    itemModel:initItemTbl(gw2c.user.item)
    --保存服务器数据到公用装备model
    EquipModel:initModel()
    EquipModel.serv_fitEquipmentList = gw2c.user.fitEquip
    EquipModel.serv_Equipment = EquipUtil:getEquipData(gw2c.user.equip)
    --初始化仓库model
    wnd_cangku_model = require("uiscripts/cangku/wnd_cangku_model")
    wnd_cangku_model:initModel()
    --引用仓库Controller处理服务器Item数据并保存
    wnd_cangku_controller = require("uiscripts/cangku/wnd_cangku_controller")
    wnd_cangku_controller:processServData(gw2c.user.item)
    wnd_cangku_controller:mergeServData()
    wnd_cangku_controller:sortProcessedData()
    --初始化商店model
    wnd_shop_model = require("uiscripts/shop/wnd_shop_model")
    wnd_shop_model:initModel()
    --初始化tips model
    ui_tips_model = require("uiscripts/tips/ui_tips_model")
    ui_tips_model:initModel()
    --初始化PVE model
    -- wnd_pve_model = require("uiscripts/PVE/wnd_PVE_model")
    -- wnd_pve_model.AvoidWarCardTimestamp = gw2c.user.pvp.avoid
    --初始化主界面model
    ui_main_model = require("uiscripts/main/ui_main_model")
    ui_main_model.AvoidWarCardTimestamp = gw2c.user.battle.avoid

    wnd_biandui_model = require("uiscripts/biandui/wnd_biandui_model")
    wnd_biandui_model:SetArmyData(gw2c.user.battle)

end
--================================================================
--30001 进入聊天室（聊天心跳）
--请求包：chat.EnterChat
--token string 密令
--================================================================
function Message_Manager:SendPB_30001(token)

    local chat = chat_pb:EnterChat()
    chat.token = token

    local msg1 = chat:SerializeToString()
    Message_Manager:createSendPBHeaderByUdp(30001,msg1)

    Event.AddListener("30001",MSGID_30001)
end

function MSGID_30001(body)
    --local chat = chat_pb.GetChatRecordResp()
    --chat:ParseFromString(body);

    print("监听到30001")

    Event.RemoveListener("30001", MSGID_30001)
end

--================================================================
--@Des 定时拉聊天记录
--请求包：chat.GetChatRecord
--@params
--type int32 频道类型（0：世界 1：工会）
--time int32 拉取某个时间点之前的若干条记录
--返回包：chat.GetChatRecordResp
--rec ChatRecord repeated聊天记录
--================================================================
local isFirstSend30002 = true --是不是第一次请求30002，第一次的话数据正常插入，但后续要把数据往前插
function Message_Manager:SendPB_30002(type,time)
    local chat = chat_pb:GetChatRecord()
    --print("timed-------------------------------------------------------"..time)
    chat.type = type
    --local timenun = time
    chat.time = time
    --print("数据初始化完成准备传输30002")
    local msg1 = chat:SerializeToString()
    Message_Manager:createSendPBHeaderByUdp(30002,msg1)

    Event.AddListener("30002",MSGID_30002)
    print("发送30002请求等待接受")
end

function MSGID_30002(body)
    local chat = chat_pb.GetChatRecordResp()
    chat:ParseFromString(body);
    --把数据放入chat的model层里面
    local datalist = chat.rec
    --print(datalist[1].userName)
    print("监听到30002-------".."接受到的消息长度为："..#datalist)

    --传输数据前，前端先过滤敏感词确保安全
    for i = 1, #datalist do
        if true then --确保不是系统消息
            datalist[i].content = chatWindow_controller:chaekSensitive(datalist[i].content)
        end
    end


    if isFirstSend30002 then
        chat_model:insertDate(datalist)
        isFirstSend30002 =false
    else
        chat_model:insertDateOnBack(datalist)
        --压入数据到C#
        chatWindow_controller:pushDataToScrollViewFormOldRecrdList()
    end


    Event.RemoveListener("30002", MSGID_30002)
end

--================================================================
--30003 发送世界聊天
--请求包：chat.ChatToWorld
--content String 内容
--================================================================
function Message_Manager:SendPB_30003(content)
    local chat = chat_pb:ChatToWorld()
    chat.content = content
    local msg1 = chat:SerializeToString()
    Message_Manager:createSendPBHeaderByUdp(30003,msg1)

    Event.AddListener("30003",MSGID_30003)
end

function MSGID_30003(body)
    print("监听到30003")
    Event.RemoveListener("30003", MSGID_30003)
end

--================================================================
--35001 世界聊天消息通知
--返回包：chat.ChatToWorldNotify
--rec ChatRecord 聊天记录
--================================================================
function MSGID_35001(body)
    local chat = chat_pb.ChatToWorldNotify()
    chat:ParseFromString(body)
    --
    --print(chat.rec.content)
    print("监听到35001")
    --print(chat.rec.content)
    local rid = chat.rec.rId
    local username = chat.rec.userName
    local content = chat.rec.content
    local time = chat.rec.time
    --print(rid..username..content ..time)
    --传输数据前，前端先过滤敏感词确保安全
        if true then --确保不是系统消息
            content = chatWindow_controller:chaekSensitive(content)
        end
    chat_model:inserDate(rid, username, content, time)
end
--================================================================
--10019 拉取邮件列表
--请求包：
--返回包：gw2c.CardUnionLvlup
--mails Mail repeat 邮件信息
--================================================================
function Message_Manager:SendPB_10019()

    Message_Manager:createSendPBHeader(10019)
    Event.AddListener("10019",MSGID_10019)
end

function Message_Manager:SendPB_10019(HCCallback)
    printw("SendPB_10019")
    Message_Manager:createSendPBHeader(10019)

    local function msgid_10019(body)
        print("监听到10019+HCCallback")
        local gw2c = gw2c_pb.GetMailList()
        gw2c:ParseFromString(body)
        print("邮件列表大小:"..#gw2c.mails)
        mail_model:insertData(gw2c.mails)
        Event.RemoveListener("10019", msgid_10019)

        if HCCallback ~= nil then
            HCCallback(mail_model.new_mailNum)
        end
    end

    Event.AddListener("10019", msgid_10019)
end

function MSGID_10019(body)
    print("监听到10019")
    local gw2c = gw2c_pb.GetMailList()
    gw2c:ParseFromString(body)
    print("邮件列表大小:"..#gw2c.mails)
    mail_model:insertData(gw2c.mails)
    Event.RemoveListener("10019", MSGID_10019)
end


--================================================================
--10025 读取邮件
--请求包：c2gw.ReadMail
--id string 邮件ID
--返回包：gw2c.ReadMail
--mail Mail 邮件信息
--card Card  repeated 卡牌信息
--equip Equip repeated装备信息
--currency Currency 货币信息
--item Item 碎片信息
--================================================================
function Message_Manager:SendPB_10025(mailID)
    local c2gw = c2gw_pb:ReadMail()
    c2gw.id = mailID
    print(c2gw.id)
    local msg1 = c2gw:SerializeToString()
    Message_Manager:createSendPBHeader(10025,msg1)
    Event.AddListener("10025",MSGID_10025)
end

function MSGID_10025(body)
    print("监听到10025")
    print("成功读取邮件")
    Event.RemoveListener("10025", MSGID_10025)
end

--================================================================
--10026 删除邮件
--请求包：c2gw.DelMail
--id string 邮件ID
--返回包：
--================================================================
function Message_Manager:SendPB_10026(mailID)
    local c2gw = c2gw_pb:DelMail()
    c2gw.id = mailID
    local msg1 = c2gw:SerializeToString()
    Message_Manager:createSendPBHeader(10026,msg1)
    Event.AddListener("10026",MSGID_10026)
end

function MSGID_10026(body)
    print("监听到10026")
    print("删除邮件成功")
    Event.RemoveListener("10026", MSGID_10026)
end
--================================================================
--10020 领取邮件奖励
--请求包：c2gw.GetMailReward
--id string 邮件ID
--返回包：gw2c.GetMailReward
--card Card  repeated 卡牌信息
--equip Equip repeated装备信息
--currency Currency 货币信息
--item Item 碎片信息
--================================================================
function Message_Manager:SendPB_10020(mailID)
    local c2gw = c2gw_pb:GetMailReward()
    c2gw.id = mailID
    local msg1 = c2gw:SerializeToString()
    Message_Manager:createSendPBHeader(10020,msg1)
    Event.AddListener("10020",MSGID_10020)
end

function MSGID_10020(body)
    print("监听到10020")
    local gw2c = gw2c_pb.GetMailReward()
    gw2c:ParseFromString(body)



    Event.RemoveListener("10020", MSGID_10020)
end



--==============================--
--desc:在事件管理类里注册消息监听
--time:2017-05-31 09:46:35
--@return 
--==============================--
function Message_Manager:OnAddHandler()
    Event.AddListener("10001", MSGID_10001)
    Event.AddListener("10002", MSGID_10002)
    Event.AddListener("10003", MSGID_10003)
    --Event.AddListener("10004", MSGID_10004)
    Event.AddListener("10005", MSGID_10005)
    --Event.AddListener("10006", MSGID_10006)
    --Event.AddListener("10007", MSGID_10007)
    --Event.AddListener("10008", MSGID_10008)
    --Event.AddListener("10009", MSGID_10009)
    --Event.AddListener("10010", MSGID_10010)
    --Event.AddListener("10011", MSGID_10011)
    --Event.AddListener("10012", MSGID_10012)
    --Event.AddListener("10013", MSGID_10013)
    --Event.AddListener("10014", MSGID_10014)
    --Event.AddListener("10015", MSGID_10015)
    --Event.AddListener("10018", MSGID_10018)
    Event.AddListener("35001",MSGID_35001)
    -- Event.AddListener("errno10001", ERRNO_10001)
end

--==============================--
--desc:必要的时候删除所有事件监听
--time:2017-05-31 09:47:48
--@return 
--==============================--
function Message_Manager:OnRemoveHandler()
    --[[
    Event.RemoveListener("10001", MSGID_10001)
    Event.RemoveListener("10002", MSGID_10002)
    Event.RemoveListener("10003", MSGID_10003)
    Event.RemoveListener("10004", MSGID_10004)
    Event.RemoveListener("10005", MSGID_10005)
    Event.RemoveListener("10006", MSGID_10006)
    Event.RemoveListener("10007", MSGID_10007)
    Event.RemoveListener("10008", MSGID_10008)
    Event.RemoveListener("10009", MSGID_10009)
    Event.RemoveListener("10010", MSGID_10010)
    Event.RemoveListener("10011", MSGID_10011)
    Event.RemoveListener("10012", MSGID_10012)
    Event.RemoveListener("10013", MSGID_10013)
    Event.RemoveListener("10014", MSGID_10014)
    Event.RemoveListener("10015", MSGID_10015)
    --Event.RemoveListener("errno10001", ERRNO_10001)
 --]]
end

return Message_Manager

