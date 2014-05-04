--Warwick, Nunu, cassio, nasus
--only downside atm
local iwannaplayforyou = nil
if (myHero.charName=="Warwick" or myHero.charName=="Nunu" or myHero.charName=="Cassiopeia" or myHero.charName=="Nasus")then
iwannaplayforyou = true
else
PrintChat("BilbaoAutoJungle supports only Warwick, Nunu, Cassiopeia and Nasus.")
PrintChat("Please contact me, what champion do you play, and i will add him.")
iwannaplayforyou = false
end
if iwannaplayforyou==false then return end

--GLOBAL'S DO NOT TOUCH
local DOWNSIDE_GREATWIGHT = { 
x = 1684,
y = 54, 
z = 8207, 
range = 250, 
isup = false, 
tick = 500, 
text = "DOWN",
name = "GreatWraith13.1.1"
}

local DOWNSIDE_ANCIENTGOLEM = { 
x = 3632, 
y = 54, 
z = 7600, 
range = 325, 
isup = false, 
tick = 500, 
text = "DOWN",
BIG = "AncientGolem1.1.1",
SMALL_ONE = "YoungLizard1.1.3",
SMALL_TWO = "YoungLizard1.1.2"
}

local DOWNSIDE_WOLVES = { 
x = 3373, 
y = 55, 
z = 6223, 
range = 300, 
isup = false, 
tick = 500, 
text = "DOWN",
BIG = "GiantWolf2.1.1",
SMALL_ONE = "Wolf2.1.3",
SMALL_TWO = "Wolf2.1.2"
}

local DOWNSIDE_WRAITHS = { 
x = 6446, 
y = 56, 
z = 5214, 
range = 400, 
isup = false, 
tick = 500, 
text = "DOWN",
BIG = "Wraith3.1.1",
SMALL_ONE = "LesserWraith3.1.4",
SMALL_TWO = "LesserWraith3.1.3",
SMALL_THREE = "LesserWraith3.1.2"
}

local DOWNSIDE_LIZARDELDER = { 
x = 7455, 
y = 56, 
z = 3890, 
range = 400, 
isup = false, 
tick = 500, 
text = "DOWN",
BIG = "LizardElder4.1.1",
SMALL_ONE = "YoungLizard4.1.2",
SMALL_TWO = "YoungLizard4.1.3"
}

local DOWNSIDE_GOLEMS = { 
x = 8216, 
y = 54, 
z = 2533, 
range = 500, 
isup = false, 
tick = 500, 
text = "DOWN",
BIG = "Golem5.1.2",
SMALL = "SmallGolem5.1.1"
}
------------------------UPSIDE NOW
local UPSIDE_GREATWIGHT = { 
x = 12337, 
y = 54, 
z = 6263, 
range = 250, 
isup = false, 
tick = 500, 
text = "DOWN",
name = "GreatWraith14.1.1"
}

local UPSIDE_ANCIENTGOLEM = { 
x = 10386, 
y = 54, 
z = 6811, 
range = 325, 
isup = false, 
tick = 500, 
text = "DOWN",
BIG = "AncientGolem7.1.1",
SMALL_ONE = "YoungLizard7.1.3",
SMALL_TWO = "YoungLizard7.1.2"
}

local UPSIDE_WOLVES = { 
x = 10651, 
y = 64, 
z = 8116, 
range = 300, 
isup = false, 
tick = 500, 
text = "DOWN",
BIG = "GiantWolf8.1.1",
SMALL_ONE = "Wolf8.1.3",
SMALL_TWO = "Wolf8.1.2"
}
local UPSIDE_WRAITHS = { 
x = 7580, 
y = 55, 
z = 9250, 
range = 400, 
isup = false, 
tick = 500, 
text = "DOWN",
BIG = "Wraith9.1.1",
SMALL_ONE = "LesserWraith9.1.4",
SMALL_TWO = "LesserWraith9.1.3",
SMALL_THREE = "LesserWraith9.1.2"
}

local UPSIDE_LIZARDELDER = { 
x = 6504, 
y = 54, 
z = 10584, 
range = 400, 
isup = false, 
tick = 500, 
text = "DOWN",
BIG = "LizardElder10.1.1",
SMALL_ONE = "YoungLizard10.1.3",
SMALL_TWO = "YoungLizard10.1.2"
}

local UPSIDE_GOLEMS = { 
x = 6140, 
y = 39, 
z = 11935, 
range = 500, 
isup = false, 
tick = 500, 
text = "DOWN",
BIG = "Golem11.1.2",
SMALL = "SmallGolem11.1.1"
}

--SAVESPOTS BOTSIDE
local savespot_alpha = {x=1838,y=56,z=5215,name="alpha"}
local savespot_beta = {x=2133,y=60,z=6402,name="beta"}
local savespot_gamma = {x=1820,y=53,z=9684,name="gamma"}
local savespot_delta = {x=4338,y=53,z=6868,name="delta"}
local savespot_epsilon = {x=4454,y=53,z=5267,name="epsilon"}
local savespot_stigma = {x=5230,y=54,z=3280,name="stigma"}
local savespot_zeta = {x=6193,y=53,z=2882,name="zeta"}
local savespot_eta = {x=7413,y=52,z=613,name="eta"}

--WARDSPOTS
local wardspot_left = {x=4825, y=-63, z=8911}
local wardspot_right = {x=9024, y=-63, z=5446}

--TRINKETS
local ward_wriggls = {itemslot=nil, isrdy=false}
local ward_trinket = {itemslot=nil, isrdy=false}


--local GENERAL_DRAGON = { x = 13933, y = 0, z = 14169, range = 1000, isup = nil, tick = nil}
--GENERAL
local QReady, WReady, EReady, RReady = nil, nil, nil, nil
local Recalling = false
local status = "BASE"
local nextcamp = nil
local player, jungleTarget, draw_tar, farmtar = nil, nil, nil, nil
local can_attack, recall_status = true, false
local abilityLevel = 0
local hp_status = nil
local camp_done, gamestart = true, true

--BUFFNAMES
local healbuff = {
flask="ItemCrystalFlask", 
minipot="ItemMiniRegenPotion", 
hppot="RegenerationPotion"
}
local txtonme = {line_one=nil, line_two=nil, line_three=nil}
local reset_little, reset_big = false, false
local my_levelSequence, my_shopSequence = nil, nil


--SEQUENCE
local levelSequence = {
	Warwick = {2,1,2,3,2,4,2,1,2,1,4,1,1,3,3,4,3,3},
	Nunu 	= {1,3,2,3,1,4,3,1,3,1,4,1,3,2,2,4,2,2},
	Cassiopeia = {1,2,3,1,1,4,1,3,1,3,4,3,2,3,2,4,2,2},
	Nasus = {3,1,3,2,1,4,1,1,3,1,4,3,2,3,2,4,2,2}
}
local shopSequence = {
	Warwick = { 3106, 1001, 3154, 1033, 3111, 1011, 1031, 3068, 1057, 1028, 3211, 1028, 3067, 3065, 1043, 1042, 3091, 1011, 3022},
	Nunu 	= {1080, 1001, 1028, 3067, 3207, 3028, 3117, 1029, 1028, 1033, 3105, 1029, 1029, 3082, 1057, 3211, 3190, 3143, 3065, 3222},
	Cassiopeia = { 1080, 1001,1052,3108,3206,1004,1027,3070,3020,1052,1052,3145, 1004, 1004, 3152, 1011, 1026, 3116, 1052, 3136, 3151, 3003},
	Nasus = { 1080,1001,3057,3047,3067,3207,3067, 1057, 1029, 3082,3078, 3143, 3211, 3065}
}
local keyZERO = 48 -- 0
local grabtimer, lulztimer, spelltimer, pstay_timer = 0, 0, 0, 0
local lulz_power  = {'/l', '/t','/j', '/d'}
local info_camp = {a="",b="",c="",d="",e="",f="",g="",h="",i="",j="",k="",l=""}
local info_spells = {a="",b="",c="",d="",e="",f="",g="",h="",i="",j="",k="",l=""}
local allySpawn, enemySpawn = nil, nil
local did_blue_start = false
local startingTime,lastBuy  = 0, 0
local autopottick = 0
local nextbuyIndex = 1
local firstBought = false

local prev_early_fail_finished = false
local runhome, setward = false, false
local pause = true
local in_fight=false
local curr_cmp, my_safespot = nil, nil
local qstack = 0
local qdmg = 0
local HasQBuff = false
local fullbuild = false

local isTOPSIDE = false
local isBOTSIDE = false

