
DeleteActualVeh = function()
    if DoesEntityExist(cachedData["vehicle"]) then
		DeleteEntity(cachedData["vehicle"])
	end
end

SpawnLocalVehicle = function(data)
    local vehicleProps = data
    if not vehicleProps.model then
        vehicleProps = data[1]
    end
     
	local spawnpoint = Config.Garages[cachedData["currentGarage"]]["positions"]["vehicle"]
    
	WaitForModel(vehicleProps["model"], vehicleProps["plate"])

	if DoesEntityExist(cachedData["vehicle"]) then
		DeleteEntity(cachedData["vehicle"])
	end
	
	if not esx.Game.IsSpawnPointClear(spawnpoint["position"], 3.0) then 
		-- TriggerEvent('notification', 'Please move the vehicle off the road', 1)
        esx.ShowNotification('Please move the vehicle off the road', 'error')

		return
	end
	
	if not IsModelValid(vehicleProps["model"]) then
		return
	end

	esx.Game.SpawnLocalVehicle(vehicleProps["model"], spawnpoint["position"], spawnpoint["heading"], function(yourVehicle)
		cachedData["vehicle"] = yourVehicle

		SetVehicleProperties(yourVehicle, vehicleProps)

		SetModelAsNoLongerNeeded(vehicleProps["model"])
	end)
end

SpawnVehicle = function(data,recuperar)
    local vehicleProps = data[1]
    if recuperar then
        -- TriggerEvent('notification', 'You paid $200 to recover your vehicle!', 1)
        if DoesEntityExist(cachedData["vehicle"]) then
            DeleteEntity(cachedData["vehicle"])
        end
        
        local gameVehicles = esx.Game.GetVehicles()

        for i = 1, #gameVehicles do
            local vehicle = gameVehicles[i]

            if DoesEntityExist(vehicle) then
                if Config.Trim(GetVehicleNumberPlateText(vehicle)) == Config.Trim(vehicleProps["plate"]) then
                    esx.ShowNotification('Your vehicle is already in the city streets', 'error')
                    CloseMenu()
                    return HandleCamera(cachedData["currentGarage"])
                end
            end
        end
        esx.ShowNotification('You paid $200 to recover your vehicle!', 'success')
        TriggerServerEvent('PX_garage:pay')
        TriggerServerEvent('PX_garage:modifystored', data[1], 1, cachedData["currentGarage"])
        CloseMenu()
    else
        
        local spawnpoint = Config.Garages[cachedData["currentGarage"]]["positions"]["vehicle"]

        WaitForModel(vehicleProps["model"], vehicleProps["plate"])

        if DoesEntityExist(cachedData["vehicle"]) then
            DeleteEntity(cachedData["vehicle"])
        end
        
        if not esx.Game.IsSpawnPointClear(spawnpoint["position"], 3.0) then 
            esx.ShowNotification('Please move the vehicle off the road', 'error')

            return
        end
        CloseMenu()
        local gameVehicles = esx.Game.GetVehicles()

        for i = 1, #gameVehicles do
            local vehicle = gameVehicles[i]

            if DoesEntityExist(vehicle) then
                if Config.Trim(GetVehicleNumberPlateText(vehicle)) == Config.Trim(vehicleProps["plate"]) then
                    esx.ShowNotification('Your vehicle is already in the city streets', 'error')

                    return HandleCamera(cachedData["currentGarage"])
                end
            end
        end

        esx.Game.SpawnVehicle(vehicleProps["model"], spawnpoint["position"], spawnpoint["heading"], function(yourVehicle)
            SetVehicleProperties(yourVehicle, vehicleProps)

            

            SetModelAsNoLongerNeeded(vehicleProps["model"])

            TaskWarpPedIntoVehicle(PlayerPedId(), yourVehicle, -1)
            TriggerServerEvent("garage:addKeys", GetVehicleNumberPlateText(yourVehicle), GetDisplayNameFromVehicleModel(GetEntityModel(yourVehicle)))
            SetEntityAsMissionEntity(yourVehicle)

            SetEntityAsMissionEntity(yourVehicle, true, true)
            Citizen.Wait(100)
            TriggerServerEvent('PX_garage:modifystored', vehicleProps, 0, nil)
            HandleCamera(cachedData["currentGarage"])
        end)

    end
    ClearMenu()
