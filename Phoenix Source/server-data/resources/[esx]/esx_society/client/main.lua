PX = nil
local InBossMenu	= false
local LastPosition		= nil
Citizen.CreateThread(function()
	while PX == nil do
		TriggerEvent(Config.ESXtrigger, function(obj) PX = obj end)
		Citizen.Wait(tonumber(0))
	end

	while PX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PX.PlayerData = PX.GetPlayerData()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PX.PlayerData.job = job
end)

function OpenBossMenu(society, close, options)
	local isBoss = nil
	local options  = options or {}
	local elements = {}

	PX.TriggerServerCallback('esx_society:isBoss', function(result)
		isBoss = result
	end, society)

	while isBoss == nil do
		Citizen.Wait(tonumber(100))
	end

	if not isBoss then
		return
	end

	local defaultOptions = {
		withdraw  = true,
		deposit   = true,
		wash      = false,
		employees = true,
		job    = true,
	}

	for k,v in pairs(defaultOptions) do
		if options[k] == nil then
			options[k] = v
		end
	end

	local wait = true
	PX.TriggerServerCallback('esx_society:getSocietyMoney', function(money)
		table.insert(elements ,{label = 'Society Money: <span style="color:green;">$'.. money .. '</span>', value = nil})
		wait = false
	end, PX.PlayerData.job.name)

	while wait do
		Citizen.Wait(tonumber(0))
	end

	if options.withdraw then
		table.insert(elements, {label = _U('withdraw_society_money'), value = 'withdraw_society_money'})
	end

	if options.deposit then
		table.insert(elements, {label = _U('deposit_society_money'), value = 'deposit_money'})
	end

	if options.employees then
		table.insert(elements, {label = _U('employee_management'), value = 'manage_employees'})
	end

	if options.job then
		table.insert(elements, {label = _U('manage_job'), value = 'manage_job'})
	end

	PX.UI.Menu.Open('default', GetCurrentResourceName(), 'boss_actions_' .. society, {
		title    = _U('boss_menu'),
		align    = 'top-left',
		elements = elements
	}, function(data, menu)

		if data.current.value == 'withdraw_society_money' then
			if Config.Withdraw == true then

				PX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'withdraw_society_money_amount_' .. society, {
					title = _U('withdraw_amount')
				}, function(data, menu)

					local amount = tonumber(data.value)

					if amount == nil then
						PX.ShowNotification(_U('invalid_amount'), 'error')
					else
						menu.close()
						TriggerServerEvent('esx_society:withdrawMoney', society, amount)
						OpenBossMenu(society, close, options)
					end

				end, function(data, menu)
					menu.close()
				end)
			else
				PX.ShowNotification(Config.WithdrawMsg, 'error')
			end
		elseif data.current.value == 'deposit_money' then
			OpenDepositMoney(society, close, options)
		elseif data.current.value == 'manage_employees' then
			OpenManageEmployeesMenu(society)
		elseif data.current.value == 'manage_job' then
			OpenManageJobMenu(society)
		end

	end, function(data, menu)
		if close then
			close(data, menu)
		end
	end)

end

function OpenManageJobMenu(society)
	if not InBossMenu then
		LastPosition = GetEntityCoords(PlayerPedId())
	end
	PX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_job' .. society, {
		title    = _U('manage_job'),
		align    = 'top-left',
		elements = {
			-- {label = _U('salary_management'), value = 'manage_grades'},
			{label = _U('manage_grades_name'), value = 'manage_grades_name'},
			{label = _U('manage_grades_outfit'), value = 'manage_grades_outfit'},
			{label = _U('manage_vehicles'), value = 'manage_vehicles'},
			{label = 'Manage divisions', value = 'manage_divisions'},
		}
	}, function(data, menu)

		if data.current.value == 'manage_grades' then
			OpenManageGradesMenu(society)
		end
		
		if data.current.value == 'manage_grades_name' then
			OpenGradeNames(society)
		end

		if data.current.value == 'manage_grades_outfit' then
			OpenSetOutfitMenu(society)
		end

		if data.current.value == 'manage_divisions' then
			if DoesHaveDivision(society) then
				OpenDivision(society)
			else
				PX.ShowNotification("Your job does not have division", 'error')
			end
		end

		if data.current.value == 'manage_vehicles' then
			if DoesHaveGarage(society) then
				OpenVehiclesManagment(society)
			else
				PX.ShowNotification("Your job does not have garage", 'error')
			end
		end
		
	end, function(data, menu)
		menu.close()
	end)
