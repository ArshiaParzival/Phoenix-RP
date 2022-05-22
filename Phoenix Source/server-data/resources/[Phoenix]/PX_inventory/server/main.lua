ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

Drops = {}
Trunks = {}
Gloveboxes = {}
Stashes = {}
ShopItems = {}

RegisterServerEvent("PX_inventory:server:LoadDrops")
AddEventHandler('PX_inventory:server:LoadDrops', function()
	local src = source
	if next(Drops) ~= nil then
		TriggerClientEvent("PX_inventory:client:AddDropItem", -1, dropId, source)
		TriggerClientEvent("PX_inventory:client:AddDropItem", src, Drops)
	end
end)

RegisterServerEvent("PX_inventory:server:addTrunkItems")
AddEventHandler('PX_inventory:server:addTrunkItems', function(plate, items)
	Trunks[plate] = {}
	Trunks[plate].items = items
end)

RegisterServerEvent("PX_inventory:server:set:inventory:disabled")
AddEventHandler('PX_inventory:server:set:inventory:disabled', function(bool)
	local Player = ESX.GetPlayerFromId(source)
	Player.set("inventorydisabled", bool)
end)

RegisterServerEvent("PX_inventory:server:combineItem")
AddEventHandler('PX_inventory:server:combineItem', function(item, fromItem, toItem, RemoveToItem)
	local src = source
	local Player = ESX.GetPlayerFromId(src)
	local CombineFrom = Player.GetItemByName(fromItem)
	local CombineTo = Player.GetItemByName(toItem)
	local GetItemData = ESX.Items[item]
	if CombineFrom ~= nil and CombineTo ~= nil then
		if GetItemData['type'] == 'weapon' then
			local Info = {quality = 100.0, melee = false, ammo = 2}
			if GetItemData['ammotype'] == nil or GetItemData['ammotype'] == 'nil' then
				Info = {quality = 100.0, melee = true}
	  			Player.addInventoryItem(item, 1, false, Info)
			else
				Player.addInventoryItem(item, 1, false, Info)
			end
		else
			Player.addInventoryItem(item, 1)
		end
		Player.removeInventoryItem(fromItem, 1)
	  if RemoveToItem then
	    Player.removeInventoryItem(toItem, 1)
	  end
	  Player.set("inventorydisabled", false)
	else
	  TriggerClientEvent('esx:showNotification', src, "Je hebt deze spullen niet eens bij je hoe dan???")
	end
end)

RegisterServerEvent("PX_inventory:server:CraftItems")
AddEventHandler('PX_inventory:server:CraftItems', function(itemName, itemCosts, count, toSlot, points)
	local src = source
	local Player = ESX.GetPlayerFromId(src)
	local count = tonumber(count)
	if itemName ~= nil and itemCosts ~= nil then
		for k, v in pairs(itemCosts) do
			Player.removeInventoryItem(k, (v*count))
		end
		Player.addInventoryItem(itemName, count, toSlot)
		Player.set("inventorydisabled", false)
		TriggerClientEvent("PX_inventory:client:UpdatePlayerInventory", src, false)
	end
end)

RegisterServerEvent("PX_inventory:server:CraftWeapon")
AddEventHandler('PX_inventory:server:CraftWeapon', function(ItemName, itemCosts, count, toSlot, ItemType)
	local src = source
	local Player = ESX.GetPlayerFromId(src)
	local count = tonumber(count)
	if ItemName ~= nil and itemCosts ~= nil then
		for k, v in pairs(itemCosts) do
			Player.removeInventoryItem(k, (v*count))
		end
		if ItemType == 'weapon' then
		  Player.addInventoryItem(ItemName, count, toSlot, {serie = tostring(Config.RandomInt(2) .. Config.RandomStr(3) .. Config.RandomInt(1) .. Config.RandomStr(2) .. Config.RandomInt(3) .. Config.RandomStr(4)), ammo = 1, quality = 100.0})
		else
		  Player.addInventoryItem(ItemName, count, toSlot)
		end
		Player.set("inventorydisabled", false)
		TriggerClientEvent("PX_inventory:client:UpdatePlayerInventory", src, false)
	end
end)

RegisterServerEvent("PX_inventory:server:SetIsOpenState")
AddEventHandler('PX_inventory:server:SetIsOpenState', function(IsOpen, type, id)
	if not IsOpen then
		if type == "stash" then
			Stashes[id].isOpen = false
		elseif type == "trunk" then
			Trunks[id].isOpen = false
		elseif type == "glovebox" then
			Gloveboxes[id].isOpen = false
		end
	end
end)

RegisterServerEvent("PX_inventory:server:OpenInventory")
AddEventHandler('PX_inventory:server:OpenInventory', function(name, id, other)
	local src = source
	local Player = ESX.GetPlayerFromId(src)
		if name ~= nil and id ~= nil then
			local secondInv = {}
			if name == "stash" then
				if Stashes[id] ~= nil then
					if Stashes[id].isOpen then
						local Target = ESX.GetPlayerFromId(Stashes[id].isOpen)
						if Target ~= nil then
							TriggerClientEvent('PX_inventory:client:CheckOpenState', Stashes[id].isOpen, name, id, Stashes[id].label)
						else
							Stashes[id].isOpen = false
						end
					end
				end
				local maxweight = 1000000
				local slots = 50
				if other ~= nil then 
					maxweight = other.maxweight ~= nil and other.maxweight or 1000000
					slots = other.slots ~= nil and other.slots or 50
				end
				secondInv.name = "stash-"..id
				secondInv.label = "Stash-"..id
				secondInv.maxweight = maxweight
				secondInv.inventory = {}
				secondInv.slots = slots
				if Stashes[id] ~= nil and Stashes[id].isOpen then
					secondInv.name = "none-inv"
					secondInv.label = "Stash-None"
					secondInv.maxweight = 1000000
					secondInv.inventory = {}
					secondInv.slots = 0
				else
					local stashItems = ItemsInStash(id)
					if next(stashItems) ~= nil then
						secondInv.inventory = stashItems
						Stashes[id] = {}
						Stashes[id].items = stashItems
						Stashes[id].isOpen = src
						Stashes[id].label = secondInv.label
					else
						Stashes[id] = {}
						Stashes[id].items = {}
						Stashes[id].isOpen = src
						Stashes[id].label = secondInv.label
					end
				end
			elseif name == "trunk" then
				if Trunks[id] ~= nil then
					if Trunks[id].isOpen then
						local Target = ESX.GetPlayerFromId(Trunks[id].isOpen)
						if Target ~= nil then
							TriggerClientEvent('PX_inventory:client:CheckOpenState', Trunks[id].isOpen, name, id, Trunks[id].label)
						else
							Trunks[id].isOpen = false
						end
					end
				end
				secondInv.name = "trunk-"..id
				secondInv.label = "Trunk-"..id
				secondInv.maxweight = other.maxweight ~= nil and other.maxweight or 60000
				secondInv.inventory = {}
				secondInv.slots = other.slots ~= nil and other.slots or 50
				if (Trunks[id] ~= nil and Trunks[id].isOpen) or (ESX.SplitStr(id, "PLZI")[2] ~= nil and Player.job.name ~= "police") then
					secondInv.name = "none-inv"
					secondInv.label = "Trunk-None"
					secondInv.maxweight = other.maxweight ~= nil and other.maxweight or 60000
					secondInv.inventory = {}
					secondInv.slots = 0
				else
					if id ~= nil then 
						local ownedItems = GetOwnedVehicleItems(id)
						if IsVehicleOwned(id) and next(ownedItems) ~= nil then
							secondInv.inventory = ownedItems
							Trunks[id] = {}
							Trunks[id].items = ownedItems
							Trunks[id].isOpen = src
							Trunks[id].label = secondInv.label
						elseif Trunks[id] ~= nil and not Trunks[id].isOpen then
							secondInv.inventory = Trunks[id].items
							Trunks[id].isOpen = src
							Trunks[id].label = secondInv.label
						else
							Trunks[id] = {}
							Trunks[id].items = {}
							Trunks[id].isOpen = src
							Trunks[id].label = secondInv.label
						end
					end
				end
			elseif name == "glovebox" then
				if Gloveboxes[id] ~= nil then
					if Gloveboxes[id].isOpen then
						local Target = ESX.GetPlayerFromId(Gloveboxes[id].isOpen)
						if Target ~= nil then
							TriggerClientEvent('PX_inventory:client:CheckOpenState', Gloveboxes[id].isOpen, name, id, Gloveboxes[id].label)
						else
							Gloveboxes[id].isOpen = false
						end
					end
				end
				secondInv.name = "glovebox-"..id
				secondInv.label = "Glovebox-"..id
				secondInv.maxweight = 10000
				secondInv.inventory = {}
				secondInv.slots = 5
				if Gloveboxes[id] ~= nil and Gloveboxes[id].isOpen then
					secondInv.name = "none-inv"
					secondInv.label = "Glovebox-None"
					secondInv.maxweight = 10000
					secondInv.inventory = {}
					secondInv.slots = 0
				else
					local ownedItems = GetOwnedVehicleGloveboxItems(id)
					if Gloveboxes[id] ~= nil and not Gloveboxes[id].isOpen then
						secondInv.inventory = Gloveboxes[id].items
						Gloveboxes[id].isOpen = src
						Gloveboxes[id].label = secondInv.label
					elseif IsVehicleOwned(id) and next(ownedItems) ~= nil then
						secondInv.inventory = ownedItems
						Gloveboxes[id] = {}
						Gloveboxes[id].items = ownedItems
						Gloveboxes[id].isOpen = src
						Gloveboxes[id].label = secondInv.label
					else
						Gloveboxes[id] = {}
						Gloveboxes[id].items = {}
						Gloveboxes[id].isOpen = src
						Gloveboxes[id].label = secondInv.label
					end
				end
			elseif name == "shop" then
				secondInv.name = "itemshop-"..id
				secondInv.label = other.label
				secondInv.maxweight = 900000
				secondInv.inventory = SetupShopItems(id, other.items)
				ShopItems[id] = {}
				ShopItems[id].items = other.items
				secondInv.slots = #other.items
			elseif name == "crafting" then
				secondInv.name = "crafting"
				secondInv.label = other.label
				secondInv.maxweight = 900000
				secondInv.inventory = other.items
				secondInv.slots = #other.items
			elseif name == "methcrafting" then
				secondInv.name = "methcrafting"
				secondInv.label = other.label
				secondInv.maxweight = 900000
				secondInv.inventory = other.items
				secondInv.slots = #other.items
			elseif name == "cokecrafting" then
				secondInv.name = "cokecrafting"
				secondInv.label = other.label
				secondInv.maxweight = 900000
				secondInv.inventory = other.items
				secondInv.slots = #other.items
			elseif name == "crafting_weapon" then
				secondInv.name = "crafting_weapon"
				secondInv.label = other.label
				secondInv.maxweight = 900000
				secondInv.inventory = other.items
				secondInv.slots = #other.items
			elseif name == "lab" then
				secondInv.name = "lab-"..id
				secondInv.label = other.label
				secondInv.maxweight = 900000
				secondInv.inventory = other.items
				secondInv.slots = other.slots
			elseif name == "otherplayer" then
				local OtherPlayer = ESX.GetPlayerFromId(tonumber(id))
				if OtherPlayer ~= nil then
					secondInv.name = "otherplayer-"..id
					secondInv.label = "Player-"..id
					secondInv.maxweight = 250
					secondInv.inventory = OtherPlayer.inventory
					secondInv.slots = Config.MaxInventorySlots
					Citizen.Wait(250)
				end
			else
				if Drops[id] ~= nil and not Drops[id].isOpen then
					secondInv.name = id
					secondInv.label = "Dropped-"..tostring(id)
					secondInv.maxweight = 100000
					secondInv.inventory = Drops[id].items
					secondInv.slots = 15
					Drops[id].isOpen = src
					Drops[id].label = secondInv.label
				else
					secondInv.name = "none-inv"
					secondInv.label = "Dropped-None"
					secondInv.maxweight = 100000
					secondInv.inventory = {}
					secondInv.slots = 0
				end
			end
			TriggerClientEvent("PX_inventory:client:OpenInventory", src, Player.inventory, secondInv)
		else
			TriggerClientEvent("PX_inventory:client:OpenInventory", src, Player.inventory)
		end
end)

