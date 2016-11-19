Scriptname mbwMainQuest Extends mbwQuestBase

string Property ModVersion Auto hidden
bool Property OneTimeInitialize Auto hidden

Actor Property AzazelRef Auto
Actor Property PlayerRef Auto
mbwAzazelEventsQuest Property AzazelEventsQuest Auto
zadLibs Property libs Auto
bool Property HasInitializedOutfit Auto hidden

Event OnInit()
	Maintenance()
EndEvent

Function Maintenance()
	If ModVersion == ""
		If !OneTimeInitialize
			Debug.Notification("Molag Bal's War Initializing...")
			AzazelRef.Disable() ;enable Azazel only when initial force greet is spoken
		    OneTimeInitialize = true
		EndIf
		ModVersion = "0.0.1"	
	EndIf
	If ModVersion == "0.0.1"
		Config.LogLevel = 3 ;very minor adjustment
		ModVersion = "0.0.2"
	EndIf
	If ModVersion == "0.0.2"
		AzazelRef.Enable() ;revert the disable in previous version
		ModVersion = "0.0.3"
	EndIf
	If ModVersion == "0.0.3"
		if !HasInitializedOutfit
			AzazelREF.AddItem(Config.AzazelDefaultCuirass, 1, true)
			Utility.Wait(0.25)
			AzazelREF.AddItem(Config.AzazelDefaultGloves, 1, true)
			Utility.Wait(0.25)
			AzazelREF.AddItem(Config.AzazelDefaultBoots, 1, true)
			Utility.Wait(0.25)

			Log("Initialized default Azazel's outfit")
        	HasInitializedOutfit = true
     	endif
		ModVersion = "0.0.4"
	EndIf
	libs.AddToDisableDialogueFaction(AzazelREF)
	if PlayerRef == None
		PlayerRef = Game.GetPlayer()
	EndIf
	AzazelRef.AddSpell(AzazelEventsQuest.ChameleonSpell, false)
	AzazelEventsQuest.ChameleonSpell.Cast(AzazelRef)
	Debug.Notification("Current Molag Bal's War version = " + ModVersion)
EndFunction

Function OnPlayerSneakStart()
	Log("Player started sneaking..")
EndFunction


Function OnPlayerSneakEnd()
	Log("Player stopped sneaking..")
EndFunction