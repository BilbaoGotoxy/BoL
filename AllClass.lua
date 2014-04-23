LIB_PATH = package.path:gsub("?.lua", "")
SCRIPT_PATH = LIB_PATH:gsub("Common\\", "")
SPRITE_PATH = SCRIPT_PATH:gsub("Scripts", "Sprites"):gsub("/", "\\")
BOL_PATH = SCRIPT_PATH:gsub("Scripts\\", "")
GAME_PATH = package.cpath:sub(1, math.max(package.cpath:find("?.") - 1, 1))
VIP_USER = CLoLPacket and true or false

--Faster for comparison of distances, returns the distance^2
function GetDistanceSqr(p1, p2)
    assert(p1, "GetDistance: invalid argument: cannot calculate distance to "..type(p1))
    p2 = p2 or player
    return (p1.x - p2.x) ^ 2 + ((p1.z or p1.y) - (p2.z or p2.y)) ^ 2
end

function GetDistance(p1, p2)
    return math.sqrt(GetDistanceSqr(p1, p2))
end

--p1 should be the BBoxed object
function GetDistanceBBox(p1, p2)
    if p2 == nil then p2 = player end
    assert(p1 and p1.minBBox and p2 and p2.minBBox, "GetDistanceBBox: wrong argument types (<object><object> expected for p1, p2)")
    local bbox1 = GetDistance(p1, p1.minBBox)
    return GetDistance(p1, p2) - (bbox1)
end

function ctype(t)
    local _type = type(t)
    if _type == "userdata" then
        local metatable = getmetatable(t)
        if not metatable or not metatable.__index then
            t, _type = "userdata", "string"
        end
    end
    if _type == "userdata" or _type == "table" then
        local _getType = t.type or t.Type or t.__type
        _type = type(_getType)=="function" and _getType(t) or type(_getType)=="string" and _getType or _type
    end
    return _type
end

function ctostring(t)
    local _type = type(t)
    if _type == "userdata" then
        local metatable = getmetatable(t)
        if not metatable or not metatable.__index then
            t, _type = "userdata", "string"
        end
    end
    if _type == "userdata" or _type == "table" then
        local _tostring = t.tostring or t.toString or t.__tostring
        if type(_tostring)=="function" then
            local tstring = _tostring(t)
            t = _tostring(t)
        else
            local _ctype = ctype(t) or "Unknown"
            if _type == "table" then
                t = tostring(t):gsub(_type,_ctype) or tostring(t)
            else
                t = _ctype
            end
        end
    end
    return tostring(t)
end

function print(...)
    local t, len = {}, select("#",...)
    for i=1, len do
        local v = select(i,...)
        local _type = type(v)
        if _type == "string" then t[i] = v
        elseif _type == "number" then t[i] = tostring(v)
        elseif _type == "table" then t[i] = table.serialize(v)
        elseif _type == "boolean" then t[i] = v and "true" or "false"
        elseif _type == "userdata" then t[i] = ctostring(v)
        else t[i] = _type
        end
    end
    if len>0 then PrintChat(table.concat(t)) end
end

function DumpPacketData(p,s,e)
    s, e = math.max(1,s or 1), math.min(p.size-1,e and e-1 or p.size-1)
    local pos, data = p.pos, ""
    p.pos = s
    for i=p.pos, e do
        data = data .. string.format("%02X ",p:Decode1())
    end
    p.pos = pos
    return data
end

function DumpPacket(p)
    local packet = {}
    packet.time = GetInGameTimer()
    packet.dwArg1 = p.dwArg1
    packet.dwArg2 = p.dwArg2
    packet.header = string.format("%02X",p.header)
    packet.data = DumpPacketData(p)
    return packet
end

function ValidTarget(object, distance, enemyTeam)
    local enemyTeam = (enemyTeam ~= false)
    return object ~= nil and object.valid and (object.team ~= player.team) == enemyTeam and object.visible and not object.dead and object.bTargetable and (enemyTeam == false or object.bInvulnerable == 0) and (distance == nil or GetDistanceSqr(object) <= distance * distance)
end

function ValidBBoxTarget(object, distance, enemyTeam)
    local enemyTeam = (enemyTeam ~= false)
    return object ~= nil and object.valid and (object.team ~= player.team) == enemyTeam and object.visible and not object.dead and object.bTargetable and (enemyTeam == false or object.bInvulnerable == 0) and (distance == nil or GetDistanceBBox(object) <= distance)
end

function ValidTargetNear(object, distance, target)
    return object ~= nil and object.valid and object.team == target.team and object.networkID ~= target.networkID and object.visible and not object.dead and object.bTargetable and GetDistanceSqr(target, object) <= distance * distance
end

function GetDistanceFromMouse(object)
    if object ~= nil and VectorType(object) then return GetDistance(object, mousePos) end
    return math.huge
end

local _enemyHeroes
function GetEnemyHeroes()
    if _enemyHeroes then return _enemyHeroes end
    _enemyHeroes = {}
    for i = 1, heroManager.iCount do
        local hero = heroManager:GetHero(i)
        if hero.team ~= player.team then
            table.insert(_enemyHeroes, hero)
        end
    end
    return setmetatable(_enemyHeroes,{
        __newindex = function(self, key, value)
            error("Adding to EnemyHeroes is not granted. Use table.copy.")
        end,
    })
end

local _allyHeroes
function GetAllyHeroes()
    if _allyHeroes then return _allyHeroes end
    _allyHeroes = {}
    for i = 1, heroManager.iCount do
        local hero = heroManager:GetHero(i)
        if hero.team == player.team and hero.networkID ~= player.networkID then
            table.insert(_allyHeroes, hero)
        end
    end
    return setmetatable(_allyHeroes,{
        __newindex = function(self, key, value)
            error("Adding to AllyHeroes is not granted. Use table.copy.")
        end,
    })
end

--[[
    Returns a number that is needed for Animation Drawing Functions.
    @param number A time in seconds in which the output goes from 0 to 1
    @param number An offset in seconds which will be added to the time to calculate the output
    @returns number A number that goes from 0 to 1 in a time interval you've set (0 .. 0,1 ... 0,9 .. 1,0 .. 0 .. 0,1 ...)
]]
function GetDrawClock(time, offset)
    time, offset = time or 1, offset or 0
    return (os.clock() + offset) % time / time
end

function table.clear(t)
    for i, v in pairs(t) do
        t[i] = nil
    end
end

function table.copy(from, deepCopy)
    if type(from) == "table" then
        local to = {}
        for k, v in pairs(from) do
            if deepCopy and type(v) == "table" then to[k] = table.copy(v)
            else to[k] = v
            end
        end
        return to
    end
end

function table.contains(t, what, member) --member is optional
    assert(type(t) == "table", "table.contains: wrong argument types (<table> expected for t)")
    for i, v in pairs(t) do
        if member and v[member] == what or v == what then return i, v end
    end
end

