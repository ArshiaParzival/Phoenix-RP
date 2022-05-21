ESX = nil
local Gangs = {}
local RegisteredGangs = {}
local TempGangs = {}
local cooldown = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function GetGang(gang)
	for i=1, #RegisteredGangs, 1 do
		if RegisteredGangs[i] == gang then
			local gn = {}
			gn.name = gang
			gn.account = 'gang_' .. string.lower(gn.name)
			return gn
		end
	end
end


MySQL.ready(function()
	local result = MySQL.query.await('SELECT * FROM gangs', {})

	for i=1, #result, 1 do
		print('Gang '.. result[i].name .. ' Az DataBase Peyda Shod')
		Gangs[result[i].name]        	= result[i]
		Gangs[result[i].name].grades 	= {}
		RegisteredGangs[i] 				= result[i].name
		Gangs[result[i].name].vehicles 	= {}
		MySQL.query('SELECT * FROM owned_vehicles WHERE owner = @owner',{
			['@owner'] = result[i].name
		}, function(vehResult)
			for j=1, #vehResult do
				Gangs[result[i].name].vehicles[j] = json.decode(vehResult[j].vehicle)
			end
		end)
	end

 	local result2 = MySQL.query.await('SELECT * FROM gang_grades', {})

 	for i=1, #result2, 1 do
		Gangs[result2[i].gang_name].grades[tonumber(result2[i].grade)] = result2[i]
	end
	
	local data = MySQL.query.await('SELECT * FROM gangs_data', {})
	for i=1, #data, 1 do
		Gangs[data[i].gang_name].slot = data[i].slot
		Gangs[data[i].gang_name].blip_color = data[i].blip_color
		Gangs[data[i].gang_name].blip_icon = data[i].blip_icon
		Gangs[data[i].gang_name].vestperm = data[i].vestperm
		Gangs[data[i].gang_name].invperm = data[i].invperm
		Gangs[data[i].gang_name].stashperm = data[i].stashperm
		Gangs[data[i].gang_name].craftperm = data[i].craftperm
	end
end)

RegisterServerEvent('gangs:acceptinv')
AddEventHandler('gangs:acceptinv', function()
local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.setGang(xPlayer.get('ganginv'),1)
end)

RegisterServerEvent('gangs:registerGang')
AddEventHandler('gangs:registerGang', function(source, name, expire)
	local xPlayer = ESX.GetPlayerFromId(source)
	-- if xPlayer.getGroup() ~= 'nogang' then

		local found = false

		local gang = name

		for i=1, #RegisteredGangs, 1 do
			if RegisteredGangs[i] == gang then
				found = true
				break
			end
		end

		if not found then
			table.insert(TempGangs, {gang = name, expire = expire})
			TriggerClientEvent('esx:showNotification', source, gang)
		else
			TriggerClientEvent('esx:showNotification', source, 'This Gang Created Before!')
		end

	-- else
	-- 	ban(xPlayer.source, "Attempted To Create Gang")
	-- end
	
end)

RegisterServerEvent('gangs:saveGangs')
AddEventHandler('gangs:saveGangs', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	-- if xPlayer.getGroup() ~= 'nogang'  then

		for j=1, #TempGangs, 1 do
			table.insert(RegisteredGangs, TempGangs[j].gang)

			Gangs[TempGangs[j].gang] 			= {}
			Gangs[TempGangs[j].gang].label      = 'gang'
			Gangs[TempGangs[j].gang].name      	= TempGangs[j].gang
			Gangs[TempGangs[j].gang].grades 	= {}
			Gangs[TempGangs[j].gang].vehicles 	= {}
			Gangs[TempGangs[j].gang].invperm = 9
			Gangs[TempGangs[j].gang].stashperm = 2
			Gangs[TempGangs[j].gang].craftperm = 2
			Gangs[TempGangs[j].gang].blip_icon = 429
			Gangs[TempGangs[j].gang].blip_color = 40
            Gangs[TempGangs[j].gang].vest = 1
			local ranks = {'Rank1','Rank2','Rank3','Rank4','Rank5','Rank6', 'Rank7', 'Rank8', 'Rank9', 'Rank10'}
			TriggerEvent('Proxtended:addGang', TempGangs[j].gang, ranks)
			TriggerEvent('gangaccount:addGang', TempGangs[j].gang)

			MySQL.update('INSERT INTO `gangs` (`name`, `label`) VALUES (@name, @label)', {
				['@name'] 		= TempGangs[j].gang,
				['@label']    = 'gang',
			}, function(e)
			--log here
			end)
			for i=1, 10, 1 do
				Gangs[TempGangs[j].gang].grades[i] 				= {}
				Gangs[TempGangs[j].gang].grades[i].gang_name 	= TempGangs[j].gang
				Gangs[TempGangs[j].gang].grades[i].grade 		= i
				Gangs[TempGangs[j].gang].grades[i].name 		= 'Rank' .. i
				Gangs[TempGangs[j].gang].grades[i].label 		= ranks[i]
				Gangs[TempGangs[j].gang].grades[i].salary 		= 100 * i
				Gangs[TempGangs[j].gang].grades[i].skin_male 	= '[]'
				Gangs[TempGangs[j].gang].grades[i].skin_female 	= '[]'


				MySQL.update('INSERT INTO `gang_grades` (`gang_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`) VALUES (@gang_name, @grade, @name, @label, @salary, @skin_male, @skin_female)', {
					['@gang_name'] 	 = TempGangs[j].gang,
					['@grade']    	 = i,
					['@name'] 		 = 'Rank '..i,
					['@label']       = ranks[i],
					['@salary'] 	 = 10*i,
					['@skin_male']   = '[]',
					['@skin_female'] = '[]',
				}, function(e)
				--log here
				end)
			end
			MySQL.update('INSERT INTO `gang_account` (`name`, `label`, `shared`) VALUES (@name, @label, @shared)', {
				['@name'] 	  = 'gang_'..string.lower(TempGangs[j].gang),
				['@label']    = 'gang',
				['@shared']   = 1,
			}, function(e)
			--log here
			end)
			MySQL.update('INSERT INTO `gang_account_data` (`gang_name`, `money`, `owner`) VALUES (@gang_name, @money, @owner)', {
				['@gang_name'] 	= 'gang_'..string.lower(TempGangs[j].gang),
				['@money']    	= 0,
				['@owner']   	= nil,
			}, function(e)
			--log here
			end)
			MySQL.update('INSERT INTO `gangs_data` (`gang_name`, `expire_time`) VALUES (@gang_name, (NOW() + INTERVAL @time DAY))', {
				['@gang_name'] 		= TempGangs[j].gang,
				['@time']			= TempGangs[j].expire
			}, function(e)
			--log here
			end)
			
			TriggerClientEvent('esx:showNotification', source, 'You Added ' .. TempGangs[j].gang .. ' Gang!')
		end
		TempGangs = {}

	-- else
	--     ban(xPlayer.source, "Attempted to save gang data")
	-- end
end)

