;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname TIF__0800E034 Extends TopicInfo Hidden

zadlibs Property libs Auto
Message Property GagRemovalMessage Auto

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
Armor gagToBeRemoved = libs.GetWornDevice(libs.playerref, Libs.zad_DeviousGag)
libs.removeDevice(libs.playerref, gagToBeRemoved, libs.GetRenderedDevice(gagToBeRemoved), libs.zad_DeviousGag, destroyDevice = false, skipevents = false, skipmutex = true)			
gagToBeRemoved = None
GagRemovalMessage.Show()
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
