if myHero.charName ~= "Karma" then return end
--[[       ----------------------------------------------------------------------------------------------       ]]--
--[[									KarmaConnection by Bilbao		    					   	 	        ]]--
--[[       ----------------------------------------------------------------------------------------------       ]]--

require "VPrediction"

	-------Skills info-------
	local projSpeed = 1.2
	local Qrange, Qwidth, Qspeed, Qdelay = 1000, 70, 1800, 0.25
	local Wrange = 650
	local Erange,Eaoe = 800, 400
	local blockR = false
	local blockE = false
	local QReady, WReady, EReady, RReady = false, false, false, false
	-------/Skills info-------
	
	
	-------Orbwalk info-------
	local lastAttack, lastWindUpTime, lastAttackCD = 0, 0, 0
	local myTrueRange = 0
	-------/Orbwalk info-------
	
	
	-------Global info-------
	local allyTable
	local ts, target, tmp_target
	local orber = nil
	local wayPointManager = WayPointManager()
	local recall_status = false
	local ch = {tick=0, spriteG=nil, spriteR=nil, trans=0, status=false }
	-------/Global info-------
	
	
	-------Autolvl info-------
	local abilitylvl = 0
	local lvlsequence = 1 
	-------/Autolvl info-------
	
	
	-------VPrediction-------
	local VP = nil
	-------/VPrediction-------	
	
	
	-------Auto update-------
	local CurVer = 1.1
	local NeedUpdate = false
	local updated = true	
	-------/Auto update-------
	

--[[       ----------------------------------------------------------------------------------------------       ]]--
--[[					OnLoad/OnTick/OnDraw/OnCreateObj/OnDeleteObj/OnProcessSpell								]]--
--[[       ----------------------------------------------------------------------------------------------       ]]--	
	
	
function OnLoad()
	VP = VPrediction()
	myTrueRange = trueRange()
	allyTable = GetAllyHeroes()
	_loadMenu()
	_loadTS()
	_loadcrosshair()
	_setimpdef()
	PrintChat("<font color='#03dafb'> >> KarmaConnection by Bilbao loaded. </font>")
end


function OnTick()
	if recall_status then return end
	_update()
	_gettarget()
	_caster()
	_autoskill()
	_crosshaircalc()
	_OrbWalk(tmp_target)
end


function OnDraw()
	_draw_tarinfo()
	_draw_ch()
	_draw_ranges()	
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


function OnProcessSpell(object, spell)
	if object == myHero then
		if spell.name:lower():find("attack") then
			lastAttack = GetTickCount() - GetLatency()/2
			lastWindUpTime = spell.windUpTime*1000
			lastAttackCD = spell.animationTime*1000
		end 
	end
end


--[[       ----------------------------------------------------------------------------------------------       ]]--
--[[												General Functions		   				 	                ]]--
--[[       ----------------------------------------------------------------------------------------------       ]]--


function _update()
	ts:update()
	_spellcheck()	
end


function _spellcheck()
    QReady = (myHero:CanUseSpell(_Q) == READY)
    WReady = (myHero:CanUseSpell(_W) == READY)
    EReady = (myHero:CanUseSpell(_E) == READY)
    RReady = (myHero:CanUseSpell(_R) == READY)
end


function _caster()
	if (Menu.keys.permrota or Menu.keys.okdrota) then
		_smartcore()
		_tscore(target)
	end
	if (Menu.keys.permhrs or Menu.keys.okdhrs) then	
	_harrass()
	end
end


function _harrass()
	if Menu.harrass.hrsQ then
		_smartRQ(false)
	end
	if Menu.harrass.hrsW then
		_smartRW(false)
	end
end


function _smartcore()
	if not Menu.ta.auto then return end
	local cle = _closestenemy(myHero)
	if myHero.health < (myHero.maxHealth*(Menu.extra.rwslider.rwslider/100)) then
		_smartRW(true)
	else
		_smartRW(false)
	end
	
	if Menu.extra.teamshild.ftsstat then
		_teamshild()
	end
	
	if cle~=nil and Menu.extra.ecfg.useE then			
		if RReady and EReady and myHero:GetDistance(cle) < 300 then			
			_smartRE(true)
		end
	end	
	_smartRQ(true)	
