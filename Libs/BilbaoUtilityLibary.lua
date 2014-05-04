--[[------------------------------------]]--
--[[		Bilbao Utility Libary		]]--
--[[------------------------------------]]--



--[[oooooooooooooooo]]--
--[[	Globals		]]--
--[[oooooooooooooooo]]--
	_G.UseAutoUpdate = false
	_G.UseDebug = true
	_G.DebugLevel = 1
--[[oooooooooooooooo]]--
--[[	Globals		]]--
--[[oooooooooooooooo]]--




--[[oooooooooooooooooooooooooooo]]--
--[[	General Information		]]--
--[[oooooooooooooooooooooooooooo]]--

	--[[AutoUpdater]]--
	local CurVer, NetVersion = 0.0, nil
	local NeedUpdate, Do_Once = false, true	
	local NetFile = "http://bilbao.lima-city.de/BilbaoUtlityLibary.lua"
	local LocalFile = LIB_PATH.."BilbaoUtlityLibary.lua"
	--[[/AutoUpdater]]--
		
	--[[CanUse]]--
	local Can_VP = false
	local Can_PRO = false	
	--[[/CanUse]]--
	
--[[oooooooooooooooooooooooooooo]]--
--[[	General Information		]]--
--[[oooooooooooooooooooooooooooo]]--




--[[oooooooooooooooooooooooooooo]]--
--[[	CheckExistingFiles		]]--
--[[oooooooooooooooooooooooooooo]]--

if FileExist(LIB_PATH.."VPrediction.lua") then
	Can_VP = true
	require "VPrediction"
end

if FileExist(LIB_PATH.."Prodiction.lua") then
	Can_PRO = true
	require "Prodiction"
end

if FileExist(LIB_PATH.."MapPosition.lua") then
	if FileExist(LIB_PATH.."2DGeometry.lua") then		
		require "MapPosition"
		require "2DGeometry"
	else
		print("<font color='#ff0000'[Critical]: 2DGeometry.lua not found. BilbaoUtilityLibary Aborted!</font>")
	end
else
	print("<font color='#ff0000'[Critical]: MapPosition.lua not found. BilbaoUtilityLibary Aborted!</font>")
end
--[[oooooooooooooooooooooooooooo]]--
--[[	/CheckExistingFiles		]]--
--[[oooooooooooooooooooooooooooo]]--




--[[oooooooooooooooooooo]]--
--[[	AutoUpdater		]]--
--[[oooooooooooooooooooo]]--
function CheckVersion(data)
	NetVersion = tonumber(data)
	if type(NetVersion) ~= "number" then return end
	if NetVersion and NetVersion > CurVer then
		_debug("<font color='#FF4000'>-- BilbaoUtlityLibary: New version available "..NetVersion..".</font>", 2) --status = Info, Important, Critical 1,2,3
		_debug("<font color='#FF4000'>-- BilbaoUtlityLibary: Updating, please do not press F9 until update is finished.</font>", 2)		 
		NeedUpdate = true  
	else		 
		_debug("<font color='#00BFFF'>-- BilbaoUtlityLibary: You have the lastest version.</font>", 1)
	end
end


function UpdateScript()
	if Do_Once then	
		Do_Once = false
		if _G.UseUpdater == nil or _G.UseUpdater == true then 			
			GetAsyncWebResult("bilbao.lima-city.de", "BilbaoUtlityLibaryver.txt", CheckVersion)			
		end
	end	
	
	if NeedUpdate then
		NeedUpdate = false
		DownloadFile(NetFile, LocalFile, function()
							if FileExist(LocalFile) then								
								_debug("<font color='#00BFFF'>-- BilbaoUtlityLibary: Successfully updated v"..CurVer.." -> v"..NetVersion.." - Please reload.</font>", 1)
							end
						end
				)
	end
end

if UseAutoUpdate then
	AddTickCallback(UpdateScript)
end
--[[oooooooooooooooooooooooo]]--
--[[	/AutoUpdater		]]--
--[[oooooooooooooooooooooooo]]--




--[[oooooooooooooooo]]--
--[[	Class		]]--
--[[oooooooooooooooo]]--
class 'BULMovement'
--[[
	BULMovement:__init([delay], [packets])
	BULMovement:RotateAround(unit)
	BULMovement:Follow(position, unit, [mindistance], [maxdistance]) --"INFRONT", "BEHIND", "RIGHT", "LEFT"
	BULMovement:Patrol(StartPos, EndPos)
	BULMovement:GoTo(Pos)
	BULMovement:FleeTo([Pos])
]]--

class 'BULCasting'
--[[
	BULCasting:__init(id, range, width, speed, delay, [sequence], [packets])
	BULCasting:Cast([delay])
	FSLSpells:Cast(Target, Predict, CheckCollision)
]]--

class 'BULFarm'
--[[
	BULFarm:__init([mode], [spell1], [spell2], [spell3], [spell4], [item1], [item2], [sequence], [packets])
	BULFarm:GetBestMinion([unit], [range])
	BULFarm:GetMeleeMinion([unit], [range])
	BULFarm:GetCasterMinion([unit], [range])
	BULFarm:GetSiegeMinion([unit], [range])
	BULFarm:GetAntiTurretCannon([unit], [range])
	BULFarm:GetSuperMinion([unit], [range])
	BULFarm:GetDrake()
	BULFarm:GetPredictedDrakeHealth(time)
	BULFarm:GetPredictedDeathTimeDrake()
	BULFarm:GetBaron()
	BULFarm:GetPredictedBaronHealth(time)
	BULFarm:GetPredictedDeathTimeBaron()
	BULFarm:GetFrontMinion(lane, team)
	BULFarm:GetFrontWave(lane, team)	
]]--

class 'BLUHero'
--[[
	BLUHero:__init([chat], [mode])
	BLUHero:GetRole()
	BLUHero:PredictHealth(time)
	BLUHero:PredictMana(time)
	BLUHero:BuyItems()
	BLUHero:GetNextItem()
	BLUHero:GetLane()
	BLUHero:GetLanePartner()
	BLUHero:Say(msg,[team])
	BLUHero:GetJoke([mode])
	BLUHero:Answer(msg)
	BLUHero:GetLanguage(unit)
	BLUHero:Flame(unit)
	BLUHero:Praise(unit)
	BLUHero:Smalltalk(unit)
	BLUHero:Motivate(team, [unit])
	BLUHero:Demotivate(team, [unit])
	BLUHero:SetChatStatus(status, [mode])
	BLUHero:SetChatMode(mode)
	BLUHero:EmoteWalk([emote1], [emote2], [emote3], [emote4], [packet])
	BLUHero:Mute(team, [unit])
	BLUHero:SetAutoWard([mode])
]]--

class 'BLUAlly'
--[[
	BLUEAlly:__init([delay])
	BLUAlly:SetUpdateDelay(delay)
	BLUAlly:GetAllys([status], [lane])
	BLUAlly:GetBestAlly([range],[lane])
	BLUAlly:GetWorstAlly([range],[lane])
]]--

class 'BLUEnemy'
--[[
	BLUEEnemy:__init([delay])
	BLUEnemy:SetUpdateDelay(delay)
	BLUEnemy:GetAllys([status], [lane])
	BLUEnemy:GetBestAlly([range],[lane])
	BLUEnemy:GetWorstAlly([range],[lane])
]]--

class 'BLUTower'
--[[
	BLUTower:__init([delay])
	BLUTower:GetTower([range], [lane])
	BLUTower:GetAllyTower([range], [lane])
	BLUTower:GetEnemyTower([range], [lane])
	BLUTower:UnderTower([Pos], [team])
	BLUTower:GetDominantTower([Pos])
	BLUTower:GetNextTower([Pos], [team])	
]]--

class 'BLUWard'
--[[
	BLUWard:__init([delay], [mode])
	BLUWard:SetWardMode(mode)
	BLUWard:SetAntiWardMode(mode)
	BLUWard:SetWard(Pos)
	BLUWard:DestroyWard(Pos)
	BLUWard:WarnTeam([delay],[chat], [ping])
]]--

class 'BLUDecisions'
--[[
	BLUDecisions:__init([mode])
	BLUDecisions:GetDecision()
	BLUDecisions:SetMode(mode)
	BLUDecisions:SetSavePlay(percent)
	BLUDecisions:SetRiskPlay(percent)
	BLUDecisions:SetTeamPlay(percent)
	BLUDecisions:SetSoloPlay(percent)
	BLUDecisions:SetFarmPlay(percent)
	BlUDecisions:SetTeamfightPlay(percent)
	BLUDecisions:SetKillSecureLevel(percent)	
]]--

class 'BLUFighting'
--[[
	BLUFighting:__init(minmana, delay, [mode], [spell1], [spell2], [spell3], [spell4], [item1], [items2])
	BLUFighting:SetMinMana(percent)	
	BLUFighting:SetCalculationDelay(delay)
	BLUFighting:SetMode(mode)
	BLUFighting:SetSpells([spell1], [spell2], [spell3], [spell4], [item1], [items2])
	BLUFighting:Position(sequence)
	BLUFighting:GetTarget(sequence)
	BLUFighting:OrbwalkHandler(sequence)
	BLUFighting:Orbwalk(mode)
]]--

