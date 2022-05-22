ESX                = nil
AdminPlayers = {}
local rcount = 1
local reports = {}
local chats = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

AddEventHandler('esx:playerLoaded', function(source)
	local identifier = GetPlayerIdentifier(source)
	for k,v in pairs(reports) do
		if v.owner.identifier == identifier then
			v.owner.id = source
		end
	end
end)

RegisterCommand('reports', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer then
		TriggerClientEvent('Phoenixsgreport:openreportsmenu', source)
	end
end, false)

RegisterCommand('report', function(source, args)
	if not args[1] then
		TriggerClientEvent('esx:showNotification', source, "Shoma Bayad Hadaghal yek kalame type konid!", 'error')
		return
	end
	local reason = table.concat(args, " ")
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer then
		local identifier = GetPlayerIdentifier(source)

		if doesHaveReport(identifier) then
			TriggerClientEvent('esx:showNotification', source, "Shoma Az Qabl Report Baz Darid lotfan shakiba bashid!", 'error')
			return
		end

		local name = GetPlayerName(source)
		local id = source
		reports[tostring(rcount)] = {
			owner = {
			identifier = identifier,
			name = name,
			id = source,
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
			if xPlayer.permission_level >= 1 then
				TriggerClientEvent('chatMessage', xPlayer.source, "[SYSTEM]", {255, 0, 0}, " ^0Report jadid tavasot ^2" .. name .. "^0(^3" .. id .. "^0) Matn: ^6" ..reason.. "^0 (^4/ar " .. rcount .. "^0) Jahat Javab Dadan Be Report.")
			end
		end
		SendLog(source, reason)
		rcount = rcount + 1
		TriggerClientEvent('esx:showNotification', source, "Report Shoma Sabt Shod Lotfan Ta Pasokhgoyi Staff Shakiba Bashid", 'success')
	end

end)

RegisterServerEvent("Phoenixlksgreport:crreport")
AddEventHandler("Phoenixlksgreport:crreport", function(id)
	local reportid = id
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.permission_level >= 1 then

			if not reportid then
				TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "ID Report Peyda Nashod!")
				return
			end

			if not tonumber(reportid) then
				TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "in Yek Id Nist!")
				return
			end

			if reports[reportid] then

				local report = reports[reportid] 
				local identifier = GetPlayerIdentifier(source)
				local ridentifier = report.owner.identifier
				local closer = GetPlayerName(source)
				chats[identifier] = nil
				chats[ridentifier] = nil
			
				TriggerClientEvent('chatMessage', xPlayer.source, "[SYSTEM]", {255, 0, 0}, "Shoma report ^2" .. report.owner.name .. "^0 (^3" .. report.owner.id .. "^0) ra bastid!")

				xPlayer = ESX.GetPlayerFromIdentifier(report.owner.identifier)
				if xPlayer then
					TriggerClientEvent('esx:showNotification', xPlayer.source, "Report shoma tavasot " .. GetPlayerName(source)  .. " baste shod!", 'info')
				end

				reports[reportid] = nil

			else
				TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Report mored nazar vojod nadarad!")
			end
	else
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma dastresi kafi baraye estefade az in dastor ra nadarid")
	end
end)

