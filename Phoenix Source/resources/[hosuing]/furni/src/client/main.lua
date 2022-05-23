furni.rotMult  = 5.0
furni.rotationAxis = "x"
furni.rotation = {x = 0.0, y = 0.0, z = 0.0}
furni.position = {x = 0.0, y = 0.0, z = 0.0}
furni.distMult = 55.0
furni.distAdder = 1.0
furni.minDist = 5.0
furni.maxDist = 20.0
furni.focused = false

furni.nudgeOffsets = {x = 0.00, y = 0.00, z = 0.00}
furni.nudgeMult = 0.01

furni.neverGrab = {
  GetHashKey('playerhouse_hotel'),
  GetHashKey('playerhouse_tier1'),
  GetHashKey('playerhouse_tier1_full'),
  GetHashKey('v_49_MotelMP_Curtains'),
  GetHashKey('V_16_DT'),

  GetHashKey('frankelientje'),
  GetHashKey('shell_coke1'),
  GetHashKey('shell_coke2'),
  GetHashKey('shell_meth'),
  GetHashKey('shell_weed'),
  GetHashKey('shell_weed2'),

  GetHashKey('shell_apartment1'),
  GetHashKey('shell_apartment2'),
  GetHashKey('shell_apartment3'),
  
  GetHashKey('shell_frankaunt'),
  GetHashKey('shell_medium2'),
  GetHashKey('shell_medium3'),


  GetHashKey('shell_v16low'),
  GetHashKey('shell_lester'),
  GetHashKey('shell_ranch'),
  GetHashKey('shell_trailer'),
  GetHashKey('shell_v16mid'),
  GetHashKey('shell_highend'),
  GetHashKey('shell_highendv2'),
  GetHashKey('shell_michael'),

  GetHashKey('shell_office1'),
  GetHashKey('shell_office2'),
  GetHashKey('shell_officebig'),
  
  GetHashKey('shell_store1'), 
  GetHashKey('shell_store2'),
  GetHashKey('shell_store3'),
  GetHashKey('shell_gunstore'),
  GetHashKey('shell_barber'),

  GetHashKey('shell_warehouse1'),
  GetHashKey('shell_warehouse2'),
  GetHashKey('shell_warehouse3'),
}
  
furni.antiGrab = {}
for k,v in pairs(furni.neverGrab) do 
  furni.antiGrab[v] = v;
  furni.antiGrab[v%0x100000000] = v%0x100000000; 
end

furni.spawnedObjects = {}

furni.awake = function()
  furni.init      (false)
  furni.display   (false)

  if Config.UsingESX then
    while not ESX                   do Citizen.Wait(0); end
    while not ESX.IsPlayerLoaded()  do Citizen.Wait(0); end

    furni.plyData = ESX.GetPlayerData()

    if Config.UsingKashacters then
      TriggerServerEvent("furni:playerLogin")
    end
  end

  furni.update    (false)
end

furni.init = function()
  local res = GetCurrentResourceName()
  while not furni.gotInit do 
    SendNUIMessage({
      type              = "init",
      onInit            = string.format("http://%s/DoInit",res),
      onOpen            = string.format("http://%s/DoOpen",res),
      onClose           = string.format("http://%s/DoClose",res),
      onCancel          = string.format("http://%s/DoCancel",res),
      onSelect          = string.format("http://%s/DoSelect",res),
      onPlace           = string.format("http://%s/DoPlace",res),
      onStartAim        = string.format("http://%s/DoStartAim",res),
      onStopAim         = string.format("http://%s/DoStopAim",res),
      onReposition      = string.format("http://%s/DoReposition",res),
      onRepositionStart = string.format("http://%s/DoRepositionStart",res),
      onTransform       = string.format("http://%s/DoTransform",res),
      onEdit            = string.format("http://%s/DoEdit",res),
      onRemove          = string.format("http://%s/DoRemove",res),
      onExit            = string.format("http://%s/DoExit",res),
      items             = furni.objects,
      top               = "300px",
      left              = "20px",
    })
    Wait(5000)
  end
end

