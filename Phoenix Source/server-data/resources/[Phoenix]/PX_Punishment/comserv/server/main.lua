ESX = nil
local ACnumb = math.random(1, 100)  --Mani[Easy-Pixel]

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

TriggerEvent('es:addAdminCommand', 'cs', 2, function(source, args, user)
	local xPlayer = ESX.GetPlayerFromId(source)
	if args[1] then
		if tonumber(args[2]) then
			if tonumber(args[2]) > 0 and tonumber(args[2]) < 1000 then
				if args[3] then
					if string.find(args[1], "steam:") == nil then
						local zPlayer = ESX.GetPlayerFromId(args[1])
						if GetPlayerName(args[1]) then
							TriggerEvent('Parzival_Comserv:OnlineJail', xPlayer.source, zPlayer.source, tonumber(args[2]), table.concat(args, ' ', 3))
						else
							TriggerClientEvent('chatMessage', source, "[Punishment]", {255, 0, 0}, " Player Mored Nazar Online Nist.!")
						end
					else
						TriggerEvent('Parzival_Comserv:OfflineJail', args[1], tonumber(args[2]), xPlayer.source, args[3])
					end
				else
					TriggerClientEvent('chatMessage', source, "[Punishment]", {255, 0, 0}, " Shoma Dar Dalil Ra Vared Nakardid.")
				end
			else
				TriggerClientEvent('chatMessage', source, "[Punishment]", {255, 0, 0}, " Shoma Dar Ghesmat Dovom Bayad Adad 1-999 Vared Konid.")
			end
		else
			TriggerClientEvent('chatMessage', source, "[Punishment]", {255, 0, 0}, " Shoma Dar Ghesmat Dovom Bayad Adad Vared Konid.")
		end
	else
		TriggerClientEvent('chatMessage', source, "[Punishment]", {255, 0, 0}, " Shoma Dar Ghesmat Aval SteamHex Ya ID Vared Nakardid.")
	end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^2[Punishment]', ' ^1Shoma Permission Kafi Nadarid!!.' } })
end, {help = "Khadamat Ejtemaei ", params = {{name = "ID / Steam", help = "Steam Hex Or ID"}, {name = "Tedad", help = "Meghdar Khadamat"}, {name = "Dalil", help = "Reason"}}})

AddEventHandler('Parzival_Comserv:OnlineJail', function(Me, Target, Tedad, Reason)
	local Action = tonumber(Tedad)
	local xPlayer = ESX.GetPlayerFromId(Target)
	Citizen.CreateThread(function()
		MySQL.query('SELECT comserv FROM users WHERE identifier = @identifier',
		{
			['@identifier'] = xPlayer.identifier

		}, function(data)
			if data[1] then
				MySQL.update('UPDATE users SET comserv = @actions WHERE identifier = @identifier',
				{
					['@actions']    = Action,
					['@identifier'] = xPlayer.identifier
				})
			end
			TriggerEvent('DiscordBot:ToDiscord', 'comserv', "Phoenix", GetPlayerName(xPlayer.source)..' Bedalil ' ..Reason ..' Tavasot '..GetPlayerName(Me)..' Be Tedad '..Action..' Comserv Shod' ,'user', xPlayer.source, true, false)
			TriggerClientEvent('Parzival_Comserv:TimeToFingerYourSelf', xPlayer.source, Action)
			TriggerClientEvent('chat:addMessage', -1, {
				template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(255, 131, 0, 0.4); border-radius: 3px;"><i class="fas fa-exclamation-triangle"></i> [Punishment]<br>  {1}</div>',
				args = {GetPlayerName(xPlayer.source), '^1' .. GetPlayerName(xPlayer.source) .. '^0 Be Dalile ^4'.. Reason .. ' ^0 Tavasot ^3'..GetPlayerName(Me)..' ^0Be ^2'.. Action ..' ^0Comserv Shod!'}
			})
		end)
	end)
end)

