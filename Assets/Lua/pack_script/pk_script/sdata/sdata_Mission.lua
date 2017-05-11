----region *.lua
----Date 20151009
----关卡静态数据

--local data = require "Mission"
--local class_sdata_Mission = classWC(luacsv) 

--local data = require "Mission"
--local class_sdata_Mission = classWC(luacsv) 
--sdata_Mission =  class_sdata_Mission.new(data)

local dataMissionCity = require "MissionCity"
local class_sdata_MissionCity = classWC(luacsv) 
sdata_MissionCity =  class_sdata_MissionCity.new(dataMissionCity)


local dataMissionState = require "MissionState"
local class_sdata_MissionState = classWC(luacsv) 
sdata_MissionState =  class_sdata_MissionState.new(dataMissionState)


local dataMissionMonster = require "MissionMonster"
local class_sdata_MissionMonster = classWC(luacsv) 


function class_sdata_MissionMonster:Init()
    local BookNames = {}
    BookNames[1] = sdata_MissionMonster.I_BookName1
    BookNames[2] = sdata_MissionMonster.I_BookName2
    BookNames[3] = sdata_MissionMonster.I_BookName3
    --BookNames[4] = sdata_MissionMonster.I_BookName4
    --BookNames[5] = sdata_MissionMonster.I_BookName5
    --BookNames[6] = sdata_MissionMonster.I_BookName6

    local SubBookNames = {}
    SubBookNames[1] = sdata_MissionMonster.I_SubBookName1
    SubBookNames[2] = sdata_MissionMonster.I_SubBookName2
    SubBookNames[3] = sdata_MissionMonster.I_SubBookName3
    --SubBookNames[4] = sdata_MissionMonster.I_SubBookName4
    --SubBookNames[5] = sdata_MissionMonster.I_SubBookName5
    --SubBookNames[6] = sdata_MissionMonster.I_SubBookName6

    local Nums = {}
    Nums[1] = sdata_MissionMonster.I_Num1
    Nums[2] = sdata_MissionMonster.I_Num2
    Nums[3] = sdata_MissionMonster.I_Num3
    --Nums[4] = sdata_MissionMonster.I_Num4
    --Nums[5] = sdata_MissionMonster.I_Num5
    --Nums[6] = sdata_MissionMonster.I_Num6

    local DiaoLuo = {}
    DiaoLuo[1] = sdata_MissionMonster.I_DiaoluoTypeID1
    DiaoLuo[2] = sdata_MissionMonster.I_DiaoluoTypeID2
    DiaoLuo[3] = sdata_MissionMonster.I_DiaoluoTypeID3
    --Nums[4] = sdata_MissionMonster.I_Num4
    --Nums[5] = sdata_MissionMonster.I_Num5
    --Nums[6] = sdata_MissionMonster.I_Num6


    self.Nums = Nums
    self.SubBookNames = SubBookNames
    self.BookNames = BookNames
    self.DiaoLuo = DiaoLuo

    local Heros = {}
    Heros[1] = sdata_MissionMonster.I_MonsterHeroID1
    Heros[2] = sdata_MissionMonster.I_MonsterHeroID2
    Heros[3] = sdata_MissionMonster.I_MonsterHeroID3
    Heros[4] = sdata_MissionMonster.I_MonsterHeroID4
    Heros[5] = sdata_MissionMonster.I_MonsterHeroID5

    self.Heros = Heros
end


sdata_MissionMonster =  class_sdata_MissionMonster.new(dataMissionMonster)

sdata_MissionMonster:Init()--初始化

function class_sdata_MissionMonster:isFirstMissionInCity(MissionID)
    if self:GetFirstID() == MissionID then return true end
    local LastMission = self:GetLast(MissionID)

    local ThisCity ,ThisProvince = self:GetOrganization(MissionID)
    local NextCity ,NextProvince = self:GetOrganization(LastMission)

    --print("class_sdata_MissionMonster:isLastMissionInState",ThisProvince,NextProvince)
    return ThisCity ~= NextCity
end
function class_sdata_MissionMonster:isLastMissionInCity(MissionID)
    local NextMission = self:GetNext(MissionID)

    local ThisCity ,ThisProvince = self:GetOrganization(MissionID)
    local NextCity ,NextProvince = self:GetOrganization(NextMission)

    --print("class_sdata_MissionMonster:isLastMissionInState",ThisProvince,NextProvince)
    return ThisCity ~= NextCity
