local ESX = nil
local LoggedIn = true

local currentWeapon = nil
local CurrentWeaponData = {}
local currentOtherInventory = nil

local Drops = {}
local CurrentDrop = 0
local DropsNear = {}

local CurrentVehicle = nil
local CurrentGlovebox = nil
local CurrentStash = nil
local CurrentTrash = false   

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(10)
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(data)
    Config.InventoryBusy = false
    LoggedIn = true
end)

-- Code

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        DisableControlAction(0, Config.Keys["TAB"], true)
        DisableControlAction(0, Config.Keys["1"], true)
        DisableControlAction(0, Config.Keys["2"], true)
        DisableControlAction(0, Config.Keys["3"], true)
        DisableControlAction(0, Config.Keys["4"], true)
        DisableControlAction(0, Config.Keys["5"], true)
        if LoggedIn then
           if IsDisabledControlJustPressed(0, Config.Keys["TAB"]) and not Config.InventoryBusy then
            --Config.InventoryBusy = true
               local DumpsterFound = ClosestContainer()
               local JailContainerFound = ClosestJailContainer()
               local curVeh = nil
               if IsPedInAnyVehicle(PlayerPedId()) then
                   local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                   CurrentGlovebox = GetVehicleNumberPlateText(vehicle)
                   curVeh = vehicle
                   CurrentVehicle = nil
               else
                   local vehicle = ESX.Game.GetClosestVehicle()
                   if vehicle ~= 0 and vehicle ~= nil then
                       local pos = GetEntityCoords(PlayerPedId())
                       local trunkpos = GetOffsetFromEntityInWorldCoords(vehicle, 0, -2.5, 0)
                       if (IsBackEngine(GetEntityModel(vehicle))) then
                           trunkpos = GetOffsetFromEntityInWorldCoords(vehicle, 0, 2.5, 0)
                       end
                       if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, trunkpos) < 1.0) and not IsPedInAnyVehicle(PlayerPedId()) then
                           if GetVehicleDoorLockStatus(vehicle) < 2 then
                               CurrentVehicle = GetVehicleNumberPlateText(vehicle)
                               curVeh = vehicle
                               CurrentGlovebox = nil
                           else
                               ESX.ShowNotification("Vehicle is locked..", 'error')
                               return
                           end
                       else
                           CurrentVehicle = nil
                       end
                   else
                       CurrentVehicle = nil
                   end
               end
               if CurrentVehicle ~= nil then
                   local other = {maxweight = Config.TrunkClasses[GetVehicleClass(curVeh)]['MaxWeight'], slots = Config.TrunkClasses[GetVehicleClass(curVeh)]['MaxSlots']}
                   TriggerServerEvent("PX_inventory:server:OpenInventory", "trunk", CurrentVehicle, other)
                   OpenTrunk()
               elseif CurrentGlovebox ~= nil then
                   TriggerServerEvent("PX_inventory:server:OpenInventory", "glovebox", CurrentGlovebox)
               elseif DumpsterFound then
                   local Dumpster = 'Container | '..math.floor(DumpsterFound.x).. ' | '..math.floor(DumpsterFound.y)..' |'
                   TriggerServerEvent("PX_inventory:server:OpenInventory", "stash", Dumpster, {maxweight = 1000000, slots = 15})
                   TriggerEvent("PX_inventory:client:SetCurrentStash", Dumpster)
                   TriggerEvent('PX_inventory:client:open:anim')   
               elseif JailContainerFound then
                   local Container = 'Jail~Container | '..math.floor(JailContainerFound.x).. ' | '..math.floor(JailContainerFound.y)..' |'
                   TriggerServerEvent("PX_inventory:server:OpenInventory", "stash", Container, {maxweight = 1000000, slots = 15})
                   TriggerEvent("PX_inventory:client:SetCurrentStash", Container)
                   TriggerEvent('PX_inventory:client:open:anim')
               elseif CurrentDrop ~= 0 then
                   TriggerServerEvent("PX_inventory:server:OpenInventory", "drop", CurrentDrop)
               else                       
                   TriggerServerEvent("PX_inventory:server:OpenInventory")
                   TriggerEvent('PX_inventory:client:open:anim')
               end
           end
           if IsDisabledControlJustReleased(0, Config.Keys["1"]) then
            TriggerServerEvent("PX_inventory:server:UseItemSlot", 1)
           end
           if IsDisabledControlJustReleased(0, Config.Keys["2"]) then
            TriggerServerEvent("PX_inventory:server:UseItemSlot", 2)
           end
           if IsDisabledControlJustReleased(0, Config.Keys["3"]) then
            TriggerServerEvent("PX_inventory:server:UseItemSlot", 3)
           end
           if IsDisabledControlJustReleased(0, Config.Keys["4"]) then
            TriggerServerEvent("PX_inventory:server:UseItemSlot", 4)
           end
           if IsDisabledControlJustReleased(0, Config.Keys["5"]) then
            TriggerServerEvent("PX_inventory:server:UseItemSlot", 5)
           end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if DropsNear ~= nil then
            for k, v in pairs(DropsNear) do
                if DropsNear[k] ~= nil then
                    DrawMarker(2, v.coords.x, v.coords.y, v.coords.z -0.5, 0, 0, 0, 0, 0, 0, 0.35, 0.5, 0.15, 252, 255, 255, 91, 0, 0, 0, 0)
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        if Drops ~= nil and next(Drops) ~= nil then
            local pos = GetEntityCoords(PlayerPedId(), true)
            for k, v in pairs(Drops) do
                if Drops[k] ~= nil then 
                    if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, v.coords.x, v.coords.y, v.coords.z, true) < 7.5 then
                        DropsNear[k] = v
                        if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, v.coords.x, v.coords.y, v.coords.z, true) < 2 then
                            CurrentDrop = k
                        else
                            CurrentDrop = nil
                        end
                    else
                        DropsNear[k] = nil
                    end
                end
            end
        else
            DropsNear = {}
        end
        Citizen.Wait(500)
    end
