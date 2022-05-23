local CurrentAction, CurrentActionMsg, CurrentActionData = nil, '', {}

local HasAlreadyEnteredMarker, LastHospital, LastPart, LastPartNum

local IsBusy, Ended = false, false

local spawnedVehicles, isInShopMenu = {}, false

local ASTimer = 0

function OpenAmbulanceActionsMenu()

	local elements = {

		{label = _U('cloakroom'), value = 'cloakroom'}

	}

	if AmbulanceConfig.EnablePlayerManagement and ESX.PlayerData.job.grade_name == 'boss' then

		table.insert(elements, {label = _U('boss_actions'), value = 'boss_actions'})

	end



	ESX.UI.Menu.CloseAll()



	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'ambulance_actions', {

		title    = _U('ambulance'),

		align    = 'right',

		elements = elements

	}, function(data, menu)

		if data.current.value == 'cloakroom' then

			OpenCloakroomMenu()

		elseif data.current.value == 'boss_actions' then

			TriggerEvent('esx_society:openBossMenu', 'ambulance', function(data, menu)

				menu.close()

			end, {wash = false})

		end

	end, function(data, menu)

		menu.close()

	end)

end

function OpenMobileAmbulanceActionsMenu()

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mobile_ambulance_actions', {
		title    = _U('ambulance'),
		align    = 'right',
		elements = {
			{label = _U('ems_menu'), value = 'citizen_interaction'},
			{label = ('Request List'),   value = 'req_list'},
			{label = ('Actions'),   value = 'actions'},
			{label = ('Livery'),   value = 'livery'},
		}
	}, function(data, menu)
		if data.current.value == 'req_list' then
			ESX.UI.Menu.CloseAll()
			ExecuteCommand("areqs")
		elseif data.current.value == 'livery' then
			ESX.UI.Menu.CloseAll()
			ExecuteCommand("livery")
		elseif data.current.value == 'actions' then
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_interaction', {
				title    = _U('ems_menu_title'),
				align    = 'right',
				elements = {
					{label = 'Drag',   value = 'drag'},
					{label = 'Put In Vehicle',   value = 'piv'},
					{label = 'Put Out Vehicle',   value = 'pov'}
				}
			}, function(data, menu)
				if data.current.value == 'drag' then
					TriggerEvent('drag')
				elseif data.current.value == 'piv' then
					TriggerEvent('PutInVeh')
				elseif data.current.value == 'pov' then
					TriggerEvent('PutOutVeh')
				end
			end, function(data, menu)
				menu.close()
			end)
		elseif data.current.value == 'citizen_interaction' then
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_interaction', {
				title    = _U('ems_menu_title'),
				align    = 'right',
				elements = {
					{label = _U('ems_menu_revive'), value = 'revive'},
					{label = _U('ems_menu_small'), value = 'small'},
					{label = _U('ems_menu_big'), value = 'big'},
					{label = 'Jerahat',   value = 'jrh'}
				}
			}, function(data, menu)
				if IsBusy then return end

				local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

				if closestPlayer == -1 then
					ESX.ShowNotification(_U('no_players'), 'error')
				else

					if data.current.value == 'revive' then
						if GetGameTimer() - ASTimer > 500 then
							IsBusy = true
							ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(quantity)
								if quantity > 0 then
									local closestPlayerPed = GetPlayerPed(closestPlayer)
									ESX.TriggerServerCallback("esx:checkInjure", function(IsDead)
										if IsDead ~= false and IsDead ~= 'done' then
											ESX.UI.Menu.CloseAll()
											local camanimDict = "mini@cpr@char_a@cpr_def"
											local camanimDict1 = "mini@cpr@char_a@cpr_str"
											local playerPed = GetPlayerPed(-1)
											

											TriggerServerEvent('esx_ambulancejob:syncDaadBady', PedToNet(GetPlayerPed(-1)),GetPlayerServerId(closestPlayer))
											Ended = false
											Citizen.CreateThread(function()
												while not Ended do
													Wait(0)
													DisableControlAction(0, Keys['F1'],true)
													DisableControlAction(0, Keys['F2'],true)
													DisableControlAction(0, Keys['F3'],true)
													DisableControlAction(0, Keys['F5'],true)
													DisableControlAction(0, Keys['R'], true)
													DisableControlAction(0, Keys['W'],true)
													DisableControlAction(0, Keys['S'],true)
													DisableControlAction(0, Keys['A'],true)
													DisableControlAction(0, Keys['D'], true)
													DisableControlAction(0, Keys['X'], true)
													DisableControlAction(0, Keys['SPACE'], true)
													DisableControlAction(0, 24, true) -- Attack
													DisableControlAction(0, 257, true) -- Attack 2
													DisableControlAction(0, 25, true) -- Right click
													DisableControlAction(0, 47, true)  -- Disable weapon
													DisableControlAction(0, 264, true) -- Disable melee
													DisableControlAction(0, 257, true) -- Disable melee
													DisableControlAction(0, 140, true) -- Disable melee
													DisableControlAction(0, 141, true) -- Disable melee
													DisableControlAction(0, 142, true) -- Disable melee
													DisableControlAction(0, 143, true) -- Disable melee
													DisableControlAction(0, 263, true) -- Melee Attack 1
													DisableControlAction(0, 27, true) -- Arrow up
												end
											end)
											ESX.Streaming.RequestAnimDict(camanimDict1)
											ESX.Streaming.RequestAnimDict(camanimDict, function()
												Citizen.Wait(500)		
												TaskPlayAnim(playerPed, camanimDict, "cpr_intro", 8.0, 8.0, -1, 0, 0, false, false, false)
												Citizen.Wait(10800)
												Citizen.Wait(5000)
												TaskPlayAnim(playerPed, camanimDict1, "cpr_pumpchest", 8.0, 8.0, -1, 1, 0, false, false, false)
												Citizen.Wait(5000)
												TaskPlayAnim(playerPed, camanimDict1, "cpr_success", 8.0, 8.0, -1, 0, 0, false, false, false)
												Citizen.Wait(28600)
												Ended = true
											end)
											ESX.ShowNotification(_U('revive_inprogress'))
											TriggerServerEvent('esx_ambulancejob:removeItem', 'medikit')
											TriggerServerEvent('esx_ambulancejob:reviveavermani', GetPlayerServerId(closestPlayer))

											-- Show revive award?
											if AmbulanceConfig.ReviveReward > 0 then
												ESX.ShowNotification(_U('revive_complete_award', GetPlayerName(closestPlayer), AmbulanceConfig.ReviveReward))
											else
												ESX.ShowNotification(_U('revive_complete', GetPlayerName(closestPlayer)))
											end
										else
											ESX.ShowNotification(_U('player_not_unconscious'))
										end
									end, GetPlayerServerId(closestPlayer))
								else
									ESX.ShowNotification(_U('not_enough_medikit'))
								end

								IsBusy = false

							end, 'medikit')
						else
							ESX.ShowNotification('~h~~r~Lotfan Spam Nakonid !')
						end
						ASTimer = GetGameTimer()
					elseif data.current.value == 'jrh' then
						ExecuteCommand("jerahat")
					elseif data.current.value == 'small' then

						ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(quantity)
							if quantity > 0 then
								local closestPlayerPed = GetPlayerPed(closestPlayer)
								local health = GetEntityHealth(closestPlayerPed)

								if health > 0 then
									local playerPed = PlayerPedId()

									IsBusy = true
									ESX.ShowNotification(_U('heal_inprogress'))
									TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
									Citizen.Wait(10000)
									ClearPedTasks(playerPed)

									TriggerServerEvent('esx_ambulancejob:removeItem', 'bandage')
									TriggerServerEvent('esx_ambulancejob:heal', GetPlayerServerId(closestPlayer), 'small')
									ESX.ShowNotification(_U('heal_complete', GetPlayerName(closestPlayer)))
									IsBusy = false
								else
									ESX.ShowNotification(_U('player_not_conscious'))
								end
							else
								ESX.ShowNotification(_U('not_enough_bandage'))
							end
						end, 'bandage')

					elseif data.current.value == 'big' then

						ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(quantity)
							if quantity > 0 then
								local closestPlayerPed = GetPlayerPed(closestPlayer)
								local health = GetEntityHealth(closestPlayerPed)

								if health > 0 then
									local playerPed = PlayerPedId()

									IsBusy = true
									ESX.ShowNotification(_U('heal_inprogress'))
									TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
									Citizen.Wait(10000)
									ClearPedTasks(playerPed)

									TriggerServerEvent('esx_ambulancejob:removeItem', 'medikit')
									TriggerServerEvent('esx_ambulancejob:heal', GetPlayerServerId(closestPlayer), 'big')
									ESX.ShowNotification(_U('heal_complete', GetPlayerName(closestPlayer)))
									IsBusy = false
								else
									ESX.ShowNotification(_U('player_not_conscious'))
								end
							else
								ESX.ShowNotification(_U('not_enough_medikit'))
							end
						end, 'medikit')
					end
				end
			end, function(data, menu)
				menu.close()
			end)
		end

	end, function(data, menu)
		menu.close()
	end)
