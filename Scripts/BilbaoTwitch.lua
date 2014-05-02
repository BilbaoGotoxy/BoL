if myHero.charName ~= "Twitch" then return end
--[[       ----------------------------------------------------------------------------------------------   ]]--
--[[						BilbaoTwitch by Bilbao			   	 	    ]]--
--[[       ----------------------------------------------------------------------------------------------   ]]--

-------Auto update-------
local CurVer = 0.1 
local NetVersion = nil 
local NeedUpdate = false 
local Do_Once = true 
local ScriptName = "BilbaoTwitch"
local NetFile = "http://bilbao.lima-city.de/BilbaoTwitch.lua" 
local LocalFile = BOL_PATH.."Scripts\\BilbaoTwitch.lua" 
-------/Auto update-------

function CheckVersion(data)
	NetVersion = tonumber(data)
	if type(NetVersion) ~= "number" then return end
	if NetVersion and NetVersion > CurVer then
		print("<font color='#FF4000'>-- "..ScriptName..": New version available "..NetVersion..".</font>") 
		print("<font color='#FF4000'>-- "..ScriptName..": Updating, please do not press F9 until update is finished.</font>") 
		NeedUpdate = true  
	else
		print("<font color='#00BFFF'>-- "..ScriptName..": You have the lastest version.</font>") 
	end
end

function UpdateScript()
	if Do_Once then	
		Do_Once = false
		if _G.UseUpdater == nil or _G.UseUpdater == true then 			
			GetAsyncWebResult("bilbao.lima-city.de", ScriptName.."ver.txt", CheckVersion)			
		end
	end
	if NeedUpdate then
		NeedUpdate = false
		DownloadFile(NetFile, LocalFile, function()
							if FileExist(LocalFile) then
								print("<font color='#00BFFF'>-- "..ScriptName..": Successfully updated v"..CurVer.." -> v"..NetVersion.." - Please reload.</font>")								
							end
						end
				)
	end
end

AddTickCallback(UpdateScript)
-----------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------


            _G.prodic = false
            _G.prodicfile = false           
            _G.vpredicfile = false      
            _G.vpredic = false           
            _G.freevippredic = false
			_G.freevippredicfile = false           
			_G.freepredic = false
            _G.freepredicfile = true       
            if VIP_USER then
                    if FileExist(SCRIPT_PATH..'Common/Prodiction.lua') then
                            require "Prodiction"
							require "Collision"
                            prodicfile = true
                            prodic = true          
                    end
                    if FileExist(SCRIPT_PATH..'Common/VPrediction.lua') then
                            require "VPrediction"
                            vpredic = true
                            vpredicfile = true
                    else                           
                            freevippredicfile = true
                    end            
            else
                    freepredicfile = true         
            end  

	-------Skills info-------	
	local Wrange, Wwidth, Wspeed, Wdelay = 950, 275, 1750, 0.25	
	local Erange, Ewidth, Espeed, Edelay = 1200, 0, math.huge, 0.5	
	local Rrange, Rwidth, Rspeed, Rdelay = 850, 250, 500, 0.2	
	local QReady, WReady, EReady, RReady = false, false, false, false
	-------/Skills info-------	
	
	-------Vprediction info-------
	local VP = nil
	------/Vprediction info-------	
	
	-------Orbwalk & Farm info-------
	local lastAttack, lastWindUpTime, lastAttackCD = 0, 0, 0
	local myTrueRange = 550
	local orb_SELF, orb_MMA, orb_SAC = false, false, false
	-------/Orbwalk & Farm info-------
		
	-------MMA & SAC info-------
	local starttick = 0
	local checkedMMASAC = false
	local is_MMA = false
	local is_SAC = false
	-------/MMA & SAC info-------
		
	-------Target info-------
	local SELFplayer = nil
	local ts = nil
	local Target = nil
	local PoisenScanTick = 0
	local ParticleDelay = 0
	-------/Target info-------	
	
	-------Autolvl info-------
	local abilitylvl = 0
	local lvlsequence = 1 
	-------/Autolvl info-------	
	
	
	
