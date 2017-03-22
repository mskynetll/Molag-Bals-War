Scriptname mbwConfigQuest extends SKI_ConfigBase

Event OnConfigInit()
	Pages = new String[4]
	Pages[0] = "Feature Settings"
	Pages[1] = "Azazel Settings"
	Pages[2] = "Azazel Interactions"
	Pages[3] = "Debug"	
EndEvent

Actor Property Azazel Auto
int Property MaxOutfitItems = 10 autoReadOnly hidden
string Property WornOutfitPropertyName = "mbwAzazelOutfitProperty" autoReadOnly hidden
string Property TakenoffOutfitPropertyName = "mbwAzazelTakenoffOutfitProperty" autoReadOnly hidden

Armor Property AzazelDefaultCuirass Auto
Armor Property AzazelDefaultGloves Auto
Armor Property AzazelDefaultBoots Auto

mbwAzazelInteractionsQuest Property AzazelInteractionsQuest Auto
mbwConsequencesTrackerQuest Property ConsequencesTrackerQuest Auto
mbwAzazelTrainingQuest Property AzazelTrainingQuest Auto
mbwAzazelNeedsQuest Property AzazelNeedsQuest Auto
mbwEventsDispatcherQuest Property EventsDispatcherQuest Auto

Function FixEvents()
	AzazelInteractionsQuest.Maintenance()
	ConsequencesTrackerQuest.Maintenance()
	AzazelTrainingQuest.Maintenance()
	AzazelNeedsQuest.Maintenance()

;always initialize EventsDispatcherQuest last because it "wires" all other quests together
	EventsDispatcherQuest.Maintenance()
EndFunction

event OnPageReset(string page)
    {Called when a new page is selected, including the initial empty page}
    	SetCursorFillMode(TOP_TO_BOTTOM) 
	If (page == "Feature Settings")
		SetCursorPosition(0)
		AddHeaderOption("Consequences")
		AddSliderOptionST("Consequences_TraumaDecreaseThresholdInHours_SliderId", "Rape Trauma Decrease", LogLevel, "{0}")

		AddHeaderOption("Optional Mods")
		Form drinkWaterEffect = Game.GetFormFromFile(0x0900FB9F, "RealisticNeedsandDiseases.esp")
		bool hasDetectedRND = drinkWaterEffect != None

		AddToggleOption("Realistic Needs And Diseases", hasDetectedRND, 1)
		;AddToggleOption("test, to remove:drinkWaterEffect is magiceffect", (drinkWaterEffect as magiceffect) != None, 1)
	endif
	If (page == "Azazel Settings")
		SetCursorPosition(0)		
		AddSliderOptionST("AzazelMoodDecreasePerHour_SliderId", "Natural Mood Decrease", AzazelMoodDecreasePerHour, "{0}% per hour")
		AddSliderOptionST("AzazelMoodIncreasePerKill_SliderId", "Mood Increase (per Azazel's kill)", AzazelMoodIncreasePerKill, "{0}%")
		AddSliderOptionST("AzazelMoodIncreasePerPlayerKill_SliderId", "Mood Increase (per PC's kill)", AzazelMoodIncreasePerPlayerKill, "{0}%")	
	endif
	If (page == "Azazel Interactions")
		SetCursorPosition(0)		
		AddToggleOptionST("AzazelNeedsEnabled_ToggleId", "Needs Enabled", AzazelNeedsEnabled)
		;
		int needsControlsEnabled = 1
		if AzazelNeedsEnabled
			needsControlsEnabled = 0
		endif
		AddToggleOptionST("AzazelResetNeeds_ToggleId", "Reset Needs", false, needsControlsEnabled)
		AddSliderOptionST("AzazelHungerIncreasePerHour_SliderId", "Hunger Increase", AzazelHungerIncreasePerHour, "{0}% per hour", needsControlsEnabled)
		AddSliderOptionST("AzazelThirstIncreasePerHour_SliderId", "Thrist Increase", AzazelThirstIncreasePerHour, "{0}% per hour", needsControlsEnabled)
		AddSliderOptionST("AzazelSleepIncreasePerHour_SliderId", "Sleep Increase", AzazelSleepIncreasePerHour, "{0}% per hour", needsControlsEnabled)
		AddSliderOptionST("AzazelSleepDecreasePerHour_SliderId", "Sleep Decrease", AzazelSleepDecreasePerHour, "{0}% per hour", needsControlsEnabled)			
        
		AddHeaderOption("Current Values")
		AddTextOption("Hunger", AzazelNeedsQuest.mbwAzazelHunger.GetValue(), 1)
		AddTextOption("Thirst", AzazelNeedsQuest.mbwAzazelThirst.GetValue(), 1)
		AddTextOption("Sleep", AzazelNeedsQuest.mbwAzazelSleep.GetValue(), 1)
	endif
	If (page == "Debug")
		SetCursorPosition(0)
		AddHeaderOption("Misc")
		AddToggleOptionST("ConsoleDebugEnabled_ToggleId", "Debug Console Messages", ConsoleDebugEnabled)
		AddSliderOptionST("Debug_LogLevel_SliderId", "Log Severity", LogLevel, "{0}")
		AddToggleOptionST("FixEvents_ToggleId", "Fix Events", false)
		AddToggleOptionST("AddAzazelDefaultArmor_ToggleId", "Add Default Armor to Azazel", false)

		AddHeaderOption("Private State Variables")
		AddTextOption("IsAzazelActiveFollower", IsAzazelActiveFollower,1)
	endif
