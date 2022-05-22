CreateThread(function()
    while true do
		HideHudComponentThisFrame(1) -- 1 : WANTED_STARS
		HideHudComponentThisFrame(2) -- 2 : WEAPON_ICON
		HideHudComponentThisFrame(3) -- 3 : CASH
		HideHudComponentThisFrame(4) -- 4 : MP_CASH
		-- HideHudComponentThisFrame(5)			-- 5 : MP_MESSAGE
		-- HideHudComponentThisFrame(6)			-- 6 : VEHICLE_NAME
		HideHudComponentThisFrame(7) -- 7 : AREA_NAME
		-- HideHudComponentThisFrame(8)			-- 8 : VEHICLE_CLASS
		HideHudComponentThisFrame(9) -- 9 : STREET_NAME
		-- HideHudComponentThisFrame(10)		-- 10 : HELP_TEXT
		-- HideHudComponentThisFrame(11)		-- 11 : FLOATING_HELP_TEXT_1
		-- HideHudComponentThisFrame(12)		-- 12 : FLOATING_HELP_TEXT_2
		HideHudComponentThisFrame(13) -- 13 : CASH_CHANGE
		HideHudComponentThisFrame(14) -- 14 : RETICLE
		-- HideHudComponentThisFrame(15)		-- 15 : SUBTITLE_TEXT
		-- HideHudComponentThisFrame(16)		-- 16 : RADIO_STATIONS
		HideHudComponentThisFrame(17) -- 17 : SAVING_GAME
		-- HideHudComponentThisFrame(18)		-- 18 : GAME_STREAM
		HideHudComponentThisFrame(19) -- 19 : WEAPON_WHEEL
		HideHudComponentThisFrame(20) -- 20 : WEAPON_WHEEL_STATS
		HideHudComponentThisFrame(21) -- 21 : HUD_COMPONENTS
		HideHudComponentThisFrame(22) -- 22 : HUD_WEAPONS
		DisableControlAction(1, 37)
		DisplayAmmoThisFrame(true)
		Wait(4)
    end
end)

Citizen.CreateThread(function()
	for i = 1, 15 do
		EnableDispatchService(i, false)
	end
end)

CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local weapon = GetSelectedPedWeapon(ped)
		if weapon ~= `WEAPON_UNARMED` then
			if IsPedArmed(ped, 6) then
				DisableControlAction(1, 140, true)
				DisableControlAction(1, 141, true)
				DisableControlAction(1, 142, true)
			end

			if weapon == `WEAPON_FIREEXTINGUISHER` or  weapon == `WEAPON_PETROLCAN` then
				if IsPedShooting(ped) then
					SetPedInfiniteAmmo(ped, true, `WEAPON_FIREEXTINGUISHER`)
					SetPedInfiniteAmmo(ped, true, `WEAPON_PETROLCAN`)
				end
			end
		else
			Wait(500)
		end
        Wait(7)
    end
end)

CreateThread(function()
    local pedPool = GetGamePool('CPed')
    for k,v in pairs(pedPool) do
        SetPedDropsWeaponsWhenDead(v, false)
    end
    Wait(500)
end)

CreateThread(function()
	while true do
		Wait(1)
		local ped = PlayerPedId()
		if IsPedBeingStunned(ped) then
			SetPedMinGroundTimeForStungun(ped, math.random(4000, 7000))
		else
			Wait(1000)
		end
	end
end)

--Control NPC

local AmountNPC = 0.45

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		SetGarbageTrucks(false)
		SetRandomBoats(false)
		SetCreateRandomCops(false)
		SetCreateRandomCopsNotOnScenarios(false)
		SetCreateRandomCopsOnScenarios(false)
        DisablePlayerVehicleRewards(PlayerId())
        RemoveAllPickupsOfType(0xDF711959)
        RemoveAllPickupsOfType(0xF9AFB48F)
        RemoveAllPickupsOfType(0xA9355DCD)
        SetCanAttackFriendly(GetPlayerPed(-1), true, false)
		NetworkSetFriendlyFireOption(true)
        SetVehicleDensityMultiplierThisFrame(AmountNPC)
	    SetPedDensityMultiplierThisFrame(AmountNPC)
	    SetRandomVehicleDensityMultiplierThisFrame(AmountNPC)
	    SetParkedVehicleDensityMultiplierThisFrame(AmountNPC)
	    SetScenarioPedDensityMultiplierThisFrame(AmountNPC, AmountNPC)
        if GetVehiclePedIsUsing(GetPlayerPed(-1)) ~= 0 then SetPedConfigFlag(GetPlayerPed(-1), 35, false) end
	end
end)

function RemovePeskyVehicles(player, range)
    local pos = GetEntityCoords(playerPed)
    RemoveVehiclesFromGeneratorsInArea(
        pos.x - range, pos.y - range, pos.z - range,
        pos.x + range, pos.y + range, pos.z + range
    );
end

local passengerDriveBy = true


-- Shooting Driver
Citizen.CreateThread(function()

	while true do
	
		Wait(500)
		
		

		playerPed = GetPlayerPed(-1)
		
		car = GetVehiclePedIsIn(playerPed, false)
		
		if car then
		
			if GetPedInVehicleSeat(car, -1) == playerPed then
                if GetEntitySpeed(car) * 3.6 > 70 then
				    SetPlayerCanDoDriveBy(PlayerId(), false)
                else
                    SetPlayerCanDoDriveBy(PlayerId(), true)
                end
				
			elseif passengerDriveBy then
			
				SetPlayerCanDoDriveBy(PlayerId(), true)
			else
			
				SetPlayerCanDoDriveBy(PlayerId(), false)
				
			end
			
		end
		
	end
	
end)

