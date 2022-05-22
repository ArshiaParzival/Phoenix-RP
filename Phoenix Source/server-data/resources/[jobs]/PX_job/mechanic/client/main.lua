local HasAlreadyEnteredMarker, LastZone = false, nil
local CurrentAction, CurrentActionMsg, CurrentActionData = nil, '', {}
local CurrentlyTowedVehicle = nil
local isDead, isBusy = false, false

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
end)

function GetClosestVehicleTire(vehicle)
	local tireBones = {"wheel_lf", "wheel_rf", "wheel_lm1", "wheel_rm1", "wheel_lm2", "wheel_rm2", "wheel_lm3", "wheel_rm3", "wheel_lr", "wheel_rr"}
	local tireIndex = {["wheel_lf"] = 0, ["wheel_rf"] = 1, ["wheel_lm1"] = 2, ["wheel_rm1"] = 3, ["wheel_lm2"] = 45,["wheel_rm2"] = 47, ["wheel_lm3"] = 46, ["wheel_rm3"] = 48, ["wheel_lr"] = 4, ["wheel_rr"] = 5,}
	local player = PlayerId()
	local plyPed = GetPlayerPed(player)
	local plyPos = GetEntityCoords(plyPed, false)
	local minDistance = 1.0
	local closestTire = nil

	for a = 1, #tireBones do
		local bonePos = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, tireBones[a]))
		local distance = Vdist(plyPos.x, plyPos.y, plyPos.z, bonePos.x, bonePos.y, bonePos.z)

		if closestTire == nil then
			if distance <= minDistance then
				closestTire = {bone = tireBones[a], boneDist = distance, bonePos = bonePos, tireIndex = tireIndex[tireBones[a]]}
			end
		else
			if distance < closestTire.boneDist then
				closestTire = {bone = tireBones[a], boneDist = distance, bonePos = bonePos, tireIndex = tireIndex[tireBones[a]]}
			end
		end
	end

	return closestTire
end

function OpenmechanicActionsMenu()
	local elements = {
		{label = "Stash", value = 'stash'},
		{label = "Craft", value = 'craft'}
	}

	if ESX.PlayerData.job and ESX.PlayerData.job.grade_name == 'boss' then
		table.insert(elements, {label = _U('boss_actions'), value = 'boss_actions'})
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mechanic_actions', {
		title    = _U('mechanic'),
		align    = 'right',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'craft' then
			TriggerEvent("PX_crafting:open")
		elseif data.current.value == 'stash' then
			Other = {maxweight = 5000000, slots = 100}
            TriggerEvent("PX_inventory:client:SetCurrentStash", ESX.PlayerData.job.name)
            TriggerServerEvent("PX_inventory:server:OpenInventory", "stash", ESX.PlayerData.job.name, Other)
		elseif data.current.value == 'boss_actions' then
			TriggerEvent('esx_society:openBossMenu', ESX.PlayerData.job.name, function(data, menu)
				menu.close()	
			end)
		end
		CurrentAction     = nil
		CurrentActionMsg  = ""
		CurrentActionData = {}
	end, function(data, menu)
		menu.close()
		CurrentAction     = nil
		CurrentActionMsg  = ""
		CurrentActionData = {}
	end)
end

