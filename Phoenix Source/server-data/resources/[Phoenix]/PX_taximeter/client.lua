local guiEnabled = false
local Total = 10
local PerMinute = 1
local BaseFare = 0
local taxiFreeze = false

DecorRegister("totalCost", 3)
DecorRegister("costPerMinute", 3)
DecorRegister("taxiFreeze", 2)

function openGui()
 guiEnabled = true
 SendNUIMessage({openSection = "openTaxiMeter"})
end

function closeGui()
 if guiEnabled then
  SendNUIMessage({openSection = "closeTaxiMeter"})
  guiEnabled = false
  SetPlayerControl(PlayerId(), 1, 0)
 end
end

Citizen.CreateThread(function()
 while true do
  Citizen.Wait(500)
  local isInVehicle = IsPedInAnyVehicle(PlayerPedId(), false)
  if isInVehicle then
   local currentVehicle = GetVehiclePedIsIn(PlayerPedId(), false)
   if IsPedInAnyTaxi(PlayerPedId()) then
    PerMinute = DecorGetInt(currentVehicle, 'costPerMinute')
    openGui()
    updateDriverMeter()
   else
    Citizen.Wait(2500)
   end
  else
   closeGui()
   Citizen.Wait(2500)
  end
 end
end)

Citizen.CreateThread(function()
 while true do
  if guiEnabled then
   Citizen.Wait(6000)
   local currentVehicle = GetVehiclePedIsIn(PlayerPedId(), false)
   if not DecorGetBool(currentVehicle, 'taxiFreeze') then
    local totalFare = DecorGetInt(currentVehicle, 'totalCost')
    local newFare = totalFare + math.ceil(PerMinute / 10)
    DecorSetInt(currentVehicle, 'totalCost', newFare)
    updateDriverMeter()
   end
  else
   Citizen.Wait(5000)
  end
 end
end)


function updateDriverMeter()
 local currentVehicle = GetVehiclePedIsIn(PlayerPedId(), false)
 local updateTotal = DecorGetInt(currentVehicle, 'totalCost')

 SendNUIMessage({openSection = "updateTotal", sentnumber = "$"..updateTotal..".00" })
 SendNUIMessage({openSection = "updatePerMinute", sentnumber = "$"..PerMinute..".00" })
 SendNUIMessage({openSection = "updateBaseFare", sentnumber = "$"..BaseFare..".00" })
end


RegisterCommand("setnumbertaximin", function(source, args)
 local currentVehicle = GetVehiclePedIsIn(PlayerPedId(), false)

 if IsPedInAnyTaxi(PlayerPedId()) then
  DecorSetInt(currentVehicle, 'costPerMinute', tonumber(args[1]))
 end
end)

RegisterCommand("setnumbertaxireset", function(source, args)
 local currentVehicle = GetVehiclePedIsIn(PlayerPedId(), false)
 local driverPed = GetPedInVehicleSeat(currentVehicle, -1)
 if IsPedInAnyTaxi(PlayerPedId()) then
  if GetPlayerPed(-1) == driverPed then
   DecorSetInt(currentVehicle, 'totalCost', 0)
   DecorSetInt(currentVehicle, 'costPerMinute', 0)
   DecorSetInt(currentVehicle, 'totalCost', BaseFare)
  end
 end
end)