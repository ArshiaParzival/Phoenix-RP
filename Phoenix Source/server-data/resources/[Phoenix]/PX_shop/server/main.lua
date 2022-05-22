--[[ Gets the ESX library ]]--
ESX = nil 
TriggerEvent("esx:getSharedObject", function(obj)
    ESX = obj
end)

local shops = {}

-- buy in shop
local items = {
    ["cocacola"] = {price = 15, label = "Coca Cola"},
    ["fanta"] = {price = 12, label = "Fanta"},
    ["sprite"] = {price = 12, label = "Sprite"},
    ["water"] = {price = 10, label = "Ab"},
    ["chips"] = {price = 15, label = "Chips"},
    ["marabou"] = {price = 8, label = "Shokolat"},
    ["macka"] = {price = 50, label = "Sandwich"},
    ["cigarett"] = {price = 12, label = "Cigar"},
    ["lighter"] = {price = 5, label = "Fandak"},
    ["phone"] = {price = 1100, label = "Phone"},
    ["radio"] = {price = 2500, label = "Radio"},
}

-- buy for owner
local sellerItems = {
    ["cocacola"] = {price = 10, label = "Coca Cola"},
    ["fanta"] = {price = 8, label = "Fanta"},
    ["sprite"] = {price = 8, label = "Sprite"},
    ["water"] = {price = 5, label = "Ab"},
    ["chips"] = {price = 10, label = "Chips"},
    ["marabou"] = {price = 5, label = "Shokolat"},
    ["macka"] = {price = 30, label = "Sandwich"},
    ["cigarett"] = {price = 10, label = "Cigar"},
    ["lighter"] = {price = 3, label = "Fandak"},
    ["phone"] = {price = 900, label = "Phone"},
    ["radio"] = {price = 2000, label = "Radio"},
}

MySQL.ready(function()
    local allShops = MySQL.query.await('SELECT * FROM owned_shops')
    
	for i=1, #allShops, 1 do
		shops[allShops[i].number] = {owner = json.decode(allShops[i].owner), money = allShops[i].money, shop = json.decode(allShops[i].value), name = allShops[i].name, inventory = json.decode(allShops[i].inventory)}
    end
    
end)

RegisterNetEvent('PX_shop:buyItem')
AddEventHandler('PX_shop:buyItem', function(item, count, shopNumber)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local price = 0
    local inventoryitem = xPlayer.getInventoryItem(item)
    if inventoryitem.limit == -1 or inventoryitem.count < inventoryitem.limit then
        if shops[shopNumber].owner.identifier ~= "government" then
            if not shops[shopNumber].inventory[item] then
                shops[shopNumber].inventory[item] = 0
                MySQL.update('UPDATE owned_shops SET inventory = @inventory WHERE number = @shopnumber', {
                    ['@inventory'] = json.encode(shops[shopNumber].inventory),
                    ['@shopnumber'] = shopNumber
                })
            end

            if shops[shopNumber].inventory[item] >= count then
                shops[shopNumber].inventory[item] = shops[shopNumber].inventory[item] - count
                price = price + (items[item].price * count)
                xPlayer.addInventoryItem(item, count)
            else
                Notification('Maghaze mored nazar meghdar kafi az mahsol Mored Nazar Ra Nadard!')
            end
        else
            price = price + (items[item].price * count)
            xPlayer.addInventoryItem(item, count)
        end
        if price ~= 0  then
            xPlayer.removeMoney(price)
            Notification('Shoma <span style="color: green">$' .. price .. '</span> Kharid Kardid')
            if shops[shopNumber].owner.identifier ~= "government" then
                shops[shopNumber].money = shops[shopNumber].money + price
                MySQL.update('UPDATE owned_shops SET `money` = money + @price, inventory = @inventory WHERE number = @shopnumber', {
                    ['@price'] = price,
                    ['@inventory'] = json.encode(shops[shopNumber].inventory),
                    ['@shopnumber'] = shopNumber
                })
            end
        end
    else
        Notification('Shoma Fazaye Khali Nadarid!')
    end
end)