--[[       ----------------------------------------------------------------------------------------------       ]]--
--[[													Callbacks												]]--
--[[       ----------------------------------------------------------------------------------------------       ]]--	


function OnLoad()	
	_loadP() 
	_load_menu() 
	_initiateTS()	
	PrintChat("<font color='#40FF00'> >> "..ScriptName.." v."..CurVer.." - loaded</font>")
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
	if myHero.dead then return end
	_draw_ranges() 
	_draw_tarinfo()	
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
if EReady then
	e_to_ks() 	
end
if (Menu.keys.permrota or Menu.keys.okdrota) then
			if Menu.rota.useQ and canQrota and QReady then
				cast_pred_q()	
			end
			if Menu.rota.useW and canWrota and WReady then
				cast_pred_w()	
			end
			if Menu.rota.useR and canRrota and RReady then
				cast_pred_r()	
			end
end
if (Menu.keys.permhrs or Menu.keys.okdhrs) then	
			if Menu.harrass.autohrsW and canWhrs and WReady then				
				cast_pred_w()	
			end	
end		
end


function cast_pred_q() 
if not QReady then return end
	if Menu.specl.qspecl.aq then
		if myhealthislowerthen(Menu.specl.qspecl.qslider) then
			_castSpell(_Q, nil, nil, SELFplayer)
		end	
	end
end


function cast_pred_w()
if not WReady then return end
local w_pos = nil
	if Menu.ta.co == 1 then
		local BestHitTar, BestHits = nil, 0
		for i, enemy in ipairs(GetEnemyHeroes()) do
			if enemy ~= nil and not enemy.dead and enemy.visible and ValidTarget(enemy, Wrange) then
			local currEnemyInRange = CountEnemyHeroInRange(Wrange, enemy)
				if currEnemyInRange >= BestHits and currEnemyInRange >= Menu.specl.wspecl.wslider then
					BestHits = currEnemyInRange
					BestHitTar = enemy
				end
			end
		end
		if BestHitTar ~= nil and ValidTarget(BestHitTar) then			
			local Position = FreePredictionW:GetPrediction(BestHitTar)
			if Position ~= nil then
				w_pos = Position
			end		
		end	
	end	
	if Menu.ta.co == 2 and VIP_USER then
		local BestHitTar, BestHits = nil, 0
		for i, enemy in ipairs(GetEnemyHeroes()) do
			if enemy ~= nil and not enemy.dead and enemy.visible and ValidTarget(enemy, Wrange) then
			local currEnemyInRange = CountEnemyHeroInRange(Wrange, enemy)
				if currEnemyInRange >= BestHits and currEnemyInRange >= Menu.specl.wspecl.wslider then
					BestHits = currEnemyInRange
					BestHitTar = enemy
				end
			end
		end
		if BestHitTar ~= nil and ValidTarget(BestHitTar) then			
			local Position = VipPredictionW:GetPrediction(BestHitTar)
			if Position ~= nil then
				w_pos = Position
			end		
		end		
	end	
	if Menu.ta.co == 3 and vpredicfile then
		local BestHitPos, BestHits, BestN = nil, 0, 0
		for i, currEnemy in pairs(GetEnemyHeroes()) do
			if ValidTarget(currEnemy) and not currEnemy.dead and currEnemy.visible and ValidTarget(currEnemy, Wrange) then				
				local  AOECastPosition, MainTargetHitChance, nTargets = VP:GetCircularAOECastPosition(currEnemy, Wdelay, Wwidth, Wrange, Wspeed, myHero)
				if MainTargetHitChance >= BestHits  and nTargets >= Menu.specl.wspecl.wslider then
					BestHitPos = AOECastPosition
					BestHits = HitChance
					BestN = nTargets					
				end				
			end	
		end
		if BestHitPos ~= nil then
			w_pos = BestHitPos
		end	
	end	
	if Menu.ta.co == 4 and prodicfile then	
		local PossTargetPos = prod_MinBest(Menu.specl.wspecl.wslider, Wrange, Wwidth)
		if PossTargetPos ~= nil then
			w_pos = PossTargetPos
		end	
	end	
	if w_pos ~= nil then
		_castSpell(_W, w_pos.x, w_pos.z, nil)	
	end