function draw_camps_DOWNSIDE()
	if my_safespot~=nil then
		DrawCircle(my_safespot.x, my_safespot.y, my_safespot.z,100, ARGB(0x00,0xFF,0xFF,0xFF))
	end
	DrawCircle(DOWNSIDE_GREATWIGHT.x, DOWNSIDE_GREATWIGHT.y, DOWNSIDE_GREATWIGHT.z, DOWNSIDE_GREATWIGHT.range, ARGB(0x00,0xFF,0xFF,0xFF))					
	DrawText3D(tostring(DOWNSIDE_GREATWIGHT.text), DOWNSIDE_GREATWIGHT.x, DOWNSIDE_GREATWIGHT.y, DOWNSIDE_GREATWIGHT.z, 25, RGB(222, 245, 15), true)					
	DrawCircle(DOWNSIDE_ANCIENTGOLEM.x, DOWNSIDE_ANCIENTGOLEM.y, DOWNSIDE_ANCIENTGOLEM.z, DOWNSIDE_ANCIENTGOLEM.range, ARGB(0x00,0xFF,0xFF,0xFF))
	DrawText3D(tostring(DOWNSIDE_ANCIENTGOLEM.text), DOWNSIDE_ANCIENTGOLEM.x, DOWNSIDE_ANCIENTGOLEM.y, DOWNSIDE_ANCIENTGOLEM.z, 25, RGB(222, 245, 15), true)
	DrawCircle(DOWNSIDE_WOLVES.x, DOWNSIDE_WOLVES.y, DOWNSIDE_WOLVES.z, DOWNSIDE_WOLVES.range, ARGB(0x00,0xFF,0xFF,0xFF))
	DrawText3D(tostring(DOWNSIDE_WOLVES.text), DOWNSIDE_WOLVES.x, DOWNSIDE_WOLVES.y, DOWNSIDE_WOLVES.z, 25, RGB(222, 245, 15), true)
	DrawCircle(DOWNSIDE_WRAITHS.x, DOWNSIDE_WRAITHS.y, DOWNSIDE_WRAITHS.z, DOWNSIDE_WRAITHS.range, ARGB(0x00,0xFF,0xFF,0xFF))
	DrawText3D(tostring(DOWNSIDE_WRAITHS.text), DOWNSIDE_WRAITHS.x, DOWNSIDE_WRAITHS.y, DOWNSIDE_WRAITHS.z, 25, RGB(222, 245, 15), true)
	DrawCircle(DOWNSIDE_LIZARDELDER.x, DOWNSIDE_LIZARDELDER.y, DOWNSIDE_LIZARDELDER.z, DOWNSIDE_LIZARDELDER.range, ARGB(0x00,0xFF,0xFF,0xFF))
	DrawText3D(tostring(DOWNSIDE_LIZARDELDER.text), DOWNSIDE_LIZARDELDER.x, DOWNSIDE_LIZARDELDER.y, DOWNSIDE_LIZARDELDER.z, 25, RGB(222, 245, 15), true)
	DrawCircle(DOWNSIDE_GOLEMS.x, DOWNSIDE_GOLEMS.y, DOWNSIDE_GOLEMS.z, DOWNSIDE_GOLEMS.range, ARGB(0x00,0xFF,0xFF,0xFF))
	DrawText3D(tostring(DOWNSIDE_GOLEMS.text), DOWNSIDE_GOLEMS.x, DOWNSIDE_GOLEMS.y, DOWNSIDE_GOLEMS.z, 25, RGB(222, 245, 15), true)
end


function draw_camps_UPSIDE()
	DrawCircle(UPSIDE_GREATWIGHT.x, UPSIDE_GREATWIGHT.y, UPSIDE_GREATWIGHT.z, UPSIDE_GREATWIGHT.range, ARGB(0x00,0xFF,0xFF,0xFF))					
	DrawText3D(tostring(UPSIDE_GREATWIGHT.text), UPSIDE_GREATWIGHT.x, UPSIDE_GREATWIGHT.y, UPSIDE_GREATWIGHT.z, 25, RGB(222, 245, 15), true)					
	DrawCircle(UPSIDE_ANCIENTGOLEM.x, UPSIDE_ANCIENTGOLEM.y, UPSIDE_ANCIENTGOLEM.z, UPSIDE_ANCIENTGOLEM.range, ARGB(0x00,0xFF,0xFF,0xFF))
	DrawText3D(tostring(UPSIDE_ANCIENTGOLEM.text), UPSIDE_ANCIENTGOLEM.x, UPSIDE_ANCIENTGOLEM.y, UPSIDE_ANCIENTGOLEM.z, 25, RGB(222, 245, 15), true)
	DrawCircle(UPSIDE_WOLVES.x, UPSIDE_WOLVES.y, UPSIDE_WOLVES.z, UPSIDE_WOLVES.range, ARGB(0x00,0xFF,0xFF,0xFF))
	DrawText3D(tostring(UPSIDE_WOLVES.text), UPSIDE_WOLVES.x, UPSIDE_WOLVES.y, UPSIDE_WOLVES.z, 25, RGB(222, 245, 15), true)
	DrawCircle(UPSIDE_WRAITHS.x, UPSIDE_WRAITHS.y, UPSIDE_WRAITHS.z, UPSIDE_WRAITHS.range, ARGB(0x00,0xFF,0xFF,0xFF))
	DrawText3D(tostring(UPSIDE_WRAITHS.text), UPSIDE_WRAITHS.x, UPSIDE_WRAITHS.y, UPSIDE_WRAITHS.z, 25, RGB(222, 245, 15), true)
	DrawCircle(UPSIDE_LIZARDELDER.x, UPSIDE_LIZARDELDER.y, UPSIDE_LIZARDELDER.z, UPSIDE_LIZARDELDER.range, ARGB(0x00,0xFF,0xFF,0xFF))
	DrawText3D(tostring(UPSIDE_LIZARDELDER.text), UPSIDE_LIZARDELDER.x, UPSIDE_LIZARDELDER.y, UPSIDE_LIZARDELDER.z, 25, RGB(222, 245, 15), true)
	DrawCircle(UPSIDE_GOLEMS.x, UPSIDE_GOLEMS.y, UPSIDE_GOLEMS.z, UPSIDE_GOLEMS.range, ARGB(0x00,0xFF,0xFF,0xFF))
	DrawText3D(tostring(UPSIDE_GOLEMS.text), UPSIDE_GOLEMS.x, UPSIDE_GOLEMS.y, UPSIDE_GOLEMS.z, 25, RGB(222, 245, 15), true)
end


function draw_and_text_camps()
--draw_camps_UPSIDE()
if Config.autojungle then infotext_champion() end
if Config.debu.camp==true then infotext_camps() end
if Config.debu.spell==true then infotext_spells() end
if Config.debu.tar==true then _draw_tar() end
if Config.debu.camptxt==true then draw_camps_DOWNSIDE() end
end


function _draw_tar()
	if draw_tar~=nil then DrawCircle(draw_tar.x, draw_tar.y, draw_tar.z, 100, RGB(255,000,000)) end
end


function _setcamps()
--if did_blue_start == false then return end

--DOWNSIDE
if isBOTSIDE then
	DOWNSIDE_ANCIENTGOLEM.tick = -185
	DOWNSIDE_ANCIENTGOLEM.isup = false
	
	DOWNSIDE_LIZARDELDER.tick = -185
	DOWNSIDE_LIZARDELDER.isup = false
	
	DOWNSIDE_GREATWIGHT.tick = -194
	DOWNSIDE_GREATWIGHT.isup = false
	
	DOWNSIDE_WOLVES.tick = -194
	DOWNSIDE_WOLVES.isup = false
	
	DOWNSIDE_WRAITHS.tick = -194
	DOWNSIDE_WRAITHS.isup = false
	
	DOWNSIDE_GOLEMS.tick = -194
	DOWNSIDE_GOLEMS.isup = false
else
--TOPSIDE SETCAMPS

end
end



function OnLoad()
	init_config()
	recall_status = false
	pause = true
	
if myHero.charName=="Warwick" then
	my_levelSequence=levelSequence.Warwick
	my_shopSequence=shopSequence.Warwick
end

if myHero.charName=="Nunu" then
	my_levelSequence=levelSequence.Nunu
	my_shopSequence=shopSequence.Nunu
end

if myHero.charName=="Cassiopeia" then
	my_levelSequence=levelSequence.Cassiopeia
	my_shopSequence=shopSequence.Cassiopeia
end

if myHero.charName=="Nasus" then
	my_levelSequence=levelSequence.Nasus
	my_shopSequence=shopSequence.Nasus
end

if GetInGameTimer() > 150 then
	did_blue_start = true
 else
	if isBOTSIDE then
		update_infotext_camps("DOWNSIDE_ANCIENTGOLEM")
	else
		update_infotext_camps("UPSIDE_ANCIENTGOLEM")
	end
end

if GetInventorySlotIsEmpty(ITEM_1) == false then
	firstBought = true
end

nextbuyIndex = 1
startingTime = GetTickCount()
player = GetMyHero()

getside()

pstay_timer = os.clock()
autopottick = os.clock()
grabtimer = os.clock()
lulztimer = os.clock()