RegisterServerEvent("Phoenixsgreport:arreport")
AddEventHandler("Phoenixsgreport:arreport", function(id)
	local reportid = id
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.permission_level >= 1 then

			if not reportid then
				TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "ID Report Peyda Nashod!")
				return
			end

			if not tonumber(reportid) then
				TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "in Yek Id Nist!")
				return
			end

			local identifier = GetPlayerIdentifier(source)

			if not canRespond(identifier) then
				TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Shoma nemitavanid be report digari javab dahid aval report ghablie khod ra bebandid!")
				return
			end

			if reports[reportid] then

				if reports[reportid].status == "open" then

					local report = reports[reportid]

					if report.owner.identifier == identifier then
						TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Shoma nemitavanid be report khod javab dahid")
						return
					end
					
					local ridentifier = report.owner.identifier
					local name = GetPlayerName(source)
					report.status = "pending"
					report.respond.name = name
					report.respond.identifier = identifier
					chats[identifier] = ridentifier
					chats[ridentifier] = identifier
					TriggerClientEvent('chatMessage', xPlayer.source, "[SYSTEM]", {255, 0, 0}, "Shoma report ^2" .. report.owner.name .. "^0 (^3" .. report.owner.id .. "^0) ra ghabol kardid!")
					TriggerClientEvent('chatMessage', xPlayer.source, "[SYSTEM]", {255, 0, 0}, "^0Matn: ^6" ..report.reason)
					SendARLog(source, report.reason, report.owner.name)
			
					xPlayer = ESX.GetPlayerFromIdentifier(report.owner.identifier)
					if xPlayer then
						TriggerClientEvent('Phoenixnotify:sendnotify', xPlayer.source, { type = 'success', typet = 'Ghabol Shod', text = "Report shoma tavasot " .. name .. " ghabol shod!", time = 4700 })
						TriggerClientEvent('chatMessage', xPlayer.source, "[SYSTEM]", {255, 0, 0}, "Jahat chat kardan ba admin marbote az ^3/rd ^0estefade konid!")
					end

					local xPlayers = ESX.GetPlayers()
					for i=1, #xPlayers do
						xPlayer = ESX.GetPlayerFromId(xPlayers[i])
						if xPlayer.permission_level >= 1 and xPlayer.source ~= source then
							TriggerClientEvent('chatMessage', xPlayer.source, "[SYSTEM]", {255, 0, 0}, " ^0Report ^3" .. reportid .. "^0 tavasot ^2" .. name .. "^0 Ghabol shod!")
						end
					end
				else
					TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "In report ghablan tavasot kasi javab dade shode ast!")
				end
			else
				TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Report mored nazar vojod nadarad!")
			end
	else
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma dastresi kafi baraye estefade az in dastor ra nadarid")
	end

end)

RegisterCommand('ar', function(source, args)

	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.permission_level >= 1 then

			if not args[1] then
				TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Shoma dar ghesmat ID chizi vared nakardid!")
				return
			end

			if not tonumber(args[1]) then
				TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Shoma dar ghesmat ID faghat adad mitavanid vared konid!")
				return
			end

			local identifier = GetPlayerIdentifier(source)

			if not canRespond(identifier) then
				TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Shoma nemitavanid be report digari javab dahid aval report ghablie khod ra bebandid!")
				return
			end

			if reports[args[1]] then

				if reports[args[1]].status == "open" then

					local report = reports[args[1]]
					
					local ridentifier = report.owner.identifier
					local name = GetPlayerName(source)
					report.status = "pending"
					report.respond.name = name
					report.respond.identifier = identifier
					chats[identifier] = ridentifier
					chats[ridentifier] = identifier
					xPlayer.addBank(10000)
					TriggerClientEvent('chatMessage', xPlayer.source, "[SYSTEM]", {255, 0, 0}, "Shoma report ^2" .. report.owner.name .. "^0 (^3" .. report.owner.id .. "^0) ra ghabol kardid!")
					TriggerClientEvent('chatMessage', xPlayer.source, "[SYSTEM]", {255, 0, 0}, "^0Matn: ^6" ..report.reason)
					SendARLog(source, report.reason, report.owner.name)
			
					xPlayer = ESX.GetPlayerFromIdentifier(report.owner.identifier)

					if xPlayer then

						TriggerClientEvent('Phoenixnotify:sendnotify', xPlayer.source, { type = 'success', typet = 'Ghabol Shod', text = "Report shoma tavasot " .. name .. " ghabol shod!", time = 4700 })
						TriggerClientEvent('chatMessage', xPlayer.source, "[SYSTEM]", {255, 0, 0}, "Jahat chat kardan ba admin marbote az ^3/rd ^0estefade konid!")
					end

					local xPlayers = ESX.GetPlayers()
					for i=1, #xPlayers do
						xPlayer = ESX.GetPlayerFromId(xPlayers[i])
						if xPlayer.permission_level >= 1 and xPlayer.source ~= source then
							TriggerClientEvent('chatMessage', xPlayer.source, "[SYSTEM]", {255, 0, 0}, " ^0Report ^3" .. args[1] .. "^0 tavasot ^2" .. name .. "^0 Ghabol shod!")
						end
					end
				else
					TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "In report ghablan tavasot kasi javab dade shode ast!")
				end
			else
				TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Report mored nazar vojod nadarad!")
			end
	else
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma dastresi kafi baraye estefade az in dastor ra nadarid")
	end

