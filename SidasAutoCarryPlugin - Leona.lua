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
	local mylevelSequence = {1,3,2,2,2,4,2,1,2,1,4,1,1,3,3,4,3,3}
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
if GetInGameTimer() >= 20 and GetInGameTimer()<= 21 then
	PrintFloatText(myHero, 9, "Leona the Radiant Dawn - by Bilbao")
end

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
		if Menu.draw.drawEpos then
			DrawCircle(currentEpos.x, currentEpos.y, currentEpos.z, 100, ARGB(255,255,7,7))
		end
    end
	
	if currentRpos then
		if Menu.draw.drawRposway then
			--DrawArrows(Target, currentRpos, 2, ARGB(255,7,7,255))
		end
	if Menu.draw.drawRpos then
        DrawCircle(currentRpos.x, currentRpos.y, currentRpos.z,Menu.co.rcenter , ARGB(255,7,7,255))
	end
    end
	
--[[
local textA = "PQWER+aa"
DrawLineHPBar(testdmg(), 1, textA)
if Target~nil and not Target.dead and Target.visible and Target.team ~= myHero.team then
	Target = GetMyHero()
	DrawLineHPBar(dmgEQ(Target), 1, "EQ")
	DrawLineHPBar(dmgEWQ(Target), 2, "EWQ")
	DrawLineHPBar(dmgEWQR(Target), 3, "EWQR")
end

]]
--for i, enemy in ipairs(GetEnemyHeroes()) do
	for i, enemy in ipairs(AutoCarry.EnemyTable) do
		if enemy~=nil and not enemy.dead and enemy.visible and GetDistance(enemy) < 2500 then
	
			DrawLineHPBar(dmgEQ(enemy), 1, "EQ", enemy)
			DrawLineHPBar(dmgEWQ(enemy), 2, "EWQ", enemy)
			DrawLineHPBar(dmgEWQR(enemy), 3, "EWQR", enemy)
		end
	end


end

function GetHPBarPos(enemy)
	enemy.barData = GetEnemyBarData()
	local barPos = GetUnitHPBarPos(enemy)
	local barPosOffset = GetUnitHPBarOffset(enemy)
	local barOffset = { x = enemy.barData.PercentageOffset.x, y = enemy.barData.PercentageOffset.y }
	local barPosPercentageOffset = { x = enemy.barData.PercentageOffset.x, y = enemy.barData.PercentageOffset.y }
	local BarPosOffsetX = 171
	local BarPosOffsetY = 46
	local CorrectionY =  0
	local StartHpPos = 31
	barPos.x = barPos.x + (barPosOffset.x - 0.176 + barPosPercentageOffset.x) * BarPosOffsetX + StartHpPos
	barPos.y = barPos.y + (barPosOffset.y - 0.5 + barPosPercentageOffset.y) * BarPosOffsetY + CorrectionY 
						
	local StartPos = Vector(barPos.x , barPos.y, 0)
	local EndPos =  Vector(barPos.x + 108 , barPos.y , 0)

	return Vector(StartPos.x, StartPos.y, 0), Vector(EndPos.x, EndPos.y, 0)
end

function dmgEQ(target)
        local ADDmg = getDmg("AD", target, myHero)
        local extraQ = getDmg("Q", target, myHero)		
		local extraE = getDmg("E", target, myHero)		
        return ADDmg+extraQ+extraE
end
function dmgEWQ(target)
        local ADDmg = getDmg("AD", target, myHero)
        local extraQ = getDmg("Q", target, myHero)
		local extraW = getDmg("Q", target, myHero)			
		local extraE = getDmg("E", target, myHero)		
        return ADDmg+extraQ+extraE+extraW
end
function dmgEWQR(target)
        local ADDmg = getDmg("AD", target, myHero)
        local extraQ = getDmg("Q", target, myHero)
		local extraW = getDmg("Q", target, myHero)			
		local extraE = getDmg("E", target, myHero)
		local extraR = getDmg("R", target, myHero)
        return ADDmg+extraQ+extraE+extraW+extraR
end
function DrawLineHPBar(damage, line, text, unit)
	local StartPos, EndPos = GetHPBarPos(unit)
	local Real_X = StartPos.x+24
	local Offs_X = (Real_X + ((unit.health-damage)/unit.maxHealth) * (EndPos.x - StartPos.x - 2))
	if Offs_X < Real_X then Offs_X = Real_X end
	
	if line == 1 then
		DrawLine(Offs_X-150, StartPos.y-45, Offs_X-150, StartPos.y-2, 2, ARGB(255,7,255,7))
		DrawText(tostring(text),15,Offs_X-148,StartPos.y-45,ARGB(255,255,255,255))
	end
	if line == 2 then
		DrawLine(Offs_X-150, StartPos.y-60, Offs_X-150, StartPos.y-2, 2, ARGB(255,7,255,7))
		DrawText(tostring(text),15,Offs_X-148,StartPos.y-60,ARGB(255,255,255,255))
	end
	if line == 3 then
		DrawLine(Offs_X-150, StartPos.y-75, Offs_X-150, StartPos.y-2, 2, ARGB(255,7,255,7))
		DrawText(tostring(text),15,Offs_X-148,StartPos.y-75,ARGB(255,255,255,255))
	end
