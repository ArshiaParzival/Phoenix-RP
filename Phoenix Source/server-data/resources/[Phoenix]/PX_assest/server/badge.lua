ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('PX_badge:show')
AddEventHandler('PX_badge:show', function()
	local xPlayer = ESX.GetPlayerFromId(source)
    TriggerClientEvent('PX_badge:badgeanim', source)
    TriggerClientEvent('PX_badge:show', -1, xPlayer)
end)

ESX.RegisterUsableItem("id-card", function(source, item)
	local Player = ESX.GetPlayerFromId(source)
	if Player.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent("PX_badge:client:ShowId", -1, source, item.info)
    end
end)

ESX.RegisterUsableItem("badge", function(source, item)
	local Player = ESX.GetPlayerFromId(source)
	if Player.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent("PX_badge:badgeanim", source)
        TriggerClientEvent("PX_badge:client:ShowBadge", -1, source, item.info)
    end
end)