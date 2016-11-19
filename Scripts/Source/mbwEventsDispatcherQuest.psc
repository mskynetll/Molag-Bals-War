Scriptname mbwEventsDispatcherQuest extends mbwQuestBase

Actor Property AzazelRef Auto
Actor Property PlayerRef Auto
mbwAzazelEventsQuest Property AzazelEventsQuest Auto
mbwMainQuest Property MainQuest Auto

Event OnInit()
	Maintenance()
EndEvent

Function Maintenance()
	RegisterForSleep()
	RegisterForSingleUpdateGameTime(1.0)
EndFunction

Event OnUpdateGameTime()
	float currentTime = Utility.GetCurrentGameTime()
	float hoursPassed = Math.abs(LastGameTimeUpdate - currentTime) * 24.0
	LastGameTimeUpdate = currentTime

	AzazelEventsQuest.OnTimePassed(hoursPassed, false)

	RegisterForSingleUpdateGameTime(1.0)
EndEvent

Function OnSneakStart(Actor akActor)
	If AzazelRef == akActor		
		MiscUtil.PrintConsole("Received OnSneakStart for Azazel")
		AzazelEventsQuest.OnSneakStart()
	EndIf
	If PlayerRef == akActor
		MiscUtil.PrintConsole("Received OnSneakStart for Player")
		MainQuest.OnPlayerSneakStart()
	EndIf
EndFunction

Function OnSneakEnd(Actor akActor)
	If AzazelRef == akActor
		MiscUtil.PrintConsole("Received OnSneakEnd for Azazel")
		AzazelEventsQuest.OnSneakEnd()
	EndIf
	If PlayerRef == akActor
		MiscUtil.PrintConsole("Received OnSneakEnd for Player")
		MainQuest.OnPlayerSneakEnd()
	EndIf
EndFunction

Event OnSleepStart(float afSleepStartTime, float afDesiredSleepEndTime)
	LastSleepStart = Utility.GetCurrentGameTime()
EndEvent

Event OnSleepStop(bool abInterrupted)
	float currentTime = Utility.GetCurrentGameTime()
	float hoursSlept = Math.abs(LastSleepStart - currentTime) * 24.0
	AzazelEventsQuest.OnTimePassed(hoursSlept, true)
EndEvent

Float Property LastGameTimeUpdate Hidden
	Float Function Get()
		return StorageUtil.GetFloatValue(None, "_mbw_LastGameTimeUpdate", 0.0)
	EndFunction
	Function Set(Float value)
		StorageUtil.SetFloatValue(None, "_mbw_LastGameTimeUpdate", value)
	EndFunction
EndProperty

Float Property LastSleepStart Hidden
	Float Function Get()
		return StorageUtil.GetFloatValue(None, "_mbw_LastSleepStart", 0.0)
	EndFunction
	Function Set(Float value)
		StorageUtil.SetFloatValue(None, "_mbw_LastSleepStart", value)
	EndFunction
EndProperty

