Keys = {
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

local deadAnimDict = "dead"
local deadAnim = "dead_a"
local hold = 5
local deathTime = 300

local FirstSpawn, inCapture = true, false
local formattedCoordsDeath = nil
local InJure, beingRevived = false, false

local lastjob = nil

ESX = nil

local inPaintBall = false
AddEventHandler('esx_paintball:inPaintBall', function(state) inPaintBall = state end)

local function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Wait(5)
    end
end

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(100)
	end

	ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
	lastjob = ESX.PlayerData.job.name
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

RegisterNetEvent('esx_ambulancejob:chnageDeathCoords')
AddEventHandler('esx_ambulancejob:chnageDeathCoords', function(playerId)
	local ped = GetPlayerFromServerId(playerId)
	local coords = GetEntityCoords(GetPlayerPed(ped))
	formattedCoordsDeath = {
		x = ESX.Math.Round(coords.x, 1),
		y = ESX.Math.Round(coords.y, 1),
		z = ESX.Math.Round(coords.z, 1) - 1
	}
end)


function revive_function()

	InJure = false
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)

	TriggerServerEvent('esx_ambulancejob:setDaathStatus', false)

	local formattedCoords = vector3(coords)

	ESX.SetPlayerData('lastPosition', formattedCoords)

	TriggerServerEvent('esx:updateLastPosition', formattedCoords)

	RespawnPed(playerPed, formattedCoords, 0.0)

	StopScreenEffect('DeathFailOut')
	DoScreenFadeIn(1)

end

RegisterNetEvent('esx_ambulancejob:ReviveIfDead')
AddEventHandler('esx_ambulancejob:ReviveIfDead', function()
	if InJure then
		InJure = false, false
	
		TriggerServerEvent('esx_ambulancejob:setDaathStatus', false)
		exports.PX_assest:DisableControl(false)
		Citizen.CreateThread(function()
			DoScreenFadeOut(500)
	
			while not IsScreenFadedOut() do
				Citizen.Wait(5)
			end
	
			local playerPed = PlayerPedId()
			local coords = GetEntityCoords(playerPed)
	
			local formattedCoords = {
				x = ESX.Math.Round(coords.x, 1),
				y = ESX.Math.Round(coords.y, 1),
				z = ESX.Math.Round(coords.z, 1)
			}
			formattedCoords = vector3(coords)
	
			ESX.SetPlayerData('lastPosition', formattedCoords)
	
			TriggerServerEvent('esx:updateLastPosition', formattedCoords)
	
			RespawnPed(playerPed, formattedCoords, 0.0)
	
			StopScreenEffect('DeathFailOut')
			DoScreenFadeIn(500)
			TriggerEvent('RL:Whitelist',
			6, ---ban type
			false --- state of that
			)
			DoScreenFadeIn(800)
		end)

	end
end)

AddEventHandler('playerSpawned', function()
	if FirstSpawn then
		exports.spawnmanager:setAutoSpawn(false) -- disable respawn
		FirstSpawn = false
	end
end)

-- Create blips
Citizen.CreateThread(function()
	for k,v in pairs(AmbulanceConfig.Hospitals) do
		local blip = AddBlipForCoord(v.Blip.coords)

		SetBlipSprite(blip, v.Blip.sprite)
		SetBlipScale(blip, v.Blip.scale)
		SetBlipColour(blip, v.Blip.color)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName(_U('hospital'))
		EndTextCommandSetBlipName(blip)
	end
end)

function OnPlayerDeath(deathCause)
    if not ESX.GetPlayerData().IsDead then
		deathTime = 300
		InJure = true
		ESX.SetPlayerData('IsDead', true)
		exports.PX_assest:DisableControl(true)
		TriggerServerEvent('esx_ambulancejob:setDaathStatus', deathCause)
        local player = PlayerPedId()
        while GetEntitySpeed(player) > 0.5 or IsPedRagdoll(player) do
            Wait(1)
        end

        if ESX.GetPlayerData().IsDead then
            local pos = GetEntityCoords(player)
            local heading = GetEntityHeading(player)

            local ped = PlayerPedId()
            if IsPedInAnyVehicle(ped) then
                local veh = GetVehiclePedIsIn(ped)
                local vehseats = GetVehicleModelNumberOfSeats(GetHashKey(GetEntityModel(veh)))
                for i = -1, vehseats do
                    local occupant = GetPedInVehicleSeat(veh, i)
                    if occupant == ped then
                        NetworkResurrectLocalPlayer(pos.x, pos.y, pos.z + 0.5, heading, true, false)
                        SetPedIntoVehicle(ped, veh, i)
                    end
                end
            else
                NetworkResurrectLocalPlayer(pos.x, pos.y, pos.z + 0.5, heading, true, false)
            end
			TriggerEvent("SetDeadTrueMotherFucker")
			InjureThreads()
            SetEntityInvincible(player, true)
			SetPlayerInvincible(player, true)
            SetEntityHealth(player, GetEntityMaxHealth(player))
			StartDistressSignal()
			Citizen.CreateThread(function()
				while InJure do
					if not beingRevived then
						if IsPedInAnyVehicle(player, false) then
							loadAnimDict("veh@low@front_ps@idle_duck")
							TaskPlayAnim(player, "veh@low@front_ps@idle_duck", "sit", 1.0, 1.0, -1, 1, 0, 0, 0, 0)
						else
							loadAnimDict(deadAnimDict)
							TaskPlayAnim(player, deadAnimDict, deadAnim, 1.0, 1.0, -1, 1, 0, 0, 0, 0)
						end
					end
					Citizen.Wait(1000)
				end
			end)
			StartDeathTimer()
        end
    end
