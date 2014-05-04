	-------Orbwalk info-------
	local lastAttack, lastWindUpTime, lastAttackCD = 0, 0, 0
	local myTrueRange = 0
	local myTarget = nil
	-------/Orbwalk info-------
	
	
function OnLoad()
	myTrueRange = myHero.range + GetDistance(myHero.minBBox)
end

function OnTick()
	_OrbWalk()
end

function OnProcessSpell(object, spell)
	if object == myHero then
		if spell.name:lower():find("attack") then
			lastAttack = GetTickCount() - GetLatency()/2
			lastWindUpTime = spell.windUpTime*1000
			lastAttackCD = spell.animationTime*1000
		end 
	end
end

function _OrbWalk()
	myTarget = GetTarget()
	if myTarget ~=nil and GetDistance(myTarget ) <= myTrueRange then		
		if timeToShoot() then
			myHero:Attack(myTarget )
		elseif heroCanMove()  then
			moveToCursor()
		end
	else		
		moveToCursor() 
	end
end

function heroCanMove()
	return (GetTickCount() + GetLatency()/2 > lastAttack + lastWindUpTime + 20)
end 
 
function timeToShoot()
	return (GetTickCount() + GetLatency()/2 > lastAttack + lastAttackCD)
end 
 
function moveToCursor()
	if GetDistance(mousePos) > 1 then
		local moveToPos = myHero + (Vector(mousePos) - myHero):normalized()*300
		myHero:MoveTo(moveToPos.x, moveToPos.z)
	end 
end
