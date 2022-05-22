ESX = nil
local carrying = false
local isDead = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

AddEventHandler('esx:onPlayerDeath', function(data)
	isDead = true
end)

AddEventHandler('playerSpawned', function(spawn)
	isDead = false
end)

RegisterCommand('carry', function(source, args, user)
	if not IsPedInAnyVehicle(PlayerPedId(), false) then
		if not carrying then
			local coords = GetEntityCoords(GetPlayerPed(-1))
			local target, distance = ESX.Game.GetClosestPlayer()
			if GetDistanceBetweenCoords(coords, tcoords, true) < 3 then
				TriggerServerEvent('PX_Carry:sendRequest', target)
			else
				TriggerEvent('chatMessage', "[ System ] : ", {255, 0, 0}, "^0Player mored nazar nazdik Shoma nist")
			end
		else
			TriggerEvent('chatMessage', "[ System ] : ", {255, 0, 0}, "^0Shoma dar hal hazer carry darid")
		end
	else
		TriggerEvent('chatMessage', "[ System ] : ", {255, 0, 0}, "^0Shoma dar mashin nemitavanid carry konid!")
	end
end, false)


RegisterNetEvent("PX_Carry:AskToCarry")
AddEventHandler("PX_Carry:AskToCarry", function(requestID)
	if not isDead then
		AskAbout(requestID)
	else
		ESX.ShowNotification("Vaghti Dead Hastid Carry Nemishavid, Az Drag Estefade Konid!", 'error')
		TriggerServerEvent("PX_Carry:DeclineCarry", requestID)
	end
end)

function AskAbout(requestID)
	ESX.UI.Menu.Open('question', GetCurrentResourceName(), 'carry',
	{
		title 	 = 'Darkhast Carry',
		align    = 'center',
		question = "Yek Shakhs Darkhast Carry Shoma Ra Darad! Aya Ghabool Mikonid?",
		elements = {
			{label = 'Bale', value = 'yes'},
			{label = 'Kheyr', value = 'no'},
		}
	}, function(data, menu)
		if data.current.value == "yes" then
			TriggerServerEvent("PX_Carry:AcceptCarry", requestID)
			menu.close()
		elseif data.current.value == "no" then
			TriggerServerEvent("PX_Carry:DeclineCarry", requestID)
			menu.close()
		end
	end)
end

RegisterNetEvent('carry:syncTarget')
AddEventHandler('carry:syncTarget', function(target)
	local playerPed = GetPlayerPed(-1)
	local targetPed = GetPlayerPed(GetPlayerFromServerId(target))
	carrying = true
	TriggerEvent("animthread", true)
	TriggerEvent('esx:showNotification', 'Press E to release carry.')
	AttachEntityToEntity(GetPlayerPed(-1), targetPed, 1, -0.68, -0.2, 0.94, 180.0, 180.0, 60.0, 1, 1, 0, 1, 0, 1)
	Citizen.CreateThread(function()
		while carrying do
			Citizen.Wait(99)
			DisableControlAction(1, 19, true)
			DisableControlAction(0, 34, true)
			DisableControlAction(0, 9, true)
			DisableControlAction(0, 288, true)
			DisableControlAction(0, 289, true)
			DisableControlAction(0, 170, true)
			DisableControlAction(0, 73, true)
			DisableControlAction(0, 79, true)
			DisableControlAction(0, 305, true)
			DisableControlAction(0, 82, true)
			DisableControlAction(0, 182, true)
			DisableControlAction(0, 32, true)
			DisableControlAction(0, 8, true)
			DisableControlAction(2, 31, true)
			DisableControlAction(2, 32, true)
			DisableControlAction(1, 33, true)
			DisableControlAction(1, 34, true)
			DisableControlAction(1, 35, true)
			DisableControlAction(1, 21, true)
			DisableControlAction(1, 22, true)
			DisableControlAction(1, 23, true)
			DisableControlAction(1, 24, true)
			DisableControlAction(1, 25, true)
			DisableControlAction(1, 106, true) -- VehicleMouseControlOverride
			DisableControlAction(1, 140, true) --Disables Melee Actions
			DisableControlAction(1, 141, true) --Disables Melee Actions
			DisableControlAction(1, 142, true) --Disables Melee Actions 
			DisableControlAction(1, 37, true) --Disables INPUT_SELECT_WEAPON (tab) Actions
			DisablePlayerFiring(playerPed, true) -- Disable weapon firing
			if not IsEntityPlayingAnim(playerPed, "amb@world_human_bum_slumped@male@laying_on_left_side@base", "base", 3) then
				loadAnim("amb@world_human_bum_slumped@male@laying_on_left_side@base")
				TaskPlayAnim(playerPed, "amb@world_human_bum_slumped@male@laying_on_left_side@base", "base", 8.0, 8.0, -1, 1, 999.0, 0, 0, 0)
			end
			Citizen.Wait(1)
		end
	end)
	Citizen.CreateThread(function()
		while carrying do
			Citizen.Wait(0)
			if IsControlJustPressed(0, 38) then
				carrying = false
				ClearPedTasks(GetPlayerPed(-1))
				DetachEntity(GetPlayerPed(-1), true, false)
				TriggerServerEvent("carry:stop", target)
			end
		end
	end)
end)


RegisterNetEvent('carry:syncMe')
AddEventHandler('carry:syncMe', function(id)
	local playerPed = GetPlayerPed(-1)
	TriggerEvent('esx:showNotification', 'Press E to release carry.')
	carrying = true
	Citizen.CreateThread(function()
		while carrying do
			Citizen.Wait(99)
			if not IsEntityPlayingAnim(playerPed, "missfinale_c2mcs_1", "fin_c2_mcs_1_camman", 3) then
				loadAnim("missfinale_c2mcs_1")
				TaskPlayAnim(playerPed, "missfinale_c2mcs_1", "fin_c2_mcs_1_camman", 1.0, 1.0, -1, 50, 0, 0, 0, 0)
			end
			Citizen.Wait(1)
		end
	end)
	Citizen.CreateThread(function()
		while carrying do
			Citizen.Wait(0)
			if IsControlJustPressed(0, 38) then
				carrying = false
				ClearPedSecondaryTask(GetPlayerPed(-1))
				DetachEntity(GetPlayerPed(-1), true, false)
				TriggerServerEvent("carry:stop", id)
			end
		end
	end)
end)

RegisterNetEvent('carry:stop')
AddEventHandler('carry:stop', function()
	carrying = false
	ClearPedTasks(PlayerPedId())
	DetachEntity(GetPlayerPed(-1), true, false)
end)

function loadAnim( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end