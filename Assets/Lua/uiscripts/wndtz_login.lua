--region *.lua
--Date 20150804
--登陆界面
--作者 wenchuan
local class = require("common/middleclass")
local class_wnd_login = class("class_wnd_login", wnd_base)

function class_wnd_login:OnShowDone()
    local btn_go = self.transform:Find("mainpanel/btn_go").gameObject
    -- SendPB_10001()
    UIEventListener.Get(btn_go).onPress = function(btn_go, args)
        if args then
            -- ui_manager:ShowWB(WNDTYPE.ui_equip)
            ui_manager:ShowWB(WNDTYPE.Prefight)
        -- ui_manager:ShowWB(WNDTYPE.ui_kejitree)
        --TODODO
        --
        -- SendPB_10004(equipP.allEqList[1][1].EquipUniID)
        -- SendPB_10005(equipP.allEqList[1][1].EquipUniID, 1 - equipP.allEqList[1][1].IsLock)
        -- SendPB_10006(equipP.allEqList[1][1].EquipUniID)
        -- SendPB_10007(equipP.allEqList[1][1].EquipUniID, 5)
        -- SendPB_10008(equipP.allEqList[1][1].EquipUniID, 5, 3)
				
			-- --jyp cardyc测试
	        -- SendPB_10001()
            -- ui_manager:ShowWB(WNDTYPE.Cardyc)
        end
    end
end

require "proto/role_pb"
require "proto/gwc_pb"
require "proto/cgw_pb"
require "proto/header_pb"
-- 测试发送PBLUA--
function SendPB_10001()
    local cgw = cgw_pb.LoginGame()
    cgw.token = 'token'
    local msg1 = cgw:SerializeToString()
    createSendPBHeader(10001, msg1)
end
function MSGID_10001(body)
    SendPB_10002()
end



function SendPB_10002()
    createSendPBHeader(10002)
end


