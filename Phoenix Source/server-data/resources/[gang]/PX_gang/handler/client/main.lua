ESX = nil

local base64MoneyIcon = ''

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

 	while ESX.GetPlayerData().gang == nil do
		Citizen.Wait(10)
	end

 	ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:setGang')
AddEventHandler('esx:setGang', function(gang)
	ESX.PlayerData.gang = gang
end)

RegisterNetEvent('gangaccount:setMoney')
AddEventHandler('gangaccount:setMoney', function(gang, money)
	if ESX.PlayerData.gang and ESX.PlayerData.gang.grade >= 9 and 'gang_' .. ESX.PlayerData.gang.name == gang then
		UpdateSocietyMoneyHUDElement(money)
	end
end)

RegisterNetEvent('gangs:inv')
AddEventHandler('gangs:inv', function(gang)
	ESX.UI.Menu.CloseAll()
											ESX.UI.Menu.Open('question', GetCurrentResourceName(), 'Aks_For_Join',
											{
												title 	 = 'Voroud Be Gang',
												align    = 'center',
												question = 'Aya Shoma Mikhahid Vared Gang ('.. gang ..') Shavid?',
												elements = {
													{label = 'Bale', value = 'yes'},
													{label = 'Kheir', value = 'no'},
												}
											}, function(data, menu)
												if data.current.value == 'yes' then
													TriggerServerEvent("gangs:acceptinv")
													ESX.UI.Menu.CloseAll()		
												elseif data.current.value == 'no' then
													menu.close()
                                                    ESX.UI.Menu.CloseAll()													
												end
											end
											)
end)

function OpenBossMenugm(gang, close, options)
	local isBoss = nil
	local options  = options or {}
	local elements = {}
	local gangMoney = nil

 	ESX.TriggerServerCallback('gangs:isBossgm', function(result)
		isBoss = result
	end, gang)

 	while isBoss == nil do
		Citizen.Wait(100)
	end

 	if not isBoss then
		return
	end

	while gangMoney == nil do
		Citizen.Wait(1)
		ESX.TriggerServerCallback('gangs:getGangMoney', function(money)
			gangMoney = money
		end, ESX.PlayerData.gang.name)
	end

 	local defaultOptions = {
		withdraw  = true,
		deposit   = true,
		wash      = false,
		employees = true,
		grades    = true
	}

 	for k,v in pairs(defaultOptions) do
		if options[k] == nil then
			options[k] = v
		end
	end

 	if options.employees then
		table.insert(elements, {label = _U('employee_management'), value = 'manage_employees'})
	end
 	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'boss_actions_' .. gang, {
		title    = _U('boss_menu'),
		align    = 'top-left',
		elements = elements
	}, function(data, menu)

 		if data.current.value == 'manage_employees' then
			OpenManageEmployeesMenugm(gang)
		end

 	end, function(data, menu)
		if close then
			close(data, menu)
		end
	end)

end