furni.update = function()
  local textTemp = Utils.drawTextTemplate()
  textTemp.x = 0.8
  textTemp.y = 0.8

  local nudgeTemp = Utils.drawTextTemplate()
  nudgeTemp.x = 0.9
  nudgeTemp.y = 0.8

  local keyHeldFor = 0
  local lastFrame = 0
  local lastHouseCheck = 0
  while true do
    if furni.inHouse and not furni.editing and not furni.doingRemoval and not furni.object and furni.canopen then
      if IsControlJustPressed(0, Controls["Focus"]) or IsDisabledControlJustPressed(0, Controls["Focus"]) then
        furni.focus(true)
        SetCursorLocation(0.5,0.5)
      end
    end
    
    if furni.inHouse then
      local timeNow = GetGameTimer()
      if (not lastHouseCheck) or ((timeNow - lastHouseCheck) > 1000) then
        lastHouseCheck = timeNow
        N_0xf4f2c0d4ee209e20() -- Disable the pedestrian idle camera
      end
    end

    if furni.active then  
      local start,fin               = Utils.getCoordsInFrontOfCam(0,5000)
      local ray                     = StartShapeTestRay(start.x,start.y,start.z, fin.x,fin.y,fin.z, 1, (furni.object or PlayerPedId()), 5000)
      local oRay                    = StartShapeTestRay(start.x,start.y,start.z, fin.x,fin.y,fin.z, 16, (furni.object or PlayerPedId()), 5000)
      local r,hit,pos,norm,ent      = GetShapeTestResult(ray)
      local oR,oHit,oPos,oNorm,oEnt = GetShapeTestResult(oRay)

      if oHit > 0 then r,hit,pos,norm,ent = oR,oHit,oPos,oNorm,oEnt; end

      if furni.doAim and not furni.focused then
        if IsDisabledControlJustReleased(0, Controls["Grab"]) or IsControlJustReleased(0, Controls["Grab"]) then
          FreezeEntityPosition(furni.object,true)
          furni.doAim = (false)          
          furni.focus   (true)
        end
      end

      if hit > 0 then        
        furni.hitPos = pos

        if furni.editing then
          furni.handleControls(true)

          local ped = PlayerPedId()
          local p = GetEntityCoords(ped)

          if ent and ent ~= -1 and ent ~= 0 and DoesEntityExist(ent) then
            local ePos = GetEntityCoords(ent)
            if ePos.x ~= 0.0 then
              local model = GetEntityModel(ent)
              if not furni.antiGrab[model] then
                if wasPressing and keyHeldFor >= 500 then
                  Utils.drawText3D(pos,"~r~Release [~s~LMB/RT~r~] to change [~s~"..(hashtable[model] and hashtable[model].name or "Unknown").."~r~]~s~",1,7)
                else
                  Utils.drawText3D(pos,"~y~Hold [~s~LMB/RT~y~] to change [~s~"..(hashtable[model] and hashtable[model].name or "Unknown").."~y~]~s~",1,7)
                end

                if IsDisabledControlJustReleased(0, Controls["Grab"]) or IsDisabledControlReleased(0, Controls["Grab"]) and wasPressing then
                  if keyHeldFor >= 500 then
                    keyHeldFor = 0
                    wasPressing = false
                    furni.editing = false
                    local fwd,up,right,p = GetEntityMatrix(ent)
                    furni.wasEditing = {pos = GetEntityCoords(ent), rot = GetEntityRotation(rot,2), lastPos = p}
                    furni.edit(ent,hashtable[model]) 
                  end
                end
                if IsDisabledControlPressed(0, Controls["Grab"]) or IsControlPressed(0, Controls["Grab"]) and not furni.focused then
                  keyHeldFor = keyHeldFor + (GetGameTimer() - lastFrame)
                  wasPressing = true
                else
                  keyHeldFor = 0
                  wasPressing = false
                end
              end
            end
          end   
          if IsDisabledControlJustPressed(0, Controls["Focus"]) or IsControlJustPressed(0, Controls["Focus"]) then
            furni.editing = false
            furni.wasEditing = false
            furni.focus(true)
          end 
        elseif furni.doingRemoval then
          furni.handleControls(true)

          local ped = PlayerPedId()
          local p = GetEntityCoords(ped)

          if ent and ent ~= -1 and ent ~= 0 then
            local ePos = GetEntityCoords(ent)
            if ePos and ePos.x and ePos.x ~= 0 and ePos.x ~= 0.0 then
              local model = GetEntityModel(ent)
              if not furni.antiGrab[model] then
                Utils.drawText3D(pos,"~y~Hold [~s~LMB/RT~y~] to sell [~s~"..(hashtable[model] and hashtable[model].name or "Unknown").."~y~] [~s~"..(hashtable[model] and "$"..math.floor(hashtable[model].price*(Config.ResaleValue and Config.ResaleValue/100.0 or 0.5)) or "Unknown").."~y~]~s~",1,7)
                if IsDisabledControlPressed(0, Controls["Grab"]) or IsControlPressed(0, Controls["Grab"]) and not furni.focused then
                  keyHeldFor = keyHeldFor + (GetGameTimer() - lastFrame)
                  if keyHeldFor >= 500 then
                    keyHeldFor = 0
                    furni.remove(ent,hashtable[model])    
                  end
                else
                  keyHeldFor = 0
                end
              end
            end
          end   
          if IsDisabledControlJustPressed(0, Controls["Focus"]) or IsControlJustPressed(0, Controls["Focus"]) then
            furni.doingRemoval = false
            furni.focus(true)
          end       
        elseif furni.object then
          furni.handleControls(true)
          
          local min,max =  GetModelDimensions(GetEntityModel(furni.object))
          local minOff  = -GetOffsetFromEntityGivenWorldCoords(furni.object, min.x, min.y, min.z)
          local maxOff  = -GetOffsetFromEntityGivenWorldCoords(furni.object, max.x, max.y, max.z)
          local off     =  maxOff - minOff

          local p = GetEntityCoords(furni.object)
          p = vector3(p.x, p.y, p.z + (max.z/2)) 

          local x,y,z = 0,0,0
          local targetPos
          local dist = Utils.vecDist(start, pos)

          if dist < furni.distMult + 0.5 then
            if norm.x >  0.5  then x = x + max.x; end
            if norm.x < -0.5  then x = x + min.x; end
            if norm.y >  0.5  then y = y + max.y; end
            if norm.y < -0.5  then y = y + min.y; end
            if norm.z >  0.5  then z = z - min.z; end
            if norm.z < -0.5  then z = z - max.z; end

            targetPos = vector3(pos.x + x,pos.y + y,pos.z + z)
          else
            local dir = pos - start
            local clamped = Utils.clampVecLength(dir, furni.distMult)
            targetPos = start + clamped
          end

          if furni.controlling then
            SetEntityCoordsNoOffset(
              furni.object, 
              targetPos.x + furni.nudgeOffsets.x, 
              targetPos.y + furni.nudgeOffsets.y, 
              targetPos.z + furni.nudgeOffsets.z
            )
          end

          local rot         = furni.rotation
          SetEntityRotation (furni.object, rot.x*1.0,rot.y*1.0,rot.z*1.0, 2)
        else
          furni.handleControls(false)
        end
      end
    end
    lastFrame = GetGameTimer()
    Wait(0)
  end