end)

RegisterNUICallback('RobMoney', function(data, cb)
    TriggerServerEvent("PX_police:server:rob:player", data.TargetId)
end)

RegisterNUICallback('Notify', function(data, cb)
    ESX.ShowNotification(data.message, data.type)
end)

RegisterNUICallback('UseItemShiftClick', function(slot)
    SendNUIMessage({
        action = "close",
    })
    SetNuiFocus(false, false)
    Config.HasInventoryOpen = false
    Citizen.Wait(250)
    TriggerServerEvent("PX_inventory:server:UseItemSlot", slot.slot)
end)

RegisterNUICallback('GetWeaponData', function(data, cb)
    local data = {
        WeaponData = ESX.Items[data.weapon],
        AttachmentData = FormatWeaponAttachments(data.ItemData)
    }
    cb(data)
end)

RegisterNUICallback('RemoveAttachment', function(data, cb)
    local WeaponData = ESX.Items[data.WeaponData.name]
    local Attachment = Config.WeaponAttachments[WeaponData.name:upper()][data.AttachmentData.attachment]
    ESX.TriggerServerCallback('PX_weapons:server:RemoveAttachment', function(NewAttachments)
        if NewAttachments ~= false then
            local Attachies = {}
            RemoveWeaponComponentFromPed(PlayerPedId(), GetHashKey(data.WeaponData.name), GetHashKey(Attachment.component))
            for k, v in pairs(NewAttachments) do
                for wep, pew in pairs(Config.WeaponAttachments[WeaponData.name:upper()]) do
                    if v.component == pew.component then
                        table.insert(Attachies, {
                            attachment = pew.item,
                            label = pew.label,
                        })
                    end
                end
            end
            local DJATA = {
                Attachments = Attachies,
                WeaponData = WeaponData,
            }
            cb(DJATA)
        else
            RemoveWeaponComponentFromPed(PlayerPedId(), GetHashKey(data.WeaponData.name), GetHashKey(Attachment.component))
            cb({})
        end
    end, data.AttachmentData, data.WeaponData)
end)

