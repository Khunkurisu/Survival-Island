mob/pc
	icon = 'defaultmale.dmi'
	var/setSpellIcon
	Login()
		..()
		keyTick()
		EQUIP = new (usr)
		EQUIP.holder = usr
		SPELL = new (usr)
		SPELL.holder = usr
		STATS["MaxHP"] = 150
		STATS["MaxMP"] = 100
		STATS["UseHP"] = STATS["MaxHP"] * (rand() * 100)
		STATS["UseMP"] = STATS["MaxMP"] * (rand() * 100)
		STATS["CurHP"] = STATS["UseHP"]
		STATS["CurMP"] = STATS["UseMP"]
		STATS["int"] = 99
		Inventory(usr)
		DrawHUD(usr)

	Logout()
		. = ..()
		var/list/userSavs = flist("players/[usr.ckey]/")
		var/player_sav = "[usr.name].sav"
		if(!player_sav in userSavs && userSavs.len >=3)
			var/i = input("Delete a save file or give up on saving?", "Save Management", "Give Up") in list("Give Up") + userSavs
			if(i == "Give Up") return .
			fdel("players\\[usr.ckey]\\[i]")
			Save_Mob(usr)
		else Save_Mob(usr)
		return .

	proc

		Edit_Spell(Magic/spellRecipe/R)

		Make_Spell()
			var/act= input("Choose an action", "Spells", "Cancel") in list("Cancel","New Spell","Edit Spell")
			switch(act)
				if("Cancel") return 0
				if("New Spell")
					var/list/spellIcons = new
					var/range = 0
					var/list/effects = new
					var/eff
					var/spellName
					var/cost
					var/icon/ico = new
					var/shape = input("Choose a spell shape.", "Shape select", "Cancel") in list("Cancel", "Projectile", "Touch", "Channel", "AoE", "Self")
					switch(shape)
						if("Cancel") return 0
						if("Projectile")
							var/exShape = input("Choose subshape.", "Subshape") in list("Orb", "Beam", "Wave", "Target")
							shape = "[shape]/[exShape]"
							spellIcons.Add(SPELLICONS[exShape])
						if("AoE")
							while(TRUE)
								range = input("Input effect range", "Effect range", 2) as num
								while(!range)
									sleep(1)
								if(range==0 || range>12) range = null
								else
									break
							spellIcons.Add(SPELLICONS[shape])
						else spellIcons.Add(SPELLICONS[shape])
					while(effects.len <=10)
						eff = input("Choose a spell effect.", "Effect select", "Done") in list("Done", "Heat", "Energy") + usr.SPELL.contents
						while(!eff)
							sleep(1)
						switch(eff)
							if("Done")
								if(effects.len < 1) continue
								else break
							if("Heat")
								var/incdec = input("Increase or decrease?") in list("Increase", "Decrease")
								var/rate = input("At what rate? (Degrees Kelvin / second)", "Rate", 15) as num
								var/dur = input("For how many seconds?", "Duration", 5) as num
								var/Element/Heat/E = new
								E.effect = incdec
								E.rate = rate
								E.dur = dur
								E.get_Cost(range)
								effects.Add(E)
							if("Energy")
								var/incdec = input("Push or pull?") in list("Push", "Pull")
								var/rate = input("At what rate? (pixels / second)", "Rate", 8) as num
								var/dur = input("For how many seconds?", "Duration", 5) as num
								var/Element/Energy/Force/E = new
								E.effect = incdec
								usr << E.effect
								E.rate = rate
								E.dur = dur
								E.get_Cost(range)
								effects.Add(E)
								/*var/t = input("Force or light energy?", "Energy type") in list("Force", "Light")
								if(t == "Force")
									var/incdec = input("Push or pull?") in list("Push", "Pull")
									var/rate = input("At what rate? (pixels / tick)", "Rate", 8) as num
									var/Element/Energy/Force/E = new
									E.effect = incdec
									E.rate = rate
									effects.Add(E)
								if(t == "Light")
									var/incdec = input("Increase or decrease?") in list("Increase", "Decrease")
									var/rate = input("How much? (lumins)", "Amount", 15) as num
									var/Element/Energy/Light/E = new
									E.effect = incdec
									E.rate = rate
									effects.Add(E)*/
							else
								effects.Add(eff)
					var/i=0
					var/o=0
					var/p=0
					var/q=0
					winset(src,"iconWindow.iconGrid",{"cells="4x[spellIcons.len+1]""})
					for(var/l=1,l<=spellIcons.len,l++)
						var/obj/iconMenuItem/I = new (usr)
						I.icon = spellIcons[l]
						switch(l)
							if(1 to 4)
								usr<<output(I,"iconWindow.iconGrid:[++i],1")
							if(5 to 8)
								usr<<output(I,"iconWindow.iconGrid:[++o],2")
							if(9 to 12)
								usr<<output(I,"iconWindow.iconGrid:[++p],3")
							if(13 to 16)
								usr<<output(I,"iconWindow.iconGrid:[++q],4")
							else
								usr  << "Fuck it broke"
					winset(usr,"iconWindow","is-visible=true")
					while(!setSpellIcon)
						sleep(1)
					ico = setSpellIcon
					setSpellIcon = null
					winset(usr,"iconWindow","is-visible=false")
					sleep(1)
					for(var/Element/E in effects)
						cost+=E.cost
					for(var/Magic/spellRecipe/R in effects)
						cost+=R.cost
					while(TRUE)
						spellName = input("What is this spell called?", "Name Spell") as text
						if(!spellName) continue
						else if(spellName == " ") continue
						else break
					var/Magic/spellRecipe/NEWSPELL = new (spellName,shape,cost,effects,range,ico)
					NEWSPELL.Move(usr.SPELL)
					usr.Inventory(usr)



				if("Edit Spell")
					act = input("Choose a spell to edit.", "Edit spell", "Cancel") in list("Cancel") + usr.SPELL.contents
					if(act == "Cancel") return 0
					Edit_Spell(act)
