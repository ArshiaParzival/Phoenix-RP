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

ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
    TriggerServerEvent("EZ_Pixel:comserv:ImLoaded")
end)

Code = nil
Got = false
RegisterNetEvent("EZ_Pixel:comserv:sendCode")
AddEventHandler("EZ_Pixel:comserv:sendCode", function(code)
    if not Got then
    	Code = code
		Got = true
	else
		ForceSocialClubUpdate()
	end
end)

local CurrentActions = 0
local IsJailed = false
local Doing = false
local tmp_action = nil
local availableActions = {}

function dpemote(state)
	TriggerEvent("dpemote:enable", state)
end

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(data)
    Wait(5000)
    TriggerServerEvent("Parzival_Comserv:CheckIsJail")
end)

RegisterNetEvent("Parzival_Comserv:TimeToFingerYourSelf")
AddEventHandler("Parzival_Comserv:TimeToFingerYourSelf", function(Actions)
    local playerPed = PlayerPedId()
	FillActionTable()
    dpemote(false)
    ESX.Game.Teleport(playerPed, Config.ServiceLocation)
    IsJailed = true
    CurrentActions = Actions
    Citizen.CreateThread(function()
        while CurrentActions > 0 and IsJailed == true do
            if IsPedInAnyVehicle(playerPed, false) then
                ClearPedTasksImmediately(playerPed)
            end
            if GetDistanceBetweenCoords(GetEntityCoords(playerPed), Config.ServiceLocation.x, Config.ServiceLocation.y, Config.ServiceLocation.z) > Config.DistanceExtension then
                ESX.Game.Teleport(playerPed, Config.ServiceLocation)
            end
            local health = GetEntityHealth(GetPlayerPed(-1))
            if health < 110 then
                TriggerEvent('esx_ambulancejob:reviveavermani')
            end
            Citizen.Wait(1000)
        end
    end)
end)

