local sprite, mario = nil, nil
local drawtxt = " "
local target = nil
local blinc = {tick = 0, value=255, status=true}

function OnTick()
target = nil
target = GetTarget()
drawtxt = "test"
_blink()
end

function OnDraw()
if mario then
		mario:SetScale(0.4,0.4)
		local cpos = GetCursorPos()
		local hpos =  WorldToScreen(D3DXVECTOR3(myHero.x,myHero.y, myHero.z))
		--pos = WorldToScreen(D3DXVECTOR3(myHero.x - (myVec.x*Config.distance), myVec.y*Config.distance, myHero.z - (myVec.z*Config.distance)))
	   if target==nil then
		mario:Draw(hpos.x-30, hpos.y-105, blinc.value)
		else
		local tpos =  WorldToScreen(D3DXVECTOR3(target.x,target.y, target.z))
		mario:Draw(tpos.x-30, tpos.y-105, blinc.value)
		end
    end
	DrawText3D(tostring(drawtxt), myHero.x, myHero.y, myHero.z, 25, RGB(222, 245, 15), true)			
end

function OnLoad()
blinc.tick = GetTickCount()
mario = GetWebSprite("http://s1.directupload.net/images/140304/id9pi3v6.png")
PrintChat("Sprite test loaded")
end
--resize to ChampionHeadSize
--enemy.spell1:SetScale((Config.size+(enemy.size/25)), (Config.size+(enemy.size/25)))
function _blink()
if GetTickCount() > blinc.tick+25 then
	if blinc.value==255 then
		blinc.status=false	
	end
	if blinc.value==0 then
		blinc.status=true
	end

	if blinc.status then
		blinc.value = blinc.value+51
	else
		blinc.value = blinc.value-51
	end
	blinc.tick = GetTickCount()
end
end