end

function OpenVehiclesManagment(society)
	PX.TriggerServerCallback('esx_society:getGrades', function(grades)
		local elements = {}
		  for k,v in pairs(grades) do
			  table.insert(elements, {label = v.label, grade = k})
		  end
        PX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_grades_' .. society .. '_new', {
            title = "Manage Grades",
            align = 'top-left',
            elements = elements
        }, function(data, menu)
            local gradeNumber = tonumber(data.current.grade)
				ChangeVehiclePerm(society,gradeNumber)
		end, function(data1, menu1)
			menu1.close()
		end)
	end, society)
end

function ChangeVehiclePerm(society,rank)
	local authorizedVehicles = Config.Garage[society]
	if authorizedVehicles then
		PX.TriggerServerCallback('esx_society:getVehicles', function(vehs)
			local rows = {}
		
			for k, society_vehicles in ipairs(authorizedVehicles) do
				local found = false
				
				if vehs then

					for k2, vehicle_state in ipairs(vehs) do
						if string.lower(society_vehicles) == string.lower(vehicle_state.model) then
							if GetDisplayNameFromVehicleModel(GetHashKey(vehicle_state.model)) then
								if vehicle_state.status == true then
									table.insert(rows, { label = vehicle_state.model .. " | [<font color=Lime>Fa\'al</font>]", model = vehicle_state.model, value = vehicle_state.status })
								elseif vehicle_state.status == false then
									table.insert(rows, { label = vehicle_state.model .. " | [<font color=red>gheyre Fa\'al</font>]", model = vehicle_state.model, value = vehicle_state.status })
								end
							else
								table.insert(rows, { label = vehicle_state.model .. " | [<font color=yellow>Unknown</font>]", model = vehicle_state.model, value = vehicle_state.status })
							end

							found = true
							break
						end
					end
				end

				if not found then
					table.insert(rows, { label = GetDisplayNameFromVehicleModel(GetHashKey(society_vehicles)) .. " | [<font color=red>gheyre Fa\'al</font>]", model = society_vehicles, value = false })
				end
			end
			PX.UI.Menu.CloseAll()
			PX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_grades_vehicles_' .. society .. '', {
				title = "Manage Vehicles",
				align = 'top-left',
				elements = rows
			}, function(data, menu)
				local state = data.current.value
				local model = data.current.model
				if state then
					PX.TriggerServerCallback('esx_society:setSocietyVehPerm', function(result)

						ChangeVehiclePerm(society,rank)

					end, society, rank, rows, false, model)
				else
					PX.TriggerServerCallback('esx_society:setSocietyVehPerm', function(result)
						
						ChangeVehiclePerm(society,rank)

					end, society, rank, rows, true, model)
				end


			end, function(data, menu)
				menu.close()
			end)

		end, rank, society)
	else
		PX.ShowNotification("Error loading Vehicles !", 'error')
	end
end

function OpenGradeNames(society)
	PX.TriggerServerCallback('esx_society:getGrades', function(grades)
		  local elements = {}
		  
			for k,v in pairs(grades) do
				table.insert(elements, {label = v.label, grade = k})
			end

		PX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_grades_name', {
			title    = _U('manage_grades_name'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)

			PX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'rename_grade', {
                title    = "Esm jadid rank ra vared konid",

			}, function(data2, menu2)
				
				if not data2.value then
					PX.ShowNotification("Shoma dar ghesmat esm jadid chizi vared nakardid!", 'error')
					return
				end
	
				if data2.value:match("[^%w%s]") or data2.value:match("%d") then
					PX.ShowNotification("~h~Shoma mojaz be vared kardan ~r~Special ~o~character ~w~ya ~r~adad ~w~nistid!", 'error')
					return
				end

				if string.len(PX.Math.Trim(data2.value)) >= 2 and string.len(PX.Math.Trim(data2.value)) <= 20 then
					menu2.close()
					menu.close()
					PX.TriggerServerCallback('esx_society:renameGrade', function(refresh)
					end, tonumber(data.current.grade), data2.value)
					OpenGradeNames(society)
					PX.ShowNotification("~w~Changed to ~y~" .. data2.value, 'success')
				else
					PX.ShowNotification("Tedad character esm grade bayad bishtar az ~g~2 ~w~0 va kamtar az ~g~20 ~o~character ~w~bashad!", 'error')
				end

            end, function (data2, menu2)
                menu2.close()
            end)
			
		end, function(data, menu)
			menu.close()
		end)
	end)
