class KFAISpawnManager_Nightmare extends KFAISpawnManager;

var KFAISpawnManager OriginalSpawnManager;
var NightmareMutator ControllerMutator;

var() SpawnRateModifier SoloWaveSpawnRateModifierMod[5];
var() float EarlyWaveSpawnRateModifierMod[5];

function Initialize()
{
    if( OriginalSpawnManager == None )
    {
        OriginalSpawnManager = new(Outer) SpawnManagerClasses[GameLength];
        OriginalSpawnManager.Initialize();
        OriginalSpawnManager.RecycleSpecialSquad.AddItem(true);
    }
    else OriginalSpawnManager.Initialize();
}

function Update()
{
    local array<class<KFPawn_Monster> > SpawnList;

    if( IsWaveActive() )
    {
        OriginalSpawnManager.TotalWavesActiveTime += 1.0;
        OriginalSpawnManager.TimeUntilNextSpawn -= 1.f;

        if( OriginalSpawnManager.ShouldAddAI() )
        {
            SpawnList = OriginalSpawnManager.GetNextSpawnList();
            if( ControllerMutator != None )
                ControllerMutator.AdjustSpawnList(SpawnList);

            NumAISpawnsQueued += OriginalSpawnManager.SpawnSquad( SpawnList );
            OriginalSpawnManager.TimeUntilNextSpawn = CalcNextGroupSpawnTime();
        }
    }
}

function int GetNumAINeeded()
{
    return OriginalSpawnManager.GetNumAINeeded();
}

function SetupNextWave(byte NextWaveIndex, int TimeToNextWaveBuffer = 0)
{
    OriginalSpawnManager.SetupNextWave(NextWaveIndex, TimeToNextWaveBuffer);
    WaveTotalAI = OriginalSpawnManager.WaveTotalAI;
}

function bool IsFinishedSpawning()
{
    return OriginalSpawnManager.IsFinishedSpawning();
}

function int GetMaxMonsters()
{
    return OriginalSpawnManager.GetMaxMonsters();
}

function GetAvailableSquads(byte MyWaveIndex, optional bool bNeedsSpecialSquad=false)
{
    OriginalSpawnManager.GetAvailableSquads(MyWaveIndex, bNeedsSpecialSquad);
}

function int SpawnSquad( out array< class<KFPawn_Monster> > AIToSpawn, optional bool bSkipHumanZedSpawning=false )
{
    return OriginalSpawnManager.SpawnSquad(AIToSpawn, bSkipHumanZedSpawning);
}

function GetSpawnListFromSquad(byte SquadIdx, out array< KFAISpawnSquad > SquadsList, out array< class<KFPawn_Monster> >  AISpawnList)
{
    OriginalSpawnManager.GetSpawnListFromSquad(SquadIdx, SquadsList, AISpawnList);
}

function array< class<KFPawn_Monster> > GetNextSpawnList()
{
    return OriginalSpawnManager.GetNextSpawnList();
}

function SummonBossMinions( array<KFAISpawnSquad> NewMinionSquad, int NewMaxBossMinions, optional bool bUseLivingPlayerScale = true )
{
	OriginalSpawnManager.SummonBossMinions(NewMinionSquad, NewMaxBossMinions, bUseLivingPlayerScale);
}

function StopSummoningBossMinions()
{
	OriginalSpawnManager.StopSummoningBossMinions();
}

function int GetAIAliveCount()
{
    return OriginalSpawnManager.GetAIAliveCount();
}

