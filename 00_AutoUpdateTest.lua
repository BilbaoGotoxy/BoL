local version = "0.5"
--https://raw.githubusercontent.com/G0t0xy/BoL/master/00_AutoUpdateTest.lua


local AUTOUPDATE = true
local UPDATE_NAME = "00_AutoUpdateTest"
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/G0t0xy/BoL/master/00_AutoUpdateTest.lua".."?rand="..math.random(1,10000)
local UPDATE_FILE_PATH = SCRIPT_PATH..GetCurrentEnv().FILE_NAME
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH

function AutoupdaterMsg(msg) print("<font color=\"#6699ff\"><b>"..UPDATE_NAME..":</b></font> <font color=\"#FFFFFF\">"..msg..".</font>") end
	if AUTOUPDATE then
		local ServerData = GetWebResult(UPDATE_HOST, UPDATE_PATH, "", 5)
		if ServerData then
			local ServerVersion = string.match(ServerData, "local version = \"%d+.%d+\"")
			ServerVersion = string.match(ServerVersion and ServerVersion or "", "%d+.%d+")
			if ServerVersion then
				ServerVersion = tonumber(ServerVersion)
				if tonumber(version) < ServerVersion then
					AutoupdaterMsg("New version available "..ServerVersion)
					AutoupdaterMsg("Updating, please don't press F9")
					DownloadFile(UPDATE_URL, UPDATE_FILE_PATH, function () AutoupdaterMsg("Successfully updated. ("..version.." => "..ServerVersion.."), press F9 twice to load the updated version.") end)	
				else
					AutoupdaterMsg("You have got the latest version ("..ServerVersion..")")
				end
			end
		else
			AutoupdaterMsg("Error downloading version info")
		end
	end
