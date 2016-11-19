Scriptname mbwMaintenancePlayerReference extends ReferenceAlias

mbwMainQuest Property MainQuest Auto
mbwEventsDispatcherQuest Property EventsDispatcherQuest Auto

Event OnPlayerLoadGame()
	MainQuest.Maintenance()
	EventsDispatcherQuest.Maintenance()
EndEvent