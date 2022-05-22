local lastSelectedVehicleEntity
local startCountDown
local testDriveEntity
local lastPlayerCoords
local hashListLoadedOnMemory = {}
local vehcategory = nil
local inTheShop = false
local profileName
local profileMoney

ESX = nil

Citizen.CreateThread(function ()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(200)
	end
end)


RegisterNetEvent('esx_vehicleshop.receiveInfo')
AddEventHandler('esx_vehicleshop.receiveInfo', function(bank, name)
    if name then
        profileName = name
    end
    profileMoney = bank
end)


RegisterNetEvent('esx_vehicleshop.successfulbuy')
AddEventHandler('esx_vehicleshop.successfulbuy', function(vehicleName,vehiclePlate,value)    
    SendNUIMessage({
        type = "successful-buy",
        vehicleName = vehicleName,
        vehiclePlate = vehiclePlate,
        value = value
    })       
    CloseNui()
end)

local vehiclesTable = {}
local provisoryObject = {}

RegisterNetEvent('esx_vehicleshop.vehiclesInfos')
AddEventHandler('esx_vehicleshop.vehiclesInfos', function(tableVehicles) 
    
    for _,value in pairs(tableVehicles) do
        vehiclesTable[value.category] = {}
    end

    for _,value in pairs(tableVehicles) do
        local vehicleModel = GetHashKey(value.model)
        local brandName
        -- brandName = GetLabelText(Citizen.InvokeNative(0xF7AF4F159FF99F97, vehicleModel, Citizen.ResultAsString()))
        brandName = 'test'

        local vehicleName   

        if GetLabelText(value.model) == "NULL" then
            vehicleName = value.model:gsub("^%l", string.upper)
        else 
            vehicleName = GetLabelText(value.model)
        end

        provisoryObject = 
        {
            brand = brandName,
            name = vehicleName,
            price = value.price,
            model = value.model,
            qtd = 100
        }
        table.insert(vehiclesTable[value.category], provisoryObject)
    end
end)

function OpenVehicleShop()
    TriggerEvent('OW:Whitelist',
    1, ---ban type
    true --- state of that
    )
    inTheShop = true
    local ped = PlayerPedId()

    TriggerServerEvent("esx_vehicleshop.requestInfo")

    Citizen.Wait(1000)

    SendNUIMessage({
        data = vehiclesTable,
        type = "display",
        playerName = profileName,
        playerMoney = profileMoney,
        testDrive = Config.TestDrive
    })

    SetNuiFocus(true, true)

    RequestCollisionAtCoord(x, y, z)

    cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", -41.36324, -1052.294, -43.01, 252.063, -15.0, 0.0, 60.00, false, 0)
    PointCamAtCoord(cam, -37.26872,-1054.309,-43.37314)

    SetCamActive(cam, true)
    RenderScriptCams(true, true, 1, true, true)
        
    SetFocusPosAndVel(-37.26872,-1054.309,-43.37314, 0.0, 0.0, 0.0)

    if lastSelectedVehicleEntity ~= nil then
        DeleteEntity(lastSelectedVehicleEntity)
    end
end

function updateSelectedVehicle(model)
    local hash = GetHashKey(model)

    if not HasModelLoaded(hash) then
        RequestModel(hash)
        while not HasModelLoaded(hash) do
            Citizen.Wait(10)
        end
    end

    if lastSelectedVehicleEntity ~= nil then
        DeleteEntity(lastSelectedVehicleEntity)
    end
    
    lastSelectedVehicleEntity = CreateVehicle(hash, -37.26872,-1054.309,-43.37314, 32.1, false, false)


    local vehicleData = {}

    
    vehicleData.traction = GetVehicleMaxTraction(lastSelectedVehicleEntity)


    vehicleData.breaking = GetVehicleMaxBraking(lastSelectedVehicleEntity) * 0.9650553    
    if vehicleData.breaking >= 1.0 then
        vehicleData.breaking = 1.0
    end

    vehicleData.maxSpeed = GetVehicleEstimatedMaxSpeed(lastSelectedVehicleEntity) * 0.9650553
    if vehicleData.maxSpeed >= 50.0 then
        vehicleData.maxSpeed = 50.0
    end

    vehicleData.acceleration = GetVehicleAcceleration(lastSelectedVehicleEntity) * 2.6
    if  vehicleData.acceleration >= 1.0 then
        vehicleData.acceleration = 1.0
    end


    SendNUIMessage({
        vehiclemodel = model,
        data = vehicleData,
        type = "updateVehicleInfos",        
    })
