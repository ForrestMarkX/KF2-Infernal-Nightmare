class KFPawn_ZedFleshpoundMini_Nightmare extends KFPawn_ZedFleshpoundMini;

var const array<float> XPValuesMod;

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
		CharacterMICs[0].SetTextureParameterValue('Tex2d_Mask', Texture2D'ZED_Fleshpound_TEX.ZED_Fleshpound_M_albino');
}

simulated static function float GetXPValue(byte Difficulty)
{
	return default.XPValuesMod[Difficulty];
}

defaultproperties
{
	DefaultGlowColor=(R=1,G=0.15f)
	
    XPValuesMod(0)=17
    XPValuesMod(1)=22
    XPValuesMod(2)=30
    XPValuesMod(3)=34
    XPValuesMod(4)=41
}