
local standardVolumeOutput = 1.0;

RegisterNetEvent('InteractSound_CL:PlayOnOne')
AddEventHandler('InteractSound_CL:PlayOnOne', function(soundFile, soundVolume)
    SendNUIMessage({
        transactionType     = 'playSound',
        transactionFile     = soundFile,
        transactionVolume   = soundVolume
    })
end)

RegisterNetEvent('InteractSound_CL:PlayOnAll')
AddEventHandler('InteractSound_CL:PlayOnAll', function(soundFile, soundVolume)
    SendNUIMessage({
        transactionType     = 'playSound',
        transactionFile     = soundFile,
        transactionVolume   = soundVolume
    })
end)

RegisterNetEvent('InteractSound_CL:PlayWithinDistance')
AddEventHandler('InteractSound_CL:PlayWithinDistance', function(playerNetId, maxDistance, soundFile, soundVolume, targetped_network, crd)
    local senderplayerPed = NetworkDoesEntityExistWithNetworkId(targetped_network) and NetworkGetEntityFromNetworkId(targetped_network) or nil
    if senderplayerPed and DoesEntityExist(senderplayerPed) then
		local lCoords = GetEntityCoords(GetPlayerPed(-1))
		local eCoords = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(playerNetId)))
		local distIs  = Vdist(lCoords.x, lCoords.y, lCoords.z, eCoords.x, eCoords.y, eCoords.z)
		if(distIs <= maxDistance) then
			SendNUIMessage({
				transactionType     = 'playSound',
				transactionFile     = soundFile,
				transactionVolume   = soundVolume
			})
		end
	elseif crd then
		local lCoords = GetEntityCoords(GetPlayerPed(-1))
		local eCoords = crd
		local distIs  = Vdist(lCoords.x, lCoords.y, lCoords.z, eCoords.x, eCoords.y, eCoords.z)
		if(distIs <= maxDistance) then
			SendNUIMessage({
				transactionType     = 'playSound',
				transactionFile     = soundFile,
				transactionVolume   = soundVolume
			})
		end
    end
end)