end



function FastTravel(coords, heading)

	local playerPed = PlayerPedId()



	DoScreenFadeOut(800)



	while not IsScreenFadedOut() do

		Citizen.Wait(500)

	end



	ESX.Game.Teleport(playerPed, coords, function()

		DoScreenFadeIn(800)



		if heading then

			SetEntityHeading(playerPed, heading)

		end

	end)

end

-- Draw markers & Marker logic

Citizen.CreateThread(function()

	while true do

		Citizen.Wait(0)

		local playerCoords = GetEntityCoords(PlayerPedId())

		local letSleep, isInMarker, hasExited = true, false, false

		local currentHospital, currentPart, currentPartNum



		for hospitalNum,hospital in pairs(AmbulanceConfig.Hospitals) do



			-- Ambulance Actions

			for k,v in ipairs(hospital.AmbulanceActions) do

				local distance = GetDistanceBetweenCoords(playerCoords, v, true)



				if distance < AmbulanceConfig.DrawDistance then
					if ESX.PlayerData.job and ESX.PlayerData.job.name == 'ambulance' then

						DrawMarker(AmbulanceConfig.Marker.type, v, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, AmbulanceConfig.Marker.x, AmbulanceConfig.Marker.y, AmbulanceConfig.Marker.z, AmbulanceConfig.Marker.r, AmbulanceConfig.Marker.g, AmbulanceConfig.Marker.b, AmbulanceConfig.Marker.a, false, false, 2, AmbulanceConfig.Marker.rotate, nil, nil, false)

						letSleep = false
					end

				end



				if distance < AmbulanceConfig.Marker.x then

					isInMarker, currentHospital, currentPart, currentPartNum = true, hospitalNum, 'AmbulanceActions', k

				end

			end



			-- Pharmacies

			for k,v in ipairs(hospital.Pharmacies) do

				local distance = GetDistanceBetweenCoords(playerCoords, v, true)



				if distance < AmbulanceConfig.DrawDistance then
					if ESX.PlayerData.job and ESX.PlayerData.job.name == 'ambulance' then

						DrawMarker(AmbulanceConfig.Marker.type, v, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, AmbulanceConfig.Marker.x, AmbulanceConfig.Marker.y, AmbulanceConfig.Marker.z, AmbulanceConfig.Marker.r, AmbulanceConfig.Marker.g, AmbulanceConfig.Marker.b, AmbulanceConfig.Marker.a, false, false, 2, AmbulanceConfig.Marker.rotate, nil, nil, false)
						
						letSleep = false
					end

				end



				if distance < AmbulanceConfig.Marker.x then

					isInMarker, currentHospital, currentPart, currentPartNum = true, hospitalNum, 'Pharmacy', k

				end

			end



			-- Vehicle Spawners

			for k,v in ipairs(hospital.Vehicles) do

				local distance = GetDistanceBetweenCoords(playerCoords, v.Spawner, true)



				if distance < AmbulanceConfig.DrawDistance then
					if ESX.PlayerData.job and ESX.PlayerData.job.name == 'ambulance' then

						DrawMarker(v.Marker.type, v.Spawner, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.Marker.x, v.Marker.y, v.Marker.z, v.Marker.r, v.Marker.g, v.Marker.b, v.Marker.a, false, false, 2, v.Marker.rotate, nil, nil, false)
						
						letSleep = false
					end

				end



				if distance < v.Marker.x then

					isInMarker, currentHospital, currentPart, currentPartNum = true, hospitalNum, 'Vehicles', k

				end

			end

			-- Vehicle Spawners

			for k,v in ipairs(hospital.VehiclesDeleter) do

				local distance = GetDistanceBetweenCoords(playerCoords, v.Deleter, true)



				if distance < AmbulanceConfig.DrawDistance then
					if ESX.PlayerData.job and ESX.PlayerData.job.name == 'ambulance' then

						DrawMarker(v.Marker.type, v.Deleter, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.Marker.x, v.Marker.y, v.Marker.z, v.Marker.r, v.Marker.g, v.Marker.b, v.Marker.a, false, false, 2, v.Marker.rotate, nil, nil, false)
						
						letSleep = false
					end

				end



				if distance < v.Marker.x then

					isInMarker, currentHospital, currentPart, currentPartNum = true, hospitalNum, 'VehiclesDeleter', k

				end

			end



			-- Fast Travels

			for k,v in ipairs(hospital.FastTravels) do

				local distance = GetDistanceBetweenCoords(playerCoords, v.From, true)



				if distance < AmbulanceConfig.DrawDistance then
					if ESX.PlayerData.job and ESX.PlayerData.job.name == 'ambulance' then

						DrawMarker(v.Marker.type, v.From, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.Marker.x, v.Marker.y, v.Marker.z, v.Marker.r, v.Marker.g, v.Marker.b, v.Marker.a, false, false, 2, v.Marker.rotate, nil, nil, false)
						
						letSleep = false
					end

				end





				if distance < v.Marker.x then

					FastTravel(v.To.coords, v.To.heading)

				end

			end



			-- Fast Travels (Prompt)

			for k,v in ipairs(hospital.FastTravelsPrompt) do

				local distance = GetDistanceBetweenCoords(playerCoords, v.From, true)



				if distance < AmbulanceConfig.DrawDistance then
					if ESX.PlayerData.job and ESX.PlayerData.job.name == 'ambulance' then

						DrawMarker(v.Marker.type, v.From, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.Marker.x, v.Marker.y, v.Marker.z, v.Marker.r, v.Marker.g, v.Marker.b, v.Marker.a, false, false, 2, v.Marker.rotate, nil, nil, false)
						
						letSleep = false
					end

				end



				if distance < v.Marker.x then

					isInMarker, currentHospital, currentPart, currentPartNum = true, hospitalNum, 'FastTravelsPrompt', k

				end

			end



		end



		-- Logic for exiting & entering markers

		if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and (LastHospital ~= currentHospital or LastPart ~= currentPart or LastPartNum ~= currentPartNum)) then



			if

				(LastHospital ~= nil and LastPart ~= nil and LastPartNum ~= nil) and

				(LastHospital ~= currentHospital or LastPart ~= currentPart or LastPartNum ~= currentPartNum)

			then

				TriggerEvent('esx_ambulancejob:hasExitedMarker', LastHospital, LastPart, LastPartNum)

				hasExited = true

			end



			HasAlreadyEnteredMarker, LastHospital, LastPart, LastPartNum = true, currentHospital, currentPart, currentPartNum



			TriggerEvent('esx_ambulancejob:hasEnteredMarker', currentHospital, currentPart, currentPartNum)



		end



		if not hasExited and not isInMarker and HasAlreadyEnteredMarker then

			HasAlreadyEnteredMarker = false

			TriggerEvent('esx_ambulancejob:hasExitedMarker', LastHospital, LastPart, LastPartNum)

		end



		if letSleep then

			Citizen.Wait(500)

		end

	end

