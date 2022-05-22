function tLength(t)
	local l = 0
	for k,v in pairs(t)do
		l = l + 1
	end

	return l
end
db = {}

RegisterServerEvent('db:updateUserNewbyMani')
AddEventHandler('db:updateUserNewbyMani', function(new)
	identifier = GetPlayerIdentifier(source, 0)
	new.dateofbirth = os.date("%x")
	db.updateUser(identifier, new)
end)

function db.updateUser(identifier, new, callback)
	local updateString = ""

	local length = tLength(new)
	local cLength = 1
	for k,v in pairs(new)do
		if cLength < length then
			if(type(v) == "number")then
				updateString = updateString .. "`" .. k .. "`=" .. v .. ","
			elseif(type(v) == "string")then
				updateString = updateString .. "`" .. k .. "`='" .. v .. "',"
			elseif(type(v) == "talbe")then
				updateString = updateString .. "`" .. k .. "`='" .. ESX.dump(v) "',"
			end
		else
			if(type(v) == "number")then
				updateString = updateString .. "`" .. k .. "`=" .. v .. ""
			else
				updateString = updateString .. "`" .. k .. "`='" .. ESX.dump(v) .. "'"
			end
		end
		cLength = cLength + 1
	end
	MySQL.query('UPDATE users SET ' .. updateString .. ' WHERE `identifier`=@identifier', 
	{
		['identifier'] = identifier
	}, function(done)
		if callback then
			callback(true)
		end
	end)
end

function db.createUser(identifier, license, callback)
	MySQL.query('INSERT INTO users (`identifier`, `money`, `bank`, `permission_level`, `inventory`, `license`) VALUES (@identifier, @money, @bank, @permission_level, @inventory, @license);', 
	{
		['identifier'] 			= identifier,
		['money'] 				= settings.defaultSettings.startingCash,
		['bank'] 				= settings.defaultSettings.startingBank,
		['license'] 			= license,
		['@inventory']          = '[{"count":1,"slot":1,"type":"item","name":"starterpack","info":""}]',
		['permission_level'] 	= 0
	}, function(e)
		callback()
	end)
end

function db.doesUserExist(identifier, callback)
	MySQL.query('SELECT * FROM `users` WHERE `identifier` = @identifier', 
	{
		['@identifier'] = identifier
	}, function(users)
		if users[1] then
			callback(true)
		else
			callback(false)
		end
	end)
end

function db.retrieveUser(identifier, callback)
	MySQL.query('SELECT * FROM users WHERE `identifier`=@identifier;', 
	{
		['identifier'] = identifier
	}, function(users)
		if users[1] then
			callback(users[1])
		else
			callback(false)
		end
	end)
end