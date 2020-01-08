mob
	step_size = 8		//moves the mob 8 pixels per step at default movement speed.
	bound_x = 10 		//bounding box (hitbox, essentially) for the mob starts 10 pixels from the left edge.
	bound_y = 0			//bounding box for the mob starts at the very bottom edge.
	bound_height = 16	//bounding box for the mob stretches up 27 pixels from the bottom edge.
	bound_width = 14	//bounding box for the mob stretches over 24 pixels from the left edge, starting at point 10.
	var/icon/head,icon/torso,icon/limbs,icon/full	//a variable icon for each body part, as well as the full icon.
	layer = MOB_LAYER	//drawing layer set to MOB LAYER which is defined in main.dm

	var
		list/baseSTAT = list("int" = 0, "spi" = 0, "will" = 0, "dex" = 0, "bal" =0, "per" = 0, "str" = 0, "sta" = 0, "vit" = 0)
		list/STATS = list("MaxHP" = 0, "MaxMP" = 0, "UseHP" = 0, "UseMP" = 0, "CurHP" = 0, "CurMP" = 0, "int" = 0, "spi" = 0, "will" = 0, "dex" = 0, "bal" =0, "per" = 0, "str" = 0, "sta" = 0, "vit" = 0, "MaxCarry" = 100, "CurCarry" = 0, "Fatigue" = 0)
		admin = 1
		adminMenu = 0
		age
		race
		list/ANCESTRY = list("Mother" = "", "MGFather" = "", "MGMother" = "", "Father" = "", "PGFather" = "", "PGMother" = "")
		Equipment/EQUIP
		Spellbook/SPELL
		lastAttack = 0
		lastClick = 0
		lastMove = 0
		ACTION_FLAG
		Magic/spellRecipe/PRIMEDSPELL
		list/canCraft = new
		list/headIcons = new
		list/torsoIcons = new
		list/limbIcons = new
	verb
		Say(msg as text)
			var/range = 8
			if(!msg) return 0
			if(findtext(msg,"/h ",1,3))
				usr << "FOUND /h IN THE TEXT!"
				msg = replacetext(msg, "/h ", "")
				usr.help_command(msg)
				return
			if(findtext(msg,"/help ",1,6))
				msg = replacetext(msg, "/help ", "")
				usr.help_command(msg)
				return
			if(findtext(msg,"/w ",1,3))
				msg = replacetext(msg, "/w ", "")
				range = 2
			if(findtext(msg,"/y ",1,3))
				msg = replacetext(msg, "/y ", "")
				range = 16
			view(range) << "[usr.name]: [html_encode(msg)]"
		OOC(msg as text)
			if(!msg) return 0
			world << "[usr.key]: [html_encode(msg)]"
		Emote(msg as message)
			view() << "<font color = yellow>[html_encode(msg)]"
	proc
		Craft_Menu()
			var/obj/Item/CI = input("Choose an item to craft.", "Crafting", "Cancel") in list("Cancel") + canCraft
			if(CI == "Cancel") return
			if(!(CI in canCraft)) return
			usr << "Crafting [CI]!"
			CI.Craft(usr)
			usr.Inventory(usr)

		Get_Time()
			if(minute < 10) minute = "0[minute]"
			else minute = num2text(minute)
			usr << "<font color = white> It is currently [hour]:[minute] on day [curDay] of the [curMonth]\th month of the [curYear]\th year since arrival."
			minute = text2num(minute)

		help_command(msg)
			if(!msg)
				usr << "Command tags:"
				usr << "\t/h or /help for help"
				usr << "\t/w \[msg\] to whisper"
				usr << "\t/y \[msg\] to yell"

		Stat_Maths(mob/M)
			M.STATS["MaxHP"] = round((M.STATS["vit"] + 10) ** 2.75)
			M.STATS["MaxMP"] = round((M.STATS["spi"] + 4) ** 2.5)
			var/MPmod = (rand() * 100) + 50
			var/HPmod = (rand() * 100) + 50
			M.STATS["UseHP"] = M.STATS["MaxHP"] * (HPmod / 100)
			M.STATS["UseMP"] = M.STATS["MaxMP"] * (MPmod / 100)
			M.STATS["MaxCarry"] = round((M.STATS["str"] + 5) ** 2.25)

		Prime_Spell(mob/M,Magic/spellRecipe/R)
			if(!R in M.SPELL) return 0
			if(M.PRIMEDSPELL == R)
				M.PRIMEDSPELL = null
				M << "[M] no longer has a primed spell!"
			else
				M.PRIMEDSPELL = R
				M << "[M] primed the spell [R]!"

		Cast_Primed_Spell(mob/M)
			if(M.PRIMEDSPELL)
				if(M.PRIMEDSPELL.pointer == /Magic/Projectile/Beam)
					M.ACTION_FLAG = CASTING
				view(M.client.view,M) << "[M] casts [M.PRIMEDSPELL]!"
				M.PRIMEDSPELL.castSpell(M)

		Die(mob/M)


		Luminescence()
			set src in usr
			usr << (src.luminosity ? "You have stopped glowing." : "You begin to glow!")
			if(src.luminosity) src.appearance_flags = NO_CLIENT_COLOR
			else src.appearance_flags = null
			src.luminosity = !src.luminosity
