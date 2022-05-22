local isLoggedIn = false

Keys = {
    ['ESC'] = 322, ['F1'] = 288, ['F2'] = 289, ['F3'] = 170, ['F5'] = 166, ['F6'] = 167, ['F7'] = 168, ['F8'] = 169, ['F9'] = 56, ['F10'] = 57,
    ['~'] = 243, ['1'] = 157, ['2'] = 158, ['3'] = 160, ['4'] = 164, ['5'] = 165, ['6'] = 159, ['7'] = 161, ['8'] = 162, ['9'] = 163, ['-'] = 84, ['='] = 83, ['BACKSPACE'] = 177,
    ['TAB'] = 37, ['Q'] = 44, ['W'] = 32, ['E'] = 38, ['R'] = 45, ['T'] = 245, ['Y'] = 246, ['U'] = 303, ['P'] = 199, ['['] = 39, [']'] = 40, ['ENTER'] = 18,
    ['CAPS'] = 137, ['A'] = 34, ['S'] = 8, ['D'] = 9, ['F'] = 23, ['G'] = 47, ['H'] = 74, ['K'] = 311, ['L'] = 182,
    ['LEFTSHIFT'] = 21, ['Z'] = 20, ['X'] = 73, ['C'] = 26, ['V'] = 0, ['B'] = 29, ['N'] = 249, ['M'] = 244, [','] = 82, ['.'] = 81,
    ['LEFTCTRL'] = 36, ['LEFTALT'] = 19, ['SPACE'] = 22, ['RIGHTCTRL'] = 70,
    ['HOME'] = 213, ['PAGEUP'] = 10, ['PAGEDOWN'] = 11, ['DELETE'] = 178,
    ['LEFT'] = 174, ['RIGHT'] = 175, ['TOP'] = 27, ['DOWN'] = 173,
}

ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        Citizen.Wait(10)
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    end
    if ESX ~= nil then
        isLoggedIn = true
    end
end)

local creatingCharacter = false

local cam = -1

local customCamLocation = nil

local skinData = {
    ["face"] = {
        item = 0,
        texture = 0,
        defaultItem = 0,
        defaultTexture = 0,
    },
    ["pants"] = {
        item = 0,
        texture = 0,
        defaultItem = 0,
        defaultTexture = 0,        
    },
    ["hair"] = {
        item = 0,
        texture = 0,
        defaultItem = 0,
        defaultTexture = 0,        
    },
    ["eyebrows"] = {
        item = -1,
        texture = 1,
        defaultItem = -1,
        defaultTexture = 1,        
    },
    ["beard"] = {
        item = -1,
        texture = 1,
        defaultItem = -1,
        defaultTexture = 1,        
    },
    ["blush"] = {
        item = -1,
        texture = 1,
        defaultItem = -1,
        defaultTexture = 1,        
    },
    ["lipstick"] = {
        item = -1,
        texture = 1,
        defaultItem = -1,
        defaultTexture = 1,        
    },
    ["makeup"] = {
        item = -1,
        texture = 1,
        defaultItem = -1,
        defaultTexture = 1,        
    },
    ["ageing"] = {
        item = -1,
        texture = 0,
        defaultItem = -1,
        defaultTexture = 0,        
    },
    ["arms"] = {
        item = 0,
        texture = 0,
        defaultItem = 0,
        defaultTexture = 0,        
    },
    ["t-shirt"] = {
        item = 1,
        texture = 0,
        defaultItem = 1,
        defaultTexture = 0,        
    },
    ["torso2"] = {
        item = 0,
        texture = 0,
        defaultItem = 0,
        defaultTexture = 0,        
    },
    ["vest"] = {
        item = 0,
        texture = 0,
        defaultItem = 0,
        defaultTexture = 0,        
    },
    ["bag"] = {
        item = 0,
        texture = 0,
        defaultItem = 0,
        defaultTexture = 0,        
    },
    ["shoes"] = {
        item = 0,
        texture = 0,
        defaultItem = 1,
        defaultTexture = 0,        
    },
    ["mask"] = {
        item = 0,
        texture = 0,
        defaultItem = 0,
        defaultTexture = 0,        
    },
    ["hat"] = {
        item = -1,
        texture = 0,
        defaultItem = -1,
        defaultTexture = 0, 
    },
    ["glass"] = {
        item = 0,
        texture = 0,
        defaultItem = 0,
        defaultTexture = 0,
    },
    ["ear"] = {
        item = -1,
        texture = 0,
        defaultItem = -1,
        defaultTexture = 0,
    },
    ["watch"] = {
        item = -1,
        texture = 0,
        defaultItem = -1,
        defaultTexture = 0,
    },
    ["bracelet"] = {
        item = -1,
        texture = 0,
        defaultItem = -1,
        defaultTexture = 0,
    },
    ["accessory"] = {
        item = 0,
        texture = 0,
        defaultItem = 0,
        defaultTexture = 0,      
    },
    ["decals"] = {
        item = 0,
        texture = 0,
        defaultItem = 0,
        defaultTexture = 0,      
    },
}

local previousSkinData = {}

RegisterNetEvent('PX_Loading:playerLoaded')
AddEventHandler('PX_Loading:playerLoaded', function()
    TriggerServerEvent("PX_clothing:loadPlayerSkin")
end)

