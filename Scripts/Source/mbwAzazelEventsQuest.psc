Scriptname mbwAzazelEventsQuest Extends mbwQuestBase

GlobalVariable Property AzazelHunger Auto
GlobalVariable Property AzazelSleep Auto
GlobalVariable Property AzazelThirst Auto

Actor Property AzazelRef Auto
Actor Property PlayerRef Auto
Spell Property ChameleonSpell Auto

Keyword Property zad_GagKeyword Auto
Keyword Property LocSetNordicRuin Auto
Keyword Property LocSetDwemerRuin Auto

Scene Property ForceGreetNordicRuinFirstTime Auto
bool Property HasBeeinInNordicRuin Auto Hidden

;TODO : finish force greet of dwemer ruins as well
;Scene Property ForceGreetDwemerRuinFirstTime Auto

Event OnInit()
	Maintenance()
EndEvent

Function Maintenance()
EndFunction

Function OnTimePassed(float hoursPassed, bool wasSleeping)
	Log("OnTimePassed, " + hoursPassed + " hours passed, wasSleeping = " + wasSleeping)
	AdjustNeedsIfNeeded(hoursPassed,wasSleeping)
	;if hoursPassed >= 1.0 && PlayerRef.WornHasKeyword(zad_GagKeyword)
	;	AzazelRef.EvaluatePackage() ;if mood good enough, force greet to remove gag
	;endif
EndFunction

Function OnLocationChange(Location akOldLoc, Location akNewLoc)
	if AzazelRef.IsSneaking()
		;reapply chameleon when going through locations, since it may dispell it (interior -> exterior mostly)
		Log("OnLocationChange(), reapplying Azazel's chameleon")
		AzazelRef.AddSpell(ChameleonSpell, false)
		ChameleonSpell.Cast(AzazelRef)
	endif
	if akNewLoc.HasKeyword(LocSetNordicRuin) && !HasBeeinInNordicRuin
		Log("Starting first time force greet for nordic ruin")
		ForceGreetNordicRuinFirstTime.ForceStart()
		HasBeeinInNordicRuin = true
	endif
EndFunction


Function OnSneakStart()
	MiscUtil.PrintConsole("Azazel starts sneaking")
EndFunction

Function OnSneakEnd()
	MiscUtil.PrintConsole("Azazel stops sneaking")
	AzazelRef.AddSpell(ChameleonSpell, false)
	ChameleonSpell.Cast(AzazelRef)
EndFunction

Function AdjustNeedsIfNeeded(float hoursPassed, bool wasSleeping)
	If wasSleeping
		AzazelSleep.Mod(-Config.AzazelSleepDecreasePerHour * hoursPassed)

		;during sleep, hunger and thirst increase less
		AzazelHunger.Mod(Config.AzazelHungerIncreasePerHour * hoursPassed * 0.5)
		AzazelThirst.Mod(Config.AzazelThirstIncreasePerHour * hoursPassed * 0.75)
	else
		AzazelSleep.Mod(Config.AzazelSleepIncreasePerHour * hoursPassed)
		AzazelHunger.Mod(Config.AzazelHungerIncreasePerHour * hoursPassed)
		AzazelThirst.Mod(Config.AzazelThirstIncreasePerHour * hoursPassed)
	endif

	mbwUtility.LimitValue(AzazelHunger,0.0,100.0)
	mbwUtility.LimitValue(AzazelThirst,0.0,100.0)
	mbwUtility.LimitValue(AzazelSleep,0.0,100.0)

	if(Config.LogLevel > 0)
		Log("Azazel needs adjusted after " + hoursPassed + " hours. Hunger=" + AzazelHunger.GetValue() + "%, Thirst=" + AzazelThirst.GetValue() + "%,Sleep=" + AzazelSleep.GetValue() + "%")
	endif
EndFunction