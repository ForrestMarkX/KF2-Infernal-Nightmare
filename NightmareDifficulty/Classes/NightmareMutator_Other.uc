class NightmareMutator_Other extends NightmareMutator;

var bool bSpawnedBoss;

function bool ReplaceZEDType(KFPawn_Monster Monster)
{
    local int i;
    local bool bShouldReplace;
	local KFPawn_Monster Z;
	local KFAIController KFAI;
	
	if( bSpawnedBoss && Monster.static.IsABoss() )
		return false;
    
	for( i=0; i<AIClassList.Length; i++ )
	{
		if( AIClassList[i].Replacment == None || AIClassList[i].Original == None )
			continue;
			
		if( AIClassList[i].bCheckChildren )
			bShouldReplace = ClassIsChildOf(Monster.Class, AIClassList[i].Original);
		else bShouldReplace = (String(Monster.Class.Name) == String(AIClassList[i].Original.Name));
			
		if( bShouldReplace )
		{
			Z = Spawn(AIClassList[i].Replacment,Monster.Owner,,Monster.Location,Monster.Rotation,,true);
			if (Z != None)
			{
				if( Monster.static.IsABoss() )
				{
					Monster.Destroy();
					bSpawnedBoss = true;
				}
				else
				{
					Monster.TakeRadiusDamage( none, 100000, 1000, class'KFDT_ZEDReplacement', 1, Monster.Location, true, none );
					KFGameReplicationInfo(WorldInfo.GRI).AIRemaining += 1;
				}
				
				Z.Controller = Spawn(Z.ControllerClass);
				
				KFAI = KFAIController(Z.Controller);
				if( KFAI != None )
				{
					KFAI.Possess(Z, false);
					KFAI.SetTeam(1);
					KFGameInfo(WorldInfo.Game).GetAIDirector().AIList.AddItem(KFAI);
				}
			}
			
			return Z != None;
		}
	}
	
	return true;
}

function bool CheckReplacement(Actor Other)
{
	if( Other.IsA('KFPawn_Monster') )
		return ReplaceZEDType(KFPawn_Monster(Other));
	else return Super.CheckReplacement(Other);
}

//This could be avoided if TWI didn't slap const and protected on the fucking AIClassList var in the GameInfo class
/*
function Tick(float DT)
{
	Super.Tick(DT);

	if( !KFGameReplicationInfo(WorldInfo.GRI).IsBossWave() && bSpawnedBoss )
		bSpawnedBoss = false;
}
*/

function SetupCompatibilityClasses(KFGameInfo KFGI);

defaultproperties
{
}