end



PutInVehicle = function()
    local vehicle = GetVehiclePedIsUsing(PlayerPedId())

    if DoesEntityExist(vehicle) then
        local vehicleProps = GetVehicleProperties(vehicle)
		esx.TriggerServerCallback("PX_garage:validateVehicle", function(valid)
			if valid then
				AbrirMenuGuardar()
            else
                CloseMenu()
                esx.ShowNotification('This vehicle does not belong to you', 'error')
			end

		end, vehicleProps)
	end
end

function deleteCar( entity )
    NetworkRequestControlOfEntity(entity)
    while not NetworkHasControlOfEntity(entity) do
        NetworkRequestControlOfEntity(entity)
        Wait(0)
    end
    DeleteEntity(entity)
end

SaveInGarage = function(garage)
    ClearMenu()
    local vehicle = GetVehiclePedIsUsing(PlayerPedId())
    local vehicleProps = GetVehicleProperties(vehicle)
    TriggerServerEvent("garage:removeKeys", GetVehicleNumberPlateText(vehicle))
    TaskLeaveVehicle(PlayerPedId(), vehicle, 0)
	
    while IsPedInVehicle(PlayerPedId(), vehicle, true) do
        Citizen.Wait(0)
    end
    Citizen.Wait(300)


    esx.ShowNotification('You saved your vehicle in garage '..garage, 'info')
    Citizen.Wait(500)
    deleteCar(vehicle)
    TriggerServerEvent('PX_garage:modifystored', vehicleProps, 1, garage)
    CloseMenu()
end

SetVehicleProperties = function(vehicle, vehicleProps)
    esx.Game.SetVehicleProperties(vehicle, vehicleProps)

    SetVehicleEngineHealth(vehicle, vehicleProps["engineHealth"] and vehicleProps["engineHealth"] + 0.0 or 1000.0)
    SetVehicleBodyHealth(vehicle, vehicleProps["bodyHealth"] and vehicleProps["bodyHealth"] + 0.0 or 1000.0)
    SetVehicleFuelLevel(vehicle, vehicleProps["fuelLevel"] and vehicleProps["fuelLevel"] + 0.0 or 1000.0)

    if vehicleProps["windows"] then
        for windowId = 1, 13, 1 do
            if vehicleProps["windows"][windowId] == false then
                RemoveVehicleWindow(vehicle, windowId)
            end
        end
    end

    if vehicleProps["tyres"] then
        for tyreId = 1, 7, 1 do
            if vehicleProps["tyres"][tyreId] ~= false then
                SetVehicleTyreBurst(vehicle, tyreId, true, 1000)
            end
        end
    end

    if vehicleProps["doors"] then
        for doorId = 0, 5, 1 do
            if vehicleProps["doors"][doorId] ~= false then
                SetVehicleDoorBroken(vehicle, doorId - 1, true)
            end
        end
    end
end

