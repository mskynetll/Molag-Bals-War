;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname TIF__08005398 Extends TopicInfo Hidden

mbwAzazelTrainingQuest Property TrainingQuest Auto
DialogueFollowerScript Property FollowerQuest Auto

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
getowningquest().setstage(20)
FollowerQuest.DismissFollower(0,0)
FollowerQuest.SetFollower(akSpeaker)
TrainingQuest.Start()
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
