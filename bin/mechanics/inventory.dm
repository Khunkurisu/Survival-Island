mob
	Enter(obj/Item/A)
		. = ..()
		var/obj/Item/Storage/Bag/B
		for(B in contents)
			if(B.contents.len < B.capacity)
				return .
		return 0

	Entered(obj/Item/A)
		..()
		var/obj/Item/Storage/Bag/B
		for(B in contents)
			if(B.contents.len < B.capacity)
				A.Move(B)
		//if(istype(A,B)) DrawHUD(usr)

	proc/Inventory(mob/M)
		if(M.client)
			var/obj/Item/I
			var/Magic/spellRecipe/S
			var/obj/Item/Storage/Bag/B
			var/s=1
			var/o=1
			winset(src,"equipWindow.bagGrid",{"cells="2x[M.EQUIP.contents.len + 1]""})
			M<<output("<b>Equipment</b>","equipWindow.bagGrid:1,1")
			M<<output("<b>Quantity</b>","equipWindow.bagGrid:2,1")
			M<<output("<b>Weight</b>","equipWindow.bagGrid:3,1")
			M<<output("<b>Base Value</b>","equipWindow.bagGrid:4,1")
			for(I in M.EQUIP)
				M<<output(I,"equipWindow.bagGrid:1,[++o]")
				M<<output(I.quantity,"equipWindow.bagGrid:2,[o]")
				M<<output(I.weight,"equipWindow.bagGrid:3,[o]")
				M<<output(I.worth,"equipWindow.bagGrid:4,[o]")
			sleep(1)
			winset(src,"spellWindow.bagGrid",{"cells="2x[M.SPELL.contents.len + 1]""})
			M<<output("<b>Spell</b>","spellWindow.bagGrid:1,1")
			M<<output("<b>Cost</b>","spellWindow.bagGrid:2,1")
			for(S in M.SPELL)
				M<<output(S,"spellWindow.bagGrid:1,[++s]")
				M<<output(S.cost,"spellWindow.bagGrid:2,[s]")
			sleep(1)
			for(var/i=1,i<=craftItems.len,i++)
				var/craftCheck = 0
				var/CT = craftItems[i]
				var/obj/Item/C = new CT
				for(var/x=1,x<=C.recipe.len,x++)
					var/obj/Item/R = C.recipe[x][1]
					for(B in M)
						for(var/obj/Item/T in B)
							if(istype(T,R))
								if(T.quantity >= C.recipe[x][2]) craftCheck++
				if(craftCheck == C.recipe.len)
					M.canCraft.Add(C)
				else
					if(C in M.canCraft) M.canCraft.Remove(C)
			spawn(1) UpdateHUD(M)

Equipment
	parent_type = /obj
	var/mob/holder
	Enter(obj/Item/Equipment/A)
		. = ..()
		var/obj/Item/Equipment/E
		var/mob/M = src.loc
		for(E in src)
			var/list/slots = splittext(A.slot,",")
			for(var/slot in slots)
				if(findtext(E.slot,slot))
					var/i = input("Swap [E] for [A]?", "Swap Equipment", "Yes") in list("Yes", "No")
					if(i == "No") return 0
					E.Move(M)
					M.STATS["CurCarry"] -= E.weight / ((M.STATS["str"] / 2) + 0.5)
					return .

	Entered(obj/Item/Equipment/A)
		. = ..()
		var/mob/M = holder
		M.STATS["CurCarry"] += A.weight / ((M.STATS["str"] / 2) + 0.5)

	Exited(obj/Item/Equipment/A)
		. = ..()
		var/mob/M = holder
		M.STATS["CurCarry"] -= A.weight / ((M.STATS["str"] / 2) + 0.5)

Spellbook
	parent_type = /obj
	var/mob/holder
	Enter(Magic/spellRecipe/S)
		. = ..()
		var/Magic/spellRecipe/R
		for(R in src)
			if(S == R) return 0
		var/mob/M = holder
		if(src.contents.len >= ((M.STATS["int"] + 1) * 2))
			M << "You lack the mental capacity to learn more spells!"
			return 0