function OpenBossMenu(gang, close, options)
	local isBoss = nil
	local options  = options or {}
	local elements = {}
	local gangMoney = nil

 	ESX.TriggerServerCallback('gangs:isBoss', function(result)
		isBoss = result
	end, gang)

 	while isBoss == nil do
		Citizen.Wait(100)
	end

 	if not isBoss then
		return
	end

	while gangMoney == nil do
		Citizen.Wait(1)
		ESX.TriggerServerCallback('gangs:getGangMoney', function(money)
			gangMoney = money
		end, ESX.PlayerData.gang.name)
	end

 	local defaultOptions = {
		withdraw  = true,
		deposit   = true,
		wash      = false,
		employees = true,
		grades    = true
	}

 	for k,v in pairs(defaultOptions) do
		if options[k] == nil then
			options[k] = v
		end
	end
	if options.withdraw then
		local formattedMoney = _U('locale_currency', ESX.Math.GroupDigits(gangMoney))
		table.insert(elements, {label = ('%s: <span style="color:green;">%s</span>'):format(_U('clean_money'), formattedMoney), value = 'withdraw_society_money'})
	end
 	if options.employees then
		table.insert(elements, {label = _U('employee_management'), value = 'manage_employees'})
	end
	table.insert(elements, {label = 'Set Access', value = 'set_access'})
	-- table.insert(elements, {label = 'Set Hud Icon', value = 'set_icon'})
	table.insert(elements, {label = 'Manage gang blip', value = 'manage_blip'})
 	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'boss_actions_' .. gang, {
		title    = _U('boss_menu'),
		align    = 'top-left',
		elements = elements
	}, function(data, menu)

 		if data.current.value == 'withdraw_society_money' then
			OpenMoneyMenu(gang)
 		elseif data.current.value == 'manage_employees' then
			OpenManageEmployeesMenu(gang)
		elseif data.current.value == 'manage_blip' then
			OpenManageBlip(gang)
		elseif data.current.value == 'set_access' then
			SetAccess(gang)
		elseif data.current.value == 'set_icon' then
			SetIcon()
		end

 	end, function(data, menu)
		if close then
			close(data, menu)
		end
	end)

end

function OpenManageEmployeesMenu(gang)
	ESX.TriggerServerCallback('gangs:getEmployees', function(employees)
		ESX.TriggerServerCallback('gangs:getGangData', function(dataG)
			local gpsS = "DeActive"
			local tedadmember = 0
			for i=1, #employees, 1 do
				tedadmember = tedadmember + 1
			end
			if dataG.gangsblip == 1 then
				gpsS = "Active"
			end
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_employees_' .. gang, {
				title    = _U('employee_management'),
				align    = 'top-left',
				elements = {
					{label = _U('employee_list'), value = 'employee_list'},
					{label = _U('recruit'),       value = 'recruit'},
					{label = "Rename Grades", value = 'rename_grades'},
					{label = "Slot: " .. tedadmember.."/"..dataG.slot, value = 'slotsize'},
					{label = "Vest: " .. dataG.bulletproof.."%", value = 'vest'},
					{label = "GPS: "..gpsS, value = 'gps'}
				}
			}, function(data, menu)

				if data.current.value == 'employee_list' then
					OpenEmployeeList(gang)
				elseif data.current.value == 'recruit' then
					OpenRecruitMenu(gang)
				elseif data.current.value == 'rename_grades' then
					ManageGrades()
				end

			end, function(data, menu)
				menu.close()
			end)
		end, gang)
	end, gang)
end

function OpenManageEmployeesMenugm(gang)

 	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_employees_' .. gang, {
		title    = _U('employee_management'),
		align    = 'top-left',
		elements = {
			{label = _U('recruit'),       value = 'recruit'},
		}
	}, function(data, menu)
		if data.current.value == 'recruit' then
			OpenRecruitMenugm(gang)
		end
 	end, function(data, menu)
		menu.close()
	end)
end
-- Rename
function ManageGrades()
	ESX.TriggerServerCallback('gang:getGrades', function(grades)
		  local elements = {}
		  
			for k,v in pairs(grades) do
				table.insert(elements, {label = '(' .. k .. ') | ' .. v.label, grade = k})
			end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'show_grade_list', {
			title    = 'Gang Grades',
			align    = 'top-left',
			elements = elements
		}, function(data, menu)

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'rename_grade', {
                title    = "Esm jadid rank ra vared konid",

			}, function(data2, menu2)
				
				if not data2.value then
					ESX.ShowNotification("Shoma dar ghesmat esm jadid chizi vared nakardid!", 'error')
					return
				end
	
				if data2.value:match("[^%w%s]") or data2.value:match("%d") then
					ESX.ShowNotification("~h~Shoma mojaz be vared kardan ~r~Special ~o~character ~w~ya ~r~adad ~w~nistid!", 'error')
					return
				end

				if string.len(ESX.Math.Trim(data2.value)) >= 3 and string.len(ESX.Math.Trim(data2.value)) <= 11 then
					ESX.TriggerServerCallback('gangs:renameGrade', function(refresh)
						menu2.close()
						if refresh then
							menu.close()
							ManageGrades()
						end
					end, data.current.grade, data2.value)
				else
					ESX.ShowNotification("Tedad character esm grade bayad bishtar az ~g~3 ~w~0 va kamtar az ~g~11 ~o~character ~w~bashad!", 'error')
				end

            end, function (data2, menu2)
                menu2.close()
            end)
			
		end, function(data, menu)
			menu.close()
		end)
	end)
