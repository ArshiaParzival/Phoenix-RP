ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('Phoenix:cuff')
AddEventHandler('Phoenix:cuff', function(targetid, playerheading, playerCoords,  playerlocation)
	if #(GetEntityCoords(GetPlayerPed(source)) - GetEntityCoords(GetPlayerPed(targetid))) >= 5 then return end
	TriggerClientEvent('Parzival_Actions:getarrested', targetid, playerheading, playerCoords, playerlocation, source)
	TriggerClientEvent('Parzival_Actions:doarrested', source)
end)

RegisterServerEvent('Phoenix:uncuff')
AddEventHandler('Phoenix:uncuff', function(targetid, playerheading, playerCoords,  playerlocation)
	if #(GetEntityCoords(GetPlayerPed(source)) - GetEntityCoords(GetPlayerPed(targetid))) >= 5 then return end
	TriggerClientEvent('Parzival_Actions:getuncuffed', targetid, playerheading, playerCoords, playerlocation, source)
	TriggerClientEvent('Parzival_Actions:douncuffing', source)
end)

RegisterServerEvent('Phoenix:drag')
AddEventHandler('Phoenix:drag', function(target)
	TriggerClientEvent('Phoenix:drag', target, source)
	TriggerClientEvent('Parzival_Actions:draging', source, target)
end)

RegisterServerEvent('Phoenix:putInVehicle')
AddEventHandler('Phoenix:putInVehicle', function(target, NetID)
	TriggerClientEvent('Phoenix:putInVehicleS', source)
	TriggerClientEvent('Phoenix:putInVehicle', target, NetID)
end)

RegisterServerEvent('Phoenix:OutVehicle')
AddEventHandler('Phoenix:OutVehicle', function(target)
    TriggerClientEvent('Phoenix:OutVehicle', target)
end)