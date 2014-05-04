local nextDelay = os.clock()
local zed_clone_status = false
local zed_clone_obj = nil




function OnTick()
	if os.clock() < nextDelay then return end
		if zed_clone_status and zed_clone_obj~=nil then
			PrintChat("Zed Clone is: on")
		else
			PrintChat("Zed Clone is: off")
		end	
	nextDelay = os.clock() + 1
end


function OnCreateObj(object)
	if object~=nil and object.name == "Zed_Clone_idle.troy" then
		zed_clone_status = true
		zed_clone_obj=object
	end
end


function OnDeleteObj(object)
	if object~=nil and object.name == "Zed_Clone_idle.troy" then
		zed_clone_status = false
		zed_clone_obj = nil
	end

end


function OnLoad()
	PrintChat("Bilbao's Zed Clone Scanner loaded.")
end
