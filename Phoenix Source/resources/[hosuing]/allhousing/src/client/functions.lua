

function GetBlipData(t,zoneCoord)
  if t == "owner" then
    if not Config.HideOwnBlips then
      local color,sprite
      if Config.UseZoneSprites then
        local zone = GetZoneAtCoords(zoneCoord.x,zoneCoord.y,zoneCoord.z)
        sprite = (Config.ZoneBlipSprites[zone] and Config.ZoneBlipSprites[zone].OwnerSprite or Config.BlipOwnerSprite)
      else
        sprite = Config.BlipOwnerSprite
      end
      if Config.UseZoneColoring then
        local zone = GetZoneAtCoords(zoneCoord.x,zoneCoord.y,zoneCoord.z)
        color = (Config.ZoneBlipColors[zone] and Config.ZoneBlipColors[zone].OwnerColor or Config.BlipOwnerColor)
      else
        color = Config.BlipOwnerColor
      end
      return color,sprite
    else
      return false
    end
  elseif t == "owned" then
    if not Config.HideSoldBlips then
      local color,sprite
      if Config.UseZoneSprites then
        local zone = GetZoneAtCoords(zoneCoord.x,zoneCoord.y,zoneCoord.z)
        sprite = (Config.ZoneBlipSprites[zone] and Config.ZoneBlipSprites[zone].OwnedSprite or Config.BlipOwnedSprite)
      else
        sprite = Config.BlipOwnedSprite
      end
      if Config.UseZoneColoring then
        local zone = GetZoneAtCoords(zoneCoord.x,zoneCoord.y,zoneCoord.z)
        color = (Config.ZoneBlipColors[zone] and Config.ZoneBlipColors[zone].OwnedColor or Config.BlipOwnedColor)
      else
        color = Config.BlipOwnedColor
      end
      return color,sprite
    else
      return false
    end
  elseif t == "empty" then
    if not Config.HideEmptyBlips then
      local color,sprite
      if Config.UseZoneSprites then
        local zone = GetZoneAtCoords(zoneCoord.x,zoneCoord.y,zoneCoord.z)
        sprite = (Config.ZoneBlipSprites[zone] and Config.ZoneBlipSprites[zone].EmptySprite or Config.BlipEmptySprite)
      else
        sprite = Config.BlipEmptySprite
      end
      if Config.UseZoneColoring then
        local zone = GetZoneAtCoords(zoneCoord.x,zoneCoord.y,zoneCoord.z)
        color = (Config.ZoneBlipColors[zone] and Config.ZoneBlipColors[zone].EmptyColor or Config.BlipEmptyColor)
      else
        color = Config.BlipEmptyColor
      end
      return color,sprite
    else
      return false
    end
  end
end

function RefreshBlips()
  local identifier = GetPlayerIdentifier()
  if Config.UseBlips then
    for _,house in pairs(Houses) do
      if house.Blip then
        RemoveBlip(house.Blip)
      end

      local color,sprite,text
      if house.Owned and house.Owner and (house.Owner == identifier) then
        text = "My Property"
        color, sprite, display = GetBlipData("owner", house.Entry)
      elseif house.Owned and house.HouseKeys[identifier] then
        text = "Proprty Access"
        color,sprite, display = GetBlipData("owned", house.Entry)
      else
        if house.Owner == identifier then
          text = "Your Property For Sale"
          color, sprite = 2, 350
        else
          text = "Empty Property"
          color,sprite = GetBlipData("empty", house.Entry)
        end
      end

      if color and sprite then
        house.Blip = CreateBlip(house.Entry,sprite,color,text, 1.0, display or 3)
      end
    end
  end
end

function CreateBlip(pos,sprite,color,text,scale,display,shortRange,highDetail)
  local blip = AddBlipForCoord(pos.x,pos.y,pos.z)
  SetBlipSprite               (blip, (sprite or 1))
  SetBlipColour               (blip, (color or 4))
  SetBlipScale                (blip, (scale or 1.0))
  SetBlipDisplay              (blip, (display or 3))
  SetBlipAsShortRange         (blip, true)
  SetBlipHighDetail           (blip, (highDetail or true))
  BeginTextCommandSetBlipName ("STRING")
  AddTextComponentString      ((text or "Blip "..tostring(blip)))
  EndTextCommandSetBlipName   (blip)
  return blip
