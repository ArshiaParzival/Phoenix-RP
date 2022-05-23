ESX = nil
gangs = {}
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('PXgangxxpropPX:forceBlip')
AddEventHandler('PXgangxxpropPX:forceBlip', function()
	TriggerClientEvent('PXgangxxpropPX:updateBlip', -1)
end)

ESX.RegisterServerCallback('PXgangxxpropPX:getOnlinePlayers', function(source, cb)
	local xPlayers = ESX.GetPlayers()
	local players  = {}

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		table.insert(players, {
			source     = xPlayer.source,
			identifier = xPlayer.identifier,
			name       = xPlayer.name,
			gang        = xPlayer.gang
		})
	end

	cb(players)
end)

RegisterServerEvent("PXgangxxpropPX:setArmor")
AddEventHandler("PXgangxxpropPX:setArmor", function()

  local xPlayer = ESX.GetPlayerFromId(source)

  if xPlayer.gang.name ~= "nogang" then
    if xPlayer.bank >= 500 then

      xPlayer.removeBank(500)
      TriggerClientEvent('setArmorHandler', source)
      TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma ba movafaghiat armor poshidid!")

    else
      TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma pol kafi baraye kharid jelighe zed golule Dar Bank nadarid gheymat jelighe ^2500$ ^0ast!")
    end
  else
    exports.Proxtended:bancheater(source, "Tried to buy armor without being part of any gang", "Cheat Lua executor")
  end

end)

ESX.RegisterServerCallback('PXgangxxpropPX:carAvalible', function(source, cb, plate)
  MySQL.scalar('SELECT `stored` FROM `owned_vehicles` WHERE plate = @plate', {
    ['@plate']  = plate
  }, function(stored)
      cb(stored)
  end)
end)

ESX.RegisterServerCallback('PXgangxxpropPX:getCars', function(source, cb)
  local ownedCars = {}
  local xPlayer = ESX.GetPlayerFromId(source)

  MySQL.query('SELECT * FROM `owned_vehicles` WHERE LOWER(owner) = @gang AND type = \'car\'', {
    ['@gang']    = string.lower(xPlayer.gang.name),
    ['@stored']  = true,
  }, function(data)
    for _,v in pairs(data) do
      local vehicle = json.decode(v.vehicle)
      if v.stored == true then
        table.insert(ownedCars, {vehicle = vehicle, state = true, plate = v.plate})
      else
        table.insert(ownedCars, {vehicle = vehicle, state = false, plate = v.plate})
      end
    end
    cb(ownedCars)
  end)
end)

ESX.RegisterServerCallback('PXgangxxpropPX:getPlayerInventory', function(source, cb)

         local xPlayer = ESX.GetPlayerFromId(source)
        local items   = xPlayer.inventory

         cb({
            items = items
        })

 end)

 function FixT(data)
  local Ti = {}
  for k,v in pairs(data) do
      if v.blip then
          table.insert(Ti, v.blip)
      end
  end
  return Ti
end

TriggerEvent('es:addAdminCommand', 'gblip', 6, function(source)
  ActiveGang = MySQL.query.await('SELECT * FROM gangs_data WHERE `expire_time` > NOW()', {})
  TriggerClientEvent("gangs:ShowBlip", source, FixT(ActiveGang))
end)

ESX.RegisterServerCallback(
    "PX_glist:getganglistusers",
    function(source, cb)
        local source = source
        local gangeshchie = ESX.GetPlayerFromId(source).gang.name
        if gangeshchie ~= "nogang" then
            local xPlayers = ESX.GetPlayers()
            local players = {}
            local gangonlines = 0
            for i = 1, #xPlayers, 1 do
                local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
                if xPlayer.gang.name == gangeshchie then
                    gangonlines = gangonlines + 1
                    table.insert(
                        players,
                        {
                            Id = xPlayer.source,
                            name = xPlayer.name
                        }
                    )
                end
            end
            cb(true, players, gangonlines, gangeshchie)
        else
            cb(false, nil, 0, gangeshchie)
        end
    end
)

RegisterServerEvent("Parzival_Gang:TakeFromImpound")
AddEventHandler("Parzival_Gang:TakeFromImpound", function(plate)
  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)
  if xPlayer.money >= 1000 then
    xPlayer.removeMoney(1000)
    TriggerClientEvent("Parzival_Gang:TakeFromImpound", _source, plate)
    MySQL.update.await("UPDATE owned_vehicles SET stored=@state, garage=@garage WHERE plate=@plate",{['@state'] = true, ['@garage'] = "gang", ['@plate'] = plate})
  else
    TriggerClientEvent('chatMessage', _source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma Pool Kafi Nadarid!")
  end
end)