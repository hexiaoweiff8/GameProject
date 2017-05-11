
local dataSuijiBaoxiang = require "SuijiBaoxiang"
local class_sdata_SuijiBaoxiang = classWC(luacsv) 

sdata_SuijiBaoxiang =  class_sdata_SuijiBaoxiang.new(dataSuijiBaoxiang)

local dataSuijiMonster = require "SuijiMonster"
local class_sdata_SuijiMonster = classWC(luacsv) 

sdata_SuijiMonster =  class_sdata_SuijiMonster.new(dataSuijiMonster)

local dataSuijiShop = require "SuijiShop"
local class_sdata_SuijiShop = classWC(luacsv) 

sdata_SuijiShop =  class_sdata_SuijiShop.new(dataSuijiShop)


function class_sdata_SuijiMonster:GetJLItem(ID)
    local JLItem = {}
    local ItemNode1 = {}
    ItemNode1.BookName = sdata_SuijiMonster:GetV(sdata_SuijiMonster.I_BookName1,ID)
    ItemNode1.SubType = sdata_SuijiMonster:GetV(sdata_SuijiMonster.I_SubType1,ID)
    ItemNode1.Num = sdata_SuijiMonster:GetV(sdata_SuijiMonster.I_Num1,ID)
    table.insert(JLItem,ItemNode1)

    local ItemNode2 = {}
    ItemNode2.BookName = sdata_SuijiMonster:GetV(sdata_SuijiMonster.I_BookName2,ID)
    ItemNode2.SubType = sdata_SuijiMonster:GetV(sdata_SuijiMonster.I_SubType2,ID)
    ItemNode2.Num = sdata_SuijiMonster:GetV(sdata_SuijiMonster.I_Num2,ID)
    table.insert(JLItem,ItemNode2)

    return JLItem
end

function class_sdata_SuijiMonster:GetHero(nIndex,ID)
    local ID1 = sdata_SuijiMonster:GetV(sdata_SuijiMonster.I_MonsterHeroID1,ID)
    local ID2 = sdata_SuijiMonster:GetV(sdata_SuijiMonster.I_MonsterHeroID2,ID)
    local ID3 = sdata_SuijiMonster:GetV(sdata_SuijiMonster.I_MonsterHeroID3,ID)
    local ID4 = sdata_SuijiMonster:GetV(sdata_SuijiMonster.I_MonsterHeroID4,ID)
    local ID5 = sdata_SuijiMonster:GetV(sdata_SuijiMonster.I_MonsterHeroID5,ID)

    local Temp = {}

    table.insert(Temp,ID1)
    table.insert(Temp,ID2)
    table.insert(Temp,ID3)
    table.insert(Temp,ID4)
    table.insert(Temp,ID5)

    return tonumber( Temp[nIndex] )
end

--endregion
