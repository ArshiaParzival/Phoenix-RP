local vehicleHotwired = {}
local gotKeys = false
local failedAttempt = {}
local disableH = false
local sendNotif = false
local hasKilledNPC = false
local useLockpick = false
local vehicleBlacklist = {
 ['BMX'] = true,
 ['CRUISER'] = true,
 ['FIXTER'] = true,
 ['SCORCHER'] = true,
 ['TRIBIKE'] = true,
 ['TRIBIKE2'] = true,
 ['TRIBIKE3'] = true,
 ['FLATBED'] = true,
 ['BOXVILLE2'] = true,
 ['BENSON'] = true,
 ['PHANTOM'] = true,
 ['RUBBLE'] = true,
 ['RUMPO'] = true,
 ['YOUGA2'] = true,
 ['BOXVILLE'] = true,
 ['TAXI'] = true,
 ['DINGHY'] = true
 }

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

 ESX = nil

 Citizen.CreateThread(function()
  while ESX == nil do
      TriggerEvent('esx:getSharedObject', function(obj)
          ESX = obj
      end)
      Citizen.Wait(0)
  end

  while ESX.GetPlayerData().job == nil do
      Citizen.Wait(10)
  end

  ESX.PlayerData = ESX.GetPlayerData()
end)

Citizen.CreateThread(function()
 while true do
  Citizen.Wait(5)
  if disableF then
   DisableControlAction(0, 23, true)
  end
  if disableH then
   DisableControlAction(0, 74, true)
   DisableControlAction(0, 47, true)
  end
 end
end)

Citizen.CreateThread(function()
    while true do
        if DoesEntityExist(GetVehiclePedIsTryingToEnter(PlayerPedId())) then
            local veh = GetVehiclePedIsTryingToEnter(PlayerPedId())
            local pedd = GetPedInVehicleSeat(veh, -1)

            if DoesEntityExist(pedd) and not IsPedAPlayer(pedd) and not IsEntityDead(pedd) then
             SetVehicleDoorsLocked(veh, 2)
             SetPedCanBeDraggedOut(pedd, false)
             TaskVehicleMissionPedTarget(pedd, veh, PlayerPedId(), 8, 50.0, 790564, 300.0, 15.0, 1)
             disableF = true
             Wait(1500)
             disableF = false
            end
        end
        Citizen.Wait(0)
    end
end)

RegisterNetEvent('vehicle:start')
AddEventHandler('vehicle:start', function()
 local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
 SetVehicleEngineOn(vehicle, true, true)
end)

Citizen.CreateThread(function()
 while true do
  Citizen.Wait(5)

  if not IsPedInAnyVehicle(PlayerPedId(), false) then

   -- Exiting
   local aiming, targetPed = GetEntityPlayerIsFreeAimingAt(PlayerId(-1))
   if aiming then
    if DoesEntityExist(targetPed) and not IsPedAPlayer(targetPed) and IsPedArmed(PlayerPedId(), 7) then
     local vehicle = GetVehiclePedIsIn(targetPed, false)
     local plate = GetVehicleNumberPlateText(vehicle)
     local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId(), true), GetEntityCoords(vehicle, true), false)
     local playerped = PlayerPedId()
     local targetVehicle = GetVehiclePedIsUsing(playerped)

     if distance < 10 and IsPedFacingPed(targetPed, PlayerPedId(), 60.0) then
     
     SetVehicleForwardSpeed(vehicle, 0)

     SetVehicleForwardSpeed(vehicle, 0)
     TaskLeaveVehicle(targetPed, vehicle, 256)

     while IsPedInAnyVehicle(targetPed, false) do
      Citizen.Wait(5)
     end

     RequestAnimDict('missfbi5ig_22')
     RequestAnimDict('mp_common')

     SetPedDropsWeaponsWhenDead(targetPed,false)
     ClearPedTasks(targetPed)
     TaskTurnPedToFaceEntity(targetPed, GetPlayerPed(-1), 3.0)
     TaskSetBlockingOfNonTemporaryEvents(targetPed, true)
     SetPedFleeAttributes(targetPed, 0, 0)
     SetPedCombatAttributes(targetPed, 17, 1)
     SetPedSeeingRange(targetPed, 0.0)
     SetPedHearingRange(targetPed, 0.0)
     SetPedAlertness(targetPed, 0)
     SetPedKeepTask(targetPed, true)
     TaskPlayAnim(targetPed, "missfbi5ig_22", "hands_up_anxious_scientist", 8.0, -8, -1, 12, 1, 0, 0, 0)
     Wait(1500)
     TaskPlayAnim(targetPed, "missfbi5ig_22", "hands_up_anxious_scientist", 8.0, -8, -1, 12, 1, 0, 0, 0)
     Wait(2500)

     local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId(), true), GetEntityCoords(vehicle, true), false)

     if not IsEntityDead(targetPed) and distance < 12 then
      TaskPlayAnim(targetPed, "mp_common", "givetake1_a", 8.0, -8, -1, 12, 1, 0, 0, 0)
      Wait(750)
      TriggerEvent('DoLongHudText', 'You have been handed the keys!', 1)
      TriggerServerEvent('garage:addKeys', plate, GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
      Citizen.Wait(500)
      TaskReactAndFleePed(targetPed, GetPlayerPed(-1))
      SetPedKeepTask(targetPed, true)
      Wait(2500)
      TaskReactAndFleePed(targetPed, GetPlayerPed(-1))
      SetPedKeepTask(targetPed, true)
      Wait(2500)
      TaskReactAndFleePed(targetPed, GetPlayerPed(-1))
      SetPedKeepTask(targetPed, true)
      Wait(2500)
      TaskReactAndFleePed(targetPed, GetPlayerPed(-1))
      SetPedKeepTask(targetPed, true)
      end
     end
    end
   end
  end
 end
end)


