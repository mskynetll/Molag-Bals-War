Scriptname mbwTeleportLaggingFollowerEffect extends ActiveMagicEffect

Actor Property AzazelRef Auto
Actor Property PlayerRef Auto
bool Property IsAzazelSeenByPlayer Auto
Spell Property TeleportLaggingFollowerSpell Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
	AzazelRef = akTarget
	PlayerRef = Game.GetPlayer()
	RegisterForSingleLOSLost(PlayerRef, AzazelRef)
	RegisterForSingleLOSGain(PlayerRef, AzazelRef)
	RegisterForSingleUpdate(2.0)
EndEvent

Event OnUpdate()
	if AzazelRef.IsPlayerTeammate() && AzazelRef.GetAv("WaitingForPlayer") == 0 && !IsAzazelSeenByPlayer  && AzazelRef.GetDistance(PlayerRef) > 1200.0 && AzazelRef.IsDoingFavor() == false && AzazelRef.IsBleedingOut() == false && AzazelRef.IsSneaking() == false && AzazelRef.GetCombatState() == 0
		float[] offsets = mbwUtility.GetPostionAwayFromRefFacing(PlayerRef,100.0, -50.0)
		AzazelRef.MoveTo(PlayerRef, offsets[0], offsets[1], 0, true)
		MiscUtil.PrintConsole("Azazel is too far, teleporting behind player")
	endif
	RegisterForSingleUpdate(2.0)
EndEvent

Event OnGainLOS(Actor akViewer, ObjectReference akTarget)
	IsAzazelSeenByPlayer = true
	RegisterForSingleLOSGain(PlayerRef, AzazelRef)
EndEvent

Event OnLostLOS(Actor akViewer, ObjectReference akTarget)	
	IsAzazelSeenByPlayer = false
	RegisterForSingleLOSLost(PlayerRef, AzazelRef)
EndEvent



Event OnEffectFinish(Actor akTarget, Actor akCaster)
	;precaution...
	AzazelRef.RemoveSpell(TeleportLaggingFollowerSpell)
	AzazelRef.AddSpell(TeleportLaggingFollowerSpell)
EndEvent