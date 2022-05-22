ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(9)
    end
end)


local inRadialMenu = false

function setupSubItems()
end

function openRadial(bool)    
    setupSubItems()

    SetNuiFocus(bool, bool)
    SendNUIMessage({
        action = "ui",
        radial = bool,
        items = Config.MenuItems
    })
    inRadialMenu = bool
end

function closeRadial(bool)    
    SetNuiFocus(false, false)
    inRadialMenu = bool
end

function getNearestVeh()
    local pos = GetEntityCoords(GetPlayerPed(-1))
    local entityWorld = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, 20.0, 0.0)

    local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, GetPlayerPed(-1), 0)
    local _, _, _, _, vehicleHandle = GetRaycastResult(rayHandle)
    return vehicleHandle
end

AddEventHandler('onKeyDown',function(key)
    if key == "end" then
    if not inRadialMenu then
        openRadial(true)
        SetCursorLocation(0.5, 0.5)
        end
    end
end)

RegisterNUICallback('closeRadial', function()
    closeRadial(false)
end)

RegisterNUICallback('selectItem', function(data)
    local itemData = data.itemData

    if itemData.type == 'client' then
        TriggerEvent(itemData.event, itemData)
    elseif itemData.type == 'server' then
        TriggerServerEvent(itemData.event, itemData)
    end
end)

function DrawText3Ds(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

AddEventHandler('copynearplate',function()
    local veh , distance = ESX.Game.GetClosestVehicle()
    if veh ~= -1 and distance <= 10 then
        SetClipboard(GetVehicleNumberPlateText(veh))
        ESX.ShowNotification("Pelak Mashine Nazdik Be Shoma Ba Movafaghiyat Copy Shod :)", 'success')
    else
        ESX.ShowNotification("Motasefane Mashini Dar Kenare Shoma Nist :(", 'error')
    end
end)

AddEventHandler('copyhex',function()
   SetClipboard(ESX.GetPlayerData().identifier)
    ESX.ShowNotification("Steam Hexe Shoma Ba Movafaghiyat Copy Shod :)", 'success')
end)

AddEventHandler('copydiscord',function()
    SetClipboard("https://discord.gg/phoenixir")
    ESX.ShowNotification("Link Discord Server Ba Movafaghiyat Copy Shod :)", 'success')
 end)

function SetClipboard(text)
    SendNUIMessage({
        action = "copy",
        cdata = text
    })
end

