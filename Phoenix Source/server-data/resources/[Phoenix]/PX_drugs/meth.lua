ESX = nil


local used = false
local cooking = false
local filled = false
local process = false
local packaged = false
local methCount = 0

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
		local dst = #(playerCoord - Config.methLab.entry.coord)
			if dst < 20 and not used then
				sleep = 1
				DrawMarker(2, Config.methLab.entry.coord, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.7, 0.7, 0.5, 44, 194, 33, 255, false, false, false, 1, false, false, false)
				if dst < 3 then
					DrawText3D(Config.methLab.entry.coord.x, Config.methLab.entry.coord.y, Config.methLab.entry.coord.z + 0.20, 0.30, Config.methLab.entry.text)
					if IsControlJustPressed(0, 38) and not used then
						used = true
						if Config.methLab.entry.requiredItem then
							ESX.TriggerServerCallback("PX_drugs:checkItem", function(output) 
								if output then
									TriggerServerEvent("PX_drugs:removeItem", Config.methLab.entry.item, 1)
									TriggerEvent('OW:Whitelist',
									6, ---ban type
									true --- state of that
									)
									SetEntityCoords(playerPed, Config.methLab.entry.coord.x, Config.methLab.entry.coord.y+0.40, Config.methLab.entry.coord.z-1.0)
									SetEntityHeading(playerPed, Config.methLab.entry.entryheading)
									TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_ATM", 0, false)
									Citizen.Wait(10000)
									TriggerEvent('OW:Whitelist',
									6, ---ban type
									false --- state of that
									)
									ClearPedTasks(playerPed)
									teleport(Config.methLab.entry.intcoord, Config.methLab.entry.intheading)
									used = false
								else
									used = false
									ESX.ShowNotification("~r~Shoma Kart Makhsos Vrood Nadarid")
								end
							end, "labcard", 1)		
						else
							teleport(Config.methLab.entry.intcoord, Config.methLab.entry.intheading)
							used = false
						end			
					end
				end
			end
		local dst2 = #(playerCoord - Config.methLab.exit.intcoord)
		if dst2 < 5 then
			sleep = 1
			DrawMarker(2, Config.methLab.exit.intcoord, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.7, 0.7, 0.5, 44, 194, 33, 255, false, false, false, 1, false, false, false)
			if dst2 < 2 then
				DrawText3D(Config.methLab.exit.intcoord.x, Config.methLab.exit.intcoord.y, Config.methLab.exit.intcoord.z + 0.20, 0.30, Config.methLab.exit.text)
				if IsControlJustPressed(0, 38) then
					teleport(Config.methLab.exit.coord, Config.methLab.exit.heading)
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
		local dst = #(playerCoord - Config.methLab.cookZone.coord)
		if dst < 3 and not cooking then
			sleep = 1
			DrawMarker(2, Config.methLab.cookZone.coord, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.7, 0.7, 0.5, 44, 194, 33, 255, false, false, false, 1, false, false, false)
			if dst < 2 and not cooking then
				DrawText3D(Config.methLab.cookZone.coord.x, Config.methLab.cookZone.coord.y, Config.methLab.cookZone.coord.z + 0.20, 0.30, Config.methLab.cookZone.text)
				if IsControlJustPressed(0, 38) and not cooking then
					-- ESX.TriggerServerCallback("PX_drugs:checkItem", function(output) 
					-- 		if output then
					-- 			ESX.TriggerServerCallback("PX_drugs:checkItem", function(output) 
					-- 				if output then
										TriggerEvent("PX_drugs:cookMeth")
					-- 				else
					-- 					ESX.ShowNotification("~r~Shoma Sodiom Nadarid")
					-- 				end
					-- 			end, 'sodiom', 1)
					-- 		else
					-- 			ESX.ShowNotification("Shoma Ammoniac Nadarid")
					-- 		end
					-- end, 'amoniac', 1)
				end 
			end
		end
		local dst2 = #(playerCoord - Config.methLab.cookZone.startingCoord)
		if dst2 < 5 and filled and cooking then
			sleep = 1
			DrawMarker(2, Config.methLab.cookZone.startingCoord, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.7, 0.7, 0.5, 44, 194, 33, 255, false, false, false, 1, false, false, false)
			DrawText3D(Config.methLab.cookZone.startingCoord.x, Config.methLab.cookZone.startingCoord.y, Config.methLab.cookZone.startingCoord.z + 0.20, 0.30, Config.methLab.cookZone.startingText)
			if dst < 2 then
				if IsControlJustPressed(0, 38) and filled then
					filled = false
					TriggerEvent('OW:Whitelist',
					6, ---ban type
					true --- state of that
					)
					SetEntityCoords(playerPed, 1007.68, -3200.84, -40.0)
					SetEntityHeading(playerPed, 184.0)
					TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_ATM", 0, false)
					Citizen.Wait(20000)
					TriggerEvent('OW:Whitelist',
					6, ---ban type
					false --- state of that
					)
					ClearPedTasks(playerPed)
					TriggerEvent("PX_drugs:processMeth")
				end
			end
		end
		Citizen.Wait(sleep)
	end
