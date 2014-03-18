if myHero.charName ~= "Leona" then return end


--[[       ----------------------------------------------------------------------------------------------       ]]--
--[[							Leona the Radiant Dawn - by Bilbao					 	                ]]--
--[[       ----------------------------------------------------------------------------------------------       ]]--
--[[	----------	]]--
--[[	17.03.2014	]]--
--[[	v. 0.9		]]--
--[[	----------	]]--






--[[       ----------------------------------------------------------------------------------------------       ]]--
--[[					     	 		     	     Basic Information	   	      								]]--
--[[       ----------------------------------------------------------------------------------------------       ]]--
	local CurVer = 0.9
	print("<font color='#FF0000'>>></font> <font color='#FF4000'>Leona the Radiant Dawn v"..CurVer.." by Bilbao loaded.</font>")
	Recalling = false
	txtonme = "test"
	
	local prodic = false
	local prodicfile = false
	
	local vpredicfile = false	
	local vpredic = false
	local vpredhitE = 0
	local vpredhitR = 0
	
	local freevippredic = false
	local freevippredicfile = false
	
	local freepredic = false
	local freepredicfile = true
		
	local Target = nil
	-------Skills info-------
	Qrange, Qspeed, Qdelay, Qwidth = 215, 20000, 0, 0
	Wwidth = 500
	Erange, Espeed, Edelay, Ewidth = 875, 1200, 0.5, 80
	Rrange, Rspeed, Rdelay, Rwidth, Rnuke = 1200, 20000, 0.7, 315, 115
	-------/Skills info-------
	
	-------OnDraw info-------
	currentEpos = nil
	currentRpos = nil
	-------/OnDraw info-------
	
	-------Spell status-------
	QReady, WReady, EReady, RReady = false, false, false, false	
	-------/Spell status-------

	
--[[       ----------------------------------------------------------------------------------------------       ]]--
--[[					     	 		     	     Callbacks		 	  	      								]]--
--[[       ----------------------------------------------------------------------------------------------       ]]--
	
function PluginOnLoad()
_initmenu()
end



function PluginOnTick()
--	ProdictManager.status-- 0 <- error,  1 <- free user , 2 <- Donated user
	--if Prodiction.status == 0 then Menu.co.addParam("test", "error", SCRIPT_PARAM_INFO, "") end
	--if Prodiction.status == 1 then Menu.co.addParam("testt", "free user prodic", SCRIPT_PARAM_INFO, "") end
	--if Prodiction.status == 2 then Menu.co.addParam("testtt", "paidpro", SCRIPT_PARAM_INFO, "") end
	--if  PaidUser then Menu.co.addParam("testt", "free user prodic", SCRIPT_PARAM_INFO, "") end
	_update()
	_smartcore()
end

function PluginOnDraw()

--DrawText(tostring(" "..txtonme),30,450,125,ARGB(255,248,255,20))


if Menu.draw.drawE then
DrawCircle(myHero.x, myHero.y, myHero.z, Erange, ARGB(24,255,7,7))
end

if Menu.draw.drawR then
DrawCircle(myHero.x, myHero.y, myHero.z, Rrange, ARGB(25,7,7,255))
end


    if currentEpos then
		if Menu.draw.drawEposway then
			--DrawArrows(Target, currentEpos, 2, ARGB(255,255,7,7))
		end
		if Menu.draw.Epos then
			DrawCircle(currentEpos.x, currentEpos.y, currentEpos.z, 100, ARGB(255,255,7,7))
		end
    end
	
	if currentRpos then
		if Menu.draw.drawRposway then
			--DrawArrows(Target, currentRpos, 2, ARGB(255,7,7,255))
		end
	if Menu.draw.Rpos then
        DrawCircle(currentRpos.x, currentRpos.y, currentRpos.z, 100, ARGB(255,7,7,255))
	end
    end


end

function PluginOnCreateObj(object)

end

function PluginOnDeleteObj(object)

end	


function EOnDashFunc(unit, pos, spell)
    if GetDistance(pos) < Erange and myHero:CanUseSpell(spell.Name) == READY then
        CastSpell(spell.Name, pos.x, pos.z)
    end
end

function EAfterDashFunc(unit, pos, spell)
    if GetDistance(pos) < Erange and myHero:CanUseSpell(spell.Name) == READY then
        CastSpell(spell.Name, pos.x, pos.z)
    end
end

function EOnImmobileFunc(unit, pos, spell)
    if GetDistance(pos) < Erange and myHero:CanUseSpell(spell.Name) == READY then
        CastSpell(spell.Name, pos.x, pos.z)
    end
end

