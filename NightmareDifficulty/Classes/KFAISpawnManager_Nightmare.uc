class KFAISpawnManager_Nightmare extends KFAISpawnManager;

var KFAISpawnManager OriginalSpawnManager;
var NightmareMutator ControllerMutator;

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
            OriginalSpawnManager.TimeUntilNextSpawn = OriginalSpawnManager.CalcNextGroupSpawnTime();
        }
	}
}

function int GetNumAINeeded()
{
	return OriginalSpawnManager.GetNumAINeeded();
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

defaultproperties
{
	RecycleSpecialSquad(4)=true
}

