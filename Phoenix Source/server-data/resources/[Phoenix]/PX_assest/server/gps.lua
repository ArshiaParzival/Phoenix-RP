ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
	ESX = obj
end)

ESX.RegisterServerCallback("esx_gps:checkGPS", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local count = xPlayer.getInventoryItem("phone").count
    if count > 0 then
        cb(true)
    else
        cb(false)
    end
end)

AddEventHandler('esx:onAddInventoryItem', function(source, item, count)
	if item == 'phone' then
		TriggerClientEvent('esx_gps:addGPS', source)
	end
end)

AddEventHandler('esx:onRemoveInventoryItem', function(source, item, count)
	if item.name == 'phone' and item.count < 1 then
		TriggerClientEvent('esx_gps:removeGPS', source)
	end
end)