end


function _tscore(target)
	if not Menu.ta.ts then return end
	if target==nil or ValidTarget(target, Qrange) then return end
	if myHero.health < (myHero.maxHealth*(Menu.extra.rwslider.rwslider/100)) then
		_tsRW(true, target)
	else
		_tsRW(false, target)
	end
	
	if myHero:GetDistance(target) < Eaoe then
		_tsRE()
	end	
	_tsRQ(target)
end


function _smartRQ(bonus)
	if not Menu.rota.useRQ then return end
    for i, vptarget in pairs(GetEnemyHeroes()) do
        local CastPosition,  HitChance,  Position = VP:GetLineCastPosition(vptarget, Qdelay, Qwidth, Qrange, Qspeed, myHero, true)
		tmp_target = vptarget
        if HitChance >= 2 and GetDistance(CastPosition) < Qrange and ValidTarget(vptarget, Qrange) then				
			tmp_target = vptarget
			if bonus==true and not blockR then Packet('S_CAST', { spellId = _R, fromX = myHero.x, fromY = myHero.z}):send() end
			Packet('S_CAST', { spellId = _Q, fromX = CastPosition.x, fromY = CastPosition.z}):send()				
        end
	end
end
 
 
function _smartRW(bonus)
	if not Menu.rota.useRW then return end
	local loc_target = _getslowestenemy()
	if loc_target~=nil then				
		tmp_target = loc_target
		if bonus==true and not blockR then Packet('S_CAST', { spellId = _R, fromX = myHero.x, fromY = myHero.z}):send() end			
		CastSpell(_W, loc_target)				
		if not _lowestally(50, Erange-25) then CastSpell(_E, myHero) end
	end
end 


function _smartRE(bonus)
	if not Menu.rota.useRE then return end
	if bonus==true and not blockR then Packet('S_CAST', { spellId = _R, fromX = myHero.x, fromY = myHero.z}):send() end
	if not blockE then CastSpell(_E, myHero) end
end


function _tsRQ(target)
    local CastPosition,  HitChance,  Position = VP:GetLineCastPosition(target, Qdelay, Qwidth, Qrange, Qspeed, myHero, true)			
    if HitChance >= 2 and GetDistance(CastPosition) < Qrange and ValidTarget(target, Qrange) then			              
		if not blockR then Packet('S_CAST', { spellId = _R, fromX = myHero.x, fromY = myHero.z}):send() end
		Packet('S_CAST', { spellId = _Q, fromX = CastPosition.x, fromY = CastPosition.z}):send()				
    end		
end


function _tsRW(bonus, target)
	if target~=nil and ValidTarget(target, Wrange) then
		if bonus and not blockR then Packet('S_CAST', { spellId = _R, fromX = myHero.x, fromY = myHero.z}):send() end
		Packet('S_CAST', { spellId = _W, fromX = target.x, fromY = target.z}):send()
	end	
end


function _tsRE()
	if not blockR then Packet('S_CAST', { spellId = _R, fromX = myHero.x, fromY = myHero.z}):send() end
	Packet('S_CAST', { spellId = _E, fromX = myHero.x, fromY = myHero.z}):send()
end


function _autoskill()
	if not Menu.extra.alvl.alvlstatus then return end	
	if myHero.level > abilitylvl then
		abilitylvl = abilitylvl + 1
		if Menu.extra.alvl.lvlseq == 1 then			
			LevelSpell(_R)
			LevelSpell(_Q)
			LevelSpell(_W)
			LevelSpell(_E)
		end
		if Menu.extra.alvl.lvlseq == 2 then	
			LevelSpell(_R)
			LevelSpell(_Q)
			LevelSpell(_E)
			LevelSpell(_W)
		end
		if Menu.extra.alvl.lvlseq == 3 then	
			LevelSpell(_R)
			LevelSpell(_W)
			LevelSpell(_Q)
			LevelSpell(_E)
		end
		if Menu.extra.alvl.lvlseq == 4 then	
			LevelSpell(_R)
			LevelSpell(_W)
			LevelSpell(_E)
			LevelSpell(_Q)
		end
		if Menu.extra.alvl.lvlseq == 5 then	
			LevelSpell(_R)
			LevelSpell(_E)
			LevelSpell(_Q)
			LevelSpell(_W)
		end
		if Menu.extra.alvl.lvlseq == 6 then	
			LevelSpell(_R)
			LevelSpell(_E)
			LevelSpell(_W)
			LevelSpell(_Q)
		end
	end
