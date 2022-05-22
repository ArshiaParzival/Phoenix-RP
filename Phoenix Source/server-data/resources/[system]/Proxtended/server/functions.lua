ESX.Trace = function(str)
	if Config.EnableDebug then
		print('ESX> ' .. str)
	end
end

ESX.SetTimeout = function(msec, cb)
	local id = ESX.TimeoutCount + 1
	SetTimeout(msec, function()
		if ESX.CancelledTimeouts[id] then
			ESX.CancelledTimeouts[id] = nil
		else
			cb()
		end
	end)

	ESX.TimeoutCount = id
	return id
end

ESX.ClearTimeout = function(id)
	ESX.CancelledTimeouts[id] = true
end

ESX.RegisterServerCallback = function(name, cb)
	ESX.ServerCallbacks[name] = cb
end

ESX.TriggerServerCallback = function(name, requestId, source, cb, ...)
	if ESX.ServerCallbacks[name] ~= nil then
		ESX.ServerCallbacks[name](source, cb, ...)
	else
		print('Proxtended: TriggerServerCallback => [' .. name .. '] does not exist')
	end
end

ESX.SetPermission = function(iden, perm)
	MySQL.query.await('UPDATE users SET permission_level = @perm WHERE identifier = @identifier', {
		['@perm'] = perm,
		['@identifier'] = iden,
	})
	return true
end

ESX.SavePlayer = function(Source, cb)
	local asyncTasks     = {}
	--inventory
	local invent = {}
	if not Users[Source] then
		return
	end
	if #Users[Source].inventory > 0 then
		for _,v in  ipairs(Users[Source].inventory) do
			table.insert(invent, {item	= v.name, count = v.count})
		end
	end
	
	table.insert(asyncTasks, function(cb)
		MySQL.update('UPDATE users SET `money` = @money, `bank` = @bank, `salary` = @salary, `stress` = @stress, `position` = @position, `inventory` = @inventory WHERE identifier = @identifier',
		{
			['@money']      = Users[Source].money,
			['@bank']  		= Users[Source].bank,
			['@salary']  	= Users[Source].salary,
			['@stress']  	= Users[Source].stress,
			['@position']   = json.encode(Users[Source].coords),
			['@inventory']  = json.encode(invent),
			['@identifier']	= Users[Source].identifier
		}, function(rowsChanged)
			cb()
		end)
	end)
	Async.parallel(asyncTasks, function(results)
		if cb ~= nil then
			cb()
		end
	end)

end

ESX.SavePlayers = function(cb)
	local asyncTasks = {}
	local xPlayers   = ESX.GetPlayers()

	for i=1, #xPlayers, 1 do
		table.insert(asyncTasks, function(cb)
			ESX.SavePlayer(xPlayers[i], cb)
		end)
	end

	Async.parallelLimit(asyncTasks, 1, function(results)
		RconPrint('Tamami Player Ha [SAVE SHOD]' .. "\n")

		if cb ~= nil then
			cb()
		end
	end)
end

ESX.StartDBSync = function()
	function saveData()
		ESX.SavePlayers()
		SetTimeout(10 * 60 * 1000, saveData)
	end

	SetTimeout(10 * 60 * 1000, saveData)
end
ESX.StartDBSync()

ESX.GetPlayers = function()
	local sources = {}

	for k,v in pairs(Users) do
		table.insert(sources, k)
	end

	return sources
end

ESX.GetSteamID = function (src)
	local sid = GetPlayerIdentifiers(src)[1] or false

	if (sid == false or sid:sub(1,5) ~= "steam") then
		return false
	end

	return sid
end

ESX.GetDiscordID = function (src)
	for k,v in ipairs(GetPlayerIdentifiers(src))do
		if string.sub(v, 1, string.len("discord:")) == "discord:" then
			return v
		end
	end
	return false
end

ESX.GetPlayerFromId = function(source)
	return Users[tonumber(source)]
end

ESX.GetPlayerFromIdentifier = function(identifier)
	for k,v in pairs(Users) do
		if v.identifier == identifier then
			return v
		end
	end
end

ESX.GetPlayerFromPlate = function(Plate)
	local result = MySQL.query.await('SELECT * FROM `owned_vehicles` WHERE `plate` = "'.. Plate ..'"', {})
	local owner
	if result[1] then
		owner = result[1].owner
	else
		return nil, nil
	end
	if string.find(owner, "steam") then
		local xPlayers = ESX.GetPlayers()
		local player = nil
		if xPlayers then
			for i=1, #xPlayers, 1 do
				local compare = owner == GetPlayerIdentifiers(xPlayers[i])[1]
				if compare then
					return player, nil
				end
			end
		end
	else
		return nil, owner
	end
end

ESX.GetTotalWeight = function(items)
	local weight = 0
	if items ~= nil then
		for slot, item in pairs(items) do
			weight = weight + (item.weight * item.count)
		end
	end
	return tonumber(weight)
end

ESX.GetSlotsByItem = function(items, itemName)
	local slotsFound = {}
	if items ~= nil then
		for slot, item in pairs(items) do
			if item.name:lower() == itemName:lower() then
				table.insert(slotsFound, slot)
			end
		end
	end
	return slotsFound
end

ESX.GetFirstSlotByItem = function(items, itemName)
	if items ~= nil then
		for slot, item in pairs(items) do
			if item.name:lower() == itemName:lower() then
				return tonumber(slot)
			end
		end
	end
	return nil
end

ESX.RegisterUsableItem = function(item, cb)
	ESX.UsableItemsCallbacks[item] = cb
end

ESX.UseItem = function(source, item)
	ESX.UsableItemsCallbacks[item.name](source, item)
