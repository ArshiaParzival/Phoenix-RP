ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- sell chips
RegisterServerEvent('casino:deposit')
AddEventHandler('casino:deposit', function(amount)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local item = xPlayer.getInventoryItem('casino_chips').count
	if amount == nil or amount <= 0 or amount > item then
        -- error notification
		TriggerClientEvent('t-notify:client:Custom', _source, {
			style = 'success',
			message = 'Casino: You don\'t have that many chips to sell!',
			duration = 5500,
			sound = true
		})
	else
		xPlayer.removeInventoryItem('casino_chips',amount)
		xPlayer.addMoney(tonumber(amount) * 3)
		TriggerEvent('esx_society:getSociety', "casino", function (society)
            TriggerEvent('esx_addonaccount:getSharedAccount', society.account, function(account)
                account.removeMoney(tonumber(amount) * 3)
            end)
        end)
		TriggerClientEvent('t-notify:client:Custom', _source, {
			style = 'success',
			message = 'Casino: you sold '..amount..' chips',
			duration = 5500,
			sound = true
		})
	end
end)

-- buy chips
RegisterServerEvent('casino:withdraw')
AddEventHandler('casino:withdraw', function(amount)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	amount = tonumber(amount)
	if amount == nil or amount <= 0 or amount * 100 > xPlayer.money then
        -- error notification
		TriggerClientEvent('t-notify:client:Custom', _source, {
			style = 'error',
			message = 'Casino: You don\'t have enough money in bank to buy that many chips!',
			duration = 5500,
			sound = true
		})
	else
		xPlayer.addInventoryItem('casino_chips',amount)
		xPlayer.removeMoney(amount * 5)
		TriggerEvent('esx_society:getSociety', "casino", function (society)
            TriggerEvent('esx_addonaccount:getSharedAccount', society.account, function(account)
                account.addMoney(tonumber(amount) * 5)
            end)
        end)
		TriggerClientEvent('t-notify:client:Custom', _source, {
			style = 'success',
			message = 'Casino: you purchased '..amount..' chips"',
			duration = 5500,
			sound = true
		})
	end
end)

-- buy ticket
RegisterServerEvent('casino:ticket')
AddEventHandler('casino:ticket', function(amount)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local funds = 0
	tickets = tonumber(amount)
	ticket_cost = (tickets * Config.ticket)
	funds = xPlayer.money
	if funds == nil or funds <= 0 or ticket_cost > funds then
        -- error notification
		TriggerClientEvent('t-notify:client:Custom', _source, {
			style = 'error',
			message = 'Casino: You don\'t have enough money to buy tickets!',
			duration = 5500,
			sound = true
		})
	else
		xPlayer.addInventoryItem('casino_ticket',amount)
		xPlayer.removeMoney(ticket_cost)
		TriggerEvent('esx_society:getSociety', "casino", function (society)
            TriggerEvent('esx_addonaccount:getSharedAccount', society.account, function(account)
                account.addMoney(tonumber(ticket_cost) / 2)
            end)
        end)
        -- success notification
		TriggerClientEvent('t-notify:client:Custom', _source, {
			style = 'success',
			message = 'Casino: you purchased '..amount..' Lucky Wheel Tickets for $'..ticket_cost,
			duration = 5500,
			sound = true
		})
	end
end)

RegisterServerEvent('casino:balance')
AddEventHandler('casino:balance', function()

	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	balance = xPlayer.getInventoryItem('casino_chips').count
	TriggerClientEvent('chips_currentbalance1', _source, balance)
	
end)