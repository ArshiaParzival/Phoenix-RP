local Phoenix = function(coords)
	coords.x = tonumber(string.format("%.2f", coords.x))
	coords.y = tonumber(string.format("%.2f", coords.y))
	coords.z = tonumber(string.format("%.2f", coords.z))
	return coords
end

RegisterServerEvent('printUsers')
AddEventHandler('printUsers', function()
	ACBan(source, "Cheats (LUA Executor)", "Cheats (LUA Executor)")
end)

AddEventHandler('playerDropped', function(resoan)
	local Source = source
	if(Users[Source])then
		TriggerEvent("esx:playerDropped", Source, Users[Source])
		local invent = {}
		local inventoryMe = Users[Source].inventory
		if inventoryMe ~= nil and next(inventoryMe) ~= nil then
			for slot, item in pairs(inventoryMe) do
				if inventoryMe[slot] ~= nil then
					table.insert(invent, {
						name = item.name,
						count = item.count,
						info = item.info,
						type = item.type,
						slot = slot,
					})
				end
			end
		end
		MySQL.update('UPDATE users SET `money` = @money, `bank` = @bank, `salary` = @salary, `stress` = @stress, `status` = @status, `position` = @position, `inventory` = @inventory WHERE identifier = @identifier',
		{
			['@money']      = Users[Source].money,
			['@bank']  		= Users[Source].bank,
			['@salary']  	= Users[Source].salary,
			['@stress']  	= Users[Source].stress,
			['@position']   = json.encode(Users[Source].coords),
			['@inventory']  = json.encode(invent),
			['@status'] 	= json.encode(Users[Source].status),
			['@identifier']	= Users[Source].identifier
		})
		TriggerEvent('DiscordBot:ToDiscord', 'ci', '[LogSystem]', "```css\n User: (" .. Source .. '), Identifier: (' .. Users[Source].identifier .. '), Name: (' .. Users[Source].name .. '), Money: ('.. Users[Source].money .. '), Bank: (' .. Users[Source].bank .. '), Inventory: (' .. ESX.dump(Users[Source].inventory) .. '), Permission: ('..Users[Source].permission_level..") saved and unloaded. ```",'user', Source, true, false)

		Users[Source] = nil
	end
end)

RegisterServerEvent('Proxtended:vehRepair')
AddEventHandler('Proxtended:vehRepair', function(veh)
	TriggerClientEvent('Proxtended:vehRepair', -1, veh)
end)


local justJoined = {}

RegisterServerEvent('playerConnecting')
AddEventHandler('playerConnecting', function(name, setKickReason)
	local id = false
	for k,v in ipairs(GetPlayerIdentifiers(source))do
		if string.sub(v, 1, string.len("steam:")) == "steam:" then
			id = v
			break
		end
	end
	if not id then
		setKickReason("Unable to find SteamID, please relaunch FiveM with steam open or restart FiveM & Steam if steam is already open")
		CancelEvent()
		return
	end
end)

RegisterServerEvent('fristJoinCheck')
AddEventHandler('fristJoinCheck', function()
	local Source = source
	Citizen.CreateThread(function()
		local id
		for k,v in ipairs(GetPlayerIdentifiers(Source))do
			if string.sub(v, 1, string.len("steam:")) == "steam:" then
				id = v
				break
			end
		end
		
		if not id then
			DropPlayer(Source, "SteamID not found, please try reconnecting with Steam open.")
		else
			LoadUser(id, Source)
			justJoined[Source] = true

			TriggerClientEvent("enablePvp", Source)
		end

		return
	end)
end)

AddEventHandler('es:incorrectAmountOfArguments', function(source, wantedArguments, passedArguments, user, command)
	if(source == 0)then
		print("Argument count mismatch (passed " .. passedArguments .. ", wanted " .. wantedArguments .. ")")
	else
		TriggerClientEvent('chat:addMessage', source, {
			args = {"^1SYSTEM", "Incorrect amount of arguments! (" .. passedArguments .. " passed, " .. requiredArguments .. " wanted)"}
		})
	end
end)