_setcamps()
end


function OnTick()
	check_spell_status()
	farmtar = _get_target()
	if farmtar~=nil and farmtar.dead==false and myHero.charName=="Nasus" then
		if farmtar.health < calc_q_dmg(farmtar) then
			_stay() 
		end
	end
	
	if recall_status then return end
	
	auto_ward()
	autopot()
	
	
	if setward==true then return end
	
	on_gamestart_wait_safe()
	_endofshopping()
	shop_items()
	stay_base_until_hp_full()
	level_skills()
	reset_timer()
	prevent_early_fail()
	
	if os.clock() >= grabtimer+0.250 then
		camp_timer()
		if gamestart==false then
			core()
		end
	grabtimer=os.clock()
	end
	perma_lulz()
end


function OnDraw()
draw_and_text_camps()
end


function OnWndMsg(msg,key)
    if msg == KEY_DOWN then	
    	if key == keyZERO then 			
				--do smth					
		end				
    end    
end


function check_for_obj(name)
	for i=1, objManager.maxObjects, 1 do
		local object = objManager:getObject(i)
		if object ~= nil and object.name == name and GetDistance(player, object) <= 2000 then					
			return object
		end
	end
end


function core()
	if Config.autojungle == false then return end

	perma_buffs()
	
	if player.health <= (player.maxHealth*0.3) then
	--laufe zu savespot and port home
		runhome=true
	else
		status="jungle"
	end

	if GetInGameTimer() < 420 and GetInGameTimer() > 0 and Config.autobuy and in_fight==false then
		if player.gold > 750 then
			--laufe zu savespot and port home
			runhome=true
		else
			status="jungle"
		end
	end
	
	if GetInGameTimer() < 900 and GetInGameTimer() > 420 and Config.autobuy and in_fight==false then
		if player.gold > 1250 then
			--laufe zu savespot and port home
			runhome=true
		else
			status="jungle"
		end
	end
	
	if GetInGameTimer() > 900 and Config.autobuy and in_fight==false then
		if player.gold > 2000 then
			--laufe zu savespot and port home
			runhome=true
		else
			status="jungle"
		end
	end
	
	if runhome==true then 
		if GetDistance(player, allySpawn) >= 100 then
			go_home()
		else
			runhome=false
		end
	end

	if status == "jungle" and runhome==false then
		jungle()
	end
	
end


function jungle()

	if camp_done==true then
		nextcamp = nil
	end
	
	if nextcamp == nil then
		nextcamp = get_next_camp()
	end

	if nextcamp=="DOWNSIDE_GREATWIGHT" then
		clear_DOWNSIDE_GREATWIGHT()
	end

	if nextcamp=="DOWNSIDE_ANCIENTGOLEM" then
		clear_DOWNSIDE_ANCIENTGOLEM()
	end

	if nextcamp=="DOWNSIDE_WOLVES" then
		clear_DOWNSIDE_WOLVES()
	end

	if nextcamp=="DOWNSIDE_WRAITHS" then
		clear_DOWNSIDE_WRAITHS()	
	end	

	if nextcamp=="DOWNSIDE_LIZARDELDER" then
		clear_DOWNSIDE_LIZARDELDER()
	end

	if nextcamp=="DOWNSIDE_GOLEMS" then
		clear_DOWNSIDE_GOLEMS()
	end	
		--und so weiter
end


function get_next_camp()
	if camp_done==false then return end
		
local tmp_next_camp = nil

	if did_blue_start==false then 
		if isBOTSIDE then
			tmp_next_camp="DOWNSIDE_ANCIENTGOLEM"
		else
			tmp_next_camp="UPSIDE_ANCIENTGOLEM"
		end
	else
		tmp_next_camp=get_best_camp()
	end

	camp_done=false
	curr_cmp = tmp_next_camp
	
	return tmp_next_camp
end


function camp_timer()
	camp_DOWNSIDE_GREATWIGHT_timer()
	camp_DOWNSIDE_ANCIENTGOLEM_timer()
	camp_DOWNSIDE_WOLVES_timer()
	camp_DOWNSIDE_WRAITHS_timer()
	camp_DOWNSIDE_LIZARDELDER_timer()
	camp_DOWNSIDE_GOLEMS_timer()
end


function get_best_camp()

if isBOTSIDE then
	local camp_DOWNSIDE_GREATWIGHT = {x=DOWNSIDE_GREATWIGHT.x,y=DOWNSIDE_GREATWIGHT.y,z=DOWNSIDE_GREATWIGHT.z, name="DOWNSIDE_GREATWIGHT", status = DOWNSIDE_GREATWIGHT.isup}
	local camp_DOWNSIDE_ANCIENTGOLEM = {x=DOWNSIDE_ANCIENTGOLEM.x,y=DOWNSIDE_ANCIENTGOLEM.y,z=DOWNSIDE_ANCIENTGOLEM.z, name="DOWNSIDE_ANCIENTGOLEM", status = DOWNSIDE_ANCIENTGOLEM.isup}
	local camp_DOWNSIDE_WOLVES = {x=DOWNSIDE_WOLVES.x,y=DOWNSIDE_WOLVES.y,z=DOWNSIDE_WOLVES.z, name="DOWNSIDE_WOLVES", status = DOWNSIDE_WOLVES.isup}
	local camp_DOWNSIDE_WRAITHS = {x=DOWNSIDE_WRAITHS.x,y=DOWNSIDE_WRAITHS.y,z=DOWNSIDE_WRAITHS.z, name="DOWNSIDE_WRAITHS", status = DOWNSIDE_WRAITHS.isup}
	local camp_DOWNSIDE_LIZARDELDER = {x=DOWNSIDE_LIZARDELDER.x,y=DOWNSIDE_LIZARDELDER.y,z=DOWNSIDE_LIZARDELDER.z, name="DOWNSIDE_LIZARDELDER", status = DOWNSIDE_LIZARDELDER.isup}
	local camp_DOWNSIDE_GOLEMS = {x=DOWNSIDE_GOLEMS.x,y=DOWNSIDE_GOLEMS.y,z=DOWNSIDE_GOLEMS.z, name="DOWNSIDE_GOLEMS", status = DOWNSIDE_GOLEMS.isup}
	local camp_array = {camp_DOWNSIDE_GREATWIGHT, camp_DOWNSIDE_ANCIENTGOLEM, camp_DOWNSIDE_WOLVES, camp_DOWNSIDE_WRAITHS, camp_DOWNSIDE_LIZARDELDER, camp_DOWNSIDE_GOLEMS}
    local way = 30000
    local closest_camp = nil
	
    for i=1, 6 do
        this_camp = camp_array[i]
        if  GetDistance(player, this_camp) < way and this_camp.status==true and GetDistance(player, this_camp) >= 500 then
            way = GetDistance(player, this_camp)
            closest_camp = this_camp
        end
    end
	update_infotext_camps(closest_camp.name)
	if closest_camp~=nil then return closest_camp.name end	
	
else
--selbes spielchen für topside



end
end


function clear_DOWNSIDE_GREATWIGHT()
	local mycamp = {x=DOWNSIDE_GREATWIGHT.x,y=DOWNSIDE_GREATWIGHT.y,z=DOWNSIDE_GREATWIGHT.z}
		if GetDistance(player, mycamp) >= 150 and not player.dead then
			in_fight=false
			txtonme.line_one="Current status: Jungle"
			txtonme.line_two="Next Camp: Great Wight"
			txtonme.line_three="Dist.: "..GetDistance(player, mycamp)
			player:MoveTo(mycamp.x,mycamp.z)
		else
			--am ziel
			camp_DOWNSIDE_GREATWIGHT_check()
			if DOWNSIDE_GREATWIGHT.isup==true then			
			--kill creeps			
			in_fight=true			
			kill_(DOWNSIDE_GREATWIGHT.name, nil, nil, nil)
			--kill_(main, slave_ONE, slave_two, slave_three, slave_four)			
			end			
		end
		
end


function camp_DOWNSIDE_GREATWIGHT_check()			
			local camp_counter = 0
			local mycamp = {x=DOWNSIDE_GREATWIGHT.x,y=DOWNSIDE_GREATWIGHT.y,z=DOWNSIDE_GREATWIGHT.z}
			
				for i=1, objManager.maxObjects, 1 do
					local object = objManager:getObject(i)					
					if object ~= nil and object.valid and object.visible and GetDistance(object, mycamp) <= 750 and object.name == DOWNSIDE_GREATWIGHT.name and not object.dead then
						camp_counter = camp_counter + 1
					end
				end
				
				if camp_counter == 1 then			
					DOWNSIDE_GREATWIGHT.text = "UP"		
					DOWNSIDE_GREATWIGHT.isup = true
					
				else					
						DOWNSIDE_GREATWIGHT.isup = false
						DOWNSIDE_GREATWIGHT.tick = GetInGameTimer()
						DOWNSIDE_GREATWIGHT.text = "DOWN"
						check_if_camp_is_done(DOWNSIDE_GREATWIGHT.name, nil, nil, nil, DOWNSIDE_GREATWIGHT.x,DOWNSIDE_GREATWIGHT.y, DOWNSIDE_GREATWIGHT.z)					
				end	
				
