ESX = nil
local PlayerData = {}
local lsMenuIsShowed = false
local isInLSMarker = false
local myCar = {}
local DefaultCar = nil
local upgrading = false
local globalVehicle
local nearAnyGarage = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end
	PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

local oldCar
function InstanMod(vehicle)
	oldCar = myCar
	myCar = ESX.Game.GetVehicleProperties(vehicle)
end

local globlalvehicle = 0
RegisterNetEvent('esx_lscustom:DontInstallMod')
AddEventHandler('esx_lscustom:DontInstallMod', function()
	myCar = oldCar
	NetworkRequestControlOfEntity(globlalvehicle)
	while  not NetworkHasControlOfEntity(globlalvehicle) do
		Wait(100)
	end
	ESX.Game.SetVehicleProperties(globlalvehicle, myCar)
	oldCar = nil
end)


RegisterNetEvent('esx_lscustom:cancelInstallMod')
AddEventHandler('esx_lscustom:cancelInstallMod', function(vehicle)
	NetworkRequestControlOfEntity(vehicle)
	while  not NetworkHasControlOfEntity(vehicle) do
		Wait(100)
	end
	ESX.Game.SetVehicleProperties(vehicle, myCar)
end)

function OpenLSMenu(elems, menuName, menuTitle, parent, vehicle)
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), menuName,
	{
		title    = menuTitle,
		align    = 'left',
		elements = elems
	}, function(data, menu)
		local isRimMod, found = false, false

		if data.current.modType == "modFrontWheels" then
			isRimMod = true
		end
		for k,v in pairs(Config.Menus) do

			if k == data.current.modType or isRimMod then

				if data.current.label == _U('by_default') or string.match(data.current.label, _U('installed')) then
					ESX.ShowNotification(_U('already_own', data.current.label), 'error')
				else
					local multiplier = Config.Classes[GetVehicleClass(vehicle)]

					if isRimMod then
						price = math.floor(data.current.price * multiplier / 100)
						TriggerServerEvent('esx_lscustom:buyMod', price, myCar.plate)
						InstanMod(vehicle)
					elseif v.modType == 11 or v.modType == 12 or v.modType == 13 or v.modType == 15 or v.modType == 16 then
						price = math.floor(v.price[data.current.modNum + 1] * multiplier / 100)
						TriggerServerEvent('esx_lscustom:buyMod', price, myCar.plate)
						InstanMod(vehicle)
					else
						price = math.floor(v.price * multiplier)
						TriggerServerEvent('esx_lscustom:buyMod', price, myCar.plate / 100)
						InstanMod(vehicle)
					end
				end
				
				menu.close()
				found = true
				break
			end

		end

		if not found then
			GetAction(data.current, vehicle)
		end
	end, function(data, menu) -- on cancel
		menu.close()
		lsMenuIsShowed = false
		TriggerEvent('esx_lscustom:cancelInstallMod', vehicle)
		SetVehicleDoorsShut(vehicle, false)
		if parent == nil  then
			myCar = {}
		end
	end, function(data, menu) -- on change
		NetworkRequestControlOfEntity(vehicle)
		while  not NetworkHasControlOfEntity(vehicle) do
			Wait(100)
		end
		UpdateMods(data.current, vehicle)
	end, function()
		lsMenuIsShowed = false
		TriggerEvent('esx_lscustom:cancelInstallMod', vehicle)
		SetVehicleDoorsShut(vehicle, false)
	end)
end

function UpdateMods(data, vehicle)
	if data.modType then
		local props = {}
		
		if data.wheelType then
			props['wheels'] = data.wheelType
			ESX.Game.SetVehicleProperties(vehicle, props)
			props = {}
		elseif data.modType == 'neonColor' then
			if data.modNum[1] == 0 and data.modNum[2] == 0 and data.modNum[3] == 0 then
				props['neonEnabled'] = { false, false, false, false }
			else
				props['neonEnabled'] = { true, true, true, true }
			end
			ESX.Game.SetVehicleProperties(vehicle, props)
			props = {}
		elseif data.modType == 'tyreSmokeColor' then
			props['modSmokeEnabled'] = true
			ESX.Game.SetVehicleProperties(vehicle, props)
			props = {}
		end

		props[data.modType] = data.modNum
		ESX.Game.SetVehicleProperties(vehicle, props)
	end
