class KFGameDifficulty_Nightmare extends KFGameDifficulty_Survival;

/** DifficultySettings struct for Nightmare difficulty level */
var(Nightmare) DifficultySettings Nightmare;

/** Great example here on why slaping private on stuff like this is pointless and uneccesary */
var DifficultySettings CurrentSettingsMod;
var float HealthMult, HeadHealthMult, SprintChanceMult;

function SetDifficultySettings( float GameDifficulty )
{
	switch ( GameDifficulty )
	{
	 	case `DIFFICULTY_NORMAL:         CurrentSettingsMod = Normal; break;
	 	case `DIFFICULTY_HARD:           CurrentSettingsMod = Hard; break;
	 	case `DIFFICULTY_SUICIDAL:       CurrentSettingsMod = Suicidal; break;
	 	case `DIFFICULTY_HELLONEARTH:    CurrentSettingsMod = HellOnEarth; break;
	 	case `DIFFICULTY_NIGHTMARE:    	 CurrentSettingsMod = Nightmare; break;

	 	default: CurrentSettingsMod = Normal; break;
	}
}

function float GetCharHealthModDifficulty( KFPawn_Monster P, float GameDifficulty )
{
	local float DefValue;
	
	DefValue = Super.GetCharHealthModDifficulty(P, GameDifficulty == `DIFFICULTY_NIGHTMARE ? GameDifficulty-1 : GameDifficulty);
	if( GameDifficulty == `DIFFICULTY_NIGHTMARE )
		DefValue *= HealthMult;
	
	return DefValue;
}

function float GetCharHeadHealthModDifficulty( KFPawn_Monster P, float GameDifficulty )
{
	local float DefValue;
	
	DefValue = Super.GetCharHeadHealthModDifficulty(P, GameDifficulty == `DIFFICULTY_NIGHTMARE ? GameDifficulty-1 : GameDifficulty);
	if( GameDifficulty == `DIFFICULTY_NIGHTMARE )
		DefValue *= HeadHealthMult;
	
	return DefValue;
}

function float GetCharSprintChanceByDifficulty( KFPawn_Monster P, float GameDifficulty )
{
	local float DefValue;
	
	DefValue = Super.GetCharSprintChanceByDifficulty(P, GameDifficulty == `DIFFICULTY_NIGHTMARE ? GameDifficulty-1 : GameDifficulty);
	if( GameDifficulty == `DIFFICULTY_NIGHTMARE )
		DefValue *= SprintChanceMult;
	
	return DefValue;
}

function float GetCharSprintWhenDamagedChanceByDifficulty( KFPawn_Monster P, float GameDifficulty )
{
	local float DefValue;
	
	DefValue = Super.GetCharSprintWhenDamagedChanceByDifficulty(P, GameDifficulty == `DIFFICULTY_NIGHTMARE ? GameDifficulty-1 : GameDifficulty);
	if( GameDifficulty == `DIFFICULTY_NIGHTMARE )
		DefValue *= SprintChanceMult;
	
	return DefValue;
}

function float GetAIDamageModifier(KFPawn_Monster P, float GameDifficulty, bool bSoloPlay)
{
	local float DefValue;
	
	DefValue = Super.GetAIDamageModifier(P, GameDifficulty == `DIFFICULTY_NIGHTMARE ? GameDifficulty-1 : GameDifficulty, bSoloPlay);
	if( GameDifficulty == `DIFFICULTY_NIGHTMARE )
		DefValue *= 1.25f;
	
	return DefValue;
}

function float GetAISpeedMod(KFPawn_Monster P, float GameDifficulty)
{
	local float DefValue;
	
	DefValue = Super.GetAISpeedMod(P, GameDifficulty == `DIFFICULTY_NIGHTMARE ? GameDifficulty-1 : GameDifficulty);
	if( GameDifficulty == `DIFFICULTY_NIGHTMARE )
		DefValue *= 1.1f;
	
	return DefValue;
}

function float GetGlobalHealthMod()
{
	return CurrentSettingsMod.GlobalHealthMod;
}

function float GetTraderTimeByDifficulty()
{
	return CurrentSettingsMod.TraderTime;
}

function float GetAIGroundSpeedMod()
{
	return CurrentSettingsMod.MovementSpeedMod;
}

function float GetDifficultyMaxAIModifier()
{
	return CurrentSettingsMod.WaveCountMod;
}

function float GetKillCashModifier()
{
	return CurrentSettingsMod.DoshKillMod;
}

function int GetAdjustedStartingCash()
{
	return CurrentSettingsMod.StartingDosh;
}

function int GetAdjustedRespawnCash()
{
	return CurrentSettingsMod.RespawnDosh;
}

function float GetItemPickupModifier()
{
	return CurrentSettingsMod.ItemPickupsMod;
}

function float GetAmmoPickupModifier()
{
	return CurrentSettingsMod.AmmoPickupsMod;
}

function float GetWeakAttackChance()
{
 	return CurrentSettingsMod.WeakAttackChance;
}

function float GetMediumAttackChance()
{
 	return CurrentSettingsMod.MediumAttackChance;
}

function float GetHardAttackChance()
{
 	return CurrentSettingsMod.HardAttackChance;
}

function float GetSelfInflictedDamageMod()
{
 	return CurrentSettingsMod.SelfInflictedDamageMod;
}

function float GetSpawnRateModifier()
{
	return CurrentSettingsMod.SpawnRateModifier;
}

static function float GetDifficultyValue( byte DifficultyIndex )
{
	switch ( DifficultyIndex )
	{
	 	case 0:	return `DIFFICULTY_NORMAL;
	 	case 1:	return `DIFFICULTY_HARD;
	 	case 2:	return `DIFFICULTY_SUICIDAL;
	 	case 3:	return `DIFFICULTY_HELLONEARTH;
	 	case 4:	return `DIFFICULTY_NIGHTMARE;
	 	default: return `DIFFICULTY_NORMAL;
	}
}

static function byte GetDifficultyIndex( float GameDifficulty )
{
 	switch ( GameDifficulty )
	{
	 	case `DIFFICULTY_NORMAL:		return 0;
	 	case `DIFFICULTY_HARD:   		return 1;
	 	case `DIFFICULTY_SUICIDAL:		return 2;
	 	case `DIFFICULTY_HELLONEARTH:	return 3;
	 	case `DIFFICULTY_NIGHTMARE:	return 4;

	 	default: return 99;
	}
}

defaultproperties
{
	HealthMult=1.0
	HeadHealthMult=1.0
	SprintChanceMult=1.0
	
	Nightmare={(
		TraderTime=30,
		MovementSpeedMod=1.100000,
   		WaveCountMod=1.950000,
   		DoshKillMod=0.750000,
   		StartingDosh=150,
   		AmmoPickupsMod=0.100000,
   		ItemPickupsMod=0.050000,
   		MediumAttackChance=1.000000,
        HardAttackChance=1.000000,
        SelfInflictedDamageMod=1.00000)}
}
