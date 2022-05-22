ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local Check  = {}
local Plate  = {}
local WaitingList = {}

ESX.RegisterServerCallback("esx_lscustom:IsRequstedVehicle", function(source, cb, plate)
    for k, v in pairs(WaitingList) do 
        if tostring(v.Plate) == tostring(plate) then
            if v.HasRequested then
                cb(true)
                return
            end
        end
    end
    cb(false)
end)

ESX.RegisterServerCallback("esx_lscustom:RequestedBefore", function(source, cb, plate)
    cb(false)
end)

ESX.RegisterServerCallback("esx_lscustom:checkVehicleOwner", function(source, cb, plate)
    MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE plate = @plate',
    {
        ['@plate'] = tostring(plate)

    }, function(data)
        if data[1] then
            if ESX.GetPlayerFromId(source).identifier == data[1].owner or ESX.GetPlayerFromId(source).gang.name == data[1].owner then 
                cb(true)
            else
                cb(false)
            end
        else
            cb(false)
        end
    end)
end)

ESX.RegisterServerCallback("esx_lscustom:checkStatus", function(source, cb, plate)
    if Check[source] == nil then
        Check[source] = false
    else
        if Check[source] == false then
            Check[source] = true
        elseif Check[source] == true then
            Check[source] = false
        end
    end
    cb(Check[source])
end)

ESX.RegisterServerCallback("esx_lscustom:PriceOfBill", function(source, cb, plate)
    for k, v in pairs(WaitingList) do
        if tostring(v.Plate) == tostring(plate) then
            cb(v.Price)
        end
    end
end)

ESX.RegisterServerCallback("esx_lscustom:PayVehicleOrders", function(source, cb, plate, prop, Bank)
    local xPlayer = ESX.GetPlayerFromId(source)
    if Bank then
        for k, v in pairs(WaitingList) do
            if tostring(v.Plate) == tostring(plate) then
                if xPlayer.bank >= v.Price then
                    xPlayer.removeBank(tonumber(v.Price))
                    cb(true)
                    MySQL.query.await('UPDATE owned_vehicles SET vehicle = @vehicle WHERE plate = @plate', {
                        ['@plate'] = plate,
                        ['@vehicle'] = json.encode(prop)
                    })
                    table.remove(WaitingList, k)
                    Plate[source] = nil
                    Check[source] = nil
                else
                    cb(false)
                end
            end
        end
    else
        for k, v in pairs(WaitingList) do
            if tostring(v.Plate) == tostring(plate) then
                if xPlayer.money >= v.Price then
                    xPlayer.removeMoney(tonumber(v.Price))
                    cb(true)
                    MySQL.query.await('UPDATE owned_vehicles SET vehicle = @vehicle WHERE plate = @plate', {
                        ['@plate'] = plate,
                        ['@vehicle'] = json.encode(prop)
                    })
                    table.remove(WaitingList, k)
                    Plate[source] = nil
                    Check[source] = nil
                else
                    cb(false)
                end
            end
        end
    end
end)

ESX.RegisterServerCallback("esx_lscustom:getDefaultCar", function(source, cb, plate)
    for k, v in pairs(WaitingList) do
        if tostring(v.Plate) == tostring(plate) then
            cb(json.decode(v.Prop))
        end
    end
end)


RegisterServerEvent("esx_lscustom:buyMod")
AddEventHandler("esx_lscustom:buyMod", function(price, plate)
    for k, v in pairs(WaitingList) do
        if tostring(v.Plate) == tostring(plate) then
            v.Price = v.Price + price
            break
        end
    end
end)

RegisterServerEvent("esx_lscustom:VehiclesInWatingList")
AddEventHandler("esx_lscustom:VehiclesInWatingList", function(plate, WaitList, prop)
    for k, v in pairs(WaitingList) do
        if tostring(v.Plate) == tostring(plate) then
            v.HasRequested = WaitList
            return
        end
    end
    table.insert(WaitingList, {Owner = source, Plate = plate, Price = 0, HasRequested = WaitList, Prop = json.encode(prop)})
end)