end)

-- Key Controls

Citizen.CreateThread(function()

	while true do

		Citizen.Wait(0)



		if CurrentAction then

			ESX.ShowHelpNotification(CurrentActionMsg)



			if IsControlJustReleased(0, Keys['E']) then



				if CurrentAction == 'AmbulanceActions' then

					OpenAmbulanceActionsMenu()

				elseif CurrentAction == 'Pharmacy' then

					OpenPharmacyMenu()

				elseif CurrentAction == 'Vehicles' then

					OpenVehicleSpawnerMenu(CurrentActionData.hospital, CurrentActionData.partNum)

				elseif CurrentAction == 'VehiclesDeleter' then
					print(CurrentActionData.vehicle)
					ESX.Game.DeleteVehicle(CurrentActionData.vehicle)

				elseif CurrentAction == 'FastTravelsPrompt' then

					FastTravel(CurrentActionData.to, CurrentActionData.heading)

				end



				CurrentAction = nil



			end



		elseif ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'ambulance' and ESX.PlayerData.job.grade >= 0 and not IsDead then

			if IsControlJustReleased(0, Keys['F6']) then

				OpenMobileAmbulanceActionsMenu()

			end

		else

			Citizen.Wait(500)

		end

	end

end)

RegisterNetEvent('esx_ambulancejob:finishCRP')
AddEventHandler('esx_ambulancejob:finishCRP', function(ped, target)
	local NersPed 	= NetToPed(ped)
	local PlayerPed = GetPlayerPed(-1)
	local coords    = GetEntityCoords(PlayerPed)
	local head 		= GetEntityHeading(PlayerPed)

	local targetPlayer = GetPlayerFromServerId(target)
	local targetPed = GetPlayerPed(targetPlayer)
	if GetDistanceBetweenCoords(GetEntityCoords(targetPed), coords) <= 10.0 then			
		local camanimDict = "mini@cpr@char_b@cpr_def"
		local camanimDict1 = "mini@cpr@char_b@cpr_str"
		local loadedanim = false

		beingRevived = true
		ESX.Streaming.RequestAnimDict(camanimDict1)
		ESX.Streaming.RequestAnimDict(camanimDict, function()
			loadedanim = true
		end)

		while not loadedanim do
			Citizen.Wait(5)
		end

		ClearPedTasksImmediately(PlayerPed)
		AttachEntityToEntity(PlayerPed, NersPed, 28422, -0.1, 1.15, 0.0, 0.0, 0.0, 75.0, false, false, false, true, 2, true)
		
		TaskPlayAnim(PlayerPed, camanimDict, "cpr_intro", 8.0, 8.0, -1, 0, 0, false, false, false)
		Citizen.Wait(800)
		DetachEntity(PlayerPed, true, false)
		Citizen.Wait(15000)
		TaskPlayAnim(PlayerPed, camanimDict1, "cpr_pumpchest", 8.0, 8.0, -1, 1, 0, false, false, false)
		Citizen.Wait(5000)
		TaskPlayAnim(PlayerPed, camanimDict1, "cpr_success", 8.0, 8.0, -1, 0, 0, false, false, false)
		Citizen.Wait(28600)
		--ClearPedTasksImmediately(NersPed)
		ClearPedTasksImmediately(PlayerPed)
	end
end)

