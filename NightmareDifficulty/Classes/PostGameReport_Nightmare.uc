class PostGameReport_Nightmare extends KFGFxMenu_PostGameReport;

function SetSumarryInfo()
{
    local string GameDifficultyString;
    local string GameTypeString;
    local string CurrentMapName;
    local KFGameReplicationInfo KFGRI;
	local GFxObject TextObject;
	TextObject = CreateObject("Object");

	//Get match info
	CurrentMapName = GetPC().WorldInfo.GetMapName(true);	

	GameTypeString = class'KFCommon_LocalizedStrings'.static.GetGameModeString(0);

	if(GetPC().WorldInfo.GRI != none)
	{
		KFGRI = KFGameReplicationInfo(GetPC().WorldInfo.GRI);

		if( KFGRI.GameDifficulty == `DIFFICULTY_NIGHTMARE )
			GameDifficultyString = "Infernal Nightmare";
		else GameDifficultyString = class'KFCommon_LocalizedStrings'.static.GetDifficultyString(KFGRI.GameDifficulty);

		GameTypeString = KFGRI.GameClass.default.GameName;

    	TextObject.SetString("mapName", class'KFCommon_LocalizedStrings'.static.GetFriendlyMapName(CurrentMapName) );
		TextObject.SetString("typeDifficulty", GameTypeString @"-" @GameDifficultyString);
		if(KFGRI.WaveNum == KFGRI.WaveMax)
		{
			TextObject.SetString("waveTime", class'KFGFxHUD_WaveInfo'.default.BossWaveString @"-" @FormatTime(KFGRI.ElapsedTime));
		}
		else
		{
			TextObject.SetString("waveTime", WaveString @KFGRI.WaveNum $"/" $(KFGRI.WaveMax - 1) @"-" @FormatTime(KFGRI.ElapsedTime));
		}
		
		TextObject.SetString("winLost", KFGRI.bMatchVictory ? VictoryString : DefeatString);
	}
	//end get match info

	SetObject("gameSummary", TextObject);
}

defaultproperties
{
}