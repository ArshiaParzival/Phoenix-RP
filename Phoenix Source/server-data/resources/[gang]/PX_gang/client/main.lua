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

local PlayerData                = {}
local GUI                       = {}
local HasAlreadyEnteredMarker   = false
local LastStation               = nil
local LastPart                  = nil
local CurrentAction             = nil
local CurrentActionMsg          = ''
local CurrentActionData         = {}
local allBlip                   = {}
local Data                      = {}

ESX                             = nil
GUI.Time                        = 0

Citizen.CreateThread(function()
while ESX == nil do
  TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
  Citizen.Wait(0)
end
end)

function OpenCloakroomMenu()

  local elements = {
    {label = 'Posheshe Shahrvandi', value = 'citizen_wear'},
    {label = 'Posheshe Gang(1)', value = 'gang_wear1'},
    {label = 'Posheshe Gang(2)', value = 'gang_wear2'},
    {label = 'Posheshe Gang(3)', value = 'gang_wear3'}
  }

  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'cloakroom',
    {
      title    = _U('cloakroom'),
      align    = 'top-right',
      elements = elements,
    },
    function(data, menu)
      menu.close()

    ESX.TriggerServerCallback('Proxtended:getGender', function(skin)
      if data.current.value == 'citizen_wear' then
        TriggerEvent('PX_clothing:client:openOutfitMenu')
      elseif data.current.value == 'gang_wear1' then
        ESX.TriggerServerCallback('Proxtended:getGangSkin', function(gangSkin)
          if skin.sex == 0 then
            TriggerEvent('PX_clothing:client:loadOutfit', gangSkin.skin_male)
          else
            TriggerEvent('PX_clothing:client:loadOutfit', gangSkin.skin_female)
          end
        end)
      elseif data.current.value == 'gang_wear2' then
          ESX.TriggerServerCallback('Proxtended:getGangSkin2', function(gangSkin)
          if skin.sex == 0 then
            TriggerEvent('PX_clothing:client:loadOutfit', gangSkin.skin_male2)
          else
            TriggerEvent('PX_clothing:client:loadOutfit', gangSkin.skin_female2)
          end
        end)
      elseif data.current.value == 'gang_wear3' then
          ESX.TriggerServerCallback('Proxtended:getGangSkin3', function(gangSkin)
          if skin.sex == 0 then
            TriggerEvent('PX_clothing:client:loadOutfit', gangSkin.skin_male3)
          else
            TriggerEvent('PX_clothing:client:loadOutfit', gangSkin.skin_female3)
          end
        end)
      end
    end)

      CurrentAction     = 'menu_cloakroom'
      CurrentActionMsg  = _U('open_cloackroom')
      CurrentActionData = {}

    end,
    function(data, menu)
      menu.close()
      
      CurrentAction     = 'menu_cloakroom'
      CurrentActionMsg  = _U('open_cloackroom')
      CurrentActionData = {}
    end
)

end

function OpenArmoryMenu(station)
local station = station
if Config.EnableArmoryManagement then

  local elements = {
    {label = 'Gang Inventory', value = 'property_inventory'},
    {label = 'Gereftan Armor',  value = 'get_armor'},
    {label = 'Craft Table', value = 'craft'}
  }
  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
  'default', GetCurrentResourceName(), 'armory',
  {
    title    = _U('armory'),
    align    = 'top-right',
    elements = elements,
  },
  function(data, menu)
    menu.close()
  if data.current.value == "property_inventory" then
      if PlayerData.gang.grade >= Data.stashperm then
        Other = {maxweight = 5000000, slots = 100}
        TriggerEvent("PX_inventory:client:SetCurrentStash", 'gang_'..PlayerData.gang.name)
        TriggerServerEvent("PX_inventory:server:OpenInventory", "stash", 'gang_'..PlayerData.gang.name, Other)
      else
        ESX.ShowNotification("Rank Shoma Dastresi be Inventory Nadarad!", 'error')
      end
  elseif data.current.value == 'craft' then
    if PlayerData.gang.grade >= Data.craftperm then
      TriggerEvent("PX_crafting:open")
    else
      ESX.ShowNotification("Rank Shoma Dastresi be Craft Nadarad!", 'error')
    end
  elseif data.current.value == 'get_armor' then
    if PlayerData.gang.grade >= Data.vestperm then
      local ped = PlayerPedId()
      local armor = GetPedArmour(ped)

      if armor >= Data.bulletproof then
        ESX.ShowNotification("~g~Armor shoma por ast nemitavanid dobare armor kharidari konid!", 'error')
      else
        TriggerServerEvent("PXgangxxpropPX:setArmor", source)
      end
    else
      ESX.ShowNotification("~h~Shoma Dastresi Be Vest Nadarid", 'error')
    end
  end

  end,
  function(data, menu)

    menu.close()

    CurrentAction     = 'menu_armory'
    CurrentActionMsg  = _U('open_armory')
    CurrentActionData = {station = station}
  end)

 else

   local elements = {}

   ESX.UI.Menu.CloseAll()

   ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'armory',
    {
      title    = _U('armory'),
      align    = 'top-right',
      elements = elements,
    },
    function(data, menu)
      local weapon = data.current.value
      TriggerServerEvent('PXgangxxpropPX:giveWeapon', weapon,  1000)
    end,
    function(data, menu)

       menu.close()

       CurrentAction     = 'menu_armory'
      CurrentActionMsg  = _U('open_armory')
      CurrentActionData = {station = station}

     end
  )

 end

