

local driftmode = false

local drift_speed_limit = 100.0



local Keys = {
	["LEFTSHIFT"] = 21
}

AddEventHandler('onKeyUP',function(key)
	if key == "numpad9" then
		driftmode = not driftmode
		if driftmode then
			TriggerEvent('esx:showNotification', 'Drift On Shod')
			Citizen.CreateThread(function()
				local vehicle			
				while driftmode do
					Citizen.Wait(100)
                    if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                        local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
                        if GetPedInVehicleSeat(vehicle, -1) == GetPlayerPed(-1) then
                            if GetEntitySpeed(vehicle) * 3.6 <= drift_speed_limit then
                                if IsControlPressed(1, Keys['LEFTSHIFT']) then
                                    SetVehicleReduceGrip(vehicle, true)
                                else
                                    SetVehicleReduceGrip(vehicle, false)
                                end
                            end
                        end
                    else
                        Citizen.Wait(1000)
                    end
				end
			end)
		else
			TriggerEvent('esx:showNotification', 'Drift Off Shod')
		end
	end
end)