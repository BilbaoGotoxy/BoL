spellList = {
	--AAtrox
	AatroxQ = {charName = "Aatrox", spellSlot = "Q", range = 650, width = 0, speed = 20,  delay = .5, spellType = "skillShot", riskLevel = "kill", cc = true, hitLineCheck = false},
	AatroxW = {charName = "Aatrox", spellSlot = "W", range = 0, width = 0, speed = 0, delay = 0, spellType = "selfCast", riskLevel = "noDmg", cc = false, hitLineCheck = false},
	aatroxw2 = {charName = "Aatrox", spellSlot = "W", range = 0, width = 0, speed = 0, delay = 0, spellType = "selfCast", riskLevel = "noDmg", cc = false, hitLineCheck = false},
	AatroxE = {charName = "Aatrox", spellSlot = "E", range = 1000, width = 150, speed = 1200, delay = .5, spellType = "skillShot", riskLevel = "extreme", cc = true, hitLineCheck = true},
	AatroxR = {charName = "Aatrox", spellSlot = "R", range = 550, width = 550, speed = 0, delay = 0, spellType = "selfCast", riskLevel = "kill", cc = false, hitLineCheck = false},
	-- Ahri
	AhriOrbofDeception = {charName = "Ahri", spellSlot = "Q", range = 880, width = 80, speed = 1100, delay = .5, spellType = "skillShot", riskLevel = "kill", cc = false, hitLineCheck = true},
	AhriFoxFire = {charName = "Ahri", spellSlot = "W", range = 800, width = 800, speed = 1800, delay = 0, spellType = "selfCast", riskLevel = "kill", cc = false,  hitLineCheck = false},
 	AhriSeduce = {charName = "Ahri", spellSlot = "E", range = 975,  width = 60, speed = 1200, delay = .5, spellType = "skillShot", riskLevel = "extreme", cc = true, hitLineCheck = true},
 	    --special spell
    AhriTumble = {charName = "Ahri", spellSlot = "R", range = 450, width = 0, speed = 2200, delay = .5, spellType = "skillshot", riskLevel = "kill", cc = false, hitLineCheck = false},
	--Akali
	AkaliMota = {charName = "Akali", spellSlot = "Q", range = 600, width = 0, speed = 1000, delay = .65, spellType = "enemyCast", riskLevel = "kill", cc = false, hitLineCheck = false},
	AkaliSmokeBomb = {charName = "Akali", spellSlot = "W", range = 700, width = 0, speed = 0, delay = .5, spellType = "skillShot", riskLevel = "dangerous", cc = true, hitLineCheck = false},
	AkaliShadowSwipe = {charName = "Akali", spellSlot = "E", range = 325, width = 325, speed = 0, delay = 0, spellType = "selfCast", riskLevel = "kill", cc = false, hitLineCheck = false},
	AkaliShadowDance = {charName = "Akali", spellSlot = "R", range = 800, width = 0, speed = 2200, delay = 0, spellType = "enemyCast", riskLevel = "kill", cc = false, hitLineCheck = false},
	--Alistar
	Pulverize = {charName = "Alistar", spellSlot = "Q", range = 365, width = 365, speed = 20, delay = .5, spellType  = "selfCast", riskLevel = "extreme", cc = true, hitLineCheck = false},
    Headbutt = {charName = "Alistar", spellSlot = "W", range = 100, width = 0 , speed = 0, delay = .5, spellType = "enemyCast", riskLevel = "extreme", cc = true, hitLineCheck = true},
    TriumphantRoar = {charName = "Alistar", spellSlot = "E", range = 575, width = 0 , speed = 0, delay = 0, spellType = "selfCast", riskLevel = "noDmg", cc = false, hitLineCheck = false, healSlot = _E},
    FerouciousHowl = {charName = "Alistar", spellSlot = "R", range = 0, width = 0, speed = 828, delay = 0, spellType = "selfCast", riskLevel = "noDmg", cc = false, hitLineCheck = false, qssSlot = _R},
 	-- Amumu
	BandageToss = {charName = "Amumu", spellSlot = "Q", range = 1100, width = 80, speed = 2000, delay = .5, spellType = "skillShot", riskLevel = "extreme", cc = true, hitLineCheck = true},
	AuraofDespair = {charName = "Amumu", spellSlot = "W", range = 300, width = 300, speed = math.huge, delay = .47, spellType = "selfCast", riskLevel = "kill", cc = false, hitLineCheck = false},
	Tantrum = {charName = "Amumu", spellSlot = "E", range = 350, width = 350, speed = math.huge, delay = .5, spellType = "selfCast", riskLevel = "kill", cc = false, hitLineCheck = false},
	CurseoftheSadMummy = {charName = "Amumu", spellSlot = "R", range = 550, width = 550, speed = math.huge, delay = .5, spellType = "selfCast", riskLevel = "extreme", cc = true, hitLineCheck = false, timer = 0},
	-- Anivia
	FlashFrost = {charName = "Anivia", spellSlot = "Q", range = 1200, width = 110, speed = 850, delay = .5, spellType = "skillShot", riskLevel = "extreme", cc = true, hitLineCheck = true},
	Crystalize = {charName = "Anivia", spellSlot = "W", range = 1000, width = 400, speed = 1600, delay = .5, spellType = "skillShot", riskLevel = "noDmg", cc = false, hitLineCheck = false},
	Frostbite = {charName = "Anivia", spellSlot = "E", range = 650, width = 0, speed = 1200, delay = .5, spellType = "enemyCast", riskLevel = "kill", cc = false, hitLineCheck = false},
	GlacialStorm = {charName = "Anivia", spellSlot = "R", range = 675, width = 400, speed = math.huge, delay = .3, spellType = "skillShot", riskLevel = "extreme", cc = true, hitLineCheck = false},
	--Annie
	Disintegrate = {charName = "Annie", spellSlot = "Q", range = 710, width = 0, speed = 1400, delay = .5, spellType = "enemyCast", riskLevel = "Kill", cc = false, hitLineCheck = false},
    Incinerate = {charName = "Annie", spellSlot = "W", range = 210, width = 0, speed = 0, delay = .5, spellType = "enemyCast", riskLevel = "Kill", cc = false, hitLineCheck = true},
    MoltenShield = {charName = "Annie", spellSlot = "E", range = 100, width = 0, speed = 20, delay = 0, spellType = "selfCast", rickLevel = "noDmg", cc = false, hitLineCheck = false, aaShieldSlot = _E},
    InfernalGuardian = {charName = "Annie", spellSlot = "R", range = 250, width = 0, delay = .5, spellType = "skillShot", risklevel = "Kill", cc = false, hitLineCheck = true, timer = 0},
	-- Ashe
	FrostShot = {charName = "Ashe", spellSlot = "Q", range = 0, width = 0, speed = math.huge, delay = 0, spellType = "selfCast", riskLevel = "noDmg", cc = false, hitLineCheck = false},
	frostarrow = {charName = "Ashe", spellSlot = "Q", range = 0, width = 0, speed = math.huge, delay = 0, spellType = "enemyCast", riskLevel = "extreme", cc = true, hitLineCheck = false},
	Volley = {charName = "Ashe", spellSlot = "W", range = 1200, width = 250, speed = 902, delay = .5, spellType = "skillShot", riskLevel = "extreme", cc = true, hitLineCheck = true},
	    --special spell: 2500 / 3250 / 4000 / 4750 / 5500 (range increase with level)
	AsheSpiritOfTheHawk = {charName = "Ashe", spellSlot = "E", range = 2500, width = 0, speed = 1400, delay = .5, spellType = "skillShot", riskLevel = "noDmg", cc = false, hitLineCheck = false},
	EnchantedCrystalArrow = {charName = "Ashe", spellSlot = "R", range = 50000, width = 130, speed = 1600, delay = .5, spellType = "skillShot", riskLevel = "extreme", cc = true, hitLineCheck = true},
	-- Blitzcrank
	RocketGrabMissile = {charName = "Blitzcrank", spellSlot = "Q", range = 925, width = 70, speed = 1800, delay = .22, spellType = "skillShot", riskLevel = "extreme", cc = true, hitLineCheck = true},
	Overdrive = {charName = "Blitzcrank", spellSlot = "W", range = 0, width = 0, speed = 0, delay = 0, spellType = "selfCast", riskLevel = "noDmg", cc = false, hitLineCheck = false},
	PowerFist = {charName = "Blitzcrank", spellSlot = "E", range = 0, width = 0, speed = 0, delay = 0, spellType = "selfCast", riskLevel = "extreme", cc = true, hitLineCheck = false},
	StaticField = {charName = "Blitzcrank", spellSlot = "R", range = 600, width = 600, speed = 0, delay = 0, spellType = "selfCast", riskLevel = "extreme", cc = true, hitLineCheck = false},
	-- Brand
	BrandBlaze = {charName = "Brand", spellSlot = "Q", range = 1150, width = 80, speed = 1200, delay = .5, spellType = "skillShot", riskLevel = "kill", cc = false, hitLineCheck = true},
	BrandFissure = {charName = "Brand", spellSlot = "W", range = 240, width = 0, speed = 20, delay = .5, spellType = "skillShot", riskLevel = "kill", cc = false,  hitLineCheck = false},
	BrandConflagration = {charName = "Brand", spellSlot = "E", range = 0, width = 0, speed = 1800, delay = 0, spellType = "enemyCast", riskLevel = "kill", cc = false, hitLineCheck = false},
	BrandWildfire = {charName = "Brand", spellSlot = "R", range = 0, width = 0, speed = 1000, delay = 0, spellType = "enemyCast", riskLevel = "kill", cc = false, hitLineCheck = false, timer = 230 - GetLatency()},
	-- Caitlyn
	CaitlynPiltoverPeacemaker = {charName = "Caitlyn", spellSlot = "Q", range = 1250, width = 90, speed = 2200, delay = .25, spellType = "skillShot", riskLevel = "kill", cc = false, hitLineCheck = true},
	CaitlynYordleTrap = {charName = "Caitlyn", spellSlot = "W", range = 800, width = 0, speed = 1400, delay = 0, spellType = "skillShot", riskLevel = "extreme", cc = true, hitLineCheck = false},
	CaitlynEntrapment = {charName = "Caitlyn", spellSlot = "E", range = 950, width = 80, speed = 2000, delay = .25, spellType = "skillShot", riskLevel = "extreme", cc = true, hitLineCheck = true},
	CaitlynAceintheHole = {charName = "Caitlyn", spellSlot = "R", range = 2500, width = 0, speed = 1500, delay = 0, spellType = "enemyCast", riskLevel = "kill", cc = false, hitLineCheck = false, timer = 1350-GetLatency()},
	-- Cassiopeia
	CassiopeiaNoxiousBlast = {charName = "Cassiopeia", spellSlot = "Q", range = 925, width = 130, speed = math.huge, delay = .25, spellType = "skillShot", riskLevel = "kill", cc = false, hitLineCheck = false},
	CassiopeiaMiasma = {charName = "Cassiopeia", spellSlot = "W", range = 925, width = 212, speed = 2500, delay = .5, spellType = "skillShot", riskLevel = "extreme", cc = true, hitLineCheck = false},
	CassiopeiaTwinFang = {charName = "Cassiopeia", spellSlot = "E", range = 700, width = 0, speed = 1900, delay = 0, spellType = "enemyCast", riskLevel = "kill", cc = false, hitLineCheck = false},
	CassiopeiaPetrifyingGaze = {charName = "Cassiopeia", spellSlot = "R", range = 875, width = 210, speed = math.huge, delay = .5, spellType = "skillShot", riskLevel = "extreme", cc = true, hitLineCheck = true, timer = 0},
	-- Cho'Gath
	Rupture = {charName = "Chogath", spellSlot = "Q", range = 1000, width = 250, speed = math.huge, delay = .5, spellType = "skillShot", riskLevel = "extreme", cc = true, hitLineCheck = false},
	FeralScream = {charName = "Chogath", spellSlot = "W", range = 675, width = 210, speed = math.huge, delay = .25, spellType = "skillShot", riskLevel = "extreme", cc = true, hitLineCheck = true},
	VorpalSpikes = {charName = "Chogath", spellSlot = "E", range = 0, width = 170, speed = 347, delay = 0, spellType = "enemyCast", riskLevel = "kill", cc = false, hitLineCheck = false},
	Feast = {charName = "Chogath", spellSlot = "R", range = 230, width = 0, speed = 500, delay = 0, spellType = "enemyCast", riskLevel = "kill", cc = false, hitLineCheck = false},
	-- Corki
	PhosphorusBomb = {charName = "Corki", spellSlot = "Q", range = 875, width = 250, speed = math.huge, delay = 0, spellType = "skillShot", riskLevel = "kill", cc = false, hitLineCheck = false},
	CarpetBomb = {charName = "Corki", spellSlot = "W", range = 875, width = 160, speed = 700, delay = 0, spellType = "skillShot", riskLevel = "kill", cc = false, hitLineCheck = true},
	GGun = {charName = "Corki", spellSlot = "E", range = 750, width = 100, speed = 902, delay = 0, spellType = "skillShot", riskLevel = "kill", cc = false, hitLineCheck = true},
	MissileBarrage = {charName = "Corki", spellSlot = "R", range = 1225, width = 40, speed = 828.5, delay = .25, spellType = "skillShot", riskLevel = "kill", cc = false, hitLineCheck = true},
	--Darius
    DariusCleave = {charName = "Darius", spellSlot = "Q", range = 425, width = 0, speed = 0, delay = .5, spellType = "skillShot", riskLevel = "kill", cc = false, hitLineCheck = false},
    DariusNoxianTacticsONH = {charName = "Darius", spellSlot = "W", range = 210, width = 0, speed = 0, delay = 0, spellType = "selfCast", riskLevel = "noDmg", cc = false, hitLineCheck = false},
    DariusAxeGrabCone = {charName = "Darius", spellSlot = "E", range = 540, width = 0, speed = 1500, delay = .5, spellType = "skillShot", riskLevel = "dangerous", cc = true, hitLineCheck = true},
    DariusExecute = {charName = "Darius", spellSlot = "R", range = 460, width = 0, speed = 20, delay = .5, spellType = "enemyCast", riskLevel = "kill", cc = false, hitLineCheck = false},
	-- Diana
	    --special spell (arc)
	DianaArc = {charName = "Diana", spellSlot = "Q", range = 900, width = 75, speed = 1500, delay = .5, spellType = "skillShot", riskLevel = "kill", cc = true, hitLineCheck = true},
	DianaOrbs = {charName = "Diana", spellSlot = "W", range = 0, width = 0, speed = 0, delay = 0, spellType = "selfCast", riskLevel = "extreme", cc = true, hitLineCheck = false, shieldSlot = _W},
	DianaVortex = {charName = "Diana", spellSlot = "E", range = 300, width = 300, speed = 1500, delay = .5, spellType = "selfCast", riskLevel = "dangerous", cc = true, hitLineCheck = false},
	DianaTeleport = {charName = "Diana", spellSlot = "R", range = 800, width = 0, speed = 1500, delay = .5, spellType = "enemyCast", riskLevel = "kill", cc = true, hitLineCheck = false},
	-- DrMundo
	InfectedCleaverMissileCast = {charName = "DrMundo", spellSlot = "Q", range = 900, width = 75, speed = 1500, delay = .5, spellType = "skillShot", riskLevel = "extreme", cc = true, hitLineCheck = true},
    BurningAgony = {charName = "DrMundo", spellSlot = "W", range = 225, width = 225, speed = math.huge, delay = math.huge, spellType = "selfCast", riskLevel = "kill", cc = false, hitLineCheck = false},--CC?
    Masochism = {charName = "DrMundo", spellSlot = "E", range = 0, width = 0, speed = math.huge, delay = math.huge, spellType = "selfCast", riskLevel = "noDmg", cc = false, hitLineCheck = false},
    Sadism = {charName = "DrMundo", spellSlot = "R", range = 0, width = 0, speed = math.huge, delay = math.huge, spellType = "selfCast", riskLevel = "noDmg", cc = false, hitLineCheck = false},
	-- Draven
	dravenspinning = {charName = "Draven", spellSlot = "Q", range = 0, width = 0, speed = math.huge, delay = math.huge, spellType = "selfCast", riskLevel = "noDmg", cc = false, hitLineCheck = false},
	DravenFury = {charName = "Draven", spellSlot = "W", range = 0, width = 0, speed = math.huge, delay = math.huge, spellType = "selfCast", riskLevel = "noDmg", cc = false, hitLineCheck = false},
	DravenDoubleShot = {charName = "Draven", spellSlot = "E", range = 1050, width = 130, speed = 1600, delay = .5, spellType = "skillShot", riskLevel = "extreme", cc = true, hitLineCheck = true},
	DravenRCast = {charName = "Draven", spellSlot = "R", range = 20000, width = 160, speed = 2000, delay = .5, spellType = "skillShot", riskLevel = "kill", cc = false, hitLineCheck = true},
	--Elise
	EliseHumanQ = {charName = "Elise", spellSlot = "Q", range = 625, width = 0, speed = 2200, delay = .75, spellType = "enemyCast", riskLevel = "kill", cc = false, hitLineCheck = false},
	EliseHumanW = {charName = "Elise", spellSlot = "W", range = 950, width = 235, speed = 5000, delay = .75, spellType = "skillShot", riskLevel = "kill", cc = false, hitLineCheck = false},
	EliseHumanE = {charName = "Elise", spellSlot = "E", range = 1075, width = 70, speed = 1450, delay = .5, spellType = "skillShot", riskLevel = "dangerous", cc = true, hitLineCheck = true},
	EliseR = {charName = "Elise", spellSlot = "R", range = 0, width = 0, speed = math.huge, delay = math.huge, spellType = "selfCast", riskLevel = "noDmg", cc = false, hitLineCheck = false},
	EliseSpiderQCast = {charName = "Elise", spellSlot = "Q", range = 475, width = 0, speed = math.huge, delay = .5, spellType = "enemyCast", riskLevel = "kill", cc = false, hitLineCheck = false},
	EliseSpiderW = {charName = "Elise", spellSlot = "W", range = 0, width = 0, speed = math.huge, delay = math.huge, spellType = "selfCast", riskLevel = "noDmg", cc = false, hitLineCheck = false},
	EliseSpiderEInitial = {charName = "Elise", spellSlot = "E", range = 975, width = 0, speed = math.huge, delay = math.huge, spellType = "enemyCast", riskLevel = "noDmg", cc = false, hitLineCheck = false},
	elisespideredescent = {charName = "Elise", spellSlot = "E", range = 975, width = 0, speed = math.huge, delay = math.huge, spellType = "enemyCast", riskLevel = "noDmg", cc = false, hitLineCheck = false},
	EliseSpiderR = {charName = "Elise", spellSlot = "R", range = 0, width = 0, speed = math.huge, delay = math.huge, spellType = "selfCast", riskLevel = "noDmg", cc = false, hitLineCheck = false},
	--Evelynn
	EvelynnQ = {charName = "Evelynn", spellSlot = "Q", range = 500, width = 500, speed = math.huge, delay = .5, spellType = "selfCast", riskLevel = "kill", cc = false, hitLineCheck = false},
	EvelynnW = {charName = "Evelynn", spellSlot = "W", range = 0, width = 0, speed = math.huge, delay = math.huge, spellType = "selfCast", riskLevel = "noDmg", cc = false, hitLineCheck = false, slowSlot = _W},
	EvelynnE = {charName = "Evelynn", spellSlot = "E", range = 290, width = 0, speed = 900, delay = .5, spellType = "enemyCast", riskLevel = "kill", cc = false, hitLineCheck = false},
	EvelynnR = {charName = "Evelynn", spellSlot = "R", range = 650, width = 350, speed = 1300, delay = .5, spellType = "skillShot", riskLevel = "extreme", cc = true, hitLineCheck = false},
		-- Ezreal
	EzrealMysticShot = {charName = "Ezreal", spellSlot = "Q", range = 1200, width = 60, speed = 2000, delay = .25, spellType = "skillShot", riskLevel = "kill", cc = false, hitLineCheck = true},
	EzrealEssenceFlux = {charName = "Ezreal", spellSlot = "W", range = 1050, width = 80, speed = 1600, delay = .25, spellType = "skillShot", riskLevel = "kill", cc = false, hitLineCheck = true},
	EzrealEssenceMissle = {charName = "Ezreal", spellSlot = "W", range = 1050, width = 80, speed = 1600, delay = .25, spellType = "skillShot", riskLevel = "kill", cc = false, hitLineCheck = true},
	EzrealArcaneShift = {charName = "Ezreal", spellSlot = "E", range = 475, width = 0, speed = math.huge, delay = .5, spellType = "enemyCast", riskLevel = "kill", cc = false, hitLineCheck = false},
	EzrealTruehotBarrage = {charName = "Ezreal", spellSlot = "R", range = 20000, width = 160, speed = 2000, delay = 1, spellType = "skillShot", riskLevel = "kill", cc = false, hitLineCheck = true},
	--FiddleSticks
	Terrify = {charName = "FiddleSticks", spellSlot = "Q", range = 575, width = 0, speed = math.huge, delay = .5, spellType = "enemyCast", riskLevel = "dangerous", cc = true, hitLineCheck = false},
	Drain = {charName = "FiddleSticks", spellSlot = "W", range = 575, width = 0, speed = math.huge, delay = .5, spellType = "enemyCast", riskLevel = "kill", cc = false, hitLineCheck = false},
	FiddlesticksDarkWind = {charName = "FiddleSticks", spellSlot = "E", range = 750, width = 0, speed = 1100, delay = .5, spellType = "skillShot", riskLevel = "kill", cc = false, hitLineCheck = false},
	Crowstorm = {charName = "FiddleSticks", spellSlot = "R", range = 800, width = 600, speed = math.huge, delay = .5, spellType = "enemyCast", riskLevel = "dangerous", cc = true, hitLineCheck = false, timer = 0},
	--Fiora
	FioraQ = {charName = "Fiora", spellSlot = "Q", range = 300 , width = 0, speed = 2200, delay = .5, spellType = "enemyCast", riskLevel = "kill", cc = false, hitLineCheck = false},
    FioraRiposte = {charName = "Fiora", spellSlot = "W", range = 100, width = 0, speed = 0, delay = 0, spellType = "selfCast", riskLevel = "noDmg", cc = false, hitLineCheck = false, aaShieldSlot = _W},
    FioraFlurry = {charName = "Fiora", spellSlot = "E", range = 210 , width = 0, speed = 0, delay = 0, spellType = "selfCast", riskLevel = "noDmg", cc = false, hitLineCheck = false},
    FioraDance = {charName = "Fiora", spellSlot = "R", range = 210, width = 0, speed = 0, delay = .5, spellType = "enemyCast", riskLevel = "kill", cc = false, hitLineCheck = false, timer = 280 - GetLatency()},
	--Fizz
	FizzPiercingStrike = {charName = "Fizz", spellSlot = "Q", range = 550 , width = 0 , speed = math.huge, delay = .5, spellType = "enemyCast", riskLevel = "kill", cc = false, hitLineCheck = false},
	FizzSeastonePassive = {charName = "Fizz", spellSlot = "W", range = 0 , width = 0 , speed = 0, delay = .5, spellType = "selfCast", riskLevel = "noDmg", cc = false, hitLineCheck = false},
	FizzJump = {charName = "Fizz", spellSlot = "E", range = 400 , width = 120 , speed = 1300, delay = .5, spellType = "selfcast", riskLevel = "extreme", cc = true, hitLineCheck = false, shieldSlot = _E},
	FizzJumptwo = {charName = "Fizz", spellSlot = "E", range = 400 , width = 500 , speed = 1300, delay = .5, spellType = "skillShot", riskLevel = "extreme", cc = true, hitLineCheck = false},
	FizzMarinerDoom = {charName = "Fizz", spellSlot = "R", range = 1275 , width = 250 , speed = 1200, delay = .5, spellType = "skillShot", riskLevel = "extreme", cc = true, hitLineCheck = false},
	-- Galio
	GalioResoluteSmite = {charName = "Galio", spellSlot = "Q", range = 940 , width = 120 , speed = 1300, delay = .5, spellType = "skillShot", riskLevel = "extreme", cc = true, hitLineCheck = false},
	GalioBulwark = {charName = "Galio", spellSlot = "W", range = 800 , width = 0 , speed = math.huge, delay = .5, spellType = "allyCast", riskLevel = "noDmg", cc = false, hitLineCheck = false, shieldSlot = _W},
	GalioRighteousGust = {charName = "Galio", spellSlot = "E", range = 1180 , width = 140 , speed = 1200, delay = .5, spellType = "skillShot", riskLevel = "kill", cc = false, hitLineCheck = true},
	GalioIdolOfDurand = {charName = "Galio", spellSlot = "R", range = 560 , width = 560 , speed = math.huge, delay = .5, spellType = "selfCast", riskLevel = "extreme", cc = true, hitLineCheck = false, timer = 0},
	--Gangplank
	Parley = {charName = "Gangplank", spellSlot = "Q", range = 625 , width = 0 , speed = 2000, delay = .5, spellType = "enemyCast", riskLevel = "kill", cc = false, hitLineCheck = false},
	RemoveScurvy = {charName = "Gangplank", spellSlot = "W", range = 0 , width = 0 , speed = math.huge, delay = .5, spellType = "selfCast", riskLevel = "noDmg", cc = false, hitLineCheck = false, healSlot = _W, qssSlot = _W},
	RaiseMorale = {charName = "Gangplank", spellSlot = "E", range = 1300 , width = 0 , speed = math.huge, delay = .5, spellType = "selfCast", riskLevel = "noDmg", cc = false, hitLineCheck = false},
	CannonBarrage = {charName = "Gangplank", spellSlot = "R", range = 20000 , width = 525 , speed = 500, delay = .5, spellType = "skillShot", riskLevel = "kill", cc = true, hitLineCheck = false},
	--Garen
	GarenQ = {charName = "Garen", spellSlot = "Q", range = 0 , width = 0 , speed = math.huge, delay = .2, spellType = "selfCast", riskLevel = "noDmg", cc = false, hitLineCheck = false, slowSlot = _Q},
	GarenW = {charName = "Garen", spellSlot = "W", range = 0 , width = 0 , speed = math.huge, delay = .5, spellType = "selfCast", riskLevel = "noDmg", cc = false, hitLineCheck = false, shieldSlot = _W},
	GarenE = {charName = "Garen", spellSlot = "E", range = 325 , width = 325, speed = 700, delay = 0, spellType = "selfCast", riskLevel = "kill", cc = false, hitLineCheck = false},
	GarenR = {charName = "Garen", spellSlot = "R", range = 400 , width = 0 , speed = math.huge, delay = .12, spellType = "enemyCast", riskLevel = "kill", cc = false, hitLineCheck = false},
	-- Gragas
	GragasBarrelRoll = {charName = "Gragas", spellSlot = "Q", range = 1100 , width = 320 , speed = 1000, delay = .3, spellType = "skillShot", riskLevel = "kill", cc = false, hitLineCheck = false},
	gragasbarrelrolltoggle = {charName = "Gragas", spellSlot = "Q", range = 1100 , width = 320 , speed = 1000, delay = .3, spellType = "skillShot", riskLevel = "kill", cc = false, hitLineCheck = false},
	GragasDrunkenRage = {charName = "Gragas", spellSlot = "W", range = 0 , width = 0 , speed = 0, delay = 0, spellType = "selfCast", riskLevel = "noDmg", cc = false, hitLineCheck = false},
	GragasBodySlam = {charName = "Gragas", spellSlot = "E", range = 1100 , width = 50 , speed = 1000, delay = .3, spellType = "skillShot", riskLevel = "extreme", cc = true, hitLineCheck = true},
	GragasExplosiveCask = {charName = "Gragas", spellSlot = "R", range = 1100 , width = 700 , speed = 1000, delay = .3, spellType = "skillShot", riskLevel = "extreme", cc = true, hitLineCheck = false},
	-- Graves
	GravesClusterShot = {charName = "Graves", spellSlot = "Q", range = 1100 , width = 10 , speed = 902, delay = .3, spellType = "skillShot", riskLevel = "kill", cc = false, hitLineCheck = true},
	GravesSmokeGrenade = {charName = "Graves", spellSlot = "W", range = 1100 , width = 250 , speed = 1650, delay = .3, spellType = "skillShot", riskLevel = "extreme", cc = true, hitLineCheck = false},
	gravessmokegrenadeboom = {charName = "Graves", spellSlot = "W", range = 1100 , width = 250 , speed = 1650, delay = .3, spellType = "skillShot", riskLevel = "extreme", cc = true, hitLineCheck = false},
	GravesMove = {charName = "Graves", spellSlot = "E", range = 425 , width = 50 , speed = 1000, delay = .3, spellType = "skillShot", riskLevel = "noDmg", cc = false, hitLineCheck = false},
	GravesChargeShot = {charName = "Graves", spellSlot = "R", range = 1000 , width = 100 , speed = 1200, delay = .5, spellType = "skillShot", riskLevel = "kill", cc = false, hitLineCheck = true},
	--Hecarim
    HecarimRapidSlash = {charName = "Hecarim", spellSlot = "Q", range = 350 , width = 350 , speed = 1450, delay = .3, spellType = "selfCast", riskLevel = "kill", cc = false, hitLineCheck = false},
    HecarimW = {charName = "Hecarim", spellSlot = "W", range = 525 , width = 525 , speed = 828.5, delay = .12, spellType = "selfCast", riskLevel = "kill", cc = false, hitLineCheck = false},
    HecarimRamp = {charName = "Hecarim", spellSlot = "E", range = 0 , width = 0 , speed = math.huge, delay = math.huge, spellType = "selfCast", riskLevel = "noDmg", cc = false, hitLineCheck = false},
    HecarimUlt = {charName = "Hecarim", spellSlot = "R", range = 1350 , width = 200 , speed = 1200, delay = .5, spellType = "skillShot", riskLevel = "extreme", cc = true, hitLineCheck = true},
	-- Heimerdinger
	HeimerdingerQ = {charName = "Heimerdinger", spellSlot = "Q", range = 350 , width = 0 , speed = math.huge, delay = .5, spellType = "skillShot", riskLevel = "noDmg", cc = false, hitLineCheck = false},
	HeimerdingerW = {charName = "Heimerdinger", spellSlot = "W", range = 1525 , width = 200 , speed = 902, delay = .5, spellType = "skillShot", riskLevel = "kill", cc = false, hitLineCheck = true},
	HeimerdingerE = {charName = "Heimerdinger", spellSlot = "E", range = 970 , width = 120 , speed = 2500, delay = .5, spellType = "skillShot", riskLevel = "extreme", cc = true, hitLineCheck = false},
	HeimerdingerR = {charName = "Heimerdinger", spellSlot = "R", range = 0 , width = 0 , speed = math.huge, delay = .23, spellType = "selfCast", riskLevel = "noDmg", cc = false, hitLineCheck = false},
	heimerdingereult = {charName = "Heimerdinger", spellSlot = "R", range = 970 , width = 250 , speed = math.huge, delay = .23, spellType = "skillShot", riskLevel = "extreme", cc = true, hitLineCheck = true},
	-- Irelia
	IreliaGatotsu = {charName = "Irelia", spellSlot = "Q", range = 650 , width = 0 , speed =2200, delay = 0, spellType = "enemyCast", riskLevel = "kill", cc = false, hitLineCheck = false},
	IreliaHitenStyle = {charName = "Irelia", spellSlot = "W", range = 0 , width = 0 , speed =347, delay = .23, spellType = "selfCast", riskLevel = "noDmg", cc = false, hitLineCheck = false},
	IreliaEquilibriumStrike = {charName = "Irelia", spellSlot = "E", range = 325 , width = 0 , speed =math.huge, delay = .5, spellType = "enemyCast", riskLevel = "extreme", cc = true, hitLineCheck = false},
	IreliaTranscendentBlades = {charName = "Irelia", spellSlot = "R", range = 1200 , width = 0 , speed =779, delay = .5, spellType = "skillShot", riskLevel = "kill", cc = false, hitLineCheck = false},
	-- Janna
	HowlingGale = {charName = "Janna", spellSlot = "Q", range = 1800 , width = 200 , speed = math.huge, delay = 0, spellType = "skillShot", riskLevel = "extreme", cc = true, hitLineCheck = true},
	SowTheWind = {charName = "Janna", spellSlot = "W", range = 600 , width = 0 , speed = 1600, delay = .5, spellType = "enemyCast", riskLevel = "extreme", cc = true, hitLineCheck = true},
	EyeOfTheStorm = {charName = "Janna", spellSlot = "E", range = 800 , width = 0, speed = math.huge, delay = .5, spellType = "allyCast", riskLevel = "noDmg", cc = false, hitLineCheck = false, shieldSlot = _E},
	ReapTheWhirlwind = {charName = "Janna", spellSlot = "R", range = 725 , width = 725 , speed = 828.5, delay = .5, spellType = "selfCast", riskLevel = "noDmg", cc = true, hitLineCheck = false},
	-- JarvanIV
	JarvanIVDragonStrike = {charName = "JarvanIV", spellSlot = "Q", range = 700, width = 70, speed = math.huge, delay = .5, spellType = "skillShot", riskLevel = "kill", cc = false, hitLineCheck = true},
	JarvanIVGoldenAegis = {charName = "JarvanIV", spellSlot = "W", range = 300, width = 300, speed = 0, delay = .5, spellType = "selfCast", riskLevel = "dangerous", cc = true, hitLineCheck = false, shieldSlot = _W},
	JarvanIVDemacianStandard = {charName = "JarvanIV", spellSlot = "E", range = 830, width = 75, speed = math.huge, delay = .5, spellType = "skillShot", riskLevel = "kill", cc = false, hitLineCheck = false},
	JarvanIVCataclysm = {charName = "JarvanIV", spellSlot = "R", range = 650, width = 325, speed = 0, delay = .5, spellType = "skillShot", riskLevel = "kill", cc = false, hitLineCheck = false},
	--Jax
	JaxLeapStrike = {charName = "Jax", spellSlot = "Q", range = 210, width = 0, speed = 0, delay = .5, spellType = "everyCast", riskLevel = "kill", cc = false, hitLineCheck = false},
    JaxEmpowerTwo = {charName = "Jax", spellSlot = "W", range = 0, width = 0, speed = 0, delay = .5, spellType = "enemyCast", riskLevel = "kill", cc = false, hitLineCheck = false},
    JaxCounterStrike = {charName = "Jax", spellSlot = "E", range = 425, width = 425, speed = 1450, delay = .5, spellType = "selfCast", riskLevel = "extreme" , cc = true, hitLineCheck = true},
    JaxRelentlessAsssault = {charName = "Jax", spellSlot = "R", range = 0, width = 0, speed = 0, delay = 0, spellType = "selfCast", riskLevel =  "noDmg", cc = false, hitLineCheck = false},
	--Jayce
	JayceToTheSkies = {charName = "Jayce", spellSlot = "Q", range = 600 , width = 0 , speed = math.huge, delay = .5, spellType = "enemyCast", riskLevel = "extreme", cc = true, hitLineCheck = false},
	JayceStaticField = {charName = "Jayce", spellSlot = "W", range = 285 , width = 285 , speed = 1500, delay = .5, spellType = "selfCast", riskLevel = "kill", cc = false, hitLineCheck = false},
	JayceThunderingBlow = {charName = "Jayce", spellSlot = "E", range = 300 , width = 80 , speed = math.huge, delay = 0, spellType = "enemyCast", riskLevel = "extreme", cc = true, hitLineCheck = false},
	JayceStanceHtG = {charName = "Jayce", spellSlot = "R", range = 0 , width = 0 , speed = math.huge, delay = .75, spellType = "selfCast", riskLevel = "noDmg", cc = false, hitLineCheck = false},
	jayceshockblast = {charName = "Jayce", spellSlot = "Q", range = 1050 , width = 80 , speed = 1200, delay = .5, spellType = "skillShot", riskLevel = "kill", cc = false, hitLineCheck = false},
	jaycehypercharge = {charName = "Jayce", spellSlot = "W", range = 0 , width = 0 , speed = math.huge, delay = .75, spellType = "selfCast", riskLevel = "noDmg", cc = false, hitLineCheck = false},
	jayceaccelerationgate = {charName = "Jayce", spellSlot = "E", range = 685 , width = 0 , speed = 1600, delay = .5, spellType = "skillShot", riskLevel = "noDmg", cc = false, hitLineCheck = false},
	jaycestancegth = {charName = "Jayce", spellSlot = "R", range = 0 , width = 0 , speed = math.huge, delay = .75, spellType = "selfCast", riskLevel = "noDmg", cc = false, hitLineCheck = false},	
	-- Karthus
	LayWaste = {charName = "Karthus", spellSlot = "Q", range = 875 , width = 160 , speed = math.huge, delay = .5, spellType = "skillShot", riskLevel = "kill", cc = false, hitLineCheck = false},
	WallOfPain = {charName = "Karthus", spellSlot = "W", range = 1090 , width = 525 , speed = 1600, delay = .5, spellType = "skillShot", riskLevel = "dangerous", cc = true, hitLineCheck = false},
	Defile = {charName = "Karthus", spellSlot = "E", range = 550 , width = 550 , speed = 1000, delay = .5, spellType = "selfCast", riskLevel = "kill", cc = false, hitLineCheck = false},
	FallenOne = {charName = "Karthus", spellSlot = "R", range = 20000 , width = 0 , speed = math.huge, delay = 0, spellType = "selfCast", riskLevel = "kill", cc = false, hitLineCheck = false, timer = 2200},
	--Karma
    KarmaQ = {charName = "Karma", spellSlot = "Q", range = 950 , width = 90 , speed = 902, delay = .5, spellType = "skillShot", riskLevel = "extreme", cc = true, hitLineCheck = true},
    KarmaSpiritBind = {charName = "Karma", spellSlot = "W", range = 700 , width = 60 , speed = 2000, delay = .5, spellType = "enemyCast", riskLevel = "extreme", cc = true, hitLineCheck = false},
    KarmaSolKimShield = {charName = "Karma", spellSlot = "E", range = 800 , width = 0 , speed = math.huge, delay = .5, spellType = "allyCast", riskLevel = "noDmg", cc = false, hitLineCheck = false, shieldSlot = _E},
    KarmaMantra = {charName = "Karma", spellSlot = "R", range = 0 , width = 0 , speed = 1300, delay = .5, spellType = "selfCast", riskLevel = "noDmg", cc = false, hitLineCheck = false},
	--Kassadin
	NullLance = {charName = "Kassadin", spellSlot = "Q", range = 650, width = 0, speed = 1400, delay = .5, spellType = "enemyCast", riskLevel = "extreme", cc = trueww, hitLineCheck = false},
	NetherBlade = {charName = "Kassadin", spellSlot = "W", range = 0, width = 0, speed = 0, delay = 0, spellType = "selfCast", riskLevel = "noDmg", cc = false, hitLineCheck = false},
	ForcePulse = {charName = "Kassadin", spellSlot = "E", range = 700, width = 10, speed = math.huge, delay = .5, spellType = "skillShot", riskLevel = "extreme", cc = true, hitLineCheck = true},
	RiftWalk = {charName = "Kassadin", spellSlot = "R", range = 675, width = 150, speed = math.huge, delay = .5, spellType = "skillShot", riskLevel = "kill", cc = false, hitLineCheck = false},
	-- Katarina
	KatarinaQ = {charName = "Katarina", spellSlot = "Q", range = 675, width = 0, speed = 1800, delay = .5, spellType = "enemyCast", riskLevel = "kill", cc = false, hitLineCheck = false},
    KatarinaW = {charName = "Katarina", spellSlot = "W", range = 400, width = 400, speed = 1800, delay = .5, spellType = "selfCast", riskLevel = "kill", cc = false, hitLineCheck = false},
    KatarinaE = {charName = "Katarina", spellSlot = "E", range = 700, width = 0, speed = 0, delay = .5, spellType = "enemyCast", riskLevel = "kill", cc = false, hitLineCheck = false},
    KatarinaR = {charName = "Katarina", spellSlot = "R", range = 550, width = 550, speed = 1450, delay = .5, spellType = "selfCast", riskLevel = "kill", cc = false, hitLineCheck = false},
	--Kayle
	JudicatorReckoning = {charName = "Kayle", spellSlot = "Q", range = 650, width = 0, speed = 1500, delay = .5, spellType = "enemyCast", riskLevel = "extreme", cc = true, hitLineCheck = false},
	JudicatorDevineBlessing = {charName = "Kayle", spellSlot = "W", range = 900, width = 0, speed = math.huge, delay = .22, spellType = "allyCast", riskLevel = "noDmg", cc = false, hitLineCheck = false, healSlot = _W},
	JudicatorRighteousFury = {charName = "Kayle", spellSlot = "E", range = 0, width = 0, speed = 779, delay = .5, spellType = "selfCast", riskLevel = "noDmg", cc = false, hitLineCheck = false},
	JudicatorIntervention = {charName = "Kayle", spellSlot = "R", range = 900, width = 0, speed = math.huge, delay = .5, spellType = "allyCast", riskLevel = "noDmg", cc = false, hitLineCheck = false, ultSlot = _R},
	-- Kennen
	KennenShurikenHurlMissile1 = {charName = "Kennen", spellSlot = "Q", range = 1000, width = 0, speed = 1700, delay = .69, spellType = "skillShot", riskLevel = "kill", cc = false, hitLineCheck = true},
	KennenBringTheLight = {charName = "Kennen", spellSlot = "W", range = 900, width = 900, speed = math.huge, delay = .5, spellType = "selfCast", riskLevel = "kill", cc = false, hitLineCheck = false},
	KennenLightningRush = {charName = "Kennen", spellSlot = "E", range = 0, width = 0, speed = math.huge, delay = 0, spellType = "selfCast", riskLevel = "noDmg", cc = false, hitLineCheck = false},
	KennenShurikenStorm = {charName = "Kennen", spellSlot = "R", range = 550, width = 550, speed = 779, delay = .5, spellType = "selfCast", riskLevel = "kill", cc = false, hitLineCheck = false},
	--Kha'Zix
    KhazixQ = {charName = "Khazix", spellSlot = "Q", range = 325, width = 0, speed = math.huge, delay = .5, spellType = "enemyCast", riskLevel = "kill", cc = false, hitLineCheck = false},
    KhazixW = {charName = "Khazix", spellSlot = "W", range = 1000, width = 60, speed = 828.5, delay = .5, spellType = "skillShot", riskLevel = "extreme", cc = true, hitLineCheck = true},
    KhazixE = {charName = "Khazix", spellSlot = "E", range = 600, width = 300, speed = math.huge, delay = .5, spellType = "skillShot", riskLevel = "kill", cc = false, hitLineCheck = false},
    KhazixR = {charName = "Khazix", spellSlot = "R", range = 0, width = 0, speed = math.huge, delay = 0, spellType = "selfCast", riskLevel = "noDmg", cc = false, hitLineCheck = false},
    khazixqlong = {charName = "Khazix", spellSlot = "Q", range = 375, width = 0, speed = math.huge, delay = .5, spellType = "enemyCast", riskLevel = "kill", cc = false, hitLineCheck = false},
    khazixwlong = {charName = "Khazix", spellSlot = "W", range = 1000, width = 250, speed = 828.5, delay = .5, spellType = "skillShot", riskLevel = "extreme", cc = true, hitLineCheck = true},
    khazixelong = {charName = "Khazix", spellSlot = "E", range = 900, width = 300, speed = math.huge, delay = .5, spellType = "skillShot", riskLevel = "kill", cc = false, hitLineCheck = false},
    khazixrlong = {charName = "Khazix", spellSlot = "R", range = 0, width = 0, speed = math.huge, delay = 0, spellType = "selfCast", riskLevel = "noDmg", cc = false, hitLineCheck = false},
	-- KogMaw
	KogMawCausticSpittle = {charName = "KogMaw", spellSlot = "Q", range = 625, width = 0, speed = math.huge, delay = .5, spellType = "enemyCast", riskLevel = "kill", cc = false, hitLineCheck = false},
	    --special spell 130/150/170/190/210 bonus range
	KogMawBioArcanBarrage = {charName = "KogMaw", spellSlot = "W", range = 130, width = 0, speed = 2000, delay = .5, spellType = "selfCast", riskLevel = "kill", cc = false, hitLineCheck = false},
	KogMawVoidOoze = {charName = "KogMaw", spellSlot = "E", range = 1000, width = 120, speed = 1200, delay = .5, spellType = "skillShot", riskLevel = "extreme", cc = true, hitLineCheck = true},
	    --special spell 1400/1700/2200 range
	KogMawLivingArtillery = {charName = "KogMaw", spellSlot = "R", range = 1400, width = 225, speed = 2000, delay = .6, spellType = "skillShot", riskLevel = "kill", cc = false, hitLineCheck = false},
	-- Leblanc
	LeblancChaosOrb = {charName = "Leblanc", spellSlot = "Q", range = 700, width = 0, speed = 2000, delay = .5, spellType = "enemyCast", riskLevel = "kill", cc = false, hitLineCheck = false},
	LeblancSlide = {charName = "Leblanc", spellSlot = "W", range = 600, width = 220, speed = math.huge, delay = .5, spellType = "skillShot", riskLevel = "kill", cc = false, hitLineCheck = false},
	leblacslidereturn = {charName = "Leblanc", spellSlot = "W", range = 0, width = 0, speed = math.huge, delay = .5, spellType = "skillShot", riskLevel = "noDmg", cc = false, hitLineCheck = false},
	LeblancSoulShackle = {charName = "Leblanc", spellSlot = "E", range = 925, width = 70, speed = 1600, delay = .5, spellType = "skillShot", riskLevel = "extreme", cc = true, hitLineCheck = true},
    LeblancChaosOrbM = {charName = "Leblanc", spellSlot = "R", range = 700, width = 0, speed = 2000, delay = .5, spellType = "enemyCast", riskLevel = "kill", cc = false, hitLineCheck = false},
	LeblancSlideM = {charName = "Leblanc", spellSlot = "R", range = 600, width = 220, speed = math.huge, delay = .5, spellType = "skillShot", riskLevel = "kill", cc = false, hitLineCheck = false},
	leblancslidereturnm = {charName = "Leblanc", spellSlot = "R", range = 0, width = 0, speed = math.huge, delay = .5, spellType = "skillShot", riskLevel = "noDmg", cc = false, hitLineCheck = false},
	LeblancSoulShackleM = {charName = "Leblanc", spellSlot = "R", range = 925, width = 70, speed = 1600, delay = .5, spellType = "skillShot", riskLevel = "extreme", cc = true, hitLineCheck = true},
	-- LeeSin
	BlindMonkQOne = {charName = "LeeSin", spellSlot = "Q", range = 1000, width = 60, speed = 1800, delay = .5, spellType = "skillShot", riskLevel = "kill", cc = false, hitLineCheck = true},
	BlindMonkWOne = {charName = "LeeSin", spellSlot = "W", range = 700, width = 0, speed = 1500, delay = 0, spellType = "allyCast", riskLevel = "noDmg", cc = false, hitLineCheck = false, shieldSlot = _W},
	BlindMonkEOne = {charName = "LeeSin", spellSlot = "E", range = 425, width = 425, speed = math.huge, delay = .5, spellType = "selfCast", riskLevel = "kill", cc = false, hitLineCheck = false},
	BlindMonkRKick = {charName = "LeeSin", spellSlot = "R", range = 375, width = 0, speed = 1500, delay = .5, spellType = "enemyCast", riskLevel = "extreme", cc = true, hitLineCheck = false},
	blindmonkqtwo = {charName = "LeeSin", spellSlot = "Q", range = 0, width = 0, speed = math.huge, delay = .5, spellType = "enemyCast", riskLevel = "kill", cc = false, hitLineCheck = true},
	blindmonkwtwo = {charName = "LeeSin", spellSlot = "W", range = 700, width = 0, speed = math.huge, delay = 0, spellType = "selfCast", riskLevel = "noDmg", cc = false, hitLineCheck = false},
	blindmonketwo = {charName = "LeeSin", spellSlot = "E", range = 425, width = 425, speed = math.huge, delay = .5, spellType = "selfCast", riskLevel = "dangerous", cc = true, hitLineCheck = false},
	-- Leona
	LeonaShieldOfDaybreak = {charName = "Leona", spellSlot = "Q", range = 215, width = 0, speed = 0, delay = 0, spellType = "selfCast", riskLevel = "noDmg", cc = true, hitLineCheck = false},
    LeonaSolarBarrier = {charName = "Leona", spellSlot = "W", range = 500, width = 0, speed = 0, delay = 3, spellType = "selfCast", riskLevel = "noDmg", cc = true, hitLineCheck = false},
    LeonaZenithBlade = {charName = "Leona", spellSlot = "E", range = 900, width = 85, speed = 2000, delay = 0, spellType = "skillShot", riskLevel = "extreme" , cc = true, hitLineCheck = true},
    LeonaZenithBladeMissle = {charName = "Leona", spellSlot = "E", range = 900, width = 85, speed = 2000, delay = 0, spellType = "skillShot", riskLevel = "extreme" , cc = true, hitLineCheck = true},
    LeonaSolarFlare = {charName = "Leona", spellSlot = "R", range = 1200, width = 315, speed = math.huge, delay = 0.7, spellType = "skillShot", riskLevel = "extreme", cc = true, hitLineCheck = false},
	--Lissandra
	LissandraQ = {charName = "Lissandra", spellSlot = "Q", range = 725, width = 75, speed = 1200, delay = .5, spellType = "skillShot", riskLevel = "extreme", cc = true, hitLineCheck = true},
	LissandraW = {charName = "Lissandra", spellSlot = "W", range = 450, width = 450, speed = math.huge, delay = .5, spellType = "selfCast", riskLevel = "extreme", cc = true, hitLineCheck = false},
	LissandraE = {charName = "Lissandra", spellSlot = "E", range = 1050, width = 110, speed = 850, delay = .5, spellType = "skillShot", riskLevel = "kill", cc = false, hitLineCheck = true},
	LissandraR = {charName = "Lissandra", spellSlot = "R", range = 550, width = 0, speed = math.huge, delay = 0, spellType = "selfEnemyCast", riskLevel = "extreme", cc = true, hitLineCheck = false, timer = 0, zhonyaSlot = _R},
	--Lucian
	LucianQ = {charName = "Lucian", spellSlot = "Q", range = 550, width = 65, speed = 500, delay = .5, spellType = "enemyCast", riskLevel = "kill", cc = false, hitLineCheck = false},
	LucianW = {charName = "Lucian", spellSlot = "W", range = 1000, width = 80, speed = 500, delay = .5, spellType = "skillShot", riskLevel = "kill", cc = false, hitLineCheck = true},
	LucianE = {charName = "Lucian", spellSlot = "E", range = 650, width = 50, speed = math.huge, delay = .5, spellType = "skillShot", riskLevel = "noDmg", cc = false, hitLineCheck = false},
	LucianR = {charName = "Lucian", spellSlot = "R", range = 1400, width = 60, speed = math.huge, delay = .5, spellType = "allyCast", riskLevel = "kill", cc = false, hitLineCheck = true},
	-- Lulu
	LuluQ = {charName = "Lulu", spellSlot = "Q", range = 925, width = 80, speed = 1400, delay = .5, spellType = "skillShot", riskLevel = "extreme", cc = true, hitLineCheck = true},
	LuluQMissle = {charName = "Lulu", spellSlot = "Q", range = 925, width = 80, speed = 1400, delay = .5, spellType = "skillShot", riskLevel = "extreme", cc = true, hitLineCheck = true},
	LuluW = {charName = "Lulu", spellSlot = "W", range = 650, width = 0, speed = 2000, delay = .64, spellType = "enemyCast", riskLevel = "dangerous", cc = true, hitLineCheck = false},
	LuluE = {charName = "Lulu", spellSlot = "E", range = 650, width = 0, speed = math.huge, delay = .64, spellType = "everyCast", riskLevel = "kill", cc = false, hitLineCheck = false, shieldSlot = _E},
	LuluR = {charName = "Lulu", spellSlot = "R", range = 900, width = 0, speed = math.huge, delay = .5, spellType = "allyCast", riskLevel = "dangerous", cc = true, hitLineCheck = false, ultSlot = _R},
	-- Lux
	LuxLightBinding = {charName = "Lux", spellSlot = "Q", range = 1300, width = 80, speed = 1200, delay = .5, spellType = "skillShot", riskLevel = "extreme", cc = true, hitLineCheck = true},
	LuxPrismaticWave = {charName = "Lux", spellSlot = "W", range = 1075, width = 150, speed = 1200, delay = .5, spellType = "skillShot", riskLevel = "noDmg", cc = false, hitLineCheck = false, shieldSlot = _E},
	LuxLightStrikeKugel = {charName = "Lux", spellSlot = "E", range = 1100, width = 275, speed = 1300, delay = .5, spellType = "skillShot", riskLevel = "dangerous", cc = true, hitLineCheck = false},
	luxlightstriketoggle = {charName = "Lux", spellSlot = "E", range = 1100, width = 275, speed = 1300, delay = .5, spellType = "skillShot", riskLevel = "kill", cc = false, hitLineCheck = false},
    LuxMaliceCannon = {charName = "Lux", spellSlot = "R", range = 3340, width = 190, speed = 3000, delay = 1.75, spellType = "skillShot", riskLevel = "kill", cc = false, hitLineCheck = false},
    LuxMaliceCannonMis = {charName = "Lux", spellSlot = "R", range = 3340, width = 190, speed = 3000, delay = 1.75, spellType = "skillShot", riskLevel = "kill", cc = false, hitLineCheck = false},
	-- Malphite
	SeismicShard = {charName = "Malphite", spellSlot = "Q", range = 625, width = 0, speed = 1200, delay = .5, spellType = "enemyCast", riskLevel = "extreme", cc = true, hitLineCheck = false},
	Obduracy = {charName = "Malphite", spellSlot = "W", range = 0, width = 0, speed = math.huge, delay = .5, spellType = "selfCast", riskLevel = "noDmg", cc = false, hitLineCheck = false},
	Landslide = {charName = "Malphite", spellSlot = "E", range = 400, width = 400, speed = math.huge, delay = .5, spellType = "selfCast", riskLevel = "kill", cc = false, hitLineCheck = false},
	UFSlash = {charName = "Malphite", spellSlot = "R", range = 1000, width = 270, speed = 700, delay = 0, spellType = "skillShot", riskLevel = "extreme", cc = true, hitLineCheck = false, timer = 0},
	-- Malzahar
	    --special spell (wall)
	AlZaharCalloftheVoid = {charName = "Malzahar", spellSlot = "Q", range = 900, width = 110, speed = math.huge, delay = .5, spellType = "skillShot", riskLevel = "extreme", cc = true, hitLineCheck = false},
	AlZaharNullZone = {charName = "Malzahar", spellSlot = "W", range = 800, width = 250, speed = math.huge, delay = .5, spellType = "skillShot", riskLevel = "kill", cc = false, hitLineCheck = false},
	AlZaharMaleficVisions = {charName = "Malzahar", spellSlot = "E", range = 650, width = 0, speed = math.huge, delay = .5, spellType = "enemyCast", riskLevel = "kill", cc = false, hitLineCheck = false},
	AlZaharNetherGrasp = {charName = "Malzahar", spellSlot = "R", range = 700, width = 0, speed = math.huge, delay = .5, spellType = "enemyCast", riskLevel = "extreme", cc = true, hitLineCheck = false},
	-- Maokai
	MaokaiTrunkLine = {charName = "Maokai", spellSlot = "Q", range = 600, width = 110, speed = 1200, delay = .5, spellType = "skillShot", riskLevel = "extreme", cc = true, hitLineCheck = true},
	MaokaiUnstableGrowth = {charName = "Maokai", spellSlot = "W", range = 650, width = 0, speed = math.huge, delay = .5, spellType = "enemyCast", riskLevel = "extreme", cc = true, hitLineCheck = false},
	MaokaiSapling2 = {charName = "Maokai", spellSlot = "E", range = 1100, width = 250, speed = 1750, delay = .5, spellType = "skillShot", riskLevel = "kill", cc = false, hitLineCheck = false},
	MaokaiDrain3 = {charName = "Maokai", spellSlot = "R", range = 625, width = 575, speed = math.huge, delay = .5, spellType = "skillShoot", riskLevel = "kill", cc = false, hitLineCheck = false},
	--Master Yi
	AlphaStrike = {charName = "MasterYi", spellSlot = "Q", range = 600, width = 0, speed = 4000, delay = .5, spellType = "enemyCast", riskLevel = "kill", cc = false, hitLineCheck = false},
	Meditate = {charName = "MasterYi", spellSlot = "W", range = 0, width = 0, speed = math.huge, delay = .5, spellType = "selfCast", riskLevel = "noDmg", cc = false, hitLineCheck = false},
	WujuStyle = {charName = "MasterYi", spellSlot = "E", range = 0, width = 0, speed = math.huge, delay = .23, spellType = "selfCast", riskLevel = "noDmg", cc = false, hitLineCheck = false},
	Highlander = {charName = "MasterYi", spellSlot = "R", range = 0, width = 0, speed = math.huge, delay = .37, spellType = "selfCast", riskLevel = "noDmg", cc = false, hitLineCheck = false, slowSlot = _R},
	-- MissFortune
    MissFortuneRicochetShot = {charName = "MissFortune", spellSlot = "Q", range = 650, width = 0, speed = 1400, delay = .5, spellType = "enemyCast", riskLevel = "kill", cc = false, hitLineCheck = false},
    MissFortuneViciousStrikes = {charName = "MissFortune", spellSlot = "W", range = 0, width = 0, speed = math.huge, delay = 0, spellType = "selfCast", riskLevel = "noDmg", cc = false, hitLineCheck = false},
    MissFortuneScattershot = {charName = "MissFortune", spellSlot = "E", range = 1000, width = 400, speed = 500, delay = .5, spellType = "skillShot", riskLevel = "extreme", cc = true, hitLineCheck = false},
    MissFortuneBulletTime = {charName = "MissFortune", spellSlot = "R", range = 1400, width = 100, speed = 775, delay = .5, spellType = "skillShot", riskLevel = "extreme", cc = false, hitLineCheck = true},
	--Mordekaiser
	MordekaiserMaceOfSpades = {charName = "Mordekaiser", spellSlot = "Q", range = 600, width = 0, speed = 1500, delay = .5, spellType = "selfCast", riskLevel = "kill", cc = false, hitLineCheck = false},
    MordekaiserCreepinDeathCast = {charName = "Mordekaiser", spellSlot = "W", range = 750, width = 0, speed = math.huge, delay = .5, spellType = "allyCast", riskLevel = "noDmg", cc = false, hitLineCheck = false},
    MordekaiserSyphoneOfDestruction = {charName = "Mordekaiser", spellSlot = "E", range = 700, width = 0, speed = 1500, delay = .5, spellType = "skillShot", riskLevel = "kill", cc = false, hitLineCheck = true},
    MordekaiserChildrenOfTheGrave = {charName = "Mordekaiser", spellSlot = "R", range = 850, width = 0, speed = 1500, delay = .5, spellType = "enemyCast", riskLevel = "kill", cc = false, hitLineCheck = false},
	-- Morgana
    DarkBindingMissile = {charName = "Morgana", spellSlot = "Q", range = 1175, width = 70, speed = 1200, delay = .5, spellType = "skillShot", riskLevel = "extreme", cc = true, hitLineCheck = true},
    TormentedSoil = {charName = "Morgana", spellSlot = "W", range = 1075, width = 350, speed = math.huge, delay = .5, spellType = "skillShot", riskLevel = "kill", cc = false, hitLineCheck = false},
    BlackShield = {charName = "Morgana", spellSlot = "E", range = 750, width = 0, speed = math.huge, delay = .5, spellType = "allyCast", riskLevel = "noDmg", cc = false, hitLineCheck = false, shieldSlot = _E},
    SoulShackles = {charName = "Morgana", spellSlot = "R", range = 600, width = 600, speed = math.huge, delay = .5, spellType = "selfCast", riskLevel = "extreme", cc = true, hitLineCheck = true, timer = 2800},
	--Nami
    NamiQ = {charName = "Nami", spellSlot = "Q", range = 875, width = 200, speed = 1750, delay = .5, spellType = "skillShot", riskLevel = "extreme", cc = true, hitLineCheck = false},
    NamiW = {charName = "Nami", spellSlot = "W", range = 725, width = 0, speed = 1100, delay = .5, spellType = "everyCast", riskLevel = "kill", cc = false, hitLineCheck = false, healSlot = _W},
    NamiE = {charName = "Nami", spellSlot = "E", range = 800, width = 0, speed = math.huge, delay = .5, spellType = "allyCast", riskLevel = "noDmg", cc = false, hitLineCheck = false},
    NamiR = {charName = "Nami", spellSlot = "R", range = 2550, width = 600, speed = 1200, delay = .5, spellType = "skillShot", riskLevel = "extreme", cc = true, hitLineCheck = true},
	--Nasus
	NasusQ = {charName = "Nasus", spellSlot = "Q", range = 0, width = 0, speed = math.huge, delay = .5, spellType = "selfCast", riskLevel = "noDmg", cc = false, hitLineCheck = false},
    NasusW = {charName = "Nasus", spellSlot = "W", range = 600, width = 0, speed = math.huge, delay = .5, spellType = "enemyCast", riskLevel = "noDmg", cc = true, hitLineCheck = false},
    NasusE = {charName = "Nasus", spellSlot = "E", range = 850, width = 400, speed = math.huge, delay = .5, spellType = "skillShot", riskLevel = "kill", cc = false, hitLineCheck = false},
    NasusR = {charName = "Nasus", spellSlot = "R", range = 1, width = 350, speed = math.huge, delay = .5, spellType = "skillShot", riskLevel = "kill", cc = false, hitLineCheck = false},
	-- Nautilus
	NautilusAnchorDrag = {charName = "Nautilus", spellSlot = "Q", range = 950, width = 80, speed = 1200, delay = .5, spellType = "skillShot", riskLevel = "extreme", cc = true, hitLineCheck = true},
	NautilusPiercingGaze = {charName = "Nautilus", spellSlot = "W", range = 0, width = 0, speed = 0, delay = 0, spellType = "selfCast", riskLevel = "noDmg", cc = false, hitLineCheck = false, shieldSlot = _W},
	NautilusSplashZone = {charName = "Nautilus", spellSlot = "E", range = 600, width = 600, speed = 1300, delay = .5, spellType = "selfCast", riskLevel = "extreme", cc = true, hitLineCheck = false},
	NautilusGandLine = {charName = "Nautilus", spellSlot = "R", range = 1500, width = 60, speed = 1400, delay = .5, spellType = "enemyCast", riskLevel = "extreme", cc = true, hitLineCheck = false, timer = 450 - GetLatency()},
	-- Nidalee
	    ---Nidalee HUMAN
    JavelinToss = {charName = "Nidalee", spellSlot = "Q", range = 1500, width = 60, speed = 1300, delay = .5, spellType = "skillShot", riskLevel = "kill", cc = false, hitLineCheck = true},
    Bushwhack = {charName = "Nidalee", spellSlot = "W", range = 900, width = 125, speed = 1450, delay = .5, spellType = "skillShot", riskLevel = "kill", cc = false, hitLineCheck = false},
    PrimalSurge = {charName = "Nidalee", spellSlot = "E", range = 600, width = 0, speed = math.huge, delay = 0, spellType = "allyCast", riskLevel = "noDmg", cc = false, hitLineCheck = false, healSlot = _E},
    AspectOfTheCougar = {charName = "Nidalee", spellSlot = "R", range = 0, width = 0, speed = math.huge, delay = 0, spellType = "selfCast", riskLevel = "noDmg", cc = false, hitLineCheck = false},
        ---Nidalee COUGAR
    Takedown = {charName = "Nidalee", spellSlot = "Q", range = 50, width = 0, speed = 500, delay = 0, spellType = "selfCast", riskLevel = "noDmg", cc = false, hitLineCheck = false},
    Pounce = {charName = "Nidalee", spellSlot = "W", range = 375, width = 150, speed = 1500, delay = .5, spellType = "skillShot", riskLevel = "kill", cc = false, hitLineCheck = false},
    Swipe = {charName = "Nidalee", spellSlot = "E", range = 300, width = 300, speed = math.huge, delay = .5, spellType = "skillShot", riskLevel = "kill", cc = false, hitLineCheck = false},
	-- Nocturne
	NocturneDuskbringer = {charName = "Nocturne", spellSlot = "Q", range = 1125, width = 60, speed = 1600, delay = .5, spellType = "skillShot", riskLevel = "kill", cc = false, hitLineCheck = true},
	NocturneShroudofDarkness = {charName = "Nocturne", spellSlot = "W", range = 0, width = 0, speed = 500, delay = .5, spellType = "selfCast", riskLevel = "noDmg", cc = false, hitLineCheck = false, shieldSlot = _W},
	NocturneUnspeakableHorror = {charName = "Nocturne", spellSlot = "E", range = 500, width = 0, speed = 0, delay = .5, spellType = "enemyCast", riskLevel = "noDmg", cc = true, hitLineCheck = false},
	    --special spell 2000/2750/3500
	NocturneParanoia = {charName = "Nocturne", spellSlot = "R", range = 2000, width = 0, speed = 500, delay = .5, spellType = "enemyCast", riskLevel = "kill", cc = false, hitLineCheck = false},
	--Nunu
    Consume = {charName = "Nunu", spellSlot = "Q", range = 125, width = 60, speed = 1400, delay = .5, spellType = "enemyCast", riskLevel = "extreme", cc = false, hitLineCheck = false},
    BloodBoil = {charName = "Nunu", spellSlot = "W", range = 700, width = 0, speed = math.huge, delay = .5, spellType = "allyCast", riskLevel = "noDmg", cc = false, hitLineCheck = false},
    IceBlast = {charName = "Nunu", spellSlot = "E", range = 550, width = 0, speed = 1000, delay = .5, spellType = "enemyCast", riskLevel = "extreme", cc = true, hitLineCheck = false},
    AbsoluteZero = {charName = "Nunu", spellSlot = "R", range = 650, width = 650, speed = math.huge, delay = .5, spellType = "selfCast", riskLevel = "extreme", cc = true, hitLineCheck = false},
	-- Olaf
    OlafAxeThrowCast = {charName = "Olaf", spellSlot = "Q", range = 1000, width = 90, speed = 1600, delay = .5, spellType = "skillShot", riskLevel = "extreme", cc = true, hitLineCheck = true},
    OlafFrenziedStrikes = {charName = "Olaf", spellSlot = "W", range = 0, width = 0, speed = math.huge, delay = .5, spellType = "selfCast", riskLevel = "noDmg", cc = false, hitLineCheck = false},
    OlafRecklessStrike = {charName = "Olaf", spellSlot = "E", range = 325, width = 0, speed = math.huge, delay = .5, spellType = "enemyCast", riskLevel = "kill", cc = false, hitLineCheck = false},
    OlafRagnarok = {charName = "Olaf", spellSlot = "R", range = 0, width = 0, speed = math.huge, delay = .5, spellType = "selfCast", riskLevel = "noDmg", cc = false, hitLineCheck = false, qssSlot = _R},
	-- Orianna
	OrianaIzunaCommand = {charName = "Orianna", spellSlot = "Q", range = 1100, width = 145, speed = 1200, delay = .5, spellType = "skillShot", riskLevel = "kill", cc = false, hitLineCheck = true},
	OrianaDissonanceCommand = {charName = "Orianna", spellSlot = "W", range = 0, width = 260, speed = 1200, delay = .5, spellType = "skillShot", riskLevel = "extreme", cc = true, hitLineCheck = false},
	OrianaRedactCommand = {charName = "Orianna", spellSlot = "E", range = 1095, width = 145, speed = 1200, delay = .5, spellType = "allyCast", riskLevel = "kill", cc = false, hitLineCheck = false, shieldSlot = _E},
	OrianaDetonateCommand = {charName = "Orianna", spellSlot = "R", range = 0, width = 425, speed = 1200, delay = .5, spellType = "skillShot", riskLevel = "extreme", cc = true, hitLineCheck = false},
	--Pantehon
    Pantheon_Throw = {charName = "Pantheon", spellSlot = "Q", range = 600, width = 0, speed = 1500, delay = .5, spellType = "enemyCast", riskLevel = "kill", cc = false, hitLineCheck = false},
    Pantheon_LeapBash = {charName = "Pantheon", spellSlot = "W", range = 600, width = 0, speed = math.huge, delay = .5, spellType = "enemyCast", riskLevel = "extreme", cc = true, hitLineCheck = false},
    Pantheon_Heartseeker = {charName = "Pantheon", spellSlot = "E", range = 600, width = 100, speed = 775, delay = .5, spellType = "skillShot", riskLevel = "kill", cc = false, hitLineCheck = true},
    Pantheon_GrandSkyfall_Jump = {charName = "Pantheon", spellSlot = "R", range = 5500, width = 1000, speed = 3000, delay = 1.0, spellType = "skillShot", riskLevel = "extreme", cc = true, hitLineCheck = false},
	--Poppy
	PoppyDevastatingBlow = {charName = "Poppy", spellSlot = "Q", range = 0, width = 0, speed = math.huge, delay = .5, spellType = "selfCast", riskLevel = "noDmg", cc = false, hitLineCheck = false},
    PoppyParagonOfDemacia = {charName = "Poppy", spellSlot = "W", range = 0, width = 0, speed = math.huge, delay = .5, spellType = "selfCast", riskLevel = "noDmg", cc = false, hitLineCheck = false},
    PoppyHeroicCharge = {charName = "Poppy", spellSlot = "E", range = 525, width = 0, speed = 1450, delay = .5, spellType = "enemyCast", riskLevel = "extreme", cc = true, hitLineCheck = false},
    PoppyDiplomaticImmunity = {charName = "Poppy", spellSlot = "R", range = 900, width = 0, speed = math.huge, delay = .5, spellType = "enemyCast", riskLevel = "noDmg", cc = false, hitLineCheck = false},
	--Quinn
	QuinnQ = {charName = "Quinn", spellSlot = "Q", range = 1025, width = 80, speed = 1200, delay = .5, spellType = "skillShot", riskLevel = "extreme", cc = true, hitLineCheck = true},
	QuinnW = {charName = "Quinn", spellSlot = "W", range = 2100, width = 0, speed = 0, delay = 0, spellType = "selfCast", riskLevel = "noDmg", cc = false, hitLineCheck = false},
	QuinnE = {charName = "Quinn", spellSlot = "E", range = 700, width = 0, speed = 775, delay = .5, spellType = "enemyCast", riskLevel = "extreme", cc = true, hitLineCheck = false},
	QuinnR = {charName = "Quinn", spellSlot = "R", range = 0, width = 0, speed = 0, delay = 0, spellType = "selfCast", riskLevel = "noDmg", cc = false, hitLineCheck = false},
	QuinnRFinale = {charName = "Quinn", spellSlot = "R", range = 700, width = 700, speed = 0, delay = 0, spellType = "selfCast", riskLevel = "noDmg", cc = false, hitLineCheck = false},
	--Rammus
	PowerBall = {charName = "Rammus", spellSlot = "Q", range = 0, width = 200, speed = 775, delay = .5, spellType = "selfCast", riskLevel = "extreme", cc = false, hitLineCheck = false},
    DefensiveBallCurl = {charName = "Rammus", spellSlot = "W", range = 0, width = 0, speed = math.huge, delay = .5, spellType = "selfCast", riskLevel = "noDmg", cc = false, hitLineCheck = false, aaShieldSlot = _W},
    PuncturingTaunt = {charName = "Rammus", spellSlot = "E", range = 325, width = 0, speed = math.huge, delay = .5, spellType = "enemyCast", riskLevel = "extreme", cc = true, hitLineCheck = false},
    Tremors2 = {charName = "Rammus", spellSlot = "R", range = 300, width = 300, speed = math.huge, delay = .5, spellType = "selfCast", riskLevel = "kill", cc = false, hitLineCheck = false},
	-- Renekton
    RenektonCleave = {charName = "Renekton", spellSlot = "Q", range = 1, width = 450, speed = math.huge, delay = .5, spellType = "skillShot", riskLevel = "kill", cc = false, hitLineCheck = false},
    RenektonPreExecute = {charName = "Renekton", spellSlot = "W", range = 0, width = 0, speed = math.huge, delay = .5, spellType = "selfCast", riskLevel = "noDmg", cc = false, hitLineCheck = false},
    RenektonSliceAndDice = {charName = "Renekton", spellSlot = "E", range = 450, width = 50, speed = 1400, delay = .5, spellType = "skillShot", riskLevel = "extreme", cc = true, hitLineCheck = true},
    RenektonReignOfTheTyrant = {charName = "Renekton", spellSlot = "R", range = 1, width = 530, speed = 775, delay = .5, spellType = "skillShot", riskLevel = "kill", cc = false, hitLineCheck = false},
	--Rengar
	RengarQ = {charName = "Rengar", spellSlot = "Q", range = 0, width = 0, speed = math.huge, delay = .5, spellType = "selfCast", riskLevel = "noDmg", cc = false, hitLineCheck = false},
    RengarW = {charName = "Rengar", spellSlot = "W", range = 1, width = 500, speed = math.huge, delay = .5, spellType = "skillShot", riskLevel = "extreme", cc = true, hitLineCheck = false},
    RengarE = {charName = "Rengar", spellSlot = "E", range = 1000, width = 70, speed = 1500, delay = .5, spellType = "enemyCast", riskLevel = "extreme", cc = true, hitLineCheck = false},
    RengarR = {charName = "Rengar", spellSlot = "R", range = 0, width = 0, speed = math.huge, delay = .5, spellType = "selfCast", riskLevel = "noDmg", cc = false, hitLineCheck = false},
	--Riven
    RivenTriCleave = {charName = "Riven", spellSlot = "Q", range = 250, width = 0, speed = 0,  delay = .5, spellType = "skillShot", riskLevel = "kill", cc = false, hitLineCheck = false},
    RivenTriCleave_03 = {charName = "Riven", spellSlot = "Q", range = 250, width = 0, speed = 0,  delay = .5, spellType = "skillShot", riskLevel = "extreme", cc = true, hitLineCheck = false},
    RivenMartyr = {charName = "Riven", spellSlot = "W", range = 260, width = 260, speed = 1500,  delay = 0.25, spellType = "selfCast", riskLevel = "extreme", cc = true, hitLineCheck = false},
    RivenFeint = {charName = "Riven", spellSlot = "E", range = 325, width = 0, speed = 1450, delay = 0, spellType = "skillShot", riskLevel = "noDmg", cc = false, hitLineCheck = false, shieldSlot = _E},
    RivenFengShuiEngine = {charName = "Riven", spellSlot = "R", range = 0, width = 0, speed = 1200, delay = .5, spellType = "selfCast", riskLevel = "noDmg", cc = false, hitLineCheck = false},
    rivenizunablade = {charName = "Riven", spellSlot = "R", range = 900, width = 200, speed = 1450, delay = .3, spellType = "skillShot", riskLevel = "kill", cc = false, hitLineCheck = true},
	-- Rumble
	RumbleFlameThrower = {charName = "Rumble", spellSlot = "Q", range = 600, width = 10, speed = math.huge, delay = .5, spellType = "skillShot", riskLevel = "kill", cc = false, hitLineCheck = true},
	RumbleShield = {charName = "Rumble", spellSlot = "W", range = 0, width = 0, speed = 0, delay = 0, spellType = "selfCast", riskLevel = "noDmg", cc = false, hitLineCheck = false, shieldSlot = _W},
	RumbeGrenade = {charName = "Rumble", spellSlot = "E", range = 850, width = 90, speed = 1200, delay = .5, spellType = "skillShot", riskLevel = "extreme", cc = true, hitLineCheck = true},
	    --special spell
	RumbleCarpetBomb = {charName = "Rumble", spellSlot = "R", range = 1700, width = 0, speed = 1400, delay = .5, spellType = "skillShot", riskLevel = "extreme", cc = true, hitLineCheck = true},
	--Ryze used Qrange+stun(from w) for Rvalues because of the "worst case"
	Overload = {charName = "Ryze", spellSlot = "Q", range = 625, width = 0, speed = 1400, delay = .5, spellType = "enemyCast", riskLevel = "kill", cc = false, hitLineCheck = false},
	RunePrison = {charName = "Ryze", spellSlot = "W", range = 600, width = 0, speed = math.huge, delay = .5, spellType = "enemyCast", riskLevel = "extreme", cc = true, hitLineCheck = false},
    SpellFlux = {charName = "Ryze", spellSlot = "E", range = 600, width = 0, speed = 1000, delay = .5, spellType = "enemyCast", riskLevel = "kill", cc = false, hitLineCheck = false},
    DesperatePower = {charName = "Ryze", spellSlot = "R", range = 625, width = 0, speed = 1400, delay = .5, spellType = "enemyCast", riskLevel = "extreme", cc = true, hitLineCheck = false},
	-- Sejuani
	SejuaniArcticAssault = {charName = "Sejuani", spellSlot = "Q", range = 650, width = 75, speed = 1450, delay = .5, spellType = "skillShot", riskLevel = "extreme", cc = true, hitLineCheck = true},
    SejuaniNorthernWinds = {charName = "Sejuani", spellSlot = "W", range = 1, width = 350, speed = 1500, delay = .5, spellType = "skillShot", riskLevel = "kill", cc = false, hitLineCheck = false},
    SejuaniWintersClaw = {charName = "Sejuani", spellSlot = "E", range = 1, width = 1000, speed = 1450, delay = .5, spellType = "skillShot", riskLevel = "extreme", cc = true, hitLineCheck = false},
    SejuaniGlacialPrisonStart = {charName = "Sejuani", spellSlot = "R", range = 1175, width = 110, speed = 1400, delay = .5, spellType = "skillShot", riskLevel = "extreme", cc = true, hitLineCheck = true},
	-- Shaco
	Deceive = {charName = "Shaco", spellSlot = "Q", range = 400, width = 0, speed = math.huge, delay = .5, spellType = "skillShot", riskLevel = "noDmg", cc = false, hitLineCheck = false},
    JackInTheBox = {charName = "Shaco", spellSlot = "W", range = 425, width = 60, speed = 1450, delay = .5, spellType = "skillShot", riskLevel = "extreme", cc = true, hitLineCheck = false},
    TwoShivPoisen = {charName = "Shaco", spellSlot = "E", range = 625, width = 0, speed = 1500, delay = .5, spellType = "enemyCast", riskLevel = "extreme", cc = true, hitLineCheck = false},
    HallucinateFull = {charName = "Shaco", spellSlot = "R", range = 1125, width = 250, speed = 395, delay = .5, spellType = "skillShot", riskLevel = "kill", cc = false, hitLineCheck = false},
	-- Shen
	ShenVorpalStar = {charName = "Shen", spellSlot = "Q", range = 475, width = 0, speed = 1500, delay = .5, spellType = "enemyCast", riskLevel = "kill", cc = false, hitLineCheck = false},
    ShenFeint = {charName = "Shen", spellSlot = "W", range = 0, width = 0, speed = math.huge, delay = .5, spellType = "selfCast", riskLevel = "noDmg", cc = false, hitLineCheck = false, shieldSlot = _W},
    ShenShadowDash = {charName = "Shen", spellSlot = "E", range = 600, width = 50, speed = 1000, delay = .5, spellType = "skillShot", riskLevel = "extreme", cc = true, hitLineCheck = true},
    ShenStandUnited = {charName = "Shen", spellSlot = "R", range = 22000, width = 0, speed = math.huge, delay = .5, spellType = "allyCast", riskLevel = "noDmg", cc = false, hitLineCheck = false, ultSlot = _R},
		-- Shyvana
    ShyvanaDoubleAttack = {charName = "Shyvana", spellSlot = "Q", range = 0, width = 0, speed = math.huge, delay = .5, spellType = "selfCast", riskLevel = "noDmg", cc = false, hitLineCheck = false},
    shyvanadoubleattackdragon = {charName = "Shyvana", spellSlot = "Q", range = 0, width = 0, speed = math.huge, delay = .5, spellType = "selfCast", riskLevel = "noDmg", cc = false, hitLineCheck = false},
    ShyvanaImmolationAuraqw = {charName = "Shyvana", spellSlot = "W", range = 0, width = 325, speed = math.huge, delay = .5, spellType = "selfCast", riskLevel = "kill", cc = false, hitLineCheck = false},
    shyvanaimmolateddragon = {charName = "Shyvana", spellSlot = "W", range = 0, width = 325, speed = math.huge, delay = .5, spellType = "selfCast", riskLevel = "kill", cc = false, hitLineCheck = false},
    ShyvanaFireball = {charName = "Shyvana", spellSlot = "E", range = 925, width = 60, speed = 1200, delay = .5, spellType = "skillShot", riskLevel = "dangerous", cc = false, hitLineCheck = true},
    shyvanafireballdragon2 = {charName = "Shyvana", spellSlot = "E", range = 925, width = 60, speed = 1200, delay = .5, spellType = "skillShot", riskLevel = "dangerous", cc = false, hitLineCheck = true},
    ShyvanaTransformCast = {charName = "Shyvana", spellSlot = "R", range = 1000, width = 160, speed = 700, delay = .5, spellType = "skillShot", riskLevel = "dangerous", cc = true, hitLineCheck = true},
    ShyvanaTransformLeap = {charName = "Shyvana", spellSlot = "R", range = 1000, width = 160, speed = 700, delay = .5, spellType = "skillShot", riskLevel = "dangerous", cc = true, hitLineCheck = true},
	-- Singed
	PoisenTrail = {charName = "Singed", spellSlot = "Q", range = 0, width = 400, speed = math.huge, delay = .5, spellType = "selfCast", riskLevel = "kill", cc = false, hitLineCheck = false},
    MegaAdhesive = {charName = "Singed", spellSlot = "W", range = 1175, width = 350, speed = 700, delay = .5, spellType = "skillShot", riskLevel = "dangerous", cc = true, hitLineCheck = false},
    Fling = {charName = "Singed", spellSlot = "E", range = 125, width = 0, speed = math.huge, delay = .5, spellType = "enemyCast", riskLevel = "extreme", cc = true, hitLineCheck = false},
    InsanityPotion = {charName = "Singed", spellSlot = "R", range = 0, width = 0, speed = math.huge, delay = .5, spellType = "selfCast", riskLevel = "noDmg", cc = false, hitLineCheck = false},
	--Sion
	CrypticGaze = {charName = "Sion", spellSlot = "Q", range = 550, width = 0, speed = 1600, delay = .5, spellType = "enemyCast", riskLevel = "extreme", cc = true, hitLineCheck = false},
    DeathsCaressFull = {charName = "Sion", spellSlot = "W", range = 550, width = 550, speed = math.huge, delay = .5, spellType = "selfCast", riskLevel = "kill", cc = false, hitLineCheck = false, shieldSlot = _W},
    deathscaress = {charName = "Sion", spellSlot = "W", range = 550, width = 550, speed = math.huge, delay = .5, spellType = "selfCast", riskLevel = "kill", cc = false, hitLineCheck = false},
    Enrage = {charName = "Sion", spellSlot = "E", range = 0, width = 0, speed = math.huge, delay = .5, spellType = "selfCast", riskLevel = "noDmg", cc = false, hitLineCheck = false},
    Cannibalism = {charName = "Sion", spellSlot = "R", range = 0, width = 0, speed = 500, delay = .5, spellType = "selfCast", riskLevel = "noDmg", cc = false, hitLineCheck = false},
	-- Sivir
	SivirQ = {charName = "Sivir", spellSlot = "Q", range = 1075, width = 90, speed = 1350, delay = .5, spellType = "skillshot", riskLevel = "kill", cc = false, hitLineCheck = true},
    SivirW = {charName = "Sivir", spellSlot = "W", range = 500, width = 0, speed = math.huge, delay = .5, spellType = "enemyCast", riskLevel = "kill", cc = false, hitLineCheck = false},
    SivirE = {charName = "Sivir", spellSlot = "E", range = 0, width = 0, speed = math.huge, delay = .5, spellType = "selfCast", riskLevel = "noDmg", cc = false, hitLineCheck = false, shieldSlot = _E},
    SivirR = {charName = "Sivir", spellSlot = "R", range = 1000, width = 1000, speed = math.huge, delay = .5, spellType = "selfCast", riskLevel = "noDmg", cc = false, hitLineCheck = false},
	-- Skarner
	SkarnerVirulentSlash = {charName = "Skarner", spellSlot = "Q", range = 350, width = 350, speed = math.huge, delay = 0, spellType = "selfCast", riskLevel = "kill", cc = false, hitLineCheck = false},
	SkarnerExoskeleton = {charName = "Skarner", spellSlot = "W", range = 0, width = 0, speed = math.huge, delay = 0, spellType = "selfCast", riskLevel = "noDmg", cc = false, hitLineCheck = false, shieldSlot = _W},
	SkarnerFracture = {charName = "Skarner", spellSlot = "E", range = 1000, width = 60, speed = 1200, delay = .5, spellType = "skillShot", riskLevel = "extreme", cc = true, hitLineCheck = true},
	SkarnerFractureMissileSpell = {charName = "Skarner", spellSlot = "E", range = 1000, width = 60, speed = 1200, delay = .5, spellType = "skillShot", riskLevel = "extreme", cc = true, hitLineCheck = true},
	SkarnerImpale = {charName = "Skarner", spellSlot = "R", range = 350, width = 0, speed = math.huge, delay = 0, spellType = "enemyCast", riskLevel = "extreme", cc = true, hitLineCheck = false},
	-- Sona
	SonaHymnofValor = {charName = "Sona", spellSlot = "Q", range = 700, width = 700, speed = 1500, delay = .5, spellType = "selfCast", riskLevel = "kill", cc = false, hitLineCheck = false},
    SonaAriaofPerseverance = {charName = "Sona", spellSlot = "W", range = 1000, width = 1000, speed = 1500, delay = .5, spellType = "selfCast", riskLevel = "noDmg", cc = false, hitLineCheck = false, healSlot = _W},
    SonaSongofDiscord = {charName = "Sona", spellSlot = "E", range = 1000, width = 1000, speed = 1500, delay = .5, spellType = "selfCast", riskLevel = "noDmg", cc = false, hitLineCheck = false},
    SonaCrescendo = {charName = "Sona", spellSlot = "R", range = 900, width = 125, speed = 2400, delay = .5, spellType = "skillShot", riskLevel = "extreme", cc = true, hitLineCheck = true, timer = 0},
	--Soraka
	Starcall = {charName = "Soraka", spellSlot = "Q", range = 675, width = 675, speed = math.huge, delay = .5, spellType = "selfCast", riskLevel = "kill", cc = false, hitLineCheck = false},
    AstralBlessing = {charName = "Soraka", spellSlot = "W", range = 750, width = 0, speed = math.huge, delay = .5, spellType = "allyCast", riskLevel = "noDmg", cc = false, hitLineCheck = false, healSlot = _W},
    InfuseWrapper = {charName = "Soraka", spellSlot = "E", range = 725, width = 0, speed = math.huge, delay = .5, spellType = "everyCast", riskLevel = "dangerous", cc = false, hitLineCheck = false},
    Wish = {charName = "Soraka", spellSlot = "R", range = 22000, width = 0, speed = math.huge, delay = .5, spellType = "selfCast", riskLevel = "noDmg", cc = false, hitLineCheck = false, ultSlot = _R},
	-- Swain
	SwainDecrepify = {charName = "Swain", spellSlot = "Q", range = 625, width = 0, speed = math.huge, delay = .5, spellType = "enemyCast", riskLevel = "extreme", cc = true, hitLineCheck = false},
    SwainShadowGrasp = {charName = "Swain", spellSlot = "W", range = 1040, width = 275, speed = 1250, delay = .5, spellType = "skillShot", riskLevel = "extreme", cc = true, hitLineCheck = false},
    SwainTorment = {charName = "Swain", spellSlot = "E", range = 625, width = 0, speed = 1400, delay = .5, spellType = "enemyCast", riskLevel = "kill", cc = false, hitLineCheck = false},
    SwainMetamorphism = {charName = "Swain", spellSlot = "R", range = 700, width = 700, speed = 950, delay = .5, spellType = "selfCast", riskLevel = "kill", cc = false, hitLineCheck = false},
	--Syndra
	SyndraQ = {charName = "Syndra", spellSlot = "Q", range = 800, width = 200, speed = 1750, delay = .25, spellType = "skillShot", riskLevel = "kill", cc = false, hitLineCheck = false},
        --special spell
    SyndraW = {charName = "Syndra", spellSlot = "W", range = 925, width = 200, speed = 1450, delay = .5, spellType = "enemyCast", riskLevel = "noDmg", cc = false, hitLineCheck = false},
    syndrawcast = {charName = "Syndra", spellSlot = "W", range = 950, width = 200, speed = 1450, delay = .5, spellType = "skillShot", riskLevel = "extreme", cc = true, hitLineCheck = false},
        --special spell
    SyndraE = {charName = "Syndra", spellSlot = "E", range = 700, width = 0, speed = 902, delay = .5, spellType = "skillShot", riskLevel = "extreme", cc = true, hitLineCheck = true},
    SyndraR = {charName = "Syndra", spellSlot = "R", range = 675, width = 0, speed = 1100, delay = .5, spellType = "enemyCast", riskLevel = "kill", cc = false, hitLineCheck = false},
	--Talon
	TalonNoxianDiplomacy = {charName = "Talon", spellSlot = "Q", range = 0, width = 0, speed = 0, delay = 0, spellType = "selfCast", riskLevel = "noDmg", cc = false, hitLineCheck = false},
	TalonRake = {charName = "Talon", spellSlot = "W", range = 750, width = 0, speed = 1200, delay = .5, spellType = "skillShot", riskLevel = "extreme", cc = true, hitLineCheck = true},
	TalonCutthroat= {charName = "Talon", spellSlot = "E", range = 750, width = 0, speed = 1200, delay = 0, spellType = "enemyCast", riskLevel = "dangerous", cc = true, hitLineCheck = false},
	TalonShadowAssault= {charName = "Talon", spellSlot = "R", range = 750, width = 0, speed = 0, delay = 0, spellType = "selfCast", riskLevel = "kill", cc = false, hitLineCheck = false},
	--Taric
    Imbue = {charName = "Taric", spellSlot = "Q", range = 750, width = 0, speed = 1200, delay = .5, spellType = "allyCast", riskLevel = "noDmg", cc = false, hitLineCheck = false, healSlot = _Q},
    Shatter = {charName = "Taric", spellSlot = "W", range = 400, width = 200, speed = math.huge, delay = .5, spellType = "selfCast", riskLevel = "kill", cc = false, hitLineCheck = false},
    Dazzle = {charName = "Taric", spellSlot = "E", range = 625, width = 0, speed = 1400, delay = .5, spellType = "enemyCast", riskLevel = "extreme", cc = true, hitLineCheck = false},
    TaricHammerSmash = {charName = "Taric", spellSlot = "R", range = 400, width = 200, speed = math.huge, delay = .5, spellType = "selfCast", riskLevel = "kill", cc = false, hitLineCheck = false},
	--Teemo
    BlindingDart = {charName = "Teemo", spellSlot = "Q", range = 580, width = 0, speed = 1500, delay = .5, spellType = "enemyCast", riskLevel = "extreme", cc = true, hitLineCheck = false},
    MoveQuick = {charName = "Teemo", spellSlot = "W", range = 0, width = 0, speed = 943, delay = 0, spellType = "selfCast", riskLevel = "noDmg", cc = false, hitLineCheck = false},
    ToxicShot = {charName = "Teemo", spellSlot = "E", range = 0, width = 0, speed = math.huge, delay = .5, spellType = "selfCast", riskLevel = "noDmg", cc = false, hitLineCheck = false},
    BantamTrap = {charName = "Teemo", spellSlot = "R", range = 230, width = 0, speed = 1500, delay = 0, spellType = "skillShot", riskLevel = "kill", cc = true, hitLineCheck = false},
	--Thresh
	ThreshQ = {charName = "Thresh", spellSlot = "Q", range = 1075, width = 60, speed = 1200, delay = 0.5, spellType = "skillShot", riskLevel = "extreme", cc = true, hitLineCheck = true},
    ThreshW = {charName = "Thresh", spellSlot = "W", range = 950, width = 315, speed = math.huge, delay = 0.5, spellType = "skillShot", riskLevel = "noDmg", cc = false, hitLineCheck = false, shieldSlot = _W},
        --special spell
    ThreshE = {charName = "Thresh", spellSlot = "E", range = 515, width = 160, speed = math.huge, delay = 0.3, spellType = "skillShot", riskLevel = "extreme", cc = true, hitLineCheck = true},
    ThreshRPenta = {charName = "Thresh", spellSlot = "R", range = 420, width = 420, speed = math.huge, delay = 0.3, spellType = "skillShot", riskLevel = "extreme", cc = true, hitLineCheck = false},
	-- Tristana
	RapidFire = {charName = "Tristana", spellSlot = "Q", range = 0, width = 0, speed = math.huge, delay = .5, spellType = "selfCast", riskLevel = "noDmg", cc = false, hitLineCheck = false},
    RocketJump = {charName = "Tristana", spellSlot = "W", range = 900, width = 270, speed = 1150, delay = .5, spellType = "skillShot", riskLevel = "kill", cc = false, hitLineCheck = false},
    DetonatingShot = {charName = "Tristana", spellSlot = "E", range = 625, width = 0, speed = 1400, delay = .5, spellType = "enemyCast", riskLevel = "kill", cc = false, hitLineCheck = false},
    BusterShot = {charName = "Tristana", spellSlot = "R", range = 700, width = 0, speed = 1600, delay = .5, spellType = "enemyCast", riskLevel = "extreme", cc = true, hitLineCheck = false},
	--Trundle
    TrundleTrollSmash = {charName = "Trundle", spellSlot = "Q", range = 0, width = 0, speed = math.huge, delay = .5, spellType = "enemyCast", riskLevel = "extreme", cc = true, hitLineCheck = false},
    trundledesecrate = {charName = "Trundle", spellSlot = "W", range = 0, width = 900, speed = math.huge, delay = .5, spellType = "skillShot", riskLevel = "noDmg", cc = true, hitLineCheck = false},
    TrundleCircle = {charName = "Trundle", spellSlot = "E", range = 1100, width = 188, speed = 1600, delay = .5, spellType = "skillShot", riskLevel = "dangerous", cc = true, hitLineCheck = false},
    TrundlePain = {charName = "Trundle", spellSlot = "R", range = 700, width = 0, speed = 1400, delay = .5, spellType = "enemyCast", riskLevel = "kill", cc = false, hitLineCheck = false},
    -- Tryndamere
    Bloodlust = {charName = "Tryndamere", spellSlot = "Q", range = 0, width = 0, speed = math.huge, delay = .5, spellType = "selfCast", riskLevel = "noDmg", cc = false, hitLineCheck = false},
    MockingShout = {charName = "Tryndamere", spellSlot = "W", range = 400, width = 400, speed = 500, delay = .5, spellType = "skillShot", riskLevel = "dangerous", cc = true, hitLineCheck = false},
    slashCast = {charName = "Tryndamere", spellSlot = "E", range = 660, width = 225, speed = 700, delay = .5, spellType = "skillShot", riskLevel = "kill", cc = false, hitLineCheck = false},
    UndyingRage = {charName = "Tryndamere", spellSlot = "R", range = 0, width = 0, speed = math.huge, delay = .5, spellType = "selfCast", riskLevel = "noDmg", cc = false, hitLineCheck = false, ultSlot = _R},
	-- TwistedFate
    WildCards = {charName = "TwistedFate", spellSlot = "Q", range = 1450, width = 80, speed = 1450, delay = .5, spellType = "skillShot", riskLevel = "kill", cc = false, hitLineCheck = true},
    PickACard = {charName = "TwistedFate", spellSlot = "W", range = 0, width = 0, speed = math.huge, delay = .5, spellType = "selfCast", riskLevel = "noDmg", cc = true, hitLineCheck = false},
    goldcardpreattack = {charName = "TwistedFate", spellSlot = "W", range = 600, width = 0, speed = math.huge, delay = .5, spellType = "enemyCast", riskLevel = "extreme", cc = true, hitLineCheck = false},
    redcardpreattack = {charName = "TwistedFate", spellSlot = "W", range = 600, width = 100, speed = math.huge, delay = .5, spellType = "enemyCast", riskLevel = "extreme", cc = true, hitLineCheck = false},
    bluecardpreattack = {charName = "TwistedFate", spellSlot = "W", range = 600, width = 0, speed = math.huge, delay = .5, spellType = "enemyCast", riskLevel = "kill", cc = true, hitLineCheck = false},
    CardmasterStack = {charName = "TwistedFate", spellSlot = "E", range = 525, width = 0, speed = 1200, delay = .5, spellType = "selfCast", riskLevel = "noDmg", cc = false, hitLineCheck = false},
    Destiny = {charName = "TwistedFate", spellSlot = "R", range = 5500, width = 0, speed = math.huge, delay = .5, spellType = "skillShot", riskLevel = "noDmg", cc = false, hitLineCheck = false},
	--Twitch
	HideInShadows = {charName = "Twich", spellSlot = "Q", range = 0, width = 0, speed = math.huge, delay = .5, spellType = "selfCast", riskLevel = "noDmg", cc = false, hitLineCheck = false},
	TwitchVenomCask = {charName = "Twich", spellSlot = "W", range = 800, width = 275, speed = 1750, delay = .5, spellType = "skillShot", riskLevel = "extreme", cc = true, hitLineCheck = false},
	TwitchVenomCaskMissle = {charName = "Twich", spellSlot = "W", range = 800, width = 275, speed = 1750, delay = .5, spellType = "skillShot", riskLevel = "extreme", cc = true, hitLineCheck = false},
    Expunge = {charName = "Twich", spellSlot = "E", range = 1200, width = 0, speed = math.huge, delay = .5, spellType = "enemyCast", riskLevel = "kill", cc = false, hitLineCheck = false},
    FullAutomatic = {charName = "Twich", spellSlot = "R", range = 850, width = 0, speed = 500, delay = .5, spellType = "enemyCast", riskLevel = "kill", cc = false, hitLineCheck = false},
	--Udyr
	UdyrTigerStance = {charName = "Udyr", spellSlot = "Q", range = 0, width = 0, speed = math.huge, delay = .5, spellType = "selfCast", riskLevel = "noDmg", cc = false, hitLineCheck = false},
    UdyrTurtleStance = {charName = "Udyr", spellSlot = "W", range = 0, width = 0, speed = math.huge, delay = .5, spellType = "selfCast", riskLevel = "noDmg", cc = false, hitLineCheck = false, shieldSlot = _W},
    UdyrBearStance = {charName = "Udyr", spellSlot = "E", range = 0, width = 0, speed = math.huge, delay = .5, spellType = "selfCast", riskLevel = "noDmg", cc = true, hitLineCheck = false},
    UdyrPhoenixStance = {charName = "Udyr", spellSlot = "R", range = 0, width = 0, speed = math.huge, delay = .5, spellType = "selfCast", riskLevel = "noDmg", cc = false, hitLineCheck = false},
	-- Urgot
	UrgotHeatseekingLineqqMissile = {charName = "Urgot", spellSlot = "Q", range = 1000, width = 80, speed = 1600, delay = .5, spellType = "skillShot", riskLevel = "kill", cc = false, hitLineCheck = false},
    UrgotHeatseekingMissile = {charName = "Urgot", spellSlot = "Q", range = 1000, width = 80, speed = 1600, delay = .5, spellType = "skillShot", riskLevel = "kill", cc = false, hitLineCheck = false},
    UrgotTerrorCapacitorActive2 = {charName = "Urgot", spellSlot = "W", range = 0, width = 300, speed = math.huge, delay = .5, spellType = "selfCast", riskLevel = "noDmg", cc = false, hitLineCheck = false, shieldSlot = _W},
    UrgotPlasmaGrenade = {charName = "Urgot", spellSlot = "E", range = 950, width = 150, speed = 1750, delay = .5, spellType = "skillShot", riskLevel = "kill", cc = false, hitLineCheck = false},
    UrgotPlasmaGrenadeBoom = {charName = "Urgot", spellSlot = "E", range = 950, width = 150, speed = 1750, delay = .5, spellType = "skillShot", riskLevel = "kill", cc = false, hitLineCheck = false},
    UrgotSwap2 = {charName = "Urgot", spellSlot = "R", range = 850, width = 0, speed = 1800, delay = .5, spellType = "enemyCast", riskLevel = "dangerous", cc = true, hitLineCheck = false},
	-- Varus
	    --special spell (charge)
	VarusQ = {charName = "Varus", spellSlot = "Q", range = 1500, width = 100, speed = 1500, delay = .5, spellType = "skillShot", riskLevel = "kill", cc = false, hitLineCheck = true},
	VarusW = {charName = "Varus", spellSlot = "W", range = 0, width = 0, speed = 0, delay = .5, spellType = "selfCast", riskLevel = "noDmg", cc = false, hitLineCheck = false},
	VarusE = {charName = "Varus", spellSlot = "E", range = 925, width = 55, speed = 1500, delay = .5, spellType = "skillShot", riskLevel = "extreme", cc = true, hitLineCheck = false},
	VarusR = {charName = "Varus", spellSlot = "R", range = 1300, width = 80, speed = 1500, delay = .5, spellType = "skillShot", riskLevel = "extreme", cc = true, hitLineCheck = true},
	-- Vayne
	VayneTumble = {charName = "Vayne", spellSlot = "Q", range = 250, width = 0, speed = math.huge, delay = .5, spellType = "skillShot", riskLevel = "noDmg", cc = false, hitLineCheck = false},
    VayneSilverBolts = {charName = "Vayne", spellSlot = "W", range = 0, width = 0, speed = math.huge, delay = 0, spellType = "selfCast", riskLevel = "noDmg", cc = false, hitLineCheck = false},
    VayneCondemm = {charName = "Vayne", spellSlot = "E", range = 450, width = 0, speed = 1200, delay = .5, spellType = "enemyCast", riskLevel = "dangerous", cc = true, hitLineCheck = false},
    vayneinquisition = {charName = "Vayne", spellSlot = "R", range = 0, width = 0, speed = math.huge, delay = .5, spellType = "selfCast", riskLevel = "noDmg", cc = false, hitLineCheck = false},
	-- Veigar|same as vik inc. E(cage) range to teh maximum of range+(cage/2)
	VeigarBalefulStrike = {charName = "Veigar", spellSlot = "Q", range = 650, width = 0, speed = 1500, delay = .5, spellType = "enemyCast", riskLevel = "kill", cc = false, hitLineCheck = false},
    VeigarDarkMatter = {charName = "Veigar", spellSlot = "W", range = 900, width = 240, speed = 1500, delay = 1.2, spellType = "skillShot", riskLevel = "kill", cc = false, hitLineCheck = false},
    VeigarEventHorizon = {charName = "Veigar", spellSlot = "E", range = 650, width = 350, speed = 1500, delay = math.huge, spellType = "skillShot", riskLevel = "dangerous", cc = true, hitLineCheck = false},
    VeigarPrimordialBurst = {charName = "Veigar", spellSlot = "R", range = 650, width = 0, speed = 1400, delay = .5, spellType = "enemyCast", riskLevel = "kill", cc = false, hitLineCheck = false, timer = 230 - GetLatency()},
	--Vel'Koz
	VelkozQ = {charName = "Velkoz", spellSlot = "Q", range = 1050, width = 60, speed = 1200, delay = .3, spellType = "skillShot", riskLevel = "extreme", cc = true, hitLineCheck = true},
	VelkozQMissle = {charName = "Velkoz", spellSlot = "Q", range = 1050, width = 60, speed = 1200, delay = 0, spellType = "skillShot", riskLevel = "extreme", cc = true, hitLineCheck = true},
    velkozqplitactive = {charName = "Velkoz", spellSlot = "Q", range = 1050, width = 60, speed = 1200, delay = .8, spellType = "skillShot", riskLevel = "extreme", cc = true, hitLineCheck = true},
    VelkozW = {charName = "Velkoz", spellSlot = "W", range = 1050, width = 90, speed = 1200, delay = 0, spellType = "skillShot", riskLevel = "kill", cc = false, hitLineCheck = true},
    VelkozE = {charName = "Velkoz", spellSlot = "E", range = 850, width = 0, speed = 500, delay = 0, spellType = "enemyCast", riskLevel = "extreme", cc = true, hitLineCheck = false},
        --special spell
    VelkozR = {charName = "Velkoz", spellSlot = "R", range = 1575, width = 0, speed = 1500, spellType = "skillShot", riskLevel = "extreme", cc = true, hitLineCheck = true},
	--Vi
	ViQ = {charName = "Vi", spellSlot = "Q", range = 800, width = 55, speed = 1500, delay = .5, spellType = "skillShot", riskLevel = "extreme", cc = true, hitLineCheck = true},
	ViW = {charName = "Vi", spellSlot = "W", range = 0, width = 0, speed = 0, delay = 0, spellType = "selfCast", riskLevel = "noDmg", cc = false, hitLineCheck = false},
	ViE = {charName = "Vi", spellSlot = "E", range = 600, width = 0, speed = 0, delay = 0, spellType = "skillShot", riskLevel = "kill", cc = false, hitLineCheck = true},
    ViR = {charName = "Vi", spellSlot = "R", range = 800, width = 0, speed = 0, delay = .5, spellType = "enemyCast", riskLevel = "extreme", cc = true, hitLineCheck = false, timer = 230 - GetLatency()},
	-- Viktor
	ViktorPowerTransfer = {charName = "Viktor", spellSlot = "Q", range = 600, width = 0, speed = 1400, delay = .5, spellType = "enemyCast", riskLevel = "kill", cc = false, hitLineCheck = false},
    ViktorGravitonField = {charName = "Viktor", spellSlot = "W", range = 815, width = 300, speed = 1750, delay = .5, spellType = "skillShot", riskLevel = "dangerous", cc = true, hitLineCheck = false},
    ViktorDeathRay = {charName = "Viktor", spellSlot = "E", range = 700, width = 90, speed = 1210, delay = .5, spellType = "skillShot", riskLevel = "kill", cc = false, hitLineCheck = true},
    ViktorChaosStorm = {charName = "Viktor", spellSlot = "R", range = 700, width = 250, speed = 1210, delay = .5, spellType = "skillShot", riskLevel = "extreme", cc = true, hitLineCheck = false},
	--Vladimir|notice:Rrange is defined as 875, because the true range to the center of the aoe is 700, and the aoe range is 350. 175+700=875, if this is not correct use 700(standart range)-Bilbao
	VladimirTransfusion = {charName = "Vladimir", spellSlot = "Q", range = 600, width = 0, speed = 1400, delay = .5, spellType = "enemyCast", riskLevel = "kill", cc = false, hitLineCheck = false},
    VladimirSanguinePool = {charName = "Vladimir", spellSlot = "W", range = 350, width = 350, speed = 1600, delay = .5, spellType = "selfCast", riskLevel = "extreme", cc = true, hitLineCheck = false},
    VladimirTidesofBlood = {charName = "Vladimir", spellSlot = "E", range = 610, width = 610, speed = 1100, delay = .5, spellType = "selfCast", riskLevel = "kill", cc = false, hitLineCheck = false},
    VladimirHemoplague = {charName = "Vladimir", spellSlot = "R", range = 875, width = 375, speed = 1200, delay = .5, spellType = "skillShot", riskLevel = "kill", cc = false, hitLineCheck = false},
	--Volibear
	VolibearQ = {charName = "Volibear", spellSlot = "Q", range = 300, width = 0, speed = math.huge, delay = .5, spellType = "selfCast", riskLevel = "noDmg", cc = false, hitLineCheck = false},
    VolibearW = {charName = "Volibear", spellSlot = "W", range = 400, width = 0, speed = 1450, delay = .5, spellType = "enemyCast", riskLevel = "kill", cc = false, hitLineCheck = false},
    VolibearE = {charName = "Volibear", spellSlot = "E", range = 425, width = 425, speed = 825, delay = .5, spellType = "selfCast", riskLevel = "noDmg", cc = true, hitLineCheck = false},
    VolibearR = {charName = "Volibear", spellSlot = "R", range = 425, width = 425, speed = 825, delay = 0, spellType = "selfCast", riskLevel = "noDmg", cc = false, hitLineCheck = false},
	--Warwick
	HungeringStrike = {charName = "Warwick", spellSlot = "Q", range = 400, width = 0, speed = math.huge, delay = 0, spellType = "enemyCast", riskLevel = "kill", cc = false, hitLineCheck = false},
	HuntersCall = {charName = "Warwick", spellSlot = "W", range = 1000, width = 0, speed = math.huge, delay = 0, spellType = "selfCast", riskLevel = "kill", cc = false, hitLineCheck = false},
	BlooScent = {charName = "Warwick", spellSlot = "E", range = 1500, width = 0, speed = math.huge, delay = 0, spellType = "selfCast", riskLevel = "kill", cc = false, hitLineCheck = false},
    InfiniteDuress = {charName = "Warwick", spellSlot = "R", range = 700, width = 0, speed = math.huge, delay = .5, spellType = "enemyCast", riskLevel = "extreme", cc = true, hitLineCheck = false},
	--Wukong
	MonkeyKingDoubleAttack = {charName = "MonkeyKing", spellSlot = "Q", range = 300, width = 0, speed = 20, delay = .5, spellType = "selfCast", riskLevel = "noDmg", cc = false, hitLineCheck = false},
	    -- special spell
    MonkeyKingDecoy = {charName = "MonkeyKing", spellSlot = "W", range = 0, width = 175, speed = 0, delay = .5, spellType = "selfCast", riskLevel = "noDmg", cc = false, hitLineCheck = false},
    MonkeyKingDecoySwipe = {charName = "MonkeyKing", spellSlot = "W", range = 325, width = 325, speed = 0, delay = .5, spellType = "selfCast", riskLevel = "noDmg", cc = false, hitLineCheck = false},
    MonkeyKingNimbus = {charName = "MonkeyKing", spellSlot = "E", range = 625, width = 0, speed = 2200, delay = 0, spellType = "enemyCast", riskLevel = "kill", cc = false, hitLineCheck = false},
    MonkeyKingSpinToWin = {charName = "MonkeyKing", spellSlot = "R", range = 315, width = 315, speed = 700, delay = 0, spellType = "selfCast", riskLevel = "extreme", cc = true, hitLineCheck = false},
    monkeykingspintowinleave = {charName = "MonkeyKing", spellSlot = "R", range = 0, width = 0, speed = 700, delay = 0, spellType = "selfCast", riskLevel = "noDmg", cc = false, hitLineCheck = false},
	-- Xerath 
	    --special spell (chargeup)
    XerathArcanoPulseChargeUp = {charName = "Xerath", spellSlot = "Q", range = 750, width = 100, speed = 500, delay = .75, spellType = "skillShot", riskLevel = "kill", cc = false, hitLineCheck = true},
    XerathArcaneBarrage2 = {charName = "Xerath", spellSlot = "W", range = 1100, width = 200, speed = 20, delay = .5, spellType = "skillShot", riskLevel = "extreme", cc = true, hitLineCheck = false},
    XerathMageSpear = {charName = "Xerath", spellSlot = "E", range = 1050, width = 70, speed = 1600, delay = .5, spellType = "skillshot", riskLevel = "extreme", cc = true, hitLineCheck = true},
        --special spell range 3200, 4400, 5600
    XerathLocusOfPower2 = {charName = "Xerath", spellSlot = "R", range = 5600, width = 200, speed = 500, delay = .75, spellType = "skillShot", riskLevel = "kill", cc = false, hitLineCheck = false},
	--Xin Zhao
    XenZhaoComboTarget = {charName = "Xin Zhao", spellSlot = "Q", range = 200, width = 0, speed = 2000, delay = 0, spellType = "selfCast", riskLevel = "extreme", cc = false, hitLineCheck = false},
    XenZhaoBattleCry = {charName = "Xin Zhao", spellSlot = "W", range = 0, width = 0, speed = 2000, delay = 0, spellType = "selfCast", riskLevel = "noDmg", cc = false, hitLineCheck = false},
    XenZhaoSweep = {charName = "Xin Zhao", spellSlot = "E", range = 600, width = 120, speed = 1750, delay = .5, spellType = "enemyCast", riskLevel = "extreme", cc = true, hitLineCheck = false},
    XenZhaoParry = {charName = "Xin Zhao", spellSlot = "R", range = 375, width = 375, speed = 1750, delay = 0, spellType = "selfCast", riskLevel = "extreme", cc = true, hitLineCheck = false},
	--Yasuo
	YasuoQW = {charName = "Yasuo", spellSlot = "Q", range = 475, width = 55, speed = 1500, delay = .75, spellType = "skillShot", riskLevel = "kill", cc = false, hitLineCheck = true},
    yasuoq2w = {charName = "Yasuo", spellSlot = "Q", range = 475, width = 55, speed = 1500, delay = .75, spellType = "skillShot", riskLevel = "kill", cc = false, hitLineCheck = true},
    yasuoq3w = {charName = "Yasuo", spellSlot = "Q", range = 1000, width = 90, speed = 1500, delay = .75, spellType = "skillShot", riskLevel = "extreme", cc = true, hitLineCheck = true},
    YasuoWMovingWall = {charName = "Yasuo", spellSlot = "W", range = 400, width = 0, speed = 500, delay = .5, spellType = "skillShot", riskLevel = "noDmg", cc = false, hitLineCheck = false},
    YasuoDashWrapper = {charName = "Yasuo", spellSlot = "E", range = 475, width = 0, speed = 20, delay = .5, spellType = "enemyCast", riskLevel = "kill", cc = false, hitLineCheck = false},
    YasuoRKnockUpComboW = {charName = "Yasuo", spellSlot = "R", range = 1200, width = 0, speed = 20, delay = .5, spellType = "selfCast", riskLevel = "kill", cc = false, hitLineCheck = false},
	--Yorick
    YorickSpectral = {charName = "Yorick", spellSlot = "Q", range = 0, width = 0, speed = math.huge, delay = .5, spellType = "selfCast", riskLevel = "kill", cc = false, hitLineCheck = false},
    YorickDecayed = {charName = "Yorick", spellSlot = "W", range = 600, width = 200, speed = math.huge, delay = .5, spellType = "skillShot", riskLevel = "extreme", cc = true, hitLineCheck = false},
    YorickRavenous = {charName = "Yorick", spellSlot = "E", range = 550, width = 200, speed = math.huge, delay = .5, spellType = "enemyCast", riskLevel = "kill", cc = true, hitLineCheck = false},
    YorickReviveAlly = {charName = "Yorick", spellSlot = "R", range = 900, width = 0, speed = 1500, delay = .5, spellType = "allyCast", riskLevel = "noDmg", cc = false, hitLineCheck = false},
	--Zac
    ZacQ = {charName = "Zac", spellSlot = "Q", range = 550, width = 120, speed = 902, delay = .5, spellType = "skillShot", riskLevel = "dangerous", cc = true, hitLineCheck = true},
	ZacW = {charName = "Zac", spellSlot = "W", range = 350, width = 350, speed = 1600, delay = .5, spellType = "selfCast", riskLevel = "extreme", cc = false, hitLineCheck = false},
	    --special spell
	ZacE = {charName = "Zac", spellSlot = "E", range = 1550, width = 250, speed = 1500, delay = .5, spellType = "skillshot", riskLevel = "extreme", cc = true, hitLineCheck = false},
	    --special spell
	ZacR = {charName = "Zac", spellSlot = "R", range = 850, width = 300, speed = 1800, delay = .5, spellType = "selfCast", riskLevel = "extreme", cc = true, hitLineCheck = false},
	--Zed
	ZedShuriken = {charName = "Zed", spellSlot = "Q", range = 900, width = 45, speed = 902, delay = .5, spellType = "skillShot", riskLevel = "kill", cc = false, hitLineCheck = true},
	ZedShdaowDash = {charName = "Zed", spellSlot = "W", range = 550, width = 40, speed = 1600, delay = .5, spellType = "skillShot", riskLevel = "noDmg", cc = false, hitLineCheck = false},
	ZedPBAOEDummy = {charName = "Zed", spellSlot = "E", range = 300, width = 300, speed = 0, delay = .0, spellType = "selfCast", riskLevel = "dangerous", cc = true, hitLineCheck = false},
	zedult = {charName = "Zed", spellSlot = "R", range = 850, width = 0, speed = 0, delay = .5, spellType = "enemyCast", riskLevel = "kill", cc = false, hitLineCheck = false},
	-- Ziggs
	ZiggsQ = {charName = "Ziggs", spellSlot = "Q", range = 850, width = 75, speed = 1750, delay = .5, spellType = "skillShot", riskLevel = "kill", cc = false, hitLineCheck = true},
	ZiggsQSpell = {charName = "Ziggs", spellSlot = "Q", range = 850, width = 75, speed = 1750, delay = .5, spellType = "skillShot", riskLevel = "kill", cc = false, hitLineCheck = true},
	ZiggsW = {charName = "Ziggs", spellSlot = "W", range = 850, width = 300, speed = 1750,  delay = .5, spellType = "skillShot", riskLevel = "kill", cc = true, hitLineCheck = false},
	ziggswtoggle = {charName = "Ziggs", spellSlot = "W", range = 850, width = 300, speed = 1750,  delay = .5, spellType = "selfCast", riskLevel = "kill", cc = true, hitLineCheck = false},
	ZiggsE = {charName = "Ziggs", spellSlot = "E", range = 850, width = 350, speed = 1750, delay = .5, spellType = "skillShot", riskLevel = "extreme", cc = true, hitLineCheck = false},
	ziggse2 = {charName = "Ziggs", spellSlot = "E", range = 850, width = 350, speed = 1750, delay = .5, spellType = "skillShot", riskLevel = "extreme", cc = true, hitLineCheck = false},
	ZiggsR = {charName = "Ziggs", spellSlot = "R", range = 850, width = 600, speed = 1750, delay = .5, spellType = "skillShot", riskLevel = "kill", cc = false, hitLineCheck = false, timer = 950 - GetLatency()},
	--Zilean
	TimeBomb = {charName = "Zilean", spellSlot = "Q", range = 700, width = 0, speed = 1100, delay = .0, spellType = "everyCast", riskLevel = "kill", cc = false, hitLineCheck = false, timer = 3000},
	Rewind = {charName = "Zilean", spellSlot = "W", range = 0, width = 0, speed = math.huge, delay = .5, spellType = "selfCast", riskLevel = "noDmg", cc = false, hitLineCheck = false},
	TimeWarp = {charName = "Zilean", spellSlot = "E", range = 700, width = 0, speed = 1100, delay = .5, spellType = "everyCast", riskLevel = "dangerous", cc = true, hitLineCheck = false, exhaustSlot = _E},
    ChronoShift = {charName = "Zilean", spellSlot = "R", range = 780, width = 0, speed = math.huge, delay = .5, spellType = "allyCast", riskLevel = "noDmg", cc = false, hitLineCheck = false, ultSlot = _R},
	-- Zyra
	ZyraQFissure = {charName = "Zyra", spellSlot = "Q", range = 800, width = 240, speed = 1400, delay = .5, spellType = "skillshot", riskLevel = "kill", cc = false, hitLineCheck = false},
	ZyraSeed = {charName = "Zyra", spellSlot = "W", range = 800, width = 0, speed = 2200, delay = .5, spellType = "skillshot", riskLevel = "noDmg", cc = false, hitLineCheck = false},
	ZyraGraspingRoots = {charName = "Zyra", spellSlot = "E", range = 1100, width = 70, speed = 1400, delay = .5, spellType = "skillshot", riskLevel = "extreme", cc = true, hitLineCheck = true},
	    --special spell
	ZyraBrambleZone = {charName = "Zyra", spellSlot = "R", range = 700, width = 550, speed = 20, delay = .5, spellType = "skillshot", riskLevel = "extreme", cc = true, hitLineCheck = false},
}
