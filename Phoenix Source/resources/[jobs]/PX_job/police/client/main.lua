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
local inPaintBall = false
local inCapture = false
local inEvent = false
local hasAlreadyJoined        = false
local isDead                  = false
local playerInService         = false
local SpawnCar = false
local carblip = nil

ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
	if PlayerData.job and PlayerData.job.name == "police" then
        TriggerPolice()
    end
end)

AddEventHandler('esx_paintball:inPaintBall', function(state) inPaintBall = state end)
AddEventHandler('capture:inCapture', function(bool)
	inCapture = bool
end)
AddEventHandler('Parzival:Event', function(bool)
    inEvent = bool
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
	ESX.TriggerServerCallback('Proxtended:getGender', function(skin)
		ESX.TriggerServerCallback('esx_society:getmydivisionclothes', function(divs)
			if skin.sex == 0 then
				gender = 'man'
			else
				gender = 'woman'
			end
			while gender == nil do
				Wait(0)
			end
			local playerPed = PlayerPedId()
			local grade = PlayerData.job.grade_name

			local elements = {
				{label =    'Outfits', value = 'custom'},
				{label = _U('police_wear'), value = 'police_wear'}
			}

			if #divs > 0 then
				for _,v in ipairs(divs) do
					table.insert(elements, {label = v.name, value = v.name, suit = v.outfit})
				end
			end

			ESX.UI.Menu.CloseAll()

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cloakroom',
			{
				title    = _U('cloakroom'),
				align    = 'right',
				elements = elements
			}, function(data, menu)

				cleanPlayer(playerPed)

				if
					data.current.value == 'police_wear'
				then
					local job =  PlayerData.job.name
					local gradenum =  PlayerData.job.grade

					
					ESX.TriggerServerCallback('esx_society:getUniforms', function(SkinMale, SkinFemale)-- get uniform from esx_society
						if skin.sex == 0 then
							TriggerEvent('PX_clothing:client:loadOutfit', SkinMale)
						else
							TriggerEvent('PX_clothing:client:loadOutfit', SkinFemale)
						end
					end, gradenum, job)
					SetPedArmour(PlayerPedId(), 100)
				elseif data.current.value == 'custom' then
					TriggerEvent('PX_clothing:client:openOutfitMenu')
				else
					ESX.TriggerServerCallback('Proxtended:getGender', function(skin)
						SetPedArmour(PlayerPedId(), 100)
						TriggerEvent('PX_clothing:client:loadOutfit', data.current.suit)
					end)
				end

			end, function(data, menu)
				menu.close()

				CurrentAction     = 'menu_cloakroom'
				CurrentActionMsg  = _U('open_cloackroom')
				CurrentActionData = {}
			end)
		end, gender)
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
				TriggerServerEvent("PX_inventory:server:OpenInventory", "shop", "police", PDConfig.Items)
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
	local vehicles = PDConfig.PoliceStations[station].Vehicles
	ESX.UI.Menu.CloseAll()

	local elements = {}
	local grade = PlayerData.job.grade
	local job = PlayerData.job.name
	ESX.TriggerServerCallback('esx_society:getmyDivVehicles', function(divVehs)
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
				if divVehs ~= nil then
					for i=1, #divVehs, 1 do
						for k,v in ipairs(divVehs[i]) do
							if v.status == true then
								table.insert(elements, {
									label = v.model,
									model = v.model
								})
							end
						end
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

					ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'car_plate', {
						title = 'Pelake Mashin',
					}, function(data2, menu2)
						if data2.value == nil then
							ESX.ShowNotification('Lotfan Yek Pelak Vared Konid!', 'error')
						else
							menu2.close()

							local model   = data.current.model
							local vehicle = GetClosestVehicle(vehicles[partNum].SpawnPoint.x, vehicles[partNum].SpawnPoint.y, vehicles[partNum].SpawnPoint.z, 3.0, 0, 71)

							if not DoesEntityExist(vehicle) then

								local playerPed = PlayerPedId()
								if not SpawnCar then
									if model == "polmav" then
										ESX.Game.SpawnVehicle(model, vehicles[partNum].Heli, vehicles[partNum].HHeading, function(vehicle)
											SetVehicleNumberPlateText(vehicle, "PX"..data2.value)
											SetVehicleLivery(Vehicle, 0)
											TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
											TriggerServerEvent("garage:addKeys", GetVehicleNumberPlateText(vehicle), GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
											Citizen.Wait(2000)
											SpawnCar = true
											SetVehicleFuelLevel(vehicle, 100.0)
											carblip = AddBlipForEntity(Vehicle)
											SetBlipSprite(carblip, 227)
											SetBlipFlashes(carblip, true)
											SetBlipFlashTimer(carblip, 5000)
										end)
									else
										ESX.Game.SpawnVehicle(model, vehicles[partNum].SpawnPoint, vehicles[partNum].Heading, function(vehicle)
											SetVehicleMaxMods(vehicle)
											SetVehicleNumberPlateText(vehicle, "PX"..data2.value)
											TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
											TriggerServerEvent("garage:addKeys", GetVehicleNumberPlateText(vehicle), GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
											Citizen.Wait(2000)
											SpawnCar = true
											SetVehicleFuelLevel(vehicle, 100.0)
											carblip = AddBlipForEntity(Vehicle)
											SetBlipSprite(carblip, 227)
											SetBlipFlashes(carblip, true)
											SetBlipFlashTimer(carblip, 5000)
										end)
									end
								else
									ESX.ShowNotification("Shoma Dar Hal Haazer Yek Mashin Darid!", 'error')
								end
							else
								ESX.ShowNotification(_U('vehicle_out'), 'error')
							end
						end
					end, function(data2, menu2)
						menu2.close()
						CurrentAction     = 'menu_vehicle_spawner'
						CurrentActionMsg  = _U('vehicle_spawner')
						CurrentActionData = {station = station, partNum = partNum}
					end)
				end, function(data, menu)
					menu.close()
					CurrentAction     = 'menu_vehicle_spawner'
					CurrentActionMsg  = _U('vehicle_spawner')
					CurrentActionData = {station = station, partNum = partNum}
				end)
			end
		end, grade, job)
	end)
