ESX = nil

PlayerData = {}

local jailTime = 0
local first = true

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData() == nil do
		Citizen.Wait(10)
	end

	if first then
		ESX.SetPlayerData('jailed' ,0)
		TriggerServerEvent("PX_jail:server:changeStatus", false)
		first = false
	end
	PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(newData)
	PlayerData = newData
	Citizen.Wait(10000)
	ESX.TriggerServerCallback("PX_jail:getOwnJail", function(inJail, newJailTime)
		if inJail then
			TriggerServerEvent("PX_jail:server:changeStatus", true)
			jailTime = newJailTime
			JailLogin()
		else
			TriggerServerEvent("PX_jail:server:changeStatus", false)
		end
	end)
end)

RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob", function(response)
	PlayerData["job"] = response
end)

RegisterNetEvent("PX_jail:openJailmenu")
AddEventHandler("PX_jail:openJailmenu", function()
	OpenJailMenu()
end)

RegisterNetEvent("PX_jail:JailPlayer")
AddEventHandler("PX_jail:JailPlayer", function(newJailTime)
	TriggerServerEvent("PX_jail:server:changeStatus", true)
	ESX.SetPlayerData('jailed', 1)
	jailTime = newJailTime
	Wait(100)
	InJail(true)
end)

RegisterNetEvent("PX_jail:UnjailPlayer")
AddEventHandler("PX_jail:UnjailPlayer", function()
	jailTime = 0
	UnJail()
end)

function JailLogin()
	InJail(true)
end

function UnJail()
	ESX.SetPlayerData('jailed', 0)
	TriggerServerEvent("PX_jail:server:changeStatus", false)
	local coords = GetEntityCoords(PlayerPedId())
	for k,v in ipairs(Config.JailPositions) do
		if GetDistanceBetweenCoords(coords, v.x, v.y, v.z, false) <= v.d then
			if k == 1 then
				SetEntityCoords(PlayerPedId(), 1851.03, 2587.21, 45.67)
			elseif k == 2 then
				SetEntityCoords(PlayerPedId(), 434.38, -975.59, 30.71)
			elseif k == 3 then
				SetEntityCoords(PlayerPedId(), 388.68, -1622.07, 29.29)
			elseif k == 4 then
				SetEntityCoords(PlayerPedId(), 616.8, 33.35, 89.25)
			elseif k == 5 then
				SetEntityCoords(PlayerPedId(), 1863.05, 3682.15, 33.78)
			end
		end
	end
end

function JailTimer()
	Citizen.CreateThread(function()
		Citizen.Wait(60000)
		while jailTime > 0 do
			jailTime = jailTime - 1
			TriggerServerEvent("PX_jail:updateJailTime", jailTime)

			if jailTime == 0 then
				UnJail()
				TriggerServerEvent("PX_jail:updateJailTime", 0)
			end
			Citizen.Wait(60000)
		end
	end)
end


function InJail(first)
	Citizen.Wait(1000)

	if first then
		JailTimer()
	end

    Citizen.CreateThread(function()
		while jailTime > 0 do
			ESX.ShowMissionText("~r~JailTime: ~w~" .. jailTime)
			Citizen.Wait(0)
		end
	end)
end

function OpenJailMenu()
	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'jail_prison_menu',
		{
			title    = "Menu ye zendan",
			align    = 'center',
			elements = {
				{ label = "Jail Closest Person", value = "jail_closest_player" },
				{ label = "Unjail Person", value = "unjail_player" }
			}
		},
	function(data, menu)
		local action = data.current.value
		if action == "jail_closest_player" then
			menu.close()
			ESX.UI.Menu.Open(
				'dialog', GetCurrentResourceName(), 'jail_choose_time_menu',
				{
					title = "Zaman e zendan(be daghighe)"
				},
			function(data2, menu2)
				local jailTime = tonumber(data2.value)
				if jailTime == nil then
					ESX.ShowNotification("Lotfan Time ro Be daqiqe Vared konid!", 'error')
				else
					if jailTime <= 1000 then
					menu2.close()
					local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
					if closestPlayer == -1 or closestDistance > 3.0 then
						ESX.ShowNotification("Hich kas nazdik nist!", 'error')
					else
						ESX.UI.Menu.Open(
							'dialog', GetCurrentResourceName(), 'jail_choose_reason_menu',
							{
							  title = "Dalil zendan"
							},
						function(data3, menu3)
							local reason = data3.value
							if reason == nil then
								ESX.ShowNotification("Bayad dalil bezarid", 'error')
							else
								menu3.close()
								local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
								if closestPlayer == -1 or closestDistance > 3.0 then
									ESX.ShowNotification("Kasi nazdik nist!", 'error')
								else
									TriggerServerEvent("PX_jail:JailPlayer", GetPlayerServerId(closestPlayer), jailTime, reason)
									menu4.close()
								end
							end
						end, function(data3, menu3)
							menu3.close()
						end)
					  end
					else
						ESX.ShowNotification("Zaman zendan nemitavand bishtar az 1000 daghighe bashad", 'error')
					end
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		elseif action == "unjail_player" then
			local elements = {}
			ESX.TriggerServerCallback("PX_jail:getJailedPlayers", function(playerArray)
				if #playerArray == 0 then
					ESX.ShowNotification("Zendan e shoma khalist", 'error')
					return
				end
				for i = 1, #playerArray, 1 do
					table.insert(elements, {label = "Zendani: " .. playerArray[i].name .. " | Zaman e zendan: " .. playerArray[i].jailTime .. " daghighe", value = playerArray[i].identifier })
				end
				ESX.UI.Menu.Open(
					'default', GetCurrentResourceName(), 'jail_unjail_menu',
					{
						title = "Azad kardan az zendan",
						align = "center",
						elements = elements
					},
				function(data2, menu2)
					local action = data2.current.value
					TriggerServerEvent("PX_jail:UnjailPlayer", action, true)
					menu2.close()
				end, function(data2, menu2)
					menu2.close()
				end)
			end)
		end
	end, function(data, menu)
		menu.close()
	end)
end

Citizen.CreateThread(function()
	local blip = AddBlipForCoord(1845.6022949219, 2585.8029785156, 45.672061920166)
    SetBlipSprite (blip, 188)
    SetBlipDisplay(blip, 4)
    SetBlipScale  (blip, 0.8)
    SetBlipColour (blip, 49)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString('Prison')
    EndTextCommandSetBlipName(blip)
end)