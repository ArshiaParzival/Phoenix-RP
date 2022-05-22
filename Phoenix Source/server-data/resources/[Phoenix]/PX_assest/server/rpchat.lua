ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterCommand("ooc", function(source, args, rawCommand)
	local playerName = GetPlayerName(source)
	local msg = rawCommand:sub(5)
	local ped = GetPlayerPed(source)
	local ped_NETWORK = NetworkGetNetworkIdFromEntity(ped)
	TriggerClientEvent("sendProximityMessage", -1, source, playerName, msg, ped_NETWORK)
end, false)

RegisterCommand("b", function(source, args, rawCommand)
	local playerName = GetPlayerName(source)
	local msg = rawCommand:sub(2)
	local ped = GetPlayerPed(source)
	local ped_NETWORK = NetworkGetNetworkIdFromEntity(ped)
	TriggerClientEvent("sendProximityMessage", -1, source, playerName, msg, ped_NETWORK)
end, false)

RegisterCommand('f', function(source, args)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.job.name == "police" or xPlayer.job.name == "ambulance" or xPlayer.job.name == "dadgostari" then
        if not args[1] then
            return
        end
        local job = xPlayer.job.name
        local jobGrade = xPlayer.job.grade_label
        local name = string.gsub(xPlayer.name, "_", " ")
        local message = table.concat(args, " ")

        local xPlayers = ESX.GetPlayers()
        for i=1, #xPlayers do
            local tplayer = ESX.GetPlayerFromId(xPlayers[i])
            if tplayer.job.name == job or tplayer.job.name == "off" .. job then
                TriggerClientEvent('chat:addMessage', xPlayers[i], {
                    template = '<div class="chat-message server"><b>{0}</b> {1}</div>',
                    args = { "Radio OOC - "..jobGrade.." | ".. name, message }
                })
            end
        end
    else
        TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma dastresi kafi baraye estefade az in dastor ra nadarid!")
    end
end)

RegisterCommand("dep", function(source, args)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xJob = xPlayer.job.name
    if xJob == "police" or xJob == "ambulance" or xJob == "dadgostari" then
        if not args[1] then
            TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma nemitavanid payam khali befrestid!")
            return
        end

        local name = string.gsub(xPlayer.name, "_", " ")
        local job  = string.upper(xJob)
        local message = table.concat(args, " ", 1)
        local xPlayers = ESX.GetPlayers()

        for i=1, #xPlayers do
            local tplayer = ESX.GetPlayerFromId(xPlayers[i])
            local tJob = tplayer.job.name
            if tJob == "police" or tJob == "ambulance" or tJob == "dadgostari" then
                TriggerClientEvent('chat:addMessage', tplayer.source, {
                    template = '<div class="chat-message server"><b>{0}</b> {1}</div>',
                    args = { "Department - "..job.." - ".. name, ": " .. message }
                })
            end
        end
    else
        TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma dastresi kafi baraye estefade az in dastor ra nadarid!")
    end
end, false)