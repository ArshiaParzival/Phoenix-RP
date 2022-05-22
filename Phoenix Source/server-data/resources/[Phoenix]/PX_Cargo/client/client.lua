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

ESX = nil
local Bots = {models = Config.Bots.Model, coords = Config.Bots.Coords}
local AlreadyTalkedWith = {}
local NeedMechanic, InConversation, NotParkedVan, Hacked = true, false, false, false
local AliveBot = 0
local pilot, aircraft, parachute, crate, pickup, blip, soundID, BotsID
local requiredModels = {"p_cargo_chute_s", "ex_prop_adv_case_sm", "cuban800", "s_m_m_pilot_02", "prop_box_wood02a_pu"} -- parachute, pickup case, plane, pilot, crate

Config.SendSignalWithLabtopPos = { x = -1158.32, y = 4924.03, z = 222.47, h = 269.35}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
    end
    
    ESX.TriggerServerCallback('PX_Cargo:SyncBotsInServer', function(BotsId, JafarCD) 
        BotsID = json.decode(BotsId) 

        BotCreatingCitizen(BotsID)

        -- JafarCD and Config.Mechanic.CooldownPos or 
        Bots.Mechanic = Config.Mechanic.ActivePos

        NeedMechanic = not JafarCD

        TriggerEvent('sr_doorlock:setState', 'Cargo', 1, NeedMechanic)

        CreateMechanicBot()
    end)
end)

RegisterNetEvent('sr_cargo:ClientSyncDealers')
AddEventHandler('sr_cargo:ClientSyncDealers', function(BotId)
    
    DeleteEntity(parachute)
    DeleteEntity(crate)
    DeleteEntity(pickup)
    DeleteEntity(Mechanic)
    RemoveBlip(blip)
    StopSound(soundID)
    ReleaseSoundId(soundID)
    
    for k,v in pairs(BotsID) do
        DeleteEntity(Bots.coords[v].BotId)            
    end

    BotsID = json.decode(BotId) 

    BotCreatingCitizen(BotsID)
    
    AlreadyTalkedWith = {}
    NeedMechanic, InConversation, NotParkedVan, Hacked = true, false, false, false
    AliveBot = 0
    
    pilot, aircraft, parachute, crate, pickup, blip, soundID = nil, nil, nil, nil, nil, nil, nil
    
    Bots = {
        models = Config.Bots.Model,
        coords = Config.Bots.Coords
    }

    Bots.Mechanic = Config.Mechanic.ActivePos

    TriggerEvent('sr_doorlock:setState', 'Cargo', 1, true)

    CreateMechanicBot()

    SendNUIMessage({
        refresh = true
    })
end)

RegisterNetEvent('PX_Cargo:DropTheCargo')
AddEventHandler('PX_Cargo:DropTheCargo', function(coord)
    CreateDrop(coord)
end)

RegisterCommand("gh", function()
    SetNuiFocus(false, false)
end)

