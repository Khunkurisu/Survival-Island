#define MOB_LAYER 10
#define OBJ_LAYER 5
#define CASTING 123
#define KO 456
#define ENCUMBERED 789
#define DEBUG			//Placing two slashes before the hash symbol will disabled DEBUG mode, allowing faster running
						//but lessening the amount of useful output for testing.
world
	name = "Panthian"
	fps = 25		// 25 frames per second
	icon_size = 32	// 32x32 icon size by default
	mob = /mob/login
	turf = /turf/liquid/water
	view = 8		// show up to 8 tiles outward from center (17x17 view)
	loop_checks = 0
	version = 0.2
	New()
		..()
		sleep(1)
		generateMap(TREE=0,SAP=10,STONE=30,FLOWER=45,STICK=25,COAL=0,WOLFPACK=5)
		log = "world.log"
		spawn() growTick()
		spawn() timeTick()
		spawn() tempTick()
var/loaded = 0, list/craftItems = list(/obj/Item/Equipment/Axe,/obj/Item/Equipment/Pickaxe,/light_obj/Campfire,/light_obj/Torch)

atom/movable
	var/tmptr
	var/ignite
	var/melt
	var/freeze
	var/subfrozen
	var/list/SPELLICONS = list("Orb" = list('fire orb.dmi', 'frost orb.dmi', 'energy orb.dmi'), "Beam" = list('energy beam.dmi'), "Wave" = new /list, "Target" = new /list, "AoE" = list('fire explosion.dmi'), "Touch" = new /list, "Self" = new /list, "Channel" = list('energy beam.dmi'))
	proc
		Ignite()

		Disintegrate()

		Freeze()

		Subfreeze()

		Normalize()