Citizen.CreateThread(function()
 while true do
  Citizen.Wait(5)

  if IsPedShooting(PlayerPedId()) then
   hasKilledNPC = true
  end

  if IsPedInAnyVehicle(PlayerPedId(), false) then
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    local plate = GetVehicleNumberPlateText(vehicle)

   if DoesEntityExist(vehicle) and not hasVehicleKey(plate) and GetPedInVehicleSeat(vehicle, -1) == PlayerPedId() and not vehicleHotwired[plate] and not vehicleBlacklist[GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))] then
    while not IsPedInAnyVehicle(PlayerPedId(), false) do
     Citizen.Wait(5)
     if sendNotif then
      sendNotif = false
     end
    end

      SetVehicleEngineOn(vehicle, false, false)
      if not sendNotif then
        ESX.ShowNotification("Use Lockpick To Get Key", 'info')
        sendNotif = true
      end

      if useLockpick then
        if math.random(1, 10) <= 4 then
          SetVehicleAlarm(vehicle, true)
          StartVehicleAlarm(vehicle)
          SetVehicleAlarmTimeLeft(vehicle, 60000)
        end
          useLockpick = false
          TriggerEvent('animation:hotwire', true)
          local Skillbar = exports['PX_skillbar']:GetSkillbarObject()
          local SucceededAttempts = 0
          local NeededAttempts = 3
          ExecuteCommand("closei")
          Skillbar.Start({
            duration = math.random(700, 1300),
            pos = math.random(10, 30),
            width = math.random(25, 30),
        }, function()
            if SucceededAttempts + 1 >= NeededAttempts then
                SucceededAttempts = 0
                TriggerEvent('animation:hotwire', false)
                vehicleHotwired[plate] = true
                SetVehicleEngineOn(vehicle, true, true)
                local plate = GetVehicleNumberPlateText(vehicle)
                TriggerServerEvent('garage:addKeys', plate, GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
                TriggerEvent('DoLongHudText', 'Engine Started', 1)
                SetVehicleEngineOn(vehicle, true, true)
                TriggerEvent('animation:hotwire', false)
            else
                Skillbar.Repeat({
                    duration = math.random(600, 1200),
                    pos = math.random(10, 30),
                    width = math.random(15, 25),
                })
                SucceededAttempts = SucceededAttempts + 1
                TriggerEvent('animation:hotwire', false)
            end
            TriggerEvent('animation:hotwire', false)
          end, function()
            TriggerServerEvent('removelockpick')
            TriggerEvent('animation:hotwire', false)
          end)
        end
      end
    end
  end
end)



Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    if IsControlJustReleased(0, Keys['U']) then
      ToggleLocks()
    end
  end
end)

-- Giving Vehicle Keys
function ToggleLocks()
 local ped = PlayerPedId()
 local coords = GetEntityCoords(ped)
 local vehicle
 if IsPedInAnyVehicle(ped, false) then vehicle = GetVehiclePedIsIn(ped, false) else vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71) end
 if DoesEntityExist(vehicle) then
  Citizen.CreateThread(function()
   if hasVehicleKey(GetVehicleNumberPlateText(vehicle)) then
     if GetVehicleDoorLockStatus(vehicle) == 1 then
      SetVehicleDoorsLocked(vehicle, 2)
     TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 8, "lock", 0.4)
     TriggerEvent('DoLongHudText', 'Vehicle Locked', 1)
     playLockAnimation()
     else
     TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 8, "unlock", 0.4)
     TriggerEvent('DoLongHudText', 'Vehicle Unlocked', 1)
      SetVehicleDoorsLocked(vehicle, 1)
      playLockAnimation()
     end
   end
  end)
 else
  TriggerEvent('DoLongHudText', 'no vehicle found', 2)
 end
