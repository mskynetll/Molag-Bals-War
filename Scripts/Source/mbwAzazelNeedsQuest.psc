Scriptname mbwAzazelNeedsQuest extends Quest Conditional

mbwConfigQuest Property Config Auto

GlobalVariable Property mbwAzazelHunger Auto
GlobalVariable Property mbwAzazelSleep Auto
GlobalVariable Property mbwAzazelThirst Auto

string Property FoodListKey = "mbw_AzazelsFoodList" AutoReadonly

Event OnInit()
	Maintenance()
EndEvent

Function Maintenance()	

EndFunction

;this is called from mbwAzazel (kind of 'callback')
Function OnGiveFoodOrDrink(Form akBaseItem, int aiItemCount)	
	Potion food = akBaseItem as Potion
	if food != None && food.IsFood()
		if Config.ConsoleDebugEnabled
			MiscUtil.PrintConsole("[mbw] Gave drink/food to Azazel... The food item given is " + food.GetName())
		endif
		StorageUtil.FormListAdd(None, FoodListKey, akBaseItem)
	endif
EndFunction

;this is called from mbwEventsDispatcherQuest (kind of 'callback')
Function OnSexAnimationEnd(string eventName, string argString, float argNum, form sender)
	;is this needed here?
EndFunction

;this is called from mbwEventsDispatcherQuest (kind of 'callback')
Function OnGameTimePass(float hoursPassed)
	if Config.AzazelNeedsEnabled && IsAzazelActiveFollower
		if Config.ConsoleDebugEnabled
			MiscUtil.PrintConsole("[mbw] OnGameTimePass(), passed " + hoursPassed + " game hours - updating Azazel's needs.")
		endif

		mbwAzazelHunger.Mod(hoursPassed * Config.AzazelHungerIncreasePerHour)
		PreventInvalidValue(mbwAzazelHunger)
		if Config.ConsoleDebugEnabled
			MiscUtil.PrintConsole("[mbw] mod hunger value by " + hoursPassed * Config.AzazelHungerIncreasePerHour)
		endif

		mbwAzazelThirst.Mod(hoursPassed * Config.AzazelThirstIncreasePerHour)
		PreventInvalidValue(mbwAzazelThirst)
		if Config.ConsoleDebugEnabled
			MiscUtil.PrintConsole("[mbw] mod thirst value by " + hoursPassed * Config.AzazelThirstIncreasePerHour)
		endif

		mbwAzazelSleep.Mod(hoursPassed * Config.AzazelSleepIncreasePerHour)
		PreventInvalidValue(mbwAzazelSleep)
		if Config.ConsoleDebugEnabled
			MiscUtil.PrintConsole("[mbw] mod fatigue value - " + hoursPassed * Config.AzazelSleepIncreasePerHour)
		endif

		ConsiderEatingSomething()
		ConsiderDrinkingSomething()
	endif
EndFunction

Function ConsiderEatingSomething()
	if mbwAzazelHunger.GetValue() >= 33.0
	endif
EndFunction

Function ConsiderDrinkingSomething()	
	if mbwAzazelThirst.GetValue() >= 33.0
	endif
EndFunction

;this is called from mbwEventsDispatcherQuest (kind of 'callback')
Function OnSleepEnd(float hoursPassed,bool interrupted)
	if Config.AzazelNeedsEnabled && IsAzazelActiveFollower
		if Config.ConsoleDebugEnabled
			MiscUtil.PrintConsole("[mbw] OnSleepEnd(), slept for " + hoursPassed + " game hours - updating Azazel's needs.")
		endif
		mbwAzazelSleep.Mod(-hoursPassed * Config.AzazelSleepDecreasePerHour)
		PreventInvalidValue(mbwAzazelSleep)
	endif
EndFunction

Function PreventInvalidValue(GlobalVariable theVariable)
	float val = theVariable.GetValue()
	if val > 100.0
		theVariable.SetValue(100.0)
	elseif val <= 0.0
		theVariable.SetValue(0.0)
	endif
EndFunction

bool Property IsAzazelActiveFollower Hidden
	bool Function Get()				
		if StorageUtil.GetIntValue(None, "mbw_IsAzazelActiveFollower") == 1
			return true
		else
			return false
		endif 
	EndFunction
	Function Set(bool value)
		if value
			StorageUtil.SetIntValue(None, "mbw_IsAzazelActiveFollower", 1)
		else
			StorageUtil.SetIntValue(None, "mbw_IsAzazelActiveFollower", 0)
		endif
	EndFunction
EndProperty