end

function SetAccess(gang)
	local elements = {
		{label = 'Garage Access', op = 'mg'},
		{label = 'vest Access', op = 'mvp'},
		{label = 'Invite Access', op = 'set_inv'},
		{label = 'Craft Access', op = 'set_craft'},
		{label = 'Inventory Access', op = 'set_stash'},
		{label = _U('salary_management'), op = 'manage_grades'},
	}

	  ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'show_gang_manage_list', {
		  title    = 'Manage your gang',
		  align    = 'top-left',
		  elements = elements
	  }, function(data, menu)
		local op = data.current.op
		if op == 'mvp' then
			SetVestp() 
		elseif op == 'set_inv' then
			SetInv()
		elseif op == 'set_craft' then
			SetCraft()
		elseif op == 'set_stash' then
			SetStash()
		elseif op == 'manage_grades' then
			OpenManageGradesMenu(gang)
		else
			SetopAccess(gang, op)
		end
	  end, function(data, menu)
		  menu.close()
	  end)
end

function OpenManageBlip(gang)
	local elements = {
		{label = 'icon', value = 'b_i'},
		{label = 'color', value = 'b_c'},
	}
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'show_grade_list', {
		title    = 'Choose one of rank',
		align    = 'top-left',
		elements = elements
	}, function(data2, menu2)
		local action = data2.current.value
		Setb(gang, action)
	end, function(data2, menu2)
		menu2.close()
	end)
end

function Setb(gang, type)
	local title
	if type == 'b_i' then
		title = 'id icon mord nazar'
	else
		title = 'id rang mord nazar'
	end

	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'set_log', {
		title    = title,

	}, function(data2, menu2)
		
		if not data2.value then
			ESX.ShowNotification("Shoma chizi Vared Nakardid!", 'error')
			return
		end
		local number = tonumber(data2.value)
		if number then
			if type == 'b_i' then
				if number >=0 and number < 826 then
					ESX.TriggerServerCallback('gangs:setb', function(refresh)
						menu2.close()
						ESX.ShowNotification("icon blip Ba Movafaghiat Sabt Shod!", 'success')
				  	end, number, type)
					menu2.close()
				else
					ESX.ShowNotification("id icon eshtebah Ast!", 'error')
					return
				end
			else
				if number >=0 and number < 86 then
					ESX.TriggerServerCallback('gangs:setb', function(refresh)
						menu2.close()
						ESX.ShowNotification("rang blip Ba Movafaghiat Sabt Shod!", 'success')
				  	end, number, type)
					menu2.close()
				else
					ESX.ShowNotification("id rang eshtebah Ast!", 'error')
					return
				end
			end
	    else
	     	ESX.ShowNotification("adad vared konid!", 'error')
			return
	    end
	end, function (data2, menu2)
		menu2.close()
	end)
end

function SetopAccess(gang, op)
	ESX.TriggerServerCallback('gang:getGrades', function(grades)
		local elements = {}
		  for k,v in pairs(grades) do
			  table.insert(elements, {label = '(' .. k .. ') | ' .. v.label, grade = k})
		  end

	  ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'show_grade_list', {
		  title    = 'Choose one of rank',
		  align    = 'top-left',
		  elements = elements
	  }, function(data, menu)
		local grade = data.current.grade
		if op == 'mg' then
			OpensetPermGarage(gang, grade)
		end
	  end, function(data, menu)
		  menu.close()
		  SetAccess(gang)
	  end)
	end)
