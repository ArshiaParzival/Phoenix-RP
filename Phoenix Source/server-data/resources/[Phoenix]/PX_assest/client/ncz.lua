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

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

local inNCZ = false
local area = nil

Zones = {
    {
          coords = vector3(443.72, -982.41, 30.72),  --pd
          distance = 110
    },
    {
          coords = vector3(220.32, -801.81, 30.71),  --parking
          distance = 100
    },
    {
          coords = vector3(354.98, -1413.45, 32.51),  --medic
          distance = 130
    },
    {
          coords = vector3(-362.33, -126.66, 38.7),  --mechanic
          distance = 130
    },
    {
          coords = vector3(-539.85, -214.78, 37.65),  --dadgostari
          distance = 50
    },
    {
          coords = vector3(901.81, -170.21, 74.08),  --taxi
          distance = 70
    },
    {
        coords = vector3(1108.94, 215.45, -49.44),  --casino
        distance = 150
    }
}

Citizen.CreateThread(function()
    while true do
        local ped = GetPlayerPed(-1)
        local coords = GetEntityCoords(ped)
        for k, v in pairs(Zones) do
            if area == nil then
                if GetDistanceBetweenCoords(coords, v.coords, false) < v.distance then
                    if not inNCZ then
                        TriggerEvent("PX_streetlabel:inNCZ", true)
                        area = k
                        inNCZ = true
                        -- if ESX ~= nil and ESX.PlayerData and ESX.PlayerData.job then
                        --     if ESX.PlayerData.job.name ~= 'police' and ESX.PlayerData.job.name ~= 'dadgostari' then
                        --         disbaleAction()
                        --     end
                        -- else
                        --     Citizen.Wait(3000)
                        -- end
                    end
                end
            elseif GetDistanceBetweenCoords(coords, Zones[area].coords, false) >= Zones[area].distance then
                if inNCZ then
                    area = nil
                    inNCZ = false
                    TriggerEvent("PX_streetlabel:inNCZ", false)
                end
            end
        end
        Citizen.Wait(3000)
    end
end)

function disbaleAction()
    Citizen.CreateThread(function()
        while inNCZ do
            DisablePlayerFiring(GetPlayerPed(-1), true)
            DisableControlAction(0, 25, true)
            DisableControlAction(0, 37, true)
            Citizen.Wait(0)
        end
    end)
end