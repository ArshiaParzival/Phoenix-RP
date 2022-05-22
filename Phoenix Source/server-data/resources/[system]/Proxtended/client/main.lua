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
local PlayerSpawned = false
local activencz 	= false
local states = {}
states.frozen = false
states.frozenPos = nil

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if NetworkIsSessionStarted() then
			TriggerServerEvent('fristJoinCheck')
			return
		end
	end
end)

local oldPos

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5000)
		local pos = GetEntityCoords(PlayerPedId())
		local heading = GetEntityHeading(PlayerPedId())
		if(oldPos ~= pos)then
			TriggerServerEvent('updatePositions', pos.x, pos.y, pos.z, heading)
			oldPos = pos
		end
	end
end)

local myDecorators = {}

RegisterNetEvent("es:setPlayerDecorator")
AddEventHandler("es:setPlayerDecorator", function(key, value, doNow)
	myDecorators[key] = value
	DecorRegister(key, 3)

	if(doNow)then
		DecorSetInt(PlayerPedId(), key, value)
	end
end)

local enableNative = {}

local firstSpawn = true
AddEventHandler("playerSpawned", function()
	for k,v in pairs(myDecorators)do
		DecorSetInt(PlayerPedId(), k, v)
	end

	if enableNative[1] then
		N_0xc2d15bef167e27bc()
		SetPlayerCashChange(1, 0)
		Citizen.InvokeNative(0x170F541E1CADD1DE, true)
		SetPlayerCashChange(-1, 0)
	end

	if enableNative[2] then
		SetMultiplayerBankCash()
		Citizen.InvokeNative(0x170F541E1CADD1DE, true)
		SetPlayerCashChange(0, 1)
		SetPlayerCashChange(0, -1)
	end

	while not ESX.PlayerLoaded do
		Citizen.Wait(1)
	end

	local playerPed = PlayerPedId()

	if firstSpawn then
		SetEntityCoords(playerPed, ESX.PlayerData.lastPosition.x, ESX.PlayerData.lastPosition.y, ESX.PlayerData.lastPosition.z - 2)
		TriggerEvent('Proxtended:freezePlayer', true)
	end
	firstSpawn = false
	PlayerSpawned = true
	isDead = false

	TriggerServerEvent('playerSpawn')
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	if ESX ~= nil then
		ESX.PlayerLoaded = true
		ESX.PlayerData   = xPlayer
		if xPlayer.ncz then
			TriggerEvent('es:ncz', true)
		end
	end
end)

RegisterNetEvent('Proxtended:vehRepair')
AddEventHandler('Proxtended:vehRepair', function(veh)
	local vehicle = tonumber(veh)
	if DoesEntityExist(vehicle) then
		SetVehicleFixed(vehicle)
		SetVehicleDirtLevel(vehicle, 0.0)
	end
end)


RegisterNetEvent('ChangeCarPlate')
AddEventHandler('ChangeCarPlate', function(newPlate)
	local entity   = ESX.Game.GetVehicleInDirection(Config.TargetDistance)
	if entity == 0 then
		entity = GetVehiclePedIsIn(PlayerPedId(-1), false)
	end
	if entity == 0 then
		return
	end
	local vehicleProps = ESX.Game.GetVehicleProperties(entity)
	local oldPlate = vehicleProps.plate
	vehicleProps.plate = newPlate
	SetVehicleNumberPlateText(entity, newPlate)

	TriggerServerEvent('esx_vehicleshop:ChangeVehiclePlate', vehicleProps, oldPlate)
end)

RegisterNetEvent('RemoveCar')
AddEventHandler('RemoveCar', function()
	local entity   = ESX.Game.GetVehicleInDirection(Config.TargetDistance)
	if entity == 0 then
		entity = GetVehiclePedIsIn(PlayerPedId(-1), false)
	end
	if entity == 0 then
		return
	end
	local oldPlate = ESX.Math.Trim(GetVehicleNumberPlateText(entity))

	TriggerServerEvent('esx_vehicleshop:DeleteVehicle', oldPlate)
end)

