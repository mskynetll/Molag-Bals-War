;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname TIF__0800C52F Extends TopicInfo Hidden

Scene Property AzazelCastChameleonOnPlayer Auto
GlobalVariable Property AzazelHelpCount Auto

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
AzazelCastChameleonOnPlayer.ForceStart()
AzazelHelpCount.Mod(1.0)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
