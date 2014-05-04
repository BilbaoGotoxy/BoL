--[[
     
    TimingLib Library by melol2
    Version 1.0
    Report bugs.
     
    ]]--
     
    Timer = {}
    Timer.__index = Timer
     
    function Timer.new()
       local object = {
                    fps = 0,
                    lastUpdate = nil,
                    frameCount = 0,
                    heroList = {},
                    heroVel = {},
                    totalFrames = 0,
                    startTime = 0,
                    scheduleList = {}
       }
       setmetatable(object, {
         __index    = Timer
       })
       
            return object
     end
     
    function Timer:fpsCounter()
            local currentTime = os.time()
            if self.startTime == 0 then self.startTime = currentTime end
            if self.lastUpdate == nil then
                    self.lastUpdate = currentTime
            elseif currentTime - self.lastUpdate >= 1 then
                    self.fps = (currentTime - self.lastUpdate)/self.frameCount
                    self.lastUpdate = currentTime
                    self.frameCount = 0
            else
                    self.frameCount = self.frameCount + 1
            end
            self.totalFrames = self.totalFrames + 1
    end
     
    function Timer:getCoords(obj)
            if obj then
                    local location = {}
                    location.x = obj.x
                    location.y = obj.y
                    location.z = obj.z
                    return location
            end
    end
     
    function Timer:getTime()
            return os.time() - self.startTime
    end
     
     
    function Timer:keepTime()
            for i,item in ipairs(self.scheduleList) do
                    item[2] = item[2] - (1*self.fps)
                    if item[2] <= 0 then
                            item[1](unpack(item[3]))
                            table.remove(self.scheduleList, i)
                    end
            end
    end
     
    function Timer:schedule(functionName, inSeconds, ...)
            local scheduleItem = {}
            scheduleItem[1] = functionName
            scheduleItem[2] = inSeconds
            scheduleItem[3] = arg
           
            table.insert(self.scheduleList, scheduleItem)
    end
     
    function Timer:trackPlayers()
            for i = 1, heroManager.iCount do
            local player = heroManager:GetHero( i )
            if player ~= nil then
                                    if self.heroList[i] == nil then self.heroList[i] = self:getCoords(player) end
                                    self.heroVel[i] = {}
                                    self.heroVel[i].x = player.x -  self.heroList[i].x
                                    self.heroVel[i].y = player.y -  self.heroList[i].y
                                    self.heroVel[i].z = player.z -  self.heroList[i].z
                                   
                                    self.heroList[i] = self:getCoords(player)
            end
            end
    end
     
    function Timer:predictMovement(iHero, inSeconds)
            if self.heroList[iHero] then
           
                    local targetNextMove = {}
                    targetNextMove.x = self.heroList[iHero].x + (self.heroVel[iHero].x * ((1/self.fps) * inSeconds))
                    targetNextMove.y = self.heroList[iHero].y + (self.heroVel[iHero].y * ((1/self.fps) * inSeconds))
                    targetNextMove.z = self.heroList[iHero].z + (self.heroVel[iHero].z * ((1/self.fps) * inSeconds))
     
                    return targetNextMove
            end
    end
     
    function Timer:tickHandler()
            self:trackPlayers()
            self:fpsCounter()
            self:keepTime()
            self:getTime()
    end
