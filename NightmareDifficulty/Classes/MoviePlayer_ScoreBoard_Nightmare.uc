class MoviePlayer_ScoreBoard_Nightmare extends KFGFxMoviePlayer_ScoreBoard;

DefaultProperties
{
	WidgetBindings.Remove((WidgetName="ScoreboardWidgetMC",WidgetClass=class'KFGFxHUD_ScoreboardWidget'))
	WidgetBindings.Add((WidgetName="ScoreboardWidgetMC",WidgetClass=class'HUD_ScoreboardWidget_Nightmare'))
}