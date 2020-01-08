Magic
	parent_type = /obj
	step_size = 12
	layer = MOB_LAYER + 5
	var/atom/target, cost, list/effects = new, range
	density = 1

	proc
		castSpell()
			#ifdef DEBUG
			world << "[src] is being cast!"
			#endif

		applyEffects(atom/O)
			set background = 1
			for(var/i=1,i<=effects.len,i++)
				if(istype(effects[i],/Element))
					var/Element/Ele = effects[i]
					var/Element/E = new Ele.type (loc)
					E.effect = Ele.effect
					E.rate = Ele.rate
					E.dur = Ele.dur
					E.apply_Effect(0,O)
				else
					var/Magic/Ma = effects[i]
					var/Magic/M = new Ma.type (src.loc)
					M.effects = Ma.effects
					M.range = Ma.range
					M.icon = Ma.icon
					M.castSpell(src)
				sleep(-1)

	Bump(atom/O)
		applyEffects(O)
		del src


	Projectile
		//Magic projectiles such as beams and bolts.
		Orb
			//Effects that take the shape of balls or orbs.
			castSpell()
				..()
				src.Move(locate(get_step(src,src.dir)))
				walk(src,src.dir)

		Beam
			//Effects that take the shape of a beam or line that connects back to the caster.
			castSpell(mob/U)
				..()
				var/atom/front = get_step(src,src.dir)
				Move(front)
				icon_state = "head"
				while(U.ACTION_FLAG == CASTING && U.STATS["CurMP"] >= cost)
					var/Magic/Projectile/Beam/M = new (loc)
					M.dir = dir
					M.name = name
					M.icon = icon
					M.cost = cost
					M.effects = effects
					M.range = range
					U.STATS["CurMP"]-=cost
					walk(M,M.dir)
					sleep(1)
				if(U.ACTION_FLAG != CASTING) del src
			Bump(atom/O)
				icon_state = "end"
				applyEffects(O)
				del src


		Wave
			//Effects that take a wide, wall-like shape that moves outward from the caster in the direction they are facing.
			New()
				..()
				spawn(1) alterHitbox()
			proc/alterHitbox()
				var/icon/ico = src.icon
				var/h = ico.Height()
				var/w = ico.Width()
				var/hitX
				h = round(h / 32)
				w = round(w / 32)
				if(h >= w) hitX = h
				else hitX = w
				bound_width = hitX
				bound_height = 24
				spawn(1) alterHitbox()
			castSpell()
				..()
				walk(src,src.dir)

		Target
			//Effects that work similarly to a touch spell, only from a distance.  (Single-target only)

	Touch
		//Touch-based magic such as many healing spells.


	Channel
		//Magic that takes effect while channeling energy and stops upon interruption.

	AoE
		//Magic that works in an area of effect around the user, such as flame cloak.
		pixel_x = -48
		pixel_y = -48
		castSpell()
			..()
			applyEffects()
			sleep(-1)
			del src
		applyEffects()
			set background = 1
			for(var/i=1,i<=effects.len,i++)
				if(istype(effects[i],/Element))
					var/Element/Ele = effects[i]
					var/Element/E = new Ele.type (loc)
					E.effect = Ele.effect
					E.rate = Ele.rate
					E.dur = Ele.dur
					if(!range) range = 4
					E.apply_Effect(range)
				else
					var/Magic/Ma = effects[i]
					var/Magic/M = new Ma.type (src.loc)
					M.effects = Ma.effects
					M.range = Ma.range
					M.icon = Ma.icon
					M.castSpell(src)
				sleep(-1)


	Self
		//Magic that affects the area in which the energy currently resides, such as the caster or impact zone of a spell.
		castSpell(atom/U)
			..()
			if(U && istype(U,/mob))
				applyEffects(U)
				return
			for(var/mob/M in src.loc)	//Find the first mob at current location
				target = M				//Target them.
				break
			if(!target)
				return
			applyEffects(target)		//If a target was found, apply effects of spell to them.



	spellRecipe
		var/pointer
		//An object for holding a spell's recipe (the variables put into it by the player creating the spell) to be held by a user.
		New(n,shape,co,list/eff,ra,icon/ico,istate)
			name = n
			pointer = text2path("/Magic/[shape]")
			cost = co
			effects = eff
			range = ra
			icon = ico

		Click()
			if(usr.PRIMEDSPELL == src)
				usr.PRIMEDSPELL = null
				return 0
			else if(usr.PRIMEDSPELL) usr.PRIMEDSPELL = null
			usr.Prime_Spell(usr,src)

		castSpell(atom/movable/U)
			var/p = pointer
			var/Magic/S = new p(U.loc)
			#ifdef DEBUG
			U << "[p]"
			U << "[S]"
			#endif
			S.step_x = U.step_x
			S.step_y = U.step_y
			S.dir = U.dir
			S.name = src.name
			S.icon = src.icon
			S:cost = src.cost
			S:effects = src.effects
			S:range = src.range
			if(istype(U,/mob)) U:STATS["CurMP"]-=cost
			S:castSpell(U)


Element
	parent_type = /obj
	var/effect
	var/rate
	var/cost
	var/dur
	proc/get_Cost()

	proc/apply_Effect()
		set background = 1
		#ifdef DEBUG
		world << "Effect of [src] is being applied!"
		#endif

	Heat
		get_Cost(range)
			var/x = ((range * 32) * 6)**2
			var/y = rate - 273.15
			cost = ((y / 29) * x) * dur

		apply_Effect(range=null,atom/movable/t)
			set background = 1
			..()
			if(range)
				while(dur >= 0)
					for(var/atom/movable/O in oview(range))
						if(istype(O,/obj/treeTop)) continue
						#ifdef DEBUG
						world << "[effect] is applied to [O]!"
						#endif
						if(effect == "Increase")
							O.tmptr+=rate
						else if(effect == "Decrease")
							O.tmptr-=rate
					dur--
					sleep(1)
			else
				while(dur >= 0)
					if(effect == "Increase")
						t.tmptr+=rate
					else if(effect == "Decrease")
						t.tmptr-=rate
					dur--
					sleep(1)
			del src
	Energy
		Force
			get_Cost(range)
				var/i = rate / 55
				var/o = (range * 32)**2
				cost = i * o * dur

			apply_Effect(range=null,atom/t)
				set background = 1
				..()
				if(range)
					while(dur >= 0)
						for(var/atom/movable/O in oview(range))
							if(O.loc == src.loc) continue								//if at center of effect radius, do nothing
							if(istype(O,/obj/Terrain)) continue 						//Don't move terrain objects
							if(istype(O,/obj/treeTop)) continue							//Don't move tops of trees
							if(istype(O,/obj/Item/Placeable)) continue					//Don't move placeable items
							#ifdef DEBUG
							world << "[effect] is applied to [O]!"
							#endif
							if(effect == "Push")
								step_towards(O,get_step_away(O,src),rate)
							else if(effect == "Pull")
								step_towards(O,src,rate)
						dur--
						sleep(1)
				else if(istype(t,/atom/movable))
					while(dur >= 0)
						if(effect == "Push")
							step_towards(t,get_step_away(t,src),rate)
						else if(effect == "Pull")
							step_towards(t,src,rate)
						dur--
						sleep(1)
				del src
		Light