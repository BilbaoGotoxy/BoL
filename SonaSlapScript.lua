if GetMyHero().charName == "Sona" then
recall_status = false
recall_tick = 0

buyDelay = math.random(1000, 3000)
lastBuy = 0
nextbuyIndex = 1
wardBought = 0
item_locket = nil
range_locket = 600
item_mikael = nil
range_mikeal = 750
item_talisman = nil
range_talisman = 600
item_dfg = nil
item_arangl = nil
item_bilge = nil
item_botrk = nil
item_hextech = nil
item_zhonya = nil
item_hydra = nil
item_tiamat = nil
item_randuin = nil
item_mercurial = nil
item_qss = nil
item_twins = nil
item_frostqueen = nil
firstBought = false
abilityLevel = 0
spell_count = 0
canitrytohitem = false
ihityou = nil
abilitySequence = {1,2,3,1,1,4,1,2,1,2,4,2,2,3,3,4,3,3} -- list for SetupAutoLvLSpell
shopList = {3098, 1004, 1004, 3028, 1001, 1028, 2049, 1052, 1027, 3057, 3222, 3158, 2045, 3100, 3092, 1028, 3105, 3190, 3107  }
--[[
slot1:Spellthief's Edge 3303->3098->3092 gold
slot2:1028->2049->2045 ward
slot3:1001->3158->3107 boots
slot4:1052->1027->3057->3100 lichbane/shen
slot5:3028->3222 mikael/mana
slot6:1028->3105->3190
ward slot:3340
]]--
function hitem()
	if canitrytohitem == true then
		for i = 1, heroManager.iCount do
			local target = heroManager:GetHero(i)
				if target ~= nil and GetDistance(target, player) < 550 and target.team~=player.team then					
					player:Attack(target)
					canitrytohitem = false
				end
		end
	end
end


function skill()
if player.level > abilityLevel then
abilityLevel=abilityLevel+1
if abilitySequence[abilityLevel] == 1 then LevelSpell(_Q)
elseif abilitySequence[abilityLevel] == 2 then LevelSpell(_W)
elseif abilitySequence[abilityLevel] == 3 then LevelSpell(_E)
elseif abilitySequence[abilityLevel] == 4 then LevelSpell(_R) end
end
end




function OnTick()
--scan_multi_target_shot()
	if recall_status == true then
		--PrintChat("Recall detected. Pause Script.")
	else
		hitem()
		_use_spells_on_cd()
		autocast_items()
		skill()
		shopping()
		auto_summ()
end
end


function _use_spells_on_cd()
autocast_Q()
autocast_W()
autocast_E()
autocast_R()
end






function autocast_Q()
	if player:GetSpellData(0).level > 0 and player:CanUseSpell(_Q) == READY then
		for i = 1, heroManager.iCount do
			local target = heroManager:GetHero(i)
				if target ~= nil and GetDistance(target, player) < 700 and target.team~=player.team then
					ihityou=target
					CastSpell(_Q)
					canitrytohitem = true
				end
		end
	end
end



function autocast_W()
	if player:GetSpellData(1).level > 0 and player:CanUseSpell(_W) == READY then
		for i = 1, heroManager.iCount do
			local healtarget = heroManager:GetHero(i)
			if healtarget ~= nil and GetDistance(healtarget, player) < 1000 and healtarget.team==player.team and healtarget.health<=healtarget.maxHealth*0.85 and healtarget.visible and healtarget.dead==false then
				CastSpell(_W)
				canitrytohitem = false
			end
		end
	end
end


function autocast_E()
if player:GetSpellData(2).level > 0 and player:CanUseSpell(_E) == READY then
for i = 1, heroManager.iCount do
local target = heroManager:GetHero(i)
if target ~= nil and GetDistance(target, player) < 1000 and target.team==player.team and player.mana >= 600 and target.health==26 then
CastSpell(_E)
canitrytohitem = false
end
end
end
end


function autocast_R()
if player:GetSpellData(3).level > 0 and player:CanUseSpell(_R) == READY then
for i = 1, heroManager.iCount do
local target = heroManager:GetHero(i)
if target ~= nil and GetDistance(target, player) < 1000 and target.team~=player.team and target.visible and target.dead==false then
scan_target(target)
canitrytohitem = false
end
end
end
end

