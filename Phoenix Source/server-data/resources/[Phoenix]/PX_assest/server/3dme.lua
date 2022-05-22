ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('3dme:shareDisplay')
AddEventHandler('3dme:shareDisplay', function(text)
	local ped = GetPlayerPed(source)
    local ped_NETWORK = NetworkGetNetworkIdFromEntity(ped)
	TriggerClientEvent('3dme:triggerDisplay', -1, text, source, ped_NETWORK)
end)

ESX.RegisterServerCallback('3dme:getIcName', function (source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer then
		local name = xPlayer.name
		local words = {}
		for w in (name):gmatch("([^_]*)") do
			table.insert(words, w)
		end
		cb(words[1])
	end
end)