local lastOpen = 0

ESXMenuHandler = function(d,t,st)
  if inProgressAction then
    return
  end

  if GetGameTimer() - lastOpen <= 3000 then
    ESX.ShowNotification("~h~Lotfan spam nakonid beyn har action hade aghal ~g~3 ~w~sanie sabr konid!", 'error')
    return
  end

  lastOpen = GetGameTimer()

  if t == "Entry" then

  if st == "Owner" then
      MenuOpen = vector3(d.Entry.x, d.Entry.y, d.Entry.z)
      FreezeEntityPosition(PlayerPedId(),false)
      ESXEntryOwnerMenu(d)
  elseif st == "Owned" then
      MenuOpen = vector3(d.Entry.x, d.Entry.y, d.Entry.z)
      FreezeEntityPosition(PlayerPedId(),false)
      ESXEntryOwnedMenu(d)
  elseif st == "Empty" then
    MenuOpen = vector3(d.Entry.x, d.Entry.y, d.Entry.z)
    FreezeEntityPosition(PlayerPedId(),false)
    ESXEntryEmptyMenu(d)
  end

  elseif t == "Garage" then
    if st == "Owner" then
      MenuOpen = vector3(d.Garage.x, d.Garage.y, d.Garage.z)
      FreezeEntityPosition(PlayerPedId(),false)
      ESXGarageOwnerMenu(d)
    elseif st == "Owned" then
      local thisHouse = Houses[d.Id]
      if thisHouse and thisHouse.HouseKeys[GetPlayerIdentifier()] then
        MenuOpen = vector3(d.Garage.x, d.Garage.y, d.Garage.z)
        FreezeEntityPosition(PlayerPedId(),false)
        ESXGarageOwnedMenu(d)
      end
    end
  elseif t == "Exit" then
    if st == "Owner" then
      ESXExitOwnerMenu(d)
    elseif st == "Owned" then
      ESXExitOwnedMenu(d)
    elseif st == "Empty" then
      ESXExitEmptyMenu(d)
    end
  elseif t == "Wardrobe" then
    if st == "Owner" or st == "Owned" then
      ESXWardrobeMenu(d)
    end
  elseif t == "InventoryLocation" then
    OpenInventory(d)
  end
end

ESXWardrobeMenu = function(d)
  TriggerEvent("PX_clothing:client:openOutfitMenu")
end

ESXOpenInviteMenu = function(d)
  local elements = {}
  local players = GetNearbyPlayers(d.Entry,10.0)
  local c = 0
  for _,player in pairs(players) do
    if player ~= PlayerId() then
      table.insert(elements,{label = GetPlayerName(player).." [ID:"..GetPlayerServerId(player).."]",value = GetPlayerServerId(player),name = GetPlayerName(player)})
    end
  end
  ESX.UI.Menu.Open('default', GetCurrentResourceName(), "exit_invite_menu",{
      title    = Labels['InviteInside'],
      align    = 'left',
      elements = elements,
    }, 
    function(submitData,submitMenu)
      submitMenu.close()
      InviteInside(d,submitData.current.value)
      ShowNotification("You invited "..submitData.current.name.." inside.")
    end
  )
end

ESXOpenKeysMenu = function(d)
  local elements = {
    [1] = {label = Labels['GiveKeys'],value = "Give"},
    [2] = {label = Labels['TakeKeys'],value = "Take"}
  }
  ESX.UI.Menu.Open('default', GetCurrentResourceName(), "exit_keys_menu",{
      title    = Labels['HouseKeys'],
      align    = 'left',
      elements = elements,
    }, 
    function(submitData,submitMenu)
      if submitData.current.value == "Give" then
        ESXGiveKeysMenu(d)
      elseif submitData.current.value == "Take" then
        ESXTakeKeysMenu(d)
      end
    end,
    function(data,menu)
      menu.close()
    end
  )
end

ESXGiveKeysMenu = function(d)
  local elements = {}
  local players = GetNearbyPlayers(GetEntityCoords(PlayerPedId()),10.0)
  local c = 0
  for _,player in pairs(players) do
    if player ~= PlayerId() then
      table.insert(elements,{label = GetPlayerName(player).." [ID:"..player.."]",value = GetPlayerServerId(player)})
    end
  end
  ESX.UI.Menu.Open('default', GetCurrentResourceName(), "exit_givekeys_menu",{
      title    = Labels['GiveKeys'],
      align    = 'left',
      elements = elements,
    }, 
    function(submitData,submitMenu)
      GiveKeys(d,submitData.current.value)
    end,
    function(data,menu)
      menu.close()
    end
  )
