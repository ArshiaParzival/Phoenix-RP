ESX = nil
local isDead = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(50)
	end
end)

AddEventHandler('esx:onPlayerDeath', function(data)
	isDead = true
end)

AddEventHandler('playerSpawned', function(spawn)
	isDead = false
end)

local keyPressed = false

local function startPointing(ped)
	RequestAnimDict("anim@mp_point")
	while not HasAnimDictLoaded("anim@mp_point") do
		Citizen.Wait(1)
	end

	SetPedCurrentWeaponVisible(ped, 0, 1, 1, 1)
	SetPedConfigFlag(ped, 36, 1)
	TaskMoveNetwork(ped, "task_mp_pointing", 0.5, 0, "anim@mp_point", 24)
	RemoveAnimDict("anim@mp_point")
end

local function stopPointing(ped)
	Citizen.InvokeNative(0xD01015C7316AE176, ped, "Stop")

	if not IsPedInjured(ped) then
		ClearPedSecondaryTask(ped)
	end

	if not IsPedInAnyVehicle(ped, 1) then
		SetPedCurrentWeaponVisible(ped, 1, 1, 1, 1)
	end

	SetPedConfigFlag(ped, 36, 0)
	ClearPedSecondaryTask(ped)
end

AddEventHandler("onKeyDown", function(key)
    if key == "b" and not isDead then
		local playerped = PlayerPedId()

		if IsPedArmed(playerped, 7) then
			ESX.ShowNotification("~h~Dast shoma por ast nemitavanid point konid!", 'error')
			return
		end

		keyPressed = true
		startPointing(playerped)

		Citizen.CreateThread(function()
			local ped = playerped
			while keyPressed do
				Citizen.Wait(10)
				if Citizen.InvokeNative(0x921CE12C489C4C41, ped) then
					
					if not IsPedOnFoot(ped) then
						stopPointing(ped)
						keyPressed = false
						return
					end

					local camPitch = GetGameplayCamRelativePitch()
					if camPitch < -70.0 then
						camPitch = -70.0
					elseif camPitch > 42.0 then
						camPitch = 42.0
					end
					camPitch = (camPitch + 70.0) / 112.0

					local camHeading = GetGameplayCamRelativeHeading()
					local cosCamHeading = Cos(camHeading)
					local sinCamHeading = Sin(camHeading)
					if camHeading < -180.0 then
						camHeading = -180.0
					elseif camHeading > 180.0 then
						camHeading = 180.0
					end
					camHeading = (camHeading + 180.0) / 360.0

					local blocked = 0
					local nn = 0

					local coords = GetOffsetFromEntityInWorldCoords(ped, (cosCamHeading * -0.2) - (sinCamHeading * (0.4 * camHeading + 0.3)), (sinCamHeading * -0.2) + (cosCamHeading * (0.4 * camHeading + 0.3)), 0.6)
					local ray = Cast_3dRayPointToPoint(coords.x, coords.y, coords.z - 0.2, coords.x, coords.y, coords.z + 0.2, 0.4, 95, ped, 7);
					nn,blocked,coords,coords = GetRaycastResult(ray)

					Citizen.InvokeNative(0xD5BB4025AE449A4E, ped, "Pitch", camPitch)
					Citizen.InvokeNative(0xD5BB4025AE449A4E, ped, "Heading", camHeading * -1.0 + 1.0)
					Citizen.InvokeNative(0xB0A6CFD2C69C1088, ped, "isBlocked", blocked)
					Citizen.InvokeNative(0xB0A6CFD2C69C1088, ped, "isFirstPerson", Citizen.InvokeNative(0xEE778F8C7E1142E2, Citizen.InvokeNative(0x19CAFA3C87F7C2FF)) == 4)
				end
				
			end
		end)
    end
end)

AddEventHandler("onKeyUP", function(key)
    if key == "b" then
		if keyPressed then
			stopPointing(PlayerPedId())
			keyPressed = false
		end
    end
end)

AddEventHandler('esx:onPlayerDeath', function()
	if keyPressed then
		stopPointing(PlayerPedId())
		keyPressed = false
	end
end)

-- Citizen.CreateThread(function()
-- 	local dict = "missminuteman_1ig_2"

-- 	RequestAnimDict(dict)
-- 	while not HasAnimDictLoaded(dict) do
-- 		Citizen.Wait(100)
-- 	end
-- end)

-- AddEventHandler("onKeyDown", function(key)
-- 	if key == "x" and not isDead and not IsPedInAnyVehicle(GetPlayerPed(-1), false) then
-- 		TaskPlayAnim(PlayerPedId(), "missminuteman_1ig_2", "handsup_base", 1.5, 2.0, -1, 50, 0, false, false, false)
--     end
-- end)

AddEventHandler("onKeyUP", function(key)
    if key == "x" and not isDead and not IsPedInAnyVehicle(GetPlayerPed(-1), false) then
		if not IsPedInAnyVehicle(GetPlayerPed(-1), false) then
			ClearPedTasks(PlayerPedId())
		end
    end
end)

local disableShuffle = true
function disableSeatShuffle(flag)
	disableShuffle = flag
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		local ped = PlayerPedId()
		if IsPedInAnyVehicle(ped, false) and disableShuffle then
			local vehicle = GetVehiclePedIsIn(ped)
			
			if GetPedInVehicleSeat(vehicle, 0) == ped then
				if GetIsTaskActive(ped, 165) then
					SetPedIntoVehicle(ped, vehicle, 0)
				end

				if GetPedInVehicleSeat(vehicle, -1) == 0 then

					ESX.ShowHelpNotification('Dokme ~INPUT_CONTEXT~ Jahat Neshastan Dar Sandali Ranande')
					if IsControlPressed(0, Keys["E"]) then
						disableSeatShuffle(false)
						Citizen.Wait(5000)
						disableSeatShuffle(true)
					end

				end
			else
				Citizen.Wait(500)
			end

		else
			Citizen.Wait(500)
		end
	end
end)