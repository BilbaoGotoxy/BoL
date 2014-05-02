if myHero.charName ~= "Teemo" then return end
--[[       ----------------------------------------------------------------------------------------------       ]]--
--[[				BilbaoTeemo by Bilbao		    			   	 	        ]]--
--[[       ----------------------------------------------------------------------------------------------       ]]--


-------Auto update-------
local CurVer = 0.1 
local NetVersion = nil 
local NeedUpdate = false 
local Do_Once = true 
local ScriptName = "BilbaoTeemo"
local NetFile = "http://bilbao.lima-city.de/BilbaoTeemo.lua" 
local LocalFile = BOL_PATH.."Scripts\\BilbaoTeemo.lua" 
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


--[[DO NOT TOUCH]]--
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
	local Qrange, Qwidth, Qspeed, Qdelay = 680, 1, 1500, 0.5
	
	local Wrange, Wwidth, Wspeed, Wdelay = 1, 1, 2000, 0.15	
	
	local Rrange, Rwidth, Rspeed, Rdelay = 230, 75, 2000, 0.1
	local ShroomCounter = 0
	local ShroomTable = nil
	
	local QReady, WReady, EReady, RReady = false, false, false, false
	local canQhrs, canWhrs, canEhrs, canRhrs = false, false, false, false
	local canQrota, canWrota, canErota, canRrota = false, false, false, false	
	-------/Skills info-------


	-------Predictions-------
	local VP = nil
	local minVPhit = 2
	------/Predictions-------
	
	
	
	-------Orbwalk & Farm info-------
	local lastAttack, lastWindUpTime, lastAttackCD = 0, 0, 0
	local myTrueRange = 500	
	-------/Orbwalk & Farm info-------
	
	
	-------MMA & SAC info-------
	local starttick = 0
	local checkedMMASAC = false
	local is_MMA = false
	local is_SAC = false
	-------/MMA & SAC info-------
	
	
	-------Target info-------
	local TarsRange = 680
	local ts = nil
	local Target = nil	
	-------/Target info-------	
	

--[[       ----------------------------------------------------------------------------------------------       ]]--
--[[													Callbacks												]]--
--[[       ----------------------------------------------------------------------------------------------       ]]--	


--[OnLoad]--
function OnLoad()	
	starttick = GetTickCount()
	_loadP()	
	_load_menu() 
	_initiateTS()
	_create_shroom_tables()
	PrintChat("<font color='#40FF00'> >> "..ScriptName.." v."..CurVer.." - loaded</font>")
end


function _loadP()
	if prodicfile then
		Prodiction = ProdictManager.GetInstance()
		ProdictionR = Prodiction:AddProdictionObject(_R, Rrange, Rspeed, Rdelay, Rwidth) 
	end
	if vpredicfile then			
		VP = VPrediction()	
	end
	if VIP_USER then
		VipPredictionR = TargetPredictionVIP(Rrange, Rspeed, Rdelay, Rwidth, myHero) 
	end
		FreePredictionR = TargetPrediction(Rrange, (Rspeed / 1000), (Rdelay * 1000), Rwidth)
end


function _load_menu()
	Menu = scriptConfig(""..ScriptName, "bilbao")  	
		-----------------------------------------------------------------------------------------------------
		Menu:addSubMenu("Drawing", "draw")
			Menu.draw:addSubMenu("Enemy", "prdraw")
				Menu.draw.prdraw:addParam("enemy", "Mark Enemy", SCRIPT_PARAM_ONOFF, true)
				Menu.draw.prdraw:addParam("enemyline", "Line2Enemy", SCRIPT_PARAM_ONOFF, true)					
		-----------------------------------------------------------------------------------------------------

		-----------------------------------------------------------------------------------------------------
			Menu.draw:addSubMenu("Ranges", "drawsub2")
				Menu.draw.drawsub2:addParam("drawaa", "Draw AA-Range", SCRIPT_PARAM_ONOFF, true)
					Menu.draw.drawsub2:addParam("drawQ", "Draw Q-Range", SCRIPT_PARAM_ONOFF, true)
					Menu.draw.drawsub2:addParam("drawR", "Draw R-Range", SCRIPT_PARAM_ONOFF, true)				
		-----------------------------------------------------------------------------------------------------
		
		
		-----------------------------------------------------------------------------------------------------
		Menu:addSubMenu("Harrass", "harrass")		
				Menu.harrass:addParam("autohrsQ", "Auto Use Q", SCRIPT_PARAM_ONOFF, true)
				Menu.harrass:addParam("autohrsW", "Auto Use W", SCRIPT_PARAM_ONOFF, true)			
				Menu.harrass:addParam("autohrsR", "Auto Use R", SCRIPT_PARAM_ONOFF, true)
		-----------------------------------------------------------------------------------------------------
		
		
		-----------------------------------------------------------------------------------------------------
		Menu:addSubMenu("Rotation", "rota")			
				Menu.rota:addParam("useQ", "Q Usage", SCRIPT_PARAM_ONOFF, true)
				Menu.rota:addParam("useW", "W Usage", SCRIPT_PARAM_ONOFF, true)				
				Menu.rota:addParam("useR", "R Usage", SCRIPT_PARAM_ONOFF, true)
		-----------------------------------------------------------------------------------------------------
		
		Menu:addSubMenu("Mana Manager", "manamenu")
			Menu.manamenu:addSubMenu("Harrass", "manahrs")
				Menu.manamenu.manahrs:addParam("manaq", "Q ManaManager", SCRIPT_PARAM_ONOFF, true)  
				Menu.manamenu.manahrs:addParam("sliderq", "Use Q only if mana over %",  SCRIPT_PARAM_SLICE, 50, 0, 100, 0)  
				Menu.manamenu.manahrs:addParam("manaw", "W ManaManager", SCRIPT_PARAM_ONOFF, true) 
				Menu.manamenu.manahrs:addParam("sliderw", "Use W only if mana over %",  SCRIPT_PARAM_SLICE, 50, 0, 100, 0)
				Menu.manamenu.manahrs:addParam("manar", "R ManaManager", SCRIPT_PARAM_ONOFF, true) 
				Menu.manamenu.manahrs:addParam("sliderr", "Use R only if mana over %",  SCRIPT_PARAM_SLICE, 50, 0, 100, 0) 
			Menu.manamenu:addSubMenu("Rotation", "manarota")
				Menu.manamenu.manarota:addParam("manaq", "Q ManaManager", SCRIPT_PARAM_ONOFF, true) 
				Menu.manamenu.manarota:addParam("sliderq", "Use Q only if mana over %",  SCRIPT_PARAM_SLICE, 50, 0, 100, 0) 
				Menu.manamenu.manarota:addParam("manaw", "W ManaManager", SCRIPT_PARAM_ONOFF, true) 
				Menu.manamenu.manarota:addParam("sliderw", "Use W only if mana over %",  SCRIPT_PARAM_SLICE, 50, 0, 100, 0) 
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
				Menu.ta:addParam("vphit", "VPrediction HitChance", SCRIPT_PARAM_LIST, 3, {"[0]Target Position","[1]Low Hitchance", "[2]High Hitchance", "[3]Target slowed/close", "[4]Target immobile", "[5]Target dashing" })  
			end
			
			if VIP_USER and prodicfile and vpredicfile then 
				Menu.ta:addParam("co", "Use", SCRIPT_PARAM_LIST, 4, {"FREEPrediction","VIPPrediction","VPrediction","Prodiction"})  
				Menu.ta.co = 4
				Menu.ta:addParam("vphit", "VPrediction HitChance", SCRIPT_PARAM_LIST, 3, {"[0]Target Position","[1]Low Hitchance", "[2]High Hitchance", "[3]Target slowed/close", "[4]Target immobile", "[5]Target dashing" }) 
			end					
			
				Menu.ta:addSubMenu("Basic", "basic")
					Menu.ta.basic:addParam("basicstatus", "Use BasicTS", SCRIPT_PARAM_ONOFF, false)
					
				Menu.ta:addParam("orb", "Basic Orbwalk", SCRIPT_PARAM_LIST, 1, { "COMBO", "ALWAYS", "NEVER" })
				Menu.ta:addParam("orbw", "Basic Orbwalk - Mode", SCRIPT_PARAM_LIST, 1, { "OnlyMove", "Kite"}) 
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
			
				Menu.specl:addSubMenu("Q-Options", "qopt")
					Menu.specl.qopt:addParam("qopt1", "Target", SCRIPT_PARAM_LIST, 1, { "TargetSelector", "Closest", "MostAD", "MostAS" })
					
				Menu.specl:addSubMenu("R-Options", "ropt")
					Menu.specl.ropt:addParam("ropt1", "Auto place shrooms", SCRIPT_PARAM_ONOFF, false)	
					Menu.specl.ropt:addParam("ropt1slider", "Save this shrooms for fights",  SCRIPT_PARAM_SLICE, 2, 0, 3, 0)
					Menu.specl.ropt:addParam("ropt1slider2", "Distance between AutoShrooms",  SCRIPT_PARAM_SLICE, 150, 60, 1000, 0)
				
				Menu.specl:addSubMenu("Minefield", "mine")
					Menu.specl.mine:addParam("mine1", "Use Minefield", SCRIPT_PARAM_ONOFF, false)	
					Menu.specl.mine:addParam("mineauto", "AutoMineField", SCRIPT_PARAM_ONOFF, false)
					Menu.specl.mine:addParam("mine2", "Create Minefield Key", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("0"))
					Menu.specl.mine:addParam("minevip", "Mine Important Spots", SCRIPT_PARAM_ONOFF, false)
					Menu.specl.mine:addParam("minemip", "Mine Medium Spots", SCRIPT_PARAM_ONOFF, false)
					Menu.specl.mine:addParam("minelip", "Mine Low Spots", SCRIPT_PARAM_ONOFF, false)
					Menu.specl.mine:addParam("mineslider", "Save this shrooms for fights",  SCRIPT_PARAM_SLICE, 2, 0, 3, 0)
		-----------------------------------------------------------------------------------------------------
		Menu:addParam("info", " >> created by Bilbao", SCRIPT_PARAM_INFO, "")
		Menu:addParam("info2", " >> Version "..CurVer, SCRIPT_PARAM_INFO, "")
		_setimpdef()
