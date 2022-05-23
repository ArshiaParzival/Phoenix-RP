
ESX = nil
KashCache = {}
KashCharacters = {}
TriggerEvent('esx:getShsinsaredObjsinsect', function(obj) ESX = obj end)

furni.canPlayerAfford = function(source,price)
    local player = ESX.GetPlayerFromId(source)
    if player.money >= price then
        player.removeMoney(price)
      return true
    elseif player.bank >= price then
      player.removeBank(price)
      return true
    end
  return false
end

furni.givePlayerMoney = function(source,price)
    local player = ESX.GetPlayerFromId(source)
    player.addMoney(price)
  return false
end

furni.getIdentifier = function(source)
      local player = ESX.GetPlayerFromId(source)
      return player.identifier
end

RegisterNetEvent("furni:playerLogin")
AddEventHandler("furni:playerLogin", function()
  local identifier = furni.getIdentifier(source,true)
  if Config.UsingKashacters then
    while not KashCharacters[source] do Wait(0); end
    local st,fn = identifier:find(":")
    KashCache[source] = KashCharacters[source]..":"..identifier:sub((fn or 0)+1,identifier:len())
  end
end)

RegisterNetEvent("kashactersS:CharacterChosen")
AddEventHandler("kashactersS:CharacterChosen", function(charId)
  KashCharacters[source] = charId
end)

furni.priceLookup = {}
error = function(...) end
function GetDatabaseName()
  local dbconvar = GetConvar('mysql_connection_string', 'Empty')
  if not dbconvar or dbconvar == "Empty" then 
    print("Local dbconvar is empty."); 
    return false
  else
    local strStart,strEnd = string.find(dbconvar, "database=")
    if not strStart or not strEnd then
      local oStart,oEnd = string.find(dbconvar,"mysql://")
      if not oStart or not oEnd then
        print("Incorrect mysql_connection_string.")
        return false
      else
        local hostStart,hostEnd = string.find(dbconvar,"@",oEnd)
        local dbStart,dbEnd = string.find(dbconvar,"/",hostEnd+1)
        local eStart,eEnd = string.find(dbconvar,"?")
        local _end = (eEnd and eEnd-1 or dbconvar:len())
        local dbName = string.sub(dbconvar, dbEnd + 1, _end) 
        return dbName
      end
    else
      local dbStart,dbEnd = string.find(dbconvar,";",strEnd)
      local dbName = string.sub(dbconvar, strEnd + 1, (dbEnd and dbEnd-1 or dbconvar:len())) 
      return dbName
    end    
  end
end
SqlReady = function()
  local dbName = GetDatabaseName()
  if not dbName then
    print("Error connecting to database.")
    return
  end
  local dbTable = (Config and Config.SaveToTable or "allhousing")
  SqlFetch("SELECT * FROM INFORMATION_SCHEMA.TABLES where TABLE_SCHEMA=@dbName AND TABLE_NAME=@tabName",{['@dbName'] = dbName,['@tabName'] = dbTable},function(retData)
    if retData and retData[1] then
      furni.sqlReady = true; 
    else
      print(GetCurrentResourceName().." does not have required SQL table.")
    end
  end)
  for _,cat in pairs(furni.objects) do
    for k,v in pairs(cat) do
      furni.priceLookup[v.object] = v.price
    end
  end
end
if not Config.ControlSql then
  SqlFetch = function(ssm,spl,callback)
    MySQL.query(ssm,spl,callback)
  end
  SqlExecute = function(ssm,spl)
    MySQL.update(ssm,spl)
  end
  MySQL.ready(SqlReady)
end
if not Config.ControlAddition then
  furni.placeFurniture = function(source,houseData,itemData,pos,rot,object)
    local truePrice = (furni.priceLookup[itemData.object] and furni.priceLookup[itemData.object] or false)
    if truePrice and furni.canPlayerAfford(source,truePrice) then
      SqlFetch("SELECT * FROM "..(Config and Config.SaveToTable or "allhousing"),{},function(retData)
        for _,data in pairs(retData) do
          entry = json.decode(data.entry)
          if (math.floor(tonumber(houseData.Entry.x)) == math.floor(tonumber(entry.x)) and math.floor(tonumber(houseData.Entry.y)) == math.floor(tonumber(entry.y)) and math.floor(tonumber(houseData.Entry.z)) == math.floor(tonumber(entry.z))) then
            local furniture = json.decode(data.furniture)
            local newPos = {x = pos.x, y = pos.y, z = pos.z}
            local newRot = {x = rot.x, y = rot.y, z = rot.z}
            table.insert(furniture,{pos = newPos, rot = newRot, model = itemData.object})
            local jTab = {}
            for k,v in pairs(furniture) do
              jTab[k] = {
                pos = {x = v.pos.x, y = v.pos.y, z = v.pos.z},
                rot = {x = v.rot.x, y = v.rot.y, z = v.rot.z},
                model = v.model,
              }
            end
            SqlExecute("UPDATE "..(Config and Config.SaveToTable or "allhousing").." SET furniture=@furniture WHERE id=@id",{['@furniture'] = json.encode(jTab),['@id'] = data.id})
            TriggerEvent("Allhousing:SetFurni",houseData,furniture)
            return
          end
        end
      end)
    end
  end
