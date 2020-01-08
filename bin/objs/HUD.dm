mob/proc
	DrawHUD(mob/M = usr)	//Draws the user's HUD.
		var/HUD/H
		if(M.client)
			for(H in M.client.screen)		//First, clear the client's screen so that we draw completely new items...
				M.client.screen.Remove(H)	//and don't just make new ones over the old.
			M.client.screen.Add(new /HUD/GUI/bagHolder)
			M.client.screen.Add(new /HUD/bar/healthBar (U = M))
			M.client.screen.Add(new /HUD/bar/manaBar (U = M))
			var/obj/Item/Storage/Bag/S
			var/HUD/GUI/Bag/B
			var/i = 1
			for(S in M)
				B = new
				switch(i)
					if(1)
						B.screen_loc = "EAST-5:13,SOUTH:20"	//"14:13,1:20"
					if(2)
						B.screen_loc = "EAST-4:6,SOUTH:20"	//"15:6,1:20"
					if(3)
						B.screen_loc = "EAST-3,SOUTH:20"	//"16:-1,1:20"
					if(4)
						B.screen_loc = "EAST-3:26,SOUTH:20"	//"16:26,1:20"
					if(5)
						B.screen_loc = "EAST-2:19,SOUTH:20"	//"17:19,1:20"
				sleep(1)
				B.icon = S.icon
				B.placement = i
				B.bagtarget = S
				M.client.screen.Add(B)
				i++

	UpdateHUD(mob/M = usr)
		var/HUD/GUI/bagItem/BI
		var/HUD/GUI/itemContainer/IC
		var/HUD/GUI/Bag/B
		for(BI in M.client.screen)
			M.client.screen.Remove(BI)
		for(IC in M.client.screen)
			M.client.screen.Remove(IC)
		for(B in M.client.screen)
			if(B.open) B.populate_Bag(M)

	ClearHUD(mob/M = usr)
		var/HUD/GUI/bagInventory/Binv
		var/HUD/GUI/itemContainer/IC
		var/HUD/GUI/bagItem/BI
		for(Binv in M.client.screen)
			M.client.screen.Remove(Binv)
		for(BI in M.client.screen)
			M.client.screen.Remove(BI)
		for(IC in M.client.screen)
			M.client.screen.Remove(IC)


