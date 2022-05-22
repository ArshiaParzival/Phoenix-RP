TriggerEvent('es:addAdminCommand', 'addcar', 3, function(source, args, user)
	if args[1] then
		local newOwner = tonumber(args[1])
		local plate = nil
		if newOwner then
			TriggerClientEvent('addDonationCar', source, newOwner, plate)
		end
	else
		TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', "Lotfan ID ya Name Sahebe Mashin Ro befrestid!" } })
	end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = "add car for player", params = {{name = "PlayerID", help = "Id Playeri ke Online hast"}}})

TriggerEvent('es:addAdminCommand', 'addcargang', 3, function(source, args, user)
	if args[1] then
		local plate = nil
		TriggerClientEvent('addGangCar', source, args[1], plate)
	end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = "Add Car For Gang", params = {{name = "Gang", help = "Esm Gang"}}})

TriggerEvent('es:addAdminCommand', 'changeplate', 3, function(source, args, user)
	if args then
		local Plate = table.concat(args, " ")
		TriggerClientEvent('ChangeCarPlate', source, Plate)
	else
		TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', "Lotfan Plake Jadid Mashin Ro Vared Konid!" } })
	end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = "Avaz Kardane Pelake Mashin", params = {{name = "Plate", help = "Pelake Jadid"}}})

TriggerEvent('es:addAdminCommand', 'removecar', 3, function(source, args, user)
	TriggerClientEvent('RemoveCar', source)
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = "Remove car from player"})

TriggerEvent('es:addAdminCommand', 'tp', 2, function(source, args, user)
	local x = tonumber(args[1])
	local y = tonumber(args[2])
	local z = tonumber(args[3])
	if x and y and z then
		TriggerClientEvent('esx:teleport', source, {
			x = x,
			y = y,
			z = z
		})
	else
		TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', "Invalid coordinates!" } })
	end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = "Teleport to coordinates", params = {{name = "x", help = "X coords"}, {name = "y", help = "Y coords"}, {name = "z", help = "Z coords"}}})

TriggerEvent('es:addAdminCommand', 'setjob', 3, function(source, args, user)
	local xPlayer = ESX.GetPlayerFromId(source)
	if tonumber(args[1]) and args[2] and tonumber(args[3]) then
		local xPlayer = ESX.getPlayerFromId(args[1])

		if xPlayer then
			xPlayer.setJob(args[2], tonumber(args[3]))
			TriggerEvent('DiscordBot:ToDiscord', 'setjob', 'SetJob Log', ' Admin ' .. GetPlayerName(source) .. ' Id ' .. args[1] .. ' ra ozve ' .. args[2] .. ' kard', 'user', source, true, false)
		else
			TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Player not online.' } })
		end
	else
		TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Invalid usage.' } })
	end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = _U('setjob'), params = {{name = "id", help = _U('id_param')}, {name = "job", help = _U('setjob_param2')}, {name = "grade_id", help = _U('setjob_param3')}}})

TriggerEvent('es:addAdminCommand', 'setgang', 3, function(source, args, user)
	if tonumber(args[1]) and args[2] and tonumber(args[3]) then
		local xPlayer = ESX.GetPlayerFromId(args[1])
		if xPlayer then
			if ESX.DoesGangExist(args[2], args[3]) then
				xPlayer.setGang(args[2], args[3])
				TriggerEvent('DiscordBot:ToDiscord', 'setgang', 'SetGanG Log', ' Admin ' .. GetPlayerName(source) .. ' Id ' .. args[1] .. ' ra ozve ' .. args[2] .. ' kard', 'user', source, true, false)
			else
				TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'That gang does not exist.' } })
			end
		else
			TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Player not online.' } })
		end
	else
		TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Invalid usage.' } })
	end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = "Set specefied gang for target player", params = {{name = "id", help = "Id Player"},{name = "gang", help = "Esme Gang"},{name = "Grade", help = "Ranke player dar gang"}}})

TriggerEvent('es:addAdminCommand', 'creategang', 3, function(source, args, user)
	local _source = source
	if args[1] and tonumber(args[2]) then
		TriggerEvent('gangs:registerGang', _source, args[1], args[2])
		TriggerEvent('DiscordBot:ToDiscord', 'creategang', 'Gang Log', ' Admin ' .. GetPlayerName(source) .. ' Gang ' .. args[1] .. ' ra Sakht', 'user', source, true, false)
	else
		TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Invalid usage.' } })
	end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = "Create Gang", params = {{name = "name", help = "ESM Gang"},{name = "expire", help = "Zaman Expire Shodan gang"}}})

