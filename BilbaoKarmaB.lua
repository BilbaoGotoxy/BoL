if myHero.charName ~= "Karma" then return end

--[[       ----------------------------------------------------------------------------------------------       ]]--
--[[									BilbaoKarma by Bilbao		    						   	 	        ]]--
--[[       ----------------------------------------------------------------------------------------------       ]]--

--[[04.06.2014 - Enabled VPred for FreeUser]]--

_G.prodic = false
_G.prodicfile = false           
_G.vpredicfile = false      
_G.vpredic = false           
_G.freevippredic = false
_G.freevippredicfile = false           
_G.freepredic = false
_G.freepredicfile = true          
     
if VIP_USER and FileExist(SCRIPT_PATH..'Common/Prodiction.lua') then
	require "Prodiction" 
	require "Collision"
	prodicfile = true
	prodic = true
	freevippredicfile = true
end
				
			
if FileExist(SCRIPT_PATH..'Common/VPrediction.lua') then --vprediction
	require "VPrediction"
	vpredic = true
	vpredicfile = true
end 


freepredicfile = true --freeprediction         
              
			

	-------Skills info-------
	local projSpeed = 1.2
	local Qrange, Qwidth, Qspeed, Qdelay = 1000, 70, 1800, 0.25
	local Wrange = 650
	local Erange,Eaoe = 800, 400
	local blockR = false
	local blockE = false
	local QReady, WReady, EReady, RReady = false, false, false, false
	local IGNReady, IGNSlot = false, nil
	-------/Skills info-------
	
	
	-------Vprediction info-------
	local VP = nil
	local vpredhitQ = 0
	------/Vprediction info-------
	
	
	-------Orbwalk & Farm info-------
	local lastAttack, lastWindUpTime, lastAttackCD = 0, 0, 0
	local myTrueRange = 0
	local orb_SELF, orb_MMA, orb_SAC = false, false, false
	-------/Orbwalk & Farm info-------
	
	
	-------MMA & SAC info-------
	local starttick = 0
	local checkedMMASAC = false
	local is_MMA = false
	local is_REVAMP = false
	local is_REBORN = false
	local is_SAC = false
	-------/MMA & SAC info-------
	
	
	-------Target info-------
	local ts = nil
	local Target, currTargetPos = nil, nil
	local predQPos, predRQPos, predSTPos, preenemy = nil, nil, nil	
	-------/Target info-------
	
	
	-------Autolvl info-------
	local abilitylvl = 0
	local lvlsequence = 1 
	-------/Autolvl info-------
	
	
	-------Auto update-------
	local CurVer = 0.3
	local CurName = "BilbaoKarma"
	local NeedUpdate = false
	local updated = true	
	-------/Auto update-------
	
	
	
--[[       ----------------------------------------------------------------------------------------------       ]]--
--[[													Callbacks												]]--
--[[       ----------------------------------------------------------------------------------------------       ]]--	


function OnLoad()	
	starttick = GetTickCount()
	_loadP()
	_load_menu()
	_initiateTS()
	PrintChat("<font color='#40FF00'> >> "..CurName.." v."..CurVer.."B - loaded</font>")	
end


function OnTick()
	_check_mmasac()
	if not myHero.dead then
		_update()
		_OrbWalk()
		_smartcore()
	end
end


function OnDraw()
	_draw_ranges()
	_draw_tarinfo()
	_drawpreddmg()
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
--[[					     	 		    	    Core Functions		 	  	   								]]--
--[[       ----------------------------------------------------------------------------------------------       ]]--