end

function OpenPoliceActionsMenu()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
	'default', GetCurrentResourceName(), 'police_actions',
	{
		title    = 'Police',
		align    = 'right',
		elements = {
			{label = _U('citizen_interaction'),	value = 'citizen_interaction'},
			{label = 	"Zendan",               value = 'jail_menu'},
			{label = "Object Menu",	value = 'object'},
			{label = "Self",               	    value = 'Self_menu'},
			{label = "Radio",               	    value = 'radio'}
		}
	}, function(data, menu)

		if data.current.value == 'citizen_interaction' then
			local elements = {
				{label =  'Search',			   value = 'search'},
				{label =  'Dastband',			 value = 'cuff'},
				{label =  'Baaz Kardan Dastband',	value = 'uncuff'},
				{label =  'Drag',			       value = 'drag'},
				{label =  'Put In Vehicle',			 value = 'piv'},
				{label =  'Put Out vehicle',		value = 'pov'},
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
		elseif data.current.value == 'object' then
			TriggerEvent("Parzival_Object:openMenu")
		elseif data.current.value == 'jail_menu' then
			TriggerEvent("PX_jail:openJailmenu")
		elseif data.current.value == 'radio' then
			ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(quantity)
				if quantity < 1 then
					ESX.ShowNotification("Shoma Radio Nadarid!", 'error')
				else
					ESX.UI.Menu.Open(
						'default', GetCurrentResourceName(), 'citizen_interaction',
					{
						title    = "Radio Actions",
						align    = 'right',
						elements = {
						{label = "Off",	            		value = 0},
						{label = "Frequency 1",		        value = 1},
						{label = "Frequency 2",	            value = 2},
						{label = "Frequency 3",	            	value = 3},
						{label = "Frequency 4",	            		value = 4},
						{label = "Frequency 5",	            		value = 5},
						{label = "Custom",	            	value = "custom"},
						}
					}, function(data2, menu2)
						if data2.current.value == 'custom' then
							ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'custom_radio',
							{
								title = "Frequene Radio Ra Vared Konid!",
							}, function(data3, menu3)
								local length = string.len(data3.value)
								if data3.value == nil or length > 3 then
									ESX.ShowNotification("Frequency Bayad Beyn 1-999 Bashad!", 'error')
								else
									if tonumber(data3.value) then
										ExecuteCommand("me Frequency Radio Ra Avaz Mikonad")
										exports["pma-voice"]:setRadioChannel(data3.value)
									else
										ESX.ShowNotification("Shoma Faghat Mitavanid Addad Benevisid!", 'error')
									end
									menu3.close()
								end
							end, function(data3, menu3)
								menu3.close()
							end)
						else
							ExecuteCommand("me Frequency Radio Ra Avaz Mikonad")
							exports["pma-voice"]:setRadioChannel(data2.current.value)
						end
					end, function(data2, menu2)
						menu2.close()
					end)
				end
			end, 'radio')
		elseif data.current.value == 'Self_menu' then
			local issheild = false
			ESX.UI.Menu.Open(
			'default', GetCurrentResourceName(), 'citizen_interaction',
			{
				title    = "Self",
				align    = 'right',
				elements = {
				  {label = "Shield",		            value = 'shield1'},
				  {label = "Tablet",	            	value = 'mdt'},
				  {label = "Livery",	            	value = 'livery'},
				  {label = "Radar",	            		value = 'radar'},
				}
			}, function(data2, menu2)
				local shieldActive = false
				local shieldEntity = nil	
				local action = data2.current.value
				if action == 'shield1' then
					TriggerEvent('shield:ToggleSwatShield')
				elseif action == 'mdt' then
					ESX.UI.Menu.CloseAll()
					ExecuteCommand("mdt")
				elseif action == 'livery' then
					ESX.UI.Menu.CloseAll()
					ExecuteCommand("livery")
				elseif action == 'radar' then
					ESX.UI.Menu.CloseAll()
					ExecuteCommand("radar")
				end
			end, function(data2, menu2)
				menu2.close()
			end)
	  end

	end, function(data, menu)
		menu.close()
	end)
