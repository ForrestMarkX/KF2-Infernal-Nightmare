class KFPawn_ZedSiren_Nightmare extends KFPawn_ZedSiren;

var const array<float> XPValuesMod;
var LinearColor MainGlowColor;
var transient ParticleSystemComponent EyeGlowPSCs[2];

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	
	if( WorldInfo.NetMode!=NM_DedicatedServer )
	{
		UpdateGameplayMICParams();
		
		EyeGlowPSCs[0] = WorldInfo.MyEmitterPool.SpawnEmitterMeshAttachment( ParticleSystem'ZED_Clot_EMIT.FX_Player_Zed_Buff_01', Mesh, 'FX_EYE_L', true );
		EyeGlowPSCs[1] = WorldInfo.MyEmitterPool.SpawnEmitterMeshAttachment( ParticleSystem'ZED_Clot_EMIT.FX_Player_Zed_Buff_01', Mesh, 'FX_EYE_R', true );
	}
}

simulated function UpdateGameplayMICParams()
{
	Super.UpdateGameplayMICParams();
	
	if( WorldInfo.NetMode!=NM_DedicatedServer )
	{
		CharacterMICs[0].SetVectorParameterValue('Vector_GlowColor', MainGlowColor);
		CharacterMICs[0].SetVectorParameterValue('Vector_FresnelGlowColor', MainGlowColor);
		CharacterMICs[0].SetTextureParameterValue('Tex2D_Diffuse', Texture2D'ZED_Siren_TEX.ZED_Siren_D');
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

defaultproperties
{
	MainGlowColor=(R=1,G=0.15f)
	
	XPValuesMod(0)=11
	XPValuesMod(1)=15
	XPValuesMod(2)=15
	XPValuesMod(3)=15
	XPValuesMod(4)=18
}