function EAfterImmobileFunc(unit, pos, spell)
    if GetDistance(pos) < Erange and myHero:CanUseSpell(spell.Name) == READY then
        CastSpell(spell.Name, pos.x, pos.z)
    end
end
		
	
	
	
function ROnDashFunc(unit, pos, spell)
    if Menu.co.rs.ondash and GetDistance(pos) < Rrange and myHero:CanUseSpell(spell.Name) == READY then
        CastSpell(spell.Name, pos.x, pos.z)
    end
end

function RAfterDashFunc(unit, pos, spell)
    if Menu.co.rs.afterdash and GetDistance(pos) < Rrange and myHero:CanUseSpell(spell.Name) == READY then
        CastSpell(spell.Name, pos.x, pos.z)
    end
end

function ROnImmobileFunc(unit, pos, spell)
    if Menu.co.rs.onimmo and GetDistance(pos) < Rrange and myHero:CanUseSpell(spell.Name) == READY then
        CastSpell(spell.Name, pos.x, pos.z)
    end
end

function RAfterImmobileFunc(unit, pos, spell)
    if Menu.co.rs.afterimmo and GetDistance(pos) < Rrange and myHero:CanUseSpell(spell.Name) == READY then
        CastSpell(spell.Name, pos.x, pos.z)
    end
end	

function QOnDashFunc(unit, pos, spell)
    if GetDistance(pos) < Qrange and myHero:CanUseSpell(spell.Name) == READY then
        CastSpell(spell.Name)
		player:Attack(unit)
    end
end

function QAfterDashFunc(unit, pos, spell)
    if GetDistance(pos) < Qrange and myHero:CanUseSpell(spell.Name) == READY then
        CastSpell(spell.Name)
		player:Attack(unit)
    end
end

function QOnImmobileFunc(unit, pos, spell)
    if GetDistance(pos) < Qrange and myHero:CanUseSpell(spell.Name) == READY then
        CastSpell(spell.Name)
		player:Attack(unit)
    end
end

function QAfterImmobileFunc(unit, pos, spell)
    if GetDistance(pos) < Qrange and myHero:CanUseSpell(spell.Name) == READY then
        CastSpell(spell.Name)
		player:Attack(unit)
    end
end		

--[[       ----------------------------------------------------------------------------------------------       ]]--
--[[					     	 		    	    Core				 	  	   								]]--
--[[       ----------------------------------------------------------------------------------------------       ]]--

function _smartcore()

if ValidTarget(Target) and GetDistance(Target) < Qrange and QReady and (Menu.co.q == 1 or Menu.co.eq or Menu.co.eqr) then
	CastSpell(_W)
	_castQ()
	player:Attack(Target)
end

if Menu.ta.co == 1 then --FREEPrediction
--txtonme="M1"
if ValidTarget(Target) then
	local Position = Efreepredic:GetPrediction(Target)
	if Position ~= nil then
		currentEpos = Position
	else
		currentEpos = nil
	end
else
	currentEpos = nil
end
if ValidTarget(Target) then
	local Position = Rfreepredic:GetPrediction(Target)
	if Position ~= nil then
		currentEpos = Position
	else
		currentEpos = nil
	end
else
	currentEpos = nil
end
	--combos	
--		PrintChat("test")
	if Menu.co.eq then --combo 1
		if ValidTarget(Target, Erange) and EReady and QReady then
	
			CastSpell(_E, currentEpos.x, currentEpos.z)				
		end
	end	
	if Menu.co.eqr and EReady and QReady and RReay then
		if ValidTarget(Target, Erange) then
			CastSpell(_E, currentEpos.x, currentEpos.z)				
		end
		if ValidTarget(Target, Rrange) and EReady and QReady and RReady then
			CastSpell(_R, currentRpos.x, currentRpos.z)					
		end
	end
end

if Menu.ta.co == 2 then --VIPPrediction
--txtonme="M2"
if ValidTarget(Target) then
	local Position = Evipfree:GetPrediction(Target)
	if Position ~= nil then
		currentEpos = Position
	else
		currentEpos = nil
	end
else
	currentEpos = nil
end
if ValidTarget(Target) then
	local Position = Rvipfree:GetPrediction(Target)
	if Position ~= nil then
		currentRpos = Position
	else
		currentRpos = nil
	end
else
	currentRpos = nil