TriggerEvent('es:addAdminCommand', 'savegangs', 3, function(source, args, user)
	local _source = source
	TriggerEvent('gangs:saveGangs', _source)
end)


TriggerEvent('es:addAdminCommand', 'changegangdata', 3, function(source, args, user)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(source)
		local playerPos = xPlayer.coords
		if ESX.DoesGangExist(args[1], 6) then
			if args[2] == 'blip' then
				local Pos     = { x = playerPos.x, y = playerPos.y, z = playerPos.z + 0.5 }
				TriggerEvent('gangs:changeGangData', args[1], args[2], Pos, _source)
			elseif args[2] == 'armory' then
				local Pos     = { x = playerPos.x, y = playerPos.y, z = (playerPos.z - 1.0) }
				TriggerEvent('gangs:changeGangData', args[1], args[2], Pos, _source)
			elseif args[2] == 'locker' then
				local Pos     = { x = playerPos.x, y = playerPos.y, z = (playerPos.z - 1.0) }
				TriggerEvent('gangs:changeGangData', args[1], args[2], Pos, _source)
			elseif args[2] == 'boss' then
				local Pos     = { x = playerPos.x, y = playerPos.y, z = (playerPos.z - 1.0) }
				TriggerEvent('gangs:changeGangData', args[1], args[2], Pos, _source)
			elseif args[2] == 'veh' then
				local Pos     = { x = playerPos.x, y = playerPos.y, z = (playerPos.z - 1.0) }
				TriggerEvent('gangs:changeGangData', args[1], args[2], Pos, _source)
			elseif args[2] == 'vehdel' then
				local Pos     = { x = playerPos.x, y = playerPos.y, z = (playerPos.z - 1.0) }
				TriggerEvent('gangs:changeGangData', args[1], args[2], Pos, _source)
			elseif args[2] == 'search' then
				TriggerEvent('gangs:changeGangData', args[1], args[2], nil, _source)
			elseif args[2] == 'vehspawn' then
				local Pos     = { x = playerPos.x, y = playerPos.y, z = playerPos.z , a = xPlayer.angel }
				TriggerEvent('gangs:changeGangData', args[1], args[2], Pos, _source)
			elseif args[2] == 'expire' then
				if tonumber(args[3]) then
					TriggerEvent('gangs:changeGangData', args[1], args[2], args[3], _source)
				else
					TriggerClientEvent('esx:showNotification', source, 'Please enter a number for days are gonna to set until expire, like: 30')
				end
			elseif args[2] == 'bulletproof' then
				if args[3] and tonumber(args[3]) then
					TriggerEvent('gangs:changeGangData', args[1], args[2], tonumber(args[3]), _source)
				else
					TriggerClientEvent('esx:showNotification', source, 'Meqdare Armor Ra vared konid (0-100)')
				end
			elseif args[2] == 'gps' then
				if args[3] and args[3] == "true" or args[3] == "false" then
					TriggerEvent('gangs:changeGangData', args[1], args[2], args[3], _source)
				else
					TriggerClientEvent('esx:showNotification', source, 'State GPS Ra Vared Konid (true/false)')
				end
			elseif args[2] == 'slot' then
				if args[3] and tonumber(args[3]) then
					TriggerEvent('gangs:changeGangData', args[1], args[2], tonumber(args[3]), source)
				else
					TriggerClientEvent('esx:showNotification', source, 'Meqdare Slot Ra vared konid (1-999)')
				end
			else
				TriggerClientEvent('esx:showNotification', source, 'You Entered Invalid Option!')
			end
		else
			TriggerClientEvent('esx:showNotification', source, 'You Entered Invalid Gang!')
		end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = "Taqir Dadane Makane Option haye Gang", params = {
	{ name="GangName", help="Esme Gang" },
	{ name="option", help="Entekhabe option:(blip, armory, locker, boss, veh, vehdel, vehspawn, expire, bulletproof, slot, gps)" },
}})

TriggerEvent('es:addAdminCommand', 'loadipl', 3, function(source, args, user)
	TriggerClientEvent('esx:loadIPL', -1, args[1])
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = _U('load_ipl')})