RegisterServerEvent('gangs:changeGangData')
AddEventHandler('gangs:changeGangData', function(name, data, pos, source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	-- if xPlayer.getGroup() ~= 'nogang' then

		local gang = name
		local data = data

		if data == 'blip' then
			blip(name,pos,function(callback)
				if callback then
					TriggerClientEvent('esx:showNotification', _source, 'You updated '..data..' point of '..gang..' Gang!')
				end
			end)
		elseif data == 'armory' then
			armory(name,pos,function(callback)
				if callback then
					TriggerClientEvent('esx:showNotification', _source, 'You updated '..data..' point of '..gang..' Gang!')
				end
			end)
		elseif data == 'locker' then
			locker(name,pos,function(callback)
				if callback then
					TriggerClientEvent('esx:showNotification', _source, 'You updated '..data..' point of '..gang..' Gang!')
				end
			end)
		elseif data == 'boss' then
			boss(name,pos,function(callback)
				if callback then
					TriggerClientEvent('esx:showNotification', _source, 'You updated '..data..' point of '..gang..' Gang!')
				end
			end)
		elseif data == 'veh' then
			veh(name,pos,function(callback)
				if callback then
					TriggerClientEvent('esx:showNotification', _source, 'You updated '..data..' point of '..gang..' Gang!')
				end
			end)
		elseif data == 'vehdel' then
			vehdel(name,pos,function(callback)
				if callback then
					TriggerClientEvent('esx:showNotification', _source, 'You updated '..data..' point of '..gang..' Gang!')
				end
			end)
		elseif data == 'vehspawn' then
			vehspawn(name,pos,function(callback)
				if callback then
					TriggerClientEvent('esx:showNotification', _source, 'You updated '..data..' point of '..gang..' Gang!')
				end
			end)
		elseif data == 'expire' then
			expire(name,pos,function(callback)
				if callback then
					TriggerClientEvent('esx:showNotification', _source, 'You updated '..data..' time of '..gang..' Gang!')
				end
			end)
		elseif data == 'gps' then
			gangsblip2(name, pos, _source)
		elseif data == 'bulletproof' then
			bulletproof(name,pos,function(callback)
				if callback then
					TriggerClientEvent('esx:showNotification', source, 'Shoma Armore %'.. callback .. ' be '..gang..' Dadid!')
				end
			end)
		elseif data == 'slot' then
			slot(name,pos, _source)
		end
		local xps = ESX.GetPlayers()
		for i,v in ipairs(xps) do
			local xp = ESX.GetPlayerFromId(v)
			local gname = xp.gang.name
			local grank = xp.gang.grade
			if xp.gang.name == name then
				xp.setGang(gname, grank)
			end
		end

	-- else
	-- 	ban(xPlayer.source, "Attempted to save gang data")
	-- end
end)

function blip(gang, pos, callback)
	MySQL.update('UPDATE gangs_data SET blip = @pos WHERE gang_name = @gang_name', {
		['@gang_name']      = gang,
		['@pos']  			= json.encode(pos)
	}, function(rowsChanged)
		if callback then
			callback(true)
		end
	end)
end

function armory(gang, pos, callback)
	MySQL.update('UPDATE gangs_data SET armory = @pos WHERE gang_name = @gang_name', {
		['@gang_name']      = gang,
		['@pos']  			= json.encode(pos)
	}, function(rowsChanged)
		if callback then
			callback(true)
		end
	end)
end

function locker(gang, pos, callback)
	MySQL.update('UPDATE gangs_data SET locker = @pos WHERE gang_name = @gang_name', {
		['@gang_name']      = gang,
		['@pos']  			= json.encode(pos)
	}, function(rowsChanged)
		if callback then
			callback(true)
		end
	end)
end

function boss(gang, pos, callback)
	MySQL.update('UPDATE gangs_data SET boss = @pos WHERE gang_name = @gang_name', {
		['@gang_name']      = gang,
		['@pos']  			= json.encode(pos)
	}, function(rowsChanged)
		if callback then
			callback(true)
		end
	end)
end

function veh(gang, pos, callback)
	MySQL.update('UPDATE gangs_data SET veh = @pos WHERE gang_name = @gang_name', {
		['@gang_name']      = gang,
		['@pos']  			= json.encode(pos)
	}, function(rowsChanged)
		if callback then
			callback(true)
		end
	end)
end

function vehdel(gang, pos, callback)
	MySQL.update('UPDATE gangs_data SET vehdel = @pos WHERE gang_name = @gang_name', {
		['@gang_name']      = gang,
		['@pos']  			= json.encode(pos)
	}, function(rowsChanged)
		if callback then
			callback(true)
		end
	end)
end

function vehspawn(gang, pos, callback)
	MySQL.update('UPDATE gangs_data SET vehspawn = @pos WHERE gang_name = @gang_name', {
		['@gang_name']      = gang,
		['@pos']  			= json.encode(pos)
	}, function(rowsChanged)
		if callback then
			callback(true)
		end
	end)
end

function expire(gang, time, callback)
	MySQL.update('UPDATE gangs_data SET expire_time = (NOW() + INTERVAL @time DAY) WHERE gang_name = @gang_name', {
		['@gang_name']      = gang,
		['@time']			= time
	}, function(rowsChanged)
		if callback then
			callback(true)
		end
	end)
end

function gangsblip2(gang, state, source)
	local _source = source
	MySQL.scalar("SELECT gangsblip FROM gangs_data WHERE gang_name = @gang_name",{
		["gang_name"] = gang
	}, function(result)
		if result then
			if state == "true" then
				MySQL.query.await("UPDATE gangs_data SET gangsblip = 1 WHERE gang_name = @gang_name",{
					["@gang_name"]	= gang
				})
				TriggerClientEvent('esx:showNotification', _source, 'You Active GPS Of '..gang..' Gang!')
			else
				MySQL.query.await("UPDATE gangs_data SET gangsblip = 0 WHERE gang_name = @gang_name",{
					["@gang_name"]	= gang
				})
				TriggerClientEvent('esx:showNotification', _source, 'You DeActive GPS Of '..gang..' Gang!')
			end
		end
	end)
	Wait(1000)
    TriggerClientEvent('esx_gangtracker:CheckGang', -1)
end

function bulletproof(gang, value, cb)
	MySQL.query.await("UPDATE gangs_data SET bulletproof = @bulletproof WHERE gang_name = @gang_name",{
		["@gang_name"]	= gang,
		["@bulletproof"]= tonumber(value)
	})
	cb(value)
end

function slot(gang, slot, source)
	local _Source = source
	MySQL.query.await("UPDATE gangs_data SET slot = @slot WHERE gang_name = @gang_name",{
		["@gang_name"]	= gang,
		["@slot"]= slot
	})
	Gangs[gang].slot = slot
	TriggerClientEvent('esx:showNotification', _Source, 'Shoma Slot Gang '.. gang .. ' Ra Be '.. slot ..' Taghir Dadid')
end

AddEventHandler('gangs:getGangs', function(cb)
	cb(RegisteredSocieties)
end)

AddEventHandler('gangs:getGang', function(name, cb)
	cb(GetGang(name))
end)

RegisterServerEvent('gangs:withdrawMoney')
AddEventHandler('gangs:withdrawMoney', function(gangName, amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	local gang = GetGang(gangName)
	amount = ESX.Math.Round(tonumber(amount))

 	if xPlayer.gang.name ~= gang.name then
		ban(xPlayer.source, "Attempted withdraw gang Money")
		return
	end

 	TriggerEvent('gangaccount:getGangAccount', gang.account, function(account)
		if amount > 0 and account.money >= amount then
			account.removeMoney(amount)
			xPlayer.addMoney(amount)
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('have_withdrawn', ESX.Math.GroupDigits(amount)))
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('invalid_amount'))
		end
	end)
end)

