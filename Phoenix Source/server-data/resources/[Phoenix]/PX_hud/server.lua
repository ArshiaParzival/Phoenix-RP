ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

AddEventHandler('esx:playerLoaded', function(source)
	TriggerClientEvent('showStatus', source)
    TriggerClientEvent('chat:addMessage', source, { args = { '^1[SYSTEM] ', " ^0Be ^1Phoenix RP ^0Khosh Amadid."} })
end)

RegisterCommand('info', function(source) 
    local xPlayer = ESX.GetPlayerFromId(source)
    TriggerClientEvent('esx:showNotification', source, "~w~name~r~ : ~b~" .. xPlayer.name)
    TriggerClientEvent('esx:showNotification', source, "~w~Job~r~ : ~b~" .. xPlayer.job.label .. " ~r~  ~w~" .. xPlayer.job.grade_label)
    TriggerClientEvent('esx:showNotification', source, "~w~Gang~r~ : ~b~" .. xPlayer.gang.name .. " ~r~  ~w~" .. xPlayer.gang.grade_label)
end)