end
Vdist = function(v1,v2)  
  if not v1 or not v2 or not v1.x or not v2.x or not v1.z or not v2.z then return 0; end
  return math.sqrt( ((v1.x - v2.x)*(v1.x-v2.x)) + ((v1.y - v2.y)*(v1.y-v2.y)) + ((v1.z-v2.z)*(v1.z-v2.z)) )
end
if not Config.ControlDeletion then
  furni.deleteFurniture = function(source,houseData,itemData,pos,rot)
    if not itemData then return; end
    SqlFetch("SELECT * FROM "..(Config and Config.SaveToTable or "allhousing"),{},function(retData)
      for _,data in pairs(retData) do
        entry = json.decode(data.entry)
        if (math.floor(tonumber(houseData.Entry.x)) == math.floor(tonumber(entry.x)) and math.floor(tonumber(houseData.Entry.y)) == math.floor(tonumber(entry.y)) and math.floor(tonumber(houseData.Entry.z)) == math.floor(tonumber(entry.z))) then
          local furniture = json.decode(data.furniture)
          local jTab = {}
          local closest,closestDist
          for k,v in pairs(furniture) do
            local _p = vector3(v.pos.x + houseData.Entry.x, v.pos.y + houseData.Entry.y, v.pos.z + houseData.Entry.z)
            local dist = Vdist(_p,pos)
            if not closestDist or dist < closestDist then
              closest = k
              closestDist = dist
            end
            jTab[k] = {
              pos = {x = v.pos.x, y = v.pos.y, z = v.pos.z},
              rot = {x = v.rot.x, y = v.rot.y, z = v.rot.z},
              model = v.model,
            }            
          end
          if closest and closestDist and closestDist < 1.0 then
            local truePrice = (furni.priceLookup[itemData.object] and furni.priceLookup[itemData.object] or false)
            if truePrice then
              table.remove(furniture,closest)
              table.remove(jTab,closest)
              furni.givePlayerMoney(source,math.floor(truePrice * (Config.ResaleValue and Config.ResaleValue/100.0 or 0.5)))
              SqlExecute("UPDATE "..(Config and Config.SaveToTable or "allhousing").." SET furniture=@furniture WHERE id=@id",{['@furniture'] = json.encode(jTab),['@id'] = data.id})
              TriggerEvent("Allhousing:SetFurni",houseData,furniture)
            end
          end
          return
        end
      end
    end)
  end
end
if not Config.ControlReplace then
  furni.replaceFurniture = function(source,houseData,itemData,pos,rot,object,lastObject)
    SqlFetch("SELECT * FROM "..(Config and Config.SaveToTable or "allhousing"),{},function(retData)
      for _,data in pairs(retData) do
        entry = json.decode(data.entry)
        if (math.floor(tonumber(houseData.Entry.x)) == math.floor(tonumber(entry.x)) and math.floor(tonumber(houseData.Entry.y)) == math.floor(tonumber(entry.y)) and math.floor(tonumber(houseData.Entry.z)) == math.floor(tonumber(entry.z))) then
          local furniture = json.decode(data.furniture)
          local newPos = {x = pos.x, y = pos.y, z = pos.z}
          local newRot = {x = rot.x, y = rot.y, z = rot.z}
          local jTab = {}
          for k,v in pairs(furniture) do
            if math.floor(v.pos.x + houseData.Entry.x) == math.floor(lastObject.pos.x) and math.floor(v.pos.y + houseData.Entry.y) == math.floor(lastObject.pos.y) and math.floor(v.pos.z + houseData.Entry.z) == math.floor(lastObject.pos.z) and v.model == itemData.object then
              furniture[k].pos = newPos
              furniture[k].rot = newRot
            end
            table.insert(jTab,{
              pos = {x = v.pos.x, y = v.pos.y, z = v.pos.z},
              rot = {x = v.rot.x, y = v.rot.y, z = v.rot.z},
              model = v.model,
            })
          end
          SqlExecute("UPDATE "..(Config and Config.SaveToTable or "allhousing").." SET furniture=@furniture WHERE id=@id",{['@furniture'] = json.encode(jTab),['@id'] = data.id})
          TriggerEvent("Allhousing:SetFurni",houseData,furniture)
          return
        end
      end
    end)
  end
end
RegisterNetEvent('furni:PlaceFurniture')
AddEventHandler('furni:PlaceFurniture', function(...) furni.placeFurniture(source,...); end)
RegisterNetEvent('furni:ReplaceFurniture')
AddEventHandler('furni:ReplaceFurniture', function(...) furni.replaceFurniture(source,...); end)
RegisterNetEvent('furni:DeleteFurniture')
AddEventHandler('furni:DeleteFurniture', function(...) furni.deleteFurniture(source,...); end)
AddEventHandler("Allhousing.Furni:GetPrices", function(cb) cb(furni.priceLookup); end)
Citizen.CreateThread(function()
  if LoadCallback then
    LoadCallback()
  end
end)