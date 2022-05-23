local ESX = nil
local isDead = false
local JobState = false
local HasAlreadyEnteredMarker = false
local LastZone = nil
local CurrentAction = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()
    DoForJob()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    JobState = false
	ESX.PlayerData = xPlayer
    DoForJob()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    JobState = false
    ESX.PlayerData.job = job
    DoForJob()
end)

AddEventHandler('esx:onPlayerDeath', function(data)
	isDead = true
end)

AddEventHandler('playerSpawned', function(spawn)
	isDead = false
end)

Citizen.CreateThread(function()
    for k,v in pairs(JobsConfig.Zones) do
        for k2,v2 in pairs(v) do
            if k2 == "blip" and v2.Active == true then
                local blip = AddBlipForCoord(v2.Pos.x, v2.Pos.y, v2.Pos.z)
                SetBlipSprite (blip, v2.Sprite)
                SetBlipDisplay(blip, 4)
                SetBlipScale  (blip, v2.Size)
                SetBlipColour (blip, v2.Color)
                SetBlipAsShortRange(blip, true)
                BeginTextCommandSetBlipName('STRING')
                AddTextComponentSubstringPlayerName(v2.Name)
                EndTextCommandSetBlipName(blip)
            end
        end
    end
end)

function DoForJob()
    for k,v in pairs(JobsConfig.Zones) do
        if ESX.PlayerData.job.name == k then
            JobState = true
            break
        else
            JobState = false
        end
    end

    Citizen.CreateThread(function()
        while JobState do
            Citizen.Wait(5)
            local letSleep = true
            for k,v in pairs(JobsConfig.Zones) do
                if k == ESX.PlayerData.job.name then
                    for k2,v2 in pairs(v) do
                        if k2 ~= "blip" and v2.Pos ~= false and GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), v2.Pos.x, v2.Pos.y, v2.Pos.z, true) < 8 then
                            DrawMarker(20, v2.Pos.x, v2.Pos.y, v2.Pos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.3, 255, 255, 255, 150, false, true, 2, false, nil, nil, false)
                            letSleep = false
                        end
                    end
                end
            end
            if letSleep then
                Citizen.Wait(3000)
            end
        end
    end)

    Citizen.CreateThread(function()
        while JobState do
            Citizen.Wait(10)
            local coords      = GetEntityCoords(PlayerPedId())
            local isInMarker  = false
            local currentZone = nil

            for k,v in pairs(JobsConfig.Zones) do
                if k == ESX.PlayerData.job.name then
                    for k2,v2 in pairs(v) do
                        if k2 ~= "blip" and v2.Pos ~= false and (GetDistanceBetweenCoords(coords, v2.Pos.x, v2.Pos.y, v2.Pos.z, true) < 2) then
                            isInMarker  = true
                            currentZone = k2
                        end
                    end
                end
            end

            if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
                HasAlreadyEnteredMarker = true
                LastZone = currentZone
                CurrentAction = currentZone
            end

            if not isInMarker and HasAlreadyEnteredMarker then
                HasAlreadyEnteredMarker = false
                CurrentAction = nil
            end

            if not isInMarker then
                Citizen.Wait(1000)
            end
        end
    end)

    Citizen.CreateThread(function()
        while JobState do
            Citizen.Wait(5)
            if not isDead then
                if CurrentAction then
                    ESX.ShowHelpNotification("Press ~INPUT_CONTEXT~ top Open "..CurrentAction)
                    if IsControlJustReleased(0, 38) then
                        doActionNow(CurrentAction)
                        CurrentAction = nil
                    end
                end
            else
                Citizen.Wait(2000)
            end
        end
    end)
end

function doActionNow(noe)
    if noe == 'boss' then
        TriggerEvent('esx_society:openBossMenu', ESX.PlayerData.job.name, function(data, menu)
            menu.close()
        end)
    elseif noe == 'craft' then
        TriggerEvent("PX_crafting:open")
    elseif noe == 'armory' then
        Other = {maxweight = 5000000, slots = 100}
        TriggerEvent("PX_inventory:client:SetCurrentStash", ESX.PlayerData.job.name)
        TriggerServerEvent("PX_inventory:server:OpenInventory", "stash", ESX.PlayerData.job.name, Other)
    end
end