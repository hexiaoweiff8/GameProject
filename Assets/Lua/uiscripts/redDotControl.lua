local class = require("common/middleclass")
redDotControl = class("redDotControl")

redDotFlag = {}
redDotFlag.RD_UPSTAR = false
redDotFlag.RD_UPLEVEL = false
redDotFlag.RD_SOLDIER = false
redDotFlag.RD_INFORMATION = false
redDotFlag.RD_SKILL = false
redDotFlag.RD_SKILLITEMS = {}
redDotFlag.RD_SYNERGY = false
redDotFlag.RD_SYNERGYITEMS = {}
local data
function redDotControl:refresh_cardyc(cardIndex)
    print("init_redDot")
    self:getRD_UPSTAR(cardIndex)
    self:getRD_UPLEVEL(cardIndex)
    self:getRD_INFORMATION(cardIndex)
    self:getRD_SKILL(cardIndex)
    self:getRD_SOLDIER(cardIndex)
    self:getRD_SYNERGY(cardIndex)
end
function redDotControl:getRD_UPSTAR(cardIndex)
    data = require("uiscripts/cardyc/upStar/upStar_model")
    data:getDatas(cardIndex)
    if data:isCan_UpStar() == 0 then 
        redDotFlag.RD_UPSTAR = true
    else 
        redDotFlag.RD_UPSTAR = false
    end
end


function redDotControl:getRD_UPLEVEL(cardIndex)
    data = require("uiscripts/cardyc/upLevel/upLevel_model")
    data:getDatas(cardIndex)
    if data:isCan_UpLevel() == 0 then 
        redDotFlag.RD_UPLEVEL = true
    else 
        redDotFlag.RD_UPLEVEL = false
    end
end

function redDotControl:getRD_INFORMATION(cardIndex)
    data = require("uiscripts/cardyc/information/information_model")
    data:getDatas(cardIndex)
    for i = 0, #data.slotState do 
        if data.slotState[i] == qualityUtil.EquipState.Enable_Enough then 
            redDotFlag.RD_INFORMATION = true
        end
    end
    if data:isCan_UpQuality() == 0 then 
        redDotFlag.RD_INFORMATION = true
    else 
        redDotFlag.RD_INFORMATION = false
    end
end

function redDotControl:getRD_SKILL(cardIndex)
    data = require("uiscripts/cardyc/upSkill/upSkill_model")
    data:getDatas(cardIndex)
    redDotFlag.RD_SKILL = false
    for i = 1, #data.skill_Lv_Table do
        redDotFlag.RD_SKILLITEMS[i] = false
        if data:isCan_UpSkill(i) == 0 then 
            redDotFlag.RD_SKILL = true
            redDotFlag.RD_SKILLITEMS[i] = true
        end
    end    
end

function redDotControl:getRD_SOLDIER(cardIndex)
    data = require("uiscripts/cardyc/upSoldier/upSoldier_model")
    data:getDatas(cardIndex)
    if data:isCan_UpSoldier() == 0 then 
        redDotFlag.RD_SOLDIER = true
    else 
        redDotFlag.RD_SOLDIER = false
    end
end


function redDotControl:getRD_SYNERGY(cardIndex)
    data = require("uiscripts/cardyc/upSynergy/upSynergy_model")
    data:getDatas(cardIndex)
    redDotFlag.RD_SYNERGY = false
    for i = 1, #data.synergyLvTbl do
        redDotFlag.RD_SYNERGYITEMS[i] = false
        if data:isCan_UpSynergy(i) == 0 then 
            redDotFlag.RD_SYNERGY = true
            redDotFlag.RD_SYNERGYITEMS[i] = true
        end
    end    
end






return redDotControl