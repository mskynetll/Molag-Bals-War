Scriptname mbwAzazelSetOutfitRef extends ReferenceAlias

Zadlibs Property libs Auto

GlobalVariable Property mbwIsAzazelArmsBound Auto

Actor Property Azazel Auto
Actor Property Player Auto

int Property MaxOutfitItems = 10 autoReadOnly hidden


Event OnItemAdded(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
	if akSourceContainer == Player
		Armor akArmor = akBaseItem as Armor
		if akArmor != None && akArmor.HasKeyword(libs.zad_Lockable) == false 			
		endif
	endif
EndEvent