end


function camp_DOWNSIDE_GREATWIGHT_timer()
	if DOWNSIDE_GREATWIGHT.isup == false then
		if GetInGameTimer() - DOWNSIDE_GREATWIGHT.tick > 50 then
			DOWNSIDE_GREATWIGHT.isup = true
			DOWNSIDE_GREATWIGHT.text = "UP"
		else
			DOWNSIDE_GREATWIGHT.text = "DOWN: "..((DOWNSIDE_GREATWIGHT.tick + 50) - GetInGameTimer())
		end
	end

end


function clear_DOWNSIDE_ANCIENTGOLEM()
	local mycamp = {x=DOWNSIDE_ANCIENTGOLEM.x,y=DOWNSIDE_ANCIENTGOLEM.y,z=DOWNSIDE_ANCIENTGOLEM.z}
	if GetDistance(player, mycamp) >= 150 and not player.dead then
		txtonme.line_one="Current status: Jungle"
		txtonme.line_two="Next Camp: Blue Buff"
		txtonme.line_three="Dist.: "..GetDistance(player, mycamp)
		player:MoveTo(mycamp.x,mycamp.z)
		in_fight=false
	else
		--am ziel
		camp_DOWNSIDE_ANCIENTGOLEM_check()
		if DOWNSIDE_ANCIENTGOLEM.isup==true then
			in_fight=true
			--kill creeps
			kill_(DOWNSIDE_ANCIENTGOLEM.BIG, DOWNSIDE_ANCIENTGOLEM.SMALL_ONE, DOWNSIDE_ANCIENTGOLEM.SMALL_TWO, nil)				
			--kill_(main, slave_ONE, slave_two, slave_three, slave_four)				
		end			
	end
	
end


function camp_DOWNSIDE_ANCIENTGOLEM_check()			
	local camp_counter = 0
	local mycamp = {x=DOWNSIDE_ANCIENTGOLEM.x,y=DOWNSIDE_ANCIENTGOLEM.y,z=DOWNSIDE_ANCIENTGOLEM.z}
			
	for i=1, objManager.maxObjects, 1 do
		local object = objManager:getObject(i)					
		if object ~= nil and object.valid and object.visible and GetDistance(object, mycamp) <= 750 and (object.name == DOWNSIDE_ANCIENTGOLEM.BIG or object.name == DOWNSIDE_ANCIENTGOLEM.SMALL_ONE or object.name == DOWNSIDE_ANCIENTGOLEM.SMALL_TWO) and not object.dead then
			camp_counter = camp_counter + 1
		end
	end
			
	if camp_counter >= 1 then			
		DOWNSIDE_ANCIENTGOLEM.text = "UP"		
		DOWNSIDE_ANCIENTGOLEM.isup = true					
	else			
		if did_blue_start==false then
			did_blue_start=true
		end
		DOWNSIDE_ANCIENTGOLEM.isup = false
		DOWNSIDE_ANCIENTGOLEM.tick = GetInGameTimer()
		DOWNSIDE_ANCIENTGOLEM.text = "DOWN"						
		check_if_camp_is_done(DOWNSIDE_ANCIENTGOLEM.BIG, DOWNSIDE_ANCIENTGOLEM.SMALL_ONE, DOWNSIDE_ANCIENTGOLEM.SMALL_TWO, nil, DOWNSIDE_ANCIENTGOLEM.x,DOWNSIDE_ANCIENTGOLEM.y, DOWNSIDE_ANCIENTGOLEM.z)
	end	
		
end


function camp_DOWNSIDE_ANCIENTGOLEM_timer()
	if DOWNSIDE_ANCIENTGOLEM.isup == false then
		if GetInGameTimer() - DOWNSIDE_ANCIENTGOLEM.tick > 300 then
			DOWNSIDE_ANCIENTGOLEM.isup = true
			DOWNSIDE_ANCIENTGOLEM.text = "UP"
		else
			DOWNSIDE_ANCIENTGOLEM.text = "DOWN: "..((DOWNSIDE_ANCIENTGOLEM.tick + 300) - GetInGameTimer())
		end
	end
end

--DOWNSIDE_WOLVES
function clear_DOWNSIDE_WOLVES()
	local mycamp = {x=DOWNSIDE_WOLVES.x,y=DOWNSIDE_WOLVES.y,z=DOWNSIDE_WOLVES.z}
	if GetDistance(player, mycamp) >= 150 and not player.dead then
		txtonme.line_one="Current status: Jungle"
		txtonme.line_two="Next Camp: Wolves"
		txtonme.line_three="Dist.: "..GetDistance(player, mycamp)
		player:MoveTo(mycamp.x,mycamp.z)
	else
		--am ziel
		camp_DOWNSIDE_WOLVES_check()
		if DOWNSIDE_WOLVES.isup==true then			
			--kill creeps
			kill_(DOWNSIDE_WOLVES.BIG, DOWNSIDE_WOLVES.SMALL_ONE, DOWNSIDE_WOLVES.SMALL_TWO, nil, nil)
			--kill_(main, slave_ONE, slave_two, slave_three, slave_four)					
		end			
	end
	
end


function camp_DOWNSIDE_WOLVES_check()			
	local camp_counter = 0
	local mycamp = {x=DOWNSIDE_WOLVES.x,y=DOWNSIDE_WOLVES.y,z=DOWNSIDE_WOLVES.z}
			
		for i=1, objManager.maxObjects, 1 do
			local object = objManager:getObject(i)					
			if object ~= nil and object.valid and object.visible and GetDistance(object, mycamp) <= 750 and (object.name == DOWNSIDE_WOLVES.BIG or object.name == DOWNSIDE_WOLVES.SMALL_ONE or object.name == DOWNSIDE_WOLVES.SMALL_TWO) and not object.dead then
				camp_counter = camp_counter + 1
			end
		end
			
		if camp_counter >= 1 then			
			DOWNSIDE_WOLVES.text = "1UP"		
			DOWNSIDE_WOLVES.isup = true					
		else								
			DOWNSIDE_WOLVES.isup = false
			DOWNSIDE_WOLVES.tick = GetInGameTimer()
			DOWNSIDE_WOLVES.text = "DOWNaaa"	
			check_if_camp_is_done(DOWNSIDE_WOLVES.BIG, DOWNSIDE_WOLVES.SMALL_ONE, DOWNSIDE_WOLVES.SMALL_TWO, nil, DOWNSIDE_WOLVES.x,DOWNSIDE_WOLVES.y, DOWNSIDE_WOLVES.z)						
		end		
		
end


function camp_DOWNSIDE_WOLVES_timer()
	if DOWNSIDE_WOLVES.isup == false then
		if GetInGameTimer() - DOWNSIDE_WOLVES.tick > 50 then
			DOWNSIDE_WOLVES.isup = true
			DOWNSIDE_WOLVES.text = "2UP"
		else
			DOWNSIDE_WOLVES.text = "DOWN"..((DOWNSIDE_WOLVES.tick + 50) - GetInGameTimer())
		end
	end

end

--wrai
function clear_DOWNSIDE_WRAITHS()
	local mycamp = {x=DOWNSIDE_WRAITHS.x,y=DOWNSIDE_WRAITHS.y,z=DOWNSIDE_WRAITHS.z}
	if GetDistance(player, mycamp) >= 150 and not player.dead then
		in_fight=false
		txtonme.line_one="Current status: Jungle"
		txtonme.line_two="Next Camp: Wraiths"
		txtonme.line_three="Dist.: "..GetDistance(player, mycamp)
		player:MoveTo(mycamp.x,mycamp.z)
	else
		--am ziel
		camp_DOWNSIDE_WRAITHS_check()
		if DOWNSIDE_WRAITHS.isup==true then			
			--kill creeps
			in_fight=true
			kill_(DOWNSIDE_WRAITHS.BIG, DOWNSIDE_WRAITHS.SMALL_ONE, DOWNSIDE_WRAITHS.SMALL_TWO, DOWNSIDE_WRAITHS.SMALL_THREE)
			--kill_(main, slave_ONE, slave_two, slave_three, slave_four)
		end			
	end
	
end