end


function _OrbWalk()
	local letmeorb = false	
	if Menu.extra.orb == 1 then
		if (Menu.keys.permrota or Menu.keys.okdrota or Menu.keys.permhrs or Menu.keys.okdhrs) then
			letmeorb = true
		end
	end
	if Menu.extra.orb == 2 then
		letmeorb = true
	end
	if Menu.extra.orb == 3 then
		letmeorb = false
	end
	if not letmeorb then return end
	orber = _orbwalktarget()
	tmp_target = orber
	if orber~=nil and GetDistance(orber) <= myHero.range then		
		if timeToShoot() then
			myHero:Attack(orber)
		elseif heroCanMove()  then
			moveToCursor()
		end
	else		
		moveToCursor() 
	end
end


function _crosshaircalc()
	if GetTickCount() > ch.tick + 25 then
		if ch.trans == 255 then
			ch.status = false	
		end
		if ch.trans == 0 then
			ch.status = true
		end
		if ch.status then
			ch.trans = ch.trans + 51
		else
			ch.trans = ch.trans - 51
		end
		ch.tick = GetTickCount()
	end
end


function _draw_ranges()
	if Menu.draw.drawsub2.drawaa then
		DrawCircle(myHero.x, myHero.y, myHero.z, myTrueRange-5, ARGB(25 , 125, 125, 125))
	end
	if Menu.draw.drawsub2.drawQ and QReady then
		DrawCircle(myHero.x, myHero.y, myHero.z, Qrange, ARGB(100, 0, 0, 250))
	end
	if Menu.draw.drawsub2.drawW and WReady then
		DrawCircle(myHero.x, myHero.y, myHero.z, Wrange, ARGB(100, 250, 0, 250))
	end
	if Menu.draw.drawsub2.drawE and EReady then
		DrawCircle(myHero.x, myHero.y, myHero.z, Erange, ARGB(100, 0, 250, 0))
	end
end


function _draw_tarinfo()
	if tmp_target~=nil and ValidTarget(tmp_target, 1100) then	
		if Menu.draw.tarvisu.drawltar then		
			DrawLine3D(myHero.x, myHero.y, myHero.z, tmp_target.x, tmp_target.y, tmp_target.z, 1, ARGB(250,235,33,33))
		end	
		if Menu.draw.tarvisu.drawcltar then
			DrawCircle(tmp_target.x, tmp_target.y, tmp_target.z, 100, ARGB(250, 253, 33, 33))
		end
		if Menu.draw.drawsub.drawwp then
			wayPointManager:DrawWayPoints(tmp_target)
		end
		if Menu.draw.drawsub.drawwpr then
			DrawText3D(tostring(wayPointManager:GetWayPointChangeRate(tmp_target)), tmp_target.x, tmp_target.y, tmp_target.z, 30, ARGB(250,5,250,5), true)
		end
	end
end


function _draw_ch()
	if ch.spriteG and tmp_target~= nil then
		ch.spriteG:SetScale(0.4, 0.4)		
		local chPos =  WorldToScreen(D3DXVECTOR3(tmp_target.x, tmp_target.y, tmp_target.z))	   
		ch.spriteG:Draw(chPos.x-30, chPos.y-105, ch.trans)		
	end
end


--[[       ----------------------------------------------------------------------------------------------       ]]--
--[[					     	 		     	     Utility			   	      								]]--
--[[       ----------------------------------------------------------------------------------------------       ]]--


