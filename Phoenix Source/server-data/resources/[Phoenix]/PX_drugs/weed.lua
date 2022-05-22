ESX = nil


local used = false
local gathering = false
local packaged = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
    while true do
        local sleep = 1500
        local playerPed = PlayerPedId()
        local playerCoord = GetEntityCoords(playerPed)
        local dst = #(playerCoord - Config.Weed.entry.coord)
        if dst < 20 and not used then
            sleep = 1
            DrawMarker(2, Config.Weed.entry.coord, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.7, 0.7, 0.5, 44, 194, 33, 255, false, false, false, 1, false, false, false)
            if dst < 3 then
                DrawText3D(Config.Weed.entry.coord.x, Config.Weed.entry.coord.y, Config.Weed.entry.coord.z + 0.20, 0.30, Config.Weed.entry.text)
                if IsControlJustPressed(0, 38) and not used then
                    used = true
                    teleport(Config.Weed.entry.intcoord, Config.Weed.entry.intheading)
                    used = false
                end
            end
        end
            local dst2 = #(playerCoord - Config.Weed.exit.intcoord)
            if dst2 < 5 then
                sleep = 1
                DrawMarker(2, Config.Weed.exit.intcoord, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.7, 0.7, 0.5, 44, 194, 33, 255, false, false, false, 1, false, false, false)
                if dst2 < 2 then
                    DrawText3D(Config.Weed.exit.intcoord.x, Config.Weed.exit.intcoord.y, Config.Weed.exit.intcoord.z + 0.20, 0.30, Config.Weed.exit.text)
                    if IsControlJustPressed(0, 38) then
                        used = true
                        teleport(Config.Weed.exit.coord, Config.Weed.exit.heading)
                        used = false
                    end
                end
            end
        Citizen.Wait(sleep)
    end
end)

Citizen.CreateThread(function()
    while true do
        local sleep = 1500
        local playerPed = PlayerPedId()
        local playerCoord = GetEntityCoords(playerPed)
        for k,v in pairs(Config.Weed.gatheringZone.coords) do
            local dst = #(playerCoord - v.coord)
            if dst < 5 then
                sleep = 1
                if dst < 3.5 and not gathering then
                    DrawMarker(2, v.coord, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.7, 0.7, 0.5, 44, 194, 33, 255, false, false, false, 1, false, false, false)
                    DrawText3D(v.coord.x, v.coord.y, v.coord.z + 0.20, 0.30, Config.Weed.gatheringZone.text)
                    if IsControlJustPressed(0, 38) and not gathering then
                        gathering = true
                        TriggerEvent("PX_drugs:gatheringWeed", v.coord, v.heading)
                    end
                end
            end
        end
        Citizen.Wait(sleep)
    end
end)

RegisterNetEvent("PX_drugs:gatheringWeed")
AddEventHandler("PX_drugs:gatheringWeed", function(coord, heading)
    local playerPed = PlayerPedId()
    local animDict = "anim@amb@business@weed@weed_inspecting_lo_med_hi@"
    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do Citizen.Wait(10) end
    SetEntityHeading(playerPed, heading)
    TriggerEvent('OW:Whitelist',
    6, ---ban type
    true --- state of that
    )
    SetEntityCoords(playerPed, coord.x, coord.y, coord.z-1.0)
    Citizen.Wait(10)
    TaskPlayAnim(playerPed, animDict, "weed_spraybottle_crouch_spraying_02_inspector", 8.0, 8.0, 1065353216, 0, 1, 0, 0, 0)
    Citizen.Wait(15000)
    TriggerServerEvent("PX_drugs:giveItem", "weed", Config.Weed.gatheringZone.count)
    Citizen.Wait(1000)
    TriggerEvent('OW:Whitelist',
    6, ---ban type
    false --- state of that
    )
    gathering = false
end)