end

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	local lastjob = PlayerData.job.name
    PlayerData.job = job

    if (PlayerData.job.name == "police") and lastjob ~= PlayerData.job.name then
        TriggerPolice()
    end
end)

AddEventHandler('esx_policejob:hasEnteredMarker', function(station, part, partNum)

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

AddEventHandler('esx_policejob:hasExitedMarker', function(station, part, partNum)
	ESX.UI.Menu.CloseAll()
	CurrentAction = nil
	dakhelheli = false
end)

AddEventHandler('esx_policejob:hasEnteredEntityZone', function(entity)

	local playerPed = PlayerPedId()

	if PlayerData.job ~= nil and PlayerData.job.name == 'police' and not IsPedInAnyVehicle(playerPed, false) then
		CurrentAction     = 'remove_entity'
		CurrentActionMsg  = _U('remove_prop')
		CurrentActionData = {entity = entity}
	end

	if GetEntityModel(entity) == GetHashKey('p_ld_stinger_s') then

		local playerPed = PlayerPedId()
		local coords    = GetEntityCoords(playerPed)

		if IsPedInAnyVehicle(playerPed,  false) then

		local vehicle = GetVehiclePedIsIn(playerPed)

		for i=0, 7, 1 do
			SetVehicleTyreBurst(vehicle,  i,  true,  1000)
		end

		end

	end

end)

-- Create blips
Citizen.CreateThread(function()

	for k,v in pairs(PDConfig.PoliceStations) do

		local blip = AddBlipForCoord(v.Blip.Pos.x, v.Blip.Pos.y, v.Blip.Pos.z)

		SetBlipSprite (blip, v.Blip.Sprite)
		SetBlipDisplay(blip, v.Blip.Display)
		SetBlipScale  (blip, v.Blip.Scale)
		SetBlipColour (blip, v.Blip.Colour)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Police Department")
		EndTextCommandSetBlipName(blip)

	end
end)

function TriggerPolice()
	-- Display markers
	Citizen.CreateThread(function()
		while PlayerData.job and PlayerData.job.name == 'police' do
			Citizen.Wait(5)

			if PlayerData.job ~= nil and PlayerData.job.name == 'police' and PlayerData.job.grade >= 0 then

			local canSleep  = true
			local playerPed = PlayerPedId()
			local coords    = GetEntityCoords(playerPed)

			for k,v in pairs(PDConfig.PoliceStations) do

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

				if PDConfig.EnablePlayerManagement and PlayerData.job ~= nil and PlayerData.job.name == 'police' and PlayerData.job.grade_name == 'boss' then

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
		while PlayerData.job and PlayerData.job.name == 'police' do
			Citizen.Wait(1000)

			if PlayerData.job ~= nil and PlayerData.job.name == 'police' and PlayerData.job.grade >= 0 then

			local playerPed      = PlayerPedId()
			local coords         = GetEntityCoords(playerPed)
			local isInMarker     = false
			local currentStation = nil
			local currentPart    = nil
			local currentPartNum = nil

			for k,v in pairs(PDConfig.PoliceStations) do

				for i=1, #v.Cloakrooms, 1 do
				if GetDistanceBetweenCoords(coords,  v.Cloakrooms[i].x,  v.Cloakrooms[i].y,  v.Cloakrooms[i].z,  true) < PDConfig.MarkerSize.x then
					isInMarker     = true
					currentStation = k
					currentPart    = 'Cloakroom'
					currentPartNum = i
				end
				end

				for i=1, #v.Armories, 1 do
				if GetDistanceBetweenCoords(coords,  v.Armories[i].x,  v.Armories[i].y,  v.Armories[i].z,  true) < PDConfig.MarkerSize.x then
					isInMarker     = true
					currentStation = k
					currentPart    = 'Armory'
					currentPartNum = i
				end
				end

				for i=1, #v.Vehicles, 1 do

				if GetDistanceBetweenCoords(coords,  v.Vehicles[i].Spawner.x,  v.Vehicles[i].Spawner.y,  v.Vehicles[i].Spawner.z,  true) < PDConfig.MarkerSize.x then
					isInMarker     = true
					currentStation = k
					currentPart    = 'VehicleSpawner'
					currentPartNum = i
				end

				if GetDistanceBetweenCoords(coords,  v.Vehicles[i].SpawnPoint.x,  v.Vehicles[i].SpawnPoint.y,  v.Vehicles[i].SpawnPoint.z,  true) < PDConfig.MarkerSize.x then
					isInMarker     = true
					currentStation = k
					currentPart    = 'VehicleSpawnPoint'
					currentPartNum = i
				end

				end

				for i=1, #v.VehicleDeleters, 1 do
				if GetDistanceBetweenCoords(coords,  v.VehicleDeleters[i].x,  v.VehicleDeleters[i].y,  v.VehicleDeleters[i].z,  true) < PDConfig.MarkerSize.x then
					isInMarker     = true
					currentStation = k
					currentPart    = 'VehicleDeleter'
					currentPartNum = i
				end
				end

				if PDConfig.EnablePlayerManagement and PlayerData.job ~= nil and PlayerData.job.name == 'police' and PlayerData.job.grade_name == 'boss' then

				for i=1, #v.BossActions, 1 do
					if GetDistanceBetweenCoords(coords,  v.BossActions[i].x,  v.BossActions[i].y,  v.BossActions[i].z,  true) < PDConfig.MarkerSize.x then
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
				TriggerEvent('esx_policejob:hasExitedMarker', LastStation, LastPart, LastPartNum)
				hasExited = true
				end

				HasAlreadyEnteredMarker = true
				LastStation             = currentStation
				LastPart                = currentPart
				LastPartNum             = currentPartNum

				TriggerEvent('esx_policejob:hasEnteredMarker', currentStation, currentPart, currentPartNum)
			end

			if not hasExited and not isInMarker and HasAlreadyEnteredMarker then

				HasAlreadyEnteredMarker = false

				TriggerEvent('esx_policejob:hasExitedMarker', LastStation, LastPart, LastPartNum)
			end
			else
			Citizen.Wait(1500)
			end

		end
	end)

	-- Key Controls
	Citizen.CreateThread(function()
		while PlayerData.job and PlayerData.job.name == 'police' do

			Citizen.Wait(5)

			if not isDead and PlayerData.job ~= nil and PlayerData.job.name == 'police' and PlayerData.job.grade >= 0 then
				if CurrentAction ~= nil then
					SetTextComponentFormat('STRING')
					AddTextComponentString(CurrentActionMsg)
					DisplayHelpTextFromStringLabel(0, 0, 1, -1)

					if IsControlJustReleased(0, Keys['E']) and PlayerData.job ~= nil and PlayerData.job.name == 'police' and PlayerData.job.grade >= 0 then

						if CurrentAction == 'menu_cloakroom' then
							OpenCloakroomMenu()
						elseif CurrentAction == 'menu_armory' then
							if PDConfig.MaxInService == -1 then
								OpenArmoryMenu(CurrentActionData.station)
							elseif playerInService then
								OpenArmoryMenu(CurrentActionData.station)
							else
								ESX.ShowNotification(_U('service_not'), 'error')
							end
						elseif CurrentAction == 'menu_vehicle_spawner' then
							OpenVehicleSpawnerMenu(CurrentActionData.station, CurrentActionData.partNum)
						elseif CurrentAction == 'delete_vehicle' then
							if PDConfig.EnableSocietyOwnedVehicles then
								local vehicleProps = ESX.Game.GetVehicleProperties(CurrentActionData.vehicle)
								TriggerServerEvent('esx_society:putVehicleInGarage', 'police', vehicleProps)
							end
							ESX.Game.DeleteVehicle(CurrentActionData.vehicle)
							SpawnCar = false
                            carblip = nil
						elseif CurrentAction == 'menu_boss_actions' then
							ESX.UI.Menu.CloseAll()
							TriggerEvent('esx_society:openBossMenu', 'police', function(data, menu)
								menu.close()
								CurrentAction     = 'menu_boss_actions'
								CurrentActionMsg  = _U('open_bossmenu')
								CurrentActionData = {}
							end, { wash = false }) -- disable washing money
						elseif CurrentAction == 'remove_entity' then
							NetworkRegisterEntityAsNetworked(CurrentActionData.entity)
							Citizen.Wait(100)           
															
							NetworkRequestControlOfEntity(CurrentActionData.entity)            

							if not IsEntityAMissionEntity(CurrentActionData.entity) then
								SetEntityAsMissionEntity(CurrentActionData.entity)        
							end

							Citizen.Wait(100)            
							DeleteEntity(CurrentActionData.entity)
						end
						
						CurrentAction = nil
					end
				end -- CurrentAction end
				
				if IsControlJustReleased(0, Keys['F6']) and not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'police_actions') then
					if PDConfig.MaxInService == -1 then
						OpenPoliceActionsMenu()
					elseif playerInService then
						OpenPoliceActionsMenu()
					else
						ESX.ShowNotification(_U('service_not'), 'error')
					end
				end
			else
				Citizen.Wait(500)
			end
		end
	end)
