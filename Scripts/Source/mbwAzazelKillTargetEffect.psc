Scriptname mbwAzazelKillTargetEffect extends ActiveMagicEffect

ReferenceAlias Property EnemyToKillRefAlias Auto
ReferenceAlias Property PlayerTargetPointer Auto
Scene Property AzazelStealthKillScene Auto
GlobalVariable Property mbwAzazelHelpCount Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
	;akCaster can be only the player, so...
	if akCaster == none || akCaster.IsSneaking() == false || akTarget == none ;precaution
		MiscUtil.PrintConsole("Azazel target is not an actor, or player is not sneaking --> aborting stealth kill")
		Dispel()
		return
	endif

	EnemyToKillRefAlias.ForceRefTo(akTarget)
	AzazelStealthKillScene.ForceStart()
	MiscUtil.PrintConsole("Starting scene for Azazel's stealth takedown. Target is " + akTarget.GetName())
	PlayerTargetPointer.Clear()
	mbwAzazelHelpCount.Mod(1.0)
	Dispel()
endEvent