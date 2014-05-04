if myHero.charName == "Thresh" then return end
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
	PrintChat("<font color='#03dafb'> >> Lantern Clicker loaded. </font>")	
	 Lanternm.okdmenu.UseLantern=false
	Lanternm.onoffmenu.lanoffon =false
end


function Lantern(id)
	p = CLoLPacket(0x39)
	p:EncodeF(myHero.networkID)
	p:EncodeF(id)
	p.dwArg1 = 1
	p.dwArg2 = 0
	SendPacket(p)
end


function OnCreateObj(obj)
	if obj and obj.name == "ThreshLantern" then
		lant = obj
	end
end


function _clicklantern()
	if lant and lant.valid and _inRangeToRun() then
		Lantern(lant.networkID)
	end
end

function OnDraw()
	if lant and lant.valid then
		DrawCircle(lant.x, lant.y, lant.z, 315, ARGB(100, 250, 0, 250))
	end
	if lant and lant.valid then
		DrawCircle(lant.x, lant.y, lant.z, Lanternm.fcR.fcrange, ARGB(253,0, 253, 0))
	end
end


function _inRangeToRun()
	if  myHero:GetDistance(lant) < Lanternm.fcR.fcrange and lant.valid and lant then
		return true
	else
		return false
	end
end


function _iamlow_OKD()
	if myHero.health <= (myHero.maxHealth*(Lanternm.okdmenu.okdhealth/ 100)) then
		return true
	else
		return false
	end
end


function _iamlow_ONOFF()
	if myHero.health <= (myHero.maxHealth*(Lanternm.onoffmenu.hconoff/ 100)) then
		return true
	else
		return false
	end
end


function OnTick()
if GetInGameTimer() < 120 then return end
	if Lanternm.okdmenu.UseLantern and _iamlow_OKD() then
		_clicklantern()
	end	
	if Lanternm.onoffmenu.lanoffon and _iamlow_ONOFF() then
		_clicklantern()
	end	
end
