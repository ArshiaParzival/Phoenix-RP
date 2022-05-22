-- ez pz lmn sqz

local access = false


	

	-- Load Script:

	Citizen.CreateThread(function()

		TriggerServerEvent('PX_bankrobbery:loadDataSV')

	end)



	RegisterNetEvent('PX_bankrobbery:loadDataCL')

	AddEventHandler('PX_bankrobbery:loadDataCL', function(BankData, SafesData)

		Banks 	= BankData

		Safes 	= SafesData

	end)



	RegisterNetEvent('PX_bankrobbery:getPoliceCount')

	AddEventHandler('PX_bankrobbery:getPoliceCount', function(policeData)

		Police = policeData

	end)



	-- inUse state:

	RegisterNetEvent('PX_bankrobbery:inUseCL')

	AddEventHandler('PX_bankrobbery:inUseCL', function(state)

		for i = 1, #Banks do

			Banks[i].inUse = state

		end

	end)



	-- Keypad state:

	RegisterNetEvent('PX_bankrobbery:KeypadStateCL')

	AddEventHandler('PX_bankrobbery:KeypadStateCL', function(id, state, type)

		if id ~= nil or state ~= nil then  

			if type == "first" then

				Banks[id].keypads[1].hacked = state

			elseif type == "second" then

				Banks[id].keypads[2].hacked = state

			end	

		end

	end)



	-- Safe state:

	RegisterNetEvent('PX_bankrobbery:SafeDataCL')

	AddEventHandler('PX_bankrobbery:SafeDataCL', function(type, id, state)

		if id ~= nil or state ~= nil then  

			if type == "robbed" then

				Safes[id].robbed = state

			elseif type == "failed" then	

				Safes[id].failed = state

			end

		end

	end)



	-- Door open event:

	RegisterNetEvent('PX_bankrobbery:OpenVaultDoorCL')

	AddEventHandler('PX_bankrobbery:OpenVaultDoorCL', function(k,v,DoorHeading,amount)

		local PlayerPos = GetEntityCoords(PlayerPedId(), true)

		if (GetDistanceBetweenCoords(PlayerPos, v.vault.pos[1], v.vault.pos[2], v.vault.pos[3], true) < 100) then

			for i=1,amount do

				Citizen.Wait(10)

				SetEntityHeading(vaultDoor, round(DoorHeading, 1) - 0.4)

				DoorHeading = GetEntityHeading(vaultDoor)

			end

		end

		vaultInteract = false

	end)



	-- Door close event:

	RegisterNetEvent('PX_bankrobbery:CloseVaultDoorCL')

	AddEventHandler('PX_bankrobbery:CloseVaultDoorCL', function(k,v,DoorHeading,amount)

	local PlayerPos = GetEntityCoords(PlayerPedId(), true)

		if (GetDistanceBetweenCoords(PlayerPos, v.vault.pos[1], v.vault.pos[2], v.vault.pos[3], true) < 100) then

			for i=1,amount do

				Citizen.Wait(10)

				SetEntityHeading(vaultDoor, round(DoorHeading, 1 ) + 0.4)

				DoorHeading = GetEntityHeading(vaultDoor)

			end

		end

		vaultInteract = false

	end)



	-- Desk Door CL:

	RegisterNetEvent('PX_bankrobbery:deskDoorCL')

	AddEventHandler('PX_bankrobbery:deskDoorCL', function(id, state)

		if id ~= nil or state ~= nil then

			Banks[id].deskDoor.lockpicked = state

		end

	end)

	

	-- Desk Cash Robbed:

	RegisterNetEvent('PX_bankrobbery:deskCashCL')

	AddEventHandler('PX_bankrobbery:deskCashCL', function(id, num, state)

		if id ~= nil or state ~= nil then

			Banks[id].deskCash[num].robbed = state

		end

	end)



	-- Add extra rob time:

	RegisterNetEvent('PX_bankrobbery:addRobTimeCL')

	AddEventHandler('PX_bankrobbery:addRobTimeCL', function(timer)

		robTime = timer

	end)



	-- Safe Cracked:

	RegisterNetEvent('PX_bankrobbery:pacificSafeCL')

	AddEventHandler('PX_bankrobbery:pacificSafeCL', function(id, state)

		if id ~= nil or state ~= nil then

			Banks[id].safe.cracked = state

		end

	end)

	

	-- Door open event:

	RegisterNetEvent('PX_bankrobbery:OpenDeskDoorCL')

	AddEventHandler('PX_bankrobbery:OpenDeskDoorCL', function(k,v,DoorHeading,amount)

		local PlayerPos = GetEntityCoords(PlayerPedId(), true)

		if (GetDistanceBetweenCoords(PlayerPos, v.deskDoor.pos[1], v.deskDoor.pos[2], v.deskDoor.pos[3], true) < 100) then

			for i=1,amount do

				Citizen.Wait(10)

				SetEntityHeading(deskCashDoor, round(DoorHeading, 1) - 0.4)

				DoorHeading = GetEntityHeading(deskCashDoor)

			end

			deskDoorInteract = false

		end

	end)



	-- Door close event:

	RegisterNetEvent('PX_bankrobbery:CloseDeskDoorCL')

	AddEventHandler('PX_bankrobbery:CloseDeskDoorCL', function(k,v,DoorHeading,amount)

	local PlayerPos = GetEntityCoords(PlayerPedId(), true)

		if (GetDistanceBetweenCoords(PlayerPos, v.deskDoor.pos[1], v.deskDoor.pos[2], v.deskDoor.pos[3], true) < 100) then

			for i=1,amount do

				Citizen.Wait(10)

				SetEntityHeading(deskCashDoor, round(DoorHeading, 1 ) + 0.4)

				DoorHeading = GetEntityHeading(deskCashDoor)

			end

			deskDoorInteract = false

		end

	end)



	-- Restore Bank:

	RegisterNetEvent('PX_bankrobbery:ResetCurrentBankCL')

	AddEventHandler('PX_bankrobbery:ResetCurrentBankCL', function()

		-- Banks:

		for i = 1, #Banks do

			Banks[i].inUse = false

			Banks[i].keypads[1].hacked = false

			Banks[i].keypads[2].hacked = false

			Banks[i].deskDoor.lockpicked = false

			for k,v in pairs(Banks[i].deskCash) do

				v.robbed = false

			end

			Banks[i].powerBox.disabled = false

			if i == 8 then

				Banks[i].safe.cracked = false

			end

		end

		

		robTime = nil

		bankID = nil

	

		-- Safes:

		for i = 1, #Safes do

			Safes[i].robbed = false

			Safes[i].failed = false

		end

	end)

	

	function RestoreBank(k,v)

		TriggerServerEvent('PX_bankrobbery:ResetCurrentBankSV')

		Citizen.Wait(1000)

		ShowNotifyESX(Lang['you_secured_bank'])

		vaultInteract = false



		-- Reset Desk Door:

		SetEntityHeading(deskCashDoor, v.deskDoor.heading)

	end



	-- Spawn Safe in Pacific Heist:

	function spawnPacificSafe()

		local prop = GetHashKey("bkr_prop_biker_safedoor_01a") % 0x100000000

		RequestModel(prop)

		while not HasModelLoaded(prop) do

			Citizen.Wait(10)

		end

		safeObj = CreateObject(prop, 264.22, 207.50, 109.39, false, false, false)

		SetEntityAsMissionEntity(safeObj, true)

		FreezeEntityPosition(safeObj, true)

		SetEntityHeading(safeObj, 250.0)

		if HasModelLoaded(prop) then

			SetModelAsNoLongerNeeded(prop)

		end

	end



	-- Camera VIew:

	RegisterNetEvent('PX_bankrobbery:openCameraView')

	AddEventHandler('PX_bankrobbery:openCameraView', function(cameraNum)

		local player = GetPlayerPed(-1)

		local curCam = Config.Camera[cameraNum]

		local x,y,z,heading = curCam.pos[1],curCam.pos[2],curCam.pos[3],curCam.heading

		usingCamera = true

		SetTimecycleModifier('heliGunCam')

		SetTimecycleModifierStrength(1.0)

		local scaleForm = RequestScaleformMovie('TRAFFIC_CAM')

		while not HasScaleformMovieLoaded(scaleForm) do

			Citizen.Wait(0)

		end

		cameraID = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)

		SetCamCoord(cameraID, x, y, (z+1.25))						

		SetCamRot(cameraID, -13.0, 0.0, heading)

		SetCamFov(cameraID, 105.0)

		RenderScriptCams(true, false, 0, 1, 0)

		PushScaleformMovieFunction(scaleForm, 'PLAY_CAM_MOVIE')

		SetFocusArea(x, y, z, 0.0, 0.0, 0.0)

		PopScaleformMovieFunctionVoid()

		while usingCamera do

			SetCamCoord(cameraID, x, y, (z+1.25))

			PushScaleformMovieFunction(scaleForm, 'SET_ALT_FOV_HEADING')

			PushScaleformMovieFunctionParameterFloat(GetEntityCoords(heading).z)

			PushScaleformMovieFunctionParameterFloat(1.0)

			PushScaleformMovieFunctionParameterFloat(GetCamRot(cameraID, 2).z)

			PopScaleformMovieFunctionVoid()

			DrawScaleformMovieFullscreen(scaleForm, 255, 255, 255, 255)

			Citizen.Wait(1)

		end



		ClearFocus()

		ClearTimecycleModifier()

		RenderScriptCams(false, false, 0, 1, 0) -- Return to gameplay camera

		SetScaleformMovieAsNoLongerNeeded(scaleForm) -- Cleanly release the scaleform

		DestroyCam(cameraID, false)

		SetNightvision(false)

		SetSeethrough(false)

	end)