AddEventHandler('esx_ambulancejob:hasEnteredMarker', function(hospital, part, partNum)

	if ESX.PlayerData.job and ESX.PlayerData.job.name == 'ambulance' and ESX.PlayerData.job.grade >= 0 then

		if part == 'AmbulanceActions' then

			CurrentAction = part

			CurrentActionMsg = _U('actions_prompt')

			CurrentActionData = {}

		elseif part == 'Pharmacy' then

			CurrentAction = part

			CurrentActionMsg = _U('open_pharmacy')

			CurrentActionData = {}

		elseif part == 'Vehicles' then

			CurrentAction = part

			CurrentActionMsg = _U('garage_prompt')

			CurrentActionData = {hospital = hospital, partNum = partNum}

		elseif part == 'VehiclesDeleter' then

			if IsPedInAnyVehicle(GetPlayerPed(-1),  false) then

				local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
		  
				if DoesEntityExist(vehicle) then
				  CurrentAction     = 'VehiclesDeleter'
				  CurrentActionMsg  = 'press ~INPUT_CONTEXT~ to delete vehicle'
				  CurrentActionData = {vehicle = vehicle}
				end
		  
			end

		elseif part == 'FastTravelsPrompt' then

			local travelItem = AmbulanceConfig.Hospitals[hospital][part][partNum]



			CurrentAction = part

			CurrentActionMsg = travelItem.Prompt

			CurrentActionData = {to = travelItem.To.coords, heading = travelItem.To.heading}

		end

	end

end)



