scriptname mbwPeriodicArousalIncrease extends ActiveMagicEffect

Actor Property TargetActorRef Auto Hidden

Event OnEffectStart(Actor akTarget, Actor akCaster)
	TargetActorRef = akTarget
	RegisterForSingleUpdateGameTime(1.0)
EndEvent

Event OnUpdateGameTime()
	mbwUtility.SendIncreaseArousal(TargetActorRef,GetMagnitude())
	RegisterForSingleUpdateGameTime(1.0)
EndEvent
