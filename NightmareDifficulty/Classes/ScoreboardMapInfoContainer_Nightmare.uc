class ScoreboardMapInfoContainer_Nightmare extends KFGFxHUD_ScoreboardMapInfoContainer;

function LocalizeText()
{
    local GFxObject LocalizedObject;
    local string MatchInfoString;
    local string GameDifficultyString;
    local KFGameReplicationInfo KFGRI;

	GameTypeString = class'KFCommon_LocalizedStrings'.static.GetGameModeString(0);
	KFGRI = KFGameReplicationInfo(GetPC().WorldInfo.GRI);

	if(KFGRI != none)
	{
		CurrentGameDifficulty = KFGameReplicationInfo(GetPC().WorldInfo.GRI).GameDifficulty;
		if( CurrentGameDifficulty == `DIFFICULTY_NIGHTMARE )
			GameDifficultyString = "Infernal Nightmare";
		else GameDifficultyString = class'KFCommon_LocalizedStrings'.static.GetDifficultyString(CurrentGameDifficulty);

		GameTypeString =  KFGRI.GameClass.default.GameName;
    	MatchInfoString = GameTypeString @"-" @GameDifficultyString;
	}

	LocalizedObject = CreateObject( "Object" );
	LocalizedObject.SetString("waveText", WaveString);
	LocalizedObject.SetString("mapText", class'KFCommon_LocalizedStrings'.static.GetFriendlyMapName(GetPC().WorldInfo.GetMapName(true)));
	LocalizedObject.SetString("matchInfo", MatchInfoString);
	
	SetObject("localizeText", LocalizedObject);

	bLocalized = true;
}

defaultProperties
{
}