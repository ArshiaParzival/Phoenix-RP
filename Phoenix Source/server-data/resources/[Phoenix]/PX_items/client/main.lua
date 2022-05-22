ESX = nil
local CheckVehicle = false
local isLoggedIn = false
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	isLoggedIn = true
end)

RegisterNetEvent('esx_basicneeds:OnSmokeCigarett')
AddEventHandler('esx_basicneeds:OnSmokeCigarett', function()
	if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
		return
	end
	TaskStartScenarioInPlace(GetPlayerPed(-1), 'WORLD_HUMAN_SMOKING', 0, true)
	TriggerServerEvent('weaponry:server:remove:stress', 2)
end)

RegisterNetEvent('esx_customItems:useBlowtorch')
AddEventHandler('esx_customItems:useBlowtorch', function()
ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(quantity)
		if quantity > 0 then
			local vehicle = ESX.Game.GetVehicleInDirection(4)
			if DoesEntityExist(vehicle) then
				local playerPed = GetPlayerPed(-1)
				CheckVehicle = true
				checkvehicle(vehicle)
				  TriggerServerEvent('esx_customItems:remove', "blowtorch")
                  TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_WELDING", 0, true)
                  SetVehicleAlarm(vehicle, true)
                  StartVehicleAlarm(vehicle)
                  SetVehicleAlarmTimeLeft(vehicle, 40000)
                  TriggerEvent("mythic_progbar:client:progress", {
                    name = "baaz",
                    duration = 15000,
                    label = "Dar Hal Baaz Kardan Mashin...",
                    useWhileDead = false,
                    canCancel = true,
                    controlDisables = {
                        disableMovement = true,
                        disableCarMovement = true,
                        disableMouse = false,
                        disableCombat = true,
                    }
                }, function(status)
                    ClearPedTasksImmediately(playerPed)
                    if not status then
                        SetVehicleDoorsLocked(vehicle, 1)
                        SetVehiceleDoorsLockedForAllPlayers(vehicle, false)
                        ESX.ShowNotification("Mashin baz shod", 'success')
                    end
                    CheckVehicle = false
                end)
           else
                ESX.ShowNotification("Hich mashini nazdik shoma nist", 'error')
          end
		else
			ESX.ShowNotification("Shoma blowtorch nadarid", 'error')
		end
	end,'blowtorch')
end)
RegisterNetEvent('esx_customItems:checkVehicleDistance')
AddEventHandler('esx_customItems:checkVehicleDistance', function(vehicle)
	CheckVehicle = true
	checkvehicle(vehicle)
end)

RegisterNetEvent('esx_customItems:checkVehicleStatus')
AddEventHandler('esx_customItems:checkVehicleStatus', function(status)
	CheckVehicle = status
end)
function checkvehicle(vehicle)
	Citizen.CreateThread(function()
		while CheckVehicle do
		  Citizen.Wait(2000)
		  local coords = GetEntityCoords(GetPlayerPed(-1))
		  local NearVehicle = GetClosestVehicle(coords.x,  coords.y,  coords.z,  4.0,  0,  71)
			if vehicle ~= NearVehicle then
				ESX.ShowNotification("Mashin mored nazar az shoma ~r~door ~s~shod!", 'error')
				CheckVehicle = false
			end
		end
	  end)
end

