class NightmareMutator extends KFMutator
	config(Nightmare);

var globalconfig int TakeHealthInterval; //How often in seconds health is taken
var globalconfig int HealthDamage; //How much health should be taken
var globalconfig int HealthLimit; //How low the player's health will go before stopping

struct ZedModInfo
{
    var float HealthMult, HeadHealthMult, SprintChanceMult;
};
var globalconfig ZedModInfo ZedModifiers; //Multipliers for zed systems

var config int ConfigVer; //Used for generating default config values

struct AIReplacementS
{
	var class<KFPawn_Monster> Original, Replacment;
	var bool bCheckChildren;
	
	structdefaultproperties
	{
		bCheckChildren=false
	}
};
var	array<AIReplacementS> AIClassList;

var SoundCue TakeHealthSound;

function PostBeginPlay()
{
	local KFGameInfo KFGI;
	local ZedModInfo DefValues;
	local int i;
	
	Super.PostBeginPlay();
	
    if( ConfigVer == 0 )
    {
		ConfigVer=1;
		TakeHealthInterval = 10;
		HealthDamage = 5;
		HealthLimit = 50;
		SaveConfig();
	}
	
	if( ConfigVer == 1 )
	{
		DefValues.HealthMult = 1.25;
		DefValues.HeadHealthMult = 1.5;
		DefValues.SprintChanceMult = 1.5;
		ZedModifiers = DefValues;
		ConfigVer=2;
		SaveConfig();
	}
	
	if( TakeHealthInterval > 0 )
		SetTimer(TakeHealthInterval, true);
	
	KFGI = KFGameInfo(WorldInfo.Game);
	if( KFGI != None )
	{
		if( KFGI.IsA('KFGameInfo_VersusSurvival') )
		{
			Destroy();
			return;
		}
		
		KFGI.DifficultyInfoClass = class'KFGameDifficulty_Nightmare';
		KFGI.GameConductorClass = class'KFGameConductor_Nightmare';
		KFGI.HUDType = class'HudWrapper_Nightmare';
		KFGI.KFGFxManagerClass = class'MoviePlayer_Manager_Nightmare';
		
		KFGI.DeathPenaltyModifiers.AddItem(0.35);
		KFGI.MaxRespawnDosh.AddItem(1000.f);
		KFGI.MaxGameDifficulty = 4;
	
		SetTimer(1, false, 'AdjustVariousSettings');
	}
	
	SetupDifficultySettings();
	
	for( i=0; AIClassList.Length < i; i++ )
	{
		AIClassList[i].Replacment.static.PreloadContent();
	}
}

function AdjustVariousSettings()
{
	local KFGameDifficulty_Nightmare KFDI;
	local KFGameInfo KFGI;
	
	KFGI = KFGameInfo(WorldInfo.Game);
	if( KFGI == None || KFGI.GameDifficulty < `DIFFICULTY_NIGHTMARE )
		return;
		
	KFGI.SpawnManager = new(KFGI) class'KFAISpawnManager_Nightmare';
	
	if( KFAISpawnManager_Nightmare(KFGI.SpawnManager) != None )
		KFAISpawnManager_Nightmare(KFGI.SpawnManager).ControllerMutator = self;
	
	KFGI.SpawnManager.Initialize();
	
	KFDI = KFGameDifficulty_Nightmare(KFGI.DifficultyInfo);
	if( KFDI != None )
	{
		if( ZedModifiers.HealthMult < 1 )
			`warn( "HealthMult is less than 1! Defaulting to 1" );
		if( ZedModifiers.HeadHealthMult < 1 )
			`warn( "HeadHealthMult is less than 1! Defaulting to 1" );
		if( ZedModifiers.SprintChanceMult < 1 )
			`warn( "SprintChanceMult is less than 1! Defaulting to 1" );
		
		KFDI.HealthMult = FMax(ZedModifiers.HealthMult, 1);
		KFDI.HeadHealthMult = FMax(ZedModifiers.HeadHealthMult, 1);
		KFDI.SprintChanceMult = FMax(ZedModifiers.SprintChanceMult, 1);
	}
}

function Timer()
{
	local KFPlayerController KFPC;
	
	if( KFGameInfo(WorldInfo.Game).bWaitingToStartMatch )
		return;
	
	foreach WorldInfo.AllControllers( class'KFPlayerController', KFPC )
	{
		if ( KFPC.Pawn != None && KFPC.Pawn.Health > HealthLimit )
		{
			KFPC.ClientPlaySound(TakeHealthSound);
			KFPC.Pawn.Health = Max(KFPC.Pawn.Health-HealthDamage,HealthLimit);
		}
	}
}

