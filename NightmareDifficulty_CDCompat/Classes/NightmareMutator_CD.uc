class NightmareMutator_CD extends NightmareMutator;

function SetupCompatibilityClasses(KFGameInfo KFGI)
{
	local CD_Survival CDGame;
	
	Super.SetupCompatibilityClasses(KFGI);
	
	CDGame = CD_Survival(KFGI);
	if( CDGame == None )
	{
		Destroy();
		return;
	}
	
    CDGame.SpawnManager = new(CDGame) class'KFAISpawnManager_Nightmare_CD';
    
    if( KFAISpawnManager_Nightmare_CD(CDGame.SpawnManager) != None )
        KFAISpawnManager_Nightmare_CD(CDGame.SpawnManager).ControllerMutator = self;
    
    CDGame.SpawnManager.Initialize();
}

function SetupDifficultySettings()
{
	local KFDifficulty_ClotAlpha ClotADif;
	local KFDifficulty_Crawler CrawlerDif;
	local KFDifficulty_Gorefast GorefastDif;
	local KFAIController_ZedFleshpound FPController;
	local CD_Survival CDGame;
	local int i;
	
	Super.SetupDifficultySettings();
	
	CDGame = CD_Survival(WorldInfo.Game);
	if( CDGame == None )
	{
		Destroy();
		return;
	}
		
	if( !bool(CDGame.AlbinoAlphas) )
	{
		ClotADif = KFDifficulty_ClotAlpha(FindObject("KFGameContent.Default__KFDifficulty_ClotAlpha",class'KFDifficulty_ClotAlpha'));
		if( ClotADif != None )
		{
			for( i = 0; i < ClotADif.ChanceToSpawnAsSpecial.Length; i++ )
			{
				ClotADif.ChanceToSpawnAsSpecial[i] = 0;
			}
		}
	}
		
	if( !bool(CDGame.AlbinoCrawlers) )
	{
		CrawlerDif = KFDifficulty_Crawler(FindObject("KFGameContent.Default__KFDifficulty_Crawler",class'KFDifficulty_Crawler'));
		if( CrawlerDif != None )
		{
			for( i = 0; i < CrawlerDif.ChanceToSpawnAsSpecial.Length; i++ )
			{
				CrawlerDif.ChanceToSpawnAsSpecial[i] = 0;
			}
		}
	}
		
	if( !bool(CDGame.AlbinoGorefasts) )
	{
		GorefastDif = KFDifficulty_Gorefast(FindObject("KFGameContent.Default__KFDifficulty_Gorefast",class'KFDifficulty_Gorefast'));
		if( GorefastDif != None )
		{
			for( i = 0; i < GorefastDif.ChanceToSpawnAsSpecial.Length; i++ )
			{
				GorefastDif.ChanceToSpawnAsSpecial[i] = 0;
			}
		}
	}
	
	if( !bool(CDGame.FleshpoundRageSpawns) )
	{
		FPController = KFAIController_ZedFleshpound(FindObject("KFGame.Default__KFAIController_ZedFleshpound",class'KFAIController_ZedFleshpound'));
		if( FPController != None )
		{
			for( i = 0; i < FPController.SpawnRagedChance.Length; i++ )
			{
				FPController.SpawnRagedChance[i] = 0.0f;
			}
		}
	}
}

defaultproperties
{
    AIClassList.Add((Original=class'ControlledDifficulty.CD_Pawn_ZedClot_Alpha_Regular', Replacment=class'NightmareDifficulty.KFPawn_ZedClot_Alpha_Nightmare'))
    AIClassList.Add((Original=class'ControlledDifficulty.CD_Pawn_ZedClot_Alpha_Special', Replacment=class'NightmareDifficulty.KFPawn_ZedClot_AlphaKing_Nightmare'))
    AIClassList.Add((Original=class'ControlledDifficulty.CD_Pawn_ZedClot_Alpha', Replacment=class'NightmareDifficulty.KFPawn_ZedClot_Alpha_Nightmare'))
    AIClassList.Add((Original=class'ControlledDifficulty.CD_Pawn_ZedCrawler_Regular', Replacment=class'NightmareDifficulty.KFPawn_ZedCrawler_Nightmare'))
    AIClassList.Add((Original=class'ControlledDifficulty.CD_Pawn_ZedCrawler_Special', Replacment=class'NightmareDifficulty.KFPawn_ZedCrawlerKing_Nightmare'))
    AIClassList.Add((Original=class'ControlledDifficulty.CD_Pawn_ZedFleshpound_RS', Replacment=class'NightmareDifficulty.KFPawn_ZedFleshpound_Nightmare'))
    AIClassList.Add((Original=class'ControlledDifficulty.CD_Pawn_ZedFleshpound_NRS', Replacment=class'NightmareDifficulty.KFPawn_ZedFleshpoundAlpha_Nightmare'))
    AIClassList.Add((Original=class'ControlledDifficulty.CD_Pawn_ZedGorefast_Regular', Replacment=class'NightmareDifficulty.KFPawn_ZedGorefast_Nightmare'))
    AIClassList.Add((Original=class'ControlledDifficulty.CD_Pawn_ZedGorefast_Special', Replacment=class'NightmareDifficulty.KFPawn_ZedGorefastDualBlade_Nightmare'))    
	AIClassList.Add((Original=class'ControlledDifficulty.CD_Pawn_ZedFleshpoundMini_RS', Replacment=class'NightmareDifficulty.KFPawn_ZedFleshpoundMini_Nightmare'))
    AIClassList.Add((Original=class'ControlledDifficulty.CD_Pawn_ZedFleshpoundMini_NRS', Replacment=class'NightmareDifficulty.KFPawn_ZedFleshpoundMini_Nightmare'))
}