end

furni.overlay = function(overlay)
  local enabled,type,text,color
  if not overlay then
    enabled = false
    type = "overlay"
    text = ""
    color = {r = 0, g = 0, b = 0, a = 0}
  elseif overlay == "place" then
    enabled = true
    type = "overlay"
    text = "place furniture"
    color = {r = 0, g = 0, b = 255, a = 100}
  elseif overlay == "remove" then
    enabled = true
    type = "overlay"
    text = "remove furniture"
    color = {r = 255, g = 0, b = 0, a = 100}
  elseif overlay == "edit" then
    enabled = true
    type = "overlay"
    text = "edit furniture"
    color = {r = 0, g = 255, b = 0, a = 100}
  end
  SendNUIMessage({enabled = enabled, type = type, text = text, color = color})
  --furni.setAlpha(0.1)
end

furni.edit = function(ent,data)
  furni.object = ent
  furni.objectData = data
  furni.focus(true)

  local rot = GetEntityRotation(ent,2)
  furni.rotation = {x = rot.x, y = rot.y, z = rot.z}
  furni.nudgeOffsets = {x = 0.0, y = 0.0, z = 0.0}

  SetEntityAsMissionEntity(ent,true,true)
  DeleteEntity(ent)
  DeleteObject(ent)

  SendNUIMessage({  type = "openEdit", name = data.name, id = data.id, price = data.price})
end

furni.remove = function(ent,data)
  local r = GetEntityRotation(ent,2)
  local p = GetEntityCoords(ent)
  SetEntityAsMissionEntity(ent,true,true)
  DeleteEntity(ent,true)
  DeleteObject(ent,true)

  furni.controlling = false
  TriggerServerEvent('furni:DeleteFurniture',furni.inHouse,data,p,r)
end

furni.display = function(display)
  SendNUIMessage({type = "display",enabled = display})
  furni.controlling = display
end

