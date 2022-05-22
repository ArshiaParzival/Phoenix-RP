ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterUsableItem('cigarett', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	local lighter = xPlayer.getInventoryItem('lighter')
	if lighter.count > 0 then
		xPlayer.removeInventoryItem('cigarett', 1)
		TriggerClientEvent('esx_basicneeds:OnSmokeCigarett', source)
	else
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma baraye etefade az cigar niaz be fandak darid!")
	end
end)

ESX.RegisterUsableItem('chips', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('chips', 1)
	TriggerClientEvent('esx_status:add', source, 'hunger', 380000)
	TriggerClientEvent('esx_basicneeds:onEat', source, "prop_ld_snack_01")
end)

ESX.RegisterUsableItem('marabou', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('marabou', 1)
	TriggerClientEvent('esx_status:add', source, 'hunger', 200000)
	TriggerClientEvent('esx_basicneeds:onEat', source, "prop_choc_ego")
end)

ESX.RegisterUsableItem('cocacola', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('cocacola', 1)
	TriggerClientEvent('esx_status:add', source, 'thirst', 600000)
	TriggerClientEvent('esx_basicneeds:onDrink', source, "prop_ecola_can")	
end)

ESX.RegisterUsableItem('fanta', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('fanta', 1)
	TriggerClientEvent('esx_status:add', source, 'thirst', 600000)
	TriggerClientEvent('esx_basicneeds:onDrink', source, "prop_ecola_can")	
end)

ESX.RegisterUsableItem('sprite', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('sprite', 1)
	TriggerClientEvent('esx_status:add', source, 'thirst', 500000)
	TriggerClientEvent('esx_basicneeds:onDrink', source, "ng_proc_sodacan_01b")
end)

ESX.RegisterUsableItem('pizza', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('pizza', 1)
	TriggerClientEvent('esx_status:add', source, 'hunger', 800000)
	TriggerClientEvent('esx_basicneeds:onEat', source)
end)

ESX.RegisterUsableItem('burger', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('burger', 1)
	TriggerClientEvent('esx_status:add', source, 'hunger', 700000)
	TriggerClientEvent('esx_basicneeds:onEat', source)
end)

ESX.RegisterUsableItem('macka', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('macka', 1)
	TriggerClientEvent('esx_status:add', source, 'hunger', 500000)
	TriggerClientEvent('esx_basicneeds:onEat', source, "prop_ld_snack_01")
end)

RegisterServerEvent('esx_customItems:remove')
AddEventHandler('esx_customItems:remove', function(itemName)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem(itemName, 1)
end)

ESX.RegisterUsableItem('beer', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('beer', 1)
	TriggerClientEvent('PX_drugs:useItem', source, 'beer')
end)

ESX.RegisterUsableItem('vodka', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('vodka', 1)
	TriggerClientEvent('PX_drugs:useItem', source, 'vodka')
end)

ESX.RegisterUsableItem('whiskey', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('whiskey', 1)
	TriggerClientEvent('PX_drugs:useItem', source, 'whiskey')
end)

ESX.RegisterUsableItem('packagedmeth', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('packagedmeth', 1)
	TriggerClientEvent('PX_drugs:useItem', source, 'packagedmeth')
end)

ESX.RegisterUsableItem('packagedcoca', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('packagedcoca', 1)
	TriggerClientEvent('PX_drugs:useItem', source, 'packagedcoca')
end)

ESX.RegisterUsableItem('packagedweed', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('packagedweed', 1)
	TriggerClientEvent('PX_drugs:useItem', source, 'packagedweed')
end)


--Weapon

ESX.RegisterUsableItem("pistol-ammo", function(source, item)
	local Player = ESX.GetPlayerFromId(source)
	if Player.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('PX_weapons:client:reload:ammo', source, 'AMMO_PISTOL', 'pistol-ammo')
    end
end)

ESX.RegisterUsableItem("rifle-ammo", function(source, item)
	local Player = ESX.GetPlayerFromId(source)
	if Player.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('PX_weapons:client:reload:ammo', source, 'AMMO_RIFLE', 'rifle-ammo')
    end
end)

ESX.RegisterUsableItem("smg-ammo", function(source, item)
	local Player = ESX.GetPlayerFromId(source)
	if Player.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('PX_weapons:client:reload:ammo', source, 'AMMO_SMG', 'smg-ammo')
    end
end)