Citizen.CreateThread(function()
    while true do
        local sleep = 1500
        local playerPed = PlayerPedId()
        local playerCoord = GetEntityCoords(playerPed)
        for k,v in pairs(Config.Weed.packageZone.coords) do
            local dst = #(playerCoord - v.coord)
            if dst < 5 and not packaged then
                sleep = 1
                DrawMarker(2, v.coord.x, v.coord.y, v.coord.z-0.50, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.7, 0.7, 0.5, 44, 194, 33, 255, false, false, false, 1, false, false, false)
                if dst < 2 then
                    DrawText3D(v.coord.x, v.coord.y, v.coord.z -0.30, 0.30, Config.Weed.packageZone.text)
                    if IsControlJustPressed(0, 38) then
                        ESX.TriggerServerCallback("PX_drugs:checkItem", function(output)
                            if output then
                                packaged = true
                                TriggerServerEvent("PX_drugs:removeItem", 'weed', Config.Weed.packageZone.count)
                                TriggerEvent("PX_drugs:packageWeed", v.coord, v.heading, v.rotx, v.roty, v.rotz)
                            else
                                ESX.ShowNotification("~r~Shoma Mariguana Nadarid")
                            end
                        end, 'weed', Config.Weed.packageZone.count)
                    end
                end
            end
        end
        Citizen.Wait(sleep)
    end
end)

local Items = {
    'bkr_prop_weed_dry_01a',
    'bkr_prop_weed_leaf_01a',
    'bkr_prop_weed_bag_01a',
    'bkr_prop_weed_bud_02b',
    'bkr_prop_weed_bud_02a',
    'bkr_prop_weed_bag_pile_01a',
    'bkr_prop_weed_bucket_open_01a',      
}