RegisterServerEvent('gangs:depositMoney')
AddEventHandler('gangs:depositMoney', function(gang, amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	local gang = GetGang(gang)
	amount = ESX.Math.Round(tonumber(amount))

 	if xPlayer.gang.name ~= gang.name then
	--	print(('gangs: %s attempted to call depositMoney!'):format(xPlayer.identifier))
		ban(xPlayer.source, "Attempted deposit gang Money")
		return
	end

 	if amount > 0 and xPlayer.money >= amount then
		TriggerEvent('gangaccount:getGangAccount', gang.account, function(account)
			xPlayer.removeMoney(amount)
			account.addMoney(amount)
		end)

 		TriggerClientEvent('esx:showNotification', xPlayer.source, _U('have_deposited', ESX.Math.GroupDigits(amount)))
	else
		TriggerClientEvent('esx:showNotification', xPlayer.source, _U('invalid_amount'))
	end
end)

RegisterServerEvent('gangs:saveOutfit')
AddEventHandler('gangs:saveOutfit', function(grade, skin)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.gender == 0 then
		TriggerEvent('ChangeGangSkin', xPlayer.gang.name, grade, true, skin)
		MySQL.query.await('UPDATE gang_grades SET skin_male = @skin WHERE (gang_name = @gang AND grade = @grade)',{
			['skin']  = json.encode(skin),
			['gang']  = xPlayer.gang.name,
			['grade'] = grade
		})
	else
		TriggerEvent('ChangeGangSkin', xPlayer.gang.name, grade, false, skin)
		MySQL.query.await('UPDATE gang_grades SET skin_female = @skin WHERE (gang_name = @gang AND grade = @grade)',{
			['skin']  = json.encode(skin),
			['gang']  = xPlayer.gang.name,
			['grade'] = grade
		})
	end
end)

RegisterServerEvent('gangs:saveOutfit2')
AddEventHandler('gangs:saveOutfit2', function(grade, skin)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.gender == 0 then
		TriggerEvent('ChangeGangSkin2', xPlayer.gang.name, grade, true, skin)
		MySQL.query.await('UPDATE gang_grades SET skin_male2 = @skin WHERE (gang_name = @gang AND grade = @grade)',{
			['skin']  = json.encode(skin),
			['gang']  = xPlayer.gang.name,
			['grade'] = grade
		})
	else
		TriggerEvent('ChangeGangSkin2', xPlayer.gang.name, grade, false, skin)
		MySQL.query.await('UPDATE gang_grades SET skin_female2 = @skin WHERE (gang_name = @gang AND grade = @grade)',{
			['skin']  = json.encode(skin),
			['gang']  = xPlayer.gang.name,
			['grade'] = grade
		})
	end
end)

RegisterServerEvent('gangs:saveOutfit3')
AddEventHandler('gangs:saveOutfit3', function(grade, skin)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.gender == 0 then
		TriggerEvent('ChangeGangSkin3', xPlayer.gang.name, grade, true, skin)
		MySQL.query.await('UPDATE gang_grades SET capture_male = @skin WHERE (gang_name = @gang AND grade = @grade)',{
			['skin']  = json.encode(skin),
			['gang']  = xPlayer.gang.name,
			['grade'] = grade
		})
	else
		TriggerEvent('ChangeGangSkin3', xPlayer.gang.name, grade, false, skin)
		MySQL.query.await('UPDATE gang_grades SET capture_female = @skin WHERE (gang_name = @gang AND grade = @grade)',{
			['skin']  = json.encode(skin),
			['gang']  = xPlayer.gang.name,
			['grade'] = grade
		})
	end
end)

ESX.RegisterServerCallback('gangs:getGangData', function(source, cb, gang)
	if ESX.DoesGangExist(gang,10) then
		gg = MySQL.query.await(
			'SELECT * FROM gangs_data WHERE gang_name = @gang_name AND `expire_time` > NOW()',
			{
				['@gang_name'] = gang
			}
		)
		cb(gg[1])
	else
		cb(nil)
	end

end)

ESX.RegisterServerCallback('gangs:getGangMoney', function(source, cb, gang)
	local gang = GetGang(gang)

 	if gang then
		TriggerEvent('gangaccount:getGangAccount', gang.account, function(account)
			cb(account.money)
		end)
	else
		cb(0)
	end
end)

ESX.RegisterServerCallback('gangs:renameGrade', function(source, cb, grade, name)
	local _source, grade, name = source, grade, name
	local xPlayer = ESX.GetPlayerFromId(_source)

	if xPlayer.gang.name == "nogang" then
		cb(false)
		exports.Proxtended:bancheater(xPlayer.source, "Tried to rename nogang label")
		return
	end

	if xPlayer.gang.grade >= 9 then
		if ESX.SetGangGrade(xPlayer.gang.name, grade, name) then
			if Gangs[xPlayer.gang.name] then Gangs[xPlayer.gang.name].grades[grade].label = name end

			local xPlayers = ESX.GetPlayers()

			for i=1, #xPlayers, 1 do
				local GangMember = ESX.GetPlayerFromId(xPlayers[i])

				if GangMember.gang.name == xPlayer.gang.name and GangMember.gang.grade == grade then
					GangMember.setGang(xPlayer.gang.name, grade)
				end

			end

			cb(true)
		else
			cb(false)
			TriggerClientEvent('chatMessage', _source, "[SYSTEM]", {255, 0, 0}, " ^0Khatayi dar avaz kardan esm gang grade shoma pish amad be developer etelaa dahid!")
		end
	else
		cb(false)
		exports.Proxtended:bancheater(xPlayer.source, "Tried to rename " .. xPlayer.gang.name .. " grade without boss level")
	end

end)

ESX.RegisterServerCallback('gangs:setvestperm', function(source, cb, perm)
	local _source, perm = source, perm
	local xPlayer = ESX.GetPlayerFromId(_source)

	if xPlayer.gang.name == "nogang" then
		cb(false)
		exports.Proxtended:bancheater(xPlayer.source, "Tried to rename nogang label")
		return
	end

	if xPlayer.gang.grade >= 9 then
		MySQL.update('UPDATE gangs_data SET vestperm = @perm WHERE gang_name = @gang_name', {
			['@gang_name']      = xPlayer.gang.name,
			['@perm']  			= perm
		}, function(rowsChanged)
			Gangs[xPlayer.gang.name].perm = perm
			local aPlayers = ESX.GetPlayers()
				for i=1, #aPlayers, 1 do
					local GangMember = ESX.GetPlayerFromId(aPlayers[i])

					if GangMember.gang.name == xPlayer.gang.name then
						GangMember.setGang(xPlayer.gang.name, GangMember.gang.grade)
					end

				end
			
		end)
		cb(true)
	else
		cb(false)
		exports.Proxtended:bancheater(xPlayer.source, "Tried to rename " .. xPlayer.gang.name .. " grade without boss level")
	end

end)


ESX.RegisterServerCallback('gangs:setb', function(source, cb, id, type)
	local _source, id = source, id
	local xPlayer = ESX.GetPlayerFromId(_source)

	if xPlayer.gang.name == "nogang" then
		cb(false)
		exports.Proxtended:bancheater(xPlayer.source, "Tried to rename nogang label")
		return
	end

	if xPlayer.gang.grade >= 9 then
		if type == 'b_i' then
			MySQL.update('UPDATE gangs_data SET blip_icon = @id WHERE gang_name = @gang_name', {
				['@gang_name']      = xPlayer.gang.name,
				['@id']  			= id
			}, function(rowsChanged)
				Gangs[xPlayer.gang.name].blip_icon = id
				local aPlayers = ESX.GetPlayers()
					for i=1, #aPlayers, 1 do
						local GangMember = ESX.GetPlayerFromId(aPlayers[i])

						if GangMember.gang.name == xPlayer.gang.name then
							GangMember.setGang(xPlayer.gang.name, GangMember.gang.grade)
						end

					end
			end)
			cb(true)
		else
			MySQL.update('UPDATE gangs_data SET blip_color = @id WHERE gang_name = @gang_name', {
				['@gang_name']      = xPlayer.gang.name,
				['@id']  			= id
			}, function(rowsChanged)
				Gangs[xPlayer.gang.name].blip_color = id
				local aPlayers = ESX.GetPlayers()
					for i=1, #aPlayers, 1 do
						local GangMember = ESX.GetPlayerFromId(aPlayers[i])

						if GangMember.gang.name == xPlayer.gang.name then
							GangMember.setGang(xPlayer.gang.name, GangMember.gang.grade)
						end

					end
			end)
			cb(true)
		end
	else
		cb(false)
		exports.Proxtended:bancheater(xPlayer.source, "Tried to rename " .. xPlayer.gang.name .. " grade without boss level")
	end

end)

ESX.RegisterServerCallback('gangs:setinvperm', function(source, cb, perm)
	local _source, perm = source, perm
	local xPlayer = ESX.GetPlayerFromId(_source)

	if xPlayer.gang.name == "nogang" then
		cb(false)
		exports.Proxtended:bancheater(xPlayer.source, "Tried to rename nogang label")
		return
	end

	if xPlayer.gang.grade >= 9 then
    MySQL.update('UPDATE gangs_data SET invperm = @perm WHERE gang_name = @gang_name', {
		['@gang_name']      = xPlayer.gang.name,
		['@perm']  			= perm
	}, function(rowsChanged)
		Gangs[xPlayer.gang.name].invperm = perm
		local aPlayers = ESX.GetPlayers()
			for i=1, #aPlayers, 1 do
				local GangMember = ESX.GetPlayerFromId(aPlayers[i])

				if GangMember.gang.name == xPlayer.gang.name then
					GangMember.setGang(xPlayer.gang.name, GangMember.gang.grade)
				end

			end
	end)
	cb(true)
	else
		cb(false)
		exports.Proxtended:bancheater(xPlayer.source, "Tried to rename " .. xPlayer.gang.name .. " grade without boss level")
	end

end)

ESX.RegisterServerCallback('gangs:setcraftperm', function(source, cb, perm)
	local _source, perm = source, perm
	local xPlayer = ESX.GetPlayerFromId(_source)

	if xPlayer.gang.name == "nogang" then
		cb(false)
		exports.Proxtended:bancheater(xPlayer.source, "Tried to rename nogang label")
		return
	end

	if xPlayer.gang.grade >= 9 then
    MySQL.update('UPDATE gangs_data SET craftperm = @perm WHERE gang_name = @gang_name', {
		['@gang_name']      = xPlayer.gang.name,
		['@perm']  			= perm
	}, function(rowsChanged)
		Gangs[xPlayer.gang.name].craftperm = perm
		local aPlayers = ESX.GetPlayers()
			for i=1, #aPlayers, 1 do
				local GangMember = ESX.GetPlayerFromId(aPlayers[i])

				if GangMember.gang.name == xPlayer.gang.name then
					GangMember.setGang(xPlayer.gang.name, GangMember.gang.grade)
				end

			end
	end)
	cb(true)
	else
		cb(false)
		exports.Proxtended:bancheater(xPlayer.source, "Tried to rename " .. xPlayer.gang.name .. " grade without boss level")
	end

end)

ESX.RegisterServerCallback('gangs:setstashperm', function(source, cb, perm)
	local _source, perm = source, perm
	local xPlayer = ESX.GetPlayerFromId(_source)

	if xPlayer.gang.name == "nogang" then
		cb(false)
		exports.Proxtended:bancheater(xPlayer.source, "Tried to rename nogang label")
		return
	end

	if xPlayer.gang.grade >= 9 then
    MySQL.update('UPDATE gangs_data SET stashperm = @perm WHERE gang_name = @gang_name', {
		['@gang_name']      = xPlayer.gang.name,
		['@perm']  			= perm
	}, function(rowsChanged)
		Gangs[xPlayer.gang.name].stashperm = perm
		local aPlayers = ESX.GetPlayers()
			for i=1, #aPlayers, 1 do
				local GangMember = ESX.GetPlayerFromId(aPlayers[i])

				if GangMember.gang.name == xPlayer.gang.name then
					GangMember.setGang(xPlayer.gang.name, GangMember.gang.grade)
				end

			end
	end)
	cb(true)
	else
		cb(false)
		exports.Proxtended:bancheater(xPlayer.source, "Tried to rename " .. xPlayer.gang.name .. " grade without boss level")
	end

end)

ESX.RegisterServerCallback('gangs:setgangicon', function(source, cb, icon)
	local _source, icon = source, icon
	local xPlayer = ESX.GetPlayerFromId(_source)

	if xPlayer.gang.name == "nogang" then
		cb(false)
		exports.Proxtended:bancheater(xPlayer.source, "Tried to rename nogang label")
		return
	end

	if xPlayer.gang.grade >= 9 then
    MySQL.update('UPDATE gangs_data SET icon = @icon WHERE gang_name = @gang_name', {
		['@gang_name']      = xPlayer.gang.name,
		['@icon']  			= icon
	}, function(rowsChanged)
		Gangs[xPlayer.gang.name].icon = icon
			local aPlayers = ESX.GetPlayers()
			for i=1, #aPlayers, 1 do
				local GangMember = ESX.GetPlayerFromId(aPlayers[i])

				if GangMember.gang.name == xPlayer.gang.name then
					GangMember.setGang(xPlayer.gang.name, GangMember.gang.grade)
				end

			end
		
	end)
	cb(true)
	else
		cb(false)
		exports.Proxtended:bancheater(xPlayer.source, "Tried to rename " .. xPlayer.gang.name .. " grade without boss level")
	end

end)

ESX.RegisterServerCallback('gangs:buy', function(source, cb, amount, station)
	local gang = GetGang(station)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.gang.name ~= gang.name then
		print(('gangs: %s attempted to buy!'):format(xPlayer.identifier))
		return
	end
	TriggerEvent('gangaccount:getGangAccount', gang.account, function(account)
		if account.money >= amount then
			account.removeMoney(amount)
			cb(true)
		else
			cb(false)
		end
	end)
end)

ESX.RegisterServerCallback('gangs:getEmployees', function(source, cb, gang)
		local result = MySQL.query.await('SELECT firstname, lastname, identifier, gang, gang_grade FROM users WHERE gang = @gang ORDER BY gang_grade DESC', {
			['@gang'] = gang
		})
		local employees = {}

		for i=1, #result, 1 do
			table.insert(employees, {
				name       = result[i].firstname.." "..result[i].lastname,
				identifier = result[i].identifier,
				gang = {
					name        = result[i].gang,
					label       = Gangs[result[i].gang].label,
					grade       = result[i].gang_grade,
					grade_name  = Gangs[result[i].gang].grades[tonumber(result[i].gang_grade)].name,
					grade_label = Gangs[result[i].gang].grades[tonumber(result[i].gang_grade)].label
				}
			})
		end

		cb(employees)
	-- end)
end)