TriggerEvent('es:addAdminCommand', 'unloadipl', 3, function(source, args, user)
	TriggerClientEvent('esx:unloadIPL', -1, args[1])
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = _U('unload_ipl')})

TriggerEvent('es:addAdminCommand', 'playanim', 3, function(source, args, user)
	TriggerClientEvent('esx:playAnim', -1, args[1], args[3])
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = _U('play_anim')})

TriggerEvent('es:addAdminCommand', 'playemote', 3, function(source, args, user)
	TriggerClientEvent('esx:playEmote', -1, args[1])
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = _U('play_emote')})

TriggerEvent('es:addAdminCommand', 'dvall', 3, function(source, args, user)
	TriggerClientEvent('PX_garage:DeleteAllVehicle', -1)
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = {"^1SYSTEM", "Insufficienct permissions!"} })
end, {help = "Delete All Vehicles"})

TriggerEvent('es:addAdminCommand', 'dv', 2, function(source, args, user)
	TriggerClientEvent('esx:deleteVehicle', source)
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = _U('delete_vehicle')})

TriggerEvent('es:addAdminCommand', 'spawnped', 3, function(source, args, user)
	TriggerClientEvent('esx:spawnPed', source, args[1])
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = _U('spawn_ped'), params = {{name = "name", help = _U('spawn_ped_param')}}})

TriggerEvent('es:addAdminCommand', 'spawnobject', 3, function(source, args, user)
	TriggerClientEvent('esx:spawnObject', source, args[1])
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = _U('spawn_object'), params = {{name = "name"}}})

TriggerEvent('es:addCommand', 'clear', function(source, args, user)
	TriggerClientEvent('chat:clear', source)
end, {help = _U('chat_clear')})

TriggerEvent('es:addAdminCommand', 'clearall', 3, function(source, args, user)
	TriggerClientEvent('chat:clear', -1)
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end)

TriggerEvent('es:addAdminCommand', 'rewardall', 3, function(source, args, user)
	local xPlayers   = ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		xPlayer.addMoney(tonumber(args[1]))
		TriggerClientEvent('esx:showNotification', xPlayer.source, 'shoma $'.. args[1] .. ' jayze gereftid')
	end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = 'Jayze dadan be hame playerha'})

TriggerEvent('es:addAdminCommand', 'ncz', 3, function(source, args, user)
	ncz = not ncz
	TriggerClientEvent('es:ncz', -1, ncz)
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = 'disable fireing in all city'})

TriggerEvent('es:addAdminCommand', 'goto', 2, function(source, args, user)
	if args[1] then
		if(tonumber(args[1]) and GetPlayerName(tonumber(args[1])))then
			local player = tonumber(args[1])
			TriggerEvent("es:getPlayerFromId", player, function(target)
				if(target)then

					TriggerClientEvent('Proxtended:teleportUser', source, target.coords.x, target.coords.y, target.coords.z)

					TriggerClientEvent('chat:addMessage', player, { args = {"^1SYSTEM", "You have been teleported to by ^2" .. GetPlayerName(source)} })
					TriggerClientEvent('chat:addMessage', source, { args = {"^1SYSTEM", "Teleported to player ^2" .. GetPlayerName(player) .. ""} })
				end
			end)
		else
			TriggerClientEvent('chat:addMessage', source, { args = {"^1SYSTEM", "Incorrect player ID"}})
		end
	else
		TriggerClientEvent('chat:addMessage', source, { args = {"^1SYSTEM", "Incorrect player ID"}})
	end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = {"^1SYSTEM", "Insufficienct permissions!"} })
end, {help = "Teleport to a user", params = {{name = "userid", help = "The ID of the player"}}})

