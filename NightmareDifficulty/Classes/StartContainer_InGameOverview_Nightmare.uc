class StartContainer_InGameOverview_Nightmare extends KFGFxStartContainer_InGameOverview;

function UpdateDifficulty( string Difficulty )
{
	local KFGameReplicationInfo KFGRI;

	KFGRI = KFGameReplicationInfo(GetPC().WorldInfo.GRI);
    if(KFGRI != none)
    {
		if( KFGRI.GameDifficulty == `DIFFICULTY_NIGHTMARE )
		{
			SetString("difficultyText", "Infernal Nightmare");
			return;
		}
	}
	
	SetString("difficultyText", Difficulty);
}

DefaultProperties
{
}