RegisterServerEvent("PX_inventory:server:SaveInventory")
AddEventHandler('PX_inventory:server:SaveInventory', function(type, id)
	if type == "trunk" then
		if (IsVehicleOwned(id)) then
			SaveOwnedVehicleItems(id, Trunks[id].items)
		else
			Trunks[id].isOpen = false
		end
	elseif type == "glovebox" then
		if (IsVehicleOwned(id)) then
			SaveOwnedGloveboxItems(id, Gloveboxes[id].items)
		else
			Gloveboxes[id].isOpen = false
		end
	elseif type == "stash" then
		SaveStashItems(id, Stashes[id].items)
	elseif type == "drop" then
		if Drops[id] ~= nil then
			Drops[id].isOpen = false
			if Drops[id].items == nil or next(Drops[id].items) == nil then
				Drops[id] = nil
				TriggerClientEvent("PX_inventory:client:RemoveDropItem", -1, id)
			end
		end
	end
end)

RegisterServerEvent("PX_inventory:server:UseItemSlot")
AddEventHandler('PX_inventory:server:UseItemSlot', function(slot)
	local src = source
	local Player = ESX.GetPlayerFromId(src)
	local itemData = Player.GetItemBySlot(slot)
	if itemData ~= nil then
		local itemInfo = ESX.Items[itemData.name]
		if itemData.type == "weapon" then
			if itemData.info.quality ~= nil then
				if itemData.info.quality ~= 0 then
					TriggerClientEvent("PX_inventory:client:UseWeapon", src, itemData, true)
				else
					TriggerClientEvent('esx:showNotification', src, "This weapon is broken..")
				end
			else
				TriggerClientEvent('esx:showNotification', src, "Didn't find a weapon quality??", "info")
			end
			TriggerClientEvent('PX_inventory:client:ItemBox', src, itemInfo, "use")
		elseif itemData.useable then
			TriggerClientEvent("esx:UseManiItem", src, itemData)
			TriggerClientEvent('PX_inventory:client:ItemBox', src, itemInfo, "use")
		end
	end
end)

RegisterServerEvent("PX_inventory:server:UseItem")
AddEventHandler('PX_inventory:server:UseItem', function(inventory, item)
	local src = source
	local Player = ESX.GetPlayerFromId(src)
	if inventory == "player" or inventory == "hotbar" then
		local itemData = Player.GetItemBySlot(item.slot)
		if itemData ~= nil then
			TriggerClientEvent('PX_inventory:client:ItemBox', src, ESX.Items[itemData.name], "use")
			TriggerClientEvent("esx:UseManiItem", src, itemData)
		end
	end
end)

