
OpenMenu = function(...)
  if Config.UsingESX then
    if Config.UsingESXMenu then
      menuType = "ESX"
    elseif Config.UsingNativeUI then
      menuType = "NativeUI"
    end
  elseif Config.UsingNativeUI then
    menuType = "NativeUI"
  end

  if menuType == "NativeUI" then
    NativeUIHandler(...)
  elseif menuType == "ESX" then
    ESXMenuHandler(...)
  end
end

UnlockHouse = function(house)

  if Config.UsingNativeUI and _Pool then
    _Pool:CloseAllMenus()
  elseif Config.UsingESX and Config.UsingESXMenu then
    ESX.UI.Menu.CloseAll()
  end

    inProgressAction = true
    TriggerEvent("mythic_progbar:client:progress", {
      name = "unlock_house",
      duration = 3000,
      label = "Dar hale baz kardan ghofl khane",
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

        inProgressAction = false
        if InsideHouse then
          InsideHouse.Unlocked = true 
        else
          house.Unlocked = true
        end
        TriggerServerEvent("Allhousing:UnlockDoor",house)
        print(house)
        -- ShowNotification(Labels["Unlocked"])

      else
        inProgressAction = false
      end
    end)
  
end

LockHouse = function(house)

  if Config.UsingNativeUI and _Pool then
    _Pool:CloseAllMenus()
  elseif Config.UsingESX and Config.UsingESXMenu then
    ESX.UI.Menu.CloseAll()
  end

  inProgressAction = true
  TriggerEvent("mythic_progbar:client:progress", {
    name = "lock_house",
    duration = 3000,
    label = "Dar hale ghofl kardan dare khane",
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
      inProgressAction = false
      if InsideHouse then
        InsideHouse.Unlocked = false 
      else
        house.Unlocked = false
      end
      TriggerServerEvent("Allhousing:LockDoor",house)
      -- ShowNotification(Labels["Locked"])
    else
      inProgressAction = false
    end
  end)
end

GetVehiclesAtHouse = function(house)
  local data = Callback("Allhousing:GetVehicles",house)
  return data
end

GetVehicleLabel = function(model)
  return GetDisplayNameFromVehicleModel(model)
end

SpawnVehicle = function(pos,model,props)
  if Config.UsingNativeUI and _Pool then
    _Pool:CloseAllMenus()
  elseif Config.UsingESX and Config.UsingESXMenu then
    ESX.UI.Menu.CloseAll()
  end

  RequestModel(model)
  while not HasModelLoaded(model) do Wait(0); end

  local veh = CreateVehicle(model,pos.x,pos.y,pos.z,true,true)
  while not DoesEntityExist(veh) do Wait(0); end

  SetEntityAsMissionEntity(veh,true,true)
  SetEntityHeading(veh,pos.w)
  SetVehicleOnGroundProperly(veh)
    
  while not NetworkHasControlOfEntity(veh) do NetworkRequestControlOfEntity(veh); Wait(0); end
  while not NetworkGetEntityIsNetworked(veh) do NetworkRegisterEntityAsNetworked(veh); Wait(0); end

  local netId = NetworkGetNetworkIdFromEntity(veh)
  TriggerServerEvent('VehicleSecurity:VehicleSpawned',netId,props.plate)
  Wait(500)

  SetVehicleProperties(veh, props)
  SetVehRadioStation(veh, "OFF")
  SetVehicleEngineOn(veh,true)
  TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
  TriggerServerEvent("garage:addKeys", GetVehicleNumberPlateText(veh), GetDisplayNameFromVehicleModel(GetEntityModel(veh)))
  SetModelAsNoLongerNeeded(model)
end

OpenInventory = function()
  Other = {maxweight = 5000000, slots = 100}
  TriggerEvent("PX_inventory:client:SetCurrentStash", 'house_'..InsideHouse)
  TriggerServerEvent("PX_inventory:server:OpenInventory", "stash", 'house_'..InsideHouse, Other)
end

SetWardrobe = function(d)  
  if Config.UsingNativeUI and _Pool then
    _Pool:CloseAllMenus()
  elseif Config.UsingESX and Config.UsingESXMenu then
    ESX.UI.Menu.CloseAll()
  end

  ShowNotification(Labels["AcceptDrawText"]..Labels["SetWardrobe"])
  while true do
    if IsControlJustPressed(0,Config.Controls.Accept) then
      local pos = d.Entry.xyz - GetEntityCoords(PlayerPedId())
      InsideHouse.Wardrobe = pos + Config.SpawnOffset
      TriggerServerEvent("Allhousing:SetWardrobe",d,InsideHouse.Wardrobe)
      ShowNotification(Labels['WardrobeSet'])
      return
    end
    Wait(0)
  end
end

SetInventory = function(d)  
  if Config.UsingNativeUI and _Pool then
    _Pool:CloseAllMenus()
  elseif Config.UsingESX and Config.UsingESXMenu then
    ESX.UI.Menu.CloseAll()
  end

  ShowNotification(Labels["AcceptDrawText"]..Labels["SetInventory"])
  while true do
    if IsControlJustPressed(0,Config.Controls.Accept) then
      local pos = d.Entry.xyz - GetEntityCoords(PlayerPedId())
      InsideHouse.InventoryLocation = pos + Config.SpawnOffset
      TriggerServerEvent("Allhousing:SetInventory",d,InsideHouse.InventoryLocation)
      ShowNotification(Labels['InventorySet'])
      return
    end
    Wait(0)
  end
end

OpenFurniture = function(d)
  ShowNotification(Labels["FurniDrawText"]..Labels["ToggleFurni"])
  TriggerEvent("Allhousing:OpenFurni")    

  if Config.UsingNativeUI and _Pool then
    _Pool:CloseAllMenus()
  elseif Config.UsingESX and Config.UsingESXMenu then
    ESX.UI.Menu.CloseAll()
  end
end

GiveKeys = function(d,serverId)
  TriggerServerEvent("Allhousing:GiveKeys",d,serverId)
  ShowNotification(Labels["GivingKeys"])
  if Config.UsingNativeUI and _Pool then
    _Pool:CloseAllMenus()
  elseif Config.UsingESX and Config.UsingESXMenu then
    ESX.UI.Menu.CloseAll()
  end
end

TakeKeys = function(d,data)
  TriggerServerEvent("Allhousing:TakeKeys",d,data)
  ShowNotification(Labels["TakingKeys"])

  if Config.UsingNativeUI and _Pool then
    _Pool:CloseAllMenus()
  elseif Config.UsingESX and Config.UsingESXMenu then
    ESX.UI.Menu.CloseAll()
  end
end

MoveGarage = function(d)
  local last_dist = Vdist(d.Garage.xyz,d.Entry.xyz)
  local ped = PlayerPedId()
  FreezeEntityPosition(ped,false)

  if Config.UsingNativeUI and _Pool then
    _Pool:CloseAllMenus()
  elseif Config.UsingESX and Config.UsingESXMenu then
    ESX.UI.Menu.CloseAll()
  end

  ShowNotification(Labels["AcceptDrawText"]..Labels["SetGarage"])
  while true do
    if IsControlJustPressed(0,Config.Controls.Accept) then
      ped = PlayerPedId()
      local pos = GetEntityCoords(ped)
      if Vdist(pos,d.Entry.xyz) <= last_dist+5.0 then
        local head = GetEntityHeading(ped)
        d.Garage = vector4(pos.x,pos.y,pos.z,head)
        TriggerServerEvent("Allhousing:SetGarageLocation",d.Id,d.Garage)
        ShowNotification(Labels["GarageSet"])
        return
      else
        ShowNotification(Labels["GarageTooFar"])
      end
    end
    Wait(0)
  end
end

--InviteInside = function(d,serverId)
  --TriggerServerEvent("Allhousing:InviteInside",d,serverId)
--end

BuyHouse = function(d)
  local price = d.Price  

    if Config.UsingNativeUI and _Pool then
      _Pool:CloseAllMenus()
    elseif Config.UsingESX and Config.UsingESXMenu then      
      ESX.UI.Menu.CloseAll()
    end


    ESX.TriggerServerCallback('allhousing:CheckMoney', function(hasMoney)
      if hasMoney then

        --ESX.TriggerServerCallback('mf_housing:CanPurchaseHouse', function(canBuy)
          --if canBuy then
            ShowNotification(string.format(Labels["PurchasedHouse"],price))
            d.Owner = GetPlayerIdentifier()
            d.Owned = true
            TriggerServerEvent("Allhousing:PurchaseHouse",d)
          --end
        --end)

      else
          ESX.ShowNotification("Shoma pole kafi baraye kharid in khane nadarid!", 'error')
      end
    end, price)
    
end


MortgageHouse = function(d)
  local price = math.floor((d.Price / 100) * Config.MortgagePercent)
  if CanPlayerAfford(price) then
    ShowNotification(string.format(Labels["MortgagedHouse"],price))
    d.Owner = GetPlayerIdentifier()
    d.Owned = true

    if Config.UsingNativeUI and _Pool then
      _Pool:CloseAllMenus()
    elseif Config.UsingESX and Config.UsingESXMenu then      
      ESX.UI.Menu.CloseAll()
    end

    TriggerServerEvent("Allhousing:MortgageHouse",d)
  else
    ShowNotification(Labels["CantAffordHouse"])
  end
  FreezeEntityPosition(PlayerPedId(),false)
end

RaidHouse = function(d)
  EnterHouse(d,not Config.InventoryRaiding)
end

RegisterNetEvent('allhousing:setraid')
AddEventHandler('allhousing:setraid', function(HomeId)
  EnterHouse(HomeId,false)
end)

KnockOnDoor = function(d)  
  if Config.UsingNativeUI and _Pool then
    _Pool:CloseAllMenus()
  elseif Config.UsingESX and Config.UsingESXMenu then
    ESX.UI.Menu.CloseAll()
  end

  GoToDoor(d.Entry)
  FaceCoordinate(d.Entry)
  TriggerServerEvent("Allhousing:KnockOnDoor",d.Entry)
  local plyPed = PlayerPedId()
  while not HasAnimDictLoaded("timetable@jimmy@doorknock@") do RequestAnimDict("timetable@jimmy@doorknock@"); Wait(0); end
  TaskPlayAnim(plyPed, "timetable@jimmy@doorknock@", "knockdoor_idle", 8.0, 8.0, -1, 4, 0, 0, 0, 0 )     
  Wait(0)

  while IsEntityPlayingAnim(plyPed, "timetable@jimmy@doorknock@", "knockdoor_idle", 3) do Citizen.Wait(0); end 

  RemoveAnimDict("timetable@jimmy@door@knock@")
end

BreakInHouse = function(d)  
  if Config.UsingNativeUI and _Pool then
    _Pool:CloseAllMenus()
  elseif Config.UsingESX and Config.UsingESXMenu then
    ESX.UI.Menu.CloseAll()
  end

  GoToDoor(d.Entry)
  FaceCoordinate(d.Entry)

  if Config.LockpickRequired then
    local hasItem = CheckForLockpick()
    if not hasItem then
      ShowNotification(Labels["NoLockpick"])
      return
    end
  end


  local plyPed = PlayerPedId()
  local plyPos = GetEntityCoords(PlayerPedId())
  local zoneName = GetNameOfZone(plyPos.x,plyPos.y,plyPos.z)
  while not HasAnimDictLoaded("mini@safe_cracking") do RequestAnimDict("mini@safe_cracking"); Citizen.Wait(0); end
  TaskPlayAnim(plyPed, "mini@safe_cracking", "idle_base", 1.0, 1.0, -1, 1, 0, 0, 0, 0 ) 
  Wait(2000)
  if Config.UsingLockpickV1 then
    TriggerEvent("lockpicking:StartMinigame",4,function(didWin)
      if didWin then
        EnterHouse(d,true)
      else
        ClearPedTasksImmediately(plyPed)
        if Config.LockpickBreakOnFail then
          TriggerServerEvent("Allhousing:BreakLockpick")
        end
        ShowNotification(Labels["LockpickFailed"])
        FreezeEntityPosition(plyPed,false)
        for k,v in pairs(Config.PoliceJobs) do
          TriggerServerEvent("Allhousing:NotifyJobs",k,string.format(Labels["NotifyRobbery"],zoneName),d.Entry)
          if Config.UsingInteractSound then
            TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 20.0, 'security-alarm', 1.0)
          end
        end
      end
    end)
  elseif Config.UsingLockpickV2 then
    exports["lockpick"]:Lockpick(function(didWin)
      if didWin then
        EnterHouse(d,true)
        ShowNotification(Labels["LockpickSuccess"])
      else
        ClearPedTasksImmediately(plyPed)
        if Config.LockpickBreakOnFail then
          TriggerServerEvent("Allhousing:BreakLockpick")
        end
        ShowNotification(Labels["LockpickFailed"])
        FreezeEntityPosition(plyPed,false)
        for k,v in pairs(Config.PoliceJobs) do
          TriggerServerEvent("Allhousing:NotifyJobs",k,string.format(Labels["NotifyRobbery"],zoneName),d.Entry)
          if Config.UsingInteractSound then
            TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 20.0, 'security-alarm', 1.0)
          end
        end
      end
    end)
  else
    if Config.UsingProgressBars then
      exports["progressBars"]:startUI(Config.LockpickTime * 1000,Labels["ProgressLockpicking"])
    end
    Wait(Config.LockpickTime * 1000)
    if math.random(100) < Config.LockpickFailChance then
      if Config.LockpickBreakOnFail then
        TriggerServerEvent("Allhousing:BreakLockpick")
      end
      for k,v in pairs(Config.PoliceJobs) do
        TriggerServerEvent("Allhousing:NotifyJobs",k,string.format(Labels["NotifyRobbery"],zoneName),d.Entry)
        if Config.UsingInteractSound then
          TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 20.0, 'security-alarm', 1.0)
        end
      end
      ClearPedTasksImmediately(plyPed)
      ShowNotification(Labels["LockpickFailed"])
      FreezeEntityPosition(plyPed,false)
    else
      EnterHouse(d,true)
    end
  end
  RemoveAnimDict("mini@safe_cracking")