end
	--combos	
	if Menu.co.eq then --combo 1
		if ValidTarget(Target, Erange) and EReady and QReady then
			CastSpell(_E, currentEpos.x, currentEpos.z)				
		end
	end	
	if Menu.co.eqr and EReady and QReady and RReay then
		if ValidTarget(Target, Erange) then
			CastSpell(_E, currentEpos.x, currentEpos.z)				
		end
		if ValidTarget(Target, Rrange) and EReady and QReady and RReady then
			CastSpell(_R, currentRpos.x, currentRpos.z)					
		end
	end
end

if Menu.ta.co == 3 then --VPrediction
--txtonme="M3"
	if ValidTarget(Target) then
		local CastPosition,  HitChance,  Position = VP:GetLineCastPosition(Target, Edelay, Ewidth, Erange, Espeed, myHero, false)
		if Position ~= nil then
			currentEpos = CastPosition
			vpredhit = HitChance
		else
			currentEpos = nil
		end
	else
		currentEpos = nil
	end
	if ValidTarget(Target) then
		local CastPosition,  HitChance,  Position = VP:GetCircularCastPosition(Target, Rdelay, Rnuke, Rrange, Rspeed, myHero, false)
		if Position ~= nil then
			currentRpos = CastPosition
			vpredhitR = HitChance
		else
			currentRpos = nil
		end
	else
		currentRpos = nil
	end	
	--combos	
	if Menu.co.eq then --combo 1
		if ValidTarget(Target, Erange) and EReady and QReady and vpredhitE >= 2 then
			CastSpell(_E, currentEpos.x, currentEpos.z)				
		end
	end	
	if Menu.co.eqr and EReady and QReady and RReay then
		if ValidTarget(Target, Erange) then
			CastSpell(_E, currentEpos.x, currentEpos.z)				
		end
		if ValidTarget(Target, Rrange) and EReady and QReady and RReady and vpredhitR >= 2 then
			CastSpell(_R, currentRpos.x, currentRpos.z)					
		end
	end
end
if Menu.ta.co == 4 then --prOdiction
local tar = nil --GetTarget()
if tar then txtonme="target: "..tar.name end
--Target = tar
--GetEPos----------------------------   
	--ValidTarget(object, distance, enemyTeam)
    if ValidTarget(Target) then --let us return all time the current prodicted e position
        ProdictionE:GetPredictionCallBack(Target, GetEPos)
		--txtonme="M1-1"
    else
        currentEpos = nil
		--txtonme="M1-2"
    end
	if ValidTarget(Target) then --let us return all time the current prodicted r position
        ProdictionR:GetPredictionCallBack(Target, GetRPos)
		--txtonme="M2-1"
    else
        currentRpos = nil
		--txtonme="M2-2"
    end    
    -- Cast our "combo"
		
        if Menu.co.eq then	
				if Target==nil then txtonme="kein ziel" else txtonme="ziel vorhanden" end
			if ValidTarget(Target, Erange)and EReady and QReady then	
							
				ProdictionE:GetPredictionCallBack(Target, castE)		
			end		
		end
		if Menu.co.eqr and EReady then
			if ValidTarget(Target, Erange) then
				ProdictionE:GetPredictionCallBack(Target, castE)				
			end
			if ValidTarget(Target, Rrange) and RReady then
				ProdictionR:GetPredictionCallBack(Target, castR)				
			end
		end
end


end





--[[       ----------------------------------------------------------------------------------------------       ]]--
--[[					     	 		    	    General				 	  	   								]]--
--[[       ----------------------------------------------------------------------------------------------       ]]--

function _castQ()
if GetDistance(ts.target) < Qrange and QReady then
        CastSpell(_Q)		
end
end


function _castW()

end


function castE(unit, pos)
txtonme="cast e"
if GetDistance(pos) < Erange and EReady then
	CastSpell(_E, pos.x, pos.z)
end
end

function castR(unit, pos)
if GetDistance(pos) < Rrange and RReady then
	CastSpell(_R, pos.x, pos.z)
end
end

function GetRPos(unit, pos)        
		currentRpos = pos
end

function GetEPos(unit, pos) 
txtonme="epos"       
		currentEpos = pos
end

function _update()
	ts:update()
	Target = ts.target
	_spellcheck()
end

--[[       ----------------------------------------------------------------------------------------------       ]]--
--[[					     	 		    	    Utility				 	  	   								]]--
--[[       ----------------------------------------------------------------------------------------------       ]]--

function _spellcheck()
    QReady = (myHero:CanUseSpell(_Q) == READY)
    WReady = (myHero:CanUseSpell(_W) == READY)
    EReady = (myHero:CanUseSpell(_E) == READY)
    RReady = (myHero:CanUseSpell(_R) == READY)
end

