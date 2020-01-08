mob/proc
	Save_Mob(mob/M)
		var/player_sav = "players/[M.ckey]/[M.name].sav"
		if(fexists(player_sav)) fdel(player_sav)
		var/savefile/S = new(player_sav)
		S["Name"]<<M.name
		S["Desc"]<<M.desc
		S["Race"]<<M.race
		S["Icon"]<<M.icon
		S["Age"]<<M.age
		S["Ancestry"]<<M.ANCESTRY
		S["Stats"]<<M.STATS
		S["Dir"]<<M.dir
		S["X"]<<M.x
		S["Y"]<<M.y
		S["Z"]<<M.z
		S["Equip"]<<M.EQUIP
		S["Spell"]<<M.SPELL
		S["Contents"]<<M.contents

	Load_Mob(ckey, name, client/C)
		var/player_sav = "players/[ckey]/[name]"
		var/savefile/S = new(player_sav)
		var/mob/pc/M = new
		var/X,Y,Z
		S["Name"]>>M.name
		S["Desc"]>>M.desc
		S["Race"]>>M.race
		S["Icon"]>>M.icon
		S["Age"]>>M.age
		S["Ancestry"]>>M.ANCESTRY
		S["Stats"]>>M.STATS
		S["Dir"]>>M.dir
		S["X"]>>X
		S["Y"]>>Y
		S["Z"]>>Z
		S["Equip"]>>M.EQUIP
		S["Spell"]>>M.SPELL
		S["Contents"]>>M.contents
		M.Move(locate(X,Y,Z))
		sleep(1)
		C.mob = M