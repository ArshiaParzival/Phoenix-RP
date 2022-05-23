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
local hasAlreadyJoined        = false
local isDead                  = false
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
	if PlayerData.job and PlayerData.job.name == "dadgostari" then
        TriggerDadgostari()
    end
end)


function SetVehicleMaxMods(vehicle)
	local props = {
		modEngine       = 5,
		modBrakes		= 5,
		windowTint		= 2,
		modArmor		= 5,
		modTransmission = 2,
		modSuspension   = 4,
		modTurbo        = true,
	}

	ESX.Game.SetVehicleProperties(vehicle, props)
	SetVehicleDirtLevel(vehicle, 0.0)
end

function cleanPlayer(playerPed)
	SetPedArmour(playerPed, 0)
	ClearPedBloodDamage(playerPed)
	ResetPedVisibleDamage(playerPed)
	ClearPedLastWeaponDamage(playerPed)
	ResetPedMovementClipset(playerPed, 0)
end

function OpenCloakroomMenu()

	local playerPed = PlayerPedId()
	local grade = PlayerData.job.grade_name

	local elements = {
		{label = "Outfits", value = 'custom'},
		{ label = _U('bullet_wear'),  value = 'bullet_wear'  },
		{label = _U('dadgostari_wear'), value = 'dadgostari_wear'}
	}

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cloakroom',
	{
		title    = _U('cloakroom'),
		align    = 'right',
		elements = elements
	}, function(data, menu)

		cleanPlayer(playerPed)

		if
			data.current.value == 'dadgostari_wear'
		then
			local job =  PlayerData.job.name
			local gradenum =  PlayerData.job.grade

			ESX.TriggerServerCallback('Proxtended:getGender', function(skin)
				ESX.TriggerServerCallback('esx_society:getUniforms', function(SkinMale, SkinFemale)-- get uniform from esx_society
					if skin.sex == 0 then
							TriggerEvent('PX_clothing:client:loadOutfit', SkinMale)
					else
							TriggerEvent('PX_clothing:client:loadOutfit', SkinFemale)
					end
				end, gradenum, job)
			end)
			SetPedArmour(PlayerPedId(), 100)
		elseif
			data.current.value == 'custom' then
				TriggerEvent('PX_clothing:client:openOutfitMenu')
		end

	end, function(data, menu)
		menu.close()

		CurrentAction     = 'menu_cloakroom'
		CurrentActionMsg  = _U('open_cloackroom')
		CurrentActionData = {}
	end)
end

function OpenArmoryMenu(station)

	local elements = {
		{label = "Self Stash",     value = 'stash'},
		{label = "Shop",     value = 'shop'}
	}

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
	'default', GetCurrentResourceName(), 'armory',
	{
		title    = _U('armory'),
		align    = 'right',
		elements = elements,
	},
	function(data, menu)

		if data.current.value == 'stash' then
			TriggerServerEvent("PX_inventory:server:OpenInventory", "stash", "personalsafe_"..ESX.GetPlayerData().job.name..'_'..ESX.GetPlayerData().identifier)
            TriggerEvent("PX_inventory:client:SetCurrentStash", "personalsafe_"..ESX.GetPlayerData().job.name..'_'..ESX.GetPlayerData().identifier)
		elseif data.current.value == 'shop' then
			if ESX.GetPlayerData().job.grade_name == 'boss' then
				TriggerServerEvent("PX_inventory:server:OpenInventory", "shop", "justice", DadgostariConfig.Items)
			else
				ESX.ShowNotification("Shoma Chief Nistid", 'error')
			end
		end

	end,
	function(data, menu)

		menu.close()

		CurrentAction     = 'menu_armory'
		CurrentActionMsg  = _U('open_armory')
		CurrentActionData = {station = station}
	end
	)
end