TriggerEvent('es:addAdminCommand', 'bring', 2, function(source, args, user)
	if args[1] then
		if(tonumber(args[1]) and GetPlayerName(tonumber(args[1])))then
			local player = tonumber(args[1])
			TriggerEvent("es:getPlayerFromId", player, function(target)
				if target then
					TriggerClientEvent('Proxtended:teleportUser', target.get('source'), user.coords.x, user.coords.y, user.coords.z)

					TriggerClientEvent('chat:addMessage', player, { args = {"^1SYSTEM", "You have brought by ^2" .. GetPlayerName(source)} })
					TriggerClientEvent('chat:addMessage', source, { args = {"^1SYSTEM", "Player ^2" .. GetPlayerName(player) .. "^0 has been brought"} })
				else
					TriggerClientEvent('chat:addMessage', source, { args = {"^1SYSTEM", "That player is offline"} })
				end
			end)
		else
			TriggerClientEvent('chat:addMessage', source, { args = {"^1SYSTEM", "Incorrect player ID"}})
		end
	else
		TriggerClientEvent('chat:addMessage', source, { args = {"^1SYSTEM", "Incorrect player ID"}})
	end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = {"^1SYSTEM", "Insufficienct permissions!"} })
end, {help = "Teleport a user to you", params = {{name = "userid", help = "The ID of the player"}}})

local frozen = {}
TriggerEvent('es:addAdminCommand', 'freeze', 1, function(source, args, user)
	if args[1] then
		if(tonumber(args[1]) and GetPlayerName(tonumber(args[1])))then
			local player = tonumber(args[1])
			TriggerEvent("es:getPlayerFromId", player, function(target)

				if(frozen[player])then
					frozen[player] = false
				else
					frozen[player] = true
				end

				TriggerClientEvent('Proxtended:freezePlayer', player, frozen[player])

				local state = "unfrozen"
				if(frozen[player])then
					state = "frozen"
				end

				TriggerClientEvent('chat:addMessage', player, { args = {"^1SYSTEM", "You have been " .. state .. " by ^2" .. GetPlayerName(source)} })
				TriggerClientEvent('chat:addMessage', source, { args = {"^1SYSTEM", "Player ^2" .. GetPlayerName(player) .. "^0 has been " .. state} })
			end)
		else
			TriggerClientEvent('chat:addMessage', source, { args = {"^1SYSTEM", "Incorrect player ID"}})
		end
	else
		TriggerClientEvent('chat:addMessage', source, { args = {"^1SYSTEM", "Incorrect player ID"}})
	end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = {"^1SYSTEM", "Insufficienct permissions!"} })
end, {help = "Freeze or unfreeze a user", params = {{name = "userid", help = "The ID of the player"}}})

TriggerEvent('es:addAdminCommand', 'slay', 2, function(source, args, user)
	if args[1] then
		if(tonumber(args[1]) and GetPlayerName(tonumber(args[1])))then
			local player = tonumber(args[1])
			TriggerEvent("es:getPlayerFromId", player, function(target)

				TriggerClientEvent('Proxtended:kill', player)

				TriggerClientEvent('chat:addMessage', player, { args = {"^1SYSTEM", "You have been killed by ^2" .. GetPlayerName(source)} })
				TriggerClientEvent('chat:addMessage', source, { args = {"^1SYSTEM", "Player ^2" .. GetPlayerName(player) .. "^0 has been killed."} })
			end)
		else
			TriggerClientEvent('chat:addMessage', source, { args = {"^1SYSTEM", "Incorrect player ID"}})
		end
	else
		TriggerClientEvent('chat:addMessage', source, { args = {"^1SYSTEM", "Incorrect player ID"}})
	end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = {"^1SYSTEM", "Insufficienct permissions!"} })
end, {help = "Slay a user", params = {{name = "userid", help = "The ID of the player"}}})

RegisterCommand('heal',function(source,args)
	local xPlayer = ESX.GetPlayerFromId(source)
	if tonumber(xPlayer.permission_level) >= 2 then
		if args[1] then
			player = args[1]
		else
			player = source
		end
		if player then
			TriggerClientEvent('esx_basicneeds:healPlayer', player)
		else
			TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', ' Player Mored Nazar Online Nist!' } })
		end
	else
		TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
	end
end)

RegisterCommand('kick',function(source,args)
	local xPlayer = ESX.GetPlayerFromId(source)
	if tonumber(xPlayer.permission_level) >= 2 then
		if args[1] then
			if args[2] then
				local reason = table.concat(args, " ",2)
				TriggerClientEvent('chatMessage',-1, "^1[Kick]: ^0Player ^2"..GetPlayerName(args[1])..' ^0Tavasote Admin ^2'..GetPlayerName(source)..' ^0Be Dalile ^3'..reason..' ^0Kick Shod.')
				DropPlayer(args[1], "Shoma Tavasote Admin "..GetPlayerName(source).." Kick Shodid, Dalil: "..reason)
			else
				TriggerClientEvent('chatMessage', source, "^1>Syntax: /kick ID DALIL")
			end
		else
			TriggerClientEvent('chatMessage', source, "^1>Syntax: /kick ID DALIL")
		end
	else
		TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
	end
end)