function camp_DOWNSIDE_WRAITHS_check()			
	local camp_counter = 0
	local mycamp = {x=DOWNSIDE_WRAITHS.x,y=DOWNSIDE_WRAITHS.y,z=DOWNSIDE_WRAITHS.z}
			
	for i=1, objManager.maxObjects, 1 do
		local object = objManager:getObject(i)					
		if object ~= nil and object.valid and object.visible and GetDistance(object, mycamp) <= 750 and (object.name == DOWNSIDE_WRAITHS.BIG or object.name == DOWNSIDE_WRAITHS.SMALL_ONE or object.name == DOWNSIDE_WRAITHS.SMALL_TWO or object.name == DOWNSIDE_WRAITHS.SMALL_THREE) and not object.dead then
			camp_counter = camp_counter + 1
		end
	end
			
	if camp_counter >= 1 then			
		DOWNSIDE_WRAITHS.text = "UP"		
		DOWNSIDE_WRAITHS.isup = true					
	else					
		DOWNSIDE_WRAITHS.isup = false
		DOWNSIDE_WRAITHS.tick = GetInGameTimer()
		DOWNSIDE_WRAITHS.text = "DOWN"
		check_if_camp_is_done(DOWNSIDE_WRAITHS.BIG, DOWNSIDE_WRAITHS.SMALL_ONE, DOWNSIDE_WRAITHS.SMALL_TWO, DOWNSIDE_WRAITHS.SMALL_THREE, DOWNSIDE_WRAITHS.x,DOWNSIDE_WRAITHS.y, DOWNSIDE_WRAITHS.z)
	end	
	
end


function camp_DOWNSIDE_WRAITHS_timer()
	if DOWNSIDE_WRAITHS.isup == false then
		if GetInGameTimer() - DOWNSIDE_WRAITHS.tick > 50 then
			DOWNSIDE_WRAITHS.isup = true
			DOWNSIDE_WRAITHS.text = "UP"
		else
			DOWNSIDE_WRAITHS.text = "DOWN"..((DOWNSIDE_WRAITHS.tick + 50) - GetInGameTimer())
		end
	end

end


function clear_DOWNSIDE_LIZARDELDER()
	local mycamp = {x=DOWNSIDE_LIZARDELDER.x,y=DOWNSIDE_LIZARDELDER.y,z=DOWNSIDE_LIZARDELDER.z}
	if GetDistance(player, mycamp) >= 150 and not player.dead then
		in_fight=false
		txtonme.line_one="Current status: Jungle"
		txtonme.line_two="Next Camp: Red Buff"
		txtonme.line_three="Dist.: "..GetDistance(player, mycamp)
		player:MoveTo(mycamp.x,mycamp.z)
	else
		--am ziel
		camp_DOWNSIDE_LIZARDELDER_check()
		if DOWNSIDE_LIZARDELDER.isup==true then
			in_fight=true			
			--kill creeps
			kill_(DOWNSIDE_LIZARDELDER.BIG, DOWNSIDE_LIZARDELDER.SMALL_ONE, DOWNSIDE_LIZARDELDER.SMALL_TWO, nil)
			--kill_(main, slave_ONE, slave_two, slave_three, slave_four)					
		end			
	end
	
end


function camp_DOWNSIDE_LIZARDELDER_check()			
	local camp_counter = 0
	local mycamp = {x=DOWNSIDE_LIZARDELDER.x,y=DOWNSIDE_LIZARDELDER.y,z=DOWNSIDE_LIZARDELDER.z}
			
	for i=1, objManager.maxObjects, 1 do
		local object = objManager:getObject(i)					
		if object ~= nil and object.valid and object.visible and GetDistance(object, mycamp) <= 750 and (object.name == DOWNSIDE_LIZARDELDER.BIG or object.name == DOWNSIDE_LIZARDELDER.SMALL_ONE or object.name == DOWNSIDE_LIZARDELDER.SMALL_TWO) and not object.dead then
			camp_counter = camp_counter + 1
		end
	end
			
	if camp_counter >= 1 then			
		DOWNSIDE_LIZARDELDER.text = "UP"		
		DOWNSIDE_LIZARDELDER.isup = true
	else								
		DOWNSIDE_LIZARDELDER.isup = false
		DOWNSIDE_LIZARDELDER.tick = GetInGameTimer()
		DOWNSIDE_LIZARDELDER.text = "DOWN"
		check_if_camp_is_done(DOWNSIDE_LIZARDELDER.BIG, DOWNSIDE_LIZARDELDER.SMALL_ONE, DOWNSIDE_LIZARDELDER.SMALL_TWO, nil, DOWNSIDE_LIZARDELDER.x,DOWNSIDE_LIZARDELDER.y, DOWNSIDE_LIZARDELDER.z)
	end		
	
end


function camp_DOWNSIDE_LIZARDELDER_timer()
	if DOWNSIDE_LIZARDELDER.isup == false then
		if GetInGameTimer() - DOWNSIDE_LIZARDELDER.tick > 300 then
			DOWNSIDE_LIZARDELDER.isup = true
			DOWNSIDE_LIZARDELDER.text = "UP"
		else
			DOWNSIDE_LIZARDELDER.text = "DOWN"..((DOWNSIDE_LIZARDELDER.tick + 300) - GetInGameTimer())
		end
	end

end


function clear_DOWNSIDE_GOLEMS()
	local mycamp = {x=DOWNSIDE_GOLEMS.x,y=DOWNSIDE_GOLEMS.y,z=DOWNSIDE_GOLEMS.z}
		if GetDistance(player, mycamp) >= 150 and not player.dead then
			in_fight=false
			txtonme.line_one="Current status: Jungle"
			txtonme.line_two="Next Camp: Golems"
			txtonme.line_three="Dist.: "..GetDistance(player, mycamp)
			player:MoveTo(mycamp.x,mycamp.z)
		else
		--am ziel
		camp_DOWNSIDE_GOLEMS_check()
		if DOWNSIDE_GOLEMS.isup==true then
			in_fight=true
			kill_(DOWNSIDE_GOLEMS.BIG, DOWNSIDE_GOLEMS.SMALL, nil, nil)
			--kill_(main, slave_ONE, slave_two, slave_three, slave_four)			
			--kill creeps		
			end			
		end
		
end


function camp_DOWNSIDE_GOLEMS_check()			
	local camp_counter = 0
	local mycamp = {x=DOWNSIDE_GOLEMS.x,y=DOWNSIDE_GOLEMS.y,z=DOWNSIDE_GOLEMS.z}
			
	for i=1, objManager.maxObjects, 1 do
		local object = objManager:getObject(i)					
		if object ~= nil and object.valid and object.visible and GetDistance(object, mycamp) <= 750 and (object.name == DOWNSIDE_GOLEMS.BIG or object.name == DOWNSIDE_GOLEMS.SMALL) and not object.dead then
			camp_counter = camp_counter + 1
		end
	end
			
	if camp_counter >= 1 then			
		DOWNSIDE_GOLEMS.text = "UP"		
		DOWNSIDE_GOLEMS.isup = true					
	else					
		DOWNSIDE_GOLEMS.isup = false
		DOWNSIDE_GOLEMS.tick = GetInGameTimer()
		DOWNSIDE_GOLEMS.text = "DOWN"
		check_if_camp_is_done(DOWNSIDE_GOLEMS.BIG, DOWNSIDE_GOLEMS.SMALL, nil, nil, DOWNSIDE_GOLEMS.x,DOWNSIDE_GOLEMS.y, DOWNSIDE_GOLEMS.z)					
	end		
	
end


function camp_DOWNSIDE_GOLEMS_timer()
	if DOWNSIDE_GOLEMS.isup == false then
		if GetInGameTimer() - DOWNSIDE_GOLEMS.tick > 50 then
			DOWNSIDE_GOLEMS.isup = true
			DOWNSIDE_GOLEMS.text = "UP"
		else
			DOWNSIDE_GOLEMS.text = "DOWN"..((DOWNSIDE_GOLEMS.tick + 50) - GetInGameTimer())
		end
	end
end







function kill_(main, slave_ONE, slave_two, slave_three, slave_four)
	if farmtar ~= nil  and farmtar.dead==false  then
		target = farmtar
		PrintChat("farmtar")
	else
		target= _get_target()
		if myHero.charName=="Nasus" then
			if target.health <  calc_q_dmg(target) then
				if QReady==false then
					_stay()
					return end
			end
		end
		PrintChat("newtar")
	end
	

	walkspot_a = {x=player.x-10,y=player.y, z=player.z-10}
	walkspot_b = {x=player.x+10,y=player.y, z=player.z+10}
	txtonme.line_one="Current status: FIGHTING"
	txtonme.line_two="Current Camp: "..curr_cmp
	
	if myHero.charName=="Nasus" then
		if target~=nil then
			draw_tar = target
			txtonme.line_three="Current Target"..target.name
			if target.health >  calc_q_dmg(target) or myHero.level==1 then
				PrintChat("i can use spells: "..target.health)
				if calc_q_dmg(target) < 1000 then
					useSpells(target)
				end
				player:Attack(target)
			else
				PrintChat("i wait for q")
				if HasQBuff then
					player:Attack(target)
				else			
					if QReady then
						CastSpell(_Q)
					else
						_stay()
					end	
				end
			end
		else
			draw_tar=nil
			camp_done=true
		end	
	else
		if target~=nil then
			draw_tar = target
			txtonme.line_three="Current Target"..target.name
			useSpells(target)
			player:Attack(target)	
		else
			draw_tar=nil
			camp_done=true
		end
	end
	