end


function _setimpdef()
	Menu.extra.alvl.alvlstatus = false
	Menu.keys.permrota = false
	Menu.keys.okdrota = false
	Menu.keys.permhrs = false
	Menu.keys.okdhrs = false
end


function _initiateTS()
	ts = TargetSelector(TARGET_LOW_HP, TarsRange)
	ts.name = ""..myHero.charName
	Menu.ta.basic:addTS(ts)
end
--[/OnLoad]--


--[[OnProcessSpell]]--
function OnProcessSpell(object, spell)
	if object == myHero then
		if spell.name:lower():find("attack") then
			lastAttack = GetTickCount() - GetLatency()/2
			lastWindUpTime = spell.windUpTime*1000
			lastAttackCD = spell.animationTime*1000
		end 
	end
	if spell.name=="BantamTrap" then
		ShroomCounter = ShroomCounter - 1		
	end
end
--[[/OnProcessSpell]]--


--[[OnPacket]]--
function OnRecvPacket(p)
        if p.header == 0xFE and p.size == 0x1C then
                p.pos = 1
                pNetworkID = p:DecodeF()
                unk01 = p:Decode2()
                unk02 = p:Decode1()
                unk03 = p:Decode4() 
				stack = p:Decode4()
                if pNetworkID == myHero.networkID then
					ShroomCounter = stack
                end
        end
end
--[[/OnPacket]]--


--[[OnDraw]]--
function OnDraw()
	if myHero.dead then return end
	_draw_ranges()
	_draw_tarinfo()
end


function _draw_ranges()
		if Menu.draw.drawsub2.drawaa then
			DrawCircle(myHero.x, myHero.y, myHero.z, myTrueRange, ARGB(25 , 125, 125, 125))
		end			
		if Menu.draw.drawsub2.drawQ and QReady then			
			DrawCircle(myHero.x, myHero.y, myHero.z, Qrange, ARGB(100, 250, 27, 27))	
		end		
		if Menu.draw.drawsub2.drawR and RReady then
			DrawCircle(myHero.x, myHero.y, myHero.z, Rrange, ARGB(100, 180, 250, 1800))	
		end		
end


function _draw_tarinfo()	
		if Menu.draw.prdraw.enemyline and ValidTarget(Target) and Target.visible and not Target.dead then		
			DrawLine3D(myHero.x, myHero.y, myHero.z, Target.x, Target.y, Target.z, 1, ARGB(250,235,33,33))
		end	
		if Menu.draw.prdraw.enemy and ValidTarget(Target) and Target.visible and not Target.dead then
			DrawCircle(Target.x, Target.y, Target.z, 100, ARGB(250, 253, 33, 33))
		end	
end
--[[/OnDraw]]--


--[[OnTick]]--
function OnTick()
	_check_mmasac()
	if not myHero.dead then
		_update()
		_OrbWalk()
		_smartcore()
	end
end


function _update()
	ts:update()
	if vpredicfile then	minVPhit = Menu.ta.vphit - 1 end
	QReady = (myHero:CanUseSpell(_Q) == READY)
    WReady = (myHero:CanUseSpell(_W) == READY)
    EReady = (myHero:CanUseSpell(_E) == READY)
    RReady = (myHero:CanUseSpell(_R) == READY)
	myTrueRange = myHero.range + (GetDistance(myHero.minBBox) - 5)
	Target = _getTarget()
	_autoskill()
	_checkcancastHRS()
	_checkcancastROTA()
end


function _OrbWalk()
	if not (Menu.ta.orb == 1 or Menu.ta.orb == 2) then return end
	if Menu.ta.orb == 1 then
		if not (Menu.keys.permrota or Menu.keys.okdrota or Menu.keys.permhrs or Menu.keys.okdhrs) then return end
	end	
		if Target ~=nil and GetDistance(Target) <= (myTrueRange - 3) and Menu.ta.orbw == 2 then		
			if timeToShoot() then
				myHero:Attack(Target)
			elseif heroCanMove()  then
				moveToCursor()
			end
		else		
			moveToCursor() 
		end
end


function moveToCursor()
	if GetDistance(mousePos) > 7 or lastAnimation == "Idle1" then
		local moveToPos = myHero + (Vector(mousePos) - myHero):normalized() * 500
		if Menu.extra.packetmove then
			Packet('S_MOVE', { type = 2, x = moveToPos.x, y = moveToPos.z }):send()
		else			
			myHero:MoveTo(moveToPos.x, moveToPos.z)
		end
	end 
end


function heroCanMove()
	return (GetTickCount() + GetLatency()/2 > lastAttack + lastWindUpTime + 20)
end 
 
 
function timeToShoot()
	return (GetTickCount() + GetLatency()/2 > lastAttack + lastAttackCD)
end


function _smartcore()
_placeShrooms()
_ShroomOnager()
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
			if Menu.harrass.autohrsQ and canQhrs and QReady then				
				cast_pred_q()			
			end			
			if Menu.harrass.autohrsW and canWhrs and WReady then				
				cast_pred_w()	
			end
			if Menu.harrass.autohrsR and canRhrs and RReady then				
				cast_pred_r()			
			end	
end
end

