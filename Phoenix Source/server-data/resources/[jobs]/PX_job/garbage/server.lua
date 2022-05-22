ESX = nil
local ACnumbG = math.random(1, 100)  --Mani
TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)


RegisterNetEvent('PX_garbage:reward')
AddEventHandler('PX_garbage:reward', function(Code)
    local _source = source
    if Code == ACnumbG then
        local xPlayer = ESX.GetPlayerFromId(_source)
        if xPlayer ~= nil then
            local item = xPlayer.getInventoryItem("plastic")
            if item.limit == -1 or item.count < item.limit then
                xPlayer.addInventoryItem("plastic", math.random(1, 5))
            else
                TriggerClientEvent('esx:showNotification', source, 'found but you can not carry')
            end
        end
    else
        print("Id: ".._source.." Try to add item with "..GetCurrentResourceName())
    end
end)

RegisterServerEvent('EZ_Pixel:garabge:ImLoaded')
AddEventHandler('EZ_Pixel:garabge:ImLoaded', function()
    TriggerClientEvent('EZ_Pixel:garabge:sendCode', source, ACnumbG)
end)