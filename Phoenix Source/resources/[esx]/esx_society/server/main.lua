PX = nil
local Jobs = {}
local RegisteredSocieties = {}


TriggerEvent(Config.ESXtrigger, function(obj) PX = obj end)

function GetSociety(name)
	for i=tonumber(1), #RegisteredSocieties, tonumber(1) do
		if RegisteredSocieties[i].name == name then
			return RegisteredSocieties[i]
		end
	end
end

MySQL.ready(function()
	local result = MySQL.query.await('SELECT * FROM jobs', {})

	for i=tonumber(1), #result, tonumber(1) do
		Jobs[result[i].name]          = result[i]
		Jobs[result[i].name].grades   = {}
		Jobs[result[i].name].division = {}
	end

	local result2 = MySQL.query.await('SELECT * FROM job_grades', {})

	for i=tonumber(1), #result2, tonumber(1) do
			Jobs[result2[i].job_name].grades[tostring(result2[i].grade)] = result2[i]
	end

	local result3 = MySQL.query.await('SELECT * FROM divisions', {})

	for i=tonumber(1), #result3, tonumber(1) do
		Jobs[result3[i].job_name].division[result3[i].division_name] = result3[i]
	end

end)

AddEventHandler('esx_society:registerSociety', function(name, label, account, datastore, inventory, data)
	local found = false

	local society = {
		name      = name,
		label     = label,
		account   = account,
		datastore = datastore,
		inventory = inventory,
		data      = data,
	}

	for i=1, #RegisteredSocieties, 1 do
		if RegisteredSocieties[i].name == name then
			found = true
			RegisteredSocieties[i] = society
			break
		end
	end

	if not found then
		table.insert(RegisteredSocieties, society)
	end
end)

AddEventHandler('esx_society:getSocieties', function(cb)
	cb(RegisteredSocieties)
end)

AddEventHandler('esx_society:getSociety', function(name, cb)
	cb(GetSociety(name))
end)

--withdraw get money
RegisterServerEvent('esx_society:withdrawMoney')
AddEventHandler('esx_society:withdrawMoney', function(society, amount)
	local xPlayer = PX.GetPlayerFromId(source)
	local society = GetSociety(society)
	amount = PX.Math.Round(tonumber(amount))

	if xPlayer.job.name ~= society.name then
		print(('esx_society: %s attempted to call withdrawMoney!'):format(xPlayer.identifier))
		return
	end

	TriggerEvent('esx_addonaccount:getSharedAccount', society.account, function(account)
		if tonumber(amount) > tonumber(0) and tonumber(account.money) >= tonumber(amount) then
			account.removeMoney(tonumber(amount))
			xPlayer.addMoney(tonumber(amount))
			if xPlayer.job.name == "ambulance" then
				TriggerEvent('DiscordBot:ToDiscord', 'ambulanceboss', xPlayer.name, ' Remove ' ..amount ..'$ To '..xPlayer.job.label..' Account Money.' ,'user', source, true, false)
			end
			TriggerEvent('DiscordBot:ToDiscord', 'wash', xPlayer.name, ' Remove ' ..amount ..'$ To '..xPlayer.job.label..' Account Money.' ,'user', source, true, false)
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('have_withdrawn', PX.Math.GroupDigits(amount)))
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('invalid_amount'), 'error')
		end
	end)
end)

--deposit get money
RegisterServerEvent('esx_society:depositMoney')
AddEventHandler('esx_society:depositMoney', function(society, amount)
	local xPlayer = PX.GetPlayerFromId(source)
	local society = GetSociety(society)
	amount = PX.Math.Round(tonumber(amount))

	if xPlayer.job.name ~= society.name then
		print(('esx_society: %s attempted to call depositMoney!'):format(xPlayer.identifier))
		return
	end

	if amount > 0 and xPlayer.money >= amount then
		TriggerEvent('esx_addonaccount:getSharedAccount', society.account, function(account)
			xPlayer.removeMoney(tonumber(amount))
			account.addMoney(tonumber(amount))
			TriggerEvent('DiscordBot:ToDiscord', 'wash', xPlayer.name, ' Add ' ..amount ..'$ To '..xPlayer.job.label..' Account Money.' ,'user', source, true, false)
		end)

		TriggerClientEvent('esx:showNotification', xPlayer.source, _U('have_deposited', PX.Math.GroupDigits(amount)))
	else
		TriggerClientEvent('esx:showNotification', xPlayer.source, _U('invalid_amount'), 'error')
	end
end)

