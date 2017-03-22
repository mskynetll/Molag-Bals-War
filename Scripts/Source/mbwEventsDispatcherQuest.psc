Scriptname mbwEventsDispatcherQuest extends Quest Conditional

mbwConsequencesTrackerQuest Property ConsequencesTrackerQuest Auto
mbwAzazelInteractionsQuest Property AzazelInteractionsQuest Auto
mbwAzazelTrainingQuest Property AzazelTrainingQuest Auto
mbwAzazelNeedsQuest Property AzazelNeedsQuest Auto
mbwConfigQuest Property Config Auto
bool Property IsAzazelActiveFollower Auto Conditional

Event OnInit()
	Maintenance()
EndEvent

Function Maintenance()
	UnregisterForModEvent("AnimationEnd")
	UnregisterForSleep()

	RegisterForModEvent("AnimationEnd", "OnSexAnimationEnd") 
	RegisterForSingleUpdateGameTime(Config.EventCalculationLatency)
	RegisterForSleep()

	Actor playerRef = Game.GetPlayer()

	AzazelInteractionsQuest.OnPlayerLocationChange(None, playerRef.GetCurrentLocation())
	AzazelTrainingQuest.OnPlayerLocationChange(None,playerRef.GetCurrentLocation())
EndFunction

Event OnSexAnimationEnd(string eventName, string argString, float argNum, form sender)
	AzazelNeedsQuest.OnSexAnimationEnd(eventName, argString, argNum, sender)
	AzazelInteractionsQuest.OnSexAnimationEnd(eventName, argString, argNum, sender)
	AzazelTrainingQuest.OnSexAnimationEnd(eventName, argString, argNum, sender)
	ConsequencesTrackerQuest.OnSexAnimationEnd(eventName, argString, argNum, sender)
EndEvent

Event OnSleepStart(float afSleepStartTime, float afDesiredSleepEndTime)
	LastSleepStart = afSleepStartTime
endEvent

Event OnSleepStop(bool abInterrupted)
	float hoursPassed = Math.Abs(Utility.GetCurrentGameTime() - LastSleepStart) * 24.0

	AzazelNeedsQuest.OnSleepEnd(hoursPassed,abInterrupted)
	AzazelInteractionsQuest.OnSleepEnd(hoursPassed,abInterrupted)
	AzazelTrainingQuest.OnSleepEnd(hoursPassed,abInterrupted)
	ConsequencesTrackerQuest.OnSleepEnd(hoursPassed,abInterrupted)

	if Config.ConsoleDebugEnabled
		MiscUtil.PrintConsole("[mbw]  OnSleepStop(), hoursPassed = " + hoursPassed)
	endif
endEvent

Event OnUpdateGameTime()
	float hoursPassed = Math.Abs(Utility.GetCurrentGameTime() - LastWait) * 24.0

	AzazelInteractionsQuest.OnGameTimePass(hoursPassed)
	AzazelNeedsQuest.OnGameTimePass(hoursPassed)
	AzazelTrainingQuest.OnGameTimePass(hoursPassed)
	ConsequencesTrackerQuest.OnGameTimePass(hoursPassed)

	RegisterForSingleUpdateGameTime(Config.EventCalculationLatency)
	LastWait = Utility.GetCurrentGameTime()
EndEvent

; TODO : distribute equipping/unequipping of DDs events to relevant quests
Function PlayerEquipOfDeviousDevice(Armor akArmor)
	AzazelInteractionsQuest.OnPlayerEquipOfDeviousDevice(akArmor)
EndFunction

Function PlayerUnequipOfDeviousDevice(Armor akArmor)
	AzazelInteractionsQuest.OnPlayerUnequipOfDeviousDevice(akArmor)
EndFunction

Function AzazelEquipOfDeviousDevice(Armor akArmor)
	AzazelInteractionsQuest.OnAzazelEquipOfDeviousDevice(akArmor)
EndFunction

