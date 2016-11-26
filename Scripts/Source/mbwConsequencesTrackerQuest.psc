Scriptname mbwConsequencesTrackerQuest extends Quest Conditional

Actor Property Player Auto
SexLabFramework Property SexLab Auto

int Property RapeTraumaLevel Auto Conditional
float Property TraumaDecreaseThresholdInHours = 3 AutoReadonly Hidden

Event OnInit()
	Maintenance()
EndEvent

Function Maintenance()	
	RegisterForModEvent("AnimationEnd", "OnSexAnimationEnd") 
	RegisterForSingleUpdateGameTime(TraumaDecreaseThresholdInHours)
	RegisterForSleep()
EndFunction

Event OnUpdateGameTime()
	float hoursPassed = Math.Abs(Utility.GetCurrentGameTime() - LastWait) * 24.0
	MiscUtil.PrintConsole("[mbw]  OnUpdateGameTime(), hoursPassed = " + hoursPassed)
	If RapeTraumaLevel >= 1 && hoursPassed >= TraumaDecreaseThresholdInHours
		RapeTraumaLevel -= 1
	endif
	RegisterForSingleUpdateGameTime(TraumaDecreaseThresholdInHours)
	LastWait = Utility.GetCurrentGameTime()
EndEvent

Event OnSexAnimationEnd(string eventName, string argString, float argNum, form sender)	   
	    Actor[] participants = Sexlab.HookActors(argString)
	    Actor victim = Sexlab.HookVictim(argString)
	    MiscUtil.PrintConsole("[mbw] OnSexAnimationEnd(), participant count = " + participants.Length)

		If victim != None && victim == Player
			MiscUtil.PrintConsole("[mbw] OnSexAnimationEnd(), RapeTraumaLevel = " + RapeTraumaLevel + ", player seems to be the victim...")
			int index = 0
			;this condition is a precaution, there cannot be animation with victim and only one actor
			If RapeTraumaLevel <= 5 
				RapeTraumaLevel += 1
			EndIf
		EndIf 
EndEvent

Event OnSleepStart(float afSleepStartTime, float afDesiredSleepEndTime)
	LastSleepStart = afSleepStartTime
endEvent

Event OnSleepStop(bool abInterrupted)
	float hoursPassed = Math.Abs(Utility.GetCurrentGameTime() - LastSleepStart) * 24.0
	MiscUtil.PrintConsole("[mbw]  OnSleepStop(), hoursPassed = " + hoursPassed)
	RapeTraumaLevel = mbwUtility.MaxInt(0, RapeTraumaLevel - (hoursPassed / TraumaDecreaseThresholdInHours) as int)
endEvent

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