end

function InjureThreads()
	Citizen.CreateThread(function()
		while InJure do
			Wait(0)
			DisableControlAction(0, Keys['F1'],true)
			DisableControlAction(0, Keys['F2'],true)
			DisableControlAction(0, Keys['F3'],true)
			DisableControlAction(0, Keys['F5'],true)
			DisableControlAction(0, Keys['F6'],true)
			DisableControlAction(0, Keys['R'], true)
			DisableControlAction(0, Keys['W'],true)
			DisableControlAction(0, Keys['S'],true)
			DisableControlAction(0, Keys['A'],true)
			DisableControlAction(0, Keys['D'], true)
			DisableControlAction(0, Keys['K'], true)
			DisableControlAction(0, Keys['SPACE'], true)
			DisableControlAction(0, Keys['LEFTSHIFT'], true)
			DisableControlAction(0, Keys['TAB'], true)
			DisableControlAction(0, Keys['X'], true)
			DisableControlAction(0, Keys['M'], true)
			DisableControlAction(0, Keys['Z'], true)
			DisableControlAction(0, Keys['U'], true)
			DisableControlAction(0, 32, false)
			DisableControlAction(0, 34, false)
			DisableControlAction(0, 31, false)
			DisableControlAction(0, 30, false)
			DisableControlAction(0, 24, true) -- Attack
			DisableControlAction(0, 257, true) -- Attack 2
			DisableControlAction(0, 25, true) -- Right click
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
end

RegisterNetEvent('esx_ambulancejob:useItem')
AddEventHandler('esx_ambulancejob:useItem', function(itemName)
	ESX.UI.Menu.CloseAll()

	if itemName == 'medikit' then
		local lib, anim = 'anim@heists@narcotics@funding@gang_idle', 'gang_chatting_idle01' -- TODO better animations
		local playerPed = PlayerPedId()

		ESX.Streaming.RequestAnimDict(lib, function()
			TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)

			Citizen.Wait(500)
			while IsEntityPlayingAnim(playerPed, lib, anim, 3) do
				Citizen.Wait(0)
				DisableAllControlActions(0)
			end
	
			TriggerEvent('esx_ambulancejob:heal', 'big', true)
			ESX.ShowNotification(_U('used_medikit'))
		end)

	elseif itemName == 'bandage' then
		local lib, anim = 'anim@heists@narcotics@funding@gang_idle', 'gang_chatting_idle01' -- TODO better animations
		local playerPed = PlayerPedId()

		ESX.Streaming.RequestAnimDict(lib, function()
			TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)

			Citizen.Wait(500)
			while IsEntityPlayingAnim(playerPed, lib, anim, 3) do
				Citizen.Wait(0)
				DisableAllControlActions(0)
			end

			TriggerEvent('esx_ambulancejob:heal', 'small', true)
			ESX.ShowNotification(_U('used_bandage'))
		end)
	end
end)

function StartDistressSignal()
	Citizen.CreateThread(function()
		while InJure do
			Citizen.Wait(2)
			SetTextFont(4)
			SetTextScale(0.45, 0.45)
			SetTextColour(185, 185, 185, 255)
			SetTextDropshadow(0, 0, 0, 0, 255)
			SetTextEdge(1, 0, 0, 0, 255)
			SetTextDropShadow()
			SetTextOutline()
			BeginTextCommandDisplayText('STRING')
			AddTextComponentSubstringPlayerName(_U('distress_send'))
			EndTextCommandDisplayText(0.435, 0.805)
			if IsControlPressed(0, Keys['E']) then
				TriggerServerEvent('parzival_ambulance:addreq', "Man Be Komak Niaz Daram.")
				Citizen.CreateThread(function()
					Citizen.Wait(1000 * 60 * 5)
					if InJure then
						StartDistressSignal()
					end
				end)
				break
			end
		end
	end)
end

