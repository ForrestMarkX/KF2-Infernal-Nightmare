class KFPawn_ZedFleshpoundAlpha_Nightmare extends KFPawn_ZedFleshpound_Nightmare;

var ParticleSystemComponent BurningEffect;

simulated function PostBeginPlay()
{
	local byte i;
	
	Super.PostBeginPlay();
	
	AfflictionHandler.FireFullyCharredDuration = 2.5;
	AfflictionHandler.FireCharPercentThreshhold = 0.25;
	
	for( i=0; i<DamageTypeModifiers.Length; i++ )
	{
		if( DamageTypeModifiers[i].DamageType == class'KFDT_Fire' )
		{
			DamageTypeModifiers[i].DamageScale[0] = 0.1;
			break;
		}
	}

	if( WorldInfo.NetMode!=NM_DedicatedServer )
		UpdateGameplayMICParams();
}

simulated function SetCharacterArch( KFCharacterInfoBase Info, optional bool bForce )
{
	local SkeletalMeshComponent PACAttachment;
	
	Super.SetCharacterArch(Info, bForce);
	
	// MonsterArchPath="ZED_ARCH.ZED_FleshpoundKing_Archetype" doesn't work for some reason
	PACAttachment = new(Self) class'SkeletalMeshComponent';
	if (PACAttachment != none)
	{
		ThirdPersonAttachments[0] = PACAttachment;
		PACAttachment.SetActorCollision(false, false);
		PACAttachment.SetSkeletalMesh(SkeletalMesh'ZED_Fleshpound_King_MESH.ZED_Fleshpound_King');
		PACAttachment.SetParentAnimComponent(Mesh);
		PACAttachment.SetLODParent(Mesh);
		PACAttachment.SetShadowParent(Mesh);
		PACAttachment.SetLightingChannels(PawnLightingChannel);
		
		PACAttachment.SetMaterial(0, MaterialInstanceConstant'ZED_Fleshpound_MAT.ZED_Fleshpound_Mic_albino');
		PACAttachment.CreateAndSetMaterialInstanceConstant(0);
		
		AttachComponent(PACAttachment);
	}  
}

simulated function UpdateGameplayMICParams()
{
	Super(KFPawn_ZedFleshpound).UpdateGameplayMICParams();
	
	if ( WorldInfo.NetMode != NM_DedicatedServer )
	{
		BurningEffect = new(self) class'ParticleSystemComponent';
		BurningEffect.SetTemplate( ParticleSystem'FX_Gameplay_EMIT.Chr.FX_CHR_Fire' );
		Mesh.AttachComponentToSocket( BurningEffect, 'Hips' );
		BurningEffect.ActivateSystem();
	}
}

simulated function TerminateEffectsOnDeath()
{
	Super.TerminateEffectsOnDeath();
	if( BurningEffect!=None )
		BurningEffect.SetStopSpawning( -1, true );
}

static function string GetLocalizedName()
{
	return Localize("Zeds", String(default.LocalizationKey), "Nightmare");;
}

defaultproperties
{
	LocalizationKey=KFPawn_ZedFleshpoundAlpha
	DefaultGlowColor=(R=1,G=0.5f)
	
	Health=2000
	GroundSpeed=510.f
	
	Begin Object Class=FIRE_MeleeHelper Name=FIREMeleeHelper_0
		BaseDamage=60.f
		MaxHitRange=300.f
	    MomentumTransfer=55000.f
		MyDamageType=class'KFDT_Fire_Napalm'
	End Object
	MeleeAttackHelper=FIREMeleeHelper_0
	
	Begin Object Class=KFGameExplosion Name=ExploTemplate1
		Damage=32
		DamageRadius=900
		DamageFalloffExponent=2.f
		DamageDelay=0.f

		MyDamageType=class'KFDT_Explosive_FleshpoundKingRage_Heavy'
		KnockDownStrength=0
		FractureMeshRadius=200.0
		FracturePartVel=500.0
		ExplosionEffects=KFImpactEffectInfo'ZED_Fleshpound_King_EMIT.King_Pound_Explosion_Heavy'
		ExplosionSound=AkEvent'ww_zed_fleshpound_2.Play_King_FP_Rage_Hit'

		CamShake=CameraShake'FX_CameraShake_Arch.Grenades.Default_Grenade'
		CamShakeInnerRadius=200
		CamShakeOuterRadius=900
		CamShakeFalloff=1.5f
		bOrientCameraShakeTowardsEpicenter=true
	End Object
	RagePoundExplosionTemplate=ExploTemplate1
	
	DifficultySettings=class'KFDifficulty_FleshpoundAlpha_Nightmare'
}