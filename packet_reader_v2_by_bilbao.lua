local player = nil
local data = {header={}, size={}, nid={}, val_one={}, val_two={}, val_three={}}
local olddata =  {header={}, size={}, nid={}, val_one={}, val_two={}, val_three={}}
local encr_data = {ptime = {}, header = {}, dwArg1 = {}, dwArg2 = {}, data = {}}
local oldencr_data = {ptime = {}, header = {}, dwArg1 = {}, dwArg2 = {}, data = {}}
local osp_data = {sp1 = {}, sp2 = {}, sp3 = {}, sp4 = {}, sp5 = {}, sp6 = {}, sp7 = {}, sp8 = {}, sp9 = {}, sp10 = {}, sp11 = {} }
local oldosp_data = {sp1 = {}, sp2 = {}, sp3 = {}, sp4 = {}, sp5 = {}, sp6 = {}, sp7 = {}, sp8 = {}, sp9 = {}, sp10 = {}, sp11 = {} }
local this = 1
local shortlog = {ctick=0, tick=0,status=false}
local round = {a=nil,b=nil,c=nil,d=nil,e=nil,f=nil,g=nil,h=nil,i=nil}


function OnLoad()
	player = GetMyHero()
	createarray()
	init_config()
end

function OnTick()
	nextsec()
	if Config.showrcv then
		Config.showsnd=false
	else
		Config.showsnd=true
	end
if Config.decrypt==false then Config.decrypt=true end
	if Config.hk then		
		save_data("===== TIMESTEMP @ "..sec2min(math.round(GetInGameTimer(), 0)))
	end
	if Config.shortlog then
		if os.clock() >= shortlog.ctick + 1 then
			save_data(">>>Shortlog started @ ingametime: "..sec2min(math.round(GetInGameTimer(), 0)))
			PrintChat(">>>Shortlog started for "..Config.slt.."sec @ ingametime: "..sec2min(math.round(GetInGameTimer(), 0)))
			shortlog.tick=GetInGameTimer()
			shortlog.status=true
			shortlog.ctick=os.clock()
		end
	end	
end

function OnDraw()
	info_box_rcv()
	info_box_snd()
end

function OnRecvPacket(p)
if Config.StatusRcvPkt==false then return end
	if Config.decryptrcv then
        pheader = p.header
		psize = p.size
		p.pos = 1
        unk04 = p:DecodeF()
        unk02 = p:Decode2()
        unk01 = p:Decode1()
        unk03 = p:Decode4() 
        if Config.onlyme then 
			if unk04 == myHero.networkID then
				set_info(pheader, psize, 1, unk04, unk01, unk02, unk03) 
			end
		else
			set_info(pheader, psize, 1, unk04, unk01, unk02, unk03) 						
        end
	else	
		cpd = _DumpPacket(p)
		set_info_encr(cpd.time, cpd.header, cpd.dwArg1, cpd.dwArg2, cpd.data)
	end	
end
function set_info_encr(ptime, header, dwArg1, dwArg2, data)
	for i=1, 50 do		
		oldencr_data.ptime[i]=encr_data.ptime[i]
		oldencr_data.header[i]=encr_data.header[i]
		oldencr_data.dwArg1[i]=encr_data.dwArg1[i]
		oldencr_data.dwArg2[i]=encr_data.dwArg2[i]
		oldencr_data.data[i]=encr_data.data[i]		
	end
	for j=1, 50 do
		encr_data.ptime[j+1]=oldencr_data.ptime[j]
		encr_data.header[j+1]=oldencr_data.header[j]
		encr_data.dwArg1[j+1]=oldencr_data.dwArg1[j]
		encr_data.dwArg2[j+1]=oldencr_data.dwArg2[j]
		encr_data.data[j+1]=oldencr_data.data[j]
	end
		encr_data.ptime[1]=ptime
		encr_data.header[1]=header
		encr_data.dwArg1[1]=dwArg1
		encr_data.dwArg2[1]=dwArg2
		encr_data.data[1]=data		
	if Config.LOG then
		save_data("Packet time "..ptime)
		save_data("Header: "..header)
		save_data("dwArg1: "..dwArg1)
		save_data("dwArg2: "..dwArg2)
		save_data("data: "..data)
		save_data("-------------------------")
	end
