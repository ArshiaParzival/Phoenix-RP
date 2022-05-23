function GetModel()
    local body_model = "male"
    local model_ped = GetEntityModel(PlayerPedId())
    if model_ped == GetHashKey("mp_f_freemode_01") then
        body_model = "female"
    end
    return body_model
end

function GetPlayers()
	local Players = {}
	for Index = 0, 255 do
		if NetworkIsPlayerActive(Index) then
			table.insert(Players, Index)
		end
	end
    return Players
end

function GetClosestPlayer()
    local Players = GetPlayers()
    local closestdist = -1
    local closestplayer = -1
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped, false)
    
    for Index = 1, #Players do
    	local targetped = GetPlayerPed(Players[Index])
    	if ped ~= targetped then
    		local targetpos = GetEntityCoords(targetped, false)
    		local dist = #(pos - targetpos)

    		if closestdist == -1 or closestdist > dist then
    			closestplayer = Players[Index]
    			closestdist = dist
    		end
    	end
    end
    
    return closestplayer, closestdist
end