ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local AS, ASWarn = {}, {}

TriggerEvent('esx_society:registerSociety', 'police', 'Police', 'society_police', 'society_police', 'society_police', {type = 'public'})

if PDConfig.MaxInService ~= -1 then
	TriggerEvent('esx_service:activateService', 'police', PDConfig.MaxInService)
end

RegisterServerEvent("Parzival:ShotsAlarm")
AddEventHandler("Parzival:ShotsAlarm", function(x, y, z, street)
    TriggerClientEvent("Parzival:ShotsAlarm", -1, x, y, z, street)
end)

RegisterServerEvent('esx_policejob:Manimessage')
AddEventHandler('esx_policejob:Manimessage', function(target, msg)
	if #(GetEntityCoords(GetPlayerPed(source)) - GetEntityCoords(GetPlayerPed(target))) >= 10 then return end
	TriggerClientEvent('esx:showNotification', target, msg)
end)

ESX.RegisterServerCallback('esx_policejob:getIcName', function(source, cb)
	local _source = source
	characterName = string.gsub(exports.Proxtended:GetPlayerICName(_source), "_", " ")

	cb(characterName)
end)

RegisterServerEvent("Parzival:ShotsAlarm")
AddEventHandler("Parzival:ShotsAlarm", function(x,y,z,s)
	TriggerClientEvent("Parzival:ShotsAlarm", -1, x,y,z,s)
end)

RegisterServerEvent("esx_policejob:sendBackUp")
AddEventHandler("esx_policejob:sendBackUp", function(x,y,z)
	TriggerClientEvent("esx_policejob:sendBackUp", -1, x,y,z)
end)

RegisterCommand("911", function(source, args)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.getInventoryItem("phone").count > 0 then
		if args[1] then
			local playerPos = xPlayer.coords
			local reason = table.concat(args, " ", 1)
			local xPlayers = ESX.GetPlayers()
			TriggerClientEvent("PX_phone:registercallanimation", source, 'cellphone_call_listen_base')
            for i=1, #xPlayers, 1 do
                local xP = ESX.GetPlayerFromId(xPlayers[i])
                if xP.job.name == 'police' then
					TriggerClientEvent('chat:addMessage', xPlayers[i], {
						template = '<div class="chat-message emergency"><b>{0}</b> {1}</div>',
						args = { "DISPATCH - "..xPlayer.name.." Need Help by Reason ", reason }
					})
					TriggerClientEvent("esx_policejob:send911", xPlayers[i], xPlayer.name, playerPos.x, playerPos.y, playerPos.z)
				end
			end
		else
			TriggerClientEvent("esx:showNotification", source, "Shoma Tozihat Vared Nakardid!")
		end
	else
		TriggerClientEvent("esx:showNotification", source, "Shoma Mobile Nadarid!")
	end
end)