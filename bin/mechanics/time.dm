var
	hour = 9			//There are 24 hours in a day. -- One day lasts 72 minutes real-time.
	minute = 58			//There are 60 minutes in one hour and a minute in game lasts 3 seconds real-time.
	tickCount = 0		//Dawn lasts 7.5 minutes real-time.
	PM					//Daylight hours last 30 minutes real-time.
	curDay = 1			//Dusk lasts 7.5 minutes real-time.
	curWeek = 1			//Night lasts 27 minutes real-time.
	curMonth = 1		//A single week lasts 504 (8.4 hours) minutes real-time.
	curYear = 1			//A month lasts 2016 (33.6 hours; 1.4 days) minutes real-time.
						//A year lasts 24192 (403.2 hours; 16.8 days) minutes real-time.

proc
	timeTick()
		if(tickCount == 10)
			tickCount = 0
			minute++
			if(minute == 60)
				minute = 0
				hour++
				if(hour == 24)
					hour = 0
					curDay++
					if(curDay == 7)
						curDay = 0
						curWeek++
						if(curWeek == 4)
							curWeek = 0
							curMonth++
							if(curMonth == 12)
								curMonth = 0
								curYear++
								for(var/mob/M)
									M.age++
				todCheck()
				sleep(1)
				if(minute < 10) minute = "0[minute]"	//Announces the time and date to the whole world
				else minute = num2text(minute)			//each hour.
				world << "<font color = white> It is currently [hour]:[minute] on day [curDay] of the [curMonth]\th month of the [curYear]\th year since arrival."
				minute = text2num(minute)
			if(minute == 30)
				if(hour == 7 || hour == 17) todCheck()
		sleep(1)
		tickCount++
		spawn(1) timeTick()

	todCheck()
		var/llS,llE	//Light level start and light level end, respectively.
		switch(hour)
			if(0)
				llS = list(0.1,0.02,0.03, 0,0.1,0.15, 0.15,0.15,0.5)
				llE = list(0.1,0.02,0.03, 0,0.1,0.15, 0.15,0.15,0.5)
			if(1)
				llS = list(0.1,0.02,0.03, 0,0.1,0.15, 0.15,0.15,0.5)
				llE = list(0.1,0.025,0.025, 0.05,0.15,0.1, 0.2,0.2,0.5)
			if(3)
				llS = list(0.1,0.025,0.025, 0.05,0.15,0.1, 0.2,0.2,0.5)
				llE = list(0.1,0.025,0.025, 0.05,0.15,0.1, 0.2,0.2,0.5)
			if(4)
				llS = list(0.1,0.025,0.025, 0.05,0.15,0.1, 0.2,0.2,0.5)
				llE = list(0.2,0.05,0.05, 0.1,0.3,0.2, 0.1,0.1,0.4)
			if(5)
				llS = list(0.2,0.05,0.05, 0.1,0.3,0.2, 0.1,0.1,0.4)
				llE = list(0.75,0.025,0, 0.05,0.75,0, 0.2,0.2,0.9)
			if(6)
				llS = list(0.75,0.025,0, 0.05,0.75,0, 0.2,0.2,0.9)
				llE = list(0.75,0.025,0, 0.05,0.75,0, 0.2,0.2,0.9)
			if(7)
				if(minute >= 30)
					llS = list(0.75,0.025,0, 0.05,0.75,0, 0.2,0.2,0.9)
					llE = list(1,0,0, 0,1,0, 0,0,1)
				else
					llS = list(0.75,0.025,0, 0.05,0.75,0, 0.2,0.2,0.9)
					llE = list(0.75,0.025,0, 0.05,0.75,0, 0.2,0.2,0.9)
			if(8)
				llS = list(1,0,0, 0,1,0, 0,0,1)
				llE = list(1,0,0, 0,1,0, 0,0,1)
			if(9)
				llE = list(1,0,0, 0,1,0, 0,0,1)
				llS = list(1,0,0, 0,1,0, 0,0,1)
			if(10)
				llE = list(1.1,0.1,0, 0.15,1.1,0, 0.15,0.1,0.9)
				llS = list(1,0,0, 0,1,0, 0,0,1)
			if(11)
				llE = list(1.1,0.1,0, 0.15,1.1,0, 0.15,0.1,0.9)
				llS = list(1.1,0.1,0, 0.15,1.1,0, 0.15,0.1,0.9)
			if(12)
				llE = list(1.1,0.1,0, 0.15,1.1,0, 0.15,0.1,0.9)
				llS = list(1.1,0.1,0, 0.15,1.1,0, 0.15,0.1,0.9)
			if(13)
				llE = list(1,0,0, 0,1,0, 0,0,1)
				llS = list(1.1,0.1,0, 0.15,1.1,0, 0.15,0.1,0.9)
			if(14)
				llE = list(1,0,0, 0,1,0, 0,0,1)
				llS = list(1,0,0, 0,1,0, 0,0,1)
			if(15)
				llE = list(1,0,0, 0,1,0, 0,0,1)
				llS = list(1,0,0, 0,1,0, 0,0,1)
			if(16)
				llE = list(1,0,0, 0,1,0, 0,0,1)
				llS = list(1,0,0, 0,1,0, 0,0,1)
			if(17)
				if(minute >= 30)
					llS = list(1,0,0, 0,1,0, 0,0,1)
					llE = list(0.3,0.025,0.025, 0.05,0.3,0.1, 0.2,0.2,0.7)
				else
					llS = list(1,0,0, 0,1,0, 0,0,1)
					llE = list(1,0,0, 0,1,0, 0,0,1)
			if(18)
				llS = list(0.3,0.025,0.025, 0.05,0.3,0.1, 0.2,0.2,0.7)
				llE = list(0.3,0.025,0.025, 0.05,0.3,0.1, 0.2,0.2,0.7)
			if(19)
				llS = list(0.3,0.025,0.025, 0.05,0.3,0.1, 0.2,0.2,0.7)
				llE = list(0.3,0.025,0.025, 0.05,0.3,0.1, 0.2,0.2,0.7)
			if(20)
				llS = list(0.3,0.025,0.025, 0.05,0.3,0.1, 0.2,0.2,0.7)
				llE = list(0.2,0.05,0.05, 0.1,0.3,0.2, 0.1,0.1,0.4)
			if(21)
				llS = list(0.2,0.05,0.05, 0.1,0.3,0.2, 0.1,0.1,0.4)
				llE = list(0.1,0.025,0.025, 0.05,0.15,0.1, 0.2,0.2,0.5)
			if(22)
				llS = list(0.1,0.025,0.025, 0.05,0.15,0.1, 0.2,0.2,0.5)
				llE = list(0.1,0.025,0.025, 0.05,0.15,0.1, 0.2,0.2,0.5)
			if(23)
				llS = list(0.1,0.025,0.025, 0.05,0.15,0.1, 0.2,0.2,0.5)
				llE = list(0.1,0.02,0.03, 0,0.1,0.15, 0.15,0.15,0.5)
		sleep(1)
		for(var/mob/M)
			M.Lighting(llS, llE)
	growTick()
		set background = 1
		for(var/obj/Item/Placeable/Useable/Sapling/S)
			if(S.growing)
				if(world.realtime > S.growStart + S.growTime)
					new /obj/Terrain/Tree (S.loc)
					sleep(1)
					del S
			sleep(1)
		spawn(10) growTick()

	tempTick()
		set background = 1
		for(var/atom/movable/O)
			switch(O.tmptr)
				if(O.ignite to O.melt)
					spawn() O.Ignite()
				if(O.subfrozen to O.freeze)
					spawn() O.Freeze()
				if(O.freeze to O.ignite)
					spawn() O.Normalize()
				if(O.melt to 999999999)
					spawn() O.Disintegrate()
				if(-999999999 to O.subfrozen)
					spawn() O.Subfreeze()
		spawn(10) tempTick()


mob
	var/set_tAnim = 0
	proc
		Lighting(list/S, list/E)
			if(client)
				if(hour == 7 || hour == 17)
					client.color = S
					sleep(1)
					animate(client, color = E, time = 900)
				else
					client.color = S
					sleep(1)
					animate(client, color = E, time = 1800)