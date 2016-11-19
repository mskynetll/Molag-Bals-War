Scriptname mbwEnemyToKillRef extends ReferenceAlias

Actor Property Azazel Auto
bool Property IsFirstHit Auto Hidden
ReferenceAlias Property PlayerTargetPointerRefAlias Auto

Event OnDeath(Actor akKiller)
  PlayerTargetPointerRefAlias.Clear()
  Clear()
endEvent

Event OnUnload()
  PlayerTargetPointerRefAlias.Clear()
  Clear()
EndEvent

Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, \
  bool abBashAttack, bool abHitBlocked)
	if IsFirstHit == false
		Actor enemy = GetActorReference()
		if enemy == None ; precaution
			IsFirstHit = true
			return
		endif

	 	Weapon akWeapon = akSource as Weapon
		if akWeapon != None && akAggressor as Actor == Azazel && abSneakAttack && akWeapon.IsDagger()
			float health = enemy.GetActorValue("health")
			float increasedDamage = akWeapon.GetBaseDamage() * 5
			MiscUtil.PrintConsole("Azazel's first stealth strike on enemy, decreasing health by " + increasedDamage)
			enemy.SetActorValue("health", health - increasedDamage)
		endif
		IsFirstHit = true
	endif
EndEvent