function _smartcore()
			predQPos = nil
			preenemy = nil
	if Menu.ta.co == 1 then
		if ValidTarget(Target) then				
			local Position = FreePredictionQ:GetPrediction(Target)
			if Position ~= nil then				
				preenemy = Target
				predQPos = Position			
			end
		else			
			for i, enemy in ipairs(GetEnemyHeroes()) do
				local Position = FreePredictionQ:GetPrediction(enemy)
				if Position ~= nil then					
					preenemy = enemy
					predQPos = Position				
				end		
			end			
		end		
	end
	if Menu.ta.co == 2 and VIP_USER then	
		if ValidTarget(Target) then					
			local Position = VipPredictionQ:GetPrediction(Target)
			if Position ~= nil then
				preenemy = Target
				predQPos = Position			
			end
		else
			for i, enemy in ipairs(GetEnemyHeroes()) do
				local Position = VipPredictionQ:GetPrediction(enemy)
				if Position ~= nil then
					preenemy = enemy
					predQPos = Position				
				end		
			end			
		end
	end
	if Menu.ta.co == 3 and vpredicfile then		
		if ValidTarget(Target) then 			
			local CastPosition,  HitChance,  Position = VP:GetLineCastPosition(Target, Qdelay, Qwidth, Qrange, Qspeed, myHero, true)
			if Position ~= nil then
				preenemy = Target
				predQPos = CastPosition
				vpredhitQ = HitChance
			else
				predQPos = nil
				preenemy = nil
			end
		else
			for i, enemy in ipairs(GetEnemyHeroes()) do
				local CastPosition,  HitChance,  Position = VP:GetLineCastPosition(enemy, Qdelay, Qwidth, Qrange, Qspeed, myHero, true)
				if Position ~= nil then
					preenemy = enemy
					predQPos = CastPosition
					vpredhitQ = HitChance
				else
					predQPos = nil
					preenemy = nil
				end		
			end			
		end	
	end	
	if Menu.ta.co == 4 and prodicfile then 		
		if ValidTarget(Target) then 			
			predQPos = ProdictionQ:GetPrediction(Target)
			preenemy = Target
		else
			predQPos = nil
			preenemy = nil
		end	
		if predQPos == nil and preenemy == nil then
			for i, enemy in ipairs(GetEnemyHeroes()) do
				if ValidTarget(enemy, Qrange) then
					predQPos = ProdictionQ:GetPrediction(enemy)
					if predQPos~=nil then
						preenemy = enemy
					end
				end	
			end
		end			
	end	
	if QReady and RReady and ValidTarget(preenemy) then	
		if (Menu.keys.permrota or Menu.keys.okdrota or Menu.keys.permhrs or Menu.keys.okdhrs ) and predQPos~=nil then		
		local cancastCOMBO = false
		if Menu.ta.co == 3 then
			if vpredhitQ >= 2 then
				cancastCOMBO = true
			else
				cancastCOMBO = false
			end
		else
			cancastCOMBO = true
		end		
		if Menu.ta.co == 4 then
			local coll = Collision(Qrange, Qspeed, Qdelay, Qwidth)
			if predQPos~=nil and not coll:GetMinionCollision(predQPos, myHero) then
				cancastCOMBO = true
			else
				cancastCOMBO = false		
			end
		end		
			if Menu.rota.userq == 3 then
				if Menu.extra.ex.packetcast == 2 and TSPELL~=_R and cancastCOMBO then	
					CastSpell(_R)
				end
				if (Menu.extra.ex.packetcast == 1 or Menu.extra.ex.packetcast == 3) and cancastCOMBO and VIP_USER then
					Packet('S_CAST', { spellId = _R, fromX = myHero.x, fromY = myHero.z}):send()
				end				
			end
			if (Menu.rota.userq == 2 or Menu.rota.userq == 3) and cancastCOMBO then
				_castSpell(_Q, predQPos.x, predQPos.z, nil)	
			end			
		end		
	end		
	if QReady and ValidTarget(preenemy) then	
		local cancastCOMBO = false
		if Menu.ta.co == 3 then
			if vpredhitQ >= 2 then
				cancastCOMBO = true
			else
				cancastCOMBO = false
			end
		else
			cancastCOMBO = true
		end
		if Menu.ta.co == 4 then
			local coll = Collision(Qrange, Qspeed, Qdelay, Qwidth)
			if predQPos~=nil and not coll:GetMinionCollision(predQPos, myHero) then
				cancastCOMBO = true
			else
				cancastCOMBO = false		
			end
		end
		if (Menu.keys.permrota or Menu.keys.okdrota or Menu.keys.permhrs or Menu.keys.okdhrs or Menu.harrass.autohrsQ) and cancastCOMBO and predQPos~=nil then				
			_castSpell(_Q, predQPos.x, predQPos.z, nil)
		end
	end	
	local cle = nil 
	if (EReady or WReady) then
		cle = _closestenemy(myHero)	
	end
 	if myHero.health < (myHero.maxHealth * (Menu.extra.rwslider.rwslider / 100)) and RReady and WReady then
		if ValidTarget(Target, Wrange) then
			if (Menu.keys.permrota or Menu.keys.okdrota or Menu.keys.permhrs or Menu.keys.okdhrs) then
				if Menu.rota.userw == 3 then
				if Menu.extra.ex.packetcast == 2 and TSPELL~=_R then	
					CastSpell(_R)
				end
				if (Menu.extra.ex.packetcast == 1 or Menu.extra.ex.packetcast == 3) and VIP_USER then
					Packet('S_CAST', { spellId = _R, fromX = myHero.x, fromY = myHero.z}):send()
				end	
				end
				if (Menu.rota.userw == 2 or Menu.rota.userw == 3) then _castSpell(_W, nil, nil, Target) end	
			end
		else
			if cle ~= nil and ValidTarget(cle, Wrange) then
				if (Menu.rota.userw == 2 or Menu.rota.userw == 3) then
					if (Menu.keys.permrota or Menu.keys.okdrota or Menu.keys.permhrs or Menu.keys.okdhrs) then
						_castSpell(_W, nil, nil, cle)
						cle = nil
					end
				end	
			end
		end	
	else
		if ValidTarget(Target, Wrange) then			
			if (Menu.rota.userw == 2 or Menu.rota.userw == 3) then
				if (Menu.keys.permrota or Menu.keys.okdrota or Menu.keys.permhrs or Menu.keys.okdhrs) then
					_castSpell(_W, nil, nil, Target)  
				end
			end
		else
			if ValidTarget(cle, Wrange) then
				if (Menu.rota.userw == 2 or Menu.rota.userw == 3) then
					if (Menu.keys.permrota or Menu.keys.okdrota or Menu.keys.permhrs or Menu.keys.okdhrs) then
						_castSpell(_W, nil, nil, cle) 
						cle = nil
					end
				end
			end
		end
	end
 	if cle~=nil and ValidTarget(cle) and GetDistance(cle) <= Menu.rota.enemyErange and EReady then			
		if (Menu.keys.permrota or Menu.keys.okdrota or Menu.keys.permhrs or Menu.keys.okdhrs) then
			if Menu.rota.usere == 3 then
				if Menu.extra.ex.packetcast == 2 and TSPELL~=_R then	
					CastSpell(_R)
				end
				if (Menu.extra.ex.packetcast == 1 or Menu.extra.ex.packetcast == 3) and VIP_USER then
					Packet('S_CAST', { spellId = _R, fromX = myHero.x, fromY = myHero.z}):send()
				end	
			end
			if (Menu.rota.usere == 2 or Menu.rota.usere == 3) and VIP_USER then Packet('S_CAST', { spellId = _E, fromX = myHero.x, fromY = myHero.z, targetNetworkId = myHero.networkID}):send() end	
		end
	end 
