ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

TriggerEvent('esx_society:registerSociety', 'dadgostari', 'Dadgostari', 'society_dadgostari', 'society_dadgostari', 'society_dadgostari', {type = 'public'})

if DadgostariConfig.MaxInService ~= -1 then
	TriggerEvent('esx_service:activateService', 'dadgostari', DadgostariConfig.MaxInService)
end

RegisterServerEvent('esx_dadgostarijob:Manimessage')
AddEventHandler('esx_dadgostarijob:Manimessage', function(target, msg)
	if #(GetEntityCoords(GetPlayerPed(source)) - GetEntityCoords(GetPlayerPed(target))) >= 10 then return end
	TriggerClientEvent('esx:showNotification', target, msg)
end)

ESX.RegisterServerCallback('esx_dadgostarijob:getIcName', function(source, cb)
	local _source = source
	characterName = string.gsub(exports.Proxtended:GetPlayerICName(_source), "_", " ")

	cb(characterName)
end)

RegisterCommand('lawyer', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.job.name == "dadgostari" and xPlayer.job.grade == 7 then
		xPlayer.setJob("lawyer", 1)
	elseif xPlayer.job.name == "dadgostari" and xPlayer.job.grade == 8 then
		xPlayer.setJob("lawyer", 2)
	elseif xPlayer.job.name == "lawyer" and xPlayer.job.grade == 1 then
		xPlayer.setJob("dadgostari", 7)
	elseif xPlayer.job.name == "lawyer" and xPlayer.job.grade == 2 then
		xPlayer.setJob("dadgostari", 8)
	else
		TriggerClientEvent('chatMessage', source, "[Justice]", {255, 0, 0}, " ^0Shoma Dastresi Kafi Nadarid!")
	end
end)