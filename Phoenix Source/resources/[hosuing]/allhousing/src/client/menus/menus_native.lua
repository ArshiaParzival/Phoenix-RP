

NativeUIHandler = function(d,t,st)
  if t == "Entry" then
    if st == "Owner" then
      NativeEntryOwnerMenu(d)
    elseif st == "Owned" then
      NativeEntryOwnedMenu(d)
    elseif st == "Empty" then
      NativeEntryEmptyMenu(d)
    end
  elseif t == "Garage" then
    if st == "Owner" then
      NativeGarageOwnerMenu(d)
    elseif st == "Owned" then
      NativeGarageOwnedMenu(d)
    end
  elseif t == "Exit" then
    if st == "Owner" then
      NativeExitOwnerMenu(d)
    elseif st == "Owned" then
      NativeExitOwnedMenu(d)
    elseif st == "Empty" then
      NativeExitEmptyMenu(d)
    end
  elseif t == "InventoryLocation" then
    OpenInventory(d)
  end
end

CreateNativeUIMenu = function(title,subtitle)
  if _Pool then _Pool:Remove(); end
  _Pool = NativeUI.CreatePool()

  local ResX,ResY = GetActiveScreenResolution()
  local xPos = ResX - (ResX > 2560 and 1050 or 550)
  local menu = NativeUI.CreateMenu(title,subtitle,xPos,250)

  _Pool:Add(menu)

  return menu
end

NativeConfirmSaleMenu = function(d,floored)
  _Pool:CloseAllMenus()

  local sellMenu = CreateNativeUIMenu("Confirm Sale","Sell house for $"..tostring(floored))

  local confirm = NativeUI.CreateItem("Yes, sell my house.","CONFIRM")
  confirm.Activated = function(...) 
    ShowNotification("Selling house for $"..tostring(floored))
    d.Owner = ""
    d.Owned = false

    if InsideHouse then LeaveHouse(d); end
    TriggerServerEvent("Allhousing:SellHouse",d,floored)

    _Pool:CloseAllMenus()
  end
  sellMenu:AddItem(confirm)

  local cancel = NativeUI.CreateItem("No, don't sell my house.","CANCEL")
  cancel.Activated = function(...) 
    _Pool:CloseAllMenus()
  end
  sellMenu:AddItem(cancel)

  sellMenu:RefreshIndex()
  sellMenu:Visible(true)
end

NativeOpenInvite = function(d)  
  _Pool:CloseAllMenus()

  local inviteMenu = CreateNativeUIMenu("Invite Inside","")

  local players = GetNearbyPlayers(d.Entry,10.0)
  local c = 0
  for _,player in pairs(players) do
    local _item = NativeUI.CreateItem(GetPlayerName(player),"Invite Inside")
    _item.Activated = function(...) InviteInside(d,GetPlayerServerId(player)); end
    inviteMenu:AddItem(_item)
    c = c + 1
  end

  if c == 0 then
    local _item = NativeUI.CreateItem("No players near entry.","")
    inviteMenu:AddItem(_item)
  end

  inviteMenu:RefreshIndex()
  inviteMenu:Visible(true)
end

