local data = {
header={},
size={},
nid={},
val_one={},
val_two={},
val_three={}
}
local olddata =  {
header={},
size={},
nid={},
val_one={},
val_two={},
val_three={}
}
local this = 1


function OnLoad()
	init_config()
	createarray()
end

function OnDraw()
	info_box()
end





function info_box()
if Config.Status==false then return end
		DrawText(tostring("Packet Reader"),25,100,100,ARGB(255,10,255,20))	
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

function OnRecvPacket(p)
                pheader = p.header
				psize = p.size
				p.pos = 1
                pNetworkID = p:DecodeF()
                unk02 = p:Decode2()
                unk01 = p:Decode1()
                unk03 = p:Decode4() 
                if Config.onlyme then 
					if pNetworkID == myHero.networkID then
						set_info(pheader, psize, 1, pNetworkID, unk01, unk02, unk03) 
					end
				else
					set_info(pheader, psize, 1, pNetworkID, unk01, unk02, unk03) 						
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
		save_data("NetID: "..netid)
		save_data("Value 1: "..val_one)
		save_data("Value 2: "..val_two)
		save_data("Value 3: "..val_three)
		save_data("-------------------------")
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
	end
end

function init_config()
    PrintChat("<font color='#ab15d9'> > Packet Reader by Bilbao loaded.</font>")   
	Config = scriptConfig("Packet Reader", "Info")	
	Config:addParam("Status", "Start/Stop logging", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte("U"))
	Config:permaShow("Status")
	Config:addParam("onlyme", "Show only my Packets", SCRIPT_PARAM_ONOFF, true)
    Config:addParam("LOG", "Log result into file", SCRIPT_PARAM_ONOFF, false)
	Config:permaShow("LOG") 
	Config:addParam("by", "v0.1 by Bilbao", SCRIPT_PARAM_INFO, "")
end

function save_data(text)
	local file = io.open(SCRIPT_PATH.."packets.txt", "a")
	file:write(text)
	file:write("\n")
	file:flush()
	file:close()
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
