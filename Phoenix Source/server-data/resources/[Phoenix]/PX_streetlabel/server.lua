ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
	ESX = obj
end)

AddEventHandler('esx:playerLoaded', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	local item = xPlayer.getInventoryItem("phone")
	if item.count > 0 then
		TriggerClientEvent('PX_streetlabel:addGPS', source)
	end
end)

AddEventHandler('esx:onAddInventoryItem', function(source, item, count)
	if item.name == 'phone' then
		TriggerClientEvent('PX_streetlabel:addGPS', source)
	end
end)

AddEventHandler('esx:onRemoveInventoryItem', function(source, item, count)
	if item.name == 'phone' and item.count < 1 then
		TriggerClientEvent('PX_streetlabel:removeGPS', source)
	end
end)