end




--[[       ----------------------------------------------------------------------------------------------       ]]--
--[[					     	 		    	    General				 	  	   								]]--
--[[       ----------------------------------------------------------------------------------------------       ]]--


function _OrbWalk()
	if not (Menu.ta.orb == 1 or Menu.ta.orb == 2) then return end
	if Menu.ta.orb == 1 then
		if not (Menu.keys.permrota or Menu.keys.okdrota or Menu.keys.permhrs or Menu.keys.okdhrs) then return end
	end
		if Target ~=nil and GetDistance(Target) <= myTrueRange then		
			if timeToShoot() then
				myHero:Attack(Target)
			elseif heroCanMove()  then
				moveToCursor()
			end
		else		
			moveToCursor() 
		end
end


function _update()
	ts:update()
	QReady = (myHero:CanUseSpell(_Q) == READY)
    WReady = (myHero:CanUseSpell(_W) == READY)
    EReady = (myHero:CanUseSpell(_E) == READY)
    RReady = (myHero:CanUseSpell(_R) == READY)
	myTrueRange = myHero.range + (GetDistance(myHero.minBBox) - 5)
	Target = _getTarget()
	_autoskill()
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




--[[       ----------------------------------------------------------------------------------------------       ]]--
--[[					     	 		    	    Utility				 	  	   								]]--
--[[       ----------------------------------------------------------------------------------------------       ]]--


