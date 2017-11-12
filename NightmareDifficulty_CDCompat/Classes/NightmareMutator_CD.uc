class NightmareMutator_CD extends NightmareMutator;

function SetupCompatibilityClasses(KFGameInfo KFGI)
{
	local CD_Survival CDGame;
	
	Super.SetupCompatibilityClasses(KFGI);
	
	CDGame = CD_Survival(KFGI);
	if( CDGame == None )
		return;
	
    CDGame.SpawnManager = new(CDGame) class'KFAISpawnManager_Nightmare_CD';
    
    if( KFAISpawnManager_Nightmare_CD(CDGame.SpawnManager) != None )
        KFAISpawnManager_Nightmare_CD(CDGame.SpawnManager).ControllerMutator = self;
    
    CDGame.SpawnManager.Initialize();
}

function SetupDifficultySettings()
{
	local KFPawn_ZedCrawler_Nightmare Crawler;
	local KFPawn_ZedClot_Alpha_Nightmare Alpha;
	local KFPawn_ZedGorefast_Nightmare Gorefast;
	local KFPawn_ZedFleshpound_Nightmare Fleshpound;
	local KFPawn_ZedFleshpoundMini_Nightmare FleshpoundMini;
	local CD_Survival CDGame;
	
	Super.SetupDifficultySettings();
	
	CDGame = CD_Survival(WorldInfo.Game);
	if( CDGame == None )
		return;
	
	if( !bool(CDGame.AlbinoCrawlers) )
	{
		Crawler = KFPawn_ZedCrawler_Nightmare(FindObject("NightmareDifficulty.Default__KFPawn_ZedCrawler_Nightmare",class'KFPawn_ZedCrawler_Nightmare'));
		if( Crawler != None )
			Crawler.DifficultySettings = class'CD_DS_Crawler_Regular';
	}
	
	if( !bool(CDGame.AlbinoAlphas) )
	{
		Alpha = KFPawn_ZedClot_Alpha_Nightmare(FindObject("NightmareDifficulty.Default__KFPawn_ZedClot_Alpha_Nightmare",class'KFPawn_ZedClot_Alpha_Nightmare'));
		if( Alpha != None )
			Alpha.DifficultySettings = class'CD_DS_ClotAlpha_Regular';
	}	
	
	if( !bool(CDGame.AlbinoGorefasts) )
	{
		Gorefast = KFPawn_ZedGorefast_Nightmare(FindObject("NightmareDifficulty.Default__KFPawn_ZedGorefast_Nightmare",class'KFPawn_ZedGorefast_Nightmare'));
		if( Gorefast != None )
			Gorefast.DifficultySettings = class'CD_DS_Gorefast_Regular';
	}	
	
	if( !bool(CDGame.FleshpoundRageSpawns) )
	{
		Fleshpound = KFPawn_ZedFleshpound_Nightmare(FindObject("NightmareDifficulty.Default__KFPawn_ZedFleshpound_Nightmare",class'KFPawn_ZedFleshpound_Nightmare'));
		if( Fleshpound != None )
		{
			Fleshpound.DifficultySettings = class'CD_DS_Fleshpound_Regular';
			Fleshpound.ControllerClass = class'CD_AIController_FP_NRS';
		}
		
		FleshpoundMini = KFPawn_ZedFleshpoundMini_Nightmare(FindObject("NightmareDifficulty.Default__KFPawn_ZedFleshpoundMini_Nightmare",class'KFPawn_ZedFleshpoundMini_Nightmare'));
		if( FleshpoundMini != None )
		{
			FleshpoundMini.DifficultySettings = class'KFDifficulty_FleshpoundMini';
			FleshpoundMini.ControllerClass = class'CD_AIController_FP_NRS';
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