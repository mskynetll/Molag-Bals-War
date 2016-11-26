Scriptname mbwAzazelInteractionsQuest extends Quest Conditional

string Property ModVersion Auto hidden
bool Property OneTimeInitialize Auto hidden

mbwAzazelEquipmentRef Property AzazelEquipmentRef Auto
mbwConfigQuest Property ConfigQuest Auto

bool Property IsPlayerAzazelsApprentice Auto Conditional

Event OnInit()
	Maintenance()
EndEvent

Function Maintenance()
	If ModVersion == ""
		If !OneTimeInitialize
			Debug.Notification("Molag Bal's War Initializing...")
		    OneTimeInitialize = true
		EndIf
		ModVersion = "0.0.5"	

		if AzazelEquipmentRef.ItemCount == 0
			
			AzazelEquipmentRef.TryAddToArmorSlot(ConfigQuest.AzazelDefaultCuirass)
			AzazelEquipmentRef.TryAddToArmorSlot(ConfigQuest.AzazelDefaultGloves)
			AzazelEquipmentRef.TryAddToArmorSlot(ConfigQuest.AzazelDefaultBoots)
		endif
	EndIf
EndFunction