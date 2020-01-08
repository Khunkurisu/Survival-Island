turf
	ground
		icon = 'ground.dmi'
		fertile
			grass
				icon_state = "grass1"
		sand
			icon = 'sand.dmi'
			icon_state = "sand1"
			name = "sand"
			New()
				..()
				var/istate = rand(0,2)
				switch(istate)
					if(0) icon_state = "[name]1"
					if(1) icon_state = "[name]2"
					if(2) icon_state = "[name]3"
			redSand
				name = "sandRed"
	liquid
		density = 1
		water
			icon = 'water.dmi'
			name = "Water"
			New()
				..()
				var/istate = rand(0,1)
				switch(istate)
					if(0) icon_state = "[name]1"
					if(1) icon_state = "[name]2"
					if(2) icon_state = "[name]3"
					if(3) icon_state = "[name]4"

	wall
		icon = 'wall.dmi'
		density = 1
		opacity = 1

		decWall
			opacity = 0

		mineWall
			var
				mineType = /obj/Item/Equipment/Pickaxe
				hp
			New()
				..()
				hp = (rand() + 0.5) * rand(100,200)
			Click()
				var/delay = ((usr.STATS["dex"] + usr.STATS["per"] + usr.STATS["bal"])+1) / 30
				if(world.timeofday > usr.lastClick + delay)
					for(var/obj/Item/Equipment/E in usr.EQUIP)
						if(istype(E,mineType))
							if(usr in oview(1,src))
								usr << "[usr] swings \his [E.name] at [src]!"
								E.durability -= rand()
								if(E.durability <= 0)
									E.Drop(usr, msg = 0)
									del E
									return
								hp -= rand(0,5)
							break
					usr.lastClick = world.timeofday
					#ifdef DEBUG
					usr << "[hp] hp remaining for [src]!"
					#endif
					if(hp <= 0)
						var/turf/T = new /turf/ground(src.loc)
						T.icon_state = "CobbledStone"
						sleep(1)
						var/obj/Item/I = new /obj/Item/Resource/Stone
						I.Move(src.loc)
						I.quantity = rand(5,I.maxStack)
						sleep(1)
						del src
					sleep(1)

	edge
		icon = 'edges.dmi'
		Enter(atom/movable/O, atom/L)
			var/turf/T
			for(T in oview(0))
				if(T.density)
					if(istype(O,/Magic))
						O:applyEffects(src)
						sleep(1)
						del O
					return 0
			if(get_dir(src,L) == src.dir)
				return 0
			else return 1
		Exit(atom/movable/O, atom/L)
			var/turf/T
			for(T in oview(0))
				if(T.density)
					if(istype(O,/Magic))
						O:applyEffects(src)
						sleep(1)
						del O
					return 0
			if(get_dir(src,L) == src.dir)
				if(istype(O,/Magic))
					O:applyEffects(src)
					sleep(1)
					del O
				return 0
			else return 1

area
	cave