class 'BLUInfomations'
--[[
	BLUInfomations:__init()
	BLUInfomations:GetPredictedHealth(unit, time)
	BLUInfomations:GetPredictedDeathTime(unit)
	BLUInfomations:GetNextPredictedFatality([team])
	BLUInfomations:GetTotalGoldAmount()
	BLUInfomations:GetItemValue(unit)
	BLUInfomations:GetBestEquippedHero([team])
	BLUInfomations:GetWorstEquippedHero([team])
	BLUInfomations:GetIfUnitAboveGoldAverage(unit)
	BLUInfomations:GetIfUnitBelowGoldAverage(unit)
	BLUInfomations:GetIfTeamAboveGoldAverage(team)
	BLUInfomations:GetIfTeamBelowGoldAverage(team)
	BLUInfomations:AnnounceBuffs(mode)
	BLUInfomations:AnnounceDrake(mode)
	BLUInfomations:AnnounceBaron(mode)
	BLUInfomations:AnnounceGanks(mode)
]]--

class 'BLUDraw'
--[[
	BLUDraw:__init(delay)
	BLUDraw:SetDelay(delay)
	BLUDraw:DrawCube(center, [size], [color], [mode])
	BLUDraw:Octahedron(center, [size], [color], [mode])
	BLUDraw:Tetrahedron(center, [size], [color], [mode])
	BLUDraw:Dodecahedron(center, [size], [color], [mode])
	BLUDraw:Isahedron(center, [size], [color], [mode])
	BLUDraw:TruncatedCube(center, [size], [color], [mode])
	BLUDraw:TruncatedOctahedron(center, [size], [color], [mode])
	BLUDraw:TruncatedTetrahedron(center, [size], [color], [mode])
	BLUDraw:TrundcatedDodecahedron(center, [size], [color], [mode])
	BLUDraw:TruncatedIcosahedron(center, [size], [color], [mode])
	BLUDraw:Cubotahedron(center, [size], [color], [mode])
	BLUDraw:Icosidecahedron(center, [size], [color], [mode])
	BLUDraw:Rhombahedron(center, [size], [color], [mode])
	BLUDraw:Tricontahedron(center, [size], [color], [mode])
	BLUDraw:Rhombicotahedron(center, [size], [color], [mode])
	BLUDraw:Sphere(center, [size], [color], [mode])
	BLUDraw:Cone(center, radius, high, [color], [mode])
	BLUDraw:ConeSawedOff(center, botradius, topradius, high, [color], [mode])
	BLUDraw:Pyramid(center, line, high,[color], [mode])
	BLUDraw:PyramidSawedOff(center, line, high,[color], [mode])
	BLUDraw:Penatgonalcone(center, line, high,[color], [mode])
	BLUDraw:DBoxOnUnit(center, [sizeX], [sizeY], [sizeZ], [color], [mode])
	BLUDraw:DBox(p1, p2, p3, p4, p5, p6, p7, p8,[color], [mode])
	BLUDraw:BoxOnUnit(center, size,[color], [mode])
	BLUDraw:Box(p1, p2, p3, p4,[color], [mode])
	BLUDraw:PolygenOnUnit(center, size,[color], [mode])
	BLUDraw:Polygen(line, line2,[color], [mode])
	BLUDraw:Egg(center, size,[color], [mode])
	BLUDraw:Triangle(p1, p2, p3,[color], [mode])
	BLUDraw:Diamond(p1, p2, p3, p4,[color], [mode])
	BLUDraw:House(p1, p2, p3, p4, p5,[color], [mode])
	BLUDraw:Star(center, size,[color], [mode]))
	BLUDraw:Arrow(FromPos, ToPos, size,[color], [mode])
	BLUDraw:PredictedDmg(unit, [size])
	BLUDraw:Health(unit, [size], [color])
	BLUDraw:Mana(unit, [size], [color])
	BLUDraw:Info(unit, form, [size],[color], [mode])
]]--

class 'BLUSprite'
--[[
	BLUSprite:__init([delay])
	BLUSprite:AddSprite(url, sprite, alpha)
	BLUSprite:SetSprite(sprite, x, y, z, name, [mode])
	BLUSprite:SetOnMouseOver(name, function())
	BLUSprite:SetOnClick(name, function())
	BLUSprite:ChangeAlpa(sprite, alpha)
	BLUSprite:RemoveOnMouseOver(name)
	BLUSprite:RemoveOnClick(name)
	BLUSprite:LoadDemoMenu()
	BLUSprite:UnloadDemoMenu()
	BLUSprite:ChangeMode(name, mode)
	BLUSprite:LoadSnake()
	BLUSprite:PauseSnake()
	BLUSprite:RestartSnake()
	BLUSprite:GetSnakeScore()
	BLUSprite:UnLoadSnake()	
]]--

class 'BLUSound'
--[[
	BLUSound:__init()
	BLUSound:AddSound(name, path)
	BLUSound:PlaySound(name, [mode])
	BLUSound:RemoveSound(name)
	BLUSound:PlayTetrisSound()	
]]--

class 'BLUSave'
--[[
	BLUSave:__init()
	BLUSave:AddSaveFile(name, path, file)
	BLUSave:RemoveSavefile(name)
	BLUSave:Write(text, name, [mode])
	BLUSave:Read(name)
	BLUSave:Copy(name, name)
	BLUSave:Find( p1, name)
	BLUSave:FindBetween( p1, p2, name)
]]--	
--[[oooooooooooooooo]]--
--[[	/Class		]]--
--[[oooooooooooooooo]]--