RegisterNUICallback('getCombineItem', function(data, cb)
    cb(ESX.Items[data.item])
end)

RegisterNUICallback("CloseInventory", function(data, cb)
    if currentOtherInventory == "none-inv" then
        CurrentDrop = 0
        CurrentVehicle = nil
        CurrentGlovebox = nil
        CurrentStash = nil
        SetNuiFocus(false, false)
        Config.HasInventoryOpen = false
        ClearPedTasks(PlayerPedId())
        return
    end
    if CurrentVehicle ~= nil then
        CloseTrunk()
        TriggerServerEvent("PX_inventory:server:SaveInventory", "trunk", CurrentVehicle)
        TriggerEvent('PX_inventory:client:open:anim')
        CurrentVehicle = nil
    elseif CurrentGlovebox ~= nil then
        TriggerServerEvent("PX_inventory:server:SaveInventory", "glovebox", CurrentGlovebox)
        CurrentGlovebox = nil
    elseif CurrentStash ~= nil then
        TriggerServerEvent("PX_inventory:server:SaveInventory", "stash", CurrentStash)
        TriggerEvent('PX_inventory:client:open:anim')
        CurrentStash = nil
    else
        TriggerServerEvent("PX_inventory:server:SaveInventory", "drop", CurrentDrop)
        TriggerEvent('PX_inventory:client:open:anim')
        CurrentDrop = 0
    end
    SetNuiFocus(false, false)
    Config.HasInventoryOpen = false
    PlaySoundFrontend(-1, "NAV", "HUD_AMMO_SHOP_SOUNDSET", 1)
    TriggerServerEvent('PX_inventory:server:set:inventory:disabled', false)
end)

RegisterNUICallback("UseItem", function(data, cb)
    TriggerServerEvent("PX_inventory:server:UseItem", data.inventory, data.item)
end)

RegisterNUICallback("UpdateStash", function(data, cb)
    if CurrentVehicle ~= nil then
        TriggerServerEvent("PX_inventory:server:SaveInventory", "trunk", CurrentVehicle)
    elseif CurrentGlovebox ~= nil then
        TriggerServerEvent("PX_inventory:server:SaveInventory", "glovebox", CurrentGlovebox)
    elseif CurrentStash ~= nil then
        TriggerServerEvent("PX_inventory:server:SaveInventory", "stash", CurrentStash)
    else
        TriggerServerEvent("PX_inventory:server:SaveInventory", "drop", CurrentDrop)
    end
end)

RegisterNUICallback("combineItem", function(data)
 Citizen.Wait(150)
 TriggerServerEvent('PX_inventory:server:combineItem', data.reward, data.fromItem, data.toItem)
end)

RegisterNUICallback('combineWithAnim', function(data)
    local combineData = data.combineData
    local aDict = combineData.anim.dict
    local aLib = combineData.anim.lib
    TriggerServerEvent('PX_inventory:server:set:inventory:disabled', true)
    Citizen.SetTimeout(1250, function()
        Config.InventoryBusy = true
        TaskPlayAnim(PlayerPedId(), aDict, aLib, 8.0, 1.0, -1, 49, 0, 0, 0, 0)
        TriggerEvent("mythic_progbar:client:progress", {
            name = "combine",
            duration = 5000,
            label = "Combine...",
            useWhileDead = false,
            canCancel = true,
            controlDisables = {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            }
        }, function(status)
            if not status then
                Config.InventoryBusy = false
                StopAnimTask(PlayerPedId(), aDict, aLib, 1.0)
                TriggerServerEvent('PX_inventory:server:combineItem', combineData.reward, data.requiredItem, data.usedItem, combineData.RemoveToItem)
            else
                Config.InventoryBusy = false
                StopAnimTask(PlayerPedId(), aDict, aLib, 1.0)
                ESX.ShowNotification("Broked!", 'error')
            end
        end)
    end)
end)

