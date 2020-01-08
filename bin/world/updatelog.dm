mob/pc/proc/view_Updates(mob/M)
	M << browse(global.updatelog,"window=updates")

var/updatelog = {"
<html>
<head><title>Update Log</title></head>
<body bgcolor="lightblue">
<h1>Survival Island v0.2.1</h1><br>
-------------------------------<br>

<h3>2017-22-02:</h3><br>
-Implemented magic system prototype.<br>
--Players may now create spell 'shapes' with elemental effects.<br>
--When creating a spell shape, players may also add entire previously made spells as an effect.<br>
---e.g. using an AoE fire spell as an effect on a projectile orb spell makes what is essentially a fireball.<br>
--Casting spells currently works by clicking the spell in your spellbook (located below equipment section) to 'prime' it.  Then press R to cast.<br>
-Disabled character creation for debug (again).<br>
-Added constant ticker for keeping track of object/mob tempurature.<br>
-Implemented keyboard mapping and fully hotkey support (all letters, numbers, and many symbols) for proper game control.  (Overrides built-in hotkeys)<br>
-Began prototype for basic combat system (disabled in this version).<br>
-Fixed bug where magic projectiles would hit an 'edge' turf and stop, never activating their effects nor being deleted from the map.<br>

"}