end


function prod_MinBest(MinAmount, distance, range)
local BestTargetUnit, BestTargetPredictedPos, BestTargetHitAmount = nil, nil, 0
	for i, enemy in pairs(GetEnemyHeroes()) do
		local currentScanUnit, currentScanPos, currentScanCount = nil, nil, 0
		if not enemy.dead and enemy.visible and ValidTarget(enemy) then
			PredWPos = ProdictionW:GetPrediction(enemy)
			currentScanUnit = enemy
			currentScanPos = PredWPos			
			for i, Cenemy in pairs(GetEnemyHeroes()) do
				if not Cenemy.dead and Cenemy.visible and ValidTarget(Cenemy) then
					PredWPosCenemy = ProdictionW:GetPrediction(Cenemy)
					if GetDistanceSqr(PredWPosCenemy, currentScanPos) < range then
						currentScanCount = currentScanCount + 1			
					end				
				end			
			end			
			if currentScanCount >= MinAmount and currentScanCount >= BestTargetHitAmount then
				BestTargetUnit = currentScanUnit
				BestTargetPredictedPos = currentScanPos
				BestTargetHitAmount = currentScanCount
			end			
		end
	end
	if BestTargetUnit ~= nil and BestTargetPredictedPos ~= nil and GetDistance(BestTargetPredictedPos) < distance then
		return BestTargetPredictedPos
	end
end


function e_to_ks()
if not EReady then return end
if not Menu.specl.especl.eks then return end
	for i, enemy in ipairs(GetEnemyHeroes()) do
		if ValidTarget(enemy, Erange) and not enemy.dead and enemy.visible then
			if enemy.health < ExpundDmg(enemy) then
				CastSpell(_E)
			end
		end
	end
end


function ExpundDmg(target)
local StucksOnEnemy = FindStacks(target)
local Elevel = GetSpellData(_E).level
local BaseAddDmg =  10 + (StucksOnEnemy * 5)
local StuckDmg = (StucksOnEnemy * ((myHero.ap * 0.2) + (myHero.addDamage * 0.25) + BaseAddDmg))
local BaseBonusDmg = (Elevel * 15) + 5
local TotalDmg = (BaseBonusDmg + StuckDmg) - 3
local RealDmg = myHero:CalcDamage(target,TotalDmg)
if RealDmg ~= nil then
	if RealDmg >= 1 then
		return RealDmg
	else
		return 0
	end
end
end


function FindStacks(target)
local scan = false
if GetTickCount() > ParticleDelay then 
	scan=true
else
	scan=false	
end
local poisencount = 0
if scan then
	for i = 1, 6 do
		local haspoisen = TargetHaveParticle("twitch_poison_counter_0"..i..".troy", target)
		if haspoisen then poisencount = i end
	end	
	ParticleDelay = GetTickCount() + Menu.specl.especl.escanner	
	if poisencount >= 1 and poisencount >= Menu.specl.especl.expund then
		if EReady and Menu.specl.especl.autoex and ValidTarget(target, Erange) then
			CastSpell(_E)
		end	
	end	
end	
	return poisencount
end


function cast_pred_r()
if not RReady then return end
	if Menu.specl.rspecl.ar then
		local EnemysInRange = CountEnemyHeroInRange(Menu.specl.rspecl.rrange, m)
		if EnemysInRange >= Menu.specl.rspecl.rslider then 
			CastSpell(_R)
		end
	else		
		CastSpell(_R)
	end
end


--[[       ----------------------------------------------------------------------------------------------       ]]--
--[[					     	 		    	    General				 	  	   								]]--
--[[       ----------------------------------------------------------------------------------------------       ]]--


