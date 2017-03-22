;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname TIF__0800CFCE Extends TopicInfo Hidden

Actor Property AzazelRef Auto
Actor Property PlayerRef Auto
FormList Property mbwAzazelArmorsList Auto
Keyword Property ArmorLight Auto
Keyword Property ArmorClothing Auto

ReferenceAlias Property AzazelSetOutfitRef Auto

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
;BEGIN CODE
	int index = PlayerRef.GetNumItems()
	while index > 0
		index -= 1
		Form kForm = PlayerRef.GetNthForm(index)
		if (kForm.HasKeyword(ArmorLight) || kForm.HasKeyword(ArmorClothing)) && mbwAzazelArmorsList.HasForm(kForm) == false
			mbwAzazelArmorsList.AddForm(kForm)
		endIf
	endwhile

	AzazelSetOutfitRef.ForceRefTo(AzazelRef)
	AzazelRef.ShowGiftMenu(true, mbwAzazelArmorsList, false)
	AzazelSetOutfitRef.Clear()
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