function _getslowestenemy()
	local ms, senemy = 2000, nil
	for i, currenemy in pairs(GetEnemyHeroes()) do		
        if GetDistance(currenemy) < Wrange and currenemy.dead==false and currenemy.ms < ms then				
			senemy = currenemy
			ms = currenemy.ms				
        end
	end
return senemy
end


function _closestenemy(object)
    local distance = 20000
    local closest = nil
    for i=1, heroManager.iCount do
        currentEnemy = heroManager:GetHero(i)
        if currentEnemy~=nil and ValidTarget(currentEnemy, 5000) and currentEnemy.team ~= myHero.team and not currentEnemy.dead and object:GetDistance(currentEnemy) < distance then
            distance = object:GetDistance(currentEnemy)
			closest = currentEnemy
        end
    end
    return closest
end


function _lowestally(percent, range)
    local low_health = {tar=nil, health=100}	
    for i=1, heroManager.iCount do
        currentAlly = heroManager:GetHero(i)
        if currentAlly.team == myHero.team and currentAlly.charName ~= myHero.charName and currentAlly~=nil then
            if not currentAlly.dead and myHero:GetDistance(currentAlly) < range then			
				local currAllyhpperc = currentAlly.maxHealth*(percent/ 100)
				if currAllyhpperc < low_health.health then
					low_health.health = currAllyhpperc
					low_health.tar = currentAlly
				end
            end
        end
    end
	if low_health.tar ~= nil then return true end
end


function _teamshild()
	local enemycount = _countenemys(myHero, Menu.extra.teamshild.ftsenemyrange)
	local allycount = _countallys(myHero, Erange)
	if enemycount >= Menu.extra.teamshild.ftsenemy and allycount >= Menu.extra.teamshild.ftsally then
		blockR = true
		blockE = true		
		if RReady and EReady then	
		PrintChat("in teamshild")
			local besttar = _getEtar()
			if besttar ~=nil then
			PrintChat("in teamshild22222")
				Packet('S_CAST', { spellId = _R, fromX = myHero.x, fromY = myHero.z}):send()
				CastSpell(_E, besttar)
			end
		end
	else
		blockR = false
		blockE = false
	end
end

function _countenemys(from, range)
	local enemysinrange = 0
    for i=1, heroManager.iCount do
        currEnemy = heroManager:GetHero(i)
        if currEnemy.team ~= myHero.team then
            if from:GetDistance(currEnemy) <= range and not currEnemy.dead and ValidTarget(currEnemy, range) then
				enemysinrange = enemysinrange + 1
			end
        end
    end
    return enemysinrange
end


function _countallys(from, range)
	local allysinrange = 0
    for i=1, heroManager.iCount do
        currAlly = heroManager:GetHero(i)
        if currAlly.team == myHero.team then
            if from:GetDistance(currAlly) <= range and not currAlly.dead then
				allysinrange = allysinrange + 1
			end
        end
    end
    return allysinrange
end


function _getEtar()
	local bestEtarR = nil
	local allycountT = 0
    for i=1, #allyTable do
        local currAlly = allyTable[i]		
        if currAlly.team == myHero.team then		
			local currAllyAllys =  _countallys(currAlly, 400)
			PrintChat("allyinrange to etar: "..currAllyAllys)
            if myHero:GetDistance(currAlly) <= 800 and currAllyAllys >= allycountT then
			 PrintChat("bestddddddddddddddetarreturn: "..currAlly.name) 
				bestEtarR = currAlly
				allycountT = currAllyAllys
			end
        end
    end
	if bestEtar~=nil then PrintChat("bestetarreturn: "..bestEtarR.name) end
    return bestEtarR
end

	
function trueRange()
	return myHero.range + GetDistance(myHero.minBBox)
end
 
 
function heroCanMove()
	return (GetTickCount() + GetLatency()/2 > lastAttack + lastWindUpTime + 20)
end
 
 
function timeToShoot()
	return (GetTickCount() + GetLatency()/2 > lastAttack + lastAttackCD)