end





AddEventHandler('playerSpawned', function(spawn)
	isDead = false
	TriggerEvent('esx_policejob:unrestrain')
	
	if not hasAlreadyJoined then
		TriggerServerEvent('esx_policejob:spawned')
	end
	hasAlreadyJoined = true
end)

AddEventHandler('esx:onPlayerDeath', function(data)
	isDead = true
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		TriggerEvent('esx_policejob:unrestrain')
		TriggerEvent('esx_phone:removeSpecialContact', 'police')

		if PDConfig.MaxInService ~= -1 then
			TriggerServerEvent('esx_service:disableService', 'police')
		end
	end
end)

local send = true
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        local ped = PlayerPedId()
        if IsPedShooting(ped) and not IsPedCurrentWeaponSilenced(ped) and not inPaintBall and not inCapture and not inEvent and send then
            local playerCoords = GetEntityCoords(ped)
		    local streetName = GetStreetNameAtCoord(playerCoords.x, playerCoords.y, playerCoords.z)
		    local streetName2 = GetStreetNameFromHashKey(streetName)
            TriggerServerEvent("Parzival:ShotsAlarm", playerCoords.x, playerCoords.y, playerCoords.z, streetName2)
            send = false
            Citizen.Wait(10000)
            send = true
        end
    end