end



------------------------

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
		AutoCarry.CanAttack = true
		player:Attack(unit)
    end
end

function QAfterDashFunc(unit, pos, spell)
    if GetDistance(pos) < Qrange and myHero:CanUseSpell(spell.Name) == READY then
        CastSpell(spell.Name)
		AutoCarry.CanAttack = true
		player:Attack(unit)
    end
end

function QOnImmobileFunc(unit, pos, spell)
    if GetDistance(pos) < Qrange and myHero:CanUseSpell(spell.Name) == READY then
        CastSpell(spell.Name)
		AutoCarry.CanAttack = true
		player:Attack(unit)
    end
end

function QAfterImmobileFunc(unit, pos, spell)
    if GetDistance(pos) < Qrange and myHero:CanUseSpell(spell.Name) == READY then
        CastSpell(spell.Name)
		AutoCarry.CanAttack = true
		player:Attack(unit)
    end
end		

--[[       ----------------------------------------------------------------------------------------------       ]]--
--[[					     	 		    	    Core				 	  	   								]]--
--[[       ----------------------------------------------------------------------------------------------       ]]--

function _smartcore()

if ValidTarget(Target) and GetDistance(Target) < Qrange and QReady and (Menu.co.q == 1 or Menu.co.eq or Menu.co.eqr) then	
	_castQ()
	AutoCarry.CanAttack = true
	player:Attack(Target)
end
--Menu.co.ws.inWrange/autoW/autoC
if ValidTarget(Target) and GetDistance(Target) < Menu.co.ws.inWrange and WReady and (Menu.co.ws.autoC or Menu.co.ws.autoW) then
	CastSpell(_W)
end

if Menu.ta.co == 1 then --FREEPrediction
PrintChat("NONVIPprediction")
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
		currentRpos = Position
	else
		currentRpos = nil
	end
else
	currentRpos = nil
end
	--combos	
--		PrintChat("test")
	if Menu.co.eq then --combo 1
		if ValidTarget(Target, Erange) and currentEpos.x~=nil then
	
			CastSpell(_E, currentEpos.x, currentEpos.z)				
		end
	end	
	if Menu.co.eqr then
		if ValidTarget(Target, Erange) and currentEpos.x~=nil then
			CastSpell(_E, currentEpos.x, currentEpos.z)				
		end
		if ValidTarget(Target, Rrange) and currentRpos.x~=nil then
			CastSpell(_R, currentRpos.x, currentRpos.z)					
		end
	end
end

if Menu.ta.co == 2 and VIP_USER then --VIPPrediction
PrintChat("VIPprediction")
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
		if ValidTarget(Target, Erange) then
			CastSpell(_E, currentEpos.x, currentEpos.z)				
		end
	end	
	if Menu.co.eqr then
		if ValidTarget(Target, Erange) and currentEpos.x~=nil then
			CastSpell(_E, currentEpos.x, currentEpos.z)				
		end
		if ValidTarget(Target, Rrange) and currentRpos.x~=nil then
			CastSpell(_R, currentRpos.x, currentRpos.z)					
		end
	end
end

if Menu.ta.co == 3 and vpredicfile then --VPrediction
PrintChat("VPREdiction")
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
		local CastPosition,  HitChance,  Position = VP:GetCircularCastPosition(Target, Rdelay, Menu.co.rcenter, Rrange, Rspeed, myHero, false)
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
		if ValidTarget(Target, Erange) and vpredhitE >= 3 and currentEpos.x~=nil then
			CastSpell(_E, currentEpos.x, currentEpos.z)				
		end
	end	
	if Menu.co.eqr then
		if ValidTarget(Target, Erange) and currentEpos.x~=nil then
			CastSpell(_E, currentEpos.x, currentEpos.z)				
		end
		if ValidTarget(Target, Rrange) and vpredhitR >= 2 and currentRpos.x~=nil then
			CastSpell(_R, currentRpos.x, currentRpos.z)					
		end
	end
end
if Menu.ta.co == 4 and prodicfile then --prOdiction
PrintChat("PROdiction")
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
			if ValidTarget(Target, Erange) and EReady then							
				ProdictionE:GetPredictionCallBack(Target, castE)		
			end		
		end
		if Menu.co.eqr then
			if ValidTarget(Target, Erange) and EReady then
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
		AutoCarry.CanAttack = true
        CastSpell(_Q)		
end
end


function _castW()

end


function castE(unit, pos)
if GetDistance(pos) < Erange and EReady then
	--CastSpell(_E, pos.x, pos.z)
	_sendE(pos)
end
end