function cast_pred_q()
local QTarget = nil	
	if Menu.specl.qopt.qopt1 == 1 then
		QTarget = Target 
	end	
	if Menu.specl.qopt.qopt1 == 2 then
		local closest = _ClosestEnemy()
		closest = Target
	end	
	if Menu.specl.qopt.qopt1 == 3 then
		local MostAD = _FindIt(Qrange, "addDamage", "Enemy", top)
		if MostAD ~= nil and ValidTarget(MostAD, Qrange) then
			QTarget = MostAD
		end
	end
	if Menu.specl.qopt.qopt1 == 4 then
		local MostAS = _FindIt(Qrange, "attackSpeed", "Enemy", top)
		QTarget = MostAS
	end	
	if QTarget == nil then
		QTarget = Target
	end	
	if QTarget ~= nil and QTarget.visible and not QTarget.dead and ValidTarget(QTarget, Qrange) and QReady then
		_castSpell(_Q, nil, nil, QTarget)
	end	
end


function _ClosestEnemy()
local EnemyUnit, EnemyDist = nil, 50000
for i, enemy in pairs(GetEnemyHeroes()) do
	if not enemy.dead and enemy.visible and ValidTarget(enemy) then
		if GetDistance(enemy) <= EnemyDist then
			EnemyDist = etDistance(enemy)
			EnemyUnit = enemy
		end
	end
end
	return EnemyUnit
end


function _FindIt(range, member, team, pointer)
local FoundUnit, FoundValue = nil, nil
local tmp_Unit, tmp_Value = nil, nil
if (member == "addDamage" or member == "ap" or member == "armor" or member == "attackSpeed" or member == "health" or member == "level" or member == "magicArmor") then	
	if pointer == "top" then FoundValue = 0 end
	if pointer == "bot" then FoundValue = 50000 end		
		if team == "Ally" then	
			for i, ally in pairs(GetAllyHeroes()) do	
				if not ally.dead and ally.visible and GetDistance(ally) < range then
					tmp_Unit = ally
					if member == "addDamage" then 
						tmp_Value = ally.addDamage						
					end
					if member == "ap" then
						tmp_Value = ally.ap
					end
					if member == "armor" then
						tmp_Value = ally.armor
					end
					if member == "attackSpeed" then
						tmp_Value = ally.attackSpeed
					end
					if member == "health" then
						tmp_Value = ally.health
					end
					if member == "level" then
						tmp_Value = ally.level
					end
					if member == "magicArmor" then
						tmp_Value = ally.magicArmor
					end					
					if pointer == "top" then
						if tmp_Value >= FoundValue then 
							FoundValue = tmp_Value
							FoundUnit = tmp_Unit
						end	
					end
					if pointer == "bot" then						
						if tmp_Value < FoundValue then												
							FoundValue = tmp_Value
							FoundUnit = tmp_Unit
							
						end	
					end
				end
			end
		end		
		if team == "Enemy" then
			for i, enemy in pairs(GetEnemyHeroes()) do			
				if not enemy.dead and enemy.visible and GetDistance(enemy) < range then
					tmp_Unit = enemy
					if member == "addDamage" then 
						tmp_Value = enemy.addDamage						
					end
					if member == "ap" then
						tmp_Value = enemy.ap
					end
					if member == "armor" then
						tmp_Value = enemy.armor
					end
					if member == "attackSpeed" then
						tmp_Value = enemy.attackSpeed
					end
					if member == "health" then
						tmp_Value = enemy.health
					end
					if member == "level" then
						tmp_Value = enemy.level
					end
					if member == "magicArmor" then
						tmp_Value = enemy.magicArmor
					end					
					if pointer == "top" then
						if tmp_Value >= FoundValue then 
							FoundValue = tmp_Value
							FoundUnit = tmp_Unit
						end	
					end
					if pointer == "bot" then						
						if tmp_Value < FoundValue then												
							FoundValue = tmp_Value
							FoundUnit = tmp_Unit
							
						end	
					end
				end
			end			
		end		
	if FoundUnit ~= nil and not FoundUnit.dead and FoundUnit.visible then		
		return FoundUnit
	else
		return nil
	end
else
	return nil
end
end


function cast_pred_w()
if WReady then
	_castSpell(_W, myHero.x, myHero.z, nil)
end
end


function cast_pred_r()
local main_cast_pos = nil
	if Menu.ta.co == 1 then
		if Target ~=nil and Target.visible and GetDistance(Target) < Rrange then
			local Position = FreePredictionR:GetPrediction(Target)
			if Position ~= nil and GetDistance(Position) < Rrange then
				main_cast_pos = Position				
			end		
		end	
	end
	if Menu.ta.co == 2 and VIP_USER then
		if Target ~=nil and Target.visible and GetDistance(Target) < Rrange then
			local Position = VipPredictionR:GetPrediction(Target)
			if Position ~= nil then
				main_cast_pos = Position				
			end		
		end	
	end
	if Menu.ta.co == 3 and vpredicfile then 	
			if ValidTarget(Target) and not Target.dead and Target.visible and GetDistance(Target) < Rrange then				
				local Position, HitChance    = VP:GetPredictedPos(Target, Rdelay, Rspeed, myHero, false)
				if HitChance >= minVPhit and Target.visible and GetDistance(Position) < Rrange then
					if Position ~= nil then
						main_cast_pos = Position						
					end
				end	
			end	
	end
	if Menu.ta.co == 4 and prodicfile then
		if ValidTarget(Target) and not Target.dead and Target.visible and GetDistance(Target) < Rrange then
			main_cast_pos = ProdictionR:GetPrediction(Target)
		end
	end	
	if main_cast_pos ~= nil and RReady then			
		_castSpell(_R, main_cast_pos.x, main_cast_pos.z, nil)	
	end	
end


function _placeShrooms()
if not Menu.specl.mine.mine1 then return end
if (Menu.specl.mine.mineauto or Menu.specl.mine.mine2) and RReady and ShroomCounter >= Menu.specl.mine.mineslider then
	if Menu.specl.mine.minevip then _placeShroomVIP() end
	if Menu.specl.mine.minemip then _placeShroomMIP() end
	if Menu.specl.mine.minelip then _placeShroomLIP() end
end
end


function _placeShroomVIP()
for i, spot in pairs(ShroomTableVIP) do
	if GetDistance(spot) <= 250 and not _IsShroom(spot) then
		CastSpell(_R, spot.x, spot.z)
	end
end
end


function _placeShroomMIP()
for i, spot in pairs(ShroomTableMIP) do
	if GetDistance(spot) <=250 and not _IsShroom(spot) then
		CastSpell(_R, spot.x, spot.z)
	end
end
end


function _placeShroomLIP()
for i, spot in pairs(ShroomTableLIP) do
	if GetDistance(spot) <=250 and not _IsShroom(spot) then
		CastSpell(_R, spot.x, spot.z)
	end
end
end


function _IsShroom(place)
	for i=1, objManager.maxObjects do
	local obj = objManager:getObject(i)
		if obj ~= nil and obj.name ~= nil and obj.name:find("Noxious Trap") then
			if GetDistance(obj, place) <= 250 then
				return true
			end
		end
	end	
	return false
end


function _ShroomOnager()
if not Menu.specl.ropt.ropt1 then return end
if ShroomCounter >= Menu.specl.ropt.ropt1slider then	
	local NextShroom = _GetNextShroomTo(myHero)
	if GetDistance(myHero, NextShroom) >= Menu.specl.ropt.ropt1slider2 then		
		_castSpell(_R, myHero.x, myHero.z, nil)	
	end
end
end


function _GetNextShroomTo(ScanUnit)
local ClosestShroomObj, ClosestShroomDist = nil, 50000
for i=1, objManager.maxObjects do
	local obj = objManager:getObject(i)
	if obj ~= nil and obj.name:find("Noxious Trap") then
		local DistSuToObj = GetDistance(ScanUnit, obj)
		if DistSuToObj <= ClosestShroomDist then
			ClosestShroomObj = obj
			ClosestShroomDist = DistSuToObj		
		end
	end
