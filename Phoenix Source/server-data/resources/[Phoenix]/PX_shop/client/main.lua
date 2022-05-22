--[[ Gets the ESX library ]]--
ESX = nil 

Keys = {["E"] = 38, ["L"] = 182, ["G"] = 47}

local HasAlreadyEnteredMarker = false
local LastZone                = nil
local CurrentAction           = nil
local CurrentActionMsg        = ''
local CurrentActionData       = {}


Citizen.CreateThread(function()
    local Marketblip = AddBlipForCoord(Config.buy.pos.x, Config.buy.pos.y, Config.buy.pos.z)
    SetBlipSprite(Marketblip, 272)
    SetBlipDisplay(Marketblip, 4)
    SetBlipScale(Marketblip, 1.0)
    SetBlipColour(Marketblip, 1)
    SetBlipAsShortRange(Marketblip, true)

    BeginTextCommandSetBlipName("gasblip")
    AddTextEntry("gasblip", 'Items Market')
    EndTextCommandSetBlipName(Marketblip)
end)

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
    ESX.TriggerServerCallback('PX_shop:getShops', function(shops)
        for i=1, #shops do
           Locations[shops[i].number]["owner"] = json.decode(shops[i].owner)
           Locations[shops[i].number]["shop"] = json.decode(shops[i].value)
           Locations[shops[i].number]["blip"]["name"] = shops[i].name
        end

        CreateBlips()
        DrawAll()
    end)
end)

function DrawText3D(x, y, z, text)
    local onScreen,x,y = World3dToScreen2d(x, y, z)
    local factor = #text / 370

    if onScreen then
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(x,y)
        DrawRect(x,y + 0.0125, 0.015 + factor, 0.03, 41, 11, 41, 120)
    end
end

--[[ Requests specified model ]]--
_RequestModel = function(hash)
    if type(hash) == "string" then hash = GetHashKey(hash) end
    RequestModel(hash)
    while not HasModelLoaded(hash) do
        Wait(0)
    end
end

--[[ Deletes the cashiers ]]--
DeleteCashier = function()
    for i=1, #Locations do
        local cashier = Locations[i]["cashier"]
        if DoesEntityExist(cashier["entity"]) then
            DeletePed(cashier["entity"])
            SetPedAsNoLongerNeeded(cashier["entity"])
        end
    end
end

-- [[ Fetch owned shops on client side ]]
RegisterNetEvent('PX_shop:passTheShops')
AddEventHandler('PX_shop:passTheShops', function (ownedShops)
    for i=1, #ownedShops, 1 do
        Locations[ownedShops[i]].boss.owner = true
    end
end)

-- [[ Fetch owned shops on client side ]]
RegisterNetEvent('PX_shop:clChangeName')
AddEventHandler('PX_shop:clChangeName', function (shopNumber, shopName)
    Locations[shopNumber].blip.name = shopName
    CreateBlips()
end)

-- [[ Change owned shop values on client side ]]
RegisterNetEvent('PX_shop:clChangedata')
AddEventHandler('PX_shop:clChangedata', function (shopNumber, data)
    Locations[shopNumber].shop.forsale = data.forsale
    Locations[shopNumber].owner.identifier = data.identifier
    Locations[shopNumber].owner.name = data.name
    if data.id == GetPlayerServerId(PlayerId()) then
        Locations[shopNumber].boss.owner = true
    else
        Locations[shopNumber].boss.owner = false
    end
end)

-- [[ Change some data ]]
RegisterNetEvent('PX_shop:clChangedataCustom')
AddEventHandler('PX_shop:clChangedataCustom', function (shopNumber, data)
    if data.type == "price" then
        Locations[shopNumber].shop.value = data.value
    elseif data.type == "status" then
        Locations[shopNumber].shop.forsale = data.forsale
    end
end)

