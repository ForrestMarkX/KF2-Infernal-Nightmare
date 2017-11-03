class StartGame_Nightmare extends KFGFxMenu_StartGame;

defaultproperties
{
	SubWidgetBindings.Empty
   	SubWidgetBindings.Add((WidgetName="findGameContainer",WidgetClass=class'KFGFxStartGameContainer_FindGame'))
   	SubWidgetBindings.Add((WidgetName="gameOptionsContainer",WidgetClass=class'KFGFxStartGameContainer_Options'))
   	SubWidgetBindings.Add((WidgetName="overviewContainer",WidgetClass=class'StartContainer_InGameOverview_Nightmare'))
   	SubWidgetBindings.Add((WidgetName="serverBrowserOverviewContainer",WidgetClass=class'KFGFxStartContainer_ServerBrowserOverview'))
   	SubWidgetBindings.Add((WidgetName="missionObjectivesContainerMC",WidgetClass=class'KFGFxMissionObjectivesContainer'))
   	SubWidgetBindings.Add((WidgetName="collapsedMissionObjectivesMC",WidgetClass=class'KFGFxCollapsedObjectivesContainer'))
	SubWidgetBindings.Add((WidgetName="expandedMissionObjectivesMC",WidgetClass=class'KFGFxExpandedObjectivesContainer'))
	SubWidgetBindings.Add((WidgetName="weeklyContainerMC",WidgetClass=class'KFGFxWeeklyObjectivesContainer'))
	SubWidgetBindings.Add((WidgetName="specialEventContainerMC",WidgetClass=class'KFGFxSpecialeventObjectivesContainer'))
}