end

function set_info(header, size, pos, netid, val_one, val_two, val_three)
	local gametime = sec2min(math.round(GetInGameTimer(), 0))
	for i=1, 50 do
		olddata.header[i] = data.header[i]
		olddata.size[i]=data.size[i]
		olddata.nid[i]=data.nid[i]
		olddata.val_one[i]=data.val_one[i]
		olddata.val_two[i]=data.val_two[i]
		olddata.val_three[i]=data.val_three[i]
	end
	for j=1, 50 do
		data.header[j+1]=olddata.header[j]
		data.size[j+1]=olddata.size[j]
		data.nid[j+1]=olddata.nid[j]
		data.val_one[j+1]=olddata.val_one[j]
		data.val_two[j+1]=olddata.val_two[j]
		data.val_three[j+1]=olddata.val_three[j]
	end
	data.header[1] = header
	data.size[1] = size
	data.nid[1] = netid
	data.val_one[1] = val_one
	data.val_two[1] = val_two
	data.val_three[1] = val_three	
	if Config.LOG then
		save_data("Game time: "..gametime)
		save_data("Header: "..header)
		save_data("Size: "..size)
		save_data("Value 4: "..netid)
		save_data("Value 1: "..val_one)
		save_data("Value 2: "..val_two)
		save_data("Value 3: "..val_three)
		save_data("-------------------------")
	end
end

function set_info_snd(z1, z2, z3, z4, z5, z6, z7, z8, z9, z10, z11)
for i=1, 50 do
		oldosp_data.sp1[i]=osp_data.sp1[i]
		oldosp_data.sp2[i]=osp_data.sp2[i]
		oldosp_data.sp3[i]=osp_data.sp3[i]
		oldosp_data.sp4[i]=osp_data.sp4[i]
		oldosp_data.sp5[i]=osp_data.sp5[i]
		oldosp_data.sp6[i]=osp_data.sp6[i]
		oldosp_data.sp7[i]=osp_data.sp7[i]
		oldosp_data.sp8[i]=osp_data.sp8[i]
		oldosp_data.sp9[i]=osp_data.sp9[i]
		oldosp_data.sp10[i]=osp_data.sp10[i]
		oldosp_data.sp11[i]=osp_data.sp11[i]
end
for j=1, 50 do
osp_data.sp1[j+1]=oldosp_data.sp1[j]
osp_data.sp2[j+1]=oldosp_data.sp2[j]
osp_data.sp3[j+1]=oldosp_data.sp3[j]
osp_data.sp4[j+1]=oldosp_data.sp4[j]
osp_data.sp5[j+1]=oldosp_data.sp5[j]
osp_data.sp6[j+1]=oldosp_data.sp6[j]
osp_data.sp7[j+1]=oldosp_data.sp7[j]
osp_data.sp8[j+1]=oldosp_data.sp8[j]
osp_data.sp9[j+1]=oldosp_data.sp9[j]
osp_data.sp10[j+1]=oldosp_data.sp10[j]
osp_data.sp11[j+1]=oldosp_data.sp11[j]
end
osp_data.sp1[1]=z1
osp_data.sp2[1]=z2
osp_data.sp3[1]=z3
osp_data.sp4[1]=z4
osp_data.sp5[1]=z5
osp_data.sp6[1]=z6
osp_data.sp7[1]=z7
osp_data.sp8[1]=z8
osp_data.sp9[1]=z9
osp_data.sp10[1]=z10
osp_data.sp11[1]=z11
end

