class MoviePlayer_Manager_Nightmare extends KFGFxMoviePlayer_Manager;

defaultproperties
{
	WidgetBindings.Remove((WidgetName="postGameMenu",WidgetClass=class'KFGFxMenu_PostGameReport'))
	WidgetBindings.Add((WidgetName="postGameMenu",WidgetClass=class'PostGameReport_Nightmare'))
	WidgetBindings.Remove((WidgetName="startMenu",WidgetClass=class'KFGFxMenu_StartGame'))
	WidgetBindings.Add((WidgetName="startMenu",WidgetClass=class'StartGame_Nightmare'))
}
