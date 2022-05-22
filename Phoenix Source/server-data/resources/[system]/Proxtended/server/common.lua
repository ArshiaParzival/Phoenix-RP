ESX                      = {}
ESX.Players              = {}
ESX.UsableItemsCallbacks = {}
ESX.ServerCallbacks      = {}
ESX.TimeoutCount         = -1
ESX.CancelledTimeouts    = {}
ESX.LastPlayerData       = {}
ESX.Jobs                 = {}
ESX.Gangs			 	 = {}
Admins					 = {}

AddEventHandler('esx:getSharedObject', function(cb)
	cb(ESX)
end)

function getSharedObject()
	return ESX
end

MySQL.ready(function()

	local result = MySQL.query.await('SELECT * FROM jobs', {})

	for i=1, #result do
		ESX.Jobs[result[i].name] = result[i]
		ESX.Jobs[result[i].name].grades = {}
		ESX.Jobs[result[i].name].divisions = {}
	end

	local result2 = MySQL.query.await('SELECT * FROM job_grades', {})

	for i=1, #result2 do
		if ESX.Jobs[result2[i].job_name] then
			ESX.Jobs[result2[i].job_name].grades[tonumber(result2[i].grade)] = result2[i]
		else
			print(('Proxtended: invalid job "%s" from table job_grades ignored!'):format(result2[i].job_name))
		end
	end

	for k,v in pairs(ESX.Jobs) do
		if next(v.grades) == nil then
			ESX.Jobs[v.name] = nil
			print(('Proxtended: ignoring job "%s" due to missing job grades!'):format(v.name))
		end
	end

	MySQL.query('SELECT * FROM divisions', {}, function(division)
		for k3,v3 in pairs(division) do
			table.insert(ESX.Jobs[v3.job_name].divisions, v3.division_name)
		end
	end)

	local gang = MySQL.query.await('SELECT * FROM gangs', {})

	for i=1, #gang do
		ESX.Gangs[gang[i].name] 		= gang[i]
		ESX.Gangs[gang[i].name].grades 	= {}
	end

	local gang2 = MySQL.query.await('SELECT * FROM gang_grades', {})

	for i=1, #gang2 do
		if ESX.Gangs[gang2[i].gang_name] then
			ESX.Gangs[gang2[i].gang_name].grades[tonumber(gang2[i].grade)] = gang2[i]
		else
			print(('Proxtended: invalid gang "%s" from table gang_grades ignored!'):format(gang2[i].gang_name))
		end
	end

	for k,v in pairs(ESX.Gangs) do
		if next(v.grades) == nil then
			ESX.Gangs[v.name] = nil
			print(('Proxtended: ignoring gang "%s" due to missing gang grades!'):format(v.name))
		end
	end
end)

AddEventHandler('ChangeGangSkin', function(gang, grade, male, newCloths)
	if male then
		ESX.Gangs[gang].grades[tonumber(grade)].skin_male 	= json.encode(newCloths)
	else
		ESX.Gangs[gang].grades[tonumber(grade)].skin_female = json.encode(newCloths)
	end
end)

AddEventHandler('ChangeGangSkin2', function(gang, grade, male, newCloths)
	if male then
		ESX.Gangs[gang].grades[tonumber(grade)].skin_male2 	= json.encode(newCloths)
	else
		ESX.Gangs[gang].grades[tonumber(grade)].skin_female2 = json.encode(newCloths)
	end
end)

AddEventHandler('ChangeGangSkin3', function(gang, grade, male, newCloths)
	if male then
		ESX.Gangs[gang].grades[tonumber(grade)].skin_male3 	= json.encode(newCloths)
	else
		ESX.Gangs[gang].grades[tonumber(grade)].skin_female3 = json.encode(newCloths)
	end
end)

RegisterServerEvent('esx:triggerServerCallback')
AddEventHandler('esx:triggerServerCallback', function(name, requestId, ...)
	local _source = source
	ESX.TriggerServerCallback(name, requestID, _source, function(...)
		TriggerClientEvent('esx:serverCallback', _source, requestId, ...)
	end, ...)
end)

RegisterServerEvent('Proxtended:addGang')
AddEventHandler('Proxtended:addGang', function(name,ranks)
	ESX.Gangs[name] = {name = name,label = 'gang'}
	ESX.Gangs[name].grades = {}
	for i=1, #ranks, 1 do
		ESX.Gangs[name].grades[tonumber(i)] = {gang_name = name, grade = i, name = 'Rank'..i, label = 'Rank'..i, salary = 100*i, skin_male = '{}', skin_female = '{}', skin_male2 = '{}', skin_female2 = '{}', skin_male3 = '{}', skin_female3 = '{}'}
	end
end)