local ESX = nil
local PlayerData = {}
local onDuty = false
local inVeh = false

local longBlips = {}
local nearBlips = {}
local myBlip = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end


    while ESX.GetPlayerData().gang == nil do
        Citizen.Wait(100)
    end

	PlayerData = ESX.GetPlayerData()

    checkgang()

    Citizen.Wait(1500)

    while true do
        checkgang()
        Citizen.Wait(1000*60*5)
    end
end)

RegisterNetEvent('esx_gangtracker:CheckGang')
AddEventHandler('esx_gangtracker:CheckGang', function()
    checkgang()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
    checkgang()
end)

RegisterNetEvent('esx:setGang')
AddEventHandler('esx:setGang', function(gang)
	PlayerData.gang = gang
    if onDuty then
        goOffDuty()
    end
    checkgang()
end)

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    DisplayPlayerNameTagsOnBlips(false)
    removeAllBlips()
end)

    Citizen.CreateThread(function()
        while true do
            if onDuty then
                local veh = GetVehiclePedIsIn(PlayerPedId(), false)
                if veh ~= 0 and not inVeh then
                    inVeh = true
                    inVehChecks(veh)

                    local cfg = 255
                    TriggerServerEvent('rflx_gangblips:enteredVeh', cfg)
                elseif veh == 0 and inVeh then
                    inVeh = false
                    if onDuty then
                        TriggerServerEvent('rflx_gangblips:leftVeh')
                    end
                end
                Citizen.Wait(750)
            else
                Citizen.Wait(1000)
            end
        end
    end)


function checkgang()
    ESX.TriggerServerCallback('getblipforme', function(haveit)
        if haveit == true then
            goOnDuty()
        else
            goOffDuty()
        end
    end)
end

function inVehChecks(veh, seat, vehiclelabel)
    Citizen.CreateThread(function()
        while inVeh do
            if IsVehicleSirenOn(veh) and not lastSirenState then
                lastSirenState = true
                TriggerServerEvent('rflx_pdblips:toggleSiren', true)
            elseif not IsVehicleSirenOn(veh) and lastSirenState then
                lastSirenState = false
                TriggerServerEvent('rflx_pdblips:toggleSiren', false)
            end
            Citizen.Wait(500)
        end
    end)
end

function MSGALERTTESTA(title, msg, time)
	TriggerEvent('dopeNotify2:Alert', tostring(title), "<span style='color:#c7c7c7; font-weight: 600;'>"..tostring(msg).."</span>!", time, 'success')
end

function goOnDuty()
    if not onDuty then
        MSGALERTTESTA('[Gps Gang System]', 'Gps Gang Shoma Faal Shod', 5000)
    end
    onDuty = true
    TriggerServerEvent('rflx_gangblips:setDuty', true)
    -- other sets
        -- SetBigmapActive(true, false)
        -- DisplayPlayerNameTagsOnBlips(true)
    if inVeh then
        TriggerServerEvent('rflx_gangblips:enteredVeh', 225)
    end
end
AddEventHandler('rflx_gangblips:goOnDuty', goOnDuty)
 
function goOffDuty()
    onDuty = false
    TriggerServerEvent('rflx_gangblips:setDuty', false)

    -- other sets
    DisplayPlayerNameTagsOnBlips(false)
    removeAllBlips()
end
AddEventHandler('rflx_gangblips:goOffDuty', goOffDuty)

function removeAllBlips()
    restoreBlip(myBlip.blip)
    for k, v in pairs(nearBlips) do
        RemoveBlip(v.blip)
    end
    for k, v in pairs(longBlips) do
        RemoveBlip(v.blip)
    end
    nearBlips = {}
    longBlips = {}
    myBlip = {}
end

RegisterNetEvent('rflx_gangblips:removeUser')
AddEventHandler('rflx_gangblips:removeUser', function(plyId)
    if nearBlips[plyId] then
        RemoveBlip(nearBlips[plyId].blip)
        nearBlips[plyId] = nil
    end
    if longBlips[plyId] then
        RemoveBlip(longBlips[plyId].blip)
        longBlips[plyId] = nil
    end
end)