function _OrbWalk()
	if not (Menu.ta.orb == 1 or Menu.ta.orb == 2) then return end
	if Menu.ta.orb == 1 then
		if not (Menu.keys.permrota or Menu.keys.okdrota or Menu.keys.okdhrs) then return end
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
	myTrueRange = myHero.range + (GetDistance(myHero.minBBox) - 3)
	Target = _getTarget()
	_autoskill()
	_checkcancastHRS()
	_checkcancastROTA()
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

function _checkcancastHRS()	
	if Menu.manamenu.manahrs.manaq then 
		if mynamaislowerthen(Menu.manamenu.manahrs.sliderq) then
			canQhrs = false
		else			
			canQhrs = true
		end
	else
		canQhrs = true	
	end
	if Menu.manamenu.manahrs.manaw then 
		if mynamaislowerthen(Menu.manamenu.manahrs.sliderw) then
			canWhrs = false
		else			
			canWhrs = true
		end
	else
		canWhrs = true	
	end	
	if Menu.manamenu.manahrs.manae then 
		if mynamaislowerthen(Menu.manamenu.manahrs.slidere) then
			canEhrs = false
		else			
			canEhrs = true
		end
	else
		canEhrs = true	
	end		
	if Menu.manamenu.manahrs.manar then 
		if mynamaislowerthen(Menu.manamenu.manahrs.sliderr) then
			canRhrs = false
		else			
			canRhrs = true
		end
	else
		canRhrs = true	
	end	
end


function _checkcancastROTA()	
	if Menu.manamenu.manarota.manaq then 
		if mynamaislowerthen(Menu.manamenu.manarota.sliderq) then
			canQrota = false
		else			
			canQrota = true
		end
	else
		canQrota = true	
	end
	if Menu.manamenu.manarota.manaw then 
		if mynamaislowerthen(Menu.manamenu.manarota.sliderw) then
			canWrota = false
		else			
			canWrota = true
		end
	else
		canWrota = true	
	end	
	if Menu.manamenu.manarota.manae then 
		if mynamaislowerthen(Menu.manamenu.manarota.slidere) then
			canErota = false
		else			
			canErota = true
		end
	else
		canErota = true	
	end		
	if Menu.manamenu.manarota.manar then 
		if mynamaislowerthen(Menu.manamenu.manarota.sliderr) then
			canRrota = false
		else			
			canRrota = true
		end
	else
		canRrota = true	
	end	
end

function mynamaislowerthen(percent)
    if myHero.mana < (myHero.maxMana * ( percent / 100)) then
        return true
    else
        return false
    end
end

function myhealthislowerthen(percent)
    if myHero.health < (myHero.maxHealth * ( percent / 100)) then
        return true
    else
        return false
    end
end

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
		if Menu.extra.packetmove then
			Packet('S_MOVE', { type = 2, x = moveToPos.x, y = moveToPos.z }):send()
		else			
			myHero:MoveTo(moveToPos.x, moveToPos.z)
		end
	end 
end	


function _draw_ranges()
	if Menu.draw.drawsub2.drawaa then
		DrawCircle(myHero.x, myHero.y, myHero.z, 525, ARGB(25 , 125, 125, 125))
	end
	if Menu.draw.drawsub2.drawW and WReady then
		DrawCircle(myHero.x, myHero.y, myHero.z, Wrange, ARGB(100, 250, 0, 250))
	end
	if Menu.draw.drawsub2.drawE and EReady then
		DrawCircle(myHero.x, myHero.y, myHero.z, Erange, ARGB(100, 0, 250, 0))
	end
end


function _draw_tarinfo()
	if Target~=nil and ValidTarget(Target, 2000) then	
		if Menu.draw.prdraw.enemyline then		
			DrawLine3D(myHero.x, myHero.y, myHero.z, Target.x, Target.y, Target.z, 1, ARGB(250,235,33,33))
		end	
		if Menu.draw.prdraw.enemy then
			DrawCircle(Target.x, Target.y, Target.z, 100, ARGB(250, 253, 33, 33))
		end
	end
end