RegisterNetEvent('PX_drugs:useItem')
AddEventHandler('PX_drugs:useItem', function(itemName)
    ESX.UI.Menu.CloseAll()
	if itemName == 'beer' then
        local lib, anim = 'amb@world_human_drinking@beer@male@idle_a', 'idle_a'
        local playerPed = PlayerPedId()
        ESX.Streaming.RequestAnimDict(lib, function()
            TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, 5000, 32, 0, false, false, false)
            Citizen.Wait(500)
            while IsEntityPlayingAnim(playerPed, lib, anim, 3) do
                Citizen.Wait(0)
                DisableAllControlActions(0)
            end
            TriggerEvent('PX_drugs:drunk')
        end)
		TriggerServerEvent('weaponry:server:remove:stress', 100)
    elseif itemName == 'vodka' then
        local lib, anim = 'amb@world_human_drinking@beer@male@idle_a', 'idle_a'
        local playerPed = PlayerPedId()
        ESX.Streaming.RequestAnimDict(lib, function()
            TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, 5000, 32, 0, false, false, false)
            Citizen.Wait(500)
            while IsEntityPlayingAnim(playerPed, lib, anim, 3) do
                Citizen.Wait(0)
                DisableAllControlActions(0)
            end
            TriggerEvent('PX_drugs:drunk')
        end)
		TriggerServerEvent('weaponry:server:remove:stress', 30)
    elseif itemName == 'whiskey' then
        local lib, anim = 'amb@world_human_drinking@beer@male@idle_a', 'idle_a'
        local playerPed = PlayerPedId()
        ESX.Streaming.RequestAnimDict(lib, function()
            TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, 5000, 32, 0, false, false, false)
            Citizen.Wait(500)
            while IsEntityPlayingAnim(playerPed, lib, anim, 3) do
                Citizen.Wait(0)
                DisableAllControlActions(0)
            end
            TriggerEvent('PX_drugs:drunk')
        end)
		TriggerServerEvent('weaponry:server:remove:stress', 50)
	elseif itemName == 'packagedmeth' then
        local lib, anim = 'anim@mp_player_intcelebrationmale@face_palm', 'face_palm'
        local playerPed = PlayerPedId()
        ESX.Streaming.RequestAnimDict(lib, function()
            TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, -1, 32, 0, false, false, false)
            Citizen.Wait(500)
            while IsEntityPlayingAnim(playerPed, lib, anim, 3) do
                Citizen.Wait(0)
                DisableAllControlActions(0)
            end
            TriggerEvent('PX_drugs:drunk')
        end)
	elseif itemName == 'packagedweed' then
        local lib, anim = 'anim@mp_player_intcelebrationmale@face_palm', 'face_palm'
        local playerPed = PlayerPedId()
        ESX.Streaming.RequestAnimDict(lib, function()
            TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, -1, 32, 0, false, false, false)
            Citizen.Wait(500)
            while IsEntityPlayingAnim(playerPed, lib, anim, 3) do
                Citizen.Wait(0)
                DisableAllControlActions(0)
            end
            TriggerEvent('PX_drugs:drunk')
        end)
	elseif itemName == 'packagedcoca' then
        local lib, anim = 'anim@mp_player_intcelebrationmale@face_palm', 'face_palm'
        local playerPed = PlayerPedId()
        ESX.Streaming.RequestAnimDict(lib, function()
            TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, -1, 32, 0, false, false, false)
            Citizen.Wait(500)
            while IsEntityPlayingAnim(playerPed, lib, anim, 3) do
                Citizen.Wait(0)
                DisableAllControlActions(0)
            end
            TriggerEvent('PX_drugs:drunk')
        end)
    end
end)

local onDrugs = false

RegisterNetEvent('PX_drugs:drunk')
AddEventHandler('PX_drugs:drunk', function()
	if not onDrugs then
		RequestAnimSet("move_m@hurry_butch@b")
		while not HasAnimSetLoaded("move_m@hurry_butch@b") do
			Citizen.Wait(0)
		end
		onDrugs = true
		count = 0
		DoScreenFadeOut(1000)
		Citizen.Wait(1000)
		SetPedMotionBlur(GetPlayerPed(-1), true)
		SetTimecycleModifier("spectator5")
		SetPedMovementClipset(GetPlayerPed(-1), "move_m@hurry_butch@b", true)
		SetRunSprintMultiplierForPlayer(PlayerId(), 0.8)
		DoScreenFadeIn(1000)
		repeat
			ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.1)
			TaskJump(GetPlayerPed(-1), false, true, false)
			Citizen.Wait(10000)
			count = count  + 1
		until count == 6
		DoScreenFadeOut(1000)
		Citizen.Wait(1000)
		DoScreenFadeIn(1000)
		ClearTimecycleModifier()
		ResetPedMovementClipset(GetPlayerPed(-1), 0)
		SetRunSprintMultiplierForPlayer(PlayerId(),1.0)
		ClearAllPedProps(GetPlayerPed(-1), true)
		SetPedMotionBlur(GetPlayerPed(-1), false)
		onDrugs = false
	end
end)

--weapon

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if isLoggedIn then
            local Weapon = GetSelectedPedWeapon(GetPlayerPed(-1))
            local WeaponBullets = GetAmmoInPedWeapon(GetPlayerPed(-1), Weapon)
            if Config.WeaponsList[Weapon] ~= nil and Config.WeaponsList[Weapon]['AmmoType'] ~= nil then
               if Config.WeaponsList[Weapon]['IdName'] ~= 'weapon_unarmed' then
                if IsPedShooting(GetPlayerPed(-1)) or IsPedPerformingMeleeAction(GetPlayerPed(-1)) then
                    if Config.WeaponsList[Weapon]['IdName'] == 'weapon_molotov' then
                        TriggerServerEvent('esx:RemoveItem', 'weapon_molotov', 1)
                        TriggerEvent('PX_weapons:client:set:current:weapon', nil)
                    else
                        TriggerServerEvent("PX_weapons:server:UpdateWeaponQuality", Config.CurrentWeaponData, 1)
                        if WeaponBullets == 1 then
                          TriggerServerEvent("PX_weapons:server:UpdateWeaponAmmo", Config.CurrentWeaponData, 1)
                        else
                          TriggerServerEvent("PX_weapons:server:UpdateWeaponAmmo", Config.CurrentWeaponData, tonumber(WeaponBullets))
                        end
                    end
                end
                if Config.WeaponsList[Weapon]['AmmoType'] ~= 'AMMO_FIRE' then
                  if IsPedArmed(GetPlayerPed(-1), 6) then
                    if WeaponBullets == 1 then
                        DisableControlAction(0, 24, true) 
                        DisableControlAction(0, 257, true)
                        if IsPedInAnyVehicle(GetPlayerPed(-1), true) then
                            SetPlayerCanDoDriveBy(PlayerId(), false)
                        end
                    else
                        EnableControlAction(0, 24, true) 
                        EnableControlAction(0, 257, true)
                        if IsPedInAnyVehicle(GetPlayerPed(-1), true) then
                            SetPlayerCanDoDriveBy(PlayerId(), true)
                        end
                    end
                  else
                      Citizen.Wait(1000)
                  end
                end
            else
                Citizen.Wait(1000)
            end
          end
        end
    end