end, false)

RegisterCommand('cr', function(source, args)
	
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.permission_level >= 1 then

			if not args[1] then
				TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Shoma dar ghesmat ID chizi vared nakardid!")
				return
			end

			if not tonumber(args[1]) then
				TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Shoma dar ghesmat ID faghat adad mitavanid vared konid")
				return
			end

			if reports[args[1]] then

				local report = reports[args[1]] 
				local identifier = GetPlayerIdentifier(source)
				local ridentifier = report.owner.identifier
				local closer = GetPlayerName(source)
				chats[identifier] = nil
				chats[ridentifier] = nil
				
				TriggerClientEvent('chatMessage', xPlayer.source, "[SYSTEM]", {255, 0, 0}, "Shoma Report ^2" .. report.owner.name .. "^0 (^3" .. report.owner.id .. "^0) Ra Bastid!")
						
				xPlayer = ESX.GetPlayerFromIdentifier(report.owner.identifier)
				if xPlayer then
					TriggerClientEvent('Phoenixnotify:sendnotify', xPlayer.source, { type = 'warn', typet = 'Baste Shod', text = "Report Shoma Tavasot " .. GetPlayerName(source)  .. " Baste Shod!", time = 4700 })
				end

				reports[args[1]] = nil
				
			else
				TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Report Mored Nazar Vojod Nadarad!")
			end
	else
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma Dastresi Kafi Baraye Estefade Az In Dastor Ra Nadarid")
	end

end, false)

RegisterCommand('rd', function(source, args)
	local identifier = GetPlayerIdentifier(source)

	if chats[identifier] then
		if not args[1] then
			TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma Nemitvanid Peygham Khali Befrestid")
			return
		end
		local message = table.concat(args, " ")
		local name = GetPlayerName(source)

		local xPlayer = ESX.GetPlayerFromIdentifier(chats[identifier])
		if xPlayer then
			TriggerClientEvent('chatMessage', source, "[REPORT]", {255, 0, 0}, "^2" .. name .. ":^0 " .. message)
			TriggerClientEvent('chatMessage', xPlayer.source, "[REPORT]", {255, 0, 0}, "^2" .. name .. ":^0 " .. message)
		else
			TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Player Mored Nazar Online Nist")
		end

	else
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma Hich Report Activi Nadarid!")
	end

end, false)

ESX.RegisterServerCallback('Phoenixfstreport:reports', function(source, cb)
	local rreports = {}
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.permission_level >= 1 then

			local status

			if TableLength(reports) > 0 then
				for k,v in pairs(reports) do
					if v.status == "open" then
						status = "Baz"
					else
						status = "DarHal Anjam (" .. v.respond.name ..")"
					end
					table.insert(rreports, {
						name		= v.owner.name .. "(" .. v.owner.id .. ")",
						reportid	= k,
						reason		= v.reason,
						status		= status
					})
				end

				cb(rreports)
			else
				TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Reporti Jahat Namayesh Vojod Nadarad")
			end
	else
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma Dastresi Kafi Baraye Estefade Az In Dastor Ra Nadarid")
	end
end)