function _castSpell(TSPELL, TSPELLX, TSPELLZ, TUNIT)
	if TUNIT~=nil and TSPELLX==nil and TSPELLZ==nil and ValidTarget(TUNIT) then
		if Menu.extra.ex.packetcast == 1 and TSPELL~=_R then	
			CastSpell(TSPELL, TUNIT)
		end
		if (Menu.extra.ex.packetcast == 2 or Menu.extra.ex.packetcast == 3) then
			_CastSpellOverPacket(TSPELL, nil, nil, TUNIT)
		end
	end
	if TUNIT==nil and TSPELLX~=nil and TSPELLZ~=nil then
		if Menu.extra.ex.packetcast == 1 then
			CastSpell(TSPELL, TSPELLX, TSPELLZ)
		end
		if (Menu.extra.ex.packetcast == 2 or Menu.extra.ex.packetcast == 3) then
			_CastSpellOverPacket(TSPELL, TSPELLX, TSPELLZ, nil)
		end
	end
end


function _CastSpellOverPacket(mySpell, PosX, PosZ, CUnit)
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


--[[       ----------------------------------------------------------------------------------------------       ]]--
--[[					     	 		    	    Once loaded			 	  	   								]]--
--[[       ----------------------------------------------------------------------------------------------       ]]--


function _check_mmasac()
	if checkedMMASAC then return end
	if not (starttick + 5000 < GetTickCount()) then return end
	checkedMMASAC = true
    if _G.MMA_Loaded then
     	print(' >> MMA found. MMA support loaded.')
		is_MMA = true
	else
		print(' >>'..ScriptName..': MMA not found')
	end	
	if _G.AutoCarry then
		print(' >>'..ScriptName..': SAC found. SAC support loaded.')
		is_SAC = true
	else
		print(' >>'..ScriptName..': SAC not found.')
	end	
	if is_MMA then
		Menu.ta:addSubMenu("Marksman's Mighty Assistant", "mma")
		Menu.ta.mma:addParam("mmastatus", "Use MMA", SCRIPT_PARAM_ONOFF, false)				
	end
	if is_SAC then
		Menu.ta:addSubMenu("Sida's Auto Carry", "sac")
		Menu.ta.sac:addParam("sacstatus", "Use SAC", SCRIPT_PARAM_ONOFF, false)
	end
	if VIP_USER then
		if prodicfile and not vpredicfile then
			print(' >>'..ScriptName..': VipPrediction and Prodiction loaded.')
		end
		if prodicfile and vpredicfile then
			print(' >>'..ScriptName..': VipPrediction, Prodiction and VPrediction loaded.')
		end
	else
		print(' >>'..ScriptName..': FreeUser Prediction loaded.')
	end
	if VIP_USER then
		print(' >>'..ScriptName..': VIP Menu loaded.')
	else
		print(' >>'..ScriptName..': FreeUser Menu loaded.')
	end	 
end