Citizen.CreateThread(function()
    for k, v in pairs (Config.Stores) do
        if Config.Stores[k].shopType == "clothing" then
            local clothingShop = AddBlipForCoord(Config.Stores[k].x, Config.Stores[k].y, Config.Stores[k].z)
            SetBlipSprite(clothingShop, 366)
            SetBlipColour(clothingShop, 47)
            SetBlipScale  (clothingShop, 0.68)
            SetBlipAsShortRange(clothingShop, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString("Clothing store")
            EndTextCommandSetBlipName(clothingShop)
        end
        if Config.Stores[k].shopType == "barber" then
            local barberShop = AddBlipForCoord(Config.Stores[k].x, Config.Stores[k].y, Config.Stores[k].z)
            SetBlipSprite(barberShop, 71)
            SetBlipColour(barberShop, 0)
            SetBlipScale  (barberShop, 0.68)
            SetBlipAsShortRange(barberShop, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString("Barber Shop")
            EndTextCommandSetBlipName(barberShop)
        end
    end
end)

Citizen.CreateThread(function()
    while true do

        if isLoggedIn then

            local ped = PlayerPedId()
            local pos = GetEntityCoords(ped)

            local inRange = false

            for k, v in pairs(Config.Stores) do
                local dist = GetDistanceBetweenCoords(pos, Config.Stores[k].x, Config.Stores[k].y, Config.Stores[k].z, true)

                if dist < 30 then
                    if not creatingCharacter then
                        DrawMarker(20, Config.Stores[k].x, Config.Stores[k].y, Config.Stores[k].z + 1.0, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.5, 0.3, 0.3, 255, 255, 255, 255, true, true, 2, false, false, false, false)
                        if dist < 5 then
                            ESX.ShowFloatingHelpNotification("Press ~INPUT_CONTEXT~", Config.Stores[k].x, Config.Stores[k].y, Config.Stores[k].z + 1.3)
                            if IsControlJustPressed(0, Keys["E"]) then
                                if Config.Stores[k].shopType == "clothing" then
                                    ESX.TriggerServerCallback('esx:checkPropertyDataStore', function(foundGang)
                                        if foundGang then
                                            ESX.UI.Menu.Open(
                                            'default', GetCurrentResourceName(), 'buy_or_save',
                                            {
                                                title = 'Clothes Shop Selection',
                                                align = 'left',
                                                elements = {
                                                    {label = 'Open Shop', value = 'shop'},
                                                    {label = 'Save For Gang', value = 'save'}
                                                }
                                            }, function(data,menu)
                                                if data.current.value == 'shop' then
                                                    menu.close()
                                                    openClothingMenu()
                                                elseif data.current.value == 'save' then
                                                    menu.close()
                                                    local location = {
                                                        {label = 'Zakhire in Lebas Baraye Gang(1)', value = 'buyforgang'},
                                                        {label = 'Zakhire in Lebas Baraye Gang(2)', value = 'buyforgang2'},
                                                        {label = 'Zakhire in Lebas Baraye Gang(3)', value = 'buyforgang3'}
                                                    }
                                                    ESX.UI.Menu.Open(
													'default', GetCurrentResourceName(), 'where_save',
													{
														title = 'Baraye Kodam Set Save Shavad?',
														align = 'left',
														elements = location
													},
													function(data2, menu2)
                                                        local event = nil
                                                        if data2.current.value == 'buyforgang' then
                                                            event = 'gangs:saveOutfit'
                                                        elseif data2.current.value == 'buyforgang2' then
                                                            event = 'gangs:saveOutfit2'
                                                        elseif data2.current.value == 'buyforgang3' then
                                                            event = 'gangs:saveOutfit3'
                                                        end
                                                        local elements = {}
                                                        for i=1, #foundGang do
                                                            table.insert(elements, {label = foundGang[i].label, value = foundGang[i].grade})
                                                        end
                                                        ESX.UI.Menu.Open(
                                                            'default', GetCurrentResourceName(), 'gang_ranks',
                                                            {
                                                                title = 'Baraye Kodom rank Set Shavad?',
                                                                align = 'left',
                                                                elements = elements
                                                            },
                                                            function(data3, menu3)
                                                                TriggerServerEvent(event, data3.current.value, skinData)
                                                                ESX.ShowNotification('Taghirat Baraye ' .. data3.current.label .. ' Anjam Shod', 'success')
                                                            end, function(data3, menu3)
                                                                menu3.close()
                                                            end)
													end, function(data2, menu2)
														menu2.close()
													end)
                                                end
                                            end, function(data, menu)
                                                menu.close()
                                            end)
                                        else
                                            openClothingMenu()
                                        end
                                    end)
                                elseif Config.Stores[k].shopType == "barber" then
                                    customCamLocation = nil
                                    openMenu({
                                        {menu = "clothing", label = "Hair", selected = true},
                                    })
                                end
                            end
                        end
                    end
                    inRange = true
                end
            end

            if not inRange then
                Citizen.Wait(2000)
            end

        end

        Citizen.Wait(3)
    end
end)

function openClothingMenu()
    customCamLocation = nil
    openMenu({
        {menu = "character", label = "Clothing", selected = true},
        {menu = "accessoires", label = "Accessoires", selected = false}
    })
end

RegisterNetEvent('PX_clothing:client:openOutfitMenu')
AddEventHandler('PX_clothing:client:openOutfitMenu', function()
    ESX.TriggerServerCallback('PX_clothing:server:getOutfits', function(result)
        openMenu({
            {menu = "myOutfits", label = "My Outfits", selected = true, outfits = result},
        })
    end)
end)

RegisterNUICallback('selectOutfit', function(data)
    TriggerEvent('PX_clothing:client:loadOutfit', data)
end)

RegisterNUICallback('rotateRight', function()
    local ped = PlayerPedId()
    local heading = GetEntityHeading(ped)
    SetEntityHeading(ped, heading + 30)
end)

RegisterNUICallback('rotateLeft', function()
    local ped = PlayerPedId()
    local heading = GetEntityHeading(ped)

    SetEntityHeading(ped, heading - 30)
end)

firstChar = false

local clothingCategorys = {
    ["arms"]        = {type = "variation",  id = 3},
    ["t-shirt"]     = {type = "variation",  id = 8},
    ["torso2"]      = {type = "variation",  id = 11},
    ["pants"]       = {type = "variation",  id = 4},
    ["vest"]        = {type = "variation",  id = 9},
    ["shoes"]       = {type = "variation",  id = 6},
    ["bag"]         = {type = "variation",  id = 5},
    ["hair"]        = {type = "hair",       id = 2},
    ["eyebrows"]    = {type = "overlay",    id = 2},
    ["face"]        = {type = "face",       id = 2},
    ["beard"]       = {type = "overlay",    id = 1},
    ["blush"]       = {type = "overlay",    id = 5},
    ["lipstick"]    = {type = "overlay",    id = 8},
    ["makeup"]      = {type = "overlay",    id = 4},
    ["ageing"]      = {type = "ageing",     id = 3},
    ["mask"]        = {type = "mask",       id = 1},
    ["hat"]         = {type = "prop",       id = 0},
    ["glass"]       = {type = "prop",       id = 1},
    ["ear"]         = {type = "prop",       id = 2},
    ["watch"]       = {type = "prop",       id = 6},
    ["bracelet"]    = {type = "prop",       id = 7},
    ["accessory"]   = {type = "variation",  id = 7},
    ["decals"]      = {type = "variation",  id = 10},
}

RegisterNetEvent('PX_clothing:client:openMenu')
AddEventHandler('PX_clothing:client:openMenu', function()
    customCamLocation = nil
    ESX.TriggerServerCallback('PX_clothing:server:getOutfits', function(result)
      openMenu({
          {menu = "character", label = "Character", selected = true},
          {menu = "clothing", label = "Clothing", selected = false},
          {menu = "myOutfits", label = "My Outfits", selected = false, outfits = result},
          {menu = "accessoires", label = "Accessoires", selected = false}
      })
    end)
end)

function GetMaxValues()
    maxModelValues = {
        ["arms"]        = {type = "character", item = 0, texture = 0},
        ["t-shirt"]     = {type = "character", item = 0, texture = 0},
        ["torso2"]      = {type = "character", item = 0, texture = 0},
        ["pants"]       = {type = "character", item = 0, texture = 0},
        ["shoes"]       = {type = "character", item = 0, texture = 0},
        ["face"]        = {type = "character", item = 0, texture = 0},
        ["vest"]        = {type = "character", item = 0, texture = 0},
        ["accessory"]   = {type = "character", item = 0, texture = 0},
        ["decals"]      = {type = "character", item = 0, texture = 0},
        ["bag"]         = {type = "character", item = 0, texture = 0},
        ["hair"]        = {type = "hair", item = 0, texture = 0},
        ["eyebrows"]    = {type = "hair", item = 0, texture = 0},
        ["beard"]       = {type = "hair", item = 0, texture = 0},
        ["blush"]       = {type = "hair", item = 0, texture = 0},
        ["lipstick"]    = {type = "hair", item = 0, texture = 0},
        ["makeup"]      = {type = "hair", item = 0, texture = 0},
        ["ageing"]      = {type = "hair", item = 0, texture = 0},
        ["mask"]        = {type = "accessoires", item = 0, texture = 0},
        ["hat"]         = {type = "accessoires", item = 0, texture = 0},
        ["glass"]       = {type = "accessoires", item = 0, texture = 0},
        ["ear"]         = {type = "accessoires", item = 0, texture = 0},
        ["watch"]       = {type = "accessoires", item = 0, texture = 0},
        ["bracelet"]    = {type = "accessoires", item = 0, texture = 0},
    }
    local ped = PlayerPedId()
    for k, v in pairs(clothingCategorys) do
        if v.type == "variation" then
            maxModelValues[k].item = GetNumberOfPedDrawableVariations(ped, v.id)
            maxModelValues[k].texture = GetNumberOfPedTextureVariations(ped, v.id, GetPedDrawableVariation(ped, v.id)) -1
        end

        if v.type == "hair" then
            maxModelValues[k].item = GetNumberOfPedDrawableVariations(ped, v.id)
            maxModelValues[k].texture = 45
        end

        if v.type == "mask" then
            maxModelValues[k].item = GetNumberOfPedDrawableVariations(ped, v.id)
            maxModelValues[k].texture = GetNumberOfPedTextureVariations(ped, v.id, GetPedDrawableVariation(ped, v.id))
        end

        if v.type == "face" then
            maxModelValues[k].item = 44
            maxModelValues[k].texture = 15
        end

        if v.type == "ageing" then
            maxModelValues[k].item = GetNumHeadOverlayValues(v.id)
            maxModelValues[k].texture = 0
        end

        if v.type == "overlay" then
            maxModelValues[k].item = GetNumHeadOverlayValues(v.id)
            maxModelValues[k].texture = 45
        end

        if v.type == "prop" then
            maxModelValues[k].item = GetNumberOfPedPropDrawableVariations(ped, v.id)
            maxModelValues[k].texture = GetNumberOfPedPropTextureVariations(ped, v.id, GetPedPropIndex(ped, v.id))
        end
    end

    SendNUIMessage({
        action = "updateMax",
        maxValues = maxModelValues
    })
end

function openMenu(allowedMenus)
    previousSkinData = json.encode(skinData)
    creatingCharacter = true
    local trackerMeta = false
    GetMaxValues()
    TriggerEvent("PX_Clothing:inMenu", true)
    SendNUIMessage({
        action = "open",
        menus = allowedMenus,
        currentClothing = skinData,
        hasTracker = trackerMeta,
    })
    SetNuiFocus(true, true)
    SetCursorLocation(0.9, 0.25)
    FreezeEntityPosition(PlayerPedId(), true)
    enableCam()
end

RegisterNUICallback('TrackerError', function()
    TriggerEvent('chatMessage', "SYSTEM", "error", "You cant remove an ankle bracelet..")
end)

RegisterNUICallback('saveOutfit', function(data, cb)
    TriggerServerEvent('PX_clothing:saveOutfit', data.outfitName, skinData)
end)

RegisterNetEvent('PX_clothing:client:reloadOutfits')
AddEventHandler('PX_clothing:client:reloadOutfits', function(myOutfits)
    SendNUIMessage({
        action = "reloadMyOutfits",
        outfits = myOutfits
    })
end)

function enableCam()
    -- Camera
    local coords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0, 2.0, 0)
    RenderScriptCams(false, false, 0, 1, 0)
    DestroyCam(cam, false)
    if(not DoesCamExist(cam)) then
        cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
        SetCamActive(cam, true)
        RenderScriptCams(true, false, 0, true, true)
        SetCamCoord(cam, coords.x, coords.y, coords.z + 0.5)
        SetCamRot(cam, 0.0, 0.0, GetEntityHeading(PlayerPedId()) + 180)
    end
    if customCamLocation ~= nil then
        SetCamCoord(cam, customCamLocation.x, customCamLocation.y, customCamLocation.z)
    end
end

RegisterNUICallback('rotateCam', function(data)
    local rotType = data.type
    local ped = PlayerPedId()
    local coords = GetOffsetFromEntityInWorldCoords(ped, 0, 2.0, 0)

    if rotType == "left" then
        SetEntityHeading(ped, GetEntityHeading(ped) - 10)
        SetCamCoord(cam, coords.x, coords.y, coords.z + 0.5)
        SetCamRot(cam, 0.0, 0.0, GetEntityHeading(ped) + 180)
    else
        SetEntityHeading(ped, GetEntityHeading(ped) + 10)
        SetCamCoord(cam, coords.x, coords.y, coords.z + 0.5)
        SetCamRot(cam, 0.0, 0.0, GetEntityHeading(ped) + 180)
    end
end)

RegisterNUICallback('setupCam', function(data)
    local value = data.value

    if value == 1 then
        local coords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0, 0.75, 0)
        SetCamCoord(cam, coords.x, coords.y, coords.z + 0.65)
    elseif value == 2 then
        local coords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0, 1.0, 0)
        SetCamCoord(cam, coords.x, coords.y, coords.z + 0.2)
    elseif value == 3 then
        local coords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0, 1.0, 0)
        SetCamCoord(cam, coords.x, coords.y, coords.z + -0.5)
    else
        local coords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0, 2.0, 0)
        SetCamCoord(cam, coords.x, coords.y, coords.z + 0.5)
    end
