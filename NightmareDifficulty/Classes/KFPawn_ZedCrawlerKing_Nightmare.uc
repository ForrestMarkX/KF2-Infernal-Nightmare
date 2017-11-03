class KFPawn_ZedCrawlerKing_Nightmare extends KFPawn_ZedCrawlerKing;

var const array<float> XPValuesMod;
var ParticleSystemComponent BurningEffect;
var(Weapon) instanced FIRE_MeleeHelper FireAttackHelper;

simulated function PostBeginPlay()
{
	local byte i;
	
	Super.PostBeginPlay();
	
	if( KFGameReplicationInfo(WorldInfo.GRI).GameDifficulty >= `DIFFICULTY_NIGHTMARE )
	{
		MeleeAttackHelper = FireAttackHelper;
		
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
	}

	if( WorldInfo.NetMode!=NM_DedicatedServer )
		UpdateGameplayMICParams();
}

simulated function UpdateGameplayMICParams()
{
	local LinearColor C;
	
	Super.UpdateGameplayMICParams();
	
	if( KFGameReplicationInfo(WorldInfo.GRI).GameDifficulty < `DIFFICULTY_NIGHTMARE )
		return;
	
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
		BaseDamage=7.f
		MaxHitRange=180.f
		MomentumTransfer=25000.f
	End Object
	FireAttackHelper=FIREMeleeHelper_0
	
	XPValuesMod(0)=8
	XPValuesMod(1)=10
	XPValuesMod(2)=10
	XPValuesMod(3)=10
	XPValuesMod(4)=12
}