ESX.RegisterServerCallback('gangs:getGang', function(source, cb, gang)
	local gang    = json.decode(json.encode(Gangs[gang]))
	local grades = {}

 	for k,v in pairs(gang.grades) do
		table.insert(grades, v)
	end

 	table.sort(grades, function(a, b)
		return a.grade < b.grade
	end)

	gang.grades = grades

 	cb(gang)
end)

ESX.RegisterServerCallback('gangs:getEmployeclothes', function(source, cb, grade, gender, gang)
	local fskin = {}
	local mskin = {}
	fskin       = json.decode(Gangs[gang].grades[tonumber(grade)].skin_female)
	mskin       = json.decode(Gangs[gang].grades[tonumber(grade)].skin_male)
		local xPlayers = ESX.GetPlayers()

		for i=1, #xPlayers, 1 do
			local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

			if xPlayer.gang.name == gang and xPlayer.gang.grade == grade then
				xPlayer.setGang(gang, grade)
			end
		end

	if gender == 'man' then
		cb(mskin)
	elseif  gender == 'woman' then 
		cb(fskin)
	end

end)

ESX.RegisterServerCallback('gangs:setUniform', function(source, cb, gang, rank, gender, model)
	local identifier = GetPlayerIdentifier(source, 0)
		if gender == 'man' then
			MySQL.update('UPDATE gang_grades SET skin_male = @skin_male WHERE gang_name = @gang_name AND grade = @grade', {
				['@skin_male']   = json.encode(model),
				['@gang_name'] = gang,
				['@grade']    = rank
			}, function(rowsChanged)
				Gangs[gang].grades[tonumber(rank)].skin_male = json.encode(model)
				
				cb()
			end)
		elseif  gender == 'woman' then 
			MySQL.update('UPDATE gang_grades SET skin_female = @skin_female WHERE gang_name = @gang_name AND grade = @grade', {
				['@skin_female']   = json.encode(model),
				['@gang_name'] = gang,
				['@grade']    = rank
			}, function(rowsChanged)
				Gangs[gang].grades[tonumber(rank)].skin_female = json.encode(model)

				cb()
			end)
		end
end)