NativeCreateKeysMenu = function(d,menu) 
  local keys = _Pool:AddSubMenu(menu,"House Keys",d.Shell,true,true) 
  local giveKeys = _Pool:AddSubMenu(keys.SubMenu,"Give Keys",d.Shell,true,true)
  local takeKeys = _Pool:AddSubMenu(keys.SubMenu,"Take Keys",d.Shell,true,true)
  keys.SubMenu:RefreshIndex()

  local plyPed = PlayerPedId()
  local nearbyPlayers = GetNearbyPlayers()
  local c = 0
  for _,player in pairs(nearbyPlayers) do
    if player ~= plyPed then
      local _item = NativeUI.CreateItem(GetPlayerName(player),"Give Keys")
      _item:RightLabel("ID: "..player)
      _item.Activated = function(...) GiveKeys(d,GetPlayerServerId(player)); end
      giveKeys.SubMenu:AddItem(_item)
      c = c + 1
    end
  end

  if c == 0 then
    local _item = NativeUI.CreateItem("No players nearby","")
    giveKeys.SubMenu:AddItem(_item)
  end

  c = 0
  for k,v in pairs(Houses) do
    if v.Entry == d.Entry then
      for _,data in pairs(v.HouseKeys) do
        local _item = NativeUI.CreateItem(data.name,"Take Keys")
        _item.Activated = function(...) TakeKeys(v,data); end
        takeKeys.SubMenu:AddItem(_item)
        c = c + 1
      end
    end
  end

  if c == 0 then
    local _item = NativeUI.CreateItem("No players with keys","")
    takeKeys.SubMenu:AddItem(_item)
  end

  giveKeys.SubMenu:RefreshIndex()
  takeKeys.SubMenu:RefreshIndex()
end

NativeCreateUpgradeMenu = function(d,menu,empty)  
  local upgrade = _Pool:AddSubMenu(menu,(not empty and "Upgrade House" or "Available Upgrades"),d.Shell,true,true)
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
      local _item = NativeUI.CreateItem(data.shell,d.Shell)
      _item:RightLabel("$"..data.price)
      if not empty then 
        _item.Activated = function(...) UpgradeHouse(d,data); end
      end
      upgrade.SubMenu:AddItem(_item)
      c = c + 1
    end    
  end

  if c == 0 then
    local _item = NativeUI.CreateItem("No upgrades available","")
    upgrade.SubMenu:AddItem(_item)
  end
  upgrade.SubMenu:RefreshIndex()
end

NativeCreateMortgageMenu = function(d,menu,paying)  
  if d.MortgageOwed and d.MortgageOwed > 0 then
    local mortgage_info = Callback("Allhousing:GetMortgageInfo",d)
    local mortgage = _Pool:AddSubMenu(menu,"Mortgage","",true,true)

    local owed = NativeUI.CreateItem(string.format("Mortgage Owed: $%i",mortgage_info.MortgageOwed),"")
    mortgage.SubMenu:AddItem(owed)

    local repayment = NativeUI.CreateItem(string.format("Last Repayment: %s",mortgage_info.LastRepayment),"")
    mortgage.SubMenu:AddItem(repayment)

    if paying then
      local repay = NativeUI.CreateItem("Repay Mortgage","")
      mortgage.SubMenu:AddItem(repay)
      repay.Activated = function(...)
        RepayMortgage(d)
      end
    else
      local evict = NativeUI.CreateItem("Evict Tenants","")
      evict.Activated = function(...)
        RevokeTenancy(d)
      end
      mortgage.SubMenu:AddItem(evict)
    end

    mortgage.SubMenu:RefreshIndex()
  end
end

NativeCreateSellMenu = function(d,menu)
  local sell = _Pool:AddSubMenu(menu,"Sell House",d.Shell,true,true)  
  local verifyItem = NativeUI.CreateItem("Verify","Sell this house.")
  local cancelItem = NativeUI.CreateItem("Cancel","Don't sell this house.")

  verifyItem.Activated = function() _Pool:CloseAllMenus(); SellHouse(d); end
  cancelItem.Activated = function() _Pool:CloseAllMenus(); end

  sell.SubMenu:AddItem(verifyItem)
  sell.SubMenu:AddItem(cancelItem)
  sell.SubMenu:RefreshIndex()
end