RegisterCommand('car',function(source,args)
	local xPlayer = ESX.GetPlayerFromId(source)
	local esm = args[1]
	local playerid = args[2]
	if xPlayer.permission_level >= 2 then
		if esm then
			if playerid then
				TriggerClientEvent('esx:spawnVehicle',playerid,esm)
			else
				TriggerClientEvent('esx:spawnVehicle',source,esm)
			end
		else
			TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', '/car name id' } })
		end
	else
		TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
	end
end)

RegisterCommand('setperm',function(source,args)
	if source == 0 then
		local xTarget = ESX.GetPlayerFromId(args[1])
		ESX.SetPermission(xTarget.identifier,args[2])
		xTarget.set('permission_level', tonumber(args[2]))
		TriggerClientEvent('chatMessage', args[1], "^1[SYSTEM]: ^0Be Shoma Permission "..args[2].." Dad.")
	else
		local xPlayer = ESX.GetPlayerFromId(source)
			if tonumber(xPlayer.permission_level) >= 3 then
				if tonumber(args[1]) and tonumber(args[2]) then
					local xTarget = ESX.GetPlayerFromId(args[1])
					if tonumber(args[2]) <= tonumber(xPlayer.permission_level) then
						if tonumber(args[2]) == 0 then
							xTarget.set('permission_level', 0)
							ESX.SetPermission(xTarget.identifier,args[2])
							TriggerClientEvent('chatMessage', source, "^1[SYSTEM]: ^0Admin ^2"..GetPlayerName(tonumber(args[1])).." ^0Az Admini Demote Shod")
							TriggerClientEvent('chatMessage', args[1], "^1[SYSTEM]: ^0Admin ^2"..GetPlayerName(source).." ^0Shomaro Demote Kard.")
						else
							ESX.SetPermission(xTarget.identifier,args[2])
							xTarget.set('permission_level', tonumber(args[2]))
							TriggerClientEvent('chatMessage', source, "^1[SYSTEM]: ^0Be ^2"..GetPlayerName(tonumber(args[1])).." ^0Permission ^4"..args[2].." ^0Dade Shod.")
							TriggerClientEvent('chatMessage', args[1], "^1[SYSTEM]: ^0Admin ^2"..GetPlayerName(source).." ^0Be Shoma Permission ^4"..args[2].." ^0Dad.")
						end
					else
						TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Rank bayad Az perm shoma kamtar bashad' } })
					end
				else
					TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', '/setperm id rank' } })
				end
			else
				TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
			end
	end
end)

RegisterCommand('kickall', function(source, args)
	if source == 0 then
		local xPlayers = ESX.GetPlayers()
		for i=1, #xPlayers, 1 do
			xPlayer = ESX.GetPlayerFromId(xPlayers[i])
			xPlayer.kick('Server dar hale restart shodan ast lotfan fivem khod ra bebandid va baz konid')
		end
	end
end, false)

RegisterCommand('a', function(source, args)
    local xPlayer = ESX.GetPlayerFromId(source)
    if tonumber(xPlayer.permission_level) >= 1 then
        if args[1] then
            local name = GetPlayerName(source)
            local message = table.concat(args, " ")
            local xPlayers = ESX.GetPlayers()
            for i=1, #xPlayers, 1 do
                local xP = ESX.GetPlayerFromId(xPlayers[i])
                if tonumber(xP.permission_level) > 0 then
                    TriggerClientEvent('chatMessage', xPlayers[i], "[ADMIN] ", {255, 0, 0}, "^2"..name.."^0: "..message)
                end
            end
        else
            TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma nemitavanid matn khali befrestid!")
        end
    else
        TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma admin nistid!")
    end
end)