ESX.RegisterUsableItem("shotgun-ammo", function(source, item)
	local Player = ESX.GetPlayerFromId(source)
	if Player.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('PX_weapons:client:reload:ammo', source, 'AMMO_SHOTGUN', 'shotgun-ammo')
    end
end)

ESX.RegisterUsableItem("pistol_suppressor", function(source, item)
    local Player = ESX.GetPlayerFromId(source)
    TriggerClientEvent("PX_weapons:client:EquipAttachment", source, item, "suppressor")
end)

ESX.RegisterUsableItem("pistol_extendedclip", function(source, item)
    local Player = ESX.GetPlayerFromId(source)
    TriggerClientEvent("PX_weapons:client:EquipAttachment", source, item, "extendedclip")
end)

ESX.RegisterUsableItem("rifle_suppressor", function(source, item)
    local Player = ESX.GetPlayerFromId(source)
    TriggerClientEvent("PX_weapons:client:EquipAttachment", source, item, "suppressor")
end)

ESX.RegisterUsableItem("rifle_extendedclip", function(source, item)
    local Player = ESX.GetPlayerFromId(source)
    TriggerClientEvent("PX_weapons:client:EquipAttachment", source, item, "extendedclip")
end)

ESX.RegisterUsableItem("rifle_flashlight", function(source, item)
    local Player = ESX.GetPlayerFromId(source)
    TriggerClientEvent("PX_weapons:client:EquipAttachment", source, item, "flashlight")
end)

ESX.RegisterUsableItem("rifle_grip", function(source, item)
    local Player = ESX.GetPlayerFromId(source)
    TriggerClientEvent("PX_weapons:client:EquipAttachment", source, item, "grip")
end)

ESX.RegisterUsableItem("rifle_scope", function(source, item)
    local Player = ESX.GetPlayerFromId(source)
    TriggerClientEvent("PX_weapons:client:EquipAttachment", source, item, "scope")
end)

RegisterServerEvent('PX_weapons:server:UpdateWeaponQuality')
AddEventHandler('PX_weapons:server:UpdateWeaponQuality', function(data, RepeatAmount)
    local src = source
    local Player = ESX.GetPlayerFromId(src)
    local WeaponData = Config.WeaponsList[GetHashKey(data.name)]
    local WeaponSlot = Player.inventory[data.slot]
    local DecreaseAmount = Config.DurabilityMultiplier[data.name]
    if WeaponSlot ~= nil then
        if not IsWeaponBlocked(WeaponData['IdName']) then
            if WeaponSlot.info.quality ~= nil then
                for i = 1, RepeatAmount, 1 do
                    if WeaponSlot.info.quality - DecreaseAmount > 0 then
                        WeaponSlot.info.quality = WeaponSlot.info.quality - DecreaseAmount
                    else
                        WeaponSlot.info.quality = 0
                        TriggerClientEvent('PX_inventory:client:UseWeapon', src, data)
                        TriggerClientEvent('esx:showNotification', src, "Your weapon is broken.", 'error')
                        break
                    end
                end
            else
                WeaponSlot.info.quality = 100
                for i = 1, RepeatAmount, 1 do
                    if WeaponSlot.info.quality - DecreaseAmount > 0 then
                        WeaponSlot.info.quality = WeaponSlot.info.quality - DecreaseAmount
                    else
                        WeaponSlot.info.quality = 0
                        TriggerClientEvent('PX_inventory:client:UseWeapon', src, data)
                        TriggerClientEvent('esx:showNotification', src, "Your weapon is broken!", 'error')
                        break
                    end
                end
            end
        end
    end
    Player.setInventoryItem(Player.inventory)
end)

