class KFPawn_ZedBloatKing_Nightmare extends KFPawn_ZedBloatKing;

var const array<float> XPValuesMod;

simulated static function float GetXPValue(byte Difficulty)
{
	return default.XPValuesMod[Difficulty];
}

defaultproperties
{
	DifficultyFartAttackTimers(4)=(X=2.0,Y=6.0)
	DifficultyVarianceFartTimers(4)=(X=1.0,Y=3.0)
	DifficultyRageFartTimers(4)=(X=0.5,Y=1.0)
	DifficultyVarianceRageFartTimers(4)=(X=0.45,Y=1.05)

    // Stats
    XPValuesMod(0)=1291
    XPValuesMod(1)=1694
    XPValuesMod(2)=1790
    XPValuesMod(3)=1843
    XPValuesMod(4)=2080
}