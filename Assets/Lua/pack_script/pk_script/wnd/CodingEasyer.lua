
CodingEasyerClass = classWC()

function CodingEasyerClass:printf(str,s1,s2,s3,s4)

    if s4 ~= nil then 
        print(str,s1,s2,s3,s4)
        return
    end

    if s3 ~= nil then 
        print(str,s1,s2,s3)
        return
    end

    if s2 ~= nil then 
        print(str,s1,s2)
        return
    end

    if s1 ~= nil then 
        print(str,s1)
        return
    end

    print(str)
end


function CodingEasyerClass:GetResult(_Request)
    local isBreak = _Request:HasError()
    if isBreak then return  nil end
    local jsonDoc = _Request:GetResult()

    return jsonDoc
end


-- 调用Gird的Reposition方法
function CodingEasyerClass:Reposition(GameObj)
    local cmgrid = GameObj:GetComponent(CMUIGrid.Name)
	cmgrid:Reposition()
end

-- 调用设置精灵的皮肤方法
function CodingEasyerClass:SetSpriteName(GameObj,Text)
    
    local sprite = GameObj:GetComponent(CMUISprite.Name)
    --print("CodingEasyerClass:SetSpriteName","GameObj:",GameObj,"sprite:",sprite,"Text:",Text)
    sprite:SetSpriteName( Text )
end
-- 调用设置文本文字方法
function CodingEasyerClass:SetGongYongMeng(GameObj,HeroID)

    local HeroTemp = SData_Hero.GetHero(HeroID)

    local GongYongMeng = HeroTemp:Type()

    local IntType = tonumber( GongYongMeng )
    local Text
    if IntType == 2 then
        Text = "猛将"
    elseif IntType == 3 then
        Text = "勇将"
    elseif IntType == 4 then
        Text = "弓将"
     elseif IntType == 1 then
        Text = "其他"
    end
    
    if IntType == 4 then 
        Text = Text.." (射程"..tostring( HeroTemp:AtkRange() )..")"
    end
    --print("CodingEasyerClass:SetGongYongMeng Type:",IntType)
    self:SetLabel(GameObj,Text)
end

-- 调用设置文本文字方法
function CodingEasyerClass:SetLabel(GameObj,Text)
    --print("CodingEasyerClass:SetSpriteName",GameObj,CMUILabel.Name)
    local temp = GameObj:GetComponent(CMUILabel.Name)
    temp:SetValue( Text )
end

-- 调用设置文本文字颜色方法
function CodingEasyerClass:SetLabelColor(GameObj,Color)
    --print("CodingEasyerClass:SetSpriteName",GameObj,CMUILabel.Name)
    local temp = GameObj:GetComponent(CMUILabel.Name)
    temp:SetColor( Color )
end

function CodingEasyerClass:ParseJL(JLNode)
    if self:IsJLExist(JLNode) ~= true then
        return 
    end
    local Temp = {}
    temp.BookName = tonumber(JLNode:GetValue("b"))
    temp.SubType = tonumber(JLNode:GetValue("i"))
    temp.Num = tonumber(JLNode:GetValue("n"))
    print("CodingEasyerClass:ParseJL SUCCESS",temp.BookName,temp.SubType,temp.Num)
    return Temp
end

function CodingEasyerClass:PrintJL(JL)
    if self:IsJLExist(JL) ~= true then
        return print("奖励错误")
    end
    --Poptip.PopMsg("BookName:"..JL.BookName.."SubType"..JL.SubType.."Num"..JL.Num,Color.red)
    print("CodingEasyerClass:PrintJL","BookName:"..JL.BookName,"SubType"..JL.SubType,"Num"..JL.Num)
end
-- 获取奖励说明
function CodingEasyerClass:GetJLNote(JL)
    if self:IsJLExist(JL) ~= true then
        return "奖励错误"
    end

    local BookName = tonumber( JL.BookName )
    local SubType = tonumber( JL.SubType )
    local Num = tonumber( JL.Num )
    local Name
    if BookName == 1 then 
        Name = sdata_itemdata:GetV(sdata_itemdata.I_ItemNote,SubType)
    elseif BookName == 2 or BookName == 5 then
        Name = SData_Hero.GetHero(SubType):Special()
        if BookName == 5 then
            Name = Name.."碎片"
        end
    elseif BookName == 3 or BookName == 6 then
        --[[    目前没有士兵表
        Name = SData_Hero.GetHero(SubType):Name()
        if BookName == 6 then
            Name = Name.."碎片"
        end
        --]]
    elseif BookName == 21 then
        Name = sdata_EquipData:GetV(sdata_EquipData.I_Description,SubType)
    elseif BookName == 22 then
        Name = sdata_XilianshiData:GetV(sdata_XilianshiData.I_Description,SubType)
    end
    return Name
