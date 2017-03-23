;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname TIF__0801007B Extends TopicInfo Hidden

mbwAzazelInteractionsQuest Property AzazelInteractionsQuest Auto

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
Debug.MessageBox("Judging by the sounds of her steps, Azazel comes closer, humming merrily. She seems to enjoy the situation. 'What do we have heeeere... oh, I know this lock... yes...' she mumbles. Then, you hear some rustling and light scratching of metal on metal, and then, suddenly hear mechanical TWANG. The lock on your device opens with a click and you suddenly see bright light. The device that was obstructing your eyes has been removed by Azazel. ")
AzazelInteractionsQuest.libs.removeDevice(AzazelInteractionsQuest.libs.PlayerRef, AzazelInteractionsQuest.BlindfoldWornByPlayer, AzazelInteractionsQuest.libs.GetRenderedDevice(AzazelInteractionsQuest.BlindfoldWornByPlayer), AzazelInteractionsQuest.libs.zad_DeviousBlindfold, destroyDevice = false, skipevents = false, skipmutex = true)	
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