end

function ShowNotification(msg)
  TriggerEvent("esx:showNotification", msg)
end

function ShowAdvancedNotification(sender, subject, msg, textureDict, iconType, flash, saveToBrief, hudColorIndex)
  TriggerEvent("esx:showNotification", msg)
end

function ShowHelpNotification(msg, thisFrame, beep, duration)
  AddTextEntry('ahHelpNotification', msg)

  if thisFrame then
    DisplayHelpTextThisFrame('ahHelpNotification', false)
  else
    if beep == nil then beep = true end
    BeginTextCommandDisplayHelp('ahHelpNotification')
    EndTextCommandDisplayHelp(0, false, beep, duration or -1)
  end
end

DrawText3D = function(_x,_y,_z, text, size)
  local coords = vector3(_x,_y,_z)
  local onScreen, x, y = World3dToScreen2d(coords.x, coords.y, coords.z)
  local camCoords      = GetGameplayCamCoords()
  local dist           = GetDistanceBetweenCoords(camCoords, coords.x, coords.y, coords.z, true)
  local size           = size

  if size == nil then
    size = 1
  end

  local scale = (size / dist) * 2
  local fov   = (1 / GetGameplayCamFov()) * 100
  local scale = scale * fov

  if onScreen then
    SetTextScale(0.0 * scale, 0.55 * scale)
    SetTextFont(1)
    SetTextColour(255, 255, 255, 255)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry('STRING')
    SetTextCentre(1)

    AddTextComponentString(text)
    DrawText(x, y)
  end
end

_Callbacks = {}
_CallbackID = 0
function Callback(event,...)
  local myId = _CallbackID  
  _Callbacks[myId] = false
  _CallbackID = _CallbackID + 1
  TriggerServerEvent("Allhousing:Callback",myId,event,...)

  local start = GetGameTimer()
  while not (_Callbacks[myId]) and (GetGameTimer() - start < 30000) do Wait(0); end

  if not _Callbacks[myId] then 
    return false
  else 
    return table.unpack(_Callbacks[myId])
  end
end

function _Calledback(id,...)
  _Callbacks[id] = {...}
end

GoToDoor = function(p)
  local plyPed = PlayerPedId()
  TaskGoStraightToCoord(plyPed, p.x, p.y, p.z, 10.0, 10, p.w, 0.5)
  local dist = 999
  local tick = 0
  while dist > 0.5 and tick < 10000 do
    local pPos = GetEntityCoords(plyPed)
    dist = Vdist(pPos.x,pPos.y,pPos.z, p.x,p.y,p.z)
    tick = tick + 1
    Citizen.Wait(100)  
  end
  ClearPedTasksImmediately(plyPed)
end

FaceCoordinate = function(pos)
  local plyPed = PlayerPedId()
  TaskTurnPedToFaceCoord(plyPed, pos.x,pos.y,pos.z, -1)
  Wait(1500)
  ClearPedTasks(plyPed)
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

function calculateCost(engine, vehicle, data)
  local cost = math.floor((1000 - engine) / 1000 * 5000 * 5)
  repairRequest(cost, vehicle, data)
end

function repairRequest(cost, vehicle, vehData)
	ESX.UI.Menu.CloseAll()
  
	local elements = {
		{label = "Park kardan mashin", value = 'yes'},
		-- {label = "Be Mechanici miram", value = 'no'}
	}
	
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'repair_menu', {
		title    = "Tayide tamir mashin",
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		menu.close()
		local new = GetVehicleProperties(vehicle)
		if data.current.value == 'yes' then
			storeVehicle(vehicle, new)
    end
    
	end, function(data, menu)
		menu.close()
	end)
end

function getClosestHome()
	local closestDist,closest
  local plyPos = GetEntityCoords(PlayerPedId())
  for _,thisHouse in pairs(Houses) do
    local dist = Vdist(plyPos,thisHouse.Entry.xyz)
    if not closestDist or dist < closestDist then
      closest = thisHouse
      closestDist = dist
    end
  end

  if closest and closestDist and closestDist <= 3 then
    return closest
  else
    return false
  end