function _sendE(target)
	local Epacket = CLoLPacket(153)
		Epacket.dwArg1 = 1
		Epacket.dwArg2 = 0
		Epacket:EncodeF(myHero.networkID)
		Epacket:Encode1(_E)
		Epacket:EncodeF(target.x)
		Epacket:EncodeF(target.z)
		Epacket:EncodeF(target.x)
		Epacket:EncodeF(target.z)
		Epacket:EncodeF(0)
		SendPacket(Epacket)
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
	autoLevelSetSequence(mylevelSequence)
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
		AutoCarry.OverrideCustomChampionSupport = true
		AutoCarry.Crosshair:SetSkillCrosshairRange(1200)
		AutoCarry.Crosshair.isCaster = true
		AutoCarry.MyHero:AttacksEnabled(true)
		AutoCarry.Skills:DisableAll()
	else
		AutoCarry.SkillsCrosshair.range = 1200
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
	
	
	Menu = AutoCarry.PluginMenu
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
	--if VIP_USER and prodicfile and not vpredicfile then Menu.ta:addParam("co", "Use", SCRIPT_PARAM_LIST, 3, {"FREEPrediction","VIPPrediction","Prodiction" }) and Menu.ta.co =  end
	if VIP_USER and prodicfile and vpredicfile then 
		Menu.ta:addParam("co", "Use", SCRIPT_PARAM_LIST, 4, {"FREEPrediction","VIPPrediction","VPrediction","Prodiction"})  
		Menu.ta.co = 4 
	end
	
 
	

	Menu:addSubMenu("Draw Options", "draw")
		Menu.draw:addParam("drawE","Draw E Range",SCRIPT_PARAM_ONOFF, true)
		Menu.draw:addParam("drawR","Draw R Range",SCRIPT_PARAM_ONOFF, true)
		Menu.draw:addParam("drawEpos","Draw E Pos",SCRIPT_PARAM_ONOFF, true)
		Menu.draw:addParam("drawEposway","Draw Tar->PosE",SCRIPT_PARAM_ONOFF, true)
		Menu.draw:addParam("drawRpos","Draw R Pos",SCRIPT_PARAM_ONOFF, true)
		Menu.draw:addParam("drawRposway","Draw Tar->PosR",SCRIPT_PARAM_ONOFF, true)
		Menu.draw:addParam("drawinfo","Infotext about Mana",SCRIPT_PARAM_ONOFF, true)
		Menu.draw:addParam("drawinfo2","Show pred. Dmg",SCRIPT_PARAM_ONOFF, true)
	

	Menu:addSubMenu("Combo Options", "co")
		Menu.co:addParam("q", "Fast Q", SCRIPT_PARAM_LIST, 2, {"OnEnemyInRange", "Interupt", "Never" })
		Menu.co:addParam("eq", "EQ Combo",SCRIPT_PARAM_ONKEYDOWN, false, string.byte("T"))
		Menu.co:addParam("eqmana","EQ only if mana",SCRIPT_PARAM_ONOFF, false)
		Menu.co:addParam("eqr", "EQR Combo",SCRIPT_PARAM_ONKEYDOWN, false, string.byte("T"))  
		Menu.co:addParam("eqrmana","EQR only if mana",SCRIPT_PARAM_ONOFF, false)
		Menu.co:addParam("rcenter", "R core width", SCRIPT_PARAM_SLICE, 200, 100, 315, 0) 
		
		Menu.co:addSubMenu("W Settings", "ws") 
			Menu.co.ws:addParam("autoW","Auto use W",SCRIPT_PARAM_ONOFF, true)
			Menu.co.ws:addParam("autoC","Use W in Combo",SCRIPT_PARAM_ONOFF, true)
			Menu.co.ws:addParam("inWrange", "Use in in range", SCRIPT_PARAM_SLICE, 150, 25, 500, 0)  
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
	
		Menu:addSubMenu("Autolevel", "alvl")
			Menu.alvl:addParam("lvlseq", "R>W>Q>E", SCRIPT_PARAM_ONOFF, false)
	_loadP()		
	ts = TargetSelector(TARGET_PRIORITY, 5000) --Rrange
	ts.name = "Leona"
	Menu:addTS(ts)
end	
	
	
function _loadP()
	if prodicfile then --initiate paidprOdiction
		require "Prodiction"
		Prodiction = ProdictManager.GetInstance()
		ProdictionQ = Prodiction:AddProdictionObject(_Q, Qrange, Qspeed, Qdelay, Qwidth)
		ProdictionE = Prodiction:AddProdictionObject(_E, Erange, Espeed, Edelay, Ewidth)
		ProdictionR = Prodiction:AddProdictionObject(_R, Rrange, Rspeed, Rdelay, Menu.co.rcenter)		
	end
	if vpredicfile then --initiate VPprediction
		require "VPrediction"		
		VP = VPrediction()	
	end
	if VIP_USER then --initiate VIPPrediction
		Evipfree = TargetPredictionVIP(Erange, Espeed, Edelay, Ewidth, myHero)
		Rvipfree = TargetPredictionVIP(Rrange, Rspeed, Rdelay, Menu.co.rcenter, myHero)		
	end
	-- --initiate FreePredition
		Efreepredic = TargetPrediction(Erange, Espeed, Edelay, Ewidth)
		Rfreepredic = TargetPrediction(Rrange, Rspeed, Rdelay, Menu.co.rcenter)	
	--
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


	





