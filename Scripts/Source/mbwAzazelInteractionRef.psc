Scriptname mbwAzazelInteractionRef extends ReferenceAlias Conditional

Actor Property Azazel Auto
mbwConfigQuest Property ConfigQuest Auto

bool Property HasAlreadyOfferedTraining Auto Conditional

float Property TrainingProgressToNextRank Auto Conditional
int Property TraineeRank Auto Conditional

Event OnCombatStateChanged(Actor akTarget, int aeCombatState)
	MiscUtil.PrintConsole("Azazel's combat state changed, combat state = " + aeCombatState + ", target = " + akTarget)
EndEvent

Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, \
  bool abBashAttack, bool abHitBlocked)
 	MiscUtil.PrintConsole("Azazel OnHit, aggressor = " + akAggressor + ", isBlocked =" + abHitBlocked)
EndEvent