end)

RegisterNetEvent("Parzival:ShotsAlarm")
AddEventHandler("Parzival:ShotsAlarm", function(x, y, z, street)
	if ESX == nil then return end
    if PlayerData == nil or PlayerData.job == nil then return end
    if PlayerData.job.name ~= nil and PlayerData.job.name == "police" then
        SendNotifMani("~r~Tir Andazi ~w~Dar ~y~"..street)
        local alpha = 250
		local gunshotBlip = AddBlipForRadius(x, y, z, 50.0)
		SetBlipHighDetail(gunshotBlip, true)
		SetBlipColour(gunshotBlip, 1)
		SetBlipAlpha(gunshotBlip, alpha)
		SetBlipAsShortRange(gunshotBlip, true)
		while alpha ~= 0 do
			Citizen.Wait(7 * 4)
			alpha = alpha - 1
			SetBlipAlpha(gunshotBlip, alpha)
			if alpha == 0 then
				RemoveBlip(gunshotBlip)
				return
			end
		end
    end
end)

function SendNotifMani(msg)
	SetNotificationTextEntry('STRING')
	AddTextComponentString(msg)
	DrawNotification(0,1)
end

local coolbackup = false

AddEventHandler("onMultiplePress", function(keys)
	if keys["lshift"] and keys["y"] then
		if PlayerData.job.name == "police" and not coolbackup then
			coolbackup = true
			ExecuteCommand("me Darkhast BackUp Ersal Mikonad")
			SendBackup()
			Citizen.Wait(30000)
			coolbackup = false
		end
	end
end)

