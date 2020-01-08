world
	proc
		generateMap(TREE = 150000, SAP = 25000, STONE = 7500, FLOWER = 75000, STICK = 5000, COAL = 5000, WOLFPACK = 35)
			var/treeCount = 0, sapCount = 0, stoneCount = 0, flowerCount = 0, stickCount = 0, coalCount = 0, wolfCount = 0
			#ifdef DEBUG
			world << "<font color = blue>Generating [TREE] trees..."
			#endif
			while(treeCount < TREE)
				for(var/turf/ground/fertile/grass/T)
					var/obj/Terrain/B
					var/chance = rand(0,1)
					if(!chance || T.z != 1) continue
					var/ranX = rand(-4,4)
					var/ranY = rand(-4,4)
					var/obj/Terrain/Tree/O = new
					O.Move(T)
					O.pixel_x = ranX
					O.pixel_y = ranY
					if(B in O.locs) del O
					else treeCount++
				sleep(-1)
			treeCount = 0
			sleep(1)
			#ifdef DEBUG
			world << "<font color = blue>Generating [SAP] saplings..."
			#endif
			while(sapCount < SAP)
				for(var/turf/ground/fertile/grass/T)
					var/obj/Item/Placeable/Useable/Sapling/B
					var/obj/Terrain/Tree/C
					var/chance = rand(0,1)
					if(!chance) continue
					var/ranX = rand(-4,4)
					var/ranY = rand(-4,4)
					var/obj/Item/Placeable/Useable/Sapling/O = new
					O.Move(T)
					O.pixel_x = ranX
					O.pixel_y = ranY
					O.growing = 1
					if(B in O.locs) del O
					else if(C in O.locs) del O
					else sapCount++
				sleep(-1)
			sapCount = 0
			sleep(1)
			#ifdef DEBUG
			world << "<font color = blue>Generating [STONE] stones..."
			#endif
			while(stoneCount < STONE)
				for(var/turf/ground/fertile/T)
					var/obj/B
					var/chance = rand(0,1)
					if(!chance) continue
					var/ranX = rand(-4,4)
					var/ranY = rand(-4,4)
					var/obj/Item/Resource/Stone/O = new
					O.Move(T)
					O.pixel_x = ranX
					O.pixel_y = ranY
					if(B in O.locs) del O
					else stoneCount++
				sleep(-1)
			stoneCount = 0
			sleep(1)
			#ifdef DEBUG
			world << "<font color = blue>Generating [FLOWER] flowers..."
			#endif
			while(flowerCount < FLOWER)
				for(var/turf/ground/fertile/grass/T)
					var/obj/Terrain/B
					var/chance = rand(0,1)
					if(!chance) continue
					var/ranX = rand(-4,4)
					var/ranY = rand(-4,4)
					var/obj/Terrain/Flowers/O = new
					O.Move(T)
					O.pixel_x = ranX
					O.pixel_y = ranY
					if(B in O.locs) del O
					else flowerCount++
				sleep(-1)
			flowerCount = 0
			sleep(1)
			#ifdef DEBUG
			world << "<font color = blue>Generating [STICK] sticks..."
			#endif
			while(stickCount < STICK)
				var/obj/Item/Resource/Wood/Stick/T = new
				var/ranX = rand(1, maxx)
				var/ranY = rand(1, maxy)
				T.Move(locate(ranX,ranY,1))
				for(var/turf/U in T.locs)
					if(!(istype(U,/turf/ground)))
						del T
					else stickCount++
				sleep(-1)
			stickCount = 0
			sleep(1)
			#ifdef DEBUG
			world << "<font color = blue>Generating [COAL] coal..."
			#endif
			while(coalCount < COAL)
				var/obj/Terrain/Coal_Rock/T = new
				var/ranX = rand(1, maxx)
				var/ranY = rand(1, maxy)
				T.Move(locate(ranX,ranY,2))
				for(var/turf/U in T.locs)
					if(!(istype(U,/turf/wall)))
						del T
					else
						coalCount++
				sleep(-1)
			coalCount = 0
			sleep(1)
			#ifdef DEBUG
			world << "<font color = blue>Generating [WOLFPACK] wolf packs..."
			#endif
			while(wolfCount < WOLFPACK)
				var/mob/npc/hostile/T = new(BL = 2)
				var/ranX = rand(1, maxx)
				var/ranY = rand(1, maxy)
				T.Move(locate(ranX,ranY,1))
				for(var/turf/U in T.locs)
					if(!(istype(U,/turf/ground/fertile/grass)))
						del T
					else
						T.icon = 'Wolf-Red.dmi'
						T.name = "Alpha Wolf"
						T.race = "Wolf"
						wolfCount++
				sleep(-1)
			wolfCount = 0
			loaded = 1