end

function playLockAnimation()
 if not IsPedInAnyVehicle(PlayerPedId(), false) then
  RequestAnimDict('anim@heists@keycard@')
  ClearPedSecondaryTask(PlayerPedId())
  TaskPlayAnim( PlayerPedId(), "anim@heists@keycard@", "exit", 8.0, 1.0, -1, 16, 0, 0, 0, 0 )
  Citizen.Wait(850)
  ClearPedTasks(PlayerPedId())
 end
end


function GetPlayers()
    local players = {}

    for i = 0, 255 do
        if NetworkIsPlayerActive(i) then
            table.insert(players, i)
        end
    end

    return players
end

function GetClosestPlayer()
    local players = GetPlayers()
    local closestDistance = -1
    local closestPlayer = -1
    local ply = GetPlayerPed(-1)
    local plyCoords = GetEntityCoords(ply, 0)

    for index,value in ipairs(players) do
        local target = GetPlayerPed(value)
        if(target ~= ply) then
            local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
            local distance = GetDistanceBetweenCoords(targetCoords["x"], targetCoords["y"], targetCoords["z"], plyCoords["x"], plyCoords["y"], plyCoords["z"], true)
            if(closestDistance == -1 or closestDistance > distance) then
                closestPlayer = value
                closestDistance = distance
            end
        end
    end

    return closestPlayer, closestDistance
end

function getVehicleInDirection(coordFrom, coordTo)
  local offset = 0
  local rayHandle
  local vehicle

  for i = 0, 100 do
    rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z + offset, 10, GetPlayerPed(-1), 0)
    a, b, c, d, vehicle = GetRaycastResult(rayHandle)

    offset = offset - 1

    if vehicle ~= 0 then break end
  end

  local distance = Vdist2(coordFrom, GetEntityCoords(vehicle))

  if distance > 25 then vehicle = nil end

    return vehicle ~= nil and vehicle or 0
end

local disable = false

RegisterNetEvent('animation:hotwire')
AddEventHandler('animation:hotwire', function(disable)
 local lPed = GetPlayerPed(-1)
 ClearPedTasks(lPed)
   ClearPedSecondaryTask(lPed)

 RequestAnimDict("mini@repair")
 while not HasAnimDictLoaded("mini@repair") do
  Citizen.Wait(0)
 end
 if disable ~= nil then
  if not disable then
   lockpicking = false
   return
  else
   lockpicking = true
  end
 end
 while lockpicking do

  if not IsEntityPlayingAnim(lPed, "mini@repair", "fixing_a_player", 3) then
   ClearPedSecondaryTask(lPed)
   TaskPlayAnim(lPed, "mini@repair", "fixing_a_player", 8.0, -8, -1, 16, 0, 0, 0, 0)
  end
  Citizen.Wait(1)
 end
 ClearPedTasks(lPed)
end)

-- Start stealing a car
local isLockpicking = false


RegisterNetEvent('lockpick:vehicleUse')
AddEventHandler('lockpick:vehicleUse', function()

 local coords = GetEntityCoords(GetPlayerPed(-1))
 local vehicle = nil
 if IsPedInAnyVehicle(PlayerPedId(), false) then
  vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
 else
  vehicle = GetClosestVehicle(coords, 8.0, 0, 70)
 end

  if DoesEntityExist(vehicle) then
   if not IsPedInAnyVehicle(PlayerPedId(), false) then
    if GetVehicleDoorLockStatus(vehicle) ~= 1 then
     RequestAnimDict("mini@repair")
     while not HasAnimDictLoaded("mini@repair") do
   	  Citizen.Wait(0)
     end

     TriggerEvent('carLockpickAnim')

     Citizen.CreateThread(function()
      TriggerEvent("mythic_progbar:client:progress", {
        name = "lockpikc_vehilce",
        duration = 20000,
        label = "Lockpicking Vehicle...",
        useWhileDead = false,
        canCancel = true,
        controlDisables = {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }
      }, function(status)
          isLockpicking = false
          ClearPedTasksImmediately(GetPlayerPed(-1))
          if not status then
            SetVehicleDoorsLocked(vehicle, 1)
            SetVehiceleDoorsLockedForAllPlayers(vehicle, false)
            TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 8, "unlock", 0.1)
            TriggerEvent('DoLongHudText', 'vehicle unlocked', 1)
            SetVehicleEngineOn(vehicle, true, true, true)
            SetVehicleLights(vehicle, 2) Wait(200)
            SetVehicleLights(vehicle, 1) Wait(200)
            SetVehicleLights(vehicle, 2) Wait(200)
            SetVehicleLights(vehicle, 1) Wait(200)
            Citizen.Wait(500)
            SetVehicleDoorsLocked(vehicle, 1)
            TaskEnterVehicle(GetPlayerPed(-1), vehicle, 10.0, -1, 16, 1, 0)
          end
          TriggerServerEvent('removelockpick')
      end)
     end)
    end
   else
    local plate = GetVehicleNumberPlateText(vehicle)
    if failedAttempt[plate] or vehicleHotwired[plate] or hasVehicleKey(plate) then
     TriggerEvent('DoLongHudText', 'You can not work out this hotwire', 1)
    else
     useLockpick = true
    end
   end
 end
