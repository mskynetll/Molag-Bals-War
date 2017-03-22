Scriptname mbwPlayerMaintenanceRef extends ReferenceAlias

mbwAzazelInteractionsQuest Property AzazelInteractionsQuest Auto
mbwConsequencesTrackerQuest Property ConsequencesTrackerQuest Auto
mbwAzazelTrainingQuest Property AzazelTrainingQuest Auto
mbwAzazelNeedsQuest Property AzazelNeedsQuest Auto
mbwEventsDispatcherQuest Property EventsDispatcherQuest Auto

Event OnPlayerLoadGame()
	AzazelInteractionsQuest.Maintenance()
	ConsequencesTrackerQuest.Maintenance()
	AzazelTrainingQuest.Maintenance()
	AzazelNeedsQuest.Maintenance()
	EventsDispatcherQuest.Maintenance()
EndEvent