RegisterNUICallback("SetInventoryData", function(data, cb)
    TriggerServerEvent("PX_inventory:server:SetInventoryData", data.fromInventory, data.toInventory, data.fromSlot, data.toSlot, data.fromCount, data.toCount)
end)

RegisterNUICallback("PlayDropSound", function(data, cb)
    PlaySound(-1, "CLICK_BACK", "WEB_NAVIGATION_SOUNDS_PHONE", 0, 0, 1)
end)

RegisterNUICallback("PlayDropFail", function(data, cb)
    PlaySound(-1, "Place_Prop_Fail", "DLC_Dmod_Prop_Editor_Sounds", 0, 0, 1)
end)

-- // Events \\ --
RegisterNetEvent('PX_inventory:client:close:inventory')
AddEventHandler('PX_inventory:client:close:inventory', function()
    TriggerServerEvent('PX_inventory:server:set:inventory:disabled', false)
    Citizen.SetTimeout(150, function()
        SendNUIMessage({
            action = "close",
        })
        SetNuiFocus(false, false)
        Config.HasInventoryOpen = false
    end)
end)

RegisterNetEvent('PX_inventory:client:set:busy')
AddEventHandler('PX_inventory:client:set:busy', function(bool)
    Config.InventoryBusy = bool
end)

RegisterNetEvent('PX_inventory:client:CheckOpenState')
AddEventHandler('PX_inventory:client:CheckOpenState', function(type, id, label)
    local name = ESX.SplitStr(label, "-")[2]
    if type == "stash" then
        if name ~= CurrentStash or CurrentStash == nil then
            TriggerServerEvent('PX_inventory:server:SetIsOpenState', false, type, id)
        end
    elseif type == "trunk" then
        if name ~= CurrentVehicle or CurrentVehicle == nil then
            TriggerServerEvent('PX_inventory:server:SetIsOpenState', false, type, id)
        end
    elseif type == "glovebox" then
        if name ~= CurrentGlovebox or CurrentGlovebox == nil then
            TriggerServerEvent('PX_inventory:server:SetIsOpenState', false, type, id)
        end
    end
end)