end)

RegisterNetEvent("PX_drugs:cookMeth")
AddEventHandler("PX_drugs:cookMeth", function()
	local playerPed = PlayerPedId()
	cooking = true
	local sceneCam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
	RenderScriptCams(true, false, 0, 1, 0)
	SetCamCoord(sceneCam, 1003.36, -3197.88, -39.0)
	PointCamAtEntity(sceneCam, playerPed, 0.0, 0.0, 0.0, 1)
	RequestAnimDict('anim@amb@business@meth@meth_monitoring_cooking@cooking@')
	RequestModel('bkr_prop_meth_sacid')
	RequestModel('bkr_prop_meth_ammonia')
	while not HasAnimDictLoaded('anim@amb@business@meth@meth_monitoring_cooking@cooking@') and not HasModelLoaded("bkr_prop_meth_sacid") and not HasModelLoaded("bkr_prop_meth_ammonia") do Citizen.Wait(30) end
	local ammonia = CreateObject(GetHashKey("bkr_prop_meth_ammonia"), Config.methLab.cookZone.coord.x, Config.methLab.cookZone.coord.y, Config.methLab.cookZone.coord.z, true, false, false)
	local sacid = CreateObject(GetHashKey("bkr_prop_meth_sacid"), Config.methLab.cookZone.coord.x, Config.methLab.cookZone.coord.y, Config.methLab.cookZone.coord.z, true, false, false)
	while not DoesEntityExist(ammonia) or not DoesEntityExist(sacid) do
        Wait(0)
    end
	SetEntityHeading(playerPed, 178.56)
	Citizen.Wait(100)
	local cookingScene = NetworkCreateSynchronisedScene(Config.methLab.cookZone.coord.x+4.84, Config.methLab.cookZone.coord.y+1.99, Config.methLab.cookZone.coord.z-0.40, 0.0, 0.0, 0.0, 2, false, false, 1065353216, 0, 1.3)
	NetworkAddPedToSynchronisedScene(playerPed, cookingScene, "anim@amb@business@meth@meth_monitoring_cooking@cooking@", "chemical_pour_short_cooker", 1.5, -4.0, 1, 16, 1148846080, 0)
	NetworkAddEntityToSynchronisedScene(ammonia, cookingScene, "anim@amb@business@meth@meth_monitoring_cooking@cooking@", "chemical_pour_short_ammonia", 4.0, -8.0, 1)
	NetworkAddEntityToSynchronisedScene(sacid, cookingScene, "anim@amb@business@meth@meth_monitoring_cooking@cooking@", "chemical_pour_short_sacid", 4.0, -8.0, 1)
	NetworkStartSynchronisedScene(cookingScene)
	Citizen.Wait(56000)
	NetworkStopSynchronisedScene(cookingScene)
	ClearFocus()
	RenderScriptCams(false, false, 0, 1, 0)
	DestroyCam(sceneCam, false)
	DeleteEntity(ammonia)
	DeleteEntity(sacid)
	filled = true
end)