end
	return ClosestShroomObj
end
--[[/OnTick]]--


--[[Utility]]--
function _check_mmasac()
	if checkedMMASAC then return end
	if not (starttick + 5000 < GetTickCount()) then return end
	checkedMMASAC = true
    if _G.MMA_Loaded then
     	print(' >>'..ScriptName..': MMA support loaded.')
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
		Menu.ta.mma:addParam("mmastatus", "Use MMA Target Selector", SCRIPT_PARAM_ONOFF, false)				
	end
	if is_SAC then
		Menu.ta:addSubMenu("Sida's Auto Carry", "sac")
		Menu.ta.sac:addParam("sacstatus", "Use SAC Target Selector", SCRIPT_PARAM_ONOFF, false)
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


function mynamaislowerthen(percent)
    if myHero.mana < (myHero.maxMana * ( percent / 100)) then
        return true
    else
        return false
    end
end


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


function _create_shroom_tables()
ShroomTableVIP = {		
                         { x = 921.46795654297, y = 39.889404296875, z = 12422.21484375},
                         { x = 1499.1662597656, y = 34.766235351563, z = 12988.01953125},
                         { x = 2298.3325195313, y = 30.003173828125, z = 13440.301757813},
                         { x = 2713.0063476563, y = -63.90966796875, z = 10630.198242188},
                         { x = 2515.1171875, y = -64.839721679688, z = 11122.674804688},
                         { x = 2975.3854980469, y = -62.576782226563, z = 10700.487304688},
                         { x = 3244.3505859375, y = -62.547485351563, z = 10755.734375},
                         { x = 3994.9416503906, y = 48.449096679688, z = 11596.635742188},
                         { x = 4139.32421875, y = -61.858642578125, z = 9903.69921875},
                         { x = 4348.1538085938, y = -61.60302734375, z = 9768.2900390625},
                         { x = 4761.8310546875, y = -63.09326171875, z = 9862.34765625},
                         { x = 4171.7451171875, y = -63.068359375, z = 10351.319335938},
                         { x = 3281.0983886719, y = -55.713745117188, z = 9349.4912109375},
                         { x = 3153.3203125, y = 36.545166015625, z = 8962.8525390625},
                         { x = 1891.9038085938, y = 54.14990234375, z = 9499.126953125},
                         { x = 2850.5981445313, y = 55.041748046875, z = 7639.6494140625},
                         { x = 2502.4973144531, y = 55.001098632813, z = 7341.9370117188},
                         { x = 2602.5441894531, y = 55.002197265625, z = 7067.4145507813},
                         { x = 2214.361328125, y = 52.984985351563, z = 7049.8295898438},
                         { x = 2498.62109375, y = 55.916137695313, z = 5075.2387695313},
                         { x = 2083.3215332031, y = 56.314208984375, z = 5145.0546875},
                         { x = 2888.1394042969, y = 54.720703125, z = 6477.1748046875},
                         { x = 3913.8659667969, y = 55.58984375, z = 5810.2133789063},
                         { x = 4137.921875, y = 53.974365234375, z = 6055.1010742188},
                         { x = 4325.3876953125, y = 54.167114257813, z = 6318.9189453125},
                         { x = 4363.681640625, y = 54.954467773438, z = 5830.9155273438},
                         { x = 4373.7373046875, y = 53.943603515625, z = 6877.822265625},
                         { x = 4439.8911132813, y = 52.956787109375, z = 7505.7993164063},
                         { x = 4292.5170898438, y = 52.443237304688, z = 7800.5454101563},
                         { x = 4481.2734375, y = 31.203369140625, z = 8167.3994140625},
                         { x = 4702.11328125, y = -39.108154296875, z = 8327.1357421875},
                         { x = 4840.8349609375, y = -63.086181640625, z = 8923.365234375},
                         { x = 409.01028442383, y = 47.910278320313, z = 7925.912109375},
                         { x = 5320.7036132813, y = 39.920776367188, z = 12485.568359375},
                         { x = 6374.5859375, y = 41.244140625, z = 12730.94921875},
                         { x = 6752.7124023438, y = 44.903564453125, z = 13844.407226563},
                         { x = 7362.7646484375, y = 51.478881835938, z = 11621.13671875},
                         { x = 7856.8012695313, y = 49.970092773438, z = 11622.293945313},
                         { x = 6613.2329101563, y = 54.534423828125, z = 11136.745117188},
                         { x = 6039.8583984375, y = 54.31103515625, z = 11115.771484375},
                         { x = 7863.0927734375, y = 53.14599609375, z = 10073.770507813},
                         { x = 5677.591796875, y = -63.449462890625, z = 9178.7578125},
                         { x = 5907.1650390625, y = -53.438598632813, z = 8993.447265625},
                         { x = 5873.8608398438, y = 53.8046875, z = 9841.0068359375},
                         { x = 5747.2626953125, y = 53.452880859375, z = 10273.5546875},
                         { x = 6823.5209960938, y = 56.019165039063, z = 8457.9013671875},
                         { x = 7046.1997070313, y = 56.019287109375, z = 8671.56640625},
                         { x = 6169.935546875, y = -59.301391601563, z = 8112.6264648438},
                         { x = 4913.3471679688, y = 54.542114257813, z = 7416.4116210938},
                         { x = 5156.5249023438, y = 54.801025390625, z = 7447.9301757813},
                         { x = 7089.7197265625, y = 55.59765625, z = 5860.263671875},
                         { x = 7146.5126953125, y = 55.838500976563, z = 5562.869140625},
                         { x = 8042.4702148438, y = -64.220581054688, z = 6240.8950195313},
                         { x = 9466.8701171875, y = 21.286254882813, z = 6207.2763671875},
                         { x = 9031.029296875, y = -63.957397460938, z = 5445.94140625},
                         { x = 9615.724609375, y = -61.227905273438, z = 4683.6630859375},
                         { x = 9813.8505859375, y = -60.410400390625, z = 4538.2255859375},
                         { x = 10124.901367188, y = -61.733642578125, z = 4861.4521484375},
                         { x = 10776.483398438, y = -13.516723632813, z = 5262.2309570313},
                         { x = 8217.439453125, y = -62.027709960938, z = 5401.1396484375},
                         { x = 10461.926757813, y = -64.395629882813, z = 4236.0048828125},
                         { x = 10691.946289063, y = -64.254760742188, z = 4401.0180664063},
                         { x = 10954.478515625, y = -63.434204101563, z = 4601.060546875},
                         { x = 11357.145507813, y = -54.605102539063, z = 3769.7680664063},
                         { x = 9915.576171875, y = 52.202392578125, z = 2978.8586425781},
                         { x = 9895.92578125, y = 52.180786132813, z = 2750.76171875},
                         { x = 10120.110351563, y = 53.538818359375, z = 2853.455078125},
                         { x = 10525.716796875, y = -36.560668945313, z = 3298.8117675781},
                         { x = 7445.8657226563, y = 55.46875, z = 3257.5419921875},
                         { x = 7904.7578125, y = 56.58203125, z = 3296.7998046875},
                         { x = 8109.4311523438, y = 55.375610351563, z = 4634.1088867188},
                         { x = 8272.7421875, y = 55.947509765625, z = 4302.23046875},
                         { x = 6131.2407226563, y = 51.67333984375, z = 4458.34765625},
                         { x = 5557.1635742188, y = 53.145385742188, z = 4852.1484375},
                         { x = 5011.01171875, y = 54.343505859375, z = 3113.8823242188},
                         { x = 5376.021484375, y = 54.53125, z = 3348.4313964844},
                         { x = 6201.3012695313, y = 53.259399414063, z = 2892.7741699219},
                         { x = 6689.6108398438, y = 55.71728515625, z = 2811.2314453125},
                         { x = 5670.3720703125, y = 55.274536132813, z = 1833.3752441406},
                         { x = 7637.787109375, y = 53.322875976563, z = 1630.271484375},
                         { x = 7356.54296875, y = 54.28955078125, z = 2027.0147705078},
                         { x = 7064.2900390625, y = 55.656616210938, z = 2463.6518554688},
                         { x = 6560.2646484375, y = 51.673461914063, z = 4359.892578125},
                         { x = 7199.0581054688, y = 51.67041015625, z = 4900.568359375},
                         { x = 8820.9375, y = 63.57958984375, z = 1903.0247802734},
                         { x = 11640.668945313, y = 48.783569335938, z = 1058.3022460938},
                         { x = 12412.471679688, y = 48.783569335938, z = 1640.6274414063},
                         { x = 12063.520507813, y = 48.783569335938, z = 1359.0847167969},
                         { x = 12719.424804688, y = 48.783447265625, z = 1965.8095703125},
                         { x = 13265.239257813, y = 48.783569335938, z = 2848.7946777344},
                         { x = 12924.999023438, y = 48.78369140625, z = 2265.1831054688},
                         { x = 12005.322265625, y = 48.927612304688, z = 4917.8154296875},
                         { x = 12195.315429688, y = 54.20849609375, z = 4809.0424804688},
                         { x = 12189.844726563, y = 52.148803710938, z = 5133.8681640625},
                         { x = 11535.673828125, y = 54.859985351563, z = 6743.541015625},
                         { x = 11195.842773438, y = 54.87353515625, z = 6849.5458984375},
                         { x = 10161.522460938, y = 54.838256835938, z = 7404.8989257813},
                         { x = 10823.671875, y = 55.360961914063, z = 7471.75390625},
                         { x = 9550.7607421875, y = 54.681518554688, z = 7851.2338867188},
                         { x = 9609.2841796875, y = 53.629760742188, z = 8623.1123046875},
                         { x = 9738.8759765625, y = 48.228637695313, z = 6176.4951171875},
                         { x = 8515.677734375, y = 55.524291992188, z = 7274.1328125},
                         { x = 9203.1376953125, y = 55.31787109375, z = 6883.65625},
                         { x = 11144.715820313, y = 58.249267578125, z = 8004.6669921875},
                         { x = 11748.110351563, y = 55.689575195313, z = 7680.4853515625},
                         { x = 11933.775390625, y = 55.45849609375, z = 8171.1162109375},
                         { x = 11663.83984375, y = 53.506958007813, z = 8618.32421875},
                         { x = 11783.155273438, y = 50.942749023438, z = 9116.0087890625},
                         { x = 11355.23046875, y = 50.350463867188, z = 9551.4541015625},
                         { x = 12118.708984375, y = 54.836669921875, z = 7175.52734375},
                         { x = 11636.209960938, y = 55.298583984375, z = 7139.6665039063},
                         { x = 12379.048828125, y = 50.354858398438, z = 9417.357421875},
                         { x = 10719.4453125, y = 50.348754882813, z = 9761.5263671875},
                         { x = 9533.9970703125, y = 52.488647460938, z = 10893.603515625},
                         { x = 9010.201171875, y = 54.606811523438, z = 11232.607421875},
                         { x = 8605.5283203125, y = 51.6875, z = 11134.741210938},
                         { x = 8229.3330078125, y = 53.65283203125, z = 10201.456054688},
                         { x = 8200.6875, y = 53.530517578125, z = 9692.642578125},
                         { x = 9170.328125, y = 51.405151367188, z = 12593.346679688},
                         { x = 9200.1787109375, y = 52.487060546875, z = 11952.364257813},
                         { x = 9394.4716796875, y = 52.48291015625, z = 11301.334960938},
                         { x = 13643.55859375, y = 53.597534179688, z = 6827.8857421875},
                         { x = 7424.7919921875, y = 52.602905273438, z = 636.64184570313},
                         { x = 4845.21484375, y = 54.945678710938, z = 1713.1027832031},
                         { x = 4794.412109375, y = 54.408081054688, z = 2377.0554199219},
                         { x = 4687.0810546875, y = 54.071655273438, z = 3056.8149414063},
                         { x = 4472.8857421875, y = 53.9248046875, z = 3690.6577148438},
                         { x = 3267.3359375, y = 56.665649414063, z = 4736.8735351563},
                         { x = 1490.9304199219, y = 57.458129882813, z = 5063.8056640625},
                         { x = 11211.5390625, y = 55.709228515625, z = 5120.58984375},
                         { x = 11028.774414063, y = 54.829711914063, z = 6133.4228515625},
                         { x = 10690.204101563, y = 54.790649414063, z = 6184.8364257813},
                         { x = 11353.065429688, y = -61.857788085938, z = 4208.9169921875},
                         { x = 11054.20703125, y = -63.471801757813, z = 4034.0634765625},
                         { x = 10729.1875, y = -64.608764648438, z = 3886.7646484375},
                         { x = 5222.2001953125, y = -65.250732421875, z = 9170.2705078125},
                         { x = 5256.4858398438, y = -64.5146484375, z = 8881.8447265625},
                         { x = 5374.3110351563, y = -63.622436523438, z = 8581.1083984375},
                         { x = 5544.1318359375, y = -60.822387695313, z = 8338.818359375},
                         { x = 5856.494140625, y = -59.145751953125, z = 8261.908203125},
                         { x = 5315.2211914063, y = 54.801147460938, z = 7194.9370117188},
                         { x = 3382.2592773438, y = 31.458251953125, z = 12508.072265625},
                         { x = 3709.2463378906, y = 37.916381835938, z = 12512.922851563},
                         { x = 5245.1381835938, y = 47.917236328125, z = 11228.446289063},
                         { x = 7275.896484375, y = 53.921508789063, z = 11008.899414063},
                         { x = 7651.9858398438, y = 52.825317382813, z = 10368.020507813},
                         { x = 7562.1123046875, y = 53.961547851563, z = 9783.9619140625},
                         { x = 6124.6577148438, y = 55.156127929688, z = 9741.4228515625},
                         { x = 5846.0161132813, y = 48.514282226563, z = 9410.921875},
                         { x = 4148.1767578125, y = -60.990478515625, z = 9254.2666015625},
                         { x = 3920.0073242188, y = -60.146850585938, z = 9398.7421875},
                         { x = 10604.783203125, y = -63.342529296875, z = 4872.3872070313},
                         { x = 13224.2421875, y = 105.00170898438, z = 10037.708007813},
                         { x = 10424.015625, y = 106.93432617188, z = 10617.844726563},
                         { x = 9731.544921875, y = 106.16320800781, z = 13427.314453125},
                         { x = 813.72741699219, y = 123.41027832031, z = 4628.5424804688},
                         { x = 3681.4140625, y = 124.169921875, z = 3953.0578613281},
                         { x = 4373.1611328125, y = 112.74145507813, z = 1091.2574462891}
				}
