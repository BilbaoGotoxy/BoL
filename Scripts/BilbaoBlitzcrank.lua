if myHero.charName ~= "Blitzcrank" then return end
--[[       ------------------------------------------       ]]--
--[[				BilbaoBlitzcrank by Bilbao				]]--
--[[       ------------------------------------------       ]]--

--[[The only think where you are allowed to change smth]]--
local AllowAutoUpdate = true
local ShowDebugText = false
--[[ends here!]]--

-------Auto update-------
local CurVer = 0.6
local NetVersion = nil
local NeedUpdate = false
local Do_Once = true
local ScriptName = "BilbaoBlitzcrank"
local NetFile = "http://bilbao.lima-city.de/"..ScriptName..".lua"
local LocalFile = BOL_PATH.."Scripts\\"..ScriptName..".lua"
-------/Auto update-------


function CheckVersion(data)
	NetVersion = tonumber(data)
	if type(NetVersion) ~= "number" then return end
	if NetVersion and NetVersion > CurVer then
		print("<font color='#FF4000'> >> "..ScriptName..": New version available "..NetVersion..".</font>") 
		print("<font color='#FF4000'> >> "..ScriptName..": Updating, please do not press F9 until update is finished.</font>") 
		NeedUpdate = true  
	else
		print("<font color='#00BFFF' >> "..ScriptName..": You have the lastest version.</font>") 
	end
end


function UpdateScript()
	if Do_Once then	
		Do_Once = false
		DownloadAll()
		if _G.UseUpdater == nil or _G.UseUpdater == true then 			
			GetAsyncWebResult("bilbao.lima-city.de", ScriptName.."ver.txt", CheckVersion)			
		end
	end	
	if NeedUpdate then
		NeedUpdate = false
		DownloadFile(NetFile, LocalFile, function()
							if FileExist(LocalFile) then
								print("<font color='#00BFFF'> >> "..ScriptName..": Successfully updated v"..CurVer.." -> v"..NetVersion.." - Please reload.</font>")								
							end
						end
				)
	end
end
if AllowAutoUpdate then AddTickCallback(UpdateScript) end
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
_G.sowfile = false
_G.is_SOW = false


if VIP_USER then
	if FileExist(SCRIPT_PATH..'Common/Prodiction.lua') then
		require "Prodiction"
		if FileExist(SCRIPT_PATH..'Common/Collision.lua')then
			require "Collision"
			prodicfile = true
			prodic = true
		else
			print("<font color='#FF4000'> >> "..ScriptName..": Prodiction found but Collision missing. Please download Collision.</font>")
		end
	end
		if FileExist(SCRIPT_PATH..'Common/VPrediction.lua') then
			require "VPrediction"
			vpredic = true
            vpredicfile = true
			if FileExist(SCRIPT_PATH..'Common/SOW.lua') then
			    require "SOW"
				sowfile = true
				is_SOW = true 
			end
		else                           
			freevippredicfile = true
        end            
    else
	freepredicfile = true       
end



	-------Skills info-------	
	local Qrange, Qwidth, Qspeed, Qdelay = 1040, 70, 1820, 0.23
	local Wrange, Wwidth, Wspeed, Wdelay = 1, 1, 7777, 0.25	
	local Erange, Ewidth, Espeed, Edelay = 250, 1, 7777, 0.25	
	local Rrange, Rwidth, Rspeed, Rdelay = 1, 600, 7777, 0.25
	
	local QReady, WReady, EReady, RReady = false, false, false, false
	local canQhrs, canWhrs, canEhrs, canRhrs = false, false, false, false
	local canQrota, canWrota, canErota, canRrota = false, false, false, false
	local canQlc, canWlc, canElc, canRlc = false, false, false, false

	
	local MyBasicRange = 7
	-------/Skills info-------


	-------Predictions-------
	local VP = nil
	local minVPhit = 2
	------/Predictions-------
	
	
	-------Orbwalk info-------
	local starttick = 0
	local checkedMMASAC = false
	local is_MMA = false
	local is_SAC = false
	local is_SOWon = false
	-------/Orbwalk info-------
	
	
	-------Target info-------
	local qts, ets, rts = nil, nil, nil
	local Target = nil
	local SelectedTarget
	local MyMinionManager = nil
	local MarkIt, QMark, QMCP
	local QCD = false
	local forced = false
	local ManQHit, ManQTextUnit
	local ManQTar
	-------/Target info-------
	
	
	-------Autolvl info-------
	local abilitylvl = 0
	local lvlsequence = 1 
	-------/Autolvl info-------

	
	
	
	
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
		{name = "AlZaharNetherGrasp", menuname = "Malzahar (R)"},	
		{name = "VolibearQ", menuname = "Volibear (Q)"},		
		{name = "MonkeyKingSpinToWin", menuname = "Wukong (R)"},
		{name = "XerathLocusOfPower2", menuname = "Xerath (R)"},
		{name = "ZacR", menuname = "Zac (R)"}
	}
	-------/Interuptions-------
	
	
	
--[[       ----------------------------------------------       ]]--
--[[						Callbacks							]]--
--[[       ----------------------------------------------       ]]--	


--[OnLoad]--
function OnLoad()
	Debug("OnLoad")
	starttick = GetTickCount()
	_loadP()
	_loadSOW()
	_load_menu()
	_initiateTS()
	MyBasicRange = myHero.range + (GetDistance(myHero.minBBox) - 3)
	PrintChat("<font color='#40FF00'> >> "..ScriptName.." v."..CurVer.." - loaded</font>")
end


function _loadP()
	if prodicfile and VIP_USER then
		Prodiction = ProdictManager.GetInstance()
		ProdictionQ = Prodiction:AddProdictionObject(_Q, Qrange, Qspeed, Qdelay, Qwidth)
		QCOLL = Collision(Qrange, Qspeed, Qdelay, Qwidth)
	end
	
	
	if vpredicfile then			
		VP = VPrediction()	
	end
	
	
	if VIP_USER then
		VipPredictionQ = TargetPredictionVIP(Qrange, Qspeed, Qdelay, Qwidth, myHero) 
	end	
		FreePredictionQ = TargetPrediction(Qrange, Qspeed, Qdelay, Qwidth)
end


function _loadSOW()
if not sowfile or not vpredicfile then return end
   SOW = SOW(VP)
   SOW:LoadToMenu() 
   is_SOWon = true
end


