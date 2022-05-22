ESX = nil
local isDead = false
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
local IsHandcuffed = false
local DragStatus = {}
DragStatus.IsDragged = false
local fol = false
local Draging = false

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

AddEventHandler('esx:onPlayerDeath', function(data)
	isDead = true
	IsHandcuffed = false
	DragStatus.IsDragged = false
	Draging = false
end)

AddEventHandler('playerSpawned', function(spawn)
	isDead = false
	IsHandcuffed = false
	DragStatus.IsDragged = false
	Draging = false
end)

RegisterNetEvent('cuff')
AddEventHandler("cuff", function()
    local target, distance = ESX.Game.GetClosestPlayer()
    playerheading = GetEntityHeading(GetPlayerPed(-1))
    playerlocation = GetEntityForwardVector(PlayerPedId())
    playerCoords = GetEntityCoords(GetPlayerPed(-1))
    local target_id = GetPlayerServerId(target)
    if distance <= 2.0 then
        TriggerServerEvent('Phoenix:cuff', target_id, playerheading, playerCoords, playerlocation)
    else
        ESX.ShowNotification('Kasi Nazdik Shoma Nist!', 'error')
    end
end)

RegisterNetEvent('uncuff')
AddEventHandler("uncuff", function()
    local target, distance = ESX.Game.GetClosestPlayer()
    playerheading = GetEntityHeading(GetPlayerPed(-1))
    playerlocation = GetEntityForwardVector(PlayerPedId())
    playerCoords = GetEntityCoords(GetPlayerPed(-1))
    local target_id = GetPlayerServerId(target)
    if distance <= 2.0 then
        TriggerServerEvent('Phoenix:uncuff', target_id, playerheading, playerCoords, playerlocation)
    else
        ESX.ShowNotification('Kasi Nazdik Shoma Nist!', 'error')
    end
end)

RegisterNetEvent('drag')
AddEventHandler("drag", function()
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    if closestPlayer ~= -1 and closestDistance <= 2.0 then
        TriggerServerEvent('Phoenix:drag', GetPlayerServerId(closestPlayer))
    else
        ESX.ShowNotification('Kasi Nazdik Shoma Nist!', 'error')
    end
end)

RegisterNetEvent('PutInVeh')
AddEventHandler("PutInVeh", function()
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    if closestPlayer ~= -1 and closestDistance <= 2.0 then
        local vehicle = ESX.Game.GetVehicleInDirection(4)
        if vehicle == 0 then
            ESX.ShowNotification('Mashini Nazdik Shoma Nist!', 'error')
            return
        end
		if GetVehicleDoorLockStatus(vehicle) == 1 then
        	local NetId = NetworkGetNetworkIdFromEntity(vehicle)
        	TriggerServerEvent('Phoenix:putInVehicle', GetPlayerServerId(closestPlayer), NetId)
		else
			ESX.ShowNotification('Dar Mashin Ghofl Ast!', 'error')
		end
    else
        ESX.ShowNotification('Kasi Nazdik Shoma Nist!', 'error')
    end
end)

RegisterNetEvent('PutOutVeh')
AddEventHandler("PutOutVeh", function()
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    if closestPlayer ~= -1 and closestDistance <= 8.0 then
        TriggerServerEvent('Phoenix:OutVehicle', GetPlayerServerId(closestPlayer))
    else
        ESX.ShowNotification('Kasi Nazdik Shoma Nist!', 'error')
    end
end)

RegisterNetEvent('search')
AddEventHandler("search", function()
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    if closestPlayer ~= -1 and closestDistance <= 3.0 then
		local searchPlayerPed = GetPlayerPed(closestPlayer)
		if IsPedSittingInAnyVehicle(searchPlayerPed) and IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
			ExecuteCommand("me Shoro Be Gashtan Fard Mikone")
			OpenBodySearchMenu(closestPlayer)
		else
			print("copyright by dadasham baby") --Mani
			if IsEntityPlayingAnim(searchPlayerPed, "missminuteman_1ig_2", "handsup_base", 3) or IsEntityPlayingAnim(searchPlayerPed, 'mp_arresting', 'idle', 3) then
				ExecuteCommand("e bumbin")
				SearchPlayer(closestPlayer, closestDistance)
			elseif IsEntityPlayingAnim(searchPlayerPed, "dead", "dead_a", 3) then
				ExecuteCommand("e medic")
				SearchPlayer(closestPlayer, closestDistance)
			else
				ESX.ShowNotification('Baraye Search Bayad Dast Fard Bala bashad Ya Dar Halat Mojaz Bashad!', 'error')
			end
		end
    else
        ESX.ShowNotification('Kasi Nazdik Shoma Nist!', 'error')
    end
end)

