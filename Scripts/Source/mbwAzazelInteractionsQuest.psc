Scriptname mbwAzazelInteractionsQuest extends Quest Conditional

string Property ModVersion Auto hidden
bool Property OneTimeInitialize Auto hidden

Actor Property AzazelRef Auto
Actor Property PlayerRef Auto

mbwAzazelEquipmentRef Property AzazelEquipmentRef Auto
mbwConfigQuest Property ConfigQuest Auto
Zadlibs Property libs Auto

GlobalVariable Property mbwAzazelDisposition Auto
GlobalVariable Property mbwAzazelMood Auto

GlobalVariable Property mbwIsWearingBlindfold Auto
GlobalVariable Property mbwIsWearingHood Auto

bool Property IsPlayerAzazelsApprentice Auto Conditional

bool Property HasGreetedSecondTime Auto Conditional

int Property WornDevicesCount Auto Conditional

Location Property CurrentLocation Auto

Scene Property AzazelTakesOffBlindfoldDialogueScene Auto

Armor Property BlindfoldWornByPlayer Auto

Float Property LastTimeBlindfoldDialogueSceneFired Auto

Event OnInit()
	Maintenance()
EndEvent

Function Maintenance()
	If ModVersion == ""
		If !OneTimeInitialize
			Debug.Notification("Molag Bal's War Initializing...")
		    OneTimeInitialize = true
		EndIf
		ModVersion = "0.0.5"			
	EndIf
	If ModVersion == "0.0.5"
		ModVersion = "0.0.6"
	EndIf
	If ModVersion == "0.0.6"
		ModVersion = "0.0.7"
	EndIf
	If ModVersion == "0.0.7"
		;don't need the events anymore, using events dispatcher quest now to 
		;distribute events on all relevant quests
		UnregisterForModEvent("AnimationEnd")
		UnregisterForSleep()
		ModVersion = "0.0.8"
	EndIf
	if ModVersion == "0.0.8"
		AzazelRef.EquipItem(ConfigQuest.AzazelDefaultCuirass, false,true)
		AzazelRef.EquipItem(ConfigQuest.AzazelDefaultGloves, false,true)
		AzazelRef.EquipItem(ConfigQuest.AzazelDefaultBoots, false,true)		
		ModVersion = "0.0.9"
	endif
	Debug.Notification("Molag Bal's War running, version " + ModVersion)
EndFunction

Function OnAzazelKill(Actor akVictim, Location akLocation, int aiCrimeStatus, int aiRelationshipRank)
	if IsAzazelActiveFollower
		if akVictim.GetLevel() <= AzazelRef.GetLevel()
			ModifyMood(ConfigQuest.AzazelMoodIncreasePerKill)
		elseif Math.Abs(akVictim.GetLevel() - AzazelRef.GetLevel()) > 2
			ModifyMood(-ConfigQuest.AzazelMoodIncreasePerKill / 2.0) ;Azazel gets upset if she kills too weak enemies
		endif
	endif
EndFunction

Function OnPlayerKill(Actor akVictim, Location akLocation, int aiCrimeStatus, int aiRelationshipRank)
	if IsAzazelActiveFollower
		if akVictim.GetLevel() <= PlayerRef.GetLevel()
			ModifyMood(ConfigQuest.AzazelMoodIncreasePerPlayerKill)
		endif
	EndIf
EndFunction

;this is called from mbwEventsDispatcherQuest (kind of 'callback')
Function OnSexAnimationEnd(string eventName, string argString, float argNum, form sender)
EndFunction

;this is called from mbwEventsDispatcherQuest (kind of 'callback')
Function OnGameTimePass(float hoursPassed)
	if IsAzazelActiveFollower
		float modAmount = 0.0
		
		if CurrentLocation != None ;precaution
			if CurrentLocation.HasKeyword(ConfigQuest.LocTypeInn)
				modAmount = -1.5 * (WornDevicesCount * 1.05) ;devices are more embarrasing in the inn
				modAmount += hoursPassed ;regenerate 1% of mood when in player house
			elseif CurrentLocation.HasKeyword(ConfigQuest.LocTypePlayerHouse)
				modAmount = -0.5 * (WornDevicesCount * 1.05) ;devices are less embarrasing in player house - noone sees them
				modAmount += (hoursPassed * 2) ;regenerate 2% of mood when in player house
			elseif CurrentLocation.HasKeyword(ConfigQuest.LocTypeCity) || CurrentLocation.HasKeyword(ConfigQuest.LocTypeTown)
				modAmount = -1 * (WornDevicesCount * 1.05)
				modAmount += (hoursPassed * 0.25) ;Azazel somewhat likes to be in the civilization, and not in the wilderness :)
			else
				modAmount = -hoursPassed * ConfigQuest.AzazelMoodDecreasePerHour
				if WornDevicesCount > 0
					modAmount *= (WornDevicesCount * 1.05)
				endif			
			endif
		EndIf

		if modAmount != 0.0
		    if ConfigQuest.ConsoleDebugEnabled
	    		MiscUtil.PrintConsole("[mbw] OnGameTimePass(), modifying Azazel's mood by " + modAmount)
	    	endif
			ModifyMood(modAmount)
		endif
	endif
