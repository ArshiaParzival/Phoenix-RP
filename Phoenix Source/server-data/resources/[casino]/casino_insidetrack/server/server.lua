ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent("insidetrack:server:winnings")
AddEventHandler("insidetrack:server:winnings", function(amount)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if xPlayer ~= nil then
        xPlayer.addInventoryItem("casino_chips", amount)
        --print("Added item")
    end
end)

RegisterServerEvent("insidetrack:server:placebet")
AddEventHandler("insidetrack:server:placebet", function(bet)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if Player ~= nil then
        xPlayer.removeInventoryItem("casino_chips", bet)
        --print("removed items")
    end
end)

ESX.RegisterServerCallback("insidetrack:server:getbalance", function(source, cb)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if xPlayer ~= nil then
        chips = xPlayer.getInventoryItem('casino_chips').count
		--print(chips)
        if chips ~= nil then
            cb(chips)
        else
            cb(0)
        end
    else
        cb(0)
    end
end)