function SearchPlayer(closestPlayer, closestDistance)
	TriggerEvent("mythic_progbar:client:progress", {
		name = "search",
		duration = 7 * 1000,
		label = "Dar hale Search Fard",
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
			if closestPlayer ~= -1 and closestDistance <= 3.0 then
				OpenBodySearchMenu(closestPlayer)
			else
				ESX.ShowNotification('Kasi Nazdik Shoma Nist!', 'error')
			end
		end
	end)
end

RegisterNetEvent('Parzival_Actions:draging')
AddEventHandler('Parzival_Actions:draging', function(copID)
	Draging = not Draging
	if Draging then
		loadanimdict('switch@trevor@escorted_out')
		TaskPlayAnim(PlayerPedId(), 'switch@trevor@escorted_out', '001215_02_trvs_12_escorted_out_idle_guard2', 8.0, 9.0, -1, 49, 0, 0, 0, 0)
	else
		StopAnimTask(PlayerPedId(), 'switch@trevor@escorted_out', '001215_02_trvs_12_escorted_out_idle_guard2', 1.0)
		ClearPedSecondaryTask(PlayerPedId())
	end
end)

RegisterNetEvent('Parzival_Actions:getarrested')
AddEventHandler('Parzival_Actions:getarrested', function(playerheading, playercoords, playerlocation, target)
	ESX.UI.Menu.CloseAll()
	if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(target)))) >= 5.0 then return end
	playerPed = GetPlayerPed(-1)
	SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true)
	local x, y, z = table.unpack(playercoords + playerlocation * 1.0)
	SetEntityCoords(GetPlayerPed(-1), x, y, z)
	SetEntityHeading(GetPlayerPed(-1), playerheading)
	TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 5.0, 'cuff', 1.0)
	Citizen.Wait(250)
	loadanimdict('mp_arrest_paired')
	TaskPlayAnim(GetPlayerPed(-1), 'mp_arrest_paired', 'crook_p2_back_right', 8.0, -8, 3750 , 2, 0, 0, 0, 0)
	Citizen.Wait(3760)
	IsHandcuffed = true
	loadanimdict('mp_arresting')
	TaskPlayAnim(GetPlayerPed(-1), 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
end)

RegisterNetEvent('Parzival_Actions:doarrested')
AddEventHandler('Parzival_Actions:doarrested', function()
	ESX.UI.Menu.CloseAll()
	SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true)
	Citizen.Wait(250)
	loadanimdict('mp_arrest_paired')
	TaskPlayAnim(GetPlayerPed(-1), 'mp_arrest_paired', 'cop_p2_back_right', 8.0, -8,3750, 2, 0, 0, 0, 0)
	Citizen.Wait(3000)
end)

RegisterNetEvent('Parzival_Actions:getuncuffed')
AddEventHandler('Parzival_Actions:getuncuffed', function(playerheading, playercoords, playerlocation, target)
	ESX.UI.Menu.CloseAll()
	if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(target)))) >= 5.0 then return end
	local x, y, z   = table.unpack(playercoords + playerlocation * 1.0)
	SetEntityCoords(GetPlayerPed(-1), x, y, z)
	SetEntityHeading(GetPlayerPed(-1), playerheading)
    TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 5.0, 'uncuff', 1.0)
	Citizen.Wait(250)
	loadanimdict('mp_arresting')
	TaskPlayAnim(GetPlayerPed(-1), 'mp_arresting', 'b_uncuff', 8.0, -8,-1, 2, 0, 0, 0, 0)
	Citizen.Wait(5500)
	IsHandcuffed = false
	ClearPedTasks(GetPlayerPed(-1))
end)

RegisterNetEvent('Parzival_Actions:douncuffing')
AddEventHandler('Parzival_Actions:douncuffing', function()
	ESX.UI.Menu.CloseAll()
	SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true)
	Citizen.Wait(250)
	loadanimdict('mp_arresting')
	TaskPlayAnim(GetPlayerPed(-1), 'mp_arresting', 'a_uncuff', 8.0, -8,-1, 2, 0, 0, 0, 0)
	Citizen.Wait(5500)
	ClearPedTasks(GetPlayerPed(-1))
end)

RegisterNetEvent('Phoenix:drag')
AddEventHandler('Phoenix:drag', function(copID)
	if IsHandcuffed or isDead then
		DragStatus.IsDragged = not DragStatus.IsDragged
		DragStatus.CopId = tonumber(copID)
	end
end)

RegisterNetEvent('Phoenix:putInVehicleS')
AddEventHandler('Phoenix:putInVehicleS', function()
	if Draging then
		Draging = false
		StopAnimTask(PlayerPedId(), 'switch@trevor@escorted_out', '001215_02_trvs_12_escorted_out_idle_guard2', 1.0)
		ClearPedSecondaryTask(PlayerPedId())
	end
end)

RegisterNetEvent('Phoenix:putInVehicle')
AddEventHandler('Phoenix:putInVehicle', function(vehicle)
	if IsHandcuffed or isDead then
		local veh = NetworkGetEntityFromNetworkId(vehicle)
		local ped = GetPlayerPed(-1)
		if IsVehicleSeatFree(veh, 1) then
			TaskWarpPedIntoVehicle(ped, veh, 1)
			DragStatus.IsDragged = false
			TriggerEvent('seatbelt:beband', true)
		elseif IsVehicleSeatFree(veh, 2) then
			TaskWarpPedIntoVehicle(ped, veh, 2)
			DragStatus.IsDragged = false
			TriggerEvent('seatbelt:beband', true)
		end
	end
end)