function OpenMobilemechanicActionsMenu()
	ESX.UI.Menu.CloseAll()
	elements = {
		{label = _U('hijack'),        value = 'hijack_vehicle'},
		{label = 'Repair Body',       value = 'body'},
		{label = _U('clean'),         value = 'clean_vehicle'},
		{label = _U('flat_bed'),      value = 'dep_vehicle'},
		{label = 'Flip Vehicle', value = 'flip'},
		{label = "Object Menu",	value = 'object'}
	}
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mobile_mechanic_actions', {
		title    = _U('mechanic'),
		align    = 'top-left',
		elements = elements
		}, function(data, menu)
		if isBusy then return end
		if data.current.value == 'body' then
			RepairVehicleBody()
		elseif data.current.value == 'object' then
			TriggerEvent("Parzival_Object:openMenu")
		elseif data.current.value == 'flip' then
			local ped = PlayerPedId()
			local coords = GetEntityCoords(ped)
			local vehicle = nil
			if IsPedInAnyVehicle(ped, false) then vehicle = GetVehiclePedIsIn(ped, false) else vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71) end
			if DoesEntityExist(vehicle) then
				loadanimdict("random@mugging4")
				TaskPlayAnim(PlayerPedId(), "random@mugging4" , "struggle_loop_b_thief" ,8.0, -8.0, -1, 1, 0, false, false, false )
				TriggerEvent("mythic_progbar:client:progress", {
					name = "flip",
					duration = 20000,
					label = "Dar Hal Saf Kardan Mashin...",
					useWhileDead = false,
					canCancel = true,
					controlDisables = {
						disableMovement = true,
						disableCarMovement = true,
						disableMouse = false,
						disableCombat = true,
					}
				}, function(status)
					ClearPedTasks(PlayerPedId())
					if not status then
						local playerped = PlayerPedId()
						local coordA = GetEntityCoords(playerped, 1)
						local coordB = GetOffsetFromEntityInWorldCoords(playerped, 0.0, 100.0, 0.0)
						local targetVehicle = getVehicleInDirection(coordA, coordB)
						SetVehicleOnGroundProperly(targetVehicle)
					end
				end)
			else
				ESX.ShowNotification('There is no vehicle near by!', 'error')
			end
		elseif data.current.value == 'hijack_vehicle' then

			local playerPed = GetPlayerPed(-1)
			local vehicle   = ESX.Game.GetVehicleInDirection()
			local coords    = GetEntityCoords(playerPed)
	
			if IsPedSittingInAnyVehicle(playerPed) then
				ESX.ShowNotification(_U('inside_vehicle'), 'error')
				return
			end
	
			if DoesEntityExist(vehicle) then

				IsBusy = true
				TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_WELDING", 0, true)
				SetVehicleAlarm(vehicle, 1)
				StartVehicleAlarm(vehicle)
				SetVehicleAlarmTimeLeft(vehicle, 40000)
				TriggerEvent('esx_customItems:checkVehicleDistance', vehicle)
				TriggerEvent("mythic_progbar:client:progress", {
					name = "bzk",
					duration = 5000,
					label = "Dar Hal Baaz Kardan Mashin...",
					useWhileDead = false,
					canCancel = true,
					controlDisables = {
						disableMovement = true,
						disableCarMovement = true,
						disableMouse = false,
						disableCombat = true,
					}
				}, function(status)
					if not status then
						SetVehicleDoorsLocked(vehicle, 1)
						SetVehiceleDoorsLockedForAllPlayers(vehicle, false)
						ESX.ShowNotification(_U('vehicle_unlocked'))
						TriggerEvent('esx_customItems:checkVehicleStatus', false)
					end
					ClearPedTasksImmediately(playerPed)
					IsBusy = false
				end)
			else
				ESX.ShowNotification(_U('no_vehicle_nearby'), 'error')
			end

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
				TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_MAID_CLEAN', 0, true)
				TriggerEvent('esx_customItems:checkVehicleDistance', vehicle)
				TriggerEvent("mythic_progbar:client:progress", {
					name = "clean",
					duration = 10000,
					label = "Dar Hal Tamiz Kardan Mashin...",
					useWhileDead = false,
					canCancel = true,
					controlDisables = {
						disableMovement = true,
						disableCarMovement = true,
						disableMouse = false,
						disableCombat = true,
					}
				}, function(status)
					if not status then
						SetVehicleDirtLevel(vehicle, 0)
						TriggerEvent('esx_customItems:checkVehicleStatus', false)
					end
					ClearPedTasksImmediately(playerPed)
					IsBusy = false
				end)
			else
				ESX.ShowNotification(_U('no_vehicle_nearby'), 'error')
			end

		elseif data.current.value == 'dep_vehicle' then
			local playerPed = PlayerPedId()
			local vehicle = GetVehiclePedIsIn(playerPed, true)
			local towmodel = GetHashKey('flatbed')
			local isVehicleTow = IsVehicleModel(vehicle, towmodel)
			if isVehicleTow then
				AttachEntityToEntity(CurrentlyTowedVehicle, vehicle, 20, -0.5, -12.0, 1.0, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
				DetachEntity(CurrentlyTowedVehicle, true, true)
				CurrentlyTowedVehicle = nil
				ESX.ShowNotification(_U('veh_det_succ'), 'success')
			else
				ESX.ShowNotification(_U('imp_flatbed'), 'info')
			end
		end
		CurrentAction     = nil
		CurrentActionMsg  = ""
		CurrentActionData = {}
	end, function(data, menu)
		menu.close()
		CurrentAction     = nil
		CurrentActionMsg  = ""
		CurrentActionData = {}
	end)