function nextsec()
	if shortlog.status then
		if GetInGameTimer() - shortlog.tick < Config.slt then
			Config.StatusSndPkt=true
			Config.onlyme=false
		else
			save_data(">>>Shortlog ended @ ingametime: "..sec2min(math.round(GetInGameTimer(), 0)))
			shortlog.status=false
			Config.StatusSndPkt=false
			Config.onlyme=false
			PrintChat((">>>Shortlog ended @ ingametime: "..sec2min(math.round(GetInGameTimer(), 0))))
		end
	end
end

function OnSendPacket(p)
	if Config.StatusSndPkt==false then return end
		local packet = Packet(p)	
		if packet:get('name') == 'S_CAST' and _is_valid(packet:get('sourceNetworkId')) then
			if Config.LOG then
				save_data(tostring("char: ".._getnamebynid(packet:get('sourceNetworkId'))))
				save_data(tostring("name: "..packet:get('name')))
				save_data(tostring("dwArg1: "..packet:get('dwArg1')))
				save_data(tostring("dwArg2: "..packet:get('dwArg2')))
				save_data(tostring("sourceNetworkID: "..packet:get('sourceNetworkId')))
				save_data(tostring("spellID: "..packet:get('spellId')))	
				save_data(tostring("fromX: "..packet:get('fromX')))
				save_data(tostring("fromY: "..packet:get('fromY')))
				save_data(tostring("toX: "..packet:get('toX')))
				save_data(tostring("toY: "..packet:get('toY')))
				save_data(tostring("targetNetworkID: "..packet:get('targetNetworkId')))
				save_data("--------------------------")
			end
			round.a = math.round(packet:get('sourceNetworkId'),0)
			round.b = math.round(packet:get('fromX'),0)
			round.c = math.round(packet:get('fromY'),0)
			round.d = math.round(packet:get('toX'),0) 
			round.e = math.round(packet:get('toY'),0)
			round.f = math.round(packet:get('targetNetworkId'),0)		
			set_info_snd("char: ".._getnamebynid(packet:get('sourceNetworkId')), "name: "..packet:get('name'), "dwArg1: "..packet:get('dwArg1'), "dwArg2: "..packet:get('dwArg2'), "srcNID:~"..round.a, "spellID: "..packet:get('spellId'), "fromX:~"..round.b, "fromY:~"..round.c, "toX:~"..round.d, "toY:~"..round.e, "tarNID:~"..round.f)
		end	
	if packet:get('name') == 'S_MOVE' and _is_valid(packet:get('sourceNetworkId')) then
		if Config.LOG then
			save_data(tostring("char: ".._getnamebynid(packet:get('sourceNetworkId'))))
			save_data(tostring("name: "..packet:get('name')))
			save_data(tostring("dwArg1: "..packet:get('dwArg1')))
			save_data(tostring("dwArg2: "..packet:get('dwArg2')))
			save_data(tostring("sourceNetworkID: "..packet:get('sourceNetworkId')))
			save_data(tostring("type: "..packet:get('type')))
			save_data(tostring("x: "..packet:get('x')))
			save_data(tostring("y: "..packet:get('y')))
			save_data(tostring("targetNetworkID: "..packet:get('targetNetworkId')))
			save_data(tostring("unitNetworkID: "..packet:get('unitNetworkId')))	
			save_data("--------------------------")
		end		
		round.a = math.round(packet:get('sourceNetworkId'),0)
		round.b = math.round(packet:get('x'),0)
		round.c = math.round(packet:get('y'),0)
		round.d = math.round(packet:get('targetNetworkId'),0)
		round.e = math.round(packet:get('unitNetworkId'),0)		
		set_info_snd("char: ".._getnamebynid(packet:get('sourceNetworkId')), "name: "..packet:get('name'), "dwArg1: "..packet:get('dwArg1'), "dwArg2: "..packet:get('dwArg2'), "srcNID:~"..round.a, "type: "..packet:get('type'), "x: "..round.b, "y: "..round.c, "tarNID:~"..round.d, "unitNID: "..round.e, "   ")
	end		
	if packet:get('name') == 'S_PING' then	
		if Config.LOG then
			save_data(tostring("name: "..packet:get('name')))
			save_data(tostring("dwArg1: "..packet:get('dwArg1')))
			save_data(tostring("dwArg2: "..packet:get('dwArg2')))
			save_data(tostring("x: "..packet:get('x')))
			save_data(tostring("y: "..packet:get('y')))
			save_data(tostring("targetNetworkID: "..packet:get('targetNetworkId')))
			save_data(tostring("type: "..packet:get('type')))
			save_data("--------------------------")	
		end
		round.a = math.round(packet:get('x'),0)
		round.b = math.round(packet:get('y'),0)
		round.c = math.round(packet:get('targetNetworkId'),0)
		set_info_snd(" ", "name: "..packet:get('name'), "dwArg1: "..packet:get('dwArg1'), "dwArg2: "..packet:get('dwArg2'), "x: "..round.a, "y: "..round.b, "tarNID:~"..round.c, "type: "..packet:get('type'), " ", "  ", "  ")
	end	
	if packet:get('name') == 'PKT_BuyItemReq' then
		if Config.LOG then
			save_data(tostring("char: ".._getnamebynid(packet:get('networkId'))))
			save_data(tostring("name: "..packet:get('name')))
			save_data(tostring("dwArg1: "..packet:get('dwArg1')))
			save_data(tostring("dwArg2: "..packet:get('dwArg2')))
			save_data(tostring("networkID: "..packet:get('networkId')))
			save_data(tostring("itemID: "..packet:get('itemId')))
			save_data("--------------------------")
		end		
		round.a = math.round(packet:get('networkId'),0)
		set_info_snd("char: ".._getnamebynid(packet:get('networkId')), "name: "..packet:get('name'), "dwArg1: "..packet:get('dwArg1'), "dwArg2: "..packet:get('dwArg2'), "NID:~"..round.a, "itemID: "..packet:get('itemId'), " ", " ", " ", " ", " ")
	end