local gohNakhor = {}
RegisterCommand('g', function(source, args)
	if not gohNakhor[source] then
		local xPlayer = ESX.GetPlayerFromId(source)
		if xPlayer.gang.name ~= 'nogang' then
			if args[1] then
				local name = GetPlayerName(source)
				local message = table.concat(args, " ")
				local xPlayers = ESX.GetPlayers()
				for i=1, #xPlayers, 1 do
					local xP = ESX.GetPlayerFromId(xPlayers[i])
					if xP.gang.name == xPlayer.gang.name then
						TriggerClientEvent('chatMessage', xPlayers[i], "[GANG OOC | "..xPlayer.gang.name.."] ", {255, 0, 0}, "^2" .. name.. "^0: " .. message)
					end
				end
				gohNakhor[source] = true
				SetTimeout(30000, function()
					gohNakhor[source] = false
				end)
			else
				TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma nemitavanid matn khali befrestid!")
			end
		else
			TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma Ozv Hich ^1Gang ^0Nistid!")
		end
	else
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Spam nakon Hoy!")
	end
end)

RegisterCommand("changeped", function(source, args, user)
	local xPlayer = ESX.GetPlayerFromId(source)
	if tonumber(xPlayer.permission_level) >= 3 then
			if args[1] then
				if args[2] == nil then
					local requestped = tostring(args[1])
					TriggerClientEvent("changepedHandler", source, requestped)
				else
					TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma esm ped ra faghat bayad dar argument aval vared konid")
				end
			else
				TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma hich pedi vared nakardid")
			end
	else
		TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
	end
end)

RegisterCommand("setarmor", function(source, args)
	local xPlayer = ESX.GetPlayerFromId(source)
	if tonumber(xPlayer.permission_level) >= 2 then
			if args[1] and args[2] then
				if tonumber(args[1]) then
					local target = tonumber(args[1])
					if tonumber(args[2]) then
						local armor = tonumber(args[2])
						if armor <= 100 then
							if GetPlayerName(target) then
								local targetPlayer = ESX.GetPlayerFromId(target)
								TriggerClientEvent('chatMessage', target, "[SYSTEM]", {255, 0, 0}, " ^2" .. GetPlayerName(source) .. " ^0 Armor shomara be ^3" .. armor ..  " ^0Taghir dad!")
								TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "^0 Shoma be ^2 " .. GetPlayerName(target) .. "^3 " .. armor .. " ^0Armor dadid!")
								TriggerClientEvent('armorHandler', target, armor)
							else
								TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Player mored nazar online nist!")
							end
						else
							TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma nemitavanid meghdar armor ra bishtar az 100 vared konid!")
						end
					else
						TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma dar ghesmat Armor faghat mitavanid adad vared konid!")
					end
				else
					TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma dar ghesmat ID faghat mitavanid adad vared konid!")
				end
			else
				TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Syntax vared shode eshtebah ast!")
			end
	else
		TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
	end
end)

RegisterCommand('setmoney',function(source,args)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.permission_level >= 3 then
		if args[1] and args[2] and args[3] then
			local targetid = tonumber(args[1])
			local typemoney = tostring(args[2])
			local moneyam = tonumber(args[3])
			local typ
			if typemoney == "cash" or typemoney == "bank" then
				local target = ESX.GetPlayerFromId(targetid)
				if typemoney == "cash" then
					target.setMoney(moneyam)
					TriggerEvent('DiscordBot:ToDiscord', 'amoney', 'Money Log', ' Admin ' .. GetPlayerName(source) .. 'Baraye Id ' .. args[1] .. ' Cash Be Meghdar ' .. moneyam .. ' setmoney zad', 'user', source, true, false)
					TriggerClientEvent('chatMessage', source, "^1[SetMoney]^0: Pule Jibe User ^2"..GetPlayerName(targetid).." ^0Be (^2"..moneyam.."$^0) Set Shod.")
					TriggerClientEvent('chatMessage', targetid, "^1[SetMoney]^0: Admin ^2"..GetPlayerName(source).." ^0Pule Jibe Shomaro Be (^2"..moneyam.."$^0) Set Kard.")			
				else
					target.setBank(moneyam)
					TriggerEvent('DiscordBot:ToDiscord', 'amoney', 'Money Log', ' Admin ' .. GetPlayerName(source) .. 'Baraye Id ' .. args[1] .. ' Bank Be Meghdar ' .. moneyam .. ' setmoney zad', 'user', source, true, false)
					TriggerClientEvent('chatMessage', source, "^1[SetMoney]^0: Bank User ^2"..GetPlayerName(targetid).." ^0Be (^2"..moneyam.."$^0) Set Shod.")
					TriggerClientEvent('chatMessage', targetid, "^1[SetMoney]^0: Admin ^2"..GetPlayerName(source).." ^0Bank Shomaro Be (^2"..moneyam.."$^0) Set Kard.")
				end
			else
				TriggerClientEvent('chatMessage', source, "^1>[SetMoney Error]: /setmoney ID TYPE(cash-bank) MEGHDAR")
				end
		else
			TriggerClientEvent('chatMessage', source, "^1>[SetMoney Error]: /setmoney ID TYPE(cash-bank) MEGHDAR")
		end
	else
		TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Boro Badan Bia.' } })
	end
end)

