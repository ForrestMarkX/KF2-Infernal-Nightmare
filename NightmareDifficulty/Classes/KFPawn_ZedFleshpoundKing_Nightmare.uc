class KFPawn_ZedFleshpoundKing_Nightmare extends KFPawn_ZedFleshpoundKing;

var const array<float> XPValuesMod;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	SetEnraged(true);
}

function KFAIWaveInfo GetWaveInfo(int BattlePhase, int Difficulty)
{
	return Super.GetWaveInfo(BattlePhase, `DIFFICULTY_HELLONEARTH);
}

simulated static function float GetXPValue(byte Difficulty)
{
	return default.XPValuesMod[Difficulty];
}

DefaultProperties
{
	GroundSpeed=360.f
	SprintSpeed=780.f
	
    XPValuesMod(0)=1291
    XPValuesMod(1)=1694
    XPValuesMod(2)=1790
    XPValuesMod(3)=1843
    XPValuesMod(4)=2212
	
	DifficultySettings=class'KFDifficulty_FleshpoundKing_Nightmare'
	ShieldHealthMaxDefaults(4)=3000
	
    NumMinionsToSpawn=(X=3,Y=6)
}