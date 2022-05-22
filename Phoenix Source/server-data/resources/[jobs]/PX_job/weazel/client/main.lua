local Keys = {
  ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
  ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
  ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
  ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
  ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
  ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
  ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
  ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local PlayerData              = {}
local HasAlreadyEnteredMarker = false
local LastStation             = nil
local LastPart                = nil
local LastPartNum             = nil
local CurrentAction           = nil
local CurrentActionMsg        = ''
local CurrentActionData       = {}
local isDead                  = false
local CurrentTask             = {}
local playerInService         = false

ESX                           = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
	if PlayerData.job and PlayerData.job.name == "weazel" then
        mainThreads()
    end
end)

function SetVehicleMaxMods(vehicle)
	local props = {
		modEngine       = 2,
		modBrakes       = 2,
		modTransmission = 2,
		modSuspension   = 3,
		modTurbo        = true
	}

	ESX.Game.SetVehicleProperties(vehicle, props)
end

function TeleportFadeEffect(entity, coords)
	Citizen.CreateThread(function()
		DoScreenFadeOut(800)

		while not IsScreenFadedOut() do
			Citizen.Wait(0)
		end

		ESX.Game.Teleport(entity, coords, function()
			DoScreenFadeIn(800)
		end)
	end)
end

function cleanPlayer(playerPed)
	SetPedArmour(playerPed, 0)
	ClearPedBloodDamage(playerPed)
	ResetPedVisibleDamage(playerPed)
	ClearPedLastWeaponDamage(playerPed)
	ResetPedMovementClipset(playerPed, 0)
end

function OpenVehicleSpawnerMenu(station, partNum)

	ESX.UI.Menu.CloseAll()

	local elements = {}

	local grade = PlayerData.job.grade
	local job = PlayerData.job.name
	ESX.TriggerServerCallback("esx_society:getVehicles", function(Cars)

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

			local sharedVehicles = WeazelConfig.AuthorizedVehicles.Shared
			for i=1, #sharedVehicles, 1 do
				table.insert(elements, {
					label = sharedVehicles[i].label, 
					model = sharedVehicles[i].model
				})
			end

			local authorizedVehicles = WeazelConfig.AuthorizedVehicles[PlayerData.job.grade_name]
			for i=1, #authorizedVehicles, 1 do
				table.insert(elements, {
					label = authorizedVehicles[i].label, 
					model = authorizedVehicles[i].model
				})
			end

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_spawner',
			{
				title    = _U('vehicle_menu'),
				align    = 'left',
				elements = elements
			}, function(data, menu)
				menu.close()

				local foundSpawnPoint, spawnPoint = GetAvailableVehicleSpawnPoint(station, partNum)

				if foundSpawnPoint then
					if WeazelConfig.MaxInService == -1 then
						ESX.Game.SpawnVehicle(data.current.model, spawnPoint, spawnPoint.heading, function(vehicle)
							TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
							SetVehicleMaxMods(vehicle)
							TriggerServerEvent("garage:addKeys", GetVehicleNumberPlateText(vehicle), GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
						end)
					else

						ESX.TriggerServerCallback('esx_service:isInService', function(isInService)

							if isInService then
								ESX.Game.SpawnVehicle(data.current.model, spawnPoint, spawnPoint.heading, function(vehicle)
									TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
									SetVehicleMaxMods(vehicle)
									TriggerServerEvent("garage:addKeys", GetVehicleNumberPlateText(vehicle), GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
								end)
							else
								ESX.ShowNotification(_U('service_not'), 'error')
							end
						end, 'weazel')
					end
				end

			end, function(data, menu)
				menu.close()

				CurrentAction     = 'menu_vehicle_spawner'
				CurrentActionMsg  = _U('vehicle_spawner')
				CurrentActionData = {station = station, partNum = partNum}
			end)
		end
	end, grade, job)
end

function GetAvailableVehicleSpawnPoint(station, partNum)
	local spawnPoints = WeazelConfig.weazelStations[station].Vehicles[partNum].SpawnPoints
	local found, foundSpawnPoint = false, nil

	for i=1, #spawnPoints, 1 do
		if ESX.Game.IsSpawnPointClear(spawnPoints[i], spawnPoints[i].radius) then
			found, foundSpawnPoint = true, spawnPoints[i]
			break
		end
	end

	if found then
		return true, foundSpawnPoint
	else
		ESX.ShowNotification(_U('vehicle_blocked'), 'error')
		return false
	end
end

function OpenweazelActionsMenu()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'weazel_actions', {
		title    = _U('weazel_actions'),
		align    = 'left',
		elements = {
			{label = "Camera", value = 'cam'},
			{label = "Mic 1", value = 'bmic'},
			{label = "Mic 2", value = 'mic'}
		}
	}, function(data, menu)
		if data.current.value == 'cam' then
			ExecuteCommand("cam")
		elseif data.current.value == 'bmic' then
			ExecuteCommand("bmic")
		elseif data.current.value == 'mic' then
			ExecuteCommand("mic")
		end
	end, function(data, menu)
		menu.close()
	end)