AddEventHandler('esx_ambulancejob:hasExitedMarker', function(hospital, part, partNum)

	if not isInShopMenu then

		ESX.UI.Menu.CloseAll()

	end



	CurrentAction = nil

end)

function OpenCloakroomMenu()
	local elements = {}
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

			table.insert(elements, {label = "Outfits", value = 'custom'})
			table.insert(elements, {label = _U('ems_clothes_ems'), value = 'cadet_wear'})

			if #divs > 0 then
				for _,v in ipairs(divs) do
					table.insert(elements, {label = v.name, value = v.name, suit = v.outfit})
				end
			end

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cloakroom', {

				title    = _U('cloakroom'),

				align    = 'right',

				elements = elements

			}, function(data, menu)

				if data.current.value == 'custom' then
					TriggerEvent('PX_clothing:client:openOutfitMenu')
				elseif data.current.value == 'cadet_wear' then

					local job =  ESX.PlayerData.job.name
					local gradenum =  ESX.PlayerData.job.grade

					ESX.TriggerServerCallback('Proxtended:getGender', function(skin)
						ESX.TriggerServerCallback('esx_society:getUniforms', function(SkinMale, SkinFemale)-- get uniform from esx_society
							if skin.sex == 0 then
								TriggerEvent('PX_clothing:client:loadOutfit', SkinMale)
							else
								TriggerEvent('PX_clothing:client:loadOutfit', SkinFemale)
							end
						end, gradenum, job)
					end)
				else
					TriggerEvent('PX_clothing:client:loadOutfit', data.current.suit)
				end



				menu.close()

			end, function(data, menu)

				menu.close()

			end)
		end)
	end)

