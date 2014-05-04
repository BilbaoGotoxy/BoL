local QRange, QReady = 650, false --we initiate the 2 variables QRange and QReady


function OnLoad() -- Once called at Scriptstart

	Config = scriptConfig("Simple Combo", "config") --create the menu
	
	Config:addParam("combo", "Combo", SCRIPT_PARAM_ONKEYDOWN, false, 32) --add to the created menu this options below
	Config:addParam("drawqrange", "Draw Q range", SCRIPT_PARAM_ONOFF, true)
	Config:addParam("drawqtarget", "Mark Q Target", SCRIPT_PARAM_ONOFF, true)
	Config:addParam("drawqtargetline", "Line to Target", SCRIPT_PARAM_ONOFF, true)
	
	ts = TargetSelector(TARGET_LOW_HP_PRIORITY, QRange) -- Initiate the targetselector
	
	print("Test script loaded.") --print a text(only for us)
end


function OnTick()
if myHero.dead then return end --if we are dead we do not continue, cuz we can do nothin

	ts:update() --we update the targetselector
	QReady = (myHero:CanUseSpell(_Q) == READY) --if Q is ready, the variable QReady get the value true, if not false
	
	
	if Config.combo then --iif your combo key is pressed
		Combo() --we execute this function
	end
	
	
end


function Combo() --here we are

	if ValidTarget(ts.target, QRange) and QReady then	--ValidTarget(unit ,range) check if the unit(in our case ts.target) is in range (QRange) and not dead, visible and so on and if then the varaible QReady(we updated it @ine 15) we go on
			CastSpell(_Q, ts.target) --and cast Q
	end
	
end


function OnDraw()

if myHero.dead then return end --if we are dead, we do nothin

	if QReady then --if Q is ready we continue
	
		if Config.drawqrange then --if we selected, we want to show the qrange in the menu, we also continue here
			DrawCircle(myHero.x, myHero.y, myHero.z, QRange, ARGB(255, 255, 0, 0))--and draw a circle, around our hero, with the QRange as radius with teh colour red. ARGB = Alpha(transparentcy), Red, Green, Blue . this values can be 0 till 255
		end
	
		if ValidTarget(ts.target, QRange) then --if we have a target AND it is in our range, we continue
		
			if Config.drawqtarget then --if we selected this option in the menu, we continue 
				DrawCircle(ts.target.x, ts.target.y, ts.target.z, 200, ARGB(255, 255, 0, 0))--and draw a RED circle with teh size 200 around the enemy. so we see who is our target
			end
			
			if Config.drawqtargetline then --if we selected this option, we also continue here
				DrawLine3D(myHero.x, myHero.y, myHero.z, ts.target.x, ts.target.y, ts.target.z, 3, ARGB(255, 255, 0, 0)) -- and draw a line from our hero to the target with the size 3. (higher size = bigger line). this line is also red
			end
			
		end
	end	
end