endEvent



State Debug_LogLevel_SliderId
	Event OnSliderOpenST()
		SetSliderDialogStartValue(LogLevel)
		SetSliderDialogDefaultValue(1)
		SetSliderDialogRange(0, 3)
		SetSliderDialogInterval(1)
	EndEvent
	
	Event OnSliderAcceptST(Float a_value)
		LogLevel = a_value as Int
		if LogLevel == 0
			SetSliderOptionValueST(LogLevel, "{0}")
		endif
		if LogLevel == 3
			SetSliderOptionValueST(LogLevel, "{0}")
		endif
		if LogLevel == 2
			SetSliderOptionValueST(LogLevel, "{0}")
		endif
		if LogLevel == 1
			SetSliderOptionValueST(LogLevel, "{0} - turned off")
		endif
	EndEvent
	
	Event OnDefaultST()
		LogLevel = 1
		SetSliderOptionValueST(LogLevel, "{0} - turned off")
	EndEvent
	
	Event OnHighlightST()
		SetInfoText("Set logging severity.")
	EndEvent
EndState


int Property LogLevel Hidden 
	int Function Get()
		return StorageUtil.GetIntValue(None, "mbw_LogLevel", 1)
	EndFunction
	Function Set(int value)
		StorageUtil.SetIntValue(None, "mbw_LogLevel", value)
	EndFunction
EndProperty

Float Property EventCalculationLatency Hidden 
	Float Function Get()
		return StorageUtil.GetFloatValue(None, "mbw_EventCalculationLatency", 1.0)
	EndFunction
	Function Set(Float value)
		StorageUtil.SetFloatValue(None, "mbw_EventCalculationLatency", value)
	EndFunction
EndProperty

state AddAzazelDefaultArmor_ToggleId
	event OnSelectST()
		Azazel.AddItem(AzazelDefaultCuirass, 1, true)
		Azazel.AddItem(AzazelDefaultGloves, 1, true)
		Azazel.AddItem(AzazelDefaultBoots, 1, true)
		Debug.MessageBox("Added Azazel's default armor to her inventory.")
	endEvent

	event OnDefaultST()
		SetToggleOptionValueST(true)
	endEvent

	event OnHighlightST()
		SetInfoText("Add default armor to Azazel's inventory")
	endEvent	
endState

bool Property ConsoleDebugEnabled Auto

state ConsoleDebugEnabled_ToggleId
	event OnSelectST()
		ConsoleDebugEnabled = !ConsoleDebugEnabled
		SetToggleOptionValueST(ConsoleDebugEnabled)

		if ConsoleDebugEnabled
			Debug.MessageBox("Started logging to console.")
		else
			Debug.MessageBox("Stopped logging to console.")
		endif
	endEvent

	event OnDefaultST()
		SetToggleOptionValueST(true)
	endEvent

	event OnHighlightST()
		SetInfoText("Enable or disable logging to console")
	endEvent	
endState

state FixEvents_ToggleId
	event OnSelectST()
		FixEvents()
		Debug.MessageBox("All quests re-initialized and all events re-registered")
	endEvent

	event OnDefaultST()
		SetToggleOptionValueST(true)
	endEvent

	event OnHighlightST()
		SetInfoText("Reinitialize all tracking quests and re-register to all events")
	endEvent	
endState

; ============================ start of Azazel's needs configuration =============================

