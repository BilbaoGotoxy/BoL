 --[[
    Collision 1.1.1 by Klokje
    ========================================================================
 
   
 
    -- Class -----------------------------------------------------------
    Collision(sRange, projSpeed, sDelay, sWidth)
   
 
    -- Operations ------------------------------------------------------
    GetMinionCollision(pStart, pEnd)
    GetHeroCollision(pStart, pEnd, mode)
    GetCollision(pStart, pEnd)
    DrawCollision(pStart, pEnd)
 
    Changelog
    ~~~~~~~~~
 
    1.0     - Initial release with Minion Collision and Hero Collision
 
    1.1     - Fixed bug with range check
            - Inceased range for minions witdh 10
 
    1.1.1    - Fixed bug what some people had that minions not updated
]]
-- Globals ---------------------------------------------------------------------
uniqueId = 0
 
 
-- Code ------------------------------------------------------------------------
 
class 'Collision' -- {
    HERO_ALL = 1
    HERO_ENEMY = 2
    HERO_ALLY = 3
 
 
    function Collision:__init(sRange, projSpeed, sDelay, sWidth)
        uniqueId = uniqueId + 1
        self.uniqueId = uniqueId
 
        self.sRange = sRange
        self.projSpeed = projSpeed
        self.sDelay = sDelay
        self.sWidth = sWidth/2
 
        self.enemyMinions = minionManager(MINION_ENEMY, 2000, myHero, MINION_SORT_HEALTH_ASC)
        self.minionupdate = 0
    end
 
    function Collision:GetMinionCollision(pStart, pEnd)
        self.enemyMinions:update()
 
        local distance =  GetDistance(pStart, pEnd)
        local prediction = TargetPredictionVIP(self.sRange, self.projSpeed, self.sDelay, self.sWidth)
        local mCollision = {}
 
        if distance > self.sRange then
            distance = self.sRange
        end
 
        local V = Vector(pEnd) - Vector(pStart)
        local k = V:normalized()
        local P = V:perpendicular2():normalized()
 
        local t,i,u = k:unpack()
        local x,y,z = P:unpack()
 
        local startLeftX = pStart.x + (x *self.sWidth)
        local startLeftY = pStart.y + (y *self.sWidth)
        local startLeftZ = pStart.z + (z *self.sWidth)
        local endLeftX = pStart.x + (x * self.sWidth) + (t * distance)
        local endLeftY = pStart.y + (y * self.sWidth) + (i * distance)
        local endLeftZ = pStart.z + (z * self.sWidth) + (u * distance)
       
        local startRightX = pStart.x - (x * self.sWidth)
        local startRightY = pStart.y - (y * self.sWidth)
        local startRightZ = pStart.z - (z * self.sWidth)
        local endRightX = pStart.x - (x * self.sWidth) + (t * distance)
        local endRightY = pStart.y - (y * self.sWidth) + (i * distance)
        local endRightZ = pStart.z - (z * self.sWidth)+ (u * distance)
 
        local startLeft = WorldToScreen(D3DXVECTOR3(startLeftX, startLeftY, startLeftZ))
        local endLeft = WorldToScreen(D3DXVECTOR3(endLeftX, endLeftY, endLeftZ))
        local startRight = WorldToScreen(D3DXVECTOR3(startRightX, startRightY, startRightZ))
        local endRight = WorldToScreen(D3DXVECTOR3(endRightX, endRightY, endRightZ))
       
        local poly = Polygon(Point(startLeft.x, startLeft.y),  Point(endLeft.x, endLeft.y), Point(startRight.x, startRight.y),   Point(endRight.x, endRight.y))
 
