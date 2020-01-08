obj
	layer = OBJ_LAYER
	Item
		icon = 'items.dmi'
		var
			weight = 0.0 		//Defining a current weight variable.
			baseWeight = 0.1	//Defining a base weight variable.
			quantity = 1		//Defining a current quantity variable.
			maxStack = 99		//Anything over this value creates a new stack and takes up an extra inventory space.
			baseWorth = 1		//Defining a base worth variable.
			worth = 1			//Defining a current worth variable.
			list/recipe = list(list(/obj/Item, 1))
		New()
			..()
			worth = baseWorth * quantity
			weight = baseWeight * quantity

		Click(L,C)									//If the player clicks the item and it is already in their inventory, drop it.
			for(var/obj/Item/Storage/Bag/B in usr)	//Otherwise, attempt to pick the item up.
				if(!(src in B)) Pickup_proc(usr)
				else
					Drop(usr)
		proc
			Pickup_proc(obj/M, msg = 1)
				if(!(M in oview(1,src))) return	//If within range to actually pick it up, do so.
				.=Move(M)
				if(msg) M << "[(.)?"\green":"\red"] You[(.)?"":" did not"] pick up \a [src.name]."
			Drop(mob/M, amt = 0, msg = 1)
				if(amt == 0)
					if(quantity == 1)
						amt = 1
					else amt=max(0,min(99,input("How many [name] do you wish to drop? Maximum quantity: [min(99,quantity)]","Item drop",1) as num|null))
				for(var/obj/Item/Storage/Bag/B in M)
					if(!(src in M)||!amt) continue
					break
				var/turf/XX = get_step(M,turn(M.dir,180))	//Drop the specified amount of the item on the ground near the player.
				if(!XX)XX=M.loc
				if(amt<1) return
				if(amt>=quantity).=Move(XX)		//If they player attempts to drop all of the items (or a number greater), then drop all with
				else							//no change to variables.  Otherwise, drop the amount specified.
					var/obj/Item/X = type
					X = new X(XX)
					X.quantity = amt			//Make sure all values are what they should be based on quantity dropped.
					quantity-=amt
					weight-=baseWeight * amt
					worth-=baseWorth * amt
					.=1
				M.Inventory(M)
				if(msg) M << "[(.)?"\green":"\red"] You[(.)?"":" did not"] drop [amt] [src.name]\s."
			Craft(mob/M)
				recipeItem:
					for(var/i=1,i<=recipe.len,i++)
						for(var/obj/Item/Storage/Bag/B in M)		//Loop through each bag for items.
							for(var/obj/Item/I in B)				//Loop through each item in the bag.
								var/R = recipe[i][1]
								if(istype(I,R))						//If the found item is the one we need.
									I.quantity -= recipe[i][2]		//Take away how much is necessary for crafting.
									if(I.quantity <= 0)				//If there are no more of these items, delete the reference.
										del I
										M.Inventory(M)
									continue recipeItem				//Move on to next recipe item.
				placeCraftable(M)

			placeCraftable(mob/M)
				var/obj/Item/I = new src.type
				I.Move(M)
				#ifdef DEBUG
				M << "Making [I]!"
				M << "We made [I]!"
				#endif
				M.Inventory(M)

		Equipment
			layer = MOB_LAYER + 1
			var
				durability
				maxDura
				slot = ""
				material
				quality
				AP = 0
				DP = 0
			maxStack = 1
			Click(L,C)
				for(var/obj/Item/Storage/Bag/B in usr)	//If the player clicks the equipment
					if(!(src in B) && !(src in usr.EQUIP)) Pickup_proc(usr)	//and it is already in their inventory, try to equip it.
					else								//Otherwise, pick it up.
						if(src in usr.EQUIP) Unequip(usr)
						else Equip(usr)
			proc
				Equip(mob/M)
					M << "Equipping [src]!"
					sleep(1)
					if(Move(M.EQUIP)) M << "Success!"
					else M << "Failed!"

				Unequip(mob/M)
					M << "Unequipping [src]!"
					sleep(1)
					if(Move(M)) M << "Success!"
					else M << "Failed!"

			New(mob/M,mat = "Stone",qual = "Shoddy")
				..()
				material = mat
				quality = qual
				name = "[quality] [material] [name]"
				desc = "It's a [name]."
				switch(material)
					if("Stone")
						maxDura *= 0.95
						AP *= 1
						DP *= 0.9
					if("Steel")
						maxDura *= 1.15
						AP *= 0.95
						DP *= 0.8
				switch(quality)
					if("Shoddy")
						maxDura *= 0.9
						AP *= 0.8
						DP *= 0.7
					if("Standard")
						maxDura *= 1
						AP *= 1
						DP *= 1
					if("Extraordinary")
						maxDura *= 1.55
						AP *= 1.75
						DP *= 1.4
				durability = maxDura

			Axe
				name = "Axe"
				icon = 'stoneaxe.dmi'
				maxDura = 100
				slot = "handL,handR"
				AP = 5
				DP = 0
				recipe = list(list(/obj/Item/Resource/Wood/Stick, 2), list(/obj/Item/Resource/Stone, 1))
			Pickaxe
				name = "Pickaxe"
				icon = 'stonepickaxe.dmi'
				maxDura = 75
				slot = "handL,handR"
				AP = 6
				DP = 0
				recipe = list(list(/obj/Item/Resource/Wood/Stick, 2), list(/obj/Item/Resource/Stone, 2))
		Storage
			var
				capacity = 4
				carryMod = 1
			Bag
				icon = 'bag.dmi'
				Backpack
					capacity = 8

				Enter()
					. = ..()
					if(contents.len >= capacity) return 0
				Entered(obj/Item/A)
					..()
					var/mob/M = loc
					if(istype(A))
						for(var/obj/Item/X in contents-A)
							if(A.type == X.type)
								if(X.quantity + A.quantity <= X.maxStack)
									X.quantity+=A.quantity
									X.weight+=A.weight
									X.worth+=A.worth
									del A
									break
					M.STATS["CurCarry"] = 0
					for(var/obj/Item/I in contents)
						M.STATS["CurCarry"] += I.weight * carryMod
					if(M.STATS["CurCarry"] > M.STATS["MaxCarry"])
						M << "You are carrying too much to move.  Drop something!"
						M.ACTION_FLAG += ENCUMBERED
					else M.ACTION_FLAG -= ENCUMBERED
					spawn(1) M.Inventory(M)

				Exited()
					..()
					var/mob/M = loc
					M.STATS["CurCarry"] = 0
					for(var/obj/Item/I in contents)
						M.STATS["CurCarry"] += I.weight
					if(M.STATS["CurCarry"] > M.STATS["MaxCarry"])
						M << "You are carrying too much to move.  Drop something!"
						M.ACTION_FLAG += ENCUMBERED
					else M.ACTION_FLAG -= ENCUMBERED

					spawn(1) M.Inventory(M)

		Resource
			Wood
				Stick
					name = "\improper Stick"
					icon_state = "stick"
					maxStack = 99
					baseWeight = 0.01

				Log
					name = "\improper Wood"
					icon_state = "wood"
					maxStack = 24
					baseWeight = 4

			Fuel
				Coal

			Stone
				name = "\improper Stone"
				icon_state = "flint"
				maxStack = 99
				baseWeight = 0.15

		Placeable
			Useable
				Sapling
					name = "\improper Sapling"
					icon_state = "sapling"
					var/growing = 0, growStart, growTime
					New()
						..()
						growStart = world.realtime
						growTime = rand(257040, 756000)