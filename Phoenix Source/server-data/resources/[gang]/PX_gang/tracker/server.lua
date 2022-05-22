local ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
local dutyTable = {}

Citizen.CreateThread(function()
    while true do
        local sendTable = {}
        for k, v in pairs(dutyTable) do
            local coords = GetEntityCoords(GetPlayerPed(k))
            local tempVar = v
            tempVar.playerId = k
            tempVar.coords = coords

            table.insert(sendTable, tempVar)
        end
        for player, kekw in pairs(dutyTable) do
            TriggerClientEvent('rflx_gangblips:receiveData', player, player, sendTable)
        end
        Citizen.Wait(2000)
    end
end)

RegisterNetEvent('rflx_gangblips:setDuty')
AddEventHandler('rflx_gangblips:setDuty', function(onDuty)
    local src = source

    if onDuty then
        local xPlayer = ESX.GetPlayerFromId(src)
        local playergangname = xPlayer.gang.name
        local playergang = xPlayer.gang
        MySQL.scalar('SELECT gangsblip FROM gangs_data WHERE gang_name = @gang_name', {
            ['@gang_name'] = playergangname
        }, function(blip)
            if tonumber(blip) == 1 then
                dutyTable[src] = {
                    gang = playergang.name,
                    name = string.gsub(xPlayer.name, "_", " "),
                    prefix = nil,
                }
            end
        end)
    else
        if dutyTable[src] then
            dutyTable[src] = nil
            for k, v in pairs(dutyTable) do
                TriggerClientEvent('rflx_gangblips:removeUser', k, src)
            end
        end
    end
end)

RegisterNetEvent('rflx_gangblips:enteredVeh')
AddEventHandler('rflx_gangblips:enteredVeh', function(vehCfg)
    local src = source
    -- local playergang = ESX.GetPlayerFromId(src).gang
    local code1 = 225
    local code2 = 0
    -- dutyTable[src].inVeh = true
    -- dutyTable[src].vehSprite = vehCfg and code1
    -- dutyTable[src].vehColor = vehCfg and code2
end)

RegisterNetEvent('rflx_gangblips:leftVeh')
AddEventHandler('rflx_gangblips:leftVeh', function()
    local src = source
    -- dutyTable[src].inVeh = nil
    -- dutyTable[src].vehSprite = nil
    -- dutyTable[src].vehColor = nil
end)

AddEventHandler('playerDropped', function(reason)
    local src = source
    if dutyTable[src] then
        dutyTable[src] = nil
        for k, v in pairs(dutyTable) do
            TriggerClientEvent('rflx_gangblips:removeUser', k, src)
        end
    end
end)

ESX.RegisterServerCallback('getblipforme', function(source, cb)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local playergang = xPlayer.gang.name

    MySQL.scalar('SELECT gangsblip FROM gangs_data WHERE gang_name = @gang_name', {
        ['@gang_name'] = playergang
    }, function(blip)
        if tonumber(blip) == 1 then
            cb(true)
        else
            cb(false)
        end
    end)
end)

RegisterNetEvent('rflx_gangblips:toggleSiren')
AddEventHandler('rflx_gangblips:toggleSiren', function(isOn)
    local src = source
    local playergang = ESX.GetPlayerFromId(src).gang
    if isOn then
        dutyTable[src].siren = true
        dutyTable[src].flashColors = Config.emergencygangs[playergang.name].blip.flashColors or {Config.emergencygangs[playergang.name].blip.color}
    else
        dutyTable[src].siren = false
        dutyTable[src].flashColors = nil
    end
end)