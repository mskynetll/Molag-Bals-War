Scriptname mbwNippleClampsEffect extends ActiveMagicEffect

Actor Property PlayerRef Auto
float Property HealthTick Auto hidden
bool Property IsActive Auto hidden

Event OnEffectStart(Actor akTarget, Actor akCaster)
	RegisterForSingleUpdateGameTime(0.5)
	IsActive = true
	HealthTick = PlayerRef.GetActorValue("Health") * 0.02
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	IsActive = false
	UnregisterForUpdateGameTime()
EndEvent

Event OnUpdateGameTime()
	if PlayerRef.GetActorValue("Health") >= 25.0 && IsActive == true
		PlayerRef.ModActorValue("Health", -HealthTick)
		Debug.Notification("Your nipples are sore, with cruel clamps digging into them")
	endif
	RegisterForSingleUpdateGameTime(Utility.RandomFloat(0.25, 3.0))
EndEvent