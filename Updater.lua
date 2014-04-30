local version = "0.09"


--https://github.com/G0t0xy/BoL/blob/master/Updater.lua

--Honda7
local autoupdateenabled = true
local UPDATE_NAME = "Updater"
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/G0t0xy/BoL/blob/master/Updater.lua".."?rand="..math.random(1,10000)
local UPDATE_FILE_PATH = SCRIPT_PATH..GetCurrentEnv().FILE_NAME
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH

function AutoupdaterMsg(msg) print("<font color=\"#6699ff\"><b>Sivir:</b></font> <font color=\"#FFFFFF\">"..msg..".</font>") end

    local ServerData = GetWebResult(UPDATE_HOST, UPDATE_PATH)
    if ServerData then
        local ServerVersion = string.match(ServerData, "local version = \"%d+.%d+\"")
        ServerVersion = string.match(ServerVersion and ServerVersion or "", "%d+.%d+")
        if ServerVersion then
            ServerVersion = tonumber(ServerVersion)
            if tonumber(version) < ServerVersion then
                AutoupdaterMsg("New version available"..ServerVersion)
                AutoupdaterMsg("Updating, please don't press F9")
                DelayAction(function() DownloadFile(UPDATE_URL, UPDATE_FILE_PATH, function () AutoupdaterMsg("Successfully updated. ("..version.." => "..ServerVersion.."), press F9 twice to load the updated version.") end) end, 3)
            else
                AutoupdaterMsg("You have got the latest version ("..ServerVersion..")")
            end
        end
    else
        AutoupdaterMsg("Error downloading version info")
    end
    
    --[[
    random
    random
    random
    ]]--