RegisterServerEvent("PX_inventory:server:SetInventoryData")
AddEventHandler('PX_inventory:server:SetInventoryData', function(fromInventory, toInventory, fromSlot, toSlot, fromCount, toCount)
	local src = source
	local Player = ESX.GetPlayerFromId(src)
	local fromSlot = tonumber(fromSlot)
	local toSlot = tonumber(toSlot)

	if (fromInventory == "player" or fromInventory == "hotbar") and (ESX.SplitStr(toInventory, "-")[1] == "itemshop" or toInventory == "crafting") then
		return
	end

	if fromInventory == "player" or fromInventory == "hotbar" then
		local fromItemData = Player.GetItemBySlot(fromSlot)
		local fromCount = tonumber(fromCount) ~= nil and tonumber(fromCount) or fromItemData.count
		if fromItemData ~= nil and fromItemData.count >= fromCount then
			if toInventory == "player" or toInventory == "hotbar" then
				local toItemData = Player.GetItemBySlot(toSlot)
				Player.removeInventoryItem(fromItemData.name, fromCount, fromSlot)
				TriggerClientEvent("PX_inventory:client:CheckWeapon", src, fromItemData.name)
				--Player.inventory[toSlot] = fromItemData
				if toItemData ~= nil then
					--Player.inventory[fromSlot] = toItemData
					local toCount = tonumber(toCount) ~= nil and tonumber(toCount) or toItemData.count
					if toItemData.name ~= fromItemData.name then
						Player.removeInventoryItem(toItemData.name, toCount, toSlot)
						Player.addInventoryItem(toItemData.name, toCount, fromSlot, toItemData.info)
					end
				else
					--Player.inventory[fromSlot] = nil
				end
				Player.addInventoryItem(fromItemData.name, fromCount, toSlot, fromItemData.info)
			elseif ESX.SplitStr(toInventory, "-")[1] == "otherplayer" then
				local playerId = tonumber(ESX.SplitStr(toInventory, "-")[2])
				local OtherPlayer = ESX.GetPlayerFromId(playerId)
				local toItemData = OtherPlayer.inventory[toSlot]
				Player.removeInventoryItem(fromItemData.name, fromCount, fromSlot)
				TriggerClientEvent("PX_inventory:client:CheckWeapon", src, fromItemData.name)
				--Player.inventory[toSlot] = fromItemData
				if toItemData ~= nil then
					--Player.inventory[fromSlot] = toItemData
					local itemInfo = ESX.Items[toItemData.name:lower()]
					local toCount = tonumber(toCount) ~= nil and tonumber(toCount) or toItemData.count
					if toItemData.name ~= fromItemData.name then
						OtherPlayer.removeInventoryItem(itemInfo.name, toCount, fromSlot)
						Player.addInventoryItem(toItemData.name, toCount, fromSlot, toItemData.info)
						--TriggerEvent("PX_logs:server:SendLog", "robbing", "Swapped Item", "orange", "**".. GetPlayerName(src) .. "** (citizenid: *"..Player.identifier.."* | *"..src.."*) swapped item; name: **"..itemInfo.name.."**, count: **" .. toCount .. "** with name: **" .. fromItemData.name .. "**, count: **" .. fromCount.. "** with player: **".. GetPlayerName(OtherPlayer.source) .. "** (citizenid: *"..OtherPlayer.identifier.."* | id: *"..OtherPlayer.source.."*)")
					end
				else
					local itemInfo = ESX.Items[fromItemData.name:lower()]
					--TriggerEvent("PX_logs:server:SendLog", "robbing", "Dropped Item", "red", "**".. GetPlayerName(src) .. "** (citizenid: *"..Player.identifier.."* | *"..src.."*) dropped new item; name: **"..itemInfo.name.."**, count: **" .. fromCount .. "** to player: **".. GetPlayerName(OtherPlayer.source) .. "** (citizenid: *"..OtherPlayer.identifier.."* | id: *"..OtherPlayer.source.."*)")
				end
				local itemInfo = ESX.Items[fromItemData.name:lower()]
				OtherPlayer.addInventoryItem(itemInfo.name, fromCount, toSlot, fromItemData.info)
			elseif ESX.SplitStr(toInventory, "-")[1] == "trunk" then
				local plate = ESX.SplitStr(toInventory, "-")[2]
				local toItemData = Trunks[plate].items[toSlot]
				Player.removeInventoryItem(fromItemData.name, fromCount, fromSlot)
				TriggerClientEvent("PX_inventory:client:CheckWeapon", src, fromItemData.name)
				--Player.inventory[toSlot] = fromItemData
				if toItemData ~= nil then
					--Player.inventory[fromSlot] = toItemData
					local itemInfo = ESX.Items[toItemData.name:lower()]
					local toCount = tonumber(toCount) ~= nil and tonumber(toCount) or toItemData.count
					if toItemData.name ~= fromItemData.name then
						RemoveFromTrunk(plate, fromSlot, itemInfo.name, toCount)
						Player.addInventoryItem(toItemData.name, toCount, fromSlot, toItemData.info)
						--TriggerEvent("PX_logs:server:SendLog", "trunk", "Swapped Item", "orange", "**".. GetPlayerName(src) .. "** (citizenid: *"..Player.identifier.."* | id: *"..src.."*) swapped item; name: **"..itemInfo.name.."**, count: **" .. toCount .. "** with name: **" .. fromItemData.name .. "**, count: **" .. fromCount .. "** - plate: *" .. plate .. "*")
					end
				else
					local itemInfo = ESX.Items[fromItemData.name:lower()]
					--TriggerEvent("PX_logs:server:SendLog", "trunk", "Dropped Item", "red", "**".. GetPlayerName(src) .. "** (citizenid: *"..Player.identifier.."* | id: *"..src.."*) dropped new item; name: **"..itemInfo.name.."**, count: **" .. fromCount .. "** - plate: *" .. plate .. "*")
				end
				local itemInfo = ESX.Items[fromItemData.name:lower()]
				AddToTrunk(plate, toSlot, fromSlot, itemInfo.name, fromCount, fromItemData.info)
			elseif ESX.SplitStr(toInventory, "-")[1] == "glovebox" then
				local plate = ESX.SplitStr(toInventory, "-")[2]
				local toItemData = Gloveboxes[plate].items[toSlot]
				Player.removeInventoryItem(fromItemData.name, fromCount, fromSlot)
				TriggerClientEvent("PX_inventory:client:CheckWeapon", src, fromItemData.name)
				--Player.inventory[toSlot] = fromItemData
				if toItemData ~= nil then
					--Player.inventory[fromSlot] = toItemData
					local itemInfo = ESX.Items[toItemData.name:lower()]
					local toCount = tonumber(toCount) ~= nil and tonumber(toCount) or toItemData.count
					if toItemData.name ~= fromItemData.name then
						RemoveFromGlovebox(plate, fromSlot, itemInfo.name, toCount)
						Player.addInventoryItem(toItemData.name, toCount, fromSlot, toItemData.info)
						--TriggerEvent("PX_logs:server:SendLog", "glovebox", "Swapped Item", "orange", "**".. GetPlayerName(src) .. "** (citizenid: *"..Player.identifier.."* | id: *"..src.."*) swapped item; name: **"..itemInfo.name.."**, count: **" .. toCount .. "** with name: **" .. fromItemData.name .. "**, count: **" .. fromCount .. "** - plate: *" .. plate .. "*")
					end
				else
					local itemInfo = ESX.Items[fromItemData.name:lower()]
					--TriggerEvent("PX_logs:server:SendLog", "glovebox", "Dropped Item", "red", "**".. GetPlayerName(src) .. "** (citizenid: *"..Player.identifier.."* | id: *"..src.."*) dropped new item; name: **"..itemInfo.name.."**, count: **" .. fromCount .. "** - plate: *" .. plate .. "*")
				end
				local itemInfo = ESX.Items[fromItemData.name:lower()]
				AddToGlovebox(plate, toSlot, fromSlot, itemInfo.name, fromCount, fromItemData.info)
			elseif ESX.SplitStr(toInventory, "-")[1] == "stash" then
				local stashId = ESX.SplitStr(toInventory, "-")[2]
				local toItemData = Stashes[stashId].items[toSlot]
				Player.removeInventoryItem(fromItemData.name, fromCount, fromSlot)
				TriggerClientEvent("PX_inventory:client:CheckWeapon", src, fromItemData.name)
				--Player.inventory[toSlot] = fromItemData
				if toItemData ~= nil then
					--Player.inventory[fromSlot] = toItemData
					local itemInfo = ESX.Items[toItemData.name:lower()]
					local toCount = tonumber(toCount) ~= nil and tonumber(toCount) or toItemData.count
					if toItemData.name ~= fromItemData.name then
						RemoveFromStash(stashId, fromSlot, itemInfo.name, toCount)
						Player.addInventoryItem(toItemData.name, toCount, fromSlot, toItemData.info)
						--TriggerEvent("PX_logs:server:SendLog", "stash", "Swapped Item", "orange", "**".. GetPlayerName(src) .. "** (citizenid: *"..Player.identifier.."* | id: *"..src.."*) swapped item; name: **"..itemInfo.name.."**, count: **" .. toCount .. "** with name: **" .. fromItemData.name .. "**, count: **" .. fromCount .. "** - stash: *" .. stashId .. "*")
					end
				else
					local itemInfo = ESX.Items[fromItemData.name:lower()]
					--TriggerEvent("PX_logs:server:SendLog", "stash", "Dropped Item", "red", "**".. GetPlayerName(src) .. "** (citizenid: *"..Player.identifier.."* | id: *"..src.."*) dropped new item; name: **"..itemInfo.name.."**, count: **" .. fromCount .. "** - stash: *" .. stashId .. "*")
				end
				local itemInfo = ESX.Items[fromItemData.name:lower()]
				AddToStash(stashId, toSlot, fromSlot, itemInfo.name, fromCount, fromItemData.info)
			elseif ESX.SplitStr(toInventory, "-")[1] == "lab" then
				local LabId = ESX.SplitStr(toInventory, "-")[2]
				local toItemData = exports['PX_labs']:GetInventoryData(LabId, toSlot)
				local IsItemValid = exports['PX_labs']:CanItemBePlaced(fromItemData.name:lower())
				if IsItemValid then
					TriggerClientEvent("PX_inventory:client:CheckWeapon", src, fromItemData.name)
					if toItemData ~= nil then
						local itemInfo = ESX.Items[toItemData.name:lower()]
						local toCount = tonumber(toCount) ~= nil and tonumber(toCount) or toItemData.count
						if toItemData.name ~= fromItemData.name then
							exports['PX_labs']:RemoveProduct(LabId, fromSlot, itemInfo.name, toCount)
							Player.addInventoryItem(toItemData.name, toCount, fromSlot, toItemData.info, false)
						end
					end
					local itemInfo = ESX.Items[fromItemData.name:lower()]
					if toSlot ~= 2 then
						Player.removeInventoryItem(fromItemData.name, fromCount, fromSlot)
						exports['PX_labs']:AddProduct(LabId, toSlot, itemInfo.name, fromCount, fromItemData.info, true)
					else
						TriggerClientEvent("PX_inventory:client:UpdatePlayerInventory", src, true)
						TriggerClientEvent("PX_inventory:client:close:inventory", src)
					end
				else
					TriggerClientEvent('esx:showNotification', src, "This cannot be contained")
					TriggerClientEvent("PX_inventory:client:UpdatePlayerInventory", src, true)
					TriggerClientEvent("PX_inventory:client:close:inventory", src)
				end
			else
				-- drop
				toInventory = tonumber(toInventory)
				if toInventory == nil or toInventory == 0 then
					CreateNewDrop(src, fromSlot, toSlot, fromCount)
				else
					local toItemData = Drops[toInventory].items[toSlot]
					Player.removeInventoryItem(fromItemData.name, fromCount, fromSlot)
					TriggerClientEvent("PX_inventory:client:CheckWeapon", src, fromItemData.name)
					if toItemData ~= nil then
						local itemInfo = ESX.Items[toItemData.name:lower()]
						local toCount = tonumber(toCount) ~= nil and tonumber(toCount) or toItemData.count
						if toItemData.name ~= fromItemData.name then
							Player.addInventoryItem(toItemData.name, toCount, fromSlot, toItemData.info)
							RemoveFromDrop(toInventory, fromSlot, itemInfo.name, toCount)
							--TriggerEvent("PX_logs:server:SendLog", "drop", "Swapped Item", "orange", "**".. GetPlayerName(src) .. "** (citizenid: *"..Player.identifier.."* | id: *"..src.."*) swapped item; name: **"..itemInfo.name.."**, count: **" .. toCount .. "** with name: **" .. fromItemData.name .. "**, count: **" .. fromCount .. "** - dropid: *" .. toInventory .. "*")
						end
					else
						local itemInfo = ESX.Items[fromItemData.name:lower()]
						--TriggerEvent("PX_logs:server:SendLog", "drop", "Dropped Item", "red", "**".. GetPlayerName(src) .. "** (citizenid: *"..Player.identifier.."* | id: *"..src.."*) dropped new item; name: **"..itemInfo.name.."**, count: **" .. fromCount .. "** - dropid: *" .. toInventory .. "*")
					end
					local itemInfo = ESX.Items[fromItemData.name:lower()]
					AddToDrop(toInventory, toSlot, itemInfo.name, fromCount, fromItemData.info)
					if itemInfo.name == "radio" then
					TriggerClientEvent('PX_radio:onRadioDrop', src)
					end
				end
			end
		else
			TriggerClientEvent("esx:showNotification", src, "You dont have this item.")
		end
	elseif ESX.SplitStr(fromInventory, "-")[1] == "otherplayer" then
		local playerId = tonumber(ESX.SplitStr(fromInventory, "-")[2])
		local OtherPlayer = ESX.GetPlayerFromId(playerId)
		local fromItemData = OtherPlayer.inventory[fromSlot]
		local fromCount = tonumber(fromCount) ~= nil and tonumber(fromCount) or fromItemData.count
		if fromItemData ~= nil and fromItemData.count >= fromCount then
			local itemInfo = ESX.Items[fromItemData.name:lower()]
			if toInventory == "player" or toInventory == "hotbar" then
				local toItemData = Player.GetItemBySlot(toSlot)
				OtherPlayer.removeInventoryItem(itemInfo.name, fromCount, fromSlot)
				TriggerClientEvent("PX_inventory:client:CheckWeapon", OtherPlayer.source, fromItemData.name)
				if toItemData ~= nil then
					local itemInfo = ESX.Items[toItemData.name:lower()]
					local toCount = tonumber(toCount) ~= nil and tonumber(toCount) or toItemData.count
					if toItemData.name ~= fromItemData.name then
						Player.removeInventoryItem(toItemData.name, toCount, toSlot)
						OtherPlayer.addInventoryItem(itemInfo.name, toCount, fromSlot, toItemData.info)
						--TriggerEvent("PX_logs:server:SendLog", "robbing", "Swapped Item", "orange", "**".. GetPlayerName(src) .. "** (citizenid: *"..Player.identifier.."* | id: *"..src.."*) swapped item; name: **"..toItemData.name.."**, count: **" .. toCount .. "** with item; **"..itemInfo.name.."**, count: **" .. toCount .. "** from player: **".. GetPlayerName(OtherPlayer.source) .. "** (citizenid: *"..OtherPlayer.identifier.."* | *"..OtherPlayer.source.."*)")
					end
				else
					--TriggerEvent("PX_logs:server:SendLog", "robbing", "Retrieved Item", "green", "**".. GetPlayerName(src) .. "** (citizenid: *"..Player.identifier.."* | id: *"..src.."*) took item; name: **"..fromItemData.name.."**, count: **" .. fromCount .. "** from player: **".. GetPlayerName(OtherPlayer.source) .. "** (citizenid: *"..OtherPlayer.identifier.."* | *"..OtherPlayer.source.."*)")
				end
				Player.addInventoryItem(fromItemData.name, fromCount, toSlot, fromItemData.info)
			else
				local toItemData = OtherPlayer.inventory[toSlot]
				OtherPlayer.removeInventoryItem(itemInfo.name, fromCount, fromSlot)
				--Player.inventory[toSlot] = fromItemData
				if toItemData ~= nil then
					local itemInfo = ESX.Items[toItemData.name:lower()]
					--Player.inventory[fromSlot] = toItemData
					local toCount = tonumber(toCount) ~= nil and tonumber(toCount) or toItemData.count
					if toItemData.name ~= fromItemData.name then
						local itemInfo = ESX.Items[toItemData.name:lower()]
						OtherPlayer.removeInventoryItem(itemInfo.name, toCount, toSlot)
						OtherPlayer.addInventoryItem(itemInfo.name, toCount, fromSlot, toItemData.info)
					end
				else
					--Player.inventory[fromSlot] = nil
				end
				local itemInfo = ESX.Items[fromItemData.name:lower()]
				OtherPlayer.addInventoryItem(itemInfo.name, fromCount, toSlot, fromItemData.info)
			end
		else
			TriggerClientEvent("esx:showNotification", src, "Item bestaat niet??")
		end
	elseif ESX.SplitStr(fromInventory, "-")[1] == "trunk" then
		local plate = ESX.SplitStr(fromInventory, "-")[2]
		local fromItemData = Trunks[plate].items[fromSlot]
		local fromCount = tonumber(fromCount) ~= nil and tonumber(fromCount) or fromItemData.count
		if fromItemData ~= nil and fromItemData.count >= fromCount then
			local itemInfo = ESX.Items[fromItemData.name:lower()]
			if toInventory == "player" or toInventory == "hotbar" then
				local toItemData = Player.GetItemBySlot(toSlot)
				RemoveFromTrunk(plate, fromSlot, itemInfo.name, fromCount)
				if toItemData ~= nil then
					local itemInfo = ESX.Items[toItemData.name:lower()]
					local toCount = tonumber(toCount) ~= nil and tonumber(toCount) or toItemData.count
					if toItemData.name ~= fromItemData.name then
						Player.removeInventoryItem(toItemData.name, toCount, toSlot)
						AddToTrunk(plate, fromSlot, toSlot, itemInfo.name, toCount, toItemData.info)
						--TriggerEvent("PX_logs:server:SendLog", "trunk", "Swapped Item", "orange", "**".. GetPlayerName(src) .. "** (citizenid: *"..Player.identifier.."* | id: *"..src.."*) swapped item; name: **"..toItemData.name.."**, count: **" .. toCount .. "** with item; name: **"..itemInfo.name.."**, count: **" .. toCount .. "** plate: *" .. plate .. "*")
					else
						TriggerEvent("server:sendLog", Player.identifier, "itemswapped", {type="2trunk3", name=toItemData.name, count=toCount, target=plate})
						--TriggerEvent("PX_logs:server:SendLog", "trunk", "Stacked Item", "orange", "**".. GetPlayerName(src) .. "** (citizenid: *"..Player.identifier.."* | id: *"..src.."*) stacked item; name: **"..toItemData.name.."**, count: **" .. toCount .. "** from plate: *" .. plate .. "*")
					end
				else
					--TriggerEvent("PX_logs:server:SendLog", "trunk", "Received Item", "green", "**".. GetPlayerName(src) .. "** (citizenid: *"..Player.identifier.."* | id: *"..src.."*) reveived item; name: **"..fromItemData.name.."**, count: **" .. fromCount.. "** plate: *" .. plate .. "*")
				end
				Player.addInventoryItem(fromItemData.name, fromCount, toSlot, fromItemData.info)
			else
				local toItemData = Trunks[plate].items[toSlot]
				RemoveFromTrunk(plate, fromSlot, itemInfo.name, fromCount)
				--Player.inventory[toSlot] = fromItemData
				if toItemData ~= nil then
					local itemInfo = ESX.Items[toItemData.name:lower()]
					--Player.inventory[fromSlot] = toItemData
					local toCount = tonumber(toCount) ~= nil and tonumber(toCount) or toItemData.count
					if toItemData.name ~= fromItemData.name then
						local itemInfo = ESX.Items[toItemData.name:lower()]
						RemoveFromTrunk(plate, toSlot, itemInfo.name, toCount)
						AddToTrunk(plate, fromSlot, toSlot, itemInfo.name, toCount, toItemData.info)
					end
				else
					--Player.inventory[fromSlot] = nil
				end
				local itemInfo = ESX.Items[fromItemData.name:lower()]
				AddToTrunk(plate, toSlot, fromSlot, itemInfo.name, fromCount, fromItemData.info)
			end
		else
			TriggerClientEvent("esx:showNotification", src, "Item bestaat niet??")
		end
	elseif ESX.SplitStr(fromInventory, "-")[1] == "glovebox" then
		local plate = ESX.SplitStr(fromInventory, "-")[2]
		local fromItemData = Gloveboxes[plate].items[fromSlot]
		local fromCount = tonumber(fromCount) ~= nil and tonumber(fromCount) or fromItemData.count
		if fromItemData ~= nil and fromItemData.count >= fromCount then
			local itemInfo = ESX.Items[fromItemData.name:lower()]
			if toInventory == "player" or toInventory == "hotbar" then
				local toItemData = Player.GetItemBySlot(toSlot)
				RemoveFromGlovebox(plate, fromSlot, itemInfo.name, fromCount)
				if toItemData ~= nil then
					local itemInfo = ESX.Items[toItemData.name:lower()]
					local toCount = tonumber(toCount) ~= nil and tonumber(toCount) or toItemData.count
					if toItemData.name ~= fromItemData.name then
						Player.removeInventoryItem(toItemData.name, toCount, toSlot)
						AddToGlovebox(plate, fromSlot, toSlot, itemInfo.name, toCount, toItemData.info)
						--TriggerEvent("PX_logs:server:SendLog", "glovebox", "Swapped", "orange", "**".. GetPlayerName(src) .. "** (citizenid: *"..Player.identifier.."* | id: *"..src..")* swapped item; name: **"..toItemData.name.."**, count: **" .. toCount .. "** with item; name: **"..itemInfo.name.."**, count: **" .. toCount .. "** plate: *" .. plate .. "*")
					else
						--TriggerEvent("PX_logs:server:SendLog", "glovebox", "Stacked Item", "orange", "**".. GetPlayerName(src) .. "** (citizenid: *"..Player.identifier.."* | id: *"..src.."*) stacked item; name: **"..toItemData.name.."**, count: **" .. toCount .. "** from plate: *" .. plate .. "*")
					end
				else
					--TriggerEvent("PX_logs:server:SendLog", "glovebox", "Received Item", "green", "**".. GetPlayerName(src) .. "** (citizenid: *"..Player.identifier.."* | id: *"..src.."*) reveived item; name: **"..fromItemData.name.."**, count: **" .. fromCount.. "** plate: *" .. plate .. "*")
				end
				Player.addInventoryItem(fromItemData.name, fromCount, toSlot, fromItemData.info)
			else
				local toItemData = Gloveboxes[plate].items[toSlot]
				RemoveFromGlovebox(plate, fromSlot, itemInfo.name, fromCount)
				--Player.inventory[toSlot] = fromItemData
				if toItemData ~= nil then
					local itemInfo = ESX.Items[toItemData.name:lower()]
					--Player.inventory[fromSlot] = toItemData
					local toCount = tonumber(toCount) ~= nil and tonumber(toCount) or toItemData.count
					if toItemData.name ~= fromItemData.name then
						local itemInfo = ESX.Items[toItemData.name:lower()]
						RemoveFromGlovebox(plate, toSlot, itemInfo.name, toCount)
						AddToGlovebox(plate, fromSlot, toSlot, itemInfo.name, toCount, toItemData.info)
					end
				else
					--Player.inventory[fromSlot] = nil
				end
				local itemInfo = ESX.Items[fromItemData.name:lower()]
				AddToGlovebox(plate, toSlot, fromSlot, itemInfo.name, fromCount, fromItemData.info)
			end
		else
			TriggerClientEvent("esx:showNotification", src, "Item bestaat niet??")
		end
	elseif ESX.SplitStr(fromInventory, "-")[1] == "stash" then
		local stashId = ESX.SplitStr(fromInventory, "-")[2]
		local fromItemData = Stashes[stashId].items[fromSlot]
		local fromCount = tonumber(fromCount) ~= nil and tonumber(fromCount) or fromItemData.count
		if fromItemData ~= nil and fromItemData.count >= fromCount then
			local itemInfo = ESX.Items[fromItemData.name:lower()]
			if toInventory == "player" or toInventory == "hotbar" then
				local toItemData = Player.GetItemBySlot(toSlot)
				RemoveFromStash(stashId, fromSlot, itemInfo.name, fromCount)
				if toItemData ~= nil then
					local itemInfo = ESX.Items[toItemData.name:lower()]
					local toCount = tonumber(toCount) ~= nil and tonumber(toCount) or toItemData.count
					if toItemData.name ~= fromItemData.name then
						Player.removeInventoryItem(toItemData.name, toCount, toSlot)
						AddToStash(stashId, fromSlot, toSlot, itemInfo.name, toCount, toItemData.info)
						--TriggerEvent("PX_logs:server:SendLog", "stash", "Swapped Item", "orange", "**".. GetPlayerName(src) .. "** (citizenid: *"..Player.identifier.."* | id: *"..src.."*) swapped item; name: **"..toItemData.name.."**, count: **" .. toCount .. "** with item; name: **"..fromItemData.name.."**, count: **" .. fromCount .. "** stash: *" .. stashId .. "*")
					else
						--TriggerEvent("PX_logs:server:SendLog", "stash", "Stacked Item", "orange", "**".. GetPlayerName(src) .. "** (citizenid: *"..Player.identifier.."* | id: *"..src.."*) stacked item; name: **"..toItemData.name.."**, count: **" .. toCount .. "** from stash: *" .. stashId .. "*")
					end
				else
					--TriggerEvent("PX_logs:server:SendLog", "stash", "Received Item", "green", "**".. GetPlayerName(src) .. "** (citizenid: *"..Player.identifier.."* | id: *"..src.."*) reveived item; name: **"..fromItemData.name.."**, count: **" .. fromCount.. "** stash: *" .. stashId .. "*")
				end
				Player.addInventoryItem(fromItemData.name, fromCount, toSlot, fromItemData.info)
			else
				local toItemData = Stashes[stashId].items[toSlot]
				RemoveFromStash(stashId, fromSlot, itemInfo.name, fromCount)
				--Player.inventory[toSlot] = fromItemData
				if toItemData ~= nil then
					local itemInfo = ESX.Items[toItemData.name:lower()]
					--Player.inventory[fromSlot] = toItemData
					local toCount = tonumber(toCount) ~= nil and tonumber(toCount) or toItemData.count
					if toItemData.name ~= fromItemData.name then
						local itemInfo = ESX.Items[toItemData.name:lower()]
						RemoveFromStash(stashId, toSlot, itemInfo.name, toCount)
						AddToStash(stashId, fromSlot, toSlot, itemInfo.name, toCount, toItemData.info)
					end
				else
					--Player.inventory[fromSlot] = nil
				end
				local itemInfo = ESX.Items[fromItemData.name:lower()]
				AddToStash(stashId, toSlot, fromSlot, itemInfo.name, fromCount, fromItemData.info)
			end
		else
			TriggerClientEvent("esx:showNotification", src, "Item bestaat niet??")
		end
	elseif ESX.SplitStr(fromInventory, "-")[1] == "lab" then
		local LabId = ESX.SplitStr(fromInventory, "-")[2]
		local fromItemData = exports['PX_labs']:GetInventoryData(LabId, fromSlot)
		local fromCount = tonumber(fromCount) ~= nil and tonumber(fromCount) or fromItemData.count
		if fromItemData ~= nil and fromItemData.count >= fromCount then
			local itemInfo = ESX.Items[fromItemData.name:lower()]
			if toInventory == "player" or toInventory == "hotbar" then
				local toItemData = Player.GetItemBySlot(toSlot)
				exports['PX_labs']:RemoveProduct(LabId, fromSlot, itemInfo.name, fromCount)
				if toItemData ~= nil then
					local itemInfo = ESX.Items[toItemData.name:lower()]
					local toCount = tonumber(toCount) ~= nil and tonumber(toCount) or toItemData.count
					if toItemData.name ~= fromItemData.name then
						if toSlot ~= 2 then
							Player.removeInventoryItem(toItemData.name, toCount, toSlot)
							exports['PX_labs']:AddProduct(LabId, fromSlot, itemInfo.name, toCount, toItemData.info, true)
							--TriggerEvent("PX_logs:server:SendLog", "stash", "Swapped Item", "orange", "**".. GetPlayerName(src) .. "** (citizenid: *"..Player.identifier.."* | id: *"..src.."*) swapped item; name: **"..toItemData.name.."**, count: **" .. toCount .. "** with item; name: **"..fromItemData.name.."**, count: **" .. fromCount .. "** stash: *" .. LabId .. "*")
						else
							TriggerClientEvent("PX_inventory:client:UpdatePlayerInventory", src, true)
						end
					else
						--TriggerEvent("PX_logs:server:SendLog", "stash", "Stacked Item", "orange", "**".. GetPlayerName(src) .. "** (citizenid: *"..Player.identifier.."* | id: *"..src.."*) stacked item; name: **"..toItemData.name.."**, count: **" .. toCount .. "** from stash: *" .. LabId .. "*")
					end
				else
					--TriggerEvent("PX_logs:server:SendLog", "stash", "Received Item", "green", "**".. GetPlayerName(src) .. "** (citizenid: *"..Player.identifier.."* | id: *"..src.."*) reveived item; name: **"..fromItemData.name.."**, count: **" .. fromCount.. "** stash: *" .. LabId .. "*")
				end
				Player.addInventoryItem(fromItemData.name, fromCount, toSlot, fromItemData.info)
			else
				local toItemData = exports['PX_labs']:GetInventoryData(LabId, toSlot)
				if toItemData ~= nil then
					local itemInfo = ESX.Items[toItemData.name:lower()]
					local toCount = tonumber(toCount) ~= nil and tonumber(toCount) or toItemData.count
					if toItemData.name ~= fromItemData.name then
						local itemInfo = ESX.Items[toItemData.name:lower()]
						exports['PX_labs']:RemoveProduct(LabId, toSlot, itemInfo.name, toCount)
						exports['PX_labs']:AddProduct(LabId, fromSlot, itemInfo.name, toCount, toItemData.info, true)
					end
				end
				local itemInfo = ESX.Items[fromItemData.name:lower()]
				if toSlot ~= 2 then
					exports['PX_labs']:RemoveProduct(LabId, fromSlot, itemInfo.name, fromCount)
					exports['PX_labs']:AddProduct(LabId, toSlot, itemInfo.name, fromCount, fromItemData.info, src)
				else
					TriggerClientEvent("PX_inventory:client:close:inventory", src)
					TriggerClientEvent("PX_inventory:client:UpdatePlayerInventory", src, true)
				end
			end
		else
			TriggerClientEvent("esx:showNotification", src, "Item bestaat niet??")
		end
	elseif ESX.SplitStr(fromInventory, "-")[1] == "itemshop" then
		local shopType = ESX.SplitStr(fromInventory, "-")[2]
		local itemData = ShopItems[shopType].items[fromSlot]
		local itemInfo = ESX.Items[itemData.name:lower()]
		local price = tonumber((itemData.price*fromCount))
		if ESX.SplitStr(shopType, "_")[1] == "Dealer" then
			if ESX.SplitStr(itemData.name, "_")[1] == "weapon" then
				price = tonumber(itemData.price)
				if Player.removeMoney(price) then
					itemData.info.quality = 100.0
				    itemData.info.serie = tostring(Config.RandomInt(2) .. Config.RandomStr(3) .. Config.RandomInt(1) .. Config.RandomStr(2) .. Config.RandomInt(3) .. Config.RandomStr(4))
					Player.addInventoryItem(itemData.name, 1, toSlot, itemData.info)
					TriggerClientEvent("PX_inventory:client:UpdatePlayerInventory", src, false)
					TriggerClientEvent('PX_dealers:client:update:dealer:items', src, itemData, 1)
					TriggerClientEvent('esx:showNotification', src, itemInfo.label .. " bought!")
					--TriggerEvent("PX_logs:server:SendLog", "dealers", "Dealer item gekocht", "green", "**"..GetPlayerName(src) .. "** heeft een " .. itemInfo.label .. " gekocht voor €"..price)
				else
					TriggerClientEvent("PX_inventory:client:UpdatePlayerInventory", src, true)
					TriggerClientEvent('esx:showNotification', src, "You dont have enough cash..")
				end
			else
				if Player.removeMoney(price) then
					Player.addInventoryItem(itemData.name, fromCount, toSlot, itemData.info)
					TriggerClientEvent('PX_dealers:client:update:dealer:items', src, itemData, fromCount)
					TriggerClientEvent('esx:showNotification', src, itemInfo.label .. " bought!")
					TriggerClientEvent("PX_inventory:client:UpdatePlayerInventory", src, false)
					--TriggerEvent("PX_logs:server:SendLog", "dealers", "Dealer item gekocht", "green", "**"..GetPlayerName(src) .. "** heeft een " .. itemInfo.label .. " gekocht voor €"..price)
				else
					TriggerClientEvent("PX_inventory:client:UpdatePlayerInventory", src, true)
					TriggerClientEvent('esx:showNotification', src, "You dont have enough cash..")
				end
			end
		elseif ESX.SplitStr(shopType, "_")[1] == "custom" then
			if Player.removeMoney(price) then
				Player.addInventoryItem(itemData.name, fromCount, toSlot, itemData.info)
				TriggerClientEvent("PX_inventory:client:UpdatePlayerInventory", src, false)
				TriggerClientEvent('esx:showNotification', src, itemInfo.label .. " bought!")
			else
				TriggerClientEvent("PX_inventory:client:UpdatePlayerInventory", src, true)
				TriggerClientEvent('esx:showNotification', src, "You dont have enough cash..")
			end
		elseif ESX.SplitStr(shopType, "_")[1] == "police" then
			--edit Phoenix Development Team
			if Player.removeMoney(price) then
				if itemData.name == "weapon_pistol_mk2" or itemData.name == "weapon_carbinerifle_mk2" or itemData.name == "weapon_sawnoffshotgun" then
					-- TriggerEvent("PX_logs:server:SendLog", "policeshop", "Get Weapon From Armory", "green", "**"..Player.firstname.." "..Player.lastname.. "** ("..itemInfo.label.." | "..itemData.info.serie..")")
				end
				Player.addInventoryItem(itemData.name, fromCount, toSlot, itemData.info)
				TriggerClientEvent("PX_inventory:client:UpdatePlayerInventory", src, false)
				TriggerClientEvent('esx:showNotification', src, itemInfo.label .. " bought!")
			else
				TriggerClientEvent("PX_inventory:client:UpdatePlayerInventory", src, true)
				TriggerClientEvent('esx:showNotification', src, "You dont have enough cash..")
			end
		elseif ESX.SplitStr(shopType, "_")[1] == "Itemshop" then
			if ESX.SplitStr(itemData.name, "_")[1] == "weapon" then
				if Player.removeMoney(price) then
					itemData.info.quality = 100.0
				    itemData.info.serie = tostring(Config.RandomInt(2) .. Config.RandomStr(3) .. Config.RandomInt(1) .. Config.RandomStr(2) .. Config.RandomInt(3) .. Config.RandomStr(4))
					Player.addInventoryItem(itemData.name, 1, toSlot, itemData.info)
					TriggerClientEvent("PX_inventory:client:UpdatePlayerInventory", src, false)
					TriggerClientEvent('PX_stores:client:update:store', src, itemData, fromCount)
					TriggerClientEvent('esx:showNotification', src, itemInfo.label .. " bought!")
					--TriggerEvent("PX_logs:server:SendLog", "policeshop", "Buy Weapon Frop GunShop", "green", "**"..Player.firstname.." "..Player.lastname.. "** ("..itemInfo.label.." | "..itemData.info.serie..")")
				else
					TriggerClientEvent("PX_inventory:client:UpdatePlayerInventory", src, true)
					TriggerClientEvent('esx:showNotification', src, "You dont have enough cash..")
				end
			else
				if Player.removeMoney(price) then
					if itemData.name == 'duffel-bag' then itemData.info.bagid = math.random(11111,99999) elseif itemData.name == 'burger-box' then itemData.info.boxid = math.random(11111,99999) end	
					Player.addInventoryItem(itemData.name, fromCount, toSlot, itemData.info)
					TriggerClientEvent("PX_inventory:client:UpdatePlayerInventory", src, false)
					TriggerClientEvent('PX_stores:client:update:store', src, itemData, fromCount)
					TriggerClientEvent('esx:showNotification', src, itemInfo.label .. " bought!")
					--TriggerEvent("PX_logs:server:SendLog", "shops", "Shop item gekocht", "green", "**"..GetPlayerName(src) .. "** heeft een " .. itemInfo.label .. " gekocht voor €"..price)
				else
					TriggerClientEvent("PX_inventory:client:UpdatePlayerInventory", src, true)
					TriggerClientEvent('esx:showNotification', src, "You dont have enough cash..")
				end
			end
		elseif ESX.SplitStr(shopType, "_")[1] == "Cokebrick" then
			if Player.removeMoney(price) then
				Player.addInventoryItem(itemData.name, fromCount, toSlot, itemData.info)
				TriggerClientEvent("PX_inventory:client:close:inventory", src)
				TriggerClientEvent("PX_inventory:client:UpdatePlayerInventory", src, false)
				--TriggerEvent("PX_logs:server:SendLog", "shops", "Shop item gekocht", "green", "**"..GetPlayerName(src) .. "** heeft een " .. itemInfo.label .. " gekocht voor €"..price)
			else
				TriggerClientEvent("PX_inventory:client:UpdatePlayerInventory", src, true)
			end
		elseif ESX.SplitStr(shopType, "_")[1] == "StreetDealer" then
			if Player.removeInventoryItem('money-roll', price) then
				Player.addInventoryItem(itemData.name, fromCount, toSlot, itemData.info)
				TriggerClientEvent("PX_inventory:client:UpdatePlayerInventory", src, false)
				TriggerClientEvent('esx:showNotification', src, itemInfo.label .. " ingekocht!")
				--TriggerEvent("PX_logs:server:SendLog", "shops", "Shop item gekocht", "green", "**"..GetPlayerName(src) .. "** heeft een " .. itemInfo.label .. " gekocht voor €"..price)
			else
				TriggerClientEvent("PX_inventory:client:UpdatePlayerInventory", src, true)
				TriggerClientEvent('esx:showNotification', src, "You dont have enough money-rolls")
			end
		else
			if Player.removeMoney(price) then
				Player.addInventoryItem(itemData.name, fromCount, toSlot, itemData.info)
				TriggerClientEvent('esx:showNotification', src, itemInfo.label .. " gekocht!")
				--TriggerEvent("PX_logs:server:SendLog", "shops", "Shop item gekocht", "green", "**"..GetPlayerName(src) .. "** heeft een " .. itemInfo.label .. " gekocht voor €"..price)
			else
				TriggerClientEvent("PX_inventory:client:UpdatePlayerInventory", src, true)
				TriggerClientEvent('esx:showNotification', src, "You dont have enough cash..")
			end
		end
	elseif fromInventory == "crafting" then
		local itemData = exports['PX_crafting']:GetCraftingConfig(fromSlot)
		if hasCraftItems(src, itemData.costs, fromCount) then
			Player.set("inventorydisabled", true)
			TriggerClientEvent("PX_inventory:client:CraftItems", src, itemData.name, itemData.costs, fromCount, toSlot, itemData.points)
		else
			TriggerClientEvent("PX_inventory:client:UpdatePlayerInventory", src, true)
			TriggerClientEvent('esx:showNotification', src, "Je hebt niet de juiste items..")
		end
	elseif fromInventory == "crafting_weapon" then
		local itemData = exports['PX_crafting']:GetWeaponCraftingConfig(fromSlot)
		if hasCraftItems(src, itemData.costs, fromCount) then
			Player.set("inventorydisabled", true)
			TriggerClientEvent("PX_inventory:client:CraftWeapon", src, itemData.name, itemData.costs, fromCount, toSlot, itemData.type)
		else
			TriggerClientEvent("PX_inventory:client:UpdatePlayerInventory", src, true)
			TriggerClientEvent('esx:showNotification', src, "Je hebt niet de juiste items..")
		end
	elseif fromInventory == "cokecrafting" then
		local itemData = exports['PX_labs']:GetCokeCrafting(fromSlot)
		if hasCraftItems(src, itemData.costs, fromCount) then
			Player.set("inventorydisabled", true)
			TriggerClientEvent("PX_inventory:client:CraftItems", src, itemData.name, itemData.costs, fromCount, toSlot, itemData.type)
		else
			TriggerClientEvent("PX_inventory:client:UpdatePlayerInventory", src, true)
			TriggerClientEvent('esx:showNotification', src, "Je hebt niet de juiste items..")
		end
	elseif fromInventory == "methcrafting" then
		local itemData = exports['PX_labs']:GetMethCrafting(fromSlot)
		if hasCraftItems(src, itemData.costs, fromCount) then
			Player.set("inventorydisabled", true)
			TriggerClientEvent("PX_inventory:client:CraftItems", src, itemData.name, itemData.costs, fromCount, toSlot, itemData.type)
		else
			TriggerClientEvent("PX_inventory:client:UpdatePlayerInventory", src, true)
			TriggerClientEvent('esx:showNotification', src, "Je hebt niet de juiste items..")
		end
	else
		-- drop
		fromInventory = tonumber(fromInventory)
		local fromItemData = Drops[fromInventory].items[fromSlot]
		local fromCount = tonumber(fromCount) ~= nil and tonumber(fromCount) or fromItemData.count
		if fromItemData ~= nil and fromItemData.count >= fromCount then
			local itemInfo = ESX.Items[fromItemData.name:lower()]
			if toInventory == "player" or toInventory == "hotbar" then
				local toItemData = Player.GetItemBySlot(toSlot)
				RemoveFromDrop(fromInventory, fromSlot, itemInfo.name, fromCount)
				if toItemData ~= nil then
					local toCount = tonumber(toCount) ~= nil and tonumber(toCount) or toItemData.count
					if toItemData.name ~= fromItemData.name then
						Player.removeInventoryItem(toItemData.name, toCount, toSlot)
						AddToDrop(fromInventory, toSlot, itemInfo.name, toCount, toItemData.info)
						if itemInfo.name == "radio" then
						TriggerClientEvent('PX_radio:onRadioDrop', src)
						end
						--TriggerEvent("PX_logs:server:SendLog", "drop", "Swapped Item", "orange", "**".. GetPlayerName(src) .. "** (citizenid: *"..Player.identifier.."* | id: *"..src.."*) swapped item; name: **"..toItemData.name.."**, count: **" .. toCount .. "** with item; name: **"..fromItemData.name.."**, count: **" .. fromCount .. "** - dropid: *" .. fromInventory .. "*")
					else
						--TriggerEvent("PX_logs:server:SendLog", "drop", "Stacked Item", "orange", "**".. GetPlayerName(src) .. "** (citizenid: *"..Player.identifier.."* | id: *"..src.."*) stacked item; name: **"..toItemData.name.."**, count: **" .. toCount .. "** - from dropid: *" .. fromInventory .. "*")
					end
				else
					--TriggerEvent("PX_logs:server:SendLog", "drop", "Received Item", "green", "**".. GetPlayerName(src) .. "** (citizenid: *"..Player.identifier.."* | id: *"..src.."*) reveived item; name: **"..fromItemData.name.."**, count: **" .. fromCount.. "** -  dropid: *" .. fromInventory .. "*")
				end
				Player.addInventoryItem(fromItemData.name, fromCount, toSlot, fromItemData.info)
			else
				toInventory = tonumber(toInventory)
				local toItemData = Drops[toInventory].items[toSlot]
				RemoveFromDrop(fromInventory, fromSlot, itemInfo.name, fromCount)
				--Player.inventory[toSlot] = fromItemData
				if toItemData ~= nil then
					local itemInfo = ESX.Items[toItemData.name:lower()]
					--Player.inventory[fromSlot] = toItemData
					local toCount = tonumber(toCount) ~= nil and tonumber(toCount) or toItemData.count
					if toItemData.name ~= fromItemData.name then
						local itemInfo = ESX.Items[toItemData.name:lower()]
						RemoveFromDrop(toInventory, toSlot, itemInfo.name, toCount)
						AddToDrop(fromInventory, fromSlot, itemInfo.name, toCount, toItemData.info)
						if itemInfo.name == "radio" then
							TriggerClientEvent('PX_radio:onRadioDrop', src)
						end
					end
				else
					--Player.inventory[fromSlot] = nil
				end
				local itemInfo = ESX.Items[fromItemData.name:lower()]
				AddToDrop(toInventory, toSlot, itemInfo.name, fromCount, fromItemData.info)
				if itemInfo.name == "radio" then
			    	TriggerClientEvent('PX_radio:onRadioDrop', src)
				end
			end
		else
			TriggerClientEvent("esx:showNotification", src, "Item does not exists??")
		end
	end
end)