function _getTarget()
	if not checkedMMASAC then return end
	if is_MMA and is_SAC then
		if Menu.ta.mma.mmastatus then
			Menu.ta.sac.sacstatus = false
			Menu.ta.basic.basicstatus = false
		elseif Menu.ta.sac.sacstatus then
			Menu.ta.mma.mmastatus = false
			Menu.ta.basic.basicstatus = false
		elseif	Menu.ta.basic.basicstatus then
			Menu.ta.mma.mmastatus = false
			Menu.ta.sac.sacstatus = false
		end
	end	
	if not is_MMA and is_SAC then
		if Menu.ta.sac.sacstatus then
			Menu.ta.basic.basicstatus = false
		else
			Menu.ta.basic.basicstatus = true
		end	
	end
	if is_MMA and not is_SAC then
		if Menu.ta.mma.mmastatus then
			Menu.ta.basic.basicstatus = false
		else
			Menu.ta.basic.basicstatus = true
		end	
	end
	if not is_MMA and not is_SAC then
		Menu.ta.basic.basicstatus = true	
	end	
	if _G.MMA_Target and _G.MMA_Target.type == myHero.type then
		return _G.MMA_Target 
	end
    if _G.AutoCarry and _G.AutoCarry.Crosshair and _G.AutoCarry.Attack_Crosshair and _G.AutoCarry.Attack_Crosshair.target and _G.AutoCarry.Attack_Crosshair.target.type == myHero.type then
		return _G.AutoCarry.Attack_Crosshair.target		
	end
    return ts.target	
end


function heroCanMove()
	return (GetTickCount() + GetLatency()/2 > lastAttack + lastWindUpTime + 20)
end 
 
 
function timeToShoot()
	return (GetTickCount() + GetLatency()/2 > lastAttack + lastAttackCD)
end 
 
 
function moveToCursor()
	if GetDistance(mousePos) > 1 or lastAnimation == "Idle1" then
		local moveToPos = myHero + (Vector(mousePos) - myHero):normalized() * 500
		if Menu.extra.packetmove and VIP_USER then
			Packet('S_MOVE', { type = 2, x = moveToPos.x, y = moveToPos.z }):send()
		else			
			myHero:MoveTo(moveToPos.x, moveToPos.z)
		end
	end 
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


function _draw_ranges()
	if Menu.draw.drawsub2.drawaa then
		DrawCircle(myHero.x, myHero.y, myHero.z, 525, ARGB(25 , 125, 125, 125))
	end
	if Menu.draw.drawsub2.drawQ and QReady then
		if Menu.extra.ex.incRQ then
			DrawCircle(myHero.x, myHero.y, myHero.z, Qrange+120, ARGB(100, 0, 0, 250))
		else
			DrawCircle(myHero.x, myHero.y, myHero.z, Qrange, ARGB(100, 0, 0, 250))
		end
	end
	if Menu.draw.drawsub2.drawW and WReady then
		DrawCircle(myHero.x, myHero.y, myHero.z, Wrange, ARGB(100, 250, 0, 250))
	end
	if Menu.draw.drawsub2.drawE and EReady then
		DrawCircle(myHero.x, myHero.y, myHero.z, Erange, ARGB(100, 0, 250, 0))
	end
end


function _draw_tarinfo()
	if preenemy~=nil and ValidTarget(preenemy, 2000) then	
		if Menu.draw.prdraw.enemyline then		
			DrawLine3D(myHero.x, myHero.y, myHero.z, preenemy.x,preenemy.y, preenemy.z, 1, ARGB(250,235,33,33))
		end	
		if Menu.draw.prdraw.enemy then
			DrawCircle(preenemy.x, preenemy.y, preenemy.z, 100, ARGB(250, 253, 33, 33))
		end
	end
		if Menu.draw.prdraw.preQ and predQPos~=nil and ValidTarget(preenemy)  then
			DrawCircle(predQPos.x, predQPos.y, predQPos.z, 70, ARGB(100, 0, 0, 250))
			DrawCircle(predQPos.x, predQPos.y, predQPos.z, 73, ARGB(100, 0, 0, 250))
			DrawCircle(predQPos.x, predQPos.y, predQPos.z, 75, ARGB(100, 0, 0, 250))
		end
		if Menu.draw.prdraw.preQR and predQPos~=nil and ValidTarget(preenemy) then
			DrawCircle(predQPos.x, predQPos.y, predQPos.z, 245, ARGB(100, 0, 0, 250))
			DrawCircle(predQPos.x, predQPos.y, predQPos.z, 248, ARGB(100, 0, 0, 250))
			DrawCircle(predQPos.x, predQPos.y, predQPos.z, 250, ARGB(100, 0, 0, 250))
		end
		if Menu.draw.prdraw.preMOVE and predQPos~=nil and ValidTarget(preenemy) then
			DrawLine3D(predQPos.x, predQPos.y, predQPos.z, preenemy.x,preenemy.y, preenemy.z, 15, ARGB(100, 0, 0, 250))			
		end	