Function AzazelUnequipOfDeviousDevice(Armor akArmor)
	AzazelInteractionsQuest.OnAzazelUnequipOfDeviousDevice(akArmor)	
EndFunction

;signaled from Actor script attached to player
Function PlayerLocationChange(Location akOldLoc, Location akNewLoc)
	if Config.ConsoleDebugEnabled
		if akOldLoc != None && akNewLoc != None	
			Debug.Notification("[mbw] Player changed location from " + akOldLoc.GetName() + " to " + akNewLoc.GetName())
			MiscUtil.PrintConsole("[mbw] Player changed location from " + akOldLoc.GetName() + " to " + akNewLoc.GetName())
		elseif akOldLoc == None && akNewLoc != None
			Debug.Notification("[mbw] Player changed location from [WILDERNESS] to " + akNewLoc.GetName())
			MiscUtil.PrintConsole("[mbw] Player changed location from [WILDERNESS] to " + akNewLoc.GetName())
		elseif akOldLoc != None && akNewLoc == None
			Debug.Notification("[mbw] Player changed location from [WILDERNESS] to " + akNewLoc.GetName())
			MiscUtil.PrintConsole("[mbw] Player changed location from [WILDERNESS] to " + akNewLoc.GetName())
		endif
	endif	
	AzazelInteractionsQuest.OnPlayerLocationChange(akOldLoc,akNewLoc)
	AzazelTrainingQuest.OnPlayerLocationChange(akOldLoc,akNewLoc)
EndFunction

Function AzazelArmorItemAdd(Armor akArmor, int count)
	
EndFunction

;aiRelationshipRank:
	;4: Lover
    ;3: Ally
    ;2: Confidant
    ;1: Friend
    ;0: Acquaintance
    ;-1: Rival
    ;-2: Foe
    ;-3: Enemy
    ;-4: Archnemesis
Function PlayerKillEvent(ObjectReference akVictim, ObjectReference akKiller, Location akLocation, int aiCrimeStatus, int aiRelationshipRank)
	if Config.ConsoleDebugEnabled
		MiscUtil.PrintConsole("[mbw] Player killed " + akVictim)
	endif	

	AzazelInteractionsQuest.OnPlayerKill(akVictim as Actor, akLocation, aiCrimeStatus, aiRelationshipRank)
	AzazelTrainingQuest.OnPlayerKill(akVictim as Actor, akLocation, aiCrimeStatus, aiRelationshipRank)
EndFunction

Function AzazelKillEvent(ObjectReference akVictim, ObjectReference akKiller, Location akLocation, int aiCrimeStatus, int aiRelationshipRank)
	if Config.ConsoleDebugEnabled
		MiscUtil.PrintConsole("[mbw] Azazel killed " + akVictim.GetName())
	endif	

	AzazelInteractionsQuest.OnAzazelKill(akVictim as Actor, akLocation, aiCrimeStatus, aiRelationshipRank)
EndFunction

Function SetAzazelActiveFollower()
	IsAzazelActiveFollower = true
	IsAzazelActiveFollowerStorage = true
EndFunction

Function SetAzazelInactiveFollower()
	IsAzazelActiveFollower = false
	IsAzazelActiveFollowerStorage = false
EndFunction

Float Property LastWait Hidden
	Float Function Get()
		return StorageUtil.GetFloatValue(None, "_mbw_LastWait", 0.0)
	EndFunction
	Function Set(Float value)
		StorageUtil.SetFloatValue(None, "_mbw_LastWait", value)
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

bool Property IsAzazelActiveFollowerStorage
	bool Function Get()				
		if StorageUtil.GetIntValue(None, "mbw_IsAzazelActiveFollower") == 1
			return true
		else
			return false
		endif 
	EndFunction
	Function Set(bool value)
		if value
			StorageUtil.SetIntValue(None, "mbw_IsAzazelActiveFollower", 1)
		else
			StorageUtil.SetIntValue(None, "mbw_IsAzazelActiveFollower", 0)
		endif
	EndFunction
EndProperty