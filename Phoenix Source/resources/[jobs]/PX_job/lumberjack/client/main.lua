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
  
  local start = false
  local khord = false
  local baste = false
  local duty = false
  local spwaned = false
  ESX = nil
  
  Citizen.CreateThread(function()
	  while ESX == nil do
		  TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		  Citizen.Wait(0)
	  end
	  TriggerServerEvent("EZ_Pixel:lumberjack:ImLoaded")
  end)
  
CodeLJ = nil
GotLJ = false
RegisterNetEvent("EZ_Pixel:lumberjack:sendCode")
AddEventHandler("EZ_Pixel:lumberjack:sendCode", function(code)
	if not GotLJ then
    	CodeLJ = code
		GotLJ = true
	else
		ForceSocialClubUpdate()
	end
end)

  function DisplayHelpText(str)
	  SetTextComponentFormat("STRING")
	  AddTextComponentString(str)
	  DisplayHelpTextFromStringLabel(0, 0, 1, -1)
  end

  function animazione()
	  local ped = PlayerPedId()
  
	  RequestAnimDict("melee@hatchet@streamed_core")
	  while (not HasAnimDictLoaded("melee@hatchet@streamed_core")) do Citizen.Wait(0) end
	  Wait(1500)
  
	  TaskPlayAnim(ped, "melee@hatchet@streamed_core", "plyr_front_takedown", 8.0, -8.0, -1, 0, 0, false, false, false) 
  end
  
  function animazione2()
	  local ped = PlayerPedId()
  
	  RequestAnimDict("melee@hatchet@streamed_core")
	  while (not HasAnimDictLoaded("melee@hatchet@streamed_core")) do Citizen.Wait(0) end
	  Wait(1500)
  
	  TaskPlayAnim(ped, "melee@hatchet@streamed_core", "plyr_front_takedown_b", 8.0, -8.0, -1, 0, 0, false, false, false) 
  end
  
  function animazionetavole()
	  local ped = PlayerPedId()
	  local prop_name = prop_name or 'prop_cs_cardbox_01'
	  tavola = CreateObject(GetHashKey(prop_name), -501.38, 5280.53, 79.61, true, true, true)
  
	  RequestAnimDict("anim@heists@box_carry@")
	  while (not HasAnimDictLoaded("anim@heists@box_carry@")) do Citizen.Wait(0) end
	  Wait(1500)
  
	  TaskPlayAnim(ped, "anim@heists@box_carry@", "idle", 8.0, -8.0, -1, 0, 0, false, false, false)
	  AttachEntityToEntity(tavola, PlayerPedId(), GetPedBoneIndex(PlayerPedId(),  28422), 0.0, -0.03, 0.0, 5.0, 0.0, 0.0, 1, 1, 0, 1, 0, 1) 
	  Wait(5000)
	  TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_BUM_BIN", 0, false)
	  DetachEntity(tavola, false, false)
	  PlaceObjectOnGroundProperly(tavola)
	  Wait(15000)
	  DeleteEntity(tavola)
	  ClearPedTasksImmediately(PlayerPedId())
  end
  
  istgah = false
  istgah2 = false
  istgah3 = false
  istgah4 = false
  istgah5 = false
  istgah6 = false
  istgah7 = false
  istgah8 = false
  istgah9 = false
  istgah10 = false
  
  function armadietto()
	  ESX.UI.Menu.CloseAll()
  
	  ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cloakroom',
	  {
		  title    = 'Locker',
		  align = 'bottom-right',
		  elements = {
			  {label = 'On Duty',     value = 'job_wear'},
			  {label = 'Off Duty', value = 'citizen_wear'}
		  }
	  }, function(data, menu)
		  if data.current.value == 'citizen_wear' then
			  duty = false
		  elseif data.current.value == 'job_wear' then
			  duty = true
			  ESX.ShowNotification("Shoma Job Ra Start Kardid. Az Posht Mashin Begirid!", 'info')
  
		  end
		  menu.close()
	  end, function(data, menu)
		  menu.close()
	  end)
  end
  
  Citizen.CreateThread(function()
	  while true do
  
		  Citizen.Wait(1)
  
		  -- if PlayerData.job ~= nil and (PlayerData.job.name == 'lumberjack') then
  
			  local playerPed = PlayerPedId()
			  local coords    = GetEntityCoords(playerPed)
			  
			  if GetDistanceBetweenCoords(coords, 1200.63, -1276.87, 34.38, true) < 15.0 then
				  if GetDistanceBetweenCoords(coords, 1200.63, -1276.87, 34.38, true) < 1.75 then
					  ESX.Game.Utils.DrawText3D(vector3(1200.63, -1276.87, 35.38), "Press [E] Baraye Baz Kardan Menu", 0.4)
					  if IsControlJustReleased(1, 51) then
						  armadietto()
					  end
				  end
			  else
				  Citizen.Wait(3000)
			  end
		  
		  -- end
	  end
  end)
  
  Citizen.CreateThread(function()
	  while true do
		  local playerPed = PlayerPedId()
		  local pos = GetEntityCoords(playerPed, true)
  
		  -- if PlayerData.job ~= nil and (PlayerData.job.name == 'lumberjack') then
			  if (GetDistanceBetweenCoords(pos, -534.32, 5373.79, 69.50) < 15.0) then
				  if not start and duty and IsPedSittingInAnyVehicle(playerPed) then
					  local cVeh = GetVehiclePedIsUsing(playerPed, false)
					  local vehicle = GetHashKey('bison2')
					  if GetEntityModel(cVeh) == vehicle then
					  DrawMarker(11, -534.32, 5373.79, 70.50, 0, 0, 0, 0, 0, 0, 0.8, 0.8, 0.8, 0, 255, 0, 150, 0, true, 2, 0, 0, 0, 0)
					  if (GetDistanceBetweenCoords(pos, -534.32, 5373.79, 69.50) < 5.75) then
						  drawTxt('Press [E] Baraye Shoro')
						  if IsControlJustReleased(1, 51) then
							--   ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(quantity)
							-- 	  local futuroinventario = math.floor(quantity + LJConfig.Wood )
								--   if quantity <= 250 and futuroinventario <= 250 then
							  start = true
							  ESX.ShowNotification("10 Derakht Robro Ra Ghate Konid!", 'info')
							  local prop_name = prop_name or 'Prop_Tree_Cedar_03'
							  derakht = CreateObject(GetHashKey(prop_name), -511.607, 5401.295, 72.904,  true, true, true)
							  FreezeEntityPosition(derakht, true)
							  derakht2 = CreateObject(GetHashKey(prop_name), -499.199, 5390.437, 74.658,  true, true, true)
							  FreezeEntityPosition(derakht2, true)
							  derakht3 = CreateObject(GetHashKey(prop_name), -487.308, 5391.439, 75.976,  true, true, true)
							  FreezeEntityPosition(derakht3, true)
							  derakht4 = CreateObject(GetHashKey(prop_name), -516.813, 5382.376, 69.32,  true, true, true)
							  FreezeEntityPosition(derakht4, true)
							  derakht5 = CreateObject(GetHashKey(prop_name), -519.28, 5390.956, 69.314,  true, true, true)
							  FreezeEntityPosition(derakht5, true)
							  derakht6 = CreateObject(GetHashKey(prop_name), -520.488, 5396.993, 70.954,  true, true, true)
							  FreezeEntityPosition(derakht6, true)
							  derakht7 = CreateObject(GetHashKey(prop_name), -489.21, 5387.261, 75.823,  true, true, true)
							  FreezeEntityPosition(derakht7, true)
							  derakht8 = CreateObject(GetHashKey(prop_name), -483.748, 5387.838, 76.445,  true, true, true)
							  FreezeEntityPosition(derakht8, true)
							  derakht9 = CreateObject(GetHashKey(prop_name), -489.176, 5396.343, 75.545,  true, true, true)
							  FreezeEntityPosition(derakht9, true)
							  derakht10 = CreateObject(GetHashKey(prop_name), -466.356, 5396.036, 77.17,  true, true, true)
							  FreezeEntityPosition(derakht10, true)
							--   else
							--   ESX.ShowNotification("Fazaye Khali Nadarid!")
							--   end
						--   end, 'packaged_plank')
					  end
					  end
				  end
				  end
			  else
				  Citizen.Wait(3000)
			  end
		  -- end
  
		  while start do
			  local coords = GetEntityCoords(GetPlayerPed(-1))
  
			  Citizen.Wait(5)
				  if(GetDistanceBetweenCoords(coords, -512.53, 5401.51, 74.779, true) < 15.0) and not istgah then  
					  DrawMarker(20, -512.53, 5401.51, 74.779, 0, 0, 0, 0, 0, 0, 0.8, 0.8, 0.8, 255, 15, 15, 150, 0, true, 2, 0, 0, 0, 0)
					  if(GetDistanceBetweenCoords(coords, -512.53, 5401.51, 74.779, true) < 1.0) then
						  drawTxt('Press [E] Baraye Ghate Kardan Derakht')
						  if IsControlJustPressed(0, 38) then
							  SetEntityCoords(GetPlayerPed(-1), -512.53, 5401.51, 74.779-0.95) 
							  SetEntityHeading(GetPlayerPed(-1), 248.867)
							  FreezeEntityPosition(playerPed, true)
							  GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_HATCHET"),0, true, true)
							   istgah = true 
							   SetCurrentPedWeapon(playerPed, GetHashKey("WEAPON_HATCHET"), false)
							   animazione()
							   Wait(2000)
							   animazione()
							   Wait(2000)
							   animazione2()
							   Wait(2000)
							   SetEntityRotation(derakht, 10.0, -0, 85.0, false, true)
							   Citizen.Wait(100)
							   SetEntityRotation(derakht, 20.0, -0, 85.0, false, true)
							   Citizen.Wait(100)
							   SetEntityRotation(derakht, 30.0, -0, 85.0, false, true)
							   Citizen.Wait(100)
							   SetEntityRotation(derakht, 40.0, -0, 85.0, false, true)
							   Citizen.Wait(100)
							   SetEntityRotation(derakht, 50.0, -0, 85.0, false, true)
							   Citizen.Wait(100)
							   SetEntityRotation(derakht, 60.0, -0, 85.0, false, true)
							   Citizen.Wait(100)
							   SetEntityRotation(derakht, 70.0, -0, 85.0, false, true)
							   Citizen.Wait(100)
							   SetEntityRotation(derakht, 80.0, -0, 85.0, false, true)
							   Citizen.Wait(100)
							   FreezeEntityPosition(playerPed, false)
							   RemoveWeaponFromPed(PlayerPedId(), GetHashKey("WEAPON_HATCHET"), true, true)
							   DeleteObject(derakht)
						  end
					  end
				  end
				  if(GetDistanceBetweenCoords(coords, -500.231, 5390.323, 76.548, true) < 15.0) and not istgah2 then  
					  DrawMarker(20, -500.231, 5390.323, 76.548, 0, 0, 0, 0, 0, 0, 0.8, 0.8, 0.8, 255, 15, 15, 150, 0, true, 2, 0, 0, 0, 0)
					  if(GetDistanceBetweenCoords(coords, -500.231, 5390.323, 76.548, true) < 1.0) then
						  drawTxt('Press [E] Baraye Ghate Kardan Derakht')
						  if IsControlJustPressed(0, 38) then
							  SetEntityCoords(GetPlayerPed(-1), -500.231, 5390.323, 76.548-0.95) 
							  SetEntityHeading(GetPlayerPed(-1), 275.492)
							  FreezeEntityPosition(playerPed, true)
							  GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_HATCHET"),0, true, true)
							   istgah2 = true 
							   animazione()
							   Wait(2000)
							   animazione()
							   Wait(2000)
							   animazione2()
							   Wait(2000)
							   SetEntityRotation(derakht2, 10.0, -0, 85.0, false, true)
							   Citizen.Wait(100)
							   SetEntityRotation(derakht2, 20.0, -0, 85.0, false, true)
							   Citizen.Wait(100)
							   SetEntityRotation(derakht2, 30.0, -0, 85.0, false, true)
							   Citizen.Wait(100)
							   SetEntityRotation(derakht2, 40.0, -0, 85.0, false, true)
							   Citizen.Wait(100)
							   SetEntityRotation(derakht2, 50.0, -0, 85.0, false, true)
							   Citizen.Wait(100)
							   SetEntityRotation(derakht2, 60.0, -0, 85.0, false, true)
							   Citizen.Wait(100)
							   SetEntityRotation(derakht2, 70.0, -0, 85.0, false, true)
							   Citizen.Wait(100)
							   SetEntityRotation(derakht2, 80.0, -0, 85.0, false, true)
							   Citizen.Wait(100)
							   FreezeEntityPosition(playerPed, false)
							   RemoveWeaponFromPed(PlayerPedId(), GetHashKey("WEAPON_HATCHET"), true, true)
							   DeleteObject(derakht2)
						  end
					  end
				  end
				  if(GetDistanceBetweenCoords(coords, -488.37, 5391.05, 77.902, true) < 15.0) and not istgah3 then  
					  DrawMarker(20, -488.37, 5391.05, 77.902, 0, 0, 0, 0, 0, 0, 0.8, 0.8, 0.8, 255, 15, 15, 150, 0, true, 2, 0, 0, 0, 0)
					  if(GetDistanceBetweenCoords(coords, -488.37, 5391.05, 77.902, true) < 1.0) then
						  drawTxt('Press [E] Baraye Ghate Kardan Derakht')
						  if IsControlJustPressed(0, 38) then
							  SetEntityCoords(GetPlayerPed(-1), -488.37, 5391.05, 77.902-0.95) 
							  SetEntityHeading(GetPlayerPed(-1), 283.681)
							  FreezeEntityPosition(playerPed, true)
							  GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_HATCHET"),0, true, true)
							   istgah3 = true 
							   animazione()
							   Wait(2000)
							   animazione()
							   Wait(2000)
							   animazione2()
							   Wait(2000)
							   SetEntityRotation(derakht3, 10.0, -0, 85.0, false, true)
							   Citizen.Wait(100)
							   SetEntityRotation(derakht3, 20.0, -0, 85.0, false, true)
							   Citizen.Wait(100)
							   SetEntityRotation(derakht3, 30.0, -0, 85.0, false, true)
							   Citizen.Wait(100)
							   SetEntityRotation(derakht3, 40.0, -0, 85.0, false, true)
							   Citizen.Wait(100)
							   SetEntityRotation(derakht3, 50.0, -0, 85.0, false, true)
							   Citizen.Wait(100)
							   SetEntityRotation(derakht3, 60.0, -0, 85.0, false, true)
							   Citizen.Wait(100)
							   SetEntityRotation(derakht3, 70.0, -0, 85.0, false, true)
							   Citizen.Wait(100)
							   SetEntityRotation(derakht3, 80.0, -0, 85.0, false, true)
							   Citizen.Wait(100)
							   FreezeEntityPosition(playerPed, false)
							   RemoveWeaponFromPed(PlayerPedId(), GetHashKey("WEAPON_HATCHET"), true, true)
							   DeleteObject(derakht3)
						  end
					  end
				  end
				  if(GetDistanceBetweenCoords(coords, -520.694, 5390.795, 71.12, true) < 15.0) and not istgah5 then  
					  DrawMarker(20, -520.694, 5390.795, 71.12, 0, 0, 0, 0, 0, 0, 0.8, 0.8, 0.8, 255, 15, 15, 150, 0, true, 2, 0, 0, 0, 0)
					  if(GetDistanceBetweenCoords(coords, -520.694, 5390.795, 71.12, true) < 1.0) then
						  drawTxt('Press [E] Baraye Ghate Kardan Derakht')
						  if IsControlJustPressed(0, 38) then
							  SetEntityCoords(GetPlayerPed(-1), -520.694, 5390.795, 71.12-0.95) 
							  SetEntityHeading(GetPlayerPed(-1), 279.34)
							  FreezeEntityPosition(playerPed, true)
							  GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_HATCHET"),0, true, true)
							   istgah5 = true 
							   animazione()
							   Wait(2000)
							   animazione()
							   Wait(2000)
							   animazione2()
							   Wait(2000)
							   SetEntityRotation(derakht5, 10.0, -0, 85.0, false, true)
							   Citizen.Wait(100)
							   SetEntityRotation(derakht5, 20.0, -0, 85.0, false, true)
							   Citizen.Wait(100)
							   SetEntityRotation(derakht5, 30.0, -0, 85.0, false, true)
							   Citizen.Wait(100)
							   SetEntityRotation(derakht5, 40.0, -0, 85.0, false, true)
							   Citizen.Wait(100)
							   SetEntityRotation(derakht5, 50.0, -0, 85.0, false, true)
							   Citizen.Wait(100)
							   SetEntityRotation(derakht5, 60.0, -0, 85.0, false, true)
							   Citizen.Wait(100)
							   SetEntityRotation(derakht5, 70.0, -0, 85.0, false, true)
							   Citizen.Wait(100)
							   SetEntityRotation(derakht5, 80.0, -0, 85.0, false, true)
							   Citizen.Wait(100)
							   FreezeEntityPosition(playerPed, false)
							   RemoveWeaponFromPed(PlayerPedId(), GetHashKey("WEAPON_HATCHET"), true, true)
							   DeleteObject(derakht4)
						  end
					  end
				  end
				  if(GetDistanceBetweenCoords(coords, -518.188, 5381.749, 71.158, true) < 15.0) and not istgah4 then  
					  DrawMarker(20, -518.188, 5381.749, 71.158, 0, 0, 0, 0, 0, 0, 0.8, 0.8, 0.8, 255, 15, 15, 150, 0, true, 2, 0, 0, 0, 0)
					  if(GetDistanceBetweenCoords(coords, -518.188, 5381.749, 71.158, true) < 1.0) then
						  drawTxt('Press [E] Baraye Ghate Kardan Derakht')
						  if IsControlJustPressed(0, 38) then
							  SetEntityCoords(GetPlayerPed(-1), -518.188, 5381.749, 71.158-0.95) 
							  SetEntityHeading(GetPlayerPed(-1), 290.974)
							  FreezeEntityPosition(playerPed, true)
							  GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_HATCHET"),0, true, true)
							   istgah4 = true 
							   animazione()
							   Wait(2000)
							   animazione()
							   Wait(2000)
							   animazione2()
							   Wait(2000)
							   SetEntityRotation(derakht4, 10.0, -0, 85.0, false, true)
							   Citizen.Wait(100)
							   SetEntityRotation(derakht4, 20.0, -0, 85.0, false, true)
							   Citizen.Wait(100)
							   SetEntityRotation(derakht4, 30.0, -0, 85.0, false, true)
							   Citizen.Wait(100)
							   SetEntityRotation(derakht4, 40.0, -0, 85.0, false, true)
							   Citizen.Wait(100)
							   SetEntityRotation(derakht4, 50.0, -0, 85.0, false, true)
							   Citizen.Wait(100)
							   SetEntityRotation(derakht4, 60.0, -0, 85.0, false, true)
							   Citizen.Wait(100)
							   SetEntityRotation(derakht4, 70.0, -0, 85.0, false, true)
							   Citizen.Wait(100)
							   SetEntityRotation(derakht4, 80.0, -0, 85.0, false, true)
							   Citizen.Wait(100)
							   FreezeEntityPosition(playerPed, false)
							   RemoveWeaponFromPed(PlayerPedId(), GetHashKey("WEAPON_HATCHET"), true, true)
							   DeleteObject(derakht5)
						  end
					  end
				  end
				  if(GetDistanceBetweenCoords(coords, -521.541, 5396.87, 72.725, true) < 15.0) and not istgah6 then  
					  DrawMarker(20, -521.541, 5396.87, 72.725, 0, 0, 0, 0, 0, 0, 0.8, 0.8, 0.8, 255, 15, 15, 150, 0, true, 2, 0, 0, 0, 0)
					  if(GetDistanceBetweenCoords(coords, -521.541, 5396.87, 72.725, true) < 1.0) then
						  drawTxt('Press [E] Baraye Ghate Kardan Derakht')
						  if IsControlJustPressed(0, 38) then
							  SetEntityCoords(GetPlayerPed(-1), -521.541, 5396.87, 72.725-0.95) 
							  SetEntityHeading(GetPlayerPed(-1), 276.57)
							  FreezeEntityPosition(playerPed, true)
							  GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_HATCHET"),0, true, true)
							   istgah6 = true 
							   animazione()
							   Wait(2000)
							   animazione()
							   Wait(2000)
							   animazione2()
							   Wait(2000)
							   SetEntityRotation(derakht6, 10.0, -0, 85.0, false, true)
							   Citizen.Wait(100)
							   SetEntityRotation(derakht6, 20.0, -0, 85.0, false, true)
							   Citizen.Wait(100)
							   SetEntityRotation(derakht6, 30.0, -0, 85.0, false, true)
							   Citizen.Wait(100)
							   SetEntityRotation(derakht6, 40.0, -0, 85.0, false, true)
							   Citizen.Wait(100)
							   SetEntityRotation(derakht6, 50.0, -0, 85.0, false, true)
							   Citizen.Wait(100)
							   SetEntityRotation(derakht6, 60.0, -0, 85.0, false, true)
							   Citizen.Wait(100)
							   SetEntityRotation(derakht6, 70.0, -0, 85.0, false, true)
							   Citizen.Wait(100)
							   SetEntityRotation(derakht6, 80.0, -0, 85.0, false, true)
							   Citizen.Wait(100)
							   FreezeEntityPosition(playerPed, false)
							   RemoveWeaponFromPed(PlayerPedId(), GetHashKey("WEAPON_HATCHET"), true, true)
							   DeleteObject(derakht6)
						  end
					  end
				  end
				  if(GetDistanceBetweenCoords(coords, -490.393, 5387.453, 77.673, true) < 15.0) and not istgah7 then  
					  DrawMarker(20, -490.393, 5387.453, 77.673, 0, 0, 0, 0, 0, 0, 0.8, 0.8, 0.8, 255, 15, 15, 150, 0, true, 2, 0, 0, 0, 0)
					  if(GetDistanceBetweenCoords(coords, -490.393, 5387.453, 77.673, true) < 1.0) then
						  drawTxt('Press [E] Baraye Ghate Kardan Derakht')
						  if IsControlJustPressed(0, 38) then
							  SetEntityCoords(GetPlayerPed(-1), -490.393, 5387.453, 77.673-0.95) 
							  SetEntityHeading(GetPlayerPed(-1), 253.624)
							  FreezeEntityPosition(playerPed, true)
							  GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_HATCHET"),0, true, true)
							   istgah7 = true 
							   animazione()
							   Wait(2000)
							   animazione()
							   Wait(2000)
							   animazione2()
							   Wait(2000)
							   SetEntityRotation(derakht7, 10.0, -0, 85.0, false, true)
							   Citizen.Wait(100)
							   SetEntityRotation(derakht7, 20.0, -0, 85.0, false, true)
							   Citizen.Wait(100)
							   SetEntityRotation(derakht7, 30.0, -0, 85.0, false, true)
							   Citizen.Wait(100)
							   SetEntityRotation(derakht7, 40.0, -0, 85.0, false, true)
							   Citizen.Wait(100)
							   SetEntityRotation(derakht7, 50.0, -0, 85.0, false, true)
							   Citizen.Wait(100)
							   SetEntityRotation(derakht7, 60.0, -0, 85.0, false, true)
							   Citizen.Wait(100)
							   SetEntityRotation(derakht7, 70.0, -0, 85.0, false, true)
							   Citizen.Wait(100)
							   SetEntityRotation(derakht7, 80.0, -0, 85.0, false, true)
							   Citizen.Wait(100)
							   FreezeEntityPosition(playerPed, false)
							   RemoveWeaponFromPed(PlayerPedId(), GetHashKey("WEAPON_HATCHET"), true, true)
							   DeleteObject(derakht7)
						  end
					  end
				  end
				  if(GetDistanceBetweenCoords(coords, -484.889, 5388.283, 78.306, true) < 15.0) and not istgah8 then  
					  DrawMarker(20, -484.889, 5388.283, 78.306, 0, 0, 0, 0, 0, 0, 0.8, 0.8, 0.8, 255, 15, 15, 150, 0, true, 2, 0, 0, 0, 0)
					  if(GetDistanceBetweenCoords(coords, -484.889, 5388.283, 78.306, true) < 1.0) then
						  drawTxt('Press [E] Baraye Ghate Kardan Derakht')
						  if IsControlJustPressed(0, 38) then
							  SetEntityCoords(GetPlayerPed(-1), -484.889, 5388.283, 78.306-0.95) 
							  SetEntityHeading(GetPlayerPed(-1), 241.943)
							  FreezeEntityPosition(playerPed, true)
							  GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_HATCHET"),0, true, true)
							   istgah8 = true 
							   animazione()
							   Wait(2000)
							   animazione()
							   Wait(2000)
							   animazione2()
							   Wait(2000)
							   SetEntityRotation(derakht8, 10.0, -0, 85.0, false, true)
							   Citizen.Wait(100)
							   SetEntityRotation(derakht8, 20.0, -0, 85.0, false, true)
							   Citizen.Wait(100)
							   SetEntityRotation(derakht8, 30.0, -0, 85.0, false, true)
							   Citizen.Wait(100)
							   SetEntityRotation(derakht8, 40.0, -0, 85.0, false, true)
							   Citizen.Wait(100)
							   SetEntityRotation(derakht8, 50.0, -0, 85.0, false, true)
							   Citizen.Wait(100)
							   SetEntityRotation(derakht8, 60.0, -0, 85.0, false, true)
							   Citizen.Wait(100)
							   SetEntityRotation(derakht8, 70.0, -0, 85.0, false, true)
							   Citizen.Wait(100)
							   SetEntityRotation(derakht8, 80.0, -0, 85.0, false, true)
							   Citizen.Wait(100)
							   FreezeEntityPosition(playerPed, false)
							   RemoveWeaponFromPed(PlayerPedId(), GetHashKey("WEAPON_HATCHET"), true, true)
							   DeleteObject(derakht8)
						  end
					  end
				  end
				  if(GetDistanceBetweenCoords(coords, -490.305, 5396.294, 77.419, true) < 15.0) and not istgah9 then  
					  DrawMarker(20, -490.305, 5396.294, 77.419, 0, 0, 0, 0, 0, 0, 0.8, 0.8, 0.8, 255, 15, 15, 150, 0, true, 2, 0, 0, 0, 0)
					  if(GetDistanceBetweenCoords(coords, -490.305, 5396.294, 77.419, true) < 1.0) then
						  drawTxt('Press [E] Baraye Ghate Kardan Derakht')
						  if IsControlJustPressed(0, 38) then
							  SetEntityCoords(GetPlayerPed(-1), -490.305, 5396.294, 77.419-0.95) 
							  SetEntityHeading(GetPlayerPed(-1), 268.013)
							  FreezeEntityPosition(playerPed, true)
							  GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_HATCHET"),0, true, true)
							   istgah9 = true 
							   animazione()
							   Wait(2000)
							   animazione()
							   Wait(2000)
							   animazione2()
							   Wait(2000)
							   SetEntityRotation(derakht9, 10.0, -0, 85.0, false, true)
							   Citizen.Wait(100)
							   SetEntityRotation(derakht9, 20.0, -0, 85.0, false, true)
							   Citizen.Wait(100)
							   SetEntityRotation(derakht9, 30.0, -0, 85.0, false, true)
							   Citizen.Wait(100)
							   SetEntityRotation(derakht9, 40.0, -0, 85.0, false, true)
							   Citizen.Wait(100)
							   SetEntityRotation(derakht9, 50.0, -0, 85.0, false, true)
							   Citizen.Wait(100)
							   SetEntityRotation(derakht9, 60.0, -0, 85.0, false, true)
							   Citizen.Wait(100)
							   SetEntityRotation(derakht9, 70.0, -0, 85.0, false, true)
							   Citizen.Wait(100)
							   SetEntityRotation(derakht9, 80.0, -0, 85.0, false, true)
							   Citizen.Wait(100)
							   FreezeEntityPosition(playerPed, false)
							   RemoveWeaponFromPed(PlayerPedId(), GetHashKey("WEAPON_HATCHET"), true, true)
							   DeleteObject(derakht9)
						  end
					  end
				  end
				  if(GetDistanceBetweenCoords(coords, -467.563, 5396.129, 79.102, true) < 15.0) and not istgah10 then  
					  DrawMarker(20, -467.563, 5396.129, 79.102, 0, 0, 0, 0, 0, 0, 0.8, 0.8, 0.8, 255, 15, 15, 150, 0, true, 2, 0, 0, 0, 0)
					  if(GetDistanceBetweenCoords(coords, -467.563, 5396.129, 79.102, true) < 1.0) then
						  drawTxt('Press [E] Baraye Ghate Kardan Derakht')
						  if IsControlJustPressed(0, 38) then
							  SetEntityCoords(GetPlayerPed(-1), -467.563, 5396.129, 79.102-0.95) 
							  SetEntityHeading(GetPlayerPed(-1), 256.945)
							  FreezeEntityPosition(playerPed, true)
							  GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_HATCHET"),0, true, true)
							   istgah10 = true 
							   animazione()
							   Wait(2000)
							   animazione()
							   Wait(2000)
							   animazione2()
							   Wait(2000)
							   SetEntityRotation(derakht10, 10.0, -0, 85.0, false, true)
							   Citizen.Wait(100)
							   SetEntityRotation(derakht10, 20.0, -0, 85.0, false, true)
							   Citizen.Wait(100)
							   SetEntityRotation(derakht10, 30.0, -0, 85.0, false, true)
							   Citizen.Wait(100)
							   SetEntityRotation(derakht10, 40.0, -0, 85.0, false, true)
							   Citizen.Wait(100)
							   SetEntityRotation(derakht10, 50.0, -0, 85.0, false, true)
							   Citizen.Wait(100)
							   SetEntityRotation(derakht10, 60.0, -0, 85.0, false, true)
							   Citizen.Wait(100)
							   SetEntityRotation(derakht10, 70.0, -0, 85.0, false, true)
							   Citizen.Wait(100)
							   SetEntityRotation(derakht10, 80.0, -0, 85.0, false, true)
							   Citizen.Wait(100)
							   FreezeEntityPosition(playerPed, false)
							   RemoveWeaponFromPed(PlayerPedId(), GetHashKey("WEAPON_HATCHET"), true, true)
							   DeleteObject(derakht10)
						  end
					  end
				  end
			  if istgah == true and istgah2 == true and istgah3 == true and istgah4 == true and istgah5 == true and istgah6 == true and istgah7 == true and istgah8 == true and istgah9 == true and istgah10 == true then
				  RemoveWeaponFromPed(PlayerPedId(), GetHashKey("WEAPON_HATCHET"), true, true)
				  Wait(1000)
				  TriggerServerEvent('parzival_lumberjack:gereftanchoob', CodeLJ)
				  start = false
				  istgah = false
				  istgah2 = false
				  istgah3 = false
				  istgah4 = false
				  istgah5 = false
				  istgah6 = false
				  istgah7 = false
				  istgah8 = false
				  istgah9 = false
				  istgah10 = false
				  ESX.ShowNotification("Agar Mikhahid choob beborid be 1 baragrdid vagarna be noghte badi beravid!")
			  end
		  end
		  Citizen.Wait(0)
	  end
  end)
  
  Citizen.CreateThread(function()
	  while true do
		  local playerPed = PlayerPedId()
		  local pos = GetEntityCoords(playerPed, true)
		  -- if PlayerData.job ~= nil and (PlayerData.job.name == 'lumberjack') then
			  if (GetDistanceBetweenCoords(pos, -554.42, 5370.554, 70.317) < 15.0) and not khord and not start and duty then
				  DrawMarker(12, -554.42, 5370.554, 70.317, 0, 0, 0, 0, 0, 0, 0.8, 0.8, 0.8, 0, 255, 0, 150, 0, true, 2, 0, 0, 0, 0)
				  if (GetDistanceBetweenCoords(pos, -554.42, 5370.554, 70.317) < 0.75) then
					  drawTxt('Press [E] Baraye Ghetee Kardan')
					  if IsControlJustReleased(0, Keys['E']) then
						  khord = true
						--   ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(quantity)
						-- 	  if quantity <= 250 then
						-- 		  ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(quantity)
						-- 			  if quantity >= 50 then
						-- 				  ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(quantity)
						-- 					  local futuroinventario2 = math.floor(quantity + 50)
						-- 					  if futuroinventario2 <= 250 then
												SetEntityCoords(GetPlayerPed(-1), -554.42, 5370.554, 70.317-0.95) 
												SetEntityHeading(GetPlayerPed(-1), 256.706)
												GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_HATCHET"),0, true, true)
												FreezeEntityPosition(playerPed, true)
												animazione()
												Wait(2000)
												animazione()
												Wait(2000)
												animazione()
												Wait(2000)
												animazione()
												Wait(2000)
												animazione()
												Wait(2000)
												FreezeEntityPosition(playerPed, false)
												RemoveWeaponFromPed(PlayerPedId(), GetHashKey("WEAPON_HATCHET"), true, true)
												TriggerServerEvent('parzival_lumberjack:khordkardanchoob')
												Wait(5000)
												khord = false
												ESX.ShowNotification("Be Noghte Badi Beravid!", 'info')
										-- 	  else
										-- 		ESX.ShowNotification("Fazaye Khali Nadarid!")
										-- 		Wait(5000)
										-- 		khord = false
										-- 	  end
										--   end, 'cutted_wood')
						-- 			  else
						-- 				  ESX.ShowNotification("Shoma Be 50 adad Khorde choob nizad darid!")
						-- 				  Wait(5000)
						-- 				  khord = false
						-- 			  end
						-- 		  end, 'packaged_plank')
						-- 	  else
						-- 		  ESX.ShowNotification("Fazaye Khali Nadarid!")
						-- 		  Wait(5000)
						-- 		  khord = false
						-- 	  end
						--   end, 'cutted_wood')
					  end
				  end
			  else
				  Citizen.Wait(3000)
			  end
		  -- end
		  Citizen.Wait(0)
	  end
  end)
  
  Citizen.CreateThread(function()
	  while true do
		  local playerPed = PlayerPedId()
		  local pos = GetEntityCoords(playerPed, true)
		  -- if PlayerData.job ~= nil and (PlayerData.job.name == 'lumberjack') then
			  if (GetDistanceBetweenCoords(pos, -501.38, 5280.53, 79.61) < 15.0) and not start and not baste and duty then
				  DrawMarker(13, -501.38, 5280.53, 80.61, 0, 0, 0, 0, 0, 0, 0.8, 0.8, 0.8, 0, 255, 0, 150, 0, true, 2, 0, 0, 0, 0)
				  if (GetDistanceBetweenCoords(pos, -501.38, 5280.53, 79.61) < 0.75) then
					  drawTxt('Press [E] Baraye Baste Bandi Kardan')
					  if IsControlJustReleased(0, Keys['E']) then
						  baste = true
						--   ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(quantity)
						-- 	  if quantity <= 250 then
						-- 		  ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(quantity)
						-- 			  if quantity >= 50 then
						-- 				  ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(quantity)
						-- 					  local futuroinventario3 = math.floor(quantity + 50)
						-- 					  if futuroinventario3 <= 250 then
												  FreezeEntityPosition(playerPed, true)
												  SetEntityCoords(GetPlayerPed(-1), -502.158, 5280.791, 80.618-0.95) 
												  SetEntityHeading(GetPlayerPed(-1), 248.593)
												  animazionetavole()
												  TriggerServerEvent('parzival_lumberjack:bastebandikardan')
												  Wait(5000)
												  baste = false
												  FreezeEntityPosition(playerPed, false)
												  ESX.ShowNotification("Marahel Kar Tamam Shod!", 'info')
						-- 					  else
						-- 						  ESX.ShowNotification("Fazaye Khali Nadarid!")
						-- 						  Wait(5000)
						-- 						  baste = false
						-- 					  end
						-- 				  end, 'wood')
						-- 			  else
						-- 				  ESX.ShowNotification("Mikhai Mojeze Koni?")
						-- 				  Wait(5000)
						-- 				  baste = false
						-- 			  end
						-- 		  end, 'cutted_wood')
						-- 	  else
						-- 		  ESX.ShowNotification("Fazaye Khali Nadarid!")
						-- 		  Wait(5000)
						-- 		  baste = false
						-- 	  end
						--   end, 'wood')
					  end
				  end
			  else
				  Citizen.Wait(3000)
			  end
		  -- end
		  Citizen.Wait(0)
	  end
  end)
  
  function piastacazzodemacchina()
	  ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'prendi_veicolo',
		{
			title    = 'Company Vehicle',
			align = 'bottom-right',
			elements = {
				{label = 'Company Trunk', value = 'uno'},
			}
		},
		function(data, menu)
			local val = data.current.value
			
		  if val == 'uno' then
			  menu.close()
			  if spwaned then
				  ESX.ShowNotification("Shoma yek Mashin Darid!", 'error')
			  else
				  ESX.Game.SpawnVehicle('bison2', {x = 1188.206, y = -1286.56, z = 35.201}, 86.187, function(vehicle)
					  spwaned = true
					  SetPedIntoVehicle(PlayerPedId(), vehicle, -1)
					  TriggerServerEvent("garage:addKeys", GetVehicleNumberPlateText(vehicle), GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
					  ESX.ShowNotification("Be Jangal Motealegh Be Company Berafvid!", 'info')
				  end)
			  end
			end
		end,
		function(data, menu)
			menu.close()
		end
	)
	end
  
  Citizen.CreateThread(function()
	  while true do
  
		  Citizen.Wait(1)
  
		  -- if PlayerData.job ~= nil and (PlayerData.job.name == 'lumberjack') then
  
			  local playerPed = PlayerPedId()
			  local coords    = GetEntityCoords(playerPed)
			  
			  if GetDistanceBetweenCoords(coords, 1194.62, -1286.95, 34.12, true) < 15.0 and duty then
				  DrawMarker(20, 1194.62, -1286.95, 35.12, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.8, 0.8, 0.8, 0, 255, 0, 100, false, true, 2, false, false, false, false)
				  if GetDistanceBetweenCoords(coords, 1194.62, -1286.95, 34.12, true) < 1.75 then
					  drawTxt('Press [E] Baraye Gerftan Mashin')
					  if IsControlJustReleased(1, 51) then
						  piastacazzodemacchina()
					  end
				  end
			  else
				  Citizen.Wait(3000)
			  end
		  
		  -- end
	  end
  end)
  
  Citizen.CreateThread(function()
	  while true do
  
		  Citizen.Wait(1)
  
		  -- if PlayerData.job ~= nil and (PlayerData.job.name == 'lumberjack') then
  
			  local playerPed = PlayerPedId()
			  local coords    = GetEntityCoords(playerPed)
			  
			  if GetDistanceBetweenCoords(coords, 1216.89, -1229.23, 34.40, true) < 15.0 and duty then
				  DrawMarker(20, 1216.89, -1229.23, 35.40, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 2.5, 2.5, 2.5, 255, 0, 0, 100, false, true, 2, false, false, false, false)
				  if GetDistanceBetweenCoords(coords, 1216.89, -1229.23, 34.40, true) < 1.75 then
					  drawTxt('Press [E] Baraye Tahvil Mashin')
					  if IsControlJustReleased(1, 51) then
						  TriggerEvent('esx:deleteVehicle', "bison2")
						  spwaned = false
					  end
				  end
			  else
				  Citizen.Wait(3000)
			  end
		  
		  -- end
	  end
  end)
  
  
  
  function drawTxt(x,y ,width,height,scale, text, r,g,b,a, outline)
	  SetTextFont(0)
	  SetTextProportional(0)
	  SetTextScale(scale, scale)
	  SetTextColour(r, g, b, a)
	  SetTextDropShadow(0, 0, 0, 0,255)
	  SetTextEdge(1, 0, 0, 0, 255)
	  SetTextDropShadow()
	  if(outline)then
		  SetTextOutline()
	  end
	  SetTextEntry("STRING")
	  AddTextComponentString(text)
	  DrawText(x - width/2, y - height/2 + 0.005)
  end
  
  function drawTxt(text)
	  SetTextFont(0)
	  SetTextProportional(0)
	  SetTextScale(0.32, 0.32)
	  SetTextColour(255, 255, 255, 255)
	  SetTextDropShadow(0, 0, 0, 0, 255)
	  SetTextEdge(1, 0, 0, 0, 255)
	  SetTextDropShadow()
	  SetTextOutline()
	  SetTextCentre(1)
	  SetTextEntry("STRING")
	  AddTextComponentString(text)
	  DrawText(0.5, 0.93)
	end
  
	Citizen.CreateThread(function()
	  for k,v in pairs(LJConfig.Zones) do
		  for i = 1, #v.Pos, 1 do
		  local blip = AddBlipForCoord(v.Pos[i].x, v.Pos[i].y, v.Pos[i].z)
		  SetBlipSprite (blip, 85)
		  SetBlipDisplay(blip, 4)
		  SetBlipScale  (blip, 0.6)
		  SetBlipColour (blip, 17)
		  SetBlipAsShortRange(blip, true)
		  BeginTextCommandSetBlipName("STRING")
		  AddTextComponentString(v.Pos[i].nome)
		  EndTextCommandSetBlipName(blip)
		  end
	  end
  end)