AddEventHandler('Parzival_Comserv:OfflineJail', function(SteamHex, Tedad, xAdmin, Reason)
	local Action = tonumber(Tedad)
	Citizen.CreateThread(function()
		MySQL.query('SELECT comserv FROM users WHERE identifier = @identifier',
		{
			['@identifier'] = SteamHex

		}, function(data)
			if data[1] then
				local xPlayer = ESX.GetPlayerFromIdentifier(SteamHex)
				if xPlayer then
					TriggerClientEvent('Parzival_Comserv:TimeToFingerYourSelf', xPlayer.source, Action)
				end
				MySQL.update('UPDATE users SET comserv = @actions, WHERE identifier = @identifier',
				{
					['@actions']    = Action,
					['@identifier'] = SteamHex
				})
				TriggerClientEvent('chat:addMessage', -1, {
					template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(255, 131, 0, 0.4); border-radius: 3px;"><i class="fas fa-exclamation-triangle"></i> ^1[Offline Punishment]<br>  {1}</div>',
					args = {GetPlayerName(xAdmin), '^1' .. SteamHex .. '^0 Be Dalile ^4'.. Reason .. ' ^0 Tavasot ^3'..GetPlayerName(xAdmin)..' ^0Be ^2'.. Action ..' ^0Comserv Shod!'}
				})
				TriggerEvent('DiscordBot:ToDiscord', 'comserv', "Phoenix", SteamHex..' Bedalil ' ..Reason ..' Tavasot '..GetPlayerName(xAdmin)..' Be Tedad '..Action..' Comserv Shod' ,'user', xAdmin, true, false)
			else
				TriggerClientEvent('chatMessage', xAdmin, "[Punishment]", {255, 0, 0}, " Steam Vared Shode Eshtebah Ast!")
			end
		end)
	end)
end)

RegisterServerEvent('Parzival_Comserv:CheckIsJail')
AddEventHandler('Parzival_Comserv:CheckIsJail', function()
	local Id = source
	local steam = "None"
	local license = "None"
	for k, v in ipairs(GetPlayerIdentifiers(Id)) do
		if string.sub(v, 1,string.len("steam:")) == "steam:" then
			steam  = v
		elseif string.sub(v, 1,string.len("license:")) == "license:" then
			license  = v
		end
	end
	Citizen.CreateThread(function()
		local tedad = 0
		MySQL.query('SELECT * FROM users',
		{}, function(data)
			for i=1, #data, 1 do
				if (data[i].identifier == steam or data[i].license == license) and data[i].comserv > 0 then
					if data[i].comserv > tedad then
						tedad = data[i].comserv
					end
				end
			end
			if tedad > 0 then
				TriggerClientEvent('esx:showNotification', Id, "Akharin Bar Ke DC Dadid ~r~Comserv ~w~Boodid!")
				TriggerClientEvent('Parzival_Comserv:TimeToFingerYourSelf', Id, tedad)
			end
			MySQL.update('UPDATE users SET comserv = @actions WHERE identifier = @identifier OR license = @license',
			{
				['@actions'] = tedad,
				['@identifier'] = steam,
				['@license'] = license
			})
		end)
	end)
end)

RegisterServerEvent('Parzival_Comserv:MyActionIsDone')
AddEventHandler('Parzival_Comserv:MyActionIsDone', function(tedad, Code)
	if Code == ACnumb then
		local steam = "None"
		local license = "None"
		for k, v in ipairs(GetPlayerIdentifiers(source)) do
			if string.sub(v, 1,string.len("steam:")) == "steam:" then
				steam  = v
			elseif string.sub(v, 1,string.len("license:")) == "license:" then
				license  = v
			end
		end
		MySQL.update('UPDATE users SET comserv = @actions WHERE identifier = @identifier OR license = @license',
		{
			['@actions'] = tedad,
			['@identifier'] = steam,
			['@license'] = license
		})
		if tedad == 0 then
			TriggerClientEvent("Parzival_Comserv:ReleaseMe", source, ACnumb)
		end
	else
		print("Id: "..source.." Try to Remove Comserv")
	end
end)

RegisterServerEvent('Parzival_Comserv:Abusing')
AddEventHandler('Parzival_Comserv:Abusing', function()
	local Id = source
	local xPlayers = ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xP = ESX.GetPlayerFromId(xPlayers[i])
		if tonumber(xP.permission_level) > 0 then
			TriggerClientEvent('chatMessage', xPlayers[i], "[Punishment]", {255, 0, 0},  "^2"..GetPlayerName(Id).."("..Id..") ^0Is Abusing Revive(ReSpawn) While Doing Action in Comserv!")
		end
	end
end)

RegisterServerEvent('EZ_Pixel:comserv:ImLoaded')
AddEventHandler('EZ_Pixel:comserv:ImLoaded', function()
    TriggerClientEvent('EZ_Pixel:comserv:sendCode', source, ACnumb)
end)