end

ESXTakeKeysMenu = function(d)
  local elements = {}
  local players = GetNearbyPlayers(d.Entry,10.0)
  local c = 0
  for _,player in pairs(d.HouseKeys) do
    table.insert(elements,{label = player.name,value = player})
  end
  ESX.UI.Menu.Open('default', GetCurrentResourceName(), "exit_takekeys_menu",{
      title    = Labels['TakeKeys'],
      align    = 'left',
      elements = elements,
    }, 
    function(submitData,submitMenu)
      TakeKeys(d,submitData.current.value)
    end,
    function(data,menu)
      menu.close()
    end
  )
end

ESXExitOwnerMenu = function(d)
  local elements = {}
  if Config.UseHouseInventory then
    if Config.AllowHouseSales then
      if d.Shell then
        elements = {
          --{label = Labels["InviteInside"],value = "Invite"},
          {label = Labels["HouseKeys"],value = "Keys"},
          --{label = Labels["UpgradeShell"],value = "Upgrade"},
          {label = Labels["SellHouse"],value = "Sell"},
          {label = Labels["FurniUI"],value = "Furni"},
          {label = Labels["SetWardrobe"],value = "Wardrobe"},
          {label = Labels["SetInventory"],value = "Inventory"},
          {label = (d.Unlocked and Labels["LockDoor"] or Labels["UnlockDoor"]),value = (d.Unlocked and "Lock" or "Unlock")},
          {label = Labels["LeaveHouse"],value = "Leave"},
        }
      else
        elements = {
          {label = Labels["HouseKeys"],value = "Keys"},
          {label = Labels["SellHouse"],value = "Sell"},
          {label = Labels["FurniUI"],value = "Furni"},
          {label = Labels["SetWardrobe"],value = "Wardrobe"},
          {label = Labels["SetInventory"],value = "Inventory"},
        }
      end
      if (d.MortgageOwed and d.MortgageOwed >= 1) then
        table.insert(elements,#elements,{label = "Mortgage", value = "Mortgage"})
      end
    else
      if d.Shell then
        elements = {
          --{label = Labels["InviteInside"],value = "Invite"},
          {label = Labels["HouseKeys"],value = "Keys"},
          --{label = Labels["UpgradeShell"],value = "Upgrade"},
          {label = Labels["FurniUI"],value = "Furni"},
          {label = Labels["SetWardrobe"],value = "Wardrobe"},
          {label = Labels["SetInventory"],value = "Inventory"},
          {label = (d.Unlocked and Labels["LockDoor"] or Labels["UnlockDoor"]),value = (d.Unlocked and "Lock" or "Unlock")},
          {label = Labels["LeaveHouse"],value = "Leave"},
        }
      else
        elements = {
          {label = Labels["HouseKeys"],value = "Keys"},
          {label = Labels["FurniUI"],value = "Furni"},
          {label = Labels["SetWardrobe"],value = "Wardrobe"},
          {label = Labels["SetInventory"],value = "Inventory"},
        }
      end
      if (d.MortgageOwed and d.MortgageOwed >= 1) then
        table.insert(elements,#elements,{label = "Mortgage", value = "Mortgage"})
      end
    end
  else
    if Config.AllowHouseSales then    
      if d.Shell then
        elements = {
          --{label = Labels["InviteInside"],value = "Invite"},
          {label = Labels["HouseKeys"],value = "Keys"},
          --{label = Labels["UpgradeShell"],value = "Upgrade"},
          {label = Labels["SellHouse"],value = "Sell"},
          {label = Labels["FurniUI"],value = "Furni"},
          {label = Labels["Wardrobe"],value = "Wardrobe"},
          {label = (d.Unlocked and Labels["LockDoor"] or Labels["UnlockDoor"]),value = (d.Unlocked and "Lock" or "Unlock")},
          {label = Labels["LeaveHouse"],value = "Leave"},
        }
      else
        elements = {
          {label = Labels["HouseKeys"],value = "Keys"},
          {label = Labels["SellHouse"],value = "Sell"},
          {label = Labels["FurniUI"],value = "Furni"},
          {label = Labels["SetWardrobe"],value = "Wardrobe"},
        }
      end
      if (d.MortgageOwed and d.MortgageOwed >= 1) then
        table.insert(elements,#elements,{label = "Mortgage", value = "Mortgage"})
      end
    else
      if d.Shell then
        elements = {
          --{label = Labels["InviteInside"],value = "Invite"},
          {label = Labels["HouseKeys"],value = "Keys"},
          --{label = Labels["UpgradeShell"],value = "Upgrade"},
          {label = Labels["FurniUI"],value = "Furni"},
          {label = Labels["Wardrobe"],value = "Wardrobe"},
          {label = (d.Unlocked and Labels["LockDoor"] or Labels["UnlockDoor"]),value = (d.Unlocked and "Lock" or "Unlock")},
          {label = Labels["LeaveHouse"],value = "Leave"},
        }
      else
        elements = {
          {label = Labels["HouseKeys"],value = "Keys"},
          {label = Labels["SellHouse"],value = "Sell"},
          {label = Labels["FurniUI"],value = "Furni"},
          {label = Labels["SetWardrobe"],value = "Wardrobe"},
        }
      end
      --if (d.MortgageOwed and d.MortgageOwed >= 1) then
        --table.insert(elements,#elements,{label = Labels["Mortgage"], value = "Mortgage"})
      --end
    end
  end
  ESX.UI.Menu.Open('default', GetCurrentResourceName(), "exit_owner_menu",{
      title    = Labels['MyHouse'],
      align    = 'left',
      elements = elements,
    }, 
    function(submitData,submitMenu)
      if      (submitData.current.value == "Invite")    then
        ESXOpenInviteMenu(d)
      elseif  (submitData.current.value == "Keys")      then
        ESXOpenKeysMenu(d)
      elseif  (submitData.current.value == "Upgrade")   then        
        ESXUpgradeMenu(d,true)
      elseif  (submitData.current.value == "Sell")      then
        SellHouse(d)
      elseif  (submitData.current.value == "Furni")     then
        OpenFurniture(d)
      elseif  (submitData.current.value == "Wardrobe")  then
        SetWardrobe(d)
      elseif  (submitData.current.value == "Inventory") then
        SetInventory(d)
      elseif  (submitData.current.value == "Leave")     then
        LeaveHouse(d)
      elseif  (submitData.current.value == "Unlock")    then
        UnlockHouse(d)
      elseif  (submitData.current.value == "Lock")      then
        LockHouse(d)
      elseif  (submitData.current.value == "Mortgage")  then
        ESXPayMortgageMenu(d)
      end
    end,
    function(data,menu)
      menu.close()
    end
  )
end

ESXExitOwnedMenu = function(d)
  local elements = {}
  local identifier = GetPlayerIdentifier()
  local mort = false
  for k,v in pairs(d.HouseKeys) do
    if v.identifier == identifier then
      --if d.Shell then
        --table.insert(elements,{label = Labels['InviteInside'],value = "Invite"})
     --end
      table.insert(elements,{label = Labels['FurniUI'],value = "Furni"})
  --  table.insert(elements,{label = Labels['Mortgage'],value = "Mortgage"})
      table.insert(elements, {label = (d.Unlocked and Labels["LockDoor"] or Labels["UnlockDoor"]),value = (d.Unlocked and "Lock" or "Unlock")})
      mort = true
      break
    end
  end
  if d.Shell then
    table.insert(elements,{label = Labels['LeaveHouse'],value = "Leave"})
  --elseif d.MortgageOwed and d.MortgageOwed > 0 then
  --  local job = GetPlayerJobName()
  --  if Config.CreationJobs[job] then
  --    if GetPlayerJobRank() >= Config.CreationJobs[job].minRank then
   --     table.insert(elements,{label = Labels['Mortgage'],value = "CheckMortgage"})
   --   end
   -- end
  end

  ESX.UI.Menu.Open('default', GetCurrentResourceName(), "exit_owned_menu",{
      title    = Labels['PlayerHouse'],
      align    = 'left',
      elements = elements,
    }, 
    function(submitData,submitMenu)
      if      (submitData.current.value == "Invite")        then
        ESXOpenInviteMenu(d)
      elseif  (submitData.current.value == "Furni")         then
        OpenFurniture(d)
      elseif  (submitData.current.value == "Lock")          then
        LockHouse(d)
      elseif  (submitData.current.value == "Unlock")        then
        UnlockHouse(d)
      elseif  (submitData.current.value == "Leave")         then
        LeaveHouse(d)
      elseif  (submitData.current.value == "Mortgage")      then
        ESXPayMortgageMenu(d)
      elseif  (submitData.current.value == "CheckMortgage") then
        ESXMortgageInfoMenu(d)
      end
    end,
    function(data,menu)
      menu.close()
    end
  )
end

ESXExitEmptyMenu = function(d)
  local elements = (d.Shell and {[1] = {label = Labels['LeaveHouse'],value = "Leave"}} or {})

  if d.Owned and d.Shell then
    local certifiedPolice = false
    local job = GetPlayerJobName()
    if Config.PoliceJobs[job] then
      if GetPlayerJobRank() >= Config.PoliceJobs[job].minRank then
        certifiedPolice = true
      end
    end

    if Config.PoliceCanRaid and certifiedPolice then
      if d.Unlocked then
        table.insert(elements,{label = Labels['LockHouse'],value = "Lock"})
      else
        table.insert(elements,{label = Labels['UnlockHouse'],value = "Unlock"})
      end
    end
  end

  ESX.UI.Menu.Open('default', GetCurrentResourceName(), "exit_empty_menu",{
      title    = Labels['EmptyHouse'],
      align    = 'left',
      elements = elements,
    }, 
    function(submitData,submitMenu)
      if submitData.current.value == "Leave" then
        LeaveHouse(d)
      elseif submitData.current.value == "Lock" then
        LockHouse(d)
      elseif submitData.current.value == "Unlock" then
        UnlockHouse(d)
      end
    end,
    function(data,menu)
      menu.close()
    end
  )
end

ESXUpgradeMenu = function(d,owner)
  local elements = {}
  local c = 0
  local dataTable = {}
  local sortedTable = {}
  for k,v in pairs(d.Shells) do
    local price = ShellPrices[k]
    if price then
      dataTable[price.."_"..k] = {
        available = v,
        price = price,
        shell = k,
      }
      table.insert(sortedTable,price.."_"..k)
    end
  end
  table.sort(sortedTable)

  for key,price in pairs(sortedTable) do
    local data = dataTable[price]
    if data.available and d.Shell ~= data.shell then
      elements[#elements+1] = {label = data.shell.." [$"..data.price.."]", data = data}
      c = c + 1
    end    
  end

  if c == 0 then
    ShowNotification(Labels['NoUpgrades'])
    return
  end

  ESX.UI.Menu.Open('default', GetCurrentResourceName(), "owner_upgrade_menu",{
      title    = Labels['UpgradeHouse2'],
      align    = 'left',
      elements = elements,
    },function(data,menu) 
      if owner then
        UpgradeHouse(d,data.current.data)
      end
    end,
    function(data,menu)
      menu.close()
    end
  )
end

DoOpenESXGarage = function(d)
  local vehicles = GetVehiclesAtHouse(d)

  local elements = {}
  if (#vehicles > 0) then
    for _,vehData in pairs(vehicles) do
      table.insert(elements,{label = "["..vehData.vehicle.plate.."] "..GetVehicleLabel(vehData.vehicle.model), value = vehData})
    end
  else
    table.insert(elements,{label = Labels['NoVehicles']})
  end
  ESX.UI.Menu.Open('default', GetCurrentResourceName(), "entry_owner_menu",{
      title    = "Player Garage",
      align    = 'left',
      elements = elements,
    }, 
    (#vehicles > 0 and function(submitData,submitMenu)
      TriggerServerEvent('Allhousing:VehicleSpawned',submitData.current.value.vehicle.plate)
      SpawnVehicle(d.Garage,submitData.current.value.vehicle.model,submitData.current.value.vehicle)
    end or false),
    function(data,menu)
      menu.close()
    end,
    function(...)
    end,
    function(...)
      MenuOpen = false
      FreezeEntityPosition(PlayerPedId(),false)
    end
  )
end

ESXGarageOwnerMenu = function(d)
  local ped = PlayerPedId()
  if IsPedInAnyVehicle(ped,false) then
    local veh = GetVehiclePedIsUsing(ped)
    local props = GetVehicleProperties(veh)
    local ownerInfo = Callback("Allhousing:GetVehicleOwner",props.plate)
    local canStore = false
    local fuel = math.floor(GetVehicleFuelLevel(veh))
    local netid = VehToNet(veh)
    local engineHealth = GetVehicleEngineHealth(veh)
    if ownerInfo.owned and ownerInfo.owner then
      canStore = true
    elseif ownerInfo.owned and Config.StoreStolenPlayerVehicles then
      canStore = true
    else
      canStore = false
    end
    local data = {house = d.Id, plate = props.plate, fuel = fuel, netid = netid}

    if canStore then
      TaskEveryoneLeaveVehicle(veh)
      SetEntityAsMissionEntity(veh,true,true)
      TriggerServerEvent("garage:removeKeys", GetVehicleNumberPlateText(veh))
      DeleteVehicle(veh)  
      TriggerServerEvent("Allhousing:VehicleStored",d.Id,props.plate,props)
      ShowNotification(Labels["VehicleStored"])
    else
      ShowNotification(Labels["CantStoreVehicle"])
    end
    FreezeEntityPosition(PlayerPedId(),false)
  else
    local vehicles = GetVehiclesAtHouse(d)

    local elements = {}
    if (#vehicles > 0) then
      for _,vehData in pairs(vehicles) do
        table.insert(elements,{label = "["..vehData.vehicle.plate.."] "..GetVehicleLabel(vehData.vehicle.model), value = vehData})
      end
    else
      table.insert(elements,{label = Labels['NoVehicles']})
    end
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), "entry_owner_menu",{
        title    = Labels['Garage'],
        align    = 'left',
        elements = elements,
      }, 
      (#vehicles > 0 and function(submitData,submitMenu)
        TriggerServerEvent('Allhousing:VehicleSpawned',submitData.current.value.vehicle.plate)
        SpawnVehicle(d.Garage,submitData.current.value.vehicle.model,submitData.current.value.vehicle)
      end or false),
      function(data,menu)
        menu.close()
      end,
      function(...)
      end,
      function(...)
        MenuOpen = false
        FreezeEntityPosition(PlayerPedId(),false)
      end
    )
  end
end

ESXGarageOwnedMenu = function(d)
  local plyPed = PlayerPedId()  
  if IsPedInAnyVehicle(plyPed,false) then
    local veh = GetVehiclePedIsUsing(plyPed)
    local props = GetVehicleProperties(veh)
    local ownerInfo = Callback("Allhousing:GetVehicleOwner",props.plate)
    local canStore = false
    if ownerInfo.owned and ownerInfo.owner then
      canStore = true
    elseif ownerInfo.owned and Config.StoreStolenPlayerVehicles then
      canStore = true
    else
      canStore = false
    end

    if canStore then
      local fuel = math.floor(GetVehicleFuelLevel(veh))
      local netid = VehToNet(veh)
      local engineHealth = GetVehicleEngineHealth(veh)
      local data = {house = d.Id, plate = props.plate, fuel = fuel, netid = netid}
      TaskEveryoneLeaveVehicle(veh)
      SetEntityAsMissionEntity(veh,true,true)
      TriggerServerEvent("garage:removeKeys", GetVehicleNumberPlateText(veh))
      DeleteVehicle(veh)  
      TriggerServerEvent("Allhousing:VehicleStored",d.Id,props.plate,props)
      ShowNotification(Labels["VehicleStored"])
    else
      ShowNotification(Labels["CantStoreVehicle"])
    end
    FreezeEntityPosition(PlayerPedId(),false)
  else
    local myId = GetPlayerIdentifier()
    for k,v in pairs(d.HouseKeys) do
      if v.identifier == myId then
        DoOpenESXGarage(d)
        return
      end
    end

    if not Config.GarageTheft then 
      FreezeEntityPosition(PlayerPedId(),false)
      return
    end

    if Config.LockpickRequired then
      local hasItem = CheckForLockpick()
      if not hasItem then
        ShowNotification(Labels['NoLockpick'])
        FreezeEntityPosition(PlayerPedId(),false)
        return
      end
    end

    while not HasAnimDictLoaded("mini@safe_cracking") do RequestAnimDict("mini@safe_cracking"); Citizen.Wait(0); end
    TaskPlayAnim(plyPed, "mini@safe_cracking", "idle_base", 1.0, 1.0, -1, 1, 0, 0, 0, 0 ) 
    Wait(2000)

    

    if Config.UsingLockpickV1 then
      TriggerEvent("lockpicking:StartMinigame",4,function(didWin)
        if didWin then
          ClearPedTasksImmediately(plyPed)
          DoOpenESXGarage(d)
        else
          ClearPedTasksImmediately(plyPed)
          TriggerServerEvent("Allhousing:BreakLockpick")
        end
        FreezeEntityPosition(PlayerPedId(),false)
      end)
    elseif Config.UsingLockpickV2 then
      exports["lockpick"]:Lockpick(function(didWin)
        if didWin then
          ClearPedTasksImmediately(plyPed)
          DoOpenESXGarage(d)
          ShowNotification(Labels["LockpickSuccess"])
        else
          ClearPedTasksImmediately(plyPed)
          TriggerServerEvent("Allhousing:BreakLockpick")
          ShowNotification(Labels["LockpickFailed"])
        end
        FreezeEntityPosition(PlayerPedId(),false)
      end)
    else
      if Config.UsingProgressBars then
        exports["progressBars"]:startUI(Config.LockpickTime * 1000,Labels["ProgressLockpicking"])
      end
      Wait(Config.LockpickTime * 1000)
      if math.random(100) < Config.LockpickFailChance then
        local plyPos = GetEntityCoords(PlayerPedId())
        local zoneName = GetNameOfZone(plyPos.x,plyPos.y,plyPos.z)
        if Config.LockpickBreakOnFail then
          TriggerServerEvent("Allhousing:BreakLockpick")
        end
        ShowNotification(Labels["LockpickFailed"])
        for k,v in pairs(Config.PoliceJobs) do
          TriggerServerEvent("Allhousing:NotifyJobs",k,"Someone is attempting to break into a garage at "..zoneName)
        end
        ClearPedTasksImmediately(plyPed)
      else
        ShowNotification(Labels["LockpickSuccess"])
        ClearPedTasksImmediately(plyPed)
        DoOpenESXGarage(d)
      end
      FreezeEntityPosition(PlayerPedId(),false)
    end
  end
end

ESXEntryOwnerMenu = function(d)
  local elements
  if Config.AllowHouseSales then
    if d.Garage and Config.AllowGarageMovement then
      if d.Shell then
        elements = {
          [1] = {label = Labels['EnterHouse']},
          --[2] = {label = Labels['UpgradeHouse2']},
          [2] = {label = (d.Unlocked and Labels['LockDoor'] or Labels['UnlockDoor'])},
          [3] = {label = Labels['MoveGarage']},
          [4] = {label = Labels['SellHouse']},
        }
      else
        elements = {
          [1] = {label = Labels['MoveGarage']},
          [2] = {label = Labels['SellHouse']},
        }
      end
    else
      if d.Shell then
        elements = {
          [1] = {label = Labels['EnterHouse']},
          --[2] = {label = Labels['UpgradeHouse2']},
          [2] = {label = (d.Unlocked and Labels['LockDoor'] or Labels['UnlockDoor'])},
          [3] = {label = Labels['SellHouse']},
        }
      else
        elements = {
          [1] = {label = Labels["SellHouse"]},
        }
      end
    end
  else
    if d.Garage and Config.AllowGarageMovement then
      if d.Shell then
        elements = {
          [1] = {label = Labels['EnterHouse']},
          --[2] = {label = Labels['UpgradeHouse2']},
          [2] = {label = (d.Unlocked and Labels['LockDoor'] or Labels['UnlockDoor'])},
          [3] = {label = Labels['MoveGarage']},
        }
      else
      end
    else
      if d.Shell then
        elements = {
          [1] = {label = Labels['EnterHouse']},
          --[2] = {label = Labels['UpgradeHouse2']},
          [2] = {label = (d.Unlocked and Labels['LockDoor'] or Labels['UnlockDoor'])},
        }
      else
        elements = {
          [1] = {label = Labels["NothingToDisplay"]}
        }
      end
    end
  end

  ESX.UI.Menu.Open('default', GetCurrentResourceName(), "entry_owner_menu",{
      title    = Labels['MyHouse'],
      align    = 'left',
      elements = elements,
    }, 
    function(submitData,submitMenu)
      print(submitData.current.label)
      if (submitData.current.label == Labels["NothingToDisplay"]) then
        menu.close()
      elseif (submitData.current.label == Labels["EnterHouse"]) then
        EnterHouse(d)
      elseif (submitData.current.label == Labels["UpgradeHouse2"]) then
        ESXUpgradeMenu(d,true)
      elseif (submitData.current.label == Labels["SellHouse"]) then  
        SellHouse(d)   
      elseif (submitData.current.label == Labels["LockDoor"]) then
        LockHouse(d)
      elseif (submitData.current.label == Labels["UnlockDoor"]) then
        UnlockHouse(d)
      elseif (submitData.current.label == Labels["MoveGarage"]) then
        MoveGarage(d)
      end
    end,
    function(data,menu)
      menu.close()
    end,
    function(...)
    end,
    function(...)
      MenuOpen = false
      FreezeEntityPosition(PlayerPedId(),false)
    end
  )
end

ESXConfirmSaleMenu = function(d,floored)
  local elements = {
    [1] = {label = Labels['ConfirmSale'], value = "yes"},
    [2] = {label = Labels['CancelSale'], value = "no"}
  }
  ESX.UI.Menu.Open('default', GetCurrentResourceName(), "esx_verify_sell",{
      title    = string.format(Labels["SellingHouse"],floored),
      align    = 'left',
      elements = elements,
    }, 
    function(data,menu)
      if (data.current.value == "yes") then
        ShowNotification(string.format(Labels["SellingHouse"],floored))
        d.Owner = ""
        d.Owned = false

        if InsideHouse then LeaveHouse(d); end
        TriggerServerEvent("Allhousing:SellHouse",d,floored)
      end
      ESX.UI.Menu.CloseAll()
    end
  )
end

ESXEntryOwnedMenu = function(d)
  local hasKeys = false
  local identifier = GetPlayerIdentifier()
  for k,v in pairs(d.HouseKeys) do
    if v.identifier == identifier then
      hasKeys = true
      break
    end
  end

  local certifiedPolice = false
  local job = GetPlayerJobName()
  if Config.PoliceJobs[job] then
    if GetPlayerJobRank() >= Config.PoliceJobs[job].minRank then
      certifiedPolice = true
    end
  end

  local certifiedRealestate = false
  if Config.CreationJobs[job] then
    if GetPlayerJobRank() >= Config.CreationJobs[job].minRank then
      certifiedRealestate = true
    end
  end

  local elements = {}

  if d.Shell then
    if hasKeys or d.Unlocked then
      table.insert(elements,{label = Labels['EnterHouse'],value = "Enter"})
    elseif certifiedPolice then
      table.insert(elements,{label = Labels['KnockHouse'],value = "Knock"})
      if Config.PoliceCanRaid then
        table.insert(elements,{label = Labels['RaidHouse'],value = "Raid"})
      end
    else
      table.insert(elements,{label = Labels['KnockHouse'],value = "Knock"})
      if Config.HouseTheft then
        table.insert(elements,{label = Labels['BreakIn'],value = "Break In"})
      end
    end
  end

  --if certifiedRealestate and d.MortgageOwed and d.MortgageOwed > 0 then
    --table.insert(elements,{label = Labels['Mortgage'],value = "Mortgage"})
  --end

  if #elements <= 0 then
    FreezeEntityPosition(PlayerPedId(),false)
    return
  end

  ESX.UI.Menu.Open('default', GetCurrentResourceName(), "entry_owner_menu",{
      title    = Labels['PlayerHouse'],
      align    = 'left',
      elements = elements,
    }, 
    function(submitData,submitMenu)
      if (submitData.current.value == "Enter") then
        EnterHouse(d,(not hasKeys and true or false))
      elseif (submitData.current.value == "Knock") then
        KnockOnDoor(d)
      elseif (submitData.current.value == "Raid") then  
        RaidHouse(d)      
      elseif (submitData.current.value == "Break In") then
        BreakInHouse(d)
      elseif (submitData.current.value == "Mortgage") then        
        ESXMortgageInfoMenu(d)
      end
    end,
    function(data,menu)
      menu.close()
    end,
    function(...)
    end,
    function(...)
      MenuOpen = false
      FreezeEntityPosition(PlayerPedId(),false)
    end
  )
end

ESXMortgageInfoMenu = function(d)
  local mortgage_info = Callback("Allhousing:GetMortgageInfo",d)
  local elements = {
    {label = string.format(Labels["MoneyOwed"],tostring(mortgage_info.MortgageOwed))},
    {label = string.format(Labels['LastRepayment'],tostring(mortgage_info.LastRepayment))},
    {label = "Revoke Tenancy", value = "Revoke"}
  }

  ESX.UI.Menu.Open('default', GetCurrentResourceName(), "mortgage_menu",{
      title    = Labels['MortgageInfo'],
      align    = 'left',
      elements = elements,
    }, 
    function(data,menu)
      if (data.current.value and data.current.value == "Revoke") then
        RevokeTenancy(d)
      end
    end,
    function(data,menu)
      menu.close()
    end,
    function(...)
    end,
    function(...)
    end
  )
end

ESXPayMortgageMenu = function(d)
  local mortgage_info = Callback("Allhousing:GetMortgageInfo",d)
  local elements = {
    {label = string.format(Labels["MoneyOwed"],tostring(mortgage_info.MortgageOwed))},
    {label = string.format(Labels['LastRepayment'],tostring(mortgage_info.LastRepayment))},
    {label = Labels['PayMortgage'], value = "Pay"}
  }

  ESX.UI.Menu.Open('default', GetCurrentResourceName(), "mortgage_menu",{
      title    = Labels['MortgageInfo'],
      align    = 'left',
      elements = elements,
    }, 
    function(data,menu)
      if data.current.value and data.current.value == "Pay" then
        menu.close()
        RepayMortgage(d)
      end
    end,
    function(data,menu)
      menu.close()
    end,
    function(...)
    end,
    function(...)
    end
  )
end

ESXEntryEmptyMenu = function(d)
  local elements = {}
  if d.ResaleJob and d.ResaleJob:len() > 0 and Config.AllowMortgage then
    if d.Shell then
      elements = {
        [1] = {label = Labels['Buy'].." [$"..d.Price.."]", value = "Buy"},
        [2] = {label = Labels['Mortgage'].." [$"..math.floor((d.Price / 100)*Config.MortgagePercent).."]", value='Mortgage'},
        [3] = {label = Labels['View'], value = "View"},
        --[4] = {label = Labels['Upgrades'], value = "Upgrades"},
      }
    else
      elements = {
        [1] = {label = Labels['Buy'].." [$"..d.Price.."]", value = "Buy"},
        [2] = {label = Labels['Mortgage'].." [$"..math.floor((d.Price / 100)*Config.MortgagePercent).."]", value='Mortgage'}
      }
    end
  else
    if d.Shell then
      elements = {
        [1] = {label = Labels['Buy'].." [$"..d.Price.."]", value = "Buy"},
        [2] = {label = Labels['View'], value = "View"},
        --[3] = {label = Labels['Upgrades'], value = "Upgrades"},
      }
    else
      elements = {
        [1] = {label = Labels['Buy'].." [$"..d.Price.."]", value = "Buy"}
      }
    end
  end

  ESX.UI.Menu.Open('default', GetCurrentResourceName(), "entry_empty_menu",{
      title    = Labels['EmptyHouse'],
      align    = 'left',
      elements = elements,
    }, 
    function(submitData,submitMenu)
      submitMenu.close()
      if (submitData.current.value == "Buy") then
        BuyHouse(d)
      elseif (submitData.current.value == "View") then
        ViewHouse(d)
      elseif (submitData.current.value == "Upgrades") then  
        ESXUpgradeMenu(d,false)      
      elseif (submitData.current.value == "Mortgage") then
        MortgageHouse(d)
      end
    end,
    function(data,menu)
      menu.close()
    end,
    function()
    end,
    function()
      print("Unfreeze?")
      MenuOpen = false
      FreezeEntityPosition(PlayerPedId(),false)
    end
  )
end

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(750)
    if MenuOpen then
      local selfCoord = GetEntityCoords(PlayerPedId())
      if Vdist(selfCoord, MenuOpen) >= 1 then
        MenuOpen = false
        ESX.UI.Menu.CloseAll()
      end
    end
  end
end)