end

function OpenSetOutfitMenu(society)
	PX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_grades_outfit' .. society, {
		title    = _U('manage_grades_outfit'),
		align    = 'top-left',
		elements = {
			{label = 'Mard ha', value = 'employee_man'},
			{label = 'Khanom ha', value = 'employee_woman'}
		}
	}, function(data, menu)

		if data.current.value == 'employee_man' then
			OpenOutfitM(society)
		end
		
		if data.current.value == 'employee_woman' then
			OpenOutfitF(society)
		end

	end, function(data, menu)
		menu.close()
	end)
end

local inClothesShop = false

AddEventHandler("PX_Clothing:inMenu", function(state)
	inClothesShop = state
end)

function OpenOutfitM(society)
	local skinMe = nil
	TriggerEvent('PX_clothing:getSkin', function(skin)
		skinMe = json.encode(skin)
	end)
	PX.TriggerServerCallback('esx_society:getGrades', function(grades)
		local elements = {}
		  for k,v in pairs(grades) do
			  table.insert(elements, {label = '(' .. k .. ') | ' .. v.label, grade = k})
		  end
		  PX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_grades_name', {
			title    = _U('manage_grades_outfit'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			PX.TriggerServerCallback('Proxtended:getGender', function(myskin)
				PX.TriggerServerCallback('esx_society:getEmployeclothes', function (skinjob)
					if skinjob ~= nil then
						TriggerEvent('PX_clothing:client:loadOutfit', skinjob)
					end
					TriggerEvent('PX_clothing:CreateFirstCharacter', 0)
					TriggerServerEvent("Proxtended:ChangeWM", true)
					local WaitForSave = true
					while WaitForSave do
						if inClothesShop then
							Citizen.Wait(tonumber(1000))
						else
							TriggerEvent('PX_clothing:getSkin', function(skin)
								PX.TriggerServerCallback('esx_society:setUniform', function ()
								end, society, tonumber(data.current.grade), 'male', skin)
							end)
							WaitForSave = false
							TriggerServerEvent("Proxtended:ChangeWM", false)
							if myskin.sex == 0 then
								TriggerEvent('PX_clothing:loadPed', 'mp_m_freemode_01')
								Wait(100)
								TriggerEvent('PX_clothing:loadSkin', 'mp_m_freemode_01', skinMe)
							else
								TriggerEvent('PX_clothing:loadPed', 'mp_f_freemode_01')
								Wait(100)
								TriggerEvent('PX_clothing:loadSkin', 'mp_f_freemode_01', skinMe)
							end
						end
						Citizen.Wait(tonumber(1000))
					end
				end, tonumber(data.current.grade), 'male', society)
			end)
		end, function(data, menu)
			menu.close()
		end)
	end)
end

function OpenOutfitF(society)
	local skinMe = nil
	TriggerEvent('PX_clothing:getSkin', function(skin)
		skinMe = json.encode(skin)
	end)
	PX.TriggerServerCallback('esx_society:getGrades', function(grades)
		local elements = {}
		  for k,v in pairs(grades) do
			  table.insert(elements, {label = '(' .. k .. ') | ' .. v.label, grade = k})
		  end
		  PX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_grades_name', {
			title    = _U('manage_grades_outfit'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			PX.TriggerServerCallback('Proxtended:getGender', function(myskin)
				PX.TriggerServerCallback('esx_society:getEmployeclothes', function (skinjob)
					if skinjob ~= nil then
						TriggerEvent('PX_clothing:client:loadOutfit', skinjob)
					end
					TriggerEvent('PX_clothing:CreateFirstCharacter', 1)
					TriggerServerEvent("Proxtended:ChangeWM", true)
					local WaitForSave = true
					while WaitForSave do
						if inClothesShop then
							Citizen.Wait(tonumber(1000))
						else
							TriggerEvent('PX_clothing:getSkin', function(skin)
								PX.TriggerServerCallback('esx_society:setUniform', function ()
								end, society, tonumber(data.current.grade), 'female', skin)
							end)
							WaitForSave = false
							TriggerServerEvent("Proxtended:ChangeWM", false)
							if myskin.sex == 0 then
								TriggerEvent('PX_clothing:loadPed', 'mp_m_freemode_01')
								Wait(100)
								TriggerEvent('PX_clothing:loadSkin', 'mp_m_freemode_01', skinMe)
							else
								TriggerEvent('PX_clothing:loadPed', 'mp_f_freemode_01')
								Wait(100)
								TriggerEvent('PX_clothing:loadSkin', 'mp_f_freemode_01', skinMe)
							end
						end
						Citizen.Wait(tonumber(1000))
					end
				end, tonumber(data.current.grade), 'female', society)
			end)
		end, function(data, menu)
			menu.close()
		end)
	end)
