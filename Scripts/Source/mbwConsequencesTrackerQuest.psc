Scriptname mbwConsequencesTrackerQuest extends Quest Conditional

Actor Property Player Auto
SexLabFramework Property SexLab Auto
mbwConfigQuest Property Config Auto
int Property RapeTraumaLevel Auto Conditional

Event OnInit()
	Maintenance()
EndEvent

Function Maintenance()	
	
EndFunction

;this is called from mbwEventsDispatcherQuest (kind of 'callback')
Function OnSexAnimationEnd(string eventName, string argString, float argNum, form sender)
	    Actor[] participants = Sexlab.HookActors(argString)
	    Actor victim = Sexlab.HookVictim(argString)
	    if Config.ConsoleDebugEnabled
	    	MiscUtil.PrintConsole("[mbw] OnSexAnimationEnd(), participant count = " + participants.Length)
	    endif

		If victim != None && victim == Player	
			if Config.ConsoleDebugEnabled		
				MiscUtil.PrintConsole("[mbw] OnSexAnimationEnd(), RapeTraumaLevel = " + RapeTraumaLevel + ", player seems to be the victim...")
			endif
			int index = 0
		;this condition is a precaution, there cannot be animation with victim and only one actor
			If RapeTraumaLevel <= 5 
				RapeTraumaLevel += 1
				RapeTraumaStorage += 1
			EndIf
		EndIf 
EndFunction

;this is called from mbwEventsDispatcherQuest (kind of 'callback')
Function OnGameTimePass(float hoursPassed)
	if Config.ConsoleDebugEnabled
		MiscUtil.PrintConsole("[mbw]  OnUpdateGameTime(), hoursPassed = " + hoursPassed)
	EndIf

	If RapeTraumaLevel >= 1 && hoursPassed >= TraumaDecreaseThresholdInHours
		RapeTraumaLevel -= 1
		RapeTraumaStorage -= 1
		if Config.ConsoleDebugEnabled
			MiscUtil.PrintConsole("[mbw]  OnUpdateGameTime(), updating rape trauma level, now it is = " + RapeTraumaLevel)
		EndIf		
	endif
EndFunction

;this is called from mbwEventsDispatcherQuest (kind of 'callback')
Function OnSleepEnd(float hoursPassed,bool interrupted)
	RapeTraumaLevel = mbwUtility.MaxInt(0, RapeTraumaLevel - (hoursPassed / TraumaDecreaseThresholdInHours) as int)
EndFunction

Float Property TraumaDecreaseThresholdInHours Hidden 
	Float Function Get()
		return StorageUtil.GetFloatValue(None, "mbw_TraumaDecreaseThresholdInHours", 3.0)
	EndFunction
	Function Set(Float value)
		StorageUtil.SetFloatValue(None, "mbw_TraumaDecreaseThresholdInHours", value)
	EndFunction
EndProperty

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

int Property RapeTraumaStorage Hidden
	int Function Get()
		return StorageUtil.GetIntValue(None, "_mbw_RapeTrauma", 0)
	EndFunction
	Function Set(int value)
		StorageUtil.SetIntValue(None, "_mbw_RapeTrauma", value)
	EndFunction
EndProperty