         for index, minion in pairs(self.enemyMinions.objects) do
            if minion ~= nil and minion.valid and not minion.dead then
                if GetDistance(pStart, minion) < distance then
                    local pos, t, vec = prediction:GetPrediction(minion)
                    local lineSegmentLeft = LineSegment(Point(startLeftX,startLeftZ), Point(endLeftX, endLeftZ))
                    local lineSegmentRight = LineSegment(Point(startRightX,startRightZ), Point(endRightX, endRightZ))
                    local toScreen, toPoint
                    if pos ~= nil then
                        toScreen = WorldToScreen(D3DXVECTOR3(minion.x, minion.y, minion.z))
                        toPoint = Point(toScreen.x, toScreen.y)
                    else
                        toScreen = WorldToScreen(D3DXVECTOR3(minion.x, minion.y, minion.z))
                        toPoint = Point(toScreen.x, toScreen.y)
                    end
 
 
                    if poly:contains(toPoint) then
                        table.insert(mCollision, minion)
                    else
                        if pos ~= nil then
                            distance1 = Point(pos.x, pos.z):distance(lineSegmentLeft)
                            distance2 = Point(pos.x, pos.z):distance(lineSegmentRight)
                        else
                            distance1 = Point(minion.x, minion.z):distance(lineSegmentLeft)
                            distance2 = Point(minion.x, minion.z):distance(lineSegmentRight)
                        end
                        if (distance1 < (getHitBoxRadius(minion)*2+10) or distance2 < (getHitBoxRadius(minion) *2+10)) then
                            table.insert(mCollision, minion)
                        end
                    end
                end
            end
        end
        if #mCollision > 0 then return true, mCollision else return false, mCollision end
    end
 
    function Collision:GetHeroCollision(pStart, pEnd, mode)
        if mode == nil then mode = HERO_ENEMY end
        local heros = {}
 
        for i = 1, heroManager.iCount do
            local hero = heroManager:GetHero(i)
            if (mode == HERO_ENEMY or mode == HERO_ALL) and hero.team ~= myHero.team then
                table.insert(heros, hero)
            elseif (mode == HERO_ALLY or mode == HERO_ALL) and hero.team == myHero.team and not hero.isMe then
                table.insert(heros, hero)
            end
        end
 
        local distance =  GetDistance(pStart, pEnd)
        local prediction = TargetPredictionVIP(self.sRange, self.projSpeed, self.sDelay, self.sWidth)
        local hCollision = {}
 
        if distance > self.sRange then
            distance = self.sRange
        end
 
        local V = Vector(pEnd) - Vector(pStart)
        local k = V:normalized()
        local P = V:perpendicular2():normalized()
 
        local t,i,u = k:unpack()
        local x,y,z = P:unpack()
 
        local startLeftX = pStart.x + (x *self.sWidth)
        local startLeftY = pStart.y + (y *self.sWidth)
        local startLeftZ = pStart.z + (z *self.sWidth)
        local endLeftX = pStart.x + (x * self.sWidth) + (t * distance)
        local endLeftY = pStart.y + (y * self.sWidth) + (i * distance)
        local endLeftZ = pStart.z + (z * self.sWidth) + (u * distance)
       
        local startRightX = pStart.x - (x * self.sWidth)
        local startRightY = pStart.y - (y * self.sWidth)
        local startRightZ = pStart.z - (z * self.sWidth)
        local endRightX = pStart.x - (x * self.sWidth) + (t * distance)
        local endRightY = pStart.y - (y * self.sWidth) + (i * distance)
        local endRightZ = pStart.z - (z * self.sWidth)+ (u * distance)
 
        local startLeft = WorldToScreen(D3DXVECTOR3(startLeftX, startLeftY, startLeftZ))
        local endLeft = WorldToScreen(D3DXVECTOR3(endLeftX, endLeftY, endLeftZ))
        local startRight = WorldToScreen(D3DXVECTOR3(startRightX, startRightY, startRightZ))
        local endRight = WorldToScreen(D3DXVECTOR3(endRightX, endRightY, endRightZ))
       
        local poly = Polygon(Point(startLeft.x, startLeft.y),  Point(endLeft.x, endLeft.y), Point(startRight.x, startRight.y),   Point(endRight.x, endRight.y))
 