end)

RegisterNetEvent('PX_weapons:client:set:current:weapon')
AddEventHandler('PX_weapons:client:set:current:weapon', function(data)
    if data ~= false then
        Config.CurrentWeaponData = data
    else
        Config.CurrentWeaponData = {}
    end
end)

RegisterNetEvent('PX_weapons:client:set:quality')
AddEventHandler('PX_weapons:client:set:quality', function(amount)
    if Config.CurrentWeaponData ~= nil and next(Config.CurrentWeaponData) ~= nil then
        TriggerServerEvent("PX_weapons:server:SetWeaponQuality", Config.CurrentWeaponData, amount)
    end
end)

RegisterNetEvent("PX_weapons:client:EquipAttachment")
AddEventHandler("PX_weapons:client:EquipAttachment", function(ItemData, attachment)
    local weapon = GetSelectedPedWeapon(GetPlayerPed(-1))
    local WeaponData = Config.WeaponsList[weapon]
    if weapon ~= GetHashKey("WEAPON_UNARMED") then
        WeaponData['IdName'] = WeaponData['IdName']:upper()
        if Config.WeaponAttachments[WeaponData['IdName']] ~= nil then
            if Config.WeaponAttachments[WeaponData['IdName']][attachment] ~= nil then
                TriggerServerEvent("PX_weapons:server:EquipAttachment", ItemData, Config.CurrentWeaponData, Config.WeaponAttachments[WeaponData['IdName']][attachment])
            else
                ESX.ShowNotification("This weapon does not support this attachment.", 'error')
            end
        end
    else
        ESX.ShowNotification("You don't have a weapon in your hand..", 'error')
    end
end)

RegisterNetEvent('PX_weapons:client:reload:ammo')
AddEventHandler('PX_weapons:client:reload:ammo', function(AmmoType, AmmoName)
 local Weapon = GetSelectedPedWeapon(GetPlayerPed(-1))
 local WeaponBullets = GetAmmoInPedWeapon(GetPlayerPed(-1), Weapon)
 if Config.WeaponsList[Weapon] ~= nil and Config.WeaponsList[Weapon]['AmmoType'] ~= nil then
 local NewAmmo = WeaponBullets + Config.WeaponsList[Weapon]['MaxAmmo']
 if Config.WeaponsList[Weapon]['AmmoType'] == AmmoType then
    if WeaponBullets <= (NewAmmo/2) then
		TriggerEvent("mythic_progbar:client:progress", {
            name = "reload",
            duration = 5000,
            label = "Reloading...",
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
                SetAmmoInClip(GetPlayerPed(-1), Weapon, 0)
				SetPedAmmo(GetPlayerPed(-1), Weapon, NewAmmo)
				TriggerServerEvent('esx:RemoveItem', AmmoName, 1)
				TriggerServerEvent("PX_weapons:server:UpdateWeaponAmmo", Config.CurrentWeaponData, tonumber(NewAmmo))
            end
        end)
    else
        ESX.ShowNotification("You already have bullets loaded.", 'error')
    end
  end
 end
end)

RegisterNetEvent('PX_weapons:client:set:ammo')
AddEventHandler('PX_weapons:client:set:ammo', function(Amount)
 local Weapon = GetSelectedPedWeapon(GetPlayerPed(-1))
 local WeaponBullets = GetAmmoInPedWeapon(GetPlayerPed(-1), Weapon)
 local NewAmmo = WeaponBullets + tonumber(Amount)
 if Config.WeaponsList[Weapon] ~= nil and Config.WeaponsList[Weapon]['AmmoType'] ~= nil then
  SetAmmoInClip(GetPlayerPed(-1), Weapon, 0)
  SetPedAmmo(GetPlayerPed(-1), Weapon, tonumber(NewAmmo))
  TriggerServerEvent("PX_weapons:server:UpdateWeaponAmmo", Config.CurrentWeaponData, tonumber(NewAmmo))
  ESX.ShowNotification("Successful "..Amount..'x bullets ('..Config.WeaponsList[Weapon]['Name']..')', "success")
 end
end)

RegisterNetEvent("PX_weapons:client:addAttachment")
AddEventHandler("PX_weapons:client:addAttachment", function(component)
 local weapon = GetSelectedPedWeapon(GetPlayerPed(-1))
 local WeaponData = Config.WeaponsList[weapon]
 GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey(WeaponData['IdName']), GetHashKey(component))
end)

function GetAmmoType(Weapon)
 if Config.WeaponsList[Weapon] ~= nil then
     return Config.WeaponsList[Weapon]['AmmoType']
 end
end