RegisterServerEvent("PX_weapons:server:EquipAttachment")
AddEventHandler("PX_weapons:server:EquipAttachment", function(ItemData, CurrentWeaponData, AttachmentData)
    local src = source
    local Player = ESX.GetPlayerFromId(src)
    local Inventory = Player.inventory
    local GiveBackItem = nil
    if Inventory[CurrentWeaponData.slot] ~= nil then
        if Inventory[CurrentWeaponData.slot].info.attachments ~= nil and next(Inventory[CurrentWeaponData.slot].info.attachments) ~= nil then
            local HasAttach, key = HasAttachment(AttachmentData.component, Inventory[CurrentWeaponData.slot].info.attachments)
            if not HasAttach then
                if CurrentWeaponData.name == "weapon_compactrifle" then
                    local component = "COMPONENT_COMPACTRIFLE_CLIP_03"
                    if AttachmentData.component == "COMPONENT_COMPACTRIFLE_CLIP_03" then
                        component = "COMPONENT_COMPACTRIFLE_CLIP_02"
                    end
                    for k, v in pairs(Inventory[CurrentWeaponData.slot].info.attachments) do
                        if v.component == component then
                            local has, key = HasAttachment(component, Inventory[CurrentWeaponData.slot].info.attachments)
                            local item = GetAttachmentItem(CurrentWeaponData.name:upper(), component)
                            GiveBackItem = tostring(item):lower()
                            table.remove(Inventory[CurrentWeaponData.slot].info.attachments, key)
                        end
                    end
                end
                table.insert(Inventory[CurrentWeaponData.slot].info.attachments, {
                    component = AttachmentData.component,
                    label = AttachmentData.label,
                })
                TriggerClientEvent("PX_weapons:client:addAttachment", src, AttachmentData.component)
                Player.setInventoryItem(Player.inventory)
                Player.removeInventoryItem(ItemData.name, 1)
            else
                TriggerClientEvent("esx:showNotification", src, "You already have one "..AttachmentData.label:lower().."  on your gun..", "error")
            end
        else
            Inventory[CurrentWeaponData.slot].info.attachments = {}
            table.insert(Inventory[CurrentWeaponData.slot].info.attachments, {
                component = AttachmentData.component,
                label = AttachmentData.label,
            })
            TriggerClientEvent("PX_weapons:client:addAttachment", src, AttachmentData.component)
            Player.setInventoryItem(Player.inventory)
            Player.removeInventoryItem(ItemData.name, 1)
        end
    end
    if GiveBackItem ~= nil then
        Player.addInventoryItem(GiveBackItem, 1, false)
        GiveBackItem = nil
    end
end)

RegisterServerEvent("PX_weapons:server:SetWeaponQuality")
AddEventHandler("PX_weapons:server:SetWeaponQuality", function(data, hp)
    local src = source
    local Player = ESX.GetPlayerFromId(src)
    local WeaponData = ESX.Weapons[GetHashKey(data.name)]
    local WeaponSlot = Player.inventory[data.slot]
    local DecreaseAmount = Config.DurabilityMultiplier[data.name]
    WeaponSlot.info.quality = hp
    Player.setInventoryItem(Player.inventory)
end)

RegisterServerEvent("PX_weapons:server:UpdateWeaponAmmo")
AddEventHandler('PX_weapons:server:UpdateWeaponAmmo', function(CurrentWeaponData, amount)
    local src = source
    local Player = ESX.GetPlayerFromId(src)
    local amount = tonumber(amount)
    if CurrentWeaponData ~= nil then
        if Player.inventory[CurrentWeaponData.slot] ~= nil then
            Player.inventory[CurrentWeaponData.slot].info.ammo = amount
        end
        Player.setInventoryItem(Player.inventory)
    end
end)

ESX.RegisterServerCallback("PX_weapon:server:GetWeaponAmmo", function(source, cb, WeaponData)
    local Player = ESX.GetPlayerFromId(source)
    local retval = 0
    if WeaponData ~= nil then
        if Player ~= nil then
            local ItemData = Player.GetItemBySlot(WeaponData.slot)
            if ItemData ~= nil then
                retval = ItemData.info.ammo ~= nil and ItemData.info.ammo or 0
            end
        end
    end
    cb(retval)
end)

ESX.RegisterServerCallback('PX_weapons:server:RemoveAttachment', function(source, cb, AttachmentData, ItemData)
    local src = source
    local Player = ESX.GetPlayerFromId(src)
    local Inventory = Player.inventory
    local AttachmentComponent = Config.WeaponAttachments[ItemData.name:upper()][AttachmentData.attachment]
    if Inventory[ItemData.slot] ~= nil then
        if Inventory[ItemData.slot].info.attachments ~= nil and next(Inventory[ItemData.slot].info.attachments) ~= nil then
            local HasAttach, key = HasAttachment(AttachmentComponent.component, Inventory[ItemData.slot].info.attachments)
            if HasAttach then
                table.remove(Inventory[ItemData.slot].info.attachments, key)
                Player.setInventoryItem(Player.inventory)
                Player.addInventoryItem(AttachmentComponent.item, 1)
                cb(Inventory[ItemData.slot].info.attachments)
            else
                cb(false)
            end
        else
            cb(false)
        end
    else
        cb(false)
    end
end)

