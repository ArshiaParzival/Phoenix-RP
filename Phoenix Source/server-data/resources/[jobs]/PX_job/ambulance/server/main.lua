ESX = nil
local playersHealing = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_ambulancejob:reviveavermani')
AddEventHandler('esx_ambulancejob:reviveavermani', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'ambulance' and xPlayer.job.grade >= 0 then
		xPlayer.addMoney(AmbulanceConfig.ReviveReward)
		TriggerClientEvent('esx_ambulancejob:reviveavermani', target)
	else
		print(('esx_ambulancejob: %s attempted to revive!'):format(xPlayer.identifier))
	end
end)

RegisterServerEvent('esx_ambulancejob:heal')
AddEventHandler('esx_ambulancejob:heal', function(target, type)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'ambulance' and xPlayer.job.grade >= 0 then
		TriggerClientEvent('esx_ambulancejob:heal', target, type)
	else
		print(('esx_ambulancejob: %s attempted to heal!'):format(xPlayer.identifier))
	end
end)

RegisterServerEvent('esx_hospital:pay')
AddEventHandler('esx_hospital:pay', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeMoney(30000)
	TriggerClientEvent('esx:showNotification', source, _U('you_paid', ESX.Math.GroupDigits(30000)))
end)

ESX.RegisterServerCallback('esx_hospital:checkMoney', function(source, cb)
	local xPlayers = ESX.GetPlayers()
	local tedad = 0
	for i=1, #xPlayers, 1 do
		if tedad < 3 then
			local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
			if xPlayer.job.name == "ambulance" then
				tedad = tedad + 1
			end
		end
	end
	if tedad > 2 then
		TriggerClientEvent('esx:showNotification', source, "Dar Shahr Bish Az 2 Medic Ast!")
		return
	end
	local xPlayer = ESX.GetPlayerFromId(source)
	cb(xPlayer.money >= 30000)
end)

RegisterServerEvent('esx_ambulancejob:syncDaadBady')
AddEventHandler('esx_ambulancejob:syncDaadBady', function(ped, target)
	if #(GetEntityCoords(GetPlayerPed(source)) - GetEntityCoords(GetPlayerPed(target))) >= 15.0 then return end
	TriggerClientEvent('esx_ambulancejob:finishCRP', target, ped, _source)
end)

TriggerEvent('esx_society:registerSociety', 'ambulance', 'Ambulance', 'society_ambulance', 'society_ambulance', 'society_ambulance', {type = 'public'})

ESX.RegisterServerCallback('esx_ambulancejob:removeItemsAfterRPDeath', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.ClearInventory()
	xPlayer.setMoney(0)
	cb()
end)

if AmbulanceConfig.EarlyRespawnFine then
	ESX.RegisterServerCallback('esx_ambulancejob:checkBalance', function(source, cb)
		local xPlayer = ESX.GetPlayerFromId(source)
		local bankBalance = xPlayer.bank

		cb(bankBalance >= AmbulanceConfig.EarlyRespawnFineAmount)
	end)

	RegisterServerEvent('esx_ambulancejob:payFine')
	AddEventHandler('esx_ambulancejob:payFine', function()
		local xPlayer = ESX.GetPlayerFromId(source)
		local fineAmount = AmbulanceConfig.EarlyRespawnFineAmount

		TriggerClientEvent('esx:showNotification', xPlayer.source, _U('respawn_bleedout_fine_msg', ESX.Math.GroupDigits(fineAmount)))
		xPlayer.removeBank(fineAmount)
	end)
end

ESX.RegisterServerCallback('esx_ambulancejob:getItemAmount', function(source, cb, item)
	local xPlayer = ESX.GetPlayerFromId(source)
	local quantity = xPlayer.getInventoryItem(item).count

	cb(quantity)
end)

TriggerEvent('es:addAdminCommand', 'revive', 2, function(source, args, user)
	if args[1] ~= nil then
		if GetPlayerName(tonumber(args[1])) ~= nil then
			TriggerClientEvent('esx_ambulancejob:reviveavermani', tonumber(args[1]))
			TriggerEvent('DiscordBot:ToDiscord', 'revive', 'revive Log', ' Admin ' .. GetPlayerName(source) .. ' Id ' .. args[1] .. ' ra Revive kard', 'user', source, true, false)
		end
	else
		TriggerClientEvent('esx_ambulancejob:reviveavermani', source)
	end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, { help = _U('revive_help'), params = {{ name = 'id' }} })

ESX.RegisterUsableItem('medikit', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not playersHealing[source] then
		local xPlayer = ESX.GetPlayerFromId(source)
		xPlayer.removeInventoryItem('medikit', 1)
	
		playersHealing[source] = true
		TriggerClientEvent('esx_ambulancejob:useItem', source, 'medikit')

		Citizen.Wait(10000)
		playersHealing[source] = nil
	end
end)

ESX.RegisterUsableItem('bandage', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not playersHealing[source] then
		local xPlayer = ESX.GetPlayerFromId(source)
		xPlayer.removeInventoryItem('bandage', 1)
	
		playersHealing[source] = true
		TriggerClientEvent('esx_ambulancejob:useItem', source, 'bandage')

		Citizen.Wait(10000)
		playersHealing[source] = nil
	end
end)

ESX.RegisterServerCallback('esx_ambulancejob:getDeathStatus', function(source, cb)
	local identifier = GetPlayerIdentifiers(source)[1]

	MySQL.scalar('SELECT is_dead FROM users WHERE identifier = @identifier', {
		['@identifier'] = identifier
	}, function(isDead)
		cb(isDead)
	end)
end)

local Combat = {}

RegisterServerEvent('esx_ambulancejob:setDaathStatus')
AddEventHandler('esx_ambulancejob:setDaathStatus', function(isDead)
	local xPlayer = ESX.GetPlayerFromId(source)
	local identifier = xPlayer.identifier
	if isDead ~= -1 then
		xPlayer.set('IsDead', isDead)
		xPlayer.set('Injure', isDead)

		if type(isDead) ~= 'boolean' then
			isDead = true
		end

		Combat[identifier] = isDead
	else
		xPlayer.set('Injure', 'done')
	end
end)

AddEventHandler('playerDropped', function(resoan)
	local steamhex = GetPlayerIdentifier(source)
	if Combat[steamhex] then
		MySQL.update.await('UPDATE users SET is_dead = @isDead WHERE identifier = @identifier', {
			['@identifier'] = steamhex,
			['@isDead'] = true
		})
	else
		MySQL.update.await('UPDATE users SET is_dead = @isDead WHERE identifier = @identifier', {
			['@identifier'] = steamhex,
			['@isDead'] = false
		})
	end
end)

RegisterServerEvent("GetDiagnosis")
AddEventHandler("GetDiagnosis", function(id)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.job.name == "ambulance" then 
		TriggerClientEvent("PassDiagnosis", id, source)
	else
		TriggerClientEvent("esx:showNotification", source, "Shoma Medic Nistid!")
	end
end)

RegisterServerEvent("PassDiagnosis")
AddEventHandler("PassDiagnosis", function(a, b, c, d, e, f, g, id)
	TriggerClientEvent("OpenBodyDamage", source, a, b, c, d, e, f, g)
	TriggerClientEvent("OpenBodyDamage", id, a, b, c, d, e, f, g)
end)