end


function _drawpreddmg()
	if not Menu.draw.prdraw.predmg then return end	
	local currLine = 1
	for i, enemy in ipairs(GetEnemyHeroes()) do		
		if enemy~=nil and not enemy.dead and enemy.visible and ValidTarget(enemy) then		
				if QReady then
					DrawLineHPBar(dmgQ(enemy), currLine, "Q: "..dmgQ(enemy), enemy)
					currLine = currLine + 1
				end
				if QReady and RReady then
						DrawLineHPBar(dmgRQRISK(enemy), currLine, "RQ: "..dmgRQRISK(enemy), enemy)
						currLine = currLine + 1					
				end
				if WReady and not RReady then
					DrawLineHPBar(dmgW(enemy), currLine, "W: "..dmgW(enemy), enemy)
					currLine = currLine + 1
				end
				if WReady and RReady and not QReady then					
					DrawLineHPBar(dmgRW(enemy), currLine, "RW: "..dmgRW(enemy), enemy)
					currLine = currLine + 1				
				end
				if WReady and RReady and not QReady and igniteReady then					
					DrawLineHPBar(dmgRW(enemy)+dmgIGN(enemy), currLine, "RW+IGN: "..dmgRW(enemy)+dmgIGN(enemy), enemy)
					currLine = currLine + 1				
				end
				
				if WReady and QReady and RReady  then
					DrawLineHPBar((dmgRQSAVE(enemy)+dmgW(enemy)), currLine, "RQ+W: "..(dmgRQSAVE(enemy)+dmgW(enemy)), enemy)
					currLine = currLine + 1				
				
				end
				if WReady and QReady and RReady and igniteReady then 				
					DrawLineHPBar((dmgRQSAVE(enemy)+dmgW(enemy)+dmgIGN(enemy)), currLine, "RQ+W+IGN: "..(dmgRQSAVE(enemy)+dmgW(enemy)+dmgIGN(enemy)), enemy)
					currLine = currLine + 1								
				end	
			end
		end		
end


function dmgQ(target)
    local myQDmg = getDmg("Q", target, myHero, 1)
    return math.round(myQDmg)
end


function dmgRQSAVE(target)
    local myRQDmg = getDmg("Q", target, myHero, 1)
	local myRQDmgD = getDmg("Q", target, myHero, 2)
    return math.round(myRQDmg+myRQDmgD)
end


function dmgRQRISK(target)
    local myRQDmg = getDmg("Q", target, myHero, 1)
	local myRQDmgD = getDmg("Q", target, myHero, 2)
	local myRQDmgDE = getDmg("Q", target, myHero, 3)
    return math.round(myRQDmg+myRQDmgD+myRQDmgDE)
end


function dmgW(target)
    local myWDmg = getDmg("W", target, myHero)
    return math.round(myWDmg)
end


function dmgRW(target)
	local myRWDmgE = getDmg("W", target, myHero, 1)
    local myRWDmg = getDmg("W", target, myHero, 2)
    return math.round(myRWDmg+myRWDmgE)
end


function dmgAA(target)
	local ADDmg = getDmg("AD", target, myHero)
	return math.round(ADDmg)
end


function dmgIGN(target)
	local IGNDmg = getDmg("IGNITE", target, myHero)
	return math.round(IGNDmg)
end


function GetHPBarPos(enemy)
	enemy.barData = {PercentageOffset = {x = -0.05, y = 0}}
	local barPos = GetUnitHPBarPos(enemy)
	local barPosOffset = GetUnitHPBarOffset(enemy)
	local barOffset = { x = enemy.barData.PercentageOffset.x, y = enemy.barData.PercentageOffset.y }
	local barPosPercentageOffset = { x = enemy.barData.PercentageOffset.x, y = enemy.barData.PercentageOffset.y }
	local BarPosOffsetX = -50
	local BarPosOffsetY = 46
	local CorrectionY = 39
	local StartHpPos = 31
	barPos.x = math.floor(barPos.x + (barPosOffset.x - 0.5 + barPosPercentageOffset.x) * BarPosOffsetX + StartHpPos)
	barPos.y = math.floor(barPos.y + (barPosOffset.y - 0.5 + barPosPercentageOffset.y) * BarPosOffsetY + CorrectionY)
	local StartPos = Vector(barPos.x , barPos.y, 0)
	local EndPos = Vector(barPos.x + 108 , barPos.y , 0)
	return Vector(StartPos.x, StartPos.y, 0), Vector(EndPos.x, EndPos.y, 0)
