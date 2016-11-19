ScriptName mbwAzazelFollowerAliasScript extends ReferenceAlias

Actor Property PlayerREF Auto
Actor Property AzazelREF Auto
bool Property Registered Auto Hidden
Light Property Torch01 Auto
ReferenceAlias Property PlayerTargetPointerRefAlias Auto
mbwConfigQuest Property Config Auto

Event OnLoad()     
     RegisterForSingleUpdate(1.0)
     AzazelREF.AddItem(Torch01)
     AzazelREF.RemoveItem(Torch01)
     if(!AzazelREF.IsPlayerTeammate())
          AzazelREF.EquipItem(Config.AzazelDefaultCuirass, false, true)
          Utility.Wait(0.25)
          AzazelREF.EquipItem(Config.AzazelDefaultGloves, false, true)
          Utility.Wait(0.25)
          AzazelREF.EquipItem(Config.AzazelDefaultBoots, false, true)
          Utility.Wait(0.25)
     endif
EndEvent

Event OnUpdate()     
     if PlayerREF.IsSneaking()
          TorchCount = AzazelREF.GetItemCount(Torch01)
          if TorchCount > 0
               MiscUtil.PrintConsole("Detected " + TorchCount + " torches on a follower, removing while sneaking")
               AzazelREF.UnequipItem(Torch01, true, false)
               AzazelREF.RemoveItem(Torch01, TorchCount, true)        
          endif
     Else
          PlayerTargetPointerRefAlias.Clear()
          if TorchCount > 0
               MiscUtil.PrintConsole("Returning to inventory " + TorchCount + " torches that belong to a follower, which removed while sneaking")
               AzazelREF.AddItem(Torch01, TorchCount, true)
          endif
     EndIf
     RegisterForSingleUpdate(1.0)
     Registered = true
EndEvent

int Property TorchCount Auto Hidden