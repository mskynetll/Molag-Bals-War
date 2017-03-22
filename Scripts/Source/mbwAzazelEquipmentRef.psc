Scriptname mbwAzazelEquipmentRef extends ReferenceAlias

Zadlibs Property libs Auto

GlobalVariable Property mbwAzazelWornDevicesCount Auto
GlobalVariable Property mbwIsAzazelArmsBound Auto

Actor Property Azazel Auto
Actor Property Player Auto

int Property MaxOutfitItems = 10 autoReadOnly hidden

Outfit Property NullOutfit  Auto
Outfit Property AzazelDefaultOutfit  Auto

Weapon Property FollowerHuntingBow  Auto
Weapon Property DummyDagger  Auto
Ammo Property FollowerIronArrow  Auto
Faction Property DismissedFollowerFaction Auto

Keyword Property VendorItemFood Auto
Keyword Property VendorItemFoodRaw Auto
Keyword Property VendorItemArmor Auto
Keyword Property VendorItemWeapon Auto
Keyword Property VendorItemPoison Auto
Keyword Property VendorItemPotion Auto

Spell Property TeleportLaggingFollowerSpell Auto

mbwEventsDispatcherQuest Property EventsDispatcherQuest Auto
mbwConfigQuest Property ConfigQuest Auto

string Property FoodListKey = "mbw_AzazelsFoodList" AutoReadonly

Function RemoveDefaultHuntingBow()
	Azazel.RemoveItem(FollowerHuntingBow, Azazel.GetItemCount(FollowerHuntingBow))
	Azazel.RemoveItem(FollowerIronArrow, Azazel.GetItemCount(FollowerIronArrow))
endFunction

Function ReEquip()
	if (Azazel.Is3DLoaded())
		Utility.Wait(0.5)
		Azazel.AddItem(DummyDagger)
		Azazel.RemoveItem(DummyDagger)
	endif
EndFunction

;when item is removed, try to find something to wear on that slot
Function ConsiderReplacing(Armor akArmor)
	;hands are bound, can't wear anyway
	if mbwIsAzazelArmsBound.GetValue() == 1.0
		return
	endif

	Armor replacementArmor = TryFindArmorInInventoryForSlot(akArmor.GetSlotMask())
	if replacementArmor != None
		Azazel.EquipItem(replacementArmor, false, true)
	endif
EndFunction

Armor Function TryFindArmorInInventoryForSlot(int targetSlotMask)
	int index = Azazel.GetNumItems()
	Armor candidateForReplacement = None
	while index > 0
		index -= 1
		Armor currentArmor = Azazel.GetNthForm(index) as Armor
		if currentArmor != None && currentArmor.GetSlotMask() == targetSlotMask
			if currentArmor != None
				if currentArmor.GetGoldValue() > candidateForReplacement.GetGoldValue()
					candidateForReplacement = currentArmor
				elseif currentArmor.IsLightArmor() && candidateForReplacement.IsHeavyArmor()
					candidateForReplacement = currentArmor
				elseif (currentArmor.IsLightArmor() || candidateForReplacement.IsHeavyArmor()) && candidateForReplacement.IsClothing()
					candidateForReplacement = currentArmor
				endif
			else
				candidateForReplacement = currentArmor
			endif
		endif
	endwhile	

	return candidateForReplacement	
EndFunction

Function ConsiderWearing(Armor akArmor)
	;hands are bound, can't wear anyway
	if mbwIsAzazelArmsBound.GetValue() == 1.0
		return
	endif

	Armor wornArmor = Azazel.GetWornForm(akArmor.GetSlotMask()) as Armor
	if wornArmor == None
		Azazel.EquipItem(akArmor, false, true)
	else
		if akArmor.GetGoldValue() > wornArmor.GetGoldValue()
			Azazel.EquipItem(akArmor, false, true)	;Azazel likes gold and likes expensive stuff :D
		endif
	endif
EndFunction

;TODO : find ways to implement this more efficient
; currently it is around O(m * n) with m is slot count and n is item count in inventory  :\
Function EquipArmorIfAvailable()	
	Utility.Wait(0.1)

	;hands are bound, can't equip stuff anyway
	if mbwIsAzazelArmsBound.GetValue() == 1.0
		return
	endif

    int slotsChecked
    slotsChecked += 0x00100000
    slotsChecked += 0x00200000 ;ignore reserved slots
    slotsChecked += 0x80000000
 
    int currentSlot = 0x01
    while (currentSlot < 0x80000000)
        if (Math.LogicalAnd(slotsChecked, currentSlot) != currentSlot) ;only check slots we haven't found anything equipped on already
            Armor currentArmor = Azazel.GetWornForm(currentSlot) as Armor
            if currentArmor == None
            	Armor toWearArmor = TryFindArmorInInventoryForSlot(currentSlot)
            	if toWearArmor != None
            		Azazel.EquipItem(toWearArmor, false, true)            		
            	endif
                slotsChecked += currentArmor.GetSlotMask() ;add all slots this item covers to our slotsChecked variable
            else ;no armor was found on this slot
                slotsChecked += currentSlot
            endif
        endif
        currentSlot *= 2 ;double the number to move on to the next slot
    endWhile
