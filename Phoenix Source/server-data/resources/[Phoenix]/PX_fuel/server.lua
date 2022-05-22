ESX 					= nil
TriggerEvent(Config.ESX.ESXSHAREDOBJECT, function(obj) ESX = obj end)

RegisterServerEvent("renzu_fuel:payfuel")
AddEventHandler("renzu_fuel:payfuel",function(price,vehicle,fuel,fuel2,key)
	local source = source
	local output = {}
	output = {
		['price'] = Config.stock.default_price,
	}
	local xPlayer = ESX.GetPlayerFromId(source)
	if price > 0 then
		local amount = 0
		money = xPlayer.money
		if money >= price then
			xPlayer.removeMoney(price)
			amount = math.floor(price/output.price)
			fuel = math.floor(fuel/output.price)
			TriggerClientEvent('renzu_fuel:syncfuel',-1,vehicle,fuel)
			pNotify("Paid <b>$"..price.." </b> in "..amount.." liters.",'success', 7000)
		else
			TriggerClientEvent('renzu_fuel:insuficiente',source,vehicle,fuel2)
			pNotify('Shoma Pole Kafi Nadarid','error', 7000)
		end
	end
end)


pNotify = function(message, messageType, messageTimeout)
	TriggerClientEvent("esx:showNotification", source, message)
end