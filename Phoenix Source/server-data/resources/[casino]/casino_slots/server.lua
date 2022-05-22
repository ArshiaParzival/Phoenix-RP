ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent("casino_slots:BetsAndMoney")
AddEventHandler("casino_slots:BetsAndMoney", function(bets)
    local _source   = source
    local xPlayer   = ESX.GetPlayerFromId(_source)
	local chips = xPlayer.getInventoryItem('casino_chips').count
    if xPlayer then
        if bets % 50 == 0 and bets >= 50 then
            if chips >= bets then
                xPlayer.removeInventoryItem('casino_chips',bets)
                TriggerClientEvent("casino_slots:UpdateSlots", _source, bets)
            else
                TriggerClientEvent('esx:showNotification', _source, "Not enought chips, get more from cashier!")
            end
        else
            TriggerClientEvent('esx:showNotification', _source, "You have to insert a multiple of 50. ex: 100, 350, 2500")
        end

    end
end)

RegisterServerEvent("casino_slots:PayOutRewards")
AddEventHandler("casino_slots:PayOutRewards", function(amount)
    local _source   = source
    local xPlayer   = ESX.GetPlayerFromId(_source)
    if xPlayer then
        amount = tonumber(amount)
        if amount > 0 then
            xPlayer.addInventoryItem('casino_chips', amount)
            TriggerClientEvent('esx:showNotification', _source, "Slots: "..amount.." chips were added to your inventory!")
        else
            TriggerClientEvent('esx:showNotification', _source, "Slots: Unfortunately you've lost all your chips, better luck next time.")
        end
    end
end)