end


function DrawLineHPBar(damage, line, text, unit)
	local thedmg = 0
	if damage >= unit.maxHealth then
		thedmg = unit.maxHealth-1
	else
		thedmg=damage
	end
	local StartPos, EndPos = GetHPBarPos(unit)
	local Real_X = StartPos.x+24
	local Offs_X = (Real_X + ((unit.health-thedmg)/unit.maxHealth) * (EndPos.x - StartPos.x - 2))
	if Offs_X < Real_X then Offs_X = Real_X end	
	local mytrans = 350 - math.round(255*((unit.health-thedmg)/unit.maxHealth)) ---   255 * 0.5
	if mytrans >= 255 then mytrans=254 end
	local my_bluepart = math.round(400*((unit.health-thedmg)/unit.maxHealth))
	if my_bluepart >= 255 then my_bluepart=254 end

	DrawLine(Offs_X-150, StartPos.y-(30+(line*15)), Offs_X-150, StartPos.y-2, 2, ARGB(mytrans, 255,my_bluepart,0))
	DrawText(tostring(text),15,Offs_X-148,StartPos.y-(30+(line*15)),ARGB(mytrans, 255,my_bluepart,0))
end


function _castSpell(TSPELL, TSPELLX, TSPELLZ, TUNIT)
	if TUNIT~=nil and TSPELLX==nil and TSPELLZ==nil and ValidTarget(TUNIT) then
		if Menu.extra.ex.packetcast == 2 and TSPELL~=_R then	
			CastSpell(TSPELL, TUNIT)
		end
		if (Menu.extra.ex.packetcast == 1 or Menu.extra.ex.packetcast == 3) then
		--	_CastSpellOverPacket(TSPELL, nil, nil, TUNIT)
			CastSpell(TSPELL, TUNIT)
		end
	end
	if TUNIT==nil and TSPELLX~=nil and TSPELLZ~=nil then
		if Menu.extra.ex.packetcast == 2 then
			CastSpell(TSPELL, TSPELLX, TSPELLZ)
		end
		if (Menu.extra.ex.packetcast == 1 or Menu.extra.ex.packetcast == 3) then
		--	_CastSpellOverPacket(TSPELL, TSPELLX, TSPELLZ, nil)
			CastSpell(TSPELL, TSPELLX, TSPELLZ)
		end
	end
end


function _CastSpellOverPacket(mySpell, PosX, PosZ, CUnit)
if not VIP_USER then
	print("<font color='#F72828'>BilbaoKarma >>[ERROR]: NonVIP USER TRY TO USE PACKETS!</font>")
else
local tnid, tposX, tposZ = nil, nil, nil
local cansend = false
	if PosX ~= nil and PosZ ~= nil then
		tposX = PosX
		tposZ = PosZ
		cansend = true
	else
		if CUnit ~= nil then
			tposX = CUnit.x
			tposZ = CUnit.z
			tnid  = CUnit.networkID
			cansend = true
		else			
			cansend = false
		end
	end
	if cansend then
		local CSOpacket = CLoLPacket(153)
		CSOpacket.dwArg1 = 1
		CSOpacket.dwArg2 = 0
		CSOpacket:EncodeF(myHero.networkID)
		CSOpacket:Encode1(mySpell)
		CSOpacket:EncodeF(tposX)
		CSOpacket:EncodeF(tposZ)
		CSOpacket:EncodeF(tposX)
		CSOpacket:EncodeF(tposZ)
		if tnid~=nil then
			CSOpacket:EncodeF(tnid)
		else
			CSOpacket:EncodeF(0)
		end
		SendPacket(CSOpacket)
	end
	if not cansend then print("<font color='#F72828'>[CSOP][ERROR]Invalid Operator</font>") end
end
end




