Scriptname mbwConfigQuest extends SKI_ConfigBase

Event OnConfigInit()
	Pages = new String[3]
	Pages[0] = "Feature Settings"
	Pages[1] = "Azazel Settings"
	Pages[2] = "Debug"	
EndEvent

Actor Property Azazel Auto
int Property MaxOutfitItems = 10 autoReadOnly hidden
string Property OutfitPropertyName = "mbwAzazelOutfitProperty" autoReadOnly hidden

Armor Property AzazelDefaultCuirass Auto
Armor Property AzazelDefaultGloves Auto
Armor Property AzazelDefaultBoots Auto

event OnPageReset(string page)
    {Called when a new page is selected, including the initial empty page}
    	SetCursorFillMode(TOP_TO_BOTTOM) 
	If (page == "Feature Settings")
		SetCursorPosition(0)
		AddHeaderOption("Placeholder")
	endif
	If (page == "Azazel Settings")
		SetCursorPosition(0)		
		AddHeaderOption("Stored Outfit")
		int outfitItemCount = StorageUtil.FormListCount(Azazel, OutfitPropertyName)
		int index = 0
		while index < outfitItemCount
			Form item = StorageUtil.FormListGet(Azazel, OutfitPropertyName, index)
			if item != None
				AddTextOption(index, item.GetName(), 1)
			endif
			index += 1
		endwhile
		
	endif
	If (page == "Debug")
		SetCursorPosition(0)
		AddHeaderOption("Misc")
		AddSliderOptionST("Debug_LogLevel_SliderId", "Log Severity", LogLevel, "{0}")
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