end

function GetAction(data, vehicle)
	local elements  = {}
	local menuName  = ''
	local menuTitle = ''
	local parent    = nil

	local playerPed = PlayerPedId()
	local currentMods = ESX.Game.GetVehicleProperties(vehicle)

	if data.value == 'modSpeakers' or
		data.value == 'modTrunk' or
		data.value == 'modHydrolic' or
		data.value == 'modEngineBlock' or
		data.value == 'modAirFilter' or
		data.value == 'modStruts' or
		data.value == 'modTank' then
		SetVehicleDoorOpen(vehicle, 4, false)
		SetVehicleDoorOpen(vehicle, 5, false)
	elseif data.value == 'modDoorSpeaker' then
		SetVehicleDoorOpen(vehicle, 0, false)
		SetVehicleDoorOpen(vehicle, 1, false)
		SetVehicleDoorOpen(vehicle, 2, false)
		SetVehicleDoorOpen(vehicle, 3, false)
	else
		SetVehicleDoorsShut(vehicle, false)
	end

	local multiplier = Config.Classes[GetVehicleClass(vehicle)]

	for k,v in pairs(Config.Menus) do

		if data.value == k then

			menuName  = k
			menuTitle = v.label
			parent    = v.parent

			if v.modType then
				
				if v.modType == 22 then
					table.insert(elements, {label = " " .. _U('by_default'), modType = k, modNum = false})
				elseif v.modType == 'neonColor' or v.modType == 'tyreSmokeColor' then -- disable neon
					table.insert(elements, {label = " " ..  _U('by_default'), modType = k, modNum = {0, 0, 0}})
				elseif v.modType == 'color1' or v.modType == 'color2' or v.modType == 'pearlescentColor' or v.modType == 'wheelColor' or v.modType == 'dashColor' or v.modType == 'interiorColor' then
					local num = myCar[v.modType]
					table.insert(elements, {label = " " .. _U('by_default'), modType = k, modNum = num})
 				else
					table.insert(elements, {label = " " .. _U('by_default'), modType = k, modNum = -1})
				end

				if v.modType == 14 then -- HORNS
					for j = 0, 51, 1 do
						local _label = ''
						if j == currentMods.modHorns then
							_label = GetHornName(j) .. ' - <span style="color:cornflowerblue;">'.. _U('installed') ..'</span>'
						else
							price = math.floor(v.price * multiplier)
							_label = GetHornName(j) .. ' - <span style="color:green;">$' .. price .. ' </span>'
						end
						table.insert(elements, {label = _label, modType = k, modNum = j})
					end
				elseif v.modType == 'plateIndex' then -- PLATES
					for j = 0, 4, 1 do
						local _label = ''
						if j == currentMods.plateIndex then
							_label = GetPlatesName(j) .. ' - <span style="color:cornflowerblue;">'.. _U('installed') ..'</span>'
						else
							price = math.floor(v.price * multiplier)
							_label = GetPlatesName(j) .. ' - <span style="color:green;">$' .. price .. ' </span>'
						end
						table.insert(elements, {label = _label, modType = k, modNum = j})
					end
				elseif v.modType == 22 then -- NEON
					local _label = ''
					if currentMods.modXenon then
						_label = _U('neon') .. ' - <span style="color:cornflowerblue;">'.. _U('installed') ..'</span>'
					else
						price = math.floor(v.price * multiplier)
						_label = _U('neon') .. ' - <span style="color:green;">$' .. price .. ' </span>'
					end
					table.insert(elements, {label = _label, modType = k, modNum = true})
				elseif v.modType == 'neonColor' or v.modType == 'tyreSmokeColor' then -- NEON & SMOKE COLOR
					local neons = GetNeons()
					price = math.floor(v.price * multiplier)
					for i=1, #neons, 1 do
						table.insert(elements, {
							label = '<span style="color:rgb(' .. neons[i].r .. ',' .. neons[i].g .. ',' .. neons[i].b .. ');">' .. neons[i].label .. ' - <span style="color:green;">$' .. price .. '</span>',
							modType = k,
							modNum = { neons[i].r, neons[i].g, neons[i].b }
						})
					end
				
				elseif v.modType == 'xenonColor' then -- Xenon Color
					if IsToggleModOn(vehicle, 22) then
						local xenons = GetXenons()
						price = math.floor(v.price * multiplier)
						for i=1, #xenons, 1 do
							table.insert(elements, {
								label = xenons[i].label .. ' - <span style="color:green;">$' .. price .. '</span>',
								modType = k,
								modNum = xenons[i].color
							})
						end
					else
						table.insert(elements, {
							label = 'Install Xenon First!!!',
							modType = k
						})
					end

				elseif v.modType == 'color1' or v.modType == 'color2' or v.modType == 'pearlescentColor' or v.modType == 'wheelColor' or v.modType == 'dashColor' or v.modType == 'interiorColor' then -- RESPRAYS
					local colors = GetColors(data.color)
					for j = 1, #colors, 1 do
						local _label = ''
						price = math.floor(v.price * multiplier)
						_label = colors[j].label .. ' - <span style="color:green;">$' .. price .. ' </span>'
						table.insert(elements, {label = _label, modType = k, modNum = colors[j].index})
					end
				elseif v.modType == 'windowTint' then -- WINDOWS TINT
					for j = 1, 5, 1 do
						local _label = ''
						if j == currentMods.modHorns then
							_label = GetWindowName(j) .. ' - <span style="color:cornflowerblue;">'.. _U('installed') ..'</span>'
						else
							price = math.floor(v.price * multiplier)
							_label = GetWindowName(j) .. ' - <span style="color:green;">$' .. price .. ' </span>'
						end
						table.insert(elements, {label = _label, modType = k, modNum = j})
					end
				elseif v.modType == 23 then -- WHEELS RIM & TYPE
					local props = {}

					props['wheels'] = v.wheelType
					ESX.Game.SetVehicleProperties(vehicle, props)

					local modCount = GetNumVehicleMods(vehicle, v.modType)
					for j = 0, modCount, 1 do
						local modName = GetModTextLabel(vehicle, v.modType, j)
						if modName then
							local _label = ''
							if j == currentMods.modFrontWheels then
								_label = GetLabelText(modName) .. ' - <span style="color:cornflowerblue;">'.. _U('installed') ..'</span>'
							else
								price = math.floor(v.price * multiplier)
								_label = GetLabelText(modName) .. ' - <span style="color:green;">$' .. price .. ' </span>'
							end
							table.insert(elements, {label = _label, modType = 'modFrontWheels', modNum = j, wheelType = v.wheelType, price = v.price})
						end
					end
				elseif v.modType == 11 or v.modType == 12 or v.modType == 13 or v.modType == 15 or v.modType == 16 then
					local modCount = GetNumVehicleMods(vehicle, v.modType) -- UPGRADES
					for j = 0, modCount, 1 do
						local _label = ''
						if j == currentMods[k] then
							_label = _U('level', j+1) .. ' - <span style="color:cornflowerblue;">'.. _U('installed') ..'</span>'
						else
							price = math.floor(v.price[j+1] * multiplier)
							_label = _U('level', j+1) .. ' - <span style="color:green;">$' .. price .. ' </span>'
						end
						table.insert(elements, {label = _label, modType = k, modNum = j})
						if j == modCount-1 then
							break
						end
					end
				elseif v.modType == 17 then -- TURBO
					local _label = ''
					if currentMods[k] then
						_label = 'Turbo - <span style="color:cornflowerblue;">'.. _U('installed') ..'</span>'
					else
						_label = 'Turbo - <span style="color:green;">$' .. math.floor(v.price[1] * multiplier) .. ' </span>'
					end
					table.insert(elements, {label = _label, modType = k, modNum = true})
				else
					local modCount = GetNumVehicleMods(vehicle, v.modType) -- BODYPARTS
					for j = 0, modCount, 1 do
						local modName = GetModTextLabel(vehicle, v.modType, j)
						if modName then
							local _label = ''
							if j == currentMods[k] then
								_label = GetLabelText(modName) .. ' - <span style="color:cornflowerblue;">'.. _U('installed') ..'</span>'
							else
								price = math.floor(v.price * multiplier)
								_label = GetLabelText(modName) .. ' - <span style="color:green;">$' .. price .. ' </span>'
							end
							table.insert(elements, {label = _label, modType = k, modNum = j})
						end
					end
				end
			else
				if data.value == 'primaryRespray' or data.value == 'secondaryRespray' or data.value == 'pearlescentRespray' or data.value == 'modFrontWheelsColor' or data.value == 'dashRespray' or data.value == 'interiorRespray' then
					for i=1, #Config.Colors, 1 do
						if data.value == 'primaryRespray' then
							table.insert(elements, {label = Config.Colors[i].label, value = 'color1', color = Config.Colors[i].value})
						elseif data.value == 'secondaryRespray' then
							table.insert(elements, {label = Config.Colors[i].label, value = 'color2', color = Config.Colors[i].value})
						elseif data.value == 'pearlescentRespray' then
							table.insert(elements, {label = Config.Colors[i].label, value = 'pearlescentColor', color = Config.Colors[i].value})
						elseif data.value == 'modFrontWheelsColor' then
							table.insert(elements, {label = Config.Colors[i].label, value = 'wheelColor', color = Config.Colors[i].value})
						elseif data.value == 'interiorRespray' then
							table.insert(elements, {label = Config.Colors[i].label, value = 'interiorColor', color = Config.Colors[i].value})
						elseif data.value == 'dashRespray' then
							table.insert(elements, {label = Config.Colors[i].label, value = 'dashColor', color = Config.Colors[i].value})
						end
					end
				else
					for l,w in pairs(v) do
						if l ~= 'label' and l ~= 'parent' then
							table.insert(elements, {label = w, value = l})
						end
					end
				end
			end
			break
		end
	end

	table.sort(elements, function(a, b)
		return a.label < b.label
	end)

	OpenLSMenu(elements, menuName, menuTitle, parent, vehicle)