--[[       ----------------------------------------------------------------------------------------------       ]]--
--[[					     	 		    	    Once loaded			 	  	   								]]--
--[[       ----------------------------------------------------------------------------------------------       ]]--
function _initmenu()
	if AutoCarry.Skills then IsSACReborn = true else IsSACReborn = false end
	
	if IsSACReborn then
		AutoCarry.Crosshair:SetSkillCrosshairRange(900)
		AutoCarry.Crosshair.isCaster = true
		AutoCarry.MyHero:AttacksEnabled(true)
		AutoCarry.Skills:DisableAll()
	else
		AutoCarry.SkillsCrosshair.range = 900
		AutoCarry.CanAttack = true
    end
	




	if VIP_USER then
		if FileExist(SCRIPT_PATH..'Common/Prodiction.lua') then --prodiction
			require "Prodiction"			
			prodicfile = true
			prodic = true		
		end
		if FileExist(SCRIPT_PATH..'Common/VPrediction.lua') then --vprediction
				vpredic = true
				vpredicfile = true
		else				
				freevippredicfile = true --vipprediction
		end		
	else
	freepredicfile = true --freeprediction		
	end
	_loadP()
	
	Menu = AutoCarry.PluginMenu
	Menu:addSubMenu("Target acquisition", "ta")


	
	
	if not VIP_USER then Menu.co:addParam("co", "Use", SCRIPT_PARAM_LIST, 1, {"FREEPrediction"}) end
	if VIP_USER and not prodicfile and not vpredicfile then Menu.ta:addParam("co", "Use", SCRIPT_PARAM_LIST, 2, {"FREEPrediction", "VIPPrediction",  }) end
	if VIP_USER and not prodicfile and vpredicfile then Menu.ta:addParam("co", "Use", SCRIPT_PARAM_LIST, 3, {"FREEPrediction","VIPPrediction", "VPrediction" }) end
	if VIP_USER and prodicfile and not vpredicfile then Menu.ta:addParam("co", "Use", SCRIPT_PARAM_LIST, 3, {"FREEPrediction","VIPPrediction","Prodiction" }) end
	if VIP_USER and prodicfile and vpredicfile then Menu.ta:addParam("co", "Use", SCRIPT_PARAM_LIST, 4, {"FREEPrediction","VIPPrediction","VPrediction","Prodiction"}) end
	
	if Menu.ta.co==1 then Menu.ta:addParam("info", "---> FREEPrediction loaded.", SCRIPT_PARAM_INFO, "")
		elseif Menu.ta.co==2 then Menu.ta:addParam("info", "---> VIPPrediction loaded.", SCRIPT_PARAM_INFO, "")
		elseif Menu.ta.co==3 then Menu.ta:addParam("info", "---> VPrediction loaded.", SCRIPT_PARAM_INFO, "")
		elseif Menu.ta.co==4 then Menu.ta:addParam("info", "---> Prodiction loaded.", SCRIPT_PARAM_INFO, "")
	end


	Menu:addSubMenu("Draw Options", "draw")
		Menu.draw:addParam("drawE","Draw E Range",SCRIPT_PARAM_ONOFF, true)
		Menu.draw:addParam("drawR","Draw R Range",SCRIPT_PARAM_ONOFF, true)
		Menu.draw:addParam("drawEpos","Draw E Pos",SCRIPT_PARAM_ONOFF, true)
		Menu.draw:addParam("drawEposway","Draw Tar->PosE",SCRIPT_PARAM_ONOFF, true)
		Menu.draw:addParam("drawRpos","Draw R Pos",SCRIPT_PARAM_ONOFF, true)
		Menu.draw:addParam("drawRposway","Draw Tar->PosR",SCRIPT_PARAM_ONOFF, true)
		
	

	Menu:addSubMenu("Combo Options", "co")
		Menu.co:addParam("q", "Fast Q", SCRIPT_PARAM_LIST, 2, {"OnEnemyInRange", "Interupt", "Never" })
		Menu.co:addParam("eq", "EQ Combo",SCRIPT_PARAM_ONKEYDOWN, false, string.byte("T"))
		Menu.co:addParam("eqr", "EQR Combo",SCRIPT_PARAM_ONKEYDOWN, false, string.byte("T"))  
		Menu.co:addSubMenu("W Settings", "ws")
			Menu.co.ws:addParam("autoW","Auto use W",SCRIPT_PARAM_ONOFF, true)
			Menu.co.ws:addParam("autoC","Use W in Combo",SCRIPT_PARAM_ONOFF, true)
			Menu.co.ws:addParam("inWrange", "Use in in range", SCRIPT_PARAM_SLICE, 100, 25, 500, 0)
			if prodicfile then --for paidprO
				Menu.co:addSubMenu("R Settings","rs")
					Menu.co.rs:addParam("info", "Only PaidProdiction.", SCRIPT_PARAM_INFO, "")
					Menu.co.rs:addParam("ondash","R on dash",SCRIPT_PARAM_ONOFF, false)
					Menu.co.rs:addParam("afterdash","R after dash",SCRIPT_PARAM_ONOFF, true)
					Menu.co.rs:addParam("onimmo","R on immobile",SCRIPT_PARAM_ONOFF, false)
					Menu.co.rs:addParam("afterimmo","R after immobile",SCRIPT_PARAM_ONOFF, true)
				Menu.co:addSubMenu("E Settings","es")
					Menu.co.es:addParam("info", "Only PaidProdiction.", SCRIPT_PARAM_INFO, "")
					Menu.co.es:addParam("ondash","E on dash",SCRIPT_PARAM_ONOFF, true)
					Menu.co.es:addParam("afterdash","E after dash",SCRIPT_PARAM_ONOFF, true)
					Menu.co.es:addParam("onimmo","E on immobile",SCRIPT_PARAM_ONOFF, true)
					Menu.co.es:addParam("afterimmo","E after immobile",SCRIPT_PARAM_ONOFF, true)
				Menu.co:addSubMenu("Q Settings","qs")
					Menu.co.qs:addParam("info", "Only PaidProdiction.", SCRIPT_PARAM_INFO, "")
					Menu.co.qs:addParam("info2", "Only if in range.", SCRIPT_PARAM_INFO, "")
					Menu.co.qs:addParam("ondash","Q on dash",SCRIPT_PARAM_ONOFF, false)
					Menu.co.qs:addParam("afterdash","Q after dash",SCRIPT_PARAM_ONOFF, true)
					Menu.co.qs:addParam("onimmo","Q on immobile",SCRIPT_PARAM_ONOFF, false)
					Menu.co.qs:addParam("afterimmo","Q after immobile",SCRIPT_PARAM_ONOFF, true)					
		end
	ts = TargetSelector(TARGET_PRIORITY, Rrange)
	ts.name = "Leona"
	Menu:addTS(ts)
