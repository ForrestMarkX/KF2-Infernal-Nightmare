class KFDT_ZEDReplacement extends KFDamageType
	abstract
	hidedropdown;

defaultproperties
{
	bNoPain=true
	bCanGib=false
	bCanObliterate=true
	bShouldSpawnBloodSplat=false
	bShouldSpawnPersistentBlood=false

	KnockdownPower=0
	StumblePower=0
	MaxObliterationGibs=1

	ObliterationHealthThreshold=0
	ObliterationDamageThreshold=1	
}