end

function OpenDepositMoney(society, close, options)
	PX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'deposit_money_amount_' .. society, {
		title = _U('deposit_amount')
	}, function(data, menu)

		local amount = tonumber(data.value)

		if amount == nil then
			PX.ShowNotification(_U('invalid_amount'), 'error')
		else
			menu.close()
			TriggerServerEvent('esx_society:depositMoney', society, amount)
			OpenBossMenu(society, close, options)
		end

	end, function(data, menu)
		menu.close()
	end)
end

function OpenManageEmployeesMenu(society)
    if DoesHaveOffDuty(society) then 
		PX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_employees_' .. society, {
			title    = _U('employee_management'),
			align    = 'top-left',
			elements = {
				{label = 'List A\'aza', value = 'employee_list'},
				{label = 'List A\'aza(Off Duty)', value = 'employee_listoff'},
				{label = 'Estekhdam',       value = 'recruit'}
			}
		}, function(data, menu)

			if data.current.value == 'employee_list' then
				OpenEmployeeList(society)
			end
			
			if data.current.value == 'employee_listoff' then
				OpenEmployeeList('off' .. society)
			end

			if data.current.value == 'recruit' then
				OpenRecruitMenu(society)
			end

		end, function(data, menu)
			menu.close()
		end)
	else
		PX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_employees_' .. society, {
			title    = _U('employee_management'),
			align    = 'top-left',
			elements = {
				{label = 'List A\'aza', value = 'employee_list'},
				{label = 'Estekhdam',       value = 'recruit'}
			}
		}, function(data, menu)

			if data.current.value == 'employee_list' then
				OpenEmployeeList(society)
			end

			if data.current.value == 'recruit' then
				OpenRecruitMenu(society)
			end

		end, function(data, menu)
			menu.close()
		end)
	end
end

function OpenEmployeeList(society)

	PX.TriggerServerCallback('esx_society:getEmployees', function(employees)

		local elements = {
			head = {_U('employee'), _U('grade'), _U('actions')},
			rows = {}
		}

		for i=1, #employees, 1 do
			local gradeLabel = (employees[i].job.grade_label == '' and employees[i].job.label or employees[i].job.grade_label)

			table.insert(elements.rows, {
				data = employees[i],
				cols = {
					employees[i].name,
					gradeLabel,
					'{{' .. _U('promote') .. '|promote}} {{' .. _U('fire') .. '|fire}} {{Divisions|divisions}}'
				}
			})
		end

		PX.UI.Menu.Open('list', GetCurrentResourceName(), 'employee_list_' .. society, elements, function(data, menu)
			local employee = data.data

			if data.value == 'promote' then
				menu.close()
				OpenPromoteMenu(society, employee)
			elseif data.value == 'divisions' then
				menu.close()
				OpenDivisionMenu(society, employee)
			elseif data.value == 'fire' then
				menu.close()
				PX.ShowNotification(_U('you_have_fired', employee.name), 'info')

				PX.TriggerServerCallback('esx_society:setJob', function()
					OpenEmployeeList(society)
				end, employee.identifier, 'nojob', tonumber(0), 'fire')
			end
		end, function(data, menu)
			menu.close()
			OpenManageEmployeesMenu(society)
		end)

	end, society)

end