end



function OpenVehicleSpawnerMenu(hospital, partNum)
	local grade = ESX.PlayerData.job.grade
	local job = ESX.PlayerData.job.name
	ESX.TriggerServerCallback('esx_society:getmyDivVehicles', function(divVehs)
		ESX.TriggerServerCallback("esx_society:getVehicles", function(Cars)
			local elements = {}
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
					ESX.ShowNotification("~y~Shoma Be Hich Mashini Dastresi Nadarid")
					return
				end
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_spawner',
				{
					title    = _U('garage_title'),
					align    = 'right',
					elements = elements
				}, function(data, menu)
					menu.close()
					local model   = data.current.model
					local foundSpawn, spawnPoint = GetAvailableVehicleSpawnPoint(hospital, 'Vehicles', partNum)
					local playerPed = PlayerPedId()
					if foundSpawn then
						if model == "emsair" then
							ESX.Game.SpawnVehicle(model, spawnPoint.heli, spawnPoint.heading, function(vehicle)
								TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
								TriggerServerEvent("garage:addKeys", GetVehicleNumberPlateText(vehicle), GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
								Citizen.Wait(2000)
								SetVehicleFuelLevel(vehicle, 100.0)
							end)
						else
							ESX.Game.SpawnVehicle(model, spawnPoint.coords, spawnPoint.heading, function(vehicle)
								TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
								SetVehicleMods(vehicle, false, nil, nil, nil)
								TriggerServerEvent("garage:addKeys", GetVehicleNumberPlateText(vehicle), GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
								Citizen.Wait(2000)
								SetVehicleFuelLevel(vehicle, 100.0)
							end)
						end
					else
						ESX.ShowNotification(_U('garage_notavailable'))
					end
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



function StoreNearbyVehicle(playerCoords)

	local vehicles, vehiclePlates = ESX.Game.GetVehiclesInArea(playerCoords, 30.0), {}



	if #vehicles > 0 then

		for k,v in ipairs(vehicles) do



			-- Make sure the vehicle we're saving is empty, or else it wont be deleted

			if GetVehicleNumberOfPassengers(v) == 0 and IsVehicleSeatFree(v, -1) then

				table.insert(vehiclePlates, {

					vehicle = v,

					plate = ESX.Math.Trim(GetVehicleNumberPlateText(v))

				})

			end

		end

	else

		ESX.ShowNotification(_U('garage_store_nearby'))

		return

	end



	ESX.TriggerServerCallback('esx_ambulancejob:storeNearbyVehicle', function(storeSuccess, foundNum)

		if storeSuccess then

			local vehicleId = vehiclePlates[foundNum]

			local attempts = 0

			ESX.Game.DeleteVehicle(vehicleId.vehicle)

			IsBusy = true



			Citizen.CreateThread(function()

				while IsBusy do

					Citizen.Wait(0)

					drawLoadingText(_U('garage_storing'), 255, 255, 255, 255)

				end

			end)



			-- Workaround for vehicle not deleting when other players are near it.

			while DoesEntityExist(vehicleId.vehicle) do

				Citizen.Wait(500)

				attempts = attempts + 1



				-- Give up

				if attempts > 30 then

					break

				end



				vehicles = ESX.Game.GetVehiclesInArea(playerCoords, 30.0)

				if #vehicles > 0 then

					for k,v in ipairs(vehicles) do

						if ESX.Math.Trim(GetVehicleNumberPlateText(v)) == vehicleId.plate then

							ESX.Game.DeleteVehicle(v)

							break

						end

					end

				end

			end



			IsBusy = false

			ESX.ShowNotification(_U('garage_has_stored'))

		else

			ESX.ShowNotification(_U('garage_has_notstored'))

		end

	end, vehiclePlates)

end



function GetAvailableVehicleSpawnPoint(hospital, part, partNum)

	local spawnPoints = AmbulanceConfig.Hospitals[hospital][part][partNum].SpawnPoints

	local found, foundSpawnPoint = false, nil



	for i=1, #spawnPoints, 1 do

		if ESX.Game.IsSpawnPointClear(spawnPoints[i].coords, spawnPoints[i].radius) then

			found, foundSpawnPoint = true, spawnPoints[i]

			break

		end

	end



	if found then

		return true, foundSpawnPoint

	else

		ESX.ShowNotification(_U('garage_blocked'))

		return false

	end

end



function OpenShopMenu(elements, restoreCoords, shopCoords)

	local playerPed = PlayerPedId()

	isInShopMenu = true



	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_shop', {

		title    = _U('vehicleshop_title'),

		align    = 'right',

		elements = elements

	}, function(data, menu)



		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_shop_confirm', {

			title    = _U('vehicleshop_confirm', data.current.name, data.current.price),

			align    = 'right',

			elements = {

				{ label = _U('confirm_no'), value = 'no' },

				{ label = _U('confirm_yes'), value = 'yes' }

			}

		}, function(data2, menu2)



			if data2.current.value == 'yes' then

				local newPlate = exports['PX_vehicleshop']:GeneratePlate()

				local vehicle  = GetVehiclePedIsIn(playerPed, false)

				local props    = ESX.Game.GetVehicleProperties(vehicle)

				props.plate    = newPlate



				ESX.TriggerServerCallback('esx_ambulancejob:buyJobVehicle', function (bought)

					if bought then

						ESX.ShowNotification(_U('vehicleshop_bought', data.current.name, ESX.Math.GroupDigits(data.current.price)))



						isInShopMenu = false

						ESX.UI.Menu.CloseAll()

				

						DeleteSpawnedVehicles()

						FreezeEntityPosition(playerPed, false)

						SetEntityVisible(playerPed, true)

				

						ESX.Game.Teleport(playerPed, restoreCoords)

					else

						ESX.ShowNotification(_U('vehicleshop_money'))

						menu2.close()

					end

				end, props, data.current.type)

			else

				menu2.close()

			end



		end, function(data2, menu2)

			menu2.close()

		end)



		end, function(data, menu)

		isInShopMenu = false

		ESX.UI.Menu.CloseAll()



		DeleteSpawnedVehicles()

		FreezeEntityPosition(playerPed, false)

		SetEntityVisible(playerPed, true)



		ESX.Game.Teleport(playerPed, restoreCoords)

	end, function(data, menu)

		DeleteSpawnedVehicles()



		WaitForVehicleToLoad(data.current.model)

		ESX.Game.SpawnLocalVehicle(data.current.model, shopCoords, 0.0, function(vehicle)

			table.insert(spawnedVehicles, vehicle)

			TaskWarpPedIntoVehicle(playerPed, vehicle, -1)

			FreezeEntityPosition(vehicle, true)

		end)

	end)



	WaitForVehicleToLoad(elements[1].model)

	ESX.Game.SpawnLocalVehicle(elements[1].model, shopCoords, 0.0, function(vehicle)

		table.insert(spawnedVehicles, vehicle)

		TaskWarpPedIntoVehicle(playerPed, vehicle, -1)

		FreezeEntityPosition(vehicle, true)

	end)

