mob
	login
		Login()
			loc = null

		verb
			NEW()
				if(loaded)
					winset(usr,"newload","is-visible=false")
					var/mob/P = new /mob/pc
					P.Move(locate(20,15,1))
					P.EQUIP = new
					P.EQUIP.holder = P
					P.SPELL = new
					P.SPELL.holder = P
					new /obj/Item/Storage/Bag/Backpack (P)
					usr.client.mob = P

			LOAD()
				set hidden = 1
				if(global.loaded != 1)
					src << "<font color = red>YOU MUST WAIT UNTIL THE MAP IS LOADED!"
					return
				else
					var/list/userSavs = flist("players/[usr.ckey]/")
					if(userSavs.len < 1)
						usr << "<font color = red>You do not have a save file!"
						return
					winset(src,"newload","is-visible=false")
					winset(src,"testmap","is-visible=true")
					winset(src,"testmap.map","is-visible=true")
					sleep(5)
					var/M = input("Which character would you like to load?", "Choose Character", "Cancel") in list("Cancel") + userSavs
					if(M == "Cancel")
						winset(src,"newload","is-visible=true")
						return
					if(usr.client) Load_Mob(usr.ckey, M, usr.client)
					del usr