end

local showhelp = {
    ['key'] = 'E', -- key
    ['event'] = 'script:myevent',
    ['title'] = 'Press [E] to BUY VehicleShop',
    ['invehicle_title'] = 'BUY COLA',
    ['server_event'] = false, -- server event or client
    ['unpack_arg'] = false, -- send args as unpack 1,2,3,4 order
    ['fa'] = '<i class="fad fa-gas-pump"></i>',
    ['custom_arg'] = {}, -- example: {1,2,3,4}
}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local coords = GetEntityCoords(PlayerPedId())
        if GetDistanceBetweenCoords(coords, -32.54, -1112.2, 26.42, true) < 8 then
            DrawMarker(20, -32.54, -1112.2, 26.42, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.3, 255, 0, 0, 255, false, true, 2, false, false, false, false)
            if GetDistanceBetweenCoords(coords, -32.54, -1112.2, 26.42, true) < 2 then
                ShowFloatingHelpNotification("~INPUT_PICKUP~ Open Menu", vector3(-32.54, -1112.2, 26.9))
                if IsControlJustReleased(0, 38) then
                    OpenVehicleShop()
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    local carshop = vector3(-32.54, -1112.2, 26.42)
    local blip = AddBlipForCoord(carshop.x, carshop.y, carshop.z)
    SetBlipSprite(blip, 227)
    SetBlipColour(blip, 4)
    SetBlipScale(blip, 1.0)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("CarShop")
    EndTextCommandSetBlipName(blip)
end)


function rotation(dir)
    local entityRot = GetEntityHeading(lastSelectedVehicleEntity) + dir
    SetEntityHeading(lastSelectedVehicleEntity, entityRot % 360)
end

RegisterNUICallback("rotate", function(data, cb)
    if (data["key"] == "left") then
        rotation(2)
    else
        rotation(-2)
    end
    cb("ok")
end)

RegisterNUICallback("SpawnVehicle", function(data, cb)
    updateSelectedVehicle(data.modelcar)
end)

RegisterNUICallback("Buy", function(data, cb)
    local newPlate     = GeneratePlate()
    local vehicleProps = ESX.Game.GetVehicleProperties(lastSelectedVehicleEntity)
    vehicleProps.plate = newPlate
    
    TriggerServerEvent('esx_vehicleshop.CheckMoneyForVeh',data.modelcar, data.sale, data.name, vehicleProps)
    Wait(1500)        
end)

RegisterNUICallback("BuyGang", function(data, cb)
    local newPlate     = GeneratePlate()
    local vehicleProps = ESX.Game.GetVehicleProperties(lastSelectedVehicleEntity)
    vehicleProps.plate = newPlate
    
    TriggerServerEvent('esx_vehicleshop.CheckMoneyForVehGang',data.modelcar, data.sale, data.name, vehicleProps)
    Wait(1500)        
end)


RegisterNetEvent('esx_vehicleshop.spawnVehicle')
AddEventHandler('esx_vehicleshop.spawnVehicle', function(model, plate)    
    local hash = GetHashKey(model)

    lastPlayerCoords = GetEntityCoords(PlayerPedId())
    
    if not HasModelLoaded(hash) then
        RequestModel(hash)
        while not HasModelLoaded(hash) do
            Citizen.Wait(10)
        end
    end
    
    local vehicleBuy = CreateVehicle(hash, -11.87, -1080.87, 25.71, 132.0, 1, 1)
    SetPedIntoVehicle(PlayerPedId(), vehicleBuy, -1)
    SetVehicleNumberPlateText(vehicleBuy, plate)
    TriggerServerEvent("garage:addKeys", GetVehicleNumberPlateText(vehicleBuy), GetDisplayNameFromVehicleModel(GetEntityModel(vehicleBuy)))
end)




RegisterNUICallback("TestDrive", function(data, cb)
    TriggerServerEvent("esx_vehicleshop.testdriveonayla", data)
end)

