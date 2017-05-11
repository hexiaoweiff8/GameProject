--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

function StartFight()
    local fightParam = FightParameter.new()
    fightParam:SetLeftZhenfaID(1)
    fightParam:SetRightZhenfaID(2)
    fightParam:SetSceneID(1)
    fightParam:SetMusic("fightmusic1")

    local Square1 = ArmySquareInfo.new()
    Square1:SetFID(1)
    Square1:SetFlag(ArmyFlag.Attacker)
    Square1:SetHeroID(1024)
    Square1:SetHeroLevel(1)
    Square1:SetSoldiersCount(100)
    Square1:SetHXJ(2)
    Square1:SetSXJ(2)
    Square1:SetEquips({})
    Square1:SetSkillLevels({1,1,1,1,1,1,1,1,1})

    local Square2 = ArmySquareInfo.new()
    Square2:SetFID(1)
    Square2:SetFlag(ArmyFlag.Defender)
    Square2:SetHeroID(1025)
    Square2:SetHeroLevel(1)
    Square2:SetSoldiersCount(100)
    Square2:SetHXJ(2)
    Square2:SetSXJ(2)
    Square2:SetEquips({})
    Square2:SetSkillLevels({1,1,1,1,1,1,1,1,1})
    fightParam:SetSquares({Square1,Square2})

    local qixiSquare = ArmySquareInfo.new()
    qixiSquare:SetFID(1)
    qixiSquare:SetFlag(ArmyFlag.Attacker)
    qixiSquare:SetHeroID(1025)
    qixiSquare:SetHeroLevel(1)
    qixiSquare:SetSoldiersCount(100)
    qixiSquare:SetHXJ(2)
    qixiSquare:SetSXJ(2)
    qixiSquare:SetEquips({})
    qixiSquare:SetSkillLevels({1,1,1,1,1,1,1,1,1})
    fightParam:SetQixiSquare(qixiSquare)

    wnd_tuiguan:Hide(0)
    Battlefield.StartFight(fightParam)
end

--endregion
