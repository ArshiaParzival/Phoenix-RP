
TriggerEvent(
  "esx:getSharedObject",
  function(obj)
      ESX = obj
      if ESX == nil then
          Wait(500)
      end
  end
)
local cshells = {}
local uclosed = false

RegisterCommand("createhouse", function(...)
  local plyPed = PlayerPedId()
  local plyJob = GetPlayerJobName()
  if not Config.CreationJobs[plyJob] then return; end
  local jobRank = GetPlayerJobRank()
  if Config.CreationJobs[plyJob].minRank then
    if not jobRank then
      return
    elseif Config.CreationJobs[plyJob].minRank > jobRank then
      return
    end
  end
  ShowNotification("Stand in position and press [G] to set the house entry portal.")
  while not IsControlJustPressed(0,47) do Wait(0); end
  while IsControlPressed(0,47) do Wait(0); end

  local entryPos = GetEntityCoords(plyPed)
  local entryHead = GetEntityHeading(plyPed)
  local entryLocation = vector4(entryPos.x,entryPos.y,entryPos.z,entryHead)
  ShowNotification("Press [G] to set the house garage portal location OR press [F] to set no garage.")
  while not IsControlJustPressed(0,47) and not IsControlJustPressed(0,49) do Wait(0); end
  while IsControlPressed(0,47) or IsControlPressed(0,49) do Wait(0); end

  local garageLocation = false
  if IsControlJustReleased(0,47) then
    local garagePos = GetEntityCoords(plyPed)
    local garageHead = GetEntityHeading(plyPed)
    garageLocation = vector4(garagePos.x,garagePos.y,garagePos.z,garageHead)
  end

  local shell = false

  local elements = {}

  for k,v in pairs(getShells()) do
    table.insert(elements, {label = k, value = k})
  end

  ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'select_shell',
  {
    title    = "Shell khane ra entekhab konid",
    align    = 'top-left',
    elements = elements,
  }, function(data, menu)

      shell = data.current.value
      menu.close()
  end)
  while not shell do Wait(0); end

  -- Select Upgrades
  uclosed = false
  cshells = getShells()

  shellUpgrades()

  while not uclosed do Wait(0); end

  local salePrice = false
  ShowNotification("Set the sale price.")
  exports["input"]:Open("Set Sale Price",(Config.UsingESX and Config.UsingESXMenu and "ESX" or "Native"),function(data)
    local price = (tonumber(data) and tonumber(data) > 0 and tonumber(data) or 0)
    salePrice = math.max(1,price)
  end)
  while not salePrice do Wait(0); end

  ShowNotification("House creation complete.")
  local loc1, loc2 = GetStreetNameAtCoord(entryLocation.x, entryLocation.y, entryLocation.z, Citizen.ResultAsInteger(), Citizen.ResultAsInteger())

  TriggerServerEvent("Allhousing:CreateHouse",{Price = salePrice,Entry = entryLocation,Garage = garageLocation,Shell = shell, Shells = finalShells()})
  -- TriggerServerEvent("allhousing:agentLog", 'Price', salePrice, 'House', GetStreetNameFromHashKey(loc1) .. '\n' .. GetStreetNameFromHashKey(loc2), 'Shells', json.encode(monkeyShells))
end)

RegisterCommand('gethouse', function(...)
  local plyJob = GetPlayerJobName()
  if not Config.CreationJobs[plyJob] then return; end
  local jobRank = GetPlayerJobRank()
  if Config.CreationJobs[plyJob].minRank then
    if not jobRank then
      return
    elseif Config.CreationJobs[plyJob].minRank > jobRank then
      return
    end
  end

  local house = getClosestHome()

  if house then
    sendMessage("House ID: " .. house.Id)
    sendMessage("House Price: " .. house.Price)
    if house.Owner and house.Owner:len() > 1 then
      sendMessage("House Owner: " .. house.OwnerName .. " (" .. house.Owner .. ")")
    end 
  end
end)