function scan_target(target)--2targets=one shot
local lasttarget=target
	for i = 1, heroManager.iCount do
		local new_target = heroManager:GetHero(i)
		if new_target ~= nil and new_target ~=lasttarget and GetDistance(new_target, player) < 1000 and GetDistance(new_target, lasttarget) < 200 and new_target.team~=player.team and new_target.visible and new_target.dead==false and new_target.isCharmed==false and new_target.isFeared==false and new_target.isTaunted==false then
			CastSpell(_R, new_target.x, new_target.z)
		end
	end
end
--336=1000
--80=230




function scan_multi_target_shot()
local mt_target_one = nil
local mt_target_two = nil
local mt_target_three = nil
local mt_target_four = nil
local mt_five = nil

	for i = 1, heroManager.iCount do
		local mt_target = heroManager:GetHero(i)		
		if mt_target ~= nil and mt_target.team~=player.team then --1
			mt_target_one = mt_target
		end
	end
		
	for i = 1, heroManager.iCount do
		local mt_target = heroManager:GetHero(i)			
		if mt_target ~= nil and mt_target.team~=player.team and mt_target~=mt_target_one then--2
			mt_target_two = mt_target
		end
	end


	for i = 1, heroManager.iCount do
		local mt_target = heroManager:GetHero(i)				
		if mt_target ~= nil and mt_target.team~=player.teamand and mt_target~=mt_target_one and mt_target~=mt_target_two then--3
			mt_target_three = mt_target
		end
	end
	
	
	for i = 1, heroManager.iCount do
		local mt_target = heroManager:GetHero(i)						
		if mt_target ~= nil and mt_target.team~=player.team and mt_target~=mt_target_one and mt_target~=mt_target_two and mt_target~=mt_target_three then--4
			mt_target_four = mt_target
		end
	end
	
	
	for i = 1, heroManager.iCount do
		local mt_target = heroManager:GetHero(i)						
		if mt_target ~= nil and mt_target.team~=player.team and mt_target~=mt_target_one and mt_target~=mt_target_two and mt_target~=mt_target_three and mt_target~=mt_target_four then--5
			mt_target_five = mt_target
		end
	end
	
	

PrintChat("MT Selector Target 1: "..mt_target_one.charName)
PrintChat("MT Selector Target 2: "..mt_target_two.charName)
PrintChat("MT Selector Target 3: "..mt_target_three.charName)
PrintChat("MT Selector Target 4: "..mt_target_four.charName)
PrintChat("MT Selector Target 5: "..mt_target_five.charName)




end


function autocast_items()
_getitemslots()
autocast_mikael()
autocast_locket()
autocast_talisman()
auto_twins()
auto_qss()
auto_mercurial()
auto_randuin()
auto_tiamat()
auto_hydra()
auto_hextech()
auto_botrk()
auto_bilge()
auto_zhonya()
auto_archangel()
auto_dfg()
auto_frostqueen()
autocast_fom()
end

function autocast_mikael()
		if item_mikael ~= nil and player:CanUseSpell(item_mikael) == READY then
			for i = 1, heroManager.iCount do
				local target = heroManager:GetHero(i)
				if target ~= nil and GetDistance(target, player) < range_mikeal and target.team==player.team and  target.health<=target.maxHealth*0.55 and target.maxHealth<=3000 and target.visible then
					CastSpell(item_mikael, target)
				end
			end
		end
end


function autocast_locket()
	if item_locket ~= nil and player:CanUseSpell(item_locket) == READY then
		for i = 1, heroManager.iCount do
			local target = heroManager:GetHero(i)
			if target ~= nil and GetDistance(target, player) < range_locket and  target.team==player.team and  target.health<=target.maxHealth*0.4 then
				CastSpell(item_locket)
			end
		end
	end
end


function autocast_fom()
	if item_fom ~= nil and player:CanUseSpell(item_fom) == READY then
		for i = 1, heroManager.iCount do
			local target = heroManager:GetHero(i)
			if target ~= nil and GetDistance(target, player) < range_locket and  target.team==player.team and  target.health<=target.maxHealth*0.44 then
				CastSpell(item_fom)
			end
		end
	end
end