EndFunction


Auto STATE Waiting
Event OnLoad()
	Azazel.SetOutfit(NullOutfit)	
	EquipArmorIfAvailable()
	ReEquip()	
endEvent

Event OnPackageStart(Package akNewPackage)
	if Azazel.IsPlayerTeammate()
		if ConfigQuest.ConsoleDebugEnabled	
			MiscUtil.PrintConsole("[mbw] Setting Azazel to 'following' state")
		endif
		EventsDispatcherQuest.SetAzazelActiveFollower()
				
		EquipArmorIfAvailable()
		ReEquip()
		Azazel.AddSpell(TeleportLaggingFollowerSpell, false)
		TeleportLaggingFollowerSpell.Cast(None, Azazel)
		RemoveAllInventoryEventFilters()
		AddInventoryEventFilter(VendorItemArmor)
		AddInventoryEventFilter(VendorItemWeapon)
		AddInventoryEventFilter(VendorItemPoison)
		AddInventoryEventFilter(VendorItemPotion)
		AddInventoryEventFilter(VendorItemFood)
		AddInventoryEventFilter(VendorItemFoodRaw)

		GoToState("Following")
		RemoveDefaultHuntingBow()		
	endif
endEvent

Event OnItemRemoved(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akDestContainer)
	if Azazel.Is3DLoaded()
		EquipArmorIfAvailable()
	endif
	
	Potion food = akBaseItem as Potion
	if food != None && food.IsFood()
		StorageUtil.FormListRemove(none, FoodListKey, akBaseItem, false)		
	endif
endEvent

Event OnItemAdded(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
	if Azazel.Is3DLoaded()
		EquipArmorIfAvailable()
	endif
endEvent


Endstate

STATE Following

Event OnLocationChange(Location akOldLoc, Location akNewLoc)
	if mbwIsAzazelArmsBound.GetValue() == 0
		EquipArmorIfAvailable()
	endif
	Azazel.DispelSpell(TeleportLaggingFollowerSpell)
	Azazel.RemoveSpell(TeleportLaggingFollowerSpell)
	Azazel.AddSpell(TeleportLaggingFollowerSpell, false)
	TeleportLaggingFollowerSpell.Cast(None, Azazel)
EndEvent

Event OnItemAdded(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
	if akSourceContainer == Player
		Armor akArmor = akBaseItem as Armor
		if akArmor != None && akArmor.HasKeyword(libs.zad_Lockable) == false
			EventsDispatcherQuest.AzazelArmorItemAdd(akArmor,aiItemCount)
			ConsiderWearing(akArmor)
		endif
	endif
EndEvent

Event OnItemRemoved(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akDestContainer)
	Potion food = akBaseItem as Potion
	if food != None && food.IsFood()
		StorageUtil.FormListRemove(none, FoodListKey, akBaseItem, false)	
		return	
	endif

 	if akDestContainer == Player
 		Armor akArmor = akBaseItem as Armor
 		if akArmor != None
 			ConsiderReplacing(akArmor)
 		endif
	endif
endEvent

Event OnObjectUnequipped(Form akBaseObject, ObjectReference akReference)
	Armor akArmor = akBaseObject as Armor
	if akArmor != None 
		if akArmor.HasKeyword(libs.zad_Lockable)
	   		mbwAzazelWornDevicesCount.Mod(-1.0)
	   		EventsDispatcherQuest.AzazelUnequipOfDeviousDevice(akArmor)
			if akArmor.HasKeyword(libs.zad_DeviousArmbinder) || akArmor.HasKeyword(libs.zad_DeviousYoke)
				mbwIsAzazelArmsBound.SetValue(0.0)
				EquipArmorIfAvailable() ;go through inventory and equip armors as needed
			endif
		endif		
	endif
endEvent

Event OnObjectEquipped(Form akBaseObject, ObjectReference akReference)
	Armor akArmor = akBaseObject as Armor
	if akArmor != None
		if akArmor.HasKeyword(libs.zad_Lockable)
	   		mbwAzazelWornDevicesCount.Mod(1.0)
	   		EventsDispatcherQuest.AzazelEquipOfDeviousDevice(akArmor)
			if akArmor.HasKeyword(libs.zad_DeviousArmbinder) || akArmor.HasKeyword(libs.zad_DeviousYoke)
				mbwIsAzazelArmsBound.SetValue(1.0)
			endif
		endif
	endif
endEvent

Event OnPackageChange(Package akOldPackage)
	If Azazel.IsInFaction(DismissedFollowerFaction)
		if ConfigQuest.ConsoleDebugEnabled			
			MiscUtil.PrintConsole("[mbw] Setting Azazel to 'waiting' state")
		endif

		Azazel.DispelSpell(TeleportLaggingFollowerSpell)
		Azazel.RemoveSpell(TeleportLaggingFollowerSpell)

		EventsDispatcherQuest.SetAzazelInactiveFollower()
		GoToState("Waiting")
		RemoveAllInventoryEventFilters()
	endif
endEvent


EndState