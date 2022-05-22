ESX = nil
local rcount = 1
local reqs = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

AddEventHandler('esx:playerLoaded', function(source)
	local identifier = GetPlayerIdentifier(source)
	for k,v in pairs(reqs) do
		if v.owner.identifier == identifier then
			v.owner.id = source
		end
	end
end)

RegisterCommand('areqs', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer then
		TriggerClientEvent('parzival_ambulance:openreqs', source)
	end
end, false)

RegisterServerEvent("parzival_ambulance:addreq")
AddEventHandler("parzival_ambulance:addreq", function(reason)
	if GetPlayerRoutingBucket(source) ~= 0 then
		return
	end
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer then
		local identifier = GetPlayerIdentifier(source)
		if doesHaveReq(identifier) then
			TriggerClientEvent("esx:showNotification", source, "Shoma Az Qabl Darkhast Darid Lotfan Shakiba Bashid!", 'error')
			return
		end
		local name = string.gsub(xPlayer.name, "_", " ")
		reqs[tostring(rcount)] = {
			owner = {
			identifier = identifier,
			name = name,
			coord = GetEntityCoords(GetPlayerPed(source))
		},
		respond = {
			name = "none",
			identifier = "none"
		},
			reason = reason,
			status = "open",
			time = os.time()
		}
		local xPlayers = ESX.GetPlayers()
		for i=1, #xPlayers do
			local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
			if xPlayer.job.name == 'ambulance' then
				TriggerClientEvent("esx:showNotification", xPlayer.source, "DarKhast Jadid ambulance Sabt Shod!")
			end
		end
		rcount = rcount + 1
		TriggerClientEvent("esx:showNotification", source, "Darkhast Shoma Baraye ambulance Ersal Shod!", 'success')
	end
end)

RegisterServerEvent("parzival_ambulance:creqs")
AddEventHandler("parzival_ambulance:creqs", function(id)
	local reqid = id
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.job.name == "ambulance" then
		if reqs[reqid] then
			local req = reqs[reqid]
			TriggerClientEvent("esx:showNotification", source, "Shoma Reqs Ra Bastid!")
			xPlayer = ESX.GetPlayerFromIdentifier(req.owner.identifier)
			if xPlayer then
				TriggerClientEvent("esx:showNotification", xPlayer.source, "Reqs Shoma Baste Shod!")
				TriggerClientEvent("parzival_ambulance:delblip", xPlayer.source)
			end
			reqs[reqid] = nil
		else
			TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " Req Mored Nazar Vojod Nadarad!")
		end
	else
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma Dastresi Kafi Baraye Estefade Az In Dastor Ra Nadarid")
	end
end)

RegisterServerEvent("parzival_ambulance:areqs")
AddEventHandler("parzival_ambulance:areqs", function(id)
	local reqid = id
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.job.name == "ambulance" then
		local identifier = GetPlayerIdentifier(source)
		local coord = GetEntityCoords(GetPlayerPed(source))
		if not canRespond(identifier) then
			TriggerClientEvent("esx:showNotification", source, "Shoma Reqs Accept Shode Darid!")
			return
		end
		if reqs[reqid] then
			if reqs[reqid].status == "open" then
				local req = reqs[reqid]
				local name = string.gsub(xPlayer.name, "_", " ")
				req.status = "pending"
				req.respond.name = name
				req.respond.identifier = identifier
				TriggerClientEvent("esx:showNotification", source, "Shoma req " .. req.owner.name .. " Ra Ghabol Kardid!")
				TriggerClientEvent("parzival_ambulance:acceptreq", source, req.owner.coord)
				xPlayer = ESX.GetPlayerFromIdentifier(req.owner.identifier)
				if xPlayer then
					TriggerClientEvent("esx:showNotification", xPlayer.source, "Darkhast Shoma Ghabool Shod!")
					TriggerClientEvent("parzival_ambulance:addblip", xPlayer.source, source, coord)
				end
			else
				TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " In Reqs Ghablan Tavasot Kasi Javab Dade Shode Ast!")
			end
		else
			TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " Reqs Mored Nazar Vojod Nadarad!")
		end
	else
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma Dastresi Kafi Baraye Estefade Az In Dastor Ra Nadarid")
	end
end)

ESX.RegisterServerCallback('parzival_ambulance:getReqs', function(source, cb)
	local treqs = {}
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.job.name == "ambulance" then
		local status
		local accept
		if TableLength(reqs) > 0 then
			for k,v in pairs(reqs) do
				if v.status == "open" then
					status = "❌"
					accept = "open"
				else
					status = "✔️"
					accept = "Accepted"
				end
				table.insert(treqs, {
					name		= v.owner.name,
					phone		= getNumberPhone(v.owner.identifier),
					coord		= v.owner.coord,
					reqid	    = k,
					reason		= v.reason,
					status		= status,
					id		    = v.owner.id,
					accept		= accept,
				})
			end
			cb(treqs)
		else
			TriggerClientEvent("esx:showNotification", source, "DarKhasti Vojod nadarad!", 'error')
		end
	else
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma Dastresi Kafi Baraye Estefade Az In Dastor Ra Nadarid")
	end
end)

ESX.RegisterServerCallback('parzival_ambulance:getcoord', function(source, cb, id)
	local coord = GetEntityCoords(GetPlayerPed(id))
	cb(coord)
end)

ESX.RegisterServerCallback('parzival_ambulance:acceptername', function(source, cb, id)
	local reqid = id
	local req = reqs[reqid]
	local acceptername = req.respond.name
	cb(acceptername)
end)

ESX.RegisterServerCallback('parzival_ambulance:icname', function(source, cb)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local name = string.gsub(xPlayer.name, "_", " ")
	cb(name)
end)

function canRespond(identifier)
	for k,v in pairs(reqs) do
		if v.respond.identifier == identifier then
			return false
		end
	end

	return true
end

function doesHaveReq(identifier)
	for k,v in pairs(reqs) do
		if v.owner.identifier == identifier then
			return true
		end
	end

	return false
end

function TableLength(table)
	local count = 0
	for _ in pairs(table) do
		count = count + 1
	end
	return count
end

function CheckReqs()
	if TableLength(reqs) > 0 then
		for k,v in pairs(reqs) do
			if os.time() - v.time >= 600 and v.respond.name == "none" then
				local xPlayer = ESX.GetPlayerFromIdentifier(reqs[k].owner.identifier)
				if xPlayer then
					TriggerClientEvent("esx:showNotification", xPlayer, "DarKhast ambulance Shoma Bedalil Adam Pasokhgoyi Baste Shod!")
				end
				reqs[k] = nil
			end
		end
	end
	SetTimeout(5000, CheckReqs)
end
CheckReqs()

function getNumberPhone(identifier)
    local result = MySQL.query.await("SELECT phone FROM users WHERE identifier = @identifier", {
        ['@identifier'] = identifier
    })
    if result[1] ~= nil then
        return result[1].phone
    end
    return nil
end