function hasCraftItems(source, CostItems, count)
	local Player = ESX.GetPlayerFromId(source)
	for k, v in pairs(CostItems) do
		if Player.getInventoryItem(k) ~= nil then
			if Player.getInventoryItem(k).count < (v * count) then
				return false
			end
		else
			return false
		end
	end
	return true
end

function IsVehicleOwned(plate)
	local val = false
	local wait = promise.new()
	MySQL.query("SELECT * FROM `owned_vehicles` WHERE `plate` = '"..plate.."'", function(result)
		if (result[1] ~= nil) then
			val = true
			wait:resolve(val)
		else
			val = false
			wait:resolve(val)
		end
	end)
	return Citizen.Await(wait)
end

-- Shop Items
function SetupShopItems(shop, shopItems)
	local items = {}
	if shopItems ~= nil and next(shopItems) ~= nil then
		for k, item in pairs(shopItems) do
			local itemInfo = ESX.Items[item.name:lower()]
			items[item.slot] = {
				name = itemInfo.name,
				count = tonumber(item.count),
				info = item.info ~= nil and item.info or "",
				label = itemInfo.label,
				description = itemInfo.description ~= nil and itemInfo.description or "",
				weight = itemInfo.weight, 
				type = itemInfo.type, 
				unique = itemInfo.unique, 
				useable = itemInfo.useable, 
				price = item.price,
				image = itemInfo.image,
				slot = item.slot,
			}
		end
	end
	return items