function OpenRecruitMenu(society)

	PX.TriggerServerCallback('esx_society:getOnlinePlayers', function(players)

		local elements = {}

		for i=1, #players, 1 do
			if players[i].job.name ~= society then
				table.insert(elements, {
					label = players[i].name,
					value = players[i].source,
					name = players[i].name,
					identifier = players[i].identifier
				})
			end
		end

		PX.UI.Menu.Open('default', GetCurrentResourceName(), 'recruit_' .. society, {
			title    = _U('recruiting'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)

			PX.UI.Menu.Open('default', GetCurrentResourceName(), 'recruit_confirm_' .. society, {
				title    = _U('do_you_want_to_recruit', data.current.name),
				align    = 'top-left',
				elements = {
					{label = _U('no'),  value = 'no'},
					{label = _U('yes'), value = 'yes'}
				}
			}, function(data2, menu2)
				menu2.close()

				if data2.current.value == 'yes' then
					PX.ShowNotification(_U('you_have_hired', data.current.name), 'info')

					PX.TriggerServerCallback('esx_society:setJob', function()
						OpenRecruitMenu(society)
					end, data.current.identifier, society, tonumber(1), 'hire')
				end
			end, function(data2, menu2)
				menu2.close()
			end)

		end, function(data, menu)
			menu.close()
		end)

	end)

end

function OpenPromoteMenu(society, employee)

	PX.TriggerServerCallback('esx_society:getJob', function(job)

		local elements = {}

		for i=tonumber(1), #job.grades, tonumber(1) do
			local gradeLabel = (job.grades[i].label == '' and job.label or job.grades[i].label)

			table.insert(elements, {
				label = gradeLabel,
				value = job.grades[i].grade,
				selected = (employee.job.grade == job.grades[i].grade)
			})
		end

		PX.UI.Menu.Open('default', GetCurrentResourceName(), 'promote_employee_' .. society, {
			title    = _U('promote_employee', employee.name),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			menu.close()
			PX.ShowNotification(_U('you_have_promoted', employee.name, data.current.label), 'info')

			PX.TriggerServerCallback('esx_society:setJob', function()
				OpenEmployeeList(society)
			end, employee.identifier, society, data.current.value, 'promote')
		end, function(data, menu)
			menu.close()
			OpenEmployeeList(society)
		end)

	end, society)

end

function OpenDivisionMenu(society, employee)
	PX.TriggerServerCallback('esx_society:getDivision', function(divisions)
		local elements = {}
			if divisions == nil then
				divisions = {}
			end
			for i, v in ipairs(divisions) do
				if v.state == true then
					table.insert(elements, { label = v.name .. " | [<font color=Lime>Fa\'al</font>]", value = v.state , name =  v.name})
				elseif v.state == false then
					table.insert(elements, { label = v.name .. " | [<font color=red>gheyre Fa\'al</font>]", value = v.state , name =  v.name})
				end
			end
			PX.UI.Menu.CloseAll()
			PX.UI.Menu.Open('default', GetCurrentResourceName(), 'employe_divisions', {
				title = "Divisions",
				align = 'top-left',
				elements = elements
			}, function(data, menu)
				local state = data.current.value
				local name = data.current.name
				PX.TriggerServerCallback('esx_society:setEmployeDiv', function(result)
					OpenDivisionMenu(society,employee)
				end, employee.identifier, name, state)
			end, function(data, menu)
				menu.close()
			end)
	end, employee.identifier)
end

function OpenDivision(society)
	PX.TriggerServerCallback('esx_society:getJobDivision', function(divisions)
		local elements = {}
			if divisions == nil then
				divisions = {}
			end
			for i, v in ipairs(divisions) do
					table.insert(elements, { label = v, value = v })
			end
			table.insert(elements, { label = '<font color=Lime>Ezafe kardan</font>', value = 'add' })
			PX.UI.Menu.CloseAll()
			PX.UI.Menu.Open('default', GetCurrentResourceName(), 'employe_divisions', {
				title = "Divisions",
				align = 'top-left',
				elements = elements
			}, function(data, menu)
				local action = data.current.value
				if action == 'add' then
					PX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'rename_grade', {
						title    = "Esm division jadid ra vared konid",
		
					}, function(data2, menu2)
						
						if not data2.value then
							PX.ShowNotification("Shoma dar ghesmat esm chizi vared nakardid!", 'error')
							return
						end
			
						if data2.value:match("[^%w%s]") or data2.value:match("%d") then
							PX.ShowNotification("~h~Shoma mojaz be vared kardan ~r~Special ~o~character ~w~ya ~r~adad ~w~nistid!", 'error')
							return
						end
		
						if string.len(PX.Math.Trim(data2.value)) >= 3 and string.len(PX.Math.Trim(data2.value)) <= 11 then
							menu2.close()
							menu.close()
							PX.TriggerServerCallback('esx_society:addDivision', function(valid)
								if valid then
									PX.ShowNotification("~y~" .. data2.value..'~w~ Added!', 'success')
									OpenDivision(society)
								else
									PX.ShowNotification("~w~" .. data2.value..'~r~ Added befor', 'error')
									OpenDivision(society)
								end
							end, data2.value)
						else
							PX.ShowNotification("Tedad character esm division bayad bishtar az ~g~3 ~w~va kamtar az ~g~11 ~o~character ~w~bashad!", 'error')
						end
		
					end, function (data2, menu2)
						menu2.close()
					end)
				else
					menu.close()
					OpenEditDivision(society,action)
				end
			end, function(data, menu)
				menu.close()
			end)
	end)
end

function OpenEditDivision(society,name)
	local elements = {
		{ label = 'Modiriat mashin ha',  value = 'div_vehicles' },
		{ label = 'Modiriat lebas',  value = 'div_outfit' },
		{ label = '<font color=red>Hazf division</font>',  value = 'div_delete' },
	}
	PX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_div_' .. name, {
		title    = name,
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'div_delete' then
			PX.TriggerServerCallback('esx_society:removeDivision', function() 
				menu.close()
				OpenDivision(society)
			end, name)
		elseif data.current.value == 'div_vehicles' then
			if DoesHaveGarage(society) then
				menu.close()
				OpenVehiclesdivManagment(society, name)
			else
				PX.ShowNotification("Your job does not have garage", 'error')
			end
		elseif data.current.value == 'div_outfit' then
			menu.close()
			OpenSetdOutfitMenu(society, name)
		end
	end, function(data, menu)
		menu.close()
	end)