function OpenVehicleSpawnerMenu(station, partNum)
	local vehicles = DadgostariConfig.DadgostariStations[station].Vehicles
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
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_spawner',
			{
				title    = _U('vehicle_menu'),
				align    = 'right',
				elements = elements
			}, function(data, menu)
				menu.close()
				local model   = data.current.model
				local vehicle = GetClosestVehicle(vehicles[partNum].SpawnPoint.x, vehicles[partNum].SpawnPoint.y, vehicles[partNum].SpawnPoint.z, 3.0, 0, 71)
				if not DoesEntityExist(vehicle) then
					local playerPed = PlayerPedId()
					ESX.Game.SpawnVehicle(model, vehicles[partNum].SpawnPoint, vehicles[partNum].Heading, function(vehicle)
						TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
						SetVehicleMaxMods(vehicle)
						TriggerServerEvent("garage:addKeys", GetVehicleNumberPlateText(vehicle), GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
						Citizen.Wait(2000)
						SetVehicleFuelLevel(vehicle, 100.0)
					end)
				else
					ESX.ShowNotification(_U('vehicle_out'), 'error')
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

function OpenDadgostariActionsMenu()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
	'default', GetCurrentResourceName(), 'dadgostari_actions',
	{
		title    = 'Dadgostari',
		align    = 'right',
		elements = {
			{label = _U('citizen_interaction'),	value = 'citizen_interaction'},
			{label = "Object Menu",	value = 'object'},
			{label = "Tablet",	value = 'mdt'},
			{label = 	"Zendan",               value = 'jail_menu'}
		}
	}, function(data, menu)

		if data.current.value == 'citizen_interaction' then
			local elements = {
				{label =  'Search',			   value = 'search'},
				{label =  'Dastband',			 value = 'cuff'},
				{label =  'Baaz Kardan Dastband',	value = 'uncuff'},
				{label =  'Drag',			       value = 'drag'},
				{label =  'Put In Vehicle',			 value = 'piv'},
				{label =  'Put Out vehicle',		value = 'pov'}
			}

			ESX.UI.Menu.Open(
			'default', GetCurrentResourceName(), 'citizen_interaction',
			{
				title    = _U('citizen_interaction'),
				align    = 'right',
				elements = elements
			}, function(data2, menu2)
				local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
				if closestPlayer ~= -1 and closestDistance <= 10.0 then
					local action = data2.current.value
					if action == 'search' then
						TriggerEvent("search")
					elseif action == 'cuff' then
						TriggerEvent("cuff")
					elseif action == 'uncuff' then
						TriggerEvent("uncuff")
					elseif action == 'drag' then
						TriggerEvent("drag")
					elseif action == 'piv' then
						TriggerEvent("PutInVeh")
					elseif action == 'pov' then
						TriggerEvent("PutOutVeh")
					end

				else
					ESX.ShowNotification(_U('no_players_nearby'), 'error')
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		elseif data.current.value == 'jail_menu' then
			TriggerEvent("PX_jail:openJailmenu")
		elseif data.current.value == 'object' then
			TriggerEvent("Parzival_Object:openMenu")
		elseif data.current.value == 'mdt' then
			ExecuteCommand("mdt")
		end

	end, function(data, menu)
		menu.close()
	end)
end

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	local lastjob = PlayerData.job.name
    PlayerData.job = job

    if (PlayerData.job.name == "dadgostari") and lastjob ~= PlayerData.job.name then
        TriggerDadgostari()
    end
end)

AddEventHandler('esx_dadgostarijob:hasEnteredMarker', function(station, part, partNum)

	if part == 'Cloakroom' then
		CurrentAction     = 'menu_cloakroom'
		CurrentActionMsg  = _U('open_cloackroom')
		CurrentActionData = {}
	end

	if part == 'Armory' then
		CurrentAction     = 'menu_armory'
		CurrentActionMsg  = _U('open_armory')
		CurrentActionData = {station = station}
	end

	if part == 'VehicleSpawner' then
		CurrentAction     = 'menu_vehicle_spawner'
		CurrentActionMsg  = _U('vehicle_spawner')
		CurrentActionData = {station = station, partNum = partNum}
	end

	if part == 'VehicleDeleter' then

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

	end

	if part == 'BossActions' then
		CurrentAction     = 'menu_boss_actions'
		CurrentActionMsg  = _U('open_bossmenu')
		CurrentActionData = {}
	end

end)

AddEventHandler('esx_dadgostarijob:hasExitedMarker', function(station, part, partNum)
	ESX.UI.Menu.CloseAll()
	CurrentAction = nil
end)


