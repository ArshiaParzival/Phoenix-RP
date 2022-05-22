ESX.StartPayCheck = function()
	function payCheck()
		local xPlayers = ESX.GetPlayers()
		for i=1, #xPlayers, 1 do
			local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
			local job     = xPlayer.job.grade_name
			local gang	  = xPlayer.gang.name
			local jsalary  = xPlayer.job.grade_salary
			local gsalary  = xPlayer.gang.grade_salary
			if jsalary > 0 then
				--Edite Phoenix Development Team
				if job ~= 'nojob' then
					TriggerEvent('esx_society:getSociety', xPlayer.job.name, function (society)
						if society ~= nil then
							TriggerEvent('esx_addonaccount:getSharedAccount', society.account, function (account)
								if account.money >= jsalary then
									xPlayer.addSalary(jsalary)
									account.removeMoney(jsalary)
									TriggerClientEvent('esx:showNotification', xPlayer.source, _U('received_help', jsalary), 'info')
								else
									TriggerClientEvent('esx:showNotification', xPlayer.source, _U('company_nomoney'), 'error')
								end
							end)
						else
							xPlayer.addSalary(jsalary)
							TriggerClientEvent('esx:showNotification', xPlayer.source, _U('received_help', jsalary), 'info')
						end
					end)
				end
			end
			if gsalary > 0 then
				TriggerEvent('gangaccount:getGangAccount', 'gang_' .. string.lower(gang), function(account)
					if account.money >= gsalary then
						xPlayer.addBank(gsalary)
						account.removeMoney(gsalary)

						TriggerClientEvent('esx:showNotification', xPlayer.source, 'Mablaqe Daryafti Az Gang: '.. gsalary, 'info')
					end
				end)
			end
		end
		SetTimeout(Config.PaycheckInterval, payCheck)
	end
	SetTimeout(Config.PaycheckInterval, payCheck)
end

RegisterServerEvent("Proxtended:PX_TakeSalary")
AddEventHandler("Proxtended:PX_TakeSalary", function()
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.salary > 0 then
		local price = ESX.Math.Round((xPlayer.salary * 90) / 100)
		xPlayer.addBank(price)
		TriggerClientEvent("esx:showNotification", source, "Meghdar ~g~"..xPlayer.salary.."$ ~w~Ba Ehtesab Maliat 10% Be Bank Shoma Ezafe Shod!")
		xPlayer.setSalary(0)
	else
		TriggerClientEvent("esx:showNotification", source, "Mojodi Salary Shoma Khali Ast!")
	end
end)