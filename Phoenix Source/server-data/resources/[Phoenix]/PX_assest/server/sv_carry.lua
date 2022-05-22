RegisterServerEvent('PX_Carry:sendRequest')
AddEventHandler('PX_Carry:sendRequest', function(targetid)
	if #(GetEntityCoords(GetPlayerPed(source)) - GetEntityCoords(GetPlayerPed(targetid))) >= 5 then return end
    TriggerClientEvent('PX_Carry:AskToCarry', targetid, source)
end)

RegisterServerEvent('PX_Carry:AcceptCarry')
AddEventHandler('PX_Carry:AcceptCarry', function(id)
	if #(GetEntityCoords(GetPlayerPed(source)) - GetEntityCoords(GetPlayerPed(id))) >= 5 then return end
    TriggerClientEvent('carry:syncTarget', source, id)
    TriggerClientEvent('carry:syncMe', id, source)
end)

RegisterServerEvent('PX_Carry:DeclineCarry')
AddEventHandler('PX_Carry:DeclineCarry', function(id)
	if #(GetEntityCoords(GetPlayerPed(source)) - GetEntityCoords(GetPlayerPed(id))) >= 5 then return end
    TriggerClientEvent('esx:showNotification', id, "Darkhast Carry Shoma Rad Shod!", 'info')
end)

RegisterServerEvent('carry:stop')
AddEventHandler('carry:stop', function(id)
	if #(GetEntityCoords(GetPlayerPed(source)) - GetEntityCoords(GetPlayerPed(id))) >= 5 then return end
    TriggerClientEvent('carry:stop', id)
    TriggerClientEvent('carry:stop', source)
end)