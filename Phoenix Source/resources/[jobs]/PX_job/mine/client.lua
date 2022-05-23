ESX = nil
local duty = false
local mining = false
local spawned = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
    TriggerServerEvent("EZ_Pixel:minerjob:ImLoaded")
end)

CodeM = nil
GotM = false
RegisterNetEvent("EZ_Pixel:minerjob:sendCode")
AddEventHandler("EZ_Pixel:minerjob:sendCode", function(code)
    if not GotM then
    	CodeM = code
		GotM = true
	else
		ForceSocialClubUpdate()
	end
end)

Citizen.CreateThread(function()
    for _, info in pairs(MineConfig.Blips) do
        info.blip = AddBlipForCoord(info.x, info.y, info.z)
        SetBlipSprite(info.blip, info.id)
        SetBlipDisplay(info.blip, 4)
        SetBlipScale(info.blip, 0.6)
        SetBlipColour(info.blip, info.colour)
        SetBlipAsShortRange(info.blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(info.title)
        EndTextCommandSetBlipName(info.blip)
    end
end)

Citizen.CreateThread(function()
    while true do
        if duty then
            local closeTo = 0
            for k, v in pairs(MineConfig.MiningPositions) do
                if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), v.coords, true) <= 2.5 then
                    closeTo = v
                    break
                end
            end
            if type(closeTo) == 'table' then
                while GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), closeTo.coords, true) <= 2.5 do
                    Wait(0)
                    helpText(Strings['press_mine'])
                    if IsControlJustReleased(0, 38) then
                        local player, distance = ESX.Game.GetClosestPlayer()
                        if distance == -1 or distance >= 1.0 then
                            mining = true
                            SetEntityCoords(PlayerPedId(), closeTo.coords)
                            SetEntityHeading(PlayerPedId(), closeTo.heading)
                            FreezeEntityPosition(PlayerPedId(), true)
                            local model = loadModel(GetHashKey(MineConfig.Objects['pickaxe']))
                            local axe = CreateObject(model, GetEntityCoords(PlayerPedId()), true, false, false)
                            AttachEntityToEntity(axe, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.09, 0.03, -0.02, -78.0, 13.0, 28.0, false, true, true, true, 0, true)
                            while mining do
                                Wait(0)
                                SetCurrentPedWeapon(PlayerPedId(), GetHashKey('WEAPON_UNARMED'))
                                helpText(Strings['mining_info'])
                                DisableControlAction(0, 24, true)
                                if IsDisabledControlJustReleased(0, 24) then
                                    local dict = loadDict('melee@hatchet@streamed_core')
                                    TaskPlayAnim(PlayerPedId(), dict, 'plyr_rear_takedown_b', 8.0, -8.0, -1, 2, 0, false, false, false)
                                    local timer = GetGameTimer() + 800
                                    while GetGameTimer() <= timer do Wait(0) DisableControlAction(0, 24, true) end
                                    ClearPedTasks(PlayerPedId())
                                    TriggerServerEvent('PX_minerjob:getItem', CodeM)
                                elseif IsControlJustReleased(0, 194) then
                                    break
                                end
                            end
                            mining = false
                            DeleteObject(axe)
                            FreezeEntityPosition(PlayerPedId(), false)
                        else
                            ESX.ShowNotification(Strings['someone_close'], 'error')
                        end
                    end
                end
            end
            Wait(250)
        else
            Citizen.Wait(10000)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local coords = GetEntityCoords(PlayerPedId())
        local distance = #(coords - MineConfig.ClackLoc)
        if distance < 20 then
            DrawMarker(1, MineConfig.ClackLoc, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.5, 1.5, 1.5, 255, 255, 255, 255, false, true, nil, false)
            if distance < 2.0 then
                TriggerEvent('esx:showHelpNotification', 'Kelid ~INPUT_CONTEXT~ jahat dastresi be ~r~Duty~s~')
                if IsControlJustReleased(1, 38) then
                    OpenDutyMenu()
                end
            end
        else
            Citizen.Wait(2000)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if duty then
            local coords = GetEntityCoords(PlayerPedId())
            local distance = #(coords - MineConfig.VehLoc)
            if distance < 20 then
                DrawMarker(36, MineConfig.VehLoc, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.8, 0.8, 0.8, 255, 255, 255, 255, true, false, nil, true)
                if distance < 2.0 then
                    TriggerEvent('esx:showHelpNotification', 'Kelid ~INPUT_CONTEXT~ jahat dastresi be ~b~Garage~s~')
                    if IsControlJustReleased(1, 38) then
                        if not spawned then
                            OpenGarageMenu()
                        else
                            ESX.ShowNotification("Shoma ~r~Mashin ~w~ Darid!", 'error')
                        end
                    end
                end
            else
                Citizen.Wait(2000)
            end
        else
            Citizen.Wait(2000)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if duty then
            local coords = GetEntityCoords(PlayerPedId())
            local distance = #(coords - MineConfig.VehDelLoc)
            if distance < 20  then
                DrawMarker(1, MineConfig.VehDelLoc, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.5, 2.5, 1.0, 255, 0, 0, 255, false, true, nil, false)
                if distance < 2.0 and IsPedInAnyVehicle(PlayerPedId(), false) then
                    TriggerEvent('esx:showHelpNotification', 'Kelid ~INPUT_CONTEXT~ jahat ~r~park kardan~s~')
                    if IsControlJustReleased(1, 38) then
                        local veh = GetVehiclePedIsIn(PlayerPedId())
                        TriggerServerEvent("garage:removeKeys", GetVehicleNumberPlateText(veh))
                        DeleteVehicle(veh)
                        spawned = false
                    end
                end
            else
                Citizen.Wait(2000)
            end
        else
            Citizen.Wait(2000)
        end
    end