state AzazelResetNeeds_ToggleId
	event OnSelectST()
		Debug.MessageBox("Azazel's needs reset to defaults..")
		AzazelNeedsQuest.mbwAzazelHunger.SetValue(0.0)
		AzazelNeedsQuest.mbwAzazelThirst.SetValue(0.0)
		AzazelNeedsQuest.mbwAzazelSleep.SetValue(0.0)	
		ForcePageReset()
	endEvent

	event OnDefaultST()
		AzazelNeedsEnabled = true
		SetToggleOptionValueST(true)
	endEvent

	event OnHighlightST()
		SetInfoText("Enable or disable logging to console")
	endEvent
endState

state AzazelNeedsEnabled_ToggleId
	event OnSelectST()
		AzazelNeedsEnabled = !AzazelNeedsEnabled
		SetToggleOptionValueST(AzazelNeedsEnabled)
		ForcePageReset()
	endEvent

	event OnDefaultST()
		AzazelNeedsEnabled = true
		SetToggleOptionValueST(true)
	endEvent

	event OnHighlightST()
		SetInfoText("Enable or disable logging to console")
	endEvent	
endState

bool Property AzazelNeedsEnabled 
	bool Function Get()				
		if StorageUtil.GetIntValue(None, "mbw_AzazelNeedsEnabled") == 1
			return true
		else
			return false
		endif 
	EndFunction
	Function Set(bool value)
		if value
			StorageUtil.SetIntValue(None, "mbw_AzazelNeedsEnabled", 1)
		else
			StorageUtil.SetIntValue(None, "mbw_AzazelNeedsEnabled", 0)
		endif
	EndFunction
EndProperty

State AzazelMoodIncreasePerSleepHour_SliderId
	Event OnSliderOpenST()
		SetSliderDialogStartValue(AzazelMoodIncreasePerSleepHour)
		SetSliderDialogDefaultValue(5.0)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(0.5)
	EndEvent
	
	Event OnSliderAcceptST(Float a_value)	
		AzazelMoodIncreasePerSleepHour = a_value	
		SetSliderOptionValueST(AzazelMoodIncreasePerSleepHour, "{0}% per hour")
	EndEvent
	
	Event OnDefaultST()
		AzazelMoodIncreasePerSleepHour = 5.0
		SetSliderOptionValueST(AzazelMoodIncreasePerSleepHour, "{0}% per hour")
	EndEvent
	
	Event OnHighlightST()
		SetInfoText("Azazel's mood increase per hour of sleep")
	EndEvent
EndState

Float Property AzazelMoodIncreasePerSleepHour Hidden ;in game hours, percent increase
	Float Function Get()
		return StorageUtil.GetFloatValue(None, "mbw_AzazelMoodIncreasePerSleepHour", 5.0)
	EndFunction
	Function Set(Float value)
		StorageUtil.SetFloatValue(None, "mbw_AzazelMoodIncreasePerSleepHour", value)
	EndFunction
EndProperty

State AzazelMoodIncreasePerKill_SliderId
	Event OnSliderOpenST()
		SetSliderDialogStartValue(AzazelMoodIncreasePerKill)
		SetSliderDialogDefaultValue(2.0)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(0.5)
	EndEvent
	
	Event OnSliderAcceptST(Float a_value)	
		AzazelMoodIncreasePerKill = a_value	
		SetSliderOptionValueST(AzazelMoodIncreasePerKill, "{0}% per kill")
	EndEvent
	
	Event OnDefaultST()
		AzazelMoodIncreasePerKill = 2.0
		SetSliderOptionValueST(AzazelMoodIncreasePerKill, "{0}% per kill")
	EndEvent
	
	Event OnHighlightST()
		SetInfoText("Azazel's mood increase per kill of a worthwile enemy")
	EndEvent
EndState

Float Property AzazelMoodIncreasePerKill Hidden ;in game hours, percent increase
	Float Function Get()
		return StorageUtil.GetFloatValue(None, "mbw_AzazelMoodIncreasePerKill", 2.0)
	EndFunction
	Function Set(Float value)
		StorageUtil.SetFloatValue(None, "mbw_AzazelMoodIncreasePerKill", value)
	EndFunction
EndProperty

State AzazelMoodIncreasePerPlayerKill_SliderId
	Event OnSliderOpenST()
		SetSliderDialogStartValue(AzazelMoodIncreasePerPlayerKill)
		SetSliderDialogDefaultValue(1.0)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(0.5)
	EndEvent
	
	Event OnSliderAcceptST(Float a_value)	
		AzazelMoodIncreasePerPlayerKill = a_value	
		SetSliderOptionValueST(AzazelMoodIncreasePerPlayerKill, "{0}% per kill")
	EndEvent
	
	Event OnDefaultST()
		AzazelMoodIncreasePerPlayerKill = 1.0
		SetSliderOptionValueST(AzazelMoodIncreasePerPlayerKill, "{0}% per kill")
	EndEvent
	
	Event OnHighlightST()
		SetInfoText("Azazel's mood increase per PC's kill of a worthwile enemy")
	EndEvent
