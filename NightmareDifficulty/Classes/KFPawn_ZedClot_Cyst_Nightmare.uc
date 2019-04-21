class KFPawn_ZedClot_Cyst_Nightmare extends KFPawn_ZedClot_Cyst;

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

/*
simulated function SetCharacterArch( KFCharacterInfoBase Info, optional bool bForce )
{
	local KFCharacterInfo_Monster MonsterInfo;
	
	MonsterInfo = KFCharacterInfo_Monster(Info);
	if( MonsterInfo != None )
	{
		MonsterInfo.Skins[0] = MaterialInstanceConstant'ZED_Clot_MAT.ZED_Clot_M_albino';
		MonsterInfo.GoreSkins[0] = MaterialInstanceConstant'ZED_Clot_MAT.ZED_Clot_Gore_M_albino';
	}
	
	Super.SetCharacterArch(Info, bForce);
}

simulated function UpdateGameplayMICParams()
{
	Super.UpdateGameplayMICParams();
	
	if( WorldInfo.NetMode!=NM_DedicatedServer )
	{
		CharacterMICs[0].SetVectorParameterValue('Vector_GlowColor', MainGlowColor);
		CharacterMICs[0].SetVectorParameterValue('Vector_FresnelGlowColor', MainGlowColor);
		CharacterMICs[0].SetTextureParameterValue('Tex2D_Diffuse', Texture2D'ZED_UndevelopedClot_TEX.ZED_UndevelopedClot_D');
		CharacterMICs[0].SetTextureParameterValue('Tex2D_Normal', Texture2D'ZED_UndevelopedClot_TEX.ZED_UndevelopedClot_N');
		CharacterMICs[0].SetTextureParameterValue('Tex2D_Specular', Texture2D'ZED_UndevelopedClot_TEX.ZED_UndevelopedClot_S');
		CharacterMICs[0].SetTextureParameterValue('Tex2D_SSS_Mask', Texture2D'ZED_UndevelopedClot_TEX.ZED_UndevelopedClot_SSS');
	}
}
*/

simulated static function float GetXPValue(byte Difficulty)
{
	return default.XPValuesMod[Difficulty];
}

defaultproperties
{
	MainGlowColor=(R=1,G=0.15f)
	
	XPValuesMod(0)=8
	XPValuesMod(1)=11
	XPValuesMod(2)=11
	XPValuesMod(3)=11
	XPValuesMod(4)=13
}