end

function OpenVehiclesdivManagment(society,name)
	local authorizedVehicles = Config.Garage[society]
	if authorizedVehicles then
		PX.TriggerServerCallback('esx_society:getDivVehicles', function(vehs)
			local rows = {}
		
			for k, society_vehicles in ipairs(authorizedVehicles) do
				local found = false
				
				if vehs then

					for k2, vehicle_state in ipairs(vehs) do
						if string.lower(society_vehicles) == string.lower(vehicle_state.model) then
							if GetDisplayNameFromVehicleModel(GetHashKey(vehicle_state.model)) then
								if vehicle_state.status == true then
									table.insert(rows, { label = GetDisplayNameFromVehicleModel(GetHashKey(vehicle_state.model)) .. " | [<font color=Lime>Fa\'al</font>]", model = vehicle_state.model, value = vehicle_state.status })
								elseif vehicle_state.status == false then
									table.insert(rows, { label = GetDisplayNameFromVehicleModel(GetHashKey(vehicle_state.model)) .. " | [<font color=red>gheyre Fa\'al</font>]", model = vehicle_state.model, value = vehicle_state.status })
								end
							else
								table.insert(rows, { label = vehicle_state.model .. " | [<font color=yellow>Unknown</font>]", model = vehicle_state.model, value = vehicle_state.status })
							end

							found = true
							break
						end
					end
				end

				if not found then
					table.insert(rows, { label = GetDisplayNameFromVehicleModel(GetHashKey(society_vehicles)) .. " | [<font color=red>gheyre Fa\'al</font>]", model = society_vehicles, value = false })
				end
			end
			PX.UI.Menu.CloseAll()
			PX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_grades_vehicles_' .. name .. '', {
				title = "Manage Vehicles",
				align = 'top-left',
				elements = rows
			}, function(data, menu)
				local model = data.current.model
					PX.TriggerServerCallback('esx_society:setSocietyDivVehPerm', function(result)
						
						OpenVehiclesdivManagment(society,name)

					end, society, name, model)

			end, function(data, menu)
				menu.close()
				OpenEditDivision(society,name)
			end)

		end, name)
	else
		PX.ShowNotification("Error loading Vehicles !", 'error')
	end
