ESX = nil
local event = {
    name = "none",
    coords = "nothing",
    weapon = false,
    status = true
}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent("Parzival:setEventCoords")
AddEventHandler("Parzival:setEventCoords", function(coords)
	if coords == nil then return end
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.permission_level >= 1 then
		event.coords = coords
		TriggerClientEvent('chatMessage', -1, "[SYSTEM]", {255, 0, 0}, " ^0Event ^3" .. event.name .. "^0 shoro shode ^1/event ^0jahat join dadan be event")
	else
		exports.Proxtended("Cheat? Onam Event? Kheili Molghaii :/")
	end
end)

RegisterCommand('event', function(source, args)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not args[1] then
		if event.name ~= "none" then
			if event.status ~= true then
				if event.coords ~= "nothing" then
					TriggerClientEvent('Parzival:gotoEvent', source, event.coords, event.name, event.weapon)
				else
					TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Moshkel Dar Daryaft Coords!!")
				end
			else
				TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Event Ghofl Shode Ast!")
			end
		else
			TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Hich Eventi Vojud Nadarad!")
		end
		return
	end
	if xPlayer.permission_level >= 3 then
		if args[1] == "set" then
			if event.name == "none" then
                if not args[2] then
					TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma Gun event ra Entekhab Nakardid! Agar gun Nmikhahid false bezanid :)")
					return
				end
				if not args[3] then
					TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma esm event ra vared nakardid!")
					return
				end
				local eventName = table.concat(args, " ", 3)
                local weapon = args[2]
                event.weapon = weapon
				event.status = false
				event.name = eventName
				TriggerClientEvent('Parzival:setEventCoords', source)
			else
				TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Ghablan yek event start shode ast nemitavanid start konid!")
			end
		elseif args[1] == "status" then
			if event.name ~= "none" then
				if args[2] == "true" then
					event.status = true
					TriggerClientEvent('chatMessage', -1, "[SYSTEM]", {255, 0, 0}, " ^0Event ^3" .. event.name .. "^0 ^1ghofl^0 shod, digar nemitavanid join dahid!")
				elseif args[2] == "false" then
					event.status = false
					TriggerClientEvent('chatMessage', -1, "[SYSTEM]", {255, 0, 0}, " ^0Event ^3" .. event.name .. "^0 ^2baaz^0 shod, mitavanid join dahid!")
				else
					TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma dar ghesmat vaziat faghat mitavanid true/false vared konid!")
				end
			else
				TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Hich eventi shoro nashode ast!")
			end
		elseif args[1] == "remove" then
			if event.name ~= "none" then
				TriggerClientEvent('chatMessage', -1, "[SYSTEM]", {255, 0, 0}, " ^0Event ^3" .. event.name .. "^0 ^2baste^0 shod, mamnon az tamam kasani ke join dadand!")
				TriggerClientEvent('Parzival:endEvent', -1, event.coords, event.name, event.weapon)
				event.status = true
				event.name = "none"
				event.coords = "nothing"
			else
				TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Hich eventi shoro nashode ast!")
			end
		else
			TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Argument vared shode eshtebah ast!")
		end
	else
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma dastresi kaafi baraye ^1estefade ^0az in dastor nadarid!")
	end
end, false)