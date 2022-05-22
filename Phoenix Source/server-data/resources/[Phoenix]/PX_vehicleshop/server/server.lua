ESX = nil
local resultVehicles = {}
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

MySQL.ready(function()
	resultVehicles = MySQL.query.await('SELECT * FROM vehicles')
end)

RegisterServerEvent('esx_vehicleshop.testdriveonayla')
AddEventHandler('esx_vehicleshop.testdriveonayla', function(data, cb)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local identifier = GetPlayerIdentifiers(src)[1]
    
    if xPlayer.money >= 50 then
        xPlayer.removeMoney(50)

        TriggerClientEvent("esx_vehicleshop.testdrives", src, data)
    else
        TriggerClientEvent("esx_vehicleshop.restart-ui", src)
        TriggerClientEvent("esx:showNotification", src, "Shoma Pool Kafi Nadarid!")
    end
end)

RegisterServerEvent('ChangeWorldVeh', function(source, world)
    if state == 'start' then
        SetPlayerRoutingBucket(source, 86)
    elseif state == 'finish' then
        SetPlayerRoutingBucket(source, 0)
    end
end)

RegisterServerEvent('esx_vehicleshop.requestInfo')
AddEventHandler('esx_vehicleshop.requestInfo', function()
    local src = source
    local rows    

    local xPlayer = ESX.GetPlayerFromId(src)
    local playerName = xPlayer.name

    TriggerClientEvent('esx_vehicleshop.receiveInfo', src, xPlayer.bank, playerName)
    TriggerClientEvent("esx_vehicleshop.vehiclesInfos", src , resultVehicles)
    TriggerClientEvent("esx:showNotification", src, "Use the A and D keys to rotate the car.")
end)

ESX.RegisterServerCallback('esx_vehicleshop.isPlateTaken', function (source, cb, plate)
	MySQL.query('SELECT * FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	}, function (result)
		cb(result[1] ~= nil)
	end)
end)