--no r key
local isAiming = false
local threadCreated = false

local function AimThread()
	Citizen.CreateThread(function()
		while isAiming do
			Citizen.Wait(5) -- A Short Daily of 5 MS
			DisableControlAction(0, 140, true) -- Disable the Light Dmg Contr ol
			DisableControlAction(1, 141, true)
			DisableControlAction(1, 142, true)

			-- Controler AIM assist disable
			SetPlayerLockonRangeOverride(player, 2.0)
			DisableControlAction(1, 140, true)
			DisableControlAction(1, 141, true)
			DisableControlAction(1, 142, true)
		end
	end)
end

local function checkArmed()
	isAiming = IsPedArmed(PlayerPedId(), 4)
	if isAiming and not threadCreated then
		threadCreated = true
		AimThread()
	elseif not isAiming and threadCreated then
		threadCreated = false
	end
	SetTimeout(500, checkArmed)
end
checkArmed()
local holdingRight = false
AddEventHandler("onKeyDown", function(key)
	if key == "mouse_right" then
		holdingRight = true
	elseif key == "mouse_left" or key == "r" then
		if not holdingRight then
			DisableControlAction(2, 263, true) -- R attack
			DisableControlAction(2, 257, true) -- Left click mouse attack
			DisableControlAction(0, 264, true) -- Disable melee
			DisableControlAction(0, 257, true) -- Disable melee
			DisableControlAction(0, 140, true) -- Disable melee
			DisableControlAction(0, 141, true) -- Disable melee
			DisableControlAction(0, 142, true) -- Disable melee
			DisableControlAction(0, 143, true) -- Disable melee
		end
	end
end)

AddEventHandler("onKeyUP", function(key)
	if key == "mouse_right" then
		holdingRight = false
	end
end)

--fix hp of ped
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if GetEntityMaxHealth(GetPlayerPed(-1)) ~= 200 then
            SetEntityMaxHealth(GetPlayerPed(-1), 200)
            SetEntityHealth(GetPlayerPed(-1), 200)
        end
    end
end)

--disable afk camera
Citizen.CreateThread(function()
    while true do
      InvalidateIdleCam()
      N_0x9e4cfff989258472()
      Wait(10000)
    end
end)

local vehicleClassDisableControl = {
    [0] = true,     --compacts
    [1] = true,     --sedans
    [2] = true,     --SUV's
    [3] = true,     --coupes
    [4] = true,     --muscle
    [5] = true,     --sport classic
    [6] = true,     --sport
    [7] = true,     --super
    [8] = false,    --motorcycle
    [9] = true,     --offroad
    [10] = true,    --industrial
    [11] = true,    --utility
    [12] = true,    --vans
    [13] = false,   --bicycles
    [14] = false,   --boats
    [15] = false,   --helicopter
    [16] = false,   --plane
    [17] = true,    --service
    [18] = true,    --emergency
    [19] = false    --military
}

-- Main thread
Citizen.CreateThread(function()
    while true do
        -- Loop forever and update every frame
        Citizen.Wait(1)

        -- Get player, vehicle and vehicle class
        local player = GetPlayerPed(-1)
        local vehicle = GetVehiclePedIsIn(player, false)
        local vehicleClass = GetVehicleClass(vehicle)

        -- Disable control if player is in the driver seat and vehicle class matches array
        if ((GetPedInVehicleSeat(vehicle, -1) == player) and vehicleClassDisableControl[vehicleClass]) then
            -- Check if vehicle is in the air and disable L/R and UP/DN controls
            if IsEntityInAir(vehicle) then
                DisableControlAction(2, 59)
                DisableControlAction(2, 60)
            end
        end
    end
end)

RegisterCommand('record', function()
	StartRecording(1)
end)

RegisterCommand('crecord', function()
	StopRecordingAndDiscardClip()
end)

RegisterCommand('srecord', function()
	StopRecordingAndSaveClip()
end)

RegisterCommand("editor", function()
	ActivateRockstarEditor()
end)

RegisterCommand('oeditor', function()
	NetworkSessionLeaveSinglePlayer()
	ActivateRockstarEditor()
end)

Citizen.CreateThread(function()
    SetMapZoomDataLevel(0, 0.96, 0.9, 0.08, 0.0, 0.0)
    SetMapZoomDataLevel(1, 1.6, 0.9, 0.08, 0.0, 0.0)
    SetMapZoomDataLevel(2, 8.6, 0.9, 0.08, 0.0, 0.0)
    SetMapZoomDataLevel(3, 12.3, 0.9, 0.08, 0.0, 0.0)
    SetMapZoomDataLevel(4, 22.3, 0.9, 0.08, 0.0, 0.0)
end)

Citizen.CreateThread(function()
    while true do
		Citizen.Wait(1)
		if IsPedOnFoot(GetPlayerPed(-1)) then 
			SetRadarZoom(1100)
		elseif IsPedInAnyVehicle(GetPlayerPed(-1), true) then
			SetRadarZoom(1100)
		end
    end
end)