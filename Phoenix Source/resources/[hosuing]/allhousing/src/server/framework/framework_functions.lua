GetESX = function()
  while not ESX do
    TriggerEvent("esx:getShsinsaredObjsinsect", function(obj)
      ESX = obj
    end)
    Wait(0)
  end
end

GetFramework = function()
    GetESX()
end

GetPlayerData = function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    while not xPlayer do xPlayer = ESX.GetPlayerFromId(source); Wait(0); end
    return xPlayer
end

GetPlayerCash = function(source)
    return GetPlayerData(source).money
end

GetPlayerBank = function(source)
      return GetPlayerData(source).bank
end

GetPlayerJobName = function(source)
    return GetPlayerData(source).job.name
end

GetPlayerJobRank = function(source)
    return GetPlayerData(source).job.grade
end

GetPlayerIdentifier = function(source)
      return GetPlayerData(source).identifier
end

TakePlayerBank = function(source,val)
    GetPlayerData(source).removeBank(val)
end

TakePlayerDirty = function(source,val)
    GetPlayerData(source).removeMoney(val)
end

GetPlayerDirty = function(source,val)
    return GetPlayerData(source).money
end

GetPlayerWeapon = function(source,name)
    local loadout = GetPlayerData(source).loadout
    for k,v in pairs(loadout) do
      if v.name == name then
        return v.name,v.ammo,v.label,v.components
      end
    end
    return false,0
end

AddPlayerWeapon = function(source,name,ammo)
    GetPlayerData(source).addWeapon(name,ammo)
end

TakePlayerWeapon = function(source,name,ammo)
    GetPlayerData(source).removeWeapon(name)
end

AddPlayerCash = function(source,value)
    GetPlayerData(source).addMoney(value)
end

TakePlayerCash = function(source,val)
    GetPlayerData(source).removeMoney(val)
end

TakePlayerItem = function(source,itemName,count)
    GetPlayerData(source).removeInventoryItem(itemName,(count or 1))
end

AddOfflineCash = function(identifier,val)
    MySQL.update("UPDATE users SET money=money+@addCash WHERE identifier=@identifier",{['@identifier'] = identifier,['@addCash'] = val})
end

AddOfflineBank = function(identifier,val)
    MySQL.update("UPDATE users SET bank = bank + @add WHERE identifier=@identifier",{['@identifier'] = identifier,['@add'] = tonumber(val)})
end

CanPlayerAfford = function(source,val)
  if GetPlayerCash(source) >= val then
    return true
  elseif GetPlayerBank(source) >= val then
    return true
  else
    return false
  end
end

GetPlayerByIdentifier = function(identifier)
    if not player then 
      return false
    else
        return player
    end
end

AddPlayerBank = function(source,val)
      GetPlayerData(source).addBank(val)
end  

AddPlayerItem = function(source,name,count)
    GetPlayerData(source).addInventoryItem(name,count)
end  

AddPlayerDirtyMoney = function(source,val)
      GetPlayerData(source).addMoney(val)
end    

GetPlayerSource = function(player)
    return player.source
end  

GetPlayerItemCount = function(source,item)
    return GetPlayerData(source).getInventoryItem(item).count
end 

GetPlayerItemData = function(source,item)
    return GetPlayerData(source).getInventoryItem(item)
end    

GetCharacterName = function(source)
    local data = GetPlayerData(source) 
    return (data.name)
end

AddSocietyMoney = function(account,money)
  TriggerEvent("esx_addonaccount:getSharedAccount",account,function(acc)
    if acc and type(acc) == "table" then
      acc.addMoney(tonumber(money))
    else
      print(string.format("Society not found for %s",account))
    end
  end)
end

CanPlayerCarry = function(source,name,count)
  if Config.UsingESX then
      local player = GetPlayerData(source)
      local itemData = player.getInventoryItem(name)
      if itemData.limit and itemData.limit ~= -1 and itemData.count and itemData.count + count > itemData.limit then
        return false
      else
        return true
      end
end

NotifyJobs = function(job,msg,pos)
  TriggerClientEvent("Allhousing:NotifyJob",-1,job,msg,pos)
end

NotifyPlayer = function(source,msg)
  TriggerClientEvent("Allhousing:NotifyPlayer",source,msg)
end

RegisterNetEvent("Allhousing:NotifyJobs")
AddEventHandler("Allhousing:NotifyJobs",NotifyJobs)
end