end)

function disableCam()
    RenderScriptCams(false, true, 250, 1, 0)
    DestroyCam(cam, false)

    FreezeEntityPosition(PlayerPedId(), false)
end

function closeMenu()
    SendNUIMessage({
        action = "close",
    })
    disableCam()
end

RegisterNUICallback('resetOutfit', function()
    resetClothing(json.decode(previousSkinData))
    skinData = json.decode(previousSkinData)
    previousSkinData = {}
end)

function resetClothing(data)
    local ped = PlayerPedId()

    -- Face
    SetPedHeadBlendData(ped, data["face"].item, data["face"].item, data["face"].item, data["face"].texture, data["face"].texture, data["face"].texture, 1.0, 1.0, 1.0, true)

    -- Pants
    SetPedComponentVariation(ped, 4, data["pants"].item, 0, 0)
    SetPedComponentVariation(ped, 4, data["pants"].item, data["pants"].texture, 0)

    -- Hair
    SetPedComponentVariation(ped, 2, data["hair"].item, 0, 0)
    SetPedHairColor(ped, data["hair"].texture, data["hair"].texture)

    -- Eyebrows
    SetPedHeadOverlay(ped, 2, data["eyebrows"].item, 1.0)
    SetPedHeadOverlayColor(ped, 2, 1, data["eyebrows"].texture, 0)

    -- Beard
    SetPedHeadOverlay(ped, 1, data["beard"].item, 1.0)
    SetPedHeadOverlayColor(ped, 1, 1, data["beard"].texture, 0)

    -- Blush
    SetPedHeadOverlay(ped, 5, data["blush"].item, 1.0)
    SetPedHeadOverlayColor(ped, 5, 1, data["blush"].texture, 0)

    -- Lipstick
    SetPedHeadOverlay(ped, 8, data["lipstick"].item, 1.0)
    SetPedHeadOverlayColor(ped, 8, 1, data["lipstick"].item, 0)

    -- Makeup
    SetPedHeadOverlay(ped, 4, data["makeup"].item, 1.0)
    SetPedHeadOverlayColor(ped, 4, 1, data["makeup"].texture, 0)

    -- Ageing
    SetPedHeadOverlay(ped, 3, data["ageing"].item, 1.0)
    SetPedHeadOverlayColor(ped, 3, 1, data["ageing"].texture, 0)

    -- Arms
    SetPedComponentVariation(ped, 3, data["arms"].item, 0, 2)
    SetPedComponentVariation(ped, 3, data["arms"].item, data["arms"].texture, 0)

    -- T-Shirt
    SetPedComponentVariation(ped, 8, data["t-shirt"].item, 0, 2)
    SetPedComponentVariation(ped, 8, data["t-shirt"].item, data["t-shirt"].texture, 0)

    -- Vest
    SetPedComponentVariation(ped, 9, data["vest"].item, 0, 2)
    SetPedComponentVariation(ped, 9, data["vest"].item, data["vest"].texture, 0)

    -- Torso 2
    SetPedComponentVariation(ped, 11, data["torso2"].item, 0, 2)
    SetPedComponentVariation(ped, 11, data["torso2"].item, data["torso2"].texture, 0)

    -- Shoes
    SetPedComponentVariation(ped, 6, data["shoes"].item, 0, 2)
    SetPedComponentVariation(ped, 6, data["shoes"].item, data["shoes"].texture, 0)

    -- Mask
    SetPedComponentVariation(ped, 1, data["mask"].item, 0, 2)
    SetPedComponentVariation(ped, 1, data["mask"].item, data["mask"].texture, 0)

    -- Badge
    SetPedComponentVariation(ped, 10, data["decals"].item, 0, 2)
    SetPedComponentVariation(ped, 10, data["decals"].item, data["decals"].texture, 0)

    -- Accessory
    SetPedComponentVariation(ped, 7, data["accessory"].item, 0, 2)
    SetPedComponentVariation(ped, 7, data["accessory"].item, data["accessory"].texture, 0)

    -- Bag
    SetPedComponentVariation(ped, 5, data["bag"].item, 0, 2)
    SetPedComponentVariation(ped, 5, data["bag"].item, data["bag"].texture, 0)

    -- Hat
    if data["hat"].item ~= -1 and data["hat"].item ~= 0 then
        SetPedPropIndex(ped, 0, data["hat"].item, data["hat"].texture, true)
    else
        ClearPedProp(ped, 0)
    end

    -- Glass
    if data["glass"].item ~= -1 and data["glass"].item ~= 0 then
        SetPedPropIndex(ped, 1, data["glass"].item, data["glass"].texture, true)
    else
        ClearPedProp(ped, 1)
    end

    -- Ear
    if data["ear"].item ~= -1 and data["ear"].item ~= 0 then
        SetPedPropIndex(ped, 2, data["ear"].item, data["ear"].texture, true)
    else
        ClearPedProp(ped, 2)
    end

    -- Watch
    if data["watch"].item ~= -1 and data["watch"].item ~= 0 then
        SetPedPropIndex(ped, 6, data["watch"].item, data["watch"].texture, true)
    else
        ClearPedProp(ped, 6)
    end

    -- Bracelet
    if data["bracelet"].item ~= -1 and data["bracelet"].item ~= 0 then
        SetPedPropIndex(ped, 7, data["bracelet"].item, data["bracelet"].texture, true)
    else
        ClearPedProp(ped, 7)
    end
