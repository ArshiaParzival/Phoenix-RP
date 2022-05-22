ESX = nil 

TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)

ESX.RegisterUsableItem("radio", function(source) 
    TriggerClientEvent("radio", source)
end)

ESX.RegisterServerCallback("CheckRadio", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getInventoryItem("radio").count > 0 then
        cb(true)
    else
        cb(false)
    end
end)

local requests = {}

RegisterCommand('checkfreq', function(source, args)
	local xPlayer = ESX.GetPlayerFromId(source)

	if not args[1] then
		TriggerClientEvent('chatMessage', source, "[SYSTEM] ", {255, 0, 0}, "^0Shoma dar argument aval chizi vared nakardid")
		return
	end

	if not tonumber(args[1]) then
		local input = string.lower(args[1])
		if input == "accept" then
			local identifier = GetPlayerIdentifier(source)
			if requests[identifier] then
				local request = requests[identifier]
				local zPlayer = ESX.GetPlayerFromIdentifier(request.target)
				if zPlayer then
					requests[identifier] = nil
					TriggerClientEvent('chatMessage', source, "[SYSTEM] ", {255, 0, 0}, "^0Darkhast freq check ba movafaghgiat ghabol shod!")
					TriggerClientEvent('chatMessage', zPlayer.source, "[SYSTEM] ", {255, 0, 0}, "^0Radio freqans ^2" .. GetPlayerName(source) .. "^0 ebarat ast az: ^3" .. exports["pma-voice"]:GetRadioChannel(source))
				else
					TriggerClientEvent('chatMessage', source, "[SYSTEM] ", {255, 0, 0}, "^0Kasi ke baraye shoma darkhast freq check ferestade shahr ra tark karde ast!")
				end
			else
				TriggerClientEvent('chatMessage', source, "[SYSTEM] ", {255, 0, 0}, "^0Shoma hich requeste freq checki nadarid!")
			end
		elseif input == "decline" then
			local identifier = GetPlayerIdentifier(source)
			if requests[identifier] then
				requests[identifier] = nil
				TriggerClientEvent('chatMessage', source, "[SYSTEM] ", {255, 0, 0}, "^0Darkhast freq check shoma ba movafaghiat baste shod!")
			else
				TriggerClientEvent('chatMessage', source, "[SYSTEM] ", {255, 0, 0}, "^0Shoma hich requeste freq checki nadarid!")
			end
		else
			TriggerClientEvent('chatMessage', source, "[SYSTEM] ", {255, 0, 0}, "^0Syntax vared shode eshtebah ast!")
			return
		end
		return
	end

	local target = tonumber(args[1])

	if target == source then
		TriggerClientEvent('chatMessage', source, "[SYSTEM] ", {255, 0, 0}, "^0Shoma nemitavanid be khodetan darkhast freq check befrestid!")
		return
	end

	local name = GetPlayerName(target)

	if not name then
		TriggerClientEvent('chatMessage', source, "[SYSTEM] ", {255, 0, 0}, "^0ID vared shode eshtebah ast!")
		return
	end
	local identifier = GetPlayerIdentifier(target)

	if requests[identifier] then
		TriggerClientEvent('chatMessage', source, "[SYSTEM] ", {255, 0, 0}, "^0In player yek darkhast check freq darad!")
		return
	end

	local coords = GetEntityCoords(GetPlayerPed(source))
	local tcoords = GetEntityCoords(GetPlayerPed(target))
	local distance = getDistance(coords, tcoords)
	if distance < 1 then
		requests[identifier] = {time = os.time(), target = GetPlayerIdentifier(source)}
		TriggerClientEvent('chatMessage', source, "[SYSTEM] ", {255, 0, 0}, "^0Darkhast freq check ba ^2movafaghiat ^0 be ^3" .. name  .. "^0 ferestade shod!")
		TriggerClientEvent('chatMessage', target, "[SYSTEM] ", {255, 0, 0}, "^0Shoma yek darkhast freq check az ^2" .. GetPlayerName(source) .. "^0 daryaft kardid! (checkfreq accept)")
	else
		TriggerClientEvent('chatMessage', source, "[SYSTEM] ", {255, 0, 0}, "^0Fasele shoma az player mored niaz ziad ast!")
	end
end, false)

function getDistance(objA, objB)
    local xDist = objB.x - objA.x
    local yDist = objB.y - objA.y

    return math.sqrt( (xDist ^ 2) + (yDist ^ 2) ) 
end

function requestCheck()
	for k,v in pairs(requests) do
		if os.time() - v.time >= 120 then
			local xPlayer = ESX.GetPlayerFromIdentifier(k)
			if xPlayer then TriggerClientEvent('chatMessage', xPlayer.source, "[SYSTEM] ", {255, 0, 0}, "^0Darkhast ^2freq check ^0shoma ^1monghazi^0 shod!") end
			requests[k] = nil
		end
	end
	SetTimeout(15000, requestCheck)
end
requestCheck()