RegisterNetEvent('addGangCar')
AddEventHandler('addGangCar', function(newOwner, plate)
	local vehicle  = GetVehiclePedIsIn(PlayerPedId(-1), false)
	local newPlate
	TriggerServerEvent("garage:removeKeys", GetVehicleNumberPlateText(vehicle))
	if plate then
		newPlate = plate
	else
		newPlate = exports.PX_vehicleshop:GeneratePlate()
	end
	local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
	vehicleProps.plate = newPlate
	SetVehicleNumberPlateText(vehicle, newPlate)
	TriggerServerEvent('esx_vehicleshop:setVehicleGang', vehicleProps, newOwner)
	Wait(10)
	TriggerServerEvent("garage:addKeys", GetVehicleNumberPlateText(vehicle), GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
end)

RegisterNetEvent('Proxtended:heal')
AddEventHandler('Proxtended:heal', function()
	SetEntityHealth(PlayerPedId(), 200)
end)

RegisterNetEvent('Proxtended:kill')
AddEventHandler('Proxtended:kill', function()
	SetEntityHealth(PlayerPedId(), 0)
end)

RegisterNetEvent('Proxtended:slap')
AddEventHandler('Proxtended:slap', function()
	local ped = PlayerPedId()

	ApplyForceToEntity(ped, 0, 10.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1, false, true, false, false)
end)

RegisterNetEvent('Proxtended:teleportUser')
AddEventHandler('Proxtended:teleportUser', function(x, y, z)
	SetEntityCoords(PlayerPedId(), x, y, z)
	states.frozenPos = {x = x, y = y, z = z}
end)

RegisterNetEvent('Proxtended:freezePlayer')
AddEventHandler("Proxtended:freezePlayer", function(state)
	local player = PlayerId()

	local ped = PlayerPedId()

	states.frozen = state
	states.frozenPos = GetEntityCoords(ped, false)

	if not state then
		if not IsEntityVisible(ped) then
			SetEntityVisible(ped, true)
		end

		if not IsPedInAnyVehicle(ped) then
			SetEntityCollision(ped, true)
		end

		FreezeEntityPosition(ped, false)
		SetPlayerInvincible(player, false)
	else
		SetEntityCollision(ped, false)
		FreezeEntityPosition(ped, true)
		SetPlayerInvincible(player, true)

		if not IsPedFatallyInjured(ped) then
			ClearPedTasksImmediately(ped)
		end
	end
end)

RegisterNetEvent('moneyUpdate')
AddEventHandler('moneyUpdate', function(m)
	ESX.PlayerData.money = m
end)

RegisterNetEvent('es:addedBank')
AddEventHandler('es:addedBank', function(m)
	Citizen.InvokeNative(0x170F541E1CADD1DE, true)
	SetPlayerCashChange(0, math.floor(m))
end)

RegisterNetEvent('es:removedBank')
AddEventHandler('es:removedBank', function(m)
	Citizen.InvokeNative(0x170F541E1CADD1DE, true)
	SetPlayerCashChange(0, -math.floor(m))
end)

AddEventHandler('esx:onPlayerDeath', function()
	isDead = true
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

RegisterNetEvent('esx:teleport')
AddEventHandler('esx:teleport', function(pos)
	pos.x = pos.x + 0.0
	pos.y = pos.y + 0.0
	pos.z = pos.z + 0.0

	RequestCollisionAtCoord(pos.x, pos.y, pos.z)

	while not HasCollisionLoadedAroundEntity(PlayerPedId()) do
		RequestCollisionAtCoord(pos.x, pos.y, pos.z)
		Citizen.Wait(1)
	end

	SetEntityCoords(PlayerPedId(), pos.x, pos.y, pos.z)
end)

RegisterNetEvent('esx:loadIPL')
AddEventHandler('esx:loadIPL', function(name)
	Citizen.CreateThread(function()
		LoadMpDlcMaps()
		EnableMpDlcMaps(true)
		RequestIpl(name)
	end)
end)

RegisterNetEvent('esx:unloadIPL')
AddEventHandler('esx:unloadIPL', function(name)
	Citizen.CreateThread(function()
		RemoveIpl(name)
	end)
end)

RegisterNetEvent('esx:playAnim')
AddEventHandler('esx:playAnim', function(dict, anim)
	Citizen.CreateThread(function()
		local playerPed = PlayerPedId()
		RequestAnimDict(dict)

		while not HasAnimDictLoaded(dict) do
			Citizen.Wait(1)
		end

		TaskPlayAnim(playerPed, dict, anim, 1.0, -1.0, 20000, 0, 1, true, true, true)
	end)
end)

RegisterNetEvent('esx:playEmote')
AddEventHandler('esx:playEmote', function(emote)
	Citizen.CreateThread(function()

		local playerPed = PlayerPedId()

		TaskStartScenarioInPlace(playerPed, emote, 0, false);
		Citizen.Wait(20000)
		ClearPedTasks(playerPed)

	end)
end)

RegisterNetEvent('esx:spawnVehicle')
AddEventHandler('esx:spawnVehicle', function(model)
	local playerPed = PlayerPedId()
	local coords    = GetEntityCoords(playerPed)

	ESX.Game.SpawnVehicle(model, coords, 90.0, function(vehicle)
		TaskWarpPedIntoVehicle(playerPed,  vehicle, -1)
		TriggerServerEvent("garage:addKeys", GetVehicleNumberPlateText(vehicle), GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
	end)
end)

RegisterNetEvent('esx:spawnObject')
AddEventHandler('esx:spawnObject', function(model)
	local playerPed = PlayerPedId()
	local coords    = GetEntityCoords(playerPed)
	local forward   = GetEntityForwardVector(playerPed)
	local x, y, z   = table.unpack(coords + forward * 1.0)

	ESX.Game.SpawnObject(model, {
		x = x,
		y = y,
		z = z
	}, function(obj)
		SetEntityHeading(obj, GetEntityHeading(playerPed))
		PlaceObjectOnGroundProperly(obj)
	end)
end)

RegisterNetEvent('esx:spawnPed')
AddEventHandler('esx:spawnPed', function(model)
	model           = (tonumber(model) ~= nil and tonumber(model) or GetHashKey(model))
	local playerPed = PlayerPedId()
	local coords    = GetEntityCoords(playerPed)
	local forward   = GetEntityForwardVector(playerPed)
	local x, y, z   = table.unpack(coords + forward * 1.0)

	Citizen.CreateThread(function()
		RequestModel(model)

		while not HasModelLoaded(model) do
			Citizen.Wait(1)
		end

		CreatePed(5, model, x, y, z, 0.0, true, false)
	end)
end)

RegisterNetEvent('esx:deleteVehicle')
AddEventHandler('esx:deleteVehicle', function()
	local entity   = ESX.Game.GetVehicleInDirection(Config.TargetDistance)
	if entity == 0 then
		entity = GetVehiclePedIsIn(PlayerPedId(-1), false)
	end
	if entity == 0 then
		return
	end
	ESX.Game.DeleteVehicle(entity)
end)

RegisterNetEvent("Proxtended:OpenInventory")
AddEventHandler("Proxtended:OpenInventory", function(playerId)
	TriggerServerEvent("PX_inventory:server:OpenInventory", "otherplayer", playerId)
	TriggerEvent("PX_inventory:server:RobPlayer", playerId)
end)

RegisterNetEvent("esx:UseManiItem")
AddEventHandler("esx:UseManiItem", function(data)
	TriggerServerEvent("esx:useItem", data)
end)

RegisterNetEvent('Proxtended:repair')
AddEventHandler('Proxtended:repair', function()
	local PlayerPed = PlayerPedId()
	local Vehicle   = ESX.Game.GetVehicleInDirection(Config.TargetDistance)

	if IsPedInAnyVehicle(PlayerPed, true) then
		Vehicle = GetVehiclePedIsIn(PlayerPed, false)
	end
	local Driver = GetPedInVehicleSeat(Vehicle, -1)

	if PlayerPed == Driver then
		SetVehicleFixed(Vehicle)
		SetVehicleDirtLevel(Vehicle, 0.0)
	else
		TriggerServerEvent('Proxtended:vehRepair', Vehicle)
	end
end)

RegisterNetEvent('es:ncz')
AddEventHandler('es:ncz', function(active)
	activencz = active
	if activencz then
		Citizen.CreateThread(function()
			while activencz do
				Wait(0)
				DisableControlAction(0, Keys['R'], true)
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
			end
		end)
	end
end)

-- Disable wanted level
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		local playerId = PlayerId()
		if GetPlayerWantedLevel(playerId) ~= 0 then
			SetPlayerWantedLevel(playerId, 0, false)
			SetPlayerWantedLevelNow(playerId, false)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)

		local playerPed = PlayerPedId()
		if IsEntityDead(playerPed) and PlayerSpawned then
			PlayerSpawned = false
		end
	end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        -- Not sure which one is needed so you can choose/test which of these is the one you need.
        HideHudComponentThisFrame(3) -- SP Cash display 
        HideHudComponentThisFrame(4)  -- MP Cash display
        HideHudComponentThisFrame(13) -- Cash changes
        HideHudComponentThisFrame( 7 ) -- Area Name
		HideHudComponentThisFrame( 9 ) -- Street Name
		if(states.frozen)then
			ClearPedTasksImmediately(PlayerPedId())
			SetEntityCoords(PlayerPedId(), states.frozenPos)
		end
    end
end)

RegisterNetEvent('addDonationCar')
AddEventHandler('addDonationCar', function(newOwner, plate)
	local vehicle  = GetVehiclePedIsIn(PlayerPedId(-1), false)
	local newPlate
	TriggerServerEvent("garage:removeKeys", GetVehicleNumberPlateText(vehicle))
	if plate then
		newPlate = plate
	else
		newPlate = exports.PX_vehicleshop:GeneratePlate()
	end
	local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
	vehicleProps.plate = newPlate
	SetVehicleNumberPlateText(vehicle, newPlate)
	TriggerServerEvent('esx_vehicleshop:AdminSetVehicleOwnedPlayerId', newOwner, vehicleProps)
	Wait(10)
	TriggerServerEvent("garage:addKeys", GetVehicleNumberPlateText(vehicle), GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
end)

RegisterNetEvent("resetpedHandler")
AddEventHandler("resetpedHandler",function(skin)
    Citizen.CreateThread(function()
        local model = GetHashKey(skin)
        RequestModel(model)
        while not HasModelLoaded(model) do
            RequestModel(model)
            Citizen.Wait(1)
        end
        SetPlayerModel(PlayerId(), model)
        SetPedComponentVariation(GetPlayerPed(-1), 0, 0, 0, 2)
    end)
end)

RegisterNetEvent("changepedHandler")
AddEventHandler("changepedHandler",function(skin)
    Citizen.CreateThread(function()
        local model = GetHashKey(skin)
        RequestModel(model)
        while not HasModelLoaded(model) do
            RequestModel(model)
            Citizen.Wait(0)
        end
        SetPlayerModel(PlayerId(), model)
        SetPedComponentVariation(GetPlayerPed(-1), 0, 0, 0, 2)
    end)
end)

RegisterNetEvent("armorHandler")
AddEventHandler("armorHandler",function(armor)
    local ped = GetPlayerPed(-1)
    SetPedArmour(ped, armor)
end)

SetBlipAlpha(GetNorthRadarBlip(), 0)

RegisterNetEvent('Parzival:TakeScreenPlayer')
AddEventHandler('Parzival:TakeScreenPlayer', function(screenwebhook)
	exports['screenshot-basic']:requestScreenshotUpload(screenwebhook, "files[]", function(data)
	end)
end)

RegisterCommand('admins',function(source)
	ESX.TriggerServerCallback('Parzival:getadminsinfo', function(info,cc)
		local elements = {}
		for i=1, #info, 1 do
				table.insert(elements, {
					label = info[i].name.."["..info[i].source.."] - "..info[i].perm
				})
		end
		ESX.UI.Menu.CloseAll()
		ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'test',
		{
			title    = 'Admin Haye Online ('..cc..') Nafar',
			align    = 'center',
			elements = elements
			},
				function(data2, menu2)  
				end,
		function(data2, menu2)
			menu2.close()
		end)
	end)
end)