RegisterNetEvent("PX_inventory:bag:UseBag")
AddEventHandler("PX_inventory:bag:UseBag", function()
    TaskPlayAnim(PlayerPedId(), "clothingshirt", "try_shirt_positive_d", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
    TriggerEvent("mythic_progbar:client:progress", {
        name = "bag",
        duration = 5000,
        label = "Opening Bag",
        useWhileDead = false,
        canCancel = false,
        controlDisables = {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = true,
            disableCombat = true,
        }
    }, function(status)
        TriggerServerEvent("PX_inventory:server:OpenInventory", "stash", "bag_"..ESX.GetPlayerData().identifier)
        TriggerEvent("PX_inventory:client:SetCurrentStash", "bag_"..ESX.GetPlayerData().identifier)
        TriggerServerEvent("InteractSound_SV:PlayOnSource", "stash", 0.5)
        TaskPlayAnim(ped, "clothingshirt", "exit", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
    end)
end)

RegisterNetEvent('PX_weapons:client:set:current:weapon')
AddEventHandler('PX_weapons:client:set:current:weapon', function(data, bool)
    if data ~= false then
        CurrentWeaponData = data
    else
        CurrentWeaponData = {}
    end
end)

RegisterNetEvent('PX_inventory:client:busy:status')
AddEventHandler('PX_inventory:client:busy:status', function(bool)
    CanOpenInventory = bool
end)

RegisterNetEvent('PX_inventory:client:requiredItems')
AddEventHandler('PX_inventory:client:requiredItems', function(items, bool)
    local itemTable = {}
    if bool then
        for k, v in pairs(items) do
            table.insert(itemTable, {
                item = items[k].name,
                label = ESX.Items[items[k].name]["label"],
                image = items[k].image,
            })
        end
    end
    SendNUIMessage({
        action = "requiredItem",
        items = itemTable,
        toggle = bool
    })
end)

RegisterNetEvent('PX_inventory:server:RobPlayer')
AddEventHandler('PX_inventory:server:RobPlayer', function(TargetId)
    SendNUIMessage({
        action = "RobMoney",
        TargetId = TargetId,
    })
end)
Citizen.CreateThread(function()
    while true do

        Citizen.Wait(4)
        if Config.HasInventoryOpen then
            DisableControlAction(0, Config.Keys["1"], true)
            DisableControlAction(0, Config.Keys["2"], true)
            DisableControlAction(0, Config.Keys["3"], true)
            DisableControlAction(0, Config.Keys["4"], true)
            DisableControlAction(0, Config.Keys["5"], true)
        else
            DisableControlAction(0, Config.Keys["Z"], false)
            DisableControlAction(0, Config.Keys["1"], false)
            DisableControlAction(0, Config.Keys["2"], false)
            DisableControlAction(0, Config.Keys["3"], false)
            DisableControlAction(0, Config.Keys["4"], false)
            DisableControlAction(0, Config.Keys["5"], false)
        end
    end
end)

RegisterNetEvent("PX_inventory:client:OpenInventory")
AddEventHandler("PX_inventory:client:OpenInventory", function(inventory, other)
    if not IsEntityDead(PlayerPedId()) then
        SetNuiFocus(true, true)
        if other ~= nil then
            currentOtherInventory = other.name
        end
        SendNUIMessage({
            action = "open",
            inventory = inventory,
            slots = Config.MaxInventorySlots,
            other = other,
            maxweight = 150000,
            playerhp = GetEntityHealth(PlayerPedId()),
            playerarmor = GetPedArmour(PlayerPedId()),
            weedaddiction = 0,
            cokeaddiction = 0,
            alcoholaddiction = 0,
            sodaaddiction = 0,
            junkfoodaddiction =0,
        })
        Config.HasInventoryOpen = true
    end
end)

RegisterNetEvent("PX_inventory:client:UpdatePlayerInventory")
AddEventHandler("PX_inventory:client:UpdatePlayerInventory", function(isError)
    
    SendNUIMessage({
        action = "update",
        inventory = ESX.GetPlayerData().items,
        maxweight = 150000,
        slots = Config.MaxInventorySlots,
        playerhp = GetEntityHealth(PlayerPedId()),
        playerarmor = GetPedArmour(PlayerPedId()),
        weedaddiction = 0,
        cokeaddiction = 0,
        alcoholaddiction = 0,
        sodaaddiction = 0,
        junkfoodaddiction = 0,
        error = isError,
    })
end)

RegisterNetEvent("PX_inventory:client:CraftItems")
AddEventHandler("PX_inventory:client:CraftItems", function(itemName, itemCosts, count, toSlot, points)
    SendNUIMessage({
        action = "close",
    })
    Config.InventoryBusy = true
    TaskPlayAnim(PlayerPedId(), "mini@repair", "fixing_a_player", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
    TriggerEvent("mythic_progbar:client:progress", {
        name = "craft",
        duration = math.random(2000, 5000) * count,
        label = "Crafting...",
        useWhileDead = false,
        canCancel = true,
        controlDisables = {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = true,
            disableCombat = true,
        }
    }, function(status)
        if not status then
            StopAnimTask(PlayerPedId(), "mini@repair", "fixing_a_player", 1.0)
            TriggerServerEvent("PX_inventory:server:CraftItems", itemName, itemCosts, count, toSlot, points)
            Config.InventoryBusy = false
        else
            StopAnimTask(PlayerPedId(), "mini@repair", "fixing_a_player", 1.0)
            ESX.ShowNotification("Broked!", 'error')
            Config.InventoryBusy = false
        end
    end)
end)

RegisterNetEvent("PX_inventory:client:CraftWeapon")
AddEventHandler("PX_inventory:client:CraftWeapon", function(itemName, itemCosts, count, toSlot, ItemType)
    SendNUIMessage({
        action = "close",
    })
    Config.InventoryBusy = true
    TaskPlayAnim(PlayerPedId(), "mini@repair", "fixing_a_player", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
    TriggerEvent("mythic_progbar:client:progress", {
        name = "craft",
        duration = math.random(10000, 12000) * count,
        label = "Crafting...",
        useWhileDead = false,
        canCancel = true,
        controlDisables = {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = true,
            disableCombat = true,
        }
    }, function(status)
        if not status then
            StopAnimTask(PlayerPedId(), "mini@repair", "fixing_a_player", 1.0)
            TriggerServerEvent("PX_inventory:server:CraftWeapon", itemName, itemCosts, count, toSlot, ItemType)
            Config.InventoryBusy = false
        else
            StopAnimTask(PlayerPedId(), "mini@repair", "fixing_a_player", 1.0)
            ESX.ShowNotification("Broked!", 'error')
            Config.InventoryBusy = false
        end
    end)
end)

RegisterNetEvent("PX_inventory:client:UseWeapon")
AddEventHandler("PX_inventory:client:UseWeapon", function(weaponData)
    local weaponName = tostring(weaponData.name)
    if currentWeapon == weaponName then
        SetCurrentPedWeapon(PlayerPedId(), GetHashKey("WEAPON_UNARMED"), true)
        RemoveAllPedWeapons(PlayerPedId(), true)
        TriggerEvent('PX_weapons:client:set:current:weapon', nil)
        currentWeapon = nil
    elseif weaponName == "weapon_stickybomb" then
        GiveWeaponToPed(PlayerPedId(), GetHashKey(weaponName), 1, false, false)
        SetPedAmmo(PlayerPedId(), GetHashKey(weaponName), 1)
        SetCurrentPedWeapon(PlayerPedId(), GetHashKey(weaponName), true)
        TriggerServerEvent('esx:RemoveItem', weaponName, 1)
        TriggerEvent('PX_weapons:client:set:current:weapon', weaponData)
        currentWeapon = weaponName
    elseif weaponName == "weapon_molotov" then
        GiveWeaponToPed(PlayerPedId(), GetHashKey(weaponName), 1, false, false)
        SetPedAmmo(PlayerPedId(), GetHashKey(weaponName), 1)
        SetCurrentPedWeapon(PlayerPedId(), GetHashKey(weaponName), true)
        TriggerEvent('PX_weapons:client:set:current:weapon', weaponData)
        currentWeapon = weaponName
    else    
        TriggerEvent('PX_weapons:client:set:current:weapon', weaponData)
        ESX.TriggerServerCallback("PX_weapon:server:GetWeaponAmmo", function(result)
            local ammo = tonumber(result)
            if weaponName == "weapon_petrolcan" or weaponName == "weapon_fireextinguisher" then 
                ammo = 4000 
            end
            GiveWeaponToPed(PlayerPedId(), GetHashKey(weaponName), ammo, false, false)
            SetPedAmmo(PlayerPedId(), GetHashKey(weaponName), ammo)
            SetCurrentPedWeapon(PlayerPedId(), GetHashKey(weaponName), true)
            if weaponData.info.attachments ~= nil then
                for _, attachment in pairs(weaponData.info.attachments) do
                    GiveWeaponComponentToPed(PlayerPedId(), GetHashKey(weaponName), GetHashKey(attachment.component))
                end
            end
            currentWeapon = weaponName
        end, CurrentWeaponData)
    end
end)

RegisterNetEvent("PX_inventory:client:CheckWeapon")
AddEventHandler("PX_inventory:client:CheckWeapon", function(weaponName)
    if currentWeapon == weaponName then 
        TriggerEvent('PX_assets:ResetHolster')
        SetCurrentPedWeapon(PlayerPedId(), GetHashKey("WEAPON_UNARMED"), true)
        RemoveAllPedWeapons(PlayerPedId(), true)
        currentWeapon = nil
    end
end)

RegisterNetEvent("PX_inventory:client:AddDropItem")
AddEventHandler("PX_inventory:client:AddDropItem", function(dropId, player)
    local coords = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(player)))
    local forward = GetEntityForwardVector(GetPlayerPed(GetPlayerFromServerId(player)))
	local x, y, z = table.unpack(coords + forward * 0.5)
    Drops[dropId] = {
        id = dropId,
        coords = {
            x = x,
            y = y,
            z = z - 0.3,
        },
    }
end)

RegisterNetEvent("PX_inventory:client:RemoveDropItem")
AddEventHandler("PX_inventory:client:RemoveDropItem", function(dropId)
    Drops[dropId] = nil
end)

RegisterNetEvent("PX_inventory:client:DropItemAnim")
AddEventHandler("PX_inventory:client:DropItemAnim", function()
    SendNUIMessage({
        action = "close",
    })
    RequestAnimDict("pickup_object")
    while not HasAnimDictLoaded("pickup_object") do
        Citizen.Wait(7)
    end
    TaskPlayAnim(PlayerPedId(), "pickup_object" ,"pickup_low" ,8.0, -8.0, -1, 1, 0, false, false, false )
    Citizen.Wait(2000)
    ClearPedTasks(PlayerPedId())
end)

RegisterNetEvent("PX_inventory:client:SetCurrentStash")
AddEventHandler("PX_inventory:client:SetCurrentStash", function(stash)
    CurrentStash = stash
end)

RegisterNetEvent('PX_inventory:client:open:anim')
AddEventHandler('PX_inventory:client:open:anim', function()
    RequestAnimationDict('pickup_object')
    TaskPlayAnim(PlayerPedId(), 'pickup_object', 'putdown_low', 5.0, 1.5, 1.0, 48, 0.0, 0, 0, 0)
    Citizen.Wait(1000)
    ClearPedSecondaryTask(PlayerPedId())
end)


-- // Functions \\ --

function ClosestContainer()
    for k, v in pairs(Config.Dumpsters) do
        local StartShape = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0, 0.1, 0)
        local EndShape = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0, 1.8, -0.4)
        local RayCast = StartShapeTestRay(StartShape.x, StartShape.y, StartShape.z, EndShape.x, EndShape.y, EndShape.z, 16, PlayerPedId(), 0)
        local Retval, Hit, Coords, Surface, EntityHit = GetShapeTestResult(RayCast)
        local BinModel = 0
        if EntityHit then
          BinModel = GetEntityModel(EntityHit)
        end
        if v['Model'] == BinModel then
         local EntityHitCoords = GetEntityCoords(EntityHit)
         if EntityHitCoords.x < 0 or EntityHitCoords.y < 0 then
             EntityHitCoords = {x = EntityHitCoords.x + 5000,y = EntityHitCoords.y + 5000}
         end
         return EntityHitCoords
        end
    end
