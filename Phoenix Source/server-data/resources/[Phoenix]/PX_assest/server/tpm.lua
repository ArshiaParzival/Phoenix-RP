local ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

TriggerEvent('es:addAdminCommand', 'tpm', 2, function(source, args, user)
	TriggerClientEvent('esx:tpm', source)
end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " Insufficient Permissions.")
end, {help = 'Tp To Mark'})