end

-- Prevent Free Tunning Bug
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)

		if lsMenuIsShowed then
			DisableControlAction(2, 288, true)
			DisableControlAction(2, 289, true)
			DisableControlAction(2, 170, true)
			DisableControlAction(2, 167, true)
			DisableControlAction(2, 168, true)
			DisableControlAction(2, 23, true)
		else
			Citizen.Wait(500)
		end
	end
end)

RegisterCommand('custom', function()
	local playerPed = PlayerPedId()
	local coords   = GetEntityCoords(playerPed)

	globlalvehicle = ESX.Game.GetVehicleInDirection(4)
	if globlalvehicle == 0 then
		globlalvehicle = GetVehiclePedIsIn(playerPed, false)
	end
	if globlalvehicle == 0 then
		ESX.ShowNotification('Shoma Be Hich mashini Eshare nemikonid', 'error')
		return
	end

	if PlayerData.job ~= nil and (PlayerData.job.name == 'mechanic' or PlayerData.job.name == 'motormechanic') and PlayerData.job.grade >= 2 then
		if NearAnyGarage(coords, GetVehicleClass(globlalvehicle) ) then
			myCar = ESX.Game.GetVehicleProperties(globlalvehicle)					
			ESX.TriggerServerCallback('esx_lscustom:IsRequstedVehicle', function(bool)
				if bool then
					NetworkRequestControlOfEntity(globlalvehicle)

					while not NetworkHasControlOfEntity(globlalvehicle) do
						Wait(100)
					end

					ESX.UI.Menu.CloseAll()
					GetAction({value = 'main'}, globlalvehicle)
					lsMenuIsShowed = true
				else
					ESX.ShowNotification('Hick Kas baraye Upgrade in mashin Darkhast Sabt nakarde ast', 'error')
				end
			end, ESX.Math.Trim(myCar.plate))
		else
			ESX.ShowNotification('Shoma faqat dar Parking Mechanici mitonid Custom konid', 'error')
		end
	else
		globlalvehicle = nil
		ESX.ShowNotification('Shoma nemitonid az in command estefade konid', 'error')
	end
end, false)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(500)
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		local vehicle = GetVehiclePedIsIn(playerPed)

		if DoesEntityExist(vehicle) then 
			nearAnyGarage = NearAnyGarage(coords, GetVehicleClass(vehicle))
		else
			 nearAnyGarage = false
	    end
         
	end
