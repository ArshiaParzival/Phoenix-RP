ESX = nil

local PlayerData = {}

Citizen.CreateThread(function()
  while not ESX do
    TriggerEvent("esx:getSharedObject", function(obj)
      ESX = obj
    end)
    Citizen.Wait(0)
  end

  while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
end)

local RSpos = vector3(-714.56,260.69,84.14)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if PlayerData ~= nil and PlayerData.job and PlayerData.job.name == 'realstate' then
            local coords = GetEntityCoords(PlayerPedId())
            local distance = #(coords - RSpos)
            if distance < 5 then
                DrawMarker(20, RSpos, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.2, 255, 255, 255, 255, false, true, nil, false)
                if distance < 2.0 then
                    TriggerEvent('esx:showHelpNotification', 'Kelid ~INPUT_CONTEXT~ jahat dastresi be ~r~Boss ~w~Menu')
                    if IsControlJustReleased(1, 38) then
                        TriggerEvent('esx_society:openBossMenu', 'realstate', function(data, menu)
                          menu.close()
                        end)
                    end
                end
            else
                Citizen.Wait(2000)
            end
        else
            Citizen.Wait(5000)
        end
    end
end)

Citizen.CreateThread(function()
    local blip = AddBlipForCoord(RSpos.x, RSpos.y, RSpos.z)
    SetBlipSprite(blip, 411)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.8)
    SetBlipColour(blip, 0)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Real State")
    EndTextCommandSetBlipName(blip)
end)

Init = function()
  -- local start = GetGameTimer()
  -- while (GetGameTimer() - start < 2000) do Wait(0); end

  StartData       = Callback("Allhousing:GetHouseData")
  Houses          = StartData.Houses
  KashIdentifier  = StartData.Identifier

  RefreshBlips  ()
  Update        ()
end



Update = function()
  while true do
    local wait_time = 0
    local do_render = false

    if not InsideHouse then
      do_render = RenderExterior()
    else
      do_render = RenderInterior()
    end

    if not do_render and Config.WaitToRender then
      wait_time = Config.WaitToRenderTime
    end

    Wait(wait_time)
  end
end