end

function class_sdata_MissionMonster:isLastMissionInState(MissionID)
    local NextMission = self:GetNext(MissionID)

    local ThisCity ,ThisProvince = self:GetOrganization(MissionID)
    local NextCity ,NextProvince = self:GetOrganization(NextMission)

    print("class_sdata_MissionMonster:isLastMissionInState",ThisProvince,NextProvince)
    return ThisProvince ~= NextProvince
end

function class_sdata_MissionMonster:GetItem(JLID,CItyID)
    --print("City:",CItyID,"JLID:",JLID)
   
    --DiaoluoTypeID1","BookName1","SubBookName1
    local temp = {}
    temp.BookName = tonumber( sdata_MissionMonster:GetV(self.BookNames[JLID],CItyID) )
    temp.SubType = tonumber( sdata_MissionMonster:GetV(self.SubBookNames[JLID],CItyID))
    temp.Num = tonumber( sdata_MissionMonster:GetV(self.Nums[JLID],CItyID))
    temp.DiaoLuo = tonumber( sdata_MissionMonster:GetV(self.DiaoLuo[JLID],CItyID))
    return temp
end

function class_sdata_MissionMonster:GetHero(HeroNumber,ID)
    return sdata_MissionMonster:GetV(self.Heros[HeroNumber],ID)
end

function class_sdata_MissionMonster:GetMissionOrder(City,Mission)
    
    local MissionBoundarystr =  sdata_MissionCity:GetV(sdata_MissionCity.I_CityID,City)
    local MissionBoundary = string.split(MissionBoundarystr,"|")
    local StartMission = tonumber( MissionBoundary[1] )
    local LastMission = tonumber( MissionBoundary[2] )
    --print("class_sdata_MissionMonster:GetMissionOrder",City,Mission,StartMission,LastMission,MissionBoundary)
    local Order = 1
    local eatchfunch = function (key,value)
        local Intkey = tonumber( key )
        if Intkey >= StartMission and Intkey <= LastMission then
            if Intkey < Mission then
                print("class_sdata_MissionMonster:GetMissionOrder  Key:",Intkey,Mission)
                Order = Order + 1 
            end
        end
    end
    sdata_MissionMonster:Foreach(eatchfunch)

    --print("class_sdata_MissionMonster:GetMissionOrder End:",Order)
    return Order
end

function class_sdata_MissionMonster:HowManyAfterMissionInCity(_Mission) 
    
    local City ,Province = sdata_MissionMonster:GetOrganization(_Mission)
    local Final = sdata_MissionCity:GetFinal(City)
    local Result = tonumber(Final) - tonumber(_Mission)
    
    return Result
end


function class_sdata_MissionMonster:GetIndexByMissionID(MissionBegin,MissionEnd) 
        local index = 0
       	local eatchfunch = function (key,value)
           if key > MissionBegin and key < MissionEnd then 
                index = index + 1
           end
           
		end
		sdata_MissionMonster:Foreach(eatchfunch)

        return index + 1 
end

function class_sdata_MissionMonster:GetIndex(MissionID)   
    local index = 1
   	local eatchfunch = function (key,value)
        if key == MissionID then 
            return index
        end
        index = index + 1
	end
	sdata_MissionMonster:Foreach(eatchfunch)

    return index - 1
end
function class_sdata_MissionMonster:GetFirstID()   
    return 100101
end

function class_sdata_MissionMonster:GetFinalMission()  
    local re = 0
    local Func = function(k,v)
        local Numk = tonumber( k )
        if Numk > re then 
            re = Numk
        end
         
    end
    sdata_MissionMonster:Foreach(Func)

    return re
end

function class_sdata_MissionMonster:GetLast(_MissionID)   
    local re = 0
    local Func = function(k,v)
        local Next = tonumber( v[sdata_MissionMonster.I_NextMonster] )
        if Next == _MissionID then
            re = tonumber( k )
        end
    end
    sdata_MissionMonster:Foreach(Func)

    return tonumber( re )
end