end

RegisterNUICallback('close', function()
    TriggerEvent("PX_Clothing:inMenu", false)
    SetNuiFocus(false, false)
    creatingCharacter = false
    disableCam()
    FreezeEntityPosition(PlayerPedId(), false)
end)

RegisterNUICallback('getCatergoryItems', function(data, cb)
    cb(Config.Menus[data.category])
end)

RegisterNUICallback('updateSkin', function(data)
    ChangeVariation(data)
end)

RegisterNUICallback('updateSkinOnInput', function(data)
    ChangeVariation(data)
end)

RegisterNUICallback('removeOutfit', function(data, cb)
    TriggerServerEvent('PX_clothing:server:removeOutfit', data.outfitName, data.outfitId)
end)

function ChangeVariation(data)
    local ped = PlayerPedId()
    local clothingCategory = data.clothingType
    local type = data.type
    local item = data.articleNumber

    if clothingCategory == "pants" then
        if type == "item" then
            SetPedComponentVariation(ped, 4, item, 0, 0)
            skinData["pants"].item = item
        elseif type == "texture" then
            local curItem = GetPedDrawableVariation(ped, 4)
            SetPedComponentVariation(ped, 4, curItem, item, 0)
            skinData["pants"].texture = item
        end
    elseif clothingCategory == "face" then
        if type == "item" then
            SetPedHeadBlendData(ped, tonumber(item), tonumber(item), tonumber(item), skinData["face"].texture, skinData["face"].texture, skinData["face"].texture, 1.0, 1.0, 1.0, true)
            skinData["face"].item = item
        elseif type == "texture" then
            SetPedHeadBlendData(ped, skinData["face"].item, skinData["face"].item, skinData["face"].item, item, item, item, 1.0, 1.0, 1.0, true)
            skinData["face"].texture = item
        end
    elseif clothingCategory == "hair" then
        SetPedHeadBlendData(ped, skinData["face"].item, skinData["face"].item, skinData["face"].item, skinData["face"].texture, skinData["face"].texture, skinData["face"].texture, 1.0, 1.0, 1.0, true)
        if type == "item" then
            SetPedComponentVariation(ped, 2, item, 0, 0)
            skinData["hair"].item = item
        elseif type == "texture" then
            SetPedHairColor(ped, item, item)
            skinData["hair"].texture = item
        end
    elseif clothingCategory == "eyebrows" then
        if type == "item" then
            SetPedHeadOverlay(ped, 2, item, 1.0)
            skinData["eyebrows"].item = item
        elseif type == "texture" then
            SetPedHeadOverlayColor(ped, 2, 1, item, 0)
            skinData["eyebrows"].texture = item
        end
    elseif clothingCategory == "beard" then
        if type == "item" then
            SetPedHeadOverlay(ped, 1, item, 1.0)
            skinData["beard"].item = item
        elseif type == "texture" then
            SetPedHeadOverlayColor(ped, 1, 1, item, 0)
            skinData["beard"].texture = item
        end
    elseif clothingCategory == "blush" then
        if type == "item" then
            SetPedHeadOverlay(ped, 5, item, 1.0)
            skinData["blush"].item = item
        elseif type == "texture" then
            SetPedHeadOverlayColor(ped, 5, 1, item, 0)
            skinData["blush"].texture = item
        end
    elseif clothingCategory == "lipstick" then
        if type == "item" then
            SetPedHeadOverlay(ped, 8, item, 1.0)
            skinData["lipstick"].item = item
        elseif type == "texture" then
            SetPedHeadOverlayColor(ped, 8, 1, item, 0)
            skinData["lipstick"].texture = item
        end
    elseif clothingCategory == "makeup" then
        if type == "item" then
            SetPedHeadOverlay(ped, 4, item, 1.0)
            skinData["makeup"].item = item
        elseif type == "texture" then
            SetPedHeadOverlayColor(ped, 4, 1, item, 0)
            skinData["makeup"].texture = item
        end
    elseif clothingCategory == "ageing" then
        if type == "item" then
            SetPedHeadOverlay(ped, 3, item, 1.0)
            skinData["ageing"].item = item
        elseif type == "texture" then
            SetPedHeadOverlayColor(ped, 3, 1, item, 0)
            skinData["ageing"].texture = item
        end
    elseif clothingCategory == "arms" then
        if type == "item" then
            SetPedComponentVariation(ped, 3, item, 0, 2)
            skinData["arms"].item = item
        elseif type == "texture" then
            local curItem = GetPedDrawableVariation(ped, 3)
            SetPedComponentVariation(ped, 3, curItem, item, 0)
            skinData["arms"].texture = item
        end
    elseif clothingCategory == "t-shirt" then
        if type == "item" then
            SetPedComponentVariation(ped, 8, item, 0, 2)
            skinData["t-shirt"].item = item
        elseif type == "texture" then
            local curItem = GetPedDrawableVariation(ped, 8)
            SetPedComponentVariation(ped, 8, curItem, item, 0)
            skinData["t-shirt"].texture = item
        end
    elseif clothingCategory == "vest" then
        if type == "item" then
            SetPedComponentVariation(ped, 9, item, 0, 2)
            skinData["vest"].item = item
        elseif type == "texture" then
            SetPedComponentVariation(ped, 9, skinData["vest"].item, item, 0)
            skinData["vest"].texture = item
        end
    elseif clothingCategory == "bag" then
        if type == "item" then
            SetPedComponentVariation(ped, 5, item, 0, 2)
            skinData["bag"].item = item
        elseif type == "texture" then
            SetPedComponentVariation(ped, 5, skinData["bag"].item, item, 0)
            skinData["bag"].texture = item
        end
    elseif clothingCategory == "decals" then
        if type == "item" then
            SetPedComponentVariation(ped, 10, item, 0, 2)
            skinData["decals"].item = item
        elseif type == "texture" then
            SetPedComponentVariation(ped, 10, skinData["decals"].item, item, 0)
            skinData["decals"].texture = item
        end
    elseif clothingCategory == "accessory" then
        if type == "item" then
            SetPedComponentVariation(ped, 7, item, 0, 2)
            skinData["accessory"].item = item
        elseif type == "texture" then
            SetPedComponentVariation(ped, 7, skinData["accessory"].item, item, 0)
            skinData["accessory"].texture = item
        end
    elseif clothingCategory == "torso2" then
        if type == "item" then
            SetPedComponentVariation(ped, 11, item, 0, 2)
            skinData["torso2"].item = item
        elseif type == "texture" then
            local curItem = GetPedDrawableVariation(ped, 11)
            SetPedComponentVariation(ped, 11, curItem, item, 0)
            skinData["torso2"].texture = item
        end
    elseif clothingCategory == "shoes" then
        if type == "item" then
            SetPedComponentVariation(ped, 6, item, 0, 2)
            skinData["shoes"].item = item
        elseif type == "texture" then
            local curItem = GetPedDrawableVariation(ped, 6)
            SetPedComponentVariation(ped, 6, curItem, item, 0)
            skinData["shoes"].texture = item
        end
    elseif clothingCategory == "mask" then
        if type == "item" then
            SetPedComponentVariation(ped, 1, item, 0, 2)
            skinData["mask"].item = item
        elseif type == "texture" then
            local curItem = GetPedDrawableVariation(ped, 1)
            SetPedComponentVariation(ped, 1, curItem, item, 0)
            skinData["mask"].texture = item
        end
    elseif clothingCategory == "hat" then
        if type == "item" then
            if item ~= -1 then
                SetPedPropIndex(ped, 0, item, skinData["hat"].texture, true)
            else
                ClearPedProp(ped, 0)
            end
            skinData["hat"].item = item
        elseif type == "texture" then
            SetPedPropIndex(ped, 0, skinData["hat"].item, item, true)
            skinData["hat"].texture = item
        end
    elseif clothingCategory == "glass" then
        if type == "item" then
            if item ~= -1 then
                SetPedPropIndex(ped, 1, item, skinData["glass"].texture, true)
                skinData["glass"].item = item
            else
                ClearPedProp(ped, 1)
            end
        elseif type == "texture" then
            SetPedPropIndex(ped, 1, skinData["glass"].item, item, true)
            skinData["glass"].texture = item
        end
    elseif clothingCategory == "ear" then
        if type == "item" then
            if item ~= -1 then
                SetPedPropIndex(ped, 2, item, skinData["ear"].texture, true)
            else
                ClearPedProp(ped, 2)
            end
            skinData["ear"].item = item
        elseif type == "texture" then
            SetPedPropIndex(ped, 2, skinData["ear"].item, item, true)
            skinData["ear"].texture = item
        end
    elseif clothingCategory == "watch" then
        if type == "item" then
            if item ~= -1 then
                SetPedPropIndex(ped, 6, item, skinData["watch"].texture, true)
            else
                ClearPedProp(ped, 6)
            end
            skinData["watch"].item = item
        elseif type == "texture" then
            SetPedPropIndex(ped, 6, skinData["watch"].item, item, true)
            skinData["watch"].texture = item
        end
    elseif clothingCategory == "bracelet" then
        if type == "item" then
            if item ~= -1 then
                SetPedPropIndex(ped, 7, item, skinData["bracelet"].texture, true)
            else
                ClearPedProp(ped, 7)
            end
            skinData["bracelet"].item = item
        elseif type == "texture" then
            SetPedPropIndex(ped, 7, skinData["bracelet"].item, item, true)
            skinData["bracelet"].texture = item
        end
    end
    GetMaxValues()