end

function RepairVehicleBody()
	local playerPed = GetPlayerPed(-1)
	local vehicle = ESX.Game.GetVehicleInDirection()
	local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
	if IsPedSittingInAnyVehicle(playerPed) then
		ESX.ShowNotification(_U('inside_vehicle'))
		return
	end
	if DoesEntityExist(vehicle) then
		vehicleProps["tyres"] = {}
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
		
		for id = 0, 5 do
			local doorId = IsVehicleDoorDamaged(vehicle, id)
		
			if doorId then
				vehicleProps["doors"][#vehicleProps["doors"] + 1] = doorId
			else
				vehicleProps["doors"][#vehicleProps["doors"] + 1] = false
			end
		end

		ExecuteCommand("e mechanic")
		TriggerEvent("mythic_progbar:client:progress", {
			name = "fixbody",
			duration = 30000,
			label = "Dar Hal Fix Kardan Body Mashin...",
			useWhileDead = false,
			canCancel = true,
			controlDisables = {
				disableMovement = true,
				disableCarMovement = true,
				disableMouse = false,
				disableCombat = true,
			}
		}, function(status)
			if not status then
				SetVehicleFixed(vehicle)
				SetVehicleDeformationFixed(vehicle)
				SetVehicleUndriveable(vehicle, false)

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
		end)
	else
		ESX.ShowNotification(_U('no_vehicle_nearby'), 'error')
	end
end

RegisterNetEvent('esx_mechanicjob:useTyre')
AddEventHandler('esx_mechanicjob:useTyre', function()
	local playerPed = GetPlayerPed(-1)
	local vehicle = ESX.Game.GetVehicleInDirection()
	local closestTire 	= GetClosestVehicleTire(vehicle)
	if IsPedSittingInAnyVehicle(playerPed) then
		ESX.ShowNotification(_U('inside_vehicle'), 'error')
		return
	end
	if DoesEntityExist(vehicle) then
		ExecuteCommand("e mechanic")
		TriggerEvent("mythic_progbar:client:progress", {
			name = "charkh",
			duration = 25000,
			label = "Dar Hal Avaz Kardan Charkh...",
			useWhileDead = false,
			canCancel = true,
			controlDisables = {
				disableMovement = true,
				disableCarMovement = true,
				disableMouse = false,
				disableCombat = true,
			}
		}, function(status)
			if not status then
				if closestTire.tireIndex then
					SetVehicleTyreFixed(vehicle, closestTire.tireIndex)
					SetVehicleWheelHealth(vehicle, closestTire.tireIndex, 100)
					TriggerServerEvent("esx_mechanicjob:remove", "tyre")
				else
					ESX.ShowNotification("Tyre Mashin Nazdik SHoma NIst!", 'error')
				end
			end
		end)
	else
		ESX.ShowNotification(_U('no_vehicle_nearby'), 'error')
	end
end)

RegisterNetEvent('esx_mechanicjob:useDoor')
AddEventHandler('esx_mechanicjob:useDoor', function()
	local playerPed = GetPlayerPed(-1)
	local vehicle = ESX.Game.GetVehicleInDirection()
	local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
	if IsPedSittingInAnyVehicle(playerPed) then
		ESX.ShowNotification(_U('inside_vehicle'))
		return
	end
	if DoesEntityExist(vehicle) then
		vehicleProps["tyres"] = {}

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

		vehicleProps["engineHealth"] = GetVehicleEngineHealth(vehicle)
		vehicleProps["bodyHealth"] = GetVehicleBodyHealth(vehicle)
		vehicleProps["fuelLevel"] = GetVehicleFuelLevel(vehicle)

		ExecuteCommand("e mechanic")
		TriggerEvent("mythic_progbar:client:progress", {
			name = "badane",
			duration = 40000,
			label = "Dar Hal Avaz Kardan Badane...",
			useWhileDead = false,
			canCancel = true,
			controlDisables = {
				disableMovement = true,
				disableCarMovement = true,
				disableMouse = false,
				disableCombat = true,
			}
		}, function(status)
			if not status then
				SetVehicleFixed(vehicle)
				SetVehicleDeformationFixed(vehicle)
				SetVehicleUndriveable(vehicle, false)
				ESX.Game.SetVehicleProperties(vehicle, vehicleProps)
				SetVehicleEngineHealth(vehicle, vehicleProps["engineHealth"] and vehicleProps["engineHealth"] + 0.0 or 1000.0)
				SetVehicleBodyHealth(vehicle, vehicleProps["bodyHealth"] and vehicleProps["bodyHealth"] + 0.0 or 1000.0)
				SetVehicleFuelLevel(vehicle, vehicleProps["fuelLevel"] and vehicleProps["fuelLevel"] + 0.0 or 1000.0)

				if vehicleProps["tyres"] then
					for tyreId = 1, 7, 1 do
						if vehicleProps["tyres"][tyreId] ~= false then
							SetVehicleTyreBurst(vehicle, tyreId, true, 1000)
						end
					end
				end

				TriggerServerEvent("esx_mechanicjob:remove", "door")
			end
		end)
	else
		ESX.ShowNotification(_U('no_vehicle_nearby'), 'error')
	end
end)

RegisterNetEvent('esx_mechanicjob:onFixkit')
AddEventHandler('esx_mechanicjob:onFixkit', function()
	local playerPed = PlayerPedId()
	local coords    = GetEntityCoords(playerPed)

	if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
		local vehicle

		if IsPedInAnyVehicle(playerPed, false) then
			vehicle = GetVehiclePedIsIn(playerPed, false)
		else
			vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
		end

		if DoesEntityExist(vehicle) then
			TaskStartScenarioInPlace(playerPed, 'PROP_HUMAN_BUM_BIN', 0, true)
			TriggerEvent("mythic_progbar:client:progress", {
				name = "engine",
				duration = 40000,
				label = "Dar Hal Repair Engine Mashin...",
				useWhileDead = false,
				canCancel = true,
				controlDisables = {
					disableMovement = true,
					disableCarMovement = true,
					disableMouse = false,
					disableCombat = true,
				}
			}, function(status)
				if not status then
					SetVehicleEngineHealth(vehicle, 1000.0)
				end
				ClearPedTasksImmediately(playerPed)
			end)
		end
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

AddEventHandler('esx_mechanicjob:hasEnteredMarker', function(zone)
	if zone == 'mechanicActions' then
		CurrentAction     = 'mechanic_actions_menu'
		CurrentActionMsg  = _U('open_actions')
		CurrentActionData = {}
	end
end)

AddEventHandler('esx_mechanicjob:hasExitedMarker', function(zone)
	CurrentAction     = nil
	CurrentActionMsg  = ''
	CurrentActionData = {}
end)


Citizen.CreateThread(function()
	for k,v in pairs(MechanicConfig.Zones) do
		for k2,v2 in pairs(v) do
			if k2 == "mechanicActions" then
				local blip = AddBlipForCoord(v2.Pos.x, v2.Pos.y, v2.Pos.z)
				SetBlipSprite (blip, 446)
				SetBlipDisplay(blip, 4)
				SetBlipScale  (blip, 0.8)
				SetBlipColour (blip, 5)
				SetBlipAsShortRange(blip, true)
				BeginTextCommandSetBlipName('STRING')
				AddTextComponentSubstringPlayerName(_U('mechanic'))
				EndTextCommandSetBlipName(blip)
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)

		if ESX.PlayerData.job and (ESX.PlayerData.job.name == 'mechanic' or ESX.PlayerData.job.name == 'motormechanic') then
			local coords, letSleep = GetEntityCoords(PlayerPedId()), true

			for k,v in pairs(MechanicConfig.Zones) do
				if k == ESX.PlayerData.job.name then
					for k2,v2 in pairs(v) do
						if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), v2.Pos.x, v2.Pos.y, v2.Pos.z, true) < 5 then
							DrawMarker(v2.Type, v2.Pos.x, v2.Pos.y, v2.Pos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v2.Size.x, v2.Size.y, v2.Size.z, v2.Color.r, v2.Color.g, v2.Color.b, 100, false, true, 2, false, nil, nil, false)
							letSleep = false
						end
					end
				end
			end

			if letSleep then
				Citizen.Wait(500)
			end
		else
			Citizen.Wait(500)
		end
	end
end)