end


function check_spell_status()
	QReady = (myHero:CanUseSpell(_Q) == READY)
	WReady = (myHero:CanUseSpell(_W) == READY)
	EReady = (myHero:CanUseSpell(_E) == READY)
	RReady = (myHero:CanUseSpell(_R) == READY)
end


function useSpells(target)
	check_spell_status()
	if os.clock() >= spelltimer+0.1then
		if QReady then useQ(target) end
		if WReady then useW(target) end
		if EReady then useE(target) end
		if RReady then useR(target) end
		spelltimer=os.clock()
	end	
end


function useQ(target)
	if myHero.charName=="Warwick" then
		update_infotext_spellss("Q", target.name)
		CastSpell(_Q, target)
	end
	
	if myHero.charName=="Nunu" then
		update_infotext_spellss("Q", target.name)
		CastSpell(_Q, target)
	end
	
	if myHero.charName=="Cassiopeia" then
		update_infotext_spellss("Q", target.name)
		CastSpell(_Q, target.x, target.z)
	end
	
	if myHero.charName=="Nasus" then
		update_infotext_spellss("Q", target.name)
		CastSpell(_Q)
	end

end


function useW(target)
	if myHero.charName=="Warwick" then
		update_infotext_spellss("W", "me")
		CastSpell(_W)
	end
	
	if myHero.charName=="Nunu" then
		update_infotext_spellss("W", "me")
		CastSpell(_W, player)
	end
	
	if myHero.charName=="Cassiopeia" then
		update_infotext_spellss("W", target.name)
		CastSpell(_W, target.x, target.z)
	end
	
end


function useE(target)
	if myHero.charName=="Warwick" and target.team ~= player.team and target.team==TEAM_ENEMY then
		CastSpell(_E)
	end
	
	if myHero.charName=="Nunu" then
		update_infotext_spellss("E", target.name)
		CastSpell(_E, target)
	end
	
	if myHero.charName=="Cassiopeia" then
		update_infotext_spellss("E", target.name)
		CastSpell(_E, target)
	end
	
	if myHero.charName=="Nasus" and target.health>=target.maxHealth*0.75 then
		update_infotext_spellss("E", target.name)
		CastSpell(_E, target.x , target.z)
	end
	
end


function useR(target)
--no need in gernerall for jungle, maybe karma?
end

function getside()
	for i=1, objManager.maxObjects, 1 do
		local foundobj = objManager:getObject(i)
		if foundobj ~= nil and foundobj.valid and foundobj.type == "obj_SpawnPoint" then
			if foundobj.x < 3000 then
				if player.team == TEAM_BLUE then
					allySpawn = foundobj
					isTOPSIDE = false
					isBOTSIDE = true
					PrintChat("DOWNSIDE")
				else 
					enemySpawn = foundobj
					isBOTSIDE = false
					isTOPSIDE = true
					PrintChat("UPSIDE")
				end					
			else
				if player.team == TEAM_BLUE then
					enemySpawn = foundobj
					isTOPSIDE = false
					isBOTSIDE = true
					PrintChat("DOWNSIDE")
				else
					allySpawn = foundobj
					isBOTSIDE = false
					isTOPSIDE = true
					PrintChat("UPSIDE")
				end
			end
		end
	end
	
end

--kill_(DOWNSIDE_ANCIENTGOLEM.BIG, DOWNSIDE_ANCIENTGOLEM.SMALL_ONE, DOWNSIDE_ANCIENTGOLEM.SMALL_TWO, nil)
function check_if_camp_is_done(big, small, little, retard, checkx,checky, checkz)
	local tmp_big, tmp_small, tmp_little, tmp_retard = nil, nil, nil, nil
	local target_counter = 0
	local scanarea = { x=checkx , y=checky ,z=checkz }
	
	if GetDistance(player, scanarea) >= 150 and not player.dead then		
		player:MoveTo(mycamp.x,mycamp.z)
	else	
		if big~= nil then
			tmp_big = big
		else
			tmp_big = "bilbao"
		end
		if small~= nil then
			tmp_small = small
		else
			tmp_small = "bilbaoo"
		end
		if little~= nil then
			tmp_little = little
		else
			tmp_little = "bilbaooo"
		end
		if retard~= nil then
			tmp_retard = retard
		else
			tmp_retard = "bilbaoooo"
		end
		for i=1, objManager.maxObjects, 1 do
			local object = objManager:getObject(i)					
			if object ~= nil and object.valid and object.visible and GetDistance(object, player) <= 750 and (object.name == tmp_big or object.name == tmp_small or object.name == tmp_little or object.name == tmp_retard ) and not object.dead then
				target_counter = target_counter + 1
			end
		end
		if target_counter == 0 then
			camp_done=true
		end
	end
	
end


function reset_timer()
	reset_timer_big()
	reset_timer_little()
end


function reset_timer_big()
	if reset_big then return end
	
	if GetInGameTimer() > 115 and isBOTSIDE then
		DOWNSIDE_ANCIENTGOLEM.tick = nil --muss startzeit haben
		DOWNSIDE_ANCIENTGOLEM.isup = true
		DOWNSIDE_ANCIENTGOLEM.text = "UP"
		DOWNSIDE_LIZARDELDER.tick = nil
		DOWNSIDE_LIZARDELDER.isup = true
		DOWNSIDE_LIZARDELDER.text = "UP"
		reset_big=true
	end
	
	if GetInGameTimer() > 115 and not isBOTSIDE then
	
	
	------------------------------------------------------SAME FOR TOP
	
	end
	
end


function reset_timer_little()
	if reset_little then return end
	
	if GetInGameTimer() > 125 and isBOTSIDE then
		DOWNSIDE_GREATWIGHT.tick = nil
		DOWNSIDE_GREATWIGHT.isup = true
		DOWNSIDE_GREATWIGHT.text = "UP"
		DOWNSIDE_WOLVES.tick = nil
		DOWNSIDE_WOLVES.isup = true
		DOWNSIDE_WOLVES.text = "3UP"
		DOWNSIDE_WRAITHS.tick = nil
		DOWNSIDE_WRAITHS.isup = true
		DOWNSIDE_WRAITHS.text = "UP"
		DOWNSIDE_GOLEMS.tick = nil
		DOWNSIDE_GOLEMS.isup = true
		DOWNSIDE_GOLEMS.text = "UP"
		reset_little=true
	end
	
	if GetInGameTimer() > 125 and not isBOTSIDE then
	
	------------------------------------------------same for top
	
	end
	
end


function level_skills()
	if Config.autoskill==false then return end
	
	if player.level > abilityLevel then
		abilityLevel=abilityLevel+1
		if my_levelSequence[abilityLevel] == 1 then LevelSpell(_Q)
			elseif my_levelSequence[abilityLevel] == 2 then LevelSpell(_W)
			elseif my_levelSequence[abilityLevel] == 3 then LevelSpell(_E)
			elseif my_levelSequence[abilityLevel] == 4 then LevelSpell(_R)
		end	
	end
	
end


function on_gamestart_wait_safe()
	if Config.autojungle == false then return end
	
	if GetInGameTimer() < 25 and GetInGameTimer() > 1 then
		gamestart = true				
		player:HoldPosition()
	end
	
	if GetInGameTimer() < 111 and GetInGameTimer() > 25 then
		gamestart = true
		txtonme.line_one="Current status: Gamestart"
		txtonme.line_two="Next Area: waitspot"
		txtonme.line_three=" "
		if isBOTSIDE then
			player:MoveTo(2235,6201)
		else
			--------------------MOVE TO TOPSIDE WAITSPOT
		end
	end
		if GetInGameTimer() > 111 then
		gamestart = false				
	end		
	
end


function perma_lulz()
	if Config.autojungle == false then return end
	if Config.autojungle == true then return end
	
	local my_as = player.attackSpeed
	if os.clock() >= lulztimer+(my_as*2) then
		SendChat("/l")
		lulztimer=os.clock()
	end
	
end


