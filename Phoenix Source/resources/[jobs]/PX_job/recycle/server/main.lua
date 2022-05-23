ESX = nil
local ACnumbR = math.random(1, 100)  --Mani
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local ItemTable = {
    "copper",
    "iron",
}

RegisterServerEvent("PX_recycle:server:getItem")
AddEventHandler("PX_recycle:server:getItem", function(Code)
    local src = source
    if Code == ACnumbR then
        local xPlayer = ESX.GetPlayerFromId(src)
        for i = 1, math.random(1, 3), 1 do
            local randItem = ItemTable[math.random(1, #ItemTable)]
            local amount = math.random(1, 3)
            local item = xPlayer.getInventoryItem(randItem)
            if item.limit == -1 or item.count < item.limit then
                xPlayer.addInventoryItem(randItem, amount)
            end
        end
    else
        print("Id: "..src.." Try to add item with "..GetCurrentResourceName())
    end
end)

RegisterServerEvent('EZ_Pixel:recycle:ImLoaded')
AddEventHandler('EZ_Pixel:recycle:ImLoaded', function()
    TriggerClientEvent('EZ_Pixel:recycle:sendCode', source, ACnumbR)
end)