RegisterCommand("disband", function(source, args)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.permission_level >= 3 then
		if args[1] and args[2] then
			local family = args[1]
			local reason = table.concat(args, " ", 2)
			MySQL.query('SELECT gang_name FROM gangs_data WHERE gang_name = @family',
			{
				['@family'] = family
			}, function(data)
				if data[1] then
					local xPlayers = ESX.GetPlayers()
					for i=1, #xPlayers, 1 do
						local xP = ESX.GetPlayerFromId(xPlayers[i])
						if xP.gang.name == family then
							xP.setGang("nogang",0)
						end
					end
					MySQL.update('DELETE FROM gangs WHERE name = @family', { ['@family'] = family })
					MySQL.update('DELETE FROM gang_grades WHERE gang_name = @family', { ['@family'] = family })
					MySQL.update('DELETE FROM gang_account WHERE name = @family', { ['@family'] = "gang_" .. string.lower(family) })
					MySQL.update('DELETE FROM gang_account_data WHERE gang_name = @family', { ['@family'] = "gang_" .. string.lower(family) })
					MySQL.update('DELETE FROM gangs_data WHERE gang_name = @family', { ['@family'] = family })
					MySQL.update('DELETE FROM owned_vehicles WHERE owner = @family', { ['@family'] = family })
					MySQL.update('DELETE FROM inventory_stash WHERE stash = @family', { ['@family'] = 'gang_'..family })
					MySQL.update('UPDATE users SET gang = "nogang" WHERE gang = @family', { ['@family'] = family })
					TriggerEvent('DiscordBot:ToDiscord', 'disband', 'Gang Log', ' Admin ' .. GetPlayerName(source) .. ' Gang ' .. family .. ' Ra be dalil ' .. reason .. ' dsiband kard', 'user', source, true, false)
					TriggerClientEvent('chatMessage', -1, "[DISBAND]", {255, 0, 0}, " Gang ^2" .. family .. " ^0Be Dalile ^1"..reason.." ^0Tavasote ^2"..GetPlayerName(source).." ^0Disband Shod.")
				else
					TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Family mored nazar vojoud nadarad!")
				end
			end)
		else
			TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma dar ghesmat dalil chizi vared nakardid!")
		end
	else
		TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Shoma Dastresi Kafi Nadarid.' } })
	end
end)

TriggerEvent('es:addAdminCommand', 'announce', 3, function(source, args, user)
    local msg = table.concat(args, " ")
	TriggerClientEvent('chat:addMessage', -1, {
        template = '<div style="background-color: rgba(255, 0, 0, 0.8);" class="chat-message advert"><div class="chat-message-body"><strong>{0}:</strong>{1}</div></div>',
        args = {"Announcement - "..GetPlayerName(source), " "..msg}
    })
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = {"^1[ System ] : ", "Shoma Dastresi Kafi Nadari!"} })
end, {help = "Announce a message to the entire server", params = {{name = "announcement", help = "The Message To Announce"}}})