EndState

Float Property AzazelMoodIncreasePerPlayerKill Hidden ;in game hours, percent increase
	Float Function Get()
		return StorageUtil.GetFloatValue(None, "mbw_AzazelMoodIncreasePerPlayerKill", 1.0)
	EndFunction
	Function Set(Float value)
		StorageUtil.SetFloatValue(None, "mbw_AzazelMoodIncreasePerPlayerKill", value)
	EndFunction
EndProperty

State AzazelMoodDecreasePerHour_SliderId
	Event OnSliderOpenST()
		SetSliderDialogStartValue(AzazelMoodDecreasePerHour)
		SetSliderDialogDefaultValue(0.5)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(0.5)
	EndEvent
	
	Event OnSliderAcceptST(Float a_value)	
		AzazelMoodDecreasePerHour = a_value	
		SetSliderOptionValueST(AzazelMoodDecreasePerHour, "{0}% per hour")
	EndEvent
	
	Event OnDefaultST()
		AzazelMoodDecreasePerHour = 0.5
		SetSliderOptionValueST(AzazelMoodDecreasePerHour, "{0}% per hour")
	EndEvent
	
	Event OnHighlightST()
		SetInfoText("Azazel's mood decrease per hour")
	EndEvent
EndState

Float Property AzazelMoodDecreasePerHour Hidden ;in game hours, percent increase
	Float Function Get()
		return StorageUtil.GetFloatValue(None, "mbw_AzazelMoodDecreasePerHour", 0.5)
	EndFunction
	Function Set(Float value)
		StorageUtil.SetFloatValue(None, "mbw_AzazelMoodDecreasePerHour", value)
	EndFunction
EndProperty

State AzazelHungerIncreasePerHour_SliderId
	Event OnSliderOpenST()
		SetSliderDialogStartValue(AzazelHungerIncreasePerHour)
		SetSliderDialogDefaultValue(7.0)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(0.5)
	EndEvent
	
	Event OnSliderAcceptST(Float a_value)	
		AzazelHungerIncreasePerHour = a_value	
		SetSliderOptionValueST(AzazelHungerIncreasePerHour, "{0}% per hour")
	EndEvent
	
	Event OnDefaultST()
		AzazelHungerIncreasePerHour = 7.0
		SetSliderOptionValueST(AzazelHungerIncreasePerHour, "{0}% per hour")
	EndEvent
	
	Event OnHighlightST()
		SetInfoText("Azazel's hunger increase per hour")
	EndEvent
EndState

Float Property AzazelHungerIncreasePerHour Hidden ;in game hours, percent increase
	Float Function Get()
		return StorageUtil.GetFloatValue(None, "mbw_AzazelHungerIncreasePerHour", 7.0)
	EndFunction
	Function Set(Float value)
		StorageUtil.SetFloatValue(None, "mbw_AzazelHungerIncreasePerHour", value)
	EndFunction
EndProperty

State AzazelThirstIncreasePerHour_SliderId
	Event OnSliderOpenST()
		SetSliderDialogStartValue(AzazelThirstIncreasePerHour)
		SetSliderDialogDefaultValue(8.0)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(0.5)
	EndEvent
	
	Event OnSliderAcceptST(Float a_value)	
		AzazelThirstIncreasePerHour = a_value	
		SetSliderOptionValueST(AzazelThirstIncreasePerHour, "{0}% per hour")
	EndEvent
	
	Event OnDefaultST()
		AzazelThirstIncreasePerHour = 8.0
		SetSliderOptionValueST(AzazelThirstIncreasePerHour, "{0}% per hour")
	EndEvent
	
	Event OnHighlightST()
		SetInfoText("Azazel's thirst increase per hour")
	EndEvent
EndState

Float Property AzazelThirstIncreasePerHour Hidden ;in game hours, percent increase
	Float Function Get()
		return StorageUtil.GetFloatValue(None, "mbw_AzazelThirstIncreasePerHour", 8.0)
	EndFunction
	Function Set(Float value)
		StorageUtil.SetFloatValue(None, "mbw_AzazelThirstIncreasePerHour", value)
	EndFunction
EndProperty

