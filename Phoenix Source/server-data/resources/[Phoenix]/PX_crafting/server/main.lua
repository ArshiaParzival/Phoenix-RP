ESX = nil

TriggerEvent(
    "esx:getSharedObject",
    function(obj)
        ESX = obj
    end
)

function craft(src, item, retrying)
    local xPlayer = ESX.GetPlayerFromId(src)
    local cancraft = true

    local count = Config.Recipes[item].Amount

    if not retrying then
        for k, v in pairs(Config.Recipes[item].Ingredients) do
            if string.find(k, "WEAPON_") == nil then
                if xPlayer.getInventoryItem(k).count < v then
                    cancraft = false
                end
            else
                local gun = xPlayer.hasWeapon(k)
                if gun then
                else
                    cancraft = false
                end
            end
        end
    end

    if Config.Recipes[item].isGun then
        if cancraft then
            for k, v in pairs(Config.Recipes[item].Ingredients) do
                if not Config.PermanentItems[k] then
                    xPlayer.removeInventoryItem(k, v)
                end
            end

            TriggerClientEvent("PX_crafting:craftStart", src, item, count)
        else
            TriggerClientEvent("PX_crafting:sendMessage", src, Config.Text["not_enough_ingredients"])
        end
    else
        if Config.UseLimitSystem then
            local xItem = xPlayer.getInventoryItem(item)
            if cancraft then
                for k, v in pairs(Config.Recipes[item].Ingredients) do
                    xPlayer.removeInventoryItem(k, v)
                end

                TriggerClientEvent("PX_crafting:craftStart", src, item, count)
            else
                TriggerClientEvent("PX_crafting:sendMessage", src, Config.Text["not_enough_ingredients"])
            end
        else
            if xPlayer.canCarryItem(item, count) then
                if cancraft then
                    for k, v in pairs(Config.Recipes[item].Ingredients) do
                        xPlayer.removeInventoryItem(k, v)
                    end

                    TriggerClientEvent("PX_crafting:craftStart", src, item, count)
                else
                    TriggerClientEvent("PX_crafting:sendMessage", src, Config.Text["not_enough_ingredients"])
                end
            else
                TriggerClientEvent("PX_crafting:sendMessage", src, Config.Text["you_cant_hold_item"])
            end
        end
    end
end

RegisterServerEvent("PX_crafting:itemCrafted")
AddEventHandler(
    "PX_crafting:itemCrafted",
    function(item, count)
        local src = source
        local xPlayer = ESX.GetPlayerFromId(src)

        if Config.Recipes[item].SuccessRate > math.random(0, Config.Recipes[item].SuccessRate) then
            if Config.UseLimitSystem then
                xPlayer.addInventoryItem(item, count)
                TriggerClientEvent("PX_crafting:sendMessage", src, Config.Text["item_crafted"])
            else
                if xPlayer.canCarryItem(item, count) then
                    if Config.Recipes[item].isGun then
                        xPlayer.addWeapon(item, 0)
                    else
                        xPlayer.addInventoryItem(item, count)
                    end
                    TriggerClientEvent("PX_crafting:sendMessage", src, Config.Text["item_crafted"])
                else
                    TriggerClientEvent("PX_crafting:sendMessage", src, Config.Text["inv_limit_exceed"])
                end
            end
        else
            TriggerClientEvent("PX_crafting:sendMessage", src, Config.Text["crafting_failed"])
        end
    end
)

RegisterServerEvent("PX_crafting:craft")
AddEventHandler(
    "PX_crafting:craft",
    function(item, retrying)
        local src = source
        craft(src, item, retrying)
    end
)


ESX.RegisterServerCallback("PX_crafting:CheckForGang", function(source, cb, val)
    local xPlayer = ESX.GetPlayerFromId(source)
    local recipes = {}
    if xPlayer and xPlayer.source and xPlayer.gang and xPlayer.job then
        if type(val) == 'table' and val.recipes and type(val.recipes) == 'table' and #val.recipes > 0 then
            for _, g in ipairs(val.recipes) do
                if (Config.Recipes[g] and Config.Recipes[g].GangsNeed) and (Config.Recipes[g].GangsNeed[xPlayer.gang.name] or Config.Recipes[g].GangsNeed[xPlayer.job.name] or (Config.Recipes[g].GangsNeed["gang"] and xPlayer.gang.name ~= "nogang") or (Config.Recipes[g].GangsNeed["public"])) then
                    recipes[g] = Config.Recipes[g]
                elseif Config.Recipes[g] and not Config.Recipes[g].GangsNeed then
                    recipes[g] = Config.Recipes[g]
                end
            end
        else
            for _,i in pairs(Config.Recipes) do
                if i.GangsNeed and (i.GangsNeed[xPlayer.gang.name] or i.GangsNeed[xPlayer.job.name] or (i.GangsNeed["gang"] and xPlayer.gang.name ~= "nogang") or (i.GangsNeed["public"])) then
                    recipes[_] = i
                elseif not i.GangsNeed then
                    recipes[_] = i
                end
            end
            -- recipes = Config.Recipes
        end
    end
    cb(recipes)
end)