ESX.RegisterServerCallback('PX_shop:getShops', function(source, cb)
    MySQL.query('SELECT * FROM owned_shops', 
    {}, function(data)
        cb(data)
    end)
end)

-- [Deposit shop money event]
ESX.RegisterServerCallback('PX_shop:depositmoney', function(source, cb, shopNumber)
    local xPlayer = ESX.GetPlayerFromId(source)

    local identifier = xPlayer.identifier
--   local identifier = GetPlayerIdentifier(source)
  if shops[shopNumber].owner.identifier == identifier then
    if shops[shopNumber].money >= 5000 then
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.addMoney(shops[shopNumber].money)
        cb(shops[shopNumber].money)
        shops[shopNumber].money = 0

        MySQL.update('UPDATE owned_shops SET `money` = 0 WHERE number = @shopnumber', {
            ['@shopnumber'] = shopNumber
        })
        
    else
        TriggerClientEvent("esx:showNotification", source, "Hade aghal mablagh bardashtan pol ~g~$5000 ~w~ast!")
        cb(false)
    end 
  else
    cb(false)
  end
end)

-- [Show inventory event]
ESX.RegisterServerCallback('PX_shop:getinventory', function(source, cb, shopNumber)
    -- local identifier = GetPlayerIdentifier(source)
    local xPlayer = ESX.GetPlayerFromId(source)

    local identifier = xPlayer.identifier
    if shops[shopNumber].owner.identifier == identifier then
        local itemObj = {}
        for k,v in pairs(shops[shopNumber].inventory) do
            itemObj[k] = {label = k, count = v}
        end
        cb(itemObj)
    else
      cb(false)
    end
end)

-- [Get buy prices]
ESX.RegisterServerCallback('PX_shop:getbuyprices', function(source, cb)
    -- local identifier = GetPlayerIdentifier(source)
    local xPlayer = ESX.GetPlayerFromId(source)

    local identifier = xPlayer.identifier
    if isOwnerOfAnyShop(identifier) then
        cb(sellerItems)
    else
      cb(false)
    end
end)

-- [Get Sell prices]
ESX.RegisterServerCallback('PX_shop:getShopItemPrices', function(source, cb)
    cb(items)
end)

-- [Change name event]
ESX.RegisterServerCallback('PX_shop:changename', function(source, cb, shopNumber, shopName)
    -- local identifier = GetPlayerIdentifier(source)
    local xPlayer = ESX.GetPlayerFromId(source)

    local identifier = xPlayer.identifier
    if shops[shopNumber].owner.identifier == identifier then
        shops[shopNumber].name = shopName
        TriggerClientEvent('PX_shop:clChangeName', -1, shopNumber, shopName)

        cb(shopName)

        MySQL.update('UPDATE owned_shops SET `name` = @name WHERE number = @shopnumber', {
            ['@shopnumber'] = shopNumber,
            ['@name'] = shopName
        })
    else
      cb(false)
    end
end)  

-- [Put item in stock]
ESX.RegisterServerCallback('PX_shop:buyStock', function(source, cb, stock)
    -- local identifier = GetPlayerIdentifier(source)
    local xPlayer = ESX.GetPlayerFromId(source)

    local identifier = xPlayer.identifier
    if isOwnerOfAnyShop(identifier) then
    
       local xPlayer = ESX.GetPlayerFromId(source)
       local price = sellerItems[stock.item].price * stock.count

       if xPlayer.money >= price then
            xPlayer.removeMoney(price)
            xPlayer.addInventoryItem(stock.item, stock.count)
            cb({item = stock.item, count = stock.count, price = price})
       else
        TriggerClientEvent("esx:showNotification", source, "~h~You dont have enough money for~g~ " .. sellerItems[stock.item].label .. " ~w~!")
        cb(false)
       end
        
    else
      cb(false)
    end
end)