Citizen.CreateThread(function()
    local defaultHash = 416176080
    for i=1, #Locations do
        local cashier = Locations[i]["cashier"]
        if cashier then
            cashier["hash"] = cashier["hash"] or defaultHash
            _RequestModel(cashier["hash"])
            if not DoesEntityExist(cashier["entity"]) then
                cashier["entity"] = CreatePed(4, cashier["hash"], cashier["x"], cashier["y"], cashier["z"], cashier["h"])
                SetEntityAsMissionEntity(cashier["entity"])
                SetBlockingOfNonTemporaryEvents(cashier["entity"], true)
                FreezeEntityPosition(cashier["entity"], true)
                SetEntityInvincible(cashier["entity"], true)
            end
            SetModelAsNoLongerNeeded(cashier["hash"])
        end
    end
end)

function DrawAll()
    Citizen.CreateThread(function()
        while true do
            local wait = 750
            local coords = GetEntityCoords(PlayerPedId())
            for i=1, #Locations do
                local cashier = Locations[i]["cashier"]
                if cashier then
                    local dist = GetDistanceBetweenCoords(coords, cashier["x"], cashier["y"], cashier["z"], true)
                    if dist <= 5.0 then
                        DrawText3D(cashier["x"], cashier["y"], cashier["z"] + 2.05, "Owner: ~r~" .. Locations[i].owner.name)

                        if Locations[i].shop.forsale then
                            if dist < 1.5 then
                                DrawText3D(cashier["x"], cashier["y"], cashier["z"] + 1.92, "[Y] Buy: ~g~$" .. Locations[i].shop.value)

                                if IsControlJustPressed(0, 246) then
                                    BuyShopMenu(i)
                                end

                            else
                                DrawText3D(cashier["x"], cashier["y"], cashier["z"] + 1.92, "Price: ~g~$" .. Locations[i].shop.value)
                            end
                        end
                        wait = 5
                    end
                end
            end
            Citizen.Wait(wait)
        end
    end)
end

--[[ Creates cashiers and blips ]]--
function CreateBlips()
    Citizen.CreateThread(function()
        for i=1, #Locations do
            local blip = Locations[i]["blip"]

            if blip then
                if DoesBlipExist(blip["id"]) then
                    RemoveBlip(blip["id"])
                end

                blip["id"] = AddBlipForCoord(blip["x"], blip["y"], blip["z"])
                SetBlipSprite(blip["id"], 59)
                SetBlipDisplay(blip["id"], 4)
                SetBlipScale(blip["id"], 1.0)
                SetBlipColour(blip["id"], 3)
                SetBlipAsShortRange(blip["id"], true)
    
                BeginTextCommandSetBlipName("shopblip")
                AddTextEntry("shopblip", blip["name"] or "Shop")
                EndTextCommandSetBlipName(blip["id"])
            end
        end
    end)
end

--[[ Function to trigger pNotify event for easier use :) ]]--
pNotify = function(message, messageType, messageTimeout)
	TriggerEvent("esx:showNotification", message)
end

Marker = function(pos)
    DrawMarker(25, pos["x"], pos["y"], pos["z"] - 0.98, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.75, 0.75, 0.75, 255, 255, 255, 120, false, false, 2, false, nil, nil, false)	
end

--[[ Deletes the peds when the resource stops ]]--
AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        DeleteCashier()
    end
end)

local inPaintBall = false
AddEventHandler('esx_paintball:inPaintBall', function(state) inPaintBall = state end)

-- [[ Draw Markers ]]
Citizen.CreateThread(function()
	while true do
	 	Citizen.Wait(0)
        local coords = GetEntityCoords(PlayerPedId())
        local canSleep = true
        for i,v in ipairs(Locations) do
            if v.boss.owner then
                if GetDistanceBetweenCoords(coords, v.boss.coords.x, v.boss.coords.y, v.boss.coords.z, true) < 15 then
                    canSleep = false
                    DrawMarker(29, v.boss.coords.x, v.boss.coords.y, v.boss.coords.z, 0, 0, 0, 0, 0, 0, 0.5, 0.5, 0.5, 140,180,140, 165, 1,0, 0,1)
                end
                if GetDistanceBetweenCoords(coords, Config.buy.pos.x, Config.buy.pos.y, Config.buy.pos.z, true) < 15 then
                    canSleep = false
                    DrawMarker(22, Config.buy.pos.x, Config.buy.pos.y, Config.buy.pos.z + 1, 0, 0, 0, 0, 0, 0,1.2,1.2,1.2, 255,0,0, 165, 1,0, 0,1)

                end
            end
        end
        if canSleep then
            Citizen.Wait(500)
        end
    end
end)