ESX.RegisterServerCallback('gangs:setGang', function(source, cb, identifier, gang, grade, type)
	local xPlayer = ESX.GetPlayerFromId(source)
	local isBoss = xPlayer.gang.grade >= Gangs[xPlayer.gang.name].invperm
	local gangmember = 0
    local users = MySQL.query.await('SELECT * FROM users', {})
	for i=1, #users, 1 do
		if users[i].gang == gang then
			gangmember = gangmember + 1
		end
	end
 	if isBoss then
		if gang == 'nogang' then
			local xTarget = ESX.GetPlayerFromIdentifier(identifier)
			MySQL.query('SELECT * FROM users WHERE identifier=@identifier',
				{
					['@identifier'] =  identifier

				}, function(data)
                	if xPlayer.gang.grade <= data[1].gang_grade then
						TriggerClientEvent('esx:showNotification', xPlayer.source, 'Shoma Nemitavanid Etela\'at Rank Bala Rar Khod Ra Edit Konid')
						return
					end
				end)
				if xTarget then
					xTarget.setGang(gang, grade)
					TriggerClientEvent('esx:showNotification', xTarget.source, _U('you_have_been_fired', xTarget.gang.label))
					cb()
				else
					MySQL.update('UPDATE users SET gang = @gang, gang_grade = @gang_grade WHERE identifier = @identifier', {
						['@gang']        = gang,
						['@gang_grade']  = grade,
						['@identifier'] 	 = identifier
					}, function(rowsChanged)
						cb()
					end)
				end
		elseif gangmember <= Gangs[gang].slot then
			local xTarget = ESX.GetPlayerFromIdentifier(identifier)
			MySQL.query('SELECT * FROM users WHERE identifier=@identifier',
				{
					['@identifier'] =  identifier

				}, function(data)
                	if xPlayer.gang.grade <= data[1].gang_grade then
						TriggerClientEvent('esx:showNotification', xPlayer.source, 'Shoma Nemitavanid Etela\'at Rank Bala Rar Khod Ra Edit Konid')
						return
					end
				end)
				if xTarget then
					if gang == "nogang" then
						xTarget.setGang(gang, grade)
						return
					elseif type == 'hire' then
						xTarget.set('ganginv', gang)
						TriggerClientEvent('gangs:inv',xTarget.source,gang)
						return
					end
						xTarget.setGang(gang, grade)
					if type == 'hire' then
					elseif type == 'promote' then
						TriggerClientEvent('esx:showNotification', xTarget.source, _U('you_have_been_promoted'))
					elseif type == 'fire' then
						TriggerClientEvent('esx:showNotification', xTarget.source, _U('you_have_been_fired', xTarget.gang.label))
					end

					cb()
				else
					MySQL.update('UPDATE users SET gang = @gang, gang_grade = @gang_grade WHERE identifier = @identifier', {
						['@gang']        = gang,
						['@gang_grade']  = grade,
						['@identifier'] 	 = identifier
					}, function(rowsChanged)
						cb()
					end)
				end
		else
			TriggerClientEvent('esx:showNotification', source, 'Slot Gang Poor Shode Ast')
		end
	else
		print(('gangs: %s attempted to setGang'):format(xPlayer.identifier))
		cb()
	end
end)