end

function ListOwnedCarsMenu()
	local elements = {}
	
	table.insert(elements, {label = '| Pelak | Esm Mashin |'})
  local grank = PlayerData.gang.grade
  local gname = PlayerData.gang.name
	ESX.TriggerServerCallback('PXgangxxpropPX:getCars', function(ownedCars)
    ESX.TriggerServerCallback('gangs:GetPermData', function(vycars)
      if #ownedCars == 0 then
        ESX.ShowNotification("Mashini Dar Garage Nist!", 'error')
      else
        for _,v in pairs(ownedCars) do
          if not vycars then
            return
          end
          for _,v2 in ipairs(vycars) do
            local hashVehicule = v.vehicle.model
            local aheadVehName = GetDisplayNameFromVehicleModel(hashVehicule)
            if v2.name == aheadVehName and v2.state == true then
              local vehicleName  = aheadVehName
              local plate        = v.plate
              labelvehicle = '| '..plate..' | '..vehicleName..' |'
              table.insert(elements, {label = labelvehicle, value = v})          
            end
          end
        end
      end
      
      ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'spawn_owned_car', {
        title    = 'Gang Parking',
        align    = 'top-left',
        elements = elements
      }, function(data, menu)
        if data.current.value.state then
          menu.close()
          Citizen.Wait(math.random(0,500))
          ESX.TriggerServerCallback('PXgangxxpropPX:carAvalible', function(avalibele)
            if avalibele then        
              SpawnVehicle(data.current.value.vehicle, data.current.value.plate)
            else
              ESX.ShowNotification('In Mashin Qablan az Parking Dar amade ast', 'error')
            end
          end, data.current.value.plate)
        else
          openImpound(data.current.value.plate)
        end
      end, function(data, menu)
        menu.close()
      end)
    end, gname, grank, 'car')
	end)
end

function openImpound(plate)
  ESX.UI.Menu.CloseAll()
  local elements = {
    {label = "Take Out", value = 'impound'},
    {label = "Back", value = 'back'},
  }

  ESX.UI.Menu.Open(
  'default', GetCurrentResourceName(), 'citizen_interaction',
  {
    title    = "Price: 1k",
    align    = 'top-left',
    elements = elements
  },
  function(data, menu)
    if data.current.value == 'impound' then
      menu.close()
      TriggerServerEvent("Parzival_Gang:TakeFromImpound", plate)
    elseif data.current.value == 'back' then
      menu.close()
      ListOwnedCarsMenu()
    end
  end,  function(data, menu)
    menu.close()
  end)
end

RegisterNetEvent("Parzival_Gang:TakeFromImpound")
AddEventHandler("Parzival_Gang:TakeFromImpound", function(plate)
  local vehicles = ESX.Game.GetVehicles()
	for _,entity in ipairs(vehicles) do
    if GetVehicleNumberPlateText(entity) == plate then
      NetworkRequestControlOfEntity(entity)
      local timeout = 2000
      while timeout > 0 and not NetworkHasControlOfEntity(entity) do
        Wait(100)
        timeout = timeout - 100
      end
      SetEntityAsMissionEntity(entity, true, true)
      local timeout = 2000
      while timeout > 0 and not IsEntityAMissionEntity(entity) do
        Wait(100)
        timeout = timeout - 100
      end
      DeleteVehicle(entity)
      if (DoesEntityExist(entity)) then
        DeleteEntity(entity)
      end
    end
  end
end)

