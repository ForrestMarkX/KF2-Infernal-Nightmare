class KFPawn_ZedStalker_Nightmare extends KFPawn_ZedStalker;

var const array<float> XPValuesMod;

simulated static function float GetXPValue(byte Difficulty)
{
	return default.XPValuesMod[Difficulty];
}

DefaultProperties
{
	XPValuesMod(0)=8
	XPValuesMod(1)=10
	XPValuesMod(2)=10
	XPValuesMod(3)=10
	XPValuesMod(4)=12
	
	ElitePawnClass.Empty
}
