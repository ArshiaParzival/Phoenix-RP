local PlayerData              = {}
local HasAlreadyEnteredMarker = false
local LastZone                = nil
local CurrentAction           = nil
local CurrentActionMsg        = ''
local CurrentActionData       = {}
local Blips                   = {}
local isBarman                = false
local isInMarker              = false
local isInPublicMarker        = false
local hintIsShowed            = false
local hintToDisplay           = "no hint to display"

ESX                           = nil

Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(0)
  end
end)

function IsJobTrue()
    if PlayerData ~= nil then
        local IsJobTrue = false
        if PlayerData.job ~= nil and PlayerData.job.name == 'casino' then
            IsJobTrue = true
        end
        return IsJobTrue
    end
end

function IsGradeBoss()
    if PlayerData ~= nil then
        local IsGradeBoss = false
        if PlayerData.job.grade_name == 'boss' or PlayerData.job.grade_name == 'manager' then
            IsGradeBoss = true
        end
        return IsGradeBoss
    end
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

Citizen.CreateThread(function()
  while true do
      Citizen.Wait(0)
      local coords = GetEntityCoords(PlayerPedId())
      local distance = #(coords - vector3(1114.94, 254.59, -45.83))
      if distance < 20 then
          if PlayerData.job.name == "casino" and PlayerData.job.grade > 2 then
              DrawMarker(20, vector3(1114.94, 254.59, -45.83), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.8, 0.8, 0.5, 255, 255, 255, 255, false, true, nil, false)
              if distance < 2.0 then
                  TriggerEvent('esx:showHelpNotification', 'Press ~INPUT_CONTEXT~ For Open ~r~Menu~s~')
                  if IsControlJustReleased(1, 38) then
                      OpenMenuAction()
                  end
              end
          else
              Citizen.Wait(5000)
          end
      else
          Citizen.Wait(2000)
      end
  end
end)

function OpenMenuAction()
  ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'wash_money', {
    title = "Wash Money"
  }, function(data, menu)
    local amount = tonumber(data.value)
    if amount == nil then
      ESX.ShowNotification("Invalid Amount", 'error')
    else
      menu.close()
      TriggerServerEvent('Parzival:casino:washMoney', amount)
    end
  end, function(data, menu)
    menu.close()
  end)
end

function OpenVaultMenu()

  if CasinoConfig.EnableVaultManagement then

    local elements = {
      {label = 'Stash', value = 'stash'},
    }
    

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'vault',
      {
        title    = _U('vault'),
        align    = 'top-left',
        elements = elements,
      },
      function(data, menu)

        if data.current.value == 'stash' then
          Other = {maxweight = 5000000, slots = 100}
          TriggerEvent("PX_inventory:client:SetCurrentStash", PlayerData.job.name)
          TriggerServerEvent("PX_inventory:server:OpenInventory", "stash", PlayerData.job.name, Other)
        end

      end,
      
      function(data, menu)

        menu.close()

        CurrentAction     = 'menu_vault'
        CurrentActionMsg  = _U('open_vault')
        CurrentActionData = {}
      end
    )

  end

end


AddEventHandler('casino_job:hasEnteredMarker', function(zone)
 
    if zone == 'BossActions' and IsGradeBoss() then
      CurrentAction     = 'menu_boss_actions'
      CurrentActionMsg  = _U('open_bossmenu')
      CurrentActionData = {}
    end

    if CasinoConfig.EnableVaultManagement then
      if zone == 'Vaults' then
        CurrentAction     = 'menu_vault'
        CurrentActionMsg  = _U('open_vault')
        CurrentActionData = {}
      end
    end
end)

AddEventHandler('casino_job:hasExitedMarker', function(zone)

    CurrentAction = nil
    ESX.UI.Menu.CloseAll()

end)

