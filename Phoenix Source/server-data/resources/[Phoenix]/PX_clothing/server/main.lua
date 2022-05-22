ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

TriggerEvent('es:addAdminCommand', 'skin', 2, function(source, args, user)
    if args[1] then
        if(tonumber(args[1]) and GetPlayerName(tonumber(args[1])))then
            local player = tonumber(args[1])
            TriggerClientEvent("PX_clothing:client:openMenu", player)
        else
            TriggerClientEvent('chat:addMessage', source, { args = {"^1SYSTEM", "Incorrect player ID"}})
        end
    else
        TriggerClientEvent("PX_clothing:client:openMenu", source)
    end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = {"^1SYSTEM", "Insufficienct permissions!"} })
end, {help = "Open Skin Menu"})

RegisterServerEvent("PX_clothing:saveSkin")
AddEventHandler('PX_clothing:saveSkin', function(skin)
    local Player = ESX.GetPlayerFromId(source)
    if skin ~= nil then
        MySQL.query("UPDATE `users` SET `skin` = '"..skin.."' WHERE `identifier` = '"..Player.identifier.."'")
    end
end)

RegisterServerEvent("PX_clothing:loadPlayerSkin")
AddEventHandler('PX_clothing:loadPlayerSkin', function()
    local src = source
    local Player = ESX.GetPlayerFromId(src)
    MySQL.query("SELECT * FROM `users` WHERE `identifier` = '"..Player.identifier.."'", function(result)
        if result[1] ~= nil then
            if result[1].skin ~= nil then
                if result[1].gender == 0 then
                    TriggerClientEvent("PX_clothing:loadSkin", src, "mp_m_freemode_01", result[1].skin)
                else
                    TriggerClientEvent("PX_clothing:loadSkin", src, "mp_f_freemode_01", result[1].skin)
                end
            else
                TriggerClientEvent("PX_clothing:CreateFirstCharacter", src, result[1].gender)
            end
        else
            DropPlayer(src, "Shoma Be Reload Niaz Darid!")
        end
    end)
end)

RegisterServerEvent("PX_clothing:saveOutfit")
AddEventHandler("PX_clothing:saveOutfit", function(outfitName, skinData)
    local src = source
    local Player = ESX.GetPlayerFromId(src)
    if model ~= nil and skinData ~= nil then
        local outfitId = "outfit-"..math.random(1, 10).."-"..math.random(1111, 9999)
        MySQL.query("INSERT INTO `user_outfits` (`owner`, `outfitname`, `skin`, `outfitId`) VALUES ('"..Player.identifier.."', '"..outfitName.."', '"..json.encode(skinData).."', '"..outfitId.."')", function()
            MySQL.query("SELECT * FROM `user_outfits` WHERE `owner` = '"..Player.identifier.."'", function(result)
                if result[1] ~= nil then
                    TriggerClientEvent('PX_clothing:client:reloadOutfits', src, result)
                else
                    TriggerClientEvent('PX_clothing:client:reloadOutfits', src, nil)
                end
            end)
        end)
    end
end)

RegisterServerEvent("PX_clothing:server:removeOutfit")
AddEventHandler("PX_clothing:server:removeOutfit", function(outfitName, outfitId)
    local src = source
    local Player = ESX.GetPlayerFromId(src)

    MySQL.query("DELETE FROM `user_outfits` WHERE `owner` = '"..Player.identifier.."' AND `outfitname` = '"..outfitName.."' AND `outfitId` = '"..outfitId.."'", function()
        MySQL.query("SELECT * FROM `user_outfits` WHERE `owner` = '"..Player.identifier.."'", function(result)
            if result[1] ~= nil then
                TriggerClientEvent('PX_clothing:client:reloadOutfits', src, result)
            else
                TriggerClientEvent('PX_clothing:client:reloadOutfits', src, nil)
            end
        end)
    end)
end)

ESX.RegisterServerCallback('PX_clothing:server:getOutfits', function(source, cb)
    local src = source
    local Player = ESX.GetPlayerFromId(src)
    local anusVal = {}

    MySQL.query("SELECT * FROM `user_outfits` WHERE `owner` = '"..Player.identifier.."'", function(result)
        if result[1] ~= nil then
            for k, v in pairs(result) do
                result[k].skin = json.decode(result[k].skin)
                anusVal[k] = v
            end
            cb(anusVal)
        end
        cb(anusVal)
    end)
end)

ESX.RegisterUsableItem("mask", function(source, item)
	local Player = ESX.GetPlayerFromId(source)
	if Player.GetItemBySlot(item.slot) ~= nil then
        Player.removeInventoryItem('mask', 1, item.slot)
        TriggerClientEvent("PX_clothing:useMask", source, item.info)
    end
end)

RegisterServerEvent("PX_clothing:addMask")
AddEventHandler("PX_clothing:addMask", function(number, color)
    if number == nil or color == nil then
        return
    end
    local xPlayer = ESX.GetPlayerFromId(source)
    local info = {
        number = number,
        color = color
    }
    xPlayer.addInventoryItem('mask', 1, nil, info)
end)