function float CalcNextGroupSpawnTime()
{
	local float NextSpawnDelay, SineMod;
	local KFMapInfo KFMI;
	local KFGameReplicationInfo KFGRI;

	// Any leftover zeds from a group that didn't spawn, spawn them right away!
    if( OriginalSpawnManager.LeftoverSpawnSquad.Length > 0 )
	{
        return 0;
	}
	else
	{
    	KFMI = KFMapInfo(WorldInfo.GetMapInfo());
    	SineMod = OriginalSpawnManager.GetSineMod();

    	NextSpawnDelay = KFMI != none ? KFMI.WaveSpawnPeriod : class'KFMapInfo'.default.WaveSpawnPeriod;
    	NextSpawnDelay *= GetNextSpawnTimeMod();
    	NextSpawnDelay += SineMod * (NextSpawnDelay * 2);

    	KFGRI = KFGameReplicationInfo(WorldInfo.GRI);
    	if( KFGRI != none && (KFGRI.bDebugSpawnManager || KFGRI.bGameConductorGraphingEnabled) )
    	{
    		KFGRI.CurrentSineMod = SineMod;
    		KFGRI.CurrentNextSpawnTime = NextSpawnDelay;
    		KFGRI.CurrentSineWavFreq = OriginalSpawnManager.GetSineWaveFreq();
    		KFGRI.CurrentNextSpawnTimeMod = GetNextSpawnTimeMod();
    	}
	}

	`log(GetFuncName()$" NextSpawnTime:" @ WorldInfo.TimeSeconds + NextSpawnDelay @"NextSpawnDelay:"@NextSpawnDelay$" SineMod: "$SineMod$" WaveSpawnPeriod: "$(KFMI != none ? KFMI.WaveSpawnPeriod : class'KFMapInfo'.default.WaveSpawnPeriod)$" GetNextSpawnTimeMod(): "$GetNextSpawnTimeMod(), bLogAISpawning || bLogWaveSpawnTiming);

	return NextSpawnDelay;
}

function float GetNextSpawnTimeMod()
{
	local byte NumLivingPlayers;
	local float SpawnTimeMod;
	local float UsedEarlyWaveRateMod;
	local float UsedSoloWaveRateMod;

	NumLivingPlayers = GetLivingPlayerCount();
	SpawnTimeMod = 1.0;
	UsedSoloWaveRateMod = 1.0;

    // Scale solo spawning rate by wave and difficulty
    if( bOnePlayerAtStart && NumLivingPlayers <= 1 )
    {
    	if( GameDifficulty < ArrayCount(SoloWaveSpawnRateModifierMod) )
    	{
            if( MyKFGRI.WaveNum <= SoloWaveSpawnRateModifierMod[GameDifficulty].RateModifier.Length )
            {
                UsedSoloWaveRateMod = SoloWaveSpawnRateModifierMod[GameDifficulty].RateModifier[MyKFGRI.WaveNum - 1];
            }
            else
            {
                UsedSoloWaveRateMod = SoloWaveSpawnRateModifierMod[GameDifficulty].RateModifier[SoloWaveSpawnRateModifierMod[GameDifficulty].RateModifier.Length -1];
            }
    	}
    	else
    	{
            if( MyKFGRI.WaveNum <= SoloWaveSpawnRateModifierMod[GameDifficulty].RateModifier.Length )
            {
                UsedSoloWaveRateMod = SoloWaveSpawnRateModifierMod[ArrayCount(SoloWaveSpawnRateModifierMod) - 1].RateModifier[MyKFGRI.WaveNum - 1];
            }
            else
            {
                UsedSoloWaveRateMod = SoloWaveSpawnRateModifierMod[ArrayCount(SoloWaveSpawnRateModifierMod) - 1].RateModifier[SoloWaveSpawnRateModifierMod[GameDifficulty].RateModifier.Length -1];
            }
    	}
    }

	if ( MyKFGRI.WaveNum < EarlyWaveIndex )
	{
        // Set the base SpawnTimeMod for early waves based on the number of living players
    	if( NumLivingPlayers <= ArrayCount(EarlyWavesSpawnTimeModByPlayers) )
    	{
            if( NumLivingPlayers == 0 )
            {
                SpawnTimeMod = EarlyWavesSpawnTimeModByPlayers[NumLivingPlayers];
            }
            else
            {
                SpawnTimeMod = EarlyWavesSpawnTimeModByPlayers[NumLivingPlayers - 1];
            }
    	}
    	else
    	{
    	   SpawnTimeMod = EarlyWavesSpawnTimeModByPlayers[ArrayCount(EarlyWavesSpawnTimeModByPlayers) - 1];
    	}

        `log("Early Waves SpawnTimeMod = "$SpawnTimeMod$" NumLivingPlayers = "$NumLivingPlayers$" UsedSoloWaveRateMod = "$UsedSoloWaveRateMod, bLogAISpawning);

        // Scale the spawning rate of early waves by difficulty (generally to make them more intense)
    	if( GameDifficulty < ArrayCount(EarlyWaveSpawnRateModifierMod) )
    	{
    	   UsedEarlyWaveRateMod = EarlyWaveSpawnRateModifierMod[GameDifficulty];
    	}
    	else
    	{
    	   UsedEarlyWaveRateMod = EarlyWaveSpawnRateModifierMod[ArrayCount(EarlyWaveSpawnRateModifierMod) - 1];
    	}

        SpawnTimeMod *= UsedEarlyWaveRateMod;
        SpawnTimeMod *= UsedSoloWaveRateMod;

        `log("Early waves final SpawnTimeMod = "$SpawnTimeMod, bLogAISpawning);
	}
	// Give a slightly bigger breather in the later waves
	else
	{
        // Set the base SpawnTimeMod for late waves based on the number of living players
        if( NumLivingPlayers <= ArrayCount(LateWavesSpawnTimeModByPlayers) )
    	{
            if( NumLivingPlayers == 0 )
            {
                SpawnTimeMod = LateWavesSpawnTimeModByPlayers[NumLivingPlayers];
            }
            else
            {
                SpawnTimeMod = LateWavesSpawnTimeModByPlayers[NumLivingPlayers - 1];
            }
    	}
    	else
    	{
    	   SpawnTimeMod = LateWavesSpawnTimeModByPlayers[ArrayCount(LateWavesSpawnTimeModByPlayers) - 1];
    	}

        `log("Late waves SpawnTimeMod = "$SpawnTimeMod$" NumLivingPlayers = "$NumLivingPlayers$" UsedSoloWaveRateMod = "$UsedSoloWaveRateMod, bLogAISpawning);

        SpawnTimeMod *= UsedSoloWaveRateMod;

        `log("Late waves final  SpawnTimeMod = "$SpawnTimeMod, bLogAISpawning);
	}

    // Apply difficulty based modifier
    if ( DifficultyInfo != None )
    {
        SpawnTimeMod *= DifficultyInfo.GetSpawnRateModifier();
        `log("Spawn rate modifier (difficulty):"@DifficultyInfo.GetSpawnRateModifier(), bLogAISpawning);
    }

    //Apply global game mode spawn rate modifier
    SpawnTimeMod *= GetGameInfoSpawnRateMod();

	return SpawnTimeMod * GameConductor.CurrentSpawnRateModification;
}