furni.focus = function(focus)
  furni.focused = focus

  if focus then
    SetControlNormal(0, Controls["Grab"], 1.0)
    Wait(100)
    SetControlNormal(0, Controls["Grab"], 0.0)
    Wait(100)
  end

  SetNuiFocus(focus,focus)

  if furni.object then
    local pos = GetEntityCoords(furni.object)
    local rot = GetEntityRotation(furni.object, 2)
    SendNUIMessage({ type = "setTransform", position = {x = Utils.round(pos.x,2), y = Utils.round(pos.y,2), z = Utils.round(pos.z,2)}, rotation = {x = rot.x, y = rot.y, z = rot.z} })
  end

  furni.lastPosition = pos;
  if focus then
    SendNUIMessage({ type = "focus" })
    furni.setAlpha(1.0)
    furni.controlling = false

    if not furni.object then
      furni.overlay(false)
    end
  else
    furni.setAlpha(0.01)
    furni.controlling = true
  end
end

furni.setAlpha = function(a)
  SendNUIMessage({ type = "setAlpha", alpha = a })
end  

-- NUI callback functions.
furni.doOpen = function(...) 
  furni.display(true)
end

furni.doClose = function(...) end

furni.doCancel = function(...) 
  if furni.object and not furni.wasEditing then
    SetEntityAsMissionEntity(furni.object,true,true)
    DeleteObject(furni.object)
  elseif furni.object then
    SetEntityCollision(furni.object, true, true)
    local p = furni.wasEditing.pos
    local r = furni.wasEditing.rot
    SetEntityCoordsNoOffset(furni.object, p.x,p.y,p.z)
    SetEntityRotation(furni.object, r.x,r.y,r.z, 2)
    furni.editing = true
    furni.focus(false)
    furni.overlay("edit")
  end
  furni.nudgeOffsets = {x = 0.0, y = 0.0, z = 0.0}
  furni.rotation = {x = 0.0, y = 0.0, z = 0.0}

  furni.object = false
end

furni.doPlace = function(...)
  FreezeEntityPosition(furni.object, true)
  SetEntityCollision(furni.object, true, true)
  
  if furni.inHouse then
    local pos = GetEntityCoords(furni.object) - furni.inHouse.Entry.xyz
    local rot = GetEntityRotation(furni.object, 2)

    local item = lookuptable[furni.objectData.id]
    if furni.wasEditing then
      TriggerServerEvent('furni:ReplaceFurniture', furni.inHouse,item,pos,rot,furni.object,furni.wasEditing)
    else
      if CanPlayerAfford(item.price) then
        TriggerServerEvent('furni:PlaceFurniture', furni.inHouse,item,pos,rot,furni.object)
      else
        Utils.showNotification("You can't afford this item.")
        SetEntityAsMissionEntity(furni.object,true,true)
        DeleteObject(furni.object)
        DeleteEntity(furni.object)
      end
    end
  end

  furni.nudgeOffsets = {x = 0.0, y = 0.0, z = 0.0}
  furni.rotation = {x = 0.0, y = 0.0, z = 0.0}

  furni.object = false
  if furni.wasEditing then
    SendNUIMessage({type = "close"})
    furni.focus(false)
    furni.editing = true
    furni.overlay("edit")
    furni.wasEditing = false
  end
end

