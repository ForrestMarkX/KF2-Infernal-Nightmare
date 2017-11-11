class KFPawn_ZedFleshpound_Nightmare extends KFPawn_ZedFleshpound;

var KFGameExplosion RagePoundExplosionTemplate;
var const array<float> XPValuesMod;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	
	// This is here to make 100% sure that the animinfo gets changed
	PawnAnimInfo = KFPawnAnimInfo'ZED_Fleshpound_ANIM.King_Fleshpound_AnimGroup';
	
	if( WorldInfo.NetMode!=NM_DedicatedServer )
		UpdateGameplayMICParams();
}

simulated function UpdateGameplayMICParams()
{
	Super.UpdateGameplayMICParams();
	
	if( WorldInfo.NetMode!=NM_DedicatedServer )
		CharacterMICs[0].SetTextureParameterValue('Tex2D_Diffuse', Texture2D'ZED_Fleshpound_TEX.ZED_Fleshpound_D');
}

simulated function ANIMNOTIFY_RagePoundLeft()
{
	local vector ExploLocation;
	
	Mesh.GetSocketWorldLocationAndRotation( 'FX_Root', ExploLocation );
	TriggerRagePoundExplosion(ExploLocation);
}

simulated function ANIMNOTIFY_RagePoundRight()
{
	local vector ExploLocation;

	Mesh.GetSocketWorldLocationAndRotation( 'FX_Root', ExploLocation );
	TriggerRagePoundExplosion(ExploLocation);
}

simulated function ANIMNOTIFY_RagePoundRightFinal()
{
	local vector ExploLocation;

	Mesh.GetSocketWorldLocationAndRotation( 'FX_Root', ExploLocation );
	TriggerRagePoundExplosion(ExploLocation);
}

simulated function TriggerRagePoundExplosion( vector ExploLocation )
{
	local KFExplosionActor ExploActor;

	// Boom
	ExploActor = Spawn( class'KFExplosionActor', self,, ExploLocation );
	ExploActor.InstigatorController = Controller;
	ExploActor.Instigator = self;
	ExploActor.Explode( RagePoundExplosionTemplate, vect(0,0,1) );
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
	XPValuesMod(0)=35
	XPValuesMod(1)=47
	XPValuesMod(2)=63
	XPValuesMod(3)=72
	XPValuesMod(4)=86
	
	DefaultGlowColor=(R=1,G=0.15f)
	
	DamageTypeModifiers.Add((DamageType=class'KFDT_Explosive_FleshpoundKingRage_Heavy', DamageScale=(0)))
	
	Begin Object Class=KFGameExplosion Name=ExploTemplate1
		Damage=30
		DamageRadius=500
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
	
	PawnAnimInfo=KFPawnAnimInfo'ZED_Fleshpound_ANIM.King_Fleshpound_AnimGroup'
	
	ElitePawnClass=class'KFPawn_ZedFleshpoundAlpha_Nightmare'
}