function SetupDifficultySettings()
{
	local KFDifficulty_Bloat BloatDif;
	local KFDifficulty_ClotAlpha ClotADif;
	local KFDifficulty_Crawler CrawlerDif;
	local KFDifficulty_Fleshpound FleshpoundDif;
	local KFDifficulty_Gorefast GorefastDif;
	local KFDifficulty_Husk HuskDif;
	local KFAIController_ZedFleshpound FPAI;
		
	BloatDif = KFDifficulty_Bloat(FindObject("KFGameContent.Default__KFDifficulty_Bloat",class'KFDifficulty_Bloat'));
	if( BloatDif != None )
		BloatDif.PukeMinesToSpawnOnDeathByDifficulty.AddItem(6);
		
	ClotADif = KFDifficulty_ClotAlpha(FindObject("KFGameContent.Default__KFDifficulty_ClotAlpha",class'KFDifficulty_ClotAlpha'));
	if( ClotADif != None )
		ClotADif.ChanceToSpawnAsSpecial.AddItem(ClotADif.ChanceToSpawnAsSpecial[3] * 1.5);
		
	CrawlerDif = KFDifficulty_Crawler(FindObject("KFGameContent.Default__KFDifficulty_Crawler",class'KFDifficulty_Crawler'));
	if( CrawlerDif != None )
		CrawlerDif.ChanceToSpawnAsSpecial.AddItem(CrawlerDif.ChanceToSpawnAsSpecial[3] * 1.5);
		
	FleshpoundDif = KFDifficulty_Fleshpound(FindObject("KFGameContent.Default__KFDifficulty_Fleshpound",class'KFDifficulty_Fleshpound'));
	if( FleshpoundDif != None )
		FleshpoundDif.ChanceToSpawnAsSpecial.AddItem(0.5);	
		
	GorefastDif = KFDifficulty_Gorefast(FindObject("KFGameContent.Default__KFDifficulty_Gorefast",class'KFDifficulty_Gorefast'));
	if( GorefastDif != None )
		GorefastDif.ChanceToSpawnAsSpecial.AddItem(GorefastDif.ChanceToSpawnAsSpecial[3] * 1.5);
		
	HuskDif = KFDifficulty_Husk(FindObject("KFGameContent.Default__KFDifficulty_Husk",class'KFDifficulty_Husk'));
	if( HuskDif != None )
		HuskDif.FireballSettings.AddItem(HuskDif.FireballSettings[`DIFFICULTY_HellOnEarth]);
		
	FPAI = KFAIController_ZedFleshpound(FindObject("KFGameContent.Default__KFAIController_ZedFleshpound",class'KFAIController_ZedFleshpound'));
	if( FPAI != None )
		FPAI.SpawnRagedChance.AddItem(1.0);
}

function AdjustSpawnList(out array<class<KFPawn_Monster> > SpawnList)
{
	local int i, j;
	local bool bShouldReplace;
	
	for( i=0; i<SpawnList.Length; i++ )
	{
		for( j=0; j<AIClassList.Length; j++ )
		{
			if( AIClassList[j].bCheckChildren )
				bShouldReplace = ClassIsChildOf(SpawnList[i], AIClassList[j].Original);
			else bShouldReplace = (String(SpawnList[i].Name) == String(AIClassList[j].Original.Name));
				
			if( bShouldReplace )
				SpawnList[i] = AIClassList[j].Replacment;
		}
	}
}

defaultproperties
{
	TakeHealthSound=SoundCue'NightmareMode_rc.st_takehealth_c'
	
	AIClassList.Add((Original=class'KFGameContent.KFPawn_ZedClot_Cyst', Replacment=class'NightmareDifficulty.KFPawn_ZedClot_Cyst_Nightmare'))
	AIClassList.Add((Original=class'KFGameContent.KFPawn_ZedClot_Alpha', Replacment=class'NightmareDifficulty.KFPawn_ZedClot_Alpha_Nightmare'))
	AIClassList.Add((Original=class'KFGameContent.KFPawn_ZedClot_Slasher', Replacment=class'NightmareDifficulty.KFPawn_ZedClot_Slasher_Nightmare'))
	AIClassList.Add((Original=class'KFGameContent.KFPawn_ZedCrawler', Replacment=class'NightmareDifficulty.KFPawn_ZedCrawler_Nightmare'))
	AIClassList.Add((Original=class'KFGameContent.KFPawn_ZedGorefast', Replacment=class'NightmareDifficulty.KFPawn_ZedGorefast_Nightmare'))
	AIClassList.Add((Original=class'KFGameContent.KFPawn_ZedStalker', Replacment=class'NightmareDifficulty.KFPawn_ZedStalker_Nightmare'))
	AIClassList.Add((Original=class'KFGameContent.KFPawn_ZedScrake', Replacment=class'NightmareDifficulty.KFPawn_ZedScrake_Nightmare'))
	AIClassList.Add((Original=class'KFGameContent.KFPawn_ZedFleshpound', Replacment=class'NightmareDifficulty.KFPawn_ZedFleshpound_Nightmare'))
	AIClassList.Add((Original=class'KFGameContent.KFPawn_ZedFleshpoundMini', Replacment=class'NightmareDifficulty.KFPawn_ZedFleshpoundMini_Nightmare'))
	AIClassList.Add((Original=class'KFGameContent.KFPawn_ZedFleshpoundKing', Replacment=class'NightmareDifficulty.KFPawn_ZedFleshpoundKing_Nightmare'))
	AIClassList.Add((Original=class'KFGameContent.KFPawn_ZedBloat', Replacment=class'NightmareDifficulty.KFPawn_ZedBloat_Nightmare'))
	AIClassList.Add((Original=class'KFGameContent.KFPawn_ZedSiren', Replacment=class'NightmareDifficulty.KFPawn_ZedSiren_Nightmare'))
	AIClassList.Add((Original=class'KFGameContent.KFPawn_ZedHusk', Replacment=class'NightmareDifficulty.KFPawn_ZedHusk_Nightmare'))
	AIClassList.Add((Original=class'KFGameContent.KFPawn_ZedHans', Replacment=class'NightmareDifficulty.KFPawn_ZedHans_Nightmare'))
	AIClassList.Add((Original=class'KFGameContent.KFPawn_ZedPatriarch', Replacment=class'NightmareDifficulty.KFPawn_ZedPatriarch_Nightmare'))
}