function _load_menu()
	Debug("Load Menu")
	Menu = scriptConfig(""..ScriptName, "bilbao")  	
		-----------------------------------------------------------------------------------------------------
		Menu:addSubMenu("Drawing", "draw")
		
				Menu.draw:addParam("info", " ", SCRIPT_PARAM_INFO, "")
				Menu.draw:addParam("reset", "Reset Colors", SCRIPT_PARAM_ONOFF, false)
				
				
			Menu.draw:addSubMenu("Enemy", "prdraw")
				Menu.draw.prdraw:addParam("prdmg", "Draw Predicted Dmg", SCRIPT_PARAM_ONOFF, false)
				Menu.draw.prdraw:addParam("visu", "Representation:", SCRIPT_PARAM_LIST, 2, {"True values", "Percentage" })
				Menu.draw.prdraw:addParam("info", " ", SCRIPT_PARAM_INFO, "")	
				Menu.draw.prdraw:addParam("enemy", "Mark Enemy", SCRIPT_PARAM_ONOFF, true)
				Menu.draw.prdraw:addParam("markcolor", "--> Mark Color", SCRIPT_PARAM_COLOR, {141, 124, 4, 4})
				Menu.draw.prdraw:addParam("info2", " ", SCRIPT_PARAM_INFO, "")				
				Menu.draw.prdraw:addParam("enemyline", "Line2Enemy", SCRIPT_PARAM_ONOFF, true)
				Menu.draw.prdraw:addParam("linecolor", "--> Line Color", SCRIPT_PARAM_COLOR, {141, 124, 4, 4})
				Menu.draw.prdraw:addParam("info2", " ", SCRIPT_PARAM_INFO, "")
				Menu.draw.prdraw:addParam("collision", "Show Q Collision", SCRIPT_PARAM_ONOFF, true)
				Menu.draw.prdraw:addParam("collision2", "Show Q Target", SCRIPT_PARAM_ONOFF, true)
				Menu.draw.prdraw:addParam("collision3", "Q Color", SCRIPT_PARAM_COLOR, {141, 124, 4, 4})
		-----------------------------------------------------------------------------------------------------
				
		
		-----------------------------------------------------------------------------------------------------
			Menu.draw:addSubMenu("Ranges", "drawsub2")
				Menu.draw.drawsub2:addParam("drawaa", "Draw AA-Range", SCRIPT_PARAM_ONOFF, true)
					Menu.draw.drawsub2:addParam("aacolor", "--> AA Range Color", SCRIPT_PARAM_COLOR, {141, 124, 4, 4})
					Menu.draw.drawsub2:addParam("info", " ", SCRIPT_PARAM_INFO, "")
					
					Menu.draw.drawsub2:addParam("drawQ", "Draw Q-Range", SCRIPT_PARAM_ONOFF, true)
					Menu.draw.drawsub2:addParam("qcolor", "--> Q Range Color", SCRIPT_PARAM_COLOR, {141, 5, 247, 217})
					Menu.draw.drawsub2:addParam("info2", " ", SCRIPT_PARAM_INFO, "")
					
					Menu.draw.drawsub2:addParam("drawW", "Draw W-Range", SCRIPT_PARAM_ONOFF, true)
					Menu.draw.drawsub2:addParam("wcolor", "--> W Range Color", SCRIPT_PARAM_COLOR, {141, 7, 7, 247})
					Menu.draw.drawsub2:addParam("info2", " ", SCRIPT_PARAM_INFO, "")
					
					Menu.draw.drawsub2:addParam("drawE", "Draw E-Range", SCRIPT_PARAM_ONOFF, true)
					Menu.draw.drawsub2:addParam("ecolor", "--> E Range Color", SCRIPT_PARAM_COLOR, {141, 212, 12, 223})
					Menu.draw.drawsub2:addParam("info3", " ", SCRIPT_PARAM_INFO, "")
					
					Menu.draw.drawsub2:addParam("drawR", "Draw R-Range", SCRIPT_PARAM_ONOFF, true)
					Menu.draw.drawsub2:addParam("rcolor", "--> R Range Color", SCRIPT_PARAM_COLOR, {141, 247, 247, 0})
					Menu.draw.drawsub2:addParam("info4", " ", SCRIPT_PARAM_INFO, "")					
		-----------------------------------------------------------------------------------------------------

		
		-----------------------------------------------------------------------------------------------------
		Menu:addSubMenu("Harrass", "harrass")		
				Menu.harrass:addParam("autohrsQ", "Auto Use Q", SCRIPT_PARAM_ONOFF, false)
				Menu.harrass:addParam("autohrsW", "Auto Use W", SCRIPT_PARAM_ONOFF, false)
				Menu.harrass:addParam("autohrsE", "Auto Use E", SCRIPT_PARAM_ONOFF, false)
				Menu.harrass:addParam("autohrsR", "Auto Use R", SCRIPT_PARAM_ONOFF, false)
		-----------------------------------------------------------------------------------------------------
		
		
		-----------------------------------------------------------------------------------------------------
		Menu:addSubMenu("Rotation", "rota")			
				Menu.rota:addParam("useQ", "Q Usage", SCRIPT_PARAM_ONOFF, false)
				Menu.rota:addParam("useW", "W Usage", SCRIPT_PARAM_ONOFF, false)
				Menu.rota:addParam("useE", "E Usage", SCRIPT_PARAM_ONOFF, false)
				Menu.rota:addParam("useR", "R Usage", SCRIPT_PARAM_ONOFF, false)
		-----------------------------------------------------------------------------------------------------
		
		
		-----------------------------------------------------------------------------------------------------
		Menu:addSubMenu("LaneClear", "laneclear")		
				Menu.laneclear:addParam("autolcQ", "Auto Use Q", SCRIPT_PARAM_ONOFF, false)
				Menu.laneclear:addParam("autolcW", "Auto Use W", SCRIPT_PARAM_ONOFF, false)
				Menu.laneclear:addParam("autolcE", "Auto Use E", SCRIPT_PARAM_ONOFF, false)
				Menu.laneclear:addParam("autolcR", "Auto Use R", SCRIPT_PARAM_ONOFF, false)
		-----------------------------------------------------------------------------------------------------
		
		Menu:addSubMenu("Mana Manager", "manamenu")
			Menu.manamenu:addSubMenu("Harrass", "manahrs")
				Menu.manamenu.manahrs:addParam("manaq", "Q ManaManager", SCRIPT_PARAM_ONOFF, false)  
				Menu.manamenu.manahrs:addParam("sliderq", "Use Q only if mana over %",  SCRIPT_PARAM_SLICE, 50, 0, 100, 0)  
				Menu.manamenu.manahrs:addParam("manaw", "W ManaManager", SCRIPT_PARAM_ONOFF, false) 
				Menu.manamenu.manahrs:addParam("sliderw", "Use W only if mana over %",  SCRIPT_PARAM_SLICE, 50, 0, 100, 0) 
				Menu.manamenu.manahrs:addParam("manae", "E ManaManager", SCRIPT_PARAM_ONOFF, false) 
				Menu.manamenu.manahrs:addParam("slidere", "Use E only if mana over %",  SCRIPT_PARAM_SLICE, 50, 0, 100, 0) 
				Menu.manamenu.manahrs:addParam("manar", "R ManaManager", SCRIPT_PARAM_ONOFF, false) 
				Menu.manamenu.manahrs:addParam("sliderr", "Use R only if mana over %",  SCRIPT_PARAM_SLICE, 50, 0, 100, 0) 
			Menu.manamenu:addSubMenu("Rotation", "manarota")
				Menu.manamenu.manarota:addParam("manaq", "Q ManaManager", SCRIPT_PARAM_ONOFF, false) 
				Menu.manamenu.manarota:addParam("sliderq", "Use Q only if mana over %",  SCRIPT_PARAM_SLICE, 50, 0, 100, 0) 
				Menu.manamenu.manarota:addParam("manaw", "W ManaManager", SCRIPT_PARAM_ONOFF, false) 
				Menu.manamenu.manarota:addParam("sliderw", "Use W only if mana over %",  SCRIPT_PARAM_SLICE, 50, 0, 100, 0) 
				Menu.manamenu.manarota:addParam("manae", "E ManaManager", SCRIPT_PARAM_ONOFF, false) 
				Menu.manamenu.manarota:addParam("slidere", "Use E only if mana over %",  SCRIPT_PARAM_SLICE, 50, 0, 100, 0) 
				Menu.manamenu.manarota:addParam("manar", "R ManaManager", SCRIPT_PARAM_ONOFF, false) 
				Menu.manamenu.manarota:addParam("sliderr", "Use R only if mana over %",  SCRIPT_PARAM_SLICE, 50, 0, 100, 0)
			Menu.manamenu:addSubMenu("LaneClear", "manalc")
				Menu.manamenu.manalc:addParam("manaq", "Q ManaManager", SCRIPT_PARAM_ONOFF, false) 
				Menu.manamenu.manalc:addParam("sliderq", "Use Q only if mana over %",  SCRIPT_PARAM_SLICE, 50, 0, 100, 0) 
				Menu.manamenu.manalc:addParam("manaw", "W ManaManager", SCRIPT_PARAM_ONOFF, false) 
				Menu.manamenu.manalc:addParam("sliderw", "Use W only if mana over %",  SCRIPT_PARAM_SLICE, 50, 0, 100, 0) 
				Menu.manamenu.manalc:addParam("manae", "E ManaManager", SCRIPT_PARAM_ONOFF, false) 
				Menu.manamenu.manalc:addParam("slidere", "Use E only if mana over %",  SCRIPT_PARAM_SLICE, 50, 0, 100, 0) 
				Menu.manamenu.manalc:addParam("manar", "R ManaManager", SCRIPT_PARAM_ONOFF, false) 
				Menu.manamenu.manalc:addParam("sliderr", "Use R only if mana over %",  SCRIPT_PARAM_SLICE, 50, 0, 100, 0)
		-----------------------------------------------------------------------------------------------------
		Menu:addSubMenu("Hotkeys", "keys")		
			Menu.keys:addParam("permrota", "Auto Rotation", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte("S"))
			Menu.keys:permaShow("permrota")
			Menu.keys:addParam("okdrota", "OnKeyDown Rotation", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("A"))
			Menu.keys:permaShow("okdrota")		
			Menu.keys:addParam("permhrs", "Auto Harrass", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte("Z"))
			Menu.keys:permaShow("permhrs")
			Menu.keys:addParam("okdhrs", "OnKeyDown Harrass", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("T"))
			Menu.keys:permaShow("okdhrs")
			Menu.keys:addParam("okdlc", "OnKeyDown LaneClear", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("C"))
			Menu.keys:permaShow("okdlc")
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
		-----------------------------------------------------------------------------------------------------
		
		
		-----------------------------------------------------------------------------------------------------				
			Menu:addSubMenu("Special", "specl")
		
				Menu.specl:addSubMenu("Q-Options", "qopt")
					Menu.specl.qopt:addParam("qts", "Q Target", SCRIPT_PARAM_LIST, 1, { "MainTarget", "GrabPrio" })
					Menu.specl.qopt:addParam("qopt1", "Grab Prio", SCRIPT_PARAM_LIST, 1, { "Q-TargetSelector", "BestHitChance" })
					
				Menu.specl:addSubMenu("Q-Manual", "qman")
					Menu.specl.qman:addParam("force", "Force Selected", SCRIPT_PARAM_ONOFF, false)
					Menu.specl.qman:addParam("move", "Movement", SCRIPT_PARAM_LIST, 1, { "ToMouse", "ToSelected", "NoMovement" })
					Menu.specl.qman:addParam("grab", "THE KEY", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("N"))
					Menu.specl.qman:addParam("showhit", "Show Hitchance", SCRIPT_PARAM_ONOFF, false)
					
				Menu.specl:addSubMenu("Q-Ignore", "ignore")
					Menu.specl.ignore:addParam("info", "Ignore: ", SCRIPT_PARAM_INFO, "")
					for i, enemy in ipairs(GetEnemyHeroes()) do
						Menu.specl.ignore:addParam(enemy.charName, enemy.charName, SCRIPT_PARAM_ONOFF, false)
					end
				
				Menu.specl:addSubMenu("W-Options", "wopt")					
					Menu.specl.wopt:addParam("range", "Range to collect",  SCRIPT_PARAM_SLICE, 250, 1, 1000, 0)
					Menu.specl.wopt:addParam("enemy", "Enemys to count",  SCRIPT_PARAM_SLICE, 2, 1, 5, 0)
					
				Menu.specl:addSubMenu("E-Options", "eopt")
					Menu.specl.eopt:addParam("ets", "E Target", SCRIPT_PARAM_LIST, 1, { "MainTarget", "E-TargetSelector" })
					Menu.specl.eopt:addParam("eopt1", "KnockUp Prio", SCRIPT_PARAM_LIST, 1, { "Defined Target", "OnCD" })

				Menu.specl:addSubMenu("R-Options", "ropt")
					Menu.specl.ropt:addParam("ks", "Kill Secure", SCRIPT_PARAM_ONOFF, false)
					Menu.specl.ropt:addParam("limit", "Limit R", SCRIPT_PARAM_ONOFF, false)
					Menu.specl.ropt:addParam("ropt2sliderrange", "Count Range",  SCRIPT_PARAM_SLICE, 500, 1, 600, 0)
					Menu.specl.ropt:addParam("ropt2sliderenemy", "AutoCastR if",  SCRIPT_PARAM_SLICE, 2, 1, 5, 0)
					
					
				Menu.specl:addSubMenu("Auto Interrupt", "autointer")
					for i, spell in pairs(spells) do
						Menu.specl.autointer:addParam(spell.name, spell.menuname, SCRIPT_PARAM_ONOFF, true)
					end

				Menu.specl:addParam("selec", "Prefer selected Target.", SCRIPT_PARAM_ONOFF, false)
		-----------------------------------------------------------------------------------------------------
		
		
		-----------------------------------------------------------------------------------------------------		
		Menu:addParam("info", " >> created by Bilbao", SCRIPT_PARAM_INFO, "")
		Menu:addParam("info2", " >> Version "..CurVer, SCRIPT_PARAM_INFO, "")
		-----------------------------------------------------------------------------------------------------
		
		
		_setimpdef()
		Debug("Menu Loaded.")
