Scriptname mbwPlayerEquipmentRef extends ReferenceAlias

GlobalVariable Property IsWearingNippleChainCollar Auto
GlobalVariable Property IsWearingArmbinder Auto
GlobalVariable Property IsWearingNippleClamps Auto

; collars with nipple chains
Armor Property NippleChainCollar Auto
Armor Property RustyNippleChainCollar Auto
Armor Property NippleChainHarness Auto
Armor Property RustyNippleChainHarness Auto

; armbinders
Armor Property Armbinder Auto
Armor Property ArmbinderEbonite Auto
Armor Property ArmbinderRDE Auto
Armor Property ArmbinderRDL Auto
Armor Property ArmbinderWTE Auto
Armor Property ArmbinderWTL Auto

Armor Property NippleClamps Auto

Spell Property AfterArmbinderRemovalSpell Auto

Event OnObjectEquipped(Form akBaseObject, ObjectReference akReference)
  if akBaseObject as Armor
  	Armor akArmorObject = akBaseObject as Armor
    if akArmorObject == NippleChainCollar || akArmorObject == RustyNippleChainCollar || akArmorObject == NippleChainHarness || akArmorObject == RustyNippleChainHarness
    	IsWearingNippleChainCollar.SetValueInt(1)
    elseif akArmorObject == Armbinder || akArmorObject == ArmbinderRDE || akArmorObject == ArmbinderRDL || akArmorObject == ArmbinderWTL || akArmorObject == ArmbinderWTE || akArmorObject == ArmbinderEbonite      
      IsWearingArmbinder.SetValueInt(1)
    endif
  endIf
endEvent

Event OnObjectUnequipped(Form akBaseObject, ObjectReference akReference)
  if akBaseObject as Armor
  	Armor akArmorObject = akBaseObject as Armor
    if akArmorObject == NippleChainCollar || akArmorObject == RustyNippleChainCollar || akArmorObject == NippleChainHarness || akArmorObject == RustyNippleChainHarness
    	IsWearingNippleChainCollar.SetValueInt(0)
    elseif akArmorObject == Armbinder || akArmorObject == ArmbinderRDE || akArmorObject == ArmbinderRDL || akArmorObject == ArmbinderWTL || akArmorObject == ArmbinderWTE || akArmorObject == ArmbinderEbonite    
      AfterArmbinderRemovalSpell.Cast(Game.GetPlayer())      
      IsWearingArmbinder.SetValueInt(0)
    endif    
  endIf
endEvent