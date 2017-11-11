class KFPawn_ZedClot_Alpha_Nightmare extends KFPawn_ZedClot_Alpha;

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
		CharacterMICs[0].SetVectorParameterValue('Vector_GlowColor', MainGlowColor);
		CharacterMICs[0].SetVectorParameterValue('Vector_FresnelGlowColor', MainGlowColor);
		CharacterMICs[0].SetTextureParameterValue('Tex2D_Diffuse', Texture2D'ZED_Clot_TEX.ZED_Clot_D');
	}
}

simulated static function float GetXPValue(byte Difficulty)
{
	return default.XPValuesMod[Difficulty];
}

simulated event bool UsePlayerControlledZedSkin()
{
    return true;
}

DefaultProperties
{
	MainGlowColor=(R=1,G=0.15f)

	XPValuesMod(0)=8
	XPValuesMod(1)=11
	XPValuesMod(2)=11
	XPValuesMod(3)=11
	XPValuesMod(4)=13
	
	ElitePawnClass=class'KFPawn_ZedClot_AlphaKing_Nightmare'
}