function autocast_talisman()
	if item_talisman ~= nil and player:CanUseSpell(item_talisman) == READY then
		for i = 1, heroManager.iCount do
			local target = heroManager:GetHero(i)
			if target ~= nil and GetDistance(target, player) < range_talisman and  target.team==player.team and  target.health<=target.maxHealth*0.45 then
				CastSpell(item_talisman)
			end
		end
	end
end

function auto_exhaust()
if EXHAUSTSlot~=nil and player:CanUseSpell(EXHAUSTSlot) == READY then
for i = 1, heroManager.iCount do
local target = heroManager:GetHero(i)
if target ~= nil and GetDistance(target, player) < 550 and target.team~=player.team and target.health<=target.maxHealth*0.5 then
CastSpell(EXHAUSTSlot, target)
end
end
end
end

function auto_frostqueen()  
if item_frostqueen~=nil and player:CanUseSpell(item_frostqueen) == READY then
for i = 1, heroManager.iCount do
local target = heroManager:GetHero(i)
if target ~= nil and GetDistance(target, player) < 700 and target.team~=player.team and target.health<=target.maxHealth*0.8 then
CastSpell(item_frostqueen, target)
end
end
end
end



function auto_dfg()
if item_dfg~=nil and player:CanUseSpell(item_dfg) == READY then
for i = 1, heroManager.iCount do
local target = heroManager:GetHero(i)
if target ~= nil and GetDistance(target, player) < 750 and target.team~=player.team and target.visible then
CastSpell(item_dfg, target)
end
end
end
end

function auto_archangel()
	if item_arangl~=nil and player:CanUseSpell(item_arangl) == READY then
		if player.health<=player.maxHealth*0.55 then
			CastSpell(item_arangl)
		end
	end
end

function auto_zhonya()
	if item_zhonya~=nil and player:CanUseSpell(item_zhonya) == READY then
		if player.health<=player.maxHealth*0.4 then
			CastSpell(item_zhonya)
		end
	end
end


function auto_bilge()
if item_bilge~=nil and player:CanUseSpell(item_bilge) == READY then
for i = 1, heroManager.iCount do
local target = heroManager:GetHero(i)
if target ~= nil and GetDistance(target, player) < 450 and target.team~=player.team and target.visible then
CastSpell(item_bilge, target)
end
end
end
end

function auto_botrk()
if item_botrk~=nil and player:CanUseSpell(item_botrk) == READY then
for i = 1, heroManager.iCount do
local target = heroManager:GetHero(i)
if target ~= nil and GetDistance(target, player) < 450 and target.team~=player.team and target.visible then
CastSpell(item_botrk, target)
end
end
end
end

function auto_hextech()
if item_hextech~=nil and player:CanUseSpell(item_hextech) == READY then
for i = 1, heroManager.iCount do
local target = heroManager:GetHero(i)
if target ~= nil and GetDistance(target, player) < 700 and target.team~=player.team and target.visible then
CastSpell(item_hextech, target)
end
end
end
end

function auto_hydra()
if item_hydra~=nil and player:CanUseSpell(item_hydra) == READY then
for i = 1, heroManager.iCount do
local target = heroManager:GetHero(i)
if target ~= nil and GetDistance(target, player) < 185 and target.team~=player.team and target.visible then
CastSpell(item_hydra)
end
end
end
end

function auto_tiamat()
if item_tiamat~=nil and player:CanUseSpell(item_tiamat) == READY then
for i = 1, heroManager.iCount do
local target = heroManager:GetHero(i)
if target ~= nil and GetDistance(target, player) < 185 and target.team~=player.team and target.visible then
CastSpell(item_tiamat)
end
end
end
end

function auto_randuin()
if item_randuin~=nil and player:CanUseSpell(item_randuin) == READY then
for i = 1, heroManager.iCount do
local target = heroManager:GetHero(i)
if target ~= nil and GetDistance(target, player) < 500 and target.team~=player.team and target.visible then
CastSpell(item_randuin)
end
end
end
end

function auto_mercurial()
	if item_mercurial~=nil and player:CanUseSpell(item_mercurial) == READY then
		if player.isAsleep or player.isCharmed or player.isFeared or player.isFleeing or player.isTaunted then
			CastSpell(item_mercurial)
		end
	end
end