end



Citizen.CreateThread(function()

	while true do

		Citizen.Wait(0)



		if isInShopMenu then

			DisableControlAction(0, 75, true)  -- Disable exit vehicle

			DisableControlAction(27, 75, true) -- Disable exit vehicle

		else

			Citizen.Wait(500)

		end

	end

end)



function DeleteSpawnedVehicles()

	while #spawnedVehicles > 0 do

		local vehicle = spawnedVehicles[1]

		ESX.Game.DeleteVehicle(vehicle)

		table.remove(spawnedVehicles, 1)

	end

end



function WaitForVehicleToLoad(modelHash)

	modelHash = (type(modelHash) == 'number' and modelHash or GetHashKey(modelHash))



	if not HasModelLoaded(modelHash) then

		RequestModel(modelHash)



		while not HasModelLoaded(modelHash) do

			Citizen.Wait(0)



			DisableControlAction(0, Keys['TOP'], true)

			DisableControlAction(0, Keys['DOWN'], true)

			DisableControlAction(0, Keys['LEFT'], true)

			DisableControlAction(0, Keys['RIGHT'], true)

			DisableControlAction(0, 176, true) -- ENTER key

			DisableControlAction(0, Keys['BACKSPACE'], true)



			drawLoadingText(_U('vehicleshop_awaiting_model'), 255, 255, 255, 255)

		end

	end