ESX.RegisterServerCallback('gangs:setGangSalary', function(source, cb, gang, grade, salary)
	local isBoss = isPlayerBoss(source, gang)
	local identifier = GetPlayerIdentifier(source, 0)

 	if isBoss then
		if salary <= Config.MaxSalary then
			MySQL.update('UPDATE gang_grades SET salary = @salary WHERE gang_name = @gang_name AND grade = @grade', {
				['@salary']   = salary,
				['@gang_name'] = gang.name,
				['@grade']    = grade
			}, function(rowsChanged)
				Gangs[gang.name].grades[tonumber(grade)].salary = salary
				local xPlayers = ESX.GetPlayers()

 				for i=1, #xPlayers, 1 do
					local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

 					if xPlayer.gang.name == gang.name and xPlayer.gang.grade == grade then
						xPlayer.setGang(gang, grade)
					end
				end

 				cb()
			end)
		else
			print(('gangs: %s attempted to setGangSalary over config limit!'):format(identifier))
			cb()
		end
	else
		print(('gangs: %s attempted to setGangSalary'):format(identifier))
		cb()
	end
end)

ESX.RegisterServerCallback('gangs:getOnlinePlayers', function(source, cb)
	local xPlayers = ESX.GetPlayers()
	local players  = {}

 	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		table.insert(players, {
			source     = xPlayer.source,
			identifier = xPlayer.identifier,
			name       = xPlayer.name,
			gang       = xPlayer.gang
		})
	end

 	cb(players)
end)

