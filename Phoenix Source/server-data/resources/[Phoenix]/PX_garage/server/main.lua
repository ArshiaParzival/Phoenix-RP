esx = nil

TriggerEvent("esx:getSharedObject", function(library)
	esx = library
end)

esx.RegisterServerCallback("PX_garage:obtenerVehiculos", function(source, callback, garage)
	local player = esx.GetPlayerFromId(source)
	if player then
		local sqlQuery = [[
			SELECT
				plate, vehicle
			FROM
				owned_vehicles
			WHERE
				owner = @cid
		]]

		if garage then
			sqlQuery = [[
				SELECT
					plate, vehicle
				FROM
					owned_vehicles
				WHERE
					owner = @cid and garage = @garage
			]]
		end

		MySQL.query(sqlQuery, {
			["@cid"] = player["identifier"],
			["@garage"] = garage
		}, function(responses)
			getPlayerVehiclesOut(player.identifier ,function(data)
				enviar = {responses,data}
				callback(enviar)
			end)
		end)
	else
		callback(false)
	end
end)

function getPlayerVehiclesOut(identifier,cb)
	local vehicles = {}
	local data = MySQL.query.await("SELECT * FROM owned_vehicles WHERE owner=@identifier",{['@identifier'] = identifier})	
	cb(data)
end

esx.RegisterServerCallback("PX_garage:validateVehicle", function(source, callback, vehicleProps, garage)
	local player = esx.GetPlayerFromId(source)

	if player then
		local sqlQuery = [[
			SELECT
				owner
			FROM
				owned_vehicles
			WHERE
				plate = @plate
		]]

		MySQL.query(sqlQuery, {
			["@plate"] = vehicleProps["plate"]
		}, function(responses)
			if responses[1] then
				callback(true)
			else
				callback(false)
			end
		end)
	else
		callback(false)
	end
end)



esx.RegisterServerCallback('PX_garage:checkMoney', function(source, cb)
	local xPlayer = esx.GetPlayerFromId(source)
	local deudas = 0
	local result = MySQL.query.await('SELECT * FROM billing WHERE identifier = @identifier',{['@identifier'] = xPlayer.identifier})
	for i=1, #result, 1 do
		amount     = result[i].amount
		deudas = deudas + amount
		if deudas >= 2000 then
			cb("deudas")
		end
	end
	if xPlayer.money >= 200 then
		cb(true)
	else
		cb(false)
	end
end)

RegisterServerEvent('PX_garage:pay')
AddEventHandler('PX_garage:pay', function()
	local xPlayer = esx.GetPlayerFromId(source)
	xPlayer.removeMoney(200)
end)

RegisterServerEvent('PX_garage:modifystored')
AddEventHandler('PX_garage:modifystored', function(vehicleProps, stored, garage)
	local _source = source
	local plate = vehicleProps.plate

	if garage == nil then
		MySQL.update.await("UPDATE owned_vehicles SET garage=@garage WHERE plate=@plate",{['@garage'] = "OUT" , ['@plate'] = plate})
		MySQL.update.await("UPDATE owned_vehicles SET vehicle=@vehicle WHERE plate=@plate",{['@vehicle'] = json.encode(vehicleProps) , ['@plate'] = plate})
		MySQL.update.await("UPDATE owned_vehicles SET stored=@stored WHERE plate=@plate",{['@stored'] = stored , ['@plate'] = plate})
	else
		MySQL.update.await("UPDATE owned_vehicles SET garage=@garage WHERE plate=@plate",{['@garage'] = garage , ['@plate'] = plate})
		MySQL.update.await("UPDATE owned_vehicles SET vehicle=@vehicle WHERE plate=@plate",{['@vehicle'] = json.encode(vehicleProps) , ['@plate'] = plate})
		MySQL.update.await("UPDATE owned_vehicles SET stored=@stored WHERE plate=@plate",{['@stored'] = stored , ['@plate'] = plate})

	end
end)

RegisterServerEvent('PX_garage:modifyHouse')
AddEventHandler('PX_garage:modifyHouse', function(vehicleProps)
	local _source = source
	local plate = vehicleProps.plate
	MySQL.update.await("UPDATE owned_vehicles SET vehicle=@vehicle WHERE plate=@plate",{['@vehicle'] = json.encode(vehicleProps) , ['@plate'] = plate})
end)

RegisterServerEvent("PX_garage:sacarometer")
AddEventHandler("PX_garage:sacarometer", function(vehicle,stored,src1)
	local src = source
	if src1 then
		src = src1
	end
	local xPlayer = esx.GetPlayerFromId(src)
	while xPlayer == nil do Citizen.Wait(1); end
	local plate = all_trim(vehicle)
	local stored = stored
	MySQL.update.await("UPDATE owned_vehicles SET stored =@stored WHERE plate=@plate",{['@stored'] = stored , ['@plate'] = plate})
end)

function all_trim(s)
	return s:match( "^%s*(.-)%s*$" )
end

function tablelength(T)
	local count = 0
	for _ in pairs(T) do count = count + 1 end
	return count
end

RegisterServerEvent('PX_garage:RemoveInvalidVehicle')
AddEventHandler('PX_garage:RemoveInvalidVehicle', function (Plate)
	MySQL.update('DELETE FROM owned_vehicles WHERE plate = @plate',
	{
		['@plate'] = Plate
	}, function (rowsChanged)
		print('Mashin Be Pelake' .. Plate .. ' Be Dalil Nabood mashin Hazf shod')
	end)
end)