end

function ItemsInStash(stashId)
    local items = {}
    local wait = promise.new()
        MySQL.query("SELECT * FROM inventory_stash WHERE stash = '"..stashId.."'", function(result)
            if result[1] ~= nil then
                if result[1].items ~= nil then
                    result[1].items = json.decode(result[1].items)
                    if (result[1].items ~= nil) then 
                        wait:resolve(result[1].items)
                        for k, item in pairs(result[1].items) do
                            local itemInfo = ESX.Items[item.name:lower()]
                            items[item.slot] = {
                                name = itemInfo.name,
                                count = tonumber(item.count),
                                info = item.info ~= nil and item.info or "",
                                label = itemInfo.label,
                                description = itemInfo.description ~= nil and itemInfo.description or "",
                                weight = itemInfo.weight, 
                                type = itemInfo.type, 
                                unique = itemInfo.unique, 
                                useable = itemInfo.useable, 
                                image = itemInfo.image,
                                slot = item.slot,
                            }
                        end
                    end
                end
            end
        end)
    return Citizen.Await(wait)
end

ESX.RegisterServerCallback('PX_inventory:server:ItemsInStash', function(source, cb, stashId)
	cb(ItemsInStash(stashId))
end)

RegisterServerEvent('PX_inventory:server:SaveStashItems')
AddEventHandler('PX_inventory:server:SaveStashItems', function(stashId, items)
	MySQL.query("SELECT * FROM `inventory_stash` WHERE `stash` = '"..stashId.."'", function(result)
		if result[1] ~= nil then
			MySQL.query("UPDATE `inventory_stash` SET `items` = '"..json.encode(items).."' WHERE `stash` = '"..stashId.."'")
		else
			MySQL.query("INSERT INTO `inventory_stash` (`stash`, `items`) VALUES ('"..stashId.."', '"..json.encode(items).."')")
		end
	end)
end)

