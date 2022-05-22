function AddLicense(target, type, cb)
	local identifier = GetPlayerIdentifier(target, 0)

	MySQL.update('INSERT INTO user_licenses (type, owner) VALUES (@type, @owner)', {
		['@type']  = type,
		['@owner'] = identifier
	}, function(rowsChanged)
		if cb ~= nil then
			cb()
		end
	end)
end

function RemoveLicense(target, type, cb)
	local identifier = GetPlayerIdentifier(target, 0)

	MySQL.update('DELETE FROM user_licenses WHERE type = @type AND owner = @owner', {
		['@type']  = type,
		['@owner'] = identifier
	}, function(rowsChanged)
		if cb ~= nil then
			cb()
		end
	end)
end

function GetLicense(type, cb)
	MySQL.query('SELECT * FROM licenses WHERE type = @type', {
		['@type'] = type
	}, function(result)
		local data = {
			type  = type,
			label = result[1].label
		}

		cb(data)
	end)
end

function GetLicenses(target, cb)
	local identifier = GetPlayerIdentifier(target, 0)

	MySQL.query('SELECT * FROM user_licenses WHERE owner = @owner', {
		['@owner'] = identifier
	}, function(result)
		local licenses   = {}
		local asyncTasks = {}

		for i=1, #result, 1 do

			local scope = function(type)
				table.insert(asyncTasks, function(cb)
					MySQL.query('SELECT * FROM licenses WHERE type = @type', {
						['@type'] = type
					}, function(result2)
						local iLabel = "NULL"
						if result2[1] and result2[1].label then
							iLabel = result2[1].label
						end
						
						table.insert(licenses, 
						{
							type  = type,
							label = iLabel
						})

						cb()
					end)
				end)
			end

			scope(result[i].type)

		end

		Async.parallel(asyncTasks, function(results)
			cb(licenses)
		end)

	end)
end

function CheckLicense(target, type, cb)
	local identifier = GetPlayerIdentifier(target, 0)

	MySQL.query('SELECT COUNT(*) as count FROM user_licenses WHERE type = @type AND owner = @owner', {
		['@type']  = type,
		['@owner'] = identifier
	}, function(result)
		if tonumber(result[1].count) > 0 then
			cb(true)
		else
			cb(false)
		end

	end)
end

function GetLicensesList(cb)
	MySQL.query('SELECT * FROM licenses', {
		['@type'] = type
	}, function(result)
		local licenses = {}

		for i=1, #result, 1 do
			table.insert(licenses, {
				type  = result[i].type,
				label = result[i].label
			})
		end

		cb(licenses)
	end)
end

RegisterNetEvent('esx_license:addLicense')
AddEventHandler('esx_license:addLicense', function(target, type, cb)
	AddLicense(target, type, cb)
end)

RegisterNetEvent('esx_license:removeLicense')
AddEventHandler('esx_license:removeLicense', function(target, type, cb)
	RemoveLicense(target, type, cb)
end)

AddEventHandler('esx_license:getLicense', function(type, cb)
	GetLicense(type, cb)
end)

AddEventHandler('esx_license:getLicenses', function(target, cb)
	GetLicenses(target, cb)
end)

AddEventHandler('esx_license:checkLicense', function(target, type, cb)
	CheckLicense(target, type, cb)
end)

AddEventHandler('esx_license:getLicensesList', function(cb)
	GetLicensesList(cb)
end)

ESX.RegisterServerCallback('esx_license:getLicense', function(source, cb, type)
	GetLicense(type, cb)
end)

ESX.RegisterServerCallback('esx_license:getLicenses', function(source, cb, target)
	GetLicenses(target, cb)
end)

ESX.RegisterServerCallback('esx_license:checkLicense', function(source, cb, target, type)
	CheckLicense(target, type, cb)
end)

ESX.RegisterServerCallback('esx_license:getLicensesList', function(source, cb)
	GetLicensesList(cb)
end)