function canRespond(identifier)
	for k,v in pairs(reports) do
		if v.respond.identifier == identifier then
			return false
		end
	end

	return true
end

function doesHaveReport(identifier)
	for k,v in pairs(reports) do
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

function CheckReports()
	if TableLength(reports) > 0 then
		for k,v in pairs(reports) do
			if os.time() - v.time >= 600 and v.respond.name == "none" then
				local xPlayers = ESX.GetPlayers()
				for i=1, #xPlayers do
					local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
					if xPlayer.permission_level >= 1 then
						TriggerClientEvent('chatMessage', xPlayer.source, "[SYSTEM]", {255, 0, 0}, " ^0Report ^5" .. k .. "^0 Be Dalil Adam Javab Dar ^3Zaman Mogharar^0 Baste Shod!")
					end
				end
				local xPlayer = ESX.GetPlayerFromIdentifier(reports[k].owner.identifier)
				if xPlayer then
					TriggerClientEvent('chatMessage', xPlayer.source, "[SYSTEM]", {255, 0, 0}, " ^0Report Shoma Be Elaat ^3Adam Pasokhgoyi^0 Tavasot Staff Dar Zaman Mogharar Shode ^1Baste Shod !")
				end
				reports[k] = nil
			end
		end
	end
	SetTimeout(5000, CheckReports)
end
CheckReports()

function SendLog(source, reason)
    local xPlayer = ESX.GetPlayerFromId(source)
    PerformHttpRequest('', function(err, text, headers)
    end, 'POST',
    json.encode({
    username = 'Report Bot',
    embeds =  {{["color"] = 65280,
                ["author"] = {["name"] = 'Phoenix Logs ',
                ["icon_url"] = 'https://media.discordapp.net/attachments/787580597177548800/948180206030569472/f0f9fc8d87bfa48e6f280ebe9f86a5e6.png?width=663&height=663'},
                ["description"] = "** New Report **\n[Report]: " ..GetPlayerName(source).. "\n" .. "[Reason]: " .. reason .. "\n",
                ["footer"] = {["text"] = "© PX Logs- "..os.date("%x %X  %p"),
                ["icon_url"] = 'https://media.discordapp.net/attachments/787580597177548800/948180206030569472/f0f9fc8d87bfa48e6f280ebe9f86a5e6.png?width=663&height=663',},}
                },
    avatar_url = 'https://media.discordapp.net/attachments/787580597177548800/948180206030569472/f0f9fc8d87bfa48e6f280ebe9f86a5e6.png?width=663&height=663'
    }),
    {['Content-Type'] = 'application/json'
    })
end

function SendARLog(source, report, reason, target)
    local xPlayer = ESX.GetPlayerFromId(source)
    PerformHttpRequest('', function(err, text, headers)
    end, 'POST',
    json.encode({
    username = 'Report Bot',
    embeds =  {{["color"] = 65280,
                ["author"] = {["name"] = 'Phoenix Logs ',
                ["icon_url"] = 'https://media.discordapp.net/attachments/787580597177548800/948180206030569472/f0f9fc8d87bfa48e6f280ebe9f86a5e6.png?width=663&height=663'},
                ["description"] = "** Accept Report **\n[Admin]: " ..GetPlayerName(source).. "\n" .. "[Report]: " .. report.. "\n" .. "[Reason]: " .. reason .. "\n" .."[Owner]: " .. target .. "\n",
                ["footer"] = {["text"] = "© PX Logs- "..os.date("%x %X  %p"),
                ["icon_url"] = 'https://media.discordapp.net/attachments/787580597177548800/948180206030569472/f0f9fc8d87bfa48e6f280ebe9f86a5e6.png?width=663&height=663',},}
                },
    avatar_url = 'https://media.discordapp.net/attachments/787580597177548800/948180206030569472/f0f9fc8d87bfa48e6f280ebe9f86a5e6.png?width=663&height=663'
    }),
    {['Content-Type'] = 'application/json'
    })
end