--[[       ----------------------------------------------------------------------------------------------       ]]--
--[[					     	 		    	    Once loaded			 	  	   								]]--
--[[       ----------------------------------------------------------------------------------------------       ]]--


function _check_mmasac()
	if checkedMMASAC then return end
	if not (starttick + 5000 < GetTickCount()) then return end
	checkedMMASAC = true
    if _G.MMA_Loaded then
     	print(' >>BilbaoKarma: MMA found. MMA support loaded.')
		is_MMA = true
	else
		print(' >>BilbaoKarma: MMA not found')
	end	
	if _G.AutoCarry then
		print(' >>BilbaoKarma: SAC found. SAC support loaded.')
		is_SAC = true
	else
		print(' >>BilbaoKarma: SAC not found.')
	end	
	if is_MMA then
		Menu.ta:addSubMenu("Marksman's Mighty Assistant", "mma")
		Menu.ta.mma:addParam("mmastatus", "Use MMA Target Selector", SCRIPT_PARAM_ONOFF, false)				
	end
	if is_SAC then
		Menu.ta:addSubMenu("Sida's Auto Carry", "sac")
		Menu.ta.sac:addParam("sacstatus", "Use SAC Target Selector", SCRIPT_PARAM_ONOFF, false)
	end
	if VIP_USER then
		if prodicfile and not vpredicfile then
			print(' >>BilbaoKarma: VipPrediction and Prodiction loaded.')
		end
		if prodicfile and vpredicfile then
			print(' >>BilbaoKarma: VipPrediction, Prodiction and VPrediction loaded.')
		end
	else
		print(' >>BilbaoKarma: FreeUser Prediction loaded.')
	end
	if VIP_USER then
		print(' >>BilbaoKarma: VIP Menu loaded.')
	else
		print(' >>BilbaoKarma: FreeUser Menu loaded.')
	end	 
end