end               

function save_data(text)
	local file = io.open(SCRIPT_PATH.."packets.txt", "a")
	file:write(text)
	file:write("\n")
	file:flush()
	file:close()
end

function _getnamebynid(nID)
	local thisone = nil
	for i=1, heroManager.iCount do
		currentHero = heroManager:GetHero(i)
		if currentHero.networkID==nID then
			thisone = currentHero.charName
		end
	end
	return thisone
end

function _is_valid(nID)
	local thisone = nil
	for i=1, heroManager.iCount do
		currentHero = heroManager:GetHero(i)
		if currentHero.networkID==nID then
			thisone = currentHero
		end
	end
	if thisone~=nil then
		return true
	else
		return false
	end
end

function createarray()
	for i=1, 50 do
		data.header[i]=""
		data.size[i]=""
		data.nid[i]=""
		data.val_one[i]=""
		data.val_two[i]=""
		data.val_three[i]=""
		olddata.header[i]=""
		olddata.size[i]=""
		olddata.nid[i]=""
		olddata.val_one[i]=""
		olddata.val_two[i]=""
		olddata.val_three[i]=""		
		encr_data.ptime[i]=""
		encr_data.header[i]=""
		encr_data.dwArg1[i]=""
		encr_data.dwArg2[i]=""
		encr_data.data[i]=""
		oldencr_data.ptime[i]=""
		oldencr_data.header[i]=""
		oldencr_data.dwArg1[i]=""
		oldencr_data.dwArg2[i]=""
		oldencr_data.data[i]=""
		osp_data.sp1[i]=""
		osp_data.sp2[i]=""
		osp_data.sp3[i]=""
		osp_data.sp4[i]=""
		osp_data.sp5[i]=""
		osp_data.sp6[i]=""
		osp_data.sp7[i]=""
		osp_data.sp8[i]=""
		osp_data.sp9[i]=""
		osp_data.sp10[i]=""
		osp_data.sp11[i]=""
		oldosp_data.sp1[i]=""
		oldosp_data.sp2[i]=""
		oldosp_data.sp3[i]=""
		oldosp_data.sp4[i]=""
		oldosp_data.sp5[i]=""
		oldosp_data.sp6[i]=""
		oldosp_data.sp7[i]=""
		oldosp_data.sp8[i]=""
		oldosp_data.sp9[i]=""
		oldosp_data.sp10[i]=""
		oldosp_data.sp11[i]=""
	end
