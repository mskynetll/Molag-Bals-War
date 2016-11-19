Scriptname mbwSneakDetectorEffect extends ActiveMagicEffect

mbwEventsDispatcherQuest Property EventsDispatcher Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
	EventsDispatcher.OnSneakStart(akCaster)
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	EventsDispatcher.OnSneakEnd(akCaster)
EndEvent