-- [Gut stock in items]
ESX.RegisterServerCallback('PX_shop:putStock', function(source, cb, shopNumber, stock)
    -- local identifier = GetPlayerIdentifier(source)
    local xPlayer = ESX.GetPlayerFromId(source)

    local identifier = xPlayer.identifier
    if shops[shopNumber].owner.identifier == identifier then
    
       local xPlayer = ESX.GetPlayerFromId(source)
       local xItem = xPlayer.getInventoryItem(stock.item)
       if xItem.count >= stock.count then

        xPlayer.removeInventoryItem(stock.item, stock.count)
        shops[shopNumber].inventory[stock.item] = shops[shopNumber].inventory[stock.item] + stock.count
        cb({item = stock.item, count = stock.count})

        MySQL.update('UPDATE owned_shops SET `inventory` = @inventory WHERE number = @shopnumber', {
            ['@shopnumber'] = shopNumber,
            ['@inventory'] = json.encode(shops[shopNumber].inventory)
        })

       else
        TriggerClientEvent("esx:showNotification", source, "~h~You dont have enough of ~g~" .. stock.item .. " ~w~!")
        cb(false)
       end

    else
      cb(false)
    end
end)

-- [buy shop]
ESX.RegisterServerCallback('PX_shop:buyShop', function(source, cb, shopNumber)
    -- local identifier = GetPlayerIdentifier(source)
    local xPlayer = ESX.GetPlayerFromId(source)

    local identifier = xPlayer.identifier
    if shops[shopNumber].shop.forsale then
        if shops[shopNumber].owner.identifier == identifier then
            TriggerClientEvent("esx:showNotification", source, "~h~You cant buy your shop !")
            cb(false)
            return
        end
    
       local xPlayer = ESX.GetPlayerFromId(source)

       if xPlayer.bank >= tonumber(shops[shopNumber].shop.value) then

        shops[shopNumber].shop.forsale = false
        xPlayer.removeBank(tonumber(shops[shopNumber].shop.value))
        if shops[shopNumber].owner.identifier ~= "government" then
            local zplayer = ESX.GetPlayerFromIdentifier(shops[shopNumber].owner.identifier)
            if zplayer then
                zplayer.addBank(tonumber(shops[shopNumber].shop.value))
                TriggerClientEvent('esx:showNotification', zplayer.source, "~o~" .. xPlayer.name .. "~w~ Buy your shop and ~g~$" .. shops[shopNumber].shop.value .. "~w~ sended to you bank!" , 'info')
            else
                MySQL.update('UPDATE users SET `bank` = bank + @money WHERE identifier = @shopnumber', {
                    ['@shopnumber'] = shops[shopNumber].owner.identifier,
                    ['@money'] = tonumber(shops[shopNumber].shop.value)
                })
            end
        end
        shops[shopNumber].owner.name = xPlayer.name
        shops[shopNumber].owner.identifier = xPlayer.identifier
        TriggerClientEvent('PX_shop:clChangedata', -1, shopNumber, {name =  shops[shopNumber].owner.name, identifier = shops[shopNumber].owner.identifier, forsale = shops[shopNumber].shop.forsale, id = source})

        cb(shopNumber)

        MySQL.update('UPDATE owned_shops SET `owner` = @owner, `value` = @value WHERE number = @shopnumber', {
            ['@shopnumber'] = shopNumber,
            ['@owner'] = json.encode(shops[shopNumber].owner),
            ['@value'] = json.encode(shops[shopNumber].shop)
        })

       else
        TriggerClientEvent("esx:showNotification", source, "~h~You dont have enough money. ~g~$" .. tostring(shops[shopNumber].shop.value - xPlayer.bank) .. "~r~ less !")
        cb(false)
       end
        
    else
      cb(false)
    end
end)