ShroomTableMID = {
						 { x = 830.19885253906, y = 43.297973632813, z = 12196.064453125},
                         { x = 1002.2636108398, y = 39.7431640625, z = 12606.44921875},
                         { x = 1341.9880371094, y = 34.954345703125, z = 12888.442382813},
                         { x = 1618.8708496094, y = 34.109985351563, z = 13091.975585938},
                         { x = 2099.8811035156, y = 28.423583984375, z = 13345.768554688},
                         { x = 2450.1613769531, y = 29.797729492188, z = 13530.345703125},
                         { x = 2589.103515625, y = -64.816528320313, z = 10888.958984375},
                         { x = 4172.919921875, y = 47.55224609375, z = 11742.409179688},
                         { x = 4070.7502441406, y = 50.983276367188, z = 11410.64453125},
                         { x = 3683.5805664063, y = 21.094970703125, z = 11240.250976563},
                         { x = 3267.9860839844, y = -60.279663085938, z = 11138.8203125},
                         { x = 2922.6806640625, y = -64.871826171875, z = 11369.1796875},
                         { x = 2600.7807617188, y = -6.84716796875, z = 11719.244140625},
                         { x = 2415.0007324219, y = 41.47900390625, z = 12102.291015625},
                         { x = 2493.4182128906, y = 32.070068359375, z = 12550.186523438},
                         { x = 2297.9140625, y = -15.896850585938, z = 11412.133789063},
                         { x = 1948.0284423828, y = 34.765747070313, z = 11666.334960938},
                         { x = 1575.5043945313, y = 34.55908203125, z = 11608.290039063},
                         { x = 1343.373046875, y = 37.153198242188, z = 11300.724609375},
                         { x = 4528.6801757813, y = -62.958374023438, z = 10623.866210938},
                         { x = 4932.00390625, y = -63.017456054688, z = 10255.55859375},
                         { x = 1842.3879394531, y = 53.532470703125, z = 9733.9296875},
                         { x = 2089.7473144531, y = 53.921264648438, z = 9501.064453125},
                         { x = 1968.9812011719, y = 54.9228515625, z = 8865.5419921875},
                         { x = 2338.9975585938, y = 54.956176757813, z = 8023.5297851563},
                         { x = 2626.009765625, y = 54.983276367188, z = 7770.7890625},
                         { x = 1809.0651855469, y = 53.540771484375, z = 7364.845703125},
                         { x = 2178.9465332031, y = 58.766357421875, z = 6537.892578125},
                         { x = 2208.9782714844, y = 60.175903320313, z = 6067.3901367188},
                         { x = 2385.5910644531, y = 60.0234375, z = 5627.4819335938},
                         { x = 2325.7844238281, y = 55.732055664063, z = 5283.4067382813},
                         { x = 3018.8393554688, y = 55.597412109375, z = 6085.6235351563},
                         { x = 3252.5610351563, y = 55.623657226563, z = 5873.7211914063},
                         { x = 3613.4768066406, y = 55.648193359375, z = 5728.4150390625},
                         { x = 3096.7954101563, y = 54.875610351563, z = 6995.326171875},
                         { x = 3440.6887207031, y = 54.178955078125, z = 7050.7387695313},
                         { x = 3794.2189941406, y = 53.608764648438, z = 7081.9794921875},
                         { x = 3993.8581542969, y = 51.972900390625, z = 8054.2666015625},
                         { x = 4776.35546875, y = -62.829833984375, z = 8621.66796875},
                         { x = 4955.7436523438, y = -63.523071289063, z = 9209.26953125},
                         { x = 4628.1376953125, y = -62.8583984375, z = 9396.798828125},
                         { x = 4361.0498046875, y = -63.051025390625, z = 9228.845703125},
                         { x = 4138.904296875, y = -62.183471679688, z = 9454.5029296875},
                         { x = 3803.6330566406, y = -60.11572265625, z = 9583.2109375},
                         { x = 3509.9680175781, y = -66.196533203125, z = 9733.3115234375},
                         { x = 4566.9755859375, y = 41.517211914063, z = 12161.418945313},
                         { x = 5019.1376953125, y = 41.119140625, z = 12126.727539063},
                         { x = 6661.501953125, y = 53.490112304688, z = 12343.174804688},
                         { x = 6970.1171875, y = 52.837646484375, z = 12085.405273438},
                         { x = 7626.5556640625, y = 50.341552734375, z = 11667.9609375},
                         { x = 8341.810546875, y = 47.06396484375, z = 12586.553710938},
                         { x = 8205.5419921875, y = 47.92236328125, z = 12214.0703125},
                         { x = 7889.9067382813, y = 50.624145507813, z = 12032.254882813},
                         { x = 7497.4301757813, y = 51.829711914063, z = 11971.23046875},
                         { x = 7190.4619140625, y = 52.347290039063, z = 11864.235351563},
                         { x = 6961.5659179688, y = 52.555786132813, z = 11620.447265625},
                         { x = 7123.6372070313, y = 53.401123046875, z = 11309.78125},
                         { x = 6308.7641601563, y = 54.635986328125, z = 11207.370117188},
                         { x = 7558.048828125, y = 53.500854492188, z = 10017.612304688},
                         { x = 7202.2822265625, y = 56.5751953125, z = 9949.486328125},
                         { x = 6877.8330078125, y = 57.489501953125, z = 9839.623046875},
                         { x = 6529.6831054688, y = 56.496337890625, z = 9623.2587890625},
                         { x = 6293.5576171875, y = 56.1796875, z = 9418.0087890625},
                         { x = 6087.5478515625, y = 33.882080078125, z = 9165.1455078125},
                         { x = 5807.6079101563, y = 54.070190429688, z = 10058.47265625},
                         { x = 6520.0327148438, y = 56.119018554688, z = 8979.7216796875},
                         { x = 6743.158203125, y = 56.018676757813, z = 8794.416015625},
                         { x = 5956.12109375, y = -55.971435546875, z = 7963.599609375},
                         { x = 6353.3598632813, y = -63.236083984375, z = 8293.9111328125},
                         { x = 6217.9921875, y = 0.1793212890625, z = 7466.6376953125},
                         { x = 6309.625, y = 55.228149414063, z = 7129.302734375},
                         { x = 6072.7607421875, y = 55.029541015625, z = 6937.6171875},
                         { x = 6776.5131835938, y = 55.169921875, z = 6342.0727539063},
                         { x = 6981.2827148438, y = 55.234130859375, z = 6576.6904296875},
                         { x = 7270.3120117188, y = 12.109008789063, z = 6434.03125},
                         { x = 7797.7431640625, y = -64.507446289063, z = 6085.8911132813},
                         { x = 8242.8203125, y = -65.101440429688, z = 6449.7436523438},
                         { x = 10432.211914063, y = -64.138061523438, z = 5127.8701171875},
                         { x = 9881.216796875, y = -57.960571289063, z = 5304.4833984375},
                         { x = 9418.724609375, y = -63.03857421875, z = 5522.458984375},
                         { x = 8949.6220703125, y = -64.691528320313, z = 5851.3208007813},
                         { x = 8645.5166015625, y = -64.037475585938, z = 6045.69140625},
                         { x = 7911.216796875, y = 14.376342773438, z = 5357.1298828125},
                         { x = 8090.6645507813, y = 50.096801757813, z = 5008.0751953125},
                         { x = 8578.615234375, y = -64.168212890625, z = 5348.1962890625},
                         { x = 9780.8447265625, y = -60.323852539063, z = 4086.7553710938},
                         { x = 9286.6044921875, y = -60.821044921875, z = 4567.8061523438},
                         { x = 11513.756835938, y = -55.671020507813, z = 3558.6372070313},
                         { x = 7704.0825195313, y = 54.697387695313, z = 3203.8781738281},
                         { x = 8245.884765625, y = 55.567626953125, z = 4481.0498046875},
                         { x = 5158.1303710938, y = 54.566528320313, z = 3337.4165039063},
                         { x = 6449.8520507813, y = 54.914306640625, z = 2846.3041992188},
                         { x = 5987.5874023438, y = 54.33203125, z = 2695.974609375},
                         { x = 7327.458984375, y = 52.747802734375, z = 4617.9311523438},
                         { x = 8757.6025390625, y = 54.303100585938, z = 2293.3483886719},
                         { x = 9873.966796875, y = 67.61669921875, z = 2220.8247070313},
                         { x = 10133.03515625, y = 61.036743164063, z = 2400.3395996094},
                         { x = 10212.555664063, y = 71.440307617188, z = 2041.4992675781},
                         { x = 10402.84765625, y = 66.650146484375, z = 2286.3129882813},
                         { x = 10527.239257813, y = 52.385986328125, z = 1974.4881591797},
                         { x = 10360.399414063, y = 51.8466796875, z = 1704.0219726563},
                         { x = 10950.71875, y = 54.8701171875, z = 6878.2861328125},
                         { x = 9643.9990234375, y = 54.905517578125, z = 7553.4931640625},
                         { x = 9954.703125, y = 55.214599609375, z = 6472.8916015625},
                         { x = 11481.409179688, y = 53.455322265625, z = 8945.13671875},
                         { x = 12055.408203125, y = 50.354858398438, z = 9477.19921875},
                         { x = 11725.150390625, y = 50.3525390625, z = 9456.052734375},
                         { x = 9206.9560546875, y = 52.493896484375, z = 11030.771484375},
                         { x = 4817.3198242188, y = 53.958618164063, z = 3417.3413085938},
                         { x = 9953.197265625, y = 57.401000976563, z = 8610.62109375},
                         { x = 10321.522460938, y = 66.448486328125, z = 8763.8125},
                         { x = 12484.79296875, y = 54.808959960938, z = 7088.17578125},
                         { x = 12687.19921875, y = 54.84375, z = 6692.1787109375},
                         { x = 12792.244140625, y = 56.218505859375, z = 6409.115234375},
                         { x = 12354.852539063, y = 54.821533203125, z = 6037.4809570313},
                         { x = 12835.203125, y = 58.21435546875, z = 6101.26953125},
                         { x = 12497.07421875, y = 51.944946289063, z = 5024.5258789063},
                         { x = 11664.420898438, y = 51.983764648438, z = 4524.75390625},
                         { x = 11575.427734375, y = 56.321166992188, z = 4989.9970703125},
                         { x = 10983.258789063, y = -54.296264648438, z = 3735.3195800781},
                         { x = 10978.331054688, y = 54.855590820313, z = 6492.98046875},
                         { x = 3557.8977050781, y = 35.097290039063, z = 12205.703125},
                         { x = 3843.8930664063, y = 41.10791015625, z = 12242.84765625},
                         { x = 3791.6662597656, y = 43.127197265625, z = 11937.227539063},
                         { x = 4359.8833007813, y = 51.46142578125, z = 11524.569335938},
                         { x = 7200.095703125, y = 55.742065429688, z = 3028.7668457031},
                         { x = 6562.9995117188, y = 51.670288085938, z = 3860.3747558594},
                         { x = 6777.2568359375, y = 51.673095703125, z = 4558.1303710938},
                         { x = 6393.5366210938, y = 51.67333984375, z = 4632.77734375},
                         { x = 7601.4150390625, y = 54.977172851563, z = 4675.103515625},
                         { x = 11334.03125, y = 106.26782226563, z = 10205.711914063},
                         { x = 11711.361328125, y = 106.8134765625, z = 10171.911132813},
                         { x = 12112.6171875, y = 106.81298828125, z = 10125.672851563},
                         { x = 9828.548828125, y = 106.20922851563, z = 12515.264648438},
                         { x = 9883.50390625, y = 106.21569824219, z = 12163.2734375},
                         { x = 9940.3408203125, y = 106.22326660156, z = 11800.89453125},
                         { x = 1753.7075195313, y = 108.36413574219, z = 4200.0795898438},
                         { x = 2105.0307617188, y = 109.25891113281, z = 4171.3740234375},
                         { x = 2433.2739257813, y = 106.26892089844, z = 4113.4072265625},
                         { x = 2761.220703125, y = 106.28112792969, z = 4033.27734375},
                         { x = 3809.6437988281, y = 110.69775390625, z = 3152.8403320313},
                         { x = 3925.6823730469, y = 109.72583007813, z = 2823.3295898438},
                         { x = 4000.2648925781, y = 109.68811035156, z = 2532.3662109375},
                         { x = 4035.48046875, y = 109.22155761719, z = 2209.0534667969},
                         { x = 4097.1752929688, y = 108.27429199219, z = 1860.681640625},
                         { x = 11564.52734375, y = 106.49267578125, z = 10608.416992188},
                         { x = 3678.8181152344, y = 108.81628417969, z = 1869.7531738281},
                         { x = 2399.2399902344, y = 106.52795410156, z = 3639.1828613281}	
}
ShroomTableLIP = {
						 { x = 3372.0583496094, y = -65.492065429688, z = 10338.30078125},
                         { x = 3571.6953125, y = -65.892944335938, z = 10122.9375},
                         { x = 3798.7873535156, y = -61.715209960938, z = 9910.177734375},
                         { x = 1988.8308105469, y = 54.923828125, z = 8321.232421875},
                         { x = 4078.7719726563, y = 53.832397460938, z = 6976.4072265625},
                         { x = 4242.6000976563, y = 54.348754882813, z = 6607.130859375},
                         { x = 4364.8828125, y = -62.968139648438, z = 8832.0546875},
                         { x = 4050.3933105469, y = -57.981811523438, z = 9044.724609375},
                         { x = 3781.57421875, y = -58.368530273438, z = 9226.8359375},
                         { x = 2857.8703613281, y = -64.637573242188, z = 10224.404296875},
                         { x = 3014.033203125, y = -65.30224609375, z = 9941.0712890625},
                         { x = 3194.505859375, y = -64.0302734375, z = 9670.908203125},
                         { x = 3303.2451171875, y = -64.96240234375, z = 10000.95703125},
                         { x = 463.42907714844, y = 49.611206054688, z = 7734.8540039063},
                         { x = 430.61758422852, y = 47.0341796875, z = 8092.296875},
                         { x = 325.08465576172, y = 184.6142578125, z = 410.50189208984},
                         { x = 5118.9594726563, y = 40.066040039063, z = 12450.451171875},
                         { x = 5495.4482421875, y = 40.013671875, z = 12537.749023438},
                         { x = 6742.9643554688, y = 53.4638671875, z = 11403.331054688},
                         { x = 6874.5864257813, y = 53.442138671875, z = 11146.3515625},
                         { x = 7048.556640625, y = 53.868896484375, z = 10885.556640625},
                         { x = 7426.8100585938, y = 53.896484375, z = 10748.78515625},
                         { x = 5465.5576171875, y = 54.917114257813, z = 10240.125976563},
                         { x = 5541.3774414063, y = 54.741455078125, z = 9844.1591796875},
                         { x = 5415.8193359375, y = 54.384033203125, z = 10582.80859375},
                         { x = 5268.5439453125, y = 51.734130859375, z = 10928.462890625},
                         { x = 5014.3740234375, y = 49.343505859375, z = 11167.96484375},
                         { x = 4679.8891601563, y = 51.196899414063, z = 11359.071289063},
                         { x = 5617.4321289063, y = 51.087036132813, z = 11135.063476563},
                         { x = 5706.6967773438, y = 53.925048828125, z = 10739.166992188},
                         { x = 5970.2431640625, y = -64.826293945313, z = 8529.310546875},
                         { x = 5669.5219726563, y = -65.473266601563, z = 8759.6953125},
                         { x = 5110.00390625, y = -62.017456054688, z = 8439.0166015625},
                         { x = 8222.703125, y = -62.781005859375, z = 5845.9658203125},
                         { x = 8502.58984375, y = -65.771362304688, z = 5730.3666992188},
                         { x = 9363.701171875, y = -60.376831054688, z = 5178.1845703125},
                         { x = 9719.7431640625, y = -59.874389648438, z = 5029.5512695313},
                         { x = 9067.4501953125, y = -62.40283203125, z = 4288.2602539063},
                         { x = 9126.8369140625, y = -63.255859375, z = 3976.4150390625},
                         { x = 9458.056640625, y = -63.266357421875, z = 3828.2639160156},
                         { x = 10174.196289063, y = 40.038696289063, z = 3240.1518554688},
                         { x = 9567.4794921875, y = 56.1328125, z = 2934.0551757813},
                         { x = 9244.5048828125, y = 55.335205078125, z = 3090.3955078125},
                         { x = 8933.13671875, y = 63.050170898438, z = 3247.2666015625},
                         { x = 8615.861328125, y = 57.4013671875, z = 3424.4494628906},
                         { x = 8307.966796875, y = 56.477416992188, z = 3580.4375},
                         { x = 5842.1791992188, y = 51.676025390625, z = 4768.8002929688},
                         { x = 5779.3642578125, y = 51.680053710938, z = 4460.1416015625},
                         { x = 5548.4755859375, y = 52.599487304688, z = 3985.1899414063},
                         { x = 5580.6918945313, y = 53.492919921875, z = 3584.5119628906},
                         { x = 5678.3041992188, y = 53.618286132813, z = 3254.5212402344},
                         { x = 5849.0395507813, y = 53.905639648438, z = 2971.9689941406},
                         { x = 5773.6801757813, y = 55.286376953125, z = 2148.1328125},
                         { x = 5965.4858398438, y = 55.307006835938, z = 2374.3132324219},
                         { x = 6227.5815429688, y = 55.456787109375, z = 2527.2998046875},
                         { x = 6500.6596679688, y = 55.517333984375, z = 2520.7216796875},
                         { x = 6771.2817382813, y = 55.665161132813, z = 2480.2241210938},
                         { x = 9025.099609375, y = 68.644287109375, z = 2336.8161621094},
                         { x = 9314.2255859375, y = 67.419311523438, z = 2328.7436523438},
                         { x = 9610.3193359375, y = 67.892333984375, z = 2225.2492675781},
                         { x = 11861.71875, y = 48.78369140625, z = 1235.7043457031},
                         { x = 12247.197265625, y = 48.783447265625, z = 1507.2700195313},
                         { x = 13103.169921875, y = 48.783569335938, z = 2538.4204101563},
                         { x = 12562.094726563, y = 48.78369140625, z = 1815.8265380859},
                         { x = 11096.672851563, y = -64.211303710938, z = 2858.0717773438},
                         { x = 11342.694335938, y = -60.20947265625, z = 3047.0815429688},
                         { x = 11601.439453125, y = -49.331176757813, z = 3220.662109375},
                         { x = 12051.541015625, y = 56.045288085938, z = 5427.96875},
                         { x = 12049.213867188, y = 62.136108398438, z = 5752.6596679688},
                         { x = 11481.485351563, y = 54.870483398438, z = 6445.2900390625},
                         { x = 10528.846679688, y = 55.335693359375, z = 7442.0048828125},
                         { x = 9686.4296875, y = 62.65966796875, z = 8327.7919921875},
                         { x = 9751.3525390625, y = 55.3994140625, z = 7964.4140625},
                         { x = 9891.2861328125, y = 54.82080078125, z = 7611.28125},
                         { x = 9700.578125, y = 54.96435546875, z = 7220.9057617188},
                         { x = 9536.650390625, y = 55.12841796875, z = 6979.3916015625},
                         { x = 9775.3525390625, y = 55.119873046875, z = 6767.3012695313},
                         { x = 9699.216796875, y = 55.236450195313, z = 6508.6967773438},
                         { x = 8731.884765625, y = 56.117065429688, z = 7103.4155273438},
                         { x = 8945.26953125, y = 55.947387695313, z = 6986.5659179688},
                         { x = 11169.331054688, y = 55.336791992188, z = 7659.8916015625},
                         { x = 11233.795898438, y = 55.3447265625, z = 7323.283203125},
                         { x = 11401.9296875, y = 54.936645507813, z = 7079.2719726563},
                         { x = 11848.16015625, y = 55.085571289063, z = 7296.6391601563},
                         { x = 11528.186523438, y = 55.418579101563, z = 7468.5400390625},
                         { x = 10993.306640625, y = 50.348510742188, z = 9653.6826171875},
                         { x = 8158.2529296875, y = 49.935546875, z = 11612.653320313},
                         { x = 8333.0546875, y = 49.935424804688, z = 11375.90234375},
                         { x = 8081.7431640625, y = 49.935424804688, z = 11304.47265625},
                         { x = 8300.5087890625, y = 49.935546875, z = 11045.23828125},
                         { x = 8447.4091796875, y = 53.658325195313, z = 10671.1328125},
                         { x = 8301.736328125, y = 53.670654296875, z = 10440.4296875},
                         { x = 9178.97265625, y = 52.488159179688, z = 12255.377929688},
                         { x = 9290.4130859375, y = 52.4853515625, z = 11625.76171875},
                         { x = 13694.413085938, y = 54.448608398438, z = 6606.8291015625},
                         { x = 7238.2846679688, y = 52.590454101563, z = 647.10113525391},
                         { x = 4815.3349609375, y = 54.278686523438, z = 2030.3173828125},
                         { x = 4768.740234375, y = 54.306518554688, z = 2709.9868164063},
                         { x = 4524.435546875, y = 53.909545898438, z = 3336.2563476563},
                         { x = 2996.748046875, y = 57.29443359375, z = 4854.4013671875},
                         { x = 2664.6518554688, y = 56.847290039063, z = 4849.02734375},
                         { x = 1837.8842773438, y = 55.985107421875, z = 4913.1982421875},
                         { x = 2234.5522460938, y = 56.322509765625, z = 4951.9467773438},
                         { x = 10691.6875, y = 68.870361328125, z = 8699.0830078125},
                         { x = 10937.659179688, y = 68.1904296875, z = 8511.58984375},
                         { x = 11093.2578125, y = 61.725830078125, z = 8281.328125},
                         { x = 13584.631835938, y = 49.900268554688, z = 9396.3232421875},
                         { x = 13584.990234375, y = 49.79443359375, z = 9015.7939453125},
                         { x = 13589.747070313, y = 49.483032226563, z = 8525.0322265625},
                         { x = 13620.759765625, y = 48.930297851563, z = 8122.2890625},
                         { x = 13611.727539063, y = 49.224243164063, z = 7708.48828125},
                         { x = 13593.979492188, y = 51.592651367188, z = 7257.1884765625},
                         { x = 12792.087890625, y = 54.060668945313, z = 7212.9130859375},
                         { x = 12829.2578125, y = 58.275512695313, z = 5804.7563476563},
                         { x = 12768.625, y = 54.05859375, z = 5494.5966796875},
                         { x = 12670.657226563, y = 51.939453125, z = 5237.720703125},
                         { x = 10774.420898438, y = 53.063598632813, z = 5690.9868164063},
                         { x = 11028.721679688, y = 53.161987304688, z = 5641.1059570313},
                         { x = 11337.638671875, y = 53.214965820313, z = 5547.7495117188},
                         { x = 11221.434570313, y = 54.87109375, z = 6544.0541992188},
                         { x = 4138.2197265625, y = 42.371459960938, z = 12293.63671875},
                         { x = 4069.3923339844, y = 43.9326171875, z = 12010.631835938},
                         { x = 7402.6079101563, y = 53.842163085938, z = 10457.609375},
                         { x = 7180.0991210938, y = 55.223510742188, z = 2249.0598144531},
                         { x = 7613.5390625, y = 54.276977539063, z = 1926.3723144531},
                         { x = 6984.2534179688, y = 55.70068359375, z = 2767.4287109375},
                         { x = 6954.1494140625, y = 55.7412109375, z = 3158.0170898438},
                         { x = 7543.0810546875, y = 54.70654296875, z = 4974.7763671875},
                         { x = 7539.3481445313, y = 56.556884765625, z = 5353.6845703125},
                         { x = 7814.7265625, y = 55.213989257813, z = 4886.8881835938},
                         { x = 10339.112304688, y = -62.325561523438, z = 4628.2255859375},
                         { x = 10147.58984375, y = -60.574829101563, z = 5262.25390625},
                         { x = 9277.5322265625, y = -64.350952148438, z = 5916.9809570313}	
}				
end
--[[/Utility]]--

