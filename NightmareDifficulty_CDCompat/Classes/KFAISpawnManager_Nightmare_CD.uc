class KFAISpawnManager_Nightmare_CD extends CD_SpawnManager;

var CD_SpawnManager OriginalSpawnManager;
var NightmareMutator ControllerMutator;

function Initialize()
{
	if( OriginalSpawnManager == None )
	{
		OriginalSpawnManager = new(Outer) class<CD_SpawnManager>(SpawnManagerClasses[GameLength]);
		OriginalSpawnManager.Initialize();
	}
	else OriginalSpawnManager.Initialize();
}

function Update()
{
	local array<class<KFPawn_Monster> > SpawnList;
	local int SpawnSquadResult;

	if ( OriginalSpawnManager.IsFinishedSpawning() || !IsWaveActive() )
	{
		return;
	}

	OriginalSpawnManager.TotalWavesActiveTime += SpawnPollFloat;
	OriginalSpawnManager.TimeUntilNextSpawn -= SpawnPollFloat;

	OriginalSpawnManager.CohortZedsSpawned = 0;
	OriginalSpawnManager.CohortSquadsSpawned = 0;
	OriginalSpawnManager.CohortVolumeIndex = 0;

	while ( OriginalSpawnManager.ShouldAddAI() )
	{
		SpawnList = OriginalSpawnManager.GetNextSpawnList();
		if( ControllerMutator != None )
			ControllerMutator.AdjustSpawnList(SpawnList);
			
		SpawnSquadResult = OriginalSpawnManager.SpawnSquad( SpawnList );
		NumAISpawnsQueued += SpawnSquadResult;
		OriginalSpawnManager.CohortZedsSpawned += SpawnSquadResult;
		
		if ( 0 == SpawnSquadResult || 0 >= Outer.CohortSizeInt )
			break;
			
		CohortSquadsSpawned += 1;
	}

	if ( 0 < CohortZedsSpawned )
	{
		OriginalSpawnManager.TimeUntilNextSpawn = OriginalSpawnManager.CalcNextGroupSpawnTime();

		OriginalSpawnManager.SpawnEventsThisWave += 1;

		OriginalSpawnManager.LatestSpawnTimestamp = Outer.Worldinfo.RealTimeSeconds;

		if ( 0 > OriginalSpawnManager.FirstSpawnTimestamp )
		{
			OriginalSpawnManager.FirstSpawnTimestamp = OriginalSpawnManager.LatestSpawnTimestamp;
		}

		if ( NumAISpawnsQueued >= OriginalSpawnManager.WaveTotalAI && 0 > OriginalSpawnManager.FinalSpawnTimestamp )
		{
			OriginalSpawnManager.FinalSpawnTimestamp = OriginalSpawnManager.LatestSpawnTimestamp;
		}
	}

	OriginalSpawnManager.CohortZedsSpawned = 0;
	OriginalSpawnManager.CohortSquadsSpawned = 0;
	OriginalSpawnManager.CohortVolumeIndex = 0;
}

function SetupNextWave(byte NextWaveIndex)
{
	OriginalSpawnManager.SetupNextWave(NextWaveIndex);
	WaveTotalAI = OriginalSpawnManager.WaveTotalAI;
}

function bool IsFinishedSpawning()
{
	return OriginalSpawnManager.IsFinishedSpawning();
}

function int SpawnSquad( out array< class<KFPawn_Monster> > AIToSpawn, optional bool bSkipHumanZedSpawning=false )
{
	return OriginalSpawnManager.SpawnSquad(AIToSpawn, bSkipHumanZedSpawning);
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

defaultproperties
{
}

