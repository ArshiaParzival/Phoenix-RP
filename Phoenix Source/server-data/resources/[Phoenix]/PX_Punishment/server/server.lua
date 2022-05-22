ESX	= nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local AS, ASWarn = {}, {}

RegisterServerEvent("PX_jail:JailPlayer")
AddEventHandler("PX_jail:JailPlayer", function(targetSrc, jailTime, jailReason)
	local src 				= source
	local targetSrc 		= tonumber(targetSrc)
	local xPlayer 			= ESX.GetPlayerFromId(src)
	local jailPlayerData 	= ESX.GetPlayerFromId(targetSrc)

	if xPlayer.job.name == "police" or xPlayer.job.name == "dadgostari" then
		if not AS[src] then
			AS[src] = true
			JailPlayer(targetSrc, jailTime)
			TriggerClientEvent('chat:addMessage', targetSrc, { args = { "^1[DOC] ^0", "Shoma Be Elate ^2" .. jailReason .. " ^0Zendani Shodid!"}, color = {255,0,0}})
			TriggerClientEvent('chat:addMessage', src, { args = { "^1[DOC] ^0", jailPlayerData.name.." Be Elate ^2" .. jailReason .. " ^0Zendani Shod!"}, color = {255,0,0}})
			SetTimeout(2000, function() AS[src] = nil end)
		else
			if not ASWarn[src] then
				exports.BanSystem:bancheater(src, 'LUA Executor (Jail All)')
				ASWarn[src] = true
				SetTimeout(3000, function() ASWarn[src] = nil end)
			end
		end
	end
end)

RegisterServerEvent("PX_jail:UnjailPlayer")
AddEventHandler("PX_jail:UnjailPlayer", function(targetIdentifier, status)
	local src = source
	local theJailPlayer = ESX.GetPlayerFromIdentifier(targetIdentifier)
	if theJailPlayer ~= nil then
		UnJail(theJailPlayer.source)
		if status then
			TriggerClientEvent("esx:showNotification", src, string.gsub(theJailPlayer.name, "_", " ")  .. " Azad shod!")
		end
	else
		MySQL.update(
			"UPDATE users SET jail = @newJailTime WHERE identifier = @identifier",
			{
				['@identifier'] = targetIdentifier,
				['@newJailTime'] = 0
			}
		)
		if status then
			MySQL.query(
			'SELECT * FROM users WHERE identifier = @identifier',
			{
				['@identifier'] = targetIdentifier,
			}, function(result)
				TriggerClientEvent("esx:showNotification", src, result[1].firstname.." "..result[1].lastname.. " Azad shod!")
			end)
		end
	end
end)

RegisterServerEvent("PX_jail:server:changeStatus")
AddEventHandler("PX_jail:server:changeStatus", function(status)
	local src = source
	if type(status) ~= 'boolean' then
		return
	end
	local xPlayer = ESX.GetPlayerFromId(src)
	if xPlayer ~= nil then
		xPlayer.set('jailed', status)
	end
end)

RegisterServerEvent("PX_jail:updateJailTime")
AddEventHandler("PX_jail:updateJailTime", function(newJailTime)
	local src = source
	EditJailTime(src, newJailTime)
end)

function JailPlayer(jailPlayer, jailTime)
	TriggerClientEvent("PX_jail:JailPlayer", jailPlayer, jailTime)
	EditJailTime(jailPlayer, jailTime)
end

function UnJail(jailPlayer)
	TriggerClientEvent("PX_jail:UnjailPlayer", jailPlayer)
	EditJailTime(jailPlayer, 0)
end

function EditJailTime(source, jailTime)
	local xPlayer = ESX.GetPlayerFromId(source)
	local Identifier = xPlayer.identifier
	MySQL.update(
       "UPDATE users SET jail = @newJailTime WHERE identifier = @identifier",
        {
			['@identifier'] = Identifier,
			['@newJailTime'] = tonumber(jailTime)
		}
	)
end

ESX.RegisterServerCallback("PX_jail:getJailedPlayers", function(source, cb)
	local jailedPersons = {}
	MySQL.query("SELECT playerName, jail, identifier FROM users WHERE jail > @jail", { ["@jail"] = 0 }, function(result)
		for i = 1, #result, 1 do
			table.insert(jailedPersons, { name =  result[i].firstname.." "..result[i].lastname, jailTime = result[i].jail, identifier = result[i].identifier })
		end
		cb(jailedPersons)
	end)
end)

ESX.RegisterServerCallback("PX_jail:getOwnJail", function(source, cb)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	local Identifier = xPlayer.identifier
	MySQL.query("SELECT jail FROM users WHERE identifier = @identifier", { ["@identifier"] = Identifier }, function(result)
		local JailTime = tonumber(result[1].jail)
		if JailTime and JailTime > 0 then
			cb(true, JailTime)
		else
			cb(false)
		end
	end)
end)

RegisterCommand("checkjail", function(source, args)
	local xPlayer = ESX.GetPlayerFromId(source)
	local pid = tonumber(args[1])
	if xPlayer.job.name == "police" or xPlayer.job.name == "dadgostari" then
		if pid then
			local zPlayer = ESX.GetPlayerFromId(pid)
			if zPlayer then
				local check = zPlayer.get("jailed")
				if check then
					TriggerClientEvent("esx:showNotification", source, zPlayer.name.." Dar Zendan Ast!")
				else
					TriggerClientEvent("esx:showNotification", source, zPlayer.name.." Dar Zendan Nist!")
				end
			else
				TriggerClientEvent("esx:showNotification", source, "player Mored Nazar Online Nist!")
			end
		else
			TriggerClientEvent("esx:showNotification", source, "Lotfan ID fard Ra vared konid!")
		end
	else
		TriggerClientEvent("esx:showNotification", source, "Shoma Police Nistid!")
	end
end)