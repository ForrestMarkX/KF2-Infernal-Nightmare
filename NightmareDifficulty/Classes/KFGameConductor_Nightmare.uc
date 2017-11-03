class KFGameConductor_Nightmare extends KFGameConductor;

var	    float           ParZedLifeSpan[5];
var	    float           ParZedLifeSpanSolo[5];
var()   vector2d      	TargetPerkRankRange[5];
var()   InterpCurveFloat SpawnRateModificationRangeCurve[5];
var() 	vector2d      	AIMovementSpeedModificationRange[5];
var()   int             AllowLowIntensityZedModeByDifficulty[5];

function UpdateOverallAttackCoolDowns(KFAIController KFAIC)
{
    local bool bAllowLowZedIntensity;

    if( GameDifficulty < ArrayCount(AllowLowIntensityZedModeByDifficulty) )
    {
        bAllowLowZedIntensity = (AllowLowIntensityZedModeByDifficulty[GameDifficulty] == 1);
    }
    else
    {
        bAllowLowZedIntensity = (AllowLowIntensityZedModeByDifficulty[ArrayCount(AllowLowIntensityZedModeByDifficulty) - 1] == 1);
    }

    if( !bBypassGameConductor && bAllowLowZedIntensity && !MyKFGRI.IsFinalWave() )
    {
        if( GameConductorStatus == GCS_ForceLull || OverallRankAndSkillModifier == 0 )
        {
            KFAIC.SetOverallCooldownTimer(KFAIC.LowIntensityAttackCooldown);
        }
        else
        {
            KFAIC.SetOverallCooldownTimer(0.0);
        }
    }
}

function float GetParZedLifeSpan()
{
    if( !bOnePlayerAtStart )
    {
        return ParZedLifeSpan[GameDifficulty];

    }
    else
    {
        return ParZedLifeSpanSolo[GameDifficulty];
    }
}

