ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

TriggerEvent('esx_society:registerSociety', 'mechanic', 'Mechanic', 'society_mechanic', 'society_mechanic', 'society_mechanic', {type = 'public'})
TriggerEvent('esx_society:registerSociety', 'motormechanic', 'MotoCycle Mechanic', 'society_motormechanic', 'society_motormechanic', 'society_motormechanic', {type = 'public'})

ESX.RegisterUsableItem('fixtool', function(source)
	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('fixtool', 1)
	TriggerClientEvent('esx_mechanicjob:onFixkit', _source)
	TriggerClientEvent('esx:showNotification', _source, _U('you_used_repair_kit'))
end)

RegisterServerEvent('esx_mechanicjob:remove')
AddEventHandler('esx_mechanicjob:remove', function(itemName)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem(itemName, 1)
end)

ESX.RegisterUsableItem('tyre', function(source)
	TriggerClientEvent('esx_mechanicjob:useTyre', source)
end)

ESX.RegisterUsableItem('door', function(source)
	TriggerClientEvent('esx_mechanicjob:useDoor', source)
end)