-- [[ Get Status ]]
ESX.RegisterServerCallback('PX_shop:getstatus', function(source, cb, shopNumber)
    local xPlayer = ESX.GetPlayerFromId(source)

    local identifier = xPlayer.identifier
    if shops[shopNumber].owner.identifier == identifier then
       cb({forsale = shops[shopNumber].shop.forsale, value = shops[shopNumber].shop.value, money = shops[shopNumber].money})
    else
      cb(false)
    end
end)

-- [[ Set Sale Status]]
ESX.RegisterServerCallback('PX_shop:setstatus', function(source, cb, shopNumber, value, type)
    local xPlayer = ESX.GetPlayerFromId(source)

    local identifier = xPlayer.identifier
    -- local identifier = GetPlayerIdentifier(source)
    if shops[shopNumber].owner.identifier == identifier then
    
       if type == "price" then
          shops[shopNumber].shop.value = value
          TriggerClientEvent('PX_shop:clChangedataCustom', -1, shopNumber, {type = "price", value = shops[shopNumber].shop.value})
          cb(shops[shopNumber].shop.value)
          MySQL.update('UPDATE owned_shops SET `value` = @value WHERE number = @shopnumber', {
            ['@shopnumber'] = shopNumber,
            ['@value'] = json.encode(shops[shopNumber].shop)
          })
       elseif type == "status" then
          if shops[shopNumber].shop.forsale then
            shops[shopNumber].shop.forsale = false
          else
            shops[shopNumber].shop.forsale = true
          end
          TriggerClientEvent('PX_shop:clChangedataCustom', -1, shopNumber, {type = "status", forsale = shops[shopNumber].shop.forsale})
          MySQL.update('UPDATE owned_shops SET `value` = @value WHERE number = @shopnumber', {
            ['@shopnumber'] = shopNumber,
            ['@value'] = json.encode(shops[shopNumber].shop)
          })
          cb(true)
       end

       cb(false)
        
    else
      cb(false)
    end
end)


Notification = function(message)
	TriggerClientEvent("esx:showNotification", source, message)
end

AddEventHandler('esx:playerLoaded', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)

    local identifier = xPlayer.identifier
    local ownedShops = {}

    for k,v in pairs(shops) do
        if v.owner.identifier == identifier then
            table.insert(ownedShops, k)
        end
    end
    
    if ownedShops ~= {} then
        TriggerClientEvent('PX_shop:passTheShops', source, ownedShops)
    end

end)

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() == resourceName) then
        Wait(2000)
        local xPlayers = ESX.GetPlayers()

        for i=1, #xPlayers, 1 do
            local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

            local ownedShops = {}

            for k,v in pairs(shops) do
                if v.owner.identifier == xPlayer.identifier then
                    table.insert(ownedShops, k)
                end
            end

            if ownedShops ~= {} then
                TriggerClientEvent('PX_shop:passTheShops', xPlayer.source, ownedShops)
            end

        end

    end
end)

function isOwnerOfAnyShop(identifier)
    for k,v in pairs(shops) do
        if v.owner.identifier == identifier then
            return true
        end
    end

    return false
end

function RobShop(shopNumber)
    if shops[shopNumber] then
        local robbedMoney = (shops[shopNumber].money * 30) / 100
        if robbedMoney > 1000 then
            shops[shopNumber].money = shops[shopNumber].money - robbedMoney
            MySQL.update('UPDATE owned_shops SET money = money - @remove WHERE number = @shopnumber', {
                ['@remove'] = robbedMoney,
                ['@shopnumber'] = shopNumber
            })
            return robbedMoney
        else
            return 1000
        end
    else
        return 1000
    end
end

function GetShopName(shopNumber)
    if shops[shopNumber] then
        return shops[shopNumber].name
    else
        return "N/A"
    end
end

-------------------- Robbery -----------------------