end

function OpenSetdOutfitMenu(society, name)
	PX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_division_outfit', {
		title    = "Choose gender",
		align    = 'top-left',
		elements = {
			{label = 'Mard ha', value = 'man'},
			{label = 'Khanom ha', value = 'woman'}
		}
	}, function(data, menu)
			OpenOutfit(society, name, data.current.value)
	end, function(data, menu)
		menu.close()
		OpenEditDivision(society,name)
	end)
end

function OpenOutfit(society, name, stype)
	local skinMe = nil
	TriggerEvent('PX_clothing:getSkin', function(skin)
		skinMe = json.encode(skin)
	end)
	PX.TriggerServerCallback('Proxtended:getGender', function(myskin)
		PX.TriggerServerCallback('esx_society:getdivisionclothes', function (skinjob)
			if skinjob ~= nil then
				TriggerEvent('PX_clothing:client:loadOutfit', skinjob)
			end
			if stype == 'man' then
				TriggerEvent('PX_clothing:CreateFirstCharacter', 0)
			else
				TriggerEvent('PX_clothing:CreateFirstCharacter', 1)
			end
			TriggerServerEvent("Proxtended:ChangeWM", true)
			local WaitForSave = true
			while WaitForSave do
				if inClothesShop then
					Citizen.Wait(tonumber(1000))
				else
					TriggerEvent('PX_clothing:getSkin', function(skin)
						PX.TriggerServerCallback('esx_society:setdivUniform', function ()
						end, name, stype, skin)
					end)
					WaitForSave = false
					TriggerServerEvent("Proxtended:ChangeWM", false)
					if myskin.sex == 0 then
						TriggerEvent('PX_clothing:loadPed', 'mp_m_freemode_01')
						Wait(100)
						TriggerEvent('PX_clothing:loadSkin', 'mp_m_freemode_01', skinMe)
					else
						TriggerEvent('PX_clothing:loadPed', 'mp_f_freemode_01')
						Wait(100)
						TriggerEvent('PX_clothing:loadSkin', 'mp_f_freemode_01', skinMe)
					end
					OpenSetdOutfitMenu(society, name)
				end
				Citizen.Wait(tonumber(1000))
			end
		end, name, stype)
	end)
end

function OpenManageGradesMenu(society)

	PX.TriggerServerCallback('esx_society:getJob', function(job)

		local elements = {}

		for i=tonumber(1), #job.grades, tonumber(1) do
			local gradeLabel = (job.grades[i].label == '' and job.label or job.grades[i].label)

			table.insert(elements, {
				label = ('%s - <span style="color:green;">%s</span>'):format(gradeLabel, _U('money_generic', PX.Math.GroupDigits(job.grades[i].salary))),
				value = job.grades[i].grade
			})
		end

		PX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_grades_' .. society, {
			title    = _U('salary_management'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)

			PX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'manage_grades_amount_' .. society, {
				title = _U('salary_amount')
			}, function(data2, menu2)

				local amount = tonumber(data2.value)

				if amount == nil then
					PX.ShowNotification(_U('invalid_amount'), 'error')
				elseif amount > Config.MaxSalary then
					PX.ShowNotification(_U('invalid_amount_max'), 'error')
				else
					menu2.close()

					PX.TriggerServerCallback('esx_society:setJobSalary', function()
						OpenManageGradesMenu(society)
					end, society, data.current.value, amount)
				end

			end, function(data2, menu2)
				menu2.close()
			end)

		end, function(data, menu)
			menu.close()
		end)

	end, society)

end

AddEventHandler(Config.OpenBossMenu, function(society, close, options)
	OpenBossMenu(society, close, options)
end)

function DoesHaveGarage(job)
	local access = false
		if Config.Garage[job] then
			access = true
		end
    return access
end

function DoesHaveOffDuty(job)
	local access = false
	for i,v in ipairs(Config.Offjobs) do
		if v == job then
			access = true
			break
		end
	end
	return access
end

function DoesHaveDivision(job)
	local access = false
	for i,v in ipairs(Config.divjobs) do
		if v == job then
			access = true
			break
		end
	end
	return access
end