ESX.RegisterServerCallback('gangs:getVehiclesInGarage', function(source, cb, gangName)
	cb(Gangs[gangName].vehicles)
end)

ESX.RegisterServerCallback('gangs:isBoss', function(source, cb, gang)
	cb(isPlayerBoss(source, gang))
end)

ESX.RegisterServerCallback('gangs:isBossgm', function(source, cb, gang)
	cb(isPlayerBossgm(source, gang))
end)

ESX.RegisterServerCallback('gang:getGrades', function(source, cb, plate)
	local xPlayer = ESX.GetPlayerFromId(source)
	  cb(ESX.GetGang(xPlayer.gang.name).grades)
end)

function isPlayerBoss(playerId, gang)
	local xPlayer = ESX.GetPlayerFromId(playerId)

 	if xPlayer.gang.label == 'gang' and xPlayer.gang.grade >= 9 then
		return true
	else
		print(('gangs: %s attempted open a gang boss menu!'):format(xPlayer.identifier))
		return false
	end
end


function isPlayerBossgm(playerId, gang)
	local xPlayer = ESX.GetPlayerFromId(playerId)

 	if xPlayer.gang.label == 'gang' and xPlayer.gang.grade >= Gangs[xPlayer.gang.name].invperm then
		return true
	else
		print(('gangs: %s attempted open a gang boss menu!'):format(xPlayer.identifier))
		return false
	end