end
 
 
function moveToCursor()
	if GetDistance(mousePos) > 1 or lastAnimation == "Idle1" then
		local moveToPos = myHero + (Vector(mousePos) - myHero):normalized()*300
		myHero:MoveTo(moveToPos.x, moveToPos.z)
	end 
end


function _orbwalktarget()
    local _orbtar = {tar=nil, hp=20000}	
    for i=1, heroManager.iCount do
        currentEnemy = heroManager:GetHero(i)
        if currentEnemy.team ~= myHero.team and currentEnemy.charName ~= myHero.charName and currentEnemy.visible and currentEnemy.bTargetable and currentEnemy~=nil then
            if not currentEnemy.dead and myHero:GetDistance(currentEnemy) < myTrueRange-5 and currentEnemy.health < _orbtar.hp then				
				_orbtar.hp = currentEnemy.health
				_orbtar.tar = currentEnemy			
            end
        end
    end
	return _orbtar.tar
end


function _gettarget()
	if Menu.ta.ts==false and Menu.ta.auto==false then Menu.ta.auto=true end
	if Menu.ta.ts then
		if ts.target ~= nil then 
			target = ts.target 
		end
	end	
end


--[[       ----------------------------------------------------------------------------------------------       ]]--
--[[					     	 		     	    Once			   	      								]]--
--[[       ----------------------------------------------------------------------------------------------       ]]--


function _loadcrosshair()
	ch.tick = GetTickCount()
	ch.spriteG = GetWebSprite("http://s1.directupload.net/images/140304/id9pi3v6.png")
	ch.spriteR = GetWebSprite("http://s7.directupload.net/images/140305/azzjex7b.png")
end