end
-- 获取奖励名
function CodingEasyerClass:GetJLName(JL)
    if self:IsJLExist(JL) ~= true then
        return "奖励错误"
    end

    local BookName = tonumber( JL.BookName )
    local SubType = tonumber( JL.SubType )
    local Num = tonumber( JL.Num )
    local Name
    if BookName == 1 then 
        Name = sdata_itemdata:GetV(sdata_itemdata.I_Name,SubType)
    elseif BookName == 2 or BookName == 5 then
        Name = SData_Hero.GetHero(SubType):Name()
        if BookName == 5 then
            Name = Name.."碎片"
        end
    elseif BookName == 3 or BookName == 6 then
        --[[    目前没有士兵表
        Name = SData_Hero.GetHero(SubType):Name()
        if BookName == 6 then
            Name = Name.."碎片"
        end
        --]]
    elseif BookName == 21 then
        Name = sdata_EquipData:GetV(sdata_EquipData.I_Name,SubType)
    elseif BookName == 22 then
        Name = sdata_XilianshiData:GetV(sdata_XilianshiData.I_Name,SubType)
    end
    return Name
end
function CodingEasyerClass:SetJLIcon(GameObj,JL)
    --tonumber( JL.BookName )
    --tonumber( JL.SubType )
    --tonumber( JL.Num )
    if self:IsJLExist(JL) ~= true then 
        GameObj:SetActive(false)
        return
    end
    GameObj:SetActive(true)
    --print("CodingEasyerClass:SetJLIcon",GameObj)
    local Icon = GameObj:FindChild("img")
    local sprite = Icon:GetComponent(CMUISprite.Name)
    local BookName = tonumber( JL.BookName )
    local SubType = tonumber( JL.SubType )
    local Number = tostring( JL.Num )
--    print("CodingEasyerClass:SetJLIcon=============================",BookName,SubType,Number)
    local SkinName = ""
    if GameObj:FindChild("txt") ~= nil then
		local txt = GameObj:FindChild("txt")
		self:SetLabel(txt,Number)
    end
   
    if BookName == 1 then --道具  
       sprite:SetAtlas("core","itemAtlas")
       SkinName = sdata_itemdata:GetV(sdata_itemdata.I_HuobiIcon,SubType)
    elseif BookName == 2 or BookName == 5 then -- 英雄 
       sprite:SetAtlas("hero","hero1Atlas")
       local HeroStruct = SData_Hero.GetHero(SubType)
       HeroStruct:SetHeroIcon(sprite)
       --print("CodingEasyerClass:SetHeroIcon","SubType:",SubType)
       return
    elseif BookName == 3  or BookName == 6 then -- 士兵 
       sprite:SetAtlas("")
       SkinName = ""
    elseif BookName == 11 then
       sprite:SetAtlas("")
       SkinName = "限时头像"
    elseif BookName == 21 then
       sprite:SetAtlas("ui_equip","ui_equipAtlas")
       SkinName = sdata_EquipData:GetV(sdata_EquipData.I_Icon,SubType)
    elseif BookName == 22 then
       sprite:SetAtlas("ui_equip","ui_equipAtlas")
       SkinName = sdata_XilianshiData:GetV(sdata_XilianshiData.I_Icon,SubType)
    end
    sprite:SetSpriteName( SkinName )
end

function CodingEasyerClass:IsJLExist(JL)
    if JL == nil then return false end 
    local BookName = tonumber( JL.BookName )
    local SubType = tonumber( JL.SubType )
    local Num = tonumber( JL.Num )
    --print("CodingEasyerClass:IsJLExist",BookName,SubType,Num)
    if BookName == nil or SubType == nil or Num == nil then 
        return false
    end
    if BookName <= 0 or SubType <= 0 or Num <= 0 then 
        return false
    end
    
    return true
end
function CodingEasyerClass:SetHero(GameObj,_Hero)
    if _Hero == nil then GameObj:SetActive(false) return end
    local HeroInfo = SData_Hero.GetHero(_Hero.ID)
    if HeroInfo == nil then GameObj:SetActive(false) return end
    GameObj:SetActive(true)
    local Icon = GameObj:FindChild("img")
    local sprite = Icon:GetComponent(CMUISprite.Name)
    
    
    HeroInfo:SetHeroIcon(sprite)
end


-- 城市ID转换
function CodingEasyerClass:SimpleToComplex(id)
    
    return sdata_Mission:GetProvinceID(id)
end

-- 城市ID转换
function CodingEasyerClass:ComplexToSimple(id)
    
    return id % 1000
end

-- 城市ID转换
function CodingEasyerClass:ComplexCityToProvince(id)
    if id <= 1000 then return print("CodingEasyerClass:ComplexCityToProvince",id) end
    return math.floor(id / 1000)
end

function CodingEasyerClass:GetJL(Json)
    local TempJL = {}
    TempJL.BookName = tonumber( Json:GetValue("b"))
    TempJL.SubType = tonumber(Json:GetValue("i"))
    TempJL.Num = tonumber(Json:GetValue("n"))
    --print("CodingEasyerClass:GetJL:",TempJL.BookName,TempJL.SubType,TempJL.Num)
    return TempJL ,self:IsJLExist(TempJL)
end
function CodingEasyerClass:GetJLByNumber(_BookName,_Subtype,_Num)
    local TempJL = {}
    TempJL.BookName = tonumber( _BookName)
    TempJL.SubType = tonumber(_Subtype)
    TempJL.Num = tonumber(_Num)
    return TempJL ,self:IsJLExist(TempJL)
end



return CodingEasyerClass.new
 