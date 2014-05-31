if not VIP_USER or not myHero.charName == "Amumu" then return end
--[[---------------------------------]]--
--[[----Prodicted Amumu by Bilbao----]]--
--[[---------------------------------]]--
require "Prodiction"
require "Collision"
local Qrange, Qwidth, Qspeed, Qdelay = 1080, 83, 2000, 0.5
local Wrange, Wstatus = 300, false

function OnLoad()
		Prodiction = ProdictManager.GetInstance()
		ProdictionQ = Prodiction:AddProdictionObject(_Q, 1100, Qspeed, Qdelay, Qwidth)
		QCOLL = Collision(1100, Qspeed, Qdelay, Qwidth)		
		Menu = scriptConfig("AmumuProdB", "bilbao")				
			Menu:addParam("useq", "Use Q", SCRIPT_PARAM_ONOFF, false)
			Menu:addParam("qrange", "Q max range", SCRIPT_PARAM_SLICE, 1180, 0, 1100, 0)
			Menu:addParam("mdis", "Max Distance to mouse", SCRIPT_PARAM_SLICE, 500, 0, 500, 0)
			Menu:addParam("drawq", "Draw Q range", SCRIPT_PARAM_ONOFF, false)
			Menu:addParam("drawm", "Draw Mouse range", SCRIPT_PARAM_ONOFF, false)			
			Menu:addParam("drawcoll", "Draw Q coll", SCRIPT_PARAM_ONOFF, false)
			Menu:addParam("key", "Q Key", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("A"))			
			Menu:addParam("info", "------------------------------", SCRIPT_PARAM_INFO, "")			
			Menu:addParam("usew", "Use W only if Enemy in range", SCRIPT_PARAM_ONOFF, false)
	print(" > > Prodicted Amumu by Bilbao loaded.")
end



function OnTick()
if myHero.dead then return end
	if Menu.usew then
		local ECount = CountEnemyHeroInRange(Wrange, myHero)
			if ECount >= 1 and not Wstatus then
				CastSpell(_W)
			elseif ECount == 0 and Wstatus then
				CastSpell(_W)
			end
	end
	if Menu.key and Menu.useq and (myHero:CanUseSpell(_Q) == READY) then
		local target = nil
		local tdist = 50000
		local predPos = nil
		for i, enemy in ipairs(GetEnemyHeroes()) do
			if enemy ~= nil and enemy.visible and enemy ~= dead and ValidTarget(enemy, 1500) and enemy.x ~= nil and GetDistance(enemy, mousePos) < Menu.mdis and GetDistance(enemy) < tdist then
				local calcPos = ProdictionQ:GetPrediction(enemy)
				if calcPos ~= nil and calcPos.x ~= nil and GetDistance(calcPos) < Menu.qrange and not QCOLL:GetMinionCollision(calcPos, myHero) then
					target = enemy
					tdist = GetDistance(enemy)
					predPos = calcPos
				end
			end		
		end	
		if target ~= nil and ValidTarget(target, 1500) and predPos ~= nil and predPos.x ~= nil and GetDistance(predPos) < Menu.qrange*0.995 then
			CastSpell(_Q, predPos.x, predPos.z)
		end
	end
end


function OnGainBuff(unit, buff)
	if buff and buff.type ~= nil and unit.isMe then
		if buff.name == "AuraofDespair" then Wstatus = true end
	end
end


function OnLoseBuff(unit, buff)
	if buff and buff.type ~= nil and unit.isMe then
		if buff.name == "AuraofDespair" then Wstatus = false end
	end
end


function OnDraw()
if myHero.dead then return end
if not (myHero:CanUseSpell(_Q) == READY) then return end
	if Menu.drawq then
		DrawCircle(myHero.x, myHero.y, myHero.z, Menu.qrange, ARGB(255, 255, 255, 255))
	end
	if Menu.drawm then
		local Count = CountEnemyHeroInRange((Menu.mdis * 2), myHero)
		if Count >= 1 then
			DrawCircle(mousePos.x, mousePos.y, mousePos.z, Menu.mdis, ARGB(255, 255, 0, 0))
		else
			DrawCircle(mousePos.x, mousePos.y, mousePos.z, Menu.mdis, ARGB(100, 255, 0, 0))
		end
	end
	if Menu.drawcoll then
		for i, enemy in ipairs(GetEnemyHeroes()) do
			if enemy ~= nil and enemy.x ~= nil and enemy.visible and enemy ~= dead and ValidTarget(enemy) and GetDistance(enemy, mousePos) < (Menu.mdis * 1.5) then
				QCOLL:DrawCollision(myHero, enemy)
			end		
		end	
	end
end