end


function _setimpdef()
	Menu.extra.alvl.alvlstatus = false
	Menu.keys.permrota = false
	Menu.keys.okdrota = false
	Menu.keys.permhrs = false
	Menu.keys.okdhrs = false
end


function _initiateTS()
	MyMinionManager = minionManager(MINION_ALL, 50000)
	
	qts = TargetSelector(TARGET_LOW_HP, Qrange, DAMAGE_MAGIC)
	qts.name = "Q Target"
	Menu.specl.qopt:addTS(qts)

	ets = TargetSelector(TARGET_LOW_HP, Erange, DAMAGE_PHYSICAL)
	ets.name = "E Target"
	Menu.specl.eopt:addTS(ets)


end
--[/OnLoad]--


--[[OnProcessSpell]]--
function OnProcessSpell(object, spell)
	if object.team ~= myHero.team and object.type == myHero.type then
		LastCastedSpell[object.networkID] = {name = spell.name:lower(), time = os.clock(), caster = object}
	end
end
--[[/OnProcessSpell]]--


--[[OnObject]]--
function OnCreateObj()
end


function OnDeleteObj()
end
--[[/OnObject]]--


--[[OnPacket]]--
function OnRecvPacket()
end


function OnSendPacket()
end
--[[/OnPacket]]--


