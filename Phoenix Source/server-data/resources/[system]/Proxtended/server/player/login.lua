function LoadUser(identifier, source, licenseNotRequired)
	local Source = source
	db.retrieveUser(identifier, function(user, isJson)
		if user then
			if isJson then
				user = json.decode(user)
			end


			if user.inventory then 
				user.inventory = json.decode(user.inventory)
			else
				user.inventory = {}
			end

			if not user.permission_level then
				user.permission_level = 0
			end

			if user.license or licenseNotRequired then
				Users[source] = CreatePlayer(Source, user.permission_level, user.money, user.bank, user.identifier, user.license, user.inventory, user.job, user.job_grade, user.gang, user.gang_grade, user.firstname, user.lastname, user.position, user.status, user.divisions, user.phone, user.stress, user.salary, user.gender)

				TriggerClientEvent('esx:playerLoaded', Source, {
					identifier   = Users[Source].identifier,
					inventory    = Users[Source].inventory,
					job          = Users[Source].job,
					gang		 = Users[Source].gang,
					loadout      = {},
					lastPosition = Users[Source].coords,
					money        = Users[Source].money,
					bank		 = Users[Source].bank,
					salary		 = Users[Source].salary,
					status		 = Users[Source].status,
					firstname	 = Users[Source].firstname,
					lastname	 = Users[Source].lastname,
					name		 = Users[Source].name,
					gender		 = Users[Source].gender,
					dead		 = user.is_dead,
					phone        = Users[Source].phone,
					stress		 = Users[Source].stress
				})
				TriggerEvent('esx:playerLoaded', Source, Users[Source])

				local new = '.'
				if (not user.firstname or not tostring(user.firstname) or string.len(user.firstname) < 2 or user.firstname == "") or (not user.lastname or not tostring(user.lastname) or string.len(user.lastname) < 2 or user.lastname == "") then
					TriggerClientEvent('registerForm', Source, true)
					new = ', and he/she is new player!' 
				else
					TriggerClientEvent('registerForm', Source, false)					
				end
				TriggerEvent('DiscordBot:ToDiscord', 'co', '[LogSystem]', "```css\n User: (".. source .. '), Identifier: (' .. Users[source].identifier .. '), Name: (' .. Users[source].name .. '), SteamName: (' .. GetPlayerName(source) .. '), money: ('.. Users[source].money .. '), Bank: (' .. Users[source].bank .. '), Permission: ('.. Users[source].permission_level .. ')'.. new .. "```",'user', Source, true, false)
				TriggerEvent("esx:PlayerConnectingSuccess", GetPlayerName(source), Users[source].identifier, source)
				for k,v in pairs(commandSuggestions) do
					TriggerClientEvent('chat:addSuggestion', Source, settings.defaultSettings.commandDelimeter .. k, v.help, v.params)
				end

				TriggerClientEvent('ManageAdmins', source, 1, Admins)

				if Users[source].permission_level > 0 then
					for k,v in pairs(AdminCommands) do
						TriggerClientEvent('chat:addSuggestion', Source, settings.defaultSettings.commandDelimeter .. k, v.help, v.params)
					end
				end
				
			else
				local license

				for k,v in ipairs(GetPlayerIdentifiers(Source))do
					if string.sub(v, 1, string.len("license:")) == "license:" then
						license = v
						break
					end
				end

				if license then
					db.updateUser(user.identifier, {license = license}, function()
						LoadUser(user.identifier, Source, false)
					end)
				else
					LoadUser(user.identifier, Source, false, true)
				end
			end
		else
			local license
			for k,v in ipairs(GetPlayerIdentifiers(Source))do
				if string.sub(v, 1, string.len("license:")) == "license:" then
					license = v
					break
				end
			end
			db.createUser(identifier, license, function()
				LoadUser(identifier, Source, true)
			end)
		end
	end)
end

-- Exported function
ESX.getPlayerFromId = function(id)
	return Users[tonumber(id)]
end

-- Returns all Proxtended user objects
AddEventHandler('es:getPlayers', function(cb)
	cb(Users)
end)

-- Same as above just easier was we know the ID already now.
AddEventHandler("es:setPlayerDataId", function(user, k, v, cb)
	db.updateUser(user, {[k] = v}, function(d)
		cb(true)
	end)
end)

RegisterServerEvent("es:newName")
AddEventHandler("es:newName", function(first, last)
	Users[source].set("firstname", first)
	Users[source].set("lastname", last)
	Users[source].set("name", first..' '..last)
end)

RegisterServerEvent("es:newGender")
AddEventHandler("es:newGender", function(gender)
	Users[source].set("gender", gender)
end)

-- Returns the user if all checks completed, if the first if check fails then you're in a bit of trouble
AddEventHandler("es:getPlayerFromId", function(user, cb)
	if(Users)then
		if(Users[user])then
			cb(Users[user])
		else
			cb(nil)
		end
	else
		cb(nil)
	end
end)

-- Same as above but uses the DB to get a user instead of memory.
AddEventHandler("es:getPlayerFromIdentifier", function(identifier, cb)
	db.retrieveUser(identifier, function(user)
		cb(user)
	end)
end)

-- Function to save player money to the database every 60 seconds.
ESX.savePlayerMoney = function()
	for k,v in pairs(Users)do
		if Users[k] ~= nil then
			db.updateUser(v.get('identifier'), {
				money 		= v.money,
				bank 		= v.bank,
				position 	= v.lastPosition,
				inventory 	= v.inventory}
			)
		end
		Wait(300)
	end
end