local NearShop = false
local isLoggedIn = true
local CurrentShop = nil

ESX = nil

TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)


RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    isLoggedIn = true
end)

-- Code

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(3)
        if isLoggedIn then
            NearShop = false
            for k, v in pairs(Config.Shops) do
                local PlayerCoords = GetEntityCoords(PlayerPedId())
                local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, v['Coords']['X'], v['Coords']['Y'], v['Coords']['Z'], true)
                if Distance < 10.0 then
                    NearShop = true
                    DrawMarker(20, v['Coords']['X'], v['Coords']['Y'], v['Coords']['Z'], 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.5, 0.3, 0.3, 255, 255, 255, 255, true, true, 2, false, false, false, false)
                    if Distance < 2.5 then
                        ESX.ShowFloatingHelpNotification("Press ~INPUT_CONTEXT~", v['Coords']['X'], v['Coords']['Y'], v['Coords']['Z'] + 0.3)
                        if IsControlJustReleased(0, 38) then
                            CurrentShop = k
                            if v['Name'] == 'Weapon Store' then
                                ESX.TriggerServerCallback('esx_license:checkLicense', function(hasWeaponLicense)
                                    if hasWeaponLicense then
                                        OpenSHop()
                                    else
                                        ESX.ShowNotification("Shoma Mojavez Aslahe Nadarid!", 'error')
                                    end
                                end, GetPlayerServerId(PlayerId()), 'weapon')
                            else
                                OpenSHop()
                            end
                        end
                    end
                end
            end
            if not NearShop then
                Citizen.Wait(3000)
                CurrentShop = nil
            end
        end
    end
end)

function OpenSHop()
    if CurrentShop ~= nil then
        local Shop = {label = Config.Shops[CurrentShop]['Name'], items = Config.Shops[CurrentShop]['Product'], slots = 3}
        TriggerServerEvent("PX_inventory:server:OpenInventory", "shop", "Itemshop_"..CurrentShop, Shop)
    end
end

local Zones = {
    vector3(-662.1, -935.3, 20.8),
    vector3(810.2, -2157.3, 28.6),
    vector3(1693.4, 3759.5, 33.7),
    vector3(-330.2, 6083.8, 30.4),
    vector3(252.3, -50.0, 68.9),
    vector3(22.0, -1107.2, 28.8),
    vector3(2567.6, 294.3, 107.7),
    vector3(-1117.5, 2698.6, 17.5),
    vector3(842.4, -1033.4, 27.1),
    vector3(-1306.2, -394.0, 35.6)
}

Citizen.CreateThread(function()
    for k,v in pairs(Zones) do
        local blip = AddBlipForCoord(v.x, v.y, v.z)
        SetBlipSprite (blip, 110)
        SetBlipDisplay(blip, 4)
        SetBlipScale  (blip, 0.6)
        SetBlipColour (blip, 4)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Weapon Shop")
        EndTextCommandSetBlipName(blip)
    end
end)