-- get money count
PX.RegisterServerCallback('esx_society:getSocietyMoney', function(source, cb, societyName)
	local society = GetSociety(societyName)

	if society then
		TriggerEvent('esx_addonaccount:getSharedAccount', society.account, function(account)
			cb(account.money)
		end)
	else
		cb(tonumber(0))
	end
end)

-- get employees of job
PX.RegisterServerCallback('esx_society:getEmployees', function(source, cb, society)
	if Config.EnableESXIdentity then

		results = MySQL.query.await('SELECT firstname, lastname, identifier, job, job_grade FROM users WHERE job = @job ORDER BY job_grade DESC', {
			['@job'] = society
		})
			local employees = {}

			for i=1, #results, 1 do
				if results[i].job_grade < tonumber(0) then
					results[i].job_grade = results[i].job_grade * tonumber(-1)
				end
				if Jobs[results[i].job].grades[tostring(results[i].job_grade)].name then
					table.insert(employees, {
						name       = results[i].firstname.." "..results[i].lastname,
						identifier = results[i].identifier,
						job = {
							name        = results[i].job,
							label       = Jobs[results[i].job].label,
							grade       = results[i].job_grade,
							grade_name  = Jobs[results[i].job].grades[tostring(results[i].job_grade)].name,
							grade_label = Jobs[results[i].job].grades[tostring(results[i].job_grade)].label
						}
					})
				end
			end

			cb(employees)
		-- end)
	else
		MySQL.query('SELECT name, identifier, job, job_grade FROM users WHERE job = @job ORDER BY job_grade DESC', {
			['@job'] = society
		}, function (result)
			local employees = {}

			for i=tonumber(1), #result, tonumber(1) do
				table.insert(employees, {
					name       = result[i].name,
					identifier = result[i].identifier,
					job = {
						name        = result[i].job,
						label       = Jobs[result[i].job].label,
						grade       = result[i].job_grade,
						grade_name  = Jobs[result[i].job].grades[tostring(result[i].job_grade)].name,
						grade_label = Jobs[result[i].job].grades[tostring(result[i].job_grade)].label
					}
				})
			end

			cb(employees)
		end)
	end
end)

-- get player job
PX.RegisterServerCallback('esx_society:getJob', function(source, cb, society)
	local job    = json.decode(json.encode(Jobs[society]))
	local grades = {}

	for k,v in pairs(job.grades) do
		table.insert(grades, v)
	end

	table.sort(grades, function(a, b)
		return a.grade < b.grade
	end)

	job.grades = grades

	cb(job)
end)

-- set player job
PX.RegisterServerCallback('esx_society:setJob', function(source, cb, identifier, job, grade, type)
	local xPlayer = PX.GetPlayerFromId(source)
	local isBoss = xPlayer.job.grade_name == 'boss'

	if isBoss then
		local xTarget = PX.GetPlayerFromIdentifier(identifier)

		if xTarget then
			xTarget.setJob(job, grade)

			if type == 'hire' then
				TriggerClientEvent('esx:showNotification', xTarget.source, _U('you_have_been_hired', job))
			elseif type == 'promote' then
				TriggerClientEvent('esx:showNotification', xTarget.source, _U('you_have_been_promoted'))
			elseif type == 'fire' then
				TriggerClientEvent('esx:showNotification', xTarget.source, _U('you_have_been_fired', xTarget.job.label))
			end

			cb()
		else
			MySQL.update('UPDATE users SET job = @job, job_grade = @job_grade WHERE identifier = @identifier', {
				['@job']        = job,
				['@job_grade']  = grade,
				['@identifier'] = identifier
			}, function(rowsChanged)
				cb()
			end)
		end
	else
		print(('esx_society: %s attempted to setJob'):format(xPlayer.identifier))
		cb()
	end
end)
-- set salar in DB and table
PX.RegisterServerCallback('esx_society:setJobSalary', function(source, cb, job, grade, salary)
	local isBoss = isPlayerBoss(source, job)
	local identifier = GetPlayerIdentifier(source, tonumber(0))

	if isBoss then
		if salary <= Config.MaxSalary then
			MySQL.update('UPDATE job_grades SET salary = @salary WHERE job_name = @job_name AND grade = @grade', {
				['@salary']   = salary,
				['@job_name'] = job,
				['@grade']    = grade
			}, function(rowsChanged)
				Jobs[job].grades[tostring(grade)].salary = salary
				local xPlayers = PX.GetPlayers()

				for i=tonumber(1), #xPlayers, tonumber(1) do
					local xPlayer = PX.GetPlayerFromId(xPlayers[i])

					if xPlayer.job.name == job and xPlayer.job.grade == grade then
						xPlayer.setJob(job, grade)
					end
				end

				cb()
			end)
		else
			print(('esx_society: %s attempted to setJobSalary over config limit!'):format(identifier))
			cb()
		end
	else
		print(('esx_society: %s attempted to setJobSalary'):format(identifier))
		cb()
	end
end)


