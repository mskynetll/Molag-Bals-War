Scriptname mbwTeleportLaggingFollowerEffect extends ActiveMagicEffect

Actor Property AzazelRef Auto
Actor Property PlayerRef Auto
bool Property IsAzazelSeenByPlayer Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
	AzazelRef = akTarget
	PlayerRef = Game.GetPlayer()
	RegisterForSingleLOSLost(PlayerRef, AzazelRef)
	RegisterForSingleLOSGain(PlayerRef, AzazelRef)
	RegisterForSingleUpdate(3.0)
EndEvent

Event OnUpdate()
	float distance = AzazelRef.GetDistance(PlayerRef)
	if IsAzazelActiveFollower && !IsAzazelSeenByPlayer  && distance > 800.0 && AzazelRef.IsBleedingOut() == false && AzazelRef.IsSneaking() == false && AzazelRef.GetCombatState() == 0
		float[] offsets = mbwUtility.GetPostionAwayFromRefFacing(PlayerRef,100.0, -50.0)
		AzazelRef.MoveTo(PlayerRef, offsets[0], offsets[1], 0, true)
		Debug.Notification("[mbw debug] Azazel lags too far behind, teleporting behind player")
	endif
	RegisterForSingleUpdate(3.0)
EndEvent

Event OnGainLOS(Actor akViewer, ObjectReference akTarget)
	IsAzazelSeenByPlayer = true
	RegisterForSingleLOSGain(PlayerRef, AzazelRef)
EndEvent

Event OnLostLOS(Actor akViewer, ObjectReference akTarget)	
	IsAzazelSeenByPlayer = false
	RegisterForSingleLOSLost(PlayerRef, AzazelRef)
EndEvent

bool Property IsAzazelActiveFollower Hidden
	bool Function Get()				
		if StorageUtil.GetIntValue(None, "mbw_IsAzazelActiveFollower") == 1
			return true
		else
			return false
		endif 
	EndFunction
	Function Set(bool value)
		if value
			StorageUtil.SetIntValue(None, "mbw_IsAzazelActiveFollower", 1)
		else
			StorageUtil.SetIntValue(None, "mbw_IsAzazelActiveFollower", 0)
		endif
	EndFunction
EndProperty