RegisterServerEvent('esx_vehicleshop.CheckMoneyForVeh')
AddEventHandler('esx_vehicleshop.CheckMoneyForVeh', function(veh, price, name, vehicleProps)
	local source = source

	local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer == nil then
        return
    end

    MySQL.query('SELECT * FROM vehicles WHERE model = @model LIMIT 1', {
		['@model'] = veh
    }, function (result)
        if #result > 0 then
            local veiculo = result[1]
            local vehicleModel = veh
            local vehiclePrice = tonumber(price * 1000)
                if xPlayer.bank >= vehiclePrice then
                    xPlayer.removeBank(vehiclePrice)             
                    local vehiclePropsjson = json.encode(vehicleProps)
                    
                    local stateVehicle = 0 

                    if Config.SpawnVehicle then
                        stateVehicle = 0
                    else
                        stateVehicle = 1
                    end
                    
                    -- MySQL.update('INSERT INTO owned_vehicles (owner, type, plate, vehicle, stored) VALUES (@owner, @type, @plate, @stored, @vehicle, @state)',
                    -- {
                    --     ['@owner']   = xPlayer.identifier,
                    --     ['@plate']   = vehicleProps.plate,
                    --     ['@vehicle'] = vehiclePropsjson,
                    --     ['@state'] = stateVehicle,
                    --     ['@type']    = "car"
                    -- },
                    MySQL.update('INSERT INTO owned_vehicles (owner, type, plate, vehicle, stored) VALUES (@owner, @type, @plate, @vehicle, @state)',
                    {
                        ['@owner']   = xPlayer.identifier,
                        ['@plate']   = vehicleProps.plate,
                        ['@vehicle'] = vehiclePropsjson,
                        ['@state'] = stateVehicle,
                        ['@type']    = "car"
                    },
                    function (rowsChanged)
                        TriggerClientEvent("esx_vehicleshop.successfulbuy", source, name, vehicleProps.plate, vehiclePrice)
                        TriggerClientEvent('esx_vehicleshop.receiveInfo', source, xPlayer.bank)    
                        TriggerClientEvent('esx_vehicleshop.spawnVehicle', source, vehicleModel, vehicleProps.plate)                  
                    end)
                else
                    TriggerClientEvent("esx:showNotification", source, "You don't have enough money.")
                end
        end
	end)
end)

RegisterServerEvent('esx_vehicleshop.CheckMoneyForVehGang')
AddEventHandler('esx_vehicleshop.CheckMoneyForVehGang', function(veh, price, name, vehicleProps)
	local source = source

	local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer == nil then
        return
    end

    MySQL.query('SELECT * FROM vehicles WHERE model = @model LIMIT 1', {
		['@model'] = veh
    }, function (result)
        if #result > 0 then
            local veiculo = result[1]
            local vehicleModel = veh
            local vehiclePrice = tonumber(price * 1000)
                if xPlayer.bank >= vehiclePrice then
                    xPlayer.removeBank(vehiclePrice)             
                    local vehiclePropsjson = json.encode(vehicleProps)
                    
                    local stateVehicle = 0 

                    if Config.SpawnVehicle then
                        stateVehicle = 0
                    else
                        stateVehicle = 1
                    end
                    
                    MySQL.update('INSERT INTO owned_vehicles (owner, plate, vehicle, job) VALUES (@owner, @plate, @vehicle, @job)',
                    {
                        ['@owner']   = xPlayer.gang.name,
                        ['@plate']   = vehicleProps.plate,
                        ['@vehicle'] = vehiclePropsjson,
                        ['@job']	 = 'gang'
                    },
                    function (rowsChanged)
                        TriggerClientEvent("esx_vehicleshop.successfulbuy", source, name, vehicleProps.plate, vehiclePrice)
                        TriggerClientEvent('esx_vehicleshop.receiveInfo', source, xPlayer.bank)       
                        TriggerClientEvent('esx_vehicleshop.spawnVehicle', source, vehicleModel, vehicleProps.plate)                   
                    end)
                else
                    TriggerClientEvent("esx:showNotification", source, "You don't have enough money.")
                end
        end
	end)
end)

RegisterServerEvent('esx_vehicleshop:setVehicleGang')
AddEventHandler('esx_vehicleshop:setVehicleGang', function (vehicleProps, society)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if xPlayer.permission_level >= 1 then
		MySQL.update('INSERT INTO owned_vehicles (owner, plate, vehicle, job) VALUES (@owner, @plate, @vehicle, @job)',
		{
			['@owner']   = society,
			['@plate']   = vehicleProps.plate,
			['@vehicle'] = json.encode(vehicleProps),
			['@job']	 = 'gang'
		}, function (rowsChanged)
			TriggerClientEvent('esx:showNotification', _source, 'Mashin Add Shod Ba Pelak: ', vehicleProps.plate)
		end)
	else
		TriggerClientEvent('esx:deleteVehicle', _source)
		print(('esx_vehicleshop: %s attempted to inject vehicle!'):format(xPlayer.identifier))
	end
end)

RegisterServerEvent('esx_vehicleshop:AdminSetVehicleOwnedPlayerId')
AddEventHandler('esx_vehicleshop:AdminSetVehicleOwnedPlayerId', function (playerId, vehicleProps)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(playerId)
	local xPlayerSource = ESX.GetPlayerFromId(source)
	if xPlayerSource.permission_level >= 1 then
		MySQL.update('INSERT INTO owned_vehicles (owner, plate, vehicle) VALUES (@owner, @plate, @vehicle)',
		{
			['@owner']   = xPlayer.identifier,
			['@plate']   = vehicleProps.plate,
			['@vehicle'] = json.encode(vehicleProps)
		}, function (rowsChanged)
			TriggerClientEvent('esx:showNotification', playerId, "Mashin Add Shod Ba Pelak: ", vehicleProps.plate)
		end)
	end
end)

RegisterServerEvent('esx_vehicleshop:ChangeVehiclePlate')
AddEventHandler('esx_vehicleshop:ChangeVehiclePlate', function (vehicleProps, oldPlate)
	local _source = source
	local xPlayerSource = ESX.GetPlayerFromId(_source)
	if xPlayerSource.permission_level >= 1 then
		MySQL.update('UPDATE owned_vehicles SET vehicle = @vehicle, plate = @newPlate WHERE plate = @oldPlate',
		{
			['@vehicle']   	= json.encode(vehicleProps),
			['@newPlate']   = vehicleProps.plate,
			['@oldPlate'] 	= oldPlate
		}, function (rowsChanged)
			TriggerClientEvent('esx:showNotification', _source, 'Pelake mashin be ~r~'.. vehicleProps.plate .. ' ~s~ Taqir Kard')
		end)
	end
end)

RegisterServerEvent('esx_vehicleshop:DeleteVehicle')
AddEventHandler('esx_vehicleshop:DeleteVehicle', function (oldPlate)
	local _source = source
	local xPlayerSource = ESX.GetPlayerFromId(_source)
	if xPlayerSource.permission_level >= 1 then
		MySQL.update('DELETE FROM owned_vehicles WHERE plate = @plate',
		{
			['@plate']   = oldPlate
		}, function (rowsChanged)
			TriggerClientEvent('esx:showNotification', _source, 'Mashin Be Pelake' .. oldPlate .. ' ba movafaqiyat Hazf shod')
		end)
	end
end)