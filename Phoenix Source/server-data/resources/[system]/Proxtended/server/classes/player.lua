function CreatePlayer(source, permission_level, money, bank, identifier, license, inventory, job, jgrade, gang, fgrade, firstname, lastname, coords, status, divisions, phone, stress, salary, gender)
	local self = {}

	self.source 			= source
	self.permission_level 	= permission_level
	self.money 				= money
	self.bank 				= bank
	self.salary 			= salary
	self.identifier 		= identifier
	self.license 			= license
	self.coords 			= nil		
	if coords then self.coords = json.decode(coords) else self.coords = json.decode(settings.defaultSettings.defaultSpawn) end
	self.session 			= {}
	self.inventory          = {}
	self.loadout            = {}
	self.job          		= {}
	self.gang				= {}
	self.angel				= 0
	self.IsDead				= false
	self.Injure				= false
	self.phone				= tonumber(phone) or nil
	self.stress				= tonumber(stress) or 0
	self.inventorydisabled  = false
	self.gender  			= gender

	if status then
		self.status			= json.decode(status)
	else
		self.status			= {}
	end

	if inventory ~= nil then
		for _, item in pairs(inventory) do
			local iteminfo = ESX.Items[item.name]
			if iteminfo then
				self.inventory[item.slot] = {
					name = iteminfo.name,
					count = item.count,
					info = item.info ~= nil and item.info or "",
					label = iteminfo.label,
					description = "",
					weight = iteminfo.weight,
					type = iteminfo.type,
					unique = iteminfo.unique,
					useable = ESX.UsableItemsCallbacks[item.name] ~= nil,
					image = iteminfo.image,
					shouldClose = iteminfo.shouldClose,
					slot = item.slot,
					combinable = iteminfo.combinable,
				}
			else
				print(('Proxtended: invalid item "%s" removed!'):format(item.name))
			end
		end
	end

	jgrade = tonumber(jgrade)
	local vJGrade
	if jgrade < 0 then
		vJGrade = jgrade
		jgrade = jgrade * -1
	end
	if ESX.DoesJobExist(job, jgrade) then
		local jobObject, gradeObject = ESX.Jobs[job], ESX.Jobs[job].grades[jgrade]

		self.job.id    = jobObject.id
		self.job.name  = jobObject.name
		self.job.label = jobObject.label

		self.job.grade        = vJGrade or jgrade
		self.job.grade_name   = gradeObject.name
		self.job.grade_label  = gradeObject.label
		self.job.grade_salary = gradeObject.salary

		self.job.skin_male    = {}
		self.job.skin_female  = {}

		self.job.divisions = jobObject.divisions or {}

		if gradeObject.skin_male ~= nil then
			self.job.skin_male = json.decode(gradeObject.skin_male)
		end

		if gradeObject.skin_female ~= nil then
			self.job.skin_female = json.decode(gradeObject.skin_female)
		end

		if divisions == '[]' then
			self.divisions = {}
		else
			self.divisions = {}
			local realdivisions = json.decode(divisions)
			for _,v in ipairs(realdivisions) do
				if ESX.DoesDivisionExist(self.job.name,v) then
					table.insert(self.divisions, v)
				end
			end
		end
	else

		local job, jgrade = 'nojob', '0'
		local jobObject, gradeObject = ESX.Jobs[job], ESX.Jobs[job].grades[tonumber(jgrade)]

		self.job = {}

		self.job.id    = jobObject.id
		self.job.name  = jobObject.name
		self.job.label = jobObject.label

		self.job.grade        = tonumber(jgrade)
		self.job.grade_name   = gradeObject.name
		self.job.grade_label  = gradeObject.label
		self.job.grade_salary = gradeObject.salary

		self.job.skin_male    = {}
		self.job.skin_female  = {}

		self.divisions = {}
	end

	if ESX.DoesGangExist(gang, fgrade) then
		local gangObject, gradeObject = ESX.Gangs[gang], ESX.Gangs[gang].grades[tonumber(fgrade)]

		self.gang.id    = gangObject.id
		self.gang.name  = gangObject.name
		self.gang.label = gangObject.label

		self.gang.grade        = tonumber(fgrade)
		self.gang.grade_name   = gradeObject.name
		self.gang.grade_label  = gradeObject.label
		self.gang.grade_salary = gradeObject.salary
	else
		local gang, fgrade = 'nogang', '0'
		local gangObject, gradeObject = ESX.Gangs[gang], ESX.Gangs[gang].grades[tonumber(fgrade)]

		self.gang = {}

		self.gang.id    = gangObject.id
		self.gang.name  = gangObject.name
		self.gang.label = gangObject.label

		self.gang.grade        = tonumber(fgrade)
		self.gang.grade_name   = gradeObject.name
		self.gang.grade_label  = gradeObject.label
		self.gang.grade_salary = gradeObject.salary
	end

	self.firstname = firstname or GetPlayerName(self.source)
	self.lastname = lastname or GetPlayerName(self.source)
	if (firstname or lastname) == nil then
		self.name = GetPlayerName(self.source)
	else
		self.name = self.firstname..' '..self.lastname
	end

	self.setCoords = function(x, y, z)
		self.coords = {x = x, y = y, z = z}
	end

	self.kick = function(r)
		DropPlayer(self.source, r)
	end

	self.addMoney = function(m)
		if type(m) == "number" and m > 0 then
			local newMoney = self.money + m
			self.money = newMoney
		end
		TriggerClientEvent('moneyUpdate', self.source, self.money)
	end

	self.removeMoney = function(m)
		if type(m) ~= "number" then
			return false
		end
		if self.money > m then
			if m > 0 then
				local newMoney = self.money - m
				self.money = newMoney
			end
			TriggerClientEvent('moneyUpdate', self.source, self.money)
			return true
		else
			return false
		end
	end

	self.setMoney = function(m)
		if type(m) == "number" then
			self.money = m
		end
		TriggerClientEvent('moneyUpdate', self.source, self.money)
	end

	self.addBank = function(m)
		if type(m) == "number" and m > 0 then
			local newBank = self.bank + m
			self.bank = newBank
			TriggerClientEvent("bankUpdate", self.source, self.bank)
		end
	end

	self.setBank = function(m)
		if type(m) == "number" then
			self.bank = m
			TriggerClientEvent("bankUpdate", self.source, self.bank)
		end
	end

	self.removeBank = function(m)
		if type(m) ~= "number" then
			return false
		end
		if self.bank > m then
			if  m > 0 then
				local newBank = self.bank - m
				self.bank = newBank
				TriggerClientEvent("bankUpdate", self.source, self.bank)
				return true
			end
		else
			return false
		end
	end

	self.addSalary = function(m)
		if type(m) == "number" and m > 0 then
			local newSalary = self.salary + m
			self.salary = newSalary
			TriggerClientEvent("salaryUpdate", self.source, self.salary)
		end
	end

	self.setSalary = function(m)
		if type(m) == "number" then
			self.salary = m
			TriggerClientEvent("salaryUpdate", self.source, self.salary)
		end
	end

	self.removeSalary = function(m)
		if type(m) ~= "number" then
			return false
		end
		if self.salary > m then
			if  m > 0 then
				local newSalary = self.salary - m
				self.salary = newSalary
				TriggerClientEvent("salaryUpdate", self.source, self.salary)
				return true
			end
		else
			return false
		end
	end

	self.setSessionVar = function(key, value)
		self.session[key] = value
	end

	self.getSessionVar = function(k)
		return self.session[k]
	end

	self.set = function(k, v)
		self[k] = v
	end

	self.get = function(k)
		return self[k]
	end

	self.setGlobal = function(g, default)
		self[g] = default or ""

		self["get" .. g:gsub("^%l", string.upper)] = function()
			return self[g]
		end

		self["set" .. g:gsub("^%l", string.upper)] = function(e)
			self[g] = e
		end

		Users[self.source] = self
	end

	self.getInventoryItem = function(check)
		local fuckESX = {}
		local count = 0
		local inventoryMe = self.inventory
		if inventoryMe ~= nil and next(inventoryMe) ~= nil then
			for slot, item in pairs(inventoryMe) do
				if inventoryMe[slot] ~= nil then
					if item.name == check then
						count = count + item.count
					end
				end
			end
		end
		fuckESX.count = count
		fuckESX.limit = -1
		return fuckESX
	end

	self.GetItemByName = function(item)
		local item = tostring(item):lower()
		local slot = ESX.GetFirstSlotByItem(self.inventory, item)
		if slot ~= nil then
			return self.inventory[slot]
		end
		return nil
	end

	self.GetItemBySlot = function(slot)
		local slot = tonumber(slot)
		if self.inventory[slot] ~= nil then
			return self.inventory[slot]
		end
		return nil
	end

	self.addInventoryItem = function(item, amount, slot, info)
		local totalWeight = ESX.GetTotalWeight(self.inventory)
		local itemInfo = ESX.Items[item:lower()]
		if itemInfo == nil then return end
		local amount = tonumber(amount)
		local slot = tonumber(slot) ~= nil and tonumber(slot) or ESX.GetFirstSlotByItem(self.inventory, item)
		if itemInfo.type == "weapon" and info == nil then
			amount = 1
			info = {
				serie = "No Serie",
				quality = 100
			}
		elseif itemInfo.name == 'id-card' and info == nil then
			info = {}
			info.firstname = self.firstname
			info.lastname = self.lastname
		elseif itemInfo.name == 'badge' and info == nil then
			info = {}
			info.job = self.job.label..' | '..self.job.grade_label
			info.firstname = self.firstname
			info.lastname = self.lastname
		elseif itemInfo.name == 'mask' and info == nil then
			info = {}
			info.number = 1
			info.color = 1
		end
		if (totalWeight + (itemInfo.weight * amount)) <= 150000 then
			if (slot ~= nil and self.inventory[slot] ~= nil) and (self.inventory[slot].name:lower() == item:lower()) and (itemInfo.type == "item" and not itemInfo.unique) then
				self.inventory[slot].count = self.inventory[slot].count + amount
				TriggerEvent("esx:onAddInventoryItem", self.source, item, amount)
				return true
			elseif (not itemInfo.unique and slot or slot ~= nil and self.inventory[slot] == nil) then
				self.inventory[slot] = {name = itemInfo.name, count = amount, info = info ~= nil and info or "", label = itemInfo.label, description = "", weight = itemInfo.weight, type = itemInfo.type, unique = itemInfo.unique, useable = itemInfo.useable, image = itemInfo.image, shouldClose = itemInfo.shouldClose, slot = slot, combinable = itemInfo.combinable}
				TriggerEvent("esx:onAddInventoryItem", self.source, item, amount)
				return true
			elseif (itemInfo.unique) or (not slot or slot == nil) or (itemInfo.type == "weapon") then
				for i = 1, 25, 1 do
					if self.inventory[i] == nil then
						self.inventory[i] = {name = itemInfo.name, count = amount, info = info ~= nil and info or "", label = itemInfo.label, description = "", weight = itemInfo.weight, type = itemInfo.type, unique = itemInfo.unique, useable = itemInfo.useable, image = itemInfo.image, shouldClose = itemInfo.shouldClose, slot = i, combinable = itemInfo.combinable}
						TriggerEvent("esx:onAddInventoryItem", self.source, item, amount)
						return true
					end
				end
			end
		end
		return false
	end

	self.removeInventoryItem = function(item, amount, slot)
		local amount = tonumber(amount)
		local slot = tonumber(slot)
		if slot ~= nil then
			if self.inventory[slot].count > amount then
				self.inventory[slot].count = self.inventory[slot].count - amount
				local event = {name = self.inventory[slot].name, count = self.inventory[slot].count}
				TriggerEvent("esx:onRemoveInventoryItem", self.source, event, amount)
				return true
			else
				local event = {name = self.inventory[slot].name, count = 0}
				TriggerEvent("esx:onRemoveInventoryItem", self.source, event, amount)
				self.inventory[slot] = nil
				return true
			end
		else
			local slots = ESX.GetSlotsByItem(self.inventory, item)
			local amountToRemove = amount
			if slots ~= nil then
				for _, slot in pairs(slots) do
					if self.inventory[slot].count > amountToRemove then
						self.inventory[slot].count = self.inventory[slot].count - amountToRemove
						local event = {name = self.inventory[slot].name, count = self.inventory[slot].count}
						TriggerEvent("esx:onRemoveInventoryItem", self.source, event, amount)
						return true
					elseif self.inventory[slot].count == amountToRemove then
						local event = {name = self.inventory[slot].name, count = 0}
						TriggerEvent("esx:onRemoveInventoryItem", self.source, event, amount)
						self.inventory[slot] = nil
						return true
					end
				end
			end
		end
		return false
	end

	self.setInventoryItem = function(items)
		self.inventory = items
	end

	self.ClearInventory = function()
		self.inventory = {}
	end

	self.setStress = function(new)
		self.stress = new
	end

	self.setJob = function(job, grade)
		local lastJob = json.decode(json.encode(self.job))
		grade = tonumber(grade)
		local vGrade
		if grade < 0 then
			vGrade = grade
			grade = grade * -1
		end
		if ESX.DoesJobExist(job, grade) then
			local jobObject, gradeObject = ESX.Jobs[job], ESX.Jobs[job].grades[grade]
			self.job.id    = jobObject.id
			self.job.name  = jobObject.name
			self.job.label = jobObject.label

			self.job.grade        = vGrade or grade
			self.job.grade_name   = gradeObject.name
			self.job.grade_label  = gradeObject.label
			self.job.grade_salary = gradeObject.salary

			self.job.skin_male    = {}
			self.job.skin_female  = {}

			if jobObject.divisions ~= nil then
				self.job.divisions = jobObject.divisions
			else
				self.job.divisions = {}
			end

			if jobObject.name ~= lastJob.name then
				if not string.find(jobObject.name, "off") and not string.find(lastJob.name, "off") then
					self.divisions = {}
			   end
			end

			if gradeObject.skin_male ~= nil then
				self.job.skin_male = json.decode(gradeObject.skin_male)
			end

			if gradeObject.skin_female ~= nil then
				self.job.skin_female = json.decode(gradeObject.skin_female)
			end
			TriggerEvent('esx:setJob', self.source, self.job)
			TriggerClientEvent('esx:setJob', self.source, self.job)
			MySQL.query.await('UPDATE users SET `job` = @job, `job_grade` = @job_grade, `divisions` = @divisions WHERE `identifier` = @identifier',{
				['job'] 		= job,
				['job_grade']	= vGrade or grade,
				['divisions']   = json.encode(self.divisions),
				['identifier']	= self.identifier
			})
		end
	end

	self.setGang = function(gang, grade)
		grade = tostring(grade)

		if ESX.DoesGangExist(gang, grade) then
			local gangObject, gradeObject = ESX.Gangs[gang], ESX.Gangs[gang].grades[tonumber(grade)]
			self.gang.id    = gangObject.id
			self.gang.name  = gangObject.name
			self.gang.label = gangObject.label

			self.gang.grade        = tonumber(grade)
			self.gang.grade_name   = gradeObject.name
			self.gang.grade_label  = gradeObject.label
			self.gang.grade_salary = gradeObject.salary

			TriggerEvent('esx:setGang', self.source, self.gang, lastGang)
			TriggerClientEvent('esx:setGang', self.source, self.gang)
			MySQL.query.await('UPDATE users SET `gang` = @gang, `gang_grade` = @gang_grade WHERE `identifier` = @identifier',{
				['gang'] 			= gang,
				['gang_grade']		= grade,
				['identifier']		= self.identifier
			})
		end
	end

	self.addDivision = function(division)
		local divisions = self.divisions
		if ESX.DoesDivisionExist(self.job.name, division) then
			table.insert(divisions, division)
		end
		self.divisions = divisions
		self.setJob(self.job.name, self.job.grade)
	end

	self.removeDivision = function(division)
		local divisions = self.divisions
		for k,v in ipairs(divisions) do
			if v == division then
				table.remove(divisions, k)
			end
		end
		self.divisions = divisions
		self.setJob(self.job.name, self.job.grade)
	end

	return self
end