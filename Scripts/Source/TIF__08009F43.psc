;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname TIF__08009F43 Extends TopicInfo Hidden

mbwAzazelTrainingQuest Property AzazelTrainingQuest Auto
mbwAzazelInteractionsQuest Property AzazelInteractionsQuest Auto
GlobalVariable Property mbwAzazelDisposition Auto

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
mbwAzazelDisposition.Mod(-1.0) ;azazel doesn't like hesitation :)
AzazelTrainingQuest.Start()
AzazelTrainingQuest.SetStage(0)
AzazelInteractionsQuest.IsPlayerAzazelsApprentice = true
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
