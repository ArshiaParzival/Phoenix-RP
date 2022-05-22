ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
  ESX = obj
end)

local vehicles = {}

RegisterServerEvent('garage:addKeys')
AddEventHandler('garage:addKeys', function(plate, model)
  local source = tonumber(source)
  local xPlayer = ESX.GetPlayerFromId(source)
  if plate == nil then
    return
  end
  TriggerClientEvent("PX_hotwire:updateKeys", source, true, plate)
  local identifier = xPlayer.identifier
  vehicles[plate] = identifier
end)


RegisterServerEvent('garage:removeKeys')
AddEventHandler('garage:removeKeys', function(plate)
  local source = tonumber(source)
  local xPlayer = ESX.GetPlayerFromId(source)
  if plate == nil then
    return
  end
  TriggerClientEvent("PX_hotwire:updateKeys", source, false, plate)
  local identifier = xPlayer.identifier
  if vehicles[plate] == identifier then
    vehicles[plate] = nil
  end
end)

RegisterServerEvent('PX_hotwire:givekey')
AddEventHandler('PX_hotwire:givekey', function(id, plate)
  local xPlayer = ESX.GetPlayerFromId(source)
  local zPlayer = ESX.GetPlayerFromId(tonumber(id))
  if plate == nil then
    return
  end
  if vehicles[plate] == xPlayer.identifier then
    vehicles[plate] = zPlayer.identifier
    TriggerClientEvent("PX_hotwire:updateKeys", tonumber(id), true, plate)
    TriggerClientEvent("PX_hotwire:updateKeys", source, false, plate)
    TriggerClientEvent('DoLongHudText', tonumber(id), 'Shoma Kelid Mashin ra Daryaft Kardid!', 1)
  else
    TriggerClientEvent('DoLongHudText', source, 'Shoma Kelid In Mashin Ra Nadarid!', 1)
  end
end)

AddEventHandler('esx:playerLoaded', function(source)
  local xPlayer = ESX.GetPlayerFromId(source)
  local identifier = xPlayer.identifier
  for i=1, #vehicles, 1 do
    if vehicles[i] == identifier then
      TriggerClientEvent("PX_hotwire:updateKeys", source, true, i)
    end
  end
end)

RegisterServerEvent('removelockpick')
AddEventHandler('removelockpick', function()
  local source = tonumber(source)
  local xPlayer = ESX.GetPlayerFromId(source)
  if math.random(1, 20) >= 14 then
    xPlayer.removeInventoryItem("lockpick", 1)
    TriggerClientEvent('DoLongHudText', source, 'The lockpick bent out of shape.', 1)
  end
end)

ESX.RegisterUsableItem('lockpick', function(source)
  TriggerClientEvent('lockpick:vehicleUse', source)
end)

----------------------------------------------

ESX.RegisterServerCallback('carlock:isVehicleOwner', function(source, cb, plate)
	local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then
        DropPlayer(source, 'Shoma Be Relog Niyaz Darid')
    end
    local plate = tostring(plate):upper()
    MySQL.scalar('SELECT owner FROM owned_vehicles WHERE (owner = @player or owner = @gang) AND plate = @plate', {
		['@player'] = xPlayer.identifier,
		['@gang']  	= xPlayer.gang.name,
		['@plate'] 	= plate
	}, function(result)
		if result then
			cb(result == xPlayer.identifier or result == xPlayer.gang.name)
		else
			cb(false)
		end
	end)
end)