end	
	
	
function _loadP()
	if prodicfile then --initiate paidprOdiction
		require "Prodiction"
		Prodiction = ProdictManager.GetInstance()
		ProdictionQ = Prodiction:AddProdictionObject(_Q, Qrange, Qspeed, Qdelay, Qwidth)
		ProdictionE = Prodiction:AddProdictionObject(_E, Erange, Espeed, Edelay, Ewidth)
		ProdictionR = Prodiction:AddProdictionObject(_R, Rrange, Rspeed, Rdelay, Rnuke)		
	end
	if vpredicfile then --initiate VPprediction
		require "VPrediction"		
		VPrediction = VPrediction()	
	end
	if freevippredicfile then --initiate VIPPrediction
		Evipfree = TargetPredictionVIP(Erange, Espeed, Edelay, Ewidth, myHero)
		Rvipfree = TargetPredictionVIP(Rrange, Rspeed, Rdelay, Rnuke, myHero)		
	end
	if freepredic then --initiate FreePredition
		Efreepredic = TargetPrediction(Erange, Espeed, Edelay, Ewidth)
		Rfreepredic = TargetPrediction(Rrange, Rspeed, Rdelay, Rnuke)	
	end
end


function _initprocallbacks()
    for i = 1, heroManager.iCount do
        local hero = heroManager:GetHero(i)
        if hero.team ~= myHero.team then
			ProdictionQ:GetPredictionOnDash(hero, QOnDashFunc)
			ProdictionQ:GetPredictionAfterDash(hero, QAfterDashFunc)
			ProdictionQ:GetPredictionOnImmobile(hero, QOnImmobileFunc)
			ProdictionQ:GetPredictionAfterImmobile(hero, QAfterImmobileFunc)
            ProdictionE:GetPredictionOnDash(hero, EOnDashFunc)
			ProdictionE:GetPredictionAfterDash(hero, EAfterDashFunc)
			ProdictionE:GetPredictionOnImmobile(hero, EOnImmobileFunc)
			ProdictionE:GetPredictionAfterImmobile(hero, EAfterImmobileFunc)
			ProdictionR:GetPredictionOnDash(hero, ROnDashFunc)
			ProdictionR:GetPredictionAfterDash(hero, RAfterDashFunc)
			ProdictionR:GetPredictionOnImmobile(hero, ROnImmobileFunc)
			ProdictionR:GetPredictionAfterImmobile(hero, RAfterImmobileFunc)
        end
    end
end


	





