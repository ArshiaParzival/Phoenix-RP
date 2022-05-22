ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

Banks = Config.Banks
Safes = Config.Safes
		
RegisterServerEvent('PX_bankrobbery:SafeDataSV')
AddEventHandler('PX_bankrobbery:SafeDataSV', function(type, id, state)
	local xPlayer = ESX.GetPlayerFromId(source)
	if type == "robbed" then
		Safes[id].robbed = state
	elseif type == "failed" then
		Safes[id].failed = state
	end
	Wait(100)
	TriggerClientEvent('PX_bankrobbery:SafeDataCL', -1, type, id, state)
end)

RegisterServerEvent('PX_bankrobbery:ResetCurrentBankSV')
AddEventHandler('PX_bankrobbery:ResetCurrentBankSV', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	
	-- Banks:
    for i = 1, #Banks do
		Banks[i].inUse = false
		Banks[i].keypads[1].hacked = false
		Banks[i].keypads[2].hacked = false
		Banks[i].deskDoor.lockpicked = false
		for k,v in pairs(Banks[i].deskCash) do
			v.robbed = false
		end
		Banks[i].powerBox.disabled = false
		if i == 8 then
			Banks[i].safe.cracked = false
		end
	end
	
	alertTime = nil

	-- Safes:
	for i = 1, #Safes do
		Safes[i].robbed = false
		Safes[i].failed = false
    end
	TriggerClientEvent('PX_bankrobbery:ResetCurrentBankCL', -1)

	-- Secure News:
	local xPlayers = ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'police' or xPlayer.job.name == 'dadgostari' or xPlayer.job.name == 'ambulance' or xPlayer.job.name == 'weazel' then
			TriggerClientEvent('chatMessage', xPlayers[i], "^2News: | ^7", { 128, 128, 128 }, string.sub('Bank Ha Amn Shodan Va Shoro Be Kar Kardand!',0))
		end
	end
end) 