end)

AddEventHandler("onKeyDown", function(key)
	if not nearAnyGarage then
		return
	end

	if key == "y" then
		requestMechanicAction()
	end
end)

local lastMessage = 0
local AlreadyCalledMechanic = false

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		if nearAnyGarage then
			SetTextComponentFormat("STRING")
			if AlreadyCalledMechanic then
				AddTextComponentString("~INPUT_MP_TEXT_CHAT_TEAM~ Payane Kare Mashin")
			else
				AddTextComponentString("~INPUT_MP_TEXT_CHAT_TEAM~ Darkhaste Mechanic")
			end
			DisplayHelpTextFromStringLabel(0, 0, 1, -1)
		else
			Citizen.Wait(1000)
		end
	end
end)

RegisterNetEvent('esx_lscustom:changestate')
AddEventHandler('esx_lscustom:changestate', function(state)
	AlreadyCalledMechanic = state
	if state == false then
		DefaultCar = nil
		globalVehicle = nil
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		if upgrading then
			local ped = PlayerPedId()
			local currentVehicle = GetVehiclePedIsIn(ped)
			if currentVehicle ~= globalVehicle or not IsPedInAnyVehicle(ped) then
				upgrading = false
				globalVehicle = nil
				ESX.UI.Menu.CloseAll()
			end
		end
	end
end)