local Stores = {
    [1] = {
        isAiming = false,
		lastRobbed = 0
	},
    [2] = {
        isAiming = false,
		lastRobbed = 0
	},
    [3] = {
        isAiming = false,
		lastRobbed = 0
	},
    [4] = {
        isAiming = false,
		lastRobbed = 0
	},
    [5] = {
        isAiming = false,
		lastRobbed = 0
	},
    [6] = {
        isAiming = false,
		lastRobbed = 0
	},
    [7] = {
        isAiming = false,
		lastRobbed = 0
	},
    [8] = {
        isAiming = false,
		lastRobbed = 0
	},
    [9] = {
        isAiming = false,
		lastRobbed = 0
	},
    [10] = {
        isAiming = false,
		lastRobbed = 0
	},
    [11] = {
        isAiming = false,
		lastRobbed = 0
	},
    [12] = {
        isAiming = false,
		lastRobbed = 0
	},
    [13] = {
        isAiming = false,
		lastRobbed = 0
	},
    [14] = {
        isAiming = false,
		lastRobbed = 0
	},
    [15] = {
        isAiming = false,
		lastRobbed = 0
	},
    [16] = {
        isAiming = false,
		lastRobbed = 0
	},
    [17] = {
        isAiming = false,
		lastRobbed = 0
	},
    [18] = {
        isAiming = false,
		lastRobbed = 0
	},
    [19] = {
        isAiming = false,
		lastRobbed = 0
	},
    [20] = {
        isAiming = false,
		lastRobbed = 0
	}
}

local police = 0

Citizen.CreateThread(function()
    while true do
        local players = GetPlayers()
        police = 0
        for _,v in pairs(players) do
            xPlayer = ESX.GetPlayerFromId(v)
            if xPlayer then
                if xPlayer.job.name == "police" then
                    police = police + 1
                end
            end
        end
        Citizen.Wait(90000)
    end
end)

ESX.RegisterServerCallback('Parzival_ShopRobbery:canPickUpMoney', function(source, cb, shopId)
    local store = Stores[shopId]
    if store.isAiming then
        cb(true)
    else
        cb(false)
    end
end)

ESX.RegisterServerCallback('Parzival_ShopRobbery:canRob', function(source, cb, shopId)
    local store = Stores[shopId]
    if police >= Config.police then
        if (os.time() - store.lastRobbed) < 1000 and store.lastRobbed ~= 0 then
            cb(false)
        else
            cb(true)
        end
    else
        cb("no_cops")
    end
end)

RegisterServerEvent("Parzival_ShopRobbery:sendNpcToAnim")
AddEventHandler("Parzival_ShopRobbery:sendNpcToAnim", function(shopNum)
    TriggerClientEvent("Parzival_ShopRobbery:fetchNpcAnim", -1, shopNum)
end)

RegisterServerEvent("Parzival_ShopRobbery:CallLSPD")
AddEventHandler("Parzival_ShopRobbery:CallLSPD", function(pos)
    local players = GetPlayers()
    for _,v in pairs(players) do
        local xPlayer = ESX.GetPlayerFromId(v)
        if xPlayer then
            if xPlayer.job.name == "police" then
                TriggerClientEvent("Parzival_shop:setBlip", xPlayer.source, pos)
            end
        end
    end
end)

RegisterServerEvent("Parzival_ShopRobbery:pickUp")
AddEventHandler("Parzival_ShopRobbery:pickUp", function(shopNum)
    _Source = source
    Wait(math.random(200, 1000))
    local store = Stores[shopNum]
    if store.lastRobbed == 0 then
        store.lastRobbed = os.time()
        local xPlayer = ESX.GetPlayerFromId(_Source)
        xPlayer.addInventoryItem("dirtymoney", RobShop(shopNum))
        TriggerClientEvent("Parzival_ShopRobbery:resetShopNPCAnim", -1, shopNum)
        SetTimeout(20 * 60 * 1000, function()
            store.isAiming = false
            store.lastRobbed = 0
        end)
    end
end)

RegisterServerEvent("Parzival_ShopRobbery:syncAiming")
AddEventHandler("Parzival_ShopRobbery:syncAiming", function(shopNum)
    local store = Stores[shopNum]
    store.isAiming = true
    SetTimeout(10000, function()
        store.isAiming = false
    end)
end)