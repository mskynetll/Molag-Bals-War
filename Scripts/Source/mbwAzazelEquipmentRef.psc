Scriptname mbwAzazelEquipmentRef extends ReferenceAlias

Actor Property Azazel Auto
int Property MaxOutfitItems = 10 autoReadOnly hidden
string Property OutfitPropertyName = "mbwAzazelOutfitProperty" autoReadOnly hidden

Outfit Property NullOutfit  Auto
Outfit Property AzazelDefaultOutfit  Auto

Weapon Property FollowerHuntingBow  Auto
Weapon Property DummyDagger  Auto
Ammo Property FollowerIronArrow  Auto
Faction Property DismissedFollowerFaction Auto

mbwConfigQuest Property ConfigQuest Auto

Function EquipCurrentArmor()
	Utility.Wait(0.1)
	int outfitItemCount = StorageUtil.FormListCount(Azazel, OutfitPropertyName)
	int index = 0
	while index < outfitItemCount
		Form item = StorageUtil.FormListGet(Azazel, OutfitPropertyName, index)
		if item != None && Azazel.GetItemCount(item) > 0
			MiscUtil.PrintConsole("Trying to equip [" + item.GetName() + "] on Azazel")
			Azazel.EquipItem(item, false, true)
		else
			StorageUtil.FormListSet(Azazel, OutfitPropertyName, index, None)			
		endif
		index += 1
	endwhile

	;cleanup
	StorageUtil.FormListRemove(Azazel, OutfitPropertyName, None, true)
EndFunction


int Property ItemCount
	int Function Get()
		return StorageUtil.FormListCount(Azazel, OutfitPropertyName)
	EndFunction
EndProperty

bool Function TryAddToArmorSlot(Form akBaseItem, bool shouldAddArmorToInventory = false)
	int outfitItemCount = StorageUtil.FormListCount(Azazel, OutfitPropertyName)
	if outfitItemCount >= MaxOutfitItems
		return false
	endif

    StorageUtil.FormListAdd(Azazel, OutfitPropertyName, akBaseItem, true)

    if shouldAddArmorToInventory
    	Azazel.AddItem(akBaseItem, 1, true)
    endif
	return true
EndFunction

Function RemoveDefaultHuntingBow()
	Azazel.RemoveItem(FollowerHuntingBow, Azazel.GetItemCount(FollowerHuntingBow))
	Azazel.RemoveItem(FollowerIronArrow, Azazel.GetItemCount(FollowerIronArrow))
endFunction

Function RemoveFromArmorSlot(Form akBaseItem)
	StorageUtil.FormListRemove(Azazel, OutfitPropertyName, akBaseItem, false)
EndFunction

Function ClearUnusedSlots()
	int outfitItemCount = StorageUtil.FormListCount(Azazel, OutfitPropertyName)
	int index = 0
	while index < outfitItemCount
		Form item = StorageUtil.FormListGet(Azazel, OutfitPropertyName, index)
		if item && !Azazel.IsEquipped(item)
			StorageUtil.FormListSet(Azazel, OutfitPropertyName, index, None)
		endif
		index += 1
	endwhile

	;cleanup
	StorageUtil.FormListRemove(Azazel, OutfitPropertyName, None, true)
EndFunction

Function ReEquip()
	if (Azazel.Is3DLoaded())
		Utility.Wait(0.5)
		Azazel.AddItem(DummyDagger)
		Azazel.RemoveItem(DummyDagger)
	endif
EndFunction

Auto STATE Waiting
Event OnLoad()
	Azazel.SetOutfit(AzazelDefaultOutfit)
	ReEquip()
endEvent

Event OnPackageStart(Package akNewPackage)
	if Azazel.IsPlayerTeammate()
		MiscUtil.PrintConsole("[mbw] Setting Azazel to 'following' state")
		GoToState("Following")
		RemoveDefaultHuntingBow()		
	endif
endEvent

Event OnItemRemoved(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akDestContainer)
	if Azazel.Is3DLoaded()
		EquipCurrentArmor()
	endif
endEvent

Event OnItemAdded(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
	if Azazel.Is3DLoaded()
		EquipCurrentArmor()
	endif
endEvent

Endstate

STATE Following

Event OnLocationChange(Location akOldLoc, Location akNewLoc)
	EquipCurrentArmor()
EndEvent

Event OnLoad()
	Azazel.SetOutfit(NullOutfit)
	EquipCurrentArmor()	
	ReEquip()
endEvent

Event OnObjectUnequipped(Form akBaseObject, ObjectReference akReference)
	if akBaseObject as Armor
		RemoveFromArmorSlot(akBaseObject)
	endif
endEvent

Event OnObjectEquipped(Form akBaseObject, ObjectReference akReference)
	if akBaseObject as Armor
		TryAddToArmorSlot(akBaseObject)
	endif
endEvent

Event OnPackageChange(Package akOldPackage)
	If Azazel.IsInFaction(DismissedFollowerFaction)
		MiscUtil.PrintConsole("[mbw] Setting Azazel to 'waiting' state")
		GoToState("Waiting")
	endif
endEvent
EndState