--[[OnWndMsg]]--
function OnWndMsg(Msg, Key)
	if Msg == WM_LBUTTONDOWN then
		local minD = 0
		local starget = nil
		for i, enemy in ipairs(GetEnemyHeroes()) do
			if ValidTarget(enemy) then
				if GetDistance(enemy, mousePos) <= minD or starget == nil then
					minD = GetDistance(enemy, mousePos)
					starget = enemy
				end
			end
		end
		
		if starget and minD < 500 then
			if SelectedTarget and starget.charName == SelectedTarget.charName then
				SelectedTarget = nil
				if Menu.specl.selec then print(ScriptName..": Target unselected: "..starget.charName) end
			else
				SelectedTarget = starget
				if Menu.specl.selec then print("<font color=\"#FF0000\">"..ScriptName..": New target selected: "..starget.charName.."</font>") end
			end
		end
	end
end
--[[/OnWndMsg]]--


--[[OnDraw]]--
function OnDraw()
	if myHero.dead then return end		 
		_draw_ranges()
		_draw_tarinfo()
		_draw_predDmg()
end


function _draw_ranges()
	local p = WorldToScreen(D3DXVECTOR3(myHero.x, myHero.y, myHero.z))
	if not OnScreen(p.x, p.y) then return end
		if Menu.draw.drawsub2.drawaa then
			DrawCircle(myHero.x, myHero.y, myHero.z, MyBasicRange, ARGB(Menu.draw.drawsub2.aacolor[1], Menu.draw.drawsub2.aacolor[2], Menu.draw.drawsub2.aacolor[3], Menu.draw.drawsub2.aacolor[4]))
		end		
		
		
		if Menu.draw.drawsub2.drawQ and QReady then			
			DrawCircle(myHero.x, myHero.y, myHero.z, Qrange, ARGB(Menu.draw.drawsub2.qcolor[1], Menu.draw.drawsub2.qcolor[2], Menu.draw.drawsub2.qcolor[3], Menu.draw.drawsub2.qcolor[4]))	
		end
		
		
		if Menu.draw.drawsub2.drawW and WReady then
			DrawCircle(myHero.x, myHero.y, myHero.z, Wrange, ARGB(Menu.draw.drawsub2.wcolor[1], Menu.draw.drawsub2.wcolor[2], Menu.draw.drawsub2.wcolor[3], Menu.draw.drawsub2.wcolor[4]))
		end
		
		
		if Menu.draw.drawsub2.drawE and EReady then
			DrawCircle(myHero.x, myHero.y, myHero.z, Erange, ARGB(Menu.draw.drawsub2.ecolor[1], Menu.draw.drawsub2.ecolor[2], Menu.draw.drawsub2.ecolor[3], Menu.draw.drawsub2.ecolor[4]))
		end
		
		
		if Menu.draw.drawsub2.drawR and RReady then
			DrawCircle(myHero.x, myHero.y, myHero.z, Rrange, ARGB(Menu.draw.drawsub2.rcolor[1], Menu.draw.drawsub2.rcolor[2], Menu.draw.drawsub2.rcolor[3], Menu.draw.drawsub2.rcolor[4]))	
		end
end


