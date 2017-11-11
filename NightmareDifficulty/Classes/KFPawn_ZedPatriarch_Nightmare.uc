class KFPawn_ZedPatriarch_Nightmare extends KFPawn_ZedPatriarch;

var const array<float> XPValuesMod;
var	BossMinionWaveInfo SummonWaves[5];

function KFAIWaveInfo GetWaveInfo(int BattlePhase, int Difficulty)
{
    switch (BattlePhase)
    {
    case 1:
        return SummonWaves[Difficulty].PhaseOneWave;
        break;
    case 2:
        return SummonWaves[Difficulty].PhaseTwoWave;
        break;
    case 3:
        return SummonWaves[Difficulty].PhaseThreeWave;
        break;
    }

    return none;
}

simulated static function float GetXPValue(byte Difficulty)
{
	return default.XPValuesMod[Difficulty];
}

defaultproperties
{
	XPValuesMod(0)=1291
	XPValuesMod(1)=1694
	XPValuesMod(2)=1790
	XPValuesMod(3)=1843
	XPValuesMod(4)=2212
	
	SummonWaves(4)=(PhaseOneWave=KFAIWaveInfo'GP_Spawning_ARCH.Special.Pat_Minions_HOE_One',PhaseTwoWave=KFAIWaveInfo'GP_Spawning_ARCH.Special.Pat_Minions_HOE_Two',PhaseThreeWave=KFAIWaveInfo'GP_Spawning_ARCH.Special.Pat_Minions_HOE_Three')
	NumMinionsToSpawn=(X=8, Y=14)
	
	BattlePhases(0)={(bAllowedToSprint=true,
					  SprintCooldownTime=3.f,
					  bCanTentacleGrab=false,
					  bCanUseMissiles=true,
					  MissileAttackCooldownTime=10.f,
					  bCanUseMortar=false,
					  bCanChargeAttack=false,
					  bCanChargeAttack=true,
					  ChargeAttackCooldownTime=14.f,
					  MinigunAttackCooldownTime=2.25f,
					  bCanMoveWhenMinigunning={(false, false, false, false, true)},
					  HealAmounts={(0.75f, 0.85f, 0.95f, 0.99f, 1.0f)},
					  bCanSummonMinions=true)}
	BattlePhases(1)={(bAllowedToSprint=true,
					  SprintCooldownTime=2.5f,
					  bCanTentacleGrab=true,
					  TentacleGrabCooldownTime=10.f,
					  TentacleDamage=10,
					  bCanUseMissiles=true,
					  MissileAttackCooldownTime=8.f,
					  bCanUseMortar=true,
					  MortarAttackCooldownTime=10.f,
					  bCanChargeAttack=true,
					  ChargeAttackCooldownTime=10.f,
					  MinigunAttackCooldownTime=2.0f,
					  bCanMoveWhenMinigunning={(false, false, false, true, true)},
					  HealAmounts={(0.65f, 0.75f, 0.85f, 0.95f, 0.99f)},
					  MaxRageAttacks=4,
					  bCanSummonMinions=true)}
	BattlePhases(2)={(bAllowedToSprint=true,
					  SprintCooldownTime=2.f,
					  bCanTentacleGrab=true,
					  TentacleGrabCooldownTime=9.f,
					  TentacleDamage=10,
					  bCanUseMissiles=true,
					  MissileAttackCooldownTime=7.f,
					  bCanUseMortar=true,
					  MortarAttackCooldownTime=9.f,
					  bCanDoMortarBarrage=true,
					  bCanChargeAttack=true,
					  ChargeAttackCooldownTime=9.f,
					  MinigunAttackCooldownTime=1.75f,
					  bCanMoveWhenMinigunning={(false, false, true, true, true)},
					  HealAmounts={(0.55f, 0.65f, 0.75f, 0.85f, 0.9f)},
					  MaxRageAttacks=5,
					  bCanSummonMinions=true)}
	BattlePhases(3)={(bAllowedToSprint=true,
					  SprintCooldownTime=1.5f,
					  bCanTentacleGrab=true,
					  TentacleGrabCooldownTime=7.f,
					  TentacleDamage=10,
					  bCanUseMissiles=true,
					  MissileAttackCooldownTime=5.f,
					  bCanUseMortar=true,
					  MortarAttackCooldownTime=7.f,
					  bCanDoMortarBarrage=true,
					  bCanChargeAttack=true,
					  ChargeAttackCooldownTime=7.f,
					  MinigunAttackCooldownTime=1.25f,
					  bCanMoveWhenMinigunning={(false, true, true, true, true)},
					  MaxRageAttacks=6,
					  bCanSummonMinions=false)}
}