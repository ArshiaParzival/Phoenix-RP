ESX = nil
isRoll = false
amount = 1

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('casino_luckywheel:getLucky')
AddEventHandler('casino_luckywheel:getLucky', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
	local ticket = xPlayer.getInventoryItem('casino_ticket').count
    if not isRoll then
        if xPlayer ~= nil then
            if ticket >= amount then
                xPlayer.removeInventoryItem('casino_ticket',amount)
				-- spin the wheel
                isRoll = true
                local _randomPrice = math.random(1,100)
				
				if _randomPrice == 1 then
				local _subRan = math.random(1,2)
                    if _subRan == 1 then
                        _priceIndex = 1 -- win car
                    else
                        _priceIndex = 11 -- loose
                end
				
				elseif _randomPrice > 1 and _randomPrice <= 6 then
				local _subRan = math.random(1,2)
                    if _subRan == 1 then
                        _priceIndex = 2 -- win
                    else
                        _priceIndex = 11 -- loose
                end
				
				elseif _randomPrice > 6 and _randomPrice <= 15 then
				local _subRan = math.random(1,3)
                    if _subRan == 1 then
                        _priceIndex = 3 -- win
                    else
                        _priceIndex = 11 -- loose
                end
                
				elseif _randomPrice > 15 and _randomPrice <= 25 then
				local _subRan = math.random(1,3)
                    if _subRan == 1 then
                        _priceIndex = 4 -- win
                    else
                        _priceIndex = 11 -- loose
                end
                
				elseif _randomPrice > 25 and _randomPrice <= 40 then
				local _subRan = math.random(1,3)
                    if _subRan == 1 then
                        _priceIndex = 5 -- win
                    else
                        _priceIndex = 11 -- loose
                end
                
				elseif _randomPrice > 40 and _randomPrice <= 60 then
				local _subRan = math.random(1,3)
                    if _subRan == 1 then
                        _priceIndex = 6 -- win
                    else
                        _priceIndex = 11 -- loose
                end
                
				elseif _randomPrice > 60 and _randomPrice <= 100 then
				local _subRan = math.random(1,3)
                    if _subRan == 1 then
                        _priceIndex = 7 -- win
                    else
                        _priceIndex = 11 -- loose
                end
				
				elseif _randomPrice > 60 and _randomPrice <= 100 then
				local _subRan = math.random(1,3)
                    if _subRan == 1 then
                        _priceIndex = 8 -- win
                    else
                        _priceIndex = 11 -- loose
                end
				
				elseif _randomPrice > 60 and _randomPrice <= 100 then
				local _subRan = math.random(1,3)
                    if _subRan == 1 then
                        _priceIndex = 9 -- win
                    else
                        _priceIndex = 11 -- loose
                end
				
				elseif _randomPrice > 60 and _randomPrice <= 100 then
				local _subRan = math.random(1,3)
                    if _subRan == 1 then
                        _priceIndex = 10 -- win
                    else
                        _priceIndex = 11 -- loose
                end
				end
                
				-- prize index
                SetTimeout(2000, function()
                    isRoll = false
                    if _priceIndex == 1 then
					TriggerClientEvent("casino_luckywheel:winCar", _source)
					TriggerClientEvent('t-notify:client:Custom', _source, {
						style = 'success',
						message = 'Winner: Congratulations you won the JACKPOT CAR!',
						duration = 5500,
						sound  =  true
					})
                    elseif _priceIndex == 2 then
					xPlayer.addInventoryItem('casino_chips', 100)
					xPlayer.addInventoryItem('casino_ticket', 1)
					TriggerClientEvent('t-notify:client:Custom', _source, {
						style = 'success',
						message = 'Winner: Congratulations you won 100 chips!',
						duration = 5500,
						sound  =  true
					})					
					elseif _priceIndex == 3 then
					xPlayer.addInventoryItem('casino_chips', 200)
					TriggerClientEvent('t-notify:client:Custom', _source, {
						style = 'success',
						message = 'Winner: Congratulations you won 200 chips!',
						duration = 5500,
						sound  =  true
					})					
					elseif _priceIndex == 4 then
					xPlayer.addInventoryItem('casino_chips', 500)
					TriggerClientEvent('t-notify:client:Custom', _source, {
						style = 'success',
						message = 'Winner: Congratulations you won 500 chips!',
						duration = 5500,
						sound  =  true
					})				
					elseif _priceIndex == 5 then
					xPlayer.addInventoryItem('casino_chips', 1000)
					TriggerClientEvent('t-notify:client:Custom', _source, {
						style = 'success',
						message = 'Winner: Congratulations you won 1,000 chips!',
						duration = 5500,
						sound  =  true
					})					
					elseif _priceIndex == 6 then
					xPlayer.addInventoryItem('casino_chips', 2000)
					TriggerClientEvent('t-notify:client:Custom', _source, {
						style = 'success',
						message = 'Winner: Congratulations you won 2,000 chips!',
						duration = 5500,
						sound  =  true
					})				
					elseif _priceIndex == 7 then
					xPlayer.addInventoryItem('casino_chips', 5000)
					TriggerClientEvent('t-notify:client:Custom', _source, {
						style = 'success',
						message = 'Winner: Congratulations you won 5,000 chips!',
						duration = 5500,
						sound  =  true
					})					
					elseif _priceIndex == 8 then
					xPlayer.addInventoryItem('casino_chips', 6000)
					TriggerClientEvent('t-notify:client:Custom', _source, {
						style = 'success',
						message = 'Winner: Congratulations you won 6,000 chips!',
						duration = 5500,
						sound  =  true
					})					
					elseif _priceIndex == 9 then
					xPlayer.addInventoryItem('casino_chips', 9000)
					TriggerClientEvent('t-notify:client:Custom', _source, {
						style = 'success',
						message = 'Winner: Congratulations you won 9,000 chips!',
						duration = 5500,
						sound  =  true
					})					
					elseif _priceIndex == 10 then
					xPlayer.addInventoryItem('casino_chips', 10000)
					TriggerClientEvent('t-notify:client:Custom', _source, {
						style = 'success',
						message = 'Winner: Congratulations you won 10,000 chips!',
						duration = 5500,
						sound  =  true
					})
					elseif _priceIndex == 11 then
					TriggerClientEvent('t-notify:client:Custom', _source, {
						style = 'error',
						message = 'Lost: sorry you lost, please try again!',
						duration = 5500,
						sound  =  true
					})				
                    end
                    TriggerClientEvent("casino_luckywheel:rollFinished", -1)
                end)
                TriggerClientEvent("casino_luckywheel:doRoll", -1, _priceIndex)
            else
                TriggerClientEvent("casino_luckywheel:rollFinished", -1)
				TriggerClientEvent('t-notify:client:Custom', _source, {
					style = 'error',
					message = 'Not enough lucky tickets, please purchase more from the cashier!',
					duration = 5500,
					sound  =  true
				})
            end
        end
    end
end)
