ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local CargoLoots = {}
local IsOnCoolDown = false
local CargoTime = 0
local Cops = 0
local KeyValue = {}
local ValidCodes = {}
local NumberCharset = {}
local Charset = {}
local DoesBotHasKey = {
    [1] = false,
    [2] = false,
    [3] = false,
    [4] = false,
    [5] = false,
    [6] = false,
    [7] = false,
    [8] = false,
    [9] = false,
    [10] = false,
    [11] = false,
    [12] = false,
    [13] = false,
    [14] = false,
    [15] = false,
    [16] = false,
    [17] = false,
    [18] = false,
    [19] = false,
    [20] = false,
    [21] = false,
    [22] = false,
    [23] = false,
    [24] = false,
    [25] = false,
    [26] = false,
    [27] = false,
    [28] = false,
    [29] = false,
    [30] = false,
    [31] = false,
    [32] = false,
    [33] = false,
    [34] = false,
    [35] = false,
    [36] = false,
    [37] = false,
    [38] = false,
    [39] = false,
    [40] = false,
    [41] = false,
    [42] = false,
    [43] = false,
    [44] = false,
    [45] = false,
    [46] = false,
    [47] = false,
    [48] = false,
    [49] = false,
    [50] = false,
    [51] = false,
    [52] = false,
    [53] = false,
    [54] = false,
    [55] = false,
    [56] = false,
    [57] = false,
    [58] = false,
    [59] = false,
    [60] = false
}