RegisterCommand("givelicense", function(source, args, user)
	local xPlayer = ESX.GetPlayerFromId(source)

	if (xPlayer.job.name == "police" and xPlayer.job.grade > 2) or (xPlayer.job.name == "sheriff" and xPlayer.job.grade > 2) or (xPlayer.job.name == "dadgostari" and xPlayer.job.grade > 1) then
		if args[1] then
			if args[2] then
				local target = tonumber(args[1])
				if target ~= nil then

					if GetPlayerName(target) then

						if args[2] == "weapon" or args[2] == "hunt" or args[2] == "dmv" or args[2] == "drive" or args[2] == "truck" or args[2] == "bike" then

							local type = nil
							local name = nil
							if args[2] == "weapon" or args[2] == "hunt" or args[2] == "dmv" or args[2] == "drive" then

								type = args[2]

							elseif args[2] == "truck" or args[2] == "bike" then

								type = "drive_" .. args[2]

							end

							if args[2] == "weapon" then

								name = "Mojavez Aslahe"

							elseif args[2] == "hunt" then
							
								name = "Mojavez Shekar"
							
							elseif args[2] == "dmv" then
							
								name = "Ayin Naame"

							elseif args[2] == "drive" then

								name = "Govahiname Ranandegi"
							
							elseif args[2] == "truck" then

								name = "Govahiname Kamiyon"

							elseif args[2] == "bike" then

								name = "Govahiname Motor"

							end

							MySQL.query('SELECT * FROM user_licenses WHERE owner=@identifier AND type = @type', 
							{
								['@identifier'] =  GetPlayerIdentifiers(target)[1],
								['@type'] = type

							}, function(data)
								if data[1] then

									TriggerClientEvent('chatMessage', source, "[LICENSE]", {255, 0, 0}, "^2" ..GetPlayerName(target) .. " ^0Dar hale hazer " .. name .. " darad!")
													
								else

									TriggerEvent('esx_license:addLicense', target, type)
									TriggerClientEvent('chatMessage', source, "[LICENSE]", {255, 0, 0}, " ^0Shoma be^2 " .. GetPlayerName(target) .. "^0 " .. name .. " dadid!" )
									TriggerClientEvent('chatMessage', target, "[LICENSE]", {255, 0, 0}, " ^0Shoma " .. name .. " daryaft kardid!")

									Citizen.Wait(1000)
									if args[2] == "dmv" or args[2] == "drive" or args[2] == "truck" or args[2] == "bike" then
									
										TriggerEvent('esx_dmvschool:updateLicense', target)

									end
									
								end
							end)
					
						else
							TriggerClientEvent('chatMessage', source, "[LICENSE]", {255, 0, 0}, " ^0Mojavezi ke vared kardid na motabar ast!")
						end

					else
						TriggerClientEvent('chatMessage', source, "[LICENSE]", {255, 0, 0}, " ^0ID vared shode na motabar ast!")
					end

				else
					TriggerClientEvent('chatMessage', source, "[LICENSE]", {255, 0, 0}, " ^0Shoma bayad dar ghesmmat ID faghat adad vared konid!")
				end

			else
				TriggerClientEvent('chatMessage', source, "[LICENSE]", {255, 0, 0}, " ^0Shoma dar ghesmat mojavez chizi vared nakardid!")
			end
		else
			TriggerClientEvent('chatMessage', source, "[LICENSE]", {255, 0, 0}, " ^0Shoma bayad ID player marbote ra vared konid!")
		end
	else
		TriggerClientEvent("esx:showNotification", source, "~r~~h~Shoma Dastresi Nadarid!")
	end
end, false)

RegisterCommand("removelicense", function(source, args, user)
	local xPlayer = ESX.GetPlayerFromId(source)

	if (xPlayer.job.name == "police" and xPlayer.job.grade > 2) or (xPlayer.job.name == "sheriff" and xPlayer.job.grade > 2) or (xPlayer.job.name == "dadgostari" and xPlayer.job.grade > 1) then
		if args[1] then
			if args[2] then
				local target = tonumber(args[1])
				if target ~= nil then

					if GetPlayerName(target) then

						if args[2] == "weapon" or args[2] == "hunt" or args[2] == "dmv" or args[2] == "drive" or args[2] == "truck" or args[2] == "bike" then

							local type = nil
							local name = nil
							if args[2] == "weapon" or args[2] == "hunt" or args[2] == "dmv" or args[2] == "drive" then

								type = args[2]

							elseif args[2] == "truck" or args[2] == "bike" then

								type = "drive_" .. args[2]

							end

							if args[2] == "weapon" then

								name = "Mojavez Aslahe"

							elseif args[2] == "hunt" then
							
								name = "Mojavz Shekar"
							
							elseif args[2] == "dmv" then
							
								name = "Ayin Naame"

							elseif args[2] == "drive" then

								name = "Govahiname Ranandegi"
							
							elseif args[2] == "truck" then

								name = "Govahiname Kamiyon"

							elseif args[2] == "bike" then

								name = "Govahiname Motor"

							end

							MySQL.query('SELECT * FROM user_licenses WHERE owner=@identifier AND type = @type', 
							{
								['@identifier'] =  GetPlayerIdentifiers(target)[1],
								['@type'] = type

							}, function(data)
								if data[1] then

									TriggerEvent('esx_license:removeLicense', target, type)
									TriggerClientEvent('chatMessage', source, "[LICENSE]", {255, 0, 0}, " ^0Shoma ^2 " .. name .. "^0 ^1" .. GetPlayerName(target) .. " ^0ra batel kardid!" )
									TriggerClientEvent('chatMessage', target, "[LICENSE]", {255, 0, 0}, " ^0" .. name .. " shoma ^1batel ^0shod!")

									Citizen.Wait(1000)
									if args[2] == "dmv" or args[2] == "drive" or args[2] == "truck" or args[2] == "bike" then
									
										TriggerEvent('esx_dmvschool:updateLicense', target)

									end
													
								else

									TriggerClientEvent('chatMessage', source, "[LICENSE]", {255, 0, 0}, "^2" ..GetPlayerName(target) .. " ^0 " .. name .. " nadarad!")
									
								end
							end)
					
						else
							TriggerClientEvent('chatMessage', source, "[LICENSE]", {255, 0, 0}, " ^0Mojavezi ke vared kardid na motabar ast!")
						end

					else
						TriggerClientEvent('chatMessage', source, "[LICENSE]", {255, 0, 0}, " ^0ID vared shode na motabar ast!")
					end

				else
					TriggerClientEvent('chatMessage', source, "[LICENSE]", {255, 0, 0}, " ^0Shoma bayad dar ghesmmat ID faghat adad vared konid!")
				end

			else
				TriggerClientEvent('chatMessage', source, "[LICENSE]", {255, 0, 0}, " ^0Shoma dar ghesmat mojavez chizi vared nakardid!")
			end
		else
			TriggerClientEvent('chatMessage', source, "[LICENSE]", {255, 0, 0}, " ^0Shoma bayad ID player marbote ra vared konid!")
		end
	else
		TriggerClientEvent("esx:showNotification", source, "~r~~h~Shoma Dastresi Nadarid!")
	end
end, false)