RegisterNetEvent('rflx_gangblips:receiveData')
AddEventHandler('rflx_gangblips:receiveData', function(myId, data) -- ugly ass event
    for k, v in pairs(data) do
        local cId = GetPlayerFromServerId(v.playerId)
        local canSee = PlayerData.gang.name == v.gang

        if canSee then
            if myId ~= v.playerId then
                if cId ~= -1 then
                    if nearBlips[v.playerId] == nil then  -- switch/init blip from long to close proximity
                        if longBlips[v.playerId] then
                            RemoveBlip(longBlips[v.playerId].blip)
                            longBlips[v.playerId] = nil
                        end
                        nearBlips[v.playerId] = {}
                        nearBlips[v.playerId].blip = AddBlipForEntity(GetPlayerPed(cId))
                        setupBlip(nearBlips[v.playerId].blip, v)
                    end

                    if v.inVeh and not nearBlips[v.playerId].inVeh then -- entered veh blip setup
                        nearBlips[v.playerId].inVeh = true
                        vehBlipSetup(nearBlips[v.playerId].blip, v)
                    elseif not v.inVeh and nearBlips[v.playerId].inVeh then -- left veh blip
                        nearBlips[v.playerId].inVeh = false
                        vehBlipSetup(nearBlips[v.playerId].blip, v)
                    end
                else
                    if longBlips[v.playerId] == nil then -- switch/init blip from close to long proximity
                        if nearBlips[v.playerId] then
                            RemoveBlip(nearBlips[v.playerId].blip)
                            nearBlips[v.playerId] = nil
                        end
                        longBlips[v.playerId] = {}
                        longBlips[v.playerId].blip = AddBlipForCoord(v.coords)
                        setupBlip(longBlips[v.playerId].blip, v)
                        if v.inVeh then
                            vehBlipSetup(longBlips[v.playerId].blip, v)
                        end
                    else
                        if longBlips[v.playerId] then
                            RemoveBlip(longBlips[v.playerId].blip)
                        end
                        longBlips[v.playerId].blip = AddBlipForCoord(v.coords)
                        setupBlip(longBlips[v.playerId].blip, v)
                        if v.inVeh then
                            vehBlipSetup(longBlips[v.playerId].blip, v)
                        end
                    end

                    if v.inVeh and not longBlips[v.playerId].inVeh then -- entered veh blip setup
                        longBlips[v.playerId].inVeh = true
                        vehBlipSetup(longBlips[v.playerId].blip, v)
                    elseif not v.inVeh and longBlips[v.playerId].inVeh then -- left veh blip
                        longBlips[v.playerId].inVeh = false
                        vehBlipSetup(longBlips[v.playerId].blip, v)
                    end
                end
            end
        end
    end
end)

function setupBlip(blip, data)
	SetBlipSprite(blip, 1)
	SetBlipDisplay(blip, 2)
	SetBlipScale(blip, 0.7)
	SetBlipColour(blip, 1)
    SetBlipFlashes(blip, false)
    ShowHeightOnBlip(blip, false)
    SetBlipShowCone(blip, true)
    -- SetBlipCategory(blip, 7)
	BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(data.name)
	EndTextCommandSetBlipName(blip)
end

function vehBlipSetup(blip, data)
    if data.inVeh then
        SetBlipSprite(blip, 326)
        SetBlipDisplay(blip, 2)
        SetBlipScale(blip, 0.7)
        SetBlipColour(blip, 1)
        SetBlipShowCone(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(data.name)
        EndTextCommandSetBlipName(blip)
        -- SetBlipCategory(blip, 7)
        ShowHeadingIndicatorOnBlip(blip, false)
    else
        SetBlipSprite(blip, 1)
        SetBlipDisplay(blip, 2)
        SetBlipScale(blip, 0.7)
        SetBlipColour(blip, 1)
        SetBlipShowCone(blip, true)
        ShowHeadingIndicatorOnBlip(blip, true)
        SetBlipRotation(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(data.name)
        EndTextCommandSetBlipName(blip)
        -- SetBlipCategory(blip, 7)
    end
end

function restoreBlip(blip) -- idk better way, pls don't kill me bruh
    SetBlipSprite(blip, 6)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.7)
    SetBlipRotation(blip, false)
    ShowHeadingIndicatorOnBlip(blip, false)
    SetBlipColour(blip, 0)
    SetBlipShowCone(blip, false)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(GetPlayerName(PlayerId()))
    EndTextCommandSetBlipName(blip)
    -- SetBlipCategory(blip, 1)
end
