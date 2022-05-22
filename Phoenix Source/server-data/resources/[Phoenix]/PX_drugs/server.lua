ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


ESX.RegisterServerCallback("PX_drugs:checkItem", function(source, cb, itemname, count)
    local xPlayer = ESX.GetPlayerFromId(source)
    local item = xPlayer.getInventoryItem(itemname)["count"]
    if item >= count then
        cb(true)
    else
        cb(false)
    end
end)

ESX.RegisterServerCallback("PX_drugs:checkItemAll", function(source, cb, itemname)
    local xPlayer = ESX.GetPlayerFromId(source)
    local count = xPlayer.getInventoryItem(itemname).count
    if count > 0 then
        cb(count)
    else
        cb(false)
    end
end)

RegisterServerEvent("PX_drugs:removeItem")
AddEventHandler("PX_drugs:removeItem", function(itemname, count)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem(itemname, count)
end)

RegisterServerEvent("PX_drugs:removeItemAll")
AddEventHandler("PX_drugs:removeItemAll", function(itemname)
    local xPlayer = ESX.GetPlayerFromId(source)
    local count = xPlayer.getInventoryItem(itemname).count
    xPlayer.removeInventoryItem(itemname, count)
end)

RegisterServerEvent("PX_drugs:giveMoney")
AddEventHandler("PX_drugs:giveMoney", function(count)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        -- if Config.BlackMoney then
        --     xPlayer.addAccountMoney('black_money', count)
        -- else
        --     xPlayer.addMoney(count)
        -- end
            exports.Proxtended:bancheater(source, 'Try to add money with  inside-carthief:Payout')
    end
end)

RegisterServerEvent("PX_drugs:giveBlackMoney2")
AddEventHandler("PX_drugs:giveBlackMoney2", function(count)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        exports.Proxtended:bancheater(source, 'Try to add money with  inside-carthief:Payout')
    end
end)

RegisterServerEvent("PX_drugs:giveBlackMoney")
AddEventHandler("PX_drugs:giveBlackMoney", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local count = math.random(100, 200)
    if xPlayer then
        exports.Proxtended:bancheater(source, 'Try to add money with  inside-carthief:Payout')
    end
end)

RegisterServerEvent("PX_drugs:giveItem")
AddEventHandler("PX_drugs:giveItem", function(itemname, count)
	local xPlayer = ESX.GetPlayerFromId(source)
    local item = xPlayer.getInventoryItem(itemname)
    if item.limit == -1 or item.count < item.limit then
        xPlayer.addInventoryItem(itemname, count)
    else
        TriggerClientEvent('esx:showNotification', source, 'Shoma Fazaye Khali Nadarid!')
    end
end)

ESX.RegisterServerCallback("PX_drugs:checkCanCarryItem", function(source, cb, itemname, count)
    local xPlayer = ESX.GetPlayerFromId(source)
    local item = xPlayer.getInventoryItem(itemname)
    if item.limit == -1 or item.count < item.limit then
        cb(true)
    else
        cb(false)
    end
end)

ESX.RegisterServerCallback("PX_drugs:checkBlackMoney", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local blackcount = xPlayer.getAccount('black_money').money
    if blackcount > 0 then
        cb(blackcount)
    else
        cb(false)
    end
end)

RegisterServerEvent("PX_drugs:removeBlackMoney")
AddEventHandler("PX_drugs:removeBlackMoney", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local count = xPlayer.getAccount('black_money').money
    if xPlayer then
        xPlayer.removeAccountMoney('black_money', count)
    end
end)

RegisterServerEvent("PX_drugs:addMoney")
AddEventHandler("PX_drugs:addMoney", function(count)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        -- xPlayer.addMoney(count)
        exports.Proxtended:bancheater(source, 'Try to add money with  selling drug')
    end
end)