end

function ChangeToSkinNoUpdate(skin)
    local model = GetHashKey(skin)
    Citizen.CreateThread(function()
        RequestModel(model)
        while not HasModelLoaded(model) do
            RequestModel(model)
            Citizen.Wait(0)
        end
        SetPlayerModel(PlayerId(), model)
        SetPedComponentVariation(PlayerPedId(), 0, 0, 0, 2)

        for k, v in pairs(skinData) do
            if skin == "mp_m_freemode_01" or skin == "mp_f_freemode_01" then
                ChangeVariation({
                    clothingType = k,
                    articleNumber = v.defaultItem,
                    type = "item",
                })
            else
                if k ~= "face" and k ~= "hair" then
                    ChangeVariation({
                        clothingType = k,
                        articleNumber = v.defaultItem,
                        type = "item",
                    })
                end
            end
            if skin == "mp_m_freemode_01" or skin == "mp_f_freemode_01" then
                ChangeVariation({
                    clothingType = k,
                    articleNumber = v.defaultTexture,
                    type = "texture",
                })
            else
                if k ~= "face" and k ~= "hair" then
                    ChangeVariation({
                        clothingType = k,
                        articleNumber = v.defaultTexture,
                        type = "texture",
                    })
                end
            end
        end
    end)
end

RegisterNUICallback('saveClothing', function(data)
    SaveSkin()
end)

