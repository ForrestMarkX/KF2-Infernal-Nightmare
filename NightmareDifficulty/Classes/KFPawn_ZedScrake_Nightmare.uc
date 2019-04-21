class KFPawn_ZedScrake_Nightmare extends KFPawn_ZedScrake;

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
		CharacterMICs[0].SetTextureParameterValue('Tex2D_Diffuse', Texture2D'ZED_Scrake_TEX.ZED_Scrake_D');
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
	GroundSpeed=480.f
	DamageTypeModifiers.Add((DamageType=class'KFDT_Explosive_FleshpoundKingRage_Heavy', DamageScale=(0)))
	
	MainGlowColor=(R=1,G=0.15f)
	
	XPValuesMod(0)=34
	XPValuesMod(1)=45
	XPValuesMod(2)=60
	XPValuesMod(3)=69
	XPValuesMod(4)=83
}
