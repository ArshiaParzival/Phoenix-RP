local HasAlreadyEnteredMarker, IsDead, CurrentActionData = false, false, {}
local LastZone, CurrentAction, CurrentActionMsg

ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()
	if ESX.PlayerData.job and ESX.PlayerData.job.name == "taxi" then
        mainThreads()
    end
end)

function SetVehicleMaxMods(vehicle)
	local props = {
		modEngine       = 10,
		modBrakes       = 10,
		color1       	= 126,
		windowTint		= 1,
		color2       	= 73,
		modTransmission = 10,
		modSuspension   = 10,
		modArmor        = 10,
		modTurbo        = true,
	}
	ESX.Game.SetVehicleProperties(vehicle, props)
	SetVehicleDirtLevel(vehicle, 0.0)
end

function OpenVehicleSpawnerMenu()
	ESX.UI.Menu.CloseAll()
	local grade = ESX.PlayerData.job.grade
	local job = ESX.PlayerData.job.name
	local elements = {}
	ESX.TriggerServerCallback('esx_society:getVehicles', function(Cars)
		if Cars ~= nil then
			for i=1, #Cars, 1 do
				if Cars[i].status == true then
					table.insert(elements, {
						label = Cars[i].model,
						model = Cars[i].model
					})
				end
			end
			if #elements == 0 then
				ESX.ShowNotification("~y~Shoma Be Hich Mashini Dastresi Nadarid", 'error')
				return
			end
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_spawner',
			{
				title		= _U('spawn_veh'),
				align		= 'left',
				elements	= elements
			}, function(data, menu)
				if not ESX.Game.IsSpawnPointClear(TaxiConfig.Zones.VehicleSpawnPoint.Pos, 5.0) then
					ESX.ShowNotification(_U('spawnpoint_blocked'), 'error')
					return
				end

				menu.close()
				ESX.Game.SpawnVehicle(data.current.model, TaxiConfig.Zones.VehicleSpawnPoint.Pos, TaxiConfig.Zones.VehicleSpawnPoint.Heading, function(vehicle)
					local playerPed = PlayerPedId()
					TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
					SetVehicleMaxMods(vehicle)
					local netId = NetworkGetNetworkIdFromEntity(vehicle)
					TriggerEvent('esx_vehiclecontol:changePointed', netId)
					local upperCase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
					local lowerCase = "abcdefghijklmnopqrstuvwxyz"
					local numbers = "0123456789"

					local characterSet = upperCase .. lowerCase .. numbers 

					local keyLength = 5
					local output = ""

					for	i = 1, keyLength do
						local rand = math.random(#characterSet)
						output = output .. string.sub(characterSet, rand, rand)
					end

					SetVehicleNumberPlateText(vehicle, "TX " .. output)
					Citizen.CreateThread(function()
						Citizen.Wait(2000)
						SetVehicleFuelLevel(vehicle, 100.0)
					end)
					TriggerServerEvent("garage:addKeys", GetVehicleNumberPlateText(vehicle), GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
				end)
			end, function(data, menu)

				CurrentAction     = 'vehicle_spawner'

				CurrentActionMsg  = _U('spawner_prompt')

				CurrentActionData = {}

				menu.close()
			end)
		end
	end, grade, job)
end


function DeleteJobVehicle()

	if TaxiConfig.EnableSocietyOwnedVehicles then
		local vehicleProps = ESX.Game.GetVehicleProperties(CurrentActionData.vehicle)
		TriggerServerEvent('esx_society:putVehicleirpixelInGarage', 'taxi', vehicleProps)
		ESX.Game.DeleteVehicle(CurrentActionData.vehicle)
	else
		ESX.Game.DeleteVehicle(CurrentActionData.vehicle)

		if TaxiConfig.MaxInService ~= -1 then
			TriggerServerEvent('esx_service:disableService', 'taxi')
		end
	end
end

function OpenTaxiActionsMenu()
	local elements = {}

	if TaxiConfig.EnablePlayerManagement and ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == 'boss' then
		table.insert(elements, {label = _U('boss_actions'), value = 'boss_actions'})
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'taxi_actions', {
		title    = 'Taxi',
		align    = 'right',
		elements = elements
	}, function(data, menu)


		if data.current.value == 'boss_actions' then
			TriggerEvent('esx_society:openBossMenu', 'taxi', function(data, menu)
				menu.close()
			end)
		end

	end, function(data, menu)
		menu.close()

		CurrentAction     = 'taxi_actions_menu'
		CurrentActionMsg  = _U('press_to_open')
		CurrentActionData = {}
	end)
end

