ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local needRegister = false

RegisterNetEvent('registerForm')
AddEventHandler('registerForm', function(bool)
	needRegister = bool
end)

function showLoadingPromt(label, time)
    Citizen.CreateThread(function()
        BeginTextCommandBusyString(tostring(label))
        EndTextCommandBusyString(3)
        Citizen.Wait(time)
        RemoveLoadingPrompt()
    end)
end

local guiEnabled = false

function EnableGui(state)
	SetNuiFocus(state, state)
	guiEnabled = state
	SendNUIMessage({
		type = "enableui",
		enable = state
	})
	if state then
		Citizen.CreateThread(function()
			while guiEnabled do
				Citizen.Wait(0)
				DisableControlAction(0, 1,   true)
				DisableControlAction(0, 2,   true)
				DisableControlAction(0, 106, true)
				DisableControlAction(0, 142, true)
				DisableControlAction(0, 30,  true)
				DisableControlAction(0, 31,  true)
				DisableControlAction(0, 21,  true)
				DisableControlAction(0, 24,  true)
				DisableControlAction(0, 25,  true)
				DisableControlAction(0, 47,  true)
				DisableControlAction(0, 58,  true)
				DisableControlAction(0, 263, true)
				DisableControlAction(0, 264, true)
				DisableControlAction(0, 257, true)
				DisableControlAction(0, 140, true)
				DisableControlAction(0, 141, true)
				DisableControlAction(0, 143, true)
				DisableControlAction(0, 75,  true)
				DisableControlAction(27, 75, true)
			end
		end)
	end
end

function loadToGround()
	TriggerEvent('Proxtended:freezePlayer', true)
	pos = GetEntityCoords(GetPlayerPed(-1))
    DoScreenFadeIn(500)
    Citizen.Wait(500)
    cam222 = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", -1166.77,-3469.82,337.94, 300.00,0.00,0.00, 100.00, false, 0)
    PointCamAtCoord(cam222, pos.x,pos.y,pos.z+10)
    SetCamActiveWithInterp(cam222, cam123, 9000, true, true)
    Citizen.Wait(9000)
	pos = GetEntityCoords(GetPlayerPed(-1))
    cam333 = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", pos.x,pos.y,pos.z+200, 300.00,0.00,0.00, 100.00, false, 0)
    PointCamAtCoord(cam333, pos.x,pos.y,pos.z+2)
    SetCamActiveWithInterp(cam333, cam222, 9000, true, true)
    Citizen.Wait(9000)
    PlaySoundFrontend(-1, "Zoom_Out", "DLC_HEIST_PLANNING_BOARD_SOUNDS", 1)
    RenderScriptCams(false, true, 500, true, true)
    PlaySoundFrontend(-1, "CAR_BIKE_WHOOSH", "MP_LOBBY_SOUNDS", 1)
    FreezeEntityPosition(GetPlayerPed(-1), false)
    Citizen.Wait(500)
    SetCamActive(cam123, false)
    DestroyCam(cam123, true)
	SwitchInPlayer(PlayerPedId())
	while not HasCollisionLoadedAroundEntity(PlayerPedId()) do
		Wait(1000)
	end
	TriggerEvent('esx_status:setLastStats')
	TriggerEvent('esx:playerSpawned')
	TriggerEvent('streetlabel:changeLoadStatus', true)
	Wait(2000)
	DestroyCam(cam123, true)
	DestroyCam(cam222, true)
	DestroyCam(cam333,true)
	TriggerEvent('PX_Loading:playerLoaded')
	ESX.TriggerServerCallback('esx_gps:checkGPS', function(has)
		if has then
			DisplayRadar(true)
		end
	end)
    TriggerEvent('Proxtended:freezePlayer', false)
	ESX.TriggerServerCallback('esx_ambulancejob:getDeathStatus', function(isDead)
		if isDead then
			ESX.ShowNotification('Shoma Akharin Bar Ke DC Dadid, Morde Boodid!', 'info')
			Wait(1500)
			SetEntityHealth(PlayerPedId(), 0)
		end
	end)
	ESX.SetPlayerData('IsPlayerLoaded', 1)
	ESX.SetPlayerData('IsLoaded', 1)
end

RegisterNUICallback('register', function(data, cb)
	ESX.TriggerServerCallback('Proxtended:checkNameisAvailable', function(callback)
		if callback then
			EnableGui(false)
			local gender = 0
			if data.sex == 'f' then
				gender = 1
			end
			TriggerServerEvent('db:updateUserNewbyMani', { firstname = data.firstname, lastname = data.lastname, gender = gender})
			TriggerServerEvent('es:newName', data.firstname, data.lastname)
			TriggerServerEvent('es:newGender', gender)
			loadToGround()
		else
			ESX.ShowNotification("In Moshakhasat Ghablan Sabt Shode Ast!", "error")
		end
	end, data.firstname, data.lastname)
end)

Citizen.CreateThread(function()
	SetManualShutdownLoadingScreenNui(true)
	ShutdownLoadingScreen()
	ShutdownLoadingScreenNui()
	cam123 = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", 3500.38,6230.06,455.48, 350.00,0.00,150.00, 100.00, false, 0)
	SetCamActive(cam123, true)
    RenderScriptCams(true, false, 1, true, true)
	showLoadingPromt("PM_WAIT", 500000)
	while ESX == nil do
		Wait(100)
	end
	while needRegister == nil do
		Wait(1000)
	end
	Wait(3000)
	showLoadingPromt("PM_WAIT", 0)
	if needRegister then
		EnableGui(true)
	else
		loadToGround()
	end
end)