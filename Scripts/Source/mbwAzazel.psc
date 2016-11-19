Scriptname mbwAzazel Extends Actor

mbwAzazelEventsQuest Property AzazelEventsQuest Auto
mbwConfigQuest Property Config Auto

Event OnLocationChange(Location akOldLoc, Location akNewLoc)
	Log("Azazel received OnLocationChange()")
	AzazelEventsQuest.OnLocationChange(akOldLoc,akNewLoc)
endEvent


;severity
;0 -> turn off
;3 -> info only
;2 -> include warnings
;1 -> errors only
Function Log(string asTextToPrint)
	;If Config.LogLevel >= 3
		Debug.Trace("[mbw]" + asTextToPrint)
		MiscUtil.PrintConsole("[mbw - Info]" + asTextToPrint)
	;EndIf
EndFunction

Function Warning(string asTextToPrint)
	;If Config.LogLevel >= 2
		Debug.Trace("[mbw]" + asTextToPrint, 1)
		MiscUtil.PrintConsole("[mbw - Warning]" + asTextToPrint)
	;EndIf
EndFunction

Function Error(string asTextToPrint)
	;If Config.LogLevel >= 1
		Debug.Trace("[mbw]" + asTextToPrint, 2)
		MiscUtil.PrintConsole("[mbw - Error]" + asTextToPrint)
	;EndIf
EndFunction