-- Spawn Cars
function SpawnVehicle(vehicle, plate)
  local shokol = GetClosestVehicle(Data.vehspawn.x,  Data.vehspawn.y,  Data.vehspawn.z,  3.0,  0,  71)
  if not DoesEntityExist(shokol) then
    ESX.Game.SpawnVehicle(vehicle.model, {
      x = Data.vehspawn.x,
      y = Data.vehspawn.y,
      z = Data.vehspawn.z 
    }, Data.vehspawn.a, function(callback_vehicle)
      -- ESX.Game.SetVehicleProperties(callback_vehicle, vehicle)
      SetVehicleProperties(callback_vehicle, vehicle)
      SetVehRadioStation(callback_vehicle, "OFF")
      TaskWarpPedIntoVehicle(PlayerPedId(), callback_vehicle, -1)
      TriggerServerEvent("garage:addKeys", GetVehicleNumberPlateText(callback_vehicle), GetDisplayNameFromVehicleModel(GetEntityModel(callback_vehicle)))
    end)
    
    -- TriggerServerEvent('esx_advancedgarage:setVehicleState', plate, false)
    TriggerServerEvent('PX_garage:modifystored', vehicle, 0, 'out')
  else
    ESX.ShowNotification('Mahale Spawn mashin ro Khali konid', 'error')
  end
end

SetVehicleProperties = function(vehicle, vehicleProps)
  ESX.Game.SetVehicleProperties(vehicle, vehicleProps)

  SetVehicleEngineHealth(vehicle, vehicleProps["engineHealth"] and vehicleProps["engineHealth"] + 0.0 or 1000.0)
  SetVehicleBodyHealth(vehicle, vehicleProps["bodyHealth"] and vehicleProps["bodyHealth"] + 0.0 or 1000.0)
  SetVehicleFuelLevel(vehicle, vehicleProps["fuelLevel"] and vehicleProps["fuelLevel"] + 0.0 or 1000.0)

  if vehicleProps["windows"] then
      for windowId = 1, 13, 1 do
          if vehicleProps["windows"][windowId] == false then
              SmashVehicleWindow(vehicle, windowId)
          end
      end
  end

  if vehicleProps["tyres"] then
      for tyreId = 1, 7, 1 do
          if vehicleProps["tyres"][tyreId] ~= false then
              SetVehicleTyreBurst(vehicle, tyreId, true, 1000)
          end
      end
  end

  if vehicleProps["doors"] then
      for doorId = 0, 5, 1 do
          if vehicleProps["doors"][doorId] ~= false then
              SetVehicleDoorBroken(vehicle, doorId - 1, true)
          end
      end
  end
end

function OpenGangActionsMenu()
  ESX.UI.Menu.CloseAll()

  local elements = {}

  if PlayerData.gang.name ~= "nogang" then
    table.insert(elements, {label = "Handcuff",        value = 'handcuff'})
    table.insert(elements, {label = "UnCuff",          value = 'uncuff'})
  end
  table.insert(elements, {label = _U('search'),          value = 'search'})
  table.insert(elements, {label = _U('drag'),            value = 'drag'})
  table.insert(elements, {label = _U('put_in_vehicle'),  value = 'put_in_vehicle'})
  table.insert(elements, {label = _U('out_the_vehicle'), value = 'out_the_vehicle'})

  if PlayerData.gang.name ~= "nogang" then
    if PlayerData.gang.grade >= Data.invperm  then
      table.insert(elements, {label = 'Modiriat A\'aza', value = 'manage_user'})
    end
  end
  ESX.UI.Menu.Open(
  'default', GetCurrentResourceName(), 'citizen_interaction',
  {
    title    = _U('citizen_interaction'),
    align    = 'top-right',
    elements = elements
  },
  function(data2, menu2)

    local player, distance = ESX.Game.GetClosestPlayer()

    if distance ~= -1 and distance <= 10.0 then

      if data2.current.value == 'handcuff' then
        playerPed = PlayerPedId()
        SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true) -- unarm player
        local target, distance = ESX.Game.GetClosestPlayer()
        if distance <= 2.0 then
          TriggerEvent('cuff')
        else
          ESX.ShowNotification('Shakhsi nazdik shoma nist', 'error')
        end
      elseif data2.current.value == 'uncuff' then
        SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true) -- unarm player
        local target, distance = ESX.Game.GetClosestPlayer()

        if distance <= 2.0 then
          TriggerEvent('uncuff')
        else
          PX.ShowNotification('Shakhsi nazdik shoma nist', 'error')
        end
      elseif data2.current.value == 'drag' then
        TriggerEvent('drag')
      elseif data2.current.value == 'put_in_vehicle' then
        
        local vehicle = ESX.Game.GetVehicleInDirection(4)
        if vehicle == 0 then
          TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Hich mashini nazdik shoma nist!")
          return
        end

        TriggerEvent('PutInVeh')
      elseif data2.current.value == 'out_the_vehicle' then
        TriggerEvent('PutOutVeh')
      elseif data2.current.value == "search" then
        TriggerEvent('search')
      end
	elseif data2.current.value == "manage_user" then
        TriggerEvent('gangs:openBossMenugm', PlayerData.gang.name, function(data, menu)
          menu.close()
          CurrentAction     = 'menu_boss_actions'
          CurrentActionMsg  = _U('open_bossmenu')
          CurrentActionData = {}
          end)
    else
      ESX.ShowNotification(_U('no_players_nearby'), 'error')
    end

  end,
  function(data2, menu2)
    menu2.close()
  end)