function StartDeathTimer()
	Citizen.CreateThread(function()
		while InJure do
			Citizen.Wait(2)
			SetTextFont(4)
			SetTextScale(0.45, 0.45)
			SetTextColour(185, 185, 185, 255)
			SetTextDropshadow(0, 0, 0, 0, 255)
			SetTextEdge(1, 0, 0, 0, 255)
			SetTextDropShadow()
			SetTextOutline()
			BeginTextCommandDisplayText('STRING')
			if deathTime <= 0 then
				AddTextComponentSubstringPlayerName("~s~Hold ~r~[H] ~s~5s To Respawn")
			else
				AddTextComponentSubstringPlayerName("~r~"..deathTime.." ~s~To Enable Respawn")
			end
			EndTextCommandDisplayText(0.450, 0.770)
		end
	end)
	Citizen.CreateThread(function()
		hold = 5
		while InJure do
			Wait(1000)
			deathTime = deathTime - 1
			if deathTime <= 0 then
				if IsControlPressed(0, 74) and hold <= 0 and not beingRevived then
					RemoveItemsAfterRPDeath()
					hold = 5
				end
				if IsControlPressed(0, 74) then
					if hold - 1 >= 0 then
						hold = hold - 1
					else
						hold = 0
					end
				end
				if IsControlReleased(0, 74) then
					hold = 5
				end
			end
		end
	end)
end

function RemoveItemsAfterRPDeath()
	ESX.SetPlayerData('IsDead', false)
	TriggerServerEvent('esx_ambulancejob:setDaathStatus', false)
	Citizen.CreateThread(function()
		DoScreenFadeOut(500)

		while not IsScreenFadedOut() do
			Citizen.Wait(5)
		end

		ESX.TriggerServerCallback('esx_ambulancejob:removeItemsAfterRPDeath', function()
			local playerPed = PlayerPedId()
			local coords = GetEntityCoords(playerPed)

			local formattedCoords = {
				x = AmbulanceConfig.RespawnPoint.coords.x,
				y = AmbulanceConfig.RespawnPoint.coords.y,
				z = AmbulanceConfig.RespawnPoint.coords.z
			}

			ESX.SetPlayerData('lastPosition', formattedCoords)
			ESX.SetPlayerData('loadout', {})

			TriggerServerEvent('esx:updateLastPosition', formattedCoords)
			exports.PX_assest:DisableControl(false)
			RespawnPed(playerPed, formattedCoords, AmbulanceConfig.RespawnPoint.heading)
			StopScreenEffect('DeathFailOut')
			DoScreenFadeIn(500)
			TriggerEvent("esx_ambulancejob:reviveavermani")
		end)
	end)
end

function RespawnPed(ped, coords, heading)
	SetEntityHealth(PlayerPedId(), GetEntityMaxHealth(PlayerPedId()))
	SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false, true)
	NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, heading, true, false)
	SetPlayerInvincible(ped, false)
	TriggerEvent('playerSpawned', coords.x, coords.y, coords.z)
	ClearPedBloodDamage(ped)

	ESX.UI.Menu.CloseAll()
end

AddEventHandler('capture:inCapture', function(bool)
	inCapture = bool
end)

local Paintball = false

AddEventHandler('Paintball', function(state)
    Paintball = state
end)

AddEventHandler('esx:onPlayerDeath', function(data)
	if inCapture then
	elseif Paintball then
	else
		OnPlayerDeath()
	end
end)

RegisterNetEvent('esx_ambulancejob:parchesefid')
AddEventHandler('esx_ambulancejob:parchesefid', function()
	RemoveItemsAfterRPDeath()
end)

RegisterNetEvent('esx_ambulancejob:reviveavermani')
AddEventHandler('esx_ambulancejob:reviveavermani', function()
	InJure = false
	TriggerServerEvent('esx_ambulancejob:setDaathStatus', false)
	ESX.SetPlayerData('IsDead', false)
	exports.PX_assest:DisableControl(false)
	Citizen.CreateThread(function()
		DoScreenFadeOut(500)

		while not IsScreenFadedOut() do
			Citizen.Wait(5)
		end

		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)

		local formattedCoords = {
			x = ESX.Math.Round(coords.x, 1),
			y = ESX.Math.Round(coords.y, 1),
			z = ESX.Math.Round(coords.z, 1)
		}
		formattedCoords = vector3(coords)

		ESX.SetPlayerData('lastPosition', formattedCoords)

		TriggerServerEvent('esx:updateLastPosition', formattedCoords)

		RespawnPed(playerPed, formattedCoords, 0.0)

		StopScreenEffect('DeathFailOut')
		DoScreenFadeIn(500)
	end)
end)

-- Load unloaded IPLs
if AmbulanceConfig.LoadIpl then
	Citizen.CreateThread(function()
		RequestIpl('Coroner_Int_on') -- Morgue
	end)
end