function table.serialize(t, tab, functions)
    assert(type(t) == "table", "table.serialize: Wrong Argument, table expected")
    local s, len = {"{\n"}, 1
    for i, v in pairs(t) do
        local iType, vType = type(i), type(v)
        if vType~="userdata" and (functions or vType~="function") then
            if tab then 
                s[len+1] = tab 
                len = len + 1
            end
            s[len+1] = "\t"
            if iType == "number" then
                s[len+2], s[len+3], s[len+4] = "[", i, "]"
            elseif iType == "string" then
                s[len+2], s[len+3], s[len+4] = '["', i, '"]'
            end
            s[len+5] = " = "
            if vType == "number" then 
                s[len+6], s[len+7], len = v, ",\n", len + 7
            elseif vType == "string" then 
                s[len+6], s[len+7], s[len+8], len = '"', v:unescape(), '",\n', len + 8
            elseif vType == "table" then 
                s[len+6], s[len+7], len = table.serialize(v, (tab or "") .. "\t", functions), ",\n", len + 7
            elseif vType == "boolean" then 
                s[len+6], s[len+7], len = tostring(v), ",\n", len + 7
            elseif vType == "function" and functions then
                local dump = string.dump(v)
                s[len+6], s[len+7], s[len+8], len = "load(Base64Decode(\"", Base64Encode(dump, #dump), "\")),\n", len + 8
            end
        end
    end
    if tab then 
        s[len+1] = tab
        len = len + 1
    end
    s[len+1] = "}"
    return table.concat(s)
end

function table.merge(base, t, deepMerge)
    for i, v in pairs(t) do
        if deepMerge and type(v) == "table" and type(base[i]) == "table" then
            base[i] = table.merge(base[i], v)
        else base[i] = v
        end
    end
    return base
end

--from http://lua-users.org/wiki/SplitJoin
function string.split(str, delim, maxNb)
    -- Eliminate bad cases...
    if not delim or delim == "" or string.find(str, delim) == nil then
        return { str }
    end
    maxNb = (maxNb and maxNb >= 1) and maxNb or 0
    local result = {}
    local pat = "(.-)" .. delim .. "()"
    local nb = 0
    local lastPos
    for part, pos in string.gmatch(str, pat) do
        nb = nb + 1
        if nb == maxNb then
            result[nb] = lastPos and string.sub(str, lastPos, #str) or str
            break
        end
        result[nb] = part
        lastPos = pos
    end
    -- Handle the last field
    if nb ~= maxNb then
        result[nb + 1] = string.sub(str, lastPos)
    end
    return result
end

function string.join(arg, del)
    return table.concat(arg, del)
end

function string.trim(s)
    return s:match'^%s*(.*%S)' or ''
end

function string.unescape(s)
    return s:gsub(".",{
        ["\a"] = [[\a]],
        ["\b"] = [[\b]],
        ["\f"] = [[\f]],
        ["\n"] = [[\n]],
        ["\r"] = [[\r]],
        ["\t"] = [[\t]],
        ["\v"] = [[\v]],
        ["\\"] = [[\\]],
        ['"'] = [[\"]],
        ["'"] = [[\']],
        ["["] = "\\[",
        ["]"] = "\\]",
      })
end

function math.isNaN(num)
    return num ~= num
end

-- Round half away from zero
function math.round(num, idp)
    assert(type(num) == "number", "math.round: wrong argument types (<number> expected for num)")
    assert(type(idp) == "number" or idp == nil, "math.round: wrong argument types (<integer> expected for idp)")
    local mult = 10 ^ (idp or 0)
    if num >= 0 then return math.floor(num * mult + 0.5) / mult
    else return math.ceil(num * mult - 0.5) / mult
    end
end

function math.close(a, b, eps)
    assert(type(a) == "number" and type(b) == "number", "math.close: wrong argument types (at least 2 <number> expected)")
    eps = eps or 1e-9
    return math.abs(a - b) <= eps
end

function math.limit(val, min, max)
    assert(type(val) == "number" and type(min) == "number" and type(max) == "number", "math.limit: wrong argument types (3 <number> expected)")
    return math.min(max, math.max(min, val))
end

local fps, avgFps, frameCount, fFrame, lastFrame, updateFPS = 0, 0, 0, -math.huge, -math.huge, nil
local function startFPSCounter()
    if not updateFPS then
        function updateFPS()
            fps = 1 / (os.clock() - lastFrame)
            lastFrame, frameCount = os.clock(), frameCount + 1
            if os.clock() < 0.5 + fFrame then return end
            avgFps = math.floor(frameCount / (os.clock() - fFrame))
            fFrame, frameCount = os.clock(), 0
        end

        AddDrawCallback(updateFPS)
    end
end

function GetExactFPS()
    startFPSCounter()
    return fps
end

function GetFPS()
    startFPSCounter()
    return avgFps
end

--[[
    function GetSave
        used to save data between matches. It can save all data except userdata, even functions!
        what you save in GetSave(name) in one match, you can access next time with the same function call
       Example:

       GetSave("mySave").print = print
       --> nextGame (Or reload)
       GetSave("mySave").print("Hello")
]]
local _saves, _initSave = {}, true
function GetSave(name)
    local save
    if not _saves[name] then
        if FileExist(LIB_PATH .. "Saves\\" .. name .. ".save") then
            local f = loadfile(LIB_PATH .. "Saves\\" .. name .. ".save")
            if type(f) == "function" then
                _saves[name] = f()
            end
        else
            _saves[name] = {}
            MakeSurePathExists(LIB_PATH .. "Saves\\" .. name .. ".save")
        end
    end
    save = _saves[name]
    if not save then
        print("SaveFile: " .. name .. " is broken. Reset.")
        _saves[name] = {}
        save = _saves[name]
    end
    function save:Save()
        local _save, _reload, _clear, _isempty, _remove = self.Save, self.Reload, self.Clear, self.IsEmpty, self.Remove
        self.Save, self.Reload, self.Clear, self.IsEmpty, self.Remove = nil, nil, nil, nil, nil
        WriteFile(table.concat({"return ",table.serialize(self, nil, true)}), LIB_PATH .. "Saves\\" .. name .. ".save")
        self.Save, self.Reload, self.Clear, self.IsEmpty, self.Remove = _save, _reload, _clear, _isempty, _remove
    end

    function save:Reload()
        _saves[name] = loadfile(LIB_PATH .. "Saves\\" .. name .. ".save")()
        save = _saves[name]
    end

    function save:Clear()
        for i, v in pairs(self) do
            if type(v) ~= "function" or (i ~= "Save" and i ~= "Reload" and i ~= "Clear" and i ~= "IsEmpty" and i ~= "Remove") then
                self[i] = nil
            end
        end
    end

    function save:IsEmpty()
        for i, v in pairs(self) do
            if type(v) ~= "function" or (i ~= "Save" and i ~= "Reload" and i ~= "Clear" and i ~= "IsEmpty" and i ~= "Remove") then
                return false
            end
        end
        return true
    end

    function save:Remove()
        for i, v in pairs(_saves) do
            if v == self then
                _saves[i] = nil
            end
            if FileExist(LIB_PATH .. "Saves\\" .. name .. ".save") then
                DeleteFile(LIB_PATH .. "Saves\\" .. name .. ".save")
            end
        end
    end

    if _initSave then
        _initSave = nil
        local function saveAll()
            for i, v in pairs(_saves) do
                if v and v.Save then
                    if v:IsEmpty() then
                        v:Remove()
                    else 
                        v:Save()
                    end
                end
            end
        end

        AddBugsplatCallback(saveAll)
        AddUnloadCallback(saveAll)
        AddExitCallback(saveAll)
    end
    return save
end

--[[
    Executes a Powershell script
    e.g: successful, output = os.executePowerShell("Write-Host \"PowerShell Executed\"")
]]
function os.executePowerShell(script, argument)
    local cmd = ""
    script:gsub(".", function(c) cmd = cmd .. c .. "\0" end)
    return PopenHidden("powershell " .. (argument or "") .. " -encoded \"" .. Base64Encode(cmd, #cmd) .. "\"")
end

function os.executePowerShellAsync(script, argument)
    local cmd = ""
    script:gsub(".", function(c) cmd = cmd .. c .. "\0" end)
    RunAsyncCmdCommand("powershell -windowstyle hidden " .. (argument or "") .. " -encoded \"" .. Base64Encode(cmd, #cmd) .. "\"")
end

--[[
    Brings the League of Legends Window in Foreground. Needed after os.execute or other function that minimize the client.
]]
function SetForeground()
    --Written By gReY
    local script = [[
Add-Type(@"
    using System;
    using System.Runtime.InteropServices;
    public class User32 {
        [DllImport("user32.dll")]
        [return: MarshalAs(UnmanagedType.Bool)]
        public static extern bool SetForegroundWindow(IntPtr hWnd);
        [DllImport("user32.dll")]
        [return: MarshalAs(UnmanagedType.Bool)]
        public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);}
"@)
$h = (ps "League of Legends").MainWindowHandle;
[User32]::ShowWindowAsync($h,9);
[User32]::SetForegroundWindow($h);]]
    os.executePowerShellAsync(script)
end

function PlaySoundPS(path, duration)
    os.executePowerShellAsync('(new-object Media.SoundPlayer "' .. path .. '").play();\nfor ($i=1; $i -le ' .. (duration or 1000) .. '; $i++) {Start-Sleep -seconds 1}')
end

function PlayMediaPS(path, duration)
    local script = [[$si = new-object System.Diagnostics.ProcessStartInfo;
$si.fileName = "]] .. path .. [[" ;
$si.windowStyle = [System.Diagnostics.ProcessWindowStyle]::Hidden;
$process = New-Object System.Diagnostics.Process;
$process.startInfo=$si;
$process.start();
]] .. (duration and ([[start-sleep -seconds ]] .. duration .. [[;
$process.CloseMainWindow();]]) or "")
    return os.executePowerShellAsync(script)
end

--Example: CreateDirectory("C:\\TEST") Returns true or false, only works if the folder doesn't already exist
function CreateDirectory(path)
    assert(type(path) == "string", "CreateDirectory: wrong argument types (<string> expected for path)")
    local worked = RunCmdCommand('mkdir "' .. string.gsub(path, [[/]], [[\]]) .. '"') == 0
    if not worked then print("Could not create the Folder " .. path) end
    return worked
end

--Example: DirectoryExist("C:\\Users")
function DirectoryExist(path)
    assert(type(path) == "string", "DirectoryExist: wrong argument types (<string> expected for path)")
    --[[local file, err = io.open(path.."\\*.*","r")
    if file then
        io.close(file)
    elseif string.sub(err,#err-24,#err)=="No such file or directory" then
        return false
    end
    return true ]]
    return RunCmdCommand("cd " .. string.gsub(path, [[/]], [[\]])) == 0
end

-- Example: foldernames, filenames = ScanDirectory([[C:\]])
function ScanDirectory(path)
    assert(type(path) == "string" and #path > 0, "ScanDirectory: wrong argument types (<string> expected for path)")
    path = path and path:gsub([[/]], [[\]]) or BOL_PATH:gsub([[/]], [[\]])
    local dirCmd, fileCmd = 'dir /b /a:d-s "' .. path .. '"', 'dir /b /a:-d-s "' .. path .. '"'
    local dirs, files = {}, {}
    if RunCmdCommand(dirCmd) == 0 then dirs = PopenHidden(dirCmd):trim():split("\n") end
    if RunCmdCommand(fileCmd) == 0 then files = PopenHidden(fileCmd):trim():split("\n") end
    return dirs, files
end

-- Example: exist = ProcessExist("League of Legends")
function ProcessExist(name)
    assert(type(name) == "string" and #name > 0, "ProcessExist: wrong argument types (<string> expected for path)")
    name = name:gsub(".exe", "", 1):trim()
    return RunCmdCommand('tasklist /FI "IMAGENAME eq ' .. name .. '.exe" 2>NUL | find /I /N "' .. name .. '.exe">NUL') == 0
end

--Return text of a file (you can also insert the filename)
function ReadFile(path)
    assert(type(path) == "string", "ReadFile: wrong argument types (<string> expected for path)")
    local file = io.open(path, "r")
    if not file then
        file = io.open(SCRIPT_PATH .. path, "r")
        if not file then
            file = io.open(LIB_PATH .. path, "r")
            if not file then return end
        end
    end
    local text = file:read("*all")
    file:close()
    return text
end

--Return true if could write to file; mode optional
function WriteFile(text, path, mode)
    assert(type(text) == "string" and type(path) == "string" and (not mode or type(mode) == "string"), "WriteFile: wrong argument types (<string> expected for text, path and mode)")
    local file = io.open(path, mode or "w+")
    if not file then
        if not MakeSurePathExists(path) then return false end
        file = io.open(path, mode or "w+")
        if not file then
            return false
        end
    end
    file:write(text)
    file:close()
    return true
end

--Return true if file exists
function FileExist(path)
    assert(type(path) == "string", "FileExist: wrong argument types (<string> expected for path)")
    local file = io.open(path, "r")
    if file then file:close() return true else return false end
end

--takes a path and creates all necessary folders.
function MakeSurePathExists(path)
    path = path:gsub("/", "\\"):reverse()
    path = path:sub(path:find("\\"), #path)
    if not DirectoryExist(path:reverse()) then
        path = path:sub(2, #path):split("\\", 2)
        if #path == 2 then
            if not MakeSurePathExists(path[2]:reverse() .. "\\") or not CreateDirectory(("\\" .. path[1] .. "\\" .. path[2]):reverse()) then
                return false
            end
        else
            return DirectoryExist(path[1]:reverse() .. "\\")
        end
    end
    return true
end

function DeleteFile(path)
    assert(type(path) == "string", "DeleteFile: wrong argument types (<string> expected for path)")
    return os.remove(path) == true
end

function GetFileSize(path)
    assert(type(path) == "string", "GetFileSize: wrong argument types (<string> expected for path)")
    local file = io.open(path, "r")
    if not file then
        file = io.open(SCRIPT_PATH .. path, "r")
        if not file then
            file = io.open(LIB_PATH .. path, "r")
            if not file then return end
        end
    end
    local size = file:seek("end")
    file:close()
    return size
end

function ReadIni(path)
    local raw = ReadFile(path)
    if not raw then return {} end
    local t, section = {}, nil
    for _, s in ipairs(raw:split("\n")) do
        local v = s:trim()
        local commentBegin = v:find(";") or v:find("#")
        if commentBegin then v = v:sub(1, commentBegin) end
        if v:sub(1, 3) == "tr " then v = v:sub(4, #v) end --ignore
        if v:sub(1, 1) == "[" and v:sub(#v, #v) == "]" then --Section
            section = v:sub(2, #v - 1):trim()
            t[section] = {}
        elseif section and v:find("=") then --Key = Value
            local kv = v:split("=", 2)
            if #kv == 2 then
                local key, value = kv[1]:trim(), kv[2]:trim()
                if value:lower() == "true" then value = true
                elseif value:lower() == "false" then value = false
                elseif tonumber(value) then value = tonumber(value)
                elseif (value:sub(1, 1) == "\"" and value:sub(#value, #value) == "\"") or
                        (value:sub(1, 1) == "'" and value:sub(#value, #value) == "'") then
                    value = value:sub(2, #value - 1):trim()
                end
                if key ~= "" and value ~= "" then
                    if section then t[section][key] = value else t[key] = value end
                end
            end
        end
    end
    return t
end

--[[
    Function 
        GetItem(what)
            returns an item.
            You can use the English name, the id (recommended) or the Itemslot to get the Item
            Example : GetItem(3070), GetItem(ITEM_1), GetItem("Healing Potion")
        GetItemDB([callback])
            returns a list with all the Items ingame
            You can also insert a callback, since it might happen that it has no Items at all, 
            the first time you start it, since it has to extract all necessary data
            
        Items:
            They have the following Properties (and more) 
            GetName([localization]),GetDescription([localization]),Buy(),Sell(),GetCount(),GetInventorySlot(),GetSprite(),Cast([x,z])
            id, icon, gold (total, sell, base), from, into, stats, tags ...
            For a more detailed content, look in the items.json in the RAF Archives (Data\Items\items.json), which will be also extracted to BoL\Sprites, if you use this function the first time            
        
        You can get your current Localization with the function GetLocalization()
        
        Example:
        function OnLoad()
            for i, item in pairs(GetItemDB) do
                print(item:GetName(GetLocalization()),"\n")
                for i, ingredient in pairs(item.from or {}) do
                    print("\t-> ",ingredient:GetName(GetLocalization()),"\n")
                end
            end
        end
]]

local _items, _itemsLoaded, _onItemsLoaded, _onRafLoaded = {}, false, {}, nil
function GetItem(i)
    local item
    if type(i) == "number" then
        if i >= ITEM_1 and i <= ITEM_7 then
            local cItem = player:getItem(i)
            item = GetItem(cItem and cItem.id)
        else
            item = GetItemDB()[i]
        end
    elseif type(i) == "string" then
        for _, v in pairs(GetItemDB()) do
            if v:GetName():trim():lower() == i:trim():lower() then item = v break end
        end
    end
    return item, _itemsLoaded
end

function GetItemDB(OnLoaded)
    local function ParseItems(RAF)
        if _itemsLoaded and not RAF then return end
        _itemsLoaded = true
        local itemsJSON = RAF and RAF:find("DATA\\Items\\items.json").content or ReadFile(SPRITE_PATH .. "Items\\items.json")
        assert(itemsJSON, "GetItemDB: items.json not found. Items couldn't get parsed. "..(RAF and "(Direct)" or "(Cached)"))
        itemsJSON = JSON:decode(itemsJSON)
        if not RAF and not itemsJSON then
            print("GetItemDB: items.json not decoded. Items couldn't get parsed.")
            print(DeleteFile(SPRITE_PATH:gsub("/", "\\") .. "Items\\items.json") and "Corrupted File Items\\items.json removed." or "Please remove the file 'items.json' in the folder 'Sprites\\Items\\'")
            return
        else
            assert(itemsJSON, "GetItemDB: items.json not decoded. Items couldn't get parsed. "..(RAF and "(Direct)" or "(Cached)"))
        end    
        local basicItem = itemsJSON.basicitem
        for i, itemJSON in pairs(itemsJSON.items) do
            if not _items[tonumber(itemJSON.id)] then _items[tonumber(itemJSON.id)] = table.copy(basicItem) end
            local item = _items[tonumber(itemJSON.id)]
            for j, p in pairs(itemJSON) do
                if j == "id" then item[j] = tonumber(p)
                elseif j == "into" or j == "from" then
                    item[j] = {}
                    for k, id in pairs(itemJSON[j]) do
                        if not _items[tonumber(id)] then _items[tonumber(id)] = table.copy(basicItem) end
                        item[j][k] = _items[tonumber(id)]
                    end
                elseif j == "itemgroup" then
                    local index, content = table.contains(itemsJSON.itemgroups, p, "groupid")
                    item[j] = { [p] = content }
                elseif j == "icon" and RAF then
                    if not FileExist(SPRITE_PATH .. "Items\\" .. p) then
                        local file = RAF:find("DATA\\Items\\Icons2D\\" .. p)
                        if not file or not file.name or file.name == "" then file = RAF:find("DATA\\Items\\Icons2D\\" .. p:gsub(" ", "_")) end
                        if file and file.name and file.name ~= "" then file:extract(SPRITE_PATH .. "Items\\" .. p)
                        else OutputDebugString("Item Icon: " .. p .. " hasnt been found")
                        end
                    end
                    item[j] = p
                elseif j == "name" or j == "description" then
                else
                    item[j] = p
                end
            end
        end
        for i, v in pairs(_items) do
            function v:GetName(localization)
                localization = localization or "en_US"
                local name = self["name_" .. localization]
                if not name or name == "" then
                    self["name_" .. localization] = GetDictionaryString("game_item_displayname_" .. self.id, localization)
                    return self["name_" .. localization]
                else return name
                end
            end

            function v:GetDescription(localization)
                localization = localization or "en_US"
                local desc = self["desc_" .. localization]
                if not desc or desc == "" then
                    self["desc_" .. localization] = GetDictionaryString("game_item_description_" .. self.id, localization)
                    return self["desc_" .. localization]
                else return desc
                end
            end

            function v:Sell()
                local slot = self:GetInventorySlot()
                if slot then return SellItem(slot) end
            end

            function v:Buy()
                return BuyItem(self.id)
            end

            function v:GetCount(object)
                local count, ItemSlot = 0, { ITEM_1, ITEM_2, ITEM_3, ITEM_4, ITEM_5, ITEM_6, ITEM_7 }
                for i = 1, 7, 1 do
                    local item = (object or player):getItem(ItemSlot[i])
                    if item and item.id == self.id then
                        count = count + math.max(item.stacks or 1, 1)
                    end
                end
                return count
            end

            function v:GetInventorySlot(object)
                local ItemSlot = { ITEM_1, ITEM_2, ITEM_3, ITEM_4, ITEM_5, ITEM_6, ITEM_7 }
                for i = 1, 7, 1 do
                    local item = (object or player):getItem(ItemSlot[i])
                    if item and item.id == self.id then return ItemSlot[i] end
                end
            end

            function v:GetSprite()
                if not self.sprite then
                    self.sprite = self:CreateSprite()
                end
                return self.sprite
            end

            function v:CreateSprite()
                if self.icon and FileExist(SPRITE_PATH .. "Items\\" .. self.icon) then
                    return createSprite("Items\\" .. self.icon)
                end
            end

            function v:Cast(x, z)
                local slot = self:GetInventorySlot()
                if not slot then return end
                if x and z then CastSpell(slot, x, z)
                elseif x then CastSpell(slot, x)
                else CastSpell(slot)
                end
            end
        end
        for i, f in pairs(_onItemsLoaded) do
            if type(f)=="function" then f(_items) end
            _onItemsLoaded[i] = nil
        end
    end

    if not _onRafLoaded then
        function _onRafLoaded(RAF)
            RAF:find("DATA\\Items\\items.json"):extract(SPRITE_PATH .. "Items\\items.json")
            ParseItems(RAF)
        end

        GetRafFiles(_onRafLoaded)
    end
    if OnLoaded then
        if not _itemsLoaded then table.insert(_onItemsLoaded, OnLoaded)
        else OnLoaded(_items, _itemsLoaded) return _items, _itemsLoaded
        end
    end
    if not _itemsLoaded and FileExist(SPRITE_PATH .. "Items\\items.json") then
        ParseItems()
    end
    return _items, _itemsLoaded
end

--[[
    Function GetDictionaryString(t,localization)
        returns the string of the ingame Dictionary
    It might happen that the Dictionary isnt already extracted, 
    in this case, the second return value is false, and you have to try again later 
    (This means the Raf Archives haven't already loaded)
    
    You can get your current Localization with the function GetLocalization()
    
    Example: myTranslation = GetDictionaryString("data_dragon_category_rune","de_DE")
    The Dictionary Files can be found in the RAF Archives in e.g DATA\Menu\fontconfig_en_US.txt
]]

local _dictionaries = {}
function GetDictionaryString(key, localization)
    localization = localization or "en_US"
    local _result = ""
    local function UpdateLibrary(localization)
        local function _onRafLoadedDic(RAF)
            local file = RAF:find("DATA\\Menu\\fontconfig_" .. localization .. ".txt")
            if file and file.name and file.name ~= "" then
                file:extract(LIB_PATH:gsub("/", "\\") .. "Saves\\" .. localization .. ".dic")
                _dictionaries[localization] = ReadFile(LIB_PATH .. "Saves\\" .. localization .. ".dic")
            end
        end

        GetRafFiles(_onRafLoadedDic)
    end

    if not _dictionaries[localization] then
        local content = ""
        if FileExist(LIB_PATH .. "Saves\\" .. localization .. ".dic") then
            content = ReadFile(LIB_PATH .. "Saves\\" .. localization .. ".dic")
        end
        _dictionaries[localization] = content
        UpdateLibrary(localization)
    end
    local s = _dictionaries[localization]
    if s then
        local A, B = s:find('\ntr "' .. key .. '" = "', 1, true)
        local C, D = s:find('"\n', B, true)
        _result = B and C and s:sub(B + 1, C - 1)
    end
    return _result, (s and true or false)
end

--[[
    Returns the Raf-Archive Version
]]

local _rafVersion
function GetRafVersion()
    if _rafVersion then return _rafVersion end
    local maxVal = 0
    for i, v in pairs(ScanDirectory(GAME_PATH:sub(1, GAME_PATH:find("\\RADS")) .. "\\RADS\\projects\\lol_game_client\\filearchives\\")) do
        local val = 0
        for i, v in pairs(v:split("[.]")) do
            val = val + (tonumber(v) or 0) * 1000 ^ i
        end
        if val > maxVal then
            _rafVersion = v:trim()
            maxVal = val
        end
    end
    return _rafVersion
end

--[[
 Gets the Gamesettings (path: League of Legends\Config\game.cfg
 example: 
    local gameSettings = GetGameSettings()
    Width, Height = gameSettings.General.Width, gameSettings.General.Height 
]]
function GetGameSettings()
    local path = GAME_PATH:sub(1, GAME_PATH:find("\\RADS")) .. "Config\\game.cfg"
    return ReadIni(path)
end

--[[
    Gets the Localization of your Game. "en_EN", "de_DE" and so on
]]

local _localization
function GetLocalization()
    if not _localization then
        _localization = FileExist(GAME_PATH .. "DATA\\cfg\\defaults\\locale.cfg") and ReadIni(GAME_PATH .. "DATA\\cfg\\defaults\\locale.cfg").General.LanguageLocaleRegion or "en_EN"
    end
    return _localization
end

--[[
    Delays a function call
    example: DelayAction(myFunc, 5)
    Note: Due to limitations to BoL
]]
local delayedActions, delayedActionsExecuter = {}, nil
function DelayAction(func, delay, args) --delay in seconds
    if not delayedActionsExecuter then
        function delayedActionsExecuter()
            for t, funcs in pairs(delayedActions) do
                if t <= os.clock() then
                    for _, f in ipairs(funcs) do f.func(table.unpack(f.args or {})) end
                    delayedActions[t] = nil
                end
            end
        end

        AddTickCallback(delayedActionsExecuter)
    end
    local t = os.clock() + (delay or 0)
    if delayedActions[t] then table.insert(delayedActions[t], { func = func, args = args })
    else delayedActions[t] = { { func = func, args = args } }
    end
end

local _intervalFunction
function SetInterval(userFunction, timeout, count, params)
    if not _intervalFunction then
        function _intervalFunction(userFunction, startTime, timeout, count, params)
            if userFunction(table.unpack(params or {})) ~= false and (not count or count > 1) then
                DelayAction(_intervalFunction, (timeout - (os.clock() - startTime - timeout)), { userFunction, startTime + timeout, timeout, count and (count - 1), params })
            end
        end
    end
    DelayAction(_intervalFunction, timeout, { userFunction, os.clock(), timeout or 0, count, params })
end

local _DrawText, _PrintChat, _PrintFloatText, _DrawLine, _DrawArrow, _DrawCircle, _DrawRectangle, _DrawLines, _DrawLines2 = DrawText, PrintChat, PrintFloatText, DrawLine, DrawArrow, DrawCircle, DrawRectangle, DrawLines, DrawLines2
function EnableOverlay()
    _G.DrawText, _G.PrintChat, _G.PrintFloatText, _G.DrawLine, _G.DrawArrow, _G.DrawCircle, _G.DrawRectangle, _G.DrawLines, _G.DrawLines2 = _DrawText, _PrintChat, _PrintFloatText, _DrawLine, _DrawArrow, _DrawCircle, _DrawRectangle, _DrawLines, _DrawLines2
end

function DisableOverlay()
    _G.DrawText, _G.PrintChat, _G.PrintFloatText, _G.DrawLine, _G.DrawArrow, _G.DrawCircle, _G.DrawRectangle, _G.DrawLines, _G.DrawLines2 = function() end, function() end, function() end, function() end, function() end, function() end, function() end, function() end, function() end
end

function QuitGame(timeout)
    RunAsyncCmdCommand("cmd /c" .. (timeout and (" ping -n " .. math.floor(timeout) .. " 127.0.0.1>nul &&") or "") .. ' taskkill /im "League of Legends.exe"')
    DelayAction(os.exit, (timeout or 0) + 5, { 0 }) --ForceQuit
end

-- return if cursor is under a rectangle
function CursorIsUnder(x, y, sizeX, sizeY)
    assert(type(x) == "number" and type(y) == "number" and type(sizeX) == "number", "CursorIsUnder: wrong argument types (at least 3 <number> expected)")
    local posX, posY = GetCursorPos().x, GetCursorPos().y
    if sizeY == nil then sizeY = sizeX end
    if sizeX < 0 then
        x = x + sizeX
        sizeX = -sizeX
    end
    if sizeY < 0 then
        y = y + sizeY
        sizeY = -sizeY
    end
    return (posX >= x and posX <= x + sizeX and posY >= y and posY <= y + sizeY)
end

--[[
   return texted version of a timer(minutes and seconds)
   if you want the full time string, use os.date("%H:%M:%S",seconds+82800)
]]
function TimerText(seconds)
    seconds = seconds or GetInGameTimer()
    if type(seconds) ~= "number" or seconds > 100000 or seconds < 0 then return " ? " end
    return string.format("%i:%02i", seconds / 60, seconds % 60)
end

-- return sprite
function GetSprite(file, altFile)
    assert(type(file) == "string", "GetSprite: wrong argument types (<string> expected for file)")
    if FileExist(SPRITE_PATH .. file) == true then
        return createSprite(file)
    else
        if altFile ~= nil and FileExist(SPRITE_PATH .. altFile) == true then
            return createSprite(altFile)
        else
            PrintChat(file .. " not found (sprites installed ?)")
            return createSprite("empty.dds")
        end
    end
end

--[=[
    GetWebSprite(url, [callback, [path]])
returns a sprite from a given website
if no callback is given, it returns it result immediately, if a callback is given, it downloads the sprite asynchrony and returns the sprite in the callback (recommended).
]=]
function GetWebSprite(url, callback, path)
    local urlr, sprite = url:reverse(), nil
    local filename, env = urlr:sub(1, urlr:find("/") - 1):reverse(), GetCurrentEnv() and GetCurrentEnv().FILE_NAME and GetCurrentEnv().FILE_NAME:gsub(".lua", "") or "WebSprites"
    if env and env:lower():sub(1, #("protected")) == "protected" then env = "Protected" end
    local filepath = type(path)=="string" and path or (SPRITE_PATH .. env .. "\\" .. filename)
    if FileExist(filepath) then
        sprite = createSprite(filepath)
        if type(callback) == "function" then callback(sprite) end
    else
        if type(callback) == "function" then
            MakeSurePathExists(filepath)
            DownloadFile(url, filepath, function()
                if FileExist(filepath) then
                    sprite = createSprite(filepath)
                end
                callback(sprite)
            end)
        else
            local finished = false
            sprite = GetWebSprite(url, function(data)
                finished = true
                sprite = data
            end, path)
            while not (finished or sprite or FileExist(filepath)) do
                RunCmdCommand("ping 127.0.0.1 -n 1 -w 1")
            end
        end
        if not sprite and FileExist(filepath) then
            sprite = createSprite(filepath)
        end
    end
    return sprite
end

-- return real hero leveled
function GetHeroLeveled()
    return player:GetSpellData(SPELL_1).level + player:GetSpellData(SPELL_2).level + player:GetSpellData(SPELL_3).level + player:GetSpellData(SPELL_4).level
end

-- return the target particle
function GetParticleObject(particle, target, range)
    assert(type(particle) == "string", "GetParticleObject: wrong argument types (<string> expected for particle)")
    local target = target or player
    local range = range or 50
    for i = 1, objManager.maxObjects do
        local object = objManager:GetObject(i)
        if object ~= nil and object.valid and object.name == particle and GetDistanceSqr(target, object) < range * range then return object end
    end
    return nil
end

-- return if target have particle
function TargetHaveParticle(particle, target, range)
    assert(type(particle) == "string", "TargetHaveParticule: wrong argument types (<string> expected for particle)")
    return (GetParticleObject(particle, target, range) ~= nil)
end

function BuffIsValid(buff)
    return buff and buff.name and buff.startT <= GetGameTimer() and buff.endT >= GetGameTimer()
end

-- return if target have buff
function TargetHaveBuff(buffName, target)
    assert(type(buffName) == "string" or type(buffName) == "table", "TargetHaveBuff: wrong argument types (<string> or <table of string> expected for buffName)")
    local target = target or player
    for i = 1, target.buffCount do
        local tBuff = target:getBuff(i)
        if BuffIsValid(tBuff) then
            if type(buffName) == "string" then
                if tBuff.name:lower() == buffName:lower() then return true end
            else
                for _, sBuff in ipairs(buffName) do
                    if tBuff.name:lower() == sBuff:lower() then return true end
                end
            end
        end
    end
    return false
end

-- return number of enemy in range
function CountEnemyHeroInRange(range, object)
    object = object or myHero
    range = range and range * range or myHero.range * myHero.range
    local enemyInRange = 0
    for i = 1, heroManager.iCount, 1 do
        local hero = heroManager:getHero(i)
        if ValidTarget(hero) and GetDistanceSqr(object, hero) <= range then
            enemyInRange = enemyInRange + 1
        end
    end
    return enemyInRange
end

function DrawArrows(posStart, posEnd, size, color, splitSize)
    assert(VectorType(posStart) and VectorType(posEnd) and type(size) == "number" and type(color) == "number" and (splitSize == nil or type(splitSize) == "number"), "DrawArrows: wrong argument types (<Vector>, <Vector>, integer, integer (, integer) expected)")
    --DrawArrow do not use y diff. We better to use the endpos y.
    local p1 = D3DXVECTOR3(posStart.x, posEnd.y, posStart.z)
    local p2 = D3DXVECTOR3(posEnd.x, posEnd.y, posEnd.z)
    local p12 = Vector(p2 - p1)
    local distarrow = p12:len() + 200 --200 is the arrow size
    local p3 = D3DXVECTOR3(p12.x, 0, p12.z)
    --split if need
    if splitSize ~= nil and splitSize > 200 and distarrow > splitSize then
        p12:normalize()
        while distarrow > splitSize do
            DrawArrow(p1, p3, splitSize, size, 1000000000000000000000, color)
            local p11 = Vector(p1) + (p12 * (splitSize - 400))
            distarrow = distarrow - splitSize + 400
            p1 = D3DXVECTOR3(p11.x, posEnd.y, p11.z)
        end
    end
    DrawArrow(p1, p3, distarrow, size, 1000000000000000000000, color)
    DrawCircle(p2.x, p2.y, p2.z, size, color)
end

function OnScreen(x, y) --Accepts one point, two points (line) or two numbers
    local typex = type(x)
    if typex == "number" then 
        return x <= WINDOW_W and x >= 0 and y >= 0 and y <= WINDOW_H
    elseif typex == "userdata" or typex == "table" then
        local p1, p2, p3, p4 = {x = 0,y = 0}, {x = WINDOW_W,y = 0}, {x = 0,y = WINDOW_H}, {x = WINDOW_W,y = WINDOW_H}
        return OnScreen(x.x, x.z or x.y) or (y and OnScreen(y.x, y.z or y.y) or 
            IsLineSegmentIntersection(x,y,p1,p2) or IsLineSegmentIntersection(x,y,p3,p4) or 
            IsLineSegmentIntersection(x,y,p1,p3) or IsLineSegmentIntersection(x,y,p2,p4))
    end
end

function DrawRectangleOutline(x, y, width, height, color, borderWidth)
    local x = math.min(x, x + width)
    local y = math.min(y, y + width)
    local width = math.abs(width)
    local height = math.abs(height)
    DrawRectangle(x, y, width, borderWidth, color)
    DrawRectangle(x, y, borderWidth, height, color)
    DrawRectangle(x, y + height - borderWidth, width, borderWidth, color)
    DrawRectangle(x + width - borderWidth, y, borderWidth, height, color)
end

function DrawLineBorder3D(x1, y1, z1, x2, y2, z2, size, color, width)
    local o = { x = -(z2 - z1), z = x2 - x1 }
    local len = math.sqrt(o.x ^ 2 + o.z ^ 2)
    o.x, o.z = o.x / len * size / 2, o.z / len * size / 2
    local points = {
        WorldToScreen(D3DXVECTOR3(x1 + o.x, y1, z1 + o.z)),
        WorldToScreen(D3DXVECTOR3(x1 - o.x, y1, z1 - o.z)),
        WorldToScreen(D3DXVECTOR3(x2 - o.x, y2, z2 - o.z)),
        WorldToScreen(D3DXVECTOR3(x2 + o.x, y2, z2 + o.z)),
        WorldToScreen(D3DXVECTOR3(x1 + o.x, y1, z1 + o.z)),
    }
    for i, c in ipairs(points) do points[i] = D3DXVECTOR2(c.x, c.y) end
    DrawLines2(points, width or 1, color or 4294967295)
end

function DrawLineBorder(x1, y1, x2, y2, size, color, width)
    local o = { x = -(y2 - y1), y = x2 - x1 }
    local len = math.sqrt(o.x ^ 2 + o.y ^ 2)
    o.x, o.y = o.x / len * size / 2, o.y / len * size / 2
    local points = {
        D3DXVECTOR2(x1 + o.x, y1 + o.y),
        D3DXVECTOR2(x1 - o.x, y1 - o.y),
        D3DXVECTOR2(x2 - o.x, y2 - o.y),
        D3DXVECTOR2(x2 + o.x, y2 + o.y),
        D3DXVECTOR2(x1 + o.x, y1 + o.y),
    }
    DrawLines2(points, width or 1, color or 4294967295)
end

function DrawCircleMinimap(x, y, z, radius, width, color, quality)
    radius = radius or 300
    quality = math.min(quality and 2 * math.pi / quality or 2 * math.pi / (radius / 100), 0.785)
    local points = {}
    for theta = 0, 2 * math.pi + quality, quality do
        points[#points + 1] = D3DXVECTOR2(GetMinimapX(x + radius * math.cos(theta)), GetMinimapY(z - radius * math.sin(theta)))
    end
    DrawLines2(points, width or 1, color or 4294967295)
end

function DrawCircle2D(x, y, radius, width, color, quality)
    quality, radius = quality and 2 * math.pi / quality or 2 * math.pi / 20, radius or 50
    local points = {}
    for theta = 0, 2 * math.pi + quality, quality do
        points[#points + 1] = D3DXVECTOR2(x + radius * math.cos(theta), y - radius * math.sin(theta))
    end
    DrawLines2(points, width or 1, color or 4294967295)
end

function DrawCircle3D(x, y, z, radius, width, color, quality)
    radius = radius or 300
    quality = quality and 2 * math.pi / quality or 2 * math.pi / (radius / 5)
    local points = {}
    for theta = 0, 2 * math.pi + quality, quality do
        local c = WorldToScreen(D3DXVECTOR3(x + radius * math.cos(theta), y, z - radius * math.sin(theta)))
        points[#points + 1] = D3DXVECTOR2(c.x, c.y)
    end
    DrawLines2(points, width or 1, color or 4294967295)
end

function DrawLine3D(x1, y1, z1, x2, y2, z2, width, color)
    local p = WorldToScreen(D3DXVECTOR3(x1, y1, z1))
    local px, py = p.x, p.y
    local c = WorldToScreen(D3DXVECTOR3(x2, y2, z2))
    local cx, cy = c.x, c.y
    if OnScreen({ x = px, y = py }, { x = px, y = py }) then
        DrawLine(cx, cy, px, py, width or 1, color or 4294967295)
    end
end

function DrawLines3D(points, width, color)
    local l
    for _, point in ipairs(points) do
        local p = { x = point.x, y = point.y, z = point.z }
        if not p.z then p.z = p.y; p.y = nil end
        p.y = p.y or player.y
        local c = WorldToScreen(D3DXVECTOR3(p.x, p.y, p.z))
        if l and OnScreen({ x = l.x, y = l.y }, { x = c.x, y = c.y }) then
            DrawLine(l.x, l.y, c.x, c.y, width or 1, color or 4294967295)
        end
        l = c
    end
end

--DrawTextA(text, [size], x, y, [color, [halign, [valign]]])
function DrawTextA(text, size, x, y, color, halign, valign)
    local textArea = GetTextArea(tostring(text) or "", size or 12)
    halign, valign = halign and halign:lower() or "left", valign and valign:lower() or "top"
    x = (halign == "right"  and x - textArea.x) or (halign == "center" and x - textArea.x/2) or x or 0
    y = (valign == "bottom" and y - textArea.y) or (valign == "center" and y - textArea.y/2) or y or 0
    DrawText(tostring(text) or "", size or 12, math.floor(x), math.floor(y), color or 4294967295)
end

function DrawText3D(text, x, y, z, size, color, center)
    local p = WorldToScreen(D3DXVECTOR3(x, y, z))
    local textArea = GetTextArea(text, size or 12)
    if center then
        if OnScreen(p.x + textArea.x / 2, p.y + textArea.y / 2) then
            DrawText(text, size or 12, p.x - textArea.x / 2, p.y, color or 4294967295)
        end
    else
        if OnScreen({ x = p.x, y = p.y }, { x = p.x + textArea.x, y = p.y + textArea.y }) then
            DrawText(text, size or 12, p.x, p.y, color or 4294967295)
        end
    end
end

function DrawHitBox(object, linesize, linecolor)
    if object and object.valid and object.minBBox then
        DrawLine3D(object.minBBox.x, object.minBBox.y, object.minBBox.z, object.minBBox.x, object.minBBox.y, object.maxBBox.z, linesize, linecolor)
        DrawLine3D(object.minBBox.x, object.minBBox.y, object.maxBBox.z, object.maxBBox.x, object.minBBox.y, object.maxBBox.z, linesize, linecolor)
        DrawLine3D(object.maxBBox.x, object.minBBox.y, object.maxBBox.z, object.maxBBox.x, object.minBBox.y, object.minBBox.z, linesize, linecolor)
        DrawLine3D(object.maxBBox.x, object.minBBox.y, object.minBBox.z, object.minBBox.x, object.minBBox.y, object.minBBox.z, linesize, linecolor)
        DrawLine3D(object.minBBox.x, object.minBBox.y, object.minBBox.z, object.minBBox.x, object.maxBBox.y, object.minBBox.z, linesize, linecolor)
        DrawLine3D(object.minBBox.x, object.minBBox.y, object.maxBBox.z, object.minBBox.x, object.maxBBox.y, object.maxBBox.z, linesize, linecolor)
        DrawLine3D(object.maxBBox.x, object.minBBox.y, object.maxBBox.z, object.maxBBox.x, object.maxBBox.y, object.maxBBox.z, linesize, linecolor)
        DrawLine3D(object.maxBBox.x, object.minBBox.y, object.minBBox.z, object.maxBBox.x, object.maxBBox.y, object.minBBox.z, linesize, linecolor)
        DrawLine3D(object.minBBox.x, object.maxBBox.y, object.minBBox.z, object.minBBox.x, object.maxBBox.y, object.maxBBox.z, linesize, linecolor)
        DrawLine3D(object.minBBox.x, object.maxBBox.y, object.maxBBox.z, object.maxBBox.x, object.maxBBox.y, object.maxBBox.z, linesize, linecolor)
        DrawLine3D(object.maxBBox.x, object.maxBBox.y, object.maxBBox.z, object.maxBBox.x, object.maxBBox.y, object.minBBox.z, linesize, linecolor)
        DrawLine3D(object.maxBBox.x, object.maxBBox.y, object.minBBox.z, object.minBBox.x, object.maxBBox.y, object.minBBox.z, linesize, linecolor)
    end
end

--[[
        Class: Vector
        API :
        ---- functions ----
        VectorType(v)                           -- return if as vector
        VectorIntersection(a1,b1,a2,b2)         -- return the Intersection of 2 lines
        IsLineSegmentIntersection(A,B,C,D)      -- return if 2 linesegments intersect
        LineSegmentIntersection(A,B,C,D)        -- return the Intersection of 2 linesegments
        VectorDirection(v1,v2,v)
        VectorPointProjectionOnLine(v1, v2, v)  -- return a vector on line v1-v2 closest to v
        Vector(a,b,c)                           -- return a vector from x,y,z pos or from another vector
        ---- Vector Members ----
        x
        y
        z
        ---- Vector Functions ----
        vector:clone()                          -- return a new Vector from vector
        vector:unpack()                         -- x, z
        vector:len2()                           -- return vector^2
        vector:len2(v)                          -- return vector^v
        vector:len()                            -- return vector length
        vector:dist(v)                          -- distance between 2 vectors (v and vector)
        vector:normalize()                      -- normalize vector
        vector:normalized()                     -- return a new Vector normalize from vector
        vector:rotate(phiX, phiY, phiZ)         -- rotate the vector by phi angle
        vector:rotated(phiX, phiY, phiZ)        -- return a new Vector rotate from vector by phi angle
        vector:projectOn(v)                     -- return a new Vector from vector projected on v
        vector:mirrorOn(v)                      -- return a new Vector from vector mirrored on v
        vector:center(v)                        -- return center between vector and v
        vector:crossP()                         -- return cross product of vector
        vector:dotP()                           -- return dot product of vector
        vector:polar()                          -- return the angle from axe
        vector:angleBetween(v1, v2)             -- return the angle formed from vector to v1,v2
        vector:compare(v)                       -- compare vector and v
        vector:perpendicular()                  -- return new Vector rotated 90° right
        vector:perpendicular2()                 -- return new Vector rotated 90° left
]]
-- STAND ALONE FUNCTIONS
function VectorType(v)
    return v and v.x and type(v.x) == "number" and ((v.y and type(v.y) == "number") or (v.z and type(v.z) == "number"))
end

local function IsClockWise(A,B,C)
    return VectorDirection(A,B,C)<=0
end

local function IsCounterClockWise(A,B,C)
    return not IsClockWise(A,B,C)
end

function IsLineSegmentIntersection(A,B,C,D)
    return IsClockWise(A, C, D) ~= IsClockWise(B, C, D) and IsClockWise(A, B, C) ~= IsClockWise(A, B, D)
end

function VectorIntersection(a1, b1, a2, b2) --returns a 2D point where to lines intersect (assuming they have an infinite length)
    assert(VectorType(a1) and VectorType(b1) and VectorType(a2) and VectorType(b2), "VectorIntersection: wrong argument types (4 <Vector> expected)")
    --http://thirdpartyninjas.com/blog/2008/10/07/line-segment-intersection/
    local x1, y1, x2, y2, x3, y3, x4, y4 = a1.x, a1.z or a1.y, b1.x, b1.z or b1.y, a2.x, a2.z or a2.y, b2.x, b2.z or b2.y
    local r, s, u, v, k, l = x1 * y2 - y1 * x2, x3 * y4 - y3 * x4, x3 - x4, x1 - x2, y3 - y4, y1 - y2
    local px, py, divisor = r * u - v * s, r * k - l * s, v * k - l * u
    return divisor ~= 0 and Vector(px / divisor, py / divisor)
end

function LineSegmentIntersection(A,B,C,D)
    return IsLineSegmentIntersection(A,B,C,D) and VectorIntersection(A,B,C,D)
end

function VectorDirection(v1, v2, v)
    --assert(VectorType(v1) and VectorType(v2) and VectorType(v), "VectorDirection: wrong argument types (3 <Vector> expected)")
    return ((v.z or v.y) - (v1.z or v1.y)) * (v2.x - v1.x) - ((v2.z or v2.y) - (v1.z or v1.y)) * (v.x - v1.x) 
end

function VectorPointProjectionOnLine(v1, v2, v)
    assert(VectorType(v1) and VectorType(v2) and VectorType(v), "VectorPointProjectionOnLine: wrong argument types (3 <Vector> expected)")
    local line = Vector(v2) - v1
    local t = ((-(v1.x * line.x - line.x * v.x + (v1.z - v.z) * line.z)) / line:len2())
    return (line * t) + v1
end

--[[
    VectorPointProjectionOnLineSegment: Extended VectorPointProjectionOnLine in 2D Space
    v1 and v2 are the start and end point of the linesegment
    v is the point next to the line
    return:
        pointSegment = the point closest to the line segment (table with x and y member)
        pointLine = the point closest to the line (assuming infinite extent in both directions) (table with x and y member), same as VectorPointProjectionOnLine
        isOnSegment = if the point closest to the line is on the segment
]]
function VectorPointProjectionOnLineSegment(v1, v2, v)
    assert(v1 and v2 and v, "VectorPointProjectionOnLineSegment: wrong argument types (3 <Vector> expected)")
    local cx, cy, ax, ay, bx, by = v.x, (v.z or v.y), v1.x, (v1.z or v1.y), v2.x, (v2.z or v2.y)
    local rL = ((cx - ax) * (bx - ax) + (cy - ay) * (by - ay)) / ((bx - ax) ^ 2 + (by - ay) ^ 2)
    local pointLine = { x = ax + rL * (bx - ax), y = ay + rL * (by - ay) }
    local rS = rL < 0 and 0 or (rL > 1 and 1 or rL)
    local isOnSegment = rS == rL
    local pointSegment = isOnSegment and pointLine or { x = ax + rS * (bx - ax), y = ay + rS * (by - ay) }
    return pointSegment, pointLine, isOnSegment
end

function VectorMovementCollision(startPoint1, endPoint1, v1, startPoint2, v2, delay)
    local sP1x, sP1y, eP1x, eP1y, sP2x, sP2y = startPoint1.x, startPoint1.z or startPoint1.y, endPoint1.x, endPoint1.z or endPoint1.y, startPoint2.x, startPoint2.z or startPoint2.y
    --v2 * t = Distance(P, A + t * v1 * (B-A):Norm())
    --(v2 * t)^2 = (r+S*t)^2+(j+K*t)^2 and v2 * t >= 0
    --0 = (S*S+K*K-v2*v2)*t^2+(-r*S-j*K)*2*t+(r*r+j*j) and v2 * t >= 0
    local d, e = eP1x-sP1x, eP1y-sP1y
    local dist, t1, t2 = math.sqrt(d*d+e*e), nil, nil
    local S, K = dist~=0 and v1*d/dist or 0, dist~=0 and v1*e/dist or 0
    local function GetCollisionPoint(t) return t and {x = sP1x+S*t, y = sP1y+K*t} or nil end
    if delay and delay~=0 then sP1x, sP1y = sP1x+S*delay, sP1y+K*delay end
    local r, j = sP2x-sP1x, sP2y-sP1y
    local c = r*r+j*j
    if dist>0 then
        if v1 == math.huge then
            local t = dist/v1
            t1 = v2*t>=0 and t or nil
        elseif v2 == math.huge then
            t1 = 0
        else
            local a, b = S*S+K*K-v2*v2, -r*S-j*K
            if a==0 then 
                if b==0 then --c=0->t variable
                    t1 = c==0 and 0 or nil
                else --2*b*t+c=0
                    local t = -c/(2*b)
                    t1 = v2*t>=0 and t or nil
                end
            else --a*t*t+2*b*t+c=0
                local sqr = b*b-a*c
                if sqr>=0 then
                    local nom = math.sqrt(sqr)
                    local t = (-nom-b)/a
                    t1 = v2*t>=0 and t or nil
                    t = (nom-b)/a
                    t2 = v2*t>=0 and t or nil
                end
            end
        end
    elseif dist==0 then
        t1 = 0
    end
    return t1, GetCollisionPoint(t1), t2, GetCollisionPoint(t2), dist
end

class'Vector'
-- INSTANCED FUNCTIONS
function Vector:__init(a, b, c)
    if a == nil then
        self.x, self.y, self.z = 0.0, 0.0, 0.0
    elseif b == nil then
        assert(VectorType(a), "Vector: wrong argument types (expected nil or <Vector> or 2 <number> or 3 <number>)")
        self.x, self.y, self.z = a.x, a.y, a.z
    else
        assert(type(a) == "number" and (type(b) == "number" or type(c) == "number"), "Vector: wrong argument types (<Vector> or 2 <number> or 3 <number>)")
        self.x = a
        if b and type(b) == "number" then self.y = b end
        if c and type(c) == "number" then self.z = c end
    end
end

function Vector:__type()
    return "Vector"
end

function Vector:__add(v)
    assert(VectorType(v) and VectorType(self), "add: wrong argument types (<Vector> expected)")
    return Vector(self.x + v.x, (v.y and self.y) and self.y + v.y, (v.z and self.z) and self.z + v.z)
end

function Vector:__sub(v)
    assert(VectorType(v) and VectorType(self), "Sub: wrong argument types (<Vector> expected)")
    return Vector(self.x - v.x, (v.y and self.y) and self.y - v.y, (v.z and self.z) and self.z - v.z)
end

function Vector.__mul(a, b)
    if type(a) == "number" and VectorType(b) then
        return Vector({ x = b.x * a, y = b.y and b.y * a, z = b.z and b.z * a })
    elseif type(b) == "number" and VectorType(a) then
        return Vector({ x = a.x * b, y = a.y and a.y * b, z = a.z and a.z * b })
    else
        assert(VectorType(a) and VectorType(b), "Mul: wrong argument types (<Vector> or <number> expected)")
        return a:dotP(b)
    end
end

function Vector.__div(a, b)
    if type(a) == "number" and VectorType(b) then
        return Vector({ x = a / b.x, y = b.y and a / b.y, z = b.z and a / b.z })
    else
        assert(VectorType(a) and type(b) == "number", "Div: wrong argument types (<number> expected)")
        return Vector({ x = a.x / b, y = a.y and a.y / b, z = a.z and a.z / b })
    end
end

function Vector.__lt(a, b)
    assert(VectorType(a) and VectorType(b), "__lt: wrong argument types (<Vector> expected)")
    return a:len() < b:len()
end

function Vector.__le(a, b)
    assert(VectorType(a) and VectorType(b), "__le: wrong argument types (<Vector> expected)")
    return a:len() <= b:len()
end

function Vector:__eq(v)
    assert(VectorType(v), "__eq: wrong argument types (<Vector> expected)")
    return self.x == v.x and self.y == v.y and self.z == v.z
end

function Vector:__unm() --redone, added check for y and z
    return Vector(-self.x, self.y and -self.y, self.z and -self.z)
end

function Vector:__vector(v)
    assert(VectorType(v), "__vector: wrong argument types (<Vector> expected)")
    return self:crossP(v)
end

function Vector:__tostring()
    if self.y and self.z then
        return "(" .. tostring(self.x) .. "," .. tostring(self.y) .. "," .. tostring(self.z) .. ")"
    else
        return "(" .. tostring(self.x) .. "," .. self.y and tostring(self.y) or tostring(self.z) .. ")"
    end
end

function Vector:clone()
    return Vector(self)
end

function Vector:unpack()
    return self.x, self.y, self.z
end

function Vector:len2(v)
    assert(v == nil or VectorType(v), "dist: wrong argument types (<Vector> expected)")
    local v = v and Vector(v) or self
    return self.x * v.x + (self.y and self.y * v.y or 0) + (self.z and self.z * v.z or 0)
end

function Vector:len()
    return math.sqrt(self:len2())
end

function Vector:dist(v)
    assert(VectorType(v), "dist: wrong argument types (<Vector> expected)")
    local a = self - v
    return a:len()
end

function Vector:normalize()
    local a = self:len()
    self.x = self.x / a
    if self.y then self.y = self.y / a end
    if self.z then self.z = self.z / a end
end

function Vector:normalized()
    local a = self:clone()
    a:normalize()
    return a
end

function Vector:center(v)
    assert(VectorType(v), "center: wrong argument types (<Vector> expected)")
    return Vector((self + v) / 2)
end

function Vector:crossP(other)
    assert(self.y and self.z and other.y and other.z, "crossP: wrong argument types (3 Dimensional <Vector> expected)")
    return Vector({
        x = other.z * self.y - other.y * self.z,
        y = other.x * self.z - other.z * self.x,
        z = other.y * self.x - other.x * self.y
    })
end

function Vector:dotP(other)
    assert(VectorType(other), "dotP: wrong argument types (<Vector> expected)")
    return self.x * other.x + (self.y and (self.y * other.y) or 0) + (self.z and (self.z * other.z) or 0)
end

function Vector:projectOn(v)
    assert(VectorType(v), "projectOn: invalid argument: cannot project Vector on " .. type(v))
    if type(v) ~= "Vector" then v = Vector(v) end
    local s = self:len2(v) / v:len2()
    return Vector(v * s)
end

function Vector:mirrorOn(v)
    assert(VectorType(v), "mirrorOn: invalid argument: cannot mirror Vector on " .. type(v))
    return self:projectOn(v) * 2
end

function Vector:sin(v)
    assert(VectorType(v), "sin: wrong argument types (<Vector> expected)")
    if type(v) ~= "Vector" then v = Vector(v) end
    local a = self:__vector(v)
    return math.sqrt(a:len2() / (self:len2() * v:len2()))
end

function Vector:cos(v)
    assert(VectorType(v), "cos: wrong argument types (<Vector> expected)")
    if type(v) ~= "Vector" then v = Vector(v) end
    return self:len2(v) / math.sqrt(self:len2() * v:len2())
end

function Vector:angle(v)
    assert(VectorType(v), "angle: wrong argument types (<Vector> expected)")
    return math.acos(self:cos(v))
end

function Vector:affineArea(v)
    assert(VectorType(v), "affineArea: wrong argument types (<Vector> expected)")
    if type(v) ~= "Vector" then v = Vector(v) end
    local a = self:__vector(v)
    return math.sqrt(a:len2())
end

function Vector:triangleArea(v)
    assert(VectorType(v), "triangleArea: wrong argument types (<Vector> expected)")
    return self:affineArea(v) / 2
end

function Vector:rotateXaxis(phi)
    assert(type(phi) == "number", "Rotate: wrong argument types (expected <number> for phi)")
    local c, s = math.cos(phi), math.sin(phi)
    self.y, self.z = self.y * c - self.z * s, self.z * c + self.y * s
end

function Vector:rotateYaxis(phi)
    assert(type(phi) == "number", "Rotate: wrong argument types (expected <number> for phi)")
    local c, s = math.cos(phi), math.sin(phi)
    self.x, self.z = self.x * c + self.z * s, self.z * c - self.x * s
end

function Vector:rotateZaxis(phi)
    assert(type(phi) == "number", "Rotate: wrong argument types (expected <number> for phi)")
    local c, s = math.cos(phi), math.sin(phi)
    self.x, self.y = self.x * c - self.z * s, self.y * c + self.x * s
end

function Vector:rotate(phiX, phiY, phiZ)
    assert(type(phiX) == "number" and type(phiY) == "number" and type(phiZ) == "number", "Rotate: wrong argument types (expected <number> for phi)")
    if phiX ~= 0 then self:rotateXaxis(phiX) end
    if phiY ~= 0 then self:rotateYaxis(phiY) end
    if phiZ ~= 0 then self:rotateZaxis(phiZ) end
end

function Vector:rotated(phiX, phiY, phiZ)
    assert(type(phiX) == "number" and type(phiY) == "number" and type(phiZ) == "number", "Rotated: wrong argument types (expected <number> for phi)")
    local a = self:clone()
    a:rotate(phiX, phiY, phiZ)
    return a
end

-- not yet full 3D functions
function Vector:polar()
    if math.close(self.x, 0) then
        if (self.z or self.y) > 0 then return 90
        elseif (self.z or self.y) < 0 then return 270
        else return 0
        end
    else
        local theta = math.deg(math.atan((self.z or self.y) / self.x))
        if self.x < 0 then theta = theta + 180 end
        if theta < 0 then theta = theta + 360 end
        return theta
    end
end

function Vector:angleBetween(v1, v2)
    assert(VectorType(v1) and VectorType(v2), "angleBetween: wrong argument types (2 <Vector> expected)")
    local p1, p2 = (-self + v1), (-self + v2)
    local theta = p1:polar() - p2:polar()
    if theta < 0 then theta = theta + 360 end
    if theta > 180 then theta = 360 - theta end
    return theta
end

function Vector:compare(v)
    assert(VectorType(v), "compare: wrong argument types (<Vector> expected)")
    local ret = self.x - v.x
    if ret == 0 then ret = self.z - v.z end
    return ret
end

function Vector:perpendicular()
    return Vector(-self.z, self.y, self.x)
end

function Vector:perpendicular2()
    return Vector(self.z, self.y, -self.x)
end

--[[
    Class: Queue
    Performance optimized implementation of a queue, much faster as if you use table.insert and table.remove
        Members:
            pushleft
            pushright
            popleft
            popright
        Sample:
            local myQueue = Queue()
            myQueue:pushleft("a"); myQueue:pushright(2);
            for i=1, #myQueue, 1 do
                PrintChat(tostring(myQueue[i]))
            end
        Notes:
            Don't use ipairs or pairs!
            It's a queue, dont try to insert values by yourself, only use the push functions to add values
]]
function Queue()
    local _queue = { first = 0, last = -1, list = {} }
    _queue.pushleft = function(self, value)
        self.first = self.first - 1
        self.list[self.first] = value
    end
    _queue.pushright = function(self, value)
        self.last = self.last + 1
        self.list[self.last] = value
    end
    _queue.popleft = function(self)
        if self.first > self.last then error("Queue is empty") end
        local value = self.list[self.first]
        self.list[self.first] = nil
        self.first = self.first + 1
        return value
    end
    _queue.popright = function(self)
        if self.first > self.last then error("Queue is empty") end
        local value = self.list[self.last]
        self.list[self.last] = nil
        self.last = self.last - 1
        return value
    end
    setmetatable(_queue,
        {
            __index = function(self, key)
                if type(key) == "number" then
                    return self.list[key + self.first - 1]
                end
            end,
            __newindex = function(self, key, value)
                error("Cant assign value to Queue, use Queue:pushleft or Queue:pushright instead")
            end,
            __len = function(self)
                return self.last - self.first + 1
            end,
        })
    return _queue
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Circle Class
--[[
    Methods:
        circle = Circle(center (opt),radius (opt))
    Function :
        circle:Contains(v)      -- return if Vector point v is in the circle
    Members :
        circle.center           -- Vector point for circle's center
        circle.radius           -- radius of the circle
]]
class'Circle'
function Circle:__init(center, radius)
    assert((VectorType(center) or center == nil) and (type(radius) == "number" or radius == nil), "Circle: wrong argument types (expected <Vector> or nil, <number> or nil)")
    self.center = Vector(center) or Vector()
    self.radius = radius or 0
end

function Circle:Contains(v)
    assert(VectorType(v), "Contains: wrong argument types (expected <Vector>)")
    return math.close(self.center:dist(v), self.radius)
end

function Circle:__tostring()
    return "{center: " .. tostring(self.center) .. ", radius: " .. tostring(self.radius) .. "}"
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Minimum Enclosing Circle class
--[[
    Global function ;
        GetMEC(R, range)                    -- Find Group Center From Nearest Enemies
        GetMEC(R, range, target)            -- Find Group Center Near Target
    MEC Class :
        Methods:
            mec = MEC(points (opt))
        Function :
            mec:SetPoints(points)
            mec:HalfHull(left, right, pointTable, factor)   -- return table
            mec:ConvexHull()                                -- return table
            mec:Compute()
        Members :
            mec.circle
            mec.points
]]
class'MEC'
function MEC:__init(points)
    self.circle = Circle()
    self.points = {}
    if points then
        self:SetPoints(points)
    end
end

function MEC:SetPoints(points)
    -- Set the points
    self.points = {}
    for _, p in ipairs(points) do
        table.insert(self.points, Vector(p))
    end
end

function MEC:HalfHull(left, right, pointTable, factor)
    -- Computes the half hull of a set of points
    local input = pointTable
    table.insert(input, right)
    local half = {}
    table.insert(half, left)
    for _, p in ipairs(input) do
        table.insert(half, p)
        while #half >= 3 do
            local dir = factor * VectorDirection(half[(#half + 1) - 3], half[(#half + 1) - 1], half[(#half + 1) - 2])
            if dir <= 0 then
                table.remove(half, #half - 1)
            else
                break
            end
        end
    end
    return half
end

function MEC:ConvexHull()
    -- Computes the set of points that represent the convex hull of the set of points
    local left, right = self.points[1], self.points[#self.points]
    local upper, lower, ret = {}, {}, {}
    -- Partition remaining points into upper and lower buckets.
    for i = 2, #self.points - 1 do
        if VectorType(self.points[i]) == false then PrintChat("self.points[i]") end
        table.insert((VectorDirection(left, right, self.points[i]) < 0 and upper or lower), self.points[i])
    end
    local upperHull = self:HalfHull(left, right, upper, -1)
    local lowerHull = self:HalfHull(left, right, lower, 1)
    local unique = {}
    for _, p in ipairs(upperHull) do
        unique["x" .. p.x .. "z" .. p.z] = p
    end
    for _, p in ipairs(lowerHull) do
        unique["x" .. p.x .. "z" .. p.z] = p
    end
    for _, p in pairs(unique) do
        table.insert(ret, p)
    end
    return ret
end

function MEC:Compute()
    -- Compute the MEC.
    -- Make sure there are some points.
    if #self.points == 0 then return nil end
    -- Handle degenerate cases first
    if #self.points == 1 then
        self.circle.center = self.points[1]
        self.circle.radius = 0
        self.circle.radiusPoint = self.points[1]
    elseif #self.points == 2 then
        local a = self.points
        self.circle.center = a[1]:center(a[2])
        self.circle.radius = a[1]:dist(self.circle.center)
        self.circle.radiusPoint = a[1]
    else
        local a = self:ConvexHull()
        local point_a = a[1]
        local point_b
        local point_c = a[2]
        if not point_c then
            self.circle.center = point_a
            self.circle.radius = 0
            self.circle.radiusPoint = point_a
            return self.circle
        end
        -- Loop until we get appropriate values for point_a and point_c
        while true do
            point_b = nil
            local best_theta = 180.0
            -- Search for the point "b" which subtends the smallest angle a-b-c.
            for _, point in ipairs(self.points) do
                if (not point == point_a) and (not point == point_c) then
                    local theta_abc = point:angleBetween(point_a, point_c)
                    if theta_abc < best_theta then
                        point_b = point
                        best_theta = theta_abc
                    end
                end
            end
            -- If the angle is obtuse, then line a-c is the diameter of the circle,
            -- so we can return.
            if best_theta >= 90.0 or (not point_b) then
                self.circle.center = point_a:center(point_c)
                self.circle.radius = point_a:dist(self.circle.center)
                self.circle.radiusPoint = point_a
                return self.circle
            end
            local ang_bca = point_c:angleBetween(point_b, point_a)
            local ang_cab = point_a:angleBetween(point_c, point_b)
            if ang_bca > 90.0 then
                point_c = point_b
            elseif ang_cab <= 90.0 then
                break
            else
                point_a = point_b
            end
        end
        local ch1 = (point_b - point_a) * 0.5
        local ch2 = (point_c - point_a) * 0.5
        local n1 = ch1:perpendicular2()
        local n2 = ch2:perpendicular2()
        ch1 = point_a + ch1
        ch2 = point_a + ch2
        self.circle.center = VectorIntersection(ch1, n1, ch2, n2)
        self.circle.radius = self.circle.center:dist(point_a)
        self.circle.radiusPoint = point_a
    end
    return self.circle
end

function GetMEC(radius, range, target)
    assert(type(radius) == "number" and type(range) == "number" and (target == nil or target.team ~= nil), "GetMEC: wrong argument types (expected <number>, <number>, <object> or nil)")
    local points = {}
    for i = 1, heroManager.iCount do
        local object = heroManager:GetHero(i)
        if (target == nil and ValidTarget(object, (range + radius))) or (target and ValidTarget(object, (range + radius), (target.team ~= player.team)) and (ValidTargetNear(object, radius * 2, target) or object.networkID == target.networkID)) then
            table.insert(points, Vector(object))
        end
    end
    return _CalcSpellPosForGroup(radius, range, points)
end

function _CalcSpellPosForGroup(radius, range, points)
    if #points == 0 then
        return nil
    elseif #points == 1 then
        return Circle(Vector(points[1]))
    end
    local mec = MEC()
    local combos = {}
    for j = #points, 2, -1 do
        local spellPos
        combos[j] = {}
        _CalcCombos(j, points, combos[j])
        for _, v in ipairs(combos[j]) do
            mec:SetPoints(v)
            local c = mec:Compute()
            if c ~= nil and c.radius <= radius and c.center:dist(player) <= range and (spellPos == nil or c.radius < spellPos.radius) then
                spellPos = Circle(c.center, c.radius)
            end
        end
        if spellPos ~= nil then return spellPos end
    end
end

function _CalcCombos(comboSize, targetsTable, comboTableToFill, comboString, index_number)
    local comboString = comboString or ""
    local index_number = index_number or 1
    if string.len(comboString) == comboSize then
        local b = {}
        for i = 1, string.len(comboString), 1 do
            local ai = tonumber(string.sub(comboString, i, i))
            table.insert(b, targetsTable[ai])
        end
        return table.insert(comboTableToFill, b)
    end
    for i = index_number, #targetsTable, 1 do
        _CalcCombos(comboSize, targetsTable, comboTableToFill, comboString .. i, i + 1)
    end
end

-- for combat
FindGroupCenterFromNearestEnemies = GetMEC
function FindGroupCenterNearTarget(target, radius, range)
    return GetMEC(radius, range, target)
end

--[[
    Class: WayPointManager
        Note: Only works for VIP user
            uses the Packet Conversion Library, might change in future
    
    Methods:
        WayPointManager:GetWayPoints(object) --returns all next waypoints of an object
                                             --The first WayPoint is always close to the position of the object itself.
                                             --A Waypoint is a Point with x and y values.
        WayPointManager:GetSimulatedWayPoints(object, [fromT, toT])
                                             --return waypoints, estimated duration(s) until target arrives at the last wayPoint (0 if already reached it)
                                             --Simulates the WayPoints in a time interval
                                             --Will simulate the target movement after going in FoW
        WayPointManager:GetWayPointChangeRate(object, [time])
                                             --only works for hero's
                                             --return how often the wayPoints changed in the last specific amount of time (default 1s)
                                             --max. Value when you hold MouseRight is 4s^-1, max. is 6s^-1
        WayPointManager:DrawWayPoints(obj, [color, size, fromT, toT])
                                             --Draws the WayPoints of an Object
    Example: local wayPointManager = WayPointManager()
    function OnDraw()
        wayPointManager:DrawWayPoints(player)
        wayPointManager:DrawWayPoints(player, ARGB(255,0,0,255), 2, 1, 2) --Draws from 1second ahead to 2seconds ahead of the object
        DrawText3D(tostring(wayPointManager:GetWayPointChangeRate(player)), player.x, player.y, player.z, 30, ARGB(255,0,255,0), true)
    end
]]
class'WayPointManager'
local WayPoints, WayPointRate, WayPointVisibility, WayPointCallbacks

local function WayPointManager_Callback(networkId)
    if WayPointCallbacks then
        for i, foo in pairs(WayPointCallbacks) do
            if type(foo)=="function" then
                foo(networkId)
            end
        end
    end
end

local function WayPointManager_OnRecvPacket(p)
    if p.header == Packet.headers.R_WAYPOINT then
        local packet = Packet(p)
        local networkID = packet:get("networkId")
        if (not networkID) or math.isNaN(networkID) then return end
        WayPoints[networkID] = packet:get("wayPoints")
        WayPointManager_Callback(networkID)
    elseif p.header == Packet.headers.R_WAYPOINTS then
        local packet = Packet(p)
        for networkID, wayPoints in pairs(packet:get("wayPoints")) do
            if WayPoints[networkID] then
                if WayPointRate[networkID] then
                    local wps = WayPoints[networkID]
                    local lwp, found = wps[#wps], false
                    for i = #wayPoints - 1, math.max(2, #wayPoints - 3), -1 do
                        local A, B = wayPoints[i], wayPoints[i + 1]
                        if lwp and A and B and GetDistanceSqr(lwp, VectorPointProjectionOnLineSegment(lwp, A, B)) < 1000 then found = true break end
                    end
                    if not found then WayPointRate[networkID]:pushleft(os.clock()) end
                    if #WayPointRate[networkID] > 20 then WayPointRate[networkID]:popright() end --Avoid memory leaks
                end
            end
            WayPoints[networkID] = wayPoints
            WayPointManager_Callback(networkID)
        end
    end
end

local function WayPointManager_OnDeleteObject(obj)
    local nwID = obj.networkID
    if nwID and nwID ~= 0 then WayPoints[nwID] = nil end
end

function WayPointManager:__init()
    if not WayPoints then
        WayPoints = {}
        WayPointRate = {}
        for i = 1, heroManager.iCount do
            local hero = heroManager:getHero(i)
            if hero ~= nil and hero.valid and hero.networkID and hero.networkID ~= 0 then
                WayPointRate[hero.networkID] = Queue()
            end
        end
        WayPointVisibility = {}
        if AddRecvPacketCallback then
            AddDeleteObjCallback(WayPointManager_OnDeleteObject)
            AddRecvPacketCallback(WayPointManager_OnRecvPacket)
            AdvancedCallback:bind('OnLoseVision', function(hero) if hero.valid and hero.networkID == hero.networkID and hero.networkID ~= 0 then WayPointVisibility[hero.networkID] = os.clock() end end)
            AdvancedCallback:bind('OnGainVision', function(hero) if hero.valid and hero.networkID == hero.networkID and hero.networkID ~= 0 then WayPointVisibility[hero.networkID] = nil end end)
            AdvancedCallback:bind('OnFinishRecall', function(hero) if hero.valid and hero.team == TEAM_ENEMY and hero.networkID == hero.networkID and hero.networkID ~= 0 then WayPoints[hero.networkID] = { { x = GetEnemySpawnPos().x, y = GetEnemySpawnPos().z } } WayPointVisibility[hero.networkID] = nil end end)
        end
        WayPointCallbacks = {}
    end
end

function WayPointManager.AddCallback(foo)
    WayPointManager()
    WayPointCallbacks[#WayPointCallbacks+1] = foo
end

function WayPointManager:GetRawWayPoints(object)
    return WayPoints[object.networkID]
end

function WayPointManager:GetWayPoints(object)
    local wayPoints, lineSegment, distanceSqr, fPoint = WayPoints[object.networkID], 0, math.huge, nil
    if not wayPoints then return { { x = object.x, y = object.z } } end
    for i = 1, #wayPoints - 1 do
        local p1, _, _ = VectorPointProjectionOnLineSegment(wayPoints[i], wayPoints[i + 1], object)
        local distanceSegmentSqr = GetDistanceSqr(p1, object)
        if distanceSegmentSqr < distanceSqr then
            fPoint = p1
            lineSegment = i
            distanceSqr = distanceSegmentSqr
        else break --not necessary, but makes it faster
        end
    end
    local result = { fPoint or { x = object.x, y = object.z } }
    for i = lineSegment + 1, #wayPoints do
        result[#result + 1] = wayPoints[i]
    end
    if #result == 2 and GetDistanceSqr(result[1], result[2]) < 400 then result[2] = nil end
    WayPoints[object.networkID] = result --not necessary, but makes later runs faster
    return result
end

function WayPointManager:GetPathLength(wayPointList, startIndex, endIndex)
    local tDist = 0
    for i = math.max(startIndex or 1, 1), math.min(#wayPointList, endIndex or math.huge) - 1 do
        tDist = tDist + GetDistance(wayPoints[i], wayPoints[i + 1])
    end
    return tDist
end

function WayPointManager:GetSimulatedWayPoints(object, fromT, toT)
    local wayPoints, fromT, toT = self:GetWayPoints(object), fromT or 0, toT or math.huge
    local invisDur = (not object.visible and WayPointVisibility[object.networkID]) and os.clock() - WayPointVisibility[object.networkID] or ((not object.visible and not WayPointVisibility[object.networkID]) and math.huge or 0)
    fromT = fromT + invisDur
    local tTime, fTime, result = 0, 0, {}
    for i = 1, #wayPoints - 1 do
        local A, B = wayPoints[i], wayPoints[i + 1]
        local dist = GetDistance(A, B)
        local cTime = dist / object.ms
        if tTime + cTime >= fromT then
            if #result == 0 then
                fTime = fromT - tTime
                result[1] = { x = A.x + object.ms * fTime * ((B.x - A.x) / dist), y = A.y + object.ms * fTime * ((B.y - A.y) / dist) }
            end
            if tTime + cTime >= toT then
                result[#result + 1] = { x = A.x + object.ms * (toT - tTime) * ((B.x - A.x) / dist), y = A.y + object.ms * (toT - tTime) * ((B.y - A.y) / dist) }
                fTime = fTime + toT - tTime
                break
            else
                result[#result + 1] = B
                fTime = fTime + cTime
            end
        end
        tTime = tTime + cTime
    end
    if #result == 0 and (tTime >= toT or invisDur) then result[1] = wayPoints[#wayPoints] end
    return result, fTime
end


function WayPointManager:GetWayPointChangeRate(object, time)
    local lastChanges = WayPointRate[object.networkID]
    if not lastChanges then return 0 end
    local time, rate = time or 1, 0
    for i = 1, #lastChanges do
        local t = lastChanges[i]
        if os.clock() - t >= time then break end
        rate = rate + 1
    end
    return rate
end

function WayPointManager:DrawWayPoints(obj, color, size, fromT, toT)
    local wayPoints = self:GetSimulatedWayPoints(obj, fromT, toT)
    local points = {}
    for i = 1, #wayPoints do
        local wayPoint = wayPoints[i]
        local c = WorldToScreen(D3DXVECTOR3(wayPoint.x, obj.y, wayPoint.y))
        points[#points + 1] = D3DXVECTOR2(c.x, c.y)
    end
    DrawLines2(points, size or 1, color or 4294967295)
end

-- Prediction Functions
--[[
    Globals Functions
        GetPredictionPos(iHero, delay)                  -- return nextPosition in delay (ms) for iHero (index)
        GetPredictionPos(Hero, delay)                   -- return nextPosition in delay (ms) for Hero
        GetPredictionPos(charName, delay, enemyTeam)    -- return nextPosition in delay (ms) for charName in enemyTeam (true/false, default true)
        GetPredictionHealth(iHero, delay)               -- return next Health in delay (ms) for iHero (index)
        GetPredictionHealth(Hero, delay)                -- return next Health in delay (ms) for Hero
        GetPredictionHealth(charName, delay, enemyTeam) -- return next Health in delay (ms) for charName in enemyTeam (true/false, default true)
]]
-- Prediction Functions
--[[
    Globals Functions
        GetPredictionPos(iHero, delay)                  -- return nextPosition in delay (ms) for iHero (index)
        GetPredictionPos(Hero, delay)                   -- return nextPosition in delay (ms) for Hero
        GetPredictionPos(charName, delay, enemyTeam)    -- return nextPosition in delay (ms) for charName in enemyTeam (true/false, default true)
        GetPredictionHealth(iHero, delay)               -- return next Health in delay (ms) for iHero (index)
        GetPredictionHealth(Hero, delay)                -- return next Health in delay (ms) for Hero
        GetPredictionHealth(charName, delay, enemyTeam) -- return next Health in delay (ms) for charName in enemyTeam (true/false, default true)
]]
local _gameHeroes, _gameAllyCount, _gameEnemyCount = {}, 0, 0
-- Class related function
local function _gameHeroes__init()
    if #_gameHeroes == 0 then
        _gameAllyCount, _gameEnemyCount = 0, 0
        for i = 1, heroManager.iCount do
            local hero = heroManager:getHero(i)
            if hero ~= nil and hero.valid then
                if hero.team == player.team then
                    _gameAllyCount = _gameAllyCount + 1
                    table.insert(_gameHeroes, { hero = hero, index = i, tIndex = _gameAllyCount, ignore = false, priority = 1, enemy = false })
                else
                    _gameEnemyCount = _gameEnemyCount + 1
                    table.insert(_gameHeroes, { hero = hero, index = i, tIndex = _gameEnemyCount, ignore = false, priority = 1, enemy = true })
                end
            end
        end
    end
end

local function _gameHeroes__extended(target, assertText)
    local assertText = assertText or ""
    if type(target) == "number" then
        return _gameHeroes[target]
    elseif target ~= nil and target.valid then
        assert(type(target.networkID) == "number", assertText .. ": wrong argument types (<charName> or <heroIndex> or <hero> expected)")
        for _, _gameHero in ipairs(_gameHeroes) do
            if _gameHero.hero.networkID == target.networkID then
                return _gameHero
            end
        end
    end
end

local function _gameHeroes__hero(target, assertText, enemyTeam)
    local assertText = assertText or ""
    enemyTeam = (enemyTeam ~= false)
    if type(target) == "string" then
        for _, _gameHero in ipairs(_gameHeroes) do
            if _gameHero.hero.charName == target and (_gameHero.hero.team ~= player.team) == enemyTeam then
                return _gameHero.hero
            end
        end
    elseif type(target) == "number" then
        return heroManager:getHero(target)
    elseif target == nil then
        return GetTarget()
    else
        assert(type(target.networkID) == "number", assertText .. ": wrong argument types (<charName> or <heroIndex> or <hero> or nil expected)")
        return target
    end
end

local function _gameHeroes__index(target, assertText, enemyTeam)
    local assertText = assertText or ""
    local enemyTeam = (enemyTeam ~= false)
    if type(target) == "string" then
        for _, _gameHero in ipairs(_gameHeroes) do
            if _gameHero.hero.charName == target and (_gameHero.hero.team ~= player.team) == enemyTeam then
                return _gameHero.index
            end
        end
    elseif type(target) == "number" then
        return target
    else
        assert(type(target.networkID) == "number", assertText .. ": wrong argument types (<charName> or <heroIndex> or <hero> or nil expected)")
        return _gameHeroes__index(target.charName, assertText, (target.team ~= player.team))
    end
end

local _Prediction = { init = true, delta = 1 }
local __Prediction__OnTick
local function _Prediction__OnLoad()
    if not __Prediction__OnTick then
        function __Prediction__OnTick()
            local tick = GetTickCount()
            _Prediction.delta = 1 / (tick - _Prediction.tick)
            _Prediction.tick = tick
            for _, _gameHero in ipairs(_gameHeroes) do
                if _gameHero.hero ~= nil and _gameHero.hero.valid and _gameHero.hero.dead == false and _gameHero.hero.visible then
                    _gameHero.pVector = (Vector(_gameHero.hero) - _gameHero.lastPos)
                    _gameHero.lastPos = Vector(_gameHero.hero)
                    _gameHero.pHealth = _gameHero.hero.health - _gameHero.lastHealth
                    _gameHero.lastHealth = _gameHero.hero.health
                end
            end
        end

        AddTickCallback(__Prediction__OnTick)
    end
    _gameHeroes__init()
    _Prediction.tick = GetTickCount()
    for _, _gameHero in ipairs(_gameHeroes) do
        if _gameHero.hero ~= nil and _gameHero.hero.valid then
            _gameHero.pVector = Vector()
            _gameHero.lastPos = Vector(_gameHero.hero)
            _gameHero.pHealth = 0
            _gameHero.lastHealth = _gameHero.hero.health
        end
    end
    _Prediction.init = nil
end

local function _PredictionPosition(iHero, delay)
    local _gameHero = _gameHeroes[iHero]
    if _gameHero and VectorType(_gameHero.pVector) and VectorType(_gameHero.lastPos) then
        local heroPosition = _gameHero.lastPos + (_gameHero.pVector * (_Prediction.delta * delay))
        heroPosition.y = _gameHero.hero.y
        return heroPosition
    end
end

local function _PredictionHealth(iHero, delay)
    local _gameHero = _gameHeroes[iHero]
    if _gameHero and _gameHero.pHealth ~= nil and _gameHero.lastHealth ~= nil then
        return _gameHero.lastHealth + (_gameHero.pHealth * (_Prediction.delta * delay))
    end
end

function GetPredictionPos(target, delay, enemyTeam)
    if _Prediction.init then _Prediction__OnLoad() end
    local enemyTeam = (enemyTeam ~= false)
    local iHero = _gameHeroes__index(target, "GetPredictionPos", enemyTeam)
    return _PredictionPosition(iHero, delay)
end

function GetPredictionHealth(target, delay, enemyTeam)
    if _Prediction.init then _Prediction__OnLoad() end
    local enemyTeam = (enemyTeam ~= false)
    local iHero = _gameHeroes__index(target, "GetPredictionHealth", enemyTeam)
    return _PredictionHealth(iHero, delay)
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- TargetSelector Class
--[[
TargetSelector Class :
    Methods:
        ts = TargetSelector(mode, range, damageType (opt), targetSelected (opt), enemyTeam (opt))
    Goblal Functions :
        TS_Print(enemyTeam (opt))           -> print Priority (global)
        TS_SetFocus()           -> set priority to the selected champion (you need to use PRIORITY modes to use it) (global)
        TS_SetFocus(id)         -> set priority to the championID (you need to use PRIORITY modes to use it) (global)
        TS_SetFocus(charName, enemyTeam (opt))  -> set priority to the champion charName (you need to use PRIORITY modes to use it) (global)
        TS_SetFocus(hero)       -> set priority to the hero object (you need to use PRIORITY modes to use it) (global)
        TS_SetHeroPriority(priority, target, enemyTeam (opt))                   -> set the priority to target
        TS_SetPriority(target1, target2, target3, target4, target5)     -> set priority in order to enemy targets
        TS_SetPriorityA(target1, target2, target3, target4, target5)    -> set priority in order to ally targets
        TS_GetPriority(target, enemyTeam)       -> return the current priority, and the max allowed
    Functions :
        ts:update()                                             -- update the instance target
        ts:SetDamages(magicDmgBase, physicalDmgBase, trueDmg)
        ts:SetPrediction()                          -- prediction off
        ts:SetPrediction(delay)                     -- predict movement for champs (need Prediction__OnTick())
        ts:SetMinionCollision()                     -- minion colission off
        ts:SetMinionCollision(spellWidth)           -- avoid champ if minion between player
        ts:SetConditional()                         -- erase external function use
        ts:SetConditional(func)                     -- set external function that return true/false to allow filter -- function(hero, index (opt))
        ts:SetProjectileSpeed(pSpeed)               -- set projectile speed (need Prediction__OnTick())
    Members:
        ts.mode                     -> TARGET_LOW_HP, TARGET_MOST_AP, TARGET_MOST_AD, TARGET_PRIORITY, TARGET_NEAR_MOUSE, TARGET_LOW_HP_PRIORITY, TARGET_LESS_CAST, TARGET_LESS_CAST_PRIORITY
        ts.range                    -> number > 0
        ts.targetSelected       -> true/false
        ts.target                   -> return the target (object or nil)
        ts.index        -> index of target (if hero)
        ts.nextPosition -> nextPosition predicted
        ts.nextHealth       -> nextHealth predicted
    Usage :
        variable = TargetSelector(mode, range, damageType (opt), targetSelected (opt), enemyTeam (opt))
        targetSelected is set to true if not filled
        Damages are set as default to magic 100 if none is set
        enemyTeam is false if ally, nil or true if enemy
        when you want to update, call variable:update()
        Values you can change on instance :
        variable.mode -> TARGET_LOW_HP, TARGET_MOST_AP, TARGET_PRIORITY, TARGET_NEAR_MOUSE, TARGET_LOW_HP_PRIORITY, TARGET_LESS_CAST, TARGET_LESS_CAST_PRIORITY
        variable.range -> number > 0
        variable.targetSelected -> true/false (if you clicked on a champ)
    ex :
        function OnLoad()
            ts = TargetSelector(TARGET_LESS_CAST, 600, DAMAGE_MAGIC, true)
        end
        function OnTick()
            if ts.target ~= nil then
                PrintChat(ts.target.charName)
                ts:SetDamages((player.ap * 10), 0, 0)
            end
        end
]]
-- Class related constants
TARGET_LOW_HP = 1
TARGET_MOST_AP = 2
TARGET_MOST_AD = 3
TARGET_LESS_CAST = 4
TARGET_NEAR_MOUSE = 5
TARGET_PRIORITY = 6
TARGET_LOW_HP_PRIORITY = 7
TARGET_LESS_CAST_PRIORITY = 8
TARGET_DEAD = 9
TARGET_CLOSEST = 10
DAMAGE_MAGIC = 1
DAMAGE_PHYSICAL = 2
-- Class related global
local _TS_Draw
local _TargetSelector__texted = { "LowHP", "MostAP", "MostAD", "LessCast", "NearMouse", "Priority", "LowHPPriority", "LessCastPriority", "Dead", "Closest" }
function TS_Print(enemyTeam)
    local enemyTeam = (enemyTeam ~= false)
    for _, target in ipairs(_gameHeroes) do
        if target.hero ~= nil and target.hero.valid and target.enemy == enemyTeam then
            PrintChat("[TS] " .. (enemyTeam and "Enemy " or "Ally ") .. target.tIndex .. " (" .. target.index .. ") : " .. target.hero.charName .. " Mode=" .. (target.ignore and "ignore" or "target") .. " Priority=" .. target.priority)
        end
    end
end

function TS_SetFocus(target, enemyTeam)
    local enemyTeam = (enemyTeam ~= false)
    local selected = _gameHeroes__hero(target, "TS_SetFocus")
    if selected ~= nil and selected.valid and selected.type == "obj_AI_Hero" and (selected.team ~= player.team) == enemyTeam then
        for _, _gameHero in ipairs(_gameHeroes) do
            if _gameHero.enemy == enemyTeam then
                if _gameHero.hero.networkID == selected.networkID then
                    _gameHero.priority = 1
                    PrintChat("[TS] Focusing " .. _gameHero.hero.charName)
                else
                    _gameHero.priority = (enemyTeam and _gameEnemyCount or _gameAllyCount)
                end
            end
        end
    end
end

function TS_SetHeroPriority(priority, target, enemyTeam)
    local enemyTeam = (enemyTeam ~= false)
    local heroCount = (enemyTeam and _gameEnemyCount or _gameAllyCount)
    assert(type(priority) == "number" and priority >= 0 and priority <= heroCount, "TS_SetHeroPriority: wrong argument types (<number> 1 to " .. heroCount .. " expected)")
    local selected = _gameHeroes__index(target, "TS_SetHeroPriority: wrong argument types (<charName> or <heroIndex> or <hero> or nil expected)", enemyTeam)
    if selected ~= nil then
        local oldPriority = _gameHeroes[selected].priority
        if oldPriority == nil or oldPriority == priority then return end
        for index, _gameHero in ipairs(_gameHeroes) do
            if _gameHero.enemy == enemyTeam then
                if index == selected then
                    _gameHero.priority = priority
                    --PrintChat("[TS] "..(enemyTeam and "Enemy " or "Ally ").._gameHero.tIndex.." (".._gameHero.index..") : " .. _gameHero.hero.charName .. " Mode=" .. (_gameHero.ignore and "ignore" or "target") .." Priority=" .. _gameHero.priority)
                end
            end
        end
    end
end

function TS_SetPriority(target1, target2, target3, target4, target5)
    assert((target5 ~= nil and _gameEnemyCount == 5) or (target4 ~= nil and _gameEnemyCount < 5) or (target3 ~= nil and _gameEnemyCount == 3) or (target2 ~= nil and _gameEnemyCount == 2) or (target1 ~= nil and _gameEnemyCount == 1), "TS_SetPriority: wrong argument types (" .. _gameEnemyCount .. " <target> expected)")
    TS_SetHeroPriority(1, target1)
    TS_SetHeroPriority(2, target2)
    TS_SetHeroPriority(3, target3)
    TS_SetHeroPriority(4, target4)
    TS_SetHeroPriority(5, target5)
end

function TS_SetPriorityA(target1, target2, target3, target4, target5)
    assert((target5 ~= nil and _gameAllyCount == 5) or (target4 ~= nil and _gameAllyCount < 5) or (target3 ~= nil and _gameAllyCount == 3) or (target2 ~= nil and _gameAllyCount == 2) or (target1 ~= nil and _gameAllyCount == 1), "TS_SetPriorityA: wrong argument types (" .. _gameAllyCount .. " <target> expected)")
    TS_SetHeroPriority(1, target1, false)
    TS_SetHeroPriority(2, target2, false)
    TS_SetHeroPriority(3, target3, false)
    TS_SetHeroPriority(4, target4, false)
    TS_SetHeroPriority(5, target5, false)
end

function TS_GetPriority(target, enemyTeam)
    local enemyTeam = (enemyTeam ~= false)
    local index = _gameHeroes__index(target, "TS_GetPriority", enemyTeam)
    return (index and _gameHeroes[index].priority or nil), (enemyTeam and _gameEnemyCount or _gameAllyCount)
end

function TS_Ignore(target, enemyTeam)
    local enemyTeam = (enemyTeam ~= false)
    local selected = _gameHeroes__hero(target, "TS_Ignore")
    if selected ~= nil and selected.valid and selected.type == "obj_AI_Hero" and (selected.team ~= player.team) == enemyTeam then
        for _, _gameHero in ipairs(_gameHeroes) do
            if _gameHero.hero.networkID == selected.networkID and _gameHero.enemy == enemyTeam then
                _gameHero.ignore = not _gameHero.ignore
                --PrintChat("[TS] "..(_gameHero.ignore and "Ignoring " or "Re-targetting ").._gameHero.hero.charName)
                break
            end
        end
    end
end

local function _TS_Draw_Init()
    if not _TS_Draw then
        UpdateWindow()
        _TS_Draw = { y1 = 0, height = 0, fontSize = WINDOW_H and math.round(WINDOW_H / 54) or 14, width = WINDOW_W and math.round(WINDOW_W / 4.8) or 213, border = 2, background = 1413167931, textColor = 4290427578, redColor = 1422721024, greenColor = 1409321728, blueColor = 2684354716 }
        _TS_Draw.cellSize, _TS_Draw.midSize, _TS_Draw.row1, _TS_Draw.row2, _TS_Draw.row3, _TS_Draw.row4 = _TS_Draw.fontSize + _TS_Draw.border, _TS_Draw.fontSize / 2, _TS_Draw.width * 0.6, _TS_Draw.width * 0.7, _TS_Draw.width * 0.8, _TS_Draw.width * 0.9
    end
end

local function TS__DrawMenu(x, y, enemyTeam)
    assert(type(x) == "number" and type(y) == "number", "TS__DrawMenu: wrong argument types (<number>, <number> expected)")
    _TS_Draw_Init()
    local enemyTeam = (enemyTeam ~= false)
    local y1 = y
    for _, _gameHero in ipairs(_gameHeroes) do
        if _gameHero.enemy == enemyTeam then
            DrawLine(x - _TS_Draw.border, y1 + _TS_Draw.midSize, x + _TS_Draw.row1 - _TS_Draw.border, y1 + _TS_Draw.midSize, _TS_Draw.cellSize, (_gameHero.ignore and _TS_Draw.redColor or _TS_Draw.background))
            DrawText(_gameHero.hero.charName, _TS_Draw.fontSize, x, y1, _TS_Draw.textColor)
            DrawLine(x + _TS_Draw.row1, y1 + _TS_Draw.midSize, x + _TS_Draw.row2 - _TS_Draw.border, y1 + _TS_Draw.midSize, _TS_Draw.cellSize, _TS_Draw.background)
            DrawText("   " .. (_gameHero.ignore and "-" or tostring(_gameHero.priority)), _TS_Draw.fontSize, x + _TS_Draw.row1, y1, _TS_Draw.textColor)
            DrawLine(x + _TS_Draw.row2, y1 + _TS_Draw.midSize, x + _TS_Draw.row3 - _TS_Draw.border, y1 + _TS_Draw.midSize, _TS_Draw.cellSize, _TS_Draw.blueColor)
            DrawText("   -", _TS_Draw.fontSize, x + _TS_Draw.row2, y1, _TS_Draw.textColor)
            DrawLine(x + _TS_Draw.row3, y1 + _TS_Draw.midSize, x + _TS_Draw.row4 - _TS_Draw.border, y1 + _TS_Draw.midSize, _TS_Draw.cellSize, _TS_Draw.blueColor)
            DrawText("   +", _TS_Draw.fontSize, x + _TS_Draw.row3, y1, _TS_Draw.textColor)
            DrawLine(x + _TS_Draw.row4, y1 + _TS_Draw.midSize, x + _TS_Draw.width, y1 + _TS_Draw.midSize, _TS_Draw.cellSize, _TS_Draw.redColor)
            DrawText("   X", _TS_Draw.fontSize, x + _TS_Draw.row4, y1, _TS_Draw.textColor)
            y1 = y1 + _TS_Draw.cellSize
        end
    end
    return y1
end

local function TS_ClickMenu(x, y, enemyTeam)
    assert(type(x) == "number" and type(y) == "number", "TS__DrawMenu: wrong argument types (<number>, <number> expected)")
    _TS_Draw_Init()
    local enemyTeam = (enemyTeam ~= false)
    local y1 = y
    for index, _gameHero in ipairs(_gameHeroes) do
        if _gameHero.enemy == enemyTeam then
            if CursorIsUnder(x + _TS_Draw.row2, y1, _TS_Draw.fontSize, _TS_Draw.fontSize) then
                TS_SetHeroPriority(math.max(1, _gameHero.priority - 1), index)
            elseif CursorIsUnder(x + _TS_Draw.row3, y1, _TS_Draw.fontSize, _TS_Draw.fontSize) then
                TS_SetHeroPriority(math.min((enemyTeam and _gameEnemyCount or _gameAllyCount), _gameHero.priority + 1), index)
            elseif CursorIsUnder(x + _TS_Draw.row4, y1, _TS_Draw.fontSize, _TS_Draw.fontSize) then TS_Ignore(index)
            end
            y1 = y1 + _TS_Draw.cellSize
        end
    end
    return y1
end

local __TargetSelector__OnSendChat
local function TargetSelector__OnLoad()
    if not __TargetSelector__OnSendChat then
        function __TargetSelector__OnSendChat(msg)
            if not msg or msg:sub(1, 3) ~= ".ts" then return end
            BlockChat()
            local args = {}
            while string.find(msg, " ") do
                local index = string.find(msg, " ")
                table.insert(args, msg:sub(1, index - 1))
                msg = string.sub(msg, index + 1)
            end
            table.insert(args, msg)
            local cmd = args[1]:lower()
            if cmd == ".tsprint" then
                TS_Print()
            elseif cmd == ".tsprinta" then
                TS_Print(false)
            elseif cmd == ".tsfocus" then
                PrintChat(cmd .. " - " .. args[2])
                TS_SetFocus(args[2])
            elseif cmd == ".tsfocusa" then
                TS_SetFocus(args[2], false)
            elseif cmd == ".tspriorityhero" then
                TS_SetHeroPriority(args[2], args[3])
            elseif cmd == ".tspriorityheroa" then
                TS_SetHeroPriority(args[2], args[3], false)
            elseif cmd == ".tspriority" then
                TS_SetPriority(args[2], args[3], args[4], args[5], args[6])
            elseif cmd == ".tsprioritya" then
                TS_SetPriorityA(args[2], args[3], args[4], args[5], args[6])
            elseif cmd == ".tsignore" then
                TS_Ignore(args[2])
            elseif cmd == ".tsignorea" then
                TS_Ignore(args[2], false)
            end
        end

        AddChatCallback(__TargetSelector__OnSendChat)
    end
end

class'TargetSelector'
function TargetSelector:__init(mode, range, damageType, targetSelected, enemyTeam)
    -- Init Global
    assert(type(mode) == "number" and type(range) == "number", "TargetSelector: wrong argument types (<mode>, <number> expected)")
    _gameHeroes__init()
    TargetSelector__OnLoad()
    self.mode = mode
    self.range = range
    self._mDmgBase, self._pDmgBase, self._tDmg = 0, 0, 0
    self._dmgType = damageType or DAMAGE_MAGIC
    if self._dmgType == DAMAGE_MAGIC then self._mDmgBase = 100 else self._pDmgBase = player.totalDamage end
    self.targetSelected = (targetSelected ~= false)
    self.enemyTeam = (enemyTeam ~= false)
    self.target = nil
    self._conditional = nil
    self._castWidth = nil
    self._pDelay = nil
    self._BBoxMode = false
end

function TargetSelector:printMode()
    PrintChat("[TS] Target mode: " .. _TargetSelector__texted[self.mode])
end

function TargetSelector:SetDamages(magicDmgBase, physicalDmgBase, trueDmg)
    assert(magicDmgBase == nil or type(magicDmgBase) == "number", "SetDamages: wrong argument types (<number> or nil expected) for magicDmgBase")
    assert(physicalDmgBase == nil or type(physicalDmgBase) == "number", "SetDamages: wrong argument types (<number> or nil expected) for physicalDmgBase")
    assert(trueDmg == nil or type(trueDmg) == "number", "SetDamages: wrong argument types (<number> or nil expected) for trueDmg")
    self._dmgType = 0
    self._mDmgBase = magicDmgBase or 0
    self._pDmgBase = physicalDmgBase or 0
    self._tDmg = trueDmg or 0
end

function TargetSelector:SetMinionCollision(castWidth, minionType)
    assert(castWidth == nil or type(castWidth) == "number", "SetMinionCollision: wrong argument types (<number> or nil expected)")
    self._castWidth = (castWidth and castWidth > 0) and castWidth
    if self._castWidth then
        local minionType = minionType or MINION_ENEMY
        self._minionTable = minionManager(minionType, self.range + 300)
    else
        self._minionTable = nil
    end
end

function TargetSelector:SetPrediction(delay)
    assert(delay == nil or type(delay) == "number", "SetPrediction: wrong argument types (<number> or nil expected)")
    _Prediction__OnLoad()
    self._pDelay = ((delay ~= nil and delay > 0) and delay or nil)
end

function TargetSelector:SetProjectileSpeed(pSpeed)
    assert(delay == nil or type(delay) == "number", "SetProjectileSpeed: wrong argument types (<number> or nil expected)")
    _Prediction__OnLoad()
    self._pSpeed = ((pSpeed ~= nil and pSpeed > 0) and pSpeed or nil)
end

function TargetSelector:SetConditional(func)
    assert(func == nil or type(func) == "function", "SetConditional : wrong argument types (<function> or nil expected)")
    self._conditional = func
end

function TargetSelector:SetBBoxMode(bbMode)
    assert(type(bbMode) == "boolean", "SetBBoxMode : wrong argument types (<boolean> expected)")
    self._BBoxMode = bbMode
end

function TargetSelector:_targetSelectedByPlayer()
    if self.targetSelected then
        local currentTarget = GetTarget()
        local validTarget = false
        if self._BBoxMode then
            validTarget = ValidBBoxTarget(currentTarget, self.range, self.enemyTeam)
        else
            validTarget = ValidTarget(currentTarget, self.range, self.enemyTeam)
        end
        if validTarget and (currentTarget.type == "obj_AI_Hero" or currentTarget.type == "obj_AI_Minion") and (self._conditional == nil or self._conditional(currentTarget)) then
            if self.target == nil or not self.target.valid or self.target.networkID ~= currentTarget.networkID then
                self.target = currentTarget
                self.index = _gameHeroes__index(currentTarget, "_targetSelectedByPlayer")
            end
            local delay = 0
            if self._pDelay ~= nil and self._pDelay > 0 then
                delay = delay + self._pDelay
            end
            if self._pSpeed ~= nil and self._pSpeed > 0 then
                delay = delay + (GetDistance(currentTarget) / self._pSpeed)
            end
            if self.index and delay > 0 then
                self.nextPosition = _PredictionPosition(self.index, delay)
                self.nextHealth = _PredictionHealth(self.index, delay)
            else
                self.nextPosition = Vector(currentTarget)
                self.nextHealth = currentTarget.health
            end
            return true
        end
    end
    return false
end

function TargetSelector:update()
    -- Resets the target if player died
    if player.dead then
        self.target = nil
        return
    end
    -- Get current selected target (by player) if needed
    if self:_targetSelectedByPlayer() then return end
    local selected, index, value, nextPosition, nextHealth
    local range = (self.mode == TARGET_NEAR_MOUSE and 2000 or self.range)
    if self._minionTable then self._minionTable:update() end
    for i, _gameHero in ipairs(_gameHeroes) do
        local hero = _gameHero.hero
        local validTarget = false
        if self._BBoxMode then
            validTarget = ValidBBoxTarget(hero, range, self.enemyTeam)
        else
            validTarget = ValidTarget(hero, range, self.enemyTeam)
        end
        if validTarget and not _gameHero.ignore and (self._conditional == nil or self._conditional(hero, i)) then
            local minionCollision = false
            local delay = 0
            local distanceValid = true
            if self._pDelay ~= nil and self._pDelay > 0 then
                delay = delay + self._pDelay
            end
            if self._pSpeed ~= nil and self._pSpeed > 0 then
                delay = delay + (GetDistance(hero) / self._pSpeed)
            end
            if delay > 0 then
                nextPosition = _PredictionPosition(i, delay)
                nextHealth = _PredictionHealth(i, delay)
                distanceValid = GetDistance(nextPosition) <= range
            else
                nextPosition, nextHealth = Vector(hero), hero.health
            end
            if self._castWidth then minionCollision = GetMinionCollision(player, nextPosition, self._castWidth, self._minionTable.objects) end
            if distanceValid and minionCollision == false then
                if self.mode == TARGET_LOW_HP or self.mode == TARGET_LOW_HP_PRIORITY or self.mode == TARGET_LESS_CAST or self.mode == TARGET_LESS_CAST_PRIORITY then
                    -- Returns lowest effective HP target that is in range
                    -- Or lowest cast to kill target that is in range
                    if self._dmgType == DAMAGE_PHYSICAL then self._pDmgBase = player.totalDamage end
                    local mDmg = (self._mDmgBase > 0 and player:CalcMagicDamage(hero, self._mDmgBase) or 0)
                    local pDmg = (self._pDmgBase > 0 and player:CalcDamage(hero, self._pDmgBase) or 0)
                    local totalDmg = mDmg + pDmg + self._tDmg
                    -- priority mode
                    if self.mode == TARGET_LOW_HP_PRIORITY or self.mode == TARGET_LESS_CAST_PRIORITY then
                        totalDmg = totalDmg / _gameHero.priority
                    end
                    local heroValue
                    if self.mode == TARGET_LOW_HP or self.mode == TARGET_LOW_HP_PRIORITY then
                        heroValue = hero.health - totalDmg
                    else
                        heroValue = hero.health / totalDmg
                    end
                    if not selected or heroValue < value then selected, index, value = hero, i, heroValue end
                elseif self.mode == TARGET_DEAD then
                    if self._dmgType == DAMAGE_PHYSICAL then self._pDmgBase = player.totalDamage end
                    local mDmg = (self._mDmgBase > 0 and player:CalcMagicDamage(hero, self._mDmgBase) or 0)
                    local pDmg = (self._pDmgBase > 0 and player:CalcDamage(hero, self._pDmgBase) or 0)
                    local totalDmg = mDmg + pDmg + self._tDmg
                    if hero.health - totalDmg <= 0 then
                        selected, index, value = hero, i, 0
                    end
                elseif self.mode == TARGET_MOST_AP then
                    -- Returns target that has highest AP that is in range
                    if not selected or hero.ap > selected.ap then selected, index = hero, i end
                elseif self.mode == TARGET_MOST_AD then
                    -- Returns target that has highest AD that is in range
                    if not selected or hero.totalDamage > selected.totalDamage then selected, index = hero, i end
                elseif self.mode == TARGET_PRIORITY then
                    -- Returns target with highest priority # that is in range
                    if not selected or _gameHero.priority < value then selected, index, value = hero, i, _gameHero.priority end
                elseif self.mode == TARGET_CLOSEST then
                    -- Returns target that is the closest to your champion.
                    local distance = GetDistanceSqr(hero)
                    if not selected or distance < value then selected, index, value = hero, i, distance end
                elseif self.mode == TARGET_NEAR_MOUSE then
                    -- Returns target that is the closest to the mouse cursor.
                    local distance = GetDistanceSqr(mousePos, hero)
                    if not selected or distance < value then selected, index, value = hero, i, distance end
                end
            end
        end
    end
    self.index = index
    self.target = selected
    self.nextPosition = nextPosition
    self.nextHealth = nextHealth
end

function TargetSelector:OnSendChat(msg, prefix)
    assert(type(prefix) == "string" and prefix ~= "" and prefix:lower() ~= "ts", "TS OnSendChat: wrong argument types (<string> (not TS) expected for prefix)")
    if msg:sub(1, 1) ~= "." then return end
    local prefix = prefix:lower()
    local length = prefix:len() + 1
    if msg:sub(1, length) ~= "." .. prefix then return end
    BlockChat()
    local args = {}
    while string.find(msg, " ") do
        local index = string.find(msg, " ")
        table.insert(args, msg:sub(1, index - 1))
        msg = msg:sub(index + 1)
    end
    table.insert(args, msg)
    local cmd = args[1]:lower()
    if cmd == "." .. prefix .. "mode" then
        assert(args[2] ~= nil, "TS OnSendChat: wrong argument types (LowHP, MostAP, MostAD, LessCast, NearMouse, Priority, LowHPPriority, LessCastPriority expected)")
        local index = 0
        for i, mode in ipairs({ "LowHP", "MostAP", "MostAD", "LessCast", "NearMouse", "Priority", "LowHPPriority", "LessCastPriority" }) do
            if mode:lower() == args[2]:lower() then
                index = i
                break
            end
        end
        assert(index ~= 0, "TS OnSendChat: wrong argument types (LowHP, MostAP, MostAD, LessCast, NearMouse, Priority, LowHPPriority, LessCastPriority expected)")
        self.mode = index
        self:printMode()
    end
end

function TargetSelector:DrawMenu(x, y)
    assert(type(x) == "number" and type(y) == "number", "ts:DrawMenu: wrong argument types (<number>, <number> expected)")
    _TS_Draw_Init()
    DrawLine(x - _TS_Draw.border, y + _TS_Draw.midSize, x + _TS_Draw.row3 - _TS_Draw.border, y + _TS_Draw.midSize, _TS_Draw.cellSize, _TS_Draw.background)
    DrawText((self.name or "ts") .. " Mode : " .. _TargetSelector__texted[self.mode], _TS_Draw.fontSize, x, y, _TS_Draw.textColor)
    DrawLine(x + _TS_Draw.row3, y + _TS_Draw.midSize, x + _TS_Draw.row4 - _TS_Draw.border, y + _TS_Draw.midSize, _TS_Draw.cellSize, _TS_Draw.blueColor)
    DrawText("   <", _TS_Draw.fontSize, x + _TS_Draw.row3, y, _TS_Draw.textColor)
    DrawLine(x + _TS_Draw.row4, y + _TS_Draw.midSize, x + _TS_Draw.width, y + _TS_Draw.midSize, _TS_Draw.cellSize, _TS_Draw.blueColor)
    DrawText("   >", _TS_Draw.fontSize, x + _TS_Draw.row4, y, _TS_Draw.textColor)
    return y + _TS_Draw.cellSize
end

function TargetSelector:ClickMenu(x, y)
    assert(type(x) == "number" and type(y) == "number", "ts:ClickMenu: wrong argument types (<number>, <number>, <string> expected)")
    _TS_Draw_Init()
    if CursorIsUnder(x + _TS_Draw.row3, y, _TS_Draw.fontSize, _TS_Draw.fontSize) then
        self.mode = (self.mode == 1 and #_TargetSelector__texted or self.mode - 1)
    elseif CursorIsUnder(x + _TS_Draw.row4, y, _TS_Draw.fontSize, _TS_Draw.fontSize) then
        self.mode = (self.mode == #_TargetSelector__texted and 1 or self.mode + 1)
    end
    return y + _TS_Draw.cellSize
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- GetMinionCollision
--[[
    Goblal Function :
    GetMinionCollision(posEnd, spellWidth)          -> return true/false if collision with minion from player to posEnd with spellWidth.
]]
local function _minionInCollision(minion, posStart, posEnd, spellSqr, sqrDist)
    if GetDistanceSqr(minion, posStart) < sqrDist and GetDistanceSqr(minion, posEnd) < sqrDist then
        local _, p2, isOnLineSegment = VectorPointProjectionOnLineSegment(posStart, posEnd, minion)
        if isOnLineSegment and GetDistanceSqr(minion, p2) <= spellSqr then return true end
    end
    return false
end

function GetMinionCollision(posStart, posEnd, spellWidth, minionTable)
    assert(VectorType(posStart) and VectorType(posEnd) and type(spellWidth) == "number", "GetMinionCollision: wrong argument types (<Vector>, <Vector>, <number> expected)")
    local sqrDist = GetDistanceSqr(posStart, posEnd)
    local spellSqr = spellWidth * spellWidth / 4
    if minionTable then
        for _, minion in pairs(minionTable) do
            if _minionInCollision(minion, posStart, posEnd, spellSqr, sqrDist) then return true end
        end
    else
        for i = 0, objManager.maxObjects, 1 do
            local object = objManager:getObject(i)
            if object and object.valid and object.team ~= player.team and object.type == "obj_AI_Minion" and not object.dead and object.visible and object.bTargetable then
                if _minionInCollision(object, posStart, posEnd, spellSqr, sqrDist) then return true end
            end
        end
    end
    return false
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[
    Class: TargetPredictionVIP by gReY
        Note: Only works for VIP user
            uses the WayPointManager
    
    Methods:
        TargetPredictionVIP(range, [proj_speed, delay, width, fromPos])     
                                                    -- initializes the prediction class
                                                    -- base time format is seconds
                                                    -- example: proj_speed = 2000 (distance/seconds); delay = 0.25 (seconds);
        TargetPredictionVIP:GetPrediction(object)     
                                                    -- returns the predicted position of the target, the arrival/hittime (in seconds) and the position where you shoot the best (only with given spellwidth)
                                                    -- a position is a table with x and y and z values.
        TargetPredictionVIP:GetHitChance(object)        
                                                    -- returns the hitchance (number from 0 to 1, 1 being best), calculations might seem ugly, and they will perhaps change in future
        TargetPredictionVIP:GetCollision(target)    
                                                    -- returns true or false depending on if there are minions in the way that would block the spell. This is more performance intense than older MinionCollision functions, but more accurate. 
                                                    -- It uses the Minion Waypoints to get its result. It is necessary that you give the TargetPredictionVIP a SpellWidth, or it won't work
        TargetPredictionVIP:DrawPrediction(object, [color, size])
                                                    -- draws a line from you to the prediction
        TargetPredictionVIP:DrawWayPoints(obj, [color, size, fromT, toT])
                                                    -- draws the WayPoints of an Object
        TargetPredictionVIP:DrawPredictionRectangle(obj, [color, size])
                                                    -- draws a rectangle from you to the Position where you should shoot to (3rd return value of GetPrediction)
                                                    -- only works when width given
        TargetPredictionVIP:DrawAnimatedPrediction(obj, [color1, color2, size1, size2, drawspeed])
                                                    -- draws an animated line of the path of the object and the spell you could shoot.
                                                    -- drawspeed in seconds. defines in seconds how much time a single animation takes.
    Example: local tp = TargetPredictionVIP(3000, 2000, 0.25)
    function OnDraw()
        for i, target in pairs(GetEnemyHeroes()) do
            tp:DrawAnimatedPrediction(target, ARGB(255,255,255,255), ARGB(255,255,0,0), 2, 2)
        end
    end
]]

class'TargetPredictionVIP'
function TargetPredictionVIP:__init(range, proj_speed, delay, width, fromPos)
    if not VIP_USER then self = nil return end
    self.WayPointManager = WayPointManager()
    self.Spell = { Source = fromPos or myHero, RangeSqr = range and (range ^ 2) or math.huge, Speed = proj_speed or math.huge, Delay = delay or 0, Width = width }
    self.Cache = {}
end

function TargetPredictionVIP:GetPrediction(target)
    if os.clock() - (self.Cache[target.networkID] and self.Cache[target.networkID].Time or 0) >= 1 / 60 then self.Cache[target.networkID] = { Time = os.clock() }
    else return self.Cache[target.networkID].HitPosition, self.Cache[target.networkID].HitTime, self.Cache[target.networkID].ShootPosition
    end
    local wayPoints, hitPosition, hitTime = self.WayPointManager:GetSimulatedWayPoints(target, self.Spell.Delay + ((GetLatency() / 2) / 1000)), nil, nil
    --assert(self.Spell.Speed > 0 and self.Spell.Delay >= 0, "TargetPredictionVIP:GetPrediction : SpellDelay must be >=0 and SpellSpeed must be >0")
    local vec
    if #wayPoints == 1 or self.Spell.Speed == math.huge then --Target not moving
        hitPosition = { x = wayPoints[1].x, y = target.y, z = wayPoints[1].y };
        hitTime = GetDistance(wayPoints[1], self.Spell.Source) / self.Spell.Speed
        vec = self.Spell.Width and hitPosition
    else --Target Moving
        local travelTimeA = 0
        for i = 1, #wayPoints - 1 do
            local A, B = wayPoints[i], wayPoints[i + 1]
            local t1, p1, t2, p2, wayPointDist =  VectorMovementCollision(A, B, target.ms, self.Spell.Source, self.Spell.Speed)
            local travelTimeB = travelTimeA + wayPointDist / target.ms
            t1, t2 = (t1 and travelTimeA <= t1 and t1 <= travelTimeB) and t1 or nil, (t2 and travelTimeA <= t2 and t2 <= travelTimeB) and t2 or nil
            local t = t1 and t2 and math.min(t1,t2) or t1 or t2
            if t then
                hitPosition = t==t1 and { x = p1.x, y = target.y, z = p1.y } or { x = p2.x, y = target.y, z = p2.y }
                hitTime = t
                if self.Spell.Width then
                    local function rotate2D(vec, vec2, phi)
                        local vec = { x = vec.x - vec2.x, y = vec.y, z = vec.z - vec2.z }
                        vec.x, vec.z = math.cos(phi) * vec.x - math.sin(phi) * vec.z + vec2.x, math.sin(phi) * vec.x + math.cos(phi) * vec.z + vec2.z
                        return vec
                    end

                    local alpha = (math.atan2(B.y - A.y, B.x - A.x) - math.atan2(self.Spell.Source.z - hitPosition.z, self.Spell.Source.x - hitPosition.x)) % (2 * math.pi) --angle between movement and spell
                    local total = 1 - (math.abs((alpha % math.pi) - math.pi / 2) / (math.pi / 2)) --0 if the player walks in your direction or away from your direction, 1 if he walks orthogonal to you
                    local phi = alpha < math.pi and math.atan((self.Spell.Width / 2) / (self.Spell.Speed * hitTime)) or -math.atan((self.Spell.Width / 2) / (self.Spell.Speed * hitTime))
                    vec = rotate2D({ x = hitPosition.x, y = hitPosition.y, z = hitPosition.z }, self.Spell.Source, phi * total)
                end
                break
            end
            --Logic In Case there is no prediction 'till the last wayPoint
            if i == #wayPoints - 1 then
                hitPosition = { x = B.x, y = target.y, z = B.y }
                hitTime = travelTimeB
                vec = self.Spell.Width and hitPosition
            end
            --no prediction in the current segment, go to next waypoint
            travelTimeA = travelTimeB
        end
    end
    if hitPosition and self.Spell.RangeSqr >= GetDistanceSqr(hitPosition, self.Spell.Source) then
        self.Cache[target.networkID].HitPosition, self.Cache[target.networkID].HitTime, self.Cache[target.networkID].ShootPosition = hitPosition, hitTime, vec
        return hitPosition, hitTime, vec
    end
end

function TargetPredictionVIP:GetHitChance(target)
    local pos, t = self:GetPrediction(target)
    if self.Cache[target.networkID] and self.Cache[target.networkID].Chance then return self.Cache[target.networkID].Chance end
    local function sum(t) local n = 0 for i, v in pairs(t) do n = n + v end return n end

    local hitChance = 0
    local hC = {}
    --Track if the enemy arrived at its last waypoint and is invisible (lower hitchance)
    local wps, arrival = self.WayPointManager:GetSimulatedWayPoints(target)
    hC[#hC + 1] = target.visible and 1 or (arrival ~= 0 and 0.5 or 0)
    if target.visible then
        --Track how often the enemy moves. If he constantly moves, the hitchance is lower
        local rate = 1 - math.max(0, (self.WayPointManager:GetWayPointChangeRate(target) - 1)) / 5
        hC[#hC + 1] = rate; hC[#hC + 1] = rate; hC[#hC + 1] = rate
        --Track the time the spell needs to hit the target. the higher it is, the lower the hitchance
        if t then hC[#hC + 1] = math.min(math.max(0, 1 - t / 1), 1) end
    end
    --Generate a value between 0 (no chance) and 100 (you'll hit for sure)
    hitChance = math.min(1, math.max(0, sum(hC) / #hC))
    if self.Cache[target.networkID] then self.Cache[target.networkID].Chance = hitChance end
    return hitChance
end

function TargetPredictionVIP:DrawPrediction(target, color, size)
    local pos, time, shoot = self:GetPrediction(target)
    if not pos then return end
    DrawLine3D(pos.x, target.y, pos.z, self.Spell.Source.x, self.Spell.Source.y, self.Spell.Source.z, size, color, true)
end

function TargetPredictionVIP:DrawPredictionRectangle(target, color, size)
    local pos, time, shoot = self:GetPrediction(target)
    if not shoot then return end
    DrawLineBorder3D(shoot.x, target.y, shoot.z, self.Spell.Source.x, self.Spell.Source.y, self.Spell.Source.z, self.Spell.Width, color, size or 1)
end

function TargetPredictionVIP:DrawAnimatedPrediction(target, color1, color2, size1, size2, drawspeed)
    drawspeed = drawspeed or 1
    local pos, time = self:GetPrediction(target)
    if pos then
        local r = GetDrawClock(drawspeed)
        DrawLine3D(self.Spell.Source.x, self.Spell.Source.y, self.Spell.Source.z, self.Spell.Source.x + r * (pos.x - self.Spell.Source.x), target.y, self.Spell.Source.z + r * (pos.z - self.Spell.Source.z), size1, color1)
        local points = {}
        for i, v in ipairs(WayPointManager:GetSimulatedWayPoints(target, 0, (self.Spell.Delay + time) * r)) do
            local c = WorldToScreen(D3DXVECTOR3(v.x, target.y, v.y))
            points[#points + 1] = D3DXVECTOR2(c.x, c.y)
        end
        DrawLines2(points, size2 or 1, color2 or 4294967295)
    end
end

function TargetPredictionVIP:GetCollision(target)
    assert(self.Spell.Width and self.Spell.Width >= 0, "SpellWidth needed for MinionCollision detection")
    if not self.MinionManager then self.MinionManager = minionManager(MINION_ENEMY, math.sqrt(self.Spell.RangeSqr) + 300) end
    local prediction, hitTime, enhPrediction = self:GetPrediction(target)
    if self.Cache[target.networkID].Collision then return self.Cache[target.networkID].Collision end
    prediction = enhPrediction or prediction
    if not prediction then return false end
    local o = { x = -(prediction.z - self.Spell.Source.z), y = prediction.x - self.Spell.Source.x }
    local len = math.sqrt(o.x ^ 2 + o.y ^ 2)
    local minionHitBoxRadius = 100
    o.x, o.y = ((self.Spell.Width / 2) + minionHitBoxRadius) * o.x / len, ((self.Spell.Width / 2) + minionHitBoxRadius) * o.y / len
    local spellBorder = {
        D3DXVECTOR2(self.Spell.Source.x + o.x, self.Spell.Source.z + o.y),
        D3DXVECTOR2(self.Spell.Source.x - o.x, self.Spell.Source.z - o.y),
        D3DXVECTOR2(prediction.x - o.x, prediction.z - o.y),
        D3DXVECTOR2(prediction.x + o.x, prediction.z + o.y),
        D3DXVECTOR2(self.Spell.Source.x + o.x, self.Spell.Source.z + o.y),
    }
    self.MinionManager:update()
    for index, minion in pairs(self.MinionManager.objects) do
        local wayPoints = self.WayPointManager:GetSimulatedWayPoints(minion, self.Spell.Delay + GetLatency() / 2000, self.Spell.Delay + GetLatency() / 2000 + hitTime + 1)
        if wayPoints and #wayPoints > 0 then
            local function getSpellHitTime(position)
                local pointSegment, pointLine, isOnSegment = VectorPointProjectionOnLineSegment(self.Spell.Source, prediction, position)
                return isOnSegment and GetDistanceSqr(pointLine, position) < (self.Spell.Width / 2) ^ 2, GetDistance(self.Spell.Source, pointLine) / self.Spell.Speed
            end

            local absTimeTravelled = 0
            for i = 1, #wayPoints - 1 do
                local A, B = wayPoints[i], wayPoints[i + 1]
                local minionIn, minionOut, minSpellT, maxSpellT = math.huge, -math.huge, math.huge, -math.huge
                local isInRect, hitStartT = getSpellHitTime(A) -- If minion starts in occupied area
                if isInRect then
                    minionIn, minionOut = math.min(minionIn, absTimeTravelled), math.max(minionOut, absTimeTravelled)
                    minSpellT, maxSpellT = math.min(hitStartT, minSpellT), math.max(hitStartT, maxSpellT)
                end
                for i = 1, #spellBorder - 1 do
                    local C, D = spellBorder[i], spellBorder[i + 1]
                    local intersection = LineSegmentIntersection(A, B, C, D)
                    if intersection then
                        local cTimeTravelled = absTimeTravelled + GetDistance(A, intersection) / minion.ms
                        local isInRect, hitMinionT = getSpellHitTime(intersection)
                        minionIn, minionOut = math.min(minionIn, cTimeTravelled), math.max(minionOut, cTimeTravelled)
                        minSpellT, maxSpellT = math.min(hitMinionT, minSpellT), math.max(hitMinionT, maxSpellT)
                    end
                end

                if not (minionIn > maxSpellT or minSpellT > minionOut) then
                    self.Cache[target.networkID].Collision = true
                    return true
                end
                absTimeTravelled = absTimeTravelled + GetDistance(A, B) / minion.ms
            end
            local isInRect, hitEndT = getSpellHitTime(wayPoints[#wayPoints]) -- If minion ends his movement in occupied area
            if isInRect and hitEndT < hitTime then
                self.Cache[target.networkID].Collision = true
                return true
            end
        end
    end

    self.Cache[target.networkID].Collision = false
    return false
end

-- TargetPrediction Class
--[[
    Methods:
        tp = TargetPrediction(range, proj_speed, delay, widthCollision, smoothness)
    Functions :
        tp:GetPrediction(target)            -- return nextPosition, minionCollision, nextHealth
    members :
        tp.nextPosition                     -- vector pos
        tp.minions
        tp.nextHealth
        tp.range
        tp.proj_speed
        tp.delay
        tp.width
        tp.smoothness
]]
-- use _gameHeroes with TargetSelector
local _TargetPrediction__tick = 0
local __TargetPrediction__OnTick
local function TargetPrediction__Onload()
    if not __TargetPrediction__OnTick then
        function __TargetPrediction__OnTick()
            local osTime = os.clock()
            if osTime - _TargetPrediction__tick > 0 then
                _TargetPrediction__tick = osTime
                for _, _enemyHero in ipairs(_gameHeroes) do
                    local hero = _enemyHero.hero
                    if hero.dead then
                        _enemyHero.prediction = nil
                    elseif hero.visible then
                        if _enemyHero.prediction then
                            local deltaTime = osTime - _enemyHero.prediction.lastUpdate
                            _enemyHero.prediction.movement = (Vector(hero) - _enemyHero.prediction.position) / deltaTime
                            _enemyHero.prediction.healthDifference = (hero.health - _enemyHero.prediction.health) / deltaTime
                            _enemyHero.prediction.health = hero.health
                            _enemyHero.prediction.position = Vector(hero)
                            _enemyHero.prediction.lastUpdate = osTime
                        else
                            _enemyHero.prediction = { position = Vector(hero), lastUpdate = osTime, minions = false, health = hero.health }
                        end
                    end
                end
            end
        end

        AddTickCallback(__TargetPrediction__OnTick)
    end
end

class'TargetPrediction'
function TargetPrediction:__init(range, proj_speed, delay, widthCollision, smoothness)
    assert(type(range) == "number", "TargetPrediction: wrong argument types (<number> expected for range)")
    _gameHeroes__init()
    TargetPrediction__Onload()
    self.range = range or 0
    self.proj_speed = proj_speed or math.huge
    assert(type(proj_speed) == "number" and proj_speed > 0, "TargetPrediction: Projectile Speed must be a positive number, is "..(type(proj_speed)=="number" and tostring(proj_speed) or type(proj_speed)))
    self.proj_speed = self.proj_speed > 100 and self.proj_speed or self.proj_speed * 1000
    self.delay = delay or 0
    self.delay = self.delay >= 30 and self.delay / 1000 or self.delay
    self.width = widthCollision
    self.smoothness = smoothness
    if self.width then
        self.minionTable = minionManager(MINION_ENEMY, self.range + 300)
    end
end

function TargetPrediction:SetMinionCollisionType(minionType)
    if minionType then
        self.minionTable = minionManager(minionType, self.range + 300)
    else
        self.minionTable = nil
    end
end

function TargetPrediction:GetPrediction(target)
    assert(target ~= nil, "GetPrediction: wrong argument types (<target> expected)")
    local index = _gameHeroes__index(target, "GetPrediction")
    if not index then return end
    local selected = _gameHeroes[index].hero
    if self.minionTable then self.minionTable:update() end
    if _gameHeroes[index].prediction and _gameHeroes[index].prediction.movement then
        if index ~= self.target then
            self.nextPosition = nil
            self.target = index
        end
        local osTime = os.clock()
        local delay = self.delay  + (GetLatency()or 0)/1000
        if GetDistanceSqr(selected) < (self.range + 300) ^ 2 then
            if osTime - (_gameHeroes[index].prediction.calculateTime or 0) > 0 then
                local delT, enemyPos, PositionPrediction
                if selected.visible then
                    enemyPos = Vector(selected)
                    delT = delay
                elseif osTime - _gameHeroes[index].prediction.lastUpdate < 3 then
                    enemyPos = _gameHeroes[index].prediction.position
                    delT = delay + osTime - _gameHeroes[index].prediction.lastUpdate
                else 
                    _gameHeroes[index].prediction = nil 
                    return
                end
                local t1, p1, t2, p2 =  VectorMovementCollision(enemyPos, enemyPos+_gameHeroes[index].prediction.movement, target.ms, player, self.proj_speed, delT)
                t1, t2 = (t1 and 0 <= t1) and t1 or nil, (t2 and 0 <= t2) and t2 or nil
                local t = t1 and t2 and math.min(t1,t2) or t1 or t2
                if t then
                    PositionPrediction = t==t1 and Vector(p1.x, enemyPos.y, p1.y) or Vector(p2.x, enemyPos.y, p2.y)
                    if self.smoothness and self.smoothness < 100 and self.nextPosition then
                        self.nextPosition = (PositionPrediction * ((100 - self.smoothness) / 100)) + (self.nextPosition * (self.smoothness / 100))
                    else
                        self.nextPosition = PositionPrediction:clone()
                    end
                    if GetDistanceSqr(PositionPrediction) < (self.range) ^ 2 then
                        --update next Health
                        self.nextHealth = selected.health + (_gameHeroes[index].prediction.healthDifference or selected.health) * (t + delay)
                        --update minions collision
                        self.minions = false
                        if self.width and self.minionTable then
                            self.minions = GetMinionCollision(player, PositionPrediction, self.width, self.minionTable.objects)
                        end
                    else 
                        return
                    end 
                else
                    return
                end
            end
            return self.nextPosition, self.minions, self.nextHealth
        end
    end
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Game Values
--[[
    _game.map
    _game.settings
]]
local _game, _game_init = { lastCmd = GAME_PATH .. "lastCmd.log" }, true

local _onGameOver, __game__OnCreateObj, __game__GameOver = {}, nil, nil
function GetGame()
    if _game_init then
        _game_init = nil
        -- init values
        local _gameSave = GetSave("lastGame")
        local cmdStr = ReadFile(_game.lastCmd)
        if cmdStr then
            local cmdArray = cmdStr:split("\" \"")
            if #cmdArray == 4 then
                _game.pid = cmdArray[1]:sub(2)
                _game.launcher = cmdArray[2]
                _game.client = cmdArray[3]
                _game.params = cmdArray[4]:sub(1, cmdArray[4]:find("\"") - 1)
                local paramArray = _game.params:split(" ")
                if paramArray[1] ~= "spectator" then
                    _game.server = paramArray[1]
                    _game.port = paramArray[2]
                    _game.key = paramArray[3]
                    _game.id = paramArray[4]
                end
            end
        end
        UpdateWindow()
        _game.WINDOW_W = tonumber(WINDOW_W ~= nil and WINDOW_W or 0)
        _game.WINDOW_H = tonumber(WINDOW_H ~= nil and WINDOW_H or 0)
        _game.settings = GetGameSettings()
        if _game.WINDOW_W == 0 or _game.WINDOW_H == 0 then
            if _game.settings.General then
                _game.WINDOW_W = _game.settings.General.Width or 0
                _game.WINDOW_H = _game.settings.General.Height or 0
            end
        end
        _game.tick = tonumber(GetTickCount())
        _game.osTime = os.time()
        if _gameSave and _gameSave.params and _gameSave.params == _game.params then
            _game.WINDOW_W = _gameSave.WINDOW_W
            _game.WINDOW_H = _gameSave.WINDOW_H
            _game.tick = _gameSave.tick
            _game.osTime = _gameSave.osTime
        else
            _gameSave.params = _game.params
            _gameSave.osTime = _game.osTime
            _gameSave.WINDOW_W = _game.WINDOW_W
            _gameSave.WINDOW_H = _game.WINDOW_H
            _gameSave.tick = _game.tick
            _gameSave:Save()
        end
        _game.map = { index = 0, name = "unknown", shortName = "unknown", min = { x = 0, y = 0 }, max = { x = 0, y = 0 }, x = 0, y = 0, grid = { width = 0, height = 0 } }
        for i = 1, objManager.maxObjects do
            local object = objManager:getObject(i)
            if object ~= nil and object.valid then
                if object.type == "obj_Shop" and object.team == TEAM_BLUE then
                    if math.floor(object.x) == -175 and math.floor(object.y) == 163 and math.floor(object.z) == 1056 then
                        _game.map = { index = 1, name = "Summoner's Rift", shortName = "summonerRift", min = { x = -538, y = -165 }, max = { x = 14279, y = 14527 }, x = 14817, y = 14692, grid = { width = 13982 / 2, height = 14446 / 2 } }
                        break
                    elseif math.floor(object.x) == -217 and math.floor(object.y) == 276 and math.floor(object.z) == 7039 then
                        _game.map = { index = 4, name = "The Twisted Treeline", shortName = "twistedTreeline", min = { x = -996, y = -1239 }, max = { x = 14120, y = 13877 }, x = 15116, y = 15116, grid = { width = 15436 / 2, height = 14474 / 2 } }
                        break
                    elseif math.floor(object.x) == 556 and math.floor(object.y) == 191 and math.floor(object.z) == 1887 then
                        _game.map = { index = 7, name = "The Proving Grounds", shortName = "provingGrounds", min = { x = -56, y = -38 }, max = { x = 12820, y = 12839 }, x = 12876, y = 12877, grid = { width = 12948 / 2, height = 12812 / 2 } }
                        break
                    elseif math.floor(object.x) == 16 and math.floor(object.y) == 168 and math.floor(object.z) == 4452 then
                        _game.map = { index = 8, name = "The Crystal Scar", shortName = "crystalScar", min = { x = -15, y = 0 }, max = { x = 13911, y = 13703 }, x = 13926, y = 13703, grid = { width = 13894 / 2, height = 13218 / 2 } }
                        break
                    elseif math.floor(object.x) == 1313 and math.floor(object.y) == 123 and math.floor(object.z) == 8005 then
                        _game.map = { index = 10, name = "The Twisted Treeline Beta", shortName = "twistedTreeline", min = { x = 0, y = 0 }, max = { x = 15398, y = 15398 }, x = 15398, y = 15398, grid = { width = 15416 / 2, height = 14454 / 2 } }
                        break
                    elseif math.floor(object.x) == 497 and math.floor(object.y) == -40 and math.floor(object.z) == 1932 then
                        _game.map = { index = 12, name = "Howling Abyss", shortName = "howlingAbyss", min = { x = -56, y = -38 }, max = { x = 12820, y = 12839 }, x = 12876, y = 12877, grid = { width = 13120 / 2, height = 12618 / 2 } }
                        break
                    else
                        PrintChat("New map : x = " .. math.floor(object.x) .. " - y = " .. math.floor(object.y) .. " - z = " .. math.floor(object.z))
                    end
                end
            end
        end
        --update game state
        function __game__GameOver(team)
            _game.isOver = true
            _game.loser = team
            _game.winner = (team == TEAM_BLUE and TEAM_RED or TEAM_BLUE)
            _game.win = (player.team == _game.winner)
            for _, func in ipairs(_onGameOver) do
                if func then func(_game.winner) end
            end
        end

        function __game__OnCreateObj(object)
            if object then
                if object.name == "NexusDestroyedExplosionFinal_Chaos.troy" or object.name == "NexusDestroyedExplosion_Chaos.troy" or object.name == "NexusDestroyedExplosion_Chaos2.troy" or object.name == "Odin_CrystalExplosion_Purple.troy" then
                    __game__GameOver(TEAM_RED)
                elseif object.name == "NexusDestroyedExplosionFinal_Order.troy" or object.name == "NexusDestroyedExplosion_Order.troy" or object.name == "NexusDestroyedExplosion_Order2.troy" or object.name == "Odin_CrystalExplosion_Blue.troy" then
                    __game__GameOver(TEAM_BLUE)
                end
            end
        end

        AddCreateObjCallback(__game__OnCreateObj)
        --clean
        _game.lastCmd = nil
    end
    return _game
end

function AddGameOverCallback(func)
    assert(type(func) == "function", "AddGameOverCallback: Expected function, got " .. type(func))
    if _game_init then GetGame() end
    table.insert(_onGameOver, func)
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- minionManager
--[[
        minionManager Class :
    Methods:
        minionArray = minionManager(mode, range, fromPos, sortMode)     --return a minionArray instance
    Functions :
        minionArray:update()                -- update the minionArray instance
    Members:
        minionArray.objects                 -- minionArray objects table
        minionArray.iCount                  -- minionArray objects count
        minionArray.mode                    -- minionArray instance mode (MINION_ALL, etc)
        minionArray.range                   -- minionArray instance range
        minionArray.fromPos                 -- minionArray instance x, z from which the range is based (player by default)
        minionArray.sortMode                -- minionArray instance sort mode (MINION_SORT_HEALTH_ASC, etc... or nil if no sorted)
    Usage ex:
        function OnLoad()
            enemyMinions = minionManager(MINION_ENEMY, 600, player, MINION_SORT_HEALTH_ASC)
            allyMinions = minionManager(MINION_ALLY, 300, player, MINION_SORT_HEALTH_DES)
        end
        function OnTick()
            enemyMinions:update()
            allyMinions:update()
            for index, minion in pairs(enemyMinions.objects) do
                -- what you want
            end
            -- ex changing range
            enemyMinions.range = 250
            enemyMinions:update() --not needed
        end
]]
local _minionTable = { {}, {}, {}, {}, {} }
local _minionManager = { init = true, tick = 0, ally = "##", enemy = "##" }
-- Class related constants
MINION_ALL = 1
MINION_ENEMY = 2
MINION_ALLY = 3
MINION_JUNGLE = 4
MINION_OTHER = 5
MINION_SORT_HEALTH_ASC = function(a, b) return a.health < b.health end
MINION_SORT_HEALTH_DEC = function(a, b) return a.health > b.health end
MINION_SORT_MAXHEALTH_ASC = function(a, b) return a.maxHealth < b.maxHealth end
MINION_SORT_MAXHEALTH_DEC = function(a, b) return a.maxHealth > b.maxHealth end
MINION_SORT_AD_ASC = function(a, b) return a.ad < b.ad end
MINION_SORT_AD_DEC = function(a, b) return a.ad > b.ad end
local __minionManager__OnCreateObj
local function minionManager__OnLoad()
    if _minionManager.init then
        local mapIndex = GetGame().map.index
        if mapIndex ~= 4 then
            _minionManager.ally = "Minion_T" .. player.team
            _minionManager.enemy = "Minion_T" .. TEAM_ENEMY
        else
            _minionManager.ally = (player.team == TEAM_BLUE and "Blue" or "Red")
            _minionManager.enemy = (player.team == TEAM_BLUE and "Red" or "Blue")
        end
        if not __minionManager__OnCreateObj then
            function __minionManager__OnCreateObj(object)
                if object and object.valid and object.type == "obj_AI_Minion" then
                    DelayAction(function(object)
                        if object and object.valid and object.type == "obj_AI_Minion" and object.name and not object.dead then
                            local name = object.name
                            table.insert(_minionTable[MINION_ALL], object)
                            if name:sub(1, #_minionManager.ally) == _minionManager.ally then table.insert(_minionTable[MINION_ALLY], object)
                            elseif name:sub(1, #_minionManager.enemy) == _minionManager.enemy then table.insert(_minionTable[MINION_ENEMY], object)
                            elseif object.team == TEAM_NEUTRAL then table.insert(_minionTable[MINION_JUNGLE], object)
                            else table.insert(_minionTable[MINION_OTHER], object)
                            end
                        end
                    end, 0, { object })
                end
            end

            AddCreateObjCallback(__minionManager__OnCreateObj)
        end
        for i = 1, objManager.maxObjects do
            __minionManager__OnCreateObj(objManager:getObject(i))
        end
        _minionManager.init = nil
    end
end

class'minionManager'
function minionManager:__init(mode, range, fromPos, sortMode)
    assert(type(mode) == "number" and type(range) == "number", "minionManager: wrong argument types (<mode>, <number> expected)")
    minionManager__OnLoad()
    self.mode = mode
    self.range = range
    self.fromPos = fromPos or player
    self.sortMode = type(sortMode) == "function" and sortMode
    self.objects = {}
    self.iCount = 0
    self:update()
end

function minionManager:update()
    self.objects = {}
    for _, object in pairs(_minionTable[self.mode]) do
        if object and object.valid and not object.dead and object.visible and GetDistanceSqr(self.fromPos, object) <= (self.range) ^ 2 then
            table.insert(self.objects, object)
        end
    end
    if self.sortMode then table.sort(self.objects, self.sortMode) end
    self.iCount = #self.objects
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Inventory
--[[
    Goblal Function :
    CastItem(itemID)                    -- Cast item
    CastItem(itemID, hero)              -- Cast item on hero
    CastItem(itemID, x, z)              -- Cast item on pos x,z
    GetInventorySlotItem(itemID)        -- return the slot or nil
    GetInventoryHaveItem(itemID)        -- return true/false
    GetInventorySlotIsEmpty(slot)       -- return true/false
    GetInventoryItemIsCastable(itemID)  -- return true/false
    InShop()                            -- return true/false, x, y, z, range
]]
function GetInventorySlotItem(itemID, target)
    assert(type(itemID) == "number", "GetInventorySlotItem: wrong argument types (<number> expected)")
    local target = target or player
    for _, j in pairs({ ITEM_1, ITEM_2, ITEM_3, ITEM_4, ITEM_5, ITEM_6, ITEM_7 }) do
        if target:getInventorySlot(j) == itemID then return j end
    end
    return nil
end

function GetInventoryHaveItem(itemID, target)
    assert(type(itemID) == "number", "GetInventoryHaveItem: wrong argument types (<number> expected)")
    local target = target or player
    return (GetInventorySlotItem(itemID, target) ~= nil)
end

function GetInventorySlotIsEmpty(slot, target)
    local target = target or player
    return (target:getInventorySlot(slot) == 0)
end

function GetInventoryItemIsCastable(itemID, target)
    assert(type(itemID) == "number", "GetInventoryItemIsCastable: wrong argument types (<number> expected)")
    local target = target or player
    local slot = GetInventorySlotItem(itemID, target)
    if slot == nil then return false end
    return (target:CanUseSpell(slot) == READY)
end

function CastItem(itemID, var1, var2)
    assert(type(itemID) == "number", "CastItem: wrong argument types (<number> expected)")
    local slot = GetInventorySlotItem(itemID)
    if slot == nil then return false end
    if (player:CanUseSpell(slot) == READY) then
        if (var2 ~= nil) then CastSpell(slot, var1, var2)
        elseif (var1 ~= nil) then CastSpell(slot, var1)
        else CastSpell(slot)
        end
        return true
    end
    return false
end

-- Shop
--[[
]]
local _shop
local _shopRadius = 1250
function GetShop()
    if _shop ~= nil then return _shop end
    for i = 1, objManager.maxObjects, 1 do
        local object = objManager:getObject(i)
        if object and object.type == "obj_Shop" and object.team == player.team then
            _shop = Vector(object)
            return _shop
        end
    end
end

function NearShop(distance)
    assert(distance == nil or type(distance) == "number", "NearShop: wrong argument types (<number> or nil expected)")
    assert(GetShop() ~= nil, "GetShop: Could not get Shop Coordinates")
    return (GetDistanceSqr(GetShop()) < (distance or _shopRadius) ^ 2), _shop.x, _shop.y, _shop.z, (distance or _shopRadius)
end

function InShop()
    return NearShop()
end

-- Fountain
--[[
]]
local _fountain
local _fountainRadius = 750
function GetFountain()
    if _fountain ~= nil then return _fountain end
    if GetGame().map.index == 1 then
        _fountainRadius = 1050
    end
    if GetShop() ~= nil then
        for i = 1, objManager.maxObjects, 1 do
            local object = objManager:getObject(i)
            if object ~= nil and object.type == "obj_SpawnPoint" and GetDistanceSqr(_shop, object) < 1000000 then
                _fountain = Vector(object)
                return _fountain
            end
        end
    end
end

function NearFountain(distance)
    distance = distance or _fountainRadius or 0
	if GetFountain() then
		return (GetDistanceSqr(_fountain) <= distance * distance), _fountain.x, _fountain.y, _fountain.z, distance
	else
		return false, 0, 0, 0, 0
	end
end

function InFountain()
    return NearFountain()
end

-- Turrets
--[[
]]
local _turrets, __turrets__OnTick
local function __Turrets__init()
    if _turrets == nil then
        _turrets = {}
        local turretRange = 950
        local fountainRange = 1050
        local visibilityRange = 1300
        for i = 1, objManager.maxObjects do
            local object = objManager:getObject(i)
            if object ~= nil and object.type == "obj_AI_Turret" then
                local turretName = object.name
                _turrets[turretName] = {
                    object = object,
                    team = object.team,
                    range = turretRange,
                    visibilityRange = visibilityRange,
                    x = object.x,
                    y = object.y,
                    z = object.z,
                }
                if turretName == "Turret_OrderTurretShrine_A" or turretName == "Turret_ChaosTurretShrine_A" then
                    _turrets[turretName].range = fountainRange
                    for j = 1, objManager.maxObjects do
                        local object2 = objManager:getObject(j)
                        if object2 ~= nil and object2.type == "obj_SpawnPoint" and GetDistanceSqr(object, object2) < 1000000 then
                            _turrets[turretName].x = object2.x
                            _turrets[turretName].z = object2.z
                        elseif object2 ~= nil and object2.type == "obj_HQ" and object2.team == object.team then
                            _turrets[turretName].y = object2.y
                        end
                    end
                end
            end
        end
        function __turrets__OnTick()
            for name, turret in pairs(_turrets) do
                if turret.object.valid == false or turret.object.dead or turret.object.health == 0 then
                    _turrets[name] = nil
                end
            end
        end

        AddTickCallback(__turrets__OnTick)
    end
end

function GetTurrets()
    __Turrets__init()
    return _turrets
end

function GetUnderTurret(pos, enemyTurret)
    __Turrets__init()
    local enemyTurret = (enemyTurret ~= false)
    for _, turret in pairs(_turrets) do
        if turret ~= nil and (turret.team ~= player.team) == enemyTurret and GetDistanceSqr(turret, pos) <= (turret.range) ^ 2 then
            return turret
        end
    end
end

function UnderTurret(pos, enemyTurret)
    return (GetUnderTurret(pos, enemyTurret) ~= nil)
end

--Spawn
local _allySpawn
function GetSpawnPos()
    if not _allySpawn then
        for i = 1, objManager.maxObjects, 1 do
            local object = objManager:getObject(i)
            if object and object.valid and object.type == "obj_SpawnPoint" and object.team == player.team then
                _allySpawn = Vector(object.x, object.y, object.z)
                return _allySpawn
            end
        end
    end
    return _allySpawn
end

local _enemySpawn
function GetEnemySpawnPos()
    if not _enemySpawn then
        for i = 1, objManager.maxObjects, 1 do
            local object = objManager:getObject(i)
            if object and object.valid and object.type == "obj_SpawnPoint" and object.team == TEAM_ENEMY then
                _enemySpawn = Vector(object.x, object.y, object.z)
                return _enemySpawn
            end
        end
    end
    return _enemySpawn
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Class : ChampionLane
--[[
    Method :
        CL = ChampionLane()
    Functions :
        CL:GetMyLane()          -- return lane name
        CL:GetPoint(lane)           -- return the 3D point of the center of the lane
        CL:GetHeroCount(lane)       -- return number of enemy hero in lane
        CL:GetHeroCount(lane, team) -- return number of team hero in lane ("ally", "enemy")
        CL:GetHeroArray(lane)   -- return the array of enemy hero objects in lane
        CL:GetHeroArray(lane, team) -- return the array of team hero objects in lane
        CL:GetCarryAD()         -- return the object of the enemy Carry Ad or nil
        CL:GetCarryAD(team)     -- return the object of the team Carry Ad or nil
        CL:GetSupport()         -- return the object of the enemy support or nil
        CL:GetSupport(team)     -- return the object of the team support or nil
        CL:GetJungler()         -- return the object of the enemy jungler or nil
        CL:GetJungler(team)     -- return the object of the team jungler or nil
]]

-- init values
local __ChampionLane__OnTick, __ChampionLane_init = nil, true

class'ChampionLane'
function ChampionLane:__init()
    if __ChampionLane_init then
        __ChampionLane_init = nil
        local _championLane = GetSave("championLane")
        if _championLane.params ~= GetGame().params then _championLane:Clear() end
        if _championLane:IsEmpty() then
            table.merge(_championLane, { enemy = { champions = {}, top = {}, mid = {}, bot = {}, jungle = {}, unknown = {} }, ally = { champions = {}, top = {}, mid = {}, bot = {}, jungle = {}, unknown = {} }, myLane = "unknown", nextUpdate = 0, tickUpdate = 0.250, params = GetGame().params })
            _championLane.mapIndex = GetGame().map.index
            for i = 1, heroManager.iCount, 1 do
                local hero = heroManager:getHero(i)
                if hero ~= nil and hero.valid then
                    local isJungler = (string.find(hero:GetSpellData(SUMMONER_1).name .. hero:GetSpellData(SUMMONER_2).name, "Smite") and true or false)
                    if not _championLane["enemy"] then _championLane["enemy"] = { champions = {} } end
                    if not _championLane["ally"] then _championLane["ally"] = { champions = {} } end
                    table.insert(_championLane[(hero.team == player.team and "ally" or "enemy")].champions, { hero = hero, top = 0, mid = 0, bot = 0, jungle = 0, isJungler = isJungler })
                    if isJungler then
                        _championLane[(hero.team == player.team and "ally" or "enemy")].jungler = hero
                    end
                end
            end
            if _championLane.mapIndex == 1 or _championLane.mapIndex == 2 then
                _championLane.startTime = 120 --2 min from start
                _championLane.stopTime = 600 --10 min from start
                if _championLane.mapIndex == 1 then
                    _championLane.top = { point = { x = 1900, y = 0, z = 12600 } }
                    _championLane.mid = { point = { x = 7100, y = 0, z = 7100 } }
                    _championLane.bot = { point = { x = 12100, y = 0, z = 2100 } }
                elseif _championLane.mapIndex == 2 then
                    _championLane.top = { point = { x = 6700, y = 0, z = 7100 } }
                    _championLane.bot = { point = { x = 6700, y = 0, z = 3100 } }
                end
            end
        end
        if not __ChampionLane__OnTick then
            function __ChampionLane__OnTick()
                local _championLane = GetSave("championLane")
                if not _championLane.startTime then return end
                local tick = GetInGameTimer()
                if tick < _championLane.startTime or tick < _championLane.nextUpdate then return end
                if tick > _championLane.stopTime then _championLane.startTime = nil return end
                _championLane.nextUpdate = GetInGameTimer() + _championLane.tickUpdate
                -- team update
                for _, team in pairs({ "ally", "enemy" }) do
                    local update = { top = {}, mid = {}, bot = {}, jungle = {}, unknown = {} }
                    for _, champion in pairs(_championLane[team].champions) do
                        -- update champ pos
                        if (champion.hero ~= nil and champion.hero.dead == false) then
                            if champion.hero.visible then
                                if GetDistanceSqr(_championLane.top.point, champion.hero) < 4000000 then champion.top = champion.top + 10 end
                                if _championLane.mid ~= nil and GetDistanceSqr(_championLane.mid.point, champion.hero) < 4000000 then champion.mid = champion.mid + 10 end
                                if GetDistanceSqr(_championLane.bot.point, champion.hero) < 4000000 then champion.bot = champion.bot + 10 end
                            else
                                champion.jungle = champion.jungle + 1
                            end
                            if champion.isJungler then champion.jungle = champion.jungle + 5 end
                        end
                        local lane
                        if champion.top > champion.mid and champion.top > champion.bot and champion.top > champion.jungle then lane = "top"
                        elseif champion.mid > champion.bot and champion.mid > champion.jungle then lane = "mid"
                        elseif champion.bot > champion.jungle then lane = "bot"
                        elseif champion.jungle > 0 then lane = "jungle"
                        else lane = "unknown"
                        end
                        table.insert(update[lane], champion.hero)
                        if (champion.hero ~= nil and champion.hero.networkID == player.networkID) then
                            _championLane.myLane = lane
                        end
                    end
                    _championLane[team].top = update.top
                    _championLane[team].mid = update.mid
                    _championLane[team].bot = update.bot
                    _championLane[team].jungle = update.jungle
                    -- update jungler if needed
                    if _championLane[team].jungler == nil and #_championLane[team].jungle == 1 then
                        _championLane[team].jungler = _championLane[team].jungle[1]
                    end
                    if _championLane.mapIndex == 1 then
                        -- update carry / support
                        local carryAD, support
                        for _, hero in pairs(_championLane[team].bot) do
                            if carryAD == nil or hero.totalDamage > carryAD.totalDamage then carryAD = hero end
                            if support == nil or hero.totalDamage < support.totalDamage then support = hero end
                        end
                        _championLane[team].carryAD = carryAD
                        _championLane[team].support = support
                    end
                end
            end

            AddTickCallback(__ChampionLane__OnTick)
        end
    end
end

function ChampionLane:GetPoint(lane)
    assert(type(lane) == "string" and (lane == "top" or lane == "bot" or lane == "mid"), "GetPoint: wrong argument types (<lane> expected)")
    return GetSave("championLane")[lane].point
end

function ChampionLane:GetMyLane()
    return GetSave("championLane").myLane
end

function ChampionLane:GetHeroCount(lane, team)
    local team = team or "enemy"
    assert(type(lane) == "string" and (lane == "top" or lane == "bot" or lane == "mid" or lane == "jungle") and type(team) == "string" and (team == "enemy" or team == "ally"), "GetHeroCount: wrong argument types (<lane>, <team> expected)")
    return #(GetSave("championLane")[team][lane])
end

function ChampionLane:GetHeroArray(lane, team)
    local team = team or "enemy"
    assert(type(lane) == "string" and (lane == "top" or lane == "bot" or lane == "mid" or lane == "jungle") and type(team) == "string" and (team == "enemy" or team == "ally"), "GetHeroArray: wrong argument types (<lane>, <team> expected)")
    return GetSave("championLane")[team][lane]
end

function ChampionLane:GetCarryAD(team)
    local team = team or "enemy"
    assert(type(team) == "string" and (team == "enemy" or team == "ally"), "GetCarryAD: wrong argument types (<team> or nil expected)")
    return GetSave("championLane")[team].carryAD
end

function ChampionLane:GetSupport(team)
    local team = team or "enemy"
    assert(type(team) == "string" and (team == "enemy" or team == "ally"), "GetSupport: wrong argument types (<team> or nil expected)")
    return GetSave("championLane")[team].support
end

function ChampionLane:GetJungler(team)
    local team = team or "enemy"
    assert(type(team) == "string" and (team == "enemy" or team == "ally"), "GetJungler: wrong argument types (<team> or nil expected)")
    return GetSave("championLane")[team].jungler
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- minimap
--[[
    Goblal Function :
        GetMinimapX(x)                  -- Return x minimap value
        GetMinimapY(y)                  -- Return y minimap value
        GetMinimap(v)                   -- Get minimap point {x, y} from object
        GetMinimap(x, y)                -- Get minimap point {x, y}
]]
local _miniMap, _miniMap__Reset = { init = true }, nil
local function _miniMap__OnLoad()
    if _miniMap.init then
        function _miniMap__Reset()
            local minimapRatio, minimapFlip, windowWidth, windowHeight = 1, false, WINDOW_W, WINDOW_H
            local gameSettings = GetGameSettings()
            if gameSettings and gameSettings.General and gameSettings.General.Width and gameSettings.General.Height then
                windowWidth, windowHeight = gameSettings.General.Width, gameSettings.General.Height
                local path = GAME_PATH .. "DATA\\menu\\hud\\hud" .. windowWidth .. "x" .. windowHeight .. ".ini"
                local hudSettings = ReadIni(path)
                if hudSettings and hudSettings.Globals and hudSettings.Globals.MinimapScale then
                    minimapRatio = (windowHeight / 1080) * hudSettings.Globals.MinimapScale
                else
                    minimapRatio = (windowHeight / 1080)
                end
                minimapFlip = (gameSettings.HUD and gameSettings.HUD.FlipMiniMap and gameSettings.HUD.FlipMiniMap == 1)
            end
            local map = GetGame().map
            _miniMap.step = { x = 265 * minimapRatio / map.x, y = -264 * minimapRatio / map.y }
            if minimapFlip then
                _miniMap.x = 5 * minimapRatio - _miniMap.step.x * map.min.x
            else
                _miniMap.x = windowWidth - 270 * minimapRatio - _miniMap.step.x * map.min.x
            end
            _miniMap.y = windowHeight - 8 * minimapRatio - _miniMap.step.y * map.min.y
        end

        _miniMap__Reset()
        AddResetCallback(_miniMap__Reset)
        _miniMap.init = nil
    end
    return _miniMap.init
end

function GetMinimapX(x)
    assert(type(x) == "number", "GetMinimapX: wrong argument types (<number> expected for x)")
    return (_miniMap__OnLoad() and -100 or _miniMap.x + _miniMap.step.x * x)
end

function GetMinimapY(y)
    assert(type(y) == "number", "GetMinimapY: wrong argument types (<number> expected for y)")
    return (_miniMap__OnLoad() and -100 or _miniMap.y + _miniMap.step.y * y)
end

function GetMinimap(a, b)
    local x, y
    if b == nil then
        if VectorType(a) then
            x, y = a.x, a.z
        else
            assert(type(a.x) == "number" and type(a.y) == "number", "GetMinimap: wrong argument types (<vector> expected, or <number>, <number>)")
            x, y = a.x, a.y
        end
    else
        assert(type(a) == "number" and type(b) == "number", "GetMinimap: wrong argument types (<vector> expected, or <number>, <number> for x, y)")
        x, y = a, b
    end
    return { x = GetMinimapX(x), y = GetMinimapY(y) }
end

--  autoLevel
--[[
autoLevelSetSequence(sequence)  -- set the sequence
autoLevelSetFunction(func)      -- set the function used if sequence level == 0
    Usage :
        On your script :
        Set the levelSequence :
            local levelSequence = {1,nil,0,1,1,4,1,nil,1,nil,4,nil,nil,nil,nil,4,nil,nil}
            autoLevelSetSequence(levelSequence)
                The levelSequence is table of 18 fields
                1-4 = spell 1 to 4
                nil = will not auto level on this one
                0 = will use your own function for this one, that return a number between 1-4
        Set the function if you use 0, example :
            local onChoiceFunction = function()
                if player:GetSpellData(SPELL_2).level < player:GetSpellData(SPELL_3).level then
                    return 2
                else
                    return 3
                end
            end
            autoLevelSetFunction(onChoiceFunction)
]]
local _autoLevel = { spellsSlots = { SPELL_1, SPELL_2, SPELL_3, SPELL_4 }, levelSequence = {}, nextUpdate = 0, tickUpdate = 500 }
local __autoLevel__OnTick
local function autoLevel__OnLoad()
    if not __autoLevel__OnTick then
        function __autoLevel__OnTick()
            local tick = GetTickCount()
            if _autoLevel.nextUpdate > tick then return end
            _autoLevel.nextUpdate = tick + _autoLevel.tickUpdate
            local realLevel = GetHeroLeveled()
            if player.level > realLevel and _autoLevel.levelSequence[realLevel + 1] ~= nil then
                local splell = _autoLevel.levelSequence[realLevel + 1]
                if splell == 0 and type(_autoLevel.onChoiceFunction) == "function" then splell = _autoLevel.onChoiceFunction() end
                if type(splell) == "number" and splell >= 1 and splell <= 4 then LevelSpell(_autoLevel.spellsSlots[splell]) end
            end
        end

        AddTickCallback(__autoLevel__OnTick)
    end
end

function autoLevelSetSequence(sequence)
    assert(sequence == nil or type(sequence) == "table", "autoLevelSetSequence : wrong argument types (<table> or nil expected)")
    autoLevel__OnLoad()
    local sequence = sequence or {}
    for i = 1, 18 do
        local spell = sequence[i]
        if type(spell) == "number" and spell >= 0 and spell <= 4 then
            _autoLevel.levelSequence[i] = spell
        else
            _autoLevel.levelSequence[i] = nil
        end
    end
end

function autoLevelSetFunction(func)
    assert(func == nil or type(func) == "function", "autoLevelSetFunction : wrong argument types (<function> or nil expected)")
    autoLevel__OnLoad()
    _autoLevel.onChoiceFunction = func
end

--  scriptConfig
--[[
    myConfig = scriptConfig("My Script Config Header", "thisScript")
    myConfig:addParam(pVar, pText, SCRIPT_PARAM_ONOFF, defaultValue)
    myConfig:addParam(pVar, pText, SCRIPT_PARAM_ONKEYDOWN, defaultValue, key)
    myConfig:addParam(pVar, pText, SCRIPT_PARAM_ONKEYTOGGLE, defaultValue, key)
    myConfig:addParam(pVar, pText, SCRIPT_PARAM_SLICE, defaultValue, minValue, maxValue, decimalPlace)
    myConfig:addParam(pVar, pText, SCRIPT_PARAM_LIST, defaultValue, listTable)
    myConfig:addParam(pVar, pText, SCRIPT_PARAM_COLOR, defaultValue)
    myConfig:permaShow(pvar)    -- show this var in perma menu
    myConfig:addTS(ts)          -- add a ts instance
    myConfig:addSubMenu("My Sub Menu Header", "subMenu")
    var are myConfig.var
    function OnLoad()
        myConfig = scriptConfig("My Script Config", "thisScript.cfg")
        myConfig:addParam("combo", "Combo mode", SCRIPT_PARAM_ONKEYDOWN, false, 32)
        myConfig:addParam("harass", "Harass mode", SCRIPT_PARAM_ONKEYTOGGLE, false, 78)
        myConfig:addParam("harassMana", "Harass Min Mana", SCRIPT_PARAM_SLICE, 0.2, 0, 1, 2)
        myConfig:addParam("drawCircle", "Draw Circle", SCRIPT_PARAM_ONOFF, false)
        myConfig:addParam("circleColor", "Circle color", SCRIPT_PARAM_COLOR, {255,0,0,255}) --{A,R,G,B}
        myConfig:addParam("multiOptions", "Multiple options", SCRIPT_PARAM_LIST, 2, { "First Option", "Default Option", "Third Option", "Just Another Option", "One More Option Baby" })
        myConfig:permaShow("harass")
        myConfig:permaShow("combo")
        ts = TargetSelector(TARGET_LOW_HP,500,DAMAGE_MAGIC,false)
        ts.name = "Q" -- set a name if you want to recognize it, otherwize, will show "ts"
        myConfig:addTS(ts)

        myConfig:addSubMenu("My Sub Menu Header", "subMenu")
        myConfig.subMenu:addParam("testOnOff", "Testing param in sub-menu", SCRIPT_PARAM_ONOFF, defaultValue)
        myConfig.subMenu:addParam("multiOptions", "Multi-opts in sub-menu", SCRIPT_PARAM_LIST, 1, { "Default", "Its", "Disco", "Baby" })
        myConfig.subMenu:permaShow("testOnOff")
        myConfig.subMenu:permaShow("multiOptions")
    end
    function OnTick()
        if myConfig.combo == true then
            -- bla
        elseif myConfig.harass then
            -- bla
        end
    end
]]
SCRIPT_PARAM_ONOFF = 1
SCRIPT_PARAM_ONKEYDOWN = 2
SCRIPT_PARAM_ONKEYTOGGLE = 3
SCRIPT_PARAM_SLICE = 4
SCRIPT_PARAM_INFO = 5
SCRIPT_PARAM_COLOR = 6
SCRIPT_PARAM_LIST = 7
local _SC = { init = true, initDraw = true, menuKey = 16, useTS = false, menuIndex = -1, instances = {}, _changeKey = false, _changeKeyInstance = false, _sliceInstance = false, _listInstance = false }
class'scriptConfig'
local function __SC__remove(name)
    if not GetSave("scriptConfig")[name] then GetSave("scriptConfig")[name] = {} end
    table.clear(GetSave("scriptConfig")[name])
end

local function __SC__load(name)
    if not GetSave("scriptConfig")[name] then GetSave("scriptConfig")[name] = {} end
    return GetSave("scriptConfig")[name]
end

local function __SC__save(name, content)
    if not GetSave("scriptConfig")[name] then GetSave("scriptConfig")[name] = {} end
    table.clear(GetSave("scriptConfig")[name])
    table.merge(GetSave("scriptConfig")[name], content, true)
end

local function __SC__saveMaster()
    local config = {}
    local P, PS, I = 0, 0, 0
    for _, instance in pairs(_SC.instances) do
        I = I + 1
        P = P + #instance._param
        PS = PS + #instance._permaShow
    end
    _SC.master["I" .. _SC.masterIndex] = I
    _SC.master["P" .. _SC.masterIndex] = P
    _SC.master["PS" .. _SC.masterIndex] = PS
    if not _SC.master.useTS and _SC.useTS then _SC.master.useTS = true end
    for var, value in pairs(_SC.master) do
        config[var] = value
    end
    __SC__save("Master", config)
end

local function __SC__updateMaster()
    _SC.master = __SC__load("Master")
    _SC.masterY, _SC.masterYp = 1, 0
    _SC.masterY = (_SC.master.useTS and 1 or 0)
    for i = 1, _SC.masterIndex - 1 do
        _SC.masterY = _SC.masterY + _SC.master["I" .. i]
        _SC.masterYp = _SC.masterYp + _SC.master["PS" .. i]
    end
    local size, sizep = (_SC.master.useTS and 2 or 1), 0
    for i = 1, _SC.master.iCount do
        size = size + _SC.master["I" .. i]
        sizep = sizep + _SC.master["PS" .. i]
    end
    _SC.draw.height = size * _SC.draw.cellSize
    _SC.pDraw.height = sizep * _SC.pDraw.cellSize
    _SC.draw.x = _SC.master.x
    _SC.draw.y = _SC.master.y
    _SC.pDraw.x = _SC.master.px
    _SC.pDraw.y = _SC.master.py
    _SC._Idraw.x = _SC.draw.x + _SC.draw.width + _SC.draw.border * 2
end

local function __SC__saveMenu()
    __SC__save("Menu", { menuKey = _SC.menuKey, draw = { x = _SC.draw.x, y = _SC.draw.y }, pDraw = { x = _SC.pDraw.x, y = _SC.pDraw.y } })
    _SC.master.x = _SC.draw.x
    _SC.master.y = _SC.draw.y
    _SC.master.px = _SC.pDraw.x
    _SC.master.py = _SC.pDraw.y
    __SC__saveMaster()
end

local function __SC__init_draw()
    if _SC.initDraw then
        UpdateWindow()
        _SC.draw = { x = WINDOW_W and math.floor(WINDOW_W / 50) or 20, y = WINDOW_H and math.floor(WINDOW_H / 4) or 190, y1 = 0, height = 0, fontSize = WINDOW_H and math.round(WINDOW_H / 54) or 14, width = WINDOW_W and math.round(WINDOW_W / 4.8) or 213, border = 2, background = 1413167931, textColor = 4290427578, trueColor = 1422721024, falseColor = 1409321728, move = false }
        _SC.pDraw = { x = WINDOW_W and math.floor(WINDOW_W * 0.66) or 675, y = WINDOW_H and math.floor(WINDOW_H * 0.8) or 608, y1 = 0, height = 0, fontSize = WINDOW_H and math.round(WINDOW_H / 72) or 10, width = WINDOW_W and math.round(WINDOW_W / 6.4) or 160, border = 1, background = 1413167931, textColor = 4290427578, trueColor = 1422721024, falseColor = 1409321728, move = false }
        local menuConfig = __SC__load("Menu")
        table.merge(_SC, menuConfig, true)
        _SC.color = { lgrey = 1413167931, grey = 4290427578, red = 1422721024, green = 1409321728, ivory = 4294967280 }
        _SC.draw.cellSize, _SC.draw.midSize, _SC.draw.row4, _SC.draw.row3, _SC.draw.row2, _SC.draw.row1 = _SC.draw.fontSize + _SC.draw.border, _SC.draw.fontSize / 2, _SC.draw.width * 0.9, _SC.draw.width * 0.8, _SC.draw.width * 0.7, _SC.draw.width * 0.6
        _SC.pDraw.cellSize, _SC.pDraw.midSize, _SC.pDraw.row = _SC.pDraw.fontSize + _SC.pDraw.border, _SC.pDraw.fontSize / 2, _SC.pDraw.width * 0.7
        _SC._Idraw = { x = _SC.draw.x + _SC.draw.width + _SC.draw.border * 2, y = _SC.draw.y, height = 0 }
        if WINDOW_H < 500 or WINDOW_W < 500 then return true end
        _SC.initDraw = nil
    end
    return _SC.initDraw
end

local function __SC__init(name)
    if name == nil then
        return (_SC.init or __SC__init_draw())
    end
    if _SC.init then
        _SC.init = nil
        __SC__init_draw()
        local gameStart = GetGame()
        _SC.master = __SC__load("Master")
        --[[ SurfaceS: Look into it! When loading the master, it screws up the Menu, when you change at the same time the running scripts.
           if _SC.master.osTime ~= nil and _SC.master.osTime == gameStart.osTime then
              for i = 1, _SC.master.iCount do
                  if _SC.master["name" .. i] == name then _SC.masterIndex = i end
              end
              if _SC.masterIndex == nil then
                  _SC.masterIndex = _SC.master.iCount + 1
                  _SC.master["name" .. _SC.masterIndex] = name
                  _SC.master.iCount = _SC.masterIndex
                  __SC__saveMaster()
             end
        else]]
        __SC__remove("Master")
        _SC.masterIndex = 1
        _SC.master.useTS = false
        _SC.master.x = _SC.draw.x
        _SC.master.y = _SC.draw.y
        _SC.master.px = _SC.pDraw.x
        _SC.master.py = _SC.pDraw.y
        _SC.master.osTime = gameStart.osTime
        _SC.master.name1 = name
        _SC.master.iCount = 1
        __SC__saveMaster()
        --end
    end
    __SC__updateMaster()
end

local function __SC__txtKey(key)
    return (key > 32 and key < 96 and " " .. string.char(key) .. " " or "(" .. tostring(key) .. ")")
end

local function __SC__DrawInstance(header, selected)
    DrawLine(_SC.draw.x + _SC.draw.width / 2, _SC.draw.y1, _SC.draw.x + _SC.draw.width / 2, _SC.draw.y1 + _SC.draw.cellSize, _SC.draw.width + _SC.draw.border * 2, (selected and _SC.color.red or _SC.color.lgrey))
    DrawText(header, _SC.draw.fontSize, _SC.draw.x, _SC.draw.y1, (selected and _SC.color.ivory or _SC.color.grey))
    _SC.draw.y1 = _SC.draw.y1 + _SC.draw.cellSize
end

local function __SC__ResetSubIndexes()
    for i, instance in ipairs(_SC.instances) do
        instance:ResetSubIndexes()
    end
end

local __SC__OnDraw, __SC__OnWndMsg
local function __SC__OnLoad()
    if not __SC__OnDraw then
        function __SC__OnDraw()
            if __SC__init() or Console__IsOpen or GetGame().isOver then return end
            if IsKeyDown(_SC.menuKey) or _SC._changeKey then
                if _SC.draw.move then
                    local cursor = GetCursorPos()
                    _SC.draw.x = cursor.x - _SC.draw.offset.x
                    _SC.draw.y = cursor.y - _SC.draw.offset.y
                    _SC._Idraw.x = _SC.draw.x + _SC.draw.width + _SC.draw.border * 2
                elseif _SC.pDraw.move then
                    local cursor = GetCursorPos()
                    _SC.pDraw.x = cursor.x - _SC.pDraw.offset.x
                    _SC.pDraw.y = cursor.y - _SC.pDraw.offset.y
                end
                if _SC.masterIndex == 1 then
                    DrawLine(_SC.draw.x + _SC.draw.width / 2, _SC.draw.y, _SC.draw.x + _SC.draw.width / 2, _SC.draw.y + _SC.draw.height, _SC.draw.width + _SC.draw.border * 2, 1414812756) -- grey
                    _SC.draw.y1 = _SC.draw.y
                    local menuText = _SC._changeKey and not _SC._changeKeyVar and "press key for Menu" or "Menu"
                    DrawText(menuText, _SC.draw.fontSize, _SC.draw.x, _SC.draw.y1, _SC.color.ivory) -- ivory
                    DrawText(__SC__txtKey(_SC.menuKey), _SC.draw.fontSize, _SC.draw.x + _SC.draw.width * 0.9, _SC.draw.y1, _SC.color.grey)
                end
                _SC.draw.y1 = _SC.draw.y + _SC.draw.cellSize
                if _SC.useTS then
                    __SC__DrawInstance("Target Selector", (_SC.menuIndex == 0))
                    if _SC.menuIndex == 0 then
                        DrawLine(_SC._Idraw.x + _SC.draw.width / 2, _SC.draw.y, _SC._Idraw.x + _SC.draw.width / 2, _SC.draw.y + _SC._Idraw.height, _SC.draw.width + _SC.draw.border * 2, 1414812756) -- grey
                        DrawText("Target Selector", _SC.draw.fontSize, _SC._Idraw.x, _SC.draw.y, _SC.color.ivory)
                        _SC._Idraw.y = TS__DrawMenu(_SC._Idraw.x, _SC.draw.y + _SC.draw.cellSize)
                        _SC._Idraw.height = _SC._Idraw.y - _SC.draw.y
                    end
                end
                _SC.draw.y1 = _SC.draw.y + _SC.draw.cellSize + (_SC.draw.cellSize * _SC.masterY)
                for index, instance in ipairs(_SC.instances) do
                    __SC__DrawInstance(instance.header, (_SC.menuIndex == index))
                    if _SC.menuIndex == index then instance:OnDraw() end
                end
            end
            local y1 = _SC.pDraw.y + (_SC.pDraw.cellSize * _SC.masterYp)
            local function DrawPermaShows(instance)

                if #instance._permaShow > 0 then
                    for _, varIndex in ipairs(instance._permaShow) do
                        local pVar = instance._param[varIndex].var
                        DrawLine(_SC.pDraw.x - _SC.pDraw.border, y1 + _SC.pDraw.midSize, _SC.pDraw.x + _SC.pDraw.row - _SC.pDraw.border, y1 + _SC.pDraw.midSize, _SC.pDraw.cellSize, _SC.color.lgrey)
                        DrawText(instance._param[varIndex].text, _SC.pDraw.fontSize, _SC.pDraw.x, y1, _SC.color.grey)
                        if instance._param[varIndex].pType == SCRIPT_PARAM_SLICE or instance._param[varIndex].pType == SCRIPT_PARAM_LIST or instance._param[varIndex].pType == SCRIPT_PARAM_INFO then
                            DrawLine(_SC.pDraw.x + _SC.pDraw.row, y1 + _SC.pDraw.midSize, _SC.pDraw.x + _SC.pDraw.width + _SC.pDraw.border, y1 + _SC.pDraw.midSize, _SC.pDraw.cellSize, _SC.color.lgrey)
                            if instance._param[varIndex].pType == SCRIPT_PARAM_LIST then
                                local text = tostring(instance._param[varIndex].listTable[instance[pVar]])
                                local maxWidth = (_SC.pDraw.width - _SC.pDraw.row) * 0.8
                                local textWidth = GetTextArea(text, _SC.pDraw.fontSize).x
                                if textWidth > maxWidth then
                                    text = text:sub(1, math.floor(text:len() * maxWidth / textWidth)) .. ".."
                                end
                                DrawText(text, _SC.pDraw.fontSize, _SC.pDraw.x + _SC.pDraw.row, y1, _SC.color.grey)
                            else
                                DrawText(tostring(instance[pVar]), _SC.pDraw.fontSize, _SC.pDraw.x + _SC.pDraw.row + _SC.pDraw.border, y1, _SC.color.grey)
                            end
                        else
                            DrawLine(_SC.pDraw.x + _SC.pDraw.row, y1 + _SC.pDraw.midSize, _SC.pDraw.x + _SC.pDraw.width + _SC.pDraw.border, y1 + _SC.pDraw.midSize, _SC.pDraw.cellSize, (instance[pVar] and _SC.color.green or _SC.color.lgrey))
                            DrawText((instance[pVar] and "      ON" or "      OFF"), _SC.pDraw.fontSize, _SC.pDraw.x + _SC.pDraw.row + _SC.pDraw.border, y1, _SC.color.grey)
                        end
                        y1 = y1 + _SC.pDraw.cellSize
                    end
                end
                for _, subInstance in ipairs(instance._subInstances) do
                    DrawPermaShows(subInstance)
                end
            end
            for _, instance in ipairs(_SC.instances) do
                DrawPermaShows(instance)
            end
        end

        AddDrawCallback(__SC__OnDraw)
    end
    if not __SC__OnWndMsg then
        function __SC__OnWndMsg(msg, key)
            if __SC__init() or Console__IsOpen then return end
            local msg, key = msg, key
            if key == _SC.menuKey and _SC.lastKeyState ~= msg then
                _SC.lastKeyState = msg
                __SC__updateMaster()
            end
            if _SC._changeKey then
                if msg == KEY_DOWN then
                    if _SC._changeKeyMenu then return end
                    _SC._changeKey = false
                    if _SC._changeKeyVar == nil then
                        _SC.menuKey = key
                        if _SC.masterIndex == 1 then __SC__saveMenu() end
                    else
                        _SC._changeKeyInstance._param[_SC._changeKeyVar].key = key
                        _SC._changeKeyInstance:save()
                        --_SC.instances[_SC.menuIndex]._param[_SC._changeKeyVar].key = key
                        --_SC.instances[_SC.menuIndex]:save()
                    end
                    return
                else
                    if _SC._changeKeyMenu and key == _SC.menuKey then _SC._changeKeyMenu = false end
                end
            end
            if msg == WM_LBUTTONDOWN and IsKeyDown(_SC.menuKey) then
                if CursorIsUnder(_SC.draw.x, _SC.draw.y, _SC.draw.width, _SC.draw.height) then
                    _SC.menuIndex = -1
                    __SC__ResetSubIndexes()
                    if CursorIsUnder(_SC.draw.x + _SC.draw.width - _SC.draw.fontSize * 1.5, _SC.draw.y, _SC.draw.fontSize, _SC.draw.cellSize) then
                        _SC._changeKey, _SC._changeKeyVar, _SC._changeKeyMenu = true, nil, true
                        return
                    elseif CursorIsUnder(_SC.draw.x, _SC.draw.y, _SC.draw.width, _SC.draw.cellSize) then
                        _SC.draw.offset = Vector(GetCursorPos()) - _SC.draw
                        _SC.draw.move = true
                        return
                    else
                        if _SC.useTS and CursorIsUnder(_SC.draw.x, _SC.draw.y + _SC.draw.cellSize, _SC.draw.width, _SC.draw.cellSize) then _SC.menuIndex = 0 __SC__ResetSubIndexes() end
                        local y1 = _SC.draw.y + _SC.draw.cellSize + (_SC.draw.cellSize * _SC.masterY)
                        for index, _ in ipairs(_SC.instances) do
                            if CursorIsUnder(_SC.draw.x, y1, _SC.draw.width, _SC.draw.cellSize) then _SC.menuIndex = index __SC__ResetSubIndexes() end
                            y1 = y1 + _SC.draw.cellSize
                        end
                    end
                elseif CursorIsUnder(_SC.pDraw.x, _SC.pDraw.y, _SC.pDraw.width, _SC.pDraw.height) then
                    _SC.pDraw.offset = Vector(GetCursorPos()) - _SC.pDraw
                    _SC.pDraw.move = true
                elseif _SC.menuIndex == 0 then
                    TS_ClickMenu(_SC._Idraw.x, _SC.draw.y + _SC.draw.cellSize)
                elseif _SC.menuIndex > 0 then
                    local function CheckOnWndMsg(instance)
                        if CursorIsUnder(instance._x, _SC.draw.y, _SC.draw.width, instance._height) then
                            instance:OnWndMsg()
                        elseif instance._subMenuIndex > 0 then
                            CheckOnWndMsg(instance._subInstances[instance._subMenuIndex])
                        end
                    end
                    CheckOnWndMsg(_SC.instances[_SC.menuIndex])
                end
            elseif msg == WM_LBUTTONUP then
                if _SC.draw.move or _SC.pDraw.move then
                    _SC.draw.move = false
                    _SC.pDraw.move = false
                    if _SC.masterIndex == 1 then __SC__saveMenu() end
                    return
                elseif _SC._sliceInstance then
                    _SC._sliceInstance:save()
                    _SC._sliceInstance._slice = false
                    _SC._sliceInstance = false

                    return
                elseif _SC._listInstance then
                    _SC._listInstance:save()
                    _SC._listInstance._list = false
                    _SC._listInstance = false
                end
            else
                local function CheckOnWndMsg(instance)

                    for _, param in ipairs(instance._param) do
                        if param.pType == SCRIPT_PARAM_ONKEYTOGGLE and key == param.key and msg == KEY_DOWN then
                            instance[param.var] = not instance[param.var]
                        elseif param.pType == SCRIPT_PARAM_ONKEYDOWN and key == param.key then
                            instance[param.var] = (msg == KEY_DOWN)
                        end
                    end
                    for _, subInstance in ipairs(instance._subInstances) do
                        CheckOnWndMsg(subInstance)
                    end
                end
                for _, instance in ipairs(_SC.instances) do
                    CheckOnWndMsg(instance)
                end
            end
        end

        AddMsgCallback(__SC__OnWndMsg)
    end
end

function scriptConfig:__init(header, name, parent)
    assert((type(header) == "string") and (type(name) == "string"), "scriptConfig: expected <string>, <string>)")
    if not parent then
        __SC__init(name)
        __SC__OnLoad()
    else
        self._parent = parent
    end
    self.header = header
    self.name = name
    self._tsInstances = {}
    self._param = {}
    self._permaShow = {}
    self._subInstances = {}
    self._subMenuIndex = 0
    self._x = parent and (parent._x + _SC.draw.width + _SC.draw.border*2) or _SC._Idraw.x
    self._y = 0
    self._height = 0
    self._slice = false
    table.insert(parent and parent._subInstances or _SC.instances, self)
end

function scriptConfig:addSubMenu(header, name)
    assert((type(header) == "string") and (type(name) == "string"), "scriptConfig: expected <string>, <string>)")
    local subName = self.name .. "_" .. name
    local sub = scriptConfig(header, subName, self)
    self[name] = sub
end

function scriptConfig:addParam(pVar, pText, pType, defaultValue, a, b, c)
    assert(type(pVar) == "string" and type(pText) == "string" and type(pType) == "number", "addParam: wrong argument types (<string>, <string>, <pType> expected)")
    assert(string.find(pVar, "[^%a%d]") == nil, "addParam: pVar should contain only char and number")
    --assert(self[pVar] == nil, "addParam: pVar should be unique, already existing " .. pVar)
    local newParam = { var = pVar, text = pText, pType = pType }
    if pType == SCRIPT_PARAM_ONOFF then
        assert(type(defaultValue) == "boolean", "addParam: wrong argument types (<boolean> expected)")
    elseif pType == SCRIPT_PARAM_COLOR then
        assert(type(defaultValue) == "table", "addParam: wrong argument types (<table> expected)")
        assert(#defaultValue == 4, "addParam: wrong argument ({a,r,g,b} expected)")
    elseif pType == SCRIPT_PARAM_ONKEYDOWN or pType == SCRIPT_PARAM_ONKEYTOGGLE then
        assert(type(defaultValue) == "boolean" and type(a) == "number", "addParam: wrong argument types (<boolean> <number> expected)")
        newParam.key = a
    elseif pType == SCRIPT_PARAM_SLICE then
        assert(type(defaultValue) == "number" and type(a) == "number" and type(b) == "number" and (type(c) == "number" or c == nil), "addParam: wrong argument types (pVar, pText, pType, defaultValue, valMin, valMax, decimal) expected")
        newParam.min = a
        newParam.max = b
        newParam.idc = c or 0
        newParam.cursor = 0
    elseif pType == SCRIPT_PARAM_LIST then
        assert(type(defaultValue) == "number" and type(a) == "table", "addParam: wrong argument types (pVar, pText, pType, defaultValue, listTable) expected")
        newParam.listTable = a
        newParam.min = 1
        newParam.max = #a
        newParam.cursor = 0
    end
    self[pVar] = defaultValue
    table.insert(self._param, newParam)
    __SC__saveMaster()
    self:load()
end

function scriptConfig:addTS(tsInstance)
    assert(type(tsInstance.mode) == "number", "addTS: expected TargetSelector)")
    _SC.useTS = true
    table.insert(self._tsInstances, tsInstance)
    __SC__saveMaster()
    self:load()
end

function scriptConfig:permaShow(pVar)
    assert(type(pVar) == "string" and self[pVar] ~= nil, "permaShow: existing pVar expected)")
    for index, param in ipairs(self._param) do
        if param.var == pVar then
            table.insert(self._permaShow, index)
        end
    end
    __SC__saveMaster()
end

function scriptConfig:_txtKey(key)
    return (key > 32 and key < 96 and " " .. string.char(key) .. " " or "(" .. tostring(key) .. ")")
end

function scriptConfig:OnDraw()
    self._x = self._parent and (self._parent._x + _SC.draw.width + _SC.draw.border*2) or _SC._Idraw.x
    if self._slice and _SC._sliceInstance then
        local cursorX = math.min(math.max(0, GetCursorPos().x - self._x - _SC.draw.row3), _SC.draw.width - _SC.draw.row3)
        self[self._param[self._slice].var] = math.round(self._param[self._slice].min + cursorX / (_SC.draw.width - _SC.draw.row3) * (self._param[self._slice].max - self._param[self._slice].min), self._param[self._slice].idc)
    end
    self._y = _SC.draw.y
    DrawLine(self._x + _SC.draw.width / 2, self._y, self._x + _SC.draw.width / 2, self._y + self._height, _SC.draw.width + _SC.draw.border * 2, 1414812756) -- grey
    local menuText = _SC._changeKey and _SC._changeKeyVar and _SC._changeKeyInstance and _SC._changeKeyInstance.name == self.name and "press key for " .. self._param[_SC._changeKeyVar].var or self.header
    DrawText(menuText, _SC.draw.fontSize, self._x, self._y, 4294967280) -- ivory
    self._y = self._y + _SC.draw.cellSize
    for index, _ in ipairs(self._subInstances) do
        self:_DrawSubInstance(index)
        if self._subMenuIndex == index then _:OnDraw() end
    end

    if #self._tsInstances > 0 then
        --_SC._Idraw.y = TS__DrawMenu(_SC._Idraw.x, _SC._Idraw.y)
        for _, tsInstance in ipairs(self._tsInstances) do
            self._y = tsInstance:DrawMenu(self._x, self._y)
        end
    end
    for index, _ in ipairs(self._param) do
        self:_DrawParam(index)
    end
    self._height = self._y - _SC.draw.y
    if self._list and _SC._listInstance and self._listY then
        local cursorY = math.min(GetCursorPos().y - self._listY, _SC.draw.cellSize * (self._param[self._list].max))
        if cursorY >= 0 then
            self[self._param[self._list].var] = math.round(self._param[self._list].min + cursorY / (_SC.draw.cellSize * (self._param[self._list].max)) * (self._param[self._list].max - self._param[self._list].min))
        end
        local maxWidth = 0
        for i, el in pairs(self._param[self._list].listTable) do
            maxWidth = math.max(maxWidth, GetTextArea(el, _SC.draw.fontSize).x)
        end
        -- BG:
        DrawRectangle(self._x + _SC.draw.row3, self._listY, maxWidth, self._param[self._list].max * _SC.draw.cellSize, ARGB(230,50,50,50))
        -- SELECTED:
        DrawRectangle(self._x + _SC.draw.row3, self._listY + (self[self._param[self._list].var]-1) * _SC.draw.cellSize, maxWidth, _SC.draw.cellSize, _SC.color.green)
        for i, el in pairs(self._param[self._list].listTable) do
            DrawText(el, _SC.draw.fontSize, self._x + _SC.draw.row3, self._listY + (i-1) * _SC.draw.cellSize, 4294967280)
        end
    end
end

function scriptConfig:_DrawSubInstance(index)
    local pVar = self._subInstances[index].name
    local selected = self._subMenuIndex == index
    DrawLine(self._x - _SC.draw.border, self._y + _SC.draw.midSize, self._x + _SC.draw.width + _SC.draw.border, self._y + _SC.draw.midSize, _SC.draw.cellSize, (selected and _SC.color.red or _SC.color.lgrey))
    DrawText(self._subInstances[index].header, _SC.draw.fontSize, self._x, self._y, (selected and _SC.color.ivory or _SC.color.grey))
    DrawText("        >>", _SC.draw.fontSize, self._x + _SC.draw.row3 + _SC.draw.border, self._y, (selected and _SC.color.ivory or _SC.color.grey))
    --_SC._Idraw.y = _SC._Idraw.y + _SC.draw.cellSize
    self._y = self._y + _SC.draw.cellSize
end

function scriptConfig:_DrawParam(varIndex)
    local pVar = self._param[varIndex].var
    DrawLine(self._x - _SC.draw.border, self._y + _SC.draw.midSize, self._x + _SC.draw.row3 - _SC.draw.border, self._y + _SC.draw.midSize, _SC.draw.cellSize, _SC.color.lgrey)
    DrawText(self._param[varIndex].text, _SC.draw.fontSize, self._x, self._y, _SC.color.grey)
    if self._param[varIndex].pType == SCRIPT_PARAM_SLICE then
        DrawText(tostring(self[pVar]), _SC.draw.fontSize, self._x + _SC.draw.row2, self._y, _SC.color.grey)
        DrawLine(self._x + _SC.draw.row3, self._y + _SC.draw.midSize, self._x + _SC.draw.width + _SC.draw.border, self._y + _SC.draw.midSize, _SC.draw.cellSize, _SC.color.lgrey)
        -- cursor
        self._param[varIndex].cursor = (self[pVar] - self._param[varIndex].min) / (self._param[varIndex].max - self._param[varIndex].min) * (_SC.draw.width - _SC.draw.row3)
        DrawLine(self._x + _SC.draw.row3 + self._param[varIndex].cursor - _SC.draw.border, self._y + _SC.draw.midSize, self._x + _SC.draw.row3 + self._param[varIndex].cursor + _SC.draw.border, self._y + _SC.draw.midSize, _SC.draw.cellSize, 4292598640)
    elseif self._param[varIndex].pType == SCRIPT_PARAM_LIST then
        local text = tostring(self._param[varIndex].listTable[self[pVar]])
        local maxWidth = (_SC.draw.width - _SC.draw.row3) * 0.8
        local textWidth = GetTextArea(text, _SC.draw.fontSize).x
        if textWidth > maxWidth then
            text = text:sub(1, math.floor(text:len() * maxWidth / textWidth)) .. ".."
        end
        DrawText(text, _SC.draw.fontSize, self._x + _SC.draw.row3, self._y, _SC.color.grey)
        if self._list and _SC._listInstance then self._listY = self._y + _SC.draw.cellSize end
    elseif self._param[varIndex].pType == SCRIPT_PARAM_INFO then
        DrawText(tostring(self[pVar]), _SC.draw.fontSize, self._x + _SC.draw.row3 + _SC.draw.border, self._y, _SC.color.grey)
    elseif self._param[varIndex].pType == SCRIPT_PARAM_COLOR then
        DrawRectangle(self._x + _SC.draw.row3 + _SC.draw.border, self._y, 80, _SC.draw.cellSize, ARGB(self[pVar][1], self[pVar][2], self[pVar][3], self[pVar][4]))
    else
        if (self._param[varIndex].pType == SCRIPT_PARAM_ONKEYDOWN or self._param[varIndex].pType == SCRIPT_PARAM_ONKEYTOGGLE) then
            DrawText(self:_txtKey(self._param[varIndex].key), _SC.draw.fontSize, self._x + _SC.draw.row2, self._y, _SC.color.grey)
        end
        DrawLine(self._x + _SC.draw.row3, self._y + _SC.draw.midSize, self._x + _SC.draw.width + _SC.draw.border, self._y + _SC.draw.midSize, _SC.draw.cellSize, (self[pVar] and _SC.color.green or _SC.color.lgrey))
        DrawText((self[pVar] and "        ON" or "        OFF"), _SC.draw.fontSize, self._x + _SC.draw.row3 + _SC.draw.border, self._y, _SC.color.grey)
    end
    self._y = self._y + _SC.draw.cellSize
end



function scriptConfig:load()
    local function sensitiveMerge(base, t)
        for i, v in pairs(t) do
            if type(base[i]) == type(v) then
                if type(v) == "table" then sensitiveMerge(base[i], v)
                else base[i] = v
                end
            end
        end
    end

    local config = __SC__load(self.name)
    for var, value in pairs(config) do
        if type(value) == "table" then
            if self[var] then sensitiveMerge(self[var], value) end
        else self[var] = value
        end
    end
end

function scriptConfig:save()
    local content = {}
    content._param = content._param or {}
    for var, param in pairs(self._param) do
        if param.pType ~= SCRIPT_PARAM_INFO then
            content[param.var] = self[param.var]
            if param.pType == SCRIPT_PARAM_ONKEYDOWN or param.pType == SCRIPT_PARAM_ONKEYTOGGLE then
                content._param[var] = { key = param.key }
            end
        end
    end
    content._tsInstances = content._tsInstances or {}
    for i, ts in pairs(self._tsInstances) do
        content._tsInstances[i] = { mode = ts.mode }
    end
    -- for i,pShow in pairs(self._permaShow) do
    -- table.insert (content, "_permaShow."..i.."="..tostring(pShow))
    -- end
    __SC__save(self.name, content)
end

function scriptConfig:ResetSubIndexes()
    if self._subMenuIndex > 0 then
        self._subInstances[self._subMenuIndex]:ResetSubIndexes()
        self._subMenuIndex = 0
    end
end

function scriptConfig:OnWndMsg()
    local y1 = _SC.draw.y + _SC.draw.cellSize
    if CursorIsUnder(self._x, _SC.draw.y, _SC.draw.width + _SC.draw.border, _SC.draw.cellSize) then self:ResetSubIndexes() end
    for i, instance in ipairs(self._subInstances) do
        if CursorIsUnder(self._x, y1, _SC.draw.width + _SC.draw.border, _SC.draw.cellSize) then self._subMenuIndex = i return end
        y1 = y1 + _SC.draw.cellSize
    end
    if #self._tsInstances > 0 then
        for _, tsInstance in ipairs(self._tsInstances) do
            y1 = tsInstance:ClickMenu(self._x, y1)
        end
    end
    for i, param in ipairs(self._param) do
        if param.pType == SCRIPT_PARAM_ONKEYDOWN or param.pType == SCRIPT_PARAM_ONKEYTOGGLE then
            if CursorIsUnder(self._x + _SC.draw.row2, y1, _SC.draw.fontSize, _SC.draw.fontSize) then
                _SC._changeKey, _SC._changeKeyVar, _SC._changeKeyMenu = true, i, true
                _SC._changeKeyInstance = self
                self:ResetSubIndexes()
                return
            end
        end
        if param.pType == SCRIPT_PARAM_ONOFF or param.pType == SCRIPT_PARAM_ONKEYTOGGLE then
            if CursorIsUnder(self._x + _SC.draw.row3, y1, _SC.draw.width - _SC.draw.row3, _SC.draw.fontSize) then
                self[param.var] = not self[param.var]
                self:save()
                self:ResetSubIndexes()
                return
            end
        end
        if param.pType == SCRIPT_PARAM_COLOR then
            if CursorIsUnder(self._x + _SC.draw.row3, y1, _SC.draw.width - _SC.draw.row3, _SC.draw.fontSize) then
                __CP(nil, nil, self[param.var][1], self[param.var][2], self[param.var][3], self[param.var][4], self[param.var])
                self:save()
                self:ResetSubIndexes()
                return
            end
        end
        if param.pType == SCRIPT_PARAM_SLICE then
            if CursorIsUnder(self._x + _SC.draw.row3 - _SC.draw.border, y1, WINDOW_W, _SC.draw.fontSize) then
                self._slice = i
                _SC._sliceInstance = self
                self:ResetSubIndexes()

                return
            end
        end
        if param.pType == SCRIPT_PARAM_LIST then
            if CursorIsUnder(self._x + _SC.draw.row3 - _SC.draw.border, y1, WINDOW_W, _SC.draw.fontSize) then
                self._list = i
                _SC._listInstance = self
                self:ResetSubIndexes()

                return
            end
        end
        y1 = y1 + _SC.draw.cellSize
    end
end

-- -- Alerter Class
-- written by Weee
--[[
    PrintAlert(text, duration, r, g, b, sprite)           - Pushes an alert message (notification) to the middle of the screen. Together with first message it also adds a configuration menu to the scriptConfig.
                text:   Alert text                        - <string>
            duration:   Alert duration (in seconds)       - <number>
                   r:   Red                               - <number>: 0..255
                   g:   Green                             - <number>: 0..255
                   b:   Blue                              - <number>: 0..255
              sprite:   Sprite                            - sprite!
]]

local __mAlerter, __Alerter_OnTick, __Alerter_OnDraw = nil, nil, nil

function PrintAlert(text, duration, r, g, b, sprite)
    if not __mAlerter then __mAlerter = __Alerter() end
    return __mAlerter:Push(text, duration, r, g, b, sprite)
end

class("__Alerter")
function __Alerter:__init()
    if not __Alerter_OnTick then
        function __Alerter_OnTick() if __mAlerter then __mAlerter:OnTick() end end
        AddTickCallback(__Alerter_OnTick)
    end
    if not __Alerter_OnDraw then
        function __Alerter_OnDraw() if __mAlerter then __mAlerter:OnDraw() end end
        AddDrawCallback(__Alerter_OnDraw)
    end

    self.config = scriptConfig("Alerter", "alerterClass")
    self.config:addParam("max", "Max Alerts", SCRIPT_PARAM_SLICE, 4, 2, 5, 0)
    self.config:addParam("yOffset", "Y Offset", SCRIPT_PARAM_SLICE, 0.25, 0.1, 0.5, 2)
    self.config:addParam("textSize", "Font Size", SCRIPT_PARAM_SLICE, 20, 12, 30, 0)
    self.config:addParam("textOutline", "Font Outline (May cause FPS drops)", SCRIPT_PARAM_SLICE, 0, 0, 3, 0)
    self.config:addParam("fadeDuration", "Fade In/Out Duration (Sec)", SCRIPT_PARAM_SLICE, 1, 0, 3, 1)
    self.config:addParam("fadeOffset", "Fade In/Out X Offset", SCRIPT_PARAM_SLICE, 50, 20, 200, 0)

    self.yO = -WINDOW_H * self.config.yOffset
    self.x = WINDOW_W/2
    self.y = WINDOW_H/2 + self.yO
    self._alerts = {}
    self.activeCount = 0
    return self
end

function __Alerter:OnTick()
    self.yO = -WINDOW_H * self.config.yOffset
    self.x = WINDOW_W/2
    self.y = WINDOW_H/2 + self.yO
    --if #self._alerts == 0 then self:__finalize() end
end

function __Alerter:OnDraw()
    local gameTime = GetInGameTimer()
    for i, alert in ipairs(self._alerts) do
        self.activeCount = 0
        for j = 1, i do
            local cAlert = self._alerts[j]
            if not cAlert.outro then self.activeCount = self.activeCount + 1 end
        end
        if self.activeCount <= self.config.max and (not alert.playT or alert.playT + self.config.fadeDuration*2 + alert.duration > gameTime) then
            alert.playT = not alert.playT and self._alerts[i-1] and (self._alerts[i-1].playT + 0.5 >= gameTime and self._alerts[i-1].playT + 0.5 or gameTime) or alert.playT or gameTime
            local intro = alert.playT + self.config.fadeDuration > gameTime
            alert.outro = alert.playT + self.config.fadeDuration + alert.duration <= gameTime
            alert.step = alert.outro and math.min(1, (gameTime - alert.playT - self.config.fadeDuration - alert.duration) / self.config.fadeDuration)
                    or gameTime >= alert.playT and math.min(1, (gameTime - alert.playT) / self.config.fadeDuration)
                    or 0
            local xO = alert.outro and self:Easing(alert.step, 0, self.config.fadeOffset) or self:Easing(alert.step, -self.config.fadeOffset, self.config.fadeOffset)
            local alpha = alert.outro and self:Easing(alert.step, 255, -255) or self:Easing(alert.step, 0, 255)
            local yOffsetTar = GetTextArea(alert.text, self.config.textSize).y * 1.2 * (self.activeCount-1)
            alert.yOffset = intro and alert.step == 0 and yOffsetTar
                    or #self._alerts > 1 and not alert.outro and (alert.yOffset < yOffsetTar and math.min(yOffsetTar, alert.yOffset + 0.5) or alert.yOffset > yOffsetTar and math.max(yOffsetTar, alert.yOffset - 0.5))
                    or alert.yOffset
            local x = self.x + xO
            local y = self.y - alert.yOffset
            -- outline:
            local o = self.config.textOutline
            if o > 0 then
                for j = -o, o do
                    for k = -o, o do
                        DrawTextA(alert.text, self.config.textSize, math.floor(x+j), math.floor(y+k), ARGB(alpha, 0, 0, 0), "center", "center")
                    end
                end
            end
            -- sprite:
            if alert.sprite then
                alert.sprite:SetScale(alert.spriteScale, alert.spriteScale)
                alert.sprite:Draw(math.floor(x - GetTextArea(alert.text, self.config.textSize).x/2 - alert.sprite.width * alert.spriteScale * 1.5), math.floor(y - alert.sprite.width * alert.spriteScale / 2), alpha)
            end
            -- text:
            DrawTextA(alert.text, self.config.textSize, math.floor(x), math.floor(y), ARGB(alpha, alert.r, alert.g, alert.b), "center", "center")
        elseif alert.playT and alert.playT + self.config.fadeDuration*2 + alert.duration <= gameTime then
            table.remove(self._alerts, i)
        end
    end
end

function __Alerter:Push(text, duration, r, g, b, sprite)
    local alert = {}
    alert.text = text
    alert.sprite = sprite
    alert.spriteScale = sprite and self.config.textSize / sprite.height
    alert.duration = duration or 1
    alert.r = r
    alert.g = g
    alert.b = b

    alert.parent = self
    alert.yOffset = 0

    alert.reset = function(duration)
        alert.playT = GetInGameTimer() - self.config.fadeDuration
        alert.duration = duration or 0
        alert.yOffset = GetTextArea(alert.text, self.config.textSize).y * (self.activeCount-1)
    end

    self._alerts[#self._alerts+1] = alert
    return alert
end

function __Alerter:Easing(step, sPos, tPos)
    step = step - 1
    return tPos * (step ^ 3 + 1) + sPos
end

function __Alerter:__finalize()
    __Alerter_OnTick = nil
    __Alerter_OnDraw = nil
    __mAlerter = nil
end

-- HSLA ColorPicker
-- written by Weee, design by Farissi, idea taken from: http://hslpicker.com/
--[[
    __CP([x, y], a, r, g, b, sConfigParam)                - Opens an instance of ColorPicker. Only one color picker can be used at the same time.
                x, y:   Draw position                     - <number>, <number>, nil
                   a:   Alpha                             - <number>: 0..255
                   r:   Red                               - <number>: 0..255
                   g:   Green                             - <number>: 0..255
                   b:   Blue                              - <number>: 0..255
        sConfigParam:   Script config parameter to change - <table> : ie self[param.var] from _SC
]]

local __ColorPickers, __ColorPickers_drag, __CP__OnTick, __CP__OnDraw, DrawUiObjFromSprite = nil, false, nil, nil, nil

class("__CP")

function __CP:__init(x, y, a, r, g, b, sConfigParam)
    if not __ColorPickers then __ColorPickers = {} end
    if not DrawUiObjFromSprite then
        function DrawUiObjFromSprite(sprite, obj, a)
            assert(type(sprite) == "userdata" and (type(obj) == "table" or type(obj) == "userdata"), "DrawUiObjFromSprite: wrong argument types (<userdata> expected for sprite and <table> or <userdata> expected for 2nd)")
            local x = obj.x
            local y = obj.y
            local W = obj.W
            local H = obj.H
            local sX = obj.sX
            local sY = obj.sY
            a = a or 255
            sprite:DrawEx(Rect(sX, sY, sX + W, sY + H), --Rect
                D3DXVECTOR3(0, 0, 0), --Center
                D3DXVECTOR3(math.floor(x), math.floor(y), 0), --Pos
                a) --Alpha
        end
    end
    if not __CP__OnTick then
        function __CP__OnTick()
            if IsFocused() then
                for i, CP in pairs(__ColorPickers) do
                    if CP:GetSprite() then
                        CP:OnTick()
                        for k, picker in pairs(CP.pickers) do picker:OnTick() end
                    else
                        CP:NoSpriteTick()
                    end
                end
            end
        end

        AddTickCallback(__CP__OnTick)
    end
    if not __CP__OnDraw then
        function __CP__OnDraw()
            for i, CP in pairs(__ColorPickers) do
                if CP:GetSprite() then
                    CP.cv:OnDraw()
                    for k, picker in pairs(CP.pickers) do picker:OnDraw() end
                    CP:OnDraw()
                    for k, picker in pairs(CP.pickers) do picker:Cursor_OnDraw() end
                else
                    CP:NoSpriteDraw()
                end
            end
        end

        AddDrawCallback(__CP__OnDraw)
    end
    UpdateWindow()
    self:NoMulti()

    self.id = os.clock()
    local h, s, l = __CP__Color:RGB2HSL({ r, g, b })
    self.c = __CP__Color(h, s, l, a)

    -- Getting sprite:
    self.getWebSpriteTry = 1
    self.getWebSpriteTick = self.id
    self:GetSprite()

    self.sConfigParam = sConfigParam
    self.W = 501
    self.H = 142
    self.sX = 0
    self.sY = 0
    self.x = x or WINDOW_W / 2 - self.W / 2
    self.y = y or WINDOW_H / 2 - self.H / 2
    self.drag = false
    self.pickers = {
        --__init(cp, type, x, y)
        h = __CP__Picker(self, "h", 95, 37 + 21 * 0),
        s = __CP__Picker(self, "s", 95, 37 + 21 * 1),
        l = __CP__Picker(self, "l", 95, 37 + 21 * 2),
        a = __CP__Picker(self, "a", 95, 37 + 21 * 3),
    }
    self.cv = self:ColorVariants(367, 31)
    self.buttons = {
        --__CP:Button(x, y, W, H, sX, sY)
        confirm = __CP__Button(self, 322, 123, 84, 26, 501, 0, 26,
            function()
                self:Return()
            end),
        cancel = __CP__Button(self, 405, 123, 78, 26, 585, 0, 26,
            function()
                self:__finalize()
            end),
        paste = __CP__Button(self, 27, 100, 64, 16, 501, 78, 16,
            function()
                self:PasteHEX()
            end),
        copy = __CP__Button(self, 36, 83, 46, 12, 501, 126, 12,
            function()
                self:CopyHEX()
            end),
        randomize = __CP__Button(self, 0, 0, 47, 47, 585, 78, 47,
            function()
                self.c:randomize()
            end),
        nsPaste = __CP__NoSpriteButton(self, 200, 20, 100, 20, "Paste HEX", 50, 50, 50, 240,
            function()
                self:PasteHEX()
            end),
        nsConfirm = __CP__NoSpriteButton(self, 200, 45, 100, 20, "Confirm", 50, 50, 50, 240,
            function()
                self:Return()
            end),
        nsCancel = __CP__NoSpriteButton(self, 200, 70, 100, 20, "Cancel", 50, 50, 50, 240,
            function()
                self:__finalize()
            end),
    }
    __ColorPickers[#__ColorPickers + 1] = self
    return self.c:HSL2HEX()
end

function __CP:GetSprite()
    --[[
            Mirror list:
                https://dl.dropboxusercontent.com/u/93477088/BoL/Scripts/ColorPicker/bol-cp.png
                http://www.weee.ru/bol-cp.png
    ]]
    if self.sprite then
        return true
    elseif os.clock() >= self.getWebSpriteTick then
        self.getWebSpriteTick = os.clock() + 1
        local mirrors = {
            "https://dl.dropboxusercontent.com/u/93477088/BoL/Scripts/ColorPicker/bol-cp.png",
            "http://www.weee.ru/bol-cp.png",
        }

        self.sprite = GetWebSprite(mirrors[self.getWebSpriteTry],
            function(data)
                self.sprite = data
                if self.cv then self.cv.sprite = data end
            end)
        self.getWebSpriteTry = self.getWebSpriteTry >= #mirrors and 1 or self.getWebSpriteTry + 1
    end
    return false
end

function __CP:NoMulti()
    for i, CP in pairs(__ColorPickers) do CP:__finalize() end
end

function __CP:PasteHEX()
    local hex = GetClipboardText() or "FFFFFF"
    local c = self.c
    c.r, c.g, c.b = c:HEX2RGB(hex)
    c.h, c.s, c.l = c:RGB2HSL({ c.r, c.g, c.b })
end

function __CP:CopyHEX()
    SetClipboardText("#" .. self.c:HSL2HEX())
end

function __CP:ColorVariants(x, y)
    local cv = {}
    cv.colors = {
        { 161, 174, 164 }, { 78, 78, 78 }, { 103, 2, 255 }, { 204, 51, 255 }, { 255, 51, 204 },
        { 51, 204, 255 }, { 0, 94, 255 }, { 6, 157, 9 }, { 191, 3, 50 }, { 255, 51, 102 },
        { 255, 201, 40 }, { 247, 107, 4 }, { 204, 255, 51 }, { 102, 255, 51 }, { 51, 255, 204 },
    }
    cv.sprite = self.sprite
    cv.xO, cv.yO = x, y
    cv.x, cv.y = self.x + x, self.y + y
    cv.txO = x
    cv.sxO = x
    cv.step = 0
    cv.duration = 1
    cv.playT = 0
    cv.easing = function(step, sPos, tPos)
        step = step - 1
        return tPos * (step ^ 3 + 1) + sPos
    end
    cv.W = 148
    cv.H = 98
    cv.sX = 663
    cv.sY = 0
    cv.buttons = {
        open = __CP__Button(cv, 129, 38, 9, 18, 565, 96, 18,
            function()
                cv.txO = 496
                cv.sxO = cv.xO
                cv.playT = os.clock()
                cv.buttons.open.disabled = true
                cv.buttons.close.disabled = false
            end),
        close = __CP__Button(cv, 129, 38, 9, 18, 574, 96, 18,
            function()
                cv.txO = 367
                cv.sxO = cv.xO
                cv.playT = os.clock()
                cv.buttons.close.disabled = true
                cv.buttons.open.disabled = false
            end),
        more = __CP__Button(cv, 51, 82, 27, 7, 632, 78, 7,
            function()
                os.executePowerShellAsync("Start-Process -FilePath 'http://botoflegends.com/forum/topic/6469-bol-hsla-color-picker/'")
                DelayAction(function() if IsFocused() then SetForeground() end end, 2)
            end),
    }
    cv.buttons.close.disabled = true
    cv.buttons.more.disabled = true

    cv.colorButtons = {}
    for i, color in pairs(cv.colors) do
        local W, H = 23, 22
        local x = 7 + (i - 1) % 5 * W
        local y = 11 + math.floor((i - 1) / 5) * H
        cv.colorButtons[i] = __CP__NoSpriteButton(cv, x, y, W, H, "", color[1], color[2], color[3], 255,
            function()
                self.c.h, self.c.s, self.c.l = self.c:RGB2HSL({ color[1], color[2], color[3] })
            end)
    end

    cv.OnDraw = function()
    -- Color variants:
        local cv = self.cv
        cv.step = math.min(1, (os.clock() - cv.playT) / cv.duration)
        cv.xO = cv.duration > 0 and cv.easing(cv.step, cv.sxO, cv.txO - cv.sxO) or cv.txO
        cv.x = self.x + cv.xO
        cv.y = self.y + cv.yO
        if cv.xO > 370 then -- enable buttons
            cv.buttons.more.disabled = false
            for i, button in pairs(cv.colorButtons) do button.disabled = false end
        else
            cv.buttons.more.disabled = true
            for i, button in pairs(cv.colorButtons) do button.disabled = true end
        end
        for i, button in pairs(cv.colorButtons) do button:OnDraw() end
        DrawUiObjFromSprite(self.sprite, cv, 255)
        for i, button in pairs(cv.buttons) do if not button.noSprite then button:OnDraw() end end
    end

    return cv
end

function __CP:OnTick()
    local cPos = GetCursorPos()
    for i, button in pairs(self.buttons) do if not button.noSprite then button:OnTick(cPos) end end
    for i, button in pairs(self.cv.buttons) do if not button.noSprite then button:OnTick(cPos) end end
    for i, button in pairs(self.cv.colorButtons) do button:OnTick(cPos) end
end

function __CP:OnDraw()
    local cPos = GetCursorPos()
    -- Chosen color:
    self.c:Update()
    DrawRectangle(self.x + 28, self.y + 35, 61, 61, ARGB(self.c.a, self.c.r, self.c.g, self.c.b))
    DrawUiObjFromSprite(self.sprite, self, 255)
    -- HEX Color Code:
    DrawTextA("" .. self.c:HSL2HEX(), 12, self.x + 59, self.y + 83, ARGB(255, 255, 255, 255), "center")
    -- Buttons:
    for i, button in pairs(self.buttons) do
        if not button.noSprite then button:OnDraw() end
    end
    --DrawRectangle(self.x+35, self.y+5, 110, 20, ARGB(150,255,255,255)) -- moving / CP window title area
    -- Drag:
    if not __ColorPickers_drag and IsKeyDown(0x01) and cPos.x >= self.x + 35 and cPos.x <= self.x + 35 + 110 and cPos.y >= self.y + 5 and cPos.y <= self.y + 5 + 20 then
        __ColorPickers_drag = true
        self.drag = true
        self.xDrag = cPos.x - self.x
        self.yDrag = cPos.y - self.y
    elseif self.drag and not IsKeyDown(0x01) then
        __ColorPickers_drag = false
        self.drag = false
    elseif self.drag and IsKeyDown(0x01) then
        self.x = cPos.x - self.xDrag
        self.y = cPos.y - self.yDrag
    end
end

function __CP:NoSpriteTick() -- Ticking while sprite is not loaded or when it cannot be loaded
    local cPos = GetCursorPos()
    for i, button in pairs(self.buttons) do
        if button.noSprite then button:OnTick(cPos) end
    end
end

function __CP:NoSpriteDraw() -- Drawing UI while sprite is not loaded or when it cannot be loaded
    local cX, cY = WINDOW_W / 2, WINDOW_H / 2
    DrawRectangle(cX - 90, cY - 100, 180, 230, ARGB(100, 20, 20, 20))
    DrawTextA("Loading sprites...", 20, cX, cY - 80, ARGB(255, 255, 255, 255), "center")
    for i, button in pairs(self.buttons) do
        if button.noSprite then button:OnDraw() end
    end
    DrawTextA("Color Code: " .. self.c:HSL2HEX(), 12, cX, cY + 30, ARGB(255, 255, 255, 255), "center")
    DrawRectangle(cX - 30, cY + 50, 60, 20, ARGB(self.c.a, self.c.r, self.c.g, self.c.b))
    DrawTextA("If sprites are not loading", 12, cX, cY + 80, ARGB(200, 255, 255, 255), "center")
    DrawTextA("copy-paste HEX color code.", 12, cX, cY + 95, ARGB(200, 255, 255, 255), "center")
end

function __CP:Return()
    self.c:Update()
    self.sConfigParam[1] = self.c.a
    self.sConfigParam[2] = self.c.r
    self.sConfigParam[3] = self.c.g
    self.sConfigParam[4] = self.c.b
    self:__finalize()
end

function __CP:__finalize()
    __ColorPickers_drag = false
    for i, CP in pairs(__ColorPickers) do if CP.id == self.id then table.remove(__ColorPickers, i) end end
end

class("__CP__Button")

function __CP__Button:__init(parent, x, y, W, H, sX, sY, aO, action)
    self.parent = parent
    self.xO, self.yO = x, y
    self.x, self.y = self.parent.x + x, self.parent.y + y
    self.W, self.H = W, H
    self.sX, self.sY = sX, sY
    self.sXold, self.sYold = sX, sY
    self.aO = aO
    self.action = action
    self.isPressed = false
    return self
end

function __CP__Button:OnTick(cPos)
    if self.disabled then return end
    if not __ColorPickers_drag and not IsKeyDown(0x01)
            and cPos.x >= self.x and cPos.x <= self.x + self.W
            and cPos.y >= self.y and cPos.y <= self.y + self.H then -- mouseover
        self.sY = self.sYold + self.aO * 1
    elseif not __ColorPickers_drag and IsKeyDown(0x01)
            and cPos.x >= self.x and cPos.x <= self.x + self.W
            and cPos.y >= self.y and cPos.y <= self.y + self.H then -- mouse down (first click. no action)
        __ColorPickers_drag = true
        self.isPressed = true
    elseif self.isPressed and not IsKeyDown(0x01) then -- mouse up/release
        self.isPressed = false
        __ColorPickers_drag = false
        if cPos.x >= self.x and cPos.x <= self.x + self.W and cPos.y >= self.y and cPos.y <= self.y + self.H then -- mouse up on button. DO ACTION
            self.action()
        end
    elseif self.isPressed and IsKeyDown(0x01) then -- mouse down (holding)
        self.sY = self.sYold + self.aO * 2
    else -- anything else
        -- not mouse over, not mouse down, nothing...
        self.sY = self.sYold + self.aO * 0
    end
end

function __CP__Button:OnDraw()
    self.x = self.parent.x + self.xO
    self.y = self.parent.y + self.yO
    if self.disabled then return end
    DrawUiObjFromSprite(self.parent.sprite, self, 255)
end

class("__CP__NoSpriteButton")

function __CP__NoSpriteButton:__init(parent, x, y, W, H, text, r, g, b, a, action)
    self.parent = parent
    self.W, self.H = W, H
    self.xO, self.yO = x, y
    self.x, self.y = parent.x + self.xO, parent.y + self.yO
    self.r, self.g, self.b, self.a = r, g, b, a
    self.text = text
    self.action = action
    self.noSprite = true
    self.isPressed = false
    return self
end

function __CP__NoSpriteButton:OnTick(cPos)
    if self.disabled then return end
    if not __ColorPickers_drag and not IsKeyDown(0x01)
            and cPos.x >= self.x and cPos.x <= self.x + self.W
            and cPos.y >= self.y and cPos.y <= self.y + self.H then -- mouseover
        self.a = 150
    elseif not __ColorPickers_drag and IsKeyDown(0x01)
            and cPos.x >= self.x and cPos.x <= self.x + self.W
            and cPos.y >= self.y and cPos.y <= self.y + self.H then -- mouse down (first click. no action)
        __ColorPickers_drag = true
        self.isPressed = true
    elseif self.isPressed and not IsKeyDown(0x01) then -- mouse up/release
        self.isPressed = false
        __ColorPickers_drag = false
        if cPos.x >= self.x and cPos.x <= self.x + self.W and cPos.y >= self.y and cPos.y <= self.y + self.H then -- mouse up on button. DO ACTION
            self.action()
        end
    elseif self.isPressed and IsKeyDown(0x01) then -- mouse down (holding)
        self.a = 100
    else -- anything else
        -- not mouse over, not mouse down, nothing...
        self.a = 255
    end
end

function __CP__NoSpriteButton:OnDraw()
    self.x = self.parent.x + self.xO
    self.y = self.parent.y + self.yO
    if self.disabled then return end
    DrawRectangle(self.x, self.y, self.W, self.H, ARGB(self.a, self.r, self.g, self.b))
    if self.text and self.text ~= "" then DrawTextA("" .. self.text, 12, self.x + self.W / 2, self.y + self.H / 2 - 5, ARGB(self.a, 255, 255, 255), "center") end
end

class("__CP__Picker")

function __CP__Picker:__init(cp, type, x, y)
    self.cp = cp
    self.type = type
    self.min = 0
    self.max = self.type == "h" and 360 or self.type == "a" and 255 or 100
    self.W = 360
    self.H = 14
    self.xO = x
    self.yO = y + 1
    self.x = self.cp.x + self.xO
    self.y = self.cp.y + self.yO
    self.sX = 0
    self.sY = 142 + 14 * (self.type == "h" and 0 or self.type == "s" and 1 or self.type == "l" and 2 or self.type == "a" and 4 or 0)
    self.alphaHack = { W = self.W, H = self.H, xO = self.xO, yO = self.yO, x = self.cp.x + self.xO, y = self.cp.y + self.yO, sX = self.sX, sY = 142 + 14 * 3 }
    local c = self.cp.c
    self.current = c[type]
    self.color = __CP__Color(c.h, c.s, c.l, c.a)
    self:Cursor()
end

function __CP__Picker:Cursor()
    self.cursor = {}
    self.cursor.W = 18
    self.cursor.H = 18
    self.cursor.sX = 565
    self.cursor.sY = 78
    self.cursor.x = math.limit(math.ceil(self.x + self.W * (self.current / self.max)), self.x - 2, self.x + self.W - self.cursor.W)
    self.cursor.y = math.ceil(self.y + self.H / 2 - self.cursor.H / 2 + 1)
end

function __CP__Picker:OnTick()
    local cPos = GetCursorPos()
    local c = self.cursor
    -- Mouse overlaying picker:
    if not __ColorPickers_drag and IsKeyDown(0x01) and cPos.x >= self.x and cPos.x <= self.x + self.W and cPos.y >= self.y and cPos.y <= self.y + self.H then
        self.cursor.drag = true
        __ColorPickers_drag = true
    elseif self.cursor.drag and not IsKeyDown(0x01) then
        self.cursor.drag = false
        __ColorPickers_drag = false
    elseif self.cursor.drag and IsKeyDown(0x01) then
        self.cp.c[self.type] = math.floor(self.max * ((c.x + c.W / 2 - self.x - c.W / 2) / (self.W - c.W)))
    end
    self.current = self.cp.c[self.type]
end

function __CP__Picker:Cursor_OnDraw()
    -- Cursor:
    local cPos = GetCursorPos()
    local c = self.cursor
    c.y = self.y + self.H / 2 - c.H / 2 + 1
    if c.drag then
        c.x = math.limit(math.floor(cPos.x - c.W / 2), self.x, self.x + self.W - c.W)
    else
        c.x = math.limit(self.x + (self.W - c.W) * (self.current / self.max), self.x, self.x + self.W - c.W)
    end
    DrawUiObjFromSprite(self.cp.sprite, c, 255) -- cursor
    DrawText(self.type:upper() .. ": " .. self.current, 12, self.x + self.W + 3, self.y + 1, ARGB(255, 255, 255, 255)) -- text ("H: 343" for example)
end

function __CP__Picker:OnDraw()
    self.x = self.cp.x + self.xO
    self.y = self.cp.y + self.yO
    self.alphaHack.x = self.cp.x + self.xO
    self.alphaHack.y = self.cp.y + self.yO
    local cpc = self.cp.c
    local sc = self.color
    if self.type == "s" then
        sc.r, sc.g, sc.b = sc:HSL2RGB({ cpc.h, 100, cpc.l })
    elseif self.type == "l" then
        sc.r, sc.g, sc.b = sc:HSL2RGB({ cpc.h, cpc.s, 50 })
    elseif self.type == "a" then
        sc.r, sc.g, sc.b = sc:HSL2RGB({ cpc.h, cpc.s, cpc.l })
    end
    DrawRectangle(self.x, self.y, self.W, self.H, ARGB(255, sc.r, sc.g, sc.b))
    DrawUiObjFromSprite(self.cp.sprite, self, 255) -- overlay
    -- Alpha hack overlay:
    if self.type ~= "a" then
        DrawUiObjFromSprite(self.cp.sprite, self.alphaHack, 255 - cpc.a)
    end
end

class("__CP__Color")

function __CP__Color:__init(h, s, l, a)
    self.h, self.s, self.l, self.a = h, s, l, a
    self.r, self.g, self.b = self:HSL2RGB()
end

function __CP__Color:Update(cpc)
    cpc = cpc or self
    self.h, self.s, self.l, self.a = cpc.h, cpc.s, cpc.l, cpc.a
    self.r, self.g, self.b = self:HSL2RGB()
end

function __CP__Color:randomize()
    self.h, self.s, self.l, self.a = math.random(0, 360), math.random(0, 100), math.random(0, 50), 255
end

function __CP__Color:ValidateHEX(hex)
    hex = hex:upper()
    if hex:find("#") then hex = hex:sub(2, 7) end
    hex = hex:gsub("[^A-F0-9]", "0")
    if hex:len() > 6 then hex = hex:sub(0, 6) elseif hex:len() < 6 then hex = hex:sub(1, 3) hex = hex:gsub(".", "%1%1") end
    return hex
end

function __CP__Color:HEX2RGB(hex)
    hex = self:ValidateHEX(hex)
    local r, g, b = "00", "00", "00"
    if hex:len() == 6 then
        r, g, b = hex:sub(1, 2), hex:sub(3, 4), hex:sub(5, 6)
    else
        if hex:len() > 4 then r = hex:sub(4, hex:len()) hex = hex:sub(0, 4) end
        if hex:len() > 2 then g = hex:sub(2, hex:len()) hex = hex:sub(0, 2) end
        if hex:len() > 0 then b = hex:sub(0, hex:len()) end
    end
    return self:HEX2INT(r), self:HEX2INT(g), self:HEX2INT(b)
end

function __CP__Color:RGB2HEX(rgb)
    local rgb = rgb or { self.r, self.g, self.b }
    return self:INT2HEX(rgb[1]) .. self:INT2HEX(rgb[2]) .. self:INT2HEX(rgb[3])
end

function __CP__Color:INT2HEX(dec) -- is it ok?
    local result = string.format("%X", dec)
    if result:len() == 1 then result = "0" .. result end
    return result
end

function __CP__Color:HEX2INT(hex)
    return tonumber(hex, 16)
end

function __CP__Color:RGB2HSL(rgb)
    local rgb = rgb or { self.r, self.g, self.b }
    local r = rgb[1] / 255
    local g = rgb[2] / 255
    local b = rgb[3] / 255
    local max = math.max(r, g, b)
    local min = math.min(r, g, b)
    local diff = max - min
    local add = max + min
    local hue = min == max and 0
            or r == max and ((60 * (g - b) / diff) + 360) % 360
            or g == max and (60 * (b - r) / diff) + 120
            or (60 * (r - g) / diff) + 240
    local lum = 0.5 * add
    local sat = lum == 0 and 0
            or lum == 1 and 1
            or lum <= 0.5 and diff / add
            or diff / (2 - add)
    local h = math.round(hue)
    local s = math.round(sat * 100)
    local l = math.round(lum * 100)
    return h, s, l
end

function __CP__Color:HSL2RGB(hsl)
    local hsl = hsl or { self.h, self.s, self.l }
    local h = hsl[1] / 360
    local s = hsl[2] / 100
    local l = hsl[3] / 100
    local q = l <= .5 and l * (1 + s) or l + s - (l * s)
    local p = 2 * l - q
    local rt = h + 1 / 3
    local gt = h
    local bt = h - 1 / 3
    local r = math.round(self:HUE2RGB(p, q, rt) * 255)
    local g = math.round(self:HUE2RGB(p, q, gt) * 255)
    local b = math.round(self:HUE2RGB(p, q, bt) * 255)
    return r, g, b
end

function __CP__Color:HSL2HEX(hsl)
    local hsl = hsl or { self.h, self.s, self.l }
    local h = hsl[1] / 360
    local s = hsl[2] / 100
    local l = hsl[3] / 100
    local r, g, b = self:HSL2RGB(hsl)
    local hex = self:RGB2HEX({ r, g, b })
    return hex
end

function __CP__Color:HUE2RGB(p, q, h)
    h = (h < 0 and h + 1) or (h > 1 and h - 1) or h
    if h * 6 < 1 then
        return p + (q - p) * h * 6
    elseif h * 2 < 1 then
        return q
    elseif h * 3 < 2 then
        return p + (q - p) * ((2 / 3) - h) * 6
    else
        return p
    end
end

--  Muramana toggler
--[[
    MuramanaIsActive()                      Return true / false
    MuramanaOn()                            Set Muramana On if possible
    MuramanaOff()                           Set Muramana Off if possible
    MuramanaToggle(range, extCondition)     Toggle Muramana based on enemy in range (number) and external condition (nil or boolean)
]]
local _muramana = { init = true, id = 3042, nextTick = 0, tick = 2500, particle = "ItemMuramanaToggle.troy", object = nil }
local __muramana__OnCreateObj
local function _muramana__Init()
    if _muramana.init then
        function __muramana__OnCreateObj(object)
            if object and object.valid and object.name == _muramana.particle and GetDistanceSqr(object) < 2500 then
                _muramana.object = object
            end
        end

        AddCreateObjCallback(__muramana__OnCreateObj)
        for i = 1, objManager.maxObjects do
            __muramana__OnCreateObj(objManager:getObject(i))
        end
        _muramana.init = false
    end
end

function MuramanaIsActive()
    _muramana__Init()
    return (_muramana.object ~= nil and _muramana.object.valid)
end

function MuramanaToggle(range, extCondition)
    assert(type(range) == "number", "MuramanaToggle: expected <number> for range)")
    assert((extCondition == nil or type(extCondition) == "boolean"), "MuramanaToggle: expected <boolean> or nil for extCondition)")
    if extCondition == nil then extCondition = true end
    if (_muramana.nextTick > GetTickCount()) then return end
    _muramana.nextTick = GetTickCount() + _muramana.tick
    local muramanaActived = MuramanaIsActive()
    if GetInventoryItemIsCastable(_muramana.id) then
        _muramana.tick = 200
        local enemyInRange = (CountEnemyHeroInRange(range) > 0)
        if (not muramanaActived and enemyInRange and extCondition) or (muramanaActived and (not enemyInRange or not extCondition)) then
            CastItem(_muramana.id)
        end
    end
end

function MuramanaOn()
    if (MuramanaIsActive() == false) then CastItem(_muramana.id) end
end

function MuramanaOff()
    if (MuramanaIsActive()) then CastItem(_muramana.id) end
end

--  Ward finder
--[[
    Know limitation :
    - as we can't get the real state of used stone, reload the script will disable them till base.
    - as we can't get the real state of WriggleLantern, reload the script will disable it for 3 min
]]
local _wards = {
    WriggleLantern = { id = 3154, nextUse = GetTickCount() + 180000 },
	WardingTotem = { id = 3340 },
	GreaterTotem = { id = 3350 },
	GreaterStealthTotem = { id = 3361 },
	GreaterVisionTotem = { id = 3362 },
    Sightstone = { id = 2049 },
    RSightstone = { id = 2045 },
    ItemMiniWard = { id = 2050 },
    SightWard = { id = 2044 },
    VisionWard = { id = 2043 },
    Sightstone_Used = 5,
    SlotUpdateTick = 0,
    Sightstone_nextUse = 0,
}
local __wards__OnTick, __wards__OnProcessSpell
local function _wardsUse()
    if not __wards__OnTick then
        function __wards__OnTick()
            if InFountain() then _wards.Sightstone_Used = 0 end
            if _wards.SlotUpdateTick < GetTickCount() then
                _wards.SlotUpdateTick = GetTickCount() + 500
                _wards.WriggleLantern.slot = GetInventorySlotItem(_wards.WriggleLantern.id)
				_wards.WardingTotem.slot = GetInventorySlotItem(_wards.WardingTotem.id)
				_wards.GreaterTotem.slot = GetInventorySlotItem(_wards.GreaterTotem.id)
				_wards.GreaterStealthTotem.slot = GetInventorySlotItem(_wards.GreaterStealthTotem.id)
				_wards.GreaterVisionTotem.slot = GetInventorySlotItem(_wards.GreaterVisionTotem.id)
                _wards.Sightstone.slot = GetInventorySlotItem(_wards.Sightstone.id)
                _wards.RSightstone.slot = GetInventorySlotItem(_wards.RSightstone.id)
                _wards.ItemMiniWard.slot = GetInventorySlotItem(_wards.ItemMiniWard.id)
                _wards.SightWard.slot = GetInventorySlotItem(_wards.SightWard.id)
                _wards.VisionWard.slot = GetInventorySlotItem(_wards.VisionWard.id)
            end
            _wards.WriggleLantern.r_slot = ((_wards.WriggleLantern.slot and player:CanUseSpell(_wards.WriggleLantern.slot) and _wards.WriggleLantern.nextUse < GetTickCount()) and _wards.WriggleLantern.slot or nil) -- Wriggle lantern
            _wards.WardingTotem.r_slot = ((_wards.WardingTotem.slot and player:CanUseSpell(_wards.WardingTotem.slot)) and _wards.WardingTotem.slot or nil)
			_wards.GreaterTotem.r_slot = ((_wards.GreaterTotem.slot and player:CanUseSpell(_wards.GreaterTotem.slot)) and _wards.GreaterTotem.slot or nil)
			_wards.GreaterStealthTotem.r_slot = ((_wards.GreaterStealthTotem.slot and player:CanUseSpell(_wards.GreaterStealthTotem.slot)) and _wards.GreaterStealthTotem.slot or nil)
			_wards.GreaterVisionTotem.r_slot = ((_wards.GreaterVisionTotem.slot and player:CanUseSpell(_wards.GreaterVisionTotem.slot)) and _wards.GreaterVisionTotem.slot or nil)
			_wards.Sightstone.r_slot = ((_wards.Sightstone.slot and _wards.Sightstone_Used < 4 and player:CanUseSpell(_wards.Sightstone.slot)) and _wards.Sightstone.slot or nil) -- Sightstone
            _wards.RSightstone.r_slot = ((_wards.RSightstone.slot and _wards.Sightstone_Used < 5 and player:CanUseSpell(_wards.RSightstone.slot)) and _wards.RSightstone.slot or nil)
            _wards.ItemMiniWard.r_slot = ((_wards.ItemMiniWard.slot and player:CanUseSpell(_wards.ItemMiniWard.slot)) and _wards.ItemMiniWard.slot or nil)
            _wards.SightWard.r_slot = ((_wards.SightWard.slot and player:CanUseSpell(_wards.SightWard.slot)) and _wards.SightWard.slot or nil)
            _wards.VisionWard.r_slot = ((_wards.VisionWard.slot and player:CanUseSpell(_wards.VisionWard.slot)) and _wards.VisionWard.slot or nil)
        end

        AddTickCallback(__wards__OnTick)
    end
    if not __wards__OnProcessSpell then
        function __wards__OnProcessSpell(unit, spell)
            if unit.isMe then
                local spellName = spell.name:lower()
                if spellName == "itemghostward" and _wards.Sightstone_nextUse < GetTickCount() then
                    _wards.Sightstone_nextUse = GetTickCount() + 500
                    _wards.Sightstone_Used = _wards.Sightstone_Used + 1
                elseif spellName == "wrigglelantern" then
                    _wards.WriggleLantern.nextUse = GetTickCount() + 180000
                end
            end
        end

        AddProcessSpellCallback(__wards__OnProcessSpell)
    end
end

function GetWardSlot()
    _wardsUse()
    if _wards.WriggleLantern.r_slot then return _wards.WriggleLantern.r_slot
	elseif _wards.WardingTotem.r_slot then return _wards.WardingTotem.r_slot
	elseif _wards.GreaterTotem.r_slot then return _wards.GreaterTotem.r_slot
	elseif _wards.GreaterStealthTotem.r_slot then return _wards.GreaterStealthTotem.r_slot
    elseif _wards.Sightstone.r_slot then return _wards.Sightstone.r_slot
    elseif _wards.RSightstone.r_slot then return _wards.RSightstone.r_slot
    elseif _wards.ItemMiniWard.r_slot then return _wards.ItemMiniWard.r_slot
    elseif _wards.SightWard.r_slot then return _wards.SightWard.r_slot
	elseif _wards.GreaterVisionTotem.r_slot then return _wards.GreaterVisionTotem.r_slot
    elseif _wards.VisionWard.r_slot then return _wards.VisionWard.r_slot
    end
end

function GetPinkWardSlot()
    _wardsUse()
	if _wards.GreaterVisionTotem.r_slot then return _wards.GreaterVisionTotem.r_slot
	elseif _wards.VisionWard.r_slot then return _wards.VisionWard.r_slot
    end
end

function GetWardsSlots()
    _wardsUse()
    return _wards.WriggleLantern.r_slot, _wards.WardingTotem.r_slot, _wards.GreaterTotem.r_slot, _wards.GreaterStealthTotem.r_slot, _wards.Sightstone.r_slot, _wards.RSightstone.r_slot, _wards.ItemMiniWard.r_slot, _wards.SightWard.r_slot, _wards.GreaterVisionTotem.r_slot, _wards.VisionWard.r_slot
end

--  Text and circles draws
--[[
]]
local _tcDraws, _tcDraws__OnDraw, _tcDraws__OnTick = { circle = false, text = false, modes = {} }, nil, nil
local function __tcDraws__init()
    if not _tcDraws.heroes then
        _tcDraws.heroes = {}
        for i = 1, heroManager.iCount do
            local hero = heroManager:getHero(i)
            if hero ~= nil and hero.networkID then
                _tcDraws.heroes[hero.networkID] = { hero = hero, state = 0, tick = 0 }
            end
        end
        function _tcDraws__OnDraw()
            if player.dead then return end
            if _tcDraws.circle then
                for _, target in pairs(_tcDraws.heroes) do
                    if target.state > 0 and target.hero.valid and target.hero.visible and not target.hero.dead then
                        if _tcDraws.modes[target.state] then
                            local mode = _tcDraws.modes[target.state]
                            if _tcDraws.circle and mode.circle > 0 then
                                local radius = 80
                                for j = 0, mode.circle do
                                    for k = 0, 10 do DrawCircle(target.hero.x, target.hero.y, target.hero.z, radius + j * 1.5, mode.color) end
                                    radius = radius + 30
                                end
                            end
                        end
                    end
                end
            end
        end

        AddDrawCallback(_tcDraws__OnDraw)
        function _tcDraws__OnTick()
            if player.dead then return end
            if _tcDraws.text then
                local tick = GetTickCount()
                for _, target in pairs(_tcDraws.heroes) do
                    if target.state > 0 and target.hero.valid and target.hero.visible and not target.hero.dead then
                        if _tcDraws.modes[target.state] then
                            local mode = _tcDraws.modes[target.state]
                            if target.tick < tick then
                                target.tick = tick + 1200
                                if mode.text1 then PrintFloatText(target.hero, mode.textType1, mode.text1) end
                                if mode.text2 then PrintFloatText(target.hero, mode.textType2, mode.text2) end
                            end
                        end
                    end
                end
            end
        end

        AddTickCallback(_tcDraws__OnTick)
    end
end

function TCDrawSetMode(index, circle, color, text1, textType1, text2, textType2)
    _tcDraws.modes[index] = {
        circle = circle,
        color = color,
        text1 = text1,
        textType1 = textType1,
        text2 = text2,
        textType2 = textType2,
    }
end

function TCDrawSetDrawCircle(state)
    assert(type(state) == "boolean", "TCDrawSetDrawCircle: expected <boolean> for State)")
    __tcDraws__init()
    _tcDraws.circle = state
end

function TCDrawSetDrawText(state)
    assert(type(state) == "boolean", "TCDrawSetDrawText: expected <boolean> for State)")
    __tcDraws__init()
    _tcDraws.text = state
end

function TCDrawSetDraw(circle, text)
    TCDrawSetDrawCircle(circle)
    TCDrawSetDrawText(text)
end

function TCDrawSetHero(hero, level)
    assert(hero and hero.valid and hero.networkID and type(level) == "number", "TCDrawSetHero: expected <hero>, <number> for level)")
    __tcDraws__init()
    if not _tcDraws.heroes[hero.networkID] then return end
    _tcDraws.heroes[hero.networkID].state = level
end


-------------------- WARNING FOR FUNCTIONS NOT USED ANYMORE ------------------------
-------------------- OLD FUNCTIONS KEPT FOR BACKWARD COMPATIBILITY -----------------
local deprecatedErrors = {}
local function deprecatedError(oldFunc, newFunc)
    if deprecatedErrors[oldFunc] or not GetCurrentEnv() or not GetCurrentEnv().FILE_NAME then return end
    deprecatedErrors[oldFunc] = true
    local t = "[" .. GetCurrentEnv().FILE_NAME .. "] " .. oldFunc .. " is deprecated and will be removed in the next major update of BoL."
    PrintChat(newFunc and t .. " Use " .. newFunc .. " instead." or t)
end

function GetDistance2D(...)
    deprecatedError("GetDistance2D()", "GetDistance()")
    return GetDistance(...)
end

function file_exists(...)
    deprecatedError("file_exists()", "FileExist()")
    return FileExist(...)
end

function timerText(...)
    deprecatedError("timerText()", "TimerText()")
    return TimerText(...)
end

function returnSprite(...)
    deprecatedError("returnSprite()", "GetSprite()")
    return GetSprite(...)
end

function GetEnemyHeros(...)
    deprecatedError("GetEnemyHeros()", "GetEnemyHeroes()")
    return GetEnemyHeroes(...)
end

function GetAllyHeros(...)
    deprecatedError("GetAllyHeros()", "GetAllyHeroes()")
    return GetAllyHeroes(...)
end

class'GameState'
function GameState:__init()
    deprecatedError("GameState()", "GetGame()")
    GetGame()
end

function GameState:gameIsOver()
    deprecatedError("GameState:gameIsOver()", "GetGame().isOver")
    return GetGame().isOver
end

function GameIsOver()
    deprecatedError("GameIsOver()", "GetGame().isOver")
    return GetGame().isOver
end

function GameWinner()
    deprecatedError("GameWinner()", "GetGame().winner")
    return GetGame().winner
end

function GameWin()
    deprecatedError("GameWin()", "GetGame().win")
    return GetGame().win
end

function GameLoser()
    deprecatedError("GameLoser()", "GetGame().loser")
    return GetGame().loser
end

function GetMap()
    deprecatedError("GetMap()", "GetGame().map")
    return GetGame().map
end

function get2DFrom3D(x, y, z)
    deprecatedError("get2DFrom3D()", "WorldToScreen()")
    local pos = WorldToScreen(D3DXVECTOR3(x, y, z))
    return pos.x, pos.y, OnScreen(pos.x, pos.y)
end

function GetStart(...)
    deprecatedError("GetStart()", "GetGame()")
    return GetGame(...)
end

-------------------- END OLD FUNCTIONS KEPT FOR BACKWARD COMPATIBILITY -------------
function Prediction__OnTick()
    deprecatedError("Prediction__OnTick()")
end

function SC__OnWndMsg(msg, key)
    deprecatedError("SC__OnWndMsg()")
end

function SC__OnDraw()
    deprecatedError("SC__OnDraw()")
end

function autoLevel__OnTick()
    deprecatedError("autoLevel__OnTick()")
end

function TargetSelector__OnSendChat(msg)
    deprecatedError("TargetSelector__OnSendChat()")
end

function TargetPrediction__OnTick()
    deprecatedError("TargetPrediction__OnTick()")
end

function minionManager__OnCreateObj(object)
    deprecatedError("minionManager__OnCreateObj()")
end

function minionManager__OnDeleteObj(object)
    deprecatedError("minionManager__OnDeleteObj()")
end

function ChampionLane__OnTick()
    deprecatedError("ChampionLane__OnTick()")
end

-------------------- END WARNING FOR FUNCTIONS NOT USED ANYMORE ----------------------