RenderInterior = function()
  local ped = PlayerPedId()
  local pos = GetEntityCoords(ped)
  local now = GetGameTimer()

  if (not lastIntCheck or not lastIntPos) or (now - lastIntCheck >= 500) or #(lastIntPos - pos) >= 2.0 then
    local _closest,_closestDist

    lastIntCheck  = now
    lastIntPos    = pos

    if InsideHouse.Interior then
      if GetInteriorAtCoords(pos.x,pos.y,pos.z) == InsideHouse.Interior then
        if InsideHouse.Owned then
          local wardrobeDist  = (                             InsideHouse.Wardrobe           and #(InsideHouse.Entry.xyz-InsideHouse.Wardrobe+Config.SpawnOffset - pos)            or false)
          local garageDist    = (                             InsideHouse.Garage             and #(InsideHouse.Garage.xyz - pos)                                                   or false)
          local inventoryDist = (not InsideHouse.Visiting and InsideHouse.InventoryLocation  and #(InsideHouse.Entry.xyz-InsideHouse.InventoryLocation+Config.SpawnOffset - pos)   or false)

          if wardrobeDist then
            if not _closestDist or wardrobeDist < _closestDist then
              _closest      = "Wardrobe"
              _closestDist  = wardrobeDist
            end
          end

          if inventoryDist then
            if not _closestDist or inventoryDist < _closestDist then
              _closest      = "InventoryLocation"
              _closestDist  = inventoryDist
            end
          end

          if garageDist then
            if not _closestDist or garageDist < _closestDist then
              _closest      = "Garage"
              _closestDist  = garageDist
            end
          end
        else
          local entryDist = #(InsideHouse.Entry.xyz - pos)
          if entryDist then
            if not _closestDist or entryDist < _closestDist then
              _closest      = "Entry"
              _closestDist  = entryDist
            end
          end
        end
      else
        UnloadInterior()
        return true
      end
    else
      local wardrobeDist  = (InsideHouse.Wardrobe     and #(InsideHouse.Entry.xyz-InsideHouse.Wardrobe+Config.SpawnOffset - pos)            or false)
      local inventoryDist = (not InsideHouse.Visiting and InsideHouse.InventoryLocation  and #(InsideHouse.Entry.xyz-InsideHouse.InventoryLocation+Config.SpawnOffset - pos)   or false)
      local exitDist      = (#(InsideHouse.Entry.xyz - ShellOffsets[InsideHouse.Shell].exit.xyz+Config.SpawnOffset-pos))

      if wardrobeDist then
        if not _closestDist or wardrobeDist < _closestDist then
          _closest      = "Wardrobe"
          _closestDist  = wardrobeDist
        end
      end

      if inventoryDist then
        if not _closestDist or inventoryDist < _closestDist then
          _closest      = "InventoryLocation"
          _closestDist  = inventoryDist
        end
      end

      if exitDist then
        if not _closestDist or exitDist < _closestDist then
          _closest      = "Exit"
          _closestDist  = exitDist
        end
      end
    end

    if _closest then
      closestInt      = _closest
      closestIntDist  = _closestDist
    end
  end

  if closestInt then
    local _pos = ((closestInt == "Garage" and InsideHouse[closestInt]) or (closestInt == "Exit" and InsideHouse.Entry.xyz-ShellOffsets[InsideHouse.Shell].exit.xyz+Config.SpawnOffset) or (InsideHouse.Entry.xyz-InsideHouse[closestInt].xyz+Config.SpawnOffset))
    if Config.UseMarkers then
      if closestIntDist < Config.MarkerDistance then
        DrawMarker(1,_pos.x,_pos.y,_pos.z-1.6, 0.0,0.0,0.0, 0.0,0.0,0.0, 1.0,1.0,1.0, Config.MarkerColors[Config.MarkerSelection].r,Config.MarkerColors[Config.MarkerSelection].g,Config.MarkerColors[Config.MarkerSelection].b,Config.MarkerColors[Config.MarkerSelection].a, false,true,2)
      end
    end

    if Config.Use3DText then
      if closestIntDist < Config.TextDistance3D then
        if closestIntDist < Config.InteractDistance then
          DrawText3D(_pos.x,_pos.y,_pos.z, Labels["InteractDrawText"]..Labels[closestInt])
        else
          DrawText3D(_pos.x,_pos.y,_pos.z, Labels[closestInt])
        end
      end
    end

    if Config.UseHelpText then
      if closestIntDist < Config.HelpTextDistance then
        ShowHelpNotification(Labels["InteractHelpText"]..Labels[closestInt])
      end
    end

    if closestIntDist < Config.InteractDistance then
      if IsControlJustReleased(0,Config.Controls.Interact) then
        if InsideHouse.Owned and (InsideHouse.Owner == GetPlayerIdentifier()) then
          OpenMenu(InsideHouse,closestInt,"Owner")
        elseif InsideHouse.Owned then
          OpenMenu(InsideHouse,closestInt,"Owned")
        else
          OpenMenu(InsideHouse,closestInt,"Empty")
        end
      end
    elseif InsideHouse.Interior then
      if IsControlJustReleased(0,Config.Controls.Interact) then
        if InsideHouse.Owned and (InsideHouse.Owner == GetPlayerIdentifier()) then
          OpenMenu(InsideHouse,"Exit","Owner")
        elseif InsideHouse.Owned then
          OpenMenu(InsideHouse,"Exit","Owned")
        else
          OpenMenu(InsideHouse,"Exit","Empty")
        end
      end
    end
    return true
  else
    return false
  end
end

RenderExterior = function()
  local ped = PlayerPedId()
  local pos = GetEntityCoords(ped)

  local now = GetGameTimer()
  if (not lastExtCheck or not lastExtPos) or (now - lastExtCheck > 5000) or (#(lastExtPos - pos) >= 2.0) then
    lastExtCheck = now
    lastExtPos   = pos

    closestExt,closestExtDist,closestExtHouse = false,false,false

    local _closest,_closestDist
    for index,house in pairs(Houses) do
      local entryDist   = #(pos - house.Entry.xyz)
      local garageDist  = (type(house.Garage) == "vector4" and type(pos) == "vector3" and #(house.Garage.xyz - pos) or false)

      if not garageDist or entryDist < garageDist then
        _closest      = "Entry"
        _closestDist  = entryDist
      else
        _closest      = "Garage"
        _closestDist  = garageDist
      end

      if not closestExtDist or _closestDist < closestExtDist then
        closestExt       = _closest
        closestExtDist   = _closestDist
        closestExtHouse  = index
      end
    end
  end

  if closestExt and closestExtDist and closestExtDist < 100.0 then
    local house = Houses[closestExtHouse]
    if house.Interior and house.Owned and GetInteriorAtCoords(pos.x,pos.y,pos.z) == house.Interior then
      LoadInterior(house)
      return true
    else
      local render = false

      if Config.UseMarkers then
        if closestExtDist < Config.MarkerDistance then
          render = true
          DrawMarker(1,house[closestExt].x,house[closestExt].y,house[closestExt].z-1.6, 0.0,0.0,0.0, 0.0,0.0,0.0, 1.0,1.0,1.0, Config.MarkerColors[Config.MarkerSelection].r,Config.MarkerColors[Config.MarkerSelection].g,Config.MarkerColors[Config.MarkerSelection].b,Config.MarkerColors[Config.MarkerSelection].a, false,true,2)
        end
      end

      if Config.Use3DText then
        if closestExtDist < Config.TextDistance3D then
          render = true
          if closestExtDist < Config.InteractDistance then
            DrawText3D(house[closestExt].x,house[closestExt].y,house[closestExt].z, Labels["InteractDrawText"]..Labels[closestExt])
          else
            DrawText3D(house[closestExt].x,house[closestExt].y,house[closestExt].z, Labels[closestExt])
          end
        end
      end

      if Config.UseHelpText then
        if closestExtDist < Config.HelpTextDistance then
          render = true
          ShowHelpNotification(Labels["InteractHelpText"]..Labels[closestExt])
        end
      end

      if closestExtDist < Config.InteractDistance then
        render = true
        if IsControlJustReleased(0,Config.Controls.Interact) then
          if house.Owned and (house.Owner == GetPlayerIdentifier()) then
            OpenMenu(house,closestExt,"Owner")
          elseif house.Owned then
            OpenMenu(house,closestExt,"Owned")
          else
            OpenMenu(house,closestExt,"Empty")
          end
        end
      end

      return render
    end
  else
    return false
  end
end

LoadModel = function(hash_or_model)
  local hash = (type(hash_or_model) == "number" and hash_or_model or GetHashKey(has_or_model))
  RequestModel(hash)
  while not HasModelLoaded(hash) do Wait(0); end
end

UnloadInterior = function()  
  if InsideHouse and InsideHouse.Extras then
    for k,v in pairs(InsideHouse.Extras) do
      SetEntityAsMissionEntity(v,true,true)
      DeleteObject(v)
    end
  end

  InsideHouse = false  
  TriggerEvent("Allhousing:Leave")
end

LoadInterior = function(d)
  ShowNotification(Labels["InteractDrawText"]..Labels["AccessHouseMenu"])

  InsideHouse         = d
  InsideHouse.Exit    = InsideHouse.Entry
  InsideHouse.Extras  = {}

  local furni = Callback("Allhousing:GetFurniture",d.Id)
  for k,v in pairs(furni) do
    local objHash = GetHashKey(v.model)
    LoadModel(objHash)

    local obj = CreateObject(objHash, InsideHouse.Entry.x + v.pos.x, InsideHouse.Entry.y + v.pos.y, InsideHouse.Entry.z + v.pos.z, false,false,false)
    SetEntityCoordsNoOffset(obj, InsideHouse.Entry.x + v.pos.x, InsideHouse.Entry.y + v.pos.y, InsideHouse.Entry.z + v.pos.z)
    SetEntityRotation(obj, v.rot.x, v.rot.y, v.rot.z, 2)
    FreezeEntityPosition(obj, true)

    SetModelAsNoLongerNeeded(objHash)

    table.insert(InsideHouse.Extras,obj)
  end

  local isOwner,hasKeys,isPolice = false,false,false

  local identifier = GetPlayerIdentifier()
  if identifier == d.Owner then
    isOwner = true
  else
    for k,v in pairs(d.HouseKeys) do
      if v.identifier == identifier then
        hasKeys = true
        break
      end
    end
  end

  local job = GetPlayerJobName()
  if Config.PoliceJobs[job] then
    if GetPlayerJobRank() >= Config.PoliceJobs[job].minRank then
      isPolice = true
    end
  end

  if hasKeys or isOwner or (isPolice and Config.PoliceCanRaid and Config.InventoryRaiding) then
    InsideHouse.Visiting = false
  else
    InsideHouse.Visiting = true
  end

  TriggerEvent("Allhousing:Enter",InsideHouse)
end

RefreshInterior = function()
  if InsideHouse then
    for k,v in pairs(Houses) do
      if v.Entry == InsideHouse.Entry then
        InsideHouse.HouseKeys = v.HouseKeys
      end
    end
  end
end

Sync = function(data)
  local _key
  for k,house in pairs(Houses) do
    if house.Blip then
      RemoveBlip(house.Blip)
      house.Blip = false
      if InsideHouse and InsideHouse.Id == house.Id then
        _key = k
      end
    end
  end
  
  Houses = data
  RefreshBlips()
  if _key then
    InsideHouse = Houses[_key]
  end
end

SyncHouse = function(sync_house)
  local house = Houses[sync_house.Id]

  if not house then
    Houses[sync_house.Id] = sync_house
    house = Houses[sync_house.Id]
  end

  if house.Blip then
    RemoveBlip(house.Blip)
    house.Blip = false
  end

  if house.Id == sync_house.Id then
    if house.Blip then
      RemoveBlip(house.Blip)
    end

    Houses[sync_house.Id] = sync_house

    if InsideHouse and InsideHouse.Id == sync_house.Id then
      sync_house.Extras = InsideHouse.Extras
      sync_house.Object = InsideHouse.Object
      sync_house.Visiting = InsideHouse.Visiting  
      InsideHouse = Houses[sync_house.Id]
    end

    if Config.UseBlips then
      local identifier = GetPlayerIdentifier()
      local color,sprite,text
      if Houses[sync_house.Id].Owned and Houses[sync_house.Id].Owner and (Houses[sync_house.Id].Owner == identifier) then
        text = "My Property"
        color,sprite = GetBlipData("owner",Houses[sync_house.Id].Entry)
      elseif Houses[sync_house.Id].Owned and Houses[sync_house.Id].HouseKeys[identifier] then
        text = "Proprty Access"
        color, sprite = GetBlipData("owned", Houses[sync_house.Id].Entry)
      else
        if Houses[sync_house.Id].Owner == identifier then
          text = "Your Property For Sale"
          color, sprite = 2, 350
        else
          text = "Empty Property"
          color,sprite = GetBlipData("empty",Houses[sync_house.Id].Entry)
        end
      end
      if color and sprite then
        Houses[sync_house.Id].Blip = CreateBlip(Houses[sync_house.Id].Entry,sprite,color, text, 1.0, 4)
      end
    end
  end
  LastExtCheck = 0
end



Invited = function(house)
  local plyPed = PlayerPedId()
  local plyPos = GetEntityCoords(plyPed)
  if Vdist(plyPos,house.Entry.xyz) < 5.0 then
    ShowNotification(Labels["InteractDrawText"]..Labels["InvitedInside"])
    BeingInvited = true
    while Vdist(GetEntityCoords(plyPed),house.Entry.xyz) < 10.0 do
      if IsControlJustPressed(0,Config.Controls.Accept) then
        ViewHouse(house)
        BeingInvited = false
        return
      end
      Wait(0)
    end
    BeingInvited = false
    ShowNotification(Labels["MovedTooFar"])
  else    
    ShowNotification(Labels["MovedTooFar"])
  end
end

KnockAtDoor = function(entry)
  if InsideHouse and InsideHouse.Entry == entry and InsideHouse.Owner and InsideHouse.Owner == GetPlayerIdentifier() then
    ShowNotification(Labels["KnockAtDoor"])
  end
end

Boot = function(id,enter)
  if InsideHouse and InsideHouse.Id == id and not LeavingHouse then
    local _id = InsideHouse.Id
    LeaveHouse()
    if enter then
      for k,v in pairs(Houses) do
        if v.Id == _id then
          EnterHouse(v)
          return
        end
      end
    end
  end
end

RegisterNetEvent("Allhousing:Sync")
AddEventHandler("Allhousing:Sync", Sync)

RegisterNetEvent("Allhousing:SyncHouse")
AddEventHandler("Allhousing:SyncHouse", SyncHouse)

RegisterNetEvent("Allhousing:Boot")
AddEventHandler("Allhousing:Boot", Boot)

RegisterNetEvent("Allhousing:Invited")
AddEventHandler("Allhousing:Invited", Invited)

RegisterNetEvent("Allhousing:KnockAtDoor")
AddEventHandler("Allhousing:KnockAtDoor", KnockAtDoor)

AddEventHandler("Allhousing:Relog", function(...)
  StartData       = Callback("Allhousing:GetHouseData")
  Houses          = StartData.Houses
  KashIdentifier  = StartData.Identifier
  RefreshBlips    ()
end)

AddEventHandler("Allhousing:GetHouseById",function(id,callback)
  callback(Houses[id],KashIdentifier)
end)

Citizen.CreateThread(Init)