function shop_items()
	if Config.autobuy == false then return end
	if fullbuild then return end

	if firstBought == false and GetTickCount() - startingTime > 2000 then	
		if myHero.charName=="Warwick" then
			BuyItem(2003)
			BuyItem(2003)
			BuyItem(1029)
			BuyItem(3340)--ward
		end	
		if myHero.charName=="Nunu" or myHero.charName=="Cassiopeia" or myHero.charName=="Nasus" then
			BuyItem(2003)
			BuyItem(2003)
			BuyItem(2003)
			BuyItem(2003)
			BuyItem(2003)
			BuyItem(1039)
			BuyItem(3340)--ward
		end
		firstBought = true
	end
	
	if GetInGameTimer() > 600 then
		local tmp_hppot_slot = GetInventorySlotItem(2003)
		if tmp_hppot_slot ~= nil then	
			SellItem(tmp_hppot_slot)
		end
	end
	
	if GetTickCount() - startingTime > 5000 then
		if GetTickCount() > lastBuy + 1000 then
			if GetInventorySlotItem(my_shopSequence[nextbuyIndex]) ~= nil then
				--Last Buy successful
				nextbuyIndex = nextbuyIndex + 1
			else
				--Last Buy unsuccessful (buy again)
				BuyItem(my_shopSequence[nextbuyIndex])
				lastBuy = GetTickCount()
			end
		end
	end
	
end


function prevent_early_fail()-------------noch topside adden
	if player.level < 6 then
		DOWNSIDE_GREATWIGHT.tick = 6666
		DOWNSIDE_GREATWIGHT.isup = false
		DOWNSIDE_GREATWIGHT.text = "DOWN_for_antifail"
	else
		if prev_early_fail_finished==false then
			DOWNSIDE_GREATWIGHT.isup = true
			prev_early_fail_finished = true
			DOWNSIDE_GREATWIGHT.text = "UP"
		end
	end
	
end


function go_home() --function mit safespot, laufe zu safespot dann recall
	my_safespot = next_safespot()
	if GetDistance(player, my_safespot) > 50 then
		txtonme.line_one="Current status: RUN HOME"
		txtonme.line_two="Next Area: Savespot-> "..my_safespot.name
		txtonme.line_three="Dist.: "..GetDistance(player, my_safespot)
		player:MoveTo(my_safespot.x, my_safespot.z)
	else
		CastSpell(RECALL)
	end

end


function next_safespot()
if isBOTSIDE then
	local savespot_array = {savespot_alpha, savespot_beta, savespot_gamma, savespot_delta, savespot_epsilon, savespot_stigma,  savespot_zeta, savespot_eta}
    local way = 25000
    local closest_savespot = nil
    for i=1, 8 do
        this_savespot = savespot_array[i]
        if  GetDistance(player, this_savespot) < way then
            way = GetDistance(player, this_savespot)
            closest_savespot = this_savespot
        end
    end
	
    return closest_savespot
else

-----------selbes für topside
end
end


function OnCreateObj(object)
	if object.name == "TeleportHome.troy" and GetDistance(player, object) < 25 then
		recall_status = true
	end
	if object.name == "TeleportHomeImproved.troy" and GetDistance(player, object) < 25 then
		recall_status = true
	end
	
end


function OnDeleteObj(object)
	if object.name == "TeleportHome.troy" and GetDistance(player, object) < 25 then
		recall_status = false 
	end
	if object.name == "TeleportHomeImproved.troy" and GetDistance(player, object) < 25 then
		recall_status = false 
	end
end


function init_config()
    PrintChat("<font color='#ab15d9'> > AutoJungler by Bilbao loaded</font>")   
	Config = scriptConfig("Bilbao Jungler", " Skill Info")
	Config:addParam("autojungle", "Auto Jungle", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte("U"))
	Config:permaShow("autojungle")	
    Config:addParam("autoskill", "AutoSkill", SCRIPT_PARAM_ONOFF, false)
    Config:addParam("autobuy", "Buy Items", SCRIPT_PARAM_ONOFF, false)
    Config:addParam("autoward", "Set Wards", SCRIPT_PARAM_ONOFF, false)
	Config:addParam("autopot", "Use HPPot", SCRIPT_PARAM_ONOFF, false)
	Config:addParam("autopotslider", "Use Pot @ %", SCRIPT_PARAM_SLICE, 75, 0, 100, 0)
	Config:addParam("by", "v1.0 by Bilbao", SCRIPT_PARAM_INFO, "")
	Config:addSubMenu("Debug","debu")
	Config.debu:addParam("camptxt", "Show camptext+timer",SCRIPT_PARAM_ONOFF, false)
	Config.debu:addParam("camp", "Show camplist",SCRIPT_PARAM_ONOFF, false)
	Config.debu:addParam("spell", "Show spelllist",SCRIPT_PARAM_ONOFF, false)
	Config.debu:addParam("tar", "Show target",SCRIPT_PARAM_ONOFF, false)
end


function auto_ward()
	if Config.autojungle == false then return end
	if Config.autoward==false then return end
	if GetInGameTimer() < 300 then	return end

	local trinket_id = nil
	if player.level >= 9 then
		trinket_id = 3350
	else
		trinket_id = 3340
	end

	ward_wriggls.itemslot = GetInventorySlotItem(3154)
	if ward_wriggls.itemslot ~= nil then
		if player:CanUseSpell(ward_wriggls.itemslot) == READY then
			ward_wriggls.isrdy=true
		else
			ward_wriggls.isrdy=false
			setward=false
		end
	end

	ward_trinket.itemslot = GetInventorySlotItem(trinket_id)
	if ward_trinket.itemslot ~= nil then
		if myHero:CanUseSpell(ward_trinket.itemslot) == READY then
			ward_trinket.isrdy=true
		else
			ward_trinket.isrdy=false
			setward=false
		end
	end

	if ward_wriggls.isrdy and GetDistance(player, wardspot_right) <= 3550 then
		setward=true
		if GetDistance(player, wardspot_right) >= 25 then
			txtonme.line_one="Current status: WARDING RIGHT RIVER"
			txtonme.line_two="Next Area: Right river,bush"
			txtonme.line_three="Dist.: "..GetDistance(player, wardspot_right)
			player:MoveTo(wardspot_right.x - 5, wardspot_right.z - 5)
		else
			CastSpell(ward_wriggls.itemslot, wardspot_right.x, wardspot_right.z)
			PingSignal(PING_NORMAL,wardspot_right.x,wardspot_right.y,wardspot_right.z,2)
		end
	else
		setward=false
	end

	if ward_trinket.isrdy and GetDistance(player, wardspot_left) <= 3550  then
		--laufe zu spot
		setward=true
		if GetDistance(player, wardspot_left) >= 25 then
			txtonme.line_one="Current status: WARDING LEFT RIVER"
			txtonme.line_two="Next Area: Left river,bush"
			txtonme.line_three="Dist.: "..GetDistance(player, wardspot_left)
			player:MoveTo(wardspot_left.x - 5, wardspot_left.z - 5)
		else
			CastSpell(ward_trinket.itemslot, wardspot_left.x, wardspot_left.z)
			PingSignal(PING_NORMAL,wardspot_left.x,wardspot_left.y,wardspot_left.z,2)
		end
	else
		setward=false
	end
	
end


function perma_buffs()
	if myHero.charName=="Nunu" and WReady and player.mana > (player.maxMana*0.5)  then 
		update_infotext_spellss("W", "me")
		CastSpell(_W, player)
	end
end


function autopot()
	if Config.autopot==false then return end	
	if (is_he_buffed(player, healbuff.flask) or is_he_buffed(player, healbuff.minipot) or is_he_buffed(player, healbuff.hppot)) then return end
	
	if os.clock() >= autopottick+1 then
		local hppot_slot = nil
		hppot_slot = GetInventorySlotItem(2003)
		if player.health <= (player.maxHealth*(Config.autopotslider/100)) and hppot_slot ~=nil then
			CastSpell(hppot_slot)
		end
		autopottick = os.clock()
	end
	
end


function _stay() --send S(stay) command, hero do not attack :)
	if os.clock() >= pstay_timer+0.05 then
		Packet("S_MOVE", {sourceNetworkId = myHero.networkID, type = 10, x = myHero.x, y = myHero.z}):send()	
		pstay_timer=os.clock()
	end	
end




function is_he_buffed(target, buffname)
	if target == nil then return false end

	for i = 1, target.buffCount do
		local tBuff = target:getBuff(i)
		if tBuff and tBuff.valid and tBuff.name == buffname then
			return true
		end
	end
	
end


function infotext_champion()
	if txtonme.line_one ~= nil then	DrawText(tostring(txtonme.line_one),25,(WINDOW_W*0.45),(WINDOW_H*0.55),ARGB(255,131,139,139)) end
	if txtonme.line_two ~= nil then	DrawText(tostring(txtonme.line_two),25,(WINDOW_W*0.45),(WINDOW_H*0.58),ARGB(255,131,139,139)) end
	if txtonme.line_three ~= nil then	DrawText(tostring(txtonme.line_three),25,(WINDOW_W*0.45),(WINDOW_H*0.61),ARGB(255,131,139,139)) end
end