end

function ClosestJailContainer()
  for k, v in pairs(Config.JailContainers) do
      local StartShape = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0, 0.1, 0)
      local EndShape = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0, 1.8, -0.4)
      local RayCast = StartShapeTestRay(StartShape.x, StartShape.y, StartShape.z, EndShape.x, EndShape.y, EndShape.z, 16, PlayerPedId(), 0)
      local Retval, Hit, Coords, Surface, EntityHit = GetShapeTestResult(RayCast)
      local BinModel = 0
      if EntityHit then
        BinModel = GetEntityModel(EntityHit)
      end
      if v['Model'] == BinModel then
       local EntityHitCoords = GetEntityCoords(EntityHit)
       if EntityHitCoords.x < 0 or EntityHitCoords.y < 0 then
           EntityHitCoords = {x = EntityHitCoords.x + 5000,y = EntityHitCoords.y + 5000}
       end
       return EntityHitCoords
      end
  end
end

function OpenTrunk()
    local vehicle = ESX.Game.GetClosestVehicle()
    while (not HasAnimDictLoaded("amb@prop_human_bum_bin@idle_b")) do
        RequestAnimDict("amb@prop_human_bum_bin@idle_b")
        Citizen.Wait(100)
    end
    TaskPlayAnim(PlayerPedId(), "amb@prop_human_bum_bin@idle_b", "idle_d", 4.0, 4.0, -1, 50, 0, false, false, false)
    if (IsBackEngine(GetEntityModel(vehicle))) then
        SetVehicleDoorOpen(vehicle, 4, false, false)
    else
        SetVehicleDoorOpen(vehicle, 5, false, false)
    end
