local savedspotsONE = {}
local savedONE = 0

local savedspotsTWO = {}
local savedTWO = 0

local savedspotsTR = {}
local savedTR = 0




local SavedThisPress = false
local SaveData, MyMousePosX, MyMousePosY, MyMousePosZ = nil, nil, nil, nil

function OnLoad()
	SaveSpotConfig = scriptConfig ("SaveSpot", "SSC")	
	SaveSpotConfig:addParam("ss1", "SpotOrder 1", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("1"))
	SaveSpotConfig:addParam("ss2", "SpotOrder 2", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("2"))
	SaveSpotConfig:addParam("ss3", "SpotOrder 3", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("3"))
	print("SaveThePress loaded.")
end

function OnTick()
if not SavedThisPress then
	if SaveSpotConfig.ss1 then
		MyMousePosX = mousePos.x
		MyMousePosY = mousePos.y
		MyMousePosZ = mousePos.z
		SaveData = "{ x = "..MyMousePosX..", y = "..MyMousePosY..", z = "..MyMousePosZ.."},"
		save_data1(SaveData)
		print("SS1 -> Saved: "..SaveData)
		savedONE = savedONE + 1
		savedspotsONE[savedONE] = {x = MyMousePosX, y = MyMousePosY, z = MyMousePosZ }
		SavedThisPress = true
	end
	if SaveSpotConfig.ss2 then
		MyMousePosX = mousePos.x
		MyMousePosY = mousePos.y
		MyMousePosZ = mousePos.z
		SaveData = "{ x = "..MyMousePosX..", y = "..MyMousePosY..", z = "..MyMousePosZ.."},"
		save_data2(SaveData)
		print("SS2 -> Saved: "..SaveData)
		savedTWO = savedTWO + 1
		savedspotsTWO[savedTWO] = {x = MyMousePosX, y = MyMousePosY, z = MyMousePosZ }
		SavedThisPress = true
	end
		if SaveSpotConfig.ss3 then
		MyMousePosX = mousePos.x
		MyMousePosY = mousePos.y
		MyMousePosZ = mousePos.z
		SaveData = "{ x = "..MyMousePosX..", y = "..MyMousePosY..", z = "..MyMousePosZ.."},"
		save_data3(SaveData)
		print("SS3 -> Saved: "..SaveData)
		savedTR = savedTR + 1
		savedspotsTR[savedTR] = {x = MyMousePosX, y = MyMousePosY, z = MyMousePosZ }
		SavedThisPress = true
	end	
end

if not SaveSpotConfig.ss1 and not SaveSpotConfig.ss2 and not SaveSpotConfig.ss3 and SavedThisPress then
	SavedThisPress = false
	print("reset")
end
end

function OnDraw()

for i, spot in ipairs(savedspotsONE) do
	DrawCircle(spot.x, spot.y, spot.z, 150, ARGB(255, 250, 27, 27))
end

for i, spot in ipairs(savedspotsTWO) do
	DrawCircle(spot.x, spot.y, spot.z, 150, ARGB(255, 27, 250, 27))
end

for i, spot in ipairs(savedspotsTR) do
	DrawCircle(spot.x, spot.y, spot.z, 150, ARGB(255, 27, 27, 250))
end

end

function save_data1(text)	
		local file = io.open(SCRIPT_PATH.."SaveSpots1.txt", "a")
	file:write(text)
	file:write("\n")
	file:flush()
	file:close()
end
function save_data2(text)	
		local file = io.open(SCRIPT_PATH.."SaveSpots2.txt", "a")
	file:write(text)
	file:write("\n")
	file:flush()
	file:close()
end
function save_data3(text)	
		local file = io.open(SCRIPT_PATH.."SaveSpots3.txt", "a")
	file:write(text)
	file:write("\n")
	file:flush()
	file:close()
end
