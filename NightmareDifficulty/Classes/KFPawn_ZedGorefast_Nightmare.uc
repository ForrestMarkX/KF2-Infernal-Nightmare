class KFPawn_ZedGorefast_Nightmare extends KFPawn_ZedGorefast;

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
		CharacterMICs[0].SetTextureParameterValue('Tex2D_Diffuse', Texture2D'ZED_Gorefast_TEX.ZED_Gorefast_D');
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
	
	XPValuesMod(0)=11
	XPValuesMod(1)=14
	XPValuesMod(2)=14
	XPValuesMod(3)=14
	XPValuesMod(4)=17
	
	ElitePawnClass=class'KFPawn_ZedGorefastDualBlade_Nightmare'
}