end

LeaveHouse = function(d, data)
  if Config.UsingNativeUI and _Pool then
    _Pool:CloseAllMenus()
  elseif Config.UsingESX and Config.UsingESXMenu then
    ESX.UI.Menu.CloseAll()
  end

  if data and data.force then
    if not data or not data.teleport then
      DoScreenFadeOut(500)
      TriggerEvent("Allhousing:Leave", d)
      Wait(1000)

      local plyPed = PlayerPedId()
      TriggerEvent('RL:Whitelist',
      6, ---ban type
      true --- state of that
      )
      SetEntityCoordsNoOffset(plyPed, InsideHouse.Entry.x,InsideHouse.Entry.y,InsideHouse.Entry.z)
      SetEntityHeading(plyPed, InsideHouse.Entry.w - 180.0)

      Wait(500)
      DoScreenFadeIn(500)
      TriggerEvent('RL:Whitelist',
	    6, ---ban type
	    false --- state of that
	    )
    end
    
    SetEntityAsMissionEntity(InsideHouse.Object,true,true)
    DeleteObject(InsideHouse.Object)
    DeleteEntity(InsideHouse.Object)

    if InsideHouse and InsideHouse.Extras then
      for k,v in pairs(InsideHouse.Extras) do
        SetEntityAsMissionEntity(v,true,true)
        DeleteObject(v)
      end
    end

    InsideHouse = false
    SetWeatherAndTime(true)
    LeavingHouse = false
    return
  end

      inProgressAction = true
      TriggerEvent("mythic_progbar:client:progress", {
        name = "leave_house",
        duration = 3000,
        label = "Dar hale kharej shodan az khane",
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

          inProgressAction = false

          LeavingHouse = true

          if not data or not data.teleport then
            DoScreenFadeOut(500)
            TriggerEvent("Allhousing:Leave", d)
            Wait(1000)
      
            local plyPed = PlayerPedId()
      
            SetEntityCoordsNoOffset(plyPed, InsideHouse.Entry.x,InsideHouse.Entry.y,InsideHouse.Entry.z)
            SetEntityHeading(plyPed, InsideHouse.Entry.w - 180.0)
      
            Wait(500)
            DoScreenFadeIn(500)
          end
          
          SetEntityAsMissionEntity(InsideHouse.Object,true,true)
          DeleteObject(InsideHouse.Object)
          DeleteEntity(InsideHouse.Object)
      
          if InsideHouse and InsideHouse.Extras then
            for k,v in pairs(InsideHouse.Extras) do
              SetEntityAsMissionEntity(v,true,true)
              DeleteObject(v)
            end
          end
      
          InsideHouse = false
          SetWeatherAndTime(true)
          LeavingHouse = false

        else
          inProgressAction = false
        end
      end)
 
end

SpawnHouse = function(d)
  local model = ShellModels[d.Shell]
  local hash  = GetHashKey(model)

  local start = GetGameTimer()
  RequestModel(hash)
  while not HasModelLoaded(hash) and GetGameTimer() - start < 30000 do Wait(0); end
  if not HasModelLoaded(hash) then
    ShowNotification(string.format(Labels["InvalidShell"],model))
    return false,false
  end

  local shell = CreateObject(hash, d.Entry.x + Config.SpawnOffset.x,d.Entry.y + Config.SpawnOffset.y,d.Entry.z - 30.0 + Config.SpawnOffset.z,false,false)
  FreezeEntityPosition(shell,true)

  start = GetGameTimer()
  while not DoesEntityExist(shell) and GetGameTimer() - start < 30000 do Wait(0); end
  if not DoesEntityExist(shell) then
    ShowNotification(string.format(Labels["ShellNotLoaded"],model))
    return false,false
  end

  SetEntityAsMissionEntity(shell,true,true)
  SetModelAsNoLongerNeeded(hash)

  local extras = {}
  if ShellExtras[d.Shell] then
    for objHash,data in pairs(ShellExtras[d.Shell]) do
      RequestModel(objHash)
      start = GetGameTimer()
      while not HasModelLoaded(objHash) and GetGameTimer() - start < 10000 do Wait(0); end
      if HasModelLoaded(objHash) then
        local pos = d.Entry.xyz + data.offset + Config.SpawnOffset
        local rot = data.rotation
        local obj = CreateObject(objHash, pos.x,pos.y,pos.z - 30.0, false,false)
        FreezeEntityPosition(obj,true)
        if rot then SetEntityRotation(obj,rot.x,rot.y,rot.z,2) end
        SetEntityAsMissionEntity(obj,true,true)
        SetModelAsNoLongerNeeded(objHash)
        table.insert(extras,obj)
      end
    end
  end

  local furni = Callback("Allhousing:GetFurniture",d.Id)
  local pos   = vector3(d.Entry.x,d.Entry.y,d.Entry.z)

  for k,v in pairs(furni) do
    local objHash = GetHashKey(v.model)
    RequestModel(objHash)
    start = GetGameTimer()
    while not HasModelLoaded(objHash) and GetGameTimer() - start < 10000 do Wait(0); end
    if HasModelLoaded(objHash) then
      local obj = CreateObject(objHash, pos.x + v.pos.x, pos.y + v.pos.y, pos.z + v.pos.z, false,false,false)
      FreezeEntityPosition(obj, true)
      SetEntityCoordsNoOffset(obj, pos.x + v.pos.x, pos.y + v.pos.y, pos.z + v.pos.z)
      SetEntityRotation(obj, v.rot.x, v.rot.y, v.rot.z, 2)

      SetModelAsNoLongerNeeded(objHash)

      table.insert(extras,obj)
    end
  end

  return shell,extras
end

TeleportInside = function(d,v)  
  local exitOffset = vector4(ShellOffsets[d.Shell]["exit"].x - Config.SpawnOffset.x,ShellOffsets[d.Shell]["exit"].y - Config.SpawnOffset.y,ShellOffsets[d.Shell]["exit"].z - Config.SpawnOffset.z,ShellOffsets[d.Shell]["exit"].w)
  if type(exitOffset) ~= "vector4" or exitOffset.w == nil then
    ShowNotification(string.format(Labels["BrokenOffset"],d.Id))
    return
  end

  local plyPed = PlayerPedId()
  FreezeEntityPosition(plyPed,true)

  DoScreenFadeOut(1000)
  Wait(1500)

  ClearPedTasksImmediately(plyPed)

  local shell,extras = SpawnHouse(d)
  if shell and extras then
    TriggerEvent('RL:Whitelist',
    6, ---ban type
    true --- state of that
    )
    SetEntityCoordsNoOffset(plyPed, d.Entry.x - exitOffset.x,d.Entry.y - exitOffset.y,d.Entry.z - exitOffset.z)
    SetEntityHeading(plyPed, exitOffset.w)

    local start_time = GetGameTimer()
    while (not HasCollisionLoadedAroundEntity(plyPed) and GetGameTimer() - start_time < 5000) do Wait(0); end
    FreezeEntityPosition(plyPed,false)

    DoScreenFadeIn(500)

    InsideHouse = d
    InsideHouse.Extras    = extras
    InsideHouse.Object    = shell
    InsideHouse.Visiting  = v  
    Wait(3000)
    TriggerEvent('RL:Whitelist',
    6, ---ban type
    false --- state of that
    )
  else
    FreezeEntityPosition(plyPed,false)
    DoScreenFadeIn(500)
  end
end

ViewHouse = function(d)
  EnterHouse(d,true)
  
  if Config.UsingNativeUI and _Pool then
    _Pool:CloseAllMenus()
  elseif Config.UsingESX and Config.UsingESXMenu then
    ESX.UI.Menu.CloseAll()
  end
end
EnterHouse = function(d,visiting)

  if Config.UsingNativeUI and _Pool then
    _Pool:CloseAllMenus()
  elseif Config.UsingESX and Config.UsingESXMenu then    
    ESX.UI.Menu.CloseAll()
  end
  
  if d.Unlocked or not d.Owned then

    inProgressAction = true
    TriggerEvent("mythic_progbar:client:progress", {
      name = "enter_house",
      duration = 3000,
      label = "Dar hale vared shodan be khane",
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

        inProgressAction = false
        if d.Unlocked or not d.Owned then
          TriggerEvent("Allhousing:Enter",d)
          TeleportInside(d,visiting)
          SetWeatherAndTime(false)
        else
          ESX.ShowNotification("~h~Dare khane ghofl ast nemitavanid vared shavid!", 'error')
        end

      else
        inProgressAction = false
      end
    end)

  else
    ESX.ShowNotification("~h~Dare khane ghofl ast nemitavanid vared shavid!", 'error')
  end
end



UpgradeHouse = function(d,data)
  if CanPlayerAfford(ShellPrices[data.shell]) then
    TriggerServerEvent("Allhousing:UpgradeHouse",d,data.shell)
    ShowNotification(string.format(Labels["UpgradeHouse"],tostring(data.shell)))
    d.Shell = data.shell
    if InsideHouse then
      local _visiting = InsideHouse.Visiting
      LeaveHouse(d)
      EnterHouse(d,_visiting)
    end
  else
    ShowNotification(Labels["CantAffordUpgrade"])
  end

  if Config.UsingNativeUI and _Pool then
    _Pool:CloseAllMenus()
  elseif Config.UsingESX and Config.UsingESXMenu then
    ESX.UI.Menu.CloseAll()
  end
end

SellHouse = function(d)
  if Config.UsingNativeUI and _Pool then
    _Pool:CloseAllMenus()
  elseif Config.UsingESX and Config.UsingESXMenu then
    ESX.UI.Menu.CloseAll()
  end

  if not d.MortgageOwed or d.MortgageOwed <= 0 then
    exports["input"]:Open(Labels["SetSalePrice"],(Config.UsingESX and Config.UsingESXMenu and "ESX" or "Native"), function(data)
      local price = (tonumber(data) and tonumber(data) > 0 and tonumber(data) or 0)
      local floored = math.max(1,math.floor(tonumber(price)))

      Wait(100)

      if Config.UsingESX and Config.UsingESXMenu then

        if floored < Config.minimumPrice then
          ShowNotification("Hade aghal gheymat forosh khane ~g~" .. Config.minimumPrice .. "~w~ ast.")
          return
        end
        
        ESXConfirmSaleMenu(d,floored)
      elseif Config.UsingNativeUI then
        NativeConfirmSaleMenu(d,floored)
      end
    end)
  else
    ShowNotification(Labels["InvalidSale"])
  end
end

RepayMortgage = function(d)
  if Config.UsingNativeUI and _Pool then
    _Pool:CloseAllMenus()
  elseif Config.UsingESX and Config.UsingESXMenu then
    ESX.UI.Menu.CloseAll()
  end

  local min_repayment = math.floor((d.MortgageOwed / 100) * Config.MortgageMinRepayment)
  if GetPlayerCash() > min_repayment or GetPlayerBank() > min_repayment then
    exports["input"]:Open(string.format("Min: $%i",min_repayment),(Config.UsingESX and Config.UsingESXMenu and "ESX" or "Native"),function(res)
      local repay = tonumber(res)
      if repay == nil or not repay then
        ShowNotification(Labels["InvalidAmount"])
      else
        repay = math.floor(repay)
        if repay < min_repayment then
          ShowNotification(Labels["InvalidAmount"])
        else
          if GetPlayerCash() > repay or GetPlayerBank() > repay then
            TriggerServerEvent("Allhousing:RepayMortgage",d.Id,repay)
          else
            ShowNotification(Labels["InvalidMoney"])
          end
        end
      end
    end)
  else
  end
end

RevokeTenancy = function(d)
  if Config.UsingNativeUI and _Pool then
    _Pool:CloseAllMenus()
  elseif Config.UsingESX and Config.UsingESXMenu then
    ESX.UI.Menu.CloseAll()
  end

  ESX.UI.Menu.CloseAll()
  ShowNotification(Labels["EvictingTenants"])
  TriggerServerEvent("Allhousing:RevokeTenancy",d)
end

MenuThread = function()
  while true do      
    if _Pool and _Pool:IsAnyMenuOpen() then
      _Pool:ControlDisablingEnabled(false)
      _Pool:MouseControlsEnabled(false)
      _Pool:ProcessMenus()
    end
    Wait(0)
  end
end

Citizen.CreateThread(MenuThread)

AddEventHandler('esx:onPlayerNLR', function()
    if InsideHouse then
      LeaveHouse(InsideHouse, {teleport = true, force = true})
    end
end)

RegisterNetEvent("allhousing:ResetPropertyDimension")
AddEventHandler("allhousing:ResetPropertyDimension", function()
  if InsideHouse then
    LeaveHouse(InsideHouse, {force = true})
  end
end)

RegisterNetEvent("allhousing:reviveFromMedic")
AddEventHandler("allhousing:reviveFromMedic", function()
  if InsideHouse then
    LeaveHouse(InsideHouse, {teleport = true, force = true})
  end
end)