end

function OpensetPermGarage(gang, rank)
	ESX.TriggerServerCallback('PXgangxxpropPX:getCars',function(vehicles)
		ESX.TriggerServerCallback('gangs:GetPermData', function(vyitems)
			local elements = {}
			for i,v in pairs(vehicles) do
				local carname = GetDisplayNameFromVehicleModel(v.vehicle.model)
				if checktable(elements, carname) then
					if checkas(carname, 'car', vyitems) == true then
						table.insert(elements, {label = carname.. " | [<font color=Lime>Active</font>]", value = carname})
					else
						table.insert(elements, {label = carname.. " | [<font color=red>Deactivate</font>]", value = carname})
					end
				end
			end
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'Vehicles_list', {
				title    = 'Choose one',
				align    = 'top-left',
				elements = elements
			}, function(data, menu)
				local item = data.current.value
					ESX.TriggerServerCallback('gangs:SetPermData', function(result)
						OpensetPermGarage(gang, rank)
					end, gang, rank, item, 'car')
			end, function(data, menu)
				menu.close()
				SetopAccess(gang, 'mg')
			end)
		end, gang, rank, 'car')
	end, gang)
end

function checkas(item, type, vyitems)
	if vyitems == nil or vyitems == {} then
		return false
	end
	if type == 'inv' then
			local found = false
			for k, v in ipairs(vyitems) do
				if string.lower(v.name) == string.lower(item) then
					if v.state == true then
						found = true
					end
					break
				end
			end
			return found
	elseif type == 'car' then
			local found = false
			for k, v in ipairs(vyitems) do
				if string.lower(v.name) == string.lower(item) then
					if v.state == true then
						found = true
					end
					break
				end
			end
			return found
	end
end


function checktable(table, item)
	local can = true
	for k,v in pairs(table) do
		if v.value == item then
			can = false
		end
	end
	return can
end

function SetInv()

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'set_perm', {
                title    = "Had Aghal Sathe Dastresi Ra Vared Konids(1 Ta 10)",

			}, function(data2, menu2)
				
				if not data2.value then
					ESX.ShowNotification("Shoma Chizi Vared Nakardid!", 'error')
					return
				end
				local perm = tonumber(data2.value)
				if perm < 11 and perm > 0 then
				ESX.TriggerServerCallback('gangs:setinvperm', function(refresh)
						menu2.close()
						ESX.ShowNotification("Permission Ba Movafaghiat Sabt Shod!", 'success')
				  end, perm)
				menu2.close()
		         else
		          	ESX.ShowNotification("Permission Vared Shode Eshtebah Ast!", 'error')
					return
		         end
            end, function (data2, menu2)
                menu2.close()
            end)
end

function SetCraft()

	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'set_perm', {
		title    = "Had Aghal Sathe Dastresi Ra Vared Konids(1 Ta 10)",

	}, function(data2, menu2)
		
		if not data2.value then
			ESX.ShowNotification("Shoma Chizi Vared Nakardid!", 'error')
			return
		end
		local perm = tonumber(data2.value)
		if perm < 11 and perm > 0 then
		ESX.TriggerServerCallback('gangs:setcraftperm', function(refresh)
				menu2.close()
				ESX.ShowNotification("Permission Ba Movafaghiat Sabt Shod!", 'success')
		  end, perm)
		menu2.close()
		 else
			  ESX.ShowNotification("Permission Vared Shode Eshtebah Ast!", 'error')
			return
		 end
	end, function (data2, menu2)
		menu2.close()
	end)
end

