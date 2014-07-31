if myHero.charName == "Thresh" or not VIP_USER then return end
function OnLoad()
	Lanternm = scriptConfig("Lantern Clicker", "Lantern")	
		Lanternm:addSubMenu("OnKeyDown", "okdmenu")
			Lanternm.okdmenu:addParam("UseLantern", "Use Lantern OnKeyDown", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("A"))
			Lanternm.okdmenu:addParam("okdhealth", "Use Lantern under % health", SCRIPT_PARAM_SLICE, 15, 0, 100, 0)
			Lanternm.okdmenu:permaShow("UseLantern")	
		Lanternm:addSubMenu("OnOffToggle", "onoffmenu")
			Lanternm.onoffmenu:addParam("lanoffon", "Use Lantern OnOff", SCRIPT_PARAM_ONOFF, true)
			Lanternm.onoffmenu:addParam("hconoff", "Use Lantern under % health", SCRIPT_PARAM_SLICE, 25, 0, 100, 0)
			Lanternm.onoffmenu:permaShow("lanoffon")				
		Lanternm:addSubMenu("ForceClickRange", "fcR")
			Lanternm.fcR:addParam("fcrange", "Run to Lantern if near", SCRIPT_PARAM_SLICE, 100, 100, 1000, 0)		
		Lanternm:addSubMenu("Drawing", "draw")
			Lanternm.draw:addParam("lantern", "Mark Lantern Range", SCRIPT_PARAM_ONOFF, true)
			Lanternm.draw:addParam("move", "Mark ForceRange", SCRIPT_PARAM_ONOFF, true)
			Lanternm.draw:addParam("line", "Line to Lantern", SCRIPT_PARAM_ONOFF, true)
	PrintChat("<font color='#03dafb'> >> Lantern Clicker by Bilbao loaded. </font>")	
	Lanternm.okdmenu.UseLantern=false
	Lanternm.onoffmenu.lanoffon =false
end


function Lantern()
if not lant or not lant.valid or not (myHero:GetDistance(lant) < Lanternm.fcR.fcrange and lant.valid and lant) then return end
	p = CLoLPacket(0x3A)
	p:EncodeF(myHero.networkID)
	p:EncodeF(lant.networkID)
	p.dwArg1 = 1
	p.dwArg2 = 0
	SendPacket(p)
end


function OnCreateObj(obj)
	if obj and obj.name == "ThreshLantern" then
		lant = obj
	end
end


function OnDraw()
	if lant and lant.valid then
		if Lanternm.draw.lantern then DrawCircle(lant.x, lant.y, lant.z, 315, ARGB(100, 250, 0, 250)) end
		if Lanternm.draw.move then DrawCircle(lant.x, lant.y, lant.z, Lanternm.fcR.fcrange, ARGB(253,0, 253, 0)) end
		if Lanternm.draw.line then DrawLine3D(myHero.x, myHero.y, myHero.z, lant.x, lant.y, lant.z, 3, ARGB(100, 250, 0, 250)) end
	end
end


function OnTick()
	if (Lanternm.okdmenu.UseLantern and myHero.health <= (myHero.maxHealth*(Lanternm.okdmenu.okdhealth/ 100))) or (Lanternm.onoffmenu.lanoffon and myHero.maxHealth*(Lanternm.onoffmenu.hconoff/ 100)) then
		Lantern()
	end
end
