ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('codem-nargile:server:setAlreadyHaveHookah')
AddEventHandler('codem-nargile:server:setAlreadyHaveHookah', function(masa, toggle)
    Config.Masalar[masa].alreadyHaveHookah = toggle
    TriggerClientEvent('codem-nargile:client:getConfig', -1,  Config.Masalar)
end)

RegisterServerEvent('codem-nargile:server:setSessionStarted')
AddEventHandler('codem-nargile:server:setSessionStarted', function(masa, toggle)
    Config.Masalar[masa].sessionActive = toggle
    TriggerClientEvent('codem-nargile:client:getConfig', -1,  Config.Masalar)
end)

RegisterServerEvent('codem-nargile:server:syncHookahTable')
AddEventHandler('codem-nargile:server:syncHookahTable', function(nargileler)
    TriggerClientEvent('codem-nargile:client:setHookahs', -1, nargileler)
end)

RegisterServerEvent("hookah_smokes")
AddEventHandler("hookah_smokes", function(entity)
	TriggerClientEvent("c_hookah_smokes", -1, entity)
end)

RegisterServerEvent('codem-nargile:server:deleteMarpuc')
AddEventHandler('codem-nargile:server:deleteMarpuc', function(masa)
    TriggerClientEvent('codem-nargile:client:deleteMarpuc', -1, masa)
end)

RegisterServerEvent('codem-nargile:server:deleteNargile')
AddEventHandler('codem-nargile:server:deleteNargile', function(masa)
    TriggerClientEvent('codem-nargile:client:deleteNargile', -1, masa)
	TriggerClientEvent('esx:showNotification', source, "Shoma Ghelyan Ra Bardashtid!")
end)

RegisterServerEvent('codem-nargile:server:syncKoz')
AddEventHandler('codem-nargile:server:syncKoz', function(obj, amount)
    TriggerClientEvent('codem-nargile:client:syncKoz', -1, obj, amount)

end)

RegisterServerEvent('BlackBand:useghelyon')
AddEventHandler('BlackBand:useghelyon', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    TriggerClientEvent('esx_status:add', source, 'hunger', 30000)
    TriggerClientEvent('esx_status:add', source, 'thirst', 30000)
end)

RegisterServerEvent('PX_Cafe:getStockItem')
AddEventHandler('PX_Cafe:getStockItem', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)
	
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_cafe', function(inventory)
		local item = inventory.getItem(itemName)
		local sourceItem = xPlayer.getInventoryItem(itemName)

		if count > 0 and item.count >= count then
		
			if sourceItem.limit ~= -1 and (sourceItem.count + count) > sourceItem.limit then
				TriggerClientEvent('esx:showNotification', xPlayer.source, "Fazaye Kafi Nadarid")
			else
				inventory.removeItem(itemName, count)
				xPlayer.addInventoryItem(itemName, count)
				TriggerClientEvent('esx:showNotification', xPlayer.source, 'Item Bardashtid')
			end
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, "Adad Vared Shode Eshtebahe")
		end
	end)
end)

ESX.RegisterServerCallback('PX_Cafe:getStockItems', function(source, cb)
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_cafe', function(inventory)
		cb(inventory.items)
	end)
end)

RegisterServerEvent('PX_Cafe:putStockItems')
AddEventHandler('PX_Cafe:putStockItems', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_cafe', function(inventory)
		local item = inventory.getItem(itemName)

		if item.count >= 0 then
			xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
			TriggerClientEvent('esx:showNotification', xPlayer.source, "Shoma Item Gozashtid")
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, "Adad Vared Shode Eshtebahe")
		end

	end)

end)

ESX.RegisterServerCallback('PX_Cafe:getPlayerInventory', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items   = xPlayer.inventory
	cb( { items = items } )
end)