RegisterNetEvent("PX_drugs:processMeth")
AddEventHandler("PX_drugs:processMeth", function()
	local taken = false
	local count = math.random(Config.methLab.cookZone.methMinCount, Config.methLab.cookZone.methMaksCount)
	ESX.ShowNotification('~b~Shoma Shoro Be Pokht Kardin Ta Etmam Sabr Konid ~g~%1')
	Citizen.Wait(10000)
	ESX.ShowNotification('~b~Shoma Shoro Be Pokht Kardin Ta Etmam Sabr Konid ~g~ %10')
	Citizen.Wait(10000)
	ESX.ShowNotification('~b~Shoma Shoro Be Pokht Kardin Ta Etmam Sabr Konid ~g~ %21')
	Citizen.Wait(10000)
	ESX.ShowNotification('~b~Shoma Shoro Be Pokht Kardin Ta Etmam Sabr Konid ~g~ %34')
	Citizen.Wait(10000)
	ESX.ShowNotification('~b~Shoma Shoro Be Pokht Kardin Ta Etmam Sabr Konid ~g~ %48')
	Citizen.Wait(10000)
	ESX.ShowNotification('~b~Shoma Shoro Be Pokht Kardin Ta Etmam Sabr Konid ~g~ %59')
	Citizen.Wait(10000)
	ESX.ShowNotification('~b~Shoma Shoro Be Pokht Kardin Ta Etmam Sabr Konid ~g~ %73')
	Citizen.Wait(10000)
	ESX.ShowNotification('~b~Shoma Shoro Be Pokht Kardin Ta Etmam Sabr Konid ~g~ %87')
	Citizen.Wait(10000)
	ESX.ShowNotification('~b~Shoma Shoro Be Pokht Kardin Ta Etmam Sabr Konid ~g~ %98')
	Citizen.Wait(5000)
	ESX.ShowNotification('Marahel Pokht Be Etmam Resid An On RA Bardarid')

	while true do
		local playerPed = PlayerPedId()
		local playerCoord = GetEntityCoords(playerPed)
		local dst = #(playerCoord - Config.methLab.cookZone.coord)
		if dst < 3 then
			DrawMarker(2, Config.methLab.cookZone.coord, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.7, 0.7, 0.5, 44, 194, 33, 255, false, false, false, 1, false, false, false)
			DrawText3D(Config.methLab.cookZone.coord.x, Config.methLab.cookZone.coord.y, Config.methLab.cookZone.coord.z + 0.20, 0.30, Config.methLab.cookZone.takeMethText)
		end
		if dst < 2 then
			if IsControlJustPressed(0, 38) then
				ESX.TriggerServerCallback("PX_drugs:checkCanCarryItem", function(output) 
					if output then
						TriggerServerEvent("PX_drugs:giveItem", 'meth', count)
						cooking = false
						filled = false	
						taken = true
					else
						ESX.ShowNotification("IDK")
					end
				end, 'meth', count)
			end
		end
		if taken then
			break
		end
		Citizen.Wait(1)
	end
end)

Citizen.CreateThread(function()
	while true do
		local sleep = 1500
		local playerPed = PlayerPedId()
		local playerCoord = GetEntityCoords(playerPed)
		local dst = #(playerCoord - Config.methLab.packageZone.coord)
		if dst < 5 and not process then
			sleep = 1
			DrawMarker(2, Config.methLab.packageZone.coord, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.7, 0.7, 0.5, 44, 194, 33, 255, false, false, false, 1, false, false, false)
			if dst < 3 then
				DrawText3D(Config.methLab.packageZone.coord.x, Config.methLab.packageZone.coord.y, Config.methLab.packageZone.coord.z + 0.20, 0.30, Config.methLab.packageZone.text)
				if IsControlJustPressed(0, 38) then
					ESX.TriggerServerCallback("PX_drugs:checkItemAll", function(output) 
						if output then
							methCount = output
							TriggerServerEvent("PX_drugs:removeItemAll", 'meth')
							TriggerEvent("PX_drugs:packageMeth")
							process = true
							TriggerEvent("PX_drugs:disableControl")
						else
							ESX.ShowNotification("Shoma Meth Nadarid")
						end
					end, 'meth')
				end
			end
		end
		Citizen.Wait(sleep)
	end
end)