function OpenMobileTaxiActionsMenu()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mobile_taxi_actions', {
		title    = 'Taxi',
		align    = 'right',
		elements = {
			{label = ('Dastmal Keshidan'),   value = 'clean_vehicle'},
			{label = ('Set Gheimat meter'),   value = 'min'},
			{label = ('Reset Kardan Meter'),   value = 'reset'}
	}}, function(data, menu)
		if data.current.value == 'min' then
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'price', {
				title = "Set Price of Meter"
			}, function(data, menu)
				local amount = tonumber(data.value)
				menu.close()
				if amount == nil then
					ESX.ShowNotification(_U('amount_invalid'), 'error')
				else
					ExecuteCommand("setnumbertaximin "..amount)
				end
			end, function(data, menu)
				menu.close()
			end)
		elseif data.current.value == 'reset' then
			ExecuteCommand("setnumbertaxireset")
		elseif data.current.value == 'clean_vehicle' then

			local playerPed = GetPlayerPed(-1)
			local vehicle   = ESX.Game.GetVehicleInDirection()
			local coords    = GetEntityCoords(playerPed)
	
			if IsPedSittingInAnyVehicle(playerPed) then
				ESX.ShowNotification(_U('inside_vehicle'), 'error')
				return
			end
	
			if DoesEntityExist(vehicle) then
				IsBusy = true
				TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_MAID_CLEAN", 0, true)
				Citizen.CreateThread(function()
					Citizen.Wait(10000)
	
					SetVehicleDirtLevel(vehicle, 0)
					ClearPedTasksImmediately(playerPed)
	
					ESX.ShowNotification(_U('vehicle_cleaned'), 'info')
					IsBusy = false
				end)
			else
				ESX.ShowNotification(_U('no_vehicle_nearby'), 'error')
			end
		end
	end, function(data, menu)
		menu.close()
	end)
end


RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	local lastjob = ESX.PlayerData.job.name
    ESX.PlayerData.job = job

    if (ESX.PlayerData.job.name == "taxi") and lastjob ~= ESX.PlayerData.job.name then
        mainThreads()
    end
end)

AddEventHandler('esx_taxijob:hasEnteredMarker', function(zone)
	if zone == 'VehicleSpawner' then
		CurrentAction     = 'vehicle_spawner'
		CurrentActionMsg  = _U('spawner_prompt')
		CurrentActionData = {}
	elseif zone == 'VehicleDeleter' then
		local playerPed = PlayerPedId()
		local vehicle   = GetVehiclePedIsIn(playerPed, false)

		if IsPedInAnyVehicle(playerPed, false) and GetPedInVehicleSeat(vehicle, -1) == playerPed then
			CurrentAction     = 'delete_vehicle'
			CurrentActionMsg  = _U('store_veh')
			CurrentActionData = { vehicle = vehicle }
		end
	elseif zone == 'TaxiActions' then
		CurrentAction     = 'taxi_actions_menu'
		CurrentActionMsg  = _U('press_to_open')
		CurrentActionData = {}
	end
end)

AddEventHandler('esx_taxijob:hasExitedMarker', function(zone)
	ESX.UI.Menu.CloseAll()
	CurrentAction = nil
end)

Citizen.CreateThread(function()
	local blip = AddBlipForCoord(TaxiConfig.Zones.TaxiActions.Pos.x, TaxiConfig.Zones.TaxiActions.Pos.y, TaxiConfig.Zones.TaxiActions.Pos.z)

	SetBlipSprite (blip, 637)
	SetBlipDisplay(blip, 4)
	SetBlipScale  (blip, 0.9)
	SetBlipColour (blip, 5)
	SetBlipAsShortRange(blip, true)

	BeginTextCommandSetBlipName('STRING')
	AddTextComponentSubstringPlayerName(_U('blip_taxi'))
	EndTextCommandSetBlipName(blip)
end)


function mainThreads()
	Citizen.CreateThread(function()
		while ESX.PlayerData.job and ESX.PlayerData.job.name == 'taxi' do
			Citizen.Wait(0)

			if ESX.PlayerData.job and ESX.PlayerData.job.name == 'taxi' then
				local coords = GetEntityCoords(PlayerPedId())
				local isInMarker, letSleep, currentZone = false, true

				for k,v in pairs(TaxiConfig.Zones) do
					local distance = GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true)

					if v.Type ~= -1 and distance < TaxiConfig.DrawDistance then
						letSleep = false
						DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, false, 2, v.Rotate, nil, nil, false)
					end

					if distance < 2.0 then
						isInMarker, currentZone = true, k
					end
				end

				if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
					HasAlreadyEnteredMarker, LastZone = true, currentZone
					TriggerEvent('esx_taxijob:hasEnteredMarker', currentZone)
				end

				if not isInMarker and HasAlreadyEnteredMarker then
					HasAlreadyEnteredMarker = false
					TriggerEvent('esx_taxijob:hasExitedMarker', LastZone)
				end

				if letSleep then
					Citizen.Wait(500)
				end
			else
				Citizen.Wait(1000)
			end
		end
	end)

	Citizen.CreateThread(function()
		while ESX.PlayerData.job and ESX.PlayerData.job.name == 'taxi' do
			Citizen.Wait(0)

			if CurrentAction and not IsDead then
				ESX.ShowHelpNotification(CurrentActionMsg)

				if IsControlJustReleased(0, 38) and ESX.PlayerData.job and ESX.PlayerData.job.name == 'taxi' then
					if CurrentAction == 'taxi_actions_menu' then
						if ESX.PlayerData.job.grade_name == 'boss' then
							OpenTaxiActionsMenu()
						end
					elseif CurrentAction == 'vehicle_spawner' then
						OpenVehicleSpawnerMenu()
					elseif CurrentAction == 'delete_vehicle' then
						DeleteJobVehicle()
					end

					CurrentAction = nil
				end
			end

			if IsControlJustReleased(0, 167) and IsInputDisabled(0) and TaxiConfig.EnablePlayerManagement and ESX.PlayerData.job and ESX.PlayerData.job.name == 'taxi' then
				OpenMobileTaxiActionsMenu()
			end
		end
	end)
end