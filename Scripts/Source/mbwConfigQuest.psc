Scriptname mbwConfigQuest extends SKI_ConfigBase

mbwEventsDispatcherQuest Property EventsDispatcherQuest Auto
mbwAzazelEventsQuest Property AzazelEventsQuest Auto

Event OnConfigInit()
	Pages = new String[3]
	Pages[0] = "General Settings"
	Pages[1] = "Azazel Stuff"
	Pages[2] = "Debug"	
EndEvent

; ============================== start of soft reference stuff =======================================
Function DetectOptionalMods()
	 If Game.GetModByName("RealisticNeedsandDiseases.esp") == 255	 	
        IsRealisticNeedsInstalled = false       
    Else
        IsRealisticNeedsInstalled = true               
	EndIf
EndFunction

Armor Property AzazelDefaultCuirass Auto
Armor Property AzazelDefaultGloves Auto
Armor Property AzazelDefaultBoots Auto

Actor Property AzazelRef Auto

Scene Property AzazelSilentKillScene Auto

bool Property IsRealisticNeedsInstalled Auto Hidden
; ============================== end of soft reference stuff =======================================
event OnPageReset(string page)
    {Called when a new page is selected, including the initial empty page}
    	SetCursorFillMode(TOP_TO_BOTTOM) 
	If (page == "General Settings")
		SetCursorPosition(0)
		AddHeaderOption("Placeholder")
	endif
	If (page == "Azazel Stuff")
		SetCursorPosition(0)		
		AddHeaderOption("Azazel's Needs (percents)")
		
		AddTextOptionST("AzazelCurrentNeeds_Hunger_TextID", "Hunger", AzazelEventsQuest.AzazelHunger.GetValue(), 1)
		AddTextOptionST("AzazelCurrentNeeds_Thirst_TextID", "Thirst", AzazelEventsQuest.AzazelThirst.GetValue(), 1)
		AddTextOptionST("AzazelCurrentNeeds_Sleep_TextID", "Sleep", AzazelEventsQuest.AzazelSleep.GetValue(), 1)		

		AddHeaderOption("Azazel's Needs Configuration")
		AddSliderOptionST("AzazelSettings_AzazelHungerIncreasePerHour_SliderId", "Hunger Increase", AzazelHungerIncreasePerHour, "{0}% per hour")
		AddSliderOptionST("AzazelSettings_AzazelThirstIncreasePerHour_SliderId", "Thirst Increase", AzazelThirstIncreasePerHour, "{0}% per hour")
		AddSliderOptionST("AzazelSettings_AzazelSleepIncreasePerHour_SliderId", "Sleep Increase", AzazelSleepIncreasePerHour, "{0}% per hour")
		AddSliderOptionST("AzazelSettings_AzazelSleepDecreasePerHour_SliderId", "Sleep Decrease", AzazelSleepDecreasePerHour, "{0}% per hour")
	endif
	If (page == "Debug")
		SetCursorPosition(0)
		AddHeaderOption("Misc")
		AddSliderOptionST("Debug_LogLevel_SliderId", "Log Severity", LogLevel, "{0}")

		;AddToggleOptionST("Debug_StopAzazelSilentKillScene_ToggleId", "Stop Azazel's Silent Kill Routine", false)
	endif
endEvent



State AzazelSettings_AzazelSleepDecreasePerHour_SliderId
	Event OnSliderOpenST()
		SetSliderDialogStartValue(AzazelSleepDecreasePerHour)
		SetSliderDialogDefaultValue(5.5)
		SetSliderDialogRange(0.0, 25.0)
		SetSliderDialogInterval(1.0)
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
		SetInfoText("Rate of Azazel tiredness decrease (when sleeping).")
	EndEvent
EndState

State AzazelSettings_AzazelSleepIncreasePerHour_SliderId
	Event OnSliderOpenST()
		SetSliderDialogStartValue(AzazelSleepIncreasePerHour)
		SetSliderDialogDefaultValue(5.5)
		SetSliderDialogRange(0.0, 25.0)
		SetSliderDialogInterval(1.0)
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
		SetInfoText("Rate of Azazel tiredness increase.")
	EndEvent
EndState

State AzazelSettings_AzazelThirstIncreasePerHour_SliderId
	Event OnSliderOpenST()
		SetSliderDialogStartValue(AzazelThirstIncreasePerHour)
		SetSliderDialogDefaultValue(8.0)
		SetSliderDialogRange(0.0, 25.0)
		SetSliderDialogInterval(1.0)
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
		SetInfoText("Rate of Azazel thirst increase.")
	EndEvent
EndState

State AzazelSettings_AzazelHungerIncreasePerHour_SliderId
	Event OnSliderOpenST()
		SetSliderDialogStartValue(AzazelHungerIncreasePerHour)
		SetSliderDialogDefaultValue(7.0)
		SetSliderDialogRange(0.0, 25.0)
		SetSliderDialogInterval(1.0)
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
		SetInfoText("Rate of Azazel hunger increase.")
	EndEvent
EndState

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
			SetSliderOptionValueST(LogLevel, "{0} - turned off")
		endif
		if LogLevel == 3
			SetSliderOptionValueST(LogLevel, "{0} - info only")
		endif
		if LogLevel == 2
			SetSliderOptionValueST(LogLevel, "{0} - info,warnings")
		endif
		if LogLevel == 1
			SetSliderOptionValueST(LogLevel, "{0} - info,warnings,errors")
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

; ============================ start of Azazel's needs configuration =============================
Float Property AzazelHungerIncreasePerHour Hidden ;in game hours, percent increase
	Float Function Get()
		return StorageUtil.GetFloatValue(None, "mbw_AzazelHungerIncreasePerHour", 7.0)
	EndFunction
	Function Set(Float value)
		StorageUtil.SetFloatValue(None, "mbw_AzazelHungerIncreasePerHour", value)
	EndFunction
EndProperty

Float Property AzazelThirstIncreasePerHour Hidden ;in game hours, percent increase
	Float Function Get()
		return StorageUtil.GetFloatValue(None, "mbw_AzazelThirstIncreasePerHour", 8.0)
	EndFunction
	Function Set(Float value)
		StorageUtil.SetFloatValue(None, "mbw_AzazelThirstIncreasePerHour", value)
	EndFunction
EndProperty

Float Property AzazelSleepIncreasePerHour Hidden ;in game hours, percent increase
	Float Function Get()
		return StorageUtil.GetFloatValue(None, "mbw_AzazelSleepIncreasePerHour", 5.5)
	EndFunction
	Function Set(Float value)
		StorageUtil.SetFloatValue(None, "mbw_AzazelSleepIncreasePerHour", value)
	EndFunction
EndProperty

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