end)

RegisterNetEvent('PX_minerjob:doAnimation')
AddEventHandler('PX_minerjob:doAnimation', function()
    local isAnimStarted = false
    ESX.Streaming.RequestAnimDict('mini@repair', function()
		TaskPlayAnim(PlayerPedId(), 'mini@repair', 'fixing_a_ped', 8.0, 0, -1, 1, 1.0, 0, 0, 0)
	end)
    isAnimStarted = true
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
            if isAnimStarted then
                DisableAllControlActions(1)
            end
        end
    end)
    Citizen.Wait(30000)
    ClearPedTasksImmediately(PlayerPedId())
    isAnimStarted = false
end)

function OpenDutyMenu()
    ped = PlayerPedId()
    local elements = {
        {label = 'Off Duty', value = 'citizen_wear'},
        {label = 'On Duty', value = 'work_wear'}
    }
    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'Duty_menu', {
        title = 'Duty',
        align = 'top-left',
        elements = elements
    }, function(data, menu)
            if data.current.value == 'citizen_wear' then
                duty = false
                menu.close()
            elseif data.current.value == 'work_wear' then
                duty = true
                menu.close()
            end
        end,
    function(data, menu)
        menu.close()
    end)
end

function OpenGarageMenu()
    local elements = {
        {label = 'Spawn Mashin', value = 'spawn_vehicle'}
    }
    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'garage_menu', {
        title = 'Garage',
        align = 'top-left',
        elements = elements
    }, function(data, menu)
            if data.current.value == 'spawn_vehicle' then
                ESX.Game.SpawnVehicle('utillitruck3', MineConfig.VehSpawn, 174.54, function(vehicle)
                    spawned = true
                    SetPedIntoVehicle(PlayerPedId(), vehicle, -1)
                    TriggerServerEvent("garage:addKeys", GetVehicleNumberPlateText(vehicle), GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
                end)
                menu.close()
            end
        end,
    function(data, menu)
        menu.close()
    end)
end

loadModel = function(model)
    while not HasModelLoaded(model) do Wait(0) RequestModel(model) end
    return model
end

loadDict = function(dict, anim)
    while not HasAnimDictLoaded(dict) do Wait(0) RequestAnimDict(dict) end
    return dict
end

helpText = function(msg)
    BeginTextCommandDisplayHelp('STRING')
    AddTextComponentSubstringPlayerName(msg)
    EndTextCommandDisplayHelp(0, false, true, -1)
end

function DrawText3D(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end