function UpdateOverallStatus()
{
    local float PerkRankModifier;
    local float SkillModifier;
    local float LifeSpanModifier;
    local float HighlySkilledAccuracy, LessSkilledAccuracy;
    local float HighlySkilledZedLifespan, LessSkilledZedLifespan;
    local bool bPlayerHealthLow;
    local int i;

    // Take us out of a forced lull if the time is up
    if( GameConductorStatus == GCS_ForceLull
        && `TimeSince(PlayerDeathForceLullTime) > PlayerDeathForceLullLength
        && `TimeSince(SoloPlayerSurroundedForceLullTime) > SoloPlayerSurroundedForceLullLength )
    {
        GameConductorStatus = GCS_Normal;
        `log("Forced lull completed", bLogGameConductor);
    }

    MyKFGRI.CurrentGameConductorStatus = GameConductorStatus;
    MyKFGRI.CurrentParZedLifeSpan = GetParZedLifeSpan();

	for( i = 0; i < (ArrayCount(MyKFGRI.OverallRankAndSkillModifierTracker) - 1); i++ )
	{
        MyKFGRI.OverallRankAndSkillModifierTracker[i] = MyKFGRI.OverallRankAndSkillModifierTracker[i+1];
	}

    // Bypassing making game conductor adjustments
    if( bBypassGameConductor || MyKFGRI.IsFinalWave() )
    {
        OverallRankAndSkillModifier = 0.5;
        `log("Bypassing GameConductor adjustment OverallRankAndSkillModifier = "$OverallRankAndSkillModifier, bLogGameConductor);
        MyKFGRI.OverallRankAndSkillModifierTracker[ArrayCount(MyKFGRI.OverallRankAndSkillModifierTracker) -1] = OverallRankAndSkillModifier;
        return;
    }

    // Forced lull, or most of the team dead, or single player nearly dead, so slow things down
    bPlayerHealthLow = PlayersHealthStatus < PlayersLowHealthThreshold;
    if( GameConductorStatus == GCS_ForceLull
        || (bPlayerHealthLow && (LullCooldownStartTime == 0.f || `TimeSince(LullCooldownStartTime) > LullSettings[GameDifficulty].Cooldown)) )
    {
        OverallRankAndSkillModifier = 0.0;
        `log("Players low on health PlayersHealthStatus: "$PlayersHealthStatus$" chilling things out, OverallRankAndSkillModifier= "$OverallRankAndSkillModifier, bLogGameConductor);
        MyKFGRI.OverallRankAndSkillModifierTracker[ArrayCount(MyKFGRI.OverallRankAndSkillModifierTracker) -1] = OverallRankAndSkillModifier;

        // Start the lull timer. Don't allow lulls to last too long
        if( bPlayerHealthLow && !MyKFGRI.IsTimerActive(nameOf(Timer_EndLull), self) )
        {
            MyKFGRI.SetTimer( LullSettings[GameDifficulty].MaxDuration, false, nameOf(Timer_EndLull), self );
        }

        return;
    }

    // No longer in a lull, reset duration timer
    MyKFGRI.ClearTimer( nameOf(Timer_EndLull), self );

    if( WithinRange(TargetPerkRankRange[GameDifficulty],AveragePlayerPerkRank) )
    {
        PerkRankModifier = GetRangePctByValue( TargetPerkRankRange[GameDifficulty], AveragePlayerPerkRank );
    }
    else if( AveragePlayerPerkRank < TargetPerkRankRange[GameDifficulty].X )
    {
        PerkRankModifier = 0;
    }
    else
    {
        PerkRankModifier = 1;
    }

    // Evaluate player skill if its greater than 15 seconds into the match,
    // so you have some data to go by
    if( MyKFGRI != none && MyKFGRI.ElapsedTime > 15 && AggregatePlayerSkill != 0 )
    {
        HighlySkilledAccuracy = BaseLinePlayerShootingSkill * HighlySkilledAccuracyMod;
        LessSkilledAccuracy = BaseLinePlayerShootingSkill * LessSkilledAccuracyMod;

        if( AggregatePlayerSkill > HighlySkilledAccuracy )
        {
            // Highly skilled players
            SkillModifier = Lerp(0.51,1.0, FMin(1.0,(AggregatePlayerSkill - HighlySkilledAccuracy)/((BaseLinePlayerShootingSkill * HighlySkilledAccuracyModMax) - HighlySkilledAccuracy)));
        }
        else if( AggregatePlayerSkill < LessSkilledAccuracy )
        {
            // Less skilled players
            SkillModifier = Lerp(0.49,0.0, FMax(0,(LessSkilledAccuracy - AggregatePlayerSkill)/(LessSkilledAccuracy - (BaseLinePlayerShootingSkill * LessSkilledAccuracyModMin))));
        }
        else
        {
            // Standard skilled players
            SkillModifier = 0.5;
        }
    }
    else
    {
        // Standard skilled players
        SkillModifier = 0.5;
    }

    if( RecentZedVisibleAverageLifeSpan > 0 )
    {
        HighlySkilledZedLifespan = GetParZedLifeSpan() * ZedLifeSpanHighlySkilledThreshold;
        LessSkilledZedLifespan = GetParZedLifeSpan() * ZedLifeSpanLessSkilledThreshold;

        if( RecentZedVisibleAverageLifeSpan < HighlySkilledZedLifespan )
        {
            // Highly skilled players
            LifeSpanModifier = Lerp(0.51,1.0, FMin(1.0,(HighlySkilledZedLifespan - RecentZedVisibleAverageLifeSpan)/( HighlySkilledZedLifespan - (GetParZedLifeSpan() * ZedLifeSpanHighlySkilledThresholdMin))));

        }
        else if( RecentZedVisibleAverageLifeSpan > LessSkilledZedLifespan )
        {
            // Less skilled players
            LifeSpanModifier = Lerp(0.49,0.0, FMin(1.0,(RecentZedVisibleAverageLifeSpan - LessSkilledZedLifespan)/((GetParZedLifeSpan() * ZedLifeSpanLessSkilledThresholdMax) - LessSkilledZedLifespan)));
        }
        else
        {
            // Standard skilled players
            LifeSpanModifier = 0.5;
        }
    }
    else
    {
        // Standard skilled players
        LifeSpanModifier = 0.5;
    }

    OverallRankAndSkillModifier = PerkRankModifier * PerkRankPercentOfOverallSkill + SkillModifier * AccuracyPercentOfOverallSkill + LifeSpanModifier * ZedLifeSpanPercentOfOverallSkill;
    MyKFGRI.OverallRankAndSkillModifierTracker[ArrayCount(MyKFGRI.OverallRankAndSkillModifierTracker) -1] = OverallRankAndSkillModifier;

    `log("PerkRankModifier = "$PerkRankModifier$" SkillModifier = "$SkillModifier$" LifeSpanModifier = "$LifeSpanModifier$" OverallRankAndSkillModifier= "$OverallRankAndSkillModifier$" GetParZedLifeSpan() = "$GetParZedLifeSpan(), bLogGameConductor);
}

function EvaluateSpawnRateModification()
{
    local int i;

    CurrentSpawnRateModification = EvalInterpCurveFloat(SpawnRateModificationRangeCurve[GameDifficulty], OverallRankAndSkillModifier);

    if( MyKFGRI.bGameConductorGraphingEnabled )
    {
    	for( i = 0; i < (ArrayCount(MyKFGRI.ZedSpawnRateModifierTracker) - 1); i++ )
    	{
            MyKFGRI.ZedSpawnRateModifierTracker[i] = MyKFGRI.ZedSpawnRateModifierTracker[i+1];
            MyKFGRI.ZedSpawnRateTracker[i] = MyKFGRI.ZedSpawnRateTracker[i+1];
    	}

        MyKFGRI.ZedSpawnRateModifierTracker[ArrayCount(MyKFGRI.ZedSpawnRateModifierTracker) -1] = CurrentSpawnRateModification;
        MyKFGRI.ZedSpawnRateTracker[ArrayCount(MyKFGRI.ZedSpawnRateTracker) -1] = MyKFGRI.CurrentNextSpawnTime;
    }

    `log("CurrentSpawnRateModification = "$CurrentSpawnRateModification$" MyKFGRI.ElapsedTime "$MyKFGRI.ElapsedTime, bLogGameConductor);
}

function EvaluateAIMovementSpeedModification()
{
    local float DifficultySpeedAdjustMod, BaseGroundSpeedMod;
	local KFPawn_Monster KFPM;
    local float UsedMovementSpeedPercentIncrease, UsedMovementSpeedPercentDecrease;
    local float UsedMovementSpeedPercent;
    local int i;

    if( GameDifficulty < ArrayCount(AIMovementSpeedModificationRange) )
    {
        UsedMovementSpeedPercentDecrease = AIMovementSpeedModificationRange[GameDifficulty].X;
        UsedMovementSpeedPercentIncrease = AIMovementSpeedModificationRange[GameDifficulty].Y;
    }
    else
    {
        UsedMovementSpeedPercentDecrease = AIMovementSpeedModificationRange[ArrayCount(AIMovementSpeedModificationRange) - 1].X;
        UsedMovementSpeedPercentIncrease = AIMovementSpeedModificationRange[ArrayCount(AIMovementSpeedModificationRange) - 1].Y;
    }

    // Clamp the values to reasonable settings
    UsedMovementSpeedPercentDecrease = FClamp( UsedMovementSpeedPercentDecrease, 0.0, 0.9 );
    UsedMovementSpeedPercentIncrease = FClamp( UsedMovementSpeedPercentIncrease, 0.0, 1.0 );

    BaseGroundSpeedMod = DifficultyInfo.GetAIGroundSpeedMod();

    if( OverallRankAndSkillModifier < 0.5 )
    {
        UsedMovementSpeedPercent = UsedMovementSpeedPercentDecrease;
    }
    else if( OverallRankAndSkillModifier > 0.5 )
    {
        UsedMovementSpeedPercent = UsedMovementSpeedPercentIncrease;
    }
    else
    {
        UsedMovementSpeedPercent = 0;
    }

    if( UsedMovementSpeedPercent > 0 )
    {
        if(  GameDifficulty <= 0 ) // Normal
        {
            DifficultySpeedAdjustMod = (DifficultyInfo.Hard.MovementSpeedMod - DifficultyInfo.Normal.MovementSpeedMod) * UsedMovementSpeedPercent;
        }
        else if(  GameDifficulty <= 1 ) // Hard
        {
            DifficultySpeedAdjustMod = (DifficultyInfo.Suicidal.MovementSpeedMod - DifficultyInfo.Hard.MovementSpeedMod) * UsedMovementSpeedPercent;
        }
        else  // Suicidal and HOE
        {
            DifficultySpeedAdjustMod = (DifficultyInfo.HellOnEarth.MovementSpeedMod - DifficultyInfo.Suicidal.MovementSpeedMod) * UsedMovementSpeedPercent;
        }

        if( OverallRankAndSkillModifier < 0.5 )
        {
            CurrentAIMovementSpeedMod = BaseGroundSpeedMod - (DifficultySpeedAdjustMod * (0.5 - OverallRankAndSkillModifier) * 2.0);
        }
        else if( OverallRankAndSkillModifier > 0.5 )
        {
            CurrentAIMovementSpeedMod = BaseGroundSpeedMod + (DifficultySpeedAdjustMod * (OverallRankAndSkillModifier - 0.5) * 2.0);
        }
        else
        {
            CurrentAIMovementSpeedMod = BaseGroundSpeedMod;
        }
    }
    else
    {
        CurrentAIMovementSpeedMod = BaseGroundSpeedMod;
    }

    if( MyKFGRI.bGameConductorGraphingEnabled )
    {
    	for( i = 0; i < (ArrayCount(MyKFGRI.ZedMovementSpeedModifierTracker) - 1); i++ )
    	{
            MyKFGRI.ZedMovementSpeedModifierTracker[i] = MyKFGRI.ZedMovementSpeedModifierTracker[i+1];
    	}

        MyKFGRI.ZedMovementSpeedModifierTracker[ArrayCount(MyKFGRI.ZedMovementSpeedModifierTracker) -1] = CurrentAIMovementSpeedMod;
    }

    // Adjust the speed of the currently living pawns
	foreach WorldInfo.AllPawns( class'KFPawn_Monster', KFPM )
	{
        if( KFPM.Health > 0 )
        {
            KFPM.AdjustMovementSpeed(CurrentAIMovementSpeedMod);
            `log("Adjust KFPM.default.GroundSpeed = "$KFPM.default.GroundSpeed$" CurrentAIMovementSpeedMod = "$CurrentAIMovementSpeedMod$" percent of default = "$(KFPM.default.GroundSpeed * CurrentAIMovementSpeedMod)/KFPM.default.GroundSpeed, bLogGameConductor);
        }
	}

    `log("CurrentAIMovementSpeedMod = "$CurrentAIMovementSpeedMod$" DifficultyInfo.GetAIGroundSpeedMod() = "$DifficultyInfo.GetAIGroundSpeedMod(), bLogGameConductor);
}

defaultproperties
{
    TargetPerkRankRange(`DIFFICULTY_NIGHTMARE)					  = (X=24.999,Y=25)
    SpawnRateModificationRangeCurve(`DIFFICULTY_NIGHTMARE)		  = (Points=((InVal=0.f,OutVal=0.75f),(InVal=0.5f, OutVal=1.0),(InVal=1.f, OutVal=0.5f)))
    AIMovementSpeedModificationRange(`DIFFICULTY_NIGHTMARE)   	  = (X=0.0,Y=0.0)
    AllowLowIntensityZedModeByDifficulty(`DIFFICULTY_NIGHTMARE)   = 0
    ParZedLifeSpan(`DIFFICULTY_NIGHTMARE) 						  = 14.0
    ParZedLifeSpanSolo(`DIFFICULTY_NIGHTMARE) 					  = 11.0
    LullSettings(`DIFFICULTY_NIGHTMARE) 						  = {(MaxDuration=3.0, Cooldown=20.0)} 
}