function CreateDrop(dropCoords)
    Citizen.CreateThread(function()

        for i = 1, #requiredModels do
            local model = GetHashKey(requiredModels[i])
            RequestModel(model)
            while not HasModelLoaded(model) do
                Wait(0)
            end
        end

        RequestWeaponAsset(GetHashKey("weapon_flare"))

        while not HasWeaponAssetLoaded(GetHashKey("weapon_flare")) do
            Wait(0)
        end

        local rHeading = math.random(0, 360) + 0.0
        local planeSpawnDistance = 50.0
        local theta = (rHeading / 180.0) * 3.14
        local rPlaneSpawn = vector3(dropCoords.x, dropCoords.y, dropCoords.z) - vector3(math.cos(theta) * planeSpawnDistance, math.sin(theta) * planeSpawnDistance, -50.0)
        local dx = dropCoords.x - rPlaneSpawn.x
        local dy = dropCoords.y - rPlaneSpawn.y
        local heading = GetHeadingFromVector_2d(dx, dy)

        aircraft = CreateVehicle((`cuban800`), rPlaneSpawn, heading, false, true)
        SetEntityHeading(aircraft, heading)
        SetEntityDynamic(aircraft, true)
        ActivatePhysics(aircraft)
        SetVehicleForwardSpeed(aircraft, 60.0)
        SetHeliBladesFullSpeed(aircraft)
        SetVehicleEngineOn(aircraft, true, true, false)
        ControlLandingGear(aircraft, 3)
        OpenBombBayDoors(aircraft)
        SetEntityProofs(aircraft, true, false, true, false, false, false, false, false)

        pilot = CreatePedInsideVehicle(aircraft, 1, (`s_m_m_pilot_02`), -1, false, true)
        SetBlockingOfNonTemporaryEvents(pilot, true)
        SetPedRandomComponentVariation(pilot, false)
        SetPedKeepTask(pilot, true)
        SetPlaneMinHeightAboveTerrain(aircraft, 50)

        TaskVehicleDriveToCoord(pilot, aircraft, vector3(dropCoords.x, dropCoords.y, dropCoords.z) + vector3(0.0, 0.0, 500.0), 60.0, 0,(`cuban800`), 262144, 15.0, -1.0)

        local droparea = vector2(dropCoords.x, dropCoords.y)
        local planeLocation = vector2(GetEntityCoords(aircraft).x, GetEntityCoords(aircraft).y)
        while #(planeLocation - droparea) > 5.0 do
            Wait(100)
            planeLocation = vector2(GetEntityCoords(aircraft).x, GetEntityCoords(aircraft).y)
        end

        TaskVehicleDriveToCoord(pilot, aircraft, 0.0, 0.0, 500.0, 60.0, 0,(`cuban800`), 262144, -1.0, -1.0)
        SetEntityAsNoLongerNeeded(pilot) 
        SetEntityAsNoLongerNeeded(aircraft)

        local crateSpawn = vector3(dropCoords.x, dropCoords.y, GetEntityCoords(aircraft).z - 5.0)

        crate = CreateObject(`prop_box_wood02a_pu`, crateSpawn, false, true, true)
        SetEntityInvincible(crate, true)
        SetEntityLodDist(crate, 1000)
        ActivatePhysics(crate)
        SetDamping(crate, 2, 2.0)
        SetEntityVelocity(crate, 0.0, 0.0, -0.2)

        parachute = CreateObject(`p_cargo_chute_s`, crateSpawn, false, true, true) 
        SetEntityInvincible(parachute, true)
        SetEntityLodDist(parachute, 1000)
        ActivatePhysics(parachute)
        SetDamping(parachute, 2, 2.0)
        SetEntityVelocity(parachute, 0.0, 0.0, -0.2)

        pickup = CreateObject(`ex_prop_adv_case_sm`, crateSpawn, false, true, true)
        SetEntityInvincible(pickup, true)
        SetEntityLodDist(pickup, 1000)
        ActivatePhysics(pickup)
        SetDamping(pickup, 2, 2.0) 
        SetEntityVelocity(pickup, 0.0, 0.0, -0.2)

        soundID = GetSoundId()
        PlaySoundFromEntity(soundID, "Crate_Beeps", pickup, "MP_CRATE_DROP_SOUNDS", true, 0)

        AttachEntityToEntity(parachute, pickup, 0, 0.0, 0.0, 0.1, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
        AttachEntityToEntity(pickup, crate, 0, 0.0, 0.0, 0.3, 0.0, 0.0, 0.0, false, false, true, false, 2, true)

        local pickupCoord = GetEntityCoords(pickup)
        while pickupCoord.z - dropCoords.z > 1.0 do
            pickupCoord = GetEntityCoords(pickup)
            Wait(0)
        end

        SetEntityInvincible(crate, false)

        CreatePickUpCitizen()

        local parachuteCoords = vector3(GetEntityCoords(parachute)) -- we get the parachute dropCoords so we know where to drop the flare
        ShootSingleBulletBetweenCoords(parachuteCoords, parachuteCoords - vector3(0.0001, 0.0001, 0.0001), 0, false, GetHashKey("weapon_flare"), 0, true, false, -1.0) -- flare needs to be dropped with dropCoords like that, otherwise it remains static and won't remove itself later
        DetachEntity(parachute, true, true)

        DeleteEntity(parachute)
        DetachEntity(pickup) -- will despawn on its own

        StopSound(soundID) -- stop the crate beeping sound
        ReleaseSoundId(soundID) -- won't need this sound ID any longer

        for i = 1, #requiredModels do
            Wait(0)
            SetModelAsNoLongerNeeded(GetHashKey(requiredModels[i]))
        end

        RemoveWeaponAsset(GetHashKey("weapon_flare"))
    end)
end

function CreatePickUpCitizen()
    Citizen.CreateThread(function()
        local WaitTime
        while pickup do 
            WaitTime = 500
            local pickupCoord = GetEntityCoords(pickup)
            local playerCoord = GetEntityCoords(PlayerPedId())
            local dist = Vdist(pickupCoord, playerCoord)
            if dist <= 2.0 then
                WaitTime = 0
                ESX.ShowHelpNotification('~INPUT_CONTEXT~ Open Loot box')
                if IsControlJustPressed(0, Keys['E']) then
                    ESX.TriggerServerCallback('PX_Cargo:GetBoxInventory', function(data)
                        TriggerEvent('esx_inventoryhud:openBoxInventory', data)
                    end)
                end
            end
            Wait(WaitTime)
        end
    end)
end

function BotCreatingCitizen(BotsId)
    Citizen.CreateThread(function()
        for k,v in pairs(Bots.models) do
            RequestModel(v)
            
            while not HasModelLoaded(v) do
                Citizen.Wait(100)
            end
        end
    
        for k,v in pairs(BotsId) do
            math.randomseed(GetGameTimer())
            local DealerPed = CreatePed(4, Bots.models[math.random(1, #Bots.models)], Bots.coords[v].x, Bots.coords[v].y, Bots.coords[v].z - 1, Bots.coords[v].h, false, true)
            Bots.coords[v].BotId = DealerPed
            SetEntityAsMissionEntity(DealerPed)
            SetBlockingOfNonTemporaryEvents(DealerPed, true)
            Wait(100)
            FreezeEntityPosition(DealerPed, true)
            SetEntityInvincible(DealerPed, true)
            ClearPedTasks(DealerPed)
            TaskStartScenarioInPlace(DealerPed, "WORLD_HUMAN_SMOKING", 0, true)
        end


        for k,v in pairs(Bots.models) do
            SetModelAsNoLongerNeeded(v)
        end
    
        while true do
            local PlayerCoord = GetEntityCoords(PlayerPedId())
            for k,v in pairs(BotsId) do
                Wait(0)
                local dist = Vdist(PlayerCoord, Bots.coords[v].x, Bots.coords[v].y, Bots.coords[v].z)
                if (dist <= 30) and (AliveBot == 0) and not AlreadyTalkedWith[v] then
                    MakeBotAlive(v)
                end
            end
            Wait(0)
        end
    end)
end

function soot(ped)
    while not HasAnimDictLoaded('taxi_hail') do
        RequestAnimDict('taxi_hail')
        Wait(10)
    end

    TaskPlayAnim(ped, 'taxi_hail', 'hail_taxi', 2.0, 2.0, 1300, 51, 0, false, false, false)
    RemoveAnimDict('taxi_hail')
end

local TalkStatementWithBots = {
    ["csb_jackhowitzer"] = {
        hasKey = {
            { label = 'دنبال رمز کارگو می‌گردم', value = 'donbale_ramze_cargo_hastam' }, 
            { label = 'خسته شدم از بس گشتم', value = 'khaste_shodam_az_bas_gashtam' }, 
        },
        noKey = {
            { label = 'قیافت خیلی مسخرست', value = 'ghiyafat_kheyli_maskharast' }, 
            { label = 'می‌خوام از همه چی سر دربیارم', value = 'mikham_az_hame_chi_sar_dar_biyaram' },  
        }
    },
    ["g_m_y_mexgoon_01"] = {
        hasKey = {
            { label = 'فکر کنم تو بتونی کمکم کنی', value = 'fekr_konam_to_betoni_komakam_koni' }, 
            { label = 'می‌دونی رمز شب چیه؟', value = 'ramz_shab_midoni_chie' }, 
        },
        noKey = {
            { label = 'دنبال یه چیزی می‌گردم', value = 'donbale_ye_chizi_migardam' }, 
            { label = 'دنبال یه رمز می‌گردم', value = 'donbale_ye_ramz_migardam' },  
        }
    },
    ["g_m_y_salvagoon_01"] = {
        hasKey = {
            { label = 'اومدم دنبال رمز شب', value = 'omadam_donbale_ramze_shab' }, 
            { label = 'شنیدم تو می‌تونی رمز شب را بهم بگی', value = 'shenidam_to_mitoni_ramze_shab_ro_bem_begi' }, 
        },
        noKey = {
            { label = 'خسته شدم از بس دنبال رمز شب گشتم', value = 'khaste_shodam_az_bas_donbale_ramze_shab_gashtam' }, 
            { label = 'سلام رفیق', value = 'salam_refiq' },  
        }
    },
    ["u_m_y_tattoo_01"] = {
        hasKey = {
            { label = 'دنبال رمزی می گردم که مطمئنم فقط تو داری', value = 'donbale_ramzi_migardam_ke_motmaenam_faqat_to_midoni' }, 
            { label = 'می‌تونی کارمو راه بندازی؟', value = 'mitoni_karamo_rah_bendazi' }, 
        },
        noKey = {
            { label = 'چند دقیقه وقت داری', value = 'chand_daqiqe_vaght_dari' }, 
            { label = 'سلام داداش .... ساعت چنده؟', value = 'salam_dadash_saat_chande' },  
        }
    },
    ["a_m_m_salton_02"] = {
        hasKey = {
            { label = 'رمزی داری که منو از این وضعیت نجات بده؟', value = 'ramzi_dari_ke_mano_az_in_vaziat_nejat_bede' }, 
            { label = 'وقتی یه بازی را شروع می کنی چاره‌ای جز ادامه دادن نداری', value = 'vaghti_ye_bazi_ro_shoro_mikoni_chare_joz_edame_dadan_nadari' }, 
        },
        noKey = {
            { label = 'من تو را می‌شناسم ... رمز را کجا گذاشتی؟', value = 'man_toro_mishnasam_ramzo_koja_gozashti' }, 
            { label = 'امشب شب سردیه', value = 'emshab_shabe_sardie' },  
        }
    },
    ["a_m_o_tramp_01"] = {
        hasKey = {
            { label = 'داداش اینورا یه کاغذ پیدا نکردی؟', value = 'dadash_invara_ye_kaqaz_peyda_nakardi' }, 
            { label = 'به قیافت نمی‌خوره بتونی یه رمز را حفظ کنی', value = 'be_qiyafat_nemikhore_betoni_ye_ramzo_hefz_koni' }, 
        },
        noKey = {
            { label = 'اینجا چی کار می کنی؟', value = 'inja_chi_kar_mikoni' }, 
            { label = 'سیگار داری؟', value = 'sigar_dari' },  
        }
    }
}

HashToPed = {}

for k,v in pairs(TalkStatementWithBots) do
    HashToPed[GetHashKey(k)] = k
end

function MakeBotAlive(BotID)
    if BotID == AliveBot then return end
    AliveBot = BotID
    soot(Bots.coords[BotID].BotId)
    Citizen.CreateThread(function()
        while AliveBot > 0 do
            local PlayerCoord = GetEntityCoords(PlayerPedId())
            local dist = Vdist(PlayerCoord, Bots.coords[BotID].x, Bots.coords[BotID].y, Bots.coords[BotID].z)
            if dist <= 3 then
                ESX.ShowHelpNotification('~INPUT_CONTEXT~ Talk to guy')
                if IsControlJustPressed(0, Keys['E']) then
                    local model = HashToPed[GetEntityModel(Bots.coords[BotID].BotId)]
                    ESX.TriggerServerCallback('PX_Cargo:DoesBotHasKey', function(HasKey)
                        if HasKey then
                            function GiveKey()
                                TriggerServerEvent('PX_Cargo:TakeKeyCodeFromDealer', BotID)
                            end
                            ShowConversationMenu(TalkStatementWithBots[model].hasKey, GiveKey)
                        else
                            ShowConversationMenu(TalkStatementWithBots[model].noKey)
                        end
                        AliveBot = 0
                        AlreadyTalkedWith[BotID] = true
                    end, BotID)
                end
            elseif dist > 30 then
                if ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'conversation_mechanic_man') then
                    ESX.UI.Menu.Close('default', GetCurrentResourceName(), 'conversation_mechanic_man')
                end
                AliveBot = 0
            end
            Wait(0)
        end
    end)
end

function CreateMechanicBot()
    Citizen.CreateThread(function()
        RequestModel(`mp_m_exarmy_01`)
                
        while not HasModelLoaded(`mp_m_exarmy_01`) do
            Citizen.Wait(100)
        end
    
        Mechanic = CreatePed(4, `mp_m_exarmy_01`,  Bots.Mechanic.x, Bots.Mechanic.y, Bots.Mechanic.z-1, Bots.Mechanic.h, false, true)
        SetEntityAsMissionEntity(Mechanic)
        SetBlockingOfNonTemporaryEvents(Mechanic, true)
        FreezeEntityPosition(Mechanic, true)
        SetEntityInvincible(Mechanic, true)
    
        local open = false
        while NeedMechanic do
            WaitTime = 3000
            local PlayerCoords = GetEntityCoords(PlayerPedId())
            if GetDistanceBetweenCoords(Bots.Mechanic.x, Bots.Mechanic.y, Bots.Mechanic.z, PlayerCoords, true) <= 3 and not InConversation then
                WaitTime = 0
                ESX.ShowHelpNotification('~INPUT_CONTEXT~ Sohbat kardan ba Mechanic')
                if IsControlJustPressed(0, Keys['E']) then
                    open = true
                    local dialogs = {
                        {label = 'Donbale Ye mashine makhsos Signal ferestadan migardam', value = 'van'},
                    }
                    ShowConversationMenu(dialogs)
                end
            elseif open then
                open = false
                ESX.UI.Menu.Close('default', GetCurrentResourceName(), 'conversation_mechanic_man')
            end
            Wait(WaitTime)
        end
    end)
end


RegisterNetEvent('PX_Cargo:SetVanDoorUnlocked')
AddEventHandler('PX_Cargo:SetVanDoorUnlocked', function(vehicle)
    if DoesEntityExist(vehicle) then
        DrawMarkerForVan(vehicle)
        SetVehicleDoorsLocked(vehicle, 1)
        SetVehicleDoorShut(vehicle, 4, true)
    end
end)

function ActivateHackCitizen(vehicle)
    local HackProcess = true
    Citizen.CreateThread(function()
        while HackProcess do
            Wait(0)
            local PlayerCoord = GetEntityCoords(PlayerPedId())
            local dist = Vdist(PlayerCoord, -1153.52, -2003.06, 12.18)
            if dist <= 2 then
                ESX.ShowHelpNotification('~INPUT_CONTEXT~ Hack kardan mashin')
                if IsControlJustPressed(0, Keys['E']) and not inGame then
                    inGame = true
                    TriggerServerEvent('sr_cargo:StartHackProcess')
                    TriggerEvent("utk_fingerprint:Start", 1, 3, 3, function(outcome)
                        inGame = false
                        if outcome == true then -- reason will be nil if outcome is true
                            ESX.ShowMissionText('Shoma ~r~10 ~w~ Daghighe Vaght Darid Ta Van Ro Be Makane Moshakhas Shode Rooye GPS Beresonid')
                            FreezeEntityPosition(vehicle, false)
                            TriggerServerEvent('sr_cargo:AddTimerForVan', VehToNet(vehicle))
                            SetVehicleDoorsLocked(vehicle, 1)
                            SetVehicleDoorShut(vehicle, 0, false)
                            SetVehicleDoorShut(vehicle, 1, false)
                            SetVehicleDoorShut(vehicle, 2, false)
                            SetVehicleDoorShut(vehicle, 3, false)
                            SetVehicleDoorShut(vehicle, 4, false)
                            SetVehicleDoorShut(vehicle, 5, false)
                            blip = AddBlipForCoord(-1111.81, 4921.7, 217.66)
                            SetBlipSprite(blip, 50)
                            SetBlipRoute(blip,  true)
                            SetBlipRouteColour(blip, 3)
                            NotParkedVan = true
                            HackProcess = false
                            TriggerEvent("PX_Cargo:SetVanDoorUnlocked", vehicle)
                            SetTimeout(8000, function()
                                TriggerEvent("PX_Cargo:CreateDistanceThread")
                            end)
                        end
                    end)
                end
             end
        end
    end)    
end

RegisterNetEvent('sr_cargo:MissionFaild')
AddEventHandler('sr_cargo:MissionFaild', function()
    NotParkedVan = false
    Hacked = true
end)

function DrawMarkerForVan(vehicle)
    Citizen.CreateThread(function()
        local WaitTime
        while NotParkedVan do
            WaitTime = 1000
            local PlayerCoord = GetEntityCoords(PlayerPedId())
            local dist = Vdist(PlayerCoord, Config.SendSignalPos.x, Config.SendSignalPos.y, Config.SendSignalPos.z)
            if dist < 50 then
                RemoveBlip(blip)
                WaitTime = 0
                DrawMarker(1, Config.SendSignalPos.x, Config.SendSignalPos.y, Config.SendSignalPos.z-1.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.5, 1.5, 1.5, 255, 255, 0, 100, false, true, 2, false, false, false, false)
                if dist <= 3 and IsPedInAnyVehicle(PlayerPedId(), false) then
                    local drivedVehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                    if vehicle == drivedVehicle then
                        ESX.ShowHelpNotification('~INPUT_CONTEXT~ Mostaqar kardane Mashin va Tajhizat')
                        if IsControlJustPressed(0, Keys['E']) then
                            SetEntityCoords(drivedVehicle,  Config.SendSignalPos.x, Config.SendSignalPos.y, Config.SendSignalPos.z)
                            SetEntityHeading(drivedVehicle, Config.SendSignalPos.h)
                            FreezeEntityPosition(drivedVehicle, true)
                            SetVehicleOnGroundProperly(drivedVehicle)
                            TriggerSendPositionCitizen(drivedVehicle)
                            NotParkedVan = false
                        end
                    end
                end
            end
            Wait(WaitTime)
        end
    end)
end

function TriggerSendPositionCitizen(vehicle)
    Citizen.CreateThread(function()
        while not Hacked do
            local PlayerCoord = GetEntityCoords(PlayerPedId())
            local dist = Vdist(PlayerCoord, Config.SendSignalWithLabtopPos.x, Config.SendSignalWithLabtopPos.y, Config.SendSignalWithLabtopPos.z)
            if dist < 1.5 then
                ESX.ShowHelpNotification('~INPUT_CONTEXT~ Roshan kardan labtop')
                if IsControlJustPressed(0, Keys['E']) then
                    SetNuiFocus(true, true)
                    SendNUIMessage({
                        show = true
                    })
                end
            end
            Wait(0)
        end
        FreezeEntityPosition(vehicle, false)
    end)
end

RegisterNUICallback('endhackprocess', function()
    Hacked = true
    TriggerServerEvent('PX_Cargo:StartProcess')
end)

RegisterNUICallback('close', function()
    SetNuiFocus(false, false)
end)

function JafarAskCode()
    if #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(Mechanic)) > 5 then
        InConversation = false
        return
    end
    ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'give_key_to_jafar', {
        title = 'Esm Ramz ro vared kon',
    }, function(data, menu)
        local code = tostring(data.value)
        menu.close()
        if code then
            ESX.TriggerServerCallback('PX_Cargo:IsCodeValid', function(valid)
                if valid then
                    TriggerEvent('InteractSound_CL:PlayOnOne', 'money_request', 0.8)
                    Wait(7000)
                    if #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(Mechanic)) > 5 then
                        InConversation = false
                        return
                    end
                    local elements = {
                        {label = 'Enseraf', value = 'cancel'},
                        {label = ('pardakht mablaqe <span style="color:green;">$%s</span>'):format(ESX.Math.GroupDigits(Config.JafarPrice)), value = 'pay'},
                    }
                    ShowConversationMenu(elements)
                else
                    TriggerEvent('InteractSound_CL:PlayOnOne', 'wrong_code', 0.8)
                    Wait(7000)
                    JafarAskCode()
                end
            end, code)
        else
            TriggerEvent('InteractSound_CL:PlayOnOne', 'wrong_code', 0.8)
            Wait(7000)
            JafarAskCode()
        end
    end, function(data, menu)
        TriggerEvent('InteractSound_CL:PlayOnOne', 'cancel', 0.8)
        menu.close()
        Wait(8000)
        InConversation = false
    end)
end

local case = {
    -- dare kilit ro csb_jackhowitzer
    ['donbale_ramze_cargo_hastam'] = function()
        TriggerEvent('InteractSound_CL:PlayOnOne', 'csb_jackhowitzer_01', 0.8)
    end,
    ['khaste_shodam_az_bas_gashtam'] = function()
        TriggerEvent('InteractSound_CL:PlayOnOne', 'csb_jackhowitzer_02', 0.8)
    end,
    -- nadare kilit ro csb_jackhowitzer
    ['ghiyafat_kheyli_maskharast'] = function()
        TriggerEvent('InteractSound_CL:PlayOnOne', 'csb_jackhowitzer_03', 0.8)
    end,
    ['mikham_az_hame_chi_sar_dar_biyaram'] = function()
        TriggerEvent('InteractSound_CL:PlayOnOne', 'csb_jackhowitzer_04', 0.8)
    end,
    -- dare kilit ro g_m_y_mexgoon_01
    ['fekr_konam_to_betoni_komakam_koni'] = function()
        TriggerEvent('InteractSound_CL:PlayOnOne', 'g_m_y_mexgoon_01_01', 0.8)
    end,
    ['ramz_shab_midoni_chie'] = function()
        TriggerEvent('InteractSound_CL:PlayOnOne', 'g_m_y_mexgoon_01_02', 0.8)
    end,
    -- nadare kilit ro g_m_y_mexgoon_01
    ['donbale_ye_chizi_migardam'] = function()
        TriggerEvent('InteractSound_CL:PlayOnOne', 'g_m_y_mexgoon_01_03', 0.8)
    end,
    ['donbale_ye_ramz_migardam'] = function()
        TriggerEvent('InteractSound_CL:PlayOnOne', 'g_m_y_mexgoon_01_04', 0.8)
    end,
    -- dare kilit ro g_m_y_salvagoon_01
    ['omadam_donbale_ramze_shab'] = function()
        TriggerEvent('InteractSound_CL:PlayOnOne', 'g_m_y_salvagoon_01_01', 0.8)
    end,
    ['shenidam_to_mitoni_ramze_shab_ro_bem_begi'] = function()
        TriggerEvent('InteractSound_CL:PlayOnOne', 'g_m_y_salvagoon_01_02', 0.8)
    end,
    -- nadare kilit ro g_m_y_salvagoon_01
    ['khaste_shodam_az_bas_donbale_ramze_shab_gashtam'] = function()
        TriggerEvent('InteractSound_CL:PlayOnOne', 'g_m_y_salvagoon_01_03', 0.8)
    end,
    ['salam_refiq'] = function()
        TriggerEvent('InteractSound_CL:PlayOnOne', 'g_m_y_salvagoon_01_04', 0.8)
    end,
    -- dare kilit ro u_m_y_tattoo_01
    ['donbale_ramzi_migardam_ke_motmaenam_faqat_to_midoni'] = function()
        TriggerEvent('InteractSound_CL:PlayOnOne', 'u_m_y_tattoo_01_01', 0.8)
    end,
    ['mitoni_karamo_rah_bendazi'] = function()
        TriggerEvent('InteractSound_CL:PlayOnOne', 'u_m_y_tattoo_01_02', 0.8)
    end,
    -- nadare kilit ro u_m_y_tattoo_01
    ['salam_dadash_saat_chande'] = function()
        TriggerEvent('InteractSound_CL:PlayOnOne', 'u_m_y_tattoo_01_03', 0.8)
    end,
    ['chand_daqiqe_vaght_dari'] = function()
        TriggerEvent('InteractSound_CL:PlayOnOne', 'u_m_y_tattoo_01_04', 0.8)
    end,
    -- dare kilit ro a_m_m_salton_02
    ['ramzi_dari_ke_mano_az_in_vaziat_nejat_bede'] = function()
        TriggerEvent('InteractSound_CL:PlayOnOne', 'a_m_m_salton_02_01', 0.8)
    end,
    ['vaghti_ye_bazi_ro_shoro_mikoni_chare_joz_edame_dadan_nadari'] = function()
        TriggerEvent('InteractSound_CL:PlayOnOne', 'a_m_m_salton_02_02', 0.8)
    end,
    -- nadare kilit ro a_m_m_salton_02
    ['man_toro_mishnasam_ramzo_koja_gozashti'] = function()
        TriggerEvent('InteractSound_CL:PlayOnOne', 'a_m_m_salton_02_03', 0.8)
    end,
    ['emshab_shabe_sardie'] = function()
        TriggerEvent('InteractSound_CL:PlayOnOne', 'a_m_m_salton_02_04', 0.8)
    end,
    -- dare kilit ro a_m_o_tramp_01
    ['dadash_invara_ye_kaqaz_peyda_nakardi'] = function()
        TriggerEvent('InteractSound_CL:PlayOnOne', 'a_m_o_tramp_01_01', 0.8)
    end,
    ['be_qiyafat_nemikhore_betoni_ye_ramzo_hefz_koni'] = function()
        TriggerEvent('InteractSound_CL:PlayOnOne', 'a_m_o_tramp_01_02', 0.8)
    end,
    -- nadare kilit ro a_m_o_tramp_01
    ['inja_chi_kar_mikoni'] = function()
        TriggerEvent('InteractSound_CL:PlayOnOne', 'a_m_o_tramp_01_03', 0.8)
    end,
    ['sigar_dari'] = function()
        TriggerEvent('InteractSound_CL:PlayOnOne', 'a_m_o_tramp_01_04', 0.8)
    end,
    ['van'] = function()
        InConversation = true
        ESX.TriggerServerCallback('PX_Cargo:CheckCargoAvalibility', function(police, labtop, cargo)
            if cargo < Config.CargoCooldown then
                ESX.ShowNotification(('Cargo Robbery Baraye ~r~%s~w~ Daghighe Digar Dar Dastres Nist'):format(math.floor((3600 - cargo) / (60))))
                TriggerEvent('InteractSound_CL:PlayOnOne', 'Cargo_Cooldown', 0.8)
                Wait(5000)
                InConversation = false
            elseif not police then
                TriggerEvent('InteractSound_CL:PlayOnOne', 'police_check', 0.8)
                Wait(5000)
                InConversation = false
            elseif not labtop then
                TriggerEvent('InteractSound_CL:PlayOnOne', 'labtop_check', 0.8)
                Wait(5000)
                InConversation = false
            else
                TriggerEvent('InteractSound_CL:PlayOnOne', 'code_request', 0.8)
                Wait(6500)
                JafarAskCode()
            end
        end)
    end,
    ['pay'] = function()
        if #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(Mechanic)) > 5 then
            InConversation = false
            return
        end
        Wait(math.random(1, 5000))
        ESX.TriggerServerCallback('PX_Cargo:MoneyRequest', function(pay)
            if pay then
                TriggerEvent('InteractSound_CL:PlayOnOne', 'complete', 0.8)

                local shokol = GetClosestVehicle(-1154.9, -2005.6, 12.68, 7.0, 0, 71)
                if DoesEntityExist(shokol) then ESX.Game.DeleteVehicle(shokol) end

                ESX.Game.SpawnVehicle('youga', {
                    x = -1154.9,
                    y = -2005.6,
                    z = 12.68 + 1
                }, 332.74, function(callback_vehicle)
                    SetVehRadioStation(callback_vehicle, "OFF")
                    Citizen.Wait(100)
                    ToggleVehicleMod(callback_vehicle,  18, true)
                    SetVehicleMod(callback_vehicle, 11, 3, false)
                    SetVehicleFuelLevel(callback_vehicle, 100.0)
                    FreezeEntityPosition(callback_vehicle, true)
                    SetVehicleDoorsLocked(callback_vehicle, true)
                    SetVehicleDoorShut(callback_vehicle, 0, false)
                    SetVehicleDoorShut(callback_vehicle, 1, false)
                    SetVehicleDoorShut(callback_vehicle, 2, false)
                    SetVehicleDoorShut(callback_vehicle, 3, false)
                    SetVehicleDoorShut(callback_vehicle, 4, false)
                    SetVehicleDoorShut(callback_vehicle, 5, false)
                    SetVehicleDoorsLocked(callback_vehicle, 2)
                    SetVehicleDoorOpen(callback_vehicle, 4, false)
                    ActivateHackCitizen(callback_vehicle)
                    TriggerEvent("sr_cargo:JafarPiad")
                end)
            else
                ESX.ShowNotification('Shoma pool kafi nadarid')
                TriggerEvent('InteractSound_CL:PlayOnOne', 'cancel', 0.8)
                Wait(8000)
                InConversation = false
            end
        end)
    end,
    ['cancel'] = function()
        TriggerEvent('InteractSound_CL:PlayOnOne', 'cancel', 0.8)
        Wait(8000)
        InConversation = false
    end
}

RegisterNetEvent('sr_cargo:JafarPiad')
AddEventHandler('sr_cargo:JafarPiad', function()
    NeedMechanic = false 

    FreezeEntityPosition(Mechanic, false)
    TaskGoStraightToCoord(Mechanic, Config.Mechanic.CooldownPos.x, Config.Mechanic.CooldownPos.y, Config.Mechanic.CooldownPos.z, 1.0, 5000, Config.Mechanic.CooldownPos.h)
    Wait(5000)
    FreezeEntityPosition(Mechanic, true)
    TriggerEvent('sr_doorlock:setState', 'Cargo', 1, false)
end)

radiusBlip = 0

RegisterNetEvent('sr_cargo:ShowVehiclePos')
AddEventHandler('sr_cargo:ShowVehiclePos', function(Coords)
    SetBlip(Coords)
    ESX.ShowNotification("~y~~h~Cargo Robbery Aghaz Shode Ast")
end)

function SetBlip(Coords)
	local Blip = AddBlipForCoord(Coords.x, Coords.y, Coords.z)
	SetBlipSprite(Blip, 161)
	SetBlipScale(Blip, 1.5)
	SetBlipColour(Blip, 27)
	PulseBlip(Blip)
	local RBlip = AddBlipForRadius(Coords.x, Coords.y, Coords.z, 550.0)
	SetBlipSprite(RBlip, 1)
	SetBlipColour(RBlip, 63)
	SetBlipAlpha(RBlip, 170)
	SetTimeout(240000, function()
	RemoveBlip(Blip)
	RemoveBlip(RBlip)
	end)
end

function ShowConversationMenu(elements, callback)
    local Inventory = ESX.GetPlayerData().inventory
    local elements  = elements

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'conversation_mechanic_man',
    {
        title    = 'Yeki ro entekhab kon',
        align    = 'center',
        elements = elements
    }, function(data, menu)
        menu.close()
        case[data.current.value]()
        if callback then callback() end
    end, function(data, menu)
        menu.close()
        InConversation = false
    end)
end

AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() then
        SetEntityAsMissionEntity(pilot, false, true)
        DeleteEntity(pilot)
        SetEntityAsMissionEntity(aircraft, false, true)
        DeleteEntity(aircraft)
        DeleteEntity(parachute)
        DeleteEntity(crate)
        DeleteEntity(pickup)
        RemoveBlip(blip)
        StopSound(soundID)
        ReleaseSoundId(soundID)

        for i = 1, #requiredModels do
            Wait(0)
            SetModelAsNoLongerNeeded(GetHashKey(requiredModels[i]))
        end

    end
end)