-- Enter / Exit marker events
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)

		if ESX.PlayerData.job and (ESX.PlayerData.job.name == 'mechanic' or ESX.PlayerData.job.name == 'motormechanic') then

			local coords      = GetEntityCoords(PlayerPedId())
			local isInMarker  = false
			local currentZone = nil

			for k,v in pairs(MechanicConfig.Zones) do
				if k == ESX.PlayerData.job.name then
					for k2,v2 in pairs(v) do
						if(GetDistanceBetweenCoords(coords, v2.Pos.x, v2.Pos.y, v2.Pos.z, true) < 3) then
							isInMarker  = true
							currentZone = k2
						end
					end
				end
			end

			if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
				HasAlreadyEnteredMarker = true
				LastZone                = currentZone
				TriggerEvent('esx_mechanicjob:hasEnteredMarker', currentZone)
			end

			if not isInMarker and HasAlreadyEnteredMarker then
				HasAlreadyEnteredMarker = false
				TriggerEvent('esx_mechanicjob:hasExitedMarker', LastZone)
			end

			if not isInMarker then
				Citizen.Wait(250)
			end
		else
			Citizen.Wait(500)
		end
	end
end)

-- Key Controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		if not isDead and ESX.PlayerData.job and (ESX.PlayerData.job.name == 'mechanic' or ESX.PlayerData.job.name == 'motormechanic') then
			if CurrentAction then
				ESX.ShowHelpNotification(CurrentActionMsg)
				if IsControlJustReleased(0, 38) then
					if CurrentAction == 'mechanic_actions_menu' then
						OpenmechanicActionsMenu()
					end
					CurrentAction = nil
				end
			end

			if IsControlJustReleased(0, 167) then
				OpenMobilemechanicActionsMenu()
			end
		else
			Citizen.Wait(500)
		end
	end
end)

AddEventHandler('esx:onPlayerDeath', function(data)
	isDead = true
end)

AddEventHandler('playerSpawned', function(spawn)
	isDead = false
end)

function DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())

    SetTextScale(0.32, 0.32)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 255)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 500
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 0, 0, 0, 80)
end