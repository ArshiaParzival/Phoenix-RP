ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

local inPaintBall = false
local inCapture = false
local inEvent = false
local StressGain = 0
local IsGaining = false
local stress = 0

AddEventHandler('esx_paintball:inPaintBall', function(state)
    inPaintBall = state 
end)
AddEventHandler('capture:inCapture', function(bool)
	inCapture = bool
end)
AddEventHandler('Parzival:Event', function(bool)
    inEvent = bool
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    stress = xPlayer.stress
end)

RegisterNetEvent("weaponry:client:update:stress")
AddEventHandler("weaponry:client:update:stress", function(new)
    stress = new
end)

Citizen.CreateThread(function()
    while true do
        if not inPaintBall and not inCapture and not inEvent then
            local ped = PlayerPedId()

            if IsPedShooting(PlayerPedId()) then
                local StressChance = math.random(1, 3)
                local odd = math.random(1, 3)
                if StressChance == odd then
                    local PlusStress = math.random(2, 4) / 100
                    StressGain = StressGain + PlusStress
                end
                if not IsGaining then
                    IsGaining = true
                end
            else
                if IsGaining then
                    IsGaining = false
                end
            end

            if IsPlayerFreeAiming(PlayerId()) and not IsPedShooting(PlayerPedId()) then
                local CurrentWeapon = GetSelectedPedWeapon(ped)
                if CurrentWeapon ~= "WEAPON_UNARMED" then
                    local StressChance = math.random(1, 20)
                    local odd = math.random(1, 20)
                    if StressChance == odd then
                        local PlusStress = math.random(1, 3) / 100
                        StressGain = StressGain + PlusStress
                    end
                end
                if not IsGaining then
                    IsGaining = true
                end
            else
                if IsGaining then
                    IsGaining = false
                end
            end
        else
            Citizen.Wait(1000)
        end
        Citizen.Wait(2)
    end
end)

Citizen.CreateThread(function()
    while true do
        if not IsGaining then
            StressGain = math.ceil(StressGain)
            if StressGain > 0 then
                TriggerServerEvent('weaponry:Server:UpdateStress', StressGain)
                StressGain = 0
            end
        end
        Citizen.Wait(3000)
    end
end)

Citizen.CreateThread(function()
    while true do
        if not inPaintBall and not inCapture and not inEvent then
            local ped = PlayerPedId()
            local Wait = GetEffectInterval(stress)
            if stress >= 90 then
                local ShakeIntensity = GetShakeIntensity(stress)
                local FallRepeat = math.random(2, 4)
                local RagdollTimeout = (FallRepeat * 1750)
                ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', ShakeIntensity)

                if not IsPedRagdoll(ped) and IsPedOnFoot(ped) and not IsPedSwimming(ped) then
                    local player = PlayerPedId()
                    SetPedToRagdollWithFall(player, RagdollTimeout, RagdollTimeout, 1, GetEntityForwardVector(player), 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
                end

                Citizen.Wait(500)
                for i = 1, FallRepeat, 1 do
                    Citizen.Wait(750)
                    DoScreenFadeOut(200)
                    Citizen.Wait(1000)
                    DoScreenFadeIn(200)
                    ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', ShakeIntensity)
                end
            end
            Citizen.Wait(Wait)
        else
            Citizen.Wait(1000)
        end
        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
    while true do
        if not inPaintBall and not inCapture and not inEvent then
            if stress >= 70 then
                SetFlash(0, 0, 500, 3000, 500)
                RequestWalking("move_m@drunk@a")
                SetPedMovementClipset(PlayerPedId(), "move_m@drunk@a", 0.2)
            elseif stress >= ManiStress.MinimumStress then
                SetFlash(0, 0, 500, 2500, 500)
                RequestWalking("move_m@drunk@slightlydrunk")
                SetPedMovementClipset(PlayerPedId(), "move_m@drunk@slightlydrunk", 0.2)
            end
        end
        Citizen.Wait(10000)
    end
end)

function RequestWalking(set)
    RequestAnimSet(set)
    while not HasAnimSetLoaded(set) do
      Citizen.Wait(1)
    end 
end

function GetShakeIntensity(stresslevel)
    local retval = 0.05
    for k, v in pairs(ManiStress.Intensity["shake"]) do
        if stresslevel >= v.min and stresslevel < v.max then
            retval = v.intensity
            break
        end
    end
    return retval
end

function GetEffectInterval(stresslevel)
    local retval = 23000
    if stresslevel == nil then
        stress = stress
        stresslevel = stress
    end
    for k, v in pairs(ManiStress.EffectInterval) do
        if stresslevel >= v.min and stresslevel < v.max then
            retval = v.timeout
            break
        end
    end
    return retval
end