function _load_menu() 
	Menu = scriptConfig(""..ScriptName, "bilbao")	
		-----------------------------------------------------------------------------------------------------
		Menu:addSubMenu("Drawing", "draw")
			Menu.draw:addSubMenu("Prediction&Co", "prdraw")
				Menu.draw.prdraw:addParam("enemy", "Mark Enemy", SCRIPT_PARAM_ONOFF, true)
				Menu.draw.prdraw:addParam("enemyline", "Line2Enemy", SCRIPT_PARAM_ONOFF, true)						
		-----------------------------------------------------------------------------------------------------

		-----------------------------------------------------------------------------------------------------
			Menu.draw:addSubMenu("Ranges", "drawsub2")
				Menu.draw.drawsub2:addParam("drawaa", "Draw AARange", SCRIPT_PARAM_ONOFF, true)			
				Menu.draw.drawsub2:addParam("drawW", "Draw WRange", SCRIPT_PARAM_ONOFF, true)
				Menu.draw.drawsub2:addParam("drawE", "Draw ERange", SCRIPT_PARAM_ONOFF, true)				
		-----------------------------------------------------------------------------------------------------
		
		
		-----------------------------------------------------------------------------------------------------
		Menu:addSubMenu("Harrass", "harrass")		
			Menu.harrass:addParam("autohrsW", "Auto Use W", SCRIPT_PARAM_ONOFF, true)					
		-----------------------------------------------------------------------------------------------------
		
		
		-----------------------------------------------------------------------------------------------------
		Menu:addSubMenu("Rotation", "rota")			
			Menu.rota:addParam("useQ", "Q Usage", SCRIPT_PARAM_ONOFF, true)
			Menu.rota:addParam("useW", "W Usage", SCRIPT_PARAM_ONOFF, true)
			Menu.rota:addParam("useE", "E Usage", SCRIPT_PARAM_ONOFF, true)
			Menu.rota:addParam("useR", "R Usage", SCRIPT_PARAM_ONOFF, true)
		-----------------------------------------------------------------------------------------------------
		
		Menu:addSubMenu("Mana Manager", "manamenu")
			Menu.manamenu:addSubMenu("Harrass", "manahrs")

				Menu.manamenu.manahrs:addParam("manaw", "W ManaManager", SCRIPT_PARAM_ONOFF, true)
				Menu.manamenu.manahrs:addParam("sliderw", "Use W only if mana over %",  SCRIPT_PARAM_SLICE, 50, 0, 100, 0)

			Menu.manamenu:addSubMenu("Rotation", "manarota")
				Menu.manamenu.manarota:addParam("manaq", "Q ManaManager", SCRIPT_PARAM_ONOFF, true)
				Menu.manamenu.manarota:addParam("sliderq", "Use Q only if mana over %",  SCRIPT_PARAM_SLICE, 50, 0, 100, 0)
				Menu.manamenu.manarota:addParam("manaw", "W ManaManager", SCRIPT_PARAM_ONOFF, true)
				Menu.manamenu.manarota:addParam("sliderw", "Use W only if mana over %",  SCRIPT_PARAM_SLICE, 50, 0, 100, 0)
				Menu.manamenu.manarota:addParam("manae", "E ManaManager", SCRIPT_PARAM_ONOFF, true)
				Menu.manamenu.manarota:addParam("slidere", "Use E only if mana over %",  SCRIPT_PARAM_SLICE, 50, 0, 100, 0)
				Menu.manamenu.manarota:addParam("manar", "R ManaManager", SCRIPT_PARAM_ONOFF, true)
				Menu.manamenu.manarota:addParam("sliderr", "Use R only if mana over %",  SCRIPT_PARAM_SLICE, 50, 0, 100, 0)
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
			if not VIP_USER then
				Menu.ta:addParam("co", "Use", SCRIPT_PARAM_LIST, 1, {"FREEPrediction"})
			end
			if VIP_USER and not prodicfile and not vpredicfile then
				Menu.ta:addParam("co", "Use", SCRIPT_PARAM_LIST, 2, {"FREEPrediction", "VIPPrediction",  }) 
				Menu.ta.co = 2
			end
			if VIP_USER and not prodicfile and vpredicfile then
				Menu.ta:addParam("co", "Use", SCRIPT_PARAM_LIST, 3, {"FREEPrediction","VIPPrediction", "VPrediction" }) 
				Menu.ta.co = 3 
			end
			
			if VIP_USER and prodicfile and vpredicfile then 
				Menu.ta:addParam("co", "Use", SCRIPT_PARAM_LIST, 4, {"FREEPrediction","VIPPrediction","VPrediction","Prodiction"})  
				Menu.ta.co = 4 
			end					
			
				Menu.ta:addSubMenu("Basic", "basic")
					Menu.ta.basic:addParam("basicstatus", "Use BasicTS", SCRIPT_PARAM_ONOFF, false)					
				Menu.ta:addParam("orb", "Basic - Orbwalk", SCRIPT_PARAM_LIST, 1, { "COMBO", "ALWAYS", "NEVER" })
		-----------------------------------------------------------------------------------------------------


		-----------------------------------------------------------------------------------------------------
		Menu:addSubMenu("Extra", "extra")
			Menu.extra:addSubMenu("Extended", "ex")
				if VIP_USER then
					Menu.extra.ex:addParam("packetcast", "Casting", SCRIPT_PARAM_LIST, 1, { "Regular", "NoFace(P)", "Packets" })
				else
					Menu.extra.ex:addParam("packetcast", "Casting", SCRIPT_PARAM_LIST, 1, {"Regular"})
				end
				if VIP_USER then
					Menu.extra.ex:addParam("packetmove", "Movement", SCRIPT_PARAM_LIST, 1, { "Regular", "Packets" })
				else
					Menu.extra.ex:addParam("packetmove", "Movement", SCRIPT_PARAM_LIST, 1, { "Regular"})
				end
			Menu.extra:addSubMenu("Auto level", "alvl")
				Menu.extra.alvl:addParam("alvlstatus", "Auto lvl skills", SCRIPT_PARAM_ONOFF, false)
				Menu.extra.alvl:addParam("lvlseq", "Choose your lvl Sequence", SCRIPT_PARAM_LIST, 1, { "R>Q>W>E", "R>Q>E>W", "R>W>Q>E", "R>W>E>Q", "R>E>Q>W", "R>E>W>Q" })
				
				
			Menu:addSubMenu("Special", "specl")
				Menu.specl:addSubMenu("Q-Options", "qspecl")
					Menu.specl.qspecl:addParam("aq", "Use Q if Health is low", SCRIPT_PARAM_ONOFF, true)
					Menu.specl.qspecl:addParam("qslider", "Q Health slider(%)",  SCRIPT_PARAM_SLICE, 80, 0, 100, 0)
				Menu.specl:addSubMenu("W-Options", "wspecl")
					Menu.specl.wspecl:addParam("wslider", "Enemys to hit",  SCRIPT_PARAM_SLICE, 1, 1, 5, 0)
				Menu.specl:addSubMenu("E-Options", "especl")
					Menu.specl.especl:addParam("autoex", "Auto expund", SCRIPT_PARAM_ONOFF, true)
					Menu.specl.especl:addParam("expund", "Auto expund", SCRIPT_PARAM_LIST, 1, { "@1 stuck", "@2 stucks", "@3 stucks", "@4 stucks", "@5 stucks", "@6 stucks" })
					Menu.specl.especl:addParam("eks", "Auto KS with E", SCRIPT_PARAM_ONOFF, true)
					Menu.specl.especl:addParam("escanner", "E Scan delay(ms)",  SCRIPT_PARAM_SLICE, 200, 0, 1000, 0) 
				Menu.specl:addSubMenu("R-Options", "rspecl")
					Menu.specl.rspecl:addParam("ar", "Use R X-Enemys are in range", SCRIPT_PARAM_ONOFF, true)
					Menu.specl.rspecl:addParam("rslider", "Enemys in Range",  SCRIPT_PARAM_SLICE, 1, 1, 5, 0)
					Menu.specl.rspecl:addParam("rrange", "Range",  SCRIPT_PARAM_SLICE, 750, 1, 900, 0)

				
		-----------------------------------------------------------------------------------------------------
		Menu:addParam("info", " >> created by Bilbao", SCRIPT_PARAM_INFO, "")
		Menu:addParam("info2", " >> Version "..CurVer, SCRIPT_PARAM_INFO, "")
		_setimpdef()
end


function _initiateTS()
	ts = TargetSelector(TARGET_LOW_HP_PRIORITY, myTrueRange)
	ts.name = ""..myHero.charName
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
	SELFplayer = GetMyHero()
	starttick = GetTickCount()
	PoisenScanTick = GetTickCount()
	ParticleDelay = GetTickCount()
	
	if prodicfile then	
		Prodiction = ProdictManager.GetInstance()
		ProdictionW = Prodiction:AddProdictionObject(_W, Wrange, Wspeed, Wdelay, Wwidth)		
	end
	if vpredicfile then			
		VP = VPrediction()	
	end
	if VIP_USER then	
			VipPredictionW = TargetPredictionVIP(Wrange, Wspeed, Wdelay, Wwidth, myHero)
	end
	
		FreePredictionW = TargetPrediction(Wrange, Wspeed, Wdelay, Wwidth)	
end	