function MSGID_10002(body)
    local gwc = gwc_pb.SelectRole()
    gwc:ParseFromString(body);
    getCardData(gwc)
    print("item:".. #gwc.user.item)
    lgyPrint('uId==>' .. gwc.user.uId);
    lgyPrint('hostId==>' .. gwc.user.hostId);
    lgyPrint('rId==>' .. gwc.user.rId);
    lgyPrint('userName==>' .. gwc.user.userName);
    lgyPrint('exp==>' .. gwc.user.exp);
    lgyPrint('vipexp==>' .. gwc.user.vipexp);
    for k, v in ipairs(gwc.user.currency) do
        lgyPrint('gwc.user.currency.gold==>' .. v.gold);
    end
    for k, v in ipairs(gwc.user.card) do
        lgyPrint('gwc.user.equip.id==>' .. v.id);
    end
    lgyPrint('uId==>' .. gwc.user.uId);
    lgyPrint('hostId==>' .. gwc.user.hostId);
    lgyPrint('rId==>' .. gwc.user.rId);
    lgyPrint('userName==>' .. gwc.user.userName);
    lgyPrint('exp==>' .. gwc.user.exp);
    lgyPrint('vipexp==>' .. gwc.user.vipexp);
    lgyPrint('gwc.user.currency.gold==>' .. gwc.user.currency.gold);
    for k, v in ipairs(gwc.user.card) do
        lgyPrint('gwc.user.card.id==>' .. v.id);
    end
    for k, v in ipairs(gwc.user.item) do
        lgyPrint('gwc.user.item.id==>' .. v.id);
    end
    local type
    --装备数据
    for k, v in ipairs(gwc.user.equip) do
        lgyPrint('gwc.user.equip.id==>' .. v.id);
        lgyPrint('gwc.user.equip.eid==>' .. v.eid);
        lgyPrint('gwc.user.equip.lv==>' .. v.lv);
        lgyPrint('gwc.user.equip.rarity==>' .. v.rarity);
        lgyPrint('gwc.user.equip.fst_attr==>' .. v.fst_attr);
        
        local tempTB1 = {}
        for k, v in ipairs(v.sndAttr) do
            lgyPrint('gwc.user.equip.sndAttr.id==>' .. v.id);
            lgyPrint('gwc.user.equip.sndAttr.val==>' .. v.val);
            lgyPrint('gwc.user.equip.sndAttr.isRemake==>' .. v.isRemake);
            
            local tempTB2 = {}
            for k, v in ipairs(v.remake) do
                lgyPrint('gwc.user.equip.sndAttr.remake.id==>' .. v.id);
                lgyPrint('gwc.user.equip.sndAttr.remake.val==>' .. v.val);
                tempTB2[k] = equipShuXingRemakeM(v.id, v.val)
            end
            
            tempTB1[k] = equipShuXingM(v.id, v.val, v.isRemake, tempTB2)
        end
        lgyPrint('gwc.user.equip.isLock==>' .. v.isLock);
        lgyPrint('gwc.user.equip.isBad==>' .. v.isBad);
        
        type = sdata_Equip_data:GetV(sdata_Equip_data.I_EquipType, v.eid)
        --TODODO v.rarity + 1
        equipP.allEqList[temp][#equipP.allEqList[temp] + 1] = equipM(v.id, v.eid, v.lv, v.rarity + 1, v.isBad, v.isLock, v.fst_attr, tempTB1)
    end
end

function getCardData(gwc)
	print("=================getCardData=============")
	local user = gwc.user
    print( string.format("User==> uid:%d, hostid:%d, rid:%d, username:%s, exp:%d, vipexp:%d, itemTblNum:%d",user.uId, user.hostId, user.rId, user.userName, user.exp, user.vipexp, #user.item) )
    --UserRole:initialize(uid,hostId,rId,userName,exp,vipexp)
    userRoleTbl = UserRole(user.uId, user.hostId, user.rId, user.userName, user.exp, user.vipexp, user.item)


    --lgyPrint("tbl:".. #gwc.user.currency )
    local currency = gwc.user.currency
    --金币 -钻石 -技能点 -经验池 -兵牌 -体力
    local diamondNum = 0  --currency.diamond (花钱充，花钱赠，免费送的和)
    for i,v in ipairs(currency.diamond) do
    	diamondNum = diamondNum+v
    end
    print( string.format("currency==> gold:%d, diamond:%d, skillPt:%d, expPool:%d, coin:%d, tili:%d",currency.gold, diamondNum, currency.skillPt, currency.expPool, currency.coin, currency.tili) )
    --currencyTbl[#currencyTbl+1]
    currencyTbl = Currency(currency.gold, diamondNum, currency.skillPt, currency.expPool, currency.coin, currency.tili)

    print("cardTbl:" .. #gwc.user.card)
    for k, v in ipairs(gwc.user.card) do
        --卡牌ID -经验 -星级 -兵员等级 -军阶等级 -数量
    	print( string.format("card==> id:%d, exp:%d, star:%d, slv:%d, rlv:%d, num:%d",v.id, v.exp, v.star, v.slv, v.rlv, v.num) )
        print( string.format("teamNum:%d, skillNum:%d, slotNum:%d", #v.team, #v.skill,  #v.slot) )
		--for k, v in ipairs(v.slot) do --slot
	        --print(k,v)
	    --end	
	    for k, v in ipairs(v.team) do--xt
	        lgyPrint('gwc.user.team.id==>' .. v.id);
	        lgyPrint('gwc.user.team.lv==>' .. v.lv);
	    end

	    for k, v in ipairs(v.skill) do--skill
	        lgyPrint('gwc.user.skill.id==>' .. v.id);
	        lgyPrint('gwc.user.skill.lv==>' .. v.lv);
	    end
		cardTbl[k] = Card(v.id, v.exp, v.star, v.slv, v.rlv, v.num, v.slot, v.skill, v.team)
		--print("id:" .. cardTbl[k]["id"])
    end
end

function changeCardData(gwc, msgId)
	print("changeCardData================msgId:"..msgId)
	if msgId == 10009 then
		print("10009....")
		--currencyTbl["expPool"] = gwc.user.currency.expPool 
		--print("exp:" .. currencyTbl["expPool"])--
		print("exp:" .. gwc.card.exp)
	    cardTbl[k]["exp"] = gwc.card.exp
	    lgyPrint('10009:card.exp==>' .. gwc.card.exp)--卡牌等级
	elseif msgId == 10010 then
    	lgyPrint('10010:card.id==>' .. gwc.card.id)--卡牌ID
    	lgyPrint('10010:card.star==>' .. gwc.card.slv)--星级
    	cardTbl[k]["star"] = gwc.card.star
    elseif msgId == 10011 then	
    	lgyPrint('10011:card.id==>' .. gwc.card.id)--卡牌ID
    	lgyPrint('10011:card.slv==>' .. gwc.card.slv)--兵员等级
    	cardTbl[k]["slv"] = gwc.card.slv
	elseif msgId == 10012 then
		--金币
		--currencyTbl["gold"] = gwc.user.currency.gold --服务器只返回了卡信息,货币信息变化没返回
		--军阶
    	cardTbl[k]["rlv"] =gwc.card.rlv
    elseif msgId == 10013 then
    	userRoleTbl["item"] = gwc.user.item
    	cardTbl[k]["slot"] = gwc.card.slot
    	--for k, v in ipairs(gwc.user.card) do
			--cardTbl[k]["slot"] = v.slot
			--for k, v in ipairs(cardTbl[k]["slot"]) do--xt
		        --print(k,v)
		   -- end	
    	--end
    elseif msgId == 10014 then
    	--for k,v in pairs(gwc.card.skill) do
		   -- lgyPrint('MSGID_10014.skill.id==>' .. v.id);
		   -- lgyPrint('MSGID_10014.skill.lv==>' .. v.lv);
    	--end
    	cardTbl[k]["skill"] = gwc.card.skill
    elseif msgId == 10015 then
    	lgyPrint('MSGID_10015.skill.id==>' .. gwc.user.currency.skillPt);
	    Currency["skillpt"] = gwc.user.currency.skillPt
    end
end


function SendPB_10003()
    local cgw = cgw_pb.RegisterRole()
    cgw.userName = 'lgy'
    local msg1 = cgw:SerializeToString()
    createSendPBHeader(10003, msg1)
end

function MSGID_10003(body)
end

-- 测试发送PBLUA--
function SendPB_10004(id)
    -- local gwc = gwc_pb.EquipLvlup()
    -- gwc.equip.id = v.EquipUniID
    -- gwc.equip.eid = v.EquipID
    -- gwc.equip.lv = v.QiangHuaLevel
    -- gwc.equip.rarity = v.EquipQuality
    -- gwc.equip.fst_attr = v.MainEffectID
    -- gwc.equip.isLock = v.IsLock
    -- gwc.equip.isBad = v.IsBad
    -- if v.ViceEffect then
    --     for k, v in ipairs(v.ViceEffect) do
    --         local sndAttr = gwc.equip.sndAttr:add()
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
    -- local msg1 = gwc:SerializeToString()
    local cgw = cgw_pb.EquipLvlup()
    cgw.equipId = id
    local msg1 = cgw:SerializeToString()
    ----------------------------------------------------------------
    -- local gwc = gwc_pb.EquipLvlup()
    -- gwc:ParseFromString(msg1);
    -- --装备数据
    -- local v = gwc.equip
    -- lgyPrint('gwc.equip.id==>' .. v.id);
    -- lgyPrint('gwc.equip.eid==>' .. v.eid);
    -- lgyPrint('gwc.equip.lv==>' .. v.lv);
    -- lgyPrint('gwc.equip.rarity==>' .. v.rarity);
    -- lgyPrint('gwc.equip.fst_attr==>' .. v.fst_attr);
    -- local tempTB1 = {}
    -- for k, v in ipairs(v.sndAttr) do
    --     lgyPrint('gwc.equip.sndAttr.id==>' .. v.id);
    --     lgyPrint('gwc.equip.sndAttr.val==>' .. v.val);
    --     lgyPrint('gwc.equip.sndAttr.isRemake==>' .. v.isRemake);
    --     local tempTB2 = {}
    --     for k, v in ipairs(v.remake) do
    --         lgyPrint('gwc.equip.sndAttr.remake.id==>' .. v.id);
    --         lgyPrint('gwc.equip.sndAttr.remake.val==>' .. v.val);
    --         tempTB2[k] = equipShuXingRemakeM(v.id, v.val)
    --     end
    --     tempTB1[k] = equipShuXingM(v.id, v.val, v.isRemake, tempTB2)
    -- end
    -- lgyPrint('gwc.equip.isLock==>' .. v.isLock);
    -- lgyPrint('gwc.equip.isBad==>' .. v.isBad);
    ----------------------------------------------------------------
    createSendPBHeader(10004, msg1)
end

function MSGID_10004(body)
    local gwc = gwc_pb.EquipLvlup()
    gwc:ParseFromString(body);
    --装备数据
    local v = gwc.equip
    lgyPrint('gwc.equip.id==>' .. v.id);
    lgyPrint('gwc.equip.eid==>' .. v.eid);
    lgyPrint('gwc.equip.lv==>' .. v.lv);
    lgyPrint('gwc.equip.rarity==>' .. v.rarity);
    lgyPrint('gwc.equip.fst_attr==>' .. v.fst_attr);
    local tempTB1 = {}
    for k, v in ipairs(v.sndAttr) do
        lgyPrint('gwc.equip.sndAttr.id==>' .. v.id);
        lgyPrint('gwc.equip.sndAttr.val==>' .. v.val);
        lgyPrint('gwc.equip.sndAttr.isRemake==>' .. v.isRemake);
        local tempTB2 = {}
        for k, v in ipairs(v.remake) do
            lgyPrint('gwc.equip.sndAttr.remake.id==>' .. v.id);
            lgyPrint('gwc.equip.sndAttr.remake.val==>' .. v.val);
            tempTB2[k] = equipShuXingRemakeM(v.id, v.val)
        end
        tempTB1[k] = equipShuXingM(v.id, v.val, v.isRemake, tempTB2)
    end
    lgyPrint('gwc.equip.isLock==>' .. v.isLock);
    lgyPrint('gwc.equip.isBad==>' .. v.isBad);
    
    local value = equipM(v.id, v.eid, v.lv, v.rarity + 1, v.isBad, v.isLock, v.fst_attr, tempTB1)
    local index, index2 = equipP.getIndexByID(v.id)
    if index2 then
        equipP.change_allEqList(index, index2, value)
    else
        equipP.change_nowEqList(index, value)
    end
end

-- 测试发送PBLUA--
function SendPB_10005(id, isLock)
    lgyPrint('isLock==>' .. isLock);
    local cgw = cgw_pb.EquipLock()
    cgw.equipId = id
    cgw.isLock = isLock
    local msg1 = cgw:SerializeToString()
    createSendPBHeader(10005, msg1)
end

function MSGID_10005(body)
    local gwc = gwc_pb.EquipLock()
    gwc:ParseFromString(body);
    --装备数据
    local v = gwc.equip
    lgyPrint('gwc.equip.id==>' .. v.id);
    lgyPrint('gwc.equip.eid==>' .. v.eid);
    lgyPrint('gwc.equip.lv==>' .. v.lv);
    lgyPrint('gwc.equip.rarity==>' .. v.rarity);
    lgyPrint('gwc.equip.fst_attr==>' .. v.fst_attr);
    local tempTB1 = {}
    for k, v in ipairs(v.sndAttr) do
        lgyPrint('gwc.equip.sndAttr.id==>' .. v.id);
        lgyPrint('gwc.equip.sndAttr.val==>' .. v.val);
        lgyPrint('gwc.equip.sndAttr.isRemake==>' .. v.isRemake);
        local tempTB2 = {}
        for k, v in ipairs(v.remake) do
            lgyPrint('gwc.equip.sndAttr.remake.id==>' .. v.id);
            lgyPrint('gwc.equip.sndAttr.remake.val==>' .. v.val);
            tempTB2[k] = equipShuXingRemakeM(v.id, v.val)
        end
        tempTB1[k] = equipShuXingM(v.id, v.val, v.isRemake, tempTB2)
    end
    lgyPrint('gwc.equip.isLock==>' .. v.isLock);
    lgyPrint('gwc.equip.isBad==>' .. v.isBad);
    
    local value = equipM(v.id, v.eid, v.lv, v.rarity + 1, v.isBad, v.isLock, v.fst_attr, tempTB1)
    local index, index2 = equipP.getIndexByID(v.id)
    if index2 then
        equipP.change_allEqList(index, index2, value)
    else
        equipP.change_nowEqList(index, value)
    end
end

-- 测试发送PBLUA--
function SendPB_10006(id)
    local cgw = cgw_pb.EquipRepair()
    cgw.equipId = id
    local msg1 = cgw:SerializeToString()
    createSendPBHeader(10006, msg1)
end
function MSGID_10006(body)
    local gwc = gwc_pb.EquipRepair()
    gwc:ParseFromString(body);
    --装备数据
    local v = gwc.equip
    lgyPrint('gwc.equip.id==>' .. v.id);
    lgyPrint('gwc.equip.eid==>' .. v.eid);
    lgyPrint('gwc.equip.lv==>' .. v.lv);
    lgyPrint('gwc.equip.rarity==>' .. v.rarity);
    lgyPrint('gwc.equip.fst_attr==>' .. v.fst_attr);
    local tempTB1 = {}
    for k, v in ipairs(v.sndAttr) do
        lgyPrint('gwc.equip.sndAttr.id==>' .. v.id);
        lgyPrint('gwc.equip.sndAttr.val==>' .. v.val);
        lgyPrint('gwc.equip.sndAttr.isRemake==>' .. v.isRemake);
        local tempTB2 = {}
        for k, v in ipairs(v.remake) do
            lgyPrint('gwc.equip.sndAttr.remake.id==>' .. v.id);
            lgyPrint('gwc.equip.sndAttr.remake.val==>' .. v.val);
            tempTB2[k] = equipShuXingRemakeM(v.id, v.val)
        end
        tempTB1[k] = equipShuXingM(v.id, v.val, v.isRemake, tempTB2)
    end
    lgyPrint('gwc.equip.isLock==>' .. v.isLock);
    lgyPrint('gwc.equip.isBad==>' .. v.isBad);
    
    local value = equipM(v.id, v.eid, v.lv, v.rarity + 1, v.isBad, v.isLock, v.fst_attr, tempTB1)
    local index, index2 = equipP.getIndexByID(v.id)
    if index2 then
        equipP.change_allEqList(index, index2, value)
    else
        equipP.change_nowEqList(index, value)
    end
end

-- 测试发送PBLUA--
function SendPB_10007(id, viceId)
    local cgw = cgw_pb.EquipRemake()
    cgw.equipId = id
    cgw.viceId = viceId
    local msg1 = cgw:SerializeToString()
    createSendPBHeader(10007, msg1)
end
function MSGID_10007(body)
    lgyPrint('MSGID_10007');
    local gwc = gwc_pb.EquipRemake()
    gwc:ParseFromString(body);
    --装备数据
    local v = gwc.equip
    lgyPrint('gwc.equip.id==>' .. v.id);
    lgyPrint('gwc.equip.eid==>' .. v.eid);
    lgyPrint('gwc.equip.lv==>' .. v.lv);
    lgyPrint('gwc.equip.rarity==>' .. v.rarity);
    lgyPrint('gwc.equip.fst_attr==>' .. v.fst_attr);
    local tempTB1 = {}
    for k, v in ipairs(v.sndAttr) do
        lgyPrint('gwc.equip.sndAttr.id==>' .. v.id);
        lgyPrint('gwc.equip.sndAttr.val==>' .. v.val);
        lgyPrint('gwc.equip.sndAttr.isRemake==>' .. v.isRemake);
        local tempTB2 = {}
        for k, v in ipairs(v.remake) do
            lgyPrint('gwc.equip.sndAttr.remake.id==>' .. v.id);
            lgyPrint('gwc.equip.sndAttr.remake.val==>' .. v.val);
            tempTB2[k] = equipShuXingRemakeM(v.id, v.val)
        end
        tempTB1[k] = equipShuXingM(v.id, v.val, v.isRemake, tempTB2)
    end
    lgyPrint('gwc.equip.isLock==>' .. v.isLock);
    lgyPrint('gwc.equip.isBad==>' .. v.isBad);
    
    local value = equipM(v.id, v.eid, v.lv, v.rarity + 1, v.isBad, v.isLock, v.fst_attr, tempTB1)
    local index, index2 = equipP.getIndexByID(v.id)
    if index2 then
        equipP.change_allEqList(index, index2, value)
    else
        equipP.change_nowEqList(index, value)
    end
end

-- 测试发送PBLUA--
function SendPB_10008(id, viceId, indexId)
    local cgw = cgw_pb.EquipConfirmRemake()
    cgw.equipId = id
    cgw.viceId = viceId
    cgw.indexId = indexId
    local msg1 = cgw:SerializeToString()
    createSendPBHeader(10008, msg1)
end

function MSGID_10008(body)
    local gwc = gwc_pb.EquipConfirmRemake()
    gwc:ParseFromString(body);
    --装备数据
    local v = gwc.equip
    lgyPrint('gwc.equip.id==>' .. v.id);
    lgyPrint('gwc.equip.eid==>' .. v.eid);
    lgyPrint('gwc.equip.lv==>' .. v.lv);
    lgyPrint('gwc.equip.rarity==>' .. v.rarity);
    lgyPrint('gwc.equip.fst_attr==>' .. v.fst_attr);
    local tempTB1 = {}
    for k, v in ipairs(v.sndAttr) do
        lgyPrint('gwc.equip.sndAttr.id==>' .. v.id);
        lgyPrint('gwc.equip.sndAttr.val==>' .. v.val);
        lgyPrint('gwc.equip.sndAttr.isRemake==>' .. v.isRemake);
        local tempTB2 = {}
        for k, v in ipairs(v.remake) do
            lgyPrint('gwc.equip.sndAttr.remake.id==>' .. v.id);
            lgyPrint('gwc.equip.sndAttr.remake.val==>' .. v.val);
            tempTB2[k] = equipShuXingRemakeM(v.id, v.val)
        end
        tempTB1[k] = equipShuXingM(v.id, v.val, v.isRemake, tempTB2)
    end
    lgyPrint('gwc.equip.isLock==>' .. v.isLock);
    lgyPrint('gwc.equip.isBad==>' .. v.isBad);
    
    local value = equipM(v.id, v.eid, v.lv, v.rarity + 1, v.isBad, v.isLock, v.fst_attr, tempTB1)
    local index, index2 = equipP.getIndexByID(v.id)
    if index2 then
        equipP.change_allEqList(index, index2, value)
    else
        equipP.change_nowEqList(index, value)
    end
end

--卡牌升经验
function SendPB_10009(id,lv)
	print("SendPB_10009")
	local cgw = cgw_pb.CardFeed()
    cgw.cardId	 = id
    cgw.lvs	 = lv
    local msg = cgw:SerializeToString()
    createSendPBHeader(10009, msg)
end

function MSGID_10009(body)
	print("MSGID_10009..")
	local gwc = gwc_pb.CardFeed()
    gwc:ParseFromString(body)
    print(string.len(body))
    changeCardData(gwc, 10009)
end

--卡牌升星
function SendPB_10010(id)
	local cgw = cgw_pb.CardStarup()
    cgw.cardId	 = id
    local msg = cgw:SerializeToString()
    createSendPBHeader(10010, msg)
end

function MSGID_10010(body)
	print("MSGID_10010..")
	local gwc = gwc_pb.CardStarup()
    gwc:ParseFromString(body)
    changeCardData(gwc,10010)
end

--卡牌携带等级
function SendPB_10011(id)
	local cgw = cgw_pb.CardCarryup()
    cgw.cardId	 = id
    local msg = cgw:SerializeToString()
    createSendPBHeader(10011, msg)
end

function MSGID_10011(body)
	print("MSGID_10011..")
	local gwc = gwc_pb.CardCarryup()
    gwc:ParseFromString(body)
    changeCardData(gwc, 10011)
end

--卡牌军阶
function SendPB_10012(id)
	local cgw = cgw_pb.CardRankup()
    cgw.cardId	 = id
    local msg = cgw:SerializeToString()
    createSendPBHeader(10012, msg)
end

function MSGID_10012(body)
	print("MSGID_10012..")
	local gwc = gwc_pb.CardRankup()
    gwc:ParseFromString(body)
   	changeCardData(gwc, 10012)
end

--卡牌激活军功章槽位
function SendPB_10013(id,slotId)
	print("SendPB_10013..")
	local cgw = cgw_pb.CardTakeMedal()
    cgw.cardId	 = id
    cgw.slotId = slotId	
    local msg = cgw:SerializeToString()
    createSendPBHeader(10013, msg)
end

function MSGID_10013(body)
	print("MSGID_10013..")
	local gwc = gwc_pb.CardTakeMedal()
    gwc:ParseFromString(body)
    changeCardData(gwc, 10013)
end

--卡牌技能升级
function SendPB_10014(id,skillid)
	local cgw = cgw_pb.SkillLevelup()
    cgw.cardId	 = id
    cgw.skillId	 = skillid
    local msg = cgw:SerializeToString()
    createSendPBHeader(10014, msg)
end

function MSGID_10014(body)
	print("MSGID_10014..")
	local gwc = gwc_pb.SkillLevelup()
    gwc:ParseFromString(body)
    changeCardData(gwc, 10014)
end

--卡牌技能点重置
function SendPB_10015(id,cost)
	local cgw = cgw_pb.SkillReset()
    cgw.cardId	 = id
    cgw.cost	 = cost
    local msg = cgw:SerializeToString()
    createSendPBHeader(10015, msg)
end

function MSGID_10015(body)
	print("MSGID_10015..")
	local gwc = gwc_pb.SkillReset()
    gwc:ParseFromString(body)
	changeCardData(gwc, 10015)
end



-- 测试发送PBLUA--
function createSendPBHeader(msgId, body)
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

function class_wnd_login:OnAddHandler()
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
    -- Event.AddListener("errno10001", ERRNO_10001)
end

function class_wnd_login:OnRemoveHandler()
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

return class_wnd_login