function _draw_tarinfo()
if Menu.specl.qman.grab and ManQTar ~= nil and ManQTar.x ~= nil and not ManQTar.dead and Menu.specl.qman.showhit then DrawText3D(""..(ManQHit or " "), ManQTar.x, ManQTar.y, ManQTar.z, 30, ARGB(255, 255, 255, 255), true) end

	if ValidTarget(QMark) then
		if Menu.draw.prdraw.collision and not VIP_USER and QReady then
			DrawLine3D(myHero.x, myHero.y, myHero.z, QMark.x, QMark.y, QMark.z, 70, ARGB(Menu.draw.prdraw.collision3[1],Menu.draw.prdraw.collision3[2],Menu.draw.prdraw.collision3[3],Menu.draw.prdraw.collision3[4]) )
		end
		
		if Menu.draw.prdraw.collision2 and QReady then
			for o=1, 70, 7 do
				DrawCircle(QMark.x, QMark.y, QMark.z, o, ARGB(Menu.draw.prdraw.collision3[1],Menu.draw.prdraw.collision3[2],Menu.draw.prdraw.collision3[3],Menu.draw.prdraw.collision3[4]))
			end
		end
		
	if QMCP~= nil and QReady then QCOLL:DrawCollision(myHero, QMCP) end
	end
	
		
	if ValidTarget(Target) then
		local p = WorldToScreen(D3DXVECTOR3(Target.x, Target.y, Target.z))
		if OnScreen(p.x, p.y) then
			if Menu.draw.prdraw.enemyline and Target.visible and not Target.dead then		
				DrawLine3D(myHero.x, myHero.y, myHero.z, Target.x, Target.y, Target.z, 1, ARGB(Menu.draw.prdraw.linecolor[1],Menu.draw.prdraw.linecolor[2],Menu.draw.prdraw.linecolor[3],Menu.draw.prdraw.linecolor[4]))
			end	
			
			
			if Menu.draw.prdraw.enemy and Target.visible and not Target.dead then			
			    for j=1, 25 do
                        local ycircle = (j*(120/25*2)-120)
                        local r = math.sqrt(120^2-ycircle^2)
                        ycircle = ycircle/1.3
                        DrawCircle(Target.x, Target.y+100+ycircle, Target.z, r, ARGB(Menu.draw.prdraw.markcolor[1],Menu.draw.prdraw.markcolor[2],Menu.draw.prdraw.markcolor[3],Menu.draw.prdraw.markcolor[4]))
				end		
			end	
		end
	end
	
	
	
end


function _draw_predDmg()
	if not Menu.draw.prdraw.prdmg then return end
	local currLine = 1
	local dmgtyp = ""
	if Menu.draw.prdraw.visu == 2 then dmgtyp = "%" end
				
				
	for i, enemy in ipairs(GetEnemyHeroes()) do		
		if enemy ~= nil and not enemy.dead and enemy.visible then		
			if QReady then
				DrawLineHPBar(_dmg("Q", enemy), currLine, "Q: ".._dmg("Q", enemy)..dmgtyp, enemy, true)
				currLine = currLine + 1
			end	

			if RReady then
				DrawLineHPBar(_dmg("R", enemy), currLine, "R: ".._dmg("R", enemy)..dmgtyp, enemy, true)
				currLine = currLine + 1
			end

		end
	end	
end

function _dmg(spell, target)
	if Menu.draw.prdraw.visu == 1 then
		return math.round(getDmg(spell, target, myHero))
	elseif Menu.draw.prdraw.visu == 2 then
		return math.round(((getDmg(spell, target, myHero) / target.maxHealth) * 100))
	end	

	
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


function DrawLineHPBar(damage, line, text, unit, enemyteam)
	if unit.dead or not unit.visible then return end
	local p = WorldToScreen(D3DXVECTOR3(unit.x, unit.y, unit.z))
	if not OnScreen(p.x, p.y) then return end

	
	local thedmg = 0
	local linePosA = {x = 0, y = 0 }
	local linePosB = {x = 0, y = 0 }
	local TextPos =  {x = 0, y = 0 }
	
	
	if damage >= unit.maxHealth then
		thedmg = unit.maxHealth - 1
	else
		thedmg = damage
	end
	
	
	local StartPos, EndPos = GetHPBarPos(unit)
	local Real_X = StartPos.x + 24
	local Offs_X = (Real_X + ((unit.health - thedmg) / unit.maxHealth) * (EndPos.x - StartPos.x - 2))
	if Offs_X < Real_X then Offs_X = Real_X end	
	local mytrans = 350 - math.round(255*((unit.health-thedmg)/unit.maxHealth))
	if mytrans >= 255 then mytrans=254 end
	local my_bluepart = math.round(400*((unit.health-thedmg)/unit.maxHealth))
	if my_bluepart >= 255 then my_bluepart=254 end

	
if enemyteam then
	linePosA.x = Offs_X-150
	linePosA.y = (StartPos.y-(30+(line*15)))	
	linePosB.x = Offs_X-150
	linePosB.y = (StartPos.y-10)
	TextPos.x = Offs_X-148
	TextPos.y = (StartPos.y-(30+(line*15)))
else
	linePosA.x = Offs_X-125
	linePosA.y = (StartPos.y-(30+(line*15)))	
	linePosB.x = Offs_X-125
	linePosB.y = (StartPos.y-15)
	
	TextPos.x = Offs_X-122
	TextPos.y = (StartPos.y-(30+(line*15)))
end

	DrawLine(linePosA.x, linePosA.y, linePosB.x, linePosB.y , 2, ARGB(mytrans, 255,my_bluepart,0))
	DrawText(tostring(text),15,TextPos.x, TextPos.y ,ARGB(mytrans, 255,my_bluepart,0))
	
end
--[[/OnDraw]]--


--[[OnTick]]--
function OnTick()
	Reset()
	_check_mmasac()	
	if not myHero.dead then
		_update()
		autointer()
		ksecurer()
		_smartcore()
	end	
end


function _update()
	MyMinionManager:update()
	qts:update()
	ets:update()
	
	if vpredicfile then minVPhit = Menu.ta.vphit - 1 end
	
	QReady = (myHero:CanUseSpell(_Q) == READY)
	WReady = (myHero:CanUseSpell(_W) == READY)
	EReady = (myHero:CanUseSpell(_E) == READY)
	RReady = (myHero:CanUseSpell(_R) == READY)
	MyBasicRange = myHero.range + (GetDistance(myHero.minBBox) - 3)
	
	if SelectedTarget ~= nil and ValidTarget(SelectedTarget) then
		Target = SelectedTarget
	else
		Target = _getTarget()
	end
	MarkIt = Target
	
	_autoskill()
	
	_checkcancastHRS()
	_checkcancastROTA()
	_checkcancastLC()
end


function _smartcore()
ManualQ()

			if Menu.rota.useQ and canQrota and QReady then
				cast_pred_q()	
			end
			
if (Menu.keys.permrota or Menu.keys.okdrota) then
			
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


if Menu.keys.okdlc then
	if Menu.laneclear.autolcQ and canQlc and QReady then
		cast_lc_q()
	end
	
	if Menu.laneclear.autolcW and canWlc and WReady then
		cast_lc_w()
	end
	
	if Menu.laneclear.autolcE and canElc and EReady then
		cast_lc_e()
	end
	
	if Menu.laneclear.autolcR and canRlc and RReady then
		cast_lc_r()
	end
end


end


function ManualQ()
local tmp_tar = GetTarget()
if ManQTar ~= nil and ManQTar.dead then ManQTar = nil end

if tmp_tar ~= nil and ValidTarget(tmp_tar) and tmp_tar ~= ManQTar then
	ManQTar = tmp_tar
end

