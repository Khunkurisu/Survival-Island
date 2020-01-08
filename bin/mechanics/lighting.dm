atom
	var
		luminCount = 0
		oldFlags
	proc
		Illuminated(source = "flame")
			set background = 1
			if(luminCount > 0)
				oldFlags = appearance_flags
				appearance_flags = NO_CLIENT_COLOR
				switch(source)
					if("flame") color = list(1,0,0, 0.15,1,0, 0.2,0.1,0.85)
			else
				appearance_flags = oldFlags
				color = null
			luminCount = 0
			sleep(-1)

light_obj
	parent_type = /obj/Item
	var
		fuel
		lit
		list/luminated = new
	proc
		Illuminate()
			var/atom/A
			if(src.lit)
				for(A in view(src.luminosity,src) - luminated)
					luminated += A
					A.luminCount++
					spawn(1) A.Illuminated()
					sleep(-1)
				for(A in luminated - view(src.luminosity,src))
					luminated -= A
					A.luminCount--
					spawn(1) A.Illuminated()
					sleep(-1)
			else
				for(A in luminated)
					luminated -= A
					A.luminCount--
					spawn(1) A.Illuminated()
					sleep(-1)
			spawn(1) Illuminate()

	Campfire
		icon = 'assets\\objs\\campfire.dmi'
		appearance_flags = NO_CLIENT_COLOR
		recipe = list(list(/obj/Item/Resource/Wood/Log, 2), list(/obj/Item/Resource/Wood/Stick, 15), list(/obj/Item/Resource/Stone, 5))
		pixel_y = 8
		density = 1
		opacity = 0
		luminosity = 4
		fuel = 4770
		var/maxF = 25200
		proc/burn()  		//A function that will cause the campfire to require fuel.  At base fuel (fuel = 4770),
			if(fuel>0)		//the campfire will burn for roughly 8 minutes real time.
				lit = 1
				icon_state = ""
				appearance_flags = NO_CLIENT_COLOR
				fuel--
			if(fuel == 0)	//If there is no fuel, the fire goes out.
				icon_state = "out"
				appearance_flags = 0
				lit = 0
			spawn(1) burn()

		verb/Use()
			set src in view(1)
			var/obj/Item/Resource/Wood/Log/L
			var/obj/Item/Resource/Wood/Stick/S
			if(lit)
				var/YN = input("Put the fire out?", "Extinguish flame", "No") in list("Yes", "No")
				if(YN == "No") return
				lit = 0
				fuel = 0
				view(src) << "[usr] has extinguished the fire!"
			else
				if(L in usr)
					lit = 1
					fuel = 1260
					L.quantity--
					if(L.quantity < 1)
						L.Drop(usr)
						sleep(1)
						del L
					view(src) << "[usr] has relit the fire!"
				else if(S in usr)
					lit = 1
					fuel = 150
					S.quantity--
					if(S.quantity < 1)
						S.Drop(usr)
						sleep(1)
						del S
					view(src) << "[usr] has relit the fire!"
		New()
			..()
			sleep(5)
			spawn(1) burn()
			spawn(1) Illuminate()

	Torch
		density = 0
		opacity = 0
		icon = 'assets\\objs\\torch.dmi'
		icon_state = "extinguished"
		recipe = list(list(/obj/Item/Resource/Wood/Stick, 1), list(/obj/Item/Resource/Fuel/Coal, 1))
		luminosity = 2
		appearance_flags = NO_CLIENT_COLOR
		verb/Use()
			set src in view(1)
			lit=!lit
			if(lit) icon_state = ""
			else icon_state = "extinguished"
		Click()
			for(var/obj/Item/Storage/Bag/B in usr)
				if(!(src in B)) Pickup_proc(usr)
				else
					lit = 1
					icon_state = ""
					spawn(1) Illuminate()
					Drop(usr, amt=1, msg = 0)
		placeCraftable(mob/M)
			var/light_obj/I = new src.type
			I.lit = 0
			#ifdef DEBUG
			M << "Making [I]!"
			M << "We made [I]!"
			#endif
			I.Move(M)
			M.Inventory(M)