end)





AddEventHandler('carLockpickAnim', function()
 isLockpicking = true
 loadAnimDict('veh@break_in@0h@p_m_one@')
 while isLockpicking do
  if not IsEntityPlayingAnim(PlayerPedId(), "veh@break_in@0h@p_m_one@", "low_force_entry_ds", 3) then
   TaskPlayAnim(PlayerPedId(), "veh@break_in@0h@p_m_one@", "low_force_entry_ds", 1.0, 1.0, 1.0, 1, 0.0, 0, 0, 0)
   Citizen.Wait(1500)
   ClearPedTasks(PlayerPedId())
  end
  Citizen.Wait(1)
 end
 ClearPedTasks(PlayerPedId())
end)


function loadAnimDict(dict)
 RequestAnimDict(dict)
 while not HasAnimDictLoaded(dict) do
  Citizen.Wait(5)
 end
end


Citizen.CreateThread(function()
 while true do
  Citizen.Wait(50)
  if GetVehiclePedIsTryingToEnter(GetPlayerPed(-1)) ~= nil and GetVehiclePedIsTryingToEnter(GetPlayerPed(-1)) ~= 0 and not gotKeys then
   local curveh = GetVehiclePedIsTryingToEnter(GetPlayerPed(-1))
   local plate1 = GetVehicleNumberPlateText(curveh)
   if not hasVehicleKey(GetVehicleNumberPlateText(curveh)) then
    local pedDriver = GetPedInVehicleSeat(curveh, -1)
    if DoesEntityExist(pedDriver) and IsEntityDead(pedDriver) and not IsPedAPlayer(pedDriver) and not hasVehicleKey(GetVehicleNumberPlateText(curveh)) and hasKilledNPC then
     hasKilledNPC = false
     gotKeys = true
     Wait(500)
     TriggerEvent("mythic_progbar:client:progress", {
      name = "taking",
      duration = 2000,
      label = "Taking Keys...",
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
          TriggerServerEvent('garage:addKeys', plate1, GetDisplayNameFromVehicleModel(curveh))
        end
        Wait(10000)
        gotKeys = false
    end)
    end
   end
  end
 end
end)

local vehicleKeys = {}

RegisterNetEvent("PX_hotwire:updateKeys")
AddEventHandler("PX_hotwire:updateKeys", function(add, plate)
  if add then
    vehicleKeys[plate] = true
  else
    vehicleKeys[plate] = false
  end
end)

function hasVehicleKey(plate)
  if vehicleKeys[plate] then
    return true
  else
    return false
  end
end

RegisterNetEvent("DoLongHudText")
AddEventHandler("DoLongHudText", function(text, int)
  if int == 1 then
    int = 'error'
  else
    int = 'succes'
  end
  ESX.ShowNotification(text, int)
end)

RegisterCommand("givekey", function()
  local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
  if closestPlayer ~= -1 and closestDistance <= 3.0 then
    local vehicle = nil
    if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
      vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
    else
      vehicle = ESX.Game.GetVehicleInDirection(4)
    end
    if vehicle == 0 or vehicle == nil then
        ESX.ShowNotification('Mashini Nazdik Shoma Nist!', 'error')
        return
    end
    local plate = GetVehicleNumberPlateText(vehicle)
    TriggerServerEvent('PX_hotwire:givekey', GetPlayerServerId(closestPlayer), plate)
    playLockAnimation()
  else
    ESX.ShowNotification('Kasi Nazdik Shoma Nist!', 'error')
  end
end)