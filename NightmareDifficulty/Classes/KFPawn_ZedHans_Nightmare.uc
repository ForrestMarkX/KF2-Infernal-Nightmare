class KFPawn_ZedHans_Nightmare extends KFPawn_ZedHans;

var const array<float> XPValuesMod;

simulated static function float GetXPValue(byte Difficulty)
{
	return default.XPValuesMod[Difficulty];
}

DefaultProperties
{
	XPValuesMod(0)=1291
	XPValuesMod(1)=1694
	XPValuesMod(2)=1790
	XPValuesMod(3)=1843
	XPValuesMod(4)=2212
	
    BattlePhases(0)={(bCanFrenzy=false,
                    bSprintingBehavior=false,
                    GlobalOffensiveNadePhaseCooldown=25,
                    bCanTossNerveGas=true,
                    bCanBarrageNerveGas=false,
                    bCanTossGrenade=false,
                    bCanBarrageGrenades=false,
                    bCanMoveWhileThrowingGrenades={(false, false, false, false, true)},
                    bCanUseGuns=true,
                    GunAttackPhaseCooldown=0,
                    GunAttackLengthPhase=99999,
                    HealThresholds={(0.6f, 0.6f, 0.6f, 0.6f, 0.6f)},
                    HealAmounts={(0.325f, 0.325f, 0.325f, 0.325f, 0.35f)},
                    MaxShieldHealth={(686, 980, 1400, 1820, 2100)},
                    )}
                    
    BattlePhases(1)={(bCanFrenzy=false,
                    GlobalOffensiveNadePhaseCooldown=25,
                    HENadeTossPhaseCooldown=20,
                    NerveGasTossPhaseCooldown=20,
                    bCanTossNerveGas=true,
                    bCanBarrageNerveGas=false,
                    bCanTossGrenade=true,
                    bCanBarrageGrenades=false,
                    bCanMoveWhileThrowingGrenades={(false, false, false, true, true)},
                    bCanUseGuns=true,
                    GunAttackPhaseCooldown=20,
                    GunAttackLengthPhase=10,
                    HealThresholds={(0.41f, 0.41f, 0.41f, 0.41f, 0.41f)},
                    HealAmounts={(0.275f, 0.275f, 0.275f, 0.275f, 0.3f)},
                    MaxShieldHealth={(860, 1225, 1750, 2275, 2625)},
                    )}

    BattlePhases(2)={(bCanFrenzy=true,
                    bSprintingBehavior=true,
                    GlobalOffensiveNadePhaseCooldown=20,
                    bCanTossNerveGas=false,
                    bCanBarrageNerveGas=true,
                    bCanTossGrenade=true,
                    bCanBarrageGrenades=false,
                    bCanMoveWhileThrowingGrenades={(false, false, true, true, true)},
                    bCanUseGuns=true,
                    GunAttackPhaseCooldown=20,
                    GunAttackLengthPhase=5,
                    HealThresholds={(0.25f, 0.25f, 0.25f, 0.25f, 0.25f)},
                    HealAmounts={(0.125f, 0.125f, 0.125f, 0.125f, 0.25f)},
                    MaxShieldHealth={(1030, 1470, 2100, 2730, 3500)},
                    )}

    BattlePhases(3)={(bCanFrenzy=true,
                    bSprintingBehavior=true,
                    GlobalOffensiveNadePhaseCooldown=10,
                    bCanTossNerveGas=false,
                    bCanBarrageNerveGas=false,
                    bCanTossGrenade=false,
                    bCanBarrageGrenades=true,
                    bCanMoveWhileThrowingGrenades={(false, false, true, true, true)},
                    bCanUseGuns=true,
                    GunAttackPhaseCooldown=30,
                    GunAttackLengthPhase=4,
                    )}
}