end



function drawLoadingText(text, red, green, blue, alpha)

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



function OpenPharmacyMenu()

	ESX.UI.Menu.CloseAll()



	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'pharmacy', {

		title    = _U('pharmacy_menu_title'),

		align    = 'top-left',

		elements = {

			{label = "Self Stash",     value = 'stash'},
			{label = "Shop",     value = 'shop'}
		}

	}, function(data, menu)

		if data.current.value == 'stash' then
			TriggerServerEvent("PX_inventory:server:OpenInventory", "stash", "personalsafe_"..ESX.GetPlayerData().job.name..'_'..ESX.GetPlayerData().identifier)
            TriggerEvent("PX_inventory:client:SetCurrentStash", "personalsafe_"..ESX.GetPlayerData().job.name..'_'..ESX.GetPlayerData().identifier)
		elseif data.current.value == 'shop' then
			TriggerServerEvent("PX_inventory:server:OpenInventory", "shop", "ambulance", AmbulanceConfig.Items)
		end

	end, function(data, menu)

		menu.close()

	end)

end


function WarpPedInClosestVehicle(ped)

	local coords = GetEntityCoords(ped)



	local vehicle, distance = ESX.Game.GetClosestVehicle(coords)



	if distance ~= -1 and distance <= 5.0 then

		local maxSeats, freeSeat = GetVehicleMaxNumberOfPassengers(vehicle)



		for i=maxSeats - 1, 0, -1 do

			if IsVehicleSeatFree(vehicle, i) then

				freeSeat = i

				break

			end

		end



		if freeSeat then

			TaskWarpPedIntoVehicle(ped, vehicle, freeSeat)

		end

	else

		ESX.ShowNotification(_U('no_vehicles'))

	end

end



RegisterNetEvent('esx_ambulancejob:heal')

AddEventHandler('esx_ambulancejob:heal', function(healType, quiet)

	local playerPed = PlayerPedId()

	local maxHealth = GetEntityMaxHealth(playerPed)



	if healType == 'small' then

		local health = GetEntityHealth(playerPed)

		local newHealth = math.min(maxHealth, math.floor(health + maxHealth / 8))

		SetEntityHealth(playerPed, newHealth)

	elseif healType == 'big' then

		SetEntityHealth(playerPed, maxHealth)

	end



	if not quiet then

		ESX.ShowNotification(_U('healed'))

	end

end)



function SetVehicleMods(vehicle, color, colorA, colorB, colorC)

	

	local props = {}



	if not color then



		props = {

			modEngine       =   3,

			modBrakes       =   2,

			windowTint      =   -1,

			modArmor        =   4,

			modTransmission =   2,

			modSuspension   =   -1,

			modTurbo        =   true,

		}



	else



		props = {

			modEngine       =   3,

			modBrakes       =   2,

			windowTint      =   -1,

			modArmor        =   4,

			modTransmission =   2,

			modSuspension   =   -1,

			color1 = colorA,

			color2 = colorB,

			pearlescentColor = colorC,

			modTurbo        =   true,

		}

	

	end

	



	ESX.Game.SetVehicleProperties(vehicle, props)

	SetVehicleDirtLevel(vehicle, 0.0)

end