end

function storeVehicle(vehicle, data)
  TaskLeaveVehicle(PlayerPedId(), vehicle, 0)
  while IsPedInVehicle(PlayerPedId(), vehicle, true) do
    Citizen.Wait(1)
  end
  Citizen.Wait(1000)
  ESX.Game.DeleteVehicle(vehicle)
  TriggerServerEvent("Allhousing:VehicleStored", {house = data.house, plate = data.plate, data.props})
  ShowNotification(Labels["VehicleStored"])
end

local shellTimes = {
  ["Trailer"] = { hour = 6, minute = 0, second = 0 },
  ["HotelV1"] = { hour = 0, minute = 0, second = 0 },
  ["Lester"] = { hour = 0, minute = 0, second = 0 },
  ["ApartmentV1"] = { hour = 0, minute = 0, second = 0 },
  ["ApartmentV2"] = { hour = 6, minute = 0, second = 0 },
  ["Trevor"] = { hour = 0, minute = 0, second = 0 },
  ["HighEndV1"] = { hour = 6, minute = 0, second = 0 },
  ["HighEndV2"] = { hour = 6, minute = 0, second = 0 },
  ["Ranch"] = { hour = 6, minute = 0, second = 0 },
  ["Michaels"] = { hour = 10, minute = 30, second = 0 },
  ["Office1"] = { hour = 0, minute = 0, second = 0 },
  ["Office2"] = { hour = 7, minute = 0, second = 0 },
  ["OfficeBig"] = { hour = 7, minute = 0, second = 0 },
  ["Franklin"] = { hour = 7, minute = 0, second = 0 },
  ["Medium2"] = { hour = 7, minute = 0, second = 0 },
  ["Medium3"] = { hour = 7, minute = 0, second = 0 },
  ["CokeShell1"] = { hour = 0, minute = 0, second = 0 },
  ["CokeShell2"] = { hour = 0, minute = 0, second = 0 },
  ["MethShell"] = { hour = 0, minute = 0, second = 0 },
  ["WeedShell1"] = { hour = 5, minute = 0, second = 0 },
  ["WeedShell2"] = { hour = 6, minute = 0, second = 0 },
  ["GarageShell1"] = { hour = 0, minute = 0, second = 0 },
  ["GarageShell2"] = { hour = 0, minute = 0, second = 0 },
  ["GarageShell3"] = { hour = 7, minute = 30, second = 0 },
  ["NewApt2"] = { hour = 6, minute = 0, second = 0 },
  ["NewApt3"] = { hour = 7, minute = 0, second = 0 },
  ["Warehouse1"] = { hour = 12, minute = 0, second = 0 },
  ["Warehouse2"] = { hour = 16, minute = 0, second = 0 },
  ["Warehouse3"] = { hour = 7, minute = 0, second = 0 },
  ["Store1"] = { hour = 7, minute = 0, second = 0 },
  ["Store2"] = { hour = 7, minute = 0, second = 0 },
  ["Store3"] = { hour = 7, minute = 0, second = 0 },
  ["Gunstore"] = { hour = 7, minute = 0, second = 0 },
  ["Barbers"] = { hour = 7, minute = 0, second = 0 },
}

SetWeatherAndTime = function(syncTime) 
  if not syncTime then
    TriggerEvent('vSync:toggle', false)
    SetRainFxIntensity(0.0)
    SetBlackout(false)
    ClearOverrideWeather()
    ClearWeatherTypePersist()
    SetWeatherTypePersist('CLEAR')
    SetWeatherTypeNow('CLEAR')
    SetWeatherTypeNowPersist('CLEAR')
  else
      TriggerEvent('vSync:toggle', true)
  end
end

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(1000)
    if InsideHouse then
      local time = shellTimes[InsideHouse.Shell]
      if time then NetworkOverrideClockTime(time.hour, time.minute, time.second) end
    end
  end
end)

RegisterNetEvent("Allhousing:Calledback")
AddEventHandler("Allhousing:Calledback",_Calledback)

RegisterNetEvent("Allhousing:NotifyPlayer")
AddEventHandler("Allhousing:NotifyPlayer",ShowNotification)