function IsWeaponBlocked(WeaponName)
  local retval = false
  for _, name in pairs(Config.DurabilityBlockedWeapons) do
      if name == WeaponName then
          retval = true
          break
      end
  end
  return retval
end

function HasAttachment(component, attachments)
    local retval = false
    local key = nil
    for k, v in pairs(attachments) do
        if v.component == component then
            key = k
            retval = true
        end
    end
    return retval, key
end

function GetWeaponList(Weapon)
    return Config.WeaponsList[Weapon]
end

--stress

ESX.RegisterUsableItem('lsd', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem("lsd",1)
    TriggerClientEvent("weaponry:client:use:lsd", source)
end)

ESX.RegisterUsableItem('adrenalin', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem("adrenalin",1)
    TriggerClientEvent("weaponry:client:use:adrenalin", source)
end)

ESX.RegisterUsableItem('sianoor', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem("sianoor",1)
    TriggerClientEvent("weaponry:client:use:sianoor", source)
end)

local ResetStress = false

RegisterServerEvent("weaponry:Server:UpdateStress")
AddEventHandler('weaponry:Server:UpdateStress', function(StressGain)
	local src = source
    local Player = ESX.GetPlayerFromId(src)
    local newStress
    if Player ~= nil then
        if not ResetStress then
            if Player.stress == nil then
                Player.stress = 0
            end
            newStress = Player.stress + StressGain
            if newStress <= 0 then newStress = 0 end
        else
            newStress = 0
        end
        if newStress > 100 then
            newStress = 100
        end
        Player.setStress(newStress)
		TriggerClientEvent("weaponry:client:update:stress", src, newStress)
	end
end)

RegisterServerEvent('weaponry:server:gain:stress')
AddEventHandler('weaponry:server:gain:stress', function(amount)
    local src = source
    local Player = ESX.GetPlayerFromId(src)
    local newStress
    if Player ~= nil then
        if not ResetStress then
            if Player.stress == nil then
                Player.stress = 0
            end
            newStress = Player.stress + amount
            if newStress <= 0 then newStress = 0 end
        else
            newStress = 0
        end
        if newStress > 100 then
            newStress = 100
        end
        Player.setStress(newStress)
        TriggerClientEvent("weaponry:client:update:stress", src, newStress)
	end
end)

RegisterServerEvent('weaponry:Server:RelieveStress')
AddEventHandler('weaponry:Server:RelieveStress', function(amount)
    local src = source
    local Player = ESX.GetPlayerFromId(src)
    local newStress
    if Player ~= nil then
        if not ResetStress then
            if Player.stress == nil then
                Player.stress = 0
            end
            newStress = Player.stress - amount
            if newStress <= 0 then newStress = 0 end
        else
            newStress = 0
        end
        if newStress > 100 then
            newStress = 100
        end
        Player.setStress(newStress)
        TriggerClientEvent("weaponry:client:update:stress", src, newStress)
	end
end)

RegisterServerEvent('weaponry:server:remove:stress')
AddEventHandler('weaponry:server:remove:stress', function(Amount)
    local Player = ESX.GetPlayerFromId(source)
    local NewStress = nil
    if Player ~= nil then
      NewStress = Player.stress - Amount
      if NewStress <= 0 then NewStress = 0 end
      if NewStress > 105 then NewStress = 100 end
      Player.setStress(NewStress)
      TriggerClientEvent("weaponry:client:update:stress", Player.source, NewStress)
    end
end)

ESX.RegisterUsableItem('starterpack', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem("starterpack",1)
    xPlayer.addInventoryItem("phone",1)
    xPlayer.addInventoryItem("id-card",1)
    xPlayer.addInventoryItem("water",5)
    xPlayer.addInventoryItem("macka",5)
    TriggerClientEvent("esx:showNotification", source, "Shoma StarterPack Khod Ra Daryaft Kardid!", 'success')
end)