RegisterNetEvent("PX_drugs:packageMeth")
AddEventHandler("PX_drugs:packageMeth", function()
	local playerPed = PlayerPedId()
	RequestAnimDict('anim@amb@business@meth@meth_smash_weight_check@')
	while not HasAnimDictLoaded('anim@amb@business@meth@meth_smash_weight_check@') do Citizen.Wait(10) end
	RequestModel('bkr_prop_meth_bigbag_04a')
	RequestModel('bkr_prop_meth_bigbag_03a')
	RequestModel('bkr_prop_fakeid_clipboard_01a')
	RequestModel('bkr_prop_meth_openbag_02')
	RequestModel('bkr_prop_fakeid_penclipboard')
	RequestModel('bkr_prop_coke_scale_01')
	RequestModel('bkr_prop_meth_scoop_01a')
	while not HasModelLoaded('bkr_prop_meth_bigbag_04a') and not HasModelLoaded('bkr_prop_meth_bigbag_03a') and not HasModelLoaded('bkr_prop_fakeid_clipboard_01a') and not HasModelLoaded('bkr_prop_meth_openbag_02') and not HasModelLoaded('bkr_prop_fakeid_penclipboard') and not HasModelLoaded('bkr_prop_coke_scale_01') and not HasModelLoaded('bkr_prop_meth_scoop_01a') do 
		Citizen.Wait(50)
	end
	local animDict = "anim@amb@business@meth@meth_smash_weight_check@"
	SetEntityHeading(playerPed, 0.86)
	local packageScene = NetworkCreateSynchronisedScene(Config.methLab.packageZone.coord.x-4.72, Config.methLab.packageZone.coord.y-1.64, Config.methLab.packageZone.coord.z-0.99, 0.0, 0.0, 0.0, 2, false, false, 1065353216, 0, 1.3)
	local packageScene2 = NetworkCreateSynchronisedScene(Config.methLab.packageZone.coord.x-4.72, Config.methLab.packageZone.coord.y-1.64, Config.methLab.packageZone.coord.z-0.99, 0.0, 0.0, 0.0, 2, false, false, 1065353216, 0, 1.3)
	local packageScene3 = NetworkCreateSynchronisedScene(Config.methLab.packageZone.coord.x-4.72, Config.methLab.packageZone.coord.y-1.64, Config.methLab.packageZone.coord.z-0.99, 0.0, 0.0, 0.0, 2, false, false, 1065353216, 0, 1.3)
	local packageScene4 = NetworkCreateSynchronisedScene(Config.methLab.packageZone.coord.x-4.72, Config.methLab.packageZone.coord.y-1.64, Config.methLab.packageZone.coord.z-0.99, 0.0, 0.0, 0.0, 2, false, false, 1065353216, 0, 1.3)
	local packageScene5 = NetworkCreateSynchronisedScene(Config.methLab.packageZone.coord.x-4.72, Config.methLab.packageZone.coord.y-1.64, Config.methLab.packageZone.coord.z-0.99, 0.0, 0.0, 0.0, 2, false, false, 1065353216, 0, 1.3)
	Citizen.Wait(10)
	local box01 = CreateObject(GetHashKey("bkr_prop_meth_bigbag_04a"), Config.methLab.packageZone.coord, 1, 0, 0)
	local box02 = CreateObject(GetHashKey("bkr_prop_meth_bigbag_03a"), Config.methLab.packageZone.coord, 1, 0, 0)
	local clipboard = CreateObject(GetHashKey("bkr_prop_fakeid_clipboard_01a"), Config.methLab.packageZone.coord, 1, 0, 0)
	local methbag01 = CreateObject(GetHashKey("bkr_prop_meth_openbag_02"), Config.methLab.packageZone.coord, 1, 0, 0)
	local methbag02 = CreateObject(GetHashKey("bkr_prop_meth_openbag_02"), Config.methLab.packageZone.coord, 1, 0, 0)
	local methbag03 = CreateObject(GetHashKey("bkr_prop_meth_openbag_02"), Config.methLab.packageZone.coord, 1, 0, 0)
	local methbag04 = CreateObject(GetHashKey("bkr_prop_meth_openbag_02"), Config.methLab.packageZone.coord, 1, 0, 0)
	local methbag05 = CreateObject(GetHashKey("bkr_prop_meth_openbag_02"), Config.methLab.packageZone.coord, 1, 0, 0)
	local methbag06 = CreateObject(GetHashKey("bkr_prop_meth_openbag_02"), Config.methLab.packageZone.coord, 1, 0, 0)
	local methbag07 = CreateObject(GetHashKey("bkr_prop_meth_openbag_02"), Config.methLab.packageZone.coord, 1, 0, 0)
	local pencil = CreateObject(GetHashKey("bkr_prop_fakeid_penclipboard"), Config.methLab.packageZone.coord, 1, 0, 0)
	local scale = CreateObject(GetHashKey("bkr_prop_coke_scale_01"), Config.methLab.packageZone.coord, 1, 0, 0)
	local scoop = CreateObject(GetHashKey("bkr_prop_meth_scoop_01a"), Config.methLab.packageZone.coord, 1, 0, 0)
	while not DoesEntityExist(scoop) or not DoesEntityExist(scale) or not DoesEntityExist(pencil) or not DoesEntityExist(methbag07) or not DoesEntityExist(methbag06) or not DoesEntityExist(methbag05) or not DoesEntityExist(methbag04) or not DoesEntityExist(box01) or not DoesEntityExist(box02) or not DoesEntityExist(clipboard) or not DoesEntityExist(methbag01) or not DoesEntityExist(methbag02) or not DoesEntityExist(methbag03) do
        Wait(0)
    end
	NetworkAddPedToSynchronisedScene(playerPed, packageScene, animDict, "break_weigh_v3_char01", 1.5, -4.0, 1, 16, 1148846080, 0)
	NetworkAddEntityToSynchronisedScene(box01, packageScene, animDict, "break_weigh_v3_box01", 4.0, -8.0, 1) 
	NetworkAddEntityToSynchronisedScene(box02, packageScene, animDict, "break_weigh_v3_box01^1", 4.0, -8.0, 1)
	NetworkAddEntityToSynchronisedScene(clipboard, packageScene, animDict, "break_weigh_v3_clipboard", 4.0, -8.0, 1)
	NetworkAddEntityToSynchronisedScene(methbag01, packageScene2, animDict, "break_weigh_v3_methbag01", 4.0, -8.0, 1)
	NetworkAddEntityToSynchronisedScene(methbag02, packageScene2, animDict, "break_weigh_v3_methbag01^1", 4.0, -8.0, 1)
	NetworkAddEntityToSynchronisedScene(methbag03, packageScene2, animDict, "break_weigh_v3_methbag01^2", 4.0, -8.0, 1)
	NetworkAddEntityToSynchronisedScene(methbag04, packageScene3, animDict, "break_weigh_v3_methbag01^3", 4.0, -8.0, 1)
	NetworkAddEntityToSynchronisedScene(methbag05, packageScene3, animDict, "break_weigh_v3_methbag01^4", 4.0, -8.0, 1)
	NetworkAddEntityToSynchronisedScene(methbag06, packageScene3, animDict, "break_weigh_v3_methbag01^5", 4.0, -8.0, 1)
	NetworkAddEntityToSynchronisedScene(methbag07, packageScene4, animDict, "break_weigh_v3_methbag01^6", 4.0, -8.0, 1)
	NetworkAddEntityToSynchronisedScene(pencil, packageScene4, animDict, "break_weigh_v3_pen", 4.0, -8.0, 1)
	NetworkAddEntityToSynchronisedScene(scale, packageScene4, animDict, "break_weigh_v3_scale", 4.0, -8.0, 1)
	NetworkAddEntityToSynchronisedScene(scoop, packageScene5, animDict, "break_weigh_v3_scoop", 4.0, -8.0, 1)
	NetworkStartSynchronisedScene(packageScene)
	NetworkStartSynchronisedScene(packageScene2)
	NetworkStartSynchronisedScene(packageScene3)
	NetworkStartSynchronisedScene(packageScene4)
	NetworkStartSynchronisedScene(packageScene5)
	Citizen.Wait(39800)
	NetworkStopSynchronisedScene(packageScene)
	NetworkStopSynchronisedScene(packageScene2)
	NetworkStopSynchronisedScene(packageScene3)
	NetworkStopSynchronisedScene(packageScene4)
	NetworkStopSynchronisedScene(packageScene5)
	DeleteEntity(box02)
	DeleteEntity(box01)
	DeleteEntity(clipboard)
	DeleteEntity(methbag01)
	DeleteEntity(methbag02)
	DeleteEntity(methbag03)
	DeleteEntity(methbag04)
	DeleteEntity(methbag05)
	DeleteEntity(methbag06)
	DeleteEntity(methbag07)
	DeleteEntity(pencil)
	DeleteEntity(scale)
	DeleteEntity(scoop)
	packaged = true
	while packaged do
		local playerCoord = GetEntityCoords(playerPed)
		local dst = #(playerCoord - Config.methLab.packageZone.coord)
		if dst < 3 and packaged then
			DrawMarker(2, Config.methLab.packageZone.coord, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.7, 0.7, 0.5, 44, 194, 33, 255, false, false, false, 1, false, false, false)
			DrawText3D(Config.methLab.packageZone.coord.x, Config.methLab.packageZone.coord.y, Config.methLab.packageZone.coord.z + 0.20, 0.30, Config.methLab.packageZone.takeMethText)
			if IsControlJustPressed(0, 38) then
				ESX.TriggerServerCallback("PX_drugs:checkCanCarryItem", function(output) 
					if output then
						TriggerServerEvent("PX_drugs:giveItem", 'packagedmeth', methCount)
						process = false
						methCount = 0
						packaged = false
					else
						ESX.ShowNotification('IDK2')
					end
				end, 'packagedmeth', methCount)
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
	TriggerEvent('OW:Whitelist',
    6, ---ban type
    false --- state of that
    )
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