end

function OpenGetWeaponMenu(gang)
  local gang = gang

  ESX.TriggerServerCallback('gangs:getArmoryWeapons', function(weapons)

    local elements = {}

    for i=1, #weapons, 1 do
      if weapons[i].count > 0 then
        table.insert(elements, {label = 'x' .. weapons[i].count .. ' ' .. ESX.GetWeaponLabel(weapons[i].name), value = weapons[i].name})
      end
    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'armory_get_weapon',
      {
        title    = _U('get_weapon_menu'),
        align    = 'top-right',
        elements = elements,
      },
      function(data, menu)

        menu.close()

        ESX.TriggerServerCallback('gangs:removeArmoryWeapon', function()
          OpenGetWeaponMenu(gang)
        end, data.current.value, gang)

      end,
      function(data, menu)
        menu.close()
      end
    )

  end, gang)

end

function OpenPutWeaponMenu(gang)
local gang = gang
local elements   = {}
local playerPed  = PlayerPedId()
local weaponList = ESX.GetWeaponList()

 for i=1, #weaponList, 1 do

   local weaponHash = GetHashKey(weaponList[i].name)

   if HasPedGotWeapon(playerPed,  weaponHash,  false) and weaponList[i].name ~= 'WEAPON_UNARMED' then
    local ammo = GetAmmoInPedWeapon(playerPed, weaponHash)
    table.insert(elements, {label = weaponList[i].label, value = weaponList[i].name})
  end

end

 ESX.UI.Menu.Open(
  'default', GetCurrentResourceName(), 'armory_put_weapon',
  {
    title    = _U('put_weapon_menu'),
    align    = 'top-right',
    elements = elements,
  },
  function(data, menu)

     menu.close()

     ESX.TriggerServerCallback('gangs:addArmoryWeapon', function()
      OpenPutWeaponMenu(gang)
    end, data.current.value, gang)

   end,
  function(data, menu)
    menu.close()
  end
)

end

function OpenBuyWeaponsMenu(station, gang)
local gang = gang

 ESX.TriggerServerCallback('gangs:getArmoryWeapons', function(weapons)

   local elements = {}
   for i=1, #weapons, 1 do
    table.insert(elements, {label = 'x' .. weapons[i].count .. ' ' .. ESX.GetWeaponLabel(weapons[i].name) .. ' $' .. weapons[i].price, value = weapons[i].name, price = weapons[i].price})
   end
   ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'armory_buy_weapons',
    {
      title    = _U('buy_weapon_menu'),
      align    = 'top-right',
      elements = elements,
    },
    function(data, menu)

       ESX.TriggerServerCallback('gangs:buy', function(hasEnoughMoney)

         if hasEnoughMoney then
          ESX.TriggerServerCallback('gangs:addArmoryWeapon', function()
            OpenBuyWeaponsMenu(station, gang)
          end, data.current.value, gang)
        else
          ESX.ShowNotification(_U('not_enough_money'), 'error')
        end

       end, data.current.price, gang)

     end,
    function(data, menu)
      menu.close()
    end
  )

 end, gang)

end

function OpenGetStocksMenu(gang)
local gang = gang

 ESX.TriggerServerCallback('gangs:getStockItems', function(items)

   -- print(json.encode(items))

  local elements = {}

  for i=1, #items, 1 do
    table.insert(elements, {label = 'x' .. items[i].count .. ' ' .. items[i].label, value = items[i].name})
  end

   ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'stocks_menu',
    {
      title    = _U('gang_stock'),
      elements = elements
    },
    function(data, menu)

       local itemName = data.current.value

       ESX.UI.Menu.Open(
        'dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count',
        {
          title = _U('quantity')
        },
        function(data2, menu2)

          local count = tonumber(data2.value)

          if count == nil then
            ESX.ShowNotification(_U('quantity_invalid'), 'error')
          else
            menu2.close()
            menu.close()
            TriggerServerEvent('gangs:getStockItem', gang, itemName, count)
            OpenGetStocksMenu(gang)
          end

         end,
        function(data2, menu2)
          menu2.close()
        end
      )

     end,
    function(data, menu)
      menu.close()
    end
  )

 end, gang)

end

