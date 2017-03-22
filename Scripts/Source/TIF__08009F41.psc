;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 3
Scriptname TIF__08009F41 Extends TopicInfo Hidden

mbwAzazelInteractionsQuest Property AzazelInteractionsQuest Auto
mbwAzazelTrainingQuest Property AzazelTrainingQuest Auto

;BEGIN FRAGMENT Fragment_2
Function Fragment_2(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
AzazelTrainingQuest.Start()
AzazelTrainingQuest.SetStage(0)
AzazelTrainingQuest.StartFirstTimeInDraugrCryptIfRelevant(Game.GetPlayer().GetCurrentLocation())
AzazelInteractionsQuest.IsPlayerAzazelsApprentice = true
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