furni.doSelect = function(obj) 
  while not furni.hitPos do Wait(0); end
  local hash = GetHashKey(obj.id)
  RequestModel(hash)
  while not HasModelLoaded(hash) do Wait(0); end

  furni.objectData = obj
  furni.object = CreateObject(hash, furni.hitPos.x,furni.hitPos.y,furni.hitPos.z, false,false,false)
  furni.spawnedObjects[#furni.spawnedObjects+1] = furni.object
  Wait(10)

  SetEntityCollision(furni.object, false, false)
  local pos = GetEntityCoords(furni.object)
  local rot = GetEntityRotation(furni.object, 2)
  SendNUIMessage({ type = "setTransform", position = {x = Utils.round(pos.x,2), y = Utils.round(pos.y,2), z = Utils.round(pos.z,2)}, rotation = {x = rot.x, y = rot.y, z = rot.z} })
  SetModelAsNoLongerNeeded(hash)
end

furni.doStartAim = function(...)
  furni.doAim = true
  if not furni.wasEditing or not furni.editing or not furni.doingRemoval then
    furni.overlay("place")
  end
  furni.focus(false)
  SetCurrentPedWeapon(PlayerPedId(), `WEAPON_UNARMED`, true)
  if furni.object then FreezeEntityPosition(furni.object,false); end
end

furni.doStopAim = function(...) end
furni.doRepo = function() end
furni.doRepoStart = function() end

furni.doTransform = function(tab)
  local vPos = vector3(tab.position.x,tab.position.y,tab.position.z)
  local p = vPos - furni.hitPos
  local r = tab.rotation

  FreezeEntityPosition(furni.object,false)
  furni.nudgeOffsets = {x = p.x, y = p.y, z = p.z}
  furni.rotation = r
  SetEntityCoordsNoOffset(furni.object, Utils.round(tab.position.x,2),Utils.round(tab.position.y,2),Utils.round(tab.position.z,2))
  FreezeEntityPosition(furni.object,true)
end

furni.doEdit = function()
  furni.editing = true
  furni.overlay("edit")
  furni.focus(false)
end

furni.doRemove = function()
  furni.doingRemoval = true
  furni.overlay("remove")
  furni.focus(false)
end

furni.doExit = function()
  furni.focus(false)
end

furni.doInit = function()
  furni.gotInit = true
end

toVec = function(self)
  if self.z then
    return vector3(self.x,self.y,self.z)
  elseif self.y then
    return vector2(self.x,self.y)
  else
    return false
  end
end

RegisterNUICallback('DoOpen',             furni.doOpen)
RegisterNUICallback('DoClose',            furni.doClose)
RegisterNUICallback('DoCancel',           furni.doCancel)
RegisterNUICallback('DoSelect',           furni.doSelect)
RegisterNUICallback('DoPlace',            furni.doPlace)
RegisterNUICallback('DoStartAim',         furni.doStartAim)
RegisterNUICallback('DoStopAim',          furni.doStopAim)
RegisterNUICallback('DoReposition',       furni.doRepo)
RegisterNUICallback('DoRepositionStart',  furni.doRepoStart)
RegisterNUICallback('DoTransform',        furni.doTransform)
RegisterNUICallback('DoEdit',             furni.doEdit)
RegisterNUICallback('DoRemove',           furni.doRemove)
RegisterNUICallback('DoExit',             furni.doExit)
RegisterNUICallback('DoInit',             furni.doInit)

Citizen.CreateThread(furni.awake)

-- PLAYERHOUSING STUFF
furni.enterHouse = function(house)
  furni.inHouse = house
  furni.display(true)
  furni.focus(false)
end

furni.leaveHouse = function()
  furni.inHouse = false
  furni.canopen = false
  furni.cleanup()

  furni.active = false
  furni.display(false)
end

furni.cleanup = function()
  for key,val in pairs(furni.spawnedObjects) do
    SetEntityAsMissionEntity(val,true,true)
    DeleteEntity(val)
    DeleteObject(val)
  end
  furni.spawnedObjects = {}
end

-- Command
furni.openCommand = function(s,args) 
  if furni.inHouse then
    furni.active = true
    furni.canopen = true
    furni.display(true)
    furni.setAlpha(0.2)
  else
    Utils.showNotification("~r~You must be inside a house.")
  end
end

furni.focusCommand = function()
  if furni.inHouse then
    furni.focus(true)
  else
    furni.focus(false)
    Utils.showNotification("~r~You must be inside a house.")
  end
end

Event = function(n,h,e)
  if n then RegisterNetEvent(e); end
  AddEventHandler(e,h)
end

Event(true,furni.openCommand,'Allhousing:OpenFurni')
Event(true,furni.enterHouse,'Allhousing:Enter')
Event(true,furni.leaveHouse,'Allhousing:Leave')

 CanPlayerAfford = function(value)
   if GetPlayerCash() >= value then
     return true
   elseif GetPlayerBank() >= value then
     return true
   else
     return false
   end
 end

GetPlayerCash = function()
  if Config.UsingESX then
    PlayerData = GetPlayerData()
    if Config["UsingESX_V1.2.0"] then
      for k,v in pairs(PlayerData.accounts) do
        if v.name == Config.CashAccountName then
          return v.money
        end
      end
    else
      return PlayerData.money
    end
  else
    -- NON-ESX USERS ADD HERE
  end
end

GetPlayerBank = function()
  if Config.UsingESX then
    PlayerData = GetPlayerData()
    for k,v in pairs(PlayerData.accounts) do
      if v.name == Config.BankAccountName then
        return v.money
      end
    end
    return 0
  else
    -- NON-ESX USERS ADD HERE
  end
end

GetPlayerData = function()
  if Config.UsingESX then
    return ESX.GetPlayerData()
  else
    -- NON-ESX USERS ADD HERE
  end
end