function SaveSkin()
	TriggerServerEvent("PX_clothing:saveSkin", json.encode(skinData))
end

RegisterNetEvent('PX_clothing:CreateFirstCharacter')
AddEventHandler('PX_clothing:CreateFirstCharacter', function(gender)
    local skin = "mp_m_freemode_01"
    openMenu({
        {menu = "character", label = "Character", selected = true},
        {menu = "clothing", label = "Clothing", selected = false},
        {menu = "accessoires", label = "Accessoires", selected = false}
    })
    if gender == 1 then
        skin = "mp_f_freemode_01"
    end
    ChangeToSkinNoUpdate(skin)
    SendNUIMessage({
        action = "ResetValues",
    })
end)

RegisterNetEvent("PX_clothing:loadSkin")
AddEventHandler("PX_clothing:loadSkin", function(model, data)
    Citizen.CreateThread(function()
        RequestModel(model)
        while not HasModelLoaded(model) do
            RequestModel(model)
            Citizen.Wait(0)
        end
        SetPlayerModel(PlayerId(), model)
        SetPedComponentVariation(PlayerPedId(), 0, 0, 0, 2)
        data = json.decode(data)
        TriggerEvent('PX_clothing:client:loadPlayerClothing', data, PlayerPedId())
    end)
end)