AddEventHandler('PX_shop:hasEnteredMarker', function(zone)
	CurrentAction     = zone
	CurrentActionMsg  = 'Press ~INPUT_CONTEXT~ to open menu!'
	CurrentActionData = {}
end)

AddEventHandler('PX_shop:hasExitedMarker', function(zone)
	CurrentAction = nil
end)

-- [[ Make Markers activate on enter]]
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(200)

		local coords      = GetEntityCoords(PlayerPedId())
		local isInMarker  = false
        local currentZone = nil

        for i,v in ipairs(Locations) do
            if v.boss.owner then
                if GetDistanceBetweenCoords(coords, v.boss.coords.x, v.boss.coords.y, v.boss.coords.z, true) < 1 then
                    isInMarker  = true
                    currentZone = i
                end

                if GetDistanceBetweenCoords(coords, Config.buy.pos.x, Config.buy.pos.y, Config.buy.pos.z, true) < 1.5 then
                    isInMarker  = true
                    currentZone = "buy"
                end
            end
        end

		if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
			HasAlreadyEnteredMarker = true
			LastZone                = currentZone
			TriggerEvent('PX_shop:hasEnteredMarker', currentZone)
		end

		if not isInMarker and HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = false
			TriggerEvent('PX_shop:hasExitedMarker', LastZone)
		end
		
		if not isInMarker then
			Citizen.Wait(500)
        end
        
	end
end)

-- [[ Key Handler ]]
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if CurrentAction ~= nil then
			ESX.ShowHelpNotification(CurrentActionMsg)
            if IsControlJustReleased(0, 38) then
                if tonumber(CurrentAction) then
                    OpenBossAction(CurrentAction)
                else
                    BuyShopItemsMenu()
                end
				CurrentAction = nil
			end
		else
			Citizen.Wait(500)
		end
	end
end)

function OpenBossAction(shopNumber)
    ESX.TriggerServerCallback('PX_shop:getstatus', function(data)
        
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_boss_action', {
            title    = shopNumber.." | Shop " .. Locations[shopNumber].blip.name,
            align    = 'top-left',
            elements = {
                {label = "Manage Shop",  value = 'manager'},
                {label = "See Products", value = "view"},
                {label = "Safe Box: <span style='color:green'>$" .. data.money .. "</span>", value = "deposit"}
            }
            
        }, function(data, menu)
            
            if data.current.value == 'manager' then
                openManagerMenu(shopNumber)
                menu.close()
            elseif data.current.value == 'view' then
                openInventoryShop(shopNumber)
            elseif data.current.value == 'deposit' then
                ESX.TriggerServerCallback('PX_shop:depositmoney', function(deposit)
                    if deposit then
                        ESX.ShowNotification("~h~You have Collected ~g~$" .. tostring(deposit) .. "~w~ From you Shop!", 'info')
                        menu.close()
                        OpenBossAction(shopNumber)
                    end
                end, shopNumber)
            end
            
        end, function (data, menu)
            menu.close()
            HasAlreadyEnteredMarker = false
        end)
    end, shopNumber)
end

function openInventoryShop(shopNumber)
    ESX.TriggerServerCallback('PX_shop:getinventory', function(inventory)

        if inventory then
            local elements = {}
            for k,v in pairs(inventory) do
                table.insert(elements, {label = v.count .. "x " .. v.label, value = k})
            end
            
            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_inventory', {
                title    = "Inventory " .. Locations[shopNumber].blip.name,
                align    = 'top-left',
                elements = elements

            }, function(data2, menu2)

                ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'shop_putstock', {
                    title    = "input value",
    
                }, function(data3, menu3)

                   local count = tonumber(data3.value)
                   if data3.value then

                    if count then
                        if count > 0 then
                            ESX.TriggerServerCallback('PX_shop:putStock', function(success)
                                if success then
                                    ESX.ShowNotification("~h~You have add ~o~x" .. success.count .. " ~g~" .. success.item .. "~w~ To your shop!", 'info')
                                    menu3.close()
                                    menu2.close()
                                    openInventoryShop(shopNumber)
                                end
                            end, shopNumber, {item = data2.current.value, count = count})
                        else
                            ESX.ShowNotification("~h~Number should more than 0", 'error')
                        end
                    else
                        ESX.ShowNotification("~h~You should just put number here", 'error')
                    end
                    
                       
                   else
                    ESX.ShowNotification("~h~You should just put number", 'error')
                   end

                end, function (data3, menu3)
                    menu3.close()
                end)

            end, function (data2, menu2)
                menu2.close()
            end)
        else
            ESX.ShowNotification("~h~Some thing went wrong!", 'error')
        end

    end, shopNumber)
