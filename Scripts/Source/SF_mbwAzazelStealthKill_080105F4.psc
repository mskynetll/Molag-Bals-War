;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 4
Scriptname SF_mbwAzazelStealthKill_080105F4 Extends Scene Hidden

ReferenceAlias Property EnemyToKillRefAlias Auto
Actor Property AzazelRef Auto
Spell Property AzazelChameleon Auto

;BEGIN FRAGMENT Fragment_2
Function Fragment_2()
;BEGIN CODE
AzazelRef.StartCombat(EnemyToKillRefAlias.GetActorReference())
AzazelChameleon.Cast(AzazelRef)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_3
Function Fragment_3()
;BEGIN CODE
Debug.Notification("Silent as a shadow, Azazel closes in...")
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