RegisterNetEvent('PX_clothing:client:loadPlayerClothing')
AddEventHandler('PX_clothing:client:loadPlayerClothing', function(data)
    local ped = PlayerPedId()

    for i = 0, 11 do
        SetPedComponentVariation(ped, i, 0, 0, 0)
    end

    for i = 0, 7 do
        ClearPedProp(ped, i)
    end

    -- Face
    SetPedHeadBlendData(ped, data["face"].item, data["face"].item, data["face"].item, data["face"].texture, data["face"].texture, data["face"].texture, 1.0, 1.0, 1.0, true)

    -- Pants
    SetPedComponentVariation(ped, 4, data["pants"].item, 0, 0)
    SetPedComponentVariation(ped, 4, data["pants"].item, data["pants"].texture, 0)

    -- Hair
    SetPedComponentVariation(ped, 2, data["hair"].item, 0, 0)
    SetPedHairColor(ped, data["hair"].texture, data["hair"].texture)

    -- Eyebrows
    SetPedHeadOverlay(ped, 2, data["eyebrows"].item, 1.0)
    SetPedHeadOverlayColor(ped, 2, 1, data["eyebrows"].texture, 0)

    -- Beard
    SetPedHeadOverlay(ped, 1, data["beard"].item, 1.0)
    SetPedHeadOverlayColor(ped, 1, 1, data["beard"].texture, 0)

    -- Blush
    SetPedHeadOverlay(ped, 5, data["blush"].item, 1.0)
    SetPedHeadOverlayColor(ped, 5, 1, data["blush"].texture, 0)

    -- Lipstick
    SetPedHeadOverlay(ped, 8, data["lipstick"].item, 1.0)
    SetPedHeadOverlayColor(ped, 8, 1, data["lipstick"].texture, 0)

    -- Makeup
    SetPedHeadOverlay(ped, 4, data["makeup"].item, 1.0)
    SetPedHeadOverlayColor(ped, 4, 1, data["makeup"].texture, 0)

    -- Ageing
    SetPedHeadOverlay(ped, 3, data["ageing"].item, 1.0)
    SetPedHeadOverlayColor(ped, 3, 1, data["ageing"].texture, 0)

    -- Arms
    SetPedComponentVariation(ped, 3, data["arms"].item, 0, 2)
    SetPedComponentVariation(ped, 3, data["arms"].item, data["arms"].texture, 0)

    -- T-Shirt
    SetPedComponentVariation(ped, 8, data["t-shirt"].item, 0, 2)
    SetPedComponentVariation(ped, 8, data["t-shirt"].item, data["t-shirt"].texture, 0)

    -- Vest
    SetPedComponentVariation(ped, 9, data["vest"].item, 0, 2)
    SetPedComponentVariation(ped, 9, data["vest"].item, data["vest"].texture, 0)

    -- Torso 2
    SetPedComponentVariation(ped, 11, data["torso2"].item, 0, 2)
    SetPedComponentVariation(ped, 11, data["torso2"].item, data["torso2"].texture, 0)

    -- Shoes
    SetPedComponentVariation(ped, 6, data["shoes"].item, 0, 2)
    SetPedComponentVariation(ped, 6, data["shoes"].item, data["shoes"].texture, 0)

    -- Mask
    SetPedComponentVariation(ped, 1, data["mask"].item, 0, 2)
    SetPedComponentVariation(ped, 1, data["mask"].item, data["mask"].texture, 0)

    -- Badge
    SetPedComponentVariation(ped, 10, data["decals"].item, 0, 2)
    SetPedComponentVariation(ped, 10, data["decals"].item, data["decals"].texture, 0)

    -- Accessory
    SetPedComponentVariation(ped, 7, data["accessory"].item, 0, 2)
    SetPedComponentVariation(ped, 7, data["accessory"].item, data["accessory"].texture, 0)

    -- Bag
    SetPedComponentVariation(ped, 5, data["bag"].item, 0, 2)
    SetPedComponentVariation(ped, 5, data["bag"].item, data["bag"].texture, 0)

    -- Hat
    if data["hat"].item ~= -1 and data["hat"].item ~= 0 then
        SetPedPropIndex(ped, 0, data["hat"].item, data["hat"].texture, true)
    else
        ClearPedProp(ped, 0)
    end

    -- Glass
    if data["glass"].item ~= -1 and data["glass"].item ~= 0 then
        SetPedPropIndex(ped, 1, data["glass"].item, data["glass"].texture, true)
    else
        ClearPedProp(ped, 1)
    end

    -- Ear
    if data["ear"].item ~= -1 and data["ear"].item ~= 0 then
        SetPedPropIndex(ped, 2, data["ear"].item, data["ear"].texture, true)
    else
        ClearPedProp(ped, 2)
    end

    -- Watch
    if data["watch"].item ~= -1 and data["watch"].item ~= 0 then
        SetPedPropIndex(ped, 6, data["watch"].item, data["watch"].texture, true)
    else
        ClearPedProp(ped, 6)
    end

    -- Bracelet
    if data["bracelet"].item ~= -1 and data["bracelet"].item ~= 0 then
        SetPedPropIndex(ped, 7, data["bracelet"].item, data["bracelet"].texture, true)
    else
        ClearPedProp(ped, 7)
    end

    skinData = data
    TriggerEvent("dpc:ResetClothing")
end)

