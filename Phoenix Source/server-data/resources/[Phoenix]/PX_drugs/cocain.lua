
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
        local dst = #(playerCoord - Config.Coca.entry.coord)
        if dst < 20 and not used then
            sleep = 1
            DrawMarker(2, Config.Coca.entry.coord, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.7, 0.7, 0.5, 44, 194, 33, 255, false, false, false, 1, false, false, false)
            if dst < 3 then
                DrawText3D(Config.Coca.entry.coord.x, Config.Coca.entry.coord.y, Config.Coca.entry.coord.z + 0.20, 0.30, Config.Coca.entry.text)
                if IsControlJustPressed(0, 38) and not used then
                    used = true
                    teleport(Config.Coca.entry.intcoord, Config.Coca.entry.intheading)
                    used = false
                end
            end
        end
            local dst2 = #(playerCoord - Config.Coca.exit.intcoord)
            if dst2 < 5 then
                sleep = 1
                DrawMarker(2, Config.Coca.exit.intcoord, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.7, 0.7, 0.5, 44, 194, 33, 255, false, false, false, 1, false, false, false)
                if dst2 < 2 then
                    DrawText3D(Config.Coca.exit.intcoord.x, Config.Coca.exit.intcoord.y, Config.Coca.exit.intcoord.z + 0.20, 0.30, Config.Coca.exit.text)
                    if IsControlJustPressed(0, 38) then
                        used = true
                        teleport(Config.Coca.exit.coord, Config.Coca.exit.heading)
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
        for k,v in pairs(Config.Coca.gatheringZone.coords) do
            local dst = #(playerCoord - v.coord)
            if dst < 5 then
                sleep = 1
                if dst < 1.5 and not gathering then
                    DrawMarker(2, v.coord, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.7, 0.7, 0.5, 44, 194, 33, 255, false, false, false, 1, false, false, false)
                    DrawText3D(v.coord.x, v.coord.y, v.coord.z + 0.20, 0.30, Config.Coca.gatheringZone.text)
                    if IsControlJustPressed(0, 38) and not gathering then
                        gathering = true
                        TriggerEvent("PX_drugs:gatheringCoca", v.coord, v.heading, v.rotx, v.roty, v.rotz)
                    end
                end
            end
        end
        Citizen.Wait(sleep)
    end
end)