--- Geting online players and information
PX.RegisterServerCallback('esx_society:getOnlinePlayers', function(source, cb)
	local xPlayers = PX.GetPlayers()
	local players  = {}

	for i=tonumber(1), #xPlayers, tonumber(1) do
		local xPlayer = PX.GetPlayerFromId(xPlayers[i])
		table.insert(players, {
			source     = xPlayer.source,
			identifier = xPlayer.identifier,
			name       = xPlayer.name,
			job        = xPlayer.job
		})
	end

	cb(players)
end)

--Get boolean for isboss
PX.RegisterServerCallback('esx_society:isBoss', function(source, cb, job)
	cb(isPlayerBoss(source, job))
end)
--checking player
function isPlayerBoss(playerId, job)
	local xPlayer = PX.GetPlayerFromId(playerId)
	if xPlayer.job.name == job and xPlayer.job.grade_name == 'boss' then
		return true
	else
		print(('esx_society: %s attempted open a society boss menu!'):format(xPlayer.identifier))
		return false
	end
end
-- get job garades
PX.RegisterServerCallback('esx_society:getGrades', function(source, cb, plate)
	local xPlayer = PX.GetPlayerFromId(source)
	  cb(PX.GetJob(xPlayer.job.name).grades)

end)
-- updating Grade names in DB and table
PX.RegisterServerCallback('esx_society:renameGrade', function(source, cb, grade, name)
	local _source, grade, name = source, grade, name
	local xPlayer = PX.GetPlayerFromId(_source)

	if xPlayer.job.name == "nojob" then
		cb(false)
		print(('esx_society: %s "Tried to rename job label"!'):format(xPlayer.identifier))
		return
	end

	if xPlayer.job.grade_name == 'boss' then
		if PX.SetJobGrade(xPlayer.job.name, grade, name) then

			local xPlayers = PX.GetPlayers()

			for i=tonumber(1), #xPlayers, tonumber(1) do
				local Member = PX.GetPlayerFromId(xPlayers[i])

				if Member.job.name == xPlayer.job.name and Member.job.grade == grade then


					Member.setJob(xPlayer.job.name, grade)
				end

			end

			cb(true)
		else
			cb(false)
			TriggerClientEvent('chatMessage', _source, "[SYSTEM]", {tonumber(255), tonumber(0), tonumber(0)}, " ^0Khatayi dar avaz kardan esm job grade shoma pish amad be developer etelaa dahid!")
		end
	else
		cb(false)	
		print(("Tried to rename " .. xPlayer.job.name .. " grade without boss level"):format(xPlayer.identifier))
	end

end)

-- geting permissions from tables
PX.RegisterServerCallback('esx_society:getUniforms', function(source, cb, rank, job)
	local fskin = {}
	local mskin = {}
	fskin       = json.decode(Jobs[job].grades[tostring(rank)].skin_female)
	mskin       = json.decode(Jobs[job].grades[tostring(rank)].skin_male)
	if mskin == nil or mskin == '' or fskin == nil or fskin == '' then
		TriggerClientEvent('esx:showNotification', source, 'Please set garades options in ~y~boss action', 'error')
	end

		cb(mskin, fskin)

end)

PX.RegisterServerCallback('esx_society:getVehicles', function(source, cb, rank, job)
	local veh = (Jobs[job].grades[tostring(rank)].vehicles)
	if veh == nil or veh == '' then
		TriggerClientEvent('esx:showNotification', source, 'Please set garades options in ~y~boss action', 'error')
	end
	cb(json.decode(veh))
end)