end

AddEventHandler('playerDropped', function()
    _source = source
    if cooldown[_source] then
      cooldown[_source] = nil
    end
end)

function ban(source,Reason)
exports.Proxtended:bancheater(source, Reason)
end
ESX.RegisterServerCallback('gangs:SetPermData',function(source, cb, gang, grade, sitem, il)
	local xp = ESX.GetPlayerFromId(source)
	if xp.gang.name ~= gang or xp.gang.grade < 9 then
		ban(source,'try to moddify a gang with out being boss gang:'.. gang)
		cb()
		return
	end
	if il == "car" then
		local status = true
		local gitems = json.decode(Gangs[gang].grades[tonumber(grade)].cars)
		local found = false
		if gitems ~= nil then
			for i, item in ipairs(gitems) do
				if string.lower(item.name) == string.lower(sitem) then
					if item.state == false then
						table.insert(gitems,{
							name = item.name,
							state = true
						})
						table.remove(gitems, i)
						found = true
						break
					else
						table.insert(gitems,{
							name = item.name,
							state = false
						})
						table.remove(gitems, i)
						found = true
						break
					end
				end
			end
		else
			gitems = {}
		end
		if found == false then
			table.insert(gitems,{
				name = sitem,
				state = true
			})
		end
		Gangs[gang].grades[tonumber(grade)].cars = json.encode(gitems)
		MySQL.update('UPDATE gang_grades SET cars = @cars WHERE gang_name = @gang_name AND grade = @grade', {
			['@cars']   = json.encode(gitems),
			['@gang_name'] = gang,
			['@grade']    = grade
		}, function(rowsChanged)
			cb(true)
		end)
	end
end)

ESX.RegisterServerCallback('gangs:GetPermData', function(source, cb, gang, grade, type)
	if type == 'car' then
		local cars       = (Gangs[gang].grades[tonumber(grade)].cars)
		if cars == nil or cars == {} then
			TriggerClientEvent('esx:showNotification', source, 'Please set garades options in ~y~boss action')
		end
		cb(json.decode(cars))
	end
end)