class HUD_ScoreboardWidget_Nightmare extends KFGFxHUD_ScoreboardWidget;

defaultproperties
{
    SubWidgetBindings.Remove((WidgetName="ScoreboardMapInfo",WidgetClass=class'KFGFxHUD_ScoreboardMapInfoContainer'))
    SubWidgetBindings.Add((WidgetName="ScoreboardMapInfo",WidgetClass=class'ScoreboardMapInfoContainer_Nightmare'))
}