function paySuccess(vehicle)
	ESX.UI.Menu.CloseAll()
	AlreadyCalledMechanic = false
	ESX.Game.SetVehicleProperties(vehicle, ESX.Game.GetVehicleProperties(vehicle))	
	FreezeEntityPosition(vehicle, false)
	TriggerServerEvent('esx_lscustom:VehiclesInWatingList', DefaultCar.plate, false)
	DefaultCar = nil
	globalVehicle = nil
end

local mechanicCoords = {
    {coords = vector3(-327.2, -122.78, 39.01), restrictedFly = false},
	{coords = vector3(991.31, -125.76, 74.06), restrictedFly = false}
}

function NearAnyGarage(coords, class)
	for i, mechanic in ipairs(mechanicCoords) do
		local distance = Vdist(coords, mechanic.coords)
		if distance <= 30.0 and mechanic.restrictedFly and (class and class == 15 or class == 16) then
			return true
		elseif distance <= 30.0 and not mechanic.restrictedFly and (class and class ~= 15 and class ~= 16) then
			return true
		end
    end

    return false
end

function requestMechanicAction()
	local playerPed = PlayerPedId()
	local vehicle = GetVehiclePedIsIn(playerPed, false)
	local plate = GetVehicleNumberPlateText(vehicle)

		if not DefaultCar then
			DefaultCar = ESX.Game.GetVehicleProperties(vehicle)
			globalVehicle = vehicle
		end				

		if GetPedInVehicleSeat(vehicle, -1) == playerPed then
			
			ESX.TriggerServerCallback('esx_lscustom:RequestedBefore', function(IsRequested)
				if not IsRequested then
					-- ESX.TriggerServerCallback('esx_lscustom:checkVehicleOwner', function(IsOwn)
					-- 	if IsOwn then
							ESX.TriggerServerCallback('esx_lscustom:checkStatus', function(ordered)
								if not ordered then
									AlreadyCalledMechanic = true
									FreezeEntityPosition(vehicle, true)
									if GetGameTimer() - lastMessage > 1000 * 60 * 5 then
										lastMessage = GetGameTimer()
									end
									TriggerServerEvent('esx_lscustom:VehiclesInWatingList', ESX.Math.Trim(DefaultCar.plate), true, DefaultCar)
								elseif ordered then
									ESX.TriggerServerCallback('esx_lscustom:PriceOfBill', function(price)
										if price > 0 then
											ESX.UI.Menu.CloseAll()
											upgrading = true
											
											ESX.UI.Menu.Open('question', GetCurrentResourceName(), 'Aks_For_Pay',
											{
												title 	 = 'Pardakht Hazine',
												align    = 'center',
												question = 'Hazine Mashin shoma $'..ESX.Math.GroupDigits(price) .. ' shode ast, Az kodam ravesh mikhahid in pool ra pardakht konid?',
												elements = {
													{label = 'Naghd', value = 'cash'},
													{label = 'Cart', value = 'bank'},
													{label = 'Enseraf', value = 'cancel'}
												}
											}, function(data, menu)
												if data.current.value == 'cash' then
													ESX.TriggerServerCallback('esx_lscustom:PayVehicleOrders', function(success)
														if success then
															paySuccess(vehicle)
															ESX.ShowNotification('Mamnon Ke Maro entekhab kardid, Mablaghe Pardakhti: ~r~$'..price, 'success')
															AlreadyCalledMechanic = false
															upgrading = false
														else
															ESX.ShowNotification('Shoma Be andaze Kafi pool naghd nadarid', 'error')
														end
													end, ESX.Math.Trim(DefaultCar.plate), ESX.Game.GetVehicleProperties(vehicle), false)
												elseif data.current.value == 'bank' then 
													ESX.TriggerServerCallback('esx_lscustom:PayVehicleOrders', function(success)
														if success then
															paySuccess(vehicle)
															ESX.ShowNotification('Mamnon Ke Maro entekhab kardid, Mablaghe Pardakhti: ~r~$'..price, 'success')
															AlreadyCalledMechanic = false
															upgrading = false
														else
															ESX.ShowNotification('Mojodie Hesabe Shoma Kafi nemibashad', 'error')
														end
													end, ESX.Math.Trim(DefaultCar.plate), ESX.Game.GetVehicleProperties(vehicle), true)
												elseif data.current.value == 'cancel' then

														NetworkRequestControlOfEntity(vehicle)
			
														while not NetworkHasControlOfEntity(vehicle) do
															NetworkRequestControlOfEntity(vehicle)
															Wait(100)
														end

														ESX.TriggerServerCallback('esx_lscustom:getDefaultCar', function(prop)
															if prop then
																TriggerServerEvent('esx_lscustom:VehiclesInWatingList', ESX.Math.Trim(DefaultCar.plate), false)
																ESX.Game.SetVehicleProperties(vehicle, prop)
																FreezeEntityPosition(vehicle, false)
																DefaultCar = nil
																globalVehicle = nil
																upgrading = false
																menu.close()
																AlreadyCalledMechanic = false
															else
																ESX.ShowNotification("Khatayi dar system upgrade pish amad be developer etelaa dahid!", 'error')
															end
														end, ESX.Math.Trim(DefaultCar.plate))

												end
											end, function(data, menu)
												menu.close()
												upgrading = false
											end)
										else
											AlreadyCalledMechanic = false
											FreezeEntityPosition(vehicle, false)
											TriggerServerEvent('esx_lscustom:VehiclesInWatingList', DefaultCar.plate, false)
											DefaultCar = nil
											globalVehicle = nil
										end
									end, ESX.Math.Trim(DefaultCar.plate))
								end
	
							end, ESX.Math.Trim(plate))
	
					-- 	else
					-- 		ESX.ShowNotification("~r~Shoma saheb in mashin nistid!", 'error')
					-- 	end
					-- end, ESX.Math.Trim(plate))

				else
					ESX.ShowNotification("~h~Lotfan aval darkhast vasile naghliye ghabli khod ra cancel konid!", 'error')
				end

			end, ESX.Math.Trim(plate))
			
		else
			ESX.ShowNotification("~h~~r~Shoma ranande mashin nistid!", 'error')
		end

end