function TriggerDadgostari()
	-- Display markers
	Citizen.CreateThread(function()
	while PlayerData.job and PlayerData.job.name == 'dadgostari' do

		Citizen.Wait(5)

		if PlayerData.job ~= nil and PlayerData.job.name == 'dadgostari' and PlayerData.job.grade >= 0 then

		local canSleep  = true
		local playerPed = PlayerPedId()
		local coords    = GetEntityCoords(playerPed)

		for k,v in pairs(DadgostariConfig.DadgostariStations) do

			for i=1, #v.Cloakrooms, 1 do
				if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),  v.Cloakrooms[i].x,  v.Cloakrooms[i].y,  v.Cloakrooms[i].z,  true) < 5 then
					canSleep = false
					DrawMarker(20, v.Cloakrooms[i].x, v.Cloakrooms[i].y, v.Cloakrooms[i].z, 0, 0, 0, 0, 0, 0, 0.5, 0.5, 0.3, 255, 255, 255, 255, true, true, 2, true, false, false, false)
				end
			end

			for i=1, #v.Armories, 1 do
				if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),  v.Armories[i].x,  v.Armories[i].y,  v.Armories[i].z,  true) < 5 then
				canSleep = false
				DrawMarker(20, v.Armories[i].x, v.Armories[i].y, v.Armories[i].z, 0, 0, 0, 0, 0, 0, 0.5, 0.5, 0.3, 255, 255, 255, 255, true, true, 2, true, false, false, false)
				end
			end

			for i=1, #v.Vehicles, 1 do
			canSleep = false
				if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),  v.Vehicles[i].Spawner.x,  v.Vehicles[i].Spawner.y,  v.Vehicles[i].Spawner.z,  true) < 5 then
					DrawMarker(36, v.Vehicles[i].Spawner.x, v.Vehicles[i].Spawner.y, v.Vehicles[i].Spawner.z, 0, 0, 0, 0, 0, 0, 0.8, 0.8, 0.8, 255, 255, 255, 500, true, true, 2, true, false, false, false)
				end
			end

			for i=1, #v.VehicleDeleters, 1 do
			canSleep = false
				if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),  v.VehicleDeleters[i].x,  v.VehicleDeleters[i].y,  v.VehicleDeleters[i].z,  true) < 5 then
					DrawMarker(24, v.VehicleDeleters[i].x, v.VehicleDeleters[i].y, v.VehicleDeleters[i].z, 0, 0, 0, 0, 0, 0, 0.8, 0.8, 0.8, 0, 255, 0, 500, true, true, 2, true, false, false, false)
				end
			end

			if DadgostariConfig.EnablePlayerManagement and PlayerData.job ~= nil and PlayerData.job.name == 'dadgostari' and PlayerData.job.grade_name == 'boss' then

				for i=1, #v.BossActions, 1 do
					if not v.BossActions[i].disabled and GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),  v.BossActions[i].x,  v.BossActions[i].y,  v.BossActions[i].z,  true) < 5 then
						DrawMarker(20, v.BossActions[i].x, v.BossActions[i].y, v.BossActions[i].z, 0, 0, 0, 0, 0, 0, 0.5, 0.5, 0.3, 255, 255, 255, 255, true, true, 2, true, false, false, false)
					end
				end

			end

		end
		if canSleep then
			Citizen.Wait(500)
			end
		end

	end
	end)

	-- Enter / Exit marker events
	Citizen.CreateThread(function()

	while PlayerData.job and PlayerData.job.name == 'dadgostari' do

		Citizen.Wait(1000)

		if PlayerData.job ~= nil and PlayerData.job.name == 'dadgostari' and PlayerData.job.grade >= 0 then

		local playerPed      = PlayerPedId()
		local coords         = GetEntityCoords(playerPed)
		local isInMarker     = false
		local currentStation = nil
		local currentPart    = nil
		local currentPartNum = nil

		for k,v in pairs(DadgostariConfig.DadgostariStations) do

			for i=1, #v.Cloakrooms, 1 do
			if GetDistanceBetweenCoords(coords,  v.Cloakrooms[i].x,  v.Cloakrooms[i].y,  v.Cloakrooms[i].z,  true) < DadgostariConfig.MarkerSize.x then
				isInMarker     = true
				currentStation = k
				currentPart    = 'Cloakroom'
				currentPartNum = i
			end
			end

			for i=1, #v.Armories, 1 do
			if GetDistanceBetweenCoords(coords,  v.Armories[i].x,  v.Armories[i].y,  v.Armories[i].z,  true) < DadgostariConfig.MarkerSize.x then
				isInMarker     = true
				currentStation = k
				currentPart    = 'Armory'
				currentPartNum = i
			end
			end

			for i=1, #v.Vehicles, 1 do

			if GetDistanceBetweenCoords(coords,  v.Vehicles[i].Spawner.x,  v.Vehicles[i].Spawner.y,  v.Vehicles[i].Spawner.z,  true) < DadgostariConfig.MarkerSize.x then
				isInMarker     = true
				currentStation = k
				currentPart    = 'VehicleSpawner'
				currentPartNum = i
			end

			if GetDistanceBetweenCoords(coords,  v.Vehicles[i].SpawnPoint.x,  v.Vehicles[i].SpawnPoint.y,  v.Vehicles[i].SpawnPoint.z,  true) < DadgostariConfig.MarkerSize.x then
				isInMarker     = true
				currentStation = k
				currentPart    = 'VehicleSpawnPoint'
				currentPartNum = i
			end

			end

			for i=1, #v.VehicleDeleters, 1 do
			if GetDistanceBetweenCoords(coords,  v.VehicleDeleters[i].x,  v.VehicleDeleters[i].y,  v.VehicleDeleters[i].z,  true) < DadgostariConfig.MarkerSize.x then
				isInMarker     = true
				currentStation = k
				currentPart    = 'VehicleDeleter'
				currentPartNum = i
			end
			end

			if DadgostariConfig.EnablePlayerManagement and PlayerData.job ~= nil and PlayerData.job.name == 'dadgostari' and PlayerData.job.grade_name == 'boss' then

			for i=1, #v.BossActions, 1 do
				if GetDistanceBetweenCoords(coords,  v.BossActions[i].x,  v.BossActions[i].y,  v.BossActions[i].z,  true) < DadgostariConfig.MarkerSize.x then
				isInMarker     = true
				currentStation = k
				currentPart    = 'BossActions'
				currentPartNum = i
				end
			end

			end
		end

		local hasExited = false

		if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and (LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum) ) then

			if
			(LastStation ~= nil and LastPart ~= nil and LastPartNum ~= nil) and
			(LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum)
			then
			TriggerEvent('esx_dadgostarijob:hasExitedMarker', LastStation, LastPart, LastPartNum)
			hasExited = true
			end

			HasAlreadyEnteredMarker = true
			LastStation             = currentStation
			LastPart                = currentPart
			LastPartNum             = currentPartNum

			TriggerEvent('esx_dadgostarijob:hasEnteredMarker', currentStation, currentPart, currentPartNum)
		end

		if not hasExited and not isInMarker and HasAlreadyEnteredMarker then

			HasAlreadyEnteredMarker = false

			TriggerEvent('esx_dadgostarijob:hasExitedMarker', LastStation, LastPart, LastPartNum)
		end
		else
		Citizen.Wait(1500)
		end

	end
	end)

	-- Key Controls
	Citizen.CreateThread(function()
		while PlayerData.job and PlayerData.job.name == 'dadgostari' do

			Citizen.Wait(0)

			if CurrentAction ~= nil then
				SetTextComponentFormat('STRING')
				AddTextComponentString(CurrentActionMsg)
				DisplayHelpTextFromStringLabel(0, 0, 1, -1)

				if IsControlJustReleased(0, Keys['E']) and PlayerData.job ~= nil and PlayerData.job.name == 'dadgostari' and PlayerData.job.grade >= 0 then

					if CurrentAction == 'menu_cloakroom' then
						OpenCloakroomMenu()
					elseif CurrentAction == 'menu_armory' then
						if DadgostariConfig.MaxInService == -1 then
							OpenArmoryMenu(CurrentActionData.station)
						elseif playerInService then
							OpenArmoryMenu(CurrentActionData.station)
						else
							ESX.ShowNotification(_U('service_not'), 'error')
						end
					elseif CurrentAction == 'menu_vehicle_spawner' then
						OpenVehicleSpawnerMenu(CurrentActionData.station, CurrentActionData.partNum)
					elseif CurrentAction == 'delete_vehicle' then
						if DadgostariConfig.EnableSocietyOwnedVehicles then
							local vehicleProps = ESX.Game.GetVehicleProperties(CurrentActionData.vehicle)
							TriggerServerEvent('esx_society:putVehicleInGarage', 'dadgostari', vehicleProps)
						end
						ESX.Game.DeleteVehicle(CurrentActionData.vehicle)
					elseif CurrentAction == 'menu_boss_actions' then
						ESX.UI.Menu.CloseAll()
						TriggerEvent('esx_society:openBossMenu', 'dadgostari', function(data, menu)
							menu.close()
							CurrentAction     = 'menu_boss_actions'
							CurrentActionMsg  = _U('open_bossmenu')
							CurrentActionData = {}
						end, { wash = false }) -- disable washing money
					end
					
					CurrentAction = nil
				end
			end -- CurrentAction end
			
			if IsControlJustReleased(0, Keys['F6']) and not isDead and PlayerData.job ~= nil and PlayerData.job.name == 'dadgostari' and PlayerData.job.grade >= 0 and not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'dadgostari_actions') then
				if DadgostariConfig.MaxInService == -1 then
					OpenDadgostariActionsMenu()
				elseif playerInService then
					OpenDadgostariActionsMenu()
				else
					ESX.ShowNotification(_U('service_not'), 'error')
				end
			end
			
		end
	end)
end

-- Create blips
Citizen.CreateThread(function()

	for k,v in pairs(DadgostariConfig.DadgostariStations) do

		local blip = AddBlipForCoord(v.Blip.Pos.x, v.Blip.Pos.y, v.Blip.Pos.z)

		SetBlipSprite (blip, v.Blip.Sprite)
		SetBlipDisplay(blip, v.Blip.Display)
		SetBlipScale  (blip, v.Blip.Scale)
		SetBlipColour (blip, v.Blip.Colour)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("DOJ")
		EndTextCommandSetBlipName(blip)

	end
end)



AddEventHandler('playerSpawned', function(spawn)
	isDead = false
	if not hasAlreadyJoined then
		TriggerServerEvent('esx_dadgostarijob:spawned')
	end
	hasAlreadyJoined = true
end)

AddEventHandler('esx:onPlayerDeath', function(data)
	isDead = true
end)