PX.RegisterServerCallback('esx_society:getDivVehicles', function(source, cb, name)
	local xPlayer = PX.GetPlayerFromId(source)
	local job     = xPlayer.job.name
	local veh     = (Jobs[job].division[name].vehicles)
	if veh == nil or veh == '' then
		TriggerClientEvent('esx:showNotification', source, 'Please set garades options in ~y~boss action', 'error')
	end
	cb(json.decode(veh))
end)

PX.RegisterServerCallback('esx_society:getmyDivVehicles', function(source, cb)
	local xPlayer = PX.GetPlayerFromId(source)
	local job     = xPlayer.job.name
	local divs    = xPlayer.divisions
	local vehs 	  = {}
	for _,v in ipairs(divs) do
		local veh     = json.decode(Jobs[job].division[v].vehicles)
		if veh ~= nil or veh ~= '' then
			table.insert(vehs, veh)
		end
	end
	cb(vehs)
end)

PX.RegisterServerCallback('esx_society:getEmployeclothes', function(source, cb, rank, gender, job)
	local fskin = {}
	local mskin = {}
	fskin       = json.decode(Jobs[job].grades[tostring(rank)].skin_female)
	mskin       = json.decode(Jobs[job	].grades[tostring(rank)].skin_male)

	if gender == 'male' then
		cb(mskin)
	elseif  gender == 'female' then 
		cb(fskin)
	end

end)

PX.RegisterServerCallback('esx_society:getdivisionclothes', function(source, cb, name, gender)
	local xP = PX.GetPlayerFromId(source)
	local job = xP.job.name
	local fskin = {}
	local mskin = {}
	fskin       = json.decode(Jobs[job].division[name].skin_female)
	mskin       = json.decode(Jobs[job].division[name].skin_male)

	if gender == 'man' then
		cb(mskin)
	elseif  gender == 'woman' then 
		cb(fskin)
	end

end)

PX.RegisterServerCallback('esx_society:getmydivisionclothes', function(source, cb, gender)
	local xP = PX.GetPlayerFromId(source)
	local divs = xP.divisions
	local jobn = xP.job.name
	local skins = {}
	for _,v in ipairs(divs) do
		if gender == 'man' then
			if json.decode(Jobs[jobn].division[v].skin_male) ~= nil then
				table.insert(skins,{
					name = v,
					outfit = json.decode(Jobs[jobn].division[v].skin_male)
				})
			end
		else
			if json.decode(Jobs[jobn].division[v].skin_female) ~= nil then
				table.insert(skins,{
					name = v,
					outfit = json.decode(Jobs[jobn].division[v].skin_female)
				})
			end
		end
	end
	cb(skins)
end)

PX.RegisterServerCallback('esx_society:getDivision', function(source, cb, identifier)
	local xPlayer = PX.GetPlayerFromId(source)
	local isBoss = xPlayer.job.grade_name == 'boss'
	if isBoss then
		local xTarget = PX.GetPlayerFromIdentifier(identifier)
		local jobdiv = {}
		if xTarget then
			for i,v in ipairs(xTarget.job.divisions) do
				local found = false
				for i2,v2 in ipairs(xTarget.divisions) do
					if v == v2 then
						table.insert(jobdiv,{
							name = v,
							state = true
						})
						found = true
						break
					end
				end
				if not found then
					table.insert(jobdiv,{
						name = v,
						state = false
					})
				end
			end
			cb(jobdiv)
		else
			MySQL.query('SELECT * FROM users WHERE identifier = @identifier',
			{
				['@identifier'] = identifier,
		
			}, function(result)
				if result[1] then
					local divs = json.decode(result[1].divisions) or {}
					for i,v in ipairs(xPlayer.job.divisions) do
						local found = false
						for i2,v2 in ipairs(divs) do
							if v == v2 then
								table.insert(jobdiv,{
									name = v,
									state = true
								})
								found = true
								break
							end
						end
						if not found then
							table.insert(jobdiv,{
								name = v,
								state = false
							})
						end
					end
					cb(jobdiv)
				end
			end)
		end
	else
		print(('esx_society: %s attempted to setDivision'):format(xPlayer.identifier))
		cb()
	end

end)

