local ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent("esx:getSharedObject", function(OBJ) ESX = OBJ end)
        Wait(1)
    end
end)

local closestBin = {
    'prop_barrier_work06a',
    'prop_roadcone02a'
}

RegisterNetEvent("Parzival_Object:openMenu")
AddEventHandler("Parzival_Object:openMenu", function()
    Menu()
end)

function Menu()
    local elements = {
        {label = 'Barrier', value = 'barrier'},
        {label = 'Cone', value = 'cone'},
        {label = 'Delete', value = 'del'}
    }
    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'object_menu', {
        title = 'Object Menu',
        align = 'left',
        elements = elements
    }, function(data, menu)
            if data.current.value == 'barrier' then
                SpwanObject("prop_barrier_work06a")
            elseif data.current.value == 'cone' then
                SpwanObject("prop_roadcone02a")
            elseif data.current.value == 'del' then
                delObject()
            end
        end,
    function(data, menu)
        menu.close()
    end)
end

function SpwanObject(model)
    local playerPed = PlayerPedId()
    local coords    = GetEntityCoords(playerPed)
    local forward   = GetEntityForwardVector(playerPed)
    local x, y, z   = table.unpack(coords + forward * 1.0)
    loadanimdict("anim@narcotics@trash")
	TaskPlayAnim(PlayerPedId(), "anim@narcotics@trash" , "drop_front" ,8.0, -8.0, -1, 1, 0, false, false, false )
    Wait(1000)
    ESX.Game.SpawnObject(model, {
        x = x,
        y = y,
        z = z
    }, function(obj)
        SetEntityHeading(obj, GetEntityHeading(playerPed))
        PlaceObjectOnGroundProperly(obj)
    end)
    ClearPedTasks(playerPed)
    ClearPedSecondaryTask(playerPed)
end

function delObject()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    for i = 1, #closestBin do
        local x = GetClosestObjectOfType(playerCoords, 2.5, GetHashKey(closestBin[i]), false, false, false)
        if DoesEntityExist(x) then
            loadanimdict("weapons@first_person@aim_rng@generic@projectile@thermal_charge@")
	        TaskPlayAnim(PlayerPedId(), "weapons@first_person@aim_rng@generic@projectile@thermal_charge@" , "plant_floor" ,8.0, -8.0, -1, 1, 0, false, false, false )
            Wait(1200)
            ESX.Game.DeleteObject(x)
        end
        ClearPedTasks(playerPed)
        ClearPedSecondaryTask(playerPed)
    end
end

function loadanimdict(dictname)
    if not HasAnimDictLoaded(dictname) then
        RequestAnimDict(dictname)
        while not HasAnimDictLoaded(dictname) do
            Citizen.Wait(1)
        end
    end
end