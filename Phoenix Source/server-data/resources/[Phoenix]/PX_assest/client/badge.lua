local prop_name = 'prop_fib_badge'

RegisterNetEvent('PX_badge:badgeanim')
AddEventHandler('PX_badge:badgeanim', function()
	Citizen.CreateThread(function()
		local playerPed = PlayerPedId()
		local x,y,z = table.unpack(GetEntityCoords(playerPed))
		local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
		local boneIndex = GetPedBoneIndex(playerPed, 28422)
		if not IsPedInAnyVehicle(playerPed, false) then
			AttachEntityToEntity(prop, playerPed, boneIndex, 0.065, 0.029, -0.035, 80.0, -1.90, 75.0, true, true, false, true, 1, true)
			RequestAnimDict('paper_1_rcm_alt1-9')
			TaskPlayAnim(playerPed, 'paper_1_rcm_alt1-9', 'player_one_dual-9', 8.0, -8, 10.0, 49, 0, 0, 0, 0)
			Citizen.Wait(3000)
			ClearPedSecondaryTask(playerPed)
			DeleteObject(prop)
		end
	end)
end)

RegisterNetEvent("PX_badge:client:ShowBadge")
AddEventHandler("PX_badge:client:ShowBadge", function(sourceId, character)
    local sourcePos = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(sourceId)), false)
    local pos = GetEntityCoords(PlayerPedId(), false)
    if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, sourcePos.x, sourcePos.y, sourcePos.z, true) < 3.0) then
        TriggerEvent('chat:addMessage', {
            template = '<div style="background-color: rgba(0, 76, 153, 0.8);" class="chat-message advert"><div class="chat-message-body"><strong>{0}:</strong><br> <strong>Job:</strong> {1} <br><strong>firstName:</strong> {2} <br><strong>LastName:</strong> {3}</div></div>',
            args = {'Badge', character.job, character.firstname, character.lastname}
        })
    end
end)

RegisterNetEvent("PX_badge:client:ShowId")
AddEventHandler("PX_badge:client:ShowId", function(sourceId, character)
    local sourcePos = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(sourceId)), false)
    local pos = GetEntityCoords(PlayerPedId(), false)
    if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, sourcePos.x, sourcePos.y, sourcePos.z, true) < 3.0) then
        TriggerEvent('chat:addMessage', {
            template = '<div style="background-color: rgba(0, 76, 153, 0.8);" class="chat-message advert"><div class="chat-message-body"><strong>{0}:</strong><br> <strong>firstName:</strong> {1} <br><strong>LastName:</strong> {2}</div></div>',
            args = {'ID-card', character.firstname, character.lastname}
        })
    end
end)