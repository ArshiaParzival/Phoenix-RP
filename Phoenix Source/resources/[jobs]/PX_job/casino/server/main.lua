ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

if CasinoConfig.MaxInService ~= -1 then
  TriggerEvent('esx_service:activateService', 'casino', CasinoConfig.MaxInService)
end

TriggerEvent('esx_phone:registerNumber', 'casino', _U('casino_customer'), true, true)
TriggerEvent('esx_society:registerSociety', 'casino', 'casino', 'society_casino', 'society_casino', 'society_casino', {type = 'private'})

RegisterServerEvent('Parzival:casino:washMoney')
AddEventHandler('Parzival:casino:washMoney', function(amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	amount = ESX.Math.Round(tonumber(amount))

	if xPlayer.job.name ~= "casino" then
		return
	end
	local item = xPlayer.getInventoryItem('dirtymoney')
	if amount > 0 and item.count >= amount then
        TriggerEvent('esx_society:getSociety', "casino", function (society)
            TriggerEvent('esx_addonaccount:getSharedAccount', society.account, function(account)
                xPlayer.removeInventoryItem("dirtymoney", tonumber(amount))
                account.addMoney(tonumber(ESX.Math.Round((tonumber(amount) * 80) / 100)))
            end)
        end)
		TriggerClientEvent('esx:showNotification', xPlayer.source, "You Washed Money!")
	else
		TriggerClientEvent('esx:showNotification', xPlayer.source, "Shoma Meghdar Kafi Nadarid!")
	end
end)