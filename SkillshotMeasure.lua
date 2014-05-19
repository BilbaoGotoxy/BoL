-- Globals ---------------------------------------------------------------------

skillshotTable       = {}
spellDataCache       = {lastSpellName = nil, lastLineMissile = nil}

-- Code ------------------------------------------------------------------------

function OnLoad()
	PrintChat(" >> Skillshot Measure loaded")
end

function OnProcessSpell(object, spell)
	if object.name == player.name then
		spellDataCache.lastSpellName = spell.name

		spellDataCache[spellDataCache.lastSpellName] = {
			castPosition = {x = object.x, y = object.y, z = object.z},
			castSpellTick = GetTickCount()
		}
	end
end

function OnCreateObj(object)
	if spellDataCache.lastLineMissile ~= nil and spellDataCache.lastSpellName ~= nil then
		spellDataCache[spellDataCache.lastSpellName].particleObject = object
		skillshotTable[spellDataCache.lastSpellName].projectileName = object.name

		spellDataCache.lastSpellName   = nil
		spellDataCache.lastLineMissile = nil
	end
	
	if object.name == "LineMissile" and spellDataCache.lastSpellName ~= nil and lastLineMissile == nil then
		spellDataCache.lastLineMissile = object

		spellDataCache[spellDataCache.lastSpellName].startTick = GetTickCount()
		spellDataCache[spellDataCache.lastSpellName].lineMissileObject = object
		spellDataCache[spellDataCache.lastSpellName].maxRange = 0

		if skillshotTable[spellDataCache.lastSpellName] == nil then
			skillshotTable[spellDataCache.lastSpellName] = {
				castDelayTable       = {spellDataCache[spellDataCache.lastSpellName].startTick - spellDataCache[spellDataCache.lastSpellName].castSpellTick},
				projectileSpeedTable = {},
				rangeTable           = {}
			}
		else
			table.insert(skillshotTable[spellDataCache.lastSpellName].castDelayTable, spellDataCache[spellDataCache.lastSpellName].startTick - spellDataCache[spellDataCache.lastSpellName].castSpellTick)
		end
	end
end

function OnDeleteObj(object)
	if object.name == "LineMissile" then
		for spellName, spellDataCacheEntry in pairs(spellDataCache) do
			if spellName ~= "lastSpellName" and spellName ~= "lastLineMissile" then
				if spellDataCacheEntry.lineMissileObject ~= nil and object.networkID == spellDataCacheEntry.lineMissileObject.networkID then
					range = GetDistance(object, spellDataCacheEntry.castPosition)
					projectileSpeed = range / (GetTickCount() - spellDataCacheEntry.startTick) * 1000

					if range < spellDataCacheEntry.maxRange then
						range = spellDataCacheEntry.maxRange
						projectileSpeed = range / (GetTickCount() - spellDataCacheEntry.startTick) * 1000 / 2
					end

					table.insert(skillshotTable[spellName].projectileSpeedTable, projectileSpeed)
					table.insert(skillshotTable[spellName].rangeTable, range)

					spellDataCacheEntry.lineMissileObject = nil
					spellDataCacheEntry.particleObject = nil
				end
			end
		end
	end
end

function OnTick()
	for spellName, spellDataCacheEntry in pairs(spellDataCache) do
		if spellName ~= "lastSpellName" and spellName ~= "lastLineMissile" then
			if spellDataCacheEntry.lineMissileObject ~= nil then
				range = GetDistance(spellDataCacheEntry.lineMissileObject, spellDataCacheEntry.castPosition)
				if range > spellDataCacheEntry.maxRange then
					spellDataCacheEntry.maxRange = range
				end
			end
		end
	end
end

function OnDraw()
	topOffset = 10
	leftOffset = 10

	for spellName, skillshot in pairs(skillshotTable) do
		DrawText("spellName = " .. spellName, 16, leftOffset, topOffset, 0xFF00FF00)
		topOffset = topOffset + 15

		DrawText("projectileName = " .. skillshot.projectileName, 16, leftOffset, topOffset, 0xFF00FF00)
		topOffset = topOffset + 15

		minCastDelay = 99999
		maxCastDelay = 0
		castDelaySum = 0
		castDelayCount = 0
		for i, castDelay in ipairs(skillshot.castDelayTable) do
			if castDelay < minCastDelay then minCastDelay = castDelay end
			if castDelay > maxCastDelay then maxCastDelay = castDelay end
			castDelaySum = castDelaySum + castDelay
			castDelayCount = castDelayCount + 1
		end
		if castDelayCount > 0 then
			castDelayAverage = castDelaySum / castDelayCount
			DrawText("castDelay = " .. string.format("%.2f", castDelayAverage) .. " (" .. string.format("%.2f", minCastDelay) .. "-" .. string.format("%.2f", maxCastDelay) .. ")", 16, leftOffset, topOffset, 0xFF00FF00)
			topOffset = topOffset + 15
		end
	
		minProjectileSpeed = 99999
		maxProjectileSpeed = 0
		projectileSpeedSum = 0
		projectileSpeedCount = 0
		for i, projectileSpeed in ipairs(skillshot.projectileSpeedTable) do
			if projectileSpeed < minProjectileSpeed then minProjectileSpeed = projectileSpeed end
			if projectileSpeed > maxProjectileSpeed then maxProjectileSpeed = projectileSpeed end
			projectileSpeedSum = projectileSpeedSum + projectileSpeed
			projectileSpeedCount = projectileSpeedCount + 1
		end
		if projectileSpeedCount > 0 then
			projectileSpeedAverage = projectileSpeedSum / projectileSpeedCount
			DrawText("projectileSpeed = " .. string.format("%.2f", projectileSpeedAverage)  .. " (" .. string.format("%.2f", minProjectileSpeed) .. "-" .. string.format("%.2f", maxProjectileSpeed) .. ")", 16, leftOffset, topOffset, 0xFF00FF00)
			topOffset = topOffset + 15
		end

		minRange = 99999
		maxRange = 0
		rangeSum = 0
		rangeCount = 0
		for i, range in ipairs(skillshot.rangeTable) do
			if range < minRange then minRange = range end
			if range > maxRange then maxRange = range end
			rangeSum = rangeSum + range
			rangeCount = rangeCount + 1
		end
		if rangeCount > 0 then
			rangeAverage = rangeSum / rangeCount
			DrawText("range = " .. string.format("%.2f", rangeAverage)  .. " (" .. string.format("%.2f", minRange) .. "-" .. string.format("%.2f", maxRange) .. ")", 16, leftOffset, topOffset, 0xFF00FF00)
			topOffset = topOffset + 15
		end

		topOffset = topOffset + 25
	end

	for spellName, spellDataCacheEntry in pairs(spellDataCache) do
		if spellName ~= "lastSpellName" and spellName ~= "lastLineMissile" then
			if spellDataCacheEntry.lineMissileObject ~= nil then
				DrawCircle(spellDataCacheEntry.lineMissileObject.x, 0, spellDataCacheEntry.lineMissileObject.z, 70, 0x00FF00)
			end
		end
	end

	DrawCircle(myHero.x, myHero.y, myHero.z, GetDistance(myHero.minBBox, myHero.maxBBox) / 2, 0xFFFFFF)
end