-- updating DB and tables

PX.RegisterServerCallback('esx_society:getJobDivision', function(source,cb)
	local xPlayer = PX.GetPlayerFromId(source)
	local divs = xPlayer.job.divisions
	cb(divs)
end)

PX.RegisterServerCallback('esx_society:setEmployeDiv', function(source, cb, identifier, name, state)
	local xPlayer = PX.GetPlayerFromId(source)
	local isBoss = xPlayer.job.grade_name == 'boss'

	if isBoss then
		local xTarget = PX.GetPlayerFromIdentifier(identifier)

		if xTarget then
			if state == false then
				xTarget.addDivision(name)
				TriggerClientEvent('esx:showNotification', xTarget.source, 'Now you have this division: ~b~'..name)
				cb()
			elseif state == true then
				xTarget.removeDivision(name)
				TriggerClientEvent('esx:showNotification', xTarget.source, 'Now you don\'t have this division: ~b~'..name)
				cb()
			end
		else
			if state == false then
				MySQL.query('SELECT * FROM users WHERE identifier = @identifier',
				{
					['@identifier'] = identifier,
			
				}, function(result)
					if result[1] then
						local divs = json.decode(result[1].divisions) or {}
						table.insert(divs, name)
						MySQL.update('UPDATE users SET divisions = @divisions WHERE identifier = @identifier', {
							['@identifier']   = identifier,
							['@divisions'] 	  = json.encode(divs),
						}, function(rowsChanged)
							cb()
						end)
					end
				end)
			elseif state == true then
				MySQL.query('SELECT * FROM users WHERE identifier = @identifier',
				{
					['@identifier'] = identifier,
			
				}, function(result)
					if result[1] then
						local divs = json.decode(result[1].divisions) or {}
							for i,v in ipairs(divs) do
								if v == name then
									table.remove(divs, i)
								end
							end
						MySQL.update('UPDATE users SET divisions = @divisions WHERE identifier = @identifier', {
							['@identifier']   = identifier,
							['@divisions'] 	  = json.encode(divs),
						}, function(rowsChanged)
							cb()
						end)
					end
				end)
			end
		end
	else
		print(('esx_society: %s attempted to setDivision'):format(xPlayer.identifier))
		cb()
	end
end)

PX.RegisterServerCallback('esx_society:addDivision', function(source, cb, name)
	local xPlayer = PX.GetPlayerFromId(source)
	local job = xPlayer.job.name
	local isBoss = isPlayerBoss(source, job)
	local identifier = GetPlayerIdentifier(source, tonumber(0))
	if isBoss then
		if PX.AddDivision(job, name) then
			Jobs[job].division[name] = {}
			cb(true)
		else
			cb(false)
		end
	else
		print(('esx_society: %s attempted to add division'):format(identifier))
		cb()
	end
end)

PX.RegisterServerCallback('esx_society:removeDivision', function(source, cb, name)
	local xPlayer = PX.GetPlayerFromId(source)
	local job = xPlayer.job.name
	local isBoss = isPlayerBoss(source, job)
	local identifier = GetPlayerIdentifier(source, tonumber(0))
	if isBoss then
		if PX.RemoveDivision(job, name) then
			local xPlayers = PX.GetPlayers()
			for i,v in ipairs(xPlayers) do
				local xP = PX.GetPlayerFromId(v)
				if xP.job.name == job then
					local division = xP.divisions
					for k2,v2 in ipairs(division) do
						if v2 == name then
							xP.removeDivision(name)
						end
					end
				end
			end
			cb(true)
		else
			cb(false)
		end
	else
		print(('esx_society: %s attempted to remove division'):format(identifier))
		cb()
	end
end)