end

function OpenElevator(station, partNum)

	local elements = {
		{ label = _U('elevator_top'), value = 'elevator_top' },
		{ label = _U('elevator_down'), value = 'elevator_down' },
		{ label = _U('elevator_parking'), value = 'elevator_parking' }
	}

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'elevator', {
		title    = _U('elevator'),
		align    = 'left',
		elements = elements
	}, function(data, menu)

		if data.current.value == 'elevator_top' then
			TeleportFadeEffect(PlayerPedId(), WeazelConfig.weazelStations[station].Elevator[partNum].Top)
		end

		if data.current.value == 'elevator_down' then
			TeleportFadeEffect(PlayerPedId(), WeazelConfig.weazelStations[station].Elevator[partNum].Down)
		end

		if data.current.value == 'elevator_parking' then
			TeleportFadeEffect(PlayerPedId(), WeazelConfig.weazelStations[station].Elevator[partNum].Parking)
		end
		menu.close()

	end, function(data, menu)
		menu.close()
		
		CurrentAction     = 'menu_elevator'
		CurrentActionMsg  = _U('open_elevator')
		CurrentActionData = {}
	end)
end

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	local lastjob = PlayerData.job.name
    PlayerData.job = job

    if (PlayerData.job.name == "weazel") and lastjob ~= PlayerData.job.name then
        mainThreads()
    end
end)


AddEventHandler('esx_weazel_job:hasEnteredMarker', function(station, part, partNum)

	if part == 'VehicleSpawner' then

		CurrentAction     = 'menu_vehicle_spawner'
		CurrentActionMsg  = _U('vehicle_spawner')
		CurrentActionData = {station = station, partNum = partNum}

	elseif part == 'VehicleDeleter' then

		local playerPed = PlayerPedId()
		local coords    = GetEntityCoords(playerPed)

		if IsPedInAnyVehicle(playerPed,  false) then

			local vehicle = GetVehiclePedIsIn(playerPed, false)

			if DoesEntityExist(vehicle) then
				CurrentAction     = 'delete_vehicle'
				CurrentActionMsg  = _U('store_vehicle')
				CurrentActionData = {vehicle = vehicle}
			end

		end

	elseif part == 'BossActions' then

		CurrentAction     = 'menu_boss_actions'
		CurrentActionMsg  = _U('open_bossmenu')
		CurrentActionData = {}

	elseif part == 'Elevator' then

		CurrentAction     = 'menu_elevator'
		CurrentActionMsg  = _U('open_elevator')
		CurrentActionData = {station = station, partNum = partNum}

	end

end)

AddEventHandler('esx_weazel_job:hasExitedMarker', function(station, part, partNum)
	ESX.UI.Menu.CloseAll()
	CurrentAction = nil
end)

AddEventHandler('esx_weazel_job:hasEnteredEntityZone', function(entity)
	local playerPed = PlayerPedId()

	if PlayerData.job ~= nil and PlayerData.job.name == 'weazel' and IsPedOnFoot(playerPed) then
		CurrentAction     = 'remove_entity'
		CurrentActionMsg  = _U('remove_prop')
		CurrentActionData = {entity = entity}
	end

	if GetEntityModel(entity) == GetHashKey('p_ld_stinger_s') then
		local playerPed = PlayerPedId()
		local coords    = GetEntityCoords(playerPed)

		if IsPedInAnyVehicle(playerPed, false) then
			local vehicle = GetVehiclePedIsIn(playerPed)

			for i=0, 7, 1 do
				SetVehicleTyreBurst(vehicle, i, true, 1000)
			end
		end
	end
end)