function OpenPutStocksMenu(station)
local gang = station

 ESX.TriggerServerCallback('PXgangxxpropPX:getPlayerInventory', function(inventory)

   local elements = {}

   for i=1, #inventory.items, 1 do

     local item = inventory.items[i]

     if item.count > 0 then
      table.insert(elements, {label = item.label .. ' x' .. item.count, type = 'item_standard', value = item.name})
    end

   end

   ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'stocks_menu',
    {
      title    = _U('inventory'),
      elements = elements
    },
    function(data, menu)

       local itemName = data.current.value

       ESX.UI.Menu.Open(
        'dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count',
        {
          title = _U('quantity')
        },
        function(data2, menu2)

          local count = tonumber(data2.value)

          if count == nil then
            ESX.ShowNotification(_U('quantity_invalid'), 'error')
          else
            menu2.close()
            menu.close()

            TriggerServerEvent('gangs:putStockItems', gang, itemName, count)
            OpenPutStocksMenu(station)
          end

         end,
        function(data2, menu2)
          menu2.close()
        end
      )

     end,
    function(data, menu)
      menu.close()
    end
  )

 end)

end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
  if PlayerData.gang.name ~= 'nogang' then
    ESX.TriggerServerCallback('gangs:getGangData', function(data)
      if data ~= nil then
        Data.gang_name    = data.gang_name
        Data.blip         = json.decode(data.blip)
        blipManager(Data.blip, data.blip_icon, data.blip_color)
        Data.armory       = json.decode(data.armory)
        Data.locker       = json.decode(data.locker)
        Data.boss         = json.decode(data.boss)
        Data.veh          = json.decode(data.veh)
        Data.vehdel       = json.decode(data.vehdel)
        Data.vehspawn     = json.decode(data.vehspawn)
		    Data.vestperm       = data.vestperm
		    Data.invperm       = data.invperm
        Data.stashperm       = data.stashperm
        Data.craftperm       = data.craftperm
        Data.bulletproof  = data.bulletproof
        Data.gangsblip  = data.gangsblip
      else
        ESX.ShowNotification('Gang Shoma Disable Shode Ast Lotfan Be Staff Morajee Konid!', 'error')
      end
    end, PlayerData.gang.name)
  end
  TriggerServerEvent('PXgangxxpropPX:forceBlip')
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

RegisterNetEvent('esx:setGang')
AddEventHandler('esx:setGang', function(gang)
  PlayerData.gang = gang
  Data = {}
  TriggerServerEvent('PXgangxxpropPX:forceBlip')
  if PlayerData.gang.name ~= 'nogang' then
    ESX.TriggerServerCallback('gangs:getGangData', function(data)
      if data ~= nil then
        Data.blip         = json.decode(data.blip)
        blipManager(Data.blip, data.blip_icon, data.blip_color)
        Data.gang_name    = data.gang_name
        Data.armory       = json.decode(data.armory)
        Data.locker       = json.decode(data.locker)
        Data.boss         = json.decode(data.boss)
        Data.veh          = json.decode(data.veh)
        Data.vehdel       = json.decode(data.vehdel)
        Data.vehspawn     = json.decode(data.vehspawn)
        Data.bulletproof  = data.bulletproof
		    Data.vestperm  = data.vestperm
		    Data.invperm       = data.invperm
        Data.stashperm       = data.stashperm
        Data.craftperm       = data.craftperm
		    Data.gangsblip  = data.gangsblip
      else
        ESX.ShowNotification('You Gang has been expired, Contact admins for recharge!', 'error')
      end
    end, PlayerData.gang.name)
  else
    for _, blip in pairs(allBlip) do
      RemoveBlip(blip)
    end
    allBlip = {}
  end
end)

-- Create blips
function blipManager(blip, sprite, color)
  if not sprite or not tonumber(sprite) then
    sprite = 88
  end
  if not color or not tonumber(color) then
    color = 76
  end
  for _, blip in pairs(allBlip) do
    RemoveBlip(blip)
  end
  allBlip = {}
  local blipCoord = AddBlipForCoord(blip.x, blip.y)
  table.insert(allBlip, blipCoord)
  SetBlipSprite (blipCoord, sprite)
  SetBlipDisplay(blipCoord, 4)
  SetBlipScale  (blipCoord, 1.2)
  SetBlipColour (blipCoord, color)
  SetBlipAsShortRange(blipCoord, true)
  BeginTextCommandSetBlipName("STRING")
  AddTextComponentString('Gang')
  EndTextCommandSetBlipName(blipCoord)
end