EndFunction

;this is called from mbwEventsDispatcherQuest (kind of 'callback')
Function OnSleepEnd(float hoursPassed,bool interrupted)
	if IsAzazelActiveFollower
		float modAmount = hoursPassed * ConfigQuest.AzazelMoodIncreasePerSleepHour
		if ConfigQuest.ConsoleDebugEnabled
	    	MiscUtil.PrintConsole("[mbw] OnSleepEnd(), modifying Azazel's mood by " + modAmount)
	    endif		
		ModifyMood(modAmount)
	endif
EndFunction

Function OnPlayerEquipOfDeviousDevice(Armor akArmor)
	if ConfigQuest.ConsoleDebugEnabled
	    MiscUtil.PrintConsole("[mbw] OnPlayerEquipOfDeviousDevice(), equipped " + akArmor)
	endif

	bool isWearingBlindfold = false
	bool isWearingHood = false

	if akArmor.HasKeyword(libs.zad_DeviousBlindfold) || akArmor.HasKeyword(libs.zad_DeviousHood)
		mbwIsWearingBlindfold.SetValue(1.0)
		BlindfoldWornByPlayer = libs.GetWornDevice(libs.playerref, libs.zad_DeviousBlindfold)
		isWearingBlindfold = true
		if akArmor.HasKeyword(libs.zad_DeviousHood)
			BlindfoldWornByPlayer = libs.GetWornDevice(libs.playerref, libs.zad_DeviousHood)
			mbwIsWearingHood.SetValue(1.0)
			isWearingHood = true
		endif
	endif

 	if IsAzazelActiveFollower && IsPlayerAzazelsApprentice && (isWearingBlindfold || isWearingHood) 
		float currentGameTime = Utility.GetCurrentGameTime()
		float hoursSinceLastDialogue = Math.Abs(currentGameTime - LastTimeBlindfoldDialogueSceneFired) * 24.0

		;fire force greet only once in 6 hours... so it won't get too annoying
		if hoursSinceLastDialogue >= 6.0 ;perhaps make it dependent on Azazel's mood?
	 		Utility.Wait(0.1)
	 		if ConfigQuest.ConsoleDebugEnabled
		    	MiscUtil.PrintConsole("[mbw] detected blindfold/hood and player is apprentice of Azazel, firing force greet of removal dialogue")
			endif

	 			 		
	 		LastTimeBlindfoldDialogueSceneFired = Utility.GetCurrentGameTime()
	 		;perhaps change conditions so only if in a good mood Azazel will take-off the device from player?
	 		AzazelTakesOffBlindfoldDialogueScene.Start()
	 	else
	 		if ConfigQuest.ConsoleDebugEnabled
		    	MiscUtil.PrintConsole("[mbw] detected blindfold/hood and player is apprentice of Azazel, but passed " + hoursSinceLastDialogue + " < 6 hours since last force greet for removal... skipping force greet.")
			endif
	 	endif
 	endif
EndFunction

Function OnPlayerUnequipOfDeviousDevice(Armor akArmor)
	if ConfigQuest.ConsoleDebugEnabled
	    MiscUtil.PrintConsole("[mbw] OnPlayerUnequipOfDeviousDevice(), unequipped " + akArmor)
	endif 	

	if akArmor.HasKeyword(libs.zad_DeviousBlindfold) || akArmor.HasKeyword(libs.zad_DeviousHood)
		BlindfoldWornByPlayer = None
		mbwIsWearingBlindfold.SetValue(0.0)
		if akArmor.HasKeyword(libs.zad_DeviousHood)
			mbwIsWearingHood.SetValue(0.0)
		endif
	endif
EndFunction

Function OnAzazelEquipOfDeviousDevice(Armor akArmor)
	if ConfigQuest.ConsoleDebugEnabled
	    MiscUtil.PrintConsole("[mbw] OnAzazelEquipOfDeviousDevice(), equipped " + akArmor)
	endif 		
 	WornDevicesCount += 1
EndFunction

Function OnAzazelUnequipOfDeviousDevice(Armor akArmor)
	if ConfigQuest.ConsoleDebugEnabled
	    MiscUtil.PrintConsole("[mbw] OnAzazelUnequipOfDeviousDevice(), unequipped " + akArmor)
	endif 	
 	WornDevicesCount -= 1
 	WornDevicesCount = mbwUtility.MaxInt(0,WornDevicesCount)
EndFunction

Function OnPlayerLocationChange(Location akOldLoc, Location akNewLoc)
	CurrentLocation = akNewLoc

	;TODO : consider adding mood changes based on location changes? perhaps newly discovered locations?
EndFunction

Function ModifyMood(float howMuch)
	mbwAzazelMood.Mod(howMuch)
	if mbwAzazelMood.GetValue() <= 0.0
		mbwAzazelMood.SetValue(0.0)
	elseif mbwAzazelMood.GetValue() > 100.0
		mbwAzazelMood.SetValue(100.0)
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