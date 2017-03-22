Scriptname mbwUtility Extends Form Hidden

Float Function Max(Float A, Float B) global
	If (A > B)
		Return A
	Else
		Return B
	EndIf
EndFunction

Float Function Min(Float A, Float B) global
	If (A < B)
		Return A
	Else
		Return B
	EndIf
EndFunction

Int Function MaxInt(Int A, Int B) global
	If (A > B)
		Return A
	Else
		Return B
	EndIf
EndFunction

Int Function MinInt(Int A, Int B) global
	If (A < B)
		Return A
	Else
		Return B
	EndIf
EndFunction

; Checks if one value is between two others. If it exceed it's limit, returns the limit
Int Function LimitValueInt(Int value, Int lowBorder, Int highBorder) global
	If value < lowBorder
		return lowBorder
	ElseIf value > highBorder
		return highBorder
	Else
		return value
	EndIf
EndFunction

; Checks if one value is between two others. If it exceed it's limit, returns the limit
Function LimitValue(GlobalVariable value, float lowBorder, float highBorder) global
	If value.GetValue() < lowBorder
		value.SetValue(lowBorder)
	ElseIf value.GetValue() > highBorder
		value.SetValue(highBorder)
	EndIf
EndFunction

; Checks if one value is between two values.
Bool Function IsValueInLimitInt(Int value, Int lowBorder, Int highBorder) global
	If value < lowBorder
		return false
	ElseIf value > highBorder
		return false
	Else
		return true
	EndIf
EndFunction

Function SendParameterlessEvent(String eventName) global
	Int retries = 3
	While(retries > 0)
		Int eventId = ModEvent.Create(eventName)
		If eventId
			If(ModEvent.Send(eventId) == true)
				retries = 0
			Else
				Utility.WaitMenuMode(0.05)
				retries -= 1
			EndIf
		Else
			Utility.WaitMenuMode(0.05)
			retries -= 1
		EndIf
	EndWhile
EndFunction

Function SendEventWithFormParam(String eventName,Form fParam) global
	Int retries = 3
	While(retries > 0)
		Int eventId = ModEvent.Create(eventName)
		If eventId
			ModEvent.PushForm(eventId, fParam)
			If(ModEvent.Send(eventId) == true)
				retries = 0
			Else
				Utility.WaitMenuMode(0.05)
				retries -= 1
			EndIf
		Else
			Utility.WaitMenuMode(0.05)
			retries -= 1
		EndIf
	EndWhile
EndFunction

Function SendEventWithFormAndFloatParam(String eventName,Form fParam, float fNum) global
	Int retries = 3
	While(retries > 0)
		Int eventId = ModEvent.Create(eventName)
		If eventId
			ModEvent.PushForm(eventId, fParam)
			ModEvent.PushFloat(eventId, fNum)
			If(ModEvent.Send(eventId) == true)
				retries = 0
			Else
				Utility.WaitMenuMode(0.05)
				retries -= 1
			EndIf
		Else
			Utility.WaitMenuMode(0.05)
			retries -= 1
		EndIf
	EndWhile
EndFunction

Function SendIncreaseArousal(Actor akActor,float fAmount) global
	SendEventWithFormAndFloatParam("slaUpdateExposure",akActor as Form, fAmount)
EndFunction

Function SendEventWithIntParam(String eventName,Int iParam) global
	Int retries = 3
	While(retries > 0)
		Int eventId = ModEvent.Create(eventName)
		If eventId
			ModEvent.PushInt(eventId, iParam)
			If(ModEvent.Send(eventId) == true)
				retries = 0
			Else
				Utility.WaitMenuMode(0.05)
				retries -= 1
			EndIf
		Else
			Utility.WaitMenuMode(0.05)
			retries -= 1
		EndIf
	EndWhile
EndFunction

Function SendEventWithFormAndIntParam(String eventName,Form fParam, Int iParam) global
	Int retries = 3
	While(retries > 0)
		Int eventId = ModEvent.Create(eventName)
		If eventId
			ModEvent.PushForm(eventId, fParam)
			ModEvent.PushInt(eventId, iParam)
			If(ModEvent.Send(eventId) == true)
				retries = 0
			Else
				Utility.WaitMenuMode(0.05)
				retries -= 1
			EndIf
		Else
			Utility.WaitMenuMode(0.05)
			retries -= 1
		EndIf
	EndWhile
EndFunction

;taken from http://www.gamesas.com/better-way-calculating-position-front-player-t291447.html
Float[] Function GetPostionAwayFromRefFacing(ObjectReference akSource, Float afDistance = 100.0, Float afOffset = 0.0) global
	Float A = akSource.GetAngleZ() + afOffset 
	Float[] Offsets = New Float[2] 
	Offsets[0] = Math.Sin(A) * afDistance 
	Offsets[1] = Math.Cos(A) * afDistance 
	Return Offsets
Endfunction

;adapted code from https://www.creationkit.com/index.php?title=Slot_Masks_-_Armor
Armor[] Function GetWornArmor(Actor target) global
    Armor[] wornArmor = new Armor[30]
    int index
    int slotsChecked
    slotsChecked += 0x00100000
    slotsChecked += 0x00200000 ;ignore reserved slots
    slotsChecked += 0x80000000
 
    int currentSlot = 0x01
    while (currentSlot < 0x80000000)
        if (Math.LogicalAnd(slotsChecked, currentSlot) != currentSlot) ;only check slots we haven't found anything equipped on already
            Armor currentArmor = target.GetWornForm(currentSlot) as Armor
            if currentArmor != None
                wornArmor[index] = currentArmor
                index += 1
                slotsChecked += currentArmor.GetSlotMask() ;add all slots this item covers to our slotsChecked variable
            else ;no armor was found on this slot
                slotsChecked += currentSlot
            endif
        endif
        currentSlot *= 2 ;double the number to move on to the next slot
    endWhile
    return wornArmor
EndFunction