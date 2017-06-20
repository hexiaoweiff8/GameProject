local class = require("common/middleclass")
Message_Manager = class("Message_Manager")

require "proto/role_pb"
require "proto/gw2c_pb"
require "proto/c2gw_pb"
require "proto/header_pb"

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
    Message_Manager:getCardData(gw2c)
    for k, v in ipairs(gw2c.user.currency) do
        lgyPrint('gw2c.user.currency.gold==>' .. v.gold);
    end
    for k, v in ipairs(gw2c.user.card) do
        lgyPrint('gw2c.user.equip.id==>' .. v.id);
    end
    for k, v in ipairs(gw2c.user.card) do
        lgyPrint('gw2c.user.card.id==>' .. v.id);
    end
    for k, v in ipairs(gw2c.user.item) do
        lgyPrint('gw2c.user.item.id==>' .. v.id);
    end
    local type
    --装备数据
    for k, v in ipairs(gw2c.user.equip) do
        local tempTB1 = {}
        for k, v in ipairs(v.sndAttr) do
            local tempTB2 = {}
            for k, v in ipairs(v.remake) do
                tempTB2[k] = equipShuXingRemakeM(v.id, v.val)
            end
            
            tempTB1[k] = equipShuXingM(v.id, v.val, v.isRemake, tempTB2)
        end
        type = sdata_equip_data:GetV(sdata_equip_data.I_EquipType, v.eid)
        --TODODO v.rarity + 1
        equipP.allEqList[temp][#equipP.allEqList[temp] + 1] = equipM(v.id, v.eid, v.lv, v.rarity + 1, v.isBad, v.isLock, v.fst_attr, tempTB1)
    end
end


function Message_Manager:SendPB_10003()
    local c2gw = c2gw_pb:RegisterRole()
    c2gw.userName = 'lgy'
    local msg1 = c2gw:SerializeToString()
    Message_Manager:createSendPBHeader(10003, msg1)
end

function MSGID_10003(body)

end

-- 测试发送PBLUA--
function Message_Manager:SendPB_10004(id)
    -- local gw2c = gw2c_pb.EquipLvlup()
    -- gw2c.equip.id = v.EquipUniID
    -- gw2c.equip.eid = v.EquipID
    -- gw2c.equip.lv = v.QiangHuaLevel
    -- gw2c.equip.rarity = v.EquipQuality
    -- gw2c.equip.fst_attr = v.MainEffectID
    -- gw2c.equip.isLock = v.IsLock
    -- gw2c.equip.isBad = v.IsBad
    -- if v.ViceEffect then
    --     for k, v in ipairs(v.ViceEffect) do
    --         local sndAttr = gw2c.equip.sndAttr:add()
    --         sndAttr.id = v.ShuXingID
    --         sndAttr.val = v.ShuXingNum
    --         sndAttr.isRemake = v.IsChongZhu
    --         if v.Remake then
    --             for k, v in ipairs(v.Remake) do
    --                 local remake = sndAttr.remake:add()
    --                 remake.id = v.RemakeShuXingID
    --                 remake.val = v.RemakeShuXingNum
    --             end
    --         end
    --     end
    -- end
    -- local msg1 = gw2c:SerializeToString()
    local c2gw = c2gw_pb:EquipLvlup()
    c2gw.equipId = id
    local msg1 = c2gw:SerializeToString()
    ----------------------------------------------------------------
    -- local gw2c = gw2c_pb.EquipLvlup()
    -- gw2c:ParseFromString(msg1);
    -- --装备数据
    -- local v = gw2c.equip
    -- lgyPrint('gw2c.equip.id==>' .. v.id);
    -- lgyPrint('gw2c.equip.eid==>' .. v.eid);
    -- lgyPrint('gw2c.equip.lv==>' .. v.lv);
    -- lgyPrint('gw2c.equip.rarity==>' .. v.rarity);
    -- lgyPrint('gw2c.equip.fst_attr==>' .. v.fst_attr);
    -- local tempTB1 = {}
    -- for k, v in ipairs(v.sndAttr) do
    --     lgyPrint('gw2c.equip.sndAttr.id==>' .. v.id);
    --     lgyPrint('gw2c.equip.sndAttr.val==>' .. v.val);
    --     lgyPrint('gw2c.equip.sndAttr.isRemake==>' .. v.isRemake);
    --     local tempTB2 = {}
    --     for k, v in ipairs(v.remake) do
    --         lgyPrint('gw2c.equip.sndAttr.remake.id==>' .. v.id);
    --         lgyPrint('gw2c.equip.sndAttr.remake.val==>' .. v.val);
    --         tempTB2[k] = equipShuXingRemakeM(v.id, v.val)
    --     end
    --     tempTB1[k] = equipShuXingM(v.id, v.val, v.isRemake, tempTB2)
    -- end
    -- lgyPrint('gw2c.equip.isLock==>' .. v.isLock);
    -- lgyPrint('gw2c.equip.isBad==>' .. v.isBad);
    ----------------------------------------------------------------
    Message_Manager:createSendPBHeader(10004, msg1)
end


function MSGID_10004(body)
    local gw2c = gw2c_pb.EquipLvlup()
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

-- 测试发送PBLUA--
function Message_Manager:SendPB_10005(id, isLock)
    lgyPrint('isLock==>' .. isLock);
    local c2gw = c2gw_pb:EquipLock()
    c2gw.equipId = id
    c2gw.isLock = isLock
    local msg1 = c2gw:SerializeToString()
    Message_Manager:createSendPBHeader(10005, msg1)
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

-- 测试发送PBLUA--
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

-- 测试发送PBLUA--
function Message_Manager:SendPB_10007(id, viceId)
    local c2gw = c2gw_pb:EquipRemake()
    c2gw.equipId = id
    c2gw.viceId = viceId
    local msg1 = c2gw:SerializeToString()
    Message_Manager:createSendPBHeader(10007, msg1)
end
function MSGID_10007(body)
    lgyPrint('MSGID_10007');
    local gw2c = gw2c_pb.EquipRemake()
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

-- 测试发送PBLUA--
function Message_Manager:SendPB_10008(id, viceId, indexId)
    local c2gw = c2gw_pb:EquipConfirmRemake()
    c2gw.equipId = id
    c2gw.viceId = viceId
    c2gw.indexId = indexId
    local msg1 = c2gw:SerializeToString()
    Message_Manager:createSendPBHeader(10008, msg1)
end

function MSGID_10008(body)
    local gw2c = gw2c_pb.EquipConfirmRemake()
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

--卡牌升经验
function Message_Manager:SendPB_10009(id,lv)
	print("SendPB_10009")
	local c2gw = c2gw_pb:CardFeed()
    c2gw.cardId	 = id
    c2gw.lvs	 = lv
    local msg = c2gw:SerializeToString()
    Message_Manager:createSendPBHeader(10009, msg)
end





function MSGID_10009(body)
	print("MSGID_10009..")
	local gw2c = gw2c_pb.CardFeed()
    gw2c:ParseFromString(body)
    print(string.len(body))
    Message_Manager:changeCardData(gw2c, 10009)
end

--卡牌升星
function Message_Manager:SendPB_10010(id)
	local c2gw = c2gw_pb:CardStarup()
    c2gw.cardId	 = id
    local msg = c2gw:SerializeToString()
    Message_Manager:createSendPBHeader(10010, msg)
end

function MSGID_10010(body)
	print("MSGID_10010..")
	local gw2c = gw2c_pb.CardStarup()
    gw2c:ParseFromString(body)
    Message_Manager:changeCardData(gw2c,10010)
end

--卡牌携带等级
function Message_Manager:SendPB_10011(id)
	local c2gw = c2gw_pb:CardCarryup()
    c2gw.cardId	 = id
    local msg = c2gw:SerializeToString()
    Message_Manager:createSendPBHeader(10011, msg)
end

function MSGID_10011(body)
	print("MSGID_10011..")
	local gw2c = gw2c_pb.CardCarryup()
    gw2c:ParseFromString(body)
    Message_Manager:changeCardData(gw2c, 10011)
end

--卡牌军阶
function Message_Manager:SendPB_10012(id)
	local c2gw = c2gw_pb:CardRankup()
    c2gw.cardId	 = id
    local msg = c2gw:SerializeToString()
    Message_Manager:createSendPBHeader(10012, msg)
end

function MSGID_10012(body)
	print("MSGID_10012..")
	local gw2c = gw2c_pb.CardRankup()
    gw2c:ParseFromString(body)
   	Message_Manager:changeCardData(gw2c, 10012)
end

--卡牌激活军功章槽位
function Message_Manager:SendPB_10013(id,slotId)
	print("SendPB_10013..")
	local c2gw = c2gw_pb:CardTakeMedal()
    c2gw.cardId	 = id
    c2gw.slotId = slotId	
    local msg = c2gw:SerializeToString()
    Message_Manager:createSendPBHeader(10013, msg)
end

function MSGID_10013(body)
	print("MSGID_10013..")
	local gw2c = gw2c_pb.CardTakeMedal()
    gw2c:ParseFromString(body)
    Message_Manager:changeCardData(gw2c, 10013)
end

--卡牌技能升级
function Message_Manager:SendPB_10014(id,skillIndex)
    print("SendPB_10014..upSkill")
	local c2gw = c2gw_pb:SkillLevelup()
    c2gw.cardId	 = id
    c2gw.skillId = skillIndex
    local msg = c2gw:SerializeToString()
    Message_Manager:createSendPBHeader(10014, msg)
end

function MSGID_10014(body)
	print("MSGID_10014..upSkill")
	local gw2c = gw2c_pb.SkillLevelup()
    gw2c:ParseFromString(body)
    Message_Manager:changeCardData(gw2c, 10014)
end

--卡牌技能点重置
function Message_Manager:SendPB_10015(id,cost)
	local c2gw = c2gw_pb:SkillReset()
    c2gw.cardId	 = id
    c2gw.cost	 = cost
    local msg = c2gw:SerializeToString()
    Message_Manager:createSendPBHeader(10015, msg)
end

function MSGID_10015(body)
	print("MSGID_10015..")
	local gw2c = gw2c_pb.SkillReset()
    gw2c:ParseFromString(body)
	Message_Manager:changeCardData(gw2c, 10015)
end



function Message_Manager:SendPB_10018(cardId,synergyId)
    print("SendPB_10018..")
    local c2gw = c2gw_pb:CardUnionLvlup()
    c2gw.cardId	= cardId
    c2gw.unionId = synergyId
    local msg = c2gw:SerializeToString()
    Message_Manager:createSendPBHeader(10018, msg)
end

function MSGID_10018(body)
	print("MSGID_10018..")
	local gw2c = gw2c_pb.CardUnionLvlup()
    gw2c:ParseFromString(body)
	Message_Manager:changeCardData(gw2c, 10018)
end



function Message_Manager:createSendPBHeader(msgId, body)
    print("asdasd:::"..msgId)
    local header = header_pb.Header()
    header.ID = 1
    header.msgId = msgId
    header.userId = 8002--8001
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
end


function Message_Manager:getCardData(gw2c)
	print("=================getCardData=============")
	local user = gw2c.user
    print( string.format("User==> uid:%d, hostid:%d, rid:%d, username:%s, exp:%d, vipexp:%d, itemTblNum:%d",user.uId, user.hostId, user.rId, user.userName, user.exp, user.vipexp, #user.item) )
    --UserRole:initialize(uid,hostId,rId,userName,exp,vipexp)
    userRoleTbl = UserRole(user.uId, user.hostId, user.rId, user.userName, user.exp, user.vipexp, user.lv, user.vip, user.item)


    --lgyPrint("tbl:".. #gw2c.user.currency )
    local currency = gw2c.user.currency
    --金币 -钻石 -技能点 -经验池 -兵牌 -体力
    local diamondNum = 0  --currency.diamond (花钱充，花钱赠，免费送的和)
    for i,v in ipairs(currency.diamond) do
    	diamondNum = diamondNum+v
    end
    print( string.format("currency==> gold:%d, diamond:%d, skillPt:%d, expPool:%d, coin:%d, tili:%d",currency.gold, diamondNum, currency.skillPt, currency.expPool, currency.coin, currency.tili) )
    --currencyTbl[#currencyTbl+1]
    currencyTbl = Currency(currency.gold, diamondNum, currency.skillPt, currency.expPool, currency.coin, currency.tili)

    print("cardTbl:" .. #gw2c.user.card)
    for k, v in ipairs(gw2c.user.card) do
        --卡牌ID -经验 -星级 -兵员等级 -军阶等级 -数量
    	print( string.format("card==> id:%d, exp:%d, star:%d, slv:%d, rlv:%d, num:%d",v.id, v.exp, v.star, v.slv, v.rlv, v.num,v.lv) )
        print( string.format("teamNum:%d, skillNum:%d, slotNum:%d", #v.team, #v.skill,  #v.slot) )
        print(v.skill[1])
		cardTbl[k] = Card(v.id, v.exp, v.star, v.slv, v.rlv, v.num, v.slot, v.skill, v.team,v.lv)
    end
end



--==============================--
--desc:根据服务器返回的信息刷新对应数据
--time:2017-05-31 09:21:12
--@gw2c:
--@msgId:
--@return 
--==============================--
function Message_Manager:changeCardData(gw2c, msgId)
	print("changeCardData================msgId:"..msgId)
	if msgId == 10009 then--升级
        for k, v in ipairs(cardTbl) do
            if v.id == gw2c.card.id then 
                v.exp = gw2c.card.exp
                v.lv  = gw2c.card.lv
            end
        end
        currencyTbl["expPool"] = gw2c.currency.expPool
        upLevel_controller:upLevel_refresh()
        
    elseif msgId == 10010 then--升星
        for k, v in ipairs(cardTbl) do
            if v.id == gw2c.card.id then
                v.star = gw2c.card.star
                v.num = gw2c.card.num
                v.skill = gw2c.card.skill
            end
        end
        currencyTbl["coin"] = gw2c.currency.coin
        upStar_controller:upStar_refresh()

    elseif msgId == 10011 then	--兵员升级
        for k, v in ipairs(cardTbl) do
            if v.id == gw2c.card.id then
                v.slv = gw2c.card.slv
            end
        end
        currencyTbl["coin"] = gw2c.currency.coin
        upSoldier_controller:upSoldier_refresh()

	elseif msgId == 10012 then--进阶
        for k,v in pairs(cardTbl) do
            if v.id == gw2c.card.id then
                v.rlv = gw2c.card.rlv
                v.slot = gw2c.card.slot
            end
        end
        currencyTbl["gold"] = gw2c.currency.gold
        information_controller:upQuality_refresh()

    elseif msgId == 10013 then--装备
        for k,v in pairs(cardTbl) do
            if v.id == gw2c.card.id then
                v.slot = gw2c.card.slot
            end
        end
        for i = 1,#gw2c.item do
            for k,v in ipairs(userRoleTbl["item"]) do 
                if v.id == gw2c.item[i].id then 
                    v.num = gw2c.item[i].num
                end
            end
        end
        
        information_controller:epuip_refresh()

    elseif msgId == 10014 then
        for k,v in pairs(cardTbl) do
            --根据当前卡片的ID获取卡牌信息,后期要改
            if v.id == gw2c.card.id then
                v.skill = gw2c.card.skill
            end
        end
        currencyTbl["skillpt"] = gw2c.currency.skillPt
        upSkill_controller:upSkill_refresh()
        
    elseif msgId == 10015 then--技能重置
         for k,v in pairs(cardTbl) do
            --根据当前卡片的ID获取卡牌信息,后期要改
            if v.id == gw2c.card.id then
                v.skill = gw2c.card.skill
            end
        end
	    currencyTbl["skillpt"] = gw2c.currency.skillPt
	    currencyTbl["diamond"] = gw2c.currency.diamond
        upSkill_controller:skillReset_refresh()

    elseif msgId == 10018 then--协同升级和激活
        for k,v in pairs(cardTbl) do
            --根据当前卡片的ID获取卡牌信息,后期要改
            if v.id == gw2c.card.id then
                v.team = gw2c.card.team
            end
        end

	    currencyTbl["coin"] = gw2c.currency.coin
        currencyTbl["gold"] = gw2c.currency.gold
        upSynergy_controller:upSynergy_refresh()
    end
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
    Event.AddListener("10004", MSGID_10004)
    Event.AddListener("10005", MSGID_10005)
    Event.AddListener("10006", MSGID_10006)
    Event.AddListener("10007", MSGID_10007)
    Event.AddListener("10008", MSGID_10008)
    Event.AddListener("10009", MSGID_10009)
    Event.AddListener("10010", MSGID_10010)
    Event.AddListener("10011", MSGID_10011)
    Event.AddListener("10012", MSGID_10012)
    Event.AddListener("10013", MSGID_10013)
    Event.AddListener("10014", MSGID_10014)
    Event.AddListener("10015", MSGID_10015)
    Event.AddListener("10018", MSGID_10018)
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