function SaveStashItems(stashId, items)
	if Stashes[stashId].label ~= "Stash-None" then
		if items ~= nil then
			for slot, item in pairs(items) do
				item.description = nil
			end
			MySQL.query("SELECT * FROM `inventory_stash` WHERE `stash` = '"..stashId.."'", function(result)
				if result[1] ~= nil then
					MySQL.query("UPDATE `inventory_stash` SET `items` = '"..json.encode(items).."' WHERE `stash` = '"..stashId.."'")
					Stashes[stashId].isOpen = false
				else
					MySQL.query("INSERT INTO `inventory_stash` (`stash`, `items`) VALUES ('"..stashId.."', '"..json.encode(items).."')")
					Stashes[stashId].isOpen = false
				end
			end)
		end
	end
end

function AddToStash(stashId, slot, otherslot, itemName, count, info)
	local count = tonumber(count)
	local ItemData = ESX.Items[itemName]
	if not ItemData.unique then
		if Stashes[stashId].items[slot] ~= nil and Stashes[stashId].items[slot].name == itemName then
			Stashes[stashId].items[slot].count = Stashes[stashId].items[slot].count + count
		else
			local itemInfo = ESX.Items[itemName:lower()]
			Stashes[stashId].items[slot] = {
				name = itemInfo.name,
				count = count,
				info = info ~= nil and info or "",
				label = itemInfo.label,
				description = itemInfo.description ~= nil and itemInfo.description or "",
				weight = itemInfo.weight, 
				type = itemInfo.type, 
				unique = itemInfo.unique, 
				useable = itemInfo.useable, 
				image = itemInfo.image,
				slot = slot,
			}
		end
	else
		if Stashes[stashId].items[slot] ~= nil and Stashes[stashId].items[slot].name == itemName then
			local itemInfo = ESX.Items[itemName:lower()]
			Stashes[stashId].items[otherslot] = {
				name = itemInfo.name,
				count = count,
				info = info ~= nil and info or "",
				label = itemInfo.label,
				description = itemInfo.description ~= nil and itemInfo.description or "",
				weight = itemInfo.weight, 
				type = itemInfo.type, 
				unique = itemInfo.unique, 
				useable = itemInfo.useable, 
				image = itemInfo.image,
				slot = otherslot,
			}
		else
			local itemInfo = ESX.Items[itemName:lower()]
			Stashes[stashId].items[slot] = {
				name = itemInfo.name,
				count = count,
				info = info ~= nil and info or "",
				label = itemInfo.label,
				description = itemInfo.description ~= nil and itemInfo.description or "",
				weight = itemInfo.weight, 
				type = itemInfo.type, 
				unique = itemInfo.unique, 
				useable = itemInfo.useable, 
				image = itemInfo.image,
				slot = slot,
			}
		end
	end