end

function CloseTrunk()
    local vehicle = ESX.Game.GetClosestVehicle()
    while (not HasAnimDictLoaded("amb@prop_human_bum_bin@idle_b")) do
        RequestAnimDict("amb@prop_human_bum_bin@idle_b")
        Citizen.Wait(100)
    end
    TaskPlayAnim(PlayerPedId(), "amb@prop_human_bum_bin@idle_b", "exit", 4.0, 4.0, -1, 50, 0, false, false, false)
    if (IsBackEngine(GetEntityModel(vehicle))) then
        SetVehicleDoorShut(vehicle, 4, false)
    else
        SetVehicleDoorShut(vehicle, 5, false)
    end
end

function IsBackEngine(vehModel)
    for _, model in pairs(Config.BackEngineVehicles) do
        if GetHashKey(model) == vehModel then
            return true
        end
    end
    return false
end

function FormatWeaponAttachments(itemdata)
    local attachments = {}
    itemdata.name = itemdata.name:upper()
    if itemdata.info.attachments ~= nil and next(itemdata.info.attachments) ~= nil then
        for k, v in pairs(itemdata.info.attachments) do
            if Config.WeaponAttachments[itemdata.name] ~= nil then
                for key, value in pairs(Config.WeaponAttachments[itemdata.name]) do
                    if value.component == v.component then
                        table.insert(attachments, {
                            attachment = key,
                            label = value.label
                        })
                    end
                end
            end
        end
    end
    return attachments