function SetStash()

	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'set_perm', {
		title    = "Had Aghal Sathe Dastresi Ra Vared Konids(1 Ta 10)",

	}, function(data2, menu2)
		
		if not data2.value then
			ESX.ShowNotification("Shoma Chizi Vared Nakardid!", 'error')
			return
		end
		local perm = tonumber(data2.value)
		if perm < 11 and perm > 0 then
		ESX.TriggerServerCallback('gangs:setstashperm', function(refresh)
				menu2.close()
				ESX.ShowNotification("Permission Ba Movafaghiat Sabt Shod!", 'success')
		  end, perm)
		menu2.close()
		 else
			  ESX.ShowNotification("Permission Vared Shode Eshtebah Ast!", 'error')
			return
		 end
	end, function (data2, menu2)
		menu2.close()
	end)
end

function SetIcon()

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'set_icon', {
                title    = "Link Axs Ra Vared Konid",

			}, function(data2, menu2)
				
				if not data2.value then
					ESX.ShowNotification("Shoma Chizi Vared Nakardid!", 'error')
					return
				end
				local link = data2.value
				if link:find('http') then
				ESX.TriggerServerCallback('gangs:setgangicon', function(refresh)
						menu2.close()
						ESX.ShowNotification("Link Axs Ba Movafaghiat Sabt Shod!", 'success')
				  end, link)
				menu2.close()
		         else
		          	ESX.ShowNotification("Link Vared Shode Eshtebah Ast!", 'error')
					return
		         end
            end, function (data2, menu2)
                menu2.close()
            end)
end

function SetVestp()

	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'set_vest_perm', {
		title    = "az 1 ta 10",

	}, function(data2, menu2)
		
		if not data2.value then
			ESX.ShowNotification("Shoma Chizi Vared Nakardid!", 'error')
			return
		end
		local perm = data2.value
		if tonumber(perm) and tonumber(perm) >= 1 and tonumber(perm) <= 10 then
			ESX.TriggerServerCallback('gangs:setvestperm', function(refresh)
					menu2.close()
					ESX.ShowNotification("Vest roye rank ~y~"..perm.." ~w~set shod!", 'success')
			end, perm)
			menu2.close()
		 else
			  ESX.ShowNotification("Adad vared shod Eshtebah Ast!", 'error')
			return
		 end
	end, function (data2, menu2)
		menu2.close()
	end)
end

function OpenMoneyMenu(gang)

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'money_manage_' .. gang, {
	   title    = _U('money_management'),
	   align    = 'top-left',
	   elements = {
		   {label = _U('withdraw_money'), 	value = 'withdraw_money'},
		   {label = _U('deposit_money')	,  	value = 'deposit_money'}
	   }
   	}, function(data, menu)

		if data.current.value == 'withdraw_money' then
			
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'withdraw_society_money_amount_' .. gang, {
				title = _U('withdraw_money')
			}, function(data, menu)

 				local amount = tonumber(data.value)

 				if amount == nil then
					ESX.ShowNotification(_U('invalid_amount'), 'error')
				else
					ESX.UI.Menu.CloseAll()
					TriggerServerEvent('gangs:withdrawMoney', gang, amount)
					OpenBossMenu(gang, close, options)
				end

 			end, function(data, menu)
				menu.close()
			end)

		elseif data.current.value == 'deposit_money' then

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'deposit_money_amount_' .. gang, {
				title = _U('deposit_money')
			}, function(data, menu)
 
				 local amount = tonumber(data.value)
 
				 if amount == nil then
					ESX.ShowNotification(_U('invalid_amount'), 'error')
				else
					ESX.UI.Menu.CloseAll()
					TriggerServerEvent('gangs:depositMoney', gang, amount)
					OpenBossMenu(gang, close, options)
				end
 
			 end, function(data, menu)
				menu.close()
			end)

	   	end

	end, function(data, menu)
	   menu.close()
   end)
end