--[[oooooooooooooooooooo]]--
--[[	SpellData		]]--
--[[oooooooooooooooooooo]]--
_G.SpellData = {


AatroxE = {Range = 1000, Width = 150, Speed = 1200, Delay = 0.5, CC = true, Collision = true},
AatroxQ = {Range = 650, Width = 0, Speed = 20, Delay = 0.5, CC = true, Collision = false},
AatroxR = {Range = 550, Width = 550, Speed = 0, Delay = 0, CC = false, Collision = false},
AatroxW = {Range = 0, Width = 0, Speed = 0, Delay = 0, CC = false, Collision = false},

AhriE = {Range = 975, Width = 60, Speed = 1200, Delay = 0.5, CC = true, Collision = true},
AhriQ = {Range = 880, Width = 80, Speed = 1100, Delay = 0.5, CC = false, Collision = true},
AhriR = {Range = 450, Width = 0, Speed = 2200, Delay = 0.5, CC = false, Collision = false},
AhriW = {Range = 800, Width = 800, Speed = 1800, Delay = 0, CC = false, Collision = false},

AkaliE = {Range = 325, Width = 325, Speed = 0, Delay = 0, CC = false, Collision = false},
AkaliQ = {Range = 600, Width = 0, Speed = 1000, Delay = 0.65, CC = false, Collision = false},
AkaliR = {Range = 800, Width = 0, Speed = 2200, Delay = 0, CC = false, Collision = false},
AkaliW = {Range = 700, Width = 0, Speed = 0, Delay = 0.5, CC = true, Collision = false},

AlistarE = {Range = 575, Width = 0, Speed = 0, Delay = 0, CC = false, Collision = false},
AlistarQ = {Range = 365, Width = 365, Speed = 20, Delay = 0.5, CC = true, Collision = false},
AlistarR = {Range = 0, Width = 0, Speed = 828, Delay = 0, CC = false, Collision = false},
AlistarW = {Range = 100, Width = 0, Speed = 0, Delay = 0.5, CC = true, Collision = true},

AmumuE = {Range = 350, Width = 350, Speed = 7777777, Delay = 0.5, CC = false, Collision = false},
AmumuQ = {Range = 1100, Width = 80, Speed = 2000, Delay = 0.5, CC = true, Collision = true},
AmumuR = {Range = 550, Width = 550, Speed = 7777777, Delay = 0.5, CC = true, Collision = false},
AmumuW = {Range = 300, Width = 300, Speed = 7777777, Delay = 0.47, CC = false, Collision = false},

AniviaE = {Range = 650, Width = 0, Speed = 1200, Delay = 0.5, CC = false, Collision = false},
AniviaQ = {Range = 1200, Width = 110, Speed = 850, Delay = 0.5, CC = true, Collision = true},
AniviaR = {Range = 675, Width = 400, Speed = 7777777, Delay = 0.3, CC = true, Collision = false},
AniviaW = {Range = 1000, Width = 400, Speed = 1600, Delay = 0.5, CC = false, Collision = false},

AnnieE = {Range = 100, Width = 0, Speed = 20, Delay = 0, CC = false, Collision = false},
AnnieQ = {Range = 710, Width = 0, Speed = 1400, Delay = 0.5, CC = false, Collision = false},
AnnieR = {Range = 250, Width = 0, Speed = 7777777, Delay = 0.5, CC = false, Collision = true},
AnnieW = {Range = 210, Width = 0, Speed = 0, Delay = 0.5, CC = false, Collision = true},

AsheE = {Range = 2500, Width = 0, Speed = 1400, Delay = 0.5, CC = false, Collision = false},
AsheQ = {Range = 0, Width = 0, Speed = 7777777, Delay = 0, CC = false, Collision = false},
AsheQ = {Range = 0, Width = 0, Speed = 7777777, Delay = 0, CC = true, Collision = false},
AsheR = {Range = 50000, Width = 130, Speed = 1600, Delay = 0.5, CC = true, Collision = true},
AsheW = {Range = 1200, Width = 250, Speed = 902, Delay = 0.5, CC = true, Collision = true},

BlitzcrankE = {Range = 0, Width = 0, Speed = 0, Delay = 0, CC = true, Collision = false},
BlitzcrankQ = {Range = 925, Width = 70, Speed = 1800, Delay = 0.22, CC = true, Collision = true},
BlitzcrankR = {Range = 600, Width = 600, Speed = 0, Delay = 0, CC = true, Collision = false},
BlitzcrankW = {Range = 0, Width = 0, Speed = 0, Delay = 0, CC = false, Collision = false},

BrandE = {Range = 0, Width = 0, Speed = 1800, Delay = 0, CC = false, Collision = false},
BrandQ = {Range = 1150, Width = 80, Speed = 1200, Delay = 0.5, CC = false, Collision = true},
BrandR = {Range = 0, Width = 0, Speed = 1000, Delay = 0, CC = false, Collision = false},
BrandW = {Range = 240, Width = 0, Speed = 20, Delay = 0.5, CC = false, Collision = false},

CaitlynE = {Range = 950, Width = 80, Speed = 2000, Delay = 0.25, CC = true, Collision = true},
CaitlynQ = {Range = 1250, Width = 90, Speed = 2200, Delay = 0.25, CC = false, Collision = true},
CaitlynR = {Range = 2500, Width = 0, Speed = 1500, Delay = 0, CC = false, Collision = false},
CaitlynW = {Range = 800, Width = 0, Speed = 1400, Delay = 0, CC = true, Collision = false},

CassiopeiaE = {Range = 700, Width = 0, Speed = 1900, Delay = 0, CC = false, Collision = false},
CassiopeiaQ = {Range = 925, Width = 130, Speed = 7777777, Delay = 0.25, CC = false, Collision = false},
CassiopeiaR = {Range = 875, Width = 210, Speed = 7777777, Delay = 0.5, CC = true, Collision = true},
CassiopeiaW = {Range = 925, Width = 212, Speed = 2500, Delay = 0.5, CC = true, Collision = false},

ChogathE = {Range = 0, Width = 170, Speed = 347, Delay = 0, CC = false, Collision = false},
ChogathQ = {Range = 1000, Width = 250, Speed = 7777777, Delay = 0.5, CC = true, Collision = false},
ChogathR = {Range = 230, Width = 0, Speed = 500, Delay = 0, CC = false, Collision = false},
ChogathW = {Range = 675, Width = 210, Speed = 7777777, Delay = 0.25, CC = true, Collision = true},

CorkiE = {Range = 750, Width = 100, Speed = 902, Delay = 0, CC = false, Collision = true},
CorkiQ = {Range = 875, Width = 250, Speed = 7777777, Delay = 0, CC = false, Collision = false},
CorkiR = {Range = 1225, Width = 40, Speed = 828.5, Delay = 0.25, CC = false, Collision = true},
CorkiW = {Range = 875, Width = 160, Speed = 700, Delay = 0, CC = false, Collision = true},

DariusE = {Range = 540, Width = 0, Speed = 1500, Delay = 0.5, CC = true, Collision = true},
DariusQ = {Range = 425, Width = 0, Speed = 0, Delay = 0.5, CC = false, Collision = false},
DariusR = {Range = 460, Width = 0, Speed = 20, Delay = 0.5, CC = false, Collision = false},
DariusW = {Range = 210, Width = 0, Speed = 0, Delay = 0, CC = false, Collision = false},

DianaE = {Range = 300, Width = 300, Speed = 1500, Delay = 0.5, CC = true, Collision = false},
DianaQ = {Range = 900, Width = 75, Speed = 1500, Delay = 0.5, CC = true, Collision = true},
DianaR = {Range = 800, Width = 0, Speed = 1500, Delay = 0.5, CC = true, Collision = false},
DianaW = {Range = 0, Width = 0, Speed = 0, Delay = 0, CC = true, Collision = false},

DravenE = {Range = 1050, Width = 130, Speed = 1600, Delay = 0.5, CC = true, Collision = true},
DravenQ = {Range = 0, Width = 0, Speed = 7777777, Delay = 7777777, CC = false, Collision = false},
DravenR = {Range = 20000, Width = 160, Speed = 2000, Delay = 0.5, CC = false, Collision = true},
DravenW = {Range = 0, Width = 0, Speed = 7777777, Delay = 7777777, CC = false, Collision = false},

DrMundoE = {Range = 0, Width = 0, Speed = 7777777, Delay = 7777777, CC = false, Collision = false},
DrMundoQ = {Range = 900, Width = 75, Speed = 1500, Delay = 0.5, CC = true, Collision = true},
DrMundoR = {Range = 0, Width = 0, Speed = 7777777, Delay = 7777777, CC = false, Collision = false},
DrMundoW = {Range = 225, Width = 225, Speed = 7777777, Delay = 7777777, CC = false, Collision = false},

EliseE = {Range = 1075, Width = 70, Speed = 1450, Delay = 0.5, CC = true, Collision = true},
EliseEM = {Range = 975, Width = 0, Speed = 7777777, Delay = 7777777, CC = false, Collision = false},
EliseEM = {Range = 975, Width = 0, Speed = 7777777, Delay = 7777777, CC = false, Collision = false},
EliseQ = {Range = 625, Width = 0, Speed = 2200, Delay = 0.75, CC = false, Collision = false},
EliseQM = {Range = 475, Width = 0, Speed = 7777777, Delay = 0.5, CC = false, Collision = false},
EliseR = {Range = 0, Width = 0, Speed = 7777777, Delay = 7777777, CC = false, Collision = false},
EliseR = {Range = 0, Width = 0, Speed = 7777777, Delay = 7777777, CC = false, Collision = false},
EliseW = {Range = 950, Width = 235, Speed = 5000, Delay = 0.75, CC = false, Collision = false},
EliseWM = {Range = 0, Width = 0, Speed = 7777777, Delay = 7777777, CC = false, Collision = false},

EvelynnE = {Range = 290, Width = 0, Speed = 900, Delay = 0.5, CC = false, Collision = false},
EvelynnQ = {Range = 500, Width = 500, Speed = 7777777, Delay = 0.5, CC = false, Collision = false},
EvelynnR = {Range = 650, Width = 350, Speed = 1300, Delay = 0.5, CC = true, Collision = false},
EvelynnW = {Range = 0, Width = 0, Speed = 7777777, Delay = 7777777, CC = false, Collision = false},

EzrealE = {Range = 475, Width = 0, Speed = 7777777, Delay = 0.5, CC = false, Collision = false},
EzrealQ = {Range = 1200, Width = 60, Speed = 2000, Delay = 0.25, CC = false, Collision = true},
EzrealR = {Range = 20000, Width = 160, Speed = 2000, Delay = 1, CC = false, Collision = true},
EzrealW = {Range = 1050, Width = 80, Speed = 1600, Delay = 0.25, CC = false, Collision = true},

FiddleSticksE = {Range = 750, Width = 0, Speed = 1100, Delay = 0.5, CC = false, Collision = false},
FiddleSticksQ = {Range = 575, Width = 0, Speed = 7777777, Delay = 0.5, CC = true, Collision = false},
FiddleSticksR = {Range = 800, Width = 600, Speed = 7777777, Delay = 0.5, CC = true, Collision = false},
FiddleSticksW = {Range = 575, Width = 0, Speed = 7777777, Delay = 0.5, CC = false, Collision = false},

FioraE = {Range = 210, Width = 0, Speed = 0, Delay = 0, CC = false, Collision = false},
FioraQ = {Range = 300, Width = 0, Speed = 2200, Delay = 0.5, CC = false, Collision = false},
FioraR = {Range = 210, Width = 0, Speed = 0, Delay = 0.5, CC = false, Collision = false},
FioraW = {Range = 100, Width = 0, Speed = 0, Delay = 0, CC = false, Collision = false},

FizzE = {Range = 400, Width = 500, Speed = 1300, Delay = 0.5, CC = true, Collision = false},
FizzQ = {Range = 550, Width = 0, Speed = 7777777, Delay = 0.5, CC = false, Collision = false},
FizzR = {Range = 1275, Width = 250, Speed = 1200, Delay = 0.5, CC = true, Collision = false},
FizzW = {Range = 0, Width = 0, Speed = 0, Delay = 0.5, CC = false, Collision = false},

GalioE = {Range = 1180, Width = 140, Speed = 1200, Delay = 0.5, CC = false, Collision = true},
GalioQ = {Range = 940, Width = 120, Speed = 1300, Delay = 0.5, CC = true, Collision = false},
GalioR = {Range = 560, Width = 560, Speed = 7777777, Delay = 0.5, CC = true, Collision = false},
GalioW = {Range = 800, Width = 0, Speed = 7777777, Delay = 0.5, CC = false, Collision = false},

GangplankE = {Range = 1300, Width = 0, Speed = 7777777, Delay = 0.5, CC = false, Collision = false},
GangplankQ = {Range = 625, Width = 0, Speed = 2000, Delay = 0.5, CC = false, Collision = false},
GangplankR = {Range = 20000, Width = 525, Speed = 500, Delay = 0.5, CC = true, Collision = false},
GangplankW = {Range = 0, Width = 0, Speed = 7777777, Delay = 0.5, CC = false, Collision = false},

GarenE = {Range = 325, Width = 325, Speed = 700, Delay = 0, CC = false, Collision = false},
GarenQ = {Range = 0, Width = 0, Speed = 7777777, Delay = 0.2, CC = false, Collision = false},
GarenR = {Range = 400, Width = 0, Speed = 7777777, Delay = 0.12, CC = false, Collision = false},
GarenW = {Range = 0, Width = 0, Speed = 7777777, Delay = 0.5, CC = false, Collision = false},

GragasE = {Range = 1100, Width = 50, Speed = 1000, Delay = 0.3, CC = true, Collision = true},
GragasQ = {Range = 1100, Width = 320, Speed = 1000, Delay = 0.3, CC = false, Collision = false},
GragasR = {Range = 1100, Width = 700, Speed = 1000, Delay = 0.3, CC = true, Collision = false},
GragasW = {Range = 0, Width = 0, Speed = 0, Delay = 0, CC = false, Collision = false},

GravesE = {Range = 425, Width = 50, Speed = 1000, Delay = 0.3, CC = false, Collision = false},
GravesQ = {Range = 1100, Width = 10, Speed = 902, Delay = 0.3, CC = false, Collision = true},
GravesR = {Range = 1000, Width = 100, Speed = 1200, Delay = 0.5, CC = false, Collision = true},
GravesW = {Range = 1100, Width = 250, Speed = 1650, Delay = 0.3, CC = true, Collision = false},

HecarimE = {Range = 0, Width = 0, Speed = 7777777, Delay = 7777777, CC = false, Collision = false},
HecarimQ = {Range = 350, Width = 350, Speed = 1450, Delay = 0.3, CC = false, Collision = false},
HecarimR = {Range = 1350, Width = 200, Speed = 1200, Delay = 0.5, CC = true, Collision = true},
HecarimW = {Range = 525, Width = 525, Speed = 828.5, Delay = 0.12, CC = false, Collision = false},

HeimerdingerE = {Range = 970, Width = 120, Speed = 2500, Delay = 0.5, CC = true, Collision = false},
HeimerdingerQ = {Range = 350, Width = 0, Speed = 7777777, Delay = 0.5, CC = false, Collision = false},
HeimerdingerR = {Range = 0, Width = 0, Speed = 7777777, Delay = 0.23, CC = false, Collision = false},
HeimerdingerW = {Range = 1525, Width = 200, Speed = 902, Delay = 0.5, CC = false, Collision = true},

IreliaE = {Range = 325, Width = 0, Speed = 7777777, Delay = 0.5, CC = true, Collision = false},
IreliaQ = {Range = 650, Width = 0, Speed = 2200, Delay = 0, CC = false, Collision = false},
IreliaR = {Range = 1200, Width = 0, Speed = 779, Delay = 0.5, CC = false, Collision = false},
IreliaW = {Range = 0, Width = 0, Speed = 347, Delay = 0.23, CC = false, Collision = false},

JannaE = {Range = 800, Width = 0, Speed = 7777777, Delay = 0.5, CC = false, Collision = false},
JannaQ = {Range = 1800, Width = 200, Speed = 7777777, Delay = 0, CC = true, Collision = true},
JannaR = {Range = 725, Width = 725, Speed = 828.5, Delay = 0.5, CC = true, Collision = false},
JannaW = {Range = 600, Width = 0, Speed = 1600, Delay = 0.5, CC = true, Collision = true},

JarvanIVE = {Range = 830, Width = 75, Speed = 7777777, Delay = 0.5, CC = false, Collision = false},
JarvanIVQ = {Range = 700, Width = 70, Speed = 7777777, Delay = 0.5, CC = false, Collision = true},
JarvanIVR = {Range = 650, Width = 325, Speed = 0, Delay = 0.5, CC = false, Collision = false},
JarvanIVW = {Range = 300, Width = 300, Speed = 0, Delay = 0.5, CC = true, Collision = false},

JaxE = {Range = 425, Width = 425, Speed = 1450, Delay = 0.5, CC = true, Collision = true},
JaxQ = {Range = 210, Width = 0, Speed = 0, Delay = 0.5, CC = false, Collision = false},
JaxR = {Range = 0, Width = 0, Speed = 0, Delay = 0, CC = false, Collision = false},
JaxW = {Range = 0, Width = 0, Speed = 0, Delay = 0.5, CC = false, Collision = false},

JayceE = {Range = 300, Width = 80, Speed = 7777777, Delay = 0, CC = true, Collision = false},
JayceEM = {Range = 685, Width = 0, Speed = 1600, Delay = 0.5, CC = false, Collision = false},
JayceQ = {Range = 600, Width = 0, Speed = 7777777, Delay = 0.5, CC = true, Collision = false},
JayceQM = {Range = 1050, Width = 80, Speed = 1200, Delay = 0.5, CC = false, Collision = false},
JayceR = {Range = 0, Width = 0, Speed = 7777777, Delay = 0.75, CC = false, Collision = false},
JayceW = {Range = 285, Width = 285, Speed = 1500, Delay = 0.5, CC = false, Collision = false},
JayceWM = {Range = 0, Width = 0, Speed = 7777777, Delay = 0.75, CC = false, Collision = false},

KarmaE = {Range = 800, Width = 0, Speed = 7777777, Delay = 0.5, CC = false, Collision = false},
KarmaQ = {Range = 950, Width = 90, Speed = 902, Delay = 0.5, CC = true, Collision = true},
KarmaR = {Range = 0, Width = 0, Speed = 1300, Delay = 0.5, CC = false, Collision = false},
KarmaW = {Range = 700, Width = 60, Speed = 2000, Delay = 0.5, CC = true, Collision = false},

KarthusE = {Range = 550, Width = 550, Speed = 1000, Delay = 0.5, CC = false, Collision = false},
KarthusQ = {Range = 875, Width = 160, Speed = 7777777, Delay = 0.5, CC = false, Collision = false},
KarthusR = {Range = 20000, Width = 0, Speed = 7777777, Delay = 0, CC = false, Collision = false},
KarthusW = {Range = 1090, Width = 525, Speed = 1600, Delay = 0.5, CC = true, Collision = false},

KassadinE = {Range = 700, Width = 10, Speed = 7777777, Delay = 0.5, CC = true, Collision = true},
KassadinQ = {Range = 650, Width = 0, Speed = 1400, Delay = 0.5, CC = false, Collision = false},
KassadinR = {Range = 675, Width = 150, Speed = 7777777, Delay = 0.5, CC = false, Collision = false},
KassadinW = {Range = 0, Width = 0, Speed = 0, Delay = 0, CC = false, Collision = false},

KatarinaE = {Range = 700, Width = 0, Speed = 0, Delay = 0.5, CC = false, Collision = false},
KatarinaQ = {Range = 675, Width = 0, Speed = 1800, Delay = 0.5, CC = false, Collision = false},
KatarinaR = {Range = 550, Width = 550, Speed = 1450, Delay = 0.5, CC = false, Collision = false},
KatarinaW = {Range = 400, Width = 400, Speed = 1800, Delay = 0.5, CC = false, Collision = false},

KayleE = {Range = 0, Width = 0, Speed = 779, Delay = 0.5, CC = false, Collision = false},
KayleQ = {Range = 650, Width = 0, Speed = 1500, Delay = 0.5, CC = true, Collision = false},
KayleR = {Range = 900, Width = 0, Speed = 7777777, Delay = 0.5, CC = false, Collision = false},
KayleW = {Range = 900, Width = 0, Speed = 7777777, Delay = 0.22, CC = false, Collision = false},

KennenE = {Range = 0, Width = 0, Speed = 7777777, Delay = 0, CC = false, Collision = false},
KennenQ = {Range = 1000, Width = 0, Speed = 1700, Delay = 0.69, CC = false, Collision = true},
KennenR = {Range = 550, Width = 550, Speed = 779, Delay = 0.5, CC = false, Collision = false},
KennenW = {Range = 900, Width = 900, Speed = 7777777, Delay = 0.5, CC = false, Collision = false},

KhazixE = {Range = 600, Width = 300, Speed = 7777777, Delay = 0.5, CC = false, Collision = false},
KhazixQ = {Range = 325, Width = 0, Speed = 7777777, Delay = 0.5, CC = false, Collision = false},
KhazixR = {Range = 0, Width = 0, Speed = 7777777, Delay = 0, CC = false, Collision = false},
KhazixW = {Range = 1000, Width = 60, Speed = 828.5, Delay = 0.5, CC = true, Collision = true},

KogMawE = {Range = 1000, Width = 120, Speed = 1200, Delay = 0.5, CC = true, Collision = true},
KogMawQ = {Range = 625, Width = 0, Speed = 7777777, Delay = 0.5, CC = false, Collision = false},
KogMawR = {Range = 1400, Width = 225, Speed = 2000, Delay = 0.6, CC = false, Collision = false},
KogMawW = {Range = 130, Width = 0, Speed = 2000, Delay = 0.5, CC = false, Collision = false},

LeblancE = {Range = 925, Width = 70, Speed = 1600, Delay = 0.5, CC = true, Collision = true},
LeblancQ = {Range = 700, Width = 0, Speed = 2000, Delay = 0.5, CC = false, Collision = false},
LeblancR = {Range = 0, Width = 0, Speed = 7777777, Delay = 0.5, CC = false, Collision = false},
LeblancW = {Range = 600, Width = 220, Speed = 7777777, Delay = 0.5, CC = false, Collision = false},

LeeSinE = {Range = 425, Width = 425, Speed = 7777777, Delay = 0.5, CC = true, Collision = false},
LeeSinQ = {Range = 1000, Width = 60, Speed = 1800, Delay = 0.5, CC = false, Collision = true},
LeeSinR = {Range = 375, Width = 0, Speed = 1500, Delay = 0.5, CC = true, Collision = false},
LeeSinW = {Range = 700, Width = 0, Speed = 1500, Delay = 0, CC = false, Collision = false},

LeonaE = {Range = 900, Width = 85, Speed = 2000, Delay = 0, CC = true, Collision = true},
LeonaQ = {Range = 215, Width = 0, Speed = 0, Delay = 0, CC = true, Collision = false},
LeonaR = {Range = 1200, Width = 315, Speed = 7777777, Delay = 0.7, CC = true, Collision = false},
LeonaW = {Range = 500, Width = 0, Speed = 0, Delay = 3, CC = true, Collision = false},

LissandraE = {Range = 1050, Width = 110, Speed = 850, Delay = 0.5, CC = false, Collision = true},
LissandraQ = {Range = 725, Width = 75, Speed = 1200, Delay = 0.5, CC = true, Collision = true},
LissandraR = {Range = 550, Width = 0, Speed = 7777777, Delay = 0, CC = true, Collision = false},
LissandraW = {Range = 450, Width = 450, Speed = 7777777, Delay = 0.5, CC = true, Collision = false},

LucianE = {Range = 650, Width = 50, Speed = 7777777, Delay = 0.5, CC = false, Collision = false},
LucianQ = {Range = 550, Width = 65, Speed = 500, Delay = 0.5, CC = false, Collision = false},
LucianR = {Range = 1400, Width = 60, Speed = 7777777, Delay = 0.5, CC = false, Collision = true},
LucianW = {Range = 1000, Width = 80, Speed = 500, Delay = 0.5, CC = false, Collision = true},

LuluE = {Range = 650, Width = 0, Speed = 7777777, Delay = 0.64, CC = false, Collision = false},
LuluQ = {Range = 925, Width = 80, Speed = 1400, Delay = 0.5, CC = true, Collision = true},
LuluR = {Range = 900, Width = 0, Speed = 7777777, Delay = 0.5, CC = true, Collision = false},
LuluW = {Range = 650, Width = 0, Speed = 2000, Delay = 0.64, CC = true, Collision = false},

LuxE = {Range = 1100, Width = 275, Speed = 1300, Delay = 0.5, CC = true, Collision = false},
LuxQ = {Range = 1300, Width = 80, Speed = 1200, Delay = 0.5, CC = true, Collision = true},
LuxR = {Range = 3340, Width = 190, Speed = 3000, Delay = 1.75, CC = false, Collision = false},
LuxW = {Range = 1075, Width = 150, Speed = 1200, Delay = 0.5, CC = false, Collision = false},

MalphiteE = {Range = 400, Width = 400, Speed = 7777777, Delay = 0.5, CC = false, Collision = false},
MalphiteQ = {Range = 625, Width = 0, Speed = 1200, Delay = 0.5, CC = true, Collision = false},
MalphiteR = {Range = 1000, Width = 270, Speed = 700, Delay = 0, CC = true, Collision = false},
MalphiteW = {Range = 0, Width = 0, Speed = 7777777, Delay = 0.5, CC = false, Collision = false},

MalzaharE = {Range = 650, Width = 0, Speed = 7777777, Delay = 0.5, CC = false, Collision = false},
MalzaharQ = {Range = 900, Width = 110, Speed = 7777777, Delay = 0.5, CC = true, Collision = false},
MalzaharR = {Range = 700, Width = 0, Speed = 7777777, Delay = 0.5, CC = true, Collision = false},
MalzaharW = {Range = 800, Width = 250, Speed = 7777777, Delay = 0.5, CC = false, Collision = false},

MaokaiE = {Range = 1100, Width = 250, Speed = 1750, Delay = 0.5, CC = false, Collision = false},
MaokaiQ = {Range = 600, Width = 110, Speed = 1200, Delay = 0.5, CC = true, Collision = true},
MaokaiR = {Range = 625, Width = 575, Speed = 7777777, Delay = 0.5, CC = false, Collision = false},
MaokaiW = {Range = 650, Width = 0, Speed = 7777777, Delay = 0.5, CC = true, Collision = false},

MasterYiE = {Range = 0, Width = 0, Speed = 7777777, Delay = 0.23, CC = false, Collision = false},
MasterYiQ = {Range = 600, Width = 0, Speed = 4000, Delay = 0.5, CC = false, Collision = false},
MasterYiR = {Range = 0, Width = 0, Speed = 7777777, Delay = 0.37, CC = false, Collision = false},
MasterYiW = {Range = 0, Width = 0, Speed = 7777777, Delay = 0.5, CC = false, Collision = false},

MissFortuneE = {Range = 1000, Width = 400, Speed = 500, Delay = 0.5, CC = true, Collision = false},
MissFortuneQ = {Range = 650, Width = 0, Speed = 1400, Delay = 0.5, CC = false, Collision = false},
MissFortuneR = {Range = 1400, Width = 100, Speed = 775, Delay = 0.5, CC = false, Collision = true},
MissFortuneW = {Range = 0, Width = 0, Speed = 7777777, Delay = 0, CC = false, Collision = false},

MonkeyKingE = {Range = 625, Width = 0, Speed = 2200, Delay = 0, CC = false, Collision = false},
MonkeyKingQ = {Range = 300, Width = 0, Speed = 20, Delay = 0.5, CC = false, Collision = false},
MonkeyKingR = {Range = 315, Width = 315, Speed = 700, Delay = 0, CC = true, Collision = false},
MonkeyKingW = {Range = 325, Width = 325, Speed = 0, Delay = 0.5, CC = false, Collision = false},

MordekaiserE = {Range = 700, Width = 0, Speed = 1500, Delay = 0.5, CC = false, Collision = true},
MordekaiserQ = {Range = 600, Width = 0, Speed = 1500, Delay = 0.5, CC = false, Collision = false},
MordekaiserR = {Range = 850, Width = 0, Speed = 1500, Delay = 0.5, CC = false, Collision = false},
MordekaiserW = {Range = 750, Width = 0, Speed = 7777777, Delay = 0.5, CC = false, Collision = false},

MorganaE = {Range = 750, Width = 0, Speed = 7777777, Delay = 0.5, CC = false, Collision = false},
MorganaQ = {Range = 1175, Width = 70, Speed = 1200, Delay = 0.5, CC = true, Collision = true},
MorganaR = {Range = 600, Width = 600, Speed = 7777777, Delay = 0.5, CC = true, Collision = true},
MorganaW = {Range = 1075, Width = 350, Speed = 7777777, Delay = 0.5, CC = false, Collision = false},

NamiE = {Range = 800, Width = 0, Speed = 7777777, Delay = 0.5, CC = false, Collision = false},
NamiQ = {Range = 875, Width = 200, Speed = 1750, Delay = 0.5, CC = true, Collision = false},
NamiR = {Range = 2550, Width = 600, Speed = 1200, Delay = 0.5, CC = true, Collision = true},
NamiW = {Range = 725, Width = 0, Speed = 1100, Delay = 0.5, CC = false, Collision = false},

NasusE = {Range = 850, Width = 400, Speed = 7777777, Delay = 0.5, CC = false, Collision = false},
NasusQ = {Range = 0, Width = 0, Speed = 7777777, Delay = 0.5, CC = false, Collision = false},
NasusR = {Range = 1, Width = 350, Speed = 7777777, Delay = 0.5, CC = false, Collision = false},
NasusW = {Range = 600, Width = 0, Speed = 7777777, Delay = 0.5, CC = true, Collision = false},

NautilusE = {Range = 600, Width = 600, Speed = 1300, Delay = 0.5, CC = true, Collision = false},
NautilusQ = {Range = 950, Width = 80, Speed = 1200, Delay = 0.5, CC = true, Collision = true},
NautilusR = {Range = 1500, Width = 60, Speed = 1400, Delay = 0.5, CC = true, Collision = false},
NautilusW = {Range = 0, Width = 0, Speed = 0, Delay = 0, CC = false, Collision = false},

NidaleeE = {Range = 600, Width = 0, Speed = 7777777, Delay = 0, CC = false, Collision = false},
NidaleeEM = {Range = 300, Width = 300, Speed = 7777777, Delay = 0.5, CC = false, Collision = false},
NidaleeQ = {Range = 1500, Width = 60, Speed = 1300, Delay = 0.5, CC = false, Collision = true},
NidaleeQM = {Range = 50, Width = 0, Speed = 500, Delay = 0, CC = false, Collision = false},
NidaleeR = {Range = 0, Width = 0, Speed = 7777777, Delay = 0, CC = false, Collision = false},
NidaleeW = {Range = 900, Width = 125, Speed = 1450, Delay = 0.5, CC = false, Collision = false},
NidaleeWM = {Range = 375, Width = 150, Speed = 1500, Delay = 0.5, CC = false, Collision = false},

NocturneE = {Range = 500, Width = 0, Speed = 0, Delay = 0.5, CC = true, Collision = false},
NocturneQ = {Range = 1125, Width = 60, Speed = 1600, Delay = 0.5, CC = false, Collision = true},
NocturneR = {Range = 2000, Width = 0, Speed = 500, Delay = 0.5, CC = false, Collision = false},
NocturneW = {Range = 0, Width = 0, Speed = 500, Delay = 0.5, CC = false, Collision = false},

NunuE = {Range = 550, Width = 0, Speed = 1000, Delay = 0.5, CC = true, Collision = false},
NunuQ = {Range = 125, Width = 60, Speed = 1400, Delay = 0.5, CC = false, Collision = false},
NunuR = {Range = 650, Width = 650, Speed = 7777777, Delay = 0.5, CC = true, Collision = false},
NunuW = {Range = 700, Width = 0, Speed = 7777777, Delay = 0.5, CC = false, Collision = false},

OlafE = {Range = 325, Width = 0, Speed = 7777777, Delay = 0.5, CC = false, Collision = false},
OlafQ = {Range = 1000, Width = 90, Speed = 1600, Delay = 0.5, CC = true, Collision = true},
OlafR = {Range = 0, Width = 0, Speed = 7777777, Delay = 0.5, CC = false, Collision = false},
OlafW = {Range = 0, Width = 0, Speed = 7777777, Delay = 0.5, CC = false, Collision = false},

OriannaE = {Range = 1095, Width = 145, Speed = 1200, Delay = 0.5, CC = false, Collision = false},
OriannaQ = {Range = 1100, Width = 145, Speed = 1200, Delay = 0.5, CC = false, Collision = true},
OriannaR = {Range = 0, Width = 425, Speed = 1200, Delay = 0.5, CC = true, Collision = false},
OriannaW = {Range = 0, Width = 260, Speed = 1200, Delay = 0.5, CC = true, Collision = false},

PantheonE = {Range = 600, Width = 100, Speed = 775, Delay = 0.5, CC = false, Collision = true},
PantheonQ = {Range = 600, Width = 0, Speed = 1500, Delay = 0.5, CC = false, Collision = false},
PantheonR = {Range = 5500, Width = 1000, Speed = 3000, Delay = 1, CC = true, Collision = false},
PantheonW = {Range = 600, Width = 0, Speed = 7777777, Delay = 0.5, CC = true, Collision = false},

PoppyE = {Range = 525, Width = 0, Speed = 1450, Delay = 0.5, CC = true, Collision = false},
PoppyQ = {Range = 0, Width = 0, Speed = 7777777, Delay = 0.5, CC = false, Collision = false},
PoppyR = {Range = 900, Width = 0, Speed = 7777777, Delay = 0.5, CC = false, Collision = false},
PoppyW = {Range = 0, Width = 0, Speed = 7777777, Delay = 0.5, CC = false, Collision = false},

QuinnE = {Range = 700, Width = 0, Speed = 775, Delay = 0.5, CC = true, Collision = false},
QuinnQ = {Range = 1025, Width = 80, Speed = 1200, Delay = 0.5, CC = true, Collision = true},
QuinnR = {Range = 700, Width = 700, Speed = 0, Delay = 0, CC = false, Collision = false},
QuinnW = {Range = 2100, Width = 0, Speed = 0, Delay = 0, CC = false, Collision = false},

RammusE = {Range = 325, Width = 0, Speed = 7777777, Delay = 0.5, CC = true, Collision = false},
RammusQ = {Range = 0, Width = 200, Speed = 775, Delay = 0.5, CC = false, Collision = false},
RammusR = {Range = 300, Width = 300, Speed = 7777777, Delay = 0.5, CC = false, Collision = false},
RammusW = {Range = 0, Width = 0, Speed = 7777777, Delay = 0.5, CC = false, Collision = false},

RenektonE = {Range = 450, Width = 50, Speed = 1400, Delay = 0.5, CC = true, Collision = true},
RenektonQ = {Range = 1, Width = 450, Speed = 7777777, Delay = 0.5, CC = false, Collision = false},
RenektonR = {Range = 1, Width = 530, Speed = 775, Delay = 0.5, CC = false, Collision = false},
RenektonW = {Range = 0, Width = 0, Speed = 7777777, Delay = 0.5, CC = false, Collision = false},

RengarE = {Range = 1000, Width = 70, Speed = 1500, Delay = 0.5, CC = true, Collision = false},
RengarQ = {Range = 0, Width = 0, Speed = 7777777, Delay = 0.5, CC = false, Collision = false},
RengarR = {Range = 0, Width = 0, Speed = 7777777, Delay = 0.5, CC = false, Collision = false},
RengarW = {Range = 1, Width = 500, Speed = 7777777, Delay = 0.5, CC = true, Collision = false},

RivenE = {Range = 325, Width = 0, Speed = 1450, Delay = 0, CC = false, Collision = false},
RivenQ = {Range = 250, Width = 0, Speed = 0, Delay = 0.5, CC = true, Collision = false},
RivenR = {Range = 900, Width = 200, Speed = 1450, Delay = 0.3, CC = false, Collision = true},
RivenW = {Range = 260, Width = 260, Speed = 1500, Delay = 0.25, CC = true, Collision = false},

RumbleE = {Range = 850, Width = 90, Speed = 1200, Delay = 0.5, CC = true, Collision = true},
RumbleQ = {Range = 600, Width = 10, Speed = 7777777, Delay = 0.5, CC = false, Collision = true},
RumbleR = {Range = 1700, Width = 0, Speed = 1400, Delay = 0.5, CC = true, Collision = true},
RumbleW = {Range = 0, Width = 0, Speed = 0, Delay = 0, CC = false, Collision = false},

RyzeE = {Range = 600, Width = 0, Speed = 1000, Delay = 0.5, CC = false, Collision = false},
RyzeQ = {Range = 625, Width = 0, Speed = 1400, Delay = 0.5, CC = false, Collision = false},
RyzeR = {Range = 625, Width = 0, Speed = 1400, Delay = 0.5, CC = true, Collision = false},
RyzeW = {Range = 600, Width = 0, Speed = 7777777, Delay = 0.5, CC = true, Collision = false},

SejuaniE = {Range = 1, Width = 1000, Speed = 1450, Delay = 0.5, CC = true, Collision = false},
SejuaniQ = {Range = 650, Width = 75, Speed = 1450, Delay = 0.5, CC = true, Collision = true},
SejuaniR = {Range = 1175, Width = 110, Speed = 1400, Delay = 0.5, CC = true, Collision = true},
SejuaniW = {Range = 1, Width = 350, Speed = 1500, Delay = 0.5, CC = false, Collision = false},

ShacoE = {Range = 625, Width = 0, Speed = 1500, Delay = 0.5, CC = true, Collision = false},
ShacoQ = {Range = 400, Width = 0, Speed = 7777777, Delay = 0.5, CC = false, Collision = false},
ShacoR = {Range = 1125, Width = 250, Speed = 395, Delay = 0.5, CC = false, Collision = false},
ShacoW = {Range = 425, Width = 60, Speed = 1450, Delay = 0.5, CC = true, Collision = false},

ShenE = {Range = 600, Width = 50, Speed = 1000, Delay = 0.5, CC = true, Collision = true},
ShenQ = {Range = 475, Width = 0, Speed = 1500, Delay = 0.5, CC = false, Collision = false},
ShenR = {Range = 22000, Width = 0, Speed = 7777777, Delay = 0.5, CC = false, Collision = false},
ShenW = {Range = 0, Width = 0, Speed = 7777777, Delay = 0.5, CC = false, Collision = false},

ShyvanaE = {Range = 925, Width = 60, Speed = 1200, Delay = 0.5, CC = false, Collision = true},
ShyvanaQ = {Range = 0, Width = 0, Speed = 7777777, Delay = 0.5, CC = false, Collision = false},
ShyvanaR = {Range = 1000, Width = 160, Speed = 700, Delay = 0.5, CC = true, Collision = true},
ShyvanaW = {Range = 0, Width = 325, Speed = 7777777, Delay = 0.5, CC = false, Collision = false},

SingedE = {Range = 125, Width = 0, Speed = 7777777, Delay = 0.5, CC = true, Collision = false},
SingedQ = {Range = 0, Width = 400, Speed = 7777777, Delay = 0.5, CC = false, Collision = false},
SingedR = {Range = 0, Width = 0, Speed = 7777777, Delay = 0.5, CC = false, Collision = false},
SingedW = {Range = 1175, Width = 350, Speed = 700, Delay = 0.5, CC = true, Collision = false},

SionE = {Range = 0, Width = 0, Speed = 7777777, Delay = 0.5, CC = false, Collision = false},
SionQ = {Range = 550, Width = 0, Speed = 1600, Delay = 0.5, CC = true, Collision = false},
SionR = {Range = 0, Width = 0, Speed = 500, Delay = 0.5, CC = false, Collision = false},
SionW = {Range = 550, Width = 550, Speed = 7777777, Delay = 0.5, CC = false, Collision = false},

SivirE = {Range = 0, Width = 0, Speed = 7777777, Delay = 0.5, CC = false, Collision = false},
SivirQ = {Range = 1075, Width = 90, Speed = 1350, Delay = 0.5, CC = false, Collision = true},
SivirR = {Range = 1000, Width = 1000, Speed = 7777777, Delay = 0.5, CC = false, Collision = false},
SivirW = {Range = 500, Width = 0, Speed = 7777777, Delay = 0.5, CC = false, Collision = false},

SkarnerE = {Range = 1000, Width = 60, Speed = 1200, Delay = 0.5, CC = true, Collision = true},
SkarnerQ = {Range = 350, Width = 350, Speed = 7777777, Delay = 0, CC = false, Collision = false},
SkarnerR = {Range = 350, Width = 0, Speed = 7777777, Delay = 0, CC = true, Collision = false},
SkarnerW = {Range = 0, Width = 0, Speed = 7777777, Delay = 0, CC = false, Collision = false},

SonaE = {Range = 1000, Width = 1000, Speed = 1500, Delay = 0.5, CC = false, Collision = false},
SonaQ = {Range = 700, Width = 700, Speed = 1500, Delay = 0.5, CC = false, Collision = false},
SonaR = {Range = 900, Width = 125, Speed = 2400, Delay = 0.5, CC = true, Collision = true},
SonaW = {Range = 1000, Width = 1000, Speed = 1500, Delay = 0.5, CC = false, Collision = false},

SorakaE = {Range = 725, Width = 0, Speed = 7777777, Delay = 0.5, CC = false, Collision = false},
SorakaQ = {Range = 675, Width = 675, Speed = 7777777, Delay = 0.5, CC = false, Collision = false},
SorakaR = {Range = 25000, Width = 0, Speed = 7777777, Delay = 0.5, CC = false, Collision = false},
SorakaW = {Range = 750, Width = 0, Speed = 7777777, Delay = 0.5, CC = false, Collision = false},

SwainE = {Range = 625, Width = 0, Speed = 1400, Delay = 0.5, CC = false, Collision = false},
SwainQ = {Range = 625, Width = 0, Speed = 7777777, Delay = 0.5, CC = true, Collision = false},
SwainR = {Range = 700, Width = 700, Speed = 950, Delay = 0.5, CC = false, Collision = false},
SwainW = {Range = 1040, Width = 275, Speed = 1250, Delay = 0.5, CC = true, Collision = false},

SyndraE = {Range = 700, Width = 0, Speed = 902, Delay = 0.5, CC = true, Collision = true},
SyndraQ = {Range = 800, Width = 200, Speed = 1750, Delay = 0.25, CC = false, Collision = false},
SyndraR = {Range = 675, Width = 0, Speed = 1100, Delay = 0.5, CC = false, Collision = false},
SyndraW = {Range = 950, Width = 200, Speed = 1450, Delay = 0.5, CC = true, Collision = false},

TalonE = {Range = 750, Width = 0, Speed = 1200, Delay = 0, CC = true, Collision = false},
TalonQ = {Range = 0, Width = 0, Speed = 0, Delay = 0, CC = false, Collision = false},
TalonR = {Range = 750, Width = 0, Speed = 0, Delay = 0, CC = false, Collision = false},
TalonW = {Range = 750, Width = 0, Speed = 1200, Delay = 0.5, CC = true, Collision = true},

TaricE = {Range = 625, Width = 0, Speed = 1400, Delay = 0.5, CC = true, Collision = false},
TaricQ = {Range = 750, Width = 0, Speed = 1200, Delay = 0.5, CC = false, Collision = false},
TaricR = {Range = 400, Width = 200, Speed = 7777777, Delay = 0.5, CC = false, Collision = false},
TaricW = {Range = 400, Width = 200, Speed = 7777777, Delay = 0.5, CC = false, Collision = false},

TeemoE = {Range = 0, Width = 0, Speed = 7777777, Delay = 0.5, CC = false, Collision = false},
TeemoQ = {Range = 580, Width = 0, Speed = 1500, Delay = 0.5, CC = true, Collision = false},
TeemoR = {Range = 230, Width = 0, Speed = 1500, Delay = 0, CC = true, Collision = false},
TeemoW = {Range = 0, Width = 0, Speed = 943, Delay = 0, CC = false, Collision = false},

ThreshE = {Range = 515, Width = 160, Speed = 7777777, Delay = 0.3, CC = true, Collision = true},
ThreshQ = {Range = 1075, Width = 60, Speed = 1200, Delay = 0.5, CC = true, Collision = true},
ThreshR = {Range = 420, Width = 420, Speed = 7777777, Delay = 0.3, CC = true, Collision = false},
ThreshW = {Range = 950, Width = 315, Speed = 7777777, Delay = 0.5, CC = false, Collision = false},

TristanaE = {Range = 625, Width = 0, Speed = 1400, Delay = 0.5, CC = false, Collision = false},
TristanaQ = {Range = 0, Width = 0, Speed = 7777777, Delay = 0.5, CC = false, Collision = false},
TristanaR = {Range = 700, Width = 0, Speed = 1600, Delay = 0.5, CC = true, Collision = false},
TristanaW = {Range = 900, Width = 270, Speed = 1150, Delay = 0.5, CC = false, Collision = false},

TrundleE = {Range = 1100, Width = 188, Speed = 1600, Delay = 0.5, CC = true, Collision = false},
TrundleQ = {Range = 0, Width = 0, Speed = 7777777, Delay = 0.5, CC = true, Collision = false},
TrundleR = {Range = 700, Width = 0, Speed = 1400, Delay = 0.5, CC = false, Collision = false},
TrundleW = {Range = 0, Width = 900, Speed = 7777777, Delay = 0.5, CC = true, Collision = false},

TryndamereE = {Range = 660, Width = 225, Speed = 700, Delay = 0.5, CC = false, Collision = false},
TryndamereQ = {Range = 0, Width = 0, Speed = 7777777, Delay = 0.5, CC = false, Collision = false},
TryndamereR = {Range = 0, Width = 0, Speed = 7777777, Delay = 0.5, CC = false, Collision = false},
TryndamereW = {Range = 400, Width = 400, Speed = 500, Delay = 0.5, CC = true, Collision = false},

TwichE = {Range = 1200, Width = 0, Speed = 7777777, Delay = 0.5, CC = false, Collision = false},
TwichQ = {Range = 0, Width = 0, Speed = 7777777, Delay = 0.5, CC = false, Collision = false},
TwichR = {Range = 850, Width = 0, Speed = 500, Delay = 0.5, CC = false, Collision = false},
TwichW = {Range = 800, Width = 275, Speed = 1750, Delay = 0.5, CC = true, Collision = false},

TwistedFateE = {Range = 525, Width = 0, Speed = 1200, Delay = 0.5, CC = false, Collision = false},
TwistedFateQ = {Range = 1450, Width = 80, Speed = 1450, Delay = 0.5, CC = false, Collision = true},
TwistedFateR = {Range = 5500, Width = 0, Speed = 7777777, Delay = 0.5, CC = false, Collision = false},
TwistedFateW = {Range = 600, Width = 0, Speed = 7777777, Delay = 0.5, CC = true, Collision = false},

UdyrE = {Range = 0, Width = 0, Speed = 7777777, Delay = 0.5, CC = true, Collision = false},
UdyrQ = {Range = 0, Width = 0, Speed = 7777777, Delay = 0.5, CC = false, Collision = false},
UdyrR = {Range = 0, Width = 0, Speed = 7777777, Delay = 0.5, CC = false, Collision = false},
UdyrW = {Range = 0, Width = 0, Speed = 7777777, Delay = 0.5, CC = false, Collision = false},

UrgotE = {Range = 950, Width = 150, Speed = 1750, Delay = 0.5, CC = false, Collision = false},
UrgotQ = {Range = 1000, Width = 80, Speed = 1600, Delay = 0.5, CC = false, Collision = false},
UrgotR = {Range = 850, Width = 0, Speed = 1800, Delay = 0.5, CC = true, Collision = false},
UrgotW = {Range = 0, Width = 300, Speed = 7777777, Delay = 0.5, CC = false, Collision = false},

VarusE = {Range = 925, Width = 55, Speed = 1500, Delay = 0.5, CC = true, Collision = false},
VarusQ = {Range = 1500, Width = 100, Speed = 1500, Delay = 0.5, CC = false, Collision = true},
VarusR = {Range = 1300, Width = 80, Speed = 1500, Delay = 0.5, CC = true, Collision = true},
VarusW = {Range = 0, Width = 0, Speed = 0, Delay = 0.5, CC = false, Collision = false},

VayneE = {Range = 450, Width = 0, Speed = 1200, Delay = 0.5, CC = true, Collision = false},
VayneQ = {Range = 250, Width = 0, Speed = 7777777, Delay = 0.5, CC = false, Collision = false},
VayneR = {Range = 0, Width = 0, Speed = 7777777, Delay = 0.5, CC = false, Collision = false},
VayneW = {Range = 0, Width = 0, Speed = 7777777, Delay = 0, CC = false, Collision = false},

VeigarE = {Range = 650, Width = 350, Speed = 1500, Delay = 7777777, CC = true, Collision = false},
VeigarQ = {Range = 650, Width = 0, Speed = 1500, Delay = 0.5, CC = false, Collision = false},
VeigarR = {Range = 650, Width = 0, Speed = 1400, Delay = 0.5, CC = false, Collision = false},
VeigarW = {Range = 900, Width = 240, Speed = 1500, Delay = 1.2, CC = false, Collision = false},

VelkozE = {Range = 850, Width = 0, Speed = 500, Delay = 0, CC = true, Collision = false},
VelkozQ = {Range = 1050, Width = 60, Speed = 1200, Delay = 0.425, CC = true, Collision = true},
VelkozR = {Range = 1575, Width = 0, Speed = 1500, Delay = 0.5, CC = true, Collision = true},
VelkozW = {Range = 1050, Width = 90, Speed = 1200, Delay = 0, CC = false, Collision = true},

ViE = {Range = 600, Width = 0, Speed = 0, Delay = 0, CC = false, Collision = true},
ViQ = {Range = 800, Width = 55, Speed = 1500, Delay = 0.5, CC = true, Collision = true},
ViR = {Range = 800, Width = 0, Speed = 0, Delay = 0.5, CC = true, Collision = false},
ViW = {Range = 0, Width = 0, Speed = 0, Delay = 0, CC = false, Collision = false},

ViktorE = {Range = 700, Width = 90, Speed = 1210, Delay = 0.5, CC = false, Collision = true},
ViktorQ = {Range = 600, Width = 0, Speed = 1400, Delay = 0.5, CC = false, Collision = false},
ViktorR = {Range = 700, Width = 250, Speed = 1210, Delay = 0.5, CC = true, Collision = false},
ViktorW = {Range = 815, Width = 300, Speed = 1750, Delay = 0.5, CC = true, Collision = false},

VladimirE = {Range = 610, Width = 610, Speed = 1100, Delay = 0.5, CC = false, Collision = false},
VladimirQ = {Range = 600, Width = 0, Speed = 1400, Delay = 0.5, CC = false, Collision = false},
VladimirR = {Range = 875, Width = 375, Speed = 1200, Delay = 0.5, CC = false, Collision = false},
VladimirW = {Range = 350, Width = 350, Speed = 1600, Delay = 0.5, CC = true, Collision = false},

VolibearE = {Range = 425, Width = 425, Speed = 825, Delay = 0.5, CC = true, Collision = false},
VolibearQ = {Range = 300, Width = 0, Speed = 7777777, Delay = 0.5, CC = false, Collision = false},
VolibearR = {Range = 425, Width = 425, Speed = 825, Delay = 0, CC = false, Collision = false},
VolibearW = {Range = 400, Width = 0, Speed = 1450, Delay = 0.5, CC = false, Collision = false},

WarwickE = {Range = 1500, Width = 0, Speed = 7777777, Delay = 0, CC = false, Collision = false},
WarwickQ = {Range = 400, Width = 0, Speed = 7777777, Delay = 0, CC = false, Collision = false},
WarwickR = {Range = 700, Width = 0, Speed = 7777777, Delay = 0.5, CC = true, Collision = false},
WarwickW = {Range = 1000, Width = 0, Speed = 7777777, Delay = 0, CC = false, Collision = false},

XerathE = {Range = 1050, Width = 70, Speed = 1600, Delay = 0.5, CC = true, Collision = true},
XerathQ = {Range = 750, Width = 100, Speed = 500, Delay = 0.75, CC = false, Collision = true},
XerathR = {Range = 5600, Width = 200, Speed = 500, Delay = 0.75, CC = false, Collision = false},
XerathW = {Range = 1100, Width = 200, Speed = 20, Delay = 0.5, CC = true, Collision = false},

Xin ZhaoE = {Range = 600, Width = 120, Speed = 1750, Delay = 0.5, CC = true, Collision = false},
Xin ZhaoQ = {Range = 200, Width = 0, Speed = 2000, Delay = 0, CC = false, Collision = false},
Xin ZhaoR = {Range = 375, Width = 375, Speed = 1750, Delay = 0, CC = true, Collision = false},
Xin ZhaoW = {Range = 0, Width = 0, Speed = 2000, Delay = 0, CC = false, Collision = false},

YasuoE = {Range = 475, Width = 0, Speed = 20, Delay = 0.5, CC = false, Collision = false},
YasuoQ = {Range = 475, Width = 55, Speed = 1500, Delay = 0.75, CC = false, Collision = true},
YasuoR = {Range = 1200, Width = 0, Speed = 20, Delay = 0.5, CC = false, Collision = false},
YasuoW = {Range = 400, Width = 0, Speed = 500, Delay = 0.5, CC = false, Collision = false},

YorickE = {Range = 550, Width = 200, Speed = 7777777, Delay = 0.5, CC = true, Collision = false},
YorickQ = {Range = 0, Width = 0, Speed = 7777777, Delay = 0.5, CC = false, Collision = false},
YorickR = {Range = 900, Width = 0, Speed = 1500, Delay = 0.5, CC = false, Collision = false},
YorickW = {Range = 600, Width = 200, Speed = 7777777, Delay = 0.5, CC = true, Collision = false},

ZacE = {Range = 1550, Width = 250, Speed = 1500, Delay = 0.5, CC = true, Collision = false},
ZacQ = {Range = 550, Width = 120, Speed = 902, Delay = 0.5, CC = true, Collision = true},
ZacR = {Range = 850, Width = 300, Speed = 1800, Delay = 0.5, CC = true, Collision = false},
ZacW = {Range = 350, Width = 350, Speed = 1600, Delay = 0.5, CC = false, Collision = false},

ZedE = {Range = 300, Width = 300, Speed = 0, Delay = 0, CC = true, Collision = false},
ZedQ = {Range = 900, Width = 45, Speed = 902, Delay = 0.5, CC = false, Collision = true},
ZedR = {Range = 850, Width = 0, Speed = 0, Delay = 0.5, CC = false, Collision = false},
ZedW = {Range = 550, Width = 40, Speed = 1600, Delay = 0.5, CC = false, Collision = false},

ZiggsE = {Range = 850, Width = 350, Speed = 1750, Delay = 0.5, CC = true, Collision = false},
ZiggsQ = {Range = 850, Width = 75, Speed = 1750, Delay = 0.5, CC = false, Collision = true},
ZiggsR = {Range = 850, Width = 600, Speed = 1750, Delay = 0.5, CC = false, Collision = false},
ZiggsW = {Range = 850, Width = 300, Speed = 1750, Delay = 0.5, CC = true, Collision = false},


ZileanE = {Range = 700, Width = 0, Speed = 1100, Delay = 0.5, CC = true, Collision = false},
ZileanQ = {Range = 700, Width = 0, Speed = 1100, Delay = 0, CC = false, Collision = false},
ZileanR = {Range = 780, Width = 0, Speed = 7777777, Delay = 0.5, CC = false, Collision = false},
ZileanW = {Range = 0, Width = 0, Speed = 7777777, Delay = 0.5, CC = false, Collision = false},

ZyraE = {Range = 1100, Width = 70, Speed = 1400, Delay = 0.5, CC = true, Collision = true},
ZyraQ = {Range = 800, Width = 240, Speed = 1400, Delay = 0.5, CC = false, Collision = false},
ZyraR = {Range = 700, Width = 550, Speed = 20, Delay = 0.5, CC = true, Collision = false},
ZyraW = {Range = 800, Width = 0, Speed = 2200, Delay = 0.5, CC = false, Collision = false}


}
--[[oooooooooooooooooooo]]--
--[[	/SpellData		]]--
--[[oooooooooooooooooooo]]--




--[[oooooooooooooooo]]--
--[[	Debug		]]--
--[[oooooooooooooooo]]--
--[[
status = true/false
level = 1/2/3 = Info/Important/Critical
]]--
function BilbaoUtilityLibary:Debug(status, level)
	UseDebug = status
	DebugLevel = level
end


--[[
status = 1/2/3 = Info/Important/Critical
]]--
function _debug(text, status)
if not UseDebug then return end
local color, info = nil, nil
if status == 1 then
	color = "#ffffff"
	info = "[Info]"
elseif status == 2 then
	color = "#ffa500"
	info = "[Important]"
elseif status == 3 then
	color = "#ff0000"
	info = "[Critical]"
elseif status > 3 or status < 1 or status == nil then
	color = "#ffb1b1"
	info = "[Unknown]"
end
if Status >= DebugLevel then
	print("<font color='"..color.."'"..info..": "..text.."</font>")
end
end
--[[oooooooooooooooo]]--
--[[	/Debug		]]--
--[[oooooooooooooooo]]--
