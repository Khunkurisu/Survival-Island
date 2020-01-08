mob/pc
	var/list/keyList = list("A" = 0, "B" = 0, "C" = 0, "D" = 0, "E" = 0, "F" = 0, "G" = 0, "H" = 0, "I" = 0, "J" = 0, "K" = 0, "L" = 0, "M" = 0, "N" = 0, "O" = 0, "P" = 0, "Q" = 0, "R" = 0, "S" = 0, "T" = 0, "U" = 0, "V" = 0, "W" = 0, "X" = 0, "Y" = 0, "Z" = 0, "0" = 0, "1" = 0, "2" = 0, "3" = 0, "4" = 0, "5" = 0, "6" = 0, "7" = 0, "8" = 0, "9" = 0)
	proc/keyTick()
		if(usr.ACTION_FLAG != KO && usr.ACTION_FLAG != ENCUMBERED)
			if(keyList["W"])
				if(keyList["A"])
					client.Northwest()
				else if(keyList["D"])
					client.Northeast()
				else client.North()
			else if(keyList["S"])
				if(keyList["A"])
					client.Southwest()
				else if(keyList["D"])
					client.Southeast()
				else client.South()
			else if(keyList["A"])
				if(keyList["W"])
					client.Northwest()
				else if(keyList["S"])
					client.Southwest()
				else client.West()
			else if(keyList["D"])
				if(keyList["W"])
					client.Northeast()
				else if(keyList["S"])
					client.Southeast()
				else client.East()
			spawn(0.5) keyTick()

	verb
		keyUp(k as text)
			set hidden = 1
			keyList[k] = 0
		keyDown(k as text)
			set hidden = 1
			keyList[k] = 1
			if(keyList["R"])
				if(!usr.ACTION_FLAG) Cast_Primed_Spell(usr)
				else usr.ACTION_FLAG = null
			else
				usr.ACTION_FLAG = null
				if(keyList["B"])
					var/HUD/GUI/Bag/B
					for(B in usr.client.screen)
						B.Open()
				else if(keyList["C"])
					Craft_Menu()
				else if(keyList["G"])
					Get_Time()
				else if(keyList["M"])
					Make_Spell()
				else if(keyList["P"])
					usr:view_Updates(usr)
