ESX = nil
local ACnumbM = math.random(1, 100)  --Mani
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('PX_minerjob:getItem')
AddEventHandler('PX_minerjob:getItem', function(Code)
    if Code == ACnumbM then
        local xPlayer = ESX.GetPlayerFromId(source)
        local item = xPlayer.getInventoryItem("stone")
        if math.random(0, 100) <= MineConfig.ChanceToGetItem then
            if item.limit == -1 or item.count < item.limit then
                xPlayer.addInventoryItem('stone', 1)
            else
                TriggerClientEvent('esx:showNotification', source, 'Shoma Fazaye Khali Nadarid!')
            end
        end
    else
        print("Id: "..source.." Try to add item with "..GetCurrentResourceName())
    end
end)

RegisterServerEvent('EZ_Pixel:minerjob:ImLoaded')
AddEventHandler('EZ_Pixel:minerjob:ImLoaded', function()
    TriggerClientEvent('EZ_Pixel:minerjob:sendCode', source, ACnumbM)
end)