end

ESX.GetItemLabel = function(item)
	if ESX.Items[item] ~= nil then
		return ESX.Items[item].label
	end
end

local weaponsObj = {
	{name = 'WEAPON_ASSAULTRIFLE', 	obj = 'w_ar_assaultrifle'},
	{name = 'WEAPON_SNSPISTOL', 	obj = 'w_pi_sns_pistol'},
	{name = 'WEAPON_PISTOL50', 		obj = 'w_pi_pistol50'},
	{name = 'WEAPON_PISTOL', 		obj = 'w_pi_pistol'},
	{name = 'WEAPON_HEAVYPISTOL', 	obj = 'w_pi_heavypistol'},
	{name = 'WEAPON_SMG', 			obj = 'w_sb_smg'},
	{name = 'WEAPON_BAT', 			obj = 'w_me_bat'},
	{name = 'WEAPON_CROWBAR', 		obj = 'w_me_crowbar'},
	{name = 'WEAPON_GCLUB', 		obj = 'w_me_gclub'},
	{name = 'WEAPON_HAMMER', 		obj = 'w_me_hammer'},
	{name = 'WEAPON_NIGHTSTICK', 	obj = 'w_me_nightstick'},
	{name = 'WEAPON_CARBINERIFLE',  obj = 'w_ar_carbinerifle'},
	{name = 'WEAPON_KNIFE', 		obj = 'w_me_knife_01'},
	{name = 'pizza',				obj = 'prop_pizza_box_02'},
	{name = 'snack',				obj = 'prop_ld_snack_01'},
	{name = 'chips',				obj = 'v_ret_ml_chips2'},
	{name = 'burger',				obj = 'prop_cs_burger_01'},
	{name = 'macka',				obj = 'prop_food_bs_burger2'},
	{name = 'bread',				obj = 'v_ret_247_bread1'},
	{name = 'cheesebows',			obj = 'prop_ld_snack_01'},
	{name = 'cocacola',				obj = 'ng_proc_sodacan_01a'},
	{name = 'sprite',				obj = 'ng_proc_sodacan_01b'},
	{name = 'radio',				obj = 'prop_cs_hand_radio'},
	{name = 'lighter',				obj = 'p_cs_lighter_01'},
	{name = 'phone',				obj = 'prop_player_phone_01'},
	{name = 'cigarett',				obj = 'ng_proc_cigar01a'}
}

ESX.GetWeaponObject = function(name)
	for i=1, #weaponsObj do
		if weaponsObj[i].name == name then
			return weaponsObj[i].obj
		end
	end
	return nil
end

ESX.DoesJobExist = function(job, grade)
	if job and grade then
		if ESX.Jobs[job] and ESX.Jobs[job].grades[grade] then
			return true
		end
	end

	return false
end

ESX.DoesDivisionExist = function(job, division)
	local divisions = ESX.Jobs[job].divisions
	local exist = false

	for _,v in ipairs(divisions) do
		if v == division then
			exist = true
		end
	end
	return exist
end

ESX.GetJobDivisions = function(job)
    return ESX.Jobs[job].divisions
end

ESX.AddDivision = function(job, division)
	if not ESX.DoesDivisionExist(job, division) then
		MySQL.update('INSERT INTO divisions (division_name, job_name) VALUES (@division_name, @job_name)', {
			['@division_name']      = division,
			['@job_name']       	= job,
		}, function(rowsChanged)
			local divisions = ESX.Jobs[job].divisions or {}
			table.insert(divisions, division)
			ESX.Jobs[job].divisions = divisions
		end)
		return true
	end
	return false
end

ESX.RemoveDivision = function(job, division)
	if ESX.DoesDivisionExist(job, division) then

			MySQL.update('DELETE FROM divisions WHERE division_name = @division_name AND job_name = @job_name;', {
				['@division_name']      = division,
				['@job_name']       	= job,
			}, function(rowsChanged)
				local divisions = ESX.Jobs[job].divisions or {}

				for i,v in ipairs(divisions) do
					if v == division then
						table.remove(divisions, i)
					end
				end
				ESX.Jobs[job].divisions = divisions
			end)

		return true

	end

	return false
end

function GetPlayerICName(source)
	if Users[source] and Users[source].name then
		return Users[source].name
	end
end

ESX.DoesGangExist = function(gang, grade)
	grade = tonumber(grade)

	if gang and grade then
		if ESX.Gangs[gang] and ESX.Gangs[gang].grades[grade] then
			return true
		end
	end

	return false
end
ESX.GetGang = function(gang)
	if ESX.DoesGangExist(gang, 1) then
		return ESX.Gangs[gang]
	else
		return nil
	end
end

ESX.SetGangGrade = function(gang, grade, name)
	if ESX.DoesGangExist(gang, grade) then
		ESX.Gangs[gang].grades[grade].label = name
		MySQL.query.await('UPDATE gang_grades SET label = @name WHERE grade = @grade AND gang_name = @gang', {
			['@name'] = name,
			['@grade'] = grade,
			['@gang'] = gang
		})
		return true
	else
		return nil
	end
end

ESX.GetJob = function(job)
	if ESX.DoesJobExist(job, 1) then
		return ESX.Jobs[job]
	else
		return nil
	end
end

ESX.SetJobGrade = function(job, grade, name)
	if ESX.DoesJobExist(job, grade) then
		ESX.Jobs[job].grades[grade].label = name
			MySQL.query.await('UPDATE job_grades SET label = @name WHERE grade = @grade AND job_name = @job', {
				['@name'] = name,
				['@grade'] = grade,
				['@job'] = job
			})
		return true
	else
		return nil
	end
end