PX.RegisterServerCallback('esx_society:setSocietyVehPerm', function(source, cb, job, rank, vehs, status, choice)
	local isBoss = isPlayerBoss(source, job)
	local identifier = GetPlayerIdentifier(source, tonumber(0))
	local vehtable = {}
	if isBoss then
		for _, veh in ipairs(vehs) do
			if veh.model ~= choice then
				table.insert(vehtable,{
					model = veh.model,
					status = veh.value
				})
			else
				if status then
					table.insert(vehtable,{
						model = veh.model,
						status = true
					})
				else
					table.insert(vehtable,{
						model = veh.model,
						status = false
					})
				end
			end
		end
		Jobs[job].grades[tostring(rank)].vehicles = json.encode(vehtable)
		MySQL.update('UPDATE job_grades SET vehicles = @vehicles WHERE job_name = @job_name AND grade = @grade', {
			['@vehicles']   = json.encode(vehtable),
			['@job_name'] = job,
			['@grade']    = rank
		}, function(rowsChanged)
			cb(true)
		end)
	else
		print(('esx_society: %s attempted to setSocietyVehPerm'):format(identifier))
		cb()
	end
end)

PX.RegisterServerCallback('esx_society:setSocietyDivVehPerm', function(source, cb, job, name, choice)
	local isBoss = isPlayerBoss(source, job)
	local identifier = GetPlayerIdentifier(source, tonumber(0))
	if isBoss then
		local vehs = json.decode(Jobs[job].division[name].vehicles) or {}
		local found = false
		local newstate = true
		for k,v in ipairs(vehs) do
			if v.model == choice then
				found = true
				if v.status == true then
					newstate = false
				elseif v.status == false then
					newstate = true
				end
				table.remove(vehs,k)
			end
		end
		if found then
			table.insert(vehs,{
				model = choice,
				status = newstate
			})
		else
			table.insert(vehs,{
				model = choice,
				status = true
			})
		end
		
		MySQL.update('UPDATE divisions SET vehicles = @vehicles WHERE job_name = @job_name AND division_name = @division_name', {
			['@vehicles']   		= json.encode(vehs),
			['@job_name'] 			= job,
			['@division_name']    	= name
		}, function(rowsChanged)
			Jobs[job].division[name].vehicles = json.encode(vehs)
			cb()
		end)
	else
		print(('esx_society: %s attempted to setSocietyVehPerm'):format(identifier))
		cb()
	end
end)

PX.RegisterServerCallback('esx_society:setUniform', function(source, cb, job, rank, gender, model)
	local isBoss = isPlayerBoss(source, job)
	local identifier = GetPlayerIdentifier(source, tonumber(0))

	if isBoss then
		if gender == 'male' then
			MySQL.update('UPDATE job_grades SET skin_male = @skin_male WHERE job_name = @job_name AND grade = @grade', {
				['@skin_male']   = json.encode(model),
				['@job_name'] = job,
				['@grade']    = rank
			}, function(rowsChanged)
				Jobs[job].grades[tostring(rank)].skin_male = json.encode(model)
				
				cb()
			end)
		elseif  gender == 'female' then 
			MySQL.update('UPDATE job_grades SET skin_female = @skin_female WHERE job_name = @job_name AND grade = @grade', {
				['@skin_female']   = json.encode(model),
				['@job_name'] = job,
				['@grade']    = rank
			}, function(rowsChanged)
				Jobs[job].grades[tostring(rank)].skin_female = json.encode(model)

				cb()
			end)
		end
	else
		print(('esx_society: %s attempted to setJobUniform'):format(identifier))
		cb()
	end
end)

PX.RegisterServerCallback('esx_society:setdivUniform', function(source, cb, name, gender, model)
	local xP = PX.GetPlayerFromId(source)
	local job = xP.job.name
	local isBoss = isPlayerBoss(source, job)
	local identifier = GetPlayerIdentifier(source, tonumber(0))
	if isBoss then
		if gender == 'man' then
			MySQL.update('UPDATE divisions SET skin_male = @skin_male WHERE job_name = @job_name AND division_name = @division_name', {
				['@skin_male']   		= json.encode(model),
				['@job_name'] 			= job,
				['@division_name']    	= name
			}, function(rowsChanged)
				Jobs[job].division[name].skin_male = json.encode(model)
				cb()
			end)
		elseif  gender == 'woman' then 
			MySQL.update('UPDATE divisions SET skin_female = @skin_female WHERE job_name = @job_name AND division_name = @division_name', {
				['@skin_female']   		= json.encode(model),
				['@job_name'] 			= job,
				['@division_name']    	= name
			}, function(rowsChanged)
				Jobs[job].division[name].skin_female = json.encode(model)
				cb()
			end)
		end
	else
		print(('esx_society: %s attempted to setDivUniform'):format(identifier))
		cb()
	end
end)