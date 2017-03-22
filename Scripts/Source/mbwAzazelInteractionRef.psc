Scriptname mbwAzazelInteractionRef extends ReferenceAlias Conditional

Actor Property Azazel Auto
mbwConfigQuest Property ConfigQuest Auto

bool Property HasAlreadyOfferedTraining Auto Conditional

float Property TrainingProgressToNextRank Auto Conditional
int Property TraineeRank Auto Conditional

Event OnCombatStateChanged(Actor akTarget, int aeCombatState)
	if ConfigQuest.ConsoleDebugEnabled
		MiscUtil.PrintConsole("[mbw] Azazel's combat state changed, combat state = " + aeCombatState + ", target = " + akTarget)
	endif
EndEvent

Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, \
  bool abBashAttack, bool abHitBlocked)
	if ConfigQuest.ConsoleDebugEnabled
 		MiscUtil.PrintConsole("[mbw] Azazel OnHit, aggressor = " + akAggressor + ", isBlocked =" + abHitBlocked)
 	endif
EndEvent