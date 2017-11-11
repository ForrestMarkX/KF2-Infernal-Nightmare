class KFPawn_ZedClot_AlphaKing_Nightmare extends KFPawn_ZedClot_AlphaKing;

var const array<float> XPValuesMod;
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

simulated function UpdateGameplayMICParams()
{
	local LinearColor C;
	
	Super.UpdateGameplayMICParams();
	
	if ( WorldInfo.NetMode != NM_DedicatedServer )
	{
		C.R = 1;
		C.G = 0.5;
		C.B = 0;
		C.A = 1;
		
		CharacterMICs[0].SetVectorParameterValue('Vector_GlowColor', C);
		CharacterMICs[0].SetVectorParameterValue('Vector_FresnelGlowColor', C);
		
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

simulated static function float GetXPValue(byte Difficulty)
{
	return default.XPValuesMod[Difficulty];
}

defaultproperties
{
	Begin Object Class=FIRE_MeleeHelper Name=FIREMeleeHelper_0
		BaseDamage=6.f
		MaxHitRange=172.f
		MomentumTransfer=25000.f
	End Object
	MeleeAttackHelper=FIREMeleeHelper_0
	
	XPValuesMod(0)=8
	XPValuesMod(1)=11
	XPValuesMod(2)=11
	XPValuesMod(3)=11
	XPValuesMod(4)=13
	
	DifficultySettings=class'KFDifficulty_ClotAlphaKing_Nightmare'
}