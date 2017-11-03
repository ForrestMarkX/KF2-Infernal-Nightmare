class KFPawn_ZedHusk_Nightmare extends KFPawn_ZedHusk;

var const array<float> XPValuesMod;
var LinearColor MainGlowColor;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	
	if( WorldInfo.NetMode!=NM_DedicatedServer )
		UpdateGameplayMICParams();
}

simulated function UpdateGameplayMICParams()
{
	Super.UpdateGameplayMICParams();
	
	if( WorldInfo.NetMode!=NM_DedicatedServer )
	{
		if( KFGameReplicationInfo(WorldInfo.GRI).GameDifficulty < `DIFFICULTY_NIGHTMARE )
			return;
			
		CharacterMICs[0].SetVectorParameterValue('Vector_GlowColor', MainGlowColor);
		CharacterMICs[0].SetVectorParameterValue('Vector_FresnelGlowColor', MainGlowColor);
		CharacterMICs[0].SetTextureParameterValue('Tex2D_Diffuse', Texture2D'ZED_Husk_TEX.ZED_Husk_D');
	}
}

simulated static function float GetXPValue(byte Difficulty)
{
	return default.XPValuesMod[Difficulty];
}

simulated event bool UsePlayerControlledZedSkin()
{
	local KFGameReplicationInfo GRI;
	
	GRI = KFGameReplicationInfo(WorldInfo.GRI);
	if( GRI != None )
		return GRI.GameDifficulty == `DIFFICULTY_NIGHTMARE;
		
    return false;
}

DefaultProperties
{
	MainGlowColor=(R=1,G=0.15f)
	
	XPValuesMod(0)=15
	XPValuesMod(1)=20
	XPValuesMod(2)=27
	XPValuesMod(3)=31
	XPValuesMod(4)=37
}