function OpenEmployeeList(gang)

 	ESX.TriggerServerCallback('gangs:getEmployees', function(employees)

 		local elements = {
			head = {_U('employee'), _U('grade'), _U('actions')},
			rows = {}
		}

 		for i=1, #employees, 1 do
			local gradeLabel = (employees[i].gang.grade_label == '' and employees[i].gang.label or employees[i].gang.grade_label)

 			table.insert(elements.rows, {
				data = employees[i],
				cols = {
					employees[i].name,
					gradeLabel,
					'{{' .. _U('promote') .. '|promote}} {{' .. _U('fire') .. '|fire}}'
				}
			})
		end

 		ESX.UI.Menu.Open('list', GetCurrentResourceName(), 'employee_list_' .. gang, elements, function(data, menu)
			local employee = data.data

 			if data.value == 'promote' then
				menu.close()
				OpenPromoteMenu(gang, employee)
			elseif data.value == 'fire' then
				ESX.ShowNotification(_U('you_have_fired', employee.name), 'info')

 				ESX.TriggerServerCallback('gangs:setGang', function()
					OpenEmployeeList(gang)
				end, employee.identifier, 'nogang', 0, 'fire')
			end
		end, function(data, menu)
			menu.close()
			OpenManageEmployeesMenu(gang)
		end)

 	end, gang)

 end
 
 function OpenEmployeeListgm(gang)

 	ESX.TriggerServerCallback('gangs:getEmployees', function(employees)

 		local elements = {
			head = {_U('employee'), _U('grade'), _U('actions')},
			rows = {}
		}

 		for i=1, #employees, 1 do
			local gradeLabel = (employees[i].gang.grade_label == '' and employees[i].gang.label or employees[i].gang.grade_label)

 			table.insert(elements.rows, {
				data = employees[i],
				cols = {
					employees[i].name,
					gradeLabel,
					'{{' .. _U('promote') .. '|promote}} {{' .. _U('fire') .. '|fire}}'
				}
			})
		end

 		ESX.UI.Menu.Open('list', GetCurrentResourceName(), 'employee_list_' .. gang, elements, function(data, menu)
			local employee = data.data

 			if data.value == 'promote' then
				menu.close()
				OpenPromoteMenu(gang, employee)
			elseif data.value == 'fire' then
				ESX.ShowNotification(_U('you_have_fired', employee.name), 'info')

 				ESX.TriggerServerCallback('gangs:setGang', function()
					OpenEmployeeList(gang)
				end, employee.identifier, 'nogang', 0, 'fire')
			end
		end, function(data, menu)
			menu.close()
			OpenManageEmployeesMenugm(gang)
		end)

 	end, gang)

 end

function OpenRecruitMenu(gang)

 	ESX.TriggerServerCallback('gangs:getOnlinePlayers', function(players)

 		local elements = {}

 		for i=1, #players, 1 do
			if players[i].gang.name ~= gang then
				table.insert(elements, {
					label = players[i].name,
					value = players[i].source,
					name = players[i].name,
					identifier = players[i].identifier
				})
			end
		end

 		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'recruit_' .. gang, {
			title    = _U('recruiting'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)

 			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'recruit_confirm_' .. gang, {
				title    = _U('do_you_want_to_recruit', data.current.name),
				align    = 'top-left',
				elements = {
					{label = _U('no'),  value = 'no'},
					{label = _U('yes'), value = 'yes'}
				}
			}, function(data2, menu2)
				menu2.close()

 				if data2.current.value == 'yes' then
					ESX.ShowNotification(_U('you_have_hired', data.current.name), 'info')

 					ESX.TriggerServerCallback('gangs:setGang', function()
						OpenRecruitMenu(gang)
					end, data.current.identifier, gang, 1, 'hire')
				end
			end, function(data2, menu2)
				menu2.close()
			end)

 		end, function(data, menu)
			menu.close()
		end)

 	end)

end

