local isUiOpen = false 
local speedBuffer  = {}
local velBuffer    = {}
local beltOn       = false
local wasInCar     = false
local vehData =  {active = false}


IsCar = function(veh)
  local vc = GetVehicleClass(veh)
  return (vc >= 0 and vc <= 7) or (vc >= 9 and vc <= 12) or (vc >= 15 and vc <= 20)
  end 

Fwv = function (entity)
  local hr = GetEntityHeading(entity) + 90.0
  if hr < 0.0 then hr = 360.0 + hr end
  hr = hr * 0.0174533
  return { x = math.cos(hr) * 2.0, y = math.sin(hr) * 2.0 }
end

Citizen.CreateThread(function()
  while true do
  Citizen.Wait(10)

    if vehData.active then
      wasInCar = true
      if isUiOpen == false and not IsPlayerDead(PlayerId()) then
          SendNUIMessage({
          displayWindow = 'true'
          })
          isUiOpen = true
      end

      if not beltOn then
        speedBuffer[2] = speedBuffer[1]
        speedBuffer[1] = GetEntitySpeed(vehData.vehicle)
        if speedBuffer[2] ~= nil 
            and GetEntitySpeedVector(vehData.vehicle, true).y > 1.0  
            and speedBuffer[1] > 19.25 
            and (speedBuffer[2] - speedBuffer[1]) > (speedBuffer[1] * 0.255) then
            
            local co = GetEntityCoords(vehData.ped)
            local fw = Fwv(vehData.ped)
            SetEntityCoords(vehData.ped, co.x + fw.x, co.y + fw.y, co.z - 0.47, true, true, true)
            SetEntityVelocity(vehData.ped, velBuffer[2].x, velBuffer[2].y, velBuffer[2].z)
            Citizen.Wait(1)
            SetPedToRagdoll(vehData.ped, 1000, 1000, 0, 0, 0, 0)
        end
        
        velBuffer[2] = velBuffer[1]
        velBuffer[1] = GetEntityVelocity(vehData.vehicle)
      else
        Citizen.Wait(500)
      end
    
  elseif wasInCar then
    wasInCar = false
    beltOn = false
    speedBuffer[1], speedBuffer[2] = 0.0, 0.0
      if isUiOpen then
        SendNUIMessage({
          displayWindow = 'false'
        })
        isUiOpen = false 
      end
  else 
    Citizen.Wait(500)
  end
  
end
end)

AddEventHandler("onKeyDown", function(key)
if not vehData.active then
  return
end

if key == "l" then
  beltOn = not beltOn
  
  if beltOn then 
    -- TriggerEvent("esx:showNotification", "Kamaraband Shoma Baste Shod!")
    TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 0.9, 'buckle', 0.9)
    
    SendNUIMessage({
      displayWindow = 'false'
      })
    isUiOpen = true 
  else 
    speedBuffer  = {}
    velBuffer    = {}
    -- TriggerEvent("esx:showNotification", "Kamarband Shoma Baaz Shod!")
    TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 0.9, 'unbuckle', 0.9)

    SendNUIMessage({
      displayWindow = 'true'
      })
    isUiOpen = true  
  end

elseif key == "f" then
  if vehData.active and beltOn then
    DisableControlAction(0, 75, true)  -- Disable exit vehicle when stop
    DisableControlAction(27, 75, true) -- Disable exit vehicle when Driving
  end
end
end)


RegisterNetEvent('seatbelt:beband')
AddEventHandler('seatbelt:beband', function(status)
  beltOn = true
  isUiOpen = true
  SendNUIMessage({
    displayWindow = 'false'
  })
  -- TriggerEvent("esx:showNotification", "Kamarband Shoma Baste Shod!")
  TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 0.9, 'buckle', 0.9)
end)



Citizen.CreateThread(function()
  while true do
      Citizen.Wait(500)
      local ped = PlayerPedId()
      local car = GetVehiclePedIsIn(ped)
     
      
      if car ~= 0 and IsCar(car) then
        vehData.ped = ped
        vehData.vehicle = car
        

        vehData.active = true

      else
        vehData = {active = false}
      end

  end
end)

RegisterNetEvent("Parzival:changebeltstatus")
AddEventHandler("Parzival:changebeltstatus",function(status)
beltOn = status
end)