--获取编制
function class_sdata_MissionMonster:GetNext(MissionID)   
    --print("class_sdata_MissionMonster:GetNext",MissionID)
    if MissionID == 0 then 
        return sdata_MissionMonster:GetFirstID()
    end
    local temp = sdata_MissionMonster:GetV(sdata_MissionMonster.I_NextMonster,MissionID)

    if temp == nil then 
        print("********MissionMonster中未找到MissionID："..MissionID.."********")
        return sdata_MissionMonster:GetFirstID()
    end

    if tonumber ( temp ) == 0 then 
        return MissionID
    end
    return tonumber( temp )
end

--获取编制
function class_sdata_MissionMonster:GetOrganization(MissionID)  
    if MissionID == 0 then 
        return 0,0
    end 
    local Mission = MissionID % 100
    local City = sdata_MissionMonster:GetV(sdata_MissionMonster.I_CityID,MissionID)

    if City == nil then return print("class_sdata_MissionMonster:GetOrganization",MissionID) end
    
    local Province = sdata_MissionCity:GetV(sdata_MissionCity.I_StateID,City)
    if Province == nil then return print("class_sdata_MissionMonster:GetOrganization",City) end

    return City,Province
end
function class_sdata_MissionMonster:GetMissionsInCity(_CityID)  
    local Mission = {}
    local Func = function (key,value)
       local CityID = value[sdata_MissionMonster.I_CityID]
       if CityID ~= nil then 
            if CityID == _CityID then
                table.insert(Mission,key)
            end
       end
    end
	sdata_MissionMonster:Foreach(Func)
    for i = 1, #Mission do
        for j = 1,#Mission do
            if Mission[i] < Mission[j] then 
                local temp = Mission[i]
                Mission[i] = Mission[j]
                Mission[j] = temp
            end
        end
    end
    return Mission
end

function class_sdata_MissionState:GetFirstProvince()  
    local re = 0
    local Func = function(k,v)
        if re == 0 then
            re = k
        end
    end
    sdata_MissionState:Foreach(Func)

    return re
end

function class_sdata_MissionState:GetFirstMission(ProvinceID)  
    local temp = sdata_MissionState:GetV(sdata_MissionState.I_CityID,ProvinceID)
    local ProvinceString = string.split(temp,'|')
    local FirstCity = tonumber( ProvinceString[1] )

    local CityTemp =  sdata_MissionCity:GetV(sdata_MissionCity.I_CityID,FirstCity)
    local CityString = string.split(CityTemp,'|')
    local FirstMission = tonumber( CityString[1] )

    return FirstMission

end