end

function init_config()      
	Config = scriptConfig("Packet Reader", "Info")	
	Config:addParam("decrypt", "Decrypt SndPackets", SCRIPT_PARAM_ONOFF, false)
	Config:addParam("showrlt", "Show Result", SCRIPT_PARAM_ONOFF, false)
	Config:addParam("showrcv", "Show RecvPacket", SCRIPT_PARAM_ONOFF, false)
	Config:addParam("showsnd", "Show SendPacket", SCRIPT_PARAM_ONOFF, false)
	Config:addParam("decryptrcv", "Decrypt RecvPacket", SCRIPT_PARAM_ONOFF, false)
	Config:addParam("StatusRcvPkt", "Start/Stop logging RcvPkt", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte("U"))
	Config:addParam("StatusSndPkt", "Start/Stop logging SendPkt", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte("Z"))
	Config:addParam("hk", "Add timestamp", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("I"))
	Config:addParam("shortlog", "Log SndPkt next sec", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("N"))	
	Config:addParam("slt", "Time for shortlog", SCRIPT_PARAM_SLICE, 3, 0, 60, 0)
	Config:permaShow("StatusRcvPkt")
	Config:permaShow("StatusSndPkt")
	Config:addParam("onlyme", "Show only my Packets", SCRIPT_PARAM_ONOFF, true)
    Config:addParam("LOG", "Log result into file", SCRIPT_PARAM_ONOFF, false)
	Config:permaShow("LOG") 
	Config:addParam("by", "v0.2 by Bilbao", SCRIPT_PARAM_INFO, "")
	PrintChat("<font color='#ab15d9'> > Packed Reader v0.2 by Bilbao loaded.</font>")
	Config.decrypt=false
	Config.StatusRcvPkt=false
	Config.onlyme=false
end

function _DumpPacket(p)
    local packet = {}
    packet.time = sec2min(math.round(GetInGameTimer(), 0))
    packet.dwArg1 = p.dwArg1
    packet.dwArg2 = p.dwArg2
    packet.header = string.format("%02X",p.header)
    packet.data = _DumpPacketData(p)
    return packet
end

function _DumpPacketData(p,s,e)
    s, e = math.max(1,s or 1), math.min(p.size-1,e and e-1 or p.size-1)
    local pos, data = p.pos, ""
    p.pos = s
    for i=p.pos, e do
        data = data .. string.format("%02X ",p:Decode1())
    end
    p.pos = pos
    return data
end

function info_box_rcv()
	if Config.showrcv==false then return end				
	if Config.decryptrcv==true and Config.showrlt then
		DrawText(tostring("Packet Reader - RecvPackets"),25,100,100,ARGB(255,10,255,20))
		_show_decrypt()
	else		
		DrawText(tostring("Packet Reader - RecvPackets"),25,100,100,ARGB(255,10,255,20))
		_show_encrypt()
	end
end
function _show_encrypt()
	this = 0
	for i=1, 50 do
		this=this+1
		if encr_data.ptime[this]~="" then DrawText(tostring("ptime: "..encr_data.ptime[this]),20,100,(105+(15*this)),ARGB(255,248,255,20)) end
		if encr_data.header[this]~="" then DrawText(tostring("pheader: "..encr_data.header[this]),20,205,(105+(15*this)),ARGB(255,248,255,20)) end
		if encr_data.dwArg1[this]~="" then DrawText(tostring("dwArg1: "..encr_data.dwArg1[this]),20,310,(105+(15*this)),ARGB(255,248,255,20)) end
		if encr_data.dwArg2[this]~="" then DrawText(tostring("dwArg2: "..encr_data.dwArg2[this]),20,395,(105+(15*this)),ARGB(255,248,255,20)) end
		if encr_data.data[this]~="" then DrawText(tostring("data: "..encr_data.data[this]),20,490,(105+(15*this)),ARGB(255,248,255,20)) end		
	end