TriggerEvent('es:addAdminCommand', 'fine', 2, function(source, args, user)
	if args[1] and args[2] and args[3] then
		target = tonumber(args[1]) 
		if target then
			if GetPlayerName(target) then
				local targetPlayer = ESX.GetPlayerFromId(target)
				money = tonumber(args[2])
				if money then
						local previousmoney = targetPlayer.bank
						local reason = table.concat(args, " ",3)
						
						targetPlayer.removeBank(money)
						TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', " ^0Shoma az^1 " .. GetPlayerName(target) .. " ^0Mablagh ^2" .. money .. "$ ^0kam kardid!" } })
						TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', " ^0Pool ghadimi ^3" .. GetPlayerName(target) .. " ^1" .. previousmoney .. "$^0 Pool jadid ^2" .. targetPlayer.bank .. "$" } })
						TriggerEvent('DiscordBot:ToDiscord', 'fine', 'Fine Log', GetPlayerName(source), "```css\n" .. GetPlayerName(target) .. " Be Elate " .. reason .. " Be Mablaqe $" .. ESX.Math.GroupDigits(money) .. " Jarime shod\n```",'user', source, true, false)

						TriggerClientEvent('chat:addMessage', -1, {
							template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(255, 131, 0, 0.4); border-radius: 3px;"><i class="fas fa-exclamation-triangle"></i> Punishment<br>  {1}</div>',
							args = { GetPlayerName(source), " ^1" .. GetPlayerName(target) .. "^0 Be Elate ^1^*" .. reason .. "^r^0 Be Mablaqe ^2$" .. ESX.Math.GroupDigits(money) .. "^0 Jarime shod" }
						})
				else
					TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', " ^0Shoma dar ghesmat fine faghat mitavanid adad vared konid!" } })
				end
			else
				TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', " ^0Player mored nazar online nist!" } })
			end
		else
			TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', " ^0Shoma dar ghesmat ID faghat mitavanid adad vared konid!" } })
		end
	else
		TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', " ^0Syntax vared shode eshtebah ast!" } })
	end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Perm Kafi Nadarid' } })
end, {help = "Kam Kardane Pool az Player", params = {{name = "PlayerID", help = "Id Playeri ke Online hast"}, {name = "Price", help = "Mablaqe Jarime"}, {name = "Reason", help = "Dalil Jarime"}}})

local screenwebhook = ''
RegisterCommand("sc", function(source, args)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.permission_level >= 2 then
        local target = tonumber(args[1])
        local targetXPlayer = ESX.GetPlayerFromId(target)
        if targetXPlayer ~= nil then
            TriggerClientEvent("Parzival:TakeScreenPlayer", target, screenwebhook)
        else
            TriggerClientEvent("chatMessage", source, "^1SYSTEM" .. ' ^0Id Vared Shode Eshtebah Ast!')
        end
    else
        TriggerClientEvent("chatMessage", source, "^1SYSTEM " .. ' ^0Permision Kafi Nadarid')
    end
end)

TriggerEvent('es:addAdminCommand', 'clearinventory', 2, function(source, args, user)
	local xPlayer = ESX.GetPlayerFromId(source)
		if args[1] then
			if(tonumber(args[1]) and GetPlayerName(tonumber(args[1])))then
				local player = ESX.GetPlayerFromId(tonumber(args[1]))
				player.ClearInventory()
			else
				TriggerClientEvent('chat:addMessage', source, { args = {"^1SYSTEM", "Incorrect player ID"}})
			end
		else
			xPlayer.ClearInventory()
		end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = {"^1SYSTEM", "Insufficienct permissions!"} })
end, {help = "Clear Inventory"})

TriggerEvent('es:addAdminCommand', 'openinventory', 3, function(source, args, user)
	local xPlayer = ESX.GetPlayerFromId(source)
		if args[1] then
			if(tonumber(args[1]) and GetPlayerName(tonumber(args[1])))then
				local player = tonumber(args[1])
				TriggerClientEvent("Proxtended:OpenInventory", source, player)
			else
				TriggerClientEvent('chat:addMessage', source, { args = {"^1SYSTEM", "Incorrect player ID"}})
			end
		end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = {"^1SYSTEM", "Insufficienct permissions!"} })
end, {help = "Open Inventory"})

TriggerEvent('es:addAdminCommand', 'openinventory', 3, function(source, args, user)
	local xPlayer = ESX.GetPlayerFromId(source)
		if args[1] then
			if(tonumber(args[1]) and GetPlayerName(tonumber(args[1])))then
				local player = tonumber(args[1])
				TriggerClientEvent("Proxtended:OpenInventory", source, player)
			else
				TriggerClientEvent('chat:addMessage', source, { args = {"^1SYSTEM", "Incorrect player ID"}})
			end
		end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = {"^1SYSTEM", "Insufficienct permissions!"} })
end, {help = "Open Inventory"})