RegisterNetEvent("PX_drugs:gatheringCoca")
AddEventHandler("PX_drugs:gatheringCoca", function(coord, heading, rotx, roty, rotz)
    local playerPed = PlayerPedId()
    local animDict = "anim@amb@business@coc@coc_unpack_cut_left@"
    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do Citizen.Wait(10) end
    RequestModel("bkr_prop_coke_bakingsoda_o")
    RequestModel("prop_cs_credit_card")
    while not HasModelLoaded("prop_cs_credit_card") and not HasModelLoaded("bkr_prop_coke_bakingsoda_o") do Citizen.Wait(10) end
    SetEntityHeading(playerPed, heading)
    Citizen.Wait(10)
    local card = CreateObject(GetHashKey("prop_cs_credit_card"), coord.x, coord.y, coord.z-20, true, false, false)
    local card2 = CreateObject(GetHashKey("prop_cs_credit_card"), coord.x, coord.y, coord.z-20, true, false, false)
    local soda = CreateObject(GetHashKey("bkr_prop_coke_bakingsoda_o"), coord.x, coord.y, coord.z-20, true, false, false)
    while not DoesEntityExist(card) or not DoesEntityExist(card2) or not DoesEntityExist(soda) do
        Wait(0)
    end
    local gathScene = NetworkCreateSynchronisedScene(coord.x+rotx, coord.y+roty, coord.z+rotz, 0.0, 0.0, 0.0, 2, false, false, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(playerPed, gathScene, animDict, "coke_cut_v5_coccutter", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(card, gathScene, animDict, "coke_cut_v5_creditcard", 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(card2, gathScene, animDict, "coke_cut_v5_creditcard^1", 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(soda, gathScene, animDict, "coke_cut_v5_bakingsoda", 4.0, -8.0, 1)
    NetworkStartSynchronisedScene(gathScene)
    Citizen.Wait(20000)
    NetworkStopSynchronisedScene(gathScene)
    DeleteEntity(card)
    DeleteEntity(card2)
    DeleteEntity(soda) 
	while gathering do
		local playerPed = PlayerPedId()
		local playerCoord = GetEntityCoords(playerPed)
		local dst = #(playerCoord - coord)
		if dst < 3 then
			DrawMarker(2, coord, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.7, 0.7, 0.5, 44, 194, 33, 255, false, false, false, 1, false, false, false)
			DrawText3D(coord.x, coord.y, coord.z + 0.20, 0.30, Config.Coca.gatheringZone.takeCoca)
		end
		if dst < 1.5 then
			if IsControlJustPressed(0, 38) then
				ESX.TriggerServerCallback("PX_drugs:checkCanCarryItem", function(output) 
					if output then
						TriggerServerEvent("PX_drugs:giveItem", 'coca', Config.Coca.gatheringZone.count)
                        gathering = false
					else
						ESX.ShowNotification("Ya estas lleno!")
					end
				end, 'coca', Config.Coca.gatheringZone.count)
			end
		end
		Citizen.Wait(1)
	end
end)

Citizen.CreateThread(function()
    while true do
        local sleep = 1500
        local playerPed = PlayerPedId()
        local playerCoord = GetEntityCoords(playerPed)
        local dst = #(playerCoord - Config.Coca.packageZone.coord)
        if dst < 5 and not packaged then
            sleep = 1
            DrawMarker(2, Config.Coca.packageZone.coord, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.7, 0.7, 0.5, 44, 194, 33, 255, false, false, false, 1, false, false, false)
            if dst < 2 then
                DrawText3D(Config.Coca.packageZone.coord.x, Config.Coca.packageZone.coord.y, Config.Coca.packageZone.coord.z + 0.20, 0.30, Config.Coca.packageZone.text)
                if IsControlJustPressed(0, 38) then
                    ESX.TriggerServerCallback("PX_drugs:checkItem", function(output)
                        if output then
                            packaged = true
                            TriggerServerEvent("PX_drugs:removeItem", 'coca', Config.Coca.gatheringZone.count)
                            TriggerEvent("PX_drugs:packageCoca")
                        else
                            ESX.ShowNotification("~r~Shoma Cocain Nadarid")
                        end
                    end, 'coca', Config.Coca.gatheringZone.count)
                end
            end
        end
        Citizen.Wait(sleep)
    end
end)

local Items = {
    'bkr_prop_coke_fullscoop_01a',
    'bkr_prop_coke_doll',
    'bkr_prop_coke_boxedDoll',
    'bkr_prop_coke_dollCast',
    'bkr_prop_coke_dollmould',
    'bkr_prop_coke_fullmetalbowl_02',
    'bkr_prop_coke_press_01b',      
    'bkr_prop_coke_dollboxfolded',
}

RegisterNetEvent("PX_drugs:packageCoca")
AddEventHandler("PX_drugs:packageCoca", function()
    local playerPed = PlayerPedId()
    local animDict = "anim@amb@business@coc@coc_packing_hi@"
    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do Citizen.Wait(10) end
    RequestModel("bkr_prop_coke_fullscoop_01a")
    RequestModel("bkr_prop_coke_doll")
    RequestModel("bkr_prop_coke_boxedDoll")
    RequestModel("bkr_prop_coke_dollmould")
    RequestModel("bkr_prop_coke_fullmetalbowl_02")
    RequestModel("bkr_prop_coke_press_01b")
    RequestModel("bkr_prop_coke_dollboxfolded")
    while not HasModelLoaded("bkr_prop_coke_fullscoop_01a") and not HasModelLoaded("bkr_prop_coke_doll") and not HasModelLoaded("bkr_prop_coke_boxedDoll") and not HasModelLoaded("bkr_prop_coke_dollCast") and not HasModelLoaded("bkr_prop_coke_dollmould") and not HasModelLoaded("bkr_prop_coke_fullmetalbowl_02") and not HasModelLoaded("bkr_prop_coke_press_01b") and not HasModelLoaded("bkr_prop_coke_dollboxfolded") do Citizen.Wait(50) end
    SetEntityHeading(playerPed, Config.Coca.packageZone.heading)
    Citizen.Wait(10)
    local packScene = NetworkCreateSynchronisedScene(Config.Coca.packageZone.coord.x-7.66, Config.Coca.packageZone.coord.y+2.17, Config.Coca.packageZone.coord.z-1.0, 0.0, 0.0, 0.0, 2, false, false, 1065353216, 0, 1.3)
    local packScene2 = NetworkCreateSynchronisedScene(Config.Coca.packageZone.coord.x-7.66, Config.Coca.packageZone.coord.y+2.17, Config.Coca.packageZone.coord.z-1.0, 0.0, 0.0, 0.0, 2, false, false, 1065353216, 0, 1.3)
    local packScene3 = NetworkCreateSynchronisedScene(Config.Coca.packageZone.coord.x-7.66, Config.Coca.packageZone.coord.y+2.17, Config.Coca.packageZone.coord.z-1.0, 0.0, 0.0, 0.0, 2, false, false, 1065353216, 0, 1.3)
    local packScene4 = NetworkCreateSynchronisedScene(Config.Coca.packageZone.coord.x-7.66, Config.Coca.packageZone.coord.y+2.17, Config.Coca.packageZone.coord.z-1.0, 0.0, 0.0, 0.0, 2, false, false, 1065353216, 0, 1.3)
    local scoop = CreateObject(GetHashKey("bkr_prop_coke_fullscoop_01a"), Config.Coca.packageZone.coord.x, Config.Coca.packageZone.coord.y, Config.Coca.packageZone.coord.z, true, false, false)
    local doll = CreateObject(GetHashKey("bkr_prop_coke_doll"), Config.Coca.packageZone.coord.x, Config.Coca.packageZone.coord.y, Config.Coca.packageZone.coord.z, true, false, false)
    local boxed = CreateObject(GetHashKey("bkr_prop_coke_boxedDoll"), Config.Coca.packageZone.coord.x, Config.Coca.packageZone.coord.y, Config.Coca.packageZone.coord.z, true, false, false)
    local dollcast = CreateObject(GetHashKey("bkr_prop_coke_dollCast"), Config.Coca.packageZone.coord.x, Config.Coca.packageZone.coord.y, Config.Coca.packageZone.coord.z, true, false, false)
    local dollcast2 = CreateObject(GetHashKey("bkr_prop_coke_dollCast"), Config.Coca.packageZone.coord.x, Config.Coca.packageZone.coord.y, Config.Coca.packageZone.coord.z, true, false, false)
    local dollcast3 = CreateObject(GetHashKey("bkr_prop_coke_dollCast"), Config.Coca.packageZone.coord.x, Config.Coca.packageZone.coord.y, Config.Coca.packageZone.coord.z, true, false, false)
    local dollcast4 = CreateObject(GetHashKey("bkr_prop_coke_dollCast"), Config.Coca.packageZone.coord.x, Config.Coca.packageZone.coord.y, Config.Coca.packageZone.coord.z, true, false, false)
    local dollmold = CreateObject(GetHashKey("bkr_prop_coke_dollmould"), Config.Coca.packageZone.coord.x, Config.Coca.packageZone.coord.y, Config.Coca.packageZone.coord.z, true, false, false)
    local bowl = CreateObject(GetHashKey("bkr_prop_coke_fullmetalbowl_02"), Config.Coca.packageZone.coord.x, Config.Coca.packageZone.coord.y, Config.Coca.packageZone.coord.z, true, false, false)
    local press = CreateObject(GetHashKey("bkr_prop_coke_press_01b"), Config.Coca.packageZone.coord.x, Config.Coca.packageZone.coord.y, Config.Coca.packageZone.coord.z, true, false, false)
    local box1 = CreateObject(GetHashKey("bkr_prop_coke_dollboxfolded"), Config.Coca.packageZone.coord.x, Config.Coca.packageZone.coord.y, Config.Coca.packageZone.coord.z, true, false, false)
    NetworkAddPedToSynchronisedScene(playerPed, packScene, animDict, "full_cycle_v3_pressoperator", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(scoop, packScene, animDict, "full_cycle_v3_scoop", 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(doll, packScene, animDict, "full_cycle_v3_cocdoll", 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(boxed, packScene, animDict, "full_cycle_v3_boxedDoll", 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(dollcast, packScene2, animDict, "full_cycle_v3_dollcast", 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(dollcast2, packScene2, animDict, "full_cycle_v3_dollCast^1", 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(dollcast3, packScene2, animDict, "full_cycle_v3_dollCast^2", 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(dollcast4, packScene3, animDict, "full_cycle_v3_dollCast^3", 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(dollmold, packScene3, animDict, "full_cycle_v3_dollmould", 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(bowl, packScene3, animDict, "full_cycle_v3_cocbowl", 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(press, packScene4, animDict, "full_cycle_v3_cokePress", 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(box1, packScene4, animDict, "full_cycle_v3_FoldedBox", 4.0, -8.0, 1)
    NetworkStartSynchronisedScene(packScene)
    NetworkStartSynchronisedScene(packScene2)
    NetworkStartSynchronisedScene(packScene3)
    NetworkStartSynchronisedScene(packScene4)
    Citizen.Wait(45000)
    NetworkStopSynchronisedScene(packScene)
    NetworkStopSynchronisedScene(packScene2)
    NetworkStopSynchronisedScene(packScene3)
    NetworkStopSynchronisedScene(packScene4)
    DeleteEntity(scoop)
    DeleteEntity(doll)
    DeleteEntity(boxed)
    DeleteEntity(dollcast)
    DeleteEntity(dollcast2)
    DeleteEntity(dollcast3)
    DeleteEntity(dollcast4)
    DeleteEntity(dollmold)
    DeleteEntity(bowl)
    DeleteEntity(press)
    DeleteEntity(box1)
    while packaged do
        local playerPed = PlayerPedId()
        local playerCoord = GetEntityCoords(playerPed)
        local dst = #(playerCoord - Config.Coca.packageZone.coord)
        if dst < 3 then
            DrawMarker(2, Config.Coca.packageZone.coord, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.7, 0.7, 0.5, 44, 194, 33, 255, false, false, false, 1, false, false, false)
            DrawText3D(Config.Coca.packageZone.coord.x, Config.Coca.packageZone.coord.y, Config.Coca.packageZone.coord.z + 0.20, 0.30, Config.Coca.packageZone.takePackCoc)
        end
        if dst < 1.5 then
            if IsControlJustPressed(0, 38) then
                ESX.TriggerServerCallback("PX_drugs:checkCanCarryItem", function(output) 
                    if output then
                        TriggerServerEvent("PX_drugs:giveItem", 'packagedcoca', Config.Coca.packageZone.count)
                        packaged = false
                    else
                        ESX.ShowNotification("Estas lleno!")
                    end
                end, 'packagedcoca', Config.Coca.packageZone.count)
            end
        end
        Citizen.Wait(1)
    end
end)


function teleport(coord, heading)
    TriggerEvent('OW:Whitelist',
    6, ---ban type
    true --- state of that
    )
	DoScreenFadeOut(500)
	Citizen.Wait(2000)
	SetEntityCoords(PlayerPedId(), coord.x, coord.y, coord.z-1.0)
	SetEntityHeading(PlayerPedId(), heading)
	DoScreenFadeIn(500)
    Citizen.CreateThread(function()
        Wait(3000)
        TriggerEvent('OW:Whitelist',
        6, ---ban type
        false --- state of that
        )
    end)

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