defaultproperties
{
    RecycleSpecialSquad(4)=true
	
	// Normal
    SoloWaveSpawnRateModifierMod(0)={(RateModifier[0]=1.0,     // Wave 1
                                   RateModifier[1]=1.0,     // Wave 2
                                   RateModifier[2]=1.0,     // Wave 3
                                   RateModifier[3]=1.0)}    // Wave 4

	// Hard
    SoloWaveSpawnRateModifierMod(1)={(RateModifier[0]=1.0,     // Wave 1
                                   RateModifier[1]=1.0,     // Wave 2
                                   RateModifier[2]=1.0,     // Wave 3
                                   RateModifier[3]=1.0)}    // Wave 4

	// Suicidal
    SoloWaveSpawnRateModifierMod(2)={(RateModifier[0]=1.0,     // Wave 1
                                   RateModifier[1]=1.0,     // Wave 2
                                   RateModifier[2]=1.0,     // Wave 3
                                   RateModifier[3]=1.0)}    // Wave 4

	// Hell On Earth
    SoloWaveSpawnRateModifierMod(3)={(RateModifier[0]=1.0,     // Wave 1
                                   RateModifier[1]=1.0,     // Wave 2
                                   RateModifier[2]=1.0,     // Wave 3
                                   RateModifier[3]=1.0)}    // Wave 4
	
	// Nightmare
    SoloWaveSpawnRateModifierMod(4)={(RateModifier[0]=0.8,     // Wave 1
                                   RateModifier[1]=0.8,     // Wave 2
                                   RateModifier[2]=0.8,     // Wave 3
                                   RateModifier[3]=0.8)}    // Wave 4
								   
	EarlyWaveSpawnRateModifierMod(0)=0.8
	EarlyWaveSpawnRateModifierMod(1)=0.6
	EarlyWaveSpawnRateModifierMod(2)=0.5
	EarlyWaveSpawnRateModifierMod(3)=0.5
	EarlyWaveSpawnRateModifierMod(4)=0.4
}