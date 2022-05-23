ESX = nil
local ACnumbLJ = math.random(1, 100)  --Mani
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('EZ_Pixel:lumberjack:ImLoaded')
AddEventHandler('EZ_Pixel:lumberjack:ImLoaded', function()
    TriggerClientEvent('EZ_Pixel:lumberjack:sendCode', source, ACnumbLJ)
end)

RegisterServerEvent('parzival_lumberjack:gereftanchoob')
AddEventHandler('parzival_lumberjack:gereftanchoob', function(Code)
	if Code == ACnumbLJ then
		local xPlayer = ESX.GetPlayerFromId(source)
		local item = xPlayer.getInventoryItem('packaged_plank')
		if item.limit == -1 or item.count < item.limit then
			xPlayer.addInventoryItem('packaged_plank', 50)
		else
			TriggerClientEvent("esx:showNotification", source, "Shoma fazaye Kafi nadarid!")
		end
	else
		print("Id: "..source.." Try to add item with "..GetCurrentResourceName())
	end
end)

RegisterServerEvent('parzival_lumberjack:khordkardanchoob')
AddEventHandler('parzival_lumberjack:khordkardanchoob', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local item = xPlayer.getInventoryItem('cutted_wood')
    if item.limit == -1 or item.count < item.limit then
		xPlayer.addInventoryItem('cutted_wood', 50)
		xPlayer.removeInventoryItem('packaged_plank', 50)
	else
		TriggerClientEvent("esx:showNotification", source, "Shoma fazaye Kafi nadarid!")
	end
end)

RegisterServerEvent('parzival_lumberjack:bastebandikardan')
AddEventHandler('parzival_lumberjack:bastebandikardan', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local item = xPlayer.getInventoryItem('wood')
    if item.limit == -1 or item.count < item.limit then
		xPlayer.addInventoryItem('wood', 50)
		xPlayer.removeInventoryItem('cutted_wood', 50)
	else
		TriggerClientEvent("esx:showNotification", source, "Shoma fazaye Kafi nadarid!")
	end
end)