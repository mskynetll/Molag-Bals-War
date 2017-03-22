Scriptname mbwAzazelTrainingQuest extends Quest Conditional

Actor Property AzazelRef Auto
Actor Property PlayerRef Auto

mbwConfigQuest Property Config Auto
mbwTrialByFire Property TrialByFireQuest Auto

int Property FirstTimeInDraugrCryptDialogue Auto Conditional
bool Property HasSetFirstTimeInDraugrCryptDialogue Auto Hidden

;1 --> "walked away" from the forced greeting 
int Property HasAbortedFirstTimeInDraugrCryptDialogue Auto Conditional

; 0 --> PC is mage
; 1 --> PC is warrior
; 2 --> PC is asassing/thief
; 3 --> PC is archer
int Property PlayerCombatStylePreference Auto Conditional

Scene Property AzazelForceGreetForFirstTimeInDraugrCrypt Auto
Scene Property AzazelForceGreetForTrailByFireCompletion Auto

Event OnInit()
	Maintenance()
EndEvent

Function Maintenance()
EndFunction

;this is called from mbwEventsDispatcherQuest (kind of 'callback')
Function OnSexAnimationEnd(string eventName, string argString, float argNum, form sender)
EndFunction

;this is called from mbwEventsDispatcherQuest (kind of 'callback')
Function OnGameTimePass(float hoursPassed)
EndFunction

;this is called from mbwEventsDispatcherQuest (kind of 'callback')
Function OnSleepEnd(float hoursPassed,bool interrupted)
EndFunction

Function OnPlayerLocationChange(Location akOldLoc, Location akNewLoc)
	if IsAzazelActiveFollower		
		StartFirstTimeInDraugrCryptIfRelevant(akNewLoc)
	endif
EndFunction

Function StartFirstTimeInDraugrCryptIfRelevant(Location akLocation)
	if akLocation != None && akLocation.HasKeyword(Config.LocTypeDraugrCrypt) && HasSetFirstTimeInDraugrCryptDialogue == false			
		HasSetFirstTimeInDraugrCryptDialogue = true
		FirstTimeInDraugrCryptDialogue = 1
		AzazelForceGreetForFirstTimeInDraugrCrypt.Start() ;start the scene with force-greet package
		AzazelRef.EvaluatePackage()
	endif	
EndFunction

Function OnPlayerKill(Actor akVictim, Location akLocation, int aiCrimeStatus, int aiRelationshipRank)
	if TrialByFireQuest.IsRunning()
		if PlayerRef.GetLevel() > akVictim.GetLevel() && IsAzazelActiveFollower
			TrialByFireQuest.CompleteAllObjectives()	
			AzazelForceGreetForTrailByFireCompletion.Start()		
			TrialByFireQuest.SetStage(10)
		endif
	endif
EndFunction

bool Property IsAzazelActiveFollower
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