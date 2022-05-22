local shield = false

RegisterNetEvent("shield:ToggleSheriffShield")
AddEventHandler("shield:ToggleSheriffShield", function()
  Citizen.CreateThread(function()
    if not shield then
      local ped = GetPlayerPed(-1)
      local propName = "prop_jsheriff_shield"
      local coords = GetEntityCoords(ped)
      local prop = GetHashKey(propName)

      local dict = "weapons@first_person@aim_rng@generic@light_machine_gun@combat_mg@"
      local name = "wall_block_low"

      while not HasAnimDictLoaded(dict) do
        Citizen.Wait(10)
        RequestAnimDict(dict)
      end

      RequestModel(prop)
      while not HasModelLoaded(prop) do
        Citizen.Wait(100)
      end

      local attachProps = CreateObject(prop, coords,  true,  false,  false)
      local netid = ObjToNet(attachProps)

      TaskPlayAnim(ped,dict,name,1.0,4.0,-1,49,0,0,0,0)
      AttachEntityToEntity(attachProps,ped,GetPedBoneIndex(ped, 57005),0.21,0.01,0.11,-72.0,85.0,80.0, false, false, false, true, 2, true)

      shield_net = netid
      shield = true
    else
      shield = false
      ClearPedSecondaryTask(GetPlayerPed(PlayerId()))
      SetModelAsNoLongerNeeded(prop)
      SetEntityAsMissionEntity(attachProps, true, false)
      DetachEntity(NetToObj(shield_net), 1, 1)
      DeleteEntity(NetToObj(shield_net))
      shield_net = nil
    end
  end)
end)

RegisterNetEvent("shield:ToggleSwatShield")
AddEventHandler("shield:ToggleSwatShield", function()
  Citizen.CreateThread(function()
    if not shield then
      local ped = GetPlayerPed(-1)
      local propName = "prop_jswat_shield"
      local coords = GetEntityCoords(ped)
      local prop = GetHashKey(propName)

      local dict = "weapons@first_person@aim_rng@generic@light_machine_gun@combat_mg@"
      local name = "wall_block_low"

      while not HasAnimDictLoaded(dict) do
        Citizen.Wait(10)
        RequestAnimDict(dict)
      end

      RequestModel(prop)
      while not HasModelLoaded(prop) do
        Citizen.Wait(100)
      end

      local attachProps = CreateObject(prop, coords,  true,  false,  false)
      local netid = ObjToNet(attachProps)

      TaskPlayAnim(ped,dict,name,1.0,4.0,-1,49,0,0,0,0)
      AttachEntityToEntity(attachProps,ped,GetPedBoneIndex(ped, 57005),0.21,0.01,0.11,-72.0,85.0,80.0, false, false, false, true, 2, true)

      shield_net = netid
      shield = true
    else
      shield = false
      ClearPedSecondaryTask(GetPlayerPed(PlayerId()))
      SetModelAsNoLongerNeeded(prop)
      SetEntityAsMissionEntity(attachProps, true, false)
      DetachEntity(NetToObj(shield_net), 1, 1)
      DeleteEntity(NetToObj(shield_net))
      shield_net = nil
    end
  end)
end)

