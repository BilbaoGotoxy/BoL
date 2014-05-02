if myHero.charName ~= "Corki" then return end
--[[       ----------------------------------------------------------------------------------------------       ]]--
--[[			BilbaoCorki by Bilbao	    					   	 	        ]]--
--[[       ----------------------------------------------------------------------------------------------       ]]--


-------Auto update-------
local CurVer = 0.1 
local NetVersion = nil 
local NeedUpdate = false 
local Do_Once = true 
local ScriptName = "BilbaoCorki"
local NetFile = "http://bilbao.lima-city.de/BilbaoCorki.lua" 
local LocalFile = BOL_PATH.."Scripts\\BilbaoCorki.lua" 
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
	local Qrange, Qwidth, Qspeed, Qdelay = 825, 250, 850, 0.5	
	local Wrange, Wwidth, Wspeed, Wdelay = 800, 40, 650, 0.15	
	local Erange, Ewidth, Espeed, Edelay = 585, 100, 1750, 0.5	
	local Rrange, Rwidth, Rspeed, Rdelay = 1225, 40, 825, 0.5
	
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
	local myTrueRange = 550	
	-------/Orbwalk & Farm info-------
	
	
	-------MMA & SAC info-------
	local starttick = 0
	local checkedMMASAC = false
	local is_MMA = false
	local is_SAC = false
	-------/MMA & SAC info-------
	
	
	-------Target info-------
	local TarsRange = 1225
	local ts = nil
	local Target = nil	
	-------/Target info-------	
	
	-------Autolvl info-------
	local abilitylvl = 0
	local lvlsequence = 1 
	-------/Autolvl info-------
	
	
--[[       ----------------------------------------------------------------------------------------------       ]]--
--[[						Callbacks							]]--
--[[       ----------------------------------------------------------------------------------------------       ]]--	


--[OnLoad]--
function OnLoad()	
	starttick = GetTickCount()
	_loadP()
	_load_menu()
	_initiateTS()
	PrintChat("<font color='#40FF00'> >> "..ScriptName.." v."..CurVer.." - loaded</font>")
end


function _loadP()
	if prodicfile then
		Prodiction = ProdictManager.GetInstance()
		ProdictionQ = Prodiction:AddProdictionObject(_Q, Qrange, Qspeed, Qdelay, Qwidth) 
		ProdictionW = Prodiction:AddProdictionObject(_W, Wrange, Wspeed, Wdelay, Wwidth) 
		ProdictionE = Prodiction:AddProdictionObject(_E, Erange, Espeed, Edelay, Ewidth) 
		ProdictionR = Prodiction:AddProdictionObject(_R, Rrange, Rspeed, Rdelay, Rwidth) 
	end
	if vpredicfile then			
		VP = VPrediction()	
	end
	if VIP_USER then
		VipPredictionQ = TargetPredictionVIP(Qrange, Qspeed, Qdelay, Qwidth, myHero) 
		VipPredictionW = TargetPredictionVIP(Wrange, Wspeed, Wdelay, Wwidth, myHero) 
		VipPredictionE = TargetPredictionVIP(Erange, Espeed, Edelay, Ewidth, myHero) 
		VipPredictionR = TargetPredictionVIP(Rrange, Rspeed, Rdelay, Rwidth, myHero) 
	end	
		FreePredictionQ = TargetPrediction(Qrange, (Qspeed / 1000), (Qdelay * 1000), Qwidth)
		FreePredictionW = TargetPrediction(Wrange, (Wspeed / 1000), (Wdelay * 1000), Wwidth)
		FreePredictionE = TargetPrediction(Erange, (Espeed / 1000), (Edelay * 1000), Ewidth)
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
					Menu.draw.drawsub2:addParam("drawW", "Draw W-Range", SCRIPT_PARAM_ONOFF, true)
					Menu.draw.drawsub2:addParam("drawE", "Draw E-Range", SCRIPT_PARAM_ONOFF, true)
					Menu.draw.drawsub2:addParam("drawR", "Draw R-Range", SCRIPT_PARAM_ONOFF, true)				
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
				Menu.specl:addSubMenu("W-Options", "wopt")
					Menu.specl.wopt:addParam("wopt1", "Use W to Escape", SCRIPT_PARAM_ONOFF, false)
					Menu.specl.wopt:addParam("wopt1slider", "Fly to Mouse if Health below",  SCRIPT_PARAM_SLICE, 50, 0, 100, 0) 
					Menu.specl.wopt:addParam("wopt2", "Attack with W", SCRIPT_PARAM_ONOFF, false)
					Menu.specl.wopt:addParam("wopt2slider", "Attack only if health above",  SCRIPT_PARAM_SLICE, 50, 0, 100, 0)					
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
end
--[[/OnProcessSpell]]--


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
		if Menu.draw.drawsub2.drawW and WReady then
			DrawCircle(myHero.x, myHero.y, myHero.z, Wrange, ARGB(100, 27, 250, 27))
		end
		if Menu.draw.drawsub2.drawE and EReady then
			DrawCircle(myHero.x, myHero.y, myHero.z, Erange, ARGB(100, 27, 27, 250))
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
cast_escape_w()
if (Menu.keys.permrota or Menu.keys.okdrota) then
			if Menu.rota.useQ and canQrota and QReady then			
				cast_pred_q()					
			end
			if Menu.rota.useW and canWrota and WReady then
				cast_pred_w()	
			end
			if Menu.rota.useE and canErota and EReady then
				cast_pred_e()	
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
			if Menu.harrass.autohrsE and canEhrs and EReady then				
				cast_pred_e()			
			end
			if Menu.harrass.autohrsR and canRhrs and RReady then				
				cast_pred_r()			
			end	
end
end


function cast_pred_q()
local main_cast_pos = nil
	if Menu.ta.co == 1 then
		if Target ~=nil and Target.visible and GetDistance(Target) < Qrange then
			local Position = FreePredictionQ:GetPrediction(Target)
			if Position ~= nil and GetDistance(Position) < Qrange then
				main_cast_pos = Position				
			end		
		end	
	end
	if Menu.ta.co == 2 and VIP_USER then
		if Target ~=nil and Target.visible and GetDistance(Target) < Qrange then
			local Position = VipPredictionQ:GetPrediction(Target)
			if Position ~= nil then
				main_cast_pos = Position				
			end		
		end	
	end
	if Menu.ta.co == 3 and vpredicfile then
			if ValidTarget(Target) and not Target.dead and Target.visible and GetDistance(Target) < Qrange then
				local CastPosition,  HitChance,  Position = VP:GetCircularCastPosition(Target, Qdelay, Qwidth, Qrange, Qspeed, myHero, false)
				if HitChance >= minVPhit and Target.visible and GetDistance(CastPosition) < Qrange then
					if CastPosition ~= nil then
						main_cast_pos = CastPosition						
					end
				end	
			end	
	end	
	if Menu.ta.co == 4 and prodicfile then
		if ValidTarget(Target) and not Target.dead and Target.visible and GetDistance(Target) < Qrange then
			main_cast_pos = ProdictionQ:GetPrediction(Target)

		end
	end	
	if main_cast_pos ~= nil and QReady then			
		_castSpell(_Q, main_cast_pos.x, main_cast_pos.z, nil)	
	end	
end


function cast_escape_w()
if not Menu.specl.wopt.wopt1 then return end
if not myhealthislowerthen(Menu.specl.wopt.wopt1slider) then return end
local flyToPos = myHero + (Vector(mousePos) - myHero):normalized() * Wrange
_castSpell(_W, flyToPos.x, flyToPos.z, nil)
end


function cast_pred_w()
if not Menu.specl.wopt.wopt2 then return end
if myhealthislowerthen(Menu.specl.wopt.wopt2slider) then return end
local main_cast_pos = nil
	if Menu.ta.co == 1 then
		if Target ~=nil and Target.visible and GetDistance(Target) < Wrange then
			local Position = FreePredictionW:GetPrediction(Target)
			if Position ~= nil and GetDistance(Position) < Wrange then
				main_cast_pos = Position				
			end		
		end	
	end	
	if Menu.ta.co == 2 and VIP_USER then
		if Target ~=nil and Target.visible and GetDistance(Target) < Wrange then
			local Position = VipPredictionW:GetPrediction(Target)
			if Position ~= nil then
				main_cast_pos = Position				
			end		
		end	
	end	
	if Menu.ta.co == 3 and vpredicfile then	
			if ValidTarget(Target) and not Target.dead and Target.visible and GetDistance(Target) < Wrange then
				local CastPosition,  HitChance,  Position = VP:GetCircularCastPosition(Target, Wdelay, Wwidth, Wrange, Wspeed, myHero, false)
				if HitChance >= minVPhit and Target.visible and GetDistance(CastPosition) < Wrange then
					if CastPosition ~= nil then
						main_cast_pos = CastPosition						
					end
				end	
			end	
	end	
	if Menu.ta.co == 4 and prodicfile then
		if ValidTarget(Target) and not Target.dead and Target.visible and GetDistance(Target) < Wrange then
			main_cast_pos = ProdictionW:GetPrediction(Target)
		end
	end	
	if main_cast_pos ~= nil and WReady then			
		_castSpell(_W, main_cast_pos.x, main_cast_pos.z, nil)	
	end	
end


function cast_pred_e()
local main_cast_pos = nil
	if Menu.ta.co == 1 then
		if Target ~=nil and Target.visible and GetDistance(Target) < Erange then
			local Position = FreePredictionE:GetPrediction(Target)
			if Position ~= nil and GetDistance(Position) < Erange then
				main_cast_pos = Position				
			end		
		end	
	end
	if Menu.ta.co == 2 and VIP_USER then
		if Target ~=nil and Target.visible and GetDistance(Target) < Erange then
			local Position = VipPredictionE:GetPrediction(Target)
			if Position ~= nil then
				main_cast_pos = Position				
			end		
		end	
	end
	if Menu.ta.co == 3 and vpredicfile then	
			if ValidTarget(Target) and not Target.dead and Target.visible and GetDistance(Target) < Erange then		
				local Position, HitChance = VP:GetPredictedPos(Target, Edelay, Espeed, myHero, false)
				if HitChance >= minVPhit and Target.visible and GetDistance(Position) < Erange then
					if Position ~= nil then
						main_cast_pos = Position						
					end
				end	
			end	
	end	
	if Menu.ta.co == 4 and prodicfile then
		if ValidTarget(Target) and not Target.dead and Target.visible and GetDistance(Target) < Wrange then
			main_cast_pos = ProdictionE:GetPrediction(Target)
		end
	end	
	if main_cast_pos ~= nil and EReady then			
		_castSpell(_E, main_cast_pos.x, main_cast_pos.z, nil)	
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
				local CastPosition,  HitChance,  Position = VP:GetLineCastPosition(Target, Rdelay, Rwidth, Rrange, Rspeed, myHero, true)
				if HitChance >= minVPhit and Target.visible and GetDistance(CastPosition) < Rrange then
					if CastPosition ~= nil then
						main_cast_pos = CastPosition						
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


function myhealthislowerthen(percent)
    if myHero.health < (myHero.maxHealth * ( percent / 100)) then
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
--[[/Utility]]--