function _load_menu()
	Menu = scriptConfig("BilbaoKarma", "Enlightened")	
	
		-----------------------------------------------------------------------------------------------------
		Menu:addSubMenu("Drawing", "draw")
			Menu.draw:addSubMenu("Prediction&Co", "prdraw")
				Menu.draw.prdraw:addParam("enemy", "Mark Enemy", SCRIPT_PARAM_ONOFF, true)
				Menu.draw.prdraw:addParam("enemyline", "Line2Enemy", SCRIPT_PARAM_ONOFF, true)
				Menu.draw.prdraw:addParam("predmg", "Draw Predicted Dmg", SCRIPT_PARAM_ONOFF, true)
				Menu.draw.prdraw:addParam("preQ", "Draw Predicted Q-Pos", SCRIPT_PARAM_ONOFF, true)
				Menu.draw.prdraw:addParam("preQR", "Draw Predicted QR-Pos", SCRIPT_PARAM_ONOFF, true)
				Menu.draw.prdraw:addParam("preMOVE", "Draw Predicted Move", SCRIPT_PARAM_ONOFF, true)				
		-----------------------------------------------------------------------------------------------------

		-----------------------------------------------------------------------------------------------------
			Menu.draw:addSubMenu("Ranges", "drawsub2")
				Menu.draw.drawsub2:addParam("drawaa", "Draw AARange", SCRIPT_PARAM_ONOFF, true)
				Menu.draw.drawsub2:addParam("drawQ", "Draw QRange", SCRIPT_PARAM_ONOFF, true)
				Menu.draw.drawsub2:addParam("drawW", "Draw WRange", SCRIPT_PARAM_ONOFF, true)
				Menu.draw.drawsub2:addParam("drawE", "Draw ERange", SCRIPT_PARAM_ONOFF, true)
		-----------------------------------------------------------------------------------------------------
		
		
		-----------------------------------------------------------------------------------------------------
		Menu:addSubMenu("Harrass", "harrass")			
			Menu.harrass:addParam("autohrsQ", "Auto Use Q", SCRIPT_PARAM_ONOFF, true)
		-----------------------------------------------------------------------------------------------------
		
		
		-----------------------------------------------------------------------------------------------------
		Menu:addSubMenu("Rotation", "rota")			
			Menu.rota:addParam("userq", "Q Usage", SCRIPT_PARAM_LIST, 3, { "Disabled", "Only Q", "RQ Combo" })
			Menu.rota:addParam("userw", "W Usage", SCRIPT_PARAM_LIST, 3, { "Disabled", "Only W", "RW Combo" })
			Menu.rota:addParam("usere", "E Usage", SCRIPT_PARAM_LIST, 3, { "Disabled", "Only E", "RE Combo" })
			Menu.rota:addParam("enemyErange", "Use E if enemy near then",  SCRIPT_PARAM_SLICE, 400, 0, 2500, 0)
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
			if VIP_USER then
				Menu.ta:addParam("packet", "Use Packets", SCRIPT_PARAM_ONOFF, false)
			end	
			if not VIP_USER then
				Menu.ta:addParam("co", "Use", SCRIPT_PARAM_LIST, 1, {"FREEPrediction"})
			end
			if VIP_USER and not prodicfile and not vpredicfile then
				Menu.ta:addParam("co", "Use", SCRIPT_PARAM_LIST, 2, {"FREEPrediction", "[VIP]Prediction",  }) 
				Menu.ta.co = 2
			end
			if not prodicfile and vpredicfile then
				Menu.ta:addParam("co", "Use", SCRIPT_PARAM_LIST, 3, {"FREEPrediction","[VIP]Prediction", "VPrediction" }) 
				Menu.ta.co = 3 
			end			
			if VIP_USER and prodicfile and vpredicfile then 
				Menu.ta:addParam("co", "Use", SCRIPT_PARAM_LIST, 4, {"FREEPrediction","[VIP]Prediction","VPrediction","Prodiction"})  
				Menu.ta.co = 4 
			end			
				Menu.ta:addSubMenu("Basic", "basic")
					Menu.ta.basic:addParam("basicstatus", "Use Basic Target Selector", SCRIPT_PARAM_ONOFF, false)
					
				Menu.ta:addParam("orb", "InBuild Orbwalk", SCRIPT_PARAM_LIST, 1, { "COMBO", "ALWAYS", "NEVER" })
		-----------------------------------------------------------------------------------------------------


		-----------------------------------------------------------------------------------------------------
		Menu:addSubMenu("Extra", "extra")
			Menu.extra:addSubMenu("Extended", "ex")
				Menu.extra.ex:addParam("packetcast", "Casting", SCRIPT_PARAM_LIST, 1, { "Mixed", "Regular", "Packets" })
				Menu.extra.ex:addParam("packetmove", "Packet Movement", SCRIPT_PARAM_ONOFF, false)			 			
			Menu.extra:addSubMenu("Auto level", "alvl")
				Menu.extra.alvl:addParam("alvlstatus", "Auto lvl skills", SCRIPT_PARAM_ONOFF, false)
				Menu.extra.alvl:addParam("lvlseq", "Choose your lvl Sequence", SCRIPT_PARAM_LIST, 1, { "R>Q>W>E", "R>Q>E>W", "R>W>Q>E", "R>W>E>Q", "R>E>Q>W", "R>E>W>Q" })
			Menu.extra:addSubMenu("RW-Config", "rwslider")
				Menu.extra.rwslider:addParam("rwslider", "myHeroHP < %",  SCRIPT_PARAM_SLICE, 75, 0, 100, 0)			
		-----------------------------------------------------------------------------------------------------
		Menu:addParam("info", " >> created by Bilbao", SCRIPT_PARAM_INFO, "")
		Menu:addParam("info2", " >> Version "..CurVer.."B", SCRIPT_PARAM_INFO, "")		
		_setimpdef()
end


function _initiateTS()
	ts = TargetSelector(TARGET_PRIORITY, 1000)
	ts.name = "Karma"
	Menu.ta.basic:addTS(ts)
end


function _setimpdef()
	Menu.extra.alvl.alvlstatus = false
	Menu.keys.permrota = false
	Menu.keys.okdrota = false
	Menu.keys.permhrs = false
	Menu.keys.okdhrs = false
end
	

function _loadP()
	if prodicfile and VIP_USER then		
		Prodiction = ProdictManager.GetInstance()
		ProdictionQ = Prodiction:AddProdictionObject(_Q, Qrange, Qspeed, Qdelay, Qwidth)				
	end
	if vpredicfile then			
		VP = VPrediction()	
	end
	if VIP_USER then
			VipPredictionQ = TargetPredictionVIP(Qrange, Qspeed, Qdelay, Qwidth, myHero)				
	end	
		FreePredictionQ = TargetPrediction(Qrange, Qspeed, Qdelay, Qwidth)		
end	
