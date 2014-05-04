function OnLoad()
	print("Teemo ShroomStuck Updater loaded.")
end

function OnRecvPacket(p)
        if p.header == 0xFE and p.size == 0x1C then
                p.pos = 1
                pNetworkID = p:DecodeF()
                unk01 = p:Decode2()
                unk02 = p:Decode1()
                unk03 = p:Decode4() 
				stack = p:Decode4()
                if pNetworkID == myHero.networkID then
					print("I got a new Shroom. Now i have "..stack.." shrooms")
                end
        end
end
