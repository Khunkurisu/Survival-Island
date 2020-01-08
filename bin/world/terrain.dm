obj/treeTop
	icon = 'tree1.dmi'
	icon_state = "top"
	layer = MOB_LAYER + EFFECTS_LAYER



obj/Terrain
	layer = TURF_LAYER + 1
	var
		amount
		mineType
	proc
		dropResource()
			for(var/obj/Item/Resource/Y in contents)
				amount = rand(0, (Y.quantity + 1) / 3)
				if(amount > Y.quantity) amount = Y.quantity
				Y.quantity -= amount
				if(amount > 0)
					var/obj/Item/Resource/X = new Y.type
					X.quantity = amount
					for(var/turf/ground/G in oview(1,src))
						X.Move(G)
						break
					if(!(X in oview(1,src))) X.Move(src.loc)
					sleep(1)
				if(Y.quantity <= 0) del Y
	Click()
		var/delay = ((usr.STATS["dex"] + usr.STATS["per"] + usr.STATS["bal"])+1) / 30
		if(world.timeofday > usr.lastClick + delay)
			for(var/obj/Item/Equipment/E in usr.EQUIP)
				if(istype(E,mineType))
					if(usr in oview(1,src))
						usr << "[usr] swings \his [E.name] at [src]!"
						E.durability -= rand()
						dropResource()
						if(E.durability <= 0)
							E.Drop(usr, msg = 0)
							del E
							return
					break
			usr.lastClick = world.timeofday
			sleep(1)
	Tree
		icon = 'tree1.dmi'
		icon_state = "base"
		density = 1
		opacity = 0
		bound_height = 14
		bound_width = 41
		bound_x = 12
		mineType = /obj/Item/Equipment/Axe
		ignite = 455
		New()
			..()
			overlays+=/obj/treeTop
			var/obj/Item/St = new /obj/Item/Resource/Wood/Stick
			var/obj/Item/W = new /obj/Item/Resource/Wood/Log
			St.quantity = rand(20,St.maxStack)
			W.quantity = rand(5,W.maxStack)
			St.Move(src)
			W.Move(src)
		Click()
			..()
			var/itemCheck = 0
			for(var/obj/Item/I in src)
				itemCheck++
			sleep(1)
			if(itemCheck == 0)
				plantSeed()

		dropResource()
			for(var/obj/Item/Resource/Y in contents)
				amount = rand(0, (Y.quantity + 1) / 3)
				if(amount > Y.quantity) amount = Y.quantity
				Y.quantity -= amount
				if(amount > 0)
					var/obj/Item/Resource/X = new Y.type
					X.quantity = amount
					for(var/turf/T in oview(1,src))
						var/R = rand(0,1)
						if(R)
							X.Move(T)
							break
					if(!(X in oview(1,src))) X.Move(src.loc)
					sleep(1)
				if(Y.quantity <= 0) del Y
		proc/plantSeed()
			var/obj/Item/Sa = new /obj/Item/Placeable/Useable/Sapling
			Sa.quantity = rand(0,3)
			Sa.Move(src.loc)
			del src
	Coal_Rock
		layer = TURF_LAYER + 1
		mineType = /obj/Item/Equipment/Pickaxe
		icon = 'coalMine.dmi'
		New()
			..()
			var/i = rand(1,3)
			icon_state = "[i]"
			var/obj/Item/C = new /obj/Item/Resource/Fuel/Coal
			C.quantity = rand(4,C.maxStack)
			C.Move(src)
		Click()
			..()
			var/itemCheck = 0
			for(var/obj/Item/I in src)
				itemCheck++
			if(itemCheck<=0) del src

	Flowers
		icon = 'flowers.dmi'
		icon_state = "flowersRed1"
		New()
			var/RF = rand(0,7)
			switch(RF)
				if(0) icon_state = "flowersRed1"
				if(1) icon_state = "flowersYellow1"
				if(2) icon_state = "flowersRed2"
				if(3) icon_state = "flowersYellow2"
				if(4) icon_state = "flowersRR"
				if(5) icon_state = "flowersRY1"
				if(6) icon_state = "flowersRY2"
				if(7) icon_state = "flowersYY"