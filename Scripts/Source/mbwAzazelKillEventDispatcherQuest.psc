Scriptname mbwAzazelKillEventDispatcherQuest extends Quest

mbwConfigQuest Property Config Auto
mbwEventsDispatcherQuest Property EventsDispatcherQuest Auto

Event OnStoryKillActor(ObjectReference akVictim, ObjectReference akKiller, Location akLocation, int aiCrimeStatus, \
  int aiRelationshipRank)	
	if Config.ConsoleDebugEnabled
		if aiCrimeStatus
			MiscUtil.PrintConsole(akKiller + " killed " + akVictim + " and it was reported!")
		else
			MiscUtil.PrintConsole(akKiller + " killed " + akVictim)
		endIf
	endif

	EventsDispatcherQuest.AzazelKillEvent(akVictim, akKiller, akLocation, aiCrimeStatus, aiRelationshipRank)
	Stop()
endEvent