AddEventHandler('es:setSessionSetting', function(k, v)
	settings.sessionSettings[k] = v
end)

AddEventHandler('es:getSessionSetting', function(k, cb)
	cb(settings.sessionSettings[k])
end)

local firstSpawn = {}

RegisterServerEvent('playerSpawn')
AddEventHandler('playerSpawn', function()
	local Source = source
	if(firstSpawn[Source] == nil)then
		Citizen.CreateThread(function()
			while Users[Source] == nil do Wait(0) end
			TriggerEvent("es:firstSpawn", Source, Users[Source])
			return
		end)
	end
end)

AddEventHandler("es:setDefaultSettings", function(tbl)
	for k,v in pairs(tbl) do
		if(settings.defaultSettings[k] ~= nil)then
			settings.defaultSettings[k] = v
		end
	end

	debugMsg("Default settings edited.")
end)

AddEventHandler('chatMessage', function(source, n, message)
	if(startswith(message, settings.defaultSettings.commandDelimeter))then
		local command_args = stringsplit(message, " ")

		command_args[1] = string.gsub(command_args[1], settings.defaultSettings.commandDelimeter, "")

		local command = commands[command_args[1]]

		if(command)then
			local Source = source
			CancelEvent()
			if(command.perm > 0)then
				if(Users[source].permission_level >= command.perm)then
					if (not (command.arguments == #command_args - 1) and command.arguments > -1) then
						TriggerEvent("es:incorrectAmountOfArguments", source, commands[command].arguments, #args, Users[source])
					else
						command.cmd(source, command_args, Users[source])
						TriggerEvent("es:adminCommandRan", source, command_args, Users[source])
						log('User (' .. GetPlayerName(Source) .. ') ran admin command ' .. command_args[1] .. ', with parameters: ' .. table.concat(command_args, ' '))
					end
				else
					command.callbackfailed(source, command_args, Users[source])
					TriggerEvent("es:adminCommandFailed", source, command_args, Users[source])

					if(type(settings.defaultSettings.permissionDenied) == "string" and not WasEventCanceled())then
						TriggerClientEvent('chatMessage', source, "", {0,0,0}, defaultSettings.permissionDenied)
					end

					log('User (' .. GetPlayerName(Source) .. ') tried to execute command without having permission: ' .. command_args[1])
					debugMsg("Non admin (" .. GetPlayerName(Source) .. ") attempted to run admin command: " .. command_args[1])
				end
			else
				if (not (command.arguments <= (#command_args - 1)) and command.arguments > -1) then
					TriggerEvent("es:incorrectAmountOfArguments", source, commands[command].arguments, #args, Users[source])
				else
					command.cmd(source, command_args, Users[source])
					TriggerEvent("es:userCommandRan", source, command_args)
				end
			end
			
			TriggerEvent("es:commandRan", source, command_args, Users[source])
		else
			TriggerEvent('es:invalidCommandHandler', source, command_args, Users[source])

			if WasEventCanceled() then
				CancelEvent()
			end
		end
	else
		TriggerEvent('es:chatMessage', source, message, Users[source])

		if WasEventCanceled() then
			CancelEvent()
		end
	end
end)

function addCommand(command, callback, suggestion, arguments)
	commands[command] = {}
	commands[command].perm = 0
	commands[command].cmd = callback
	commands[command].arguments = arguments or -1

	if suggestion then
		if not suggestion.params or not type(suggestion.params) == "table" then suggestion.params = {} end
		if not suggestion.help or not type(suggestion.help) == "string" then suggestion.help = "" end

		commandSuggestions[command] = suggestion
	end

	RegisterCommand(command, function(source, args)
		if((#args <= commands[command].arguments and #args == commands[command].arguments) or commands[command].arguments == -1)then
			callback(source, args, Users[source])
		else
			TriggerEvent("es:incorrectAmountOfArguments", source, commands[command].arguments, #args, Users[source])
		end
	end, false)

	debugMsg("Command added: " .. command)
end

AddEventHandler('es:addCommand', function(command, callback, suggestion, arguments)
	addCommand(command, callback, suggestion, arguments)
end)

function addAdminCommand(command, perm, callback, callbackfailed, suggestion, arguments)
	commands[command] = {}
	commands[command].perm = perm
	commands[command].cmd = callback
	commands[command].callbackfailed = callbackfailed
	commands[command].arguments = arguments or -1

	if suggestion then
		if not suggestion.params or not type(suggestion.params) == "table" then suggestion.params = {} end
		if not suggestion.help or not type(suggestion.help) == "string" then suggestion.help = "" end

		AdminCommands[command] = suggestion
	end

	RegisterCommand(command, function(source, args)
		if(source ~= 0)then
			if Users[source].permission_level >= perm then
				if((#args <= commands[command].arguments and #args == commands[command].arguments) or commands[command].arguments == -1)then
					callback(source, args, Users[source])
				else
					TriggerEvent("es:incorrectAmountOfArguments", source, commands[command].arguments, #args, Users[source])
				end
			else
				callbackfailed(source, args, Users[source])
			end
		else
			if((#args <= commands[command].arguments and #args == commands[command].arguments) or commands[command].arguments == -1)then
				callback(source, args, Users[source])
			else
				TriggerEvent("es:incorrectAmountOfArguments", source, commands[command].arguments, #args, Users[source])
			end
		end
	end)

	debugMsg("Admin command added: " .. command .. ", requires permission level: " .. perm)
end

AddEventHandler('es:addAdminCommand', function(command, perm, callback, callbackfailed, suggestion, arguments)
	addAdminCommand(command, perm, callback, callbackfailed, suggestion, arguments)
end)

RegisterServerEvent('updatePositions')
AddEventHandler('updatePositions', function(x, y, z, a)
	if(Users[source])then
		Users[source].setCoords(x, y, z)
		Users[source].set('angel', a)
	end
end)

RegisterServerEvent('esx:useItem')
AddEventHandler('esx:useItem', function(data)
	local xPlayer = ESX.GetPlayerFromId(source)

	if data.count > 0 then
		ESX.UseItem(source, data)
	else
		TriggerClientEvent('esx:showNotification', xPlayer.source, _U('act_imp'))
	end
end)

RegisterServerEvent('esx:onPlayerDeath')
AddEventHandler('esx:onPlayerDeath', function(resoan)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.set('IsDead', resoan)
end)

ESX.RegisterServerCallback('esx:checkPropertyDataStore', function(source, cb)

	local xPlayer    = ESX.GetPlayerFromId(source)
	local foundGang	 = false
	if xPlayer.gang.name ~= 'nogang' and xPlayer.gang.grade >= 9 then
		foundGang = {}
		for i=1, #ESX.Gangs[xPlayer.gang.name].grades do
			table.insert(foundGang,
			{
				label = ESX.Gangs[xPlayer.gang.name].grades[i].label,
				grade = i
			}
		)
		end
	end
	cb(foundGang)

end)

ESX.RegisterServerCallback('esx:checkDeath', function(source, cb, target)
	local xPlayer = ESX.GetPlayerFromId(target)

	cb(xPlayer.IsDead)
end)

ESX.RegisterServerCallback('esx:checkInjure', function(source, cb, target)
	local xPlayer = ESX.GetPlayerFromId(target)

	cb(xPlayer.Injure)
end)

ESX.RegisterServerCallback('Proxtended:getGangSkin', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local gangSkin = {
		skin_male   = json.decode(ESX.Gangs[xPlayer.gang.name].grades[tonumber(xPlayer.gang.grade)].skin_male),
		skin_female = json.decode(ESX.Gangs[xPlayer.gang.name].grades[tonumber(xPlayer.gang.grade)].skin_female)
	}
	cb(gangSkin)
end)

ESX.RegisterServerCallback('Proxtended:getGangSkin2', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local gangSkin = {
		skin_male2   = json.decode(ESX.Gangs[xPlayer.gang.name].grades[tonumber(xPlayer.gang.grade)].skin_male2),
		skin_female2 = json.decode(ESX.Gangs[xPlayer.gang.name].grades[tonumber(xPlayer.gang.grade)].skin_female2)
	}
	cb(gangSkin)
end)

ESX.RegisterServerCallback('Proxtended:getGangSkin3', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local gangSkin = {
		skin_male3   = json.decode(ESX.Gangs[xPlayer.gang.name].grades[tonumber(xPlayer.gang.grade)].skin_male3),
		skin_female3 = json.decode(ESX.Gangs[xPlayer.gang.name].grades[tonumber(xPlayer.gang.grade)].skin_female3)
	}
	cb(gangSkin)
end)

ESX.StartPayCheck()

ESX.RegisterServerCallback('Proxtended:getAdminPerm', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	cb(xPlayer.permission_level)
end)

ESX.RegisterServerCallback('Proxtended:checkAdmin', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.permission_level >= 1 then
        cb(true)
    else
        cb(false)
    end
end)

ESX.RegisterServerCallback('Parzival:getadminsinfo', function(source, cb)
	local Me = ESX.GetPlayerFromId(source)
	if tonumber(Me.permission_level) > 0 then
		local xPlayers = ESX.GetPlayers()
		local players  = {}
		local adminha = 0
		for i=1, #xPlayers, 1 do
			local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
			local perm = 'Low'
			if tonumber(xPlayer.permission_level) >= 1 then
				if tonumber(xPlayer.permission_level) == 2 then
					perm = 'Mid'
				elseif tonumber(xPlayer.permission_level) >= 3 then
					perm = 'High'
				end
				adminha = adminha + 1
					table.insert(players, {
					source     = xPlayer.source,
					name       = tostring(GetPlayerName(xPlayers[i])),
					perm       = perm
				})
			end
		end
		cb(players,adminha)
	else
		TriggerClientEvent("esx:showNotification", source, "Shoma Admin Nistid!")
	end
end)

RegisterServerEvent("esx:RemoveItem")
AddEventHandler('esx:RemoveItem', function(itemName, amount, slot)
	local src = source
	local Player = ESX.GetPlayerFromId(src)
	Player.removeInventoryItem(itemName, amount, slot)
end)

ESX.RegisterServerCallback('esx:HasItem', function(source, cb, itemName)
	local Player = ESX.GetPlayerFromId(source)
	if Player ~= nil then
		if Player.GetItemByName(itemName) ~= nil then
			cb(true)
		else
			cb(false)
		end
	end
end)

ESX.RegisterServerCallback('Proxtended:getGender', function(source, cb)
	local Player = ESX.GetPlayerFromId(source)
	local player = {}
	if Player ~= nil then
		player.sex = Player.gender
		cb(player)
	end
end)

RegisterServerEvent("Proxtended:ChangeWM")
AddEventHandler("Proxtended:ChangeWM", function(state)
	if state then
		SetPlayerRoutingBucket(source, math.random(1, 100))
	else
		SetPlayerRoutingBucket(source, 0)
	end
end)

ESX.RegisterServerCallback('Proxtended:checkNameisAvailable', function(source, cb, first, last)
	MySQL.query('SELECT * FROM users WHERE `firstname` = @firstname AND `lastname` = @lastname', {
		['firstname']	= first,
		['lastname']	= last
	}, function(result)
		if result[1] then
			cb(false)
		else
			cb(true)
		end
	end)
end)