function FillActionTable(last_action)
    if #availableActions < 3 then
        while #availableActions < 8 do
            local service_does_not_exist = true
            local random_selection = Config.ServiceLocations[math.random(1,#Config.ServiceLocations)]
            for i = 1, #availableActions do
                if random_selection.coords.x == availableActions[i].coords.x and random_selection.coords.y == availableActions[i].coords.y and random_selection.coords.z == availableActions[i].coords.z then
                    service_does_not_exist = false
                end
            end
            if last_action ~= nil and random_selection.coords.x == last_action.coords.x and random_selection.coords.y == last_action.coords.y and random_selection.coords.z == last_action.coords.z then
                service_does_not_exist = false
            end
            if service_does_not_exist then
                table.insert(availableActions, random_selection)
            end
        end
    end
end

RegisterNetEvent('Parzival_Comserv:ReleaseMe')
AddEventHandler('Parzival_Comserv:ReleaseMe', function(code)
    if code == Code then
        IsJailed = false
        CurrentActions = 0
        dpemote(true)
        SetEntityHeading(PlayerPedId(), 156.46)
        ESX.Game.Teleport(PlayerPedId(), Config.ReleaseLocation)
    end
end)

Citizen.CreateThread(function()
    while true do
        :: start_over ::
        Citizen.Wait(1)
        if CurrentActions > 0 and IsJailed then
            ESX.ShowMissionText("~r~Remaining Actions: ~w~" .. ESX.Math.Round(CurrentActions))
            DrawAvailableActions()
            DisableViolentActions()
            local pCoords = GetEntityCoords(PlayerPedId())
            for i = 1, #availableActions do
                local distance = GetDistanceBetweenCoords(pCoords, availableActions[i].coords, true)
                if distance < 1.5 then
                    DisplayHelpText("Press   ~INPUT_CONTEXT~", availableActions[i].coords.x, availableActions[i].coords.y, availableActions[i].coords.z + 0.2)
                    if IsControlJustReleased(1, 38) then
                        tmp_action = availableActions[i]
                        RemoveAction(tmp_action)
                        FillActionTable(tmp_action)
                        if tmp_action.type == "bargh" then
                            SetEntityHeading(PlayerPedId(), 330.0)
							TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_WELDING", 0, true)
                            SetPlayerControl(PlayerId(), false)
                            Doing = true
                            SetTimeout(25000, function()
                                SetPlayerControl(PlayerId(), true)
                                ClearPedTasks(PlayerPedId())
                                SetTimeout(1000, function()
                                    CurrentActions = CurrentActions - 1
                                    TriggerServerEvent('Parzival_Comserv:MyActionIsDone', CurrentActions, Code)
                                    Doing = false
                                end)
                            end)
                        end
                        goto start_over
                    end
                end
            end
        end
    end
end)

AddEventHandler('playerSpawned', function(spawn)
	if Doing then
		TriggerServerEvent("Parzival_Comserv:Abusing")
	end
end)

function RemoveAction(action)
    local action_pos = -1

    for i=1, #availableActions do
        if action.coords.x == availableActions[i].coords.x and action.coords.y == availableActions[i].coords.y and action.coords.z == availableActions[i].coords.z then
            action_pos = i
        end
    end

    if action_pos ~= -1 then
        table.remove(availableActions, action_pos)
    end
end

function DisplayHelpText(msg, x, y, z)
	AddTextEntry('esxFloatingHelpNotification', msg)
    SetFloatingHelpTextWorldPosition(1, x, y, z)
    SetFloatingHelpTextStyle(1, 1, 2, -1, 3, 0)
    BeginTextCommandDisplayHelp('esxFloatingHelpNotification')
    EndTextCommandDisplayHelp(2, false, false, -1)
end

function DrawAvailableActions()
    for i = 1, #availableActions do
        DrawMarker(20, availableActions[i].coords, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.6, 0.6, 0.3, 255, 0, 0, 255, false, true, 2, true, false, false, false)
    end
end

function DisableViolentActions()
    local playerPed = PlayerPedId()

    if Doing then
        DisableControlAction(0, 32, false)
		DisableControlAction(0, 34, false)
		DisableControlAction(0, 31, false)
		DisableControlAction(0, 30, false)
    end

    DisableControlAction(0, Keys['F1'],true)
	DisableControlAction(0, Keys['F3'],true)
	DisableControlAction(0, Keys['F5'],true)
	DisableControlAction(0, Keys['PAGEUP'], true)
	DisableControlAction(0, Keys['R'], true)
	DisableControlAction(0, Keys['K'], true)
	DisableControlAction(0, Keys['M'], true)
    DisableControlAction(0, Keys[','], true)
    DisableControlAction(0, Keys['X'], true)
    DisableControlAction(0, Keys['F4'], true)
    DisableControlAction(0, Keys['L'], true)
    DisableControlAction(0, Keys['H'], true)
    DisableControlAction(0, Keys['U'], true)
    DisableControlAction(0, Keys['Y'], true)
    DisableControlAction(0, Keys['G'], true)
    DisableControlAction(0, Keys['V'], true)
    DisableControlAction(0, Keys['~'], true)
    DisableControlAction(0, Keys['TAB'], true)
    DisableControlAction(0, Keys['LEFTSHIFT'], true)
    DisableControlAction(0, Keys['SPACE'], true)
    DisableControlAction(2, 37, true)
    DisableControlAction(0, 106, true)
    DisableControlAction(0, 140, true)
    DisableControlAction(0, 141, true)
    DisableControlAction(0, 142, true)
    DisableControlAction(0, 243, true)

    DisablePlayerFiring(playerPed,true)

    if IsDisabledControlJustPressed(2, 37) then
        SetCurrentPedWeapon(playerPed,GetHashKey("WEAPON_UNARMED"),true)
    end
    if IsDisabledControlJustPressed(0, 106) then
        SetCurrentPedWeapon(playerPed,GetHashKey("WEAPON_UNARMED"),true)
    end
end

AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() then
        ForceSocialClubUpdate()
    end
end)

AddEventHandler("onClientResourceStop", function(resource)
    if resource == GetCurrentResourceName() then
        ForceSocialClubUpdate()
    end
end)