function update_infotext_camps(new_camp)
	local tmp_info_cmp = {a="",b="",c="",d="",e="",f="",g="",h="",i="",j="",k="",l=""}
	tmp_info_cmp.a = info_camp.a
	tmp_info_cmp.b = info_camp.b
	tmp_info_cmp.c = info_camp.c
	tmp_info_cmp.d = info_camp.d
	tmp_info_cmp.e = info_camp.e
	tmp_info_cmp.f = info_camp.f
	tmp_info_cmp.g = info_camp.g
	tmp_info_cmp.h = info_camp.h
	tmp_info_cmp.i = info_camp.i
	tmp_info_cmp.j = info_camp.j
	tmp_info_cmp.k = info_camp.k
	tmp_info_cmp.l = info_camp.l

	info_camp.a = new_camp
	info_camp.b = tmp_info_cmp.a
	info_camp.c = tmp_info_cmp.b
	info_camp.d = tmp_info_cmp.c
	info_camp.e = tmp_info_cmp.d
	info_camp.f = tmp_info_cmp.e
	info_camp.g = tmp_info_cmp.f
	info_camp.h = tmp_info_cmp.g
	info_camp.i = tmp_info_cmp.h
	info_camp.j = tmp_info_cmp.i
	info_camp.k = tmp_info_cmp.j
	info_camp.l = tmp_info_cmp.k
	
end


function infotext_camps()
	DrawText(tostring("Camp Information"),15,100,110,ARGB(255,10,255,20))
    DrawText(tostring("Current Camp: "..info_camp.a),15,100,125,ARGB(255,248,255,20))		
	DrawText(tostring("Last Camp 1: "..info_camp.b),15,100,140,ARGB(255,248,255,20))
	DrawText(tostring("Last Camp 2: "..info_camp.c),15,100,155,ARGB(255,248,255,20))
	DrawText(tostring("Last Camp 3: "..info_camp.d),15,100,170,ARGB(255,248,255,20))
	DrawText(tostring("Last Camp 4: "..info_camp.e),15,100,185,ARGB(255,248,255,20))
	DrawText(tostring("Last Camp 5: "..info_camp.f),15,100,200,ARGB(255,248,255,20))
	DrawText(tostring("Last Camp 6: "..info_camp.h),15,100,215,ARGB(255,248,255,20))
	DrawText(tostring("Last Camp 7: "..info_camp.i),15,100,230,ARGB(255,248,255,20))
	DrawText(tostring("Last Camp 8: "..info_camp.j),15,100,245,ARGB(255,248,255,20))
	DrawText(tostring("Last Camp 9: "..info_camp.k),15,100,260,ARGB(255,248,255,20))
	DrawText(tostring("Last Camp 10: "..info_camp.l),15,100,275,ARGB(255,248,255,20))
end


function infotext_spells()
	DrawText(tostring("Spell Information"),15,100,360,ARGB(255,10,255,20))
	DrawText(tostring("Current spell: "..info_spells.a),15,100,375,ARGB(255,248,255,20))		
	DrawText(tostring("Last spell 1: "..info_spells.b),15,100,390,ARGB(255,248,255,20))
	DrawText(tostring("Last spell 2: "..info_spells.c),15,100,405,ARGB(255,248,255,20))
	DrawText(tostring("Last spell 3: "..info_spells.d),15,100,420,ARGB(255,248,255,20))
	DrawText(tostring("Last spell 4: "..info_spells.e),15,100,435,ARGB(255,248,255,20))
	DrawText(tostring("Last spell 5: "..info_spells.f),15,100,450,ARGB(255,248,255,20))
	DrawText(tostring("Last spell 6: "..info_spells.h),15,100,465,ARGB(255,248,255,20))
	DrawText(tostring("Last spell 7: "..info_spells.i),15,100,480,ARGB(255,248,255,20))
	DrawText(tostring("Last spell 8: "..info_spells.j),15,100,495,ARGB(255,248,255,20))
	DrawText(tostring("Last spell 9: "..info_spells.k),15,100,510,ARGB(255,248,255,20))
	DrawText(tostring("Last spell 10: "..info_spells.l),15,100,525,ARGB(255,248,255,20))
end


function update_infotext_spellss(spell, target)
	local tmp_info_spells = {a="",b="",c="",d="",e="",f="",g="",h="",i="",j="",k="",l=""}
	tmp_info_spells.a = info_spells.a
	tmp_info_spells.b = info_spells.b
	tmp_info_spells.c = info_spells.c
	tmp_info_spells.d = info_spells.d
	tmp_info_spells.e = info_spells.e
	tmp_info_spells.f = info_spells.f
	tmp_info_spells.g = info_spells.g
	tmp_info_spells.h = info_spells.h
	tmp_info_spells.i = info_spells.i
	tmp_info_spells.j = info_spells.j
	tmp_info_spells.k = info_spells.k
	tmp_info_spells.l = info_spells.l

	info_spells.a = spell.." on "..target.."@"..GetInGameTimer()
	info_spells.b = tmp_info_spells.a
	info_spells.c = tmp_info_spells.b
	info_spells.d = tmp_info_spells.c
	info_spells.e = tmp_info_spells.d
	info_spells.f = tmp_info_spells.e
	info_spells.g = tmp_info_spells.f
	info_spells.h = tmp_info_spells.g
	info_spells.i = tmp_info_spells.h
	info_spells.j = tmp_info_spells.i
	info_spells.k = tmp_info_spells.j
	info_spells.l = tmp_info_spells.k
	
end


function stay_base_until_hp_full()
	if player.health < player.maxHealth and GetDistance(player, allySpawn) <= 200 then
		player:MoveTo(allySpawn.x, allySpawn.z)
	end
end


function OnRecvPacket(p)
	if myHero.charName=="Nasus" then
		if p.header == 0xFE and p.size == 0xC then
			p.pos = 1
			pNetworkID = p:DecodeF()
			unk01 = p:Decode2()
			unk02 = p:Decode1()
			qstack = p:Decode4()
		end
	end
end


function calc_q_dmg(target)
	local my_dmg = player.addDamage + qstack
	--.addDamage
	--PrintChat = getDmg("Q", target, myHero)
		--return player:CalcDamage(target, my_dmg)
	return QDamage(target)*0.9
end

function QDamage(target)
        local ADDmg = getDmg("AD", target, myHero)
        local extra = (SheenSlot and ADDmg or 0) + (TrinitySlot and ADDmg*1.5 or 0) + (LichBaneSlot and getDmg("LICHBANE",target,myHero) or 0) + (IceBornSlot and ADDmg*1.25 or 0)
        return getDmg("Q", target, myHero) + myHero:CalcDamage(target,qstack) + extra
end

function calc_w_dmg()
	return getDmg("W", target, myHero)
end


function calc_e_dmg()
	return getDmg("E", target, myHero)
end


function calc_r_dmg()
	return getDmg("R", target, myHero)
end


function OnGainBuff(unit,buff)
    if unit.isMe then
        if buff.name == "NasusQ" then
			PrintChat("GOT Q buff: "..buff.name)
            HasQBuff = true						
        end
    end
end


function OnLoseBuff(unit,buff)
    if unit.isMe then
        if buff.name == "NasusQ" then
		PrintChat("LOST Q buff: "..buff.name)
            HasQBuff = false
        end
    end	
end


function _get_target()
	local target = nil
	for i = 1, objManager.maxObjects, 1 do		
		local object = objManager:getObject(i)
		if object~=nil and object.dead==false and object.type == "obj_AI_Minion" and object.name~=nil and GetDistance(player, object) <=400 then
			if object.name=="AncientGolem1.1.1" or object.name=="GiantWolf2.1.1" or object.name=="Wraith3.1.1" or object.name=="LizardElder4.1.1" or object.name=="Golem5.1.2" then
				target = object	
			end
		end
	end	
	
	if target==nil then
		for i = 1, objManager.maxObjects, 1 do
			local object = objManager:getObject(i)
			if object~=nil and object.type == "obj_AI_Minion" and object.name~=nil and GetDistance(player, object) <=400 then
				if object.name=="GreatWraith13.1.1" or object.name=="YoungLizard1.1.2" or object.name=="YoungLizard1.1.3" or object.name=="Wolf2.1.3" or object.name=="Wolf2.1.2" or object.name=="LesserWraith3.1.4" or object.name=="LesserWraith3.1.3" or object.name=="LesserWraith3.1.2" or object.name=="YoungLizard4.1.2" or object.name=="YoungLizard4.1.3" or object.name=="SmallGolem5.1.1" then
					target = object					
				end
			end
		end
	end
	
	if target==nil then
		return nil
	else		
		return target
	end
	
end


function _endofshopping()
	if GetInventorySlotIsEmpty(ITEM_1) == false and GetInventorySlotIsEmpty(ITEM_2) == false and GetInventorySlotIsEmpty(ITEM_3) == false and GetInventorySlotIsEmpty(ITEM_4) == false and GetInventorySlotIsEmpty(ITEM_5) == false and GetInventorySlotIsEmpty(ITEM_6) == false and GetInventorySlotIsEmpty(ITEM_7) == false then
		fullbuild = true
	else
		fullbuild = false
	end
end

























































































