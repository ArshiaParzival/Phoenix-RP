GetESX = function()
  while not ESX do
    TriggerEvent("esx:getShsinsaredObjsinsect", function(obj)
      ESX = obj
    end)
    Wait(0)
  end
  while not ESX.IsPlayerLoaded() do Wait(0); end
end


GetFramework = function()
    GetESX()
end

GetPlayerData = function()
  if Config.UsingESX then
    while not ESX do
      Wait(50)
    end
    
    return ESX.GetPlayerData()
  else
    -- NON-ESX USERS ADD HERE
  end
end

SetPlayerData = function(data)
  PlayerData = data
end

SetPlayerJob = function(job)
  PlayerData = (PlayerData or GetPlayerData())
  if type(PlayerData) ~= "table" then
    _print("SetPlayerJob() Failed")
  else
    PlayerData.job = job
  end
end

GetPlayerCash = function()
  if Config.UsingESX then
    PlayerData = GetPlayerData()
    if Config["UsingESX_V1.2.0"] then
      for k,v in pairs(PlayerData.accounts) do
        if v.name == Config.CashAccountName then
          return v.money
        end
      end
    else
      return PlayerData.money
    end
  else
    -- NON-ESX USERS ADD HERE
  end
end

GetPlayerBank = function()
  if Config.UsingESX then
    PlayerData = GetPlayerData()
    for k,v in pairs(PlayerData.accounts) do
      if v.name == Config.BankAccountName then
        return v.money
      end
    end
    return 0
  else
    -- NON-ESX USERS ADD HERE
  end
end

CheckForLockpick = function()
  if Config.UsingESX then
    PlayerData = GetPlayerData()
    for k,v in pairs(PlayerData.inventory) do
      if v.name == Config.LockpickItem then
        return (v.count and v.count > 0 and true or false)
      end
    end
    return false
  else
    -- NON-ESX USERS ADD HERE
  end
end

GetPlayerJobName = function()
  if Config.UsingESX then
    PlayerData = GetPlayerData()
    return PlayerData.job.name
  else
    -- NON-ESX USERS ADD HERE
  end
end

GetPlayerJobRank = function()
  if Config.UsingESX then
    PlayerData = GetPlayerData()
    return PlayerData.job.grade
  else
    -- NON-ESX USERS ADD HERE
  end
end

GetPlayerIdentifier = function()
  if Config.UsingESX then
    if Config.UsingKashacters then 
      return KashIdentifier
    else
      PlayerData = GetPlayerData()
      return PlayerData.identifier
    end
  else
    -- NON-ESX USERS ADD HERE
  end
end

CanPlayerAfford = function(value)
  print("Can player afford?",GetPlayerCash(),value)
  if GetPlayerCash() >= value then
    return true
  elseif GetPlayerBank() >= value then
    return true
  else
    return false
  end
end

GetNearbyPlayers = function(pos,radius)
    return ESX.Game.GetPlayersInArea((pos or GetEntityCoords(PlayerPedId())),(radius or 20.0))
end

NotifyJob = function(job,msg,pos)
  local jobName = GetPlayerJobName()
  if jobName and jobName == job then
    if pos then
      Citizen.CreateThread(function()
        local start = GetGameTimer()
        ShowNotification(Labels["InteractDrawText"]..Labels["TrackMessage"].."\n"..msg)
        while GetGameTimer() - start < 10000 do
          if IsControlJustPressed(0,47) then
            SetNewWaypoint(pos.x,pos.y)
            return
          end
          Wait(0)
        end
      end)
    else
      ShowNotification(msg)
    end
  end
end

RegisterNetEvent("Allhousing:NotifyJob")
AddEventHandler("Allhousing:NotifyJob",NotifyJob)

RegisterNetEvent("esx:updatePlayerData")
AddEventHandler("esx:updatePlayerData",SetPlayerData)

RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob",SetPlayerJob)
