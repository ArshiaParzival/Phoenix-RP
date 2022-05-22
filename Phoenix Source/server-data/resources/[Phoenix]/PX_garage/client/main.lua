esx = nil

cachedData = {}

Citizen.CreateThread(function()
	while not esx do
		TriggerEvent("esx:getSharedObject", function(library) 
			esx = library 
		end)

		Citizen.Wait(0)
	end
end)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(playerData)
	esx.PlayerData = playerData
end)

RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob", function(newJob)
	esx.PlayerData["job"] = newJob
end)

Citizen.CreateThread(function()
	local CanDraw = function(action)
		if action == "vehicle" then
			if IsPedInAnyVehicle(PlayerPedId()) then
				local vehicle = GetVehiclePedIsIn(PlayerPedId())

				if GetPedInVehicleSeat(vehicle, -1) == PlayerPedId() then
					return true
				else
					return false
				end
			else
				return false
			end
		end

		return true
	end

	for garage, garageData in pairs(Config.Garages) do
		local garageBlip = AddBlipForCoord(garageData["positions"]["menu"]["position"])

		SetBlipSprite(garageBlip, 289)
		SetBlipDisplay(garageBlip, 4)
		SetBlipScale (garageBlip, 0.9)
		SetBlipColour(garageBlip, 67)
		SetBlipAsShortRange(garageBlip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Parking "..garage)
		EndTextCommandSetBlipName(garageBlip)
	end

	while true do
		local sleepThread = 500

		local ped = PlayerPedId()
		local pedCoords = GetEntityCoords(ped)

		for garage, garageData in pairs(Config.Garages) do
			for action, actionData in pairs(garageData["positions"]) do
				local dstCheck = #(pedCoords - actionData["position"])

				if dstCheck <= 10.0 then
					sleepThread = 5
					local draw = CanDraw(action)

					if draw then
						local markerSize = action == "vehicle" and 4.0 or 1.5
						if dstCheck <= markerSize - 0.1 then
							local usable = not DoesCamExist(cachedData["cam"])
							if Menu.hidden then

							end
							if IsControlJustPressed(1, 177) and not Menu.hidden then
								CloseMenu()
								PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
							end
							if usable then
								if IsControlJustPressed(0, 38) and Menu.hidden then
									cachedData["currentGarage"] = garage
									esx.TriggerServerCallback("PX_garage:obtenerVehiculos", function(fetchedVehicles)
										EnvioVehLocal(fetchedVehicles[1])
										if fetchedVehicles[2] then
											EnvioVehFuera(fetchedVehicles[2])
										end
									end,garage)
									Menu.hidden = not Menu.hidden
									MenuGarage(action)
									TriggerEvent("inmenu",true)
								end
								
							end
						end
						DrawScriptMarker({
							["type"] = 27,
							["pos"] = actionData["position"] - vector3(0.0, 0.0, 0.0),
							["sizeX"] = markerSize,
							["sizeY"] = markerSize,
							["sizeZ"] = markerSize,
							["r"] = 0,
							["g"] = 0,
							["b"] = 0
						})
						if dstCheck <= 3.0 then
							esx.ShowHelpNotification("Press ~INPUT_PICKUP~ To Access Garage")
						end
					end
				elseif (dstCheck > 10.0 and dentro == garage) then
					dentro = nil
				end
			end
		end
		Menu.renderGUI()
		Citizen.Wait(sleepThread)
	end
end)
-------------------------------------------------------------------------------------------------------------------------
function DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.005+ factor, 0.03, 0, 0, 0, 100)
end

RegisterNetEvent('PX_garage:DeleteAllVehicle')
AddEventHandler('PX_garage:DeleteAllVehicle', function()
	local vehicles = esx.Game.GetVehicles()
	for _,entity in ipairs(vehicles) do
		if IsAnyPedInVehicle(entity) then
			return
		end
		NetworkRequestControlOfEntity(entity)
		local timeout = 2000
		while timeout > 0 and not NetworkHasControlOfEntity(entity) do
			Wait(100)
			timeout = timeout - 100
		end
		SetEntityAsMissionEntity(entity, true, true)
		local timeout = 2000
		while timeout > 0 and not IsEntityAMissionEntity(entity) do
			Wait(100)
			timeout = timeout - 100
		end
		DeleteVehicle(entity)
		if (DoesEntityExist(entity)) then
			DeleteEntity(entity)
		end
	end
end)

function IsAnyPedInVehicle(veh)
	return (GetVehicleNumberOfPassengers(veh)+(IsVehicleSeatFree(veh,-1) and 0 or 1))>0
end