RegisterNetEvent('Phoenix:OutVehicle')
AddEventHandler('Phoenix:OutVehicle', function()
	local playerPed = PlayerPedId()
	if not IsPedSittingInAnyVehicle(playerPed) then
		return
	end
	local vehicle = GetVehiclePedIsIn(playerPed, false)
	if GetVehicleDoorLockStatus(vehicle) == 1 then
		TaskLeaveVehicle(playerPed, vehicle, 16)
	end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsHandcuffed then
            DisableControlAction(2, 24, true)
            DisableControlAction(0, 69, true)
            DisableControlAction(0, 70, true)
            DisableControlAction(0, 68, true)
            DisableControlAction(0, 66, true)
            DisableControlAction(0, 167, true)
            DisableControlAction(0, 67, true)
            DisableControlAction(2, 257, true)
            DisableControlAction(2, 25, true)
            DisableControlAction(2, 263, true)
            DisableControlAction(0, 29,  true)
            DisableControlAction(0, 74,  true)
            DisableControlAction(0, 71,  true)
            DisableControlAction(0, 72,  true)
            DisableControlAction(0, 63,  true)
            DisableControlAction(0, 64,  true)
            DisableControlAction(2, Keys['R'], true)
            DisableControlAction(2, Keys['LEFTSHIFT'], true)
            DisableControlAction(2, Keys['TOP'], true)
            DisableControlAction(2, Keys['SPACE'], true)
            DisableControlAction(2, Keys['Q'], true)
            DisableControlAction(2, Keys['TAB'], true)
            DisableControlAction(2, Keys['F1'], true)
            DisableControlAction(2, Keys['F2'], true)
            DisableControlAction(2, Keys['F3'], true)
            DisableControlAction(2, Keys['V'], true)
            DisableControlAction(2, Keys['X'], true)
            DisableControlAction(2, Keys['P'], true)
            DisableControlAction(2, Keys['L'], true)
            DisableControlAction(2, Keys['Z'], true)
            DisableControlAction(2, 59, true)
            DisableControlAction(2, Keys['LEFTCTRL'], true)
            DisableControlAction(0, 47, true)
            DisableControlAction(0, 264, true)
            DisableControlAction(0, 257, true)
            DisableControlAction(0, 140, true)
            DisableControlAction(0, 141, true)
            DisableControlAction(0, 142, true)
            DisableControlAction(0, 143, true)
            DisableControlAction(0, 75, true)
            DisableControlAction(27, 75, true)
            DisableControlAction(0, 107, true)
            DisableControlAction(0, 108, true)
            DisableControlAction(0, 109, true)
            DisableControlAction(0, 110, true)
            DisableControlAction(0, 111, true)
            DisableControlAction(0, 112, true)
            SetCurrentPedWeapon(GetPlayerPed(-1), GetHashKey('WEAPON_UNARMED'), true)
            if not IsEntityPlayingAnim(GetPlayerPed(-1), "mp_arresting", "idle", 1) then
              TaskPlayAnim(GetPlayerPed(-1), 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
            end
        else
            Citizen.Wait(500)
        end
    end
end)

Citizen.CreateThread(function()
    local playerPed
    local targetPed
    while true do
        Citizen.Wait(500)
        if IsHandcuffed or isDead then
            playerPed = PlayerPedId()
            if DragStatus.IsDragged then
                targetPed = GetPlayerPed(GetPlayerFromServerId(DragStatus.CopId))
                if not IsPedSittingInAnyVehicle(targetPed) then
                    AttachEntityToEntity(playerPed, targetPed, 11816, 0.1, 0.6, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
                else
                    DragStatus.IsDragged = false
                    DetachEntity(playerPed, true, false)
                end
            else
                DetachEntity(playerPed, true, false)
            end
        else
            Citizen.Wait(500)
        end
    end
end)

function loadanimdict(dictname)
    if not HasAnimDictLoaded(dictname) then
        RequestAnimDict(dictname)
        while not HasAnimDictLoaded(dictname) do
            Citizen.Wait(1)
        end
    end
end

function getVehicleInDirection(coordFrom, coordTo)
	local offset = 0
	local rayHandle
	local vehicle
	for i = 0, 100 do
		rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z + offset, 10, PlayerPedId(), 0)
		a, b, c, d, vehicle = GetRaycastResult(rayHandle)
		offset = offset - 1
		if vehicle ~= 0 then break end
	end
	local distance = Vdist2(coordFrom, GetEntityCoords(vehicle))
	if distance > 25 then vehicle = nil end
    return vehicle ~= nil and vehicle or 0
end

function OpenBodySearchMenu(player)
	local playerId = GetPlayerServerId(player)
	TriggerServerEvent("PX_inventory:server:OpenInventory", "otherplayer", playerId)
    TriggerEvent("PX_inventory:server:RobPlayer", playerId)
end