        for index, hero in pairs(heros) do
            if hero ~= nil and hero.valid and not hero.dead then
                if GetDistance(pStart, hero) < distance then
                    local pos, t, vec = prediction:GetPrediction(hero)
                    local lineSegmentLeft = LineSegment(Point(startLeftX,startLeftZ), Point(endLeftX, endLeftZ))
                    local lineSegmentRight = LineSegment(Point(startRightX,startRightZ), Point(endRightX, endRightZ))
                    local toScreen, toPoint
                    if pos ~= nil then
                        toScreen = WorldToScreen(D3DXVECTOR3(pos.x, hero.y, pos.z))
                        toPoint = Point(toScreen.x, toScreen.y)
                    else
                        toScreen = WorldToScreen(D3DXVECTOR3(hero.x, hero.y, hero.z))
                        toPoint = Point(toScreen.x, toScreen.y)
                    end
 
 
                    if poly:contains(toPoint) then
                        table.insert(hCollision, hero)
                    else
                        if pos ~= nil then
                            distance1 = Point(pos.x, pos.z):distance(lineSegmentLeft)
                            distance2 = Point(pos.x, pos.z):distance(lineSegmentRight)
                        else
                            distance1 = Point(hero.x, hero.z):distance(lineSegmentLeft)
                            distance2 = Point(hero.x, hero.z):distance(lineSegmentRight)
                        end
                        if (distance1 < (getHitBoxRadius(hero)*2+10) or distance2 < (getHitBoxRadius(hero) *2+10)) then
                            table.insert(hCollision, hero)
                        end
                    end
                end
            end
        end
        if #hCollision > 0 then return true, hCollision else return false, hCollision end
    end
 
    function Collision:GetCollision(pStart, pEnd)
        local b , minions = self:GetMinionCollision(pStart, pEnd)
        local t , heros = self:GetHeroCollision(pStart, pEnd, HERO_ENEMY)
 
        if not b then return t, heros end
        if not t then return b, minions end
 
        local all = {}
 
        for index, hero in pairs(heros) do
            table.insert(all, hero)
        end
 
        for index, minion in pairs(minions) do
            table.insert(all, minion)
        end
 
        return true, all
    end
 
    function Collision:DrawCollision(pStart, pEnd)
       
        local distance =  GetDistance(pStart, pEnd)
 
        if distance > self.sRange then
            distance = self.sRange
        end
 
        local color = 4294967295
 
        local V = Vector(pEnd) - Vector(pStart)
        local k = V:normalized()
        local P = V:perpendicular2():normalized()
 
        local t,i,u = k:unpack()
        local x,y,z = P:unpack()
 
        local startLeftX = pStart.x + (x *self.sWidth)
        local startLeftY = pStart.y + (y *self.sWidth)
        local startLeftZ = pStart.z + (z *self.sWidth)
        local endLeftX = pStart.x + (x * self.sWidth) + (t * distance)
        local endLeftY = pStart.y + (y * self.sWidth) + (i * distance)
        local endLeftZ = pStart.z + (z * self.sWidth) + (u * distance)
       
        local startRightX = pStart.x - (x * self.sWidth)
        local startRightY = pStart.y - (y * self.sWidth)
        local startRightZ = pStart.z - (z * self.sWidth)
        local endRightX = pStart.x - (x * self.sWidth) + (t * distance)
        local endRightY = pStart.y - (y * self.sWidth) + (i * distance)
        local endRightZ = pStart.z - (z * self.sWidth)+ (u * distance)
 
        local startLeft = WorldToScreen(D3DXVECTOR3(startLeftX, startLeftY, startLeftZ))
        local endLeft = WorldToScreen(D3DXVECTOR3(endLeftX, endLeftY, endLeftZ))
        local startRight = WorldToScreen(D3DXVECTOR3(startRightX, startRightY, startRightZ))
        local endRight = WorldToScreen(D3DXVECTOR3(endRightX, endRightY, endRightZ))
 
        local colliton, objects = self:GetCollision(pStart, pEnd)
       
        if colliton then
            color = 4294901760
        end
 
        for i, object in pairs(objects) do
            DrawCircle(object.x,object.y,object.z,getHitBoxRadius(object)*2+20,4294901760)
        end
 
        DrawLine(startLeft.x, startLeft.y, endLeft.x, endLeft.y, 1, color)
        DrawLine(startRight.x, startRight.y, endRight.x, endRight.y, 1, color)
 
    end
 
    function getHitBoxRadius(target)
        return GetDistance(target, target.minBBox)/2
    end
-- }