local ManQTextUnit = ManQTar
local main_cast_pos = nil
if ValidTarget(ManQTar) and Menu.specl.qman.force then
	forced = true
else
	forced = false
end

if ManQTar == nil or ManQTar.dead then return end
if Menu.specl.qman.grab and GetDistance(ManQTar) > 990 and not ManQTar.dead then
	if Menu.specl.qman.move == 1 then
		myHero:MoveTo(mousePos.x, mousePos.z)
	elseif Menu.specl.qman.move == 2 then
		myHero:MoveTo(ManQTar.x, ManQTar.z)
	end
end

	if Menu.ta.co == 1 then
		if ManQTar ~= nil and ManQTar.visible then
			local Position = FreePredictionQ:GetPrediction(ManQTar)
			if Position ~= nil then
				main_cast_pos = Position				
			end		
		end	
	end

	
	if Menu.ta.co == 2 and VIP_USER then
		if ManQTar ~= nil and ManQTar.visible then
			local Position = VipPredictionQ:GetPrediction(ManQTar)
			if Position ~= nil then
				main_cast_pos = Position				
			end		
		end	
	end

	if Menu.ta.co == 3 and vpredicfile and VIP_USER then 
		local CastPosition, HitChance, HeroPosition = VP:GetLineCastPosition(ManQTar, Qdelay, Qwidth, Qrange, Qspeed, myHero, true)
		if HitChance >= minVPhit then
			main_cast_pos = CastPosition
			ManQHit = HitChance.."/5 - GRAB!"
		else
			ManQHit = HitChance.."/5 - NO"
		end	
	end
	
	
	if Menu.ta.co == 4 and prodicfile and VIP_USER then 
		local calcPos = ProdictionQ:GetPrediction(ManQTar)
				if calcPos ~= nil and not QCOLL:GetMinionCollision(calcPos, myHero) then
					main_cast_pos = calcPos
				end	
	end

	if main_cast_pos ~= nil and main_cast_pos.x ~= nil then
		QMCP = main_cast_pos
	else
		QMCP = nil
	end
-----------
	if Menu.specl.qman.grab and QReady and main_cast_pos ~= nil and GetDistance(main_cast_pos) < 1000 then
		_castSpell(_Q, main_cast_pos.x, main_cast_pos.z, nil)
	end	
if main_cast_pos ~= nil and main_cast_pos.x ~= nil and QReady then
	if Menu.ta.co == 1 then
		if GetDistance(main_cast_pos) < 1000 then
			ManQHit = "Could Hit"
		else
			ManQHit = "Could Fail"
		end	
	end
	
	if Menu.ta.co == 2 then
		if GetDistance(main_cast_pos) < 1000 then
			ManQHit = "Could Hit"
		else
			ManQHit = "Could Fail"
		end		
	end
	
	if Menu.ta.co == 4 then
			if GetDistance(main_cast_pos) < 1000 and not QCOLL:GetMinionCollision(QMCP, myHero) then
			ManQHit = "GRAB!"
		else
			ManQHit = "WAIT!"
		end
	
	end
end
end


function cast_pred_q()
if forced then return end
local LOCAL_TAR = nil
local main_cast_pos = nil
if ValidTarget(SelectedTarget, Qrange) and not Ignore(SelectedTarget) and Menu.specl.selec then
	LOCAL_TAR = SelectedTarget
elseif ValidTarget(Target, Qrange) and not Ignore(SelectedTarget) and Menu.specl.qopt.qts == 1 then
	LOCAL_TAR = Target
elseif ValidTarget(qts.target, Qrange) and not Ignore(SelectedTarget) and Menu.specl.qopt.qts == 2 and Menu.specl.qopt.qopt1 == 1 then
	LOCAL_TAR = qts.target
end
MarkIt = LOCAL_TAR
QMark = LOCAL_TAR

	if Menu.ta.co == 1 then	 
		if LOCAL_TAR ~= nil and LOCAL_TAR.visible then
			local Position = FreePredictionQ:GetPrediction(LOCAL_TAR)
			if Position ~= nil and GetDistance(Position) < Qrange then
				main_cast_pos = Position				
			end		
		end	
	end	 
	
	if Menu.ta.co == 2 and VIP_USER then 
		if LOCAL_TAR ~= nil and LOCAL_TAR.visible then
			local Position = VipPredictionQ:GetPrediction(LOCAL_TAR)
			if Position ~= nil then
				main_cast_pos = Position				
			end		
		end	
	end	

	
	if Menu.ta.co == 3 and vpredicfile and Menu.specl.qopt.qts == 1 and ValidTarget(LOCAL_TAR) then 
		local CastPosition, HitChance, HeroPosition = VP:GetLineCastPosition(LOCAL_TAR, Qdelay, Qwidth, Qrange, Qspeed, myHero, true)
		if HitChance >= minVPhit and GetDistance(CastPosition) < 5000 then
			main_cast_pos = CastPosition
		end	
	end
	if Menu.ta.co == 3 and vpredicfile and Menu.specl.qopt.qts == 2 and Menu.specl.qopt.qopt1 == 1 and ValidTarget(qts.target) then 
		local CastPosition, HitChance, HeroPosition = VP:GetLineCastPosition(qts.target, Qdelay, Qwidth, Qrange, Qspeed, myHero, true)
		if HitChance >= minVPhit and GetDistance(CastPosition) < 5000 then
			main_cast_pos = CastPosition
			QMark = qts.target
		end	
	
	end
	if Menu.ta.co == 3 and vpredicfile and Menu.specl.qopt.qts == 2 and Menu.specl.qopt.qopt1 == 2 then 
		local BestHitUnit, BestHitChance, BestHitPos = nil, -10, nil
		for i, enemy in ipairs(GetEnemyHeroes()) do
			if not enemy.dead and enemy ~= nil and ValidTarget(enemy) then
				local CastPosition, HitChance, HeroPosition = VP:GetLineCastPosition(enemy, Qdelay, Qwidth, Qrange, Qspeed, myHero, true)
				if HitChance >= minVPhit and HitChance >= BestHitChance then
					BestHitUnit = enemy
					BestHitChance = HitChance
					BestHitPos = CastPosition				
				end
			end
		end
		
		if ValidTarget(BestHitUnit) and BestHitChance >= minVPhit and BestHitPos.x ~= nil then
			main_cast_pos = BestHitPos
			QMark = BestHitUnit
		end	
	end

	

	if Menu.ta.co == 4 and prodicfile and Menu.specl.qopt.qts == 1 and ValidTarget(LOCAL_TAR) then 
		local calcPos = ProdictionQ:GetPrediction(LOCAL_TAR)
				if calcPos ~= nil and not QCOLL:GetMinionCollision(calcPos, myHero) then
					main_cast_pos = calcPos
				end	
	end
	
	if Menu.ta.co == 4 and prodicfile and Menu.specl.qopt.qts == 2 and Menu.specl.qopt.qopt1 == 1 and ValidTarget(qts.target) then 
			local calcPos = ProdictionQ:GetPrediction(qts.target)
			if calcPos ~= nil and not QCOLL:GetMinionCollision(calcPos, myHero) then
				main_cast_pos = calcPos
				QMark = qts.target
			end
	end	

	if Menu.ta.co == 4 and prodicfile and Menu.specl.qopt.qts == 2 and Menu.specl.qopt.qopt1 == 2 then
		local BestHitUnit, BestHitDist, BestHitPos = nil, 50000, nil
		for i, enemy in ipairs(GetEnemyHeroes()) do
			if not enemy.dead and enemy ~= nil and ValidTarget(enemy) then
				local calcPos = ProdictionQ:GetPrediction(enemy)
				if calcPos ~= nil and not QCOLL:GetMinionCollision(calcPos, myHero) and GetDistance(enemy) <= BestHitDist then
					BestHitUnit = enemy
					BestHitDist = GetDistance(enemy)
					BestHitPos = calcPos
				end	
			end
		end
		if ValidTarget(BestHitUnit) and BestHitDist <= 5000 and BestHitPos.x ~= nil then
			main_cast_pos = BestHitPos
			QMark = BestHitUnit
		end
	end		
	
	if main_cast_pos ~= nil and main_cast_pos.x ~= nil and VIP_USER then
		QMCP = main_cast_pos
	else
		QMCP = nil
	end

	if (Menu.keys.permrota or Menu.keys.okdrota) and QReady and main_cast_pos ~= nil then
		_castSpell(_Q, main_cast_pos.x, main_cast_pos.z, nil)
	end