function OpenRecruitMenugm(gang)

 	ESX.TriggerServerCallback('gangs:getOnlinePlayers', function(players)

 		local elements = {}

 		for i=1, #players, 1 do
			if players[i].gang.name ~= gang then
				table.insert(elements, {
					label = players[i].name,
					value = players[i].source,
					name = players[i].name,
					identifier = players[i].identifier
				})
			end
		end

 		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'recruit_' .. gang, {
			title    = _U('recruiting'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)

 			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'recruit_confirm_' .. gang, {
				title    = _U('do_you_want_to_recruit', data.current.name),
				align    = 'top-left',
				elements = {
					{label = _U('no'),  value = 'no'},
					{label = _U('yes'), value = 'yes'}
				}
			}, function(data2, menu2)
				menu2.close()

 				if data2.current.value == 'yes' then
					ESX.ShowNotification(_U('you_have_hired', data.current.name), 'info')

 					ESX.TriggerServerCallback('gangs:setGang', function()
						OpenRecruitMenugm(gang)
					end, data.current.identifier, gang, 1, 'hire')
				end
			end, function(data2, menu2)
				menu2.close()
			end)

 		end, function(data, menu)
			menu.close()
		end)

 	end)

end


function OpenPromoteMenu(gangname, employee)

 	ESX.TriggerServerCallback('gangs:getGang', function(gang)

 		local elements = {}

 		for i=1, #gang.grades, 1 do
			local gradeLabel = (gang.grades[i].label == '' and gang.label or gang.grades[i].label)

 			table.insert(elements, {
				label = gradeLabel,
				value = gang.grades[i].grade,
				selected = (employee.gang.grade == gang.grades[i].grade)
			})
		end

 		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'promote_employee_' .. gangname, {
			title    = _U('promote_employee', employee.name),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			menu.close()
			ESX.ShowNotification(_U('you_have_promoted', employee.name, data.current.label), 'info')

 			ESX.TriggerServerCallback('gangs:setGang', function()
				OpenEmployeeList(gangname)
			end, employee.identifier, gangname, data.current.value, 'promote')
		end, function(data, menu)
			menu.close()
			OpenEmployeeList(gangname)
		end)

 	end, gangname)

end

function OpenManageGradesMenu(gangname)

 	ESX.TriggerServerCallback('gangs:getGang', function(gang)

 		local elements = {}

 		for i=1, #gang.grades, 1 do
			local gradeLabel = (gang.grades[i].label == '' and gang.label or gang.grades[i].label)

 			table.insert(elements, {
				label = ('%s - <span style="color:green;">%s</span>'):format(gradeLabel, _U('money_generic', ESX.Math.GroupDigits(gang.grades[i].salary))),
				value = gang.grades[i].grade
			})
		end

 		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_grades_' .. gang.name, {
			title    = _U('salary_management'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)

 			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'manage_grades_amount_' .. gang.name, {
				title = _U('salary_amount')
			}, function(data2, menu2)

 				local amount = tonumber(data2.value)

 				if amount == nil then
					ESX.ShowNotification(_U('invalid_amount'), 'error')
				elseif amount > Config.MaxSalary then
					ESX.ShowNotification(_U('invalid_amount_max'), 'error')
				else
					menu2.close()

 					ESX.TriggerServerCallback('gangs:setGangSalary', function()
						OpenManageGradesMenu(gangname)
					end, gang, data.current.value, amount)
				end

 			end, function(data2, menu2)
				menu2.close()
			end)

 		end, function(data, menu)
			menu.close()
		end)

 	end, gangname)

end

AddEventHandler('gangs:openBossMenu', function(gang, close, options)
	OpenBossMenu(gang, close, options)
end)

AddEventHandler('gangs:openBossMenugm', function(gang, close, options)
	OpenBossMenugm(gang, close, options)
end)



-- get weapon label
function GetModelLabel(name)
	local label = string.upper(string.gsub(name, 'WEAPON_', ''))
	label = string.gsub(label, '_', '')
	return label
end