end

function openManagerMenu(shopNumber)
    ESX.TriggerServerCallback('PX_shop:getstatus', function(data)
        
        local elements = {
            {label = "Change Your Shop Name", value = "changename"},
            {label = "Shop Price: <span style='color:green'>$" .. data.value .. "</span>", value = "changeprice"},
        }
        if data.forsale then
            table.insert(elements, {label = "sale status: true", value = "changestatus"})
        else
            table.insert(elements, {label = "sale status: false", value = "changestatus"})
        end

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_manager', {
            title    = "Manage " .. Locations[shopNumber].blip.name,
            align    = 'top-left',
            elements = elements
    
        }, function(data2, menu2)
    
            if data2.current.value == "changename" then
                openChangeNameMenu(shopNumber)
            elseif data2.current.value == "changeprice" then
                changePrice(shopNumber)
            elseif data2.current.value == "changestatus" then
                ESX.TriggerServerCallback('PX_shop:setstatus', function(success)
                    if success then
                        menu2.close()
                        openManagerMenu(shopNumber)
                    end
                end, shopNumber, data2.current.value, "status")
            end
    
        end, function (data2, menu2)
            menu2.close()
            HasAlreadyEnteredMarker = false
        end)

    end, shopNumber)
end

function changePrice(shopNumber)
    ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'shop_changeprice', {
        title    = "Enter the Value",

    }, function(data3, menu3)

       local count = tonumber(data3.value)
       if data3.value then

        if count then
            if count > 0 then
                ESX.TriggerServerCallback('PX_shop:setstatus', function(success)
                    if success then
                        ESX.ShowNotification("~h~You have sussecfully put price to ~g~$" .. success, 'success')
                        menu3.close()
                        openManagerMenu(shopNumber)
                    end
                end, shopNumber, data3.value, "price")
            else
                ESX.ShowNotification("~h~Price should more than 0", 'error')
            end
        else
            ESX.ShowNotification("~h~Just enter some number", 'error')
        end
        
           
       else
        ESX.ShowNotification("~h~You didnt put anything!", 'error')
       end

    end, function (data3, menu3)
        menu3.close()
    end)
end

function openChangeNameMenu(shopNumber)
    ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'shop_changename', {
        title    = "Choose your shop name",

    }, function(data3, menu3)
        if not data3.value then
            ESX.ShowNotification("Minimum char : ~g~3", 'error')
            return
        end

        if string.len(trim1(data3.value)) >= 3 then
            ESX.TriggerServerCallback('PX_shop:changename', function(changed)

                if changed then
                    ESX.ShowNotification("~h~Change shop name to : ~g~" .. changed, 'info')
                    openManagerMenu(shopNumber)
                else
                    ESX.ShowNotification("~h~Some thing went wrong", 'error')
                end

            end, shopNumber, data3.value)
        else
            ESX.ShowNotification("~h~Minimum char : ~g~3", 'error')
        end
    end, function (data3, menu3)
        menu3.close()
        HasAlreadyEnteredMarker = false
    end)
end

function BuyShopMenu(shopNumber)
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'confirm_buyshop',
    {
        title 	 = 'Confirm Shop',
        align    = 'center',
        elements = {
            {label = 'Yes', value = 'yes'},
            {label = 'No', value = 'no'},
        }
    }, function(data, menu)
       
        if data.current.value == "yes" then
            print('yes babe')
            Citizen.Wait(math.random(100, 500))
            ESX.TriggerServerCallback('PX_shop:buyShop', function(success)

                if success then
                    ESX.ShowNotification("~h~Sussesfully buy ~g~" .. Locations[success].blip.name .. "(" .. success .. ")", 'success')
                end
                menu.close()

            end, shopNumber)
        end
        menu.close()

    end, function (data, menu)
        menu.close()
    end)
