 
if myHero.charName ~= "Veigar" then return end
--[[       ----------------------------------------------------------------------------------------------       ]]--
--[[								Lil' Veigar by Bilbao		    							   	 	        ]]--
--[[       ----------------------------------------------------------------------------------------------       ]]--

            _G.prodic = false
            _G.prodicfile = false           
            _G.vpredicfile = false      
            _G.vpredic = false           
            _G.freevippredic = false
			_G.freevippredicfile = false           
			_G.freepredic = false
            _G.freepredicfile = true          
     
           
            if VIP_USER then
                    if FileExist(SCRIPT_PATH..'Common/Prodiction.lua') then --prodiction
                            require "Prodiction"
							require "Collision"
                            prodicfile = true
                            prodic = true          
                    end
                    if FileExist(SCRIPT_PATH..'Common/VPrediction.lua') then --vprediction
                            require "VPrediction"
                            vpredic = true
                            vpredicfile = true
                    else                           
                            freevippredicfile = true --vipprediction
                    end            
            else
                    freepredicfile = true --freeprediction         
            end  


--ENCRYPTED AFTER HERE--
	

	-------Skills info-------
	local projSpeed = 1.2
	local Qrange, Qwidth, Qspeed, Qdelay = 650, 0, 1500, 0.5
	
	local Wrange, Wwidth, Wspeed, Wdelay = 900, 225, 1500, 1.2
	
	local Erange, Ewidth, Espeed, Edelay = 1000, 45, math.huge, 0 --650
	
	local Rrange, Rwidth, Rspeed, Rdelay = 650, 0, 1400, 0.5
	
	local DFGrange, DFGslot = 750, nil
	
	local QReady, WReady, EReady, RReady, DFGReady = false, false, false, false, false
	local canQhrs, canWhrs, canEhrs, canRhrs = false, false, false, false
	local canQrota, canWrota, canErota, canRrota = false, false, false, false
	local comboQ, comboQW, comboQWR, comboQR, comboR, DfgDmg = nil, nil, nil, nil, nil, nil
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
	local is_SAC = false
	-------/MMA & SAC info-------
	
	
	-------Target info-------
	local ts = nil
	local Target, currTargetPos = nil, nil
	local preenemy = nil
	local drawtar = nil
	local predQpos, predWpos, predEpos, predRpos = nil, nil, nil, nil
	-------/Target info-------
	
	
	-------Autolvl info-------
	local abilitylvl = 0
	local lvlsequence = 1 
	-------/Autolvl info-------
	
	
	-------Auto update-------
	local CurVer = 0.3
	local CurName = "BilbaoVeigar"
	local NeedUpdate = false
	local updated = true	
	-------/Auto update-------

	
	-------Interuptions-------
	local LastCastedSpell = {}
	local spells = 
	{
		{name = "CaitlynAceintheHole", menuname = "Caitlyn (R)"},
		{name = "AhriTumble", menuname = "Ahri (R)"},
		{name = "DariusExecute", menuname = "Darius (R)"},
		{name = "Crowstorm", menuname = "Fiddlesticks (R)"},
		{name = "DrainChannel", menuname = "Fiddlesticks (W)"},
		{name = "GalioIdolOfDurand", menuname = "Galio (R)"},
		{name = "KatarinaR", menuname = "Katarina (R)"},
		{name = "InfiniteDuress", menuname = "WarWick (R)"},
		{name = "AbsoluteZero", menuname = "Nunu (R)"},
		{name = "MissFortuneBulletTime", menuname = "Miss Fortune (R)"},
		{name = "FallenOne", menuname = "Karthus (R)"},
		{name = "LucianR", menuname = "Lucian (R)"},
		{name = "SoulShackles", menuname = "Morgana (R)"},
		{name = "UndyingRage", menuname = "Tryndamere (R)"},
		{name = "GrandSkyfall", menuname = "Pantheon (R)"},
		{name = "AlZaharNetherGrasp", menuname = "Malzahar (R)"},	
		{name = "VolibearQ", menuname = "Volibear (Q)"}, 
		{name = "InfiniteDuress", menuname = "Warwick (R)"},
		{name = "MonkeyKingSpinToWin", menuname = "Wukong (R)"},
		{name = "XerathLocusOfPower2", menuname = "Xerath (R)"},
		{name = "ZacR", menuname = "Zac (R)"},
	}
	-------/Interuptions-------
	
--[[       ----------------------------------------------------------------------------------------------       ]]--
--[[													Callbacks												]]--
--[[       ----------------------------------------------------------------------------------------------       ]]--	


function OnLoad()	
	starttick = GetTickCount()
	_loadP()
	_load_menu()
	_initiateTS()
	PrintChat("<font color='#40FF00'> >> "..CurName.." v."..CurVer.." - loaded</font>")
end


function OnUnLoad()


end


function OnTick()
	_check_mmasac()
	if myHero.dead then return end
		_update()
		_interupt()
		autofarm()
		_OrbWalk()		
		_castcore()
		_harrasscore()
	
end


function OnDraw()
	_drawstartsprite()
	if myHero.dead then return end
	_draw_ranges()
	_draw_tarinfo()
	--_drawpreddmg()	
end


function OnCreateObj()


end


function OnDeleteObj()


end


function OnProcessSpell(object, spell)
	if object == myHero then
		if spell.name:lower():find("attack") then
			lastAttack = GetTickCount() - GetLatency()/2
			lastWindUpTime = spell.windUpTime*1000
			lastAttackCD = spell.animationTime*1000
		end 
	end
	if object.team ~= myHero.team and object.type == myHero.type then
		LastCastedSpell[object.networkID] = {name = spell.name:lower(), time = os.clock(), caster = object}
	end
end


function OnRecvPacket()

end


function OnSendPacket()

end

function OnGainBuff(unit, buff)----Menu.specl.whit==1/2 (stunned, predicted)
	if ValidTarget(unit) and unit.type == "obj_AI_Hero" and GetDistance(unit) < Wrange and Menu.specl.whit == 1 then
		if buff.name == "Stun" then	
	--	print('uniiit found')		
				_castSpell(_W, unit.x, unit.z, nil)		
		end
	end
end

 

function OnUpdateBuff(unit, buff)

end

 

function OnLoseBuff(unit, buff)

end

--[[       ----------------------------------------------------------------------------------------------       ]]--
--[[					     	 		    	    Core Functions		 	  	   								]]--
--[[       ----------------------------------------------------------------------------------------------       ]]--





function _castpredictedW(target) 
--print('cast predicted W')
	if Menu.ta.co == 1 then	 --FREEPrediction
		if ValidTarget(target) then				
			local Position = FreePredictionW:GetPrediction(target)
			if Position ~= nil then
				_castSpell(_W, Position.x, Position.z, nil)
			end
		end
	end	 --//FREEPrediction

	
	if Menu.ta.co == 2 and VIP_USER then --VIPPrediction
		if ValidTarget(target) then					
			local Position = VipPredictionW:GetPrediction(target)
			if Position ~= nil then
				_castSpell(_W, Position.x, Position.z, nil)		
			end
		end
	end	--//VIPPrediction

	
	if Menu.ta.co == 3 and vpredicfile then --VPrediction 	
		if ValidTarget(target, Wrange) then 	
		--print('castW: '..)
			--Menu.specl.whit==1/2 (stunned, predicted)
			local overhit = 5
			if Menu.specl.whit == 1 then 
				 overhit = 3
			else
				 overhit = 2
			end
			local CastPosition,  HitChance,  Position = VP:GetCircularCastPosition(target, Wdelay, Wwidth, Wrange, Wspeed, myHero, false)
			if CastPosition ~= nil and HitChance >= overhit  then
				_castSpell(_W, CastPosition.x, CastPosition.z, nil)	
			end
		end	
	end--//VPrediction

	
	if Menu.ta.co == 4 and prodicfile and Menu.specl.whit == 2 then --prOdiction	
	--Menu.specl.whit==1/2 (stunned, predicted)
	
	--print('prodiction W')
		if ValidTarget(target) then	
			Position = ProdictionW:GetPrediction(target)
			--print('prodiction W 2')
			if Position ~= nil  then			
			--print('prodiction W 3')
				_castSpell(_W, Position.x, Position.z, nil)		
			end
		end	

	end--//prOdiction
	
end

function _interupt()
	if myHero:CanUseSpell(_W) == READY then
		for i, spell in ipairs(spells) do
			if Menu.AutoInterrupt[spell.name] then
				for j, LastCast in pairs(LastCastedSpell) do
					if LastCast.name == spell.name:lower() and (os.clock() - LastCast.time) < 3 and GetDistance(LastCast.caster.visionPos, myHero.visionPos) < Erange + 330 and ValidTarget(LastCast.caster) then
						 _castprodictedE(LastCast.caster)
						break
					end
				end
			end
		end
	end
end




function _castprodictedE(target)
if not ValidTarget(target) then return end
local predCastPos = nil

	if Menu.ta.co == 1 then	 --FREEPrediction
		local Position = FreePredictionW:GetPrediction(target)
		if Position ~= nil then
			predCastPos = Position
		end	
	end	 --//FREEPrediction

	
	if Menu.ta.co == 2 and VIP_USER then --VIPPrediction
		local Position = VipPredictionW:GetPrediction(target)
		if Position ~= nil then
			predCastPos = Position		
		end
	end	--//VIPPrediction

	
	if Menu.ta.co == 3 and vpredicfile then --VPrediction 
		--local CastPosition,  HitChance,  Position = VP:GetCircularCastPosition(target, Edelay, Ewidth, Erange, Espeed, myHero, false)
		local CastPosition,  HitChance,  Position = VP:GetLineCastPosition(target, Edelay, Ewidth, Erange, Espeed, myHero, false)
		if CastPosition ~= nil and HitChance >= 2  then
			predCastPos = CastPosition
			
			drawtarget =target
		end
	end--//VPrediction

	
	if Menu.ta.co == 4 and prodicfile then --prOdiction
		Position = ProdictionE:GetPrediction(target)
		if Position ~= nil then
			predCastPos = Position		
		end
	end--//prOdiction	
		
	--cast
	
	if predCastPos ~= nil then 
	
		Cage = Vector(math.sign(predCastPos.x-myHero.x)*math.cos(math.atan(math.abs(predCastPos.z-myHero.z)/math.abs(predCastPos.x-myHero.x)))*(GetDistance(predCastPos) - 330)+myHero.x,myHero.y,math.sign(predCastPos.z-myHero.z)*math.sin(math.atan(math.abs(predCastPos.z-myHero.z)/math.abs(predCastPos.x-myHero.x)))*(GetDistance(predCastPos) - 330)+myHero.z)
		drawpos = Cage
		--print('distance to cagepos: '..GetDistance(Cage))
		if GetDistance(Cage) <= 599 then
			_castSpell(_E, Cage.x, Cage.z, nil)
		end
	end



end

function math.sign(x)
if x < 0 then
	return -1
elseif x > 0 then return 1 
else return 0 
end 
end

function autofarm()
---Menu.harrass.autohrsQ
--[[
				Menu.specl:addParam("qfarm", "Auto Q Farm", SCRIPT_PARAM_ONOFF, false)
				Menu.specl:addParam("qfarmprio", "If Q Farm", SCRIPT_PARAM_LIST, 1, { "Only Farm", "Farm > Harrass", "Harrass > Farm" })
				Menu.specl:addParam("qfarmslider", "Farm Q until Mana",  SCRIPT_PARAM_SLICE, 50, 0, 100, 0)
				
				]]
if (Menu.keys.permrota or Menu.keys.okdrota) then return end
if mynamaislowerthen(Menu.specl.qfarmslider) then return end
if not Menu.specl.qfarm then return end
--print('behind ends')
local qhrson = false
if (Menu.keys.permhrs or Menu.keys.okdhrs) and Menu.harrass.autohrsQ then
	qhrson = true
else
	qhrson = false
end
--print('before combos')
	if Menu.specl.qfarmprio == 3 and qhrson then
		_castSpell(_Q, nil, nil, _gettargetwithworstmres(Qrange))
	end
	if (Menu.specl.qfarmprio == 3 or Menu.specl.qfarmprio == 2 or Menu.specl.qfarmprio == 1) and (myHero:CanUseSpell(_Q) == READY) then
			for m = 1, objManager.maxObjects do
				local minion = objManager:GetObject(m)
				if minion ~= nil and minion.name:find("Minion_") and minion.team ~= myHero.team and minion.dead == false and GetDistance(minion) < Qrange then
					if getDmg("Q", minion, myHero) > minion.health then
						CastSpell(_Q,minion)
					end
				end
			end	
	end
	
	if Menu.specl.qfarmprio == 2 then
			for m = 1, objManager.maxObjects do
				local minion = objManager:GetObject(m)
				if minion ~= nil and minion.name:find("Minion_") and minion.team ~= myHero.team and minion.dead == false and GetDistance(minion) < Qrange then
					if getDmg("Q", minion, myHero) > minion.health then
						CastSpell(_Q,minion)
					end
				end
			end	
	end
	if Menu.specl.qfarmprio == 2 and (myHero:CanUseSpell(_Q) == READY) then
		_castSpell(_Q, nil, nil, _gettargetwithworstmres(Qrange))
	end

end


function _castcore()
--if (Menu.keys.permrota or Menu.keys.okdrota or Menu.keys.permhrs or Menu.keys.okdhrs ) and predQPos~=nil then
if not (Menu.keys.permrota or Menu.keys.okdrota) then return end
local DidCombo = false

	
if ValidTarget(Target, Qrange) and canQrota then
	if comboQ ~= nil then
		if Target.health < comboQ  then
			_castSpell(_Q, nil, nil, Target)
			DidCombo = true
		end	
	end
	
	if DFGReady then
		if Target.health < DfgDmg  then
			_castSpell(DFGslot, nil, nil, Target)
			DidCombo = true
		end
	end
	
	if comboQ ~= nil and DFGReady and canQrota then
		if Target.health < (DfgDmg + (1.2 * comboQ)) then
			_castSpell(DFGslot, nil, nil, Target)
			_castSpell(_Q, nil, nil, Target)
			DidCombo = true
		end	
	end
	
	if comboQW ~= nil and canQrota and canWrota then
		if Target.health < comboQW then
			_castSpell(_Q, nil, nil, Target)
			_castpredictedW(Target)
			_castprodictedE(Target)
			DidCombo = true
		end
	end
	
	if comboQW ~= nil and DFGReady and canQrota and canWrota then
		if Target.health < (DfgDmg + (1.2 * comboQW)) then
			_castSpell(DFGslot, nil, nil, Target)
			_castSpell(_Q, nil, nil, Target)
			_castpredictedW(Target)
			_castprodictedE(Target)
			DidCombo = true
		end
	end
	
	if comboQWR ~= nil and canQrota and canWrota and canRrota then
		if Target.health < comboQWR then
			_castSpell(_Q, nil, nil, Target)
			_castpredictedW(Target)
			_castprodictedE(Target)
			_castSpell(_R, nil, nil, Target)			
			DidCombo = true
		end
	end
	
	if comboQWR ~= nil and DFGReady and canQrota and canWrota and canRrota then
		if Target.health < (DfgDmg + (1.2 * comboQWR)) then
			_castSpell(DFGslot, nil, nil, Target)
			_castSpell(_Q, nil, nil, Target)
			_castpredictedW(Target)
			_castprodictedE(Target)
			_castSpell(_R, nil, nil, Target)
			DidCombo = true
		end
	end

	if comboR ~= nil and canRrota then
		if Target.health < comboR then
			_castSpell(_R, nil, nil, Target)
			DidCombo = true
		end
	end
	
	if comboR ~= nil and DFGReady and canRrota then
		if Target.health - (DfgDmg + (1.2 * comboR)) then
			_castSpell(DFGslot, nil, nil, Target)
			_castSpell(_R, nil, nil, Target)
			DidCombo = true
		end
	end
end


if not DidCombo then
--print('no combo')
	if EReady and canErota then _castprodictedE(_gettargetwithworstmres(1000)) end
	if DFGReady then _castSpell(DFGslot, nil, nil, _gettargetwithworstmres(DFGrange)) end
	if QReady and canQrota then _castSpell(_Q, nil, nil, _gettargetwithworstmres(Qrange)) end
	if WReady and canWrota then
	--print('W nocomboW2')
	_castpredictedW(_gettargetwithworstmres(Wrange))
	 
	end
	end
end

function _harrasscore()
if not (Menu.keys.permhrs or Menu.keys.okdhrs) then return end

		
	if Menu.harrass.autohrsQ and canQhrs then
		_castSpell(_Q, nil, nil, _gettargetwithworstmres(Qrange))
	end
	if Menu.harrass.autohrsW and canWhrs then
		_castpredictedW(_gettargetwithworstmres(Wrange))
	end
	if Menu.harrass.autohrsE and canWhrs then
		_castprodictedE(_gettargetwithworstmres(1000))
	end
	if Menu.harrass.autohrsR and canRhrs then
		_castSpell(_R, nil, nil, _gettargetwithworstmres(Rrange))
	end

end

function _gettargetwithworstmres(range)
local magicresist, poorunit = 5000, nil
	for i, currenemy in pairs(GetEnemyHeroes()) do
		if GetDistance(currenemy) < range and currenemy.dead==false and ValidTarget(currenemy, range) and currenemy.magicArmor < magicresist then				
			poorunit = currenemy
			magicresist = currenemy.magicArmor				
        end
	end	
	return poorunit
end

function _calc_combo_dmg(target)
--[[
local comboQ, comboQW, comboQWR, comboQR = nil, nil, nil, nil

local QReady, WReady, EReady, RReady, DFGReady = false, false, false, false, false
]]

	if QReady then
		comboQ = math.round(getDmg("Q", target, myHero))
	else
		comboQ = nil
	end
	
	if QReady and WReady then
		comboQW = (math.round(getDmg("Q", target, myHero)) + math.round(getDmg("W", target, myHero)))
	else
		comboQW = nil
	end
	
	if QReady and WReady and RReady then
		comboQWR = (math.round(getDmg("Q", target, myHero)) + math.round(getDmg("W", target, myHero)) + math.round(getDmg("R", target, myHero)))
	else
		comboQWR = nil
	end
	
	if QReady and RReady then
		comboQR = (math.round(getDmg("Q", target, myHero)) + math.round(getDmg("R", target, myHero)))
	else
		comboQR = nil
	end
	if DFGReady then 
		DfgDmg = math.round(getDmg("DFG", target, myHero))
	else
		DfgDmg = nil
	end
	if RReady then
		comboR = math.round(getDmg("R", target, myHero))
	else
		comboR = nil
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
	DFGslot = GetInventorySlotItem(3128)
	if DFGslot ~=nil then 
		if player:CanUseSpell(DFGslot) == READY then
			DFGReady = true
		else
			DFGReady = false
		end
	else
		DFGReady = false
	end
		
	myTrueRange = myHero.range + (GetDistance(myHero.minBBox) - 5)
	Target = _getTarget()
	drawtar = Target
	_autoskill()
	_checkcancastHRS()
	_checkcancastROTA()
	if Target ~= nil and ValidTarget(Target) then _calc_combo_dmg(Target) end
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
--canQ, canW, canE, canR
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
--		Menu.manamenu.manarota:addParam("manae", "E ManaManager", SCRIPT_PARAM_ONOFF, true)
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
	if drawtar~=nil and ValidTarget(drawtar, 2000) then	
		if Menu.draw.prdraw.enemyline and ValidTarget(drawtar) then		
			DrawLine3D(myHero.x, myHero.y, myHero.z, drawtar.x, drawtar.y, drawtar.z, 10, ARGB(250,235,33,33))
		end	
		if Menu.draw.prdraw.enemy and ValidTarget(drawtar) then
			DrawCircle(drawtar.x, drawtar.y, drawtar.z, 100, ARGB(250, 253, 33, 33))
		end
	end
end


function _drawpreddmg()
	if not Menu.draw.prdraw.predmg then return end	
	local currLine = 1
	for i, enemy in ipairs(GetEnemyHeroes()) do	
		--local enemy= GetMyHero()
		if enemy~=nil and ValidTarget(enemy, 2500) then		
	
				if QReady then
				
					DrawLineHPBar(dmgQ(enemy), currLine, "Q: "..dmgQ(enemy), enemy)
					currLine = currLine + 1
				end	
				if WReady then
					DrawLineHPBar(dmgW(enemy), currLine, "W: "..dmgW(enemy), enemy)
					currLine = currLine + 1
				end		
				if DFGReady then
					DrawLineHPBar(dmgDFG(enemy), currLine, "DFG: "..dmgDFG(enemy), enemy)
					currLine = currLine + 1
				end					
				if QReady and WReady then
					DrawLineHPBar((dmgQ(enemy)+dmgW(enemy)), currLine, "QW: "..(dmgQ(enemy)+dmgW(enemy)), enemy)
					currLine = currLine + 1
				end
				if QReady and RReady then
					DrawLineHPBar((dmgQ(enemy)+dmgR(enemy)), currLine, "QR: "..(dmgQ(enemy)+dmgR(enemy)), enemy)
					currLine = currLine + 1
				end
				if QReady and WReady and RReady and not DFGReady then
					DrawLineHPBar((dmgQ(enemy)+dmgR(enemy)+dmgW(enemy)), currLine, "QWR: "..(dmgQ(enemy)+dmgR(enemy)+dmgW(enemy)), enemy)
					currLine = currLine + 1
				end
				if QReady and WReady and RReady and DFGReady then
					DrawLineHPBar((((dmgQ(enemy)+dmgR(enemy)+dmgW(enemy))*1.2)+dmgDFG(enemy)), currLine, "QWR+DFG: "..(((dmgQ(enemy)+dmgR(enemy)+dmgW(enemy))*1.2)+dmgDFG(enemy)), enemy)
					currLine = currLine + 1
				end
				
			--EnemyDummy
			---	DrawLineHPBar(0, 10, "TEST ZERO ", enemy) --dummy for calibration 
			---	DrawLineHPBar(myHero.maxHealth*0.5, 11, "TEST 50% ", enemy) --dummy for calibration
			---	DrawLineHPBar(myHero.maxHealth, 12, "TEST 100% ", enemy) --dummy for calibration
			

			end
		end		
		
			--SelfDummy - SelfOffsets=/=EnemyOffsets
			DrawLineHPBar(0, 10, "TEST ZERO ", GetMyHero()) --dummy for calibration 
			DrawLineHPBar(myHero.maxHealth*0.5, 11, "TEST 50% ", GetMyHero()) --dummy for calibration
			DrawLineHPBar(myHero.maxHealth, 12, "TEST 100% ", GetMyHero()) --dummy for calibration
end


function dmgQ(target)
    local myQDmg = getDmg("Q", target, myHero)
    return math.round(myQDmg)
end

function dmgW(target)
    local myWDmg = getDmg("W", target, myHero)
    return math.round(myWDmg)
end

function dmgR(target)
    local myRDmg = getDmg("R", target, myHero)
    return math.round(myRDmg)
end

function dmgDFG(target) 
    local myDFGDmg = getDmg("DFG", target, myHero)
    return math.round(myDFGDmg)
end

function GetHPBarPos(enemy) --DONE
	enemy.barData = GetEnemyBarData()
	local barPos = GetUnitHPBarPos(enemy)
	local barPosOffset = GetUnitHPBarOffset(enemy)
	local barOffset = { x = enemy.barData.PercentageOffset.x, y = enemy.barData.PercentageOffset.y }
	local barPosPercentageOffset = { x = enemy.barData.PercentageOffset.x, y = enemy.barData.PercentageOffset.y }
	local BarPosOffsetX = 171
	local BarPosOffsetY = 46
	local CorrectionY =  0
	local StartHpPos = 31
	barPos.x = barPos.x + (barPosOffset.x - 0.3225 + barPosPercentageOffset.x) * BarPosOffsetX + StartHpPos
	barPos.y = barPos.y + (barPosOffset.y - 0.5 + barPosPercentageOffset.y) * BarPosOffsetY + CorrectionY 						
	local StartPos = Vector(barPos.x , barPos.y, 0)
	local EndPos =  Vector(barPos.x + 108 , barPos.y , 0)
	return Vector(StartPos.x, StartPos.y, 0), Vector(EndPos.x, EndPos.y, 0)
end


function DrawLineHPBar(damage, line, text, unit) --DONE
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
	--math.round(255*((unit.health-damage)/unit.maxHealth))
	--math.round(NUMBER)
	--ARGB(255,7,255,7)
	DrawLine(Offs_X-150, StartPos.y-(30+(line*15)), Offs_X-150, StartPos.y-2, 2, ARGB(mytrans, 255,my_bluepart,0))
	DrawText(tostring(text),15,Offs_X-148,StartPos.y-(30+(line*15)),ARGB(mytrans, 255,my_bluepart,0))  --ARGB(mytrans, 255,255,255)
end

--Menu.extra.ex:addParam("packetcast", "Casting", SCRIPT_PARAM_LIST, 1, { "Regular", "NoFace(P)", "Packets" })
function _castSpell(TSPELL, TSPELLX, TSPELLZ, TUNIT) --DONE
	if TUNIT~=nil and TSPELLX==nil and TSPELLZ==nil then --targetted
		if Menu.extra.ex.packetcast == 1 then	
			CastSpell(TSPELL, TUNIT)
		end
		if (Menu.extra.ex.packetcast == 2 or Menu.extra.ex.packetcast == 3) then
			_CastSpellOverPacket(TSPELL, nil, nil, TUNIT)
		end
	end
	if TUNIT==nil and TSPELLX~=nil and TSPELLZ~=nil then --skillshot
		if Menu.extra.ex.packetcast == 1 then
			CastSpell(TSPELL, TSPELLX, TSPELLZ)
		end
		if (Menu.extra.ex.packetcast == 2 or Menu.extra.ex.packetcast == 3) then
			_CastSpellOverPacket(TSPELL, TSPELLX, TSPELLZ, nil)
		end
	end
end


--[[
	_CastSpellOverPacket(_Q, PosX, PosZ, nil) --skillshot
	_CastSpellOverPacket(_Q, nil, nil, CUnit) --targeted
]]
function _CastSpellOverPacket(mySpell, PosX, PosZ, CUnit) --DONE
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


function _check_mmasac() --DONE
	if GetInGameTimer() >= 20 and GetInGameTimer()<= 21 then
		PrintFloatText(myHero, 9, "Lil' Veigar - by Bilbao")
	end
	if checkedMMASAC then return end
	if not (starttick + 5000 < GetTickCount()) then return end
	checkedMMASAC = true
    if _G.MMA_Loaded then
     	print(' >> MMA found. MMA support loaded.')
		is_MMA = true
	else
		print(' >>'..CurName..': MMA not found')
	end	
	if _G.AutoCarry then
		print(' >>'..CurName..': SAC found. SAC support loaded.')
		is_SAC = true
	else
		print(' >>'..CurName..': SAC not found.')
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
			print(' >>'..CurName..': VipPrediction and Prodiction loaded.')
		end
		if prodicfile and vpredicfile then
			print(' >>'..CurName..': VipPrediction, Prodiction and VPrediction loaded.')
		end
	else
		print(' >>'..CurName..': FreeUser Prediction loaded.')
	end
	if VIP_USER then
		print(' >>'..CurName..': VIP Menu loaded.')
	else
		print(' >>'..CurName..': FreeUser Menu loaded.')
	end	 
end


--[[ SAC
	AutoCarry.Orbwalker = nil
	AutoCarry.SkillsCrosshair = nil
	AutoCarry.CanMove = true
	AutoCarry.CanAttack = true
	AutoCarry.MainMenu = nil
	AutoCarry.PluginMenu = nil
	AutoCarry.EnemyTable = nil
	AutoCarry.shotFired = false
	AutoCarry.OverrideCustomChampionSupport = false
	AutoCarry.CurrentlyShooting = false
]]
--[[ MMA
    _G.MMA_Loaded // Boolean
    _G.MMA_AttackAvailable //Boolean
    _G.MMA_AbleToMove //Boolean
    _G.MMA_NextAttackAvailability // from 0 to 1, percentage of next attack
    _G.MMA_ForceTarget // Unit object, with this you can force MMA target selector to select a different target, for ex.: AllClass TS target
    _G.MMA_Target //Currently selected target (unit object)
    _G.MMA_Orbwalker, _G.MMA_HybridMode, _G.MMA_LaneClear, _G.MMA_LastHit //Boolean, indicates what mode is active.
    _G.MMA_ConsideredTarget(range) //function, returns MMA considered target(unit) from custom range.
    _G.MMA_ResetAutoAttack() //function, forces MMA to think that your attack is available.
]]


function _load_menu()
	Menu = scriptConfig(""..CurName, "bilbao")
	
	
		-----------------------------------------------------------------------------------------------------
		Menu:addSubMenu("Drawing", "draw")
			Menu.draw:addSubMenu("Prediction&Co", "prdraw")
				Menu.draw.prdraw:addParam("enemy", "Mark Enemy", SCRIPT_PARAM_ONOFF, true)
				Menu.draw.prdraw:addParam("enemyline", "Line2Enemy", SCRIPT_PARAM_ONOFF, true)
				--Menu.draw.prdraw:addParam("predmg", "Draw Predicted Dmg", SCRIPT_PARAM_ONOFF, true)				
		-----------------------------------------------------------------------------------------------------

		-----------------------------------------------------------------------------------------------------
			Menu.draw:addSubMenu("Ranges", "drawsub2") --DONE
				Menu.draw.drawsub2:addParam("drawaa", "Draw AARange", SCRIPT_PARAM_ONOFF, true)
				Menu.draw.drawsub2:addParam("drawQ", "Draw QRange", SCRIPT_PARAM_ONOFF, true)
				Menu.draw.drawsub2:addParam("drawW", "Draw WRange", SCRIPT_PARAM_ONOFF, true)
				Menu.draw.drawsub2:addParam("drawE", "Draw ERange", SCRIPT_PARAM_ONOFF, true)
				Menu.draw.drawsub2:addParam("drawR", "Draw RRange", SCRIPT_PARAM_ONOFF, true)
		-----------------------------------------------------------------------------------------------------

		
		-----------------------------------------------------------------------------------------------------
		Menu:addSubMenu("Harrass", "harrass")			
			Menu.harrass:addParam("autohrsQ", "Auto Use Q", SCRIPT_PARAM_ONOFF, true)
			Menu.harrass:addParam("autohrsW", "Auto Use W", SCRIPT_PARAM_ONOFF, true)
			Menu.harrass:addParam("autohrsE", "Auto Use E", SCRIPT_PARAM_ONOFF, true)
			Menu.harrass:addParam("autohrsR", "Auto Use R", SCRIPT_PARAM_ONOFF, true)
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
				Menu.manamenu.manahrs:addParam("manaq", "Q ManaManager", SCRIPT_PARAM_ONOFF, true) 
				Menu.manamenu.manahrs:addParam("sliderq", "Use Q only if mana over %",  SCRIPT_PARAM_SLICE, 50, 0, 100, 0) 
				Menu.manamenu.manahrs:addParam("manaw", "W ManaManager", SCRIPT_PARAM_ONOFF, true)
				Menu.manamenu.manahrs:addParam("sliderw", "Use W only if mana over %",  SCRIPT_PARAM_SLICE, 50, 0, 100, 0)
				Menu.manamenu.manahrs:addParam("manae", "E ManaManager", SCRIPT_PARAM_ONOFF, true)
				Menu.manamenu.manahrs:addParam("slidere", "Use E only if mana over %",  SCRIPT_PARAM_SLICE, 50, 0, 100, 0)
				Menu.manamenu.manahrs:addParam("manar", "R ManaManager", SCRIPT_PARAM_ONOFF, true)
				Menu.manamenu.manahrs:addParam("sliderr", "Use R only if mana over %",  SCRIPT_PARAM_SLICE, 50, 0, 100, 0)
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
			Menu.keys:addParam("okdhrs", "OnKeyDown Harrass", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("C"))
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
					Menu.ta.basic:addParam("basicstatus", "Use BasicTS&Orbwalk", SCRIPT_PARAM_ONOFF, false)
					
				Menu.ta:addParam("orb", "Orbwalk", SCRIPT_PARAM_LIST, 1, { "COMBO", "ALWAYS", "NEVER" })
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
				
			Menu:addSubMenu("Auto-Interrupt", "AutoInterrupt")
				for i, spell in ipairs(spells) do
					Menu.AutoInterrupt:addParam(spell.name, spell.menuname, SCRIPT_PARAM_ONOFF, true)
				end
				
			Menu:addSubMenu("Special", "specl")			
				Menu.specl:addParam("whit", "Cast W", SCRIPT_PARAM_LIST, 1, { "Only on stunned", "predicted pos" }) 
				Menu.specl:addParam("qfarm", "Auto Q Farm", SCRIPT_PARAM_ONOFF, false)
				Menu.specl:addParam("qfarmprio", "If Q Farm", SCRIPT_PARAM_LIST, 1, { "Only Farm", "Farm > Harrass", "Harrass > Farm" })
				Menu.specl:addParam("qfarmslider", "Farm Q until Mana",  SCRIPT_PARAM_SLICE, 50, 0, 100, 0)
				
		-----------------------------------------------------------------------------------------------------
		Menu:addParam("info", " >> created by Bilbao", SCRIPT_PARAM_INFO, "")
		Menu:addParam("info2", " >> Version "..CurVer, SCRIPT_PARAM_INFO, "")
		_setimpdef()
		--startsprite = GetWebSprite("http://th02.deviantart.net/fs70/200H/f/2013/145/c/6/hot_girl_png_by_xyeddanishali-d66jmde.png")
		startsprite = GetWebSprite("http://puu.sh/7MOvc.png")
		
end
	if GetInGameTimer() >= 20 and GetInGameTimer()<= 21 then
		PrintFloatText(myHero, 9, CurName.." v."..CurVer.." - loaded")
	end
function _drawstartsprite()
	if startsprite and GetInGameTimer() >= 1 and GetInGameTimer() <= 20 then
		--startsprite:SetScale(0.4, 0.4)		
		local chPos =  WorldToScreen(D3DXVECTOR3(myHero.x, myHero.y, myHero.z))	   
		startsprite:Draw(WINDOW_W*0.84, WINDOW_H*0.43, 255)		
	end
end


function _initiateTS()
	ts = TargetSelector(TARGET_PRIORITY, 1525) --Rrange
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
	if prodicfile then --initiate paidprOdiction
		--require "Prodiction"		--not needed anymore
		Prodiction = ProdictManager.GetInstance()
	--	ProdictionQ = Prodiction:AddProdictionObject(_Q, Qrange, Qspeed, Qdelay, Qwidth)
		ProdictionW = Prodiction:AddProdictionObject(_W, Wrange, Wspeed, Wdelay, Wwidth)
		ProdictionE = Prodiction:AddProdictionObject(_E, Erange, Espeed, Edelay, Ewidth)
	--	ProdictionR = Prodiction:AddProdictionObject(_R, Rrange, Rspeed, Rdelay, Rwidth)
		
		--[[
		local collision = GetMinionCollision(pStart, pEnd)    coliision kann true or false sein
		GetHeroCollision(pStart, pEnd, mode)
		GetCollision(pStart, pEnd)
		DrawCollision(pStart, pEnd)
		]]
		
		--[[
			local coll = Collision(Qrange, Qspeed, Qdelay, Qwidth)
			if not coll:GetMinionCollision(predQPos, myHero) then
				keine collision
			end
		]]
		
	--	collQ = Collision(Qrange, Qspeed, Qdelay, Qwidth)
	--	collW = Collision(Wrange, Wspeed, Wdelay, Wwidth)
	--	collE = Collision(Erange, Espeed, Edelay, Ewidth)
	--	collR = Collision(Rrange, Rspeed, Rdelay, Rwidth)
		
	end
	if vpredicfile then --initiate VPprediction
		--require "VPrediction"		
		VP = VPrediction()	
	end
	if VIP_USER then --initiate VIPPrediction
	--		VipPredictionQ = TargetPredictionVIP(Qrange, Qspeed, Qdelay, Qwidth, myHero)
			VipPredictionW = TargetPredictionVIP(Wrange, Wspeed, Wdelay, Wwidth, myHero)
			VipPredictionE = TargetPredictionVIP(Erange, Espeed, Edelay, Ewidth, myHero)
	--		VipPredictionR = TargetPredictionVIP(Rrange, Rspeed, Rdelay, Rwidth, myHero)
	end
	-- --initiate FreePredition always cuz every can use it
	--	FreePredictionQ = TargetPrediction(Qrange, Qspeed, Qdelay, Qwidth)	
		FreePredictionW = TargetPrediction(Wrange, Wspeed, Wdelay, Wwidth)
		FreePredictionE = TargetPrediction(Erange, Espeed, Edelay, Ewidth)
	--	FreePredictionR = TargetPrediction(Rrange, Rspeed, Rdelay, Rwidth)		
end	


	
	
	