function SendBackup()
	ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(quantity)
		if quantity < 1 then
			ESX.ShowNotification("Shoma Radio Nadarid!", 'error')
			return
		end
	end, 'radio')
	local playerPed = PlayerPedId()
	local PedPosition = GetEntityCoords(playerPed)
	TriggerServerEvent("esx_policejob:sendBackUp", PedPosition.x, PedPosition.y, PedPosition.z)
end

RegisterNetEvent("esx_policejob:sendBackUp")
AddEventHandler("esx_policejob:sendBackUp", function(x, y, z)
	ESX.ShowNotification("Darkhast BackUp Jadid Recive Shod!", 'info')
    if PlayerData.job.name == "police" then
		local blip = AddBlipForCoord(x, y, z)
		SetBlipSprite (blip, 280)
		SetBlipDisplay(blip, 0.4)
		SetBlipScale  (blip, 2.0)
		SetBlipColour (blip, 1)
		SetBlipAsShortRange(blip, false)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("BackUp")
		EndTextCommandSetBlipName(blip)
		Citizen.Wait(60000)
		RemoveBlip(blip)
    end
end)

RegisterNetEvent("esx_policejob:send911")
AddEventHandler("esx_policejob:send911", function(name, x, y, z)
	local blip = AddBlipForCoord(x, y, z)
	SetBlipSprite (blip, 280)
	SetBlipDisplay(blip, 0.4)
	SetBlipScale  (blip, 2.0)
	SetBlipColour (blip, 3)
	SetBlipAsShortRange(blip, false)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(name)
	EndTextCommandSetBlipName(blip)
	Citizen.Wait(60000)
	RemoveBlip(blip)
end)