end

function RequestAnimationDict(AnimDict)
    RequestAnimDict(AnimDict)
    while not HasAnimDictLoaded(AnimDict) do
        Citizen.Wait(1)
    end
end

RegisterCommand('givecash', function(source, args)
	if args[1] then
		local coords = GetEntityCoords(GetPlayerPed(-1))
		local target, distance = ESX.Game.GetClosestPlayer()
		if GetDistanceBetweenCoords(coords, tcoords, true) < 3 then
			TriggerServerEvent('PX_inventory:givecash', target, args[1])
		else
			TriggerEvent('chatMessage', "[ System ] : ", {255, 0, 0}, "^0Player mored nazar nazdik Shoma nist")
		end
	else
		TriggerEvent('chatMessage', "[ System ] : ", {255, 0, 0}, "^0Shoma Meghdar Vared Nakardid!")
	end
end, false)

RegisterNetEvent("PX_inventory:doCashAnimation")
AddEventHandler("PX_inventory:doCashAnimation", function()
    if not IsPedInAnyVehicle(PlayerPedId(), false) then
        RequestAnimDict('anim@heists@keycard@')
        ClearPedSecondaryTask(PlayerPedId())
        TaskPlayAnim( PlayerPedId(), "anim@heists@keycard@", "exit", 8.0, 1.0, -1, 16, 0, 0, 0, 0 )
        Citizen.Wait(850)
        ClearPedTasks(PlayerPedId())
    end
end)