-- Drill:
ESX.RegisterServerCallback('PX_bankrobbery:drillItem',function(source,cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local gotItem = xPlayer.getInventoryItem(Config.DrillItem).count >= 1
	if gotItem then
		xPlayer.removeInventoryItem(Config.DrillItem, 1)
		cb(true)
	else
		cb(false)
	end
end)

-- Hacker Device:
ESX.RegisterServerCallback('PX_bankrobbery:hackerDevice',function(source,cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local gotItem = xPlayer.getInventoryItem(Config.HackItem ).count >= 1
	if gotItem then
		xPlayer.removeInventoryItem(Config.HackItem ,1)
		cb(true)
	else
		cb(false)
	end
end)

-- Lockpick:
ESX.RegisterServerCallback('PX_bankrobbery:lockpickItem',function(source,cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local gotItem = xPlayer.getInventoryItem(Config.LockPick).count >= 1
	if gotItem then
		xPlayer.removeInventoryItem(Config.LockPick ,1)
		cb(true)
	else
		cb(false)
	end
end)

-- Hammer & WireCutter:
ESX.RegisterServerCallback('PX_bankrobbery:hammerWireCutterItem',function(source,cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local gotItem = xPlayer.getInventoryItem(Config.HammerWireCutter).count >= 1
	if gotItem then
		xPlayer.removeInventoryItem(Config.HammerWireCutter,1)
		cb(true)
	else
		cb(false)
	end
end)

-- Access Card:
ESX.RegisterServerCallback('PX_bankrobbery:accessCard',function(source,cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local gotItem = xPlayer.getInventoryItem(Config.AccessCard).count >= 1
	if gotItem then
		cb(true)
	else
		cb(false)
	end
end)

-- Callback to remove item:
ESX.RegisterServerCallback('PX_bankrobbery:removeItem',function(source,cb,item)
	local xPlayer = ESX.GetPlayerFromId(source)
	local gotItem = xPlayer.getInventoryItem(item).count >= 1
	if gotItem then
		xPlayer.removeInventoryItem(item,1)
	end
end)

-- Safe Reward:
RegisterServerEvent('PX_bankrobbery:safeReward')
AddEventHandler('PX_bankrobbery:safeReward', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	
	-- Chance to keep drill:
	math.randomseed(GetGameTimer())
	if math.random(0,100) <= Config.ChanceToKeepDrill then 
		xPlayer.addInventoryItem(Config.DrillItem,1)
	end

	-- Money:
	for k,v in pairs(Config.SafeMoneyReward) do
		local amount = (math.random(v.minAmount, v.maxAmount))
		if v.dirtyCash then
			xPlayer.addAccountMoney('black_money', amount)
		else
			xPlayer.addInventoryItem("dirtymoney", amount) 
		end
	end

	-- Item Reward:
	for k,v in pairs(Config.SafeItemRewards) do
		if math.random(0,100) <= v.chance then
			local itemAmount = math.random(v.min,v.max)
			local itemName = ''
			if Config.HasItemLabel then
				itemName = ESX.GetItemLabel(v.item)
			else
				itemName = tostring(v.item)
			end
			xPlayer.addInventoryItem(v.item,itemAmount)
			TriggerClientEvent('PX_bankrobbery:ShowNotifyESX', xPlayer.source, (Lang['drill_item_not_usable']:format(itemName,itemAmount)))
		end
	end
end)

RegisterServerEvent('PX_bankrobbery:giveItem')
AddEventHandler('PX_bankrobbery:giveItem', function(item)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.addInventoryItem(item,1)
end)

-- Event for police alerts
RegisterServerEvent('PX_bankrobbery:PoliceNotifySV')
AddEventHandler('PX_bankrobbery:PoliceNotifySV', function(targetCoords, streetName, name)
	TriggerClientEvent('PX_bankrobbery:PoliceNotifyCL', -1, (Lang['police_notify']):format(name,streetName))
	TriggerClientEvent('PX_bankrobbery:PoliceNotifyBlip', -1, targetCoords)
end)

-- get police online:
function getPoliceCount()
	local xPlayers = ESX.GetPlayers()
	PoliceOnline = 0
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'police' then
			PoliceOnline = PoliceOnline + 1
		end
	end
	TriggerClientEvent('PX_bankrobbery:getPoliceCount', -1, PoliceOnline)
	SetTimeout(300 * 1000, getPoliceCount)
end

-- Cash Grab:
RegisterServerEvent('PX_bankrobbery:deskCashSV')
AddEventHandler('PX_bankrobbery:deskCashSV', function(id, num, state)
    local xPlayer = ESX.GetPlayerFromId(source)
	Banks[id].deskCash[num].robbed = state
	TriggerClientEvent('PX_bankrobbery:deskCashCL', -1, id, num, state)
	-- money reward:
	local amount = math.random(Banks[id].deskCash[num].reward.min,Banks[id].deskCash[num].reward.max)
	amount = amount
	if Banks[id].deskCash[num].reward.dirty then
		xPlayer.addInventoryItem("dirtymoney", amount)
	else
		xPlayer.addAccountMoney('black_money', amount)
	end 
	--TriggerClientEvent('PX_bankrobbery:ShowNotifyESX', xPlayer.source, (Lang['drill_item_not_usable']:format(itemName,itemAmount)))
	TriggerClientEvent('PX_bankrobbery:ShowNotifyESX', xPlayer.source, "~g~"..amount.."$~s~ in cash taken from the desk")
end)

-- ## POWER BOX ## --

alertTime = nil
RegisterServerEvent('PX_bankrobbery:powerBoxSV')
AddEventHandler('PX_bankrobbery:powerBoxSV', function(id, state, timer)
    local xPlayer = ESX.GetPlayerFromId(source)
	Banks[id].powerBox.disabled = state
	alertTime = timer
	TriggerClientEvent('PX_bankrobbery:powerBoxCL', -1, id, state, alertTime)
end)

RegisterServerEvent('PX_bankrobbery:addRobTimeSV')
AddEventHandler('PX_bankrobbery:addRobTimeSV', function(timer)
    local xPlayer = ESX.GetPlayerFromId(source)
	alertTime = timer
	TriggerClientEvent('PX_bankrobbery:addRobTimeCL', -1, alertTime)
end)

RegisterServerEvent('PX_bankrobbery:notiyforpolicemani')
AddEventHandler('PX_bankrobbery:notiyforpolicemani', function(coord)
	local xPlayers = ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'police' or xPlayer.job.name == 'dadgostari' then
			TriggerClientEvent('esx:showNotification', xPlayers[i], 'Robbery ~r~Bank ~w~Start Shod!')
			TriggerClientEvent('Parzival_bank:setBlip', xPlayers[i], coord)
		end
	end
end)