AddEventHandler('PXgangxxpropPX:hasEnteredMarker', function(station, part)

if part == 'Cloakroom' then
  CurrentAction     = 'menu_cloakroom'
  CurrentActionMsg  = _U('open_cloackroom')
  CurrentActionData = {station = station}
end

if part == 'Armory' then
  CurrentAction     = 'menu_armory'
  CurrentActionMsg  = _U('open_armory')
  CurrentActionData = {station = station}
end

if part == 'VehicleSpawner' then
  CurrentAction     = 'menu_vehicle_spawner'
  CurrentActionMsg  = _U('vehicle_spawner')
  CurrentActionData = {station = station}
end

if part == 'VehicleDeleter' then

  local playerPed = PlayerPedId()
  local coords    = GetEntityCoords(playerPed)

  if IsPedInAnyVehicle(playerPed,  false) then

    local vehicle = GetVehiclePedIsIn(playerPed, false)

    if DoesEntityExist(vehicle) then
      CurrentAction     = 'delete_vehicle'
      CurrentActionMsg  = _U('store_vehicle')
      CurrentActionData = {vehicle = vehicle, station = station}
    end

  end

 end

 if part == 'BossActions' then
  CurrentAction     = 'menu_boss_actions'
  CurrentActionMsg  = _U('open_bossmenu')
  CurrentActionData = {station = station}
end

end)

AddEventHandler('PXgangxxpropPX:hasExitedMarker', function(station, part)
ESX.UI.Menu.CloseAll()
CurrentAction = nil
end)

