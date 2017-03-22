;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 2
Scriptname TIF__0800E00A Extends TopicInfo Hidden

mbwAzazelTrainingQuest Property AzazelTrainingQuest Auto

;BEGIN FRAGMENT Fragment_1
Function Fragment_1(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
AzazelTrainingQuest.PlayerCombatStylePreference = 1
AzazelTrainingQuest.FirstTimeInDraugrCryptDialogue = 0
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