RegisterNetEvent("PX_drugs:packageWeed")
AddEventHandler("PX_drugs:packageWeed", function(coord, heading, rotx, roty, rotz)
    local playerPed = PlayerPedId()
    local animDict = "anim@amb@business@weed@weed_sorting_seated@"
    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do Citizen.Wait(10) end
    RequestModel("bkr_prop_weed_dry_01a")
    RequestModel("bkr_prop_weed_leaf_01a")
    RequestModel("bkr_prop_weed_bag_01a")
    RequestModel("bkr_prop_weed_bud_02b")
    RequestModel("bkr_prop_weed_bud_02a")
    RequestModel("bkr_prop_weed_bag_pile_01a")
    RequestModel("bkr_prop_weed_bucket_open_01a")
    while not HasModelLoaded("bkr_prop_weed_dry_01a") and not HasModelLoaded("bkr_prop_weed_leaf_01a") and not HasModelLoaded("bkr_prop_weed_bag_01a") and not HasModelLoaded("bkr_prop_weed_bud_02b") and not HasModelLoaded("bkr_prop_weed_bud_02a") and not HasModelLoaded("bkr_prop_weed_bag_pile_01a") and not HasModelLoaded("bkr_prop_weed_bucket_open_01a") do Citizen.Wait(50) end
    SetEntityHeading(playerPed, heading)
    Citizen.Wait(10)
    local packScene = NetworkCreateSynchronisedScene(coord.x+rotx, coord.y+roty, coord.z+rotz, 0.0, 0.0, 90.0, 2, false, false, 1065353216, 0, 1.3)
    local packScene2 = NetworkCreateSynchronisedScene(coord.x+rotx, coord.y+roty, coord.z+rotz, 0.0, 0.0, 90.0, 2, false, false, 1065353216, 0, 1.3)
    local packScene3 = NetworkCreateSynchronisedScene(coord.x+rotx, coord.y+roty, coord.z+rotz, 0.0, 0.0, 90.0, 2, false, false, 1065353216, 0, 1.3)
    local packScene4 = NetworkCreateSynchronisedScene(coord.x+rotx, coord.y+roty, coord.z+rotz, 0.0, 0.0, 90.0, 2, false, false, 1065353216, 0, 1.3)
    local packScene5 = NetworkCreateSynchronisedScene(coord.x+rotx, coord.y+roty, coord.z+rotz, 0.0, 0.0, 90.0, 2, false, false, 1065353216, 0, 1.3)
    local packScene6 = NetworkCreateSynchronisedScene(coord.x+rotx, coord.y+roty, coord.z+rotz, 0.0, 0.0, 90.0, 2, false, false, 1065353216, 0, 1.3)
    local dry = CreateObject(GetHashKey("bkr_prop_weed_dry_01a"), coord.x, coord.y, coord.z-20, true, false, false)
    local dry2 = CreateObject(GetHashKey("bkr_prop_weed_dry_01a"), coord.x, coord.y, coord.z-20, true, false, false)
    local leaf = CreateObject(GetHashKey("bkr_prop_weed_leaf_01a"), coord.x, coord.y, coord.z-20, true, false, false)
    local leaf2 = CreateObject(GetHashKey("bkr_prop_weed_leaf_01a"), coord.x, coord.y, coord.z-20, true, false, false)
    local bag = CreateObject(GetHashKey("bkr_prop_weed_bag_01a"), coord.x, coord.y, coord.z-20, true, false, false)
    local bud = CreateObject(GetHashKey("bkr_prop_weed_bud_02b"), coord.x, coord.y, coord.z-20, true, false, false)
    local bud2 = CreateObject(GetHashKey("bkr_prop_weed_bud_02b"), coord.x, coord.y, coord.z-20, true, false, false)
    local bud3 = CreateObject(GetHashKey("bkr_prop_weed_bud_02b"), coord.x, coord.y, coord.z-20, true, false, false)
    local bud4 = CreateObject(GetHashKey("bkr_prop_weed_bud_02b"), coord.x, coord.y, coord.z-20, true, false, false)
    local bud5 = CreateObject(GetHashKey("bkr_prop_weed_bud_02b"), coord.x, coord.y, coord.z-20, true, false, false)
    local bud6 = CreateObject(GetHashKey("bkr_prop_weed_bud_02b"), coord.x, coord.y, coord.z-20, true, false, false)
    local bud7 = CreateObject(GetHashKey("bkr_prop_weed_bud_02a"), coord.x, coord.y, coord.z-20, true, false, false)
    local bud8 = CreateObject(GetHashKey("bkr_prop_weed_bud_02a"), coord.x, coord.y, coord.z-20, true, false, false)
    local bud9 = CreateObject(GetHashKey("bkr_prop_weed_bud_02a"), coord.x, coord.y, coord.z-20, true, false, false)
    local bag2 = CreateObject(GetHashKey("bkr_prop_weed_bag_pile_01a"), coord.x, coord.y, coord.z-20, true, false, false)
    local buck = CreateObject(GetHashKey("bkr_prop_weed_bucket_open_01a"), coord.x, coord.y, coord.z-20, true, false, false)
    local buck2 = CreateObject(GetHashKey("bkr_prop_weed_bucket_open_01a"), coord.x, coord.y, coord.z-20, true, false, false)
    Wait(100)
    while not DoesEntityExist(buck2) or not DoesEntityExist(buck) or not DoesEntityExist(bag2) or not DoesEntityExist(bud9) or not DoesEntityExist(dry) or not DoesEntityExist(dry2) or not DoesEntityExist(leaf) or not DoesEntityExist(leaf2) or not DoesEntityExist(bag) or not DoesEntityExist(bud) or not DoesEntityExist(bud2) or not DoesEntityExist(bud3) or not DoesEntityExist(bud4) or not DoesEntityExist(bud5) or not DoesEntityExist(bud6) or not DoesEntityExist(bud7) or not DoesEntityExist(bud8) do
        Wait(0)
    end
    NetworkAddPedToSynchronisedScene(playerPed, packScene, animDict, "sorter_right_sort_v3_sorter02", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(dry, packScene, animDict, "sorter_right_sort_v3_weeddry01a", 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(dry2, packScene, animDict, "sorter_right_sort_v3_weeddry01a^1", 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(leaf, packScene, animDict, "sorter_right_sort_v3_weedleaf01a", 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(leaf2, packScene2, animDict, "sorter_right_sort_v3_weedleaf01a^1", 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(bag, packScene2, animDict, "sorter_right_sort_v3_weedbag01a", 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(bud, packScene2, animDict, "sorter_right_sort_v3_weedbud02b", 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(bud2, packScene3, animDict, "sorter_right_sort_v3_weedbud02b^1", 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(bud3, packScene3, animDict, "sorter_right_sort_v3_weedbud02b^2", 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(bud4, packScene3, animDict, "sorter_right_sort_v3_weedbud02b^3", 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(bud5, packScene4, animDict, "sorter_right_sort_v3_weedbud02b^4", 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(bud6, packScene4, animDict, "sorter_right_sort_v3_weedbud02b^5", 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(bud7, packScene4, animDict, "sorter_right_sort_v3_weedbud02a", 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(bud8, packScene5, animDict, "sorter_right_sort_v3_weedbud02a^1", 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(bud9, packScene5, animDict, "sorter_right_sort_v3_weedbud02a^2", 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(bag2, packScene5, animDict, "sorter_right_sort_v3_weedbagpile01a", 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(buck, packScene6, animDict, "sorter_right_sort_v3_bucket01a", 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(buck2, packScene6, animDict, "sorter_right_sort_v3_bucket01a^1", 4.0, -8.0, 1)
    NetworkStartSynchronisedScene(packScene)
    NetworkStartSynchronisedScene(packScene2)
    NetworkStartSynchronisedScene(packScene3)
    NetworkStartSynchronisedScene(packScene4)
    NetworkStartSynchronisedScene(packScene5)
    NetworkStartSynchronisedScene(packScene6)
    Citizen.Wait(24000)
    NetworkStopSynchronisedScene(packScene)
    NetworkStopSynchronisedScene(packScene2)
    NetworkStopSynchronisedScene(packScene3)
    NetworkStopSynchronisedScene(packScene4)
    NetworkStopSynchronisedScene(packScene5)
    NetworkStopSynchronisedScene(packScene6)
    DeleteEntity(dry)
    DeleteEntity(dry2)
    DeleteEntity(leaf)
    DeleteEntity(leaf2)
    DeleteEntity(bag)
    DeleteEntity(bag2)
    DeleteEntity(bud)
    DeleteEntity(bud2)
    DeleteEntity(bud3)
    DeleteEntity(bud4)
    DeleteEntity(bud5)
    DeleteEntity(bud6)
    DeleteEntity(bud7)
    DeleteEntity(bud8)
    DeleteEntity(bud9)
    DeleteEntity(buck)
    DeleteEntity(buck2)
    while packaged do
        local playerPed = PlayerPedId()
        local playerCoord = GetEntityCoords(playerPed)
        local dst = #(playerCoord - coord)
        if dst < 3 then
            DrawMarker(2, coordcoord, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.7, 0.7, 0.5, 44, 194, 33, 255, false, false, false, 1, false, false, false)
            DrawText3D(coord.x, coord.y, coord.z + 0.20, 0.30, Config.Weed.packageZone.takeText)
        end
        if dst < 1.5 then
            if IsControlJustPressed(0, 38) then
                ESX.TriggerServerCallback("PX_drugs:checkCanCarryItem", function(output) 
                    if output then
                        TriggerServerEvent("PX_drugs:giveItem", 'packagedweed', Config.Weed.packageZone.count)
                        packaged = false
                    else
                        ESX.ShowNotification("Estas lleno!")
                    end
                end, 'packagedweed', Config.Weed.packageZone.count)
            end
        end
        Citizen.Wait(1)
    end
end)


function teleport(coord, heading)
	DoScreenFadeOut(500)
	Citizen.Wait(2000)
	SetEntityCoords(PlayerPedId(), coord.x, coord.y, coord.z-1.0)
	SetEntityHeading(PlayerPedId(), heading)
	DoScreenFadeIn(500)
end

function DrawText3D(x, y, z, scale, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    -- local scale = 0.35
    if onScreen then
        SetTextScale(scale, scale)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextDropshadow(0)
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
        local factor = (string.len(text)) / 200
        DrawRect(_x, _y + 0.0120, 0.0 + factor, 0.025, 41, 11, 41, 100)
    end
end