end

function RemoveFromStash(stashId, slot, itemName, count)
	local count = tonumber(count)
	if Stashes[stashId].items[slot] ~= nil and Stashes[stashId].items[slot].name == itemName then
		if Stashes[stashId].items[slot].count > count then
			Stashes[stashId].items[slot].count = Stashes[stashId].items[slot].count - count
		else
			Stashes[stashId].items[slot] = nil
			if next(Stashes[stashId].items) == nil then
				Stashes[stashId].items = {}
			end
		end
	else
		Stashes[stashId].items[slot] = nil
		if Stashes[stashId].items == nil then
			Stashes[stashId].items[slot] = nil
		end
	end
end

-- Trunk items
function GetOwnedVehicleItems(plate)
	local items = {}
	   MySQL.query("SELECT * FROM `owned_vehicles` WHERE `plate` = '"..plate.."'", function(result)
	   	if result[1] ~= nil then
	   		if result[1].trunkitems ~= nil then
	   			result[1].trunkitems = json.decode(result[1].trunkitems)
	   			if result[1].trunkitems ~= nil then 
	   				for k, item in pairs(result[1].trunkitems) do
	   					local itemInfo = ESX.Items[item.name:lower()]
	   					items[item.slot] = {
	   						name = itemInfo.name,
	   						count = tonumber(item.count),
	   						info = item.info ~= nil and item.info or "",
	   						label = itemInfo.label,
	   						description = itemInfo.description ~= nil and itemInfo.description or "",
	   						weight = itemInfo.weight, 
	   						type = itemInfo.type, 
	   						unique = itemInfo.unique, 
	   						useable = itemInfo.useable, 
	   						image = itemInfo.image,
	   						slot = item.slot,
	   					}
	   				end
	   			end
	   		end
	   	end
	   end)
	return items
end

function SaveOwnedVehicleItems(plate, items)
	if Trunks[plate].label ~= "Trunk-None" then
		if items ~= nil then
			for slot, item in pairs(items) do
				item.description = nil
			end

			MySQL.query("SELECT * FROM `owned_vehicles` WHERE `plate` = '"..plate.."'", function(result)
				if result[1] ~= nil then
					MySQL.query("UPDATE `owned_vehicles` SET `trunkitems` = '"..json.encode(items).."' WHERE `plate` = '"..plate.."'", function(result) 
						Trunks[plate].isOpen = false
					end)
				else
					MySQL.query("INSERT INTO `owned_vehicles` (`plate`, `trunkitems`) VALUES ('"..plate.."', '"..json.encode(items).."')", function(result) 
						Trunks[plate].isOpen = false
					end)
				end
			end)
		end
	end
end

function AddToTrunk(plate, slot, otherslot, itemName, count, info)
	local count = tonumber(count)
	local ItemData = ESX.Items[itemName]

	if not ItemData.unique then
		if Trunks[plate].items[slot] ~= nil and Trunks[plate].items[slot].name == itemName then
			Trunks[plate].items[slot].count = Trunks[plate].items[slot].count + count
		else
			local itemInfo = ESX.Items[itemName:lower()]
			Trunks[plate].items[slot] = {
				name = itemInfo.name,
				count = count,
				info = info ~= nil and info or "",
				label = itemInfo.label,
				description = itemInfo.description ~= nil and itemInfo.description or "",
				weight = itemInfo.weight, 
				type = itemInfo.type, 
				unique = itemInfo.unique, 
				useable = itemInfo.useable, 
				image = itemInfo.image,
				slot = slot,
			}
		end
	else
		if Trunks[plate].items[slot] ~= nil and Trunks[plate].items[slot].name == itemName then
			local itemInfo = ESX.Items[itemName:lower()]
			Trunks[plate].items[otherslot] = {
				name = itemInfo.name,
				count = count,
				info = info ~= nil and info or "",
				label = itemInfo.label,
				description = itemInfo.description ~= nil and itemInfo.description or "",
				weight = itemInfo.weight, 
				type = itemInfo.type, 
				unique = itemInfo.unique, 
				useable = itemInfo.useable, 
				image = itemInfo.image,
				slot = otherslot,
			}
		else
			local itemInfo = ESX.Items[itemName:lower()]
			Trunks[plate].items[slot] = {
				name = itemInfo.name,
				count = count,
				info = info ~= nil and info or "",
				label = itemInfo.label,
				description = itemInfo.description ~= nil and itemInfo.description or "",
				weight = itemInfo.weight, 
				type = itemInfo.type, 
				unique = itemInfo.unique, 
				useable = itemInfo.useable, 
				image = itemInfo.image,
				slot = slot,
			}
		end
	end
end

function RemoveFromTrunk(plate, slot, itemName, count)
	if Trunks[plate].items[slot] ~= nil and Trunks[plate].items[slot].name == itemName then
		if Trunks[plate].items[slot].count > count then
			Trunks[plate].items[slot].count = Trunks[plate].items[slot].count - count
		else
			Trunks[plate].items[slot] = nil
			if next(Trunks[plate].items) == nil then
				Trunks[plate].items = {}
			end
		end
	else
		Trunks[plate].items[slot]= nil
		if Trunks[plate].items == nil then
			Trunks[plate].items[slot] = nil
		end
	end