Citizen.CreateThread(function()
    local blip = AddBlipForCoord(Config.DropCoord.x, Config.DropCoord.y, Config.DropCoord.z)
    SetBlipSprite(blip, 564)
    SetBlipScale(blip, 1.2)
    SetBlipColour(blip, 25)
    SetBlipAsShortRange(blip, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString('Cargo Robbery')
    EndTextCommandSetBlipName(blip)
end)

RegisterNetEvent('PX_Cargo:CreateDistanceThread') --- lol xD
AddEventHandler('PX_Cargo:CreateDistanceThread', function()
  local Seceonds = 59
  local Minutes  = 9
  Citizen.CreateThread(function()
    while true do
      if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), Config.SendSignalWithLabtopPos.x, Config.SendSignalWithLabtopPos.y, Config.SendSignalWithLabtopPos.z, false) < 30.0 then
        ESX.ShowMissionText("~g~Zaman Baghi Mande : ~g~0"..Minutes..":"..Seceonds)
        ESX.ShowNotification("~g~~h~Shoma Be Mahal Cargo Residid.")
        TriggerServerEvent("PX_Cargo:ImArrived")
        break
      else
        if Seceonds < 10 then
          ESX.ShowMissionText("~r~Zaman Baghi Mande : ~y~0"..Minutes..":0"..Seceonds)
            if Seceonds == 0 then
              if Minutes == 0 and Seceonds == 0 then
                ESX.ShowNotification("~r~~h~XP Gang Shoma Be Dalil Naresidan Dar Time Hazf Shod.")
                ESX.ShowMissionText("~r~Zaman Baghi Mande : ~r~00:00")
                break
              else
                Minutes = Minutes - 1
                Seceonds = 60
              end
            end
        else
            ESX.ShowMissionText("~r~Zaman Baghi Mande : ~y~0"..Minutes..":"..Seceonds)
        end
        Seceonds = Seceonds - 1
        Citizen.Wait(1000)
      end
    end
  end)
end)