-- Create blips
Citizen.CreateThread(function()

    local blipMarker = CasinoConfig.Blips.Blip
    local blipCoord = AddBlipForCoord(blipMarker.Pos.x, blipMarker.Pos.y, blipMarker.Pos.z)

    SetBlipSprite (blipCoord, blipMarker.Sprite)
    SetBlipDisplay(blipCoord, blipMarker.Display)
    SetBlipScale  (blipCoord, blipMarker.Scale)
    SetBlipColour (blipCoord, blipMarker.Colour)
    SetBlipAsShortRange(blipCoord, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Casino")
    EndTextCommandSetBlipName(blipCoord)


end)

-- Display markers
Citizen.CreateThread(function()
    while true do

        Wait(0)
        if IsJobTrue() then

            local coords = GetEntityCoords(GetPlayerPed(-1))

            for k,v in pairs(CasinoConfig.Zones) do
                if(v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < CasinoConfig.DrawDistance) then
                    DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, false, 2, false, false, false, false)
                end
            end

        end

    end
end)

-- Enter / Exit marker events
Citizen.CreateThread(function()
    while true do

        Wait(0)
        if IsJobTrue() then

            local coords      = GetEntityCoords(GetPlayerPed(-1))
            local isInMarker  = false
            local currentZone = nil

            for k,v in pairs(CasinoConfig.Zones) do
                if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
                    isInMarker  = true
                    currentZone = k
                end
            end

            if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
                HasAlreadyEnteredMarker = true
                LastZone                = currentZone
                TriggerEvent('casino_job:hasEnteredMarker', currentZone)
            end

            if not isInMarker and HasAlreadyEnteredMarker then
                HasAlreadyEnteredMarker = false
                TriggerEvent('casino_job:hasExitedMarker', LastZone)
            end

        end

    end
end)

-- Key Controls
Citizen.CreateThread(function()
  while true do

    Citizen.Wait(0)

    if CurrentAction ~= nil then

      SetTextComponentFormat('STRING')
      AddTextComponentString(CurrentActionMsg)
      DisplayHelpTextFromStringLabel(0, 0, 1, -1)

      if IsControlJustReleased(0,  38) and IsJobTrue() then

        if CurrentAction == 'menu_vault' then
            OpenVaultMenu()
        end
        if CurrentAction == 'menu_boss_actions' and IsGradeBoss() then

          local options = {
            wash      = CasinoConfig.EnableMoneyWash,
          }

          ESX.UI.Menu.CloseAll()

          TriggerEvent('esx_society:openBossMenu', 'casino', function(data, menu)

            menu.close()
            CurrentAction     = 'menu_boss_actions'
            CurrentActionMsg  = _U('open_bossmenu')
            CurrentActionData = {}
          end,options)
        end
        CurrentAction = nil
      end
    end

  end
end)


-----------------------
----- TELEPORTERS -----

AddEventHandler('casino_job:teleportMarkers', function(position)
  SetEntityCoords(GetPlayerPed(-1), position.x, position.y, position.z)
end)

-- Show top left hint
Citizen.CreateThread(function()
  while true do
    Wait(0)
    if hintIsShowed == true then
      SetTextComponentFormat("STRING")
      AddTextComponentString(hintToDisplay)
      DisplayHelpTextFromStringLabel(0, 0, 1, -1)
    end
  end
end)

-- Display teleport markers
Citizen.CreateThread(function()
  while true do
    Wait(0)

    if IsJobTrue() then

        local coords = GetEntityCoords(GetPlayerPed(-1))
        for k,v in pairs(CasinoConfig.TeleportZones) do
          if(v.Marker ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < CasinoConfig.DrawDistance) then
            DrawMarker(v.Marker, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
          end
        end

    end

  end
end)

-- Activate teleport marker
Citizen.CreateThread(function()
  while true do
    Wait(0)
    local coords      = GetEntityCoords(GetPlayerPed(-1))
    local position    = nil
    local zone        = nil

    if IsJobTrue() then

        for k,v in pairs(CasinoConfig.TeleportZones) do
          if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
            isInPublicMarker = true
            position = v.Teleport
            zone = v
            break
          else
            isInPublicMarker  = false
          end
        end

        if IsControlJustReleased(0, 38) and isInPublicMarker then
          TriggerEvent('casino_job:teleportMarkers', position)
        end

        -- hide or show top left zone hints
        if isInPublicMarker then
          hintToDisplay = zone.Hint
          hintIsShowed = true
        else
          if not isInMarker then
            hintToDisplay = "no hint to display"
            hintIsShowed = false
          end
        end
    end
  end
end)