function GenerateBotKeys() --inja ridam ye meghdar LoL xD
    for i = 0, Config.TotalKeys do 
        for k, v in pairs(DoesBotHasKey) do
            if DoesBotHasKey[math.random(#DoesBotHasKey)] ~= true then
                DoesBotHasKey[math.random(#DoesBotHasKey)] = true
                break
            else
                DoesBotHasKey[math.random(#DoesBotHasKey)] = true
                break
            end
        end
    end
    CargoLoots = Config.Loots
end

GenerateBotKeys()

ESX.RegisterServerCallback("PX_Cargo:SyncBotsInServer", function(source, cb)
    KeyValue = {}
    for k, v in pairs(DoesBotHasKey) do
        table.insert(KeyValue, k)
    end
    cb(json.encode(KeyValue), IsOnCoolDown)
end)

ESX.RegisterServerCallback("PX_Cargo:DoesBotHasKey", function(source, cb, ID)
    for k, v in pairs(DoesBotHasKey) do
        if k == tonumber(ID) then
            if v then
                cb(true)
                break
            else
                cb(false)
                break
            end
        end
    end
end)

ESX.RegisterServerCallback("PX_Cargo:GetBoxInventory", function(source, cb)
    for k, v in pairs(CargoLoots) do
        cb({
            items = v.items,
            weapons = v.weapons
        })
        break
    end
end)

ESX.RegisterServerCallback("PX_Cargo:CheckCargoAvalibility", function(source, cb)
    Cops = 0
    for k, v in pairs(GetPlayers()) do
        local gPx = ESX.GetPlayerFromId(v)
        if gPx ~= nil then
            if gPx.job.name == 'police' then
                Cops = Cops + 1
            end
        end
    end
    if ESX.GetPlayerFromId(source).getInventoryItem("net_cracker").count >= 1 then
        if Cops > Config.RequiredCops then
            cb(true, true, os.time() - CargoTime)
        else
            cb(false, true, os.time() - CargoTime)
        end
    else
        cb(true, false, os.time() - CargoTime)
    end
end)

ESX.RegisterServerCallback("PX_Cargo:IsCodeValid", function(source, cb, Code)
    for k, v in pairs(ValidCodes) do
        if v == Code then
            cb(true)
            table.remove(ValidCodes, k)
            return
        end
    end
    cb(false)
end)

ESX.RegisterServerCallback("PX_Cargo:MoneyRequest", function(source, cb)
    if ESX.GetPlayerFromId(source).money > 200000 then 
        cb(true)
        ESX.GetPlayerFromId(source).removeMoney(200000)
    else
        TriggerClientEvent('chat:addMessage', source, { args = { '^1[Cargo]', ' ^2Pool Shoma Kafi Nist' } })
        cb(false)
    end
end)

RegisterServerEvent("PX_Cargo:TakeKeyCodeFromDealer")
AddEventHandler("PX_Cargo:TakeKeyCodeFromDealer", function(ID)
    local source = source
    for k, v in pairs(DoesBotHasKey) do
        if k == tonumber(ID) then
            v = false
            break
        end
    end
    local NewCode = GenerateCode()
    TriggerClientEvent('esx:showNotification', source, "~y~~h~Code Cargo Shoma: ~w~~h~"..NewCode)
    TriggerClientEvent('chat:addMessage', source, { args = { '^1[Cargo Code]', ' ^2Code Daryaft Shode: ^3'..NewCode } })
    table.insert(ValidCodes, NewCode)
end)

RegisterServerEvent("PX_Cargo:ImArrived")
AddEventHandler("PX_Cargo:ImArrived", function()
    CargoTime = os.time()
    IsOnCoolDown = true
    SetTimeout(3600000, function()
        IsOnCoolDown = false
        KeyValue = {}
        for k, v in pairs(DoesBotHasKey) do
            table.insert(KeyValue, k)
        end
        TriggerClientEvent("sr_cargo:ClientSyncDealers", -1, json.encode(KeyValue))
        CargoLoots = Config.Loots
    end)
end)

RegisterServerEvent("PX_Cargo:StartProcess")
AddEventHandler("PX_Cargo:StartProcess", function()
    for k, v in pairs(GetPlayers()) do
        local gPx = ESX.GetPlayerFromId(v)
        if gPx ~= nil then
            if gPx.job.name == 'police' then
                TriggerClientEvent("sr_cargo:ShowVehiclePos", gPx.source, Config.DropCoord)
            end
        end
    end
    SetTimeout(900000, function()
        TriggerClientEvent("PX_Cargo:DropTheCargo", -1, Config.DropCoord)
    end)
end)

RegisterServerEvent('PX_Cargo:RefreshInventory')
AddEventHandler('PX_Cargo:RefreshInventory', function(type, name, number)
    print(true)
	local xPlayer = ESX.GetPlayerFromId(source)
	Citizen.CreateThread(function()
		for k, v in pairs(xPlayer.loadout) do
			for _, j in pairs(v) do
				if _ == "name" then 
					if j == name then
						TriggerClientEvent('esx:showNotification', xPlayer.source, "~y~~h~Shoma In Aslahe Ra Dar Inventory Khod Darid")
						return 
					end
				end
			end
		end
		if type == "item_standard" then
			for k, v in pairs(CargoLoots[1].items) do
				if v.name == name then
					if number > v.count then
						TriggerClientEvent('esx:showNotification', xPlayer.source, "~y~~h~Meghdar Vared Shode Sahih Nist")
						break
					elseif number < v.count or number == v.count then
						if xPlayer.getInventoryItem(name).count + number < xPlayer.getInventoryItem(name).limit or xPlayer.getInventoryItem(name).count + number == xPlayer.getInventoryItem(name).limit then
							v.count = v.count - number
							xPlayer.addInventoryItem(name, number)
							break
						else
							TriggerClientEvent('esx:showNotification', xPlayer.source, "~y~~h~Inventory Shoma Fazaye Kafi Baraye In Item Nadarad.")
							break
						end
					end
				end
	   		end
		elseif type == "item_weapon" then
			for k, v in pairs(CargoLoots[1].weapons) do
				for _, j in pairs(v) do
					if j == name then
						xPlayer.addWeapon(name, 250)
						table.remove(CargoLoots[1].weapons, k)
						break
					end
				end
			end
		end
	end)
end)

for i = 48,  57 do table.insert(NumberCharset, string.char(i)) end
for i = 65,  90 do table.insert(Charset, string.char(i)) end
for i = 97, 122 do table.insert(Charset, string.char(i)) end

function GenerateCode()
	math.randomseed(GetGameTimer())
	local generatedCode = string.lower(GetRandomLetter(2) ..GetRandomNumber(2)..GetRandomLetter(1))
	return generatedCode
end

function GetRandomNumber(length)
	Citizen.Wait(1)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandomNumber(length - 1) .. NumberCharset[math.random(1, #NumberCharset)]
	else
		return ''
	end
end

function GetRandomLetter(length)
	Citizen.Wait(1)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandomLetter(length - 1) .. Charset[math.random(1, #Charset)]
	else
		return ''
	end
end