GetVehicleProperties = function(vehicle)
    if DoesEntityExist(vehicle) then
        local vehicleProps = esx.Game.GetVehicleProperties(vehicle)

        vehicleProps["tyres"] = {}
        vehicleProps["windows"] = {}
        vehicleProps["doors"] = {}

        for id = 1, 7 do
            local tyreId = IsVehicleTyreBurst(vehicle, id, false)
        
            if tyreId then
                vehicleProps["tyres"][#vehicleProps["tyres"] + 1] = tyreId
        
                if tyreId == false then
                    tyreId = IsVehicleTyreBurst(vehicle, id, true)
                    vehicleProps["tyres"][ #vehicleProps["tyres"]] = tyreId
                end
            else
                vehicleProps["tyres"][#vehicleProps["tyres"] + 1] = false
            end
        end

        for id = 1, 13 do
            local windowId = IsVehicleWindowIntact(vehicle, id)

            if windowId ~= nil then
                vehicleProps["windows"][#vehicleProps["windows"] + 1] = windowId
            else
                vehicleProps["windows"][#vehicleProps["windows"] + 1] = true
            end
        end
        
        for id = 0, 5 do
            local doorId = IsVehicleDoorDamaged(vehicle, id)
        
            if doorId then
                vehicleProps["doors"][#vehicleProps["doors"] + 1] = doorId
            else
                vehicleProps["doors"][#vehicleProps["doors"] + 1] = false
            end
        end

        vehicleProps["engineHealth"] = GetVehicleEngineHealth(vehicle)
        vehicleProps["bodyHealth"] = GetVehicleBodyHealth(vehicle)
        vehicleProps["fuelLevel"] = GetVehicleFuelLevel(vehicle)

        return vehicleProps
    end
end

HandleAction = function(action)
    if action == "menu" then
        OpenGarageMenu()
    elseif action == "vehicle" then
        PutInVehicle()
    end
end

HandleCamera = function(garage, toggle)
    if not garage then return; end
    local Camerapos = Config.Garages[garage]["camera"]

    if not Camerapos then return end

	if not toggle then
		if cachedData["cam"] then
			DestroyCam(cachedData["cam"])
		end
		
		if DoesEntityExist(cachedData["vehicle"]) then
			DeleteEntity(cachedData["vehicle"])
		end

		RenderScriptCams(0, 1, 750, 1, 0)

		return
	end

	if cachedData["cam"] then
		DestroyCam(cachedData["cam"])
	end

	cachedData["cam"] = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)

	SetCamCoord(cachedData["cam"], Camerapos["x"], Camerapos["y"], Camerapos["z"])
	SetCamRot(cachedData["cam"], Camerapos["rotationX"], Camerapos["rotationY"], Camerapos["rotationZ"])
	SetCamActive(cachedData["cam"], true)

	RenderScriptCams(1, 1, 750, 1, 1)

	Citizen.Wait(500)
end



DrawScriptMarker = function(markerData)
    DrawMarker(20, markerData["pos"],0,0,0,0,0,0,0.701,1.0001,0.3001,222, 50, 50, 0.05,0, 0,0,0,0,0,0)
end

PlayAnimation = function(ped, dict, anim, settings)
	if dict then
        Citizen.CreateThread(function()
            RequestAnimDict(dict)

            while not HasAnimDictLoaded(dict) do
                Citizen.Wait(100)
            end

            if settings == nil then
                TaskPlayAnim(ped, dict, anim, 1.0, -1.0, 1.0, 0, 0, 0, 0, 0)
            else 
                local speed = 1.0
                local speedMultiplier = -1.0
                local duration = 1.0
                local flag = 0
                local playbackRate = 0

                if settings["speed"] then
                    speed = settings["speed"]
                end

                if settings["speedMultiplier"] then
                    speedMultiplier = settings["speedMultiplier"]
                end

                if settings["duration"] then
                    duration = settings["duration"]
                end

                if settings["flag"] then
                    flag = settings["flag"]
                end

                if settings["playbackRate"] then
                    playbackRate = settings["playbackRate"]
                end

                TaskPlayAnim(ped, dict, anim, speed, speedMultiplier, duration, flag, playbackRate, 0, 0, 0)
            end
      
            RemoveAnimDict(dict)
		end)
	else
		TaskStartScenarioInPlace(ped, anim, 0, true)
	end
end

WaitForModel = function(model, plate)
    local DrawScreenText = function(text, red, green, blue, alpha)
        SetTextFont(4)
        SetTextScale(0.0, 0.5)
        SetTextColour(red, green, blue, alpha)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(1, 0, 0, 0, 255)
        SetTextDropShadow()
        SetTextOutline()
        SetTextCentre(true)
    
        BeginTextCommandDisplayText("STRING")
        AddTextComponentSubstringPlayerName(text)
        EndTextCommandDisplayText(0.5, 0.5)
    end

    if not IsModelValid(model) then
        TriggerServerEvent("PX_garage:RemoveInvalidVehicle", plate)
        return  esx.ShowNotification('This model does not exist in the game, send a report!', 'error')
    end

	if not HasModelLoaded(model) then
		RequestModel(model)
	end
	
	while not HasModelLoaded(model) do
		Citizen.Wait(0)

		DrawScreenText("Looking for you " .. GetDisplayNameFromVehicleModel(model) .. "...", 255, 255, 255, 150)
	end
end