function _loadMenu()
	Menu = scriptConfig("KarmaConnection", "Enlightened")
	
	
		-----------------------------------------------------------------------------------------------------
		Menu:addSubMenu("Drawing", "draw")
			Menu.draw:addSubMenu("WayPointManager","drawsub")
				Menu.draw.drawsub:addParam("drawwp", "Draw waypoints", SCRIPT_PARAM_ONOFF, true)
				Menu.draw.drawsub:addParam("drawwpr", "Draw waypoint rate", SCRIPT_PARAM_ONOFF, false)
		-----------------------------------------------------------------------------------------------------
			Menu.draw:addSubMenu("Target visualisation", "tarvisu")
				Menu.draw.tarvisu:addParam("drawltar", "Draw line to target", SCRIPT_PARAM_ONOFF, false)
				Menu.draw.tarvisu:addParam("drawcltar", "Draw circle around target", SCRIPT_PARAM_ONOFF, true)
		-----------------------------------------------------------------------------------------------------
			Menu.draw:addSubMenu("Ranges", "drawsub2")
				Menu.draw.drawsub2:addParam("drawaa", "Draw AARange", SCRIPT_PARAM_ONOFF, true)
				Menu.draw.drawsub2:addParam("drawQ", "Draw QRange", SCRIPT_PARAM_ONOFF, true)
				Menu.draw.drawsub2:addParam("drawW", "Draw WRange", SCRIPT_PARAM_ONOFF, true)
				Menu.draw.drawsub2:addParam("drawE", "Draw ERange", SCRIPT_PARAM_ONOFF, true)
		-----------------------------------------------------------------------------------------------------
		
		
		-----------------------------------------------------------------------------------------------------
		Menu:addSubMenu("Harrass", "harrass")
			Menu.harrass:addParam("hrsQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
			Menu.harrass:addParam("hrsW", "Use W", SCRIPT_PARAM_ONOFF, false)
		-----------------------------------------------------------------------------------------------------
		
		
		-----------------------------------------------------------------------------------------------------
		Menu:addSubMenu("Rotation", "rota")
			Menu.rota:addParam("useRQ", "Use RQ Combo", SCRIPT_PARAM_ONOFF, true)
			Menu.rota:addParam("useRW", "Use RW Combo", SCRIPT_PARAM_ONOFF, true)
			Menu.rota:addParam("useRE", "Use RE Combo", SCRIPT_PARAM_ONOFF, true)
		-----------------------------------------------------------------------------------------------------
		
		
		-----------------------------------------------------------------------------------------------------
		Menu:addSubMenu("Hotkeys", "keys")		
			Menu.keys:addParam("permrota", "Auto Rotation", SCRIPT_PARAM_ONKEYTOGGLE, true, string.byte("S"))
			Menu.keys:permaShow("permrota")
			Menu.keys:addParam("okdrota", "OnKeyDown Rotation", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("A"))
			Menu.keys:permaShow("okdrota")		
			Menu.keys:addParam("permhrs", "Auto Harrass", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte("Z"))
			Menu.keys:permaShow("permhrs")
			Menu.keys:addParam("okdhrs", "OnKeyDown Harrass", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("T"))
			Menu.keys:permaShow("okdhrs")
		-----------------------------------------------------------------------------------------------------
		
		
		-----------------------------------------------------------------------------------------------------
		Menu:addSubMenu("Target acquisition", "ta")	
			Menu.ta:addParam("ts", "Target from ts", SCRIPT_PARAM_ONOFF, false)
			Menu.ta:addParam("auto", "Smart aming", SCRIPT_PARAM_ONOFF, true)
		-----------------------------------------------------------------------------------------------------
		
		
		-----------------------------------------------------------------------------------------------------
		Menu:addSubMenu("Target tracking", "tartrack")
			Menu.tartrack:addParam("single", "Single target mark", SCRIPT_PARAM_ONOFF, true)
			--Menu.tartrack:addParam("multi", "Multi target mark", SCRIPT_PARAM_ONOFF, false)
		-----------------------------------------------------------------------------------------------------
		
		
		-----------------------------------------------------------------------------------------------------
		Menu:addSubMenu("Extra", "extra")
			Menu.extra:addParam("orb", "Orbwalk", SCRIPT_PARAM_LIST, 1, { "COMBO", "ALWAYS", "NEVER" })
			Menu.extra:addSubMenu("Auto level", "alvl")
				Menu.extra.alvl:addParam("alvlstatus", "Auto lvl skills", SCRIPT_PARAM_ONOFF, false)
				Menu.extra.alvl:addParam("lvlseq", "Choose your lvl Sequence", SCRIPT_PARAM_LIST, 1, { "R>Q>W>E", "R>Q>E>W", "R>W>Q>E", "R>W>E>Q", "R>E>Q>W", "R>E>W>Q" })
			Menu.extra:addSubMenu("Force Teamshild", "teamshild")				
				Menu.extra.teamshild:addParam("ftsstat", "Force Teamshild", SCRIPT_PARAM_ONOFF, false)
				Menu.extra.teamshild:addParam("ftsally", "Min. Ally in Range",  SCRIPT_PARAM_SLICE, 2, 0, 4, 0)
				Menu.extra.teamshild:addParam("ftsenemy", "Min. Enemy in Range",  SCRIPT_PARAM_SLICE, 2, 0, 5, 0)
				Menu.extra.teamshild:addParam("ftsenemyrange", "Max Range for enemys",  SCRIPT_PARAM_SLICE, 1000, 0, 2500, 0)
			Menu.extra:addSubMenu("RW-Config", "rwslider")
				Menu.extra.rwslider:addParam("rwslider", "myHeroHP < %",  SCRIPT_PARAM_SLICE, 75, 0, 100, 0)
			Menu.extra:addSubMenu("E Config", "ecfg")
				Menu.extra.ecfg:addParam("useE", "Use E", SCRIPT_PARAM_ONOFF, false)
		-----------------------------------------------------------------------------------------------------
end


function _loadTS()
	ts = TargetSelector(TARGET_LOW_HP_PRIORITY,1000)
	ts.name = "Karma"
	Menu:addTS(ts)
end


function _setimpdef()
Menu.extra.alvl.alvlstatus = false
Menu.keys.permrota = false
Menu.keys.okdrota = false
Menu.keys.permhrs = false
Menu.keys.okdhrs = false
end
