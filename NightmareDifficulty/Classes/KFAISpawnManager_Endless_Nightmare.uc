class KFAISpawnManager_Endless_Nightmare extends KFAISpawnManager_Endless;

var NightmareMutator ControllerMutator;

function Update()
{
	local array<class<KFPawn_Monster> > SpawnList;

	if( IsWaveActive() )
	{
   		TotalWavesActiveTime += 1.0;
		TimeUntilNextSpawn -= 1.f;

        if( ShouldAddAI() )
        {
			SpawnList = GetNextSpawnList();
			if( ControllerMutator != None )
				ControllerMutator.AdjustSpawnList(SpawnList);

			NumAISpawnsQueued += SpawnSquad( SpawnList );
            TimeUntilNextSpawn = CalcNextGroupSpawnTime();
        }
	}
}

defaultproperties
{
}