-- RegisterNetEvent("shield:ToggleFibShield")
-- AddEventHandler("shield:ToggleFibShield", function()
--   Citizen.CreateThread(function()
--     if not shield then
--       local ped = GetPlayerPed(-1)
--       local propName = "prop_jfib_shield"
--       local coords = GetEntityCoords(ped)
--       local prop = GetHashKey(propName)

--       local dict = "weapons@first_person@aim_rng@generic@light_machine_gun@combat_mg@"
--       local name = "wall_block_low"

--       while not HasAnimDictLoaded(dict) do
--         Citizen.Wait(10)
--         RequestAnimDict(dict)
--       end

--       RequestModel(prop)
--       while not HasModelLoaded(prop) do
--         Citizen.Wait(100)
--       end

--       local attachProps = CreateObject(prop, coords,  true,  false,  false)
--       local netid = ObjToNet(attachProps)

--       TaskPlayAnim(ped,dict,name,1.0,4.0,-1,49,0,0,0,0)
--       AttachEntityToEntity(attachProps,ped,GetPedBoneIndex(ped, 57005),0.21,0.01,0.11,-72.0,85.0,80.0, false, false, false, true, 2, true)

--       shield_net = netid
--       shield = true
--     else
--       shield = false
--       ClearPedSecondaryTask(GetPlayerPed(PlayerId()))
--       SetModelAsNoLongerNeeded(prop)
--       SetEntityAsMissionEntity(attachProps, true, false)
--       DetachEntity(NetToObj(shield_net), 1, 1)
--       DeleteEntity(NetToObj(shield_net))
--       shield_net = nil
--     end
--   end)
-- end)

RegisterNetEvent("shield:ToggleNooseShield")
AddEventHandler("shield:ToggleNooseShield", function()
  Citizen.CreateThread(function()
    if not shield then
      local ped = GetPlayerPed(-1)
      local propName = "prop_jnoose_shield"
      local coords = GetEntityCoords(ped)
      local prop = GetHashKey(propName)

      local dict = "weapons@first_person@aim_rng@generic@light_machine_gun@combat_mg@"
      local name = "wall_block_low"

      RequestAnimDict(dict)
      while not HasAnimDictLoaded(dict) do
        Citizen.Wait(10)
      end

      RequestModel(prop)
      while not HasModelLoaded(prop) do
        Citizen.Wait(100)
      end

      local attachProps = CreateObject(prop, coords,  true,  false,  false)
      local netid = ObjToNet(attachProps)

      TaskPlayAnim(ped,dict,name,1.0,4.0,-1,49,0,0,0,0)
      AttachEntityToEntity(attachProps,ped,GetPedBoneIndex(ped, 57005),0.21,0.01,0.11,-72.0,85.0,80.0, false, false, false, true, 2, true)

      shield_net = netid
      shield = true
    else
      shield = false
      ClearPedSecondaryTask(GetPlayerPed(PlayerId()))
      SetModelAsNoLongerNeeded(prop)
      SetEntityAsMissionEntity(attachProps, true, false)
      DetachEntity(NetToObj(shield_net), 1, 1)
      DeleteEntity(NetToObj(shield_net))
      shield_net = nil
    end
  end)
end)


Citizen.CreateThread(function()
  while true do
    local player = GetPlayerPed(-1)
    Citizen.Wait(0)
    if shield then
      NetworkSetFriendlyFireOption(true)
      SetCurrentPedWeapon(player,GetHashKey("WEAPON_CARBINERIFLE"),true)
      DisableControlAction(2, 25, true) -- Aim
      DisableControlAction(2, 37, true) -- disable weapon wheel (Tab)
      DisablePlayerFiring(player,true) -- Disables firing all together if they somehow bypass inzone Mouse Disable
      DisableControlAction(0, 106, true)
      DisableControlAction(2, 24, true)
      DisableControlAction(2, 257, true) -- Attack 2
      DisableControlAction(2, 263, true) -- Melee Attack 1
      SetPedConfigFlag(ped, 438, false)
    else
      Citizen.Wait(500)
    end
  end
end)

Citizen.CreateThread(function()
  local dict = "weapons@first_person@aim_rng@generic@light_machine_gun@combat_mg@"
  local name = "wall_block_low"
  while true do
      if shield then
          local ped = GetPlayerPed(-1)
          if not IsEntityPlayingAnim(ped, dict, name, 1) then
              RequestAnimDict(dict)
              while not HasAnimDictLoaded(dict) do
                  Citizen.Wait(100)
              end
              TaskPlayAnim(ped,dict,name,1.0,4.0,-1,49,0,0,0,0)
          end
      end
      Citizen.Wait(500)
  end
end)



