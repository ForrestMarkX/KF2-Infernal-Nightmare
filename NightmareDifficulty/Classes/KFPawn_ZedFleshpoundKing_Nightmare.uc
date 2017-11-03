class KFPawn_ZedFleshpoundKing_Nightmare extends KFPawn_ZedFleshpoundKing;

var const array<float> XPValuesMod;

function KFAIWaveInfo GetWaveInfo(int BattlePhase, int Difficulty)
{
	if( Difficulty > ArrayCount(SummonWaves) )
		Difficulty = ArrayCount(SummonWaves) - 1;
	
    switch (BattlePhase)
    {
    case 1:
        return SummonWaves[Difficulty].PhaseTwoWave;
        break;
    case 2:
        return SummonWaves[Difficulty].PhaseThreeWave;
        break;
    case 3:
        return SummonWaves[Difficulty].PhaseFourWave;
        break;
    case 0:
    default:
        return SummonWaves[Difficulty].PhaseOneWave;
    }

    return none;
}

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
	
	DifficultySettings=class'KFDifficulty_FleshpoundKing_Nightmare'
	ShieldHealthMaxDefaults(4)=3000
}