function typeof(var)
    local _type = type(var);
    if(_type ~= "table" and _type ~= "userdata") then
        return _type;
    end
    local _meta = getmetatable(var);
    if(_meta ~= nil and _meta._NAME ~= nil) then
        return _meta._NAME;
    else
        return _type;
    end
end

RegisterNetEvent('PX_clothing:client:loadOutfit')
AddEventHandler('PX_clothing:client:loadOutfit', function(oData)
    if not oData then
        return ESX.ShowNotification("Nothing To Wear!", 'error')
    end
    local ped = PlayerPedId()

    data = oData

    if typeof(data) ~= "table" then data = json.decode(data) end

    for k, v in pairs(data) do
        skinData[k].item = data[k].item
        skinData[k].texture = data[k].texture
    end

    -- Pants
    if data["pants"] ~= nil then
        SetPedComponentVariation(ped, 4, data["pants"].item, data["pants"].texture, 0)
    end

    -- Arms
    if data["arms"] ~= nil then
        SetPedComponentVariation(ped, 3, data["arms"].item, data["arms"].texture, 0)
    end

    -- T-Shirt
    if data["t-shirt"] ~= nil then
        SetPedComponentVariation(ped, 8, data["t-shirt"].item, data["t-shirt"].texture, 0)
    end

    -- Vest
    if data["vest"] ~= nil then
        SetPedComponentVariation(ped, 9, data["vest"].item, data["vest"].texture, 0)
    end

    -- Torso 2
    if data["torso2"] ~= nil then
        SetPedComponentVariation(ped, 11, data["torso2"].item, data["torso2"].texture, 0)
    end

    -- Shoes
    if data["shoes"] ~= nil then
        SetPedComponentVariation(ped, 6, data["shoes"].item, data["shoes"].texture, 0)
    end

    -- Bag
    if data["bag"] ~= nil then
        SetPedComponentVariation(ped, 5, data["bag"].item, data["bag"].texture, 0)
    end

    -- Badge
    if data["badge"] ~= nil then
        SetPedComponentVariation(ped, 10, data["decals"].item, data["decals"].texture, 0)
    end

    -- Accessory
    if data["accessory"] ~= nil then
        SetPedComponentVariation(ped, 7, data["accessory"].item, data["accessory"].texture, 0)
    else
        SetPedComponentVariation(ped, 7, -1, 0, 2)
    end

    -- Mask
    if data["mask"] ~= nil then
        SetPedComponentVariation(ped, 1, data["mask"].item, data["mask"].texture, 0)
    end

    -- Bag
    if data["bag"] ~= nil then
        SetPedComponentVariation(ped, 5, data["bag"].item, data["bag"].texture, 0)
    end

    -- Hat
    if data["hat"] ~= nil then
        if data["hat"].item ~= -1 and data["hat"].item ~= 0 then
            SetPedPropIndex(ped, 0, data["hat"].item, data["hat"].texture, true)
        else
            ClearPedProp(ped, 0)
        end
    end

    -- Glass
    if data["glass"] ~= nil then
        if data["glass"].item ~= -1 and data["glass"].item ~= 0 then
            SetPedPropIndex(ped, 1, data["glass"].item, data["glass"].texture, true)
        else
            ClearPedProp(ped, 1)
        end
    end

    -- Ear
    if data["ear"] ~= nil then
        if data["ear"].item ~= -1 and data["ear"].item ~= 0 then
            SetPedPropIndex(ped, 2, data["ear"].item, data["ear"].texture, true)
        else
            ClearPedProp(ped, 2)
        end
    end
    TriggerEvent("dpc:ResetClothing")
end)

RegisterNUICallback('Sound', function()
    PlaySound(-1, "CLICK_BACK", "WEB_NAVIGATION_SOUNDS_PHONE", 0, 0, 1)
end)

AddEventHandler("PX_clothing:getSkin", function(cb)
    cb(skinData)
end)

AddEventHandler("PX_clothing:loadPed", function(model)
    Citizen.CreateThread(function()
        RequestModel(model)
        while not HasModelLoaded(model) do
            RequestModel(model)
            Citizen.Wait(0)
        end
        SetPlayerModel(PlayerId(), model)
        SetPedComponentVariation(PlayerPedId(), 0, 0, 0, 2)
        ChangeToSkinNoUpdate(model)
        SendNUIMessage({
            action = "ResetValues",
        })
    end)
end)

RegisterNetEvent("PX_clothing:useMask")
AddEventHandler("PX_clothing:useMask", function(item)
    if skinData["mask"].item ~= 0 then
        TriggerServerEvent("PX_clothing:addMask", skinData["mask"].item, skinData["mask"].texture)
    end
    local Ped = PlayerPedId()
	while not HasAnimDictLoaded("mp_masks@standard_car@ds@") do RequestAnimDict("mp_masks@standard_car@ds@") Wait(100) end
	TaskPlayAnim(Ped, "mp_masks@standard_car@ds@", "put_on_mask", 3.0, 3.0, 800, 51, 0, false, false, false)
	Wait(500)
    SetPedComponentVariation(PlayerPedId(), 1, item.number, item.color, 0)
    skinData["mask"].item = item.number
    skinData["mask"].texture = item.color
    SaveSkin()
end)

RegisterNetEvent("PX_clothing:addMask")
AddEventHandler("PX_clothing:addMask", function(number, color)
    if number == 0 then
        return
    end
    TriggerServerEvent("PX_clothing:addMask", number, color)
    skinData["mask"].item = 0
    skinData["mask"].texture = 0
    SaveSkin()
end)