end

function _show_decrypt()
	this = 0
	for i=1, 50 do
		this=this+1
		if data.header[this]~="" then DrawText(tostring("Header: "..data.header[this]),20,100,(105+(15*this)),ARGB(255,248,255,20)) end
		if data.size[this]~="" then DrawText(tostring("Size: "..data.size[this]),20,205,(105+(15*this)),ARGB(255,248,255,20)) end
		if data.val_one[this]~="" then DrawText(tostring("Value 1: "..data.val_one[this]),20,290,(105+(15*this)),ARGB(255,248,255,20)) end
		if data.val_two[this]~="" then DrawText(tostring("Value 2: "..data.val_two[this]),20,395,(105+(15*this)),ARGB(255,248,255,20)) end
		if data.val_three[this]~="" then DrawText(tostring("Value 3: "..data.val_three[this]),20,520,(105+(15*this)),ARGB(255,248,255,20)) end
		if data.nid[this]~="" then 
		DrawText(tostring("nID: "..data.nid[this]),20,690,(105+(15*this)),ARGB(255,248,255,20)) end
	end	
end

function info_box_snd()
	if Config.showsnd==false then return end		
	if Config.showrlt then
		DrawText(tostring("Packet Reader - SndPackets"),25,100,100,ARGB(255,10,255,20))		
		_show_decr_snd()		
	end
end

function _show_decr_snd()
	this = 0
	for i=1, 50 do
		this=this+1			
		if osp_data.sp1[this]~="" then DrawText(tostring(osp_data.sp1[this]),20,100,(105+(15*this)),ARGB(255,248,255,20)) end
		if osp_data.sp2[this]~="" then DrawText(tostring(osp_data.sp2[this]),20,210,(105+(15*this)),ARGB(255,248,255,20)) end
		if osp_data.sp3[this]~="" then DrawText(tostring(osp_data.sp3[this]),20,340,(105+(15*this)),ARGB(255,248,255,20)) end
		if osp_data.sp4[this]~="" then DrawText(tostring(osp_data.sp4[this]),20,430,(105+(15*this)),ARGB(255,248,255,20)) end
		if osp_data.sp5[this]~="" then DrawText(tostring(osp_data.sp5[this]),20,525,(105+(15*this)),ARGB(255,248,255,20)) end
		if osp_data.sp6[this]~="" then DrawText(tostring(osp_data.sp6[this]),20,620,(105+(15*this)),ARGB(255,248,255,20)) end
		if osp_data.sp7[this]~="" then DrawText(tostring(osp_data.sp7[this]),20,715,(105+(15*this)),ARGB(255,248,255,20)) end
		if osp_data.sp8[this]~="" then DrawText(tostring(osp_data.sp8[this]),20,845,(105+(15*this)),ARGB(255,248,255,20)) end
		if osp_data.sp9[this]~="" then DrawText(tostring(osp_data.sp9[this]),20,960,(105+(15*this)),ARGB(255,248,255,20)) end
		if osp_data.sp10[this]~="" then DrawText(tostring(osp_data.sp10[this]),20,1100,(105+(15*this)),ARGB(255,248,255,20)) end
		if osp_data.sp11[this]~="" then DrawText(tostring(osp_data.sp11[this]),20,1250,(105+(15*this)),ARGB(255,248,255,20)) end
	end
end

function sec2min(secs)
	local myMinutes, mySeconds, myTime = 0,0,0
	if secs > 59 then
		myMinutes = math.floor(secs/60);
		mySeconds = secs-(math.floor(secs/60)*60)		
		if mySeconds < 10 then
			mySeconds = "0"..mySeconds
		end		
		myTime = myMinutes..":"..mySeconds
	else	
		if secs < 10 then
			mySeconds = "0"..secs
		end	
		myTime = "0:"..mySeconds
	end        
	return myTime	
end