end


function BuyShopItemsMenu()
    local data = {}
    ESX.TriggerServerCallback('PX_shop:getbuyprices', function(items)
        for k, v in pairs(items) do
            table.insert(data, {name = k, label = v.label, price = v.price, image = k})
        end
        SetNuiFocus(true, true)
        SendNUIMessage({
            type = 'open',
            data = {
                inventory = data,
                shop = 0
            }
        })
    end)
end

function trim1(s)
    return (s:gsub("^%s*(.-)%s*$", "%1"))
end

-------------------- Robbery -----------------------

local blipRobbery = nil

RegisterNetEvent('Parzival_shop:setBlip')
AddEventHandler('Parzival_shop:setBlip', function(position)
	blipRobbery = AddBlipForCoord(position.x, position.y, position.z)
	SetBlipSprite(blipRobbery, 161)
	SetBlipScale(blipRobbery, 2.0)
	SetBlipColour(blipRobbery, 15)
	PulseBlip(blipRobbery)
    SetTimeout(120000, function()
        RemoveBlip(blipRobbery)
    end)
end)

loadDict = function(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(10)
    end
end

Citizen.CreateThread(function()
    while true do
        local _sleep = true
        Citizen.Wait(0)
        if not inPaintBall then
            local ccobject = nearcashRegister()
            if ccobject then
                local shopId = nearShop()
                _sleep = false
                DisplayHelpText("Dokme ~INPUT_MP_TEXT_CHAT_TEAM~ ra jahat dozdi feshar dahid ~b~")
                if IsControlPressed(1, 246) then
                    local doing = true
                    ESX.TriggerServerCallback('Parzival_ShopRobbery:canPickUpMoney', function(can)
                        if can then
                            TaskTurnPedToFaceEntity(PlayerPedId(),ccobject, 4000)
                            Wait(500)
                            ExecuteCommand("closei")
                            local ccobject = nearcashRegister()
                            local shopId = nearShop()
                            startAnim(PlayerPedId(), "anim@gangops@facility@servers@bodysearch@", "player_search")
                            local finish = false
                            local myCoord = GetEntityCoords(PlayerPedId())
                            TriggerServerEvent("Parzival_ShopRobbery:CallLSPD", myCoord)
                            TriggerEvent("mythic_progbar:client:progress", {
                                name = "rob",
                                duration = 70 * 1000,
                                label = "Dar hale bardasht pool",
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
                                    CreateModelSwap(GetEntityCoords(ccobject), 0.5, GetHashKey('prop_till_01'), GetHashKey('prop_till_01_dam'), false)
                                    ClearPedTasks(PlayerPedId())
                                    TriggerServerEvent('Parzival_ShopRobbery:pickUp', shopId)
                                    doing = false
                                    SetTimeout(25 * 1000 * 60, function()
                                        CreateModelSwap(GetEntityCoords(ccobject), 0.5, GetHashKey('prop_till_01_dam'), GetHashKey('prop_till_01'), false)
                                    end)
                                elseif status then
                                    ClearPedTasks(PlayerPedId())
                                    doing = false
                                end
                                finish= true
                            end)
                            Citizen.CreateThread(function()
                                while not finish do
                                    Wait(5000)
                                    if not finish then
                                        startAnim(PlayerPedId(), "anim@gangops@facility@servers@bodysearch@", "player_search")
                                    end
                                end
                                ClearPedTasks(PlayerPedId())
                            end)
                            Wait(3000)
                        else
                            doing = false
                            ESX.ShowNotification('Ebteda roye forooshande aim begirid!', 'error')
                        end
                    end, shopId)
                    while doing do
                        Wait(1000)
                    end
                end
            end
        end
        if _sleep then Citizen.Wait(1000) end
    end
end)

DisplayHelpText = function(str)
    ESX.ShowHelpNotification(str)
end

nearShop = function()
    local ped = PlayerPedId()
    local pcoords = GetEntityCoords(ped)
    for k, v in pairs(Locations) do
        if #(pcoords- vector3(v.blip.x,v.blip.y,v.blip.z)) <= 20 then
            return k
        end
    end
end

startAnim = function(ped, dictionary, anim)
    Citizen.CreateThread(function()
        RequestAnimDict(dictionary)
        while not HasAnimDictLoaded(dictionary) do
            Citizen.Wait(0)
        end
        TaskPlayAnim(ped, dictionary, anim, 1.5, 1.5, -1, 16, 0, 0, 0, 0)
    end)
end

nearcashRegister = function()
    local ped = PlayerPedId()
    local pcoords = GetEntityCoords(ped)
    local toreturn = false
    local cashRegister = GetClosestObjectOfType(pcoords.x, pcoords.y, pcoords.z, 0.75, GetHashKey('prop_till_01'), false)
    if DoesEntityExist(cashRegister) then
        toreturn = cashRegister
        return toreturn
    end
    return toreturn
end

local currentPedEnt = nil
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)
        if not IsPedInAnyVehicle(PlayerPedId()) and not inPaintBall then
            local retval, entity = GetEntityPlayerIsFreeAimingAt(PlayerId())
            if (retval == true or retval == 1) then
                local isRegistered, shopId = isCashierRegistered(entity)
                if isRegistered then
                    local returnValue, currentPedWeapon = GetCurrentPedWeapon(PlayerPedId(),1)
                    if returnValue == 1 and GetWeaponDamageType(currentPedWeapon) == 3 and HasEntityClearLosToEntity(PlayerPedId(), entity, 17) then
                        TriggerServerEvent("Parzival_ShopRobbery:syncAiming", shopId)
                        local canRob = nil
                        ESX.TriggerServerCallback('Parzival_ShopRobbery:canRob', function(cb)
                            canRob = cb
                        end, shopId)
                        while canRob == nil do
                            Citizen.Wait(0)
                        end
                        if canRob == true and currentPedEnt == nil then
                            if currentPedEnt == nil then
                                currentPedEnt = entity
                                TriggerServerEvent("Parzival_ShopRobbery:sendNpcToAnim", shopId)
                                while currentPedEnt do
                                    retval, entity = GetEntityPlayerIsFreeAimingAt(PlayerId())
                                    if not retval then
                                        ClearPedTasks(currentPedEnt)
                                        currentPedEnt = nil
                                    end
                                    Wait(2000)
                                end
                            end
                        elseif canRob == 'no_cops' then
                            ESX.ShowNotification('Dar hale hazer tedad morede niaz police online nist!', 'error')
                            Citizen.Wait(10000)
                        else
                            ESX.ShowNotification('In shop be tazegi behesh dastbord zade shode, lotfan kami sabr konid!', 'error')
                            Citizen.Wait(10000)
                        end
                    end
                end
            end
        end
    end
end)

RegisterNetEvent('Parzival_ShopRobbery:resetShopNPCAnim')
AddEventHandler('Parzival_ShopRobbery:resetShopNPCAnim', function(storeId)
    local entity = Locations[storeId]["cashier"]["entity"]
    if entity and DoesEntityExist(entity) then
        ClearPedTasks(entity)
    end
end)

RegisterNetEvent('Parzival_ShopRobbery:fetchNpcAnim')
AddEventHandler('Parzival_ShopRobbery:fetchNpcAnim', function(storeId)
    local entity = Locations[storeId]["cashier"]["entity"]
    if entity and DoesEntityExist(entity) then
        loadDict('missheist_agency2ahands_up')
        TaskPlayAnim(entity, "missheist_agency2ahands_up", "handsup_anxious", 8.0, -8.0, -1, 1, 0, false, false, false)
    end
end)

function isCashierRegistered(entity)
    for i=1, #Locations do
        local cashier = Locations[i]["cashier"]
        if DoesEntityExist(cashier["entity"]) and cashier["entity"] == entity then
            return true, i
        end
    end
    return false, nil
end