function auto_qss()
	if item_qss~=nil and player:CanUseSpell(item_qss) == READY then
		if player.isAsleep or player.isCharmed or player.isFeared or player.isFleeing or player.isTaunted then
			CastSpell(item_qss)
		end
	end
end

function auto_twins()
if item_twins~=nil and player:CanUseSpell(item_twins) == READY then
for i = 1, heroManager.iCount do
local target = heroManager:GetHero(i)
if target ~= nil and GetDistance(target, player) < 1250 and target.team~=player.team then
CastSpell(item_twins)
end
end
end
end


function _getitemslots()
item_locket = GetInventorySlotItem(3190) --Locket of the Iron Solari
item_mikael = GetInventorySlotItem(3222) --Mikael's Crucible
item_talisman = GetInventorySlotItem(3069) --Talisman of Ascension
item_dfg = GetInventorySlotItem(3128)
item_arangl = GetInventorySlotItem(3003)
item_bilge = GetInventorySlotItem(3144)
item_botrk = GetInventorySlotItem(3153)
item_hextech = GetInventorySlotItem(3146)
item_zhonya = GetInventorySlotItem(3157)
item_hydra = GetInventorySlotItem(3074)
item_tiamat = GetInventorySlotItem(3077)
item_randuin = GetInventorySlotItem(3143)
item_mercurial = GetInventorySlotItem(3139)
item_qss = GetInventorySlotItem(3140)
item_twins = GetInventorySlotItem(3023)
item_frostqueen = GetInventorySlotItem(3092)
item_fom = GetInventorySlotItem(3401)
end


function auto_ignite()
if IGNITESlot~=nil and player:CanUseSpell(IGNITESlot) == READY then
for i = 1, heroManager.iCount do
local target = heroManager:GetHero(i)
if target ~= nil and GetDistance(target, player) < 550 and target.team~=player.team and target.health<=target.maxHealth*0.3 then
CastSpell(IGNITESlot, target)
end
end
end
end


function detect_summoner_spells()
EXHAUSTSlot = ((myHero:GetSpellData(SUMMONER_1).name:find("SummonerExhaust") and SUMMONER_1) or (myHero:GetSpellData(SUMMONER_2).name:find("SummonerExhaust") and SUMMONER_2) or nil)
IGNITESlot =  ((myHero:GetSpellData(SUMMONER_1).name:find("SummonerDot") and SUMMONER_1) or (myHero:GetSpellData(SUMMONER_2).name:find("SummonerDot") and SUMMONER_2) or nil)
end

function auto_summ()
auto_exhaust()
auto_ignite()
end

function OnLoad()
	detect_summoner_spells()
	if GetInventorySlotIsEmpty(ITEM_1) == false then
	firstBought = true
	end
	startingTime = GetTickCount()
	player = GetMyHero()
	PrintChat("Sona Slap Script v.0.1 loaded.")	
end

function OnDraw()
        if not player.dead then
                DrawCircle(player.x, player.y, player.z, 700, 0x19A712)
        end
end

function OnCreateObj(object)
	if object.name == "TeleportHome.troy" and GetDistance(player, object) < 50 then
		recall_tick = GetTickCount()
		recall_status = true
	end
	if object.name == "TeleportHomeImproved.troy" and GetDistance(player, object) < 50 then
		recall_tick = GetTickCount()
		recall_status = true
	end
end

function OnDeleteObj(object)
	if object.name == "TeleportHome.troy" and GetDistance(player, object) < 50 then
		recall_status = false 
	end
	if object.name == "TeleportHomeImproved.troy" and GetDistance(player, object) < 50 then
		recall_status = false 
	end
end


function shopping()
if firstBought == false and GetTickCount() - startingTime > 2000 then
BuyItem(3303)
BuyItem(3340)
BuyItem(2044)
BuyItem(2004)
BuyItem(2003)
firstBought = true
end



if GetTickCount() - startingTime > 5000 then
if GetTickCount() > lastBuy + buyDelay then
if GetInventorySlotItem(shopList[nextbuyIndex]) ~= nil then
--Last Buy successful
nextbuyIndex = nextbuyIndex + 1
else
--Last Buy unsuccessful (buy again)
BuyItem(shopList[nextbuyIndex])
lastBuy = GetTickCount()
end
end
end

end




end