State AzazelSleepIncreasePerHour_SliderId
	Event OnSliderOpenST()
		SetSliderDialogStartValue(AzazelSleepIncreasePerHour)
		SetSliderDialogDefaultValue(5.5)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(0.5)
	EndEvent
	
	Event OnSliderAcceptST(Float a_value)	
		AzazelSleepIncreasePerHour = a_value	
		SetSliderOptionValueST(AzazelSleepIncreasePerHour, "{0}% per hour")
	EndEvent
	
	Event OnDefaultST()
		AzazelSleepIncreasePerHour = 5.5
		SetSliderOptionValueST(AzazelSleepIncreasePerHour, "{0}% per hour")
	EndEvent
	
	Event OnHighlightST()
		SetInfoText("Azazel's sleep increase per hour when awake")
	EndEvent
EndState

Float Property AzazelSleepIncreasePerHour Hidden ;in game hours, percent increase
	Float Function Get()
		return StorageUtil.GetFloatValue(None, "mbw_AzazelSleepIncreasePerHour", 5.5)
	EndFunction
	Function Set(Float value)
		StorageUtil.SetFloatValue(None, "mbw_AzazelSleepIncreasePerHour", value)
	EndFunction
EndProperty

State AzazelSleepDecreasePerHour_SliderId
	Event OnSliderOpenST()
		SetSliderDialogStartValue(AzazelSleepDecreasePerHour)
		SetSliderDialogDefaultValue(6.0)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(0.5)
	EndEvent
	
	Event OnSliderAcceptST(Float a_value)	
		AzazelSleepDecreasePerHour = a_value	
		SetSliderOptionValueST(AzazelSleepDecreasePerHour, "{0}% per hour")
	EndEvent
	
	Event OnDefaultST()
		AzazelSleepDecreasePerHour = 6.0
		SetSliderOptionValueST(AzazelSleepDecreasePerHour, "{0}% per hour")
	EndEvent
	
	Event OnHighlightST()
		SetInfoText("Azazel's sleep decrease per hour when sleeping")
	EndEvent
EndState

;when sleeping, by how much decrease tiredness per hour
Float Property AzazelSleepDecreasePerHour Hidden ;in game hours, percent decrease
	Float Function Get()
		return StorageUtil.GetFloatValue(None, "mbw_AzazelSleepIncreasePerHour", 6.0)
	EndFunction
	Function Set(Float value)
		StorageUtil.SetFloatValue(None, "mbw_AzazelSleepIncreasePerHour", value)
	EndFunction
EndProperty

; ============================ end of Azazel's needs configuration =============================

; ============================ start of consequences stuff =============================
Float Property TraumaDecreaseThresholdInHours Hidden 
	Float Function Get()
		return StorageUtil.GetFloatValue(None, "mbw_TraumaDecreaseThresholdInHours", 3.0)
	EndFunction
	Function Set(Float value)
		StorageUtil.SetFloatValue(None, "mbw_TraumaDecreaseThresholdInHours", value)
	EndFunction
EndProperty

State Consequences_TraumaDecreaseThresholdInHours_SliderId
	Event OnSliderOpenST()
		SetSliderDialogStartValue(TraumaDecreaseThresholdInHours)
		SetSliderDialogDefaultValue(3.0)
		SetSliderDialogRange(0.5, 128.0)
		SetSliderDialogInterval(0.5)
	EndEvent
	
	Event OnSliderAcceptST(Float a_value)
		TraumaDecreaseThresholdInHours = a_value
		SetSliderOptionValueST(a_value, "{0}")
	EndEvent
	
	Event OnDefaultST()
		TraumaDecreaseThresholdInHours = 3.0
		SetSliderOptionValueST(3.0, "{0}")
	EndEvent
	
	Event OnHighlightST()
		SetInfoText("In game hours for rape trauma level to decrease.")
	EndEvent
EndState
; ============================ end of consequences stuff =============================

bool Property IsAzazelActiveFollower Hidden
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

; ============================ start of constants =============================

Keyword Property LocTypeBanditCamp Auto
Keyword Property LocTypeBarracks Auto
Keyword Property LocTypeCity Auto
Keyword Property LocTypeTown Auto
Keyword Property LocTypeDragonPriestLair Auto
Keyword Property LocTypeDungeon Auto
Keyword Property LocTypeFalmerHive Auto
Keyword Property LocTypeGuild Auto
Keyword Property LocTypeInn Auto
Keyword Property LocTypeStore Auto
Keyword Property LocTypeDraugrCrypt Auto
Keyword Property LocTypePlayerHouse Auto
Keyword Property LocTypeCemetery Auto
Keyword Property LocTypeSettlement Auto
Keyword Property LocTypeOrcStronghold Auto

; ============================ end of constants =============================