AddEventHandler('esx_weazel_job:hasExitedEntityZone', function(entity)
	if CurrentAction == 'remove_entity' then
		CurrentAction = nil
	end
end)

-- Create blips
Citizen.CreateThread(function()

	for k,v in pairs(WeazelConfig.weazelStations) do
		local blip = AddBlipForCoord(v.Blip.Pos.x, v.Blip.Pos.y, v.Blip.Pos.z)

		SetBlipSprite (blip, v.Blip.Sprite)
		SetBlipDisplay(blip, v.Blip.Display)
		SetBlipScale  (blip, 0.8)
		SetBlipColour (blip, v.Blip.Colour)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("News")
		EndTextCommandSetBlipName(blip)
	end

end)


function mainThreads()
	-- Display markers
	Citizen.CreateThread(function()
		while PlayerData.job and PlayerData.job.name == 'weazel' do

			Citizen.Wait(1)

			if PlayerData.job ~= nil and PlayerData.job.name == 'weazel' then

				local playerPed = PlayerPedId()
				local coords    = GetEntityCoords(playerPed)

				for k,v in pairs(WeazelConfig.weazelStations) do

					for i=1, #v.Armories, 1 do
						if GetDistanceBetweenCoords(coords, v.Armories[i].x, v.Armories[i].y, v.Armories[i].z, true) < WeazelConfig.DrawDistance then
							DrawMarker(20, v.Armories[i].x, v.Armories[i].y, v.Armories[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.5, 0.5, 0.3, WeazelConfig.MarkerColor.r, WeazelConfig.MarkerColor.g, WeazelConfig.MarkerColor.b, 500, true, true, 2, false, false, false, false)
						end
					end

					for i=1, #v.Vehicles, 1 do
						if GetDistanceBetweenCoords(coords, v.Vehicles[i].Spawner.x, v.Vehicles[i].Spawner.y, v.Vehicles[i].Spawner.z, true) < WeazelConfig.DrawDistance then
							DrawMarker(36, v.Vehicles[i].Spawner.x, v.Vehicles[i].Spawner.y, v.Vehicles[i].Spawner.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 0, 255, 0, 500, true, true, 2, false, false, false, false)
						end
					end

					for i=1, #v.VehicleDeleters, 1 do
						if GetDistanceBetweenCoords(coords, v.VehicleDeleters[i].x, v.VehicleDeleters[i].y, v.VehicleDeleters[i].z, true) < WeazelConfig.DrawDistance then
							DrawMarker(24, v.VehicleDeleters[i].x, v.VehicleDeleters[i].y, v.VehicleDeleters[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.5, 255, 0, 0, 500, true, true, 2, false, false, false, false)
						end
					end

					if WeazelConfig.EnablePlayerManagement and PlayerData.job.grade_name == 'boss' then
						for i=1, #v.BossActions, 1 do
							if not v.BossActions[i].disabled and GetDistanceBetweenCoords(coords, v.BossActions[i].x, v.BossActions[i].y, v.BossActions[i].z, true) < WeazelConfig.DrawDistance then
								DrawMarker(20, v.BossActions[i].x, v.BossActions[i].y, v.BossActions[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.5, 0.5, 0.3, WeazelConfig.MarkerColor.r, WeazelConfig.MarkerColor.g, WeazelConfig.MarkerColor.b, 500, true, true, 2, false, false, false, false)
							end
						end
					end

					for i=1, #v.Elevator, 1 do
						if GetDistanceBetweenCoords(coords, v.Elevator[i].Top.x, v.Elevator[i].Top.y, v.Elevator[i].Top.z, true) < WeazelConfig.DrawDistance then
							DrawMarker(WeazelConfig.MarkerType, v.Elevator[i].Top.x, v.Elevator[i].Top.y, v.Elevator[i].Top.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, WeazelConfig.MarkerSize.x, WeazelConfig.MarkerSize.y, WeazelConfig.MarkerSize.z, WeazelConfig.MarkerColor.r, WeazelConfig.MarkerColor.g, WeazelConfig.MarkerColor.b, 500, true, true, 2, false, false, false, false)
						end

						if GetDistanceBetweenCoords(coords, v.Elevator[i].Down.x, v.Elevator[i].Down.y, v.Elevator[i].Down.z, true) < WeazelConfig.DrawDistance then
							DrawMarker(WeazelConfig.MarkerType, v.Elevator[i].Down.x, v.Elevator[i].Down.y, v.Elevator[i].Down.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, WeazelConfig.MarkerSize.x, WeazelConfig.MarkerSize.y, WeazelConfig.MarkerSize.z, WeazelConfig.MarkerColor.r, WeazelConfig.MarkerColor.g, WeazelConfig.MarkerColor.b, 500, true, true, 2, false, false, false, false)
						end

						if GetDistanceBetweenCoords(coords, v.Elevator[i].Parking.x, v.Elevator[i].Parking.y, v.Elevator[i].Parking.z, true) < WeazelConfig.DrawDistance then
							DrawMarker(WeazelConfig.MarkerType, v.Elevator[i].Parking.x, v.Elevator[i].Parking.y, v.Elevator[i].Parking.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, WeazelConfig.MarkerSize.x, WeazelConfig.MarkerSize.y, WeazelConfig.MarkerSize.z, WeazelConfig.MarkerColor.r, WeazelConfig.MarkerColor.g, WeazelConfig.MarkerColor.b, 500, true, true, 2, false, false, false, false)
						end
					end

				end

			else
				Citizen.Wait(500)
			end

		end
	end)

	-- Enter / Exit marker events
	Citizen.CreateThread(function()

		while PlayerData.job and PlayerData.job.name == 'weazel' do

			Citizen.Wait(10)

			if PlayerData.job ~= nil and PlayerData.job.name == 'weazel' then

				local playerPed      = PlayerPedId()
				local coords         = GetEntityCoords(playerPed)
				local isInMarker     = false
				local currentStation = nil
				local currentPart    = nil
				local currentPartNum = nil

				for k,v in pairs(WeazelConfig.weazelStations) do

					for i=1, #v.Vehicles, 1 do
						if GetDistanceBetweenCoords(coords, v.Vehicles[i].Spawner.x, v.Vehicles[i].Spawner.y, v.Vehicles[i].Spawner.z, true) < WeazelConfig.MarkerSize.x then
							isInMarker     = true
							currentStation = k
							currentPart    = 'VehicleSpawner'
							currentPartNum = i
						end
					end

					for i=1, #v.VehicleDeleters, 1 do
						if GetDistanceBetweenCoords(coords, v.VehicleDeleters[i].x, v.VehicleDeleters[i].y, v.VehicleDeleters[i].z, true) < WeazelConfig.MarkerSize.x then
							isInMarker     = true
							currentStation = k
							currentPart    = 'VehicleDeleter'
							currentPartNum = i
						end
					end

					if WeazelConfig.EnablePlayerManagement and PlayerData.job.grade_name == 'boss' then
						for i=1, #v.BossActions, 1 do
							if GetDistanceBetweenCoords(coords, v.BossActions[i].x, v.BossActions[i].y, v.BossActions[i].z, true) < WeazelConfig.MarkerSize.x then
								isInMarker     = true
								currentStation = k
								currentPart    = 'BossActions'
								currentPartNum = i
							end
						end
					end

					for i=1, #v.Elevator, 1 do
						if GetDistanceBetweenCoords(coords, v.Elevator[i].Top.x, v.Elevator[i].Top.y, v.Elevator[i].Top.z, true) < WeazelConfig.MarkerSize.x then
							isInMarker     = true
							currentStation = k
							currentPart    = 'Elevator'
							currentPartNum = i
						end

						if GetDistanceBetweenCoords(coords, v.Elevator[i].Down.x, v.Elevator[i].Down.y, v.Elevator[i].Down.z, true) < WeazelConfig.MarkerSize.x then
							isInMarker     = true
							currentStation = k
							currentPart    = 'Elevator'
							currentPartNum = i
						end

						if GetDistanceBetweenCoords(coords, v.Elevator[i].Parking.x, v.Elevator[i].Parking.y, v.Elevator[i].Parking.z, true) < WeazelConfig.MarkerSize.x then
							isInMarker     = true
							currentStation = k
							currentPart    = 'Elevator'
							currentPartNum = i
						end
					end

				end

				local hasExited = false

				if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and (LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum)) then

					if
						(LastStation ~= nil and LastPart ~= nil and LastPartNum ~= nil) and
						(LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum)
					then
						TriggerEvent('esx_weazel_job:hasExitedMarker', LastStation, LastPart, LastPartNum)
						hasExited = true
					end

					HasAlreadyEnteredMarker = true
					LastStation             = currentStation
					LastPart                = currentPart
					LastPartNum             = currentPartNum

					TriggerEvent('esx_weazel_job:hasEnteredMarker', currentStation, currentPart, currentPartNum)
				end

				if not hasExited and not isInMarker and HasAlreadyEnteredMarker then
					HasAlreadyEnteredMarker = false
					TriggerEvent('esx_weazel_job:hasExitedMarker', LastStation, LastPart, LastPartNum)
				end

			else
				Citizen.Wait(500)
			end

		end
	end)

	-- Key Controls
	Citizen.CreateThread(function()
		while PlayerData.job and PlayerData.job.name == 'weazel' do

			Citizen.Wait(10)

			if CurrentAction ~= nil then
				ESX.ShowHelpNotification(CurrentActionMsg)

				if IsControlJustReleased(0, Keys['E']) and PlayerData.job ~= nil and PlayerData.job.name == 'weazel' then

					if CurrentAction == 'menu_vehicle_spawner' then
						OpenVehicleSpawnerMenu(CurrentActionData.station, CurrentActionData.partNum)

					elseif CurrentAction == 'delete_vehicle' then
						if WeazelConfig.EnableSocietyOwnedVehicles then
							local vehicleProps = ESX.Game.GetVehicleProperties(CurrentActionData.vehicle)
							TriggerServerEvent('esx_society:putVehicleInGarage', 'weazel', vehicleProps)
						end
						ESX.Game.DeleteVehicle(CurrentActionData.vehicle)

					elseif CurrentAction == 'menu_boss_actions' then
						ESX.UI.Menu.CloseAll()
						TriggerEvent('esx_society:openBossMenu', 'weazel', function(data, menu)
							menu.close()
							CurrentAction     = 'menu_boss_actions'
							CurrentActionMsg  = _U('open_bossmenu')
							CurrentActionData = {}
						end, { wash = false }) -- disable washing money

					elseif CurrentAction == 'remove_entity' then
						DeleteEntity(CurrentActionData.entity)

					elseif CurrentAction == 'menu_elevator' then
						OpenElevator(CurrentActionData.station, CurrentActionData.partNum)
					end
					
					CurrentAction = nil
				end
			end -- CurrentAction end
			
			if IsControlJustReleased(0, Keys['F6']) and not isDead and PlayerData.job ~= nil and PlayerData.job.name == 'weazel' and not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'weazel_actions') then
				if WeazelConfig.MaxInService == -1 then
					OpenweazelActionsMenu()
				elseif playerInService then
					OpenweazelActionsMenu()
				else
					ESX.ShowNotification(_U('service_not'), 'error')
				end
			end
			
			if IsControlJustReleased(0, Keys['E']) and CurrentTask.Busy then
				ESX.ShowNotification(_U('impound_canceled'), 'error')
				ESX.ClearTimeout(CurrentTask.Task)
				ClearPedTasks(PlayerPedId())
				
				CurrentTask.Busy = false
			end
		end
	end)
end

AddEventHandler('esx:onPlayerDeath', function(data)
	isDead = true
end)

Citizen.CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/tabligh', 'Tabligh', {
        { name="Message", help="Matn Payam Shoma" }
    })
	TriggerEvent('chat:addSuggestion', '/ads', 'Didan Tabligh ha', {
    })
	TriggerEvent('chat:addSuggestion', '/ad', 'Action Haye Tablighat', {
        { name="id", help="Id tabligh ra vared konid" },
		{ name="action", help="view/accept/decline" }
    })
end)