RegisterCommand('setwardrobe', function(...)
  if InsideHouse then
    if InsideHouse.Owned and (InsideHouse.Owner == GetPlayerIdentifier()) then
      SetWardrobe(InsideHouse)
    else
      sendMessage("Shoma saheb in property nistid")
    end
  else
    sendMessage("Shoma dakhel hich khaneyi nistid")
  end
end)

RegisterCommand('setinventory', function(...)
  if InsideHouse then
    if InsideHouse.Owned and (InsideHouse.Owner == GetPlayerIdentifier()) then
       SetInventory(InsideHouse)
    else
      sendMessage("Shoma saheb in property nistid")
    end
  else
    sendMessage("Shoma dakhel hich khaneyi nistid")
  end
end)

CreateDoors = function(house)
  local elements = {
    [1] = {label = Labels['NewDoor'],value = "new"},
    [2] = {label = Labels["Done"],value="done"}
  }
  ESX.UI.Menu.Open('default', GetCurrentResourceName(), "create_house_doors",{
      title    = Labels['Doors'],
      align    = 'center',
      elements = elements,
    }, 
    function(data,menu)
      menu.close()
      if data.current.value == "done" then
        TriggerServerEvent("Allhousing:CreateHouse",house)
      else
        Wait(500)
        TriggerEvent("Doors:CreateDoors",function(creation)
          table.insert(house.Doors,creation)
          CreateDoors(house)
        end)        
      end
    end
  )
  end
  local canBeUsed = true
  RegisterCommand("showhouses", function(...)
  
    if canBeUsed then
      canBeUsed = false
      local identifier = GetPlayerIdentifier()
  
      for _,house in pairs(Houses) do
  
        if not house.Owned and house.Owner ~= identifier then
          if house.Blip and DoesBlipExist(house.Blip) then
            RemoveBlip(house.Blip)
          end
        end
    
        if not house.Owned and house.Owner ~= identifier then
          house.Blip = CreateBlip(house.Entry, 350, 1, "Empty House", 1.0, 4)
        end
  
      end
  
      sendMessage("Tamami khane hayi ke kharidari nashodand dar GPS shoma be modat ^230 ^0sanie mark shodand!")
    
      Citizen.SetTimeout(30000, function()
        for _,house in pairs(Houses) do
          if not house.Owned and house.Owner ~= identifier then
            if house.Blip and DoesBlipExist(house.Blip) then
              RemoveBlip(house.Blip)
            end
          end
        end
  
        canBeUsed = true
      end)
  
    else
        sendMessage('Shoma be tazegi az in dastor estefade kardid lotfan hade aghal ^230 ^0sanie sabr konid!')
    end
  end)

  function getShells()
    return {
      ["HotelV1"]    = false,
      ["Trevor"]     = false,
      ["ApartmentV1"]= false,
      ["Michaels"]   = false
    }
  end


  function finalShells()
    local finalShells = {}
  
    for k,v in pairs(cshells) do
      if v then
        finalShells[k] = v
      end
    end
  
    return finalShells
  end

  function shellUpgrades()
    local elements = {}
  
    for k,v in pairs(cshells) do
      local condition = "❌"
      if v then
        condition = "✔️"
      end
      table.insert(elements, {label = k .. " " .. condition, value = k, status = v})
    end
  
    table.insert(elements, {label = " Confirm", value = "confirm"})
  
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'upgrade_shells',
    {
      title    = "Shell Upgrade",
      align    = 'top-left',
      elements = elements,
    }, function(data, menu)
  
      if data.current.value == "confirm" then
        uclosed = true
        menu.close()
      else
  
        cshells[data.current.value] = not data.current.status
  
        menu.close()
        shellUpgrades()
      end 
      
    end, function(data, menu)
    end)
  end
  
  function sendMessage(message)
    TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true ,args = {"[SYSTEM]", "^0" .. message}})
  end