end

-- Glovebox items
function GetOwnedVehicleGloveboxItems(plate)
	local items = {}
	MySQL.query("SELECT * FROM `owned_vehicles` WHERE `plate` = '"..plate.."'", function(result)
			if result[1] ~= nil then 
				if result[1].gloveboxitems ~= nil then
					result[1].gloveboxitems = json.decode(result[1].gloveboxitems)
					if result[1].gloveboxitems ~= nil then 
						for k, item in pairs(result[1].gloveboxitems) do
							local itemInfo = ESX.Items[item.name:lower()]
							items[item.slot] = {
								name = itemInfo.name,
								count = tonumber(item.count),
								info = item.info ~= nil and item.info or "",
								label = itemInfo.label,
								description = itemInfo.description ~= nil and itemInfo.description or "",
								weight = itemInfo.weight, 
								type = itemInfo.type, 
								unique = itemInfo.unique, 
								useable = itemInfo.useable, 
								image = itemInfo.image,
								slot = item.slot,
							}
						end
					end
				end
			end
		end)
	return items
end

function SaveOwnedGloveboxItems(plate, items)
	if Gloveboxes[plate].label ~= "Glovebox-None" then
		if items ~= nil then
			for slot, item in pairs(items) do
				item.description = nil
			end

			MySQL.query("SELECT * FROM `owned_vehicles` WHERE `plate` = '"..plate.."'", function(result)
				if result[1] ~= nil then
					MySQL.query("UPDATE `owned_vehicles` SET `gloveboxitems` = '"..json.encode(items).."' WHERE `plate` = '"..plate.."'", function(result) 
						Gloveboxes[plate].isOpen = false
					end)
				else
					MySQL.query("INSERT INTO `owned_vehicles` (`plate`, `gloveboxitems`) VALUES ('"..plate.."', '"..json.encode(items).."')", function(result) 
						Gloveboxes[plate].isOpen = false
					end)
				end
			end)
		end
	end
end

function AddToGlovebox(plate, slot, otherslot, itemName, count, info)
	local count = tonumber(count)
	local ItemData = ESX.Items[itemName]

	if not ItemData.unique then
		if Gloveboxes[plate].items[slot] ~= nil and Gloveboxes[plate].items[slot].name == itemName then
			Gloveboxes[plate].items[slot].count = Gloveboxes[plate].items[slot].count + count
		else
			local itemInfo = ESX.Items[itemName:lower()]
			Gloveboxes[plate].items[slot] = {
				name = itemInfo.name,
				count = count,
				info = info ~= nil and info or "",
				label = itemInfo.label,
				description = itemInfo.description ~= nil and itemInfo.description or "",
				weight = itemInfo.weight, 
				type = itemInfo.type, 
				unique = itemInfo.unique, 
				useable = itemInfo.useable, 
				image = itemInfo.image,
				slot = slot,
			}
		end
	else
		if Gloveboxes[plate].items[slot] ~= nil and Gloveboxes[plate].items[slot].name == itemName then
			local itemInfo = ESX.Items[itemName:lower()]
			Gloveboxes[plate].items[otherslot] = {
				name = itemInfo.name,
				count = count,
				info = info ~= nil and info or "",
				label = itemInfo.label,
				description = itemInfo.description ~= nil and itemInfo.description or "",
				weight = itemInfo.weight, 
				type = itemInfo.type, 
				unique = itemInfo.unique, 
				useable = itemInfo.useable, 
				image = itemInfo.image,
				slot = otherslot,
			}
		else
			local itemInfo = ESX.Items[itemName:lower()]
			Gloveboxes[plate].items[slot] = {
				name = itemInfo.name,
				count = count,
				info = info ~= nil and info or "",
				label = itemInfo.label,
				description = itemInfo.description ~= nil and itemInfo.description or "",
				weight = itemInfo.weight, 
				type = itemInfo.type, 
				unique = itemInfo.unique, 
				useable = itemInfo.useable, 
				image = itemInfo.image,
				slot = slot,
			}
		end
	end
end

function RemoveFromGlovebox(plate, slot, itemName, count)
	if Gloveboxes[plate].items[slot] ~= nil and Gloveboxes[plate].items[slot].name == itemName then
		if Gloveboxes[plate].items[slot].count > count then
			Gloveboxes[plate].items[slot].count = Gloveboxes[plate].items[slot].count - count
		else
			Gloveboxes[plate].items[slot] = nil
			if next(Gloveboxes[plate].items) == nil then
				Gloveboxes[plate].items = {}
			end
		end
	else
		Gloveboxes[plate].items[slot]= nil
		if Gloveboxes[plate].items == nil then
			Gloveboxes[plate].items[slot] = nil
		end
	end
end

-- Drop items
function AddToDrop(dropId, slot, itemName, count, info)
	local count = tonumber(count)
	if Drops[dropId].items[slot] ~= nil and Drops[dropId].items[slot].name == itemName then
		Drops[dropId].items[slot].count = Drops[dropId].items[slot].count + count
	else
		local itemInfo = ESX.Items[itemName:lower()]
		Drops[dropId].items[slot] = {
			name = itemInfo.name,
			count = count,
			info = info ~= nil and info or "",
			label = itemInfo.label,
			description = itemInfo.description ~= nil and itemInfo.description or "",
			weight = itemInfo.weight, 
			type = itemInfo.type, 
			unique = itemInfo.unique, 
			useable = itemInfo.useable, 
			image = itemInfo.image,
			slot = slot,
			id = dropId,
		}
	end
end

function RemoveFromDrop(dropId, slot, itemName, count)
	if Drops[dropId].items[slot] ~= nil and Drops[dropId].items[slot].name == itemName then
		if Drops[dropId].items[slot].count > count then
			Drops[dropId].items[slot].count = Drops[dropId].items[slot].count - count
		else
			Drops[dropId].items[slot] = nil
			if next(Drops[dropId].items) == nil then
				Drops[dropId].items = {}
			end
		end
	else
		Drops[dropId].items[slot] = nil
		if Drops[dropId].items == nil then
			Drops[dropId].items[slot] = nil
		end
	end
end

function CreateDropId()
	if Drops ~= nil then
		local id = math.random(10000, 99999)
		local dropid = id
		while Drops[dropid] ~= nil do
			id = math.random(10000, 99999)
			dropid = id
		end
		return dropid
	else
		local id = math.random(10000, 99999)
		local dropid = id
		return dropid
	end
end

function CreateNewDrop(source, fromSlot, toSlot, itemCount)
	local Player = ESX.GetPlayerFromId(source)
	local itemData = Player.GetItemBySlot(fromSlot)
	if Player.removeInventoryItem(itemData.name, itemCount, itemData.slot) then
		TriggerClientEvent("PX_inventory:client:CheckWeapon", source, itemData.name)
		local itemInfo = ESX.Items[itemData.name:lower()]
		local dropId = CreateDropId()
		Drops[dropId] = {}
		Drops[dropId].items = {}

		Drops[dropId].items[toSlot] = {
			name = itemInfo.name,
			count = itemCount,
			info = itemData.info ~= nil and itemData.info or "",
			label = itemInfo.label,
			description = itemInfo.description ~= nil and itemInfo.description or "",
			weight = itemInfo.weight, 
			type = itemInfo.type, 
			unique = itemInfo.unique, 
			useable = itemInfo.useable, 
			image = itemInfo.image,
			slot = toSlot,
			id = dropId,
		}
		--TriggerEvent("PX_logs:server:SendLog", "drop", "New Item Drop", "red", "**".. GetPlayerName(source) .. "** (citizenid: *"..Player.identifier.."* | id: *"..source.."*) dropped new item; name: **"..itemData.name.."**, count: **" .. itemCount .. "**")
		TriggerClientEvent("PX_inventory:client:DropItemAnim", source)
		TriggerClientEvent("PX_inventory:client:AddDropItem", -1, dropId, source)
		if itemData.name:lower() == "radio" then
		TriggerClientEvent('PX_radio:onRadioDrop', source)
		end
	else
		TriggerClientEvent("esx:showNotification", src, "You dont have the item!")
		return
	end
end

TriggerEvent('es:addAdminCommand', 'giveitem', 8, function(source, args, user)
	local xPlayer = ESX.GetPlayerFromId(source)
	local Player = ESX.GetPlayerFromId(tonumber(args[1]))
	local count = tonumber(args[3])
	local itemData = ESX.Items[tostring(args[2]):lower()]
	if Player ~= nil then
		if count > 0 then
			if itemData ~= nil then
				if Player.addInventoryItem(itemData.name, count, false) then
					TriggerClientEvent('esx:showNotification', source, "You gave " ..GetPlayerName(tonumber(args[1])).." " .. itemData.name .. " ("..count.. ")")
				else
					TriggerClientEvent('esx:showNotification', source,  "Can not give the item")
				end
			else
				TriggerClientEvent('chatMessage', source, "[SYSTEM] ", {255, 0, 0}, "Item does not exist!")
			end
		else
			TriggerClientEvent('chatMessage', source, "[SYSTEM] ", {255, 0, 0}, "Count has to be higher then 0!")
		end
	else
		TriggerClientEvent('chatMessage', source, "[SYSTEM] ", {255, 0, 0}, "Player not online")
	end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = "Give Item", params = {{name = "id", help = "ID Player"}, {name = "item", help = "Item Name"}, {name = "amount", help = "Amount"}}})

RegisterServerEvent("PX_inventory:givecash")
AddEventHandler("PX_inventory:givecash", function(id, numb)
	if #(GetEntityCoords(GetPlayerPed(source)) - GetEntityCoords(GetPlayerPed(id))) >= 5 then return end
	local xPlayer = ESX.GetPlayerFromId(source)
	local zPlayer = ESX.GetPlayerFromId(id)
	local cash = tonumber(numb)
	if xPlayer.money >= cash then
		TriggerClientEvent("PX_inventory:doCashAnimation", xPlayer.source)
		xPlayer.removeMoney(cash)
		zPlayer.addMoney(cash)
		TriggerClientEvent("esx:showNotification", zPlayer.source, "Shoma "..cash.."$ Daryaft Kardid!")
	else
		TriggerClientEvent("esx:showNotification", source, "Shoma Pool Kafi Nadarid!")
	end
end)