HUD
	parent_type = /obj
	layer = OBJ_LAYER + EFFECTS_LAYER + MOB_LAYER
	appearance_flags = NO_CLIENT_COLOR

	bar
		proc/Update(stat,statmax)
			var/pct = (stat/statmax) * 100
			switch(pct)
				if(0) icon_state = "0"
				if(1 to 10) icon_state = "10"
				if(11 to 20) icon_state = "20"
				if(21 to 30) icon_state = "30"
				if(31 to 40) icon_state = "40"
				if(41 to 50) icon_state = "50"
				if(51 to 60) icon_state = "60"
				if(61 to 70) icon_state = "70"
				if(71 to 80) icon_state = "80"
				if(81 to 90) icon_state = "90"
				if(91 to 100) icon_state = "100"
				if(101 to 110) icon_state = "110"
				if(111 to 120) icon_state = "120"
				if(121 to 130) icon_state = "130"
				if(131 to 140) icon_state = "140"
				if(141 to 150) icon_state = "150"
				if(151 to 160) icon_state = "160"
				if(161 to 170) icon_state = "170"
				if(171 to 180) icon_state = "180"
				if(181 to 190) icon_state = "190"
				if(191 to 200) icon_state = "200"
				if(211 to 210) icon_state = "210"
				if(211 to 220) icon_state = "220"
				if(221 to 230) icon_state = "230"
				if(231 to 240) icon_state = "240"
				if(241 to 250) icon_state = "250"
				if(251 to 260) icon_state = "260"
				if(261 to 270) icon_state = "270"
				if(271 to 280) icon_state = "280"
				if(281 to 290) icon_state = "290"
				if(291 to 300) icon_state = "300"
				else icon_state = "100"
			spawn(1) Update(stat,statmax)

		healthBar
			icon = 'healthbar.dmi'
			icon_state = "100"
			screen_loc = "CENTER-5,SOUTH+1:16"	//"6,SOUTH+1:16"
			New(mob/U)
				..()
				Update(U.STATS["CurHP"],U.STATS["UseHP"])
		manaBar
			icon = 'manabar.dmi'
			icon_state = "100"
			screen_loc = "CENTER+2,SOUTH+1:16"	//"10,SOUTH+1:16"
			New(mob/U)
				..()
				Update(U.STATS["CurMP"],U.STATS["UseMP"])

	GUI
		bagHolder
			icon = 'assets\\ui\\bagHolder.dmi'
			screen_loc = "EAST-5,SOUTH:15"	//"14,1:15"

		Bag
			var
				obj/Item/Storage/Bag/bagtarget
				open = 0
				placement
				HUD/GUI/bagInventory/Binv
			Click()
				Binv = new (placement)
				if(!open)
					open = 1
					usr.client.screen.Add(Binv)
					populate_Bag(usr)
				else
					open = 0
					usr.ClearHUD(usr)
			proc/populate_Bag(mob/M)
				for(var/i=1,i<=bagtarget.contents.len,i++)
					var/obj/O = bagtarget.contents[i]
					var/HUD/GUI/itemContainer/IC = new (i,placement)
					var/HUD/GUI/bagItem/BI = new
					BI.icon = O.icon
					BI.targetItem = O
					BI.icon_state = O.icon_state
					BI.screen_loc = IC.screen_loc
					M.client.screen.Add(IC)
					M.client.screen.Add(BI)
			proc/Open()
				set src in usr.client.screen
				Click()

		bagInventory
			icon = 'backdropI.dmi'
			layer = OBJ_LAYER + EFFECTS_LAYER + MOB_LAYER + 1
			New(i = 1)
				switch(i)
					if(1) screen_loc = "EAST-5,SOUTH+6:24 to EAST-1,SOUTH:24"		//"14,7:24 to 18,1:24"
					if(2) screen_loc = "EAST-5,SOUTH+15:24 to EAST-1,SOUTH+7:24"	//"14,14:24 to 18,8:24"
					if(3) screen_loc = "EAST-10,SOUTH+15:24 to EAST-6,SOUTH+7:24"	//"9,14:24 to 13,8:24"
					if(4) screen_loc = "EAST-10,SOUTH+6:24 to EAST-6,SOUTH:24"		//"9,7:24 to 13,1:24"
					if(5) screen_loc = "EAST-15,SOUTH+6:24 TO EAST-11,SOUTH:24"		//"4,7:24 to 8,1:24"

		itemContainer
			layer = OBJ_LAYER + EFFECTS_LAYER + MOB_LAYER + 2
			icon = 'invTiles.dmi'
			New(i = 1, x = 1)
				transform *= 1.5
				switch(x)
					if(1)
						switch(i)
							if(1)
								screen_loc = "EAST-5:9,SOUTH+6:24"
							if(2)
								screen_loc = "EAST-4:9,SOUTH+6:24"
							if(3)
								screen_loc = "EAST-3:9,SOUTH+6:24"
							if(4)
								screen_loc = "EAST-2:9,SOUTH+6:24"
							if(5)
								screen_loc = "EAST-5:9,SOUTH+5:24"
							if(6)
								screen_loc = "EAST-4:9,SOUTH+5:24"
							if(7)
								screen_loc = "EAST-3:9,SOUTH+5:24"
							if(8)
								screen_loc = "EAST-2:9,SOUTH+5:24"
							if(9)
								screen_loc = "EAST-5:9,SOUTH+4:24"
							if(10)
								screen_loc = "EAST-4:9,SOUTH+4:24"
							if(11)
								screen_loc = "EAST-3:9,SOUTH+4:24"
							if(12)
								screen_loc = "EAST-2:9,SOUTH+4:24"
							if(13)
								screen_loc = "EAST-5:9,SOUTH+3:24"
							if(14)
								screen_loc = "EAST-4:9,SOUTH+3:24"
							if(15)
								screen_loc = "EAST-3:9,SOUTH+3:24"
							if(16)
								screen_loc = "EAST-2:9,SOUTH+3:24"
							if(17)
								screen_loc = "EAST-5:9,SOUTH+2:24"
							if(18)
								screen_loc = "EAST-4:9,SOUTH+2:24"
							if(19)
								screen_loc = "EAST-3:9,SOUTH+2:24"
							if(20)
								screen_loc = "EAST-2:9,SOUTH+2:24"
							if(21)
								screen_loc = "EAST-5:9,SOUTH+1:24"
							if(22)
								screen_loc = "EAST-4:9,SOUTH+1:24"
							if(23)
								screen_loc = "EAST-3:9,SOUTH+1:24"
							if(24)
								screen_loc = "EAST-2:9,SOUTH+1:24"
					if(2)
						switch(i)
							if(1)
								screen_loc = "EAST-5:9,14:24"
							if(2)
								screen_loc = "EAST-4:9,14:24"
							if(3)
								screen_loc = "EAST-3:9,14:24"
							if(4)
								screen_loc = "EAST-2:9,14:24"
							if(5)
								screen_loc = "EAST-5:9,13:24"
							if(6)
								screen_loc = "EAST-4:9,13:24"
							if(7)
								screen_loc = "EAST-3:9,13:24"
							if(8)
								screen_loc = "EAST-2:9,13:24"
							if(9)
								screen_loc = "EAST-5:9,12:24"
							if(10)
								screen_loc = "EAST-4:9,12:24"
							if(11)
								screen_loc = "EAST-3:9,12:24"
							if(12)
								screen_loc = "EAST-2:9,12:24"
							if(13)
								screen_loc = "EAST-5:9,11:24"
							if(14)
								screen_loc = "EAST-4:9,11:24"
							if(15)
								screen_loc = "EAST-3:9,11:24"
							if(16)
								screen_loc = "EAST-2:9,11:24"
							if(17)
								screen_loc = "EAST-5:9,10:24"
							if(18)
								screen_loc = "EAST-4:9,10:24"
							if(19)
								screen_loc = "EAST-3:9,10:24"
							if(20)
								screen_loc = "EAST-2:9,10:24"
							if(21)
								screen_loc = "EAST-5:9,9:24"
							if(22)
								screen_loc = "EAST-4:9,9:24"
							if(23)
								screen_loc = "EAST-3:9,9:24"
							if(24)
								screen_loc = "EAST-2:9,9:24"
					if(3)
						switch(i)
							if(1)
								screen_loc = "EAST-10:9,14:24"
							if(2)
								screen_loc = "EAST-9:9,14:24"
							if(3)
								screen_loc = "EAST-8:9,14:24"
							if(4)
								screen_loc = "EAST-7:9,14:24"
							if(5)
								screen_loc = "EAST-10:9,13:24"
							if(6)
								screen_loc = "EAST-9:9,13:24"
							if(7)
								screen_loc = "EAST-8:9,13:24"
							if(8)
								screen_loc = "EAST-7:9,13:24"
							if(9)
								screen_loc = "EAST-10:9,12:24"
							if(10)
								screen_loc = "EAST-9:9,12:24"
							if(11)
								screen_loc = "EAST-8:9,12:24"
							if(12)
								screen_loc = "EAST-7:9,12:24"
							if(13)
								screen_loc = "EAST-10:9,11:24"
							if(14)
								screen_loc = "EAST-9:9,11:24"
							if(15)
								screen_loc = "EAST-8:9,11:24"
							if(16)
								screen_loc = "EAST-7:9,11:24"
							if(17)
								screen_loc = "EAST-10:9,10:24"
							if(18)
								screen_loc = "EAST-9:9,10:24"
							if(19)
								screen_loc = "EAST-8:9,10:24"
							if(20)
								screen_loc = "EAST-7:9,10:24"
							if(21)
								screen_loc = "EAST-10:9,9:24"
							if(22)
								screen_loc = "EAST-9:9,9:24"
							if(23)
								screen_loc = "EAST-8:9,9:24"
							if(24)
								screen_loc = "EAST-7:9,9:24"
					if(4)
						switch(i)
							if(1)
								screen_loc = "EAST-10:9,SOUTH+6:24"
							if(2)
								screen_loc = "EAST-9:9,SOUTH+6:24"
							if(3)
								screen_loc = "EAST-8:9,SOUTH+6:24"
							if(4)
								screen_loc = "EAST-7:9,SOUTH+6:24"
							if(5)
								screen_loc = "EAST-10:9,SOUTH+5:24"
							if(6)
								screen_loc = "EAST-9:9,SOUTH+5:24"
							if(7)
								screen_loc = "EAST-8:9,SOUTH+5:24"
							if(8)
								screen_loc = "EAST-7:9,SOUTH+5:24"
							if(9)
								screen_loc = "EAST-10:9,SOUTH+4:24"
							if(10)
								screen_loc = "EAST-9:9,SOUTH+4:24"
							if(11)
								screen_loc = "EAST-8:9,SOUTH+4:24"
							if(12)
								screen_loc = "EAST-7:9,SOUTH+4:24"
							if(13)
								screen_loc = "EAST-10:9,SOUTH+3:24"
							if(14)
								screen_loc = "EAST-9:9,SOUTH+3:24"
							if(15)
								screen_loc = "EAST-8:9,SOUTH+3:24"
							if(16)
								screen_loc = "EAST-7:9,SOUTH+3:24"
							if(17)
								screen_loc = "EAST-10:9,SOUTH+2:24"
							if(18)
								screen_loc = "EAST-9:9,SOUTH+2:24"
							if(19)
								screen_loc = "EAST-8:9,SOUTH+2:24"
							if(20)
								screen_loc = "EAST-7:9,SOUTH+2:24"
							if(21)
								screen_loc = "EAST-10:9,SOUTH+1:24"
							if(22)
								screen_loc = "EAST-9:9,SOUTH+1:24"
							if(23)
								screen_loc = "EAST-8:9,SOUTH+1:24"
							if(24)
								screen_loc = "EAST-7:9,SOUTH+1:24"
					if(5)
						switch(i)
							if(1)
								screen_loc = "EAST-15:9,SOUTH+6:24"
							if(2)
								screen_loc = "EAST-14:9,SOUTH+6:24"
							if(3)
								screen_loc = "EAST-13:9,SOUTH+6:24"
							if(4)
								screen_loc = "EAST-12:9,SOUTH+6:24"
							if(5)
								screen_loc = "EAST-15:9,SOUTH+5:24"
							if(6)
								screen_loc = "EAST-14:9,SOUTH+5:24"
							if(7)
								screen_loc = "EAST-13:9,SOUTH+5:24"
							if(8)
								screen_loc = "EAST-12:9,SOUTH+5:24"
							if(9)
								screen_loc = "EAST-15:9,SOUTH+4:24"
							if(10)
								screen_loc = "EAST-14:9,SOUTH+4:24"
							if(11)
								screen_loc = "EAST-13:9,SOUTH+4:24"
							if(12)
								screen_loc = "EAST-12:9,SOUTH+4:24"
							if(13)
								screen_loc = "EAST-15:9,SOUTH+3:24"
							if(14)
								screen_loc = "EAST-14:9,SOUTH+3:24"
							if(15)
								screen_loc = "EAST-13:9,SOUTH+3:24"
							if(16)
								screen_loc = "EAST-12:9,SOUTH+3:24"
							if(17)
								screen_loc = "EAST-15:9,SOUTH+2:24"
							if(18)
								screen_loc = "EAST-14:9,SOUTH+2:24"
							if(19)
								screen_loc = "EAST-13:9,SOUTH+2:24"
							if(20)
								screen_loc = "EAST-12:9,SOUTH+2:24"
							if(21)
								screen_loc = "EAST-15:9,SOUTH+1:24"
							if(22)
								screen_loc = "EAST-14:9,SOUTH+1:24"
							if(23)
								screen_loc = "EAST-13:9,SOUTH+1:24"
							if(24)
								screen_loc = "EAST-12:9,SOUTH+1:24"
		bagItem
			var/obj/Item/targetItem
			layer = OBJ_LAYER + EFFECTS_LAYER + MOB_LAYER + 3
			Click()
				targetItem.Click(usr)

obj/iconMenuItem
	Click()
		usr:setSpellIcon = src.icon