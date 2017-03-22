Scriptname mbwAzazel extends Actor

mbwAzazelInteractionsQuest Property AzazelInteractionsQuest Auto
mbwAzazelNeedsQuest Property AzazelNeedsQuest Auto

Keyword Property VendorItemFood Auto ;this includes drinks also, apparently
Keyword Property VendorItemFoodRaw Auto

Event OnItemAdded(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
	If akSourceContainer == Game.GetPlayer()
		if akBaseItem.HasKeyword(VendorItemFood) || akBaseItem.HasKeyword(VendorItemFoodRaw)
			self.RemoveItem(akBaseItem,aiItemCount)
			AzazelNeedsQuest.OnGiveFoodOrDrink(akBaseItem,aiItemCount)
		endif
	EndIf
EndEvent