DoOpenNativeGarage = function(d)
  local garageMenu = CreateNativeUIMenu("Garage","Player House")
  local vehicles = GetVehiclesAtHouse(d)
  
  if (#vehicles > 0) then
    for _,vehData in pairs(vehicles) do
      local vehicle = NativeUI.CreateItem("["..vehData.vehicle.plate.."] "..GetVehicleLabel(vehData.vehicle.model),"Spawn Vehicle")
      vehicle.Activated = function(...) 
        TriggerServerEvent('Allhousing:VehicleSpawned',vehData.vehicle.plate)
        SpawnVehicle(d.Garage,vehData.vehicle.model,vehData.vehicle)
      end
      garageMenu:AddItem(vehicle)
    end
  else
    local invalid = NativeUI.CreateItem("No vehicles available","")
    garageMenu:AddItem(invalid)
  end

  garageMenu:RefreshIndex()
  garageMenu:Visible(true)
end

NativeGarageOwnerMenu = function(d)
  local ped = PlayerPedId()
  if IsPedInAnyVehicle(ped,false) then
    local veh = GetVehiclePedIsUsing(ped)
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
    local garageMenu = CreateNativeUIMenu("Garage","My House")
    local vehicles = GetVehiclesAtHouse(d)

    if (#vehicles > 0) then
      for _,vehData in pairs(vehicles) do
        local vehicle = NativeUI.CreateItem("["..vehData.vehicle.plate.."] "..GetVehicleLabel(vehData.vehicle.model),"Spawn Vehicle")
        vehicle.Activated = function(...) 
          TriggerServerEvent('Allhousing:VehicleSpawned',vehData.vehicle.plate)
          SpawnVehicle(d.Garage,vehData.vehicle.model,vehData.vehicle)
        end
        garageMenu:AddItem(vehicle)
      end
    else
      local invalid = NativeUI.CreateItem("No vehicles available","")
      garageMenu:AddItem(invalid)
    end

    garageMenu:RefreshIndex()
    garageMenu:Visible(true)
  end
end

NativeGarageOwnedMenu = function(d)
  local ped = PlayerPedId()
  if IsPedInAnyVehicle(ped,false) then
    local veh = GetVehiclePedIsUsing(ped)
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
    local plyPed = PlayerPedId()  

    local myId = GetPlayerIdentifier()
    for k,v in pairs(d.HouseKeys) do
      if v.identifier == myId then
        DoOpenNativeGarage(d)
        return
      end
    end
    
    if not Config.GarageTheft then return; end

    if Config.LockpickRequired then
      local hasItem = CheckForLockpick()
      if not hasItem then
        ShowNotification("You don't have a lockpick.")
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
          DoOpenNativeGarage(d)
        else
          ClearPedTasksImmediately(plyPed)
          TriggerServerEvent("Allhousing:BreakLockpick")
        end
      end)
    elseif Config.UsingLockpickV2 then
      exports["lockpick"]:Lockpick(function(didWin)
        if didWin then
          ClearPedTasksImmediately(plyPed)
          DoOpenNativeGarage(d)
          ShowNotification("You successfully cracked the lock.")
        else
          ClearPedTasksImmediately(plyPed)
          TriggerServerEvent("Allhousing:BreakLockpick")
          ShowNotification("You failed to crack the lock.")
        end
      end)
    else
      if Config.UsingProgressBars then
        exports["progressBars"]:startUI(Config.LockpickTime * 1000,"Lockpicking Door")
      end
      Wait(Config.LockpickTime * 1000)
      if math.random(100) < Config.LockpickFailChance then
        local plyPos = GetEntityCoords(PlayerPedId())
        local zoneName = GetNameOfZone(plyPos.x,plyPos.y,plyPos.z)
        if Config.LockpickBreakOnFail then
          TriggerServerEvent("Allhousing:BreakLockpick")
        end
        ShowNotification("You failed to crack the lock.")
        for k,v in pairs(Config.PoliceJobs) do
          TriggerServerEvent("Allhousing:NotifyJobs",k,"Someone is attempting to break into a garage at "..zoneName)
        end
        ClearPedTasksImmediately(plyPed)
      else
        ShowNotification("You successfully cracked the lock.")
        ClearPedTasksImmediately(plyPed)
        DoOpenNativeGarage(d)
      end
    end
  end
end

NativeExitOwnerMenu = function(d)
  local exitMenu = CreateNativeUIMenu("House Exit","My House")

  local invite = NativeUI.CreateItem("Invite Inside",d.Shell)
  invite.Activated = function(...) NativeOpenInvite(d); end
  exitMenu:AddItem(invite)

  NativeCreateKeysMenu(d,exitMenu)

  NativeCreateUpgradeMenu(d,exitMenu)

  if Config.AllowHouseSales then
    NativeCreateSellMenu(d,exitMenu)
  end

  local furni = NativeUI.CreateItem("Furniture UI",d.Shell)
  furni.Activated = function(...) OpenFurniture(d); end
  exitMenu:AddItem(furni)

  local wardrobe = NativeUI.CreateItem("Set Wardrobe",d.Shell)
  wardrobe.Activated = function(...) SetWardrobe(d); end
  exitMenu:AddItem(wardrobe)

  if Config.UseHouseInventory then
    local inventory = NativeUI.CreateItem("Set Inventory",d.Shell)
    inventory.Activated = function(...) SetInventory(d); end
    exitMenu:AddItem(inventory)
  end

  if d.Unlocked then
    local lock = NativeUI.CreateItem("Lock House",d.Shell)
    lock.Activated = function(...) LockHouse(d); end
    exitMenu:AddItem(lock)
  else
    local unlock = NativeUI.CreateItem("Unlock House",d.Shell)
    unlock.Activated = function(...) UnlockHouse(d); end
    exitMenu:AddItem(unlock)
  end

  NativeCreateMortgageMenu(d,exitMenu,true)

  local leave = NativeUI.CreateItem("Leave House",d.Shell)
  leave.Activated = function(...) LeaveHouse(d); end
  exitMenu:AddItem(leave)

  

  exitMenu:RefreshIndex()
  exitMenu:Visible(true)
end

NativeExitOwnedMenu = function(d)
  local exitMenu = CreateNativeUIMenu("House Exit","Player House")

  local leave = NativeUI.CreateItem("Leave House",d.Shell)
  leave.Activated = function(...) LeaveHouse(d); end
  exitMenu:AddItem(leave)

  for k,v in pairs(d.HouseKeys) do
    if v.identifier == GetPlayerIdentifier() then
      local invite = NativeUI.CreateItem("Invite Inside",d.Shell)
      invite.Activated = function(...) NativeOpenInvite(d); end
      exitMenu:AddItem(invite)

      local furni = NativeUI.CreateItem("Furniture UI",d.Shell)
      furni.Activated = function(...) OpenFurniture(d); end
      exitMenu:AddItem(furni)
      break
    end
  end

  exitMenu:RefreshIndex()
  exitMenu:Visible(true)
end

NativeExitEmptyMenu = function(d)
  local exitMenu = CreateNativeUIMenu("House Exit","Empty House")

  local leave = NativeUI.CreateItem("Leave House",d.Shell)
  leave.Activated = function(...) LeaveHouse(d); end
  exitMenu:AddItem(leave)

  if (d.Owned) then
    local jobName = GetPlayerJobName()
    if Config.PoliceCanRaid and Config.PoliceJobs[jobName] then 
      if GetPlayerJobRank() >= Config.PoliceJobs[jobName].minRank then
        if d.Unlocked then
          local lock = NativeUI.CreateItem("Lock House",d.Shell)
          lock.Activated = function(...) LockHouse(d); end
          exitMenu:AddItem(lock)
        else
          local unlock = NativeUI.CreateItem("Unlock House",d.Shell)
          unlock.Activated = function(...) UnlockHouse(d); end
          exitMenu:AddItem(unlock)
        end
      end
    end
  end

  exitMenu:RefreshIndex()
  exitMenu:Visible(true)
end

NativeEntryOwnerMenu = function(d)
  local entryMenu = CreateNativeUIMenu("House Entry","My House")

  if d.Shell then
    local enter = NativeUI.CreateItem("Enter House",d.Shell)
    enter.Activated = function(...) EnterHouse(d); end
    entryMenu:AddItem(enter)

    NativeCreateUpgradeMenu(d,entryMenu)

    if d.Unlocked then
      local lock = NativeUI.CreateItem("Lock House",d.Shell)
      lock.Activated = function(...) LockHouse(d); end
      entryMenu:AddItem(lock)
    else
      local unlock = NativeUI.CreateItem("Unlock House",d.Shell)
      unlock.Activated = function(...) EnterHouse(d); end
      entryMenu:AddItem(unlock)
    end
  end

  if d.Garage and Config.AllowGarageMovement then
    local move = NativeUI.CreateItem("Move Garage",d.Shell)
    move.Activated = function(...) MoveGarage(d); end
    entryMenu:AddItem(move)
  end
  
  if Config.AllowHouseSales then
    NativeCreateSellMenu(d,entryMenu)
  end

  entryMenu:RefreshIndex()
  entryMenu:Visible(true)
end

NativeEntryOwnedMenu = function(d)
  local entryMenu = CreateNativeUIMenu("House Entry","Player House")


  local hasKeys = false
  for k,v in pairs(d.HouseKeys) do
    if v.identifier == GetPlayerIdentifier() then
      if d.Shell then
        local enter = NativeUI.CreateItem("Enter House",d.Shell)
        enter.Activated = function(...) EnterHouse(d); end
        entryMenu:AddItem(enter)
      end
      hasKeys = true
      break
    end
  end

  if not hasKeys then
    if d.Shell then
      local knock = NativeUI.CreateItem("Knock On Door",d.Shell)
      knock.Activated = function(...) KnockOnDoor(d); end
      entryMenu:AddItem(knock)

      local isPolice = false
      local jobName = GetPlayerJobName()
      if Config.PoliceCanRaid and Config.PoliceJobs[jobName] then 
        if GetPlayerJobRank() >= Config.PoliceJobs[jobName].minRank then
          isPolice = true
          local raid = NativeUI.CreateItem("Raid House",d.Shell)
          raid.Activated = function(...) RaidHouse(d); end
          entryMenu:AddItem(raid)
        end
      end
    end

    local isRealestate = false
    if Config.CreationJobs and Config.CreationJobs[jobName] then
      if GetPlayerJobRank() >= Config.CreationJobs[jobName].minRank then
        NativeCreateMortgageMenu(d,entryMenu)
      end
    end

    if d.Shell then
      if Config.HouseTheft and not isPolice then
        local breakIn = NativeUI.CreateItem("Break In",d.Shell)
        breakIn.Activated = function(...) BreakInHouse(d); end
        entryMenu:AddItem(breakIn)
      end

      if d.Unlocked then
        local enterHouse = NativeUI.CreateItem("Enter House",d.Shell)
        enterHouse.Activated = function(...) EnterHouse(d,true); end
        entryMenu:AddItem(enterHouse)
      end
    end
  end

  entryMenu:RefreshIndex()
  entryMenu:Visible(true)
end

NativeEntryEmptyMenu = function(d)
  local entryMenu = CreateNativeUIMenu("House Entry","Empty House")

  local buy = NativeUI.CreateItem("Purchase House",d.Shell)
  local mortgage = NativeUI.CreateItem("Mortgage House",d.Shell)
  buy.Activated = function(...) BuyHouse(d); end
  mortgage.Activated = function(...) MortgageHouse(d); end

  buy:RightLabel("$"..d.Price)
  mortgage:RightLabel("$"..math.floor(d.Price / 100) * Config.MortgagePercent)

  entryMenu:AddItem(buy)
  entryMenu:AddItem(mortgage)
  
  if d.Shell then
    local visit = NativeUI.CreateItem("View House",d.Shell)
    visit.Activated = function(...) ViewHouse(d); end
    entryMenu:AddItem(visit)
  end

  NativeCreateUpgradeMenu(d,entryMenu,true)

  entryMenu:RefreshIndex()
  entryMenu:Visible(true)
end