-- Display markers
Citizen.CreateThread(function()
while true do

  Wait(1)

  local playerPed = PlayerPedId()
  local coords    = GetEntityCoords(playerPed)
  local canSleep = true

  if Data.locker ~= nil then
    if #(vector3(coords) - vector3(Data.locker.x,  Data.locker.y,  Data.locker.z)) < Config.DrawDistance then
      DrawMarker(Config.MarkerType, Data.locker.x,  Data.locker.y,  Data.locker.z + 1, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
      canSleep = false
    end
  end

  if Data.armory ~= nil then
    if #(vector3(coords) -  vector3(Data.armory.x,  Data.armory.y,  Data.armory.z)) < Config.DrawDistance then
      DrawMarker(Config.MarkerType, Data.armory.x,  Data.armory.y,  Data.armory.z + 1, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
      canSleep = false
    end
  end

  if Data.veh ~= nil then
    if #(vector3(coords) -  vector3(Data.veh.x,  Data.veh.y,  Data.veh.z)) < Config.DrawDistance then
      DrawMarker(Config.MarkerType, Data.veh.x,  Data.veh.y,  Data.veh.z + 1, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
      canSleep = false
    end
  end

  if Data.vehdel ~= nil then
    if #(vector3(coords) -   vector3(Data.vehdel.x,  Data.vehdel.y,  Data.vehdel.z)) < Config.DrawDistance then
      DrawMarker(Config.MarkerType, Data.vehdel.x,  Data.vehdel.y,  Data.vehdel.z + 1, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
      canSleep = false
    end
  end

  if Data.boss ~= nil then
    if #(vector3(coords) -  vector3(Data.boss.x,  Data.boss.y,  Data.boss.z)) < Config.DrawDistance then
      DrawMarker(Config.MarkerType, Data.boss.x,  Data.boss.y,  Data.boss.z + 1, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
      canSleep = false
    end
  end
  if canSleep then
    Citizen.Wait(2000)
  end
end
end)

-- Enter / Exit marker events
Citizen.CreateThread(function()

 while true do

  Wait(10)

  if PlayerData.gang ~= nil then
    local playerPed      = PlayerPedId()
    local coords         = GetEntityCoords(playerPed)
    local isInMarker     = false
    local currentStation = nil
    local currentPart    = nil
    
    if Data.locker ~= nil then
      if #(vector3(coords) -  vector3(Data.locker.x,  Data.locker.y,  Data.locker.z)) < 1.5 then
        isInMarker     = true
        currentStation = Data.gang_name
        currentPart    = 'Cloakroom'
      end
    end

    if Data.armory ~= nil then
      if #(vector3(coords) -  vector3(Data.armory.x,  Data.armory.y,  Data.armory.z)) < 1.5 then
        isInMarker     = true
        currentStation = Data.gang_name
        currentPart    = 'Armory'
      end
    end

    if Data.veh ~= nil then
      if #(vector3(coords) -  vector3(Data.veh.x,  Data.veh.y,  Data.veh.z)) < 1.5 then
        isInMarker     = true
        currentStation = Data.gang_name
        currentPart    = 'VehicleSpawner'
      end
    end

    if Data.vehspawn ~= nil then
      if #(vector3(coords) -  vector3(Data.vehspawn.x,  Data.vehspawn.y,  Data.vehspawn.z)) < 1.5 then
        isInMarker     = true
        currentStation = Data.gang_name
        currentPart    = 'VehicleSpawnPoint'
      end
    end

    if Data.vehdel ~= nil then
      if #(vector3(coords) -  vector3(Data.vehdel.x,  Data.vehdel.y,  Data.vehdel.z)) < 1.5 then
        isInMarker     = true
        currentStation = Data.gang_name
        currentPart    = 'VehicleDeleter'
      end
    end

    if Data.boss ~= nil and PlayerData.gang ~= nil and PlayerData.gang.grade >= 9 then
      if #(vector3(coords) -   vector3(Data.boss.x,  Data.boss.y,  Data.boss.z)) < 1.5 then
        isInMarker     = true
        currentStation = Data.gang_name
        currentPart    = 'BossActions'
      end
    end

    local hasExited = false
    
    if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and (LastStation ~= currentStation or LastPart ~= currentPart)) then
      if
        (LastStation ~= nil and LastPart ~= nil) and
        (LastStation ~= currentStation or LastPart ~= currentPart)
      then
        TriggerEvent('PXgangxxpropPX:hasExitedMarker', LastStation, LastPart)
        hasExited = true
      end
      HasAlreadyEnteredMarker = true
      LastStation             = currentStation
      LastPart                = currentPart

      TriggerEvent('PXgangxxpropPX:hasEnteredMarker', currentStation, currentPart)
    end

    if not hasExited and not isInMarker and HasAlreadyEnteredMarker then

      HasAlreadyEnteredMarker = false

      TriggerEvent('PXgangxxpropPX:hasExitedMarker', LastStation, LastPart)
    end
  end
 end
end)


-- Key Controls
Citizen.CreateThread(function()
while true do

   Citizen.Wait(10)

   if CurrentAction ~= nil then

    SetTextComponentFormat('STRING')
    AddTextComponentString(CurrentActionMsg)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)

      if IsControlPressed(0,  Keys['E']) and PlayerData.gang ~= nil and PlayerData.gang.name == CurrentActionData.station and (GetGameTimer() - GUI.Time) > 150 then
        if CurrentAction == 'menu_cloakroom' then
          OpenCloakroomMenu()
        elseif CurrentAction == 'menu_armory' then
          OpenArmoryMenu(CurrentActionData.station)
        elseif CurrentAction == 'menu_vehicle_spawner' then
          ListOwnedCarsMenu()
        elseif CurrentAction == 'delete_vehicle' then
          StoreOwnedCarsMenu()
        elseif CurrentAction == 'menu_boss_actions' then
          ESX.UI.Menu.CloseAll()
          TriggerEvent('gangs:openBossMenu', CurrentActionData.station, function(data, menu)
          menu.close()
          CurrentAction     = 'menu_boss_actions'
          CurrentActionMsg  = _U('open_bossmenu')
          CurrentActionData = {}
          end)
        end
        CurrentAction = nil
        GUI.Time      = GetGameTimer()
      end
    end
  end
end)

GetVehicleProperties = function(vehicle)
  if DoesEntityExist(vehicle) then
      local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)

      vehicleProps["tyres"] = {}
      vehicleProps["windows"] = {}
      vehicleProps["doors"] = {}

      for id = 1, 7 do
          local tyreId = IsVehicleTyreBurst(vehicle, id, false)
      
          if tyreId then
              vehicleProps["tyres"][#vehicleProps["tyres"] + 1] = tyreId
      
              if tyreId == false then
                  tyreId = IsVehicleTyreBurst(vehicle, id, true)
                  vehicleProps["tyres"][ #vehicleProps["tyres"]] = tyreId
              end
          else
              vehicleProps["tyres"][#vehicleProps["tyres"] + 1] = false
          end
      end

      for id = 1, 13 do
          local windowId = IsVehicleWindowIntact(vehicle, id)

          if windowId ~= nil then
              vehicleProps["windows"][#vehicleProps["windows"] + 1] = windowId
          else
              vehicleProps["windows"][#vehicleProps["windows"] + 1] = true
          end
      end
      
      for id = 0, 5 do
          local doorId = IsVehicleDoorDamaged(vehicle, id)
      
          if doorId then
              vehicleProps["doors"][#vehicleProps["doors"] + 1] = doorId
          else
              vehicleProps["doors"][#vehicleProps["doors"] + 1] = false
          end
      end

      vehicleProps["engineHealth"] = GetVehicleEngineHealth(vehicle)
      vehicleProps["bodyHealth"] = GetVehicleBodyHealth(vehicle)
      vehicleProps["fuelLevel"] = GetVehicleFuelLevel(vehicle)

      return vehicleProps
  end
end

function StoreOwnedCarsMenu()
	local playerPed    = PlayerPedId()
  local coords       = GetEntityCoords(playerPed)
  local vehicle      = CurrentActionData.vehicle
  local vehicleProps = GetVehicleProperties(vehicle)
  local engineHealth = GetVehicleEngineHealth(vehicle)
  local plate        = vehicleProps.plate
  if GetPedInVehicleSeat(vehicle, -1) == playerPed then
    ESX.TriggerServerCallback('PX_garage:validateVehicle', function(valid)
      if valid then
          putaway(vehicle, vehicleProps)
      else
        ESX.ShowNotification('Shoma nemitavanid in mashin ro dar Parking Park konid', 'error')
      end
    end, vehicleProps)
  else
    ESX.ShowNotification("Mikhai Glitch Bezani? Movafagh Bashi!", 'error')
  end
end

-- Put Away Vehicles
function putaway(vehicle, vehicleProps)
  TaskLeaveVehicle(PlayerPedId(), vehicle, 0)
  while IsPedInVehicle(PlayerPedId(), vehicle, true) do
    Citizen.Wait(1)
  end
  Citizen.Wait(1000)
	ESX.Game.DeleteVehicle(vehicle)
	-- TriggerServerEvent('esx_advancedgarage:setVehicleState', vehicleProps.plate, true)
  TriggerServerEvent('PX_garage:modifystored', vehicleProps, 1, 'gang')
	ESX.ShowNotification('Mashin dar Garage Park shod', 'success')
end

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(10)
		if IsControlPressed(0, Keys["F5"]) then
      OpenGangActionsMenu()
		end
  end
end)

---------------------------------------------------------------------------------------------------------
-- NB : gestion des menu
---------------------------------------------------------------------------------------------------------

RegisterNetEvent('NB:openMenuGang')
AddEventHandler('NB:openMenuGang', function()
  OpenGangActionsMenu()
end)

RegisterNetEvent("setArmorHandler")
AddEventHandler("setArmorHandler",function()
  local ped = PlayerPedId()
  SetPedArmour(ped, Data.bulletproof)
end)

local blackListedWeapons = {
        'WEAPON_SMG',
        'WEAPON_CARBINERIFLE',
        'WEAPON_STUNGUN',
        'WEAPON_NIGHTSTICK',
        'WEAPON_PUMPSHOTGUN',
		'WEAPON_DOUBLEACTION'
}

function IsBlackList(weaponName)
  for k,v in pairs(blackListedWeapons) do
    if weaponName == v then
      return true
    end
  end

  return false
end

local SHBlip = {{}, false}
RegisterNetEvent('gangs:ShowBlip')
AddEventHandler("gangs:ShowBlip", function(blips)
  local DeleteSB = function()
    for k,v in pairs(SHBlip[1]) do
      if DoesBlipExist(v) then
        RemoveBlip(v)
      end
      ESX.ShowNotification("Blip Ha Ba Movafaghiat Hazf Shod", 'info')
    end
    SHBlip[2] = false
  end
  if SHBlip[2] then
    DeleteSB()
  else
    SHBlip[2] = true
    for k,v in pairs(blips) do
      local Blip = json.decode(v)
            local meleeBlip = AddBlipForRadius(Blip.x, Blip.y, Blip.z, 50.0)
            SetBlipHighDetail(meleeBlip, true)
            SetBlipColour(meleeBlip, 17)
            SetBlipAlpha(meleeBlip, 100)
            SetBlipAsShortRange(meleeBlip, true)
      table.insert(SHBlip[1], meleeBlip)
    end
    ESX.ShowNotification("Blip Gang Ha Ba Movafaghiat Add Shod", 'success')
    SetTimeout(60000, function()
      if SHBlip[2] then
        DeleteSB()
      end
    end)
  end
end)

RegisterCommand(
    "glist",
    function(source)
        ESX.TriggerServerCallback(
            "PX_glist:getganglistusers",
            function(a, info, cc, ngang)
                if a then
                    local elements = {}
                    for i = 1, #info, 1 do
                        table.insert(
                            elements,
                            {
                                label = info[i].name .. "(" .. info[i].Id .. ")"
                            }
                        )
                    end
                    ESX.UI.Menu.CloseAll()
                    ESX.UI.Menu.Open(
                        "default",
                        GetCurrentResourceName(),
                        "test",
                        {
                            title = "Afrade Online Gang " .. ngang .. " : (" .. cc .. ") Nafar",
                            align = "center",
                            elements = elements
                        },
                        function(data2, menu2)
                        end,
                        function(data2, menu2)
                            menu2.close()
                        end
                    )
                else
                    ESX.ShowNotification("~r~Shoma Dar Gangi Hozur Nadarid.", 'error')
                end
            end
        )
    end
)