function class_sdata_MissionState:GetLastCity(ProvinceID)  
    local temp = sdata_MissionState:GetV(sdata_MissionState.I_CityID,ProvinceID)
    local ProvinceString = string.split(temp,'|')
    local LastCity = tonumber( ProvinceString[#ProvinceString] )
    return LastCity
end

function class_sdata_MissionState:GetLastMission(ProvinceID)  

    local LastCity = self:GetLastCity(ProvinceID)
    local CityTemp =  sdata_MissionCity:GetV(sdata_MissionCity.I_CityID,LastCity)
    local CityString = string.split(CityTemp,'|')
    local LastMission = tonumber( CityString[#CityString] )

    return LastMission
end
function class_sdata_MissionState:GetFirstCity(ProvinceID)  

    local Citys = sdata_MissionState:GetV(sdata_MissionState.I_CityID,ProvinceID)
    local CityStr = string.split(Citys,'|')
    local FirstCity = tonumber( CityStr[1] )

    return FirstCity
end

function class_sdata_MissionState:GetProvinceID(CityID)  
    
    local eatchfunch = function (key,value)
        local temp = sdata_MissionState:GetV(sdata_MissionState.I_CityID,key)
        local teststring = string.split(temp,'|')
        for i = 1,#teststring do
            if tonumber(teststring[i]) == CityID then 
                return key
            end
        end
    end
	sdata_MissionState:Foreach(eatchfunch)
    return 1
    --local citys = sdata_MissionState:GetV(sdata_MissionState.I_CityID,)
end
--获取前一个省的ID，参数是当前省的ID
function class_sdata_MissionState:GetPreState(ProvinceID)  
    local preID = 1;
    if(ProvinceID > 1)then
        local provID = sdata_MissionState:GetV(sdata_MissionState.I_NextState,ProvinceID-1)
        if(tonumber(provID) == ProvinceID)then
            preID = ProvinceID-1;
            return ProvinceID-1
        else
            local eatchfunch = function(key,value)
                 local nextID = tonumber(sdata_MissionState:GetV(sdata_MissionState.I_NextState,key) )
                   if(tonumber(nextID) == ProvinceID)then
                        preID = key;
                        return key;
                   end
            end
            sdata_MissionState:Foreach(eatchfunch)
        end
    end
    return preID
end

function class_sdata_MissionState:GetCount()
    local temp = 1
    local eatchfunch = function (key,value)
       temp = temp + 1
    end
	sdata_MissionState:Foreach(eatchfunch)
    return temp
end

function class_sdata_MissionCity:GetCount()
    local temp = 1
    local eatchfunch = function (key,value)
       temp = temp + 1
    end
	sdata_MissionCity:Foreach(eatchfunch)
    return temp
end

function class_sdata_MissionCity:GetFirst(CityID)
    local MissionString = sdata_MissionCity:GetV(sdata_MissionCity.I_CityID,CityID)
    local Missions = string.split(MissionString,"|")
    local First = tonumber( Missions[1] )
    
    return First
end

function class_sdata_MissionCity:GetFinal(CityID)
    
    local MissionString = sdata_MissionCity:GetV(sdata_MissionCity.I_CityID,CityID)
    local Missions = string.split(MissionString,"|")
    local Final = tonumber( Missions[2] )
    return Final
end


function class_sdata_MissionCity:GetMissions(CityID)
    local MissionRange = sdata_MissionCity:GetV(sdata_MissionCity.I_CityID,CityID)
    local MissionString = string.split(MissionRange,"|")
    local MissionNumber = {}
    for i = 1, #MissionString do 
        MissionNumber[i] = tonumber( MissionString[i] )
    end 
    local Missions = {}
    local MissionIndex ={}

    local FirstRow = sdata_MissionMonster:GetRow(MissionNumber[1])
    local FirstName = FirstRow[sdata_MissionMonster.I_Name]
    Missions[MissionNumber[1]] = FirstName
    MissionIndex[1] = MissionNumber[1]
    local i = 2
    local Next = tonumber( FirstRow[sdata_MissionMonster.I_NextMonster] )
    while(true)
    do
        local NextRow = sdata_MissionMonster:GetRow(Next)
        if NextRow ~= nil then
            Missions[Next] = NextRow[sdata_MissionMonster.I_Name]
            MissionIndex[i] = Next
            --print("Key:"..Next,"Value:"..Missions[Next])
            if Next >= MissionNumber[2] then
                break
            end
            Next = tonumber( NextRow[sdata_MissionMonster.I_NextMonster] )
            i = 1 + i
        else
            break
        end
        
    end
    return Missions,MissionIndex
end
----- <summary>
----- 构造函数
----- </summary>
--function class_sdata_Mission:Init()	
--	local IJuanID = self:Name2I("_JuanID") 
--	self.JuanInfo = {} 

--	--取出最大的卷
--	local maxVolume = 0
--	local findMaxVolume = function(id,attr) 
--		local currJuan = attr[IJuanID]
--		if(currJuan>maxVolume) then maxVolume = currJuan end

--		if( self.JuanInfo[currJuan]==nil) then self.JuanInfo[currJuan] = {} end

--		table.insert(self.JuanInfo[currJuan],attr)
--	end
--	self:Foreach(findMaxVolume)

--	--保存最大卷信息
--	self.maxVolume = maxVolume  
--end

--function class_sdata_Mission:GetMissionsByJuanID(juanID)
--	return self.JuanInfo[juanID]
--end

--function class_sdata_Mission:GetNextGK(c,m)
--	if(c==0 or m==0) then return 1,1 end
--	local nextid = c*10+m+1
--	local nextData = self:GetRow(nextid)
--	if(nextData~=nil) then return c,m+1 end
--	return c+1,1
--end

--function class_sdata_Mission:IsWin(c,m)
--	if(PlayerData.data.CurrChapterID<1 or PlayerData.data.CurrMissionID<1) then 
--		return false
--	end

--	if(c>PlayerData.data.CurrChapterID) then  return true end
--	if(c<PlayerData.data.CurrChapterID) then   return false end 
--	return (m>=PlayerData.data.CurrMissionID)
--end

--sdata_Mission =  class_sdata_Mission.new(data)
--sdata_Mission:Init()
----endregion