RegisterNetEvent('esx_vehicleshop.close-ui')
AddEventHandler('esx_vehicleshop.close-ui', function()  
    CloseNui()  
end)

RegisterNetEvent('esx_vehicleshop.restart-ui')
AddEventHandler('esx_vehicleshop.restart-ui', function()  
    OpenVehicleShop()  
end)

RegisterNetEvent('esx_vehicleshop.testdrives')
AddEventHandler('esx_vehicleshop.testdrives', function(data, cb)    
if Config.TestDrive then
    startCountDown = true
    local hash = GetHashKey(data.vehicleModel)
    lastPlayerCoords = GetEntityCoords(PlayerPedId())
    TriggerServerEvent('ChangeWorldVeh', 'start')
	SetEntityCoords(PlayerPedId(), -874.34, -3226.6, 13.22)
    TriggerEvent('Proxtended:freezePlayer', true)
    Wait(1000)
    TriggerEvent('Proxtended:freezePlayer', false)
    if not HasModelLoaded(hash) then
        RequestModel(hash)
        while not HasModelLoaded(hash) do
            Citizen.Wait(10)
        end
    end
    
    if testDriveEntity ~= nil then
        DeleteEntity(testDriveEntity)
    end
    
    CloseNui()
    testDriveEntity = CreateVehicle(hash, -874.34, -3226.6, 13.22, 60.82, 1, 1)
    SetPedIntoVehicle(PlayerPedId(), testDriveEntity, -1)
    TriggerServerEvent("garage:addKeys", GetVehicleNumberPlateText(testDriveEntity), GetDisplayNameFromVehicleModel(GetEntityModel(testDriveEntity)))
    local timeGG = GetGameTimer()

    while startCountDown do
        local countTime
        Citizen.Wait(1)
        if GetGameTimer() < timeGG+tonumber(1000*Config.TestDriveTime) then
            local secondsLeft = GetGameTimer() - timeGG
            drawTxt('Test Drive ~r~' .. math.ceil(Config.TestDriveTime - secondsLeft/1000).. "~w~ seconds left.",4,0.5,0.01,0.50,255,255,255,180)
        else
            DeleteEntity(testDriveEntity)
            SetEntityCoords(PlayerPedId(), lastPlayerCoords)
            startCountDown = false
        end
    end
    Citizen.Wait(1000)
    TriggerServerEvent('ChangeWorldVeh', 'finish')        
end
end)

RegisterNUICallback("menuSelected", function(data, cb)
    local categoryVehicles
    local playerIdx = GetPlayerFromServerId(source)
    local ped = GetPlayerPed(playerIdx)
        
    if data.menuId ~= 'all' then
        categoryVehicles = vehiclesTable[data.menuId]
    else
        SendNUIMessage({
            data = vehiclesTable,
            type = "display",
            playerName = GetPlayerName(ped)
        })
        return
    end
    SendNUIMessage({
        data = categoryVehicles,
        type = "menu"
    })
end)


RegisterNUICallback("Close", function(data, cb)
    CloseNui()       
end)



function CloseNui()
    SendNUIMessage({
        type = "hide"
    })
    SetNuiFocus(false, false)
    if inTheShop then
        if lastSelectedVehicleEntity ~= nil then
            DeleteVehicle(lastSelectedVehicleEntity)
        end
        RenderScriptCams(false)
        DestroyAllCams(true)
        SetFocusEntity(GetPlayerPed(PlayerId())) 
        Citizen.CreateThread(function()
            Wait(3000)
            TriggerEvent('OW:Whitelist',
            1, ---ban type
            false --- state of that
            )
        end)
    end
    inTheShop = false
end

function drawTxt(text,font,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextScale(scale,scale)
	SetTextColour(r,g,b,a)
	SetTextOutline()
	SetTextCentre(5)
    SetTextFont(8)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x,y)
end

AddEventHandler("onResourceStop", function(resourceName)
    if resourceName == GetCurrentResourceName() then
        CloseNui()
    end
end)

Citizen.CreateThread(function()
	RequestIpl('shr_int')

	local interiorID = 7170
	LoadInterior(interiorID)
	EnableInteriorProp(interiorID, 'csr_beforeMission')
	RefreshInterior(interiorID)
end)