end


function cast_pred_w()
if not WReady then return end
if not WReady then return end
local EnemyInMyRange = 0

EnemyInMyRange = CountEnemyHeroInRange(Menu.specl.wopt.range, myHero)
if EnemyInMyRange ~=nil and EnemyInMyRange >= Menu.specl.wopt.enemy then
	CastSpell(_W)
end
end


function cast_pred_e()
if not EReady then return end
local LOCAL_TAR = nil
if ValidTarget(SelectedTarget, 210) and Menu.specl.selec then
	LOCAL_TAR = SelectedTarget
elseif ValidTarget(Target, 210) and Menu.specl.eopt.ets == 1 then
	LOCAL_TAR = Target
elseif ValidTarget(ets.target, 210) and Menu.specl.eopt.ets == 2 then
	LOCAL_TAR = ets.target
end
if not (LOCAL_TAR ~=nil and LOCAL_TAR.visible and GetDistance(LOCAL_TAR) < Erange) then return end  
MarkIt = LOCAL_TAR

if Menu.specl.eopt.eopt1 == 1 then
	if ValidTarget(LOCAL_TAR, Erange) then
		CastSpell(_E)
		myHero:Attack(LOCAL_TAR)
	end
elseif Menu.specl.eopt.eopt1 == 2 then
local ClosestUnit, ClosestDist = nil, 50000
	for i, enemy in ipairs(GetEnemyHeroes()) do
				if ValidTarget(enemy, Erange) and GetDistance(enemy) < ClosestDist then
					ClosestUnit = enemy
					ClosestDist = GetDistance(enemy)
				end
	end
	if ClosestUnit ~= nil and ValidTarget(ClosestUnit, Erange) then
		CastSpell(_E)
		myHero:Attack(ClosestUnit)
	end
end
end


function ksecurer()
if Menu.specl.ropt.ks and RReady then
	for i, enemy in ipairs(GetEnemyHeroes()) do
	if not enemy.dead and enemy.visible and ValidTarget(enemy, 595) and RReady then
		if enemy.health*1.025 < getDmg("R", enemy, myHero) then			
			_castSpell(_R, myHero.x, myHero.z, nil)
		end	
	end	
	end
end
end


function cast_pred_r()
if not RReady then return end
if Menu.specl.ropt.limit then

	local LECount = CountEnemyHeroInRange(Menu.specl.ropt.ropt2sliderrange, myHero)
	if LECount >= Menu.specl.ropt.ropt2sliderenemy then
		_castSpell(_R, myHero.x, myHero.z, nil)
	end
else
	local ENLCount = CountEnemyHeroInRange(450, myHero)
	if ENLCount >= 1 then 
		_castSpell(_R, myHero.x, myHero.z, nil)
	end
end
end

function cast_lc_q()
if not QReady then return end
	for i, minion in pairs(MyMinionManager.objects) do 
		if minion ~= nil and minion.valid and minion.team ~= myHero.team and GetDistance(minion) <= Qrange and not minion.dead and minion.visible and minion.health < getDmg("Q", minion, myHero) then
			CastSpell(_Q, minion.x, minion.z)
		end
	end
end


function cast_lc_w()
if not WReady then return end
local minionCount = 0
	for i, minion in pairs(MyMinionManager.objects) do
		if minion ~= nil and minion.valid and minion.team ~= myHero.team and GetDistance(minion) <= 500 and minion.visible then
			minionCount = minionCount + 1
		end
	end
	if minionCount >= 2 then
		CastSpell(_W)
	end
end


function cast_lc_e()
if not EReady then return end
	for i, minion in pairs(MyMinionManager.objects) do 
		if minion ~= nil and minion.valid and minion.team ~= myHero.team and GetDistance(minion) <= Erange and not minion.dead and minion.visible and (minion.health < (getDmg("AD", minion, myHero)*1.85)) then
			CastSpell(_E)
			myHero:Attack(minion)
		end
	end
end


function cast_lc_r()
if not RReady then return end
local minionCount = 0
	for i, minion in pairs(MyMinionManager.objects) do
		if minion ~= nil and minion.valid and minion.team ~= myHero.team and GetDistance(minion) <= 590 and not minion.dead and minion.visible and minion.health < getDmg("R", minion, myHero) then
			minionCount = minionCount + 1
		end
	end
	if minionCount >= 3 then
		CastSpell(_R)
	end
end


function autointer()
	if QReady or EReady or RReady then
		for i, spell in ipairs(spells) do
			if Menu.specl.autointer[spell.name] then
				for j, LastCast in pairs(LastCastedSpell) do
					if LastCast.name == spell.name:lower() and (os.clock() - LastCast.time) < 3 and ValidTarget(LastCast.caster) then
						local DistToLC = GetDistance(LastCast.caster.visionPos, myHero.visionPos)
						if DistToLC < Erange and EReady then
						CastSpell(_E)
						myHero:Attack(LastCast.caster)
						break
						elseif DistToLC < Qrange and QReady then
						CastSpell(_Q, LastCast.caster.x, LastCast.caster.z)
						break
						elseif DistToLC < Rrange and RReady then
						CastSpell(_R, myHero.x, myHero.z)
						break
						end						
					end
				end
			end
		end
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
		Menu.ta.orb = 3
	end
	
	
	if is_SAC then
		Menu.ta:addSubMenu("Sida's Auto Carry", "sac")
		Menu.ta.sac:addParam("sacstatus", "Use SAC Target Selector", SCRIPT_PARAM_ONOFF, false)		
		Menu.ta.orb = 3
	end
	
	
	if sowfile and vpredicfile and is_SOWon then
		Menu.ta:addSubMenu("Simple Orbwalker", "sow")
		Menu.ta.sow:addParam("sowstatus", "Use SOW Target Selector", SCRIPT_PARAM_ONOFF, false)
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

	local tscount = 0
	
	
	if is_SOWon and sowfile and Menu.ta.sow.sowstatus then tscount = tscount + 1 end
	if is_MMA and Menu.ta.mma.mmastatus then tscount = tscount + 1 end
	if is_SAC and Menu.ta.sac.sacstatus then tscount = tscount + 1 end
	
	
	if tscount > 1 then
			if is_SAC then Menu.ta.sac.sacstatus = false end
		if sowfile then Menu.ta.sow.sowstatus = false end
		if is_MMA then Menu.ta.mma.mmastatus = false end		
	end
	
	
	if is_MMA and Menu.ta.mma.mmastatus then
		SOW:DisableAttacks()
		if _G.MMA_Target and _G.MMA_Target.type == myHero.type then
			return _G.MMA_Target 
		end
	end
	
	
	if is_SAC and Menu.ta.sac.sacstatus then
		SOW:DisableAttacks()
		if _G.AutoCarry and _G.AutoCarry.Crosshair and _G.AutoCarry.Attack_Crosshair and _G.AutoCarry.Attack_Crosshair.target and _G.AutoCarry.Attack_Crosshair.target.type == myHero.type then
			return _G.AutoCarry.Attack_Crosshair.target		
		end
	end

	
	if sowfile and Menu.ta.sow.sowstatus then
		SOW:EnableAttacks()
		return SOW:GetTarget()
	end
	
	
	return GetTarget()
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


function _checkcancastLC()	

	if Menu.manamenu.manalc.manaq then 
		if mynamaislowerthen(Menu.manamenu.manalc.sliderq) then
			canQlc = false
		else			
			canQlc = true
		end
	else
		canQlc = true	
	end
	
	
	if Menu.manamenu.manalc.manaw then 
		if mynamaislowerthen(Menu.manamenu.manalc.sliderw) then
			canWlc = false
		else			
			canWlc = true
		end
	else
		canWlc = true	
	end	
	
	
	if Menu.manamenu.manalc.manae then 
		if mynamaislowerthen(Menu.manamenu.manalc.slidere) then
			canElc = false
		else			
			canElc = true
		end
	else
		canElc = true	
	end		
	
	
	if Menu.manamenu.manalc.manar then 
		if mynamaislowerthen(Menu.manamenu.manalc.sliderr) then
			canRlc = false
		else			
			canRlc = true
		end
	else
		canRlc = true	
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


function _healthover(percent, unit)
	return unit.health < ( unit.maxHealth * ( percent / 100))
end


function _manaover(percent, unit)
	 return unit.mana < (unit.maxMana * ( percent / 100))
end


function Reset()
	if Menu.draw.reset then
		Menu.draw.reset = false
		Menu.draw.prdraw.markcolor = {141, 124, 4, 4}
		Menu.draw.prdraw.linecolor = {141, 124, 4, 4}
		Menu.draw.drawsub2.aacolor = {141, 124, 4, 4}
		Menu.draw.drawsub2.qcolor = {141, 5, 247, 217}
		Menu.draw.drawsub2.wcolor = {141, 7, 7, 247}
		Menu.draw.drawsub2.ecolor = {141, 212, 12, 223}
		Menu.draw.drawsub2.rcolor = {141, 247, 247, 0}	
		PrintChat("<font color='#40FF00'> >> "..ScriptName..": Reset.</font>")
	end
end


function Ignore(target)
if not ValidTarget(target) then
	return true
end

if Menu.specl.ignore[target.charName] then
	return true
else
	return false
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


function DownloadAll()
Debug("Start DownloadALL")
local siteVP = "http://bilbao.lima-city.de/VPrediction.lua"
local siteSOW = "http://bilbao.lima-city.de/SOW.lua"
local siteSOURCE = "http://bilbao.lima-city.de/SourceLib.lua"
local sitePRO = "http://bilbao.lima-city.de/Prodiction.lua"
local siteCollision = "http://bilbao.lima-city.de/Collision.lua"

	if not FileExist(LIB_PATH.."VPrediction.lua") then
		Debug("Download VPrediction.")
		DownoadSite(siteVP, "VPrediction.lua", "VPrediction")
	else
		Debug("VPrediction exists.")
	end
	
	if not FileExist(LIB_PATH.."SOW.lua") then
		Debug("Download SOW.")
		DownoadSite(siteSOW, "SOW.lua", "SimpleOrbwalker")
	else
		Debug("SOW exists.")
	end
	
	if not FileExist(LIB_PATH.."SourceLib.lua") then
		Debug("Download SourceLib.")
		DownoadSite(siteSOW, "SourceLib.lua", "SourceLib")
	else
		Debug("SOW exists.")
	end
	
	if not FileExist(LIB_PATH.."Prodiction.lua") then
		Debug("Download Prodiction")
		DownoadSite(siteVP, "Prodiction.lua", "Prodiction 0.9d")
	else
		Debug("Prodiction exists.")
	end
	
	if not FileExist(LIB_PATH.."Collision.lua") then
		Debug("Download Collision.")
		DownoadSite(siteVP, "Collision.lua", "Collision")
	else
		Debug("Collision exists.")
	end
	
Debug("Finished DownloadALL")
end


function DownoadSite(url, savename, show)
Debug("initiate "..show.." download")
	DownloadFile(url, LIB_PATH..savename, function()
							if FileExist(LIB_PATH..savename) then								
							Debug("Downloaded "..show.." Complete.")								
							end
						end
				)
end


function Debug(input)
if not ShowDebugText then return end
print("Debug: "..input)
end
--[[/Utility]]--
