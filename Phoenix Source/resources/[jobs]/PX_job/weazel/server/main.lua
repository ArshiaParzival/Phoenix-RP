ESX = nil
local ads = {}
local cads = 1
local adcost = 50000

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

TriggerEvent('esx_society:registerSociety', 'weazel', 'News', 'society_weazel', 'society_weazel', 'society_weazel', {type = 'public'})

RegisterCommand('tabligh', function(source, args)
    local identifier = GetPlayerIdentifier(source)
    if not DoesHaveAds(identifier) then
      if not args[1] then
        SendMessage(source, "Shoma Dar Ghesmat Matn Tabligh Chizi Vared Nakardid!")
        return
      end
      local message = table.concat(args, " ")
      ads[cads] = {message = message, owner = identifier, name = string.gsub(exports.Proxtended:GetPlayerICName(source), "_", " "), created = os.time()}
      cads = cads + 1
      SendMessage(source, "Tabligh Shoma Ba Movafaghiat Sabt Shod Lotfan Ta Baresi An Shakiba Bashid!")
	  local xPlayers = ESX.GetPlayers()
	  for i=1, #xPlayers, 1 do
		local xP = ESX.GetPlayerFromId(xPlayers[i])
		if xP.job.name  == "weazel" and xP.job.grade >= 1 then
			TriggerClientEvent("esx:showNotification", xPlayers[i], "Tabligh Jadid Sabt Shod!")
		end
	  end
    else
      SendMessage(source, "Shoma Dar hale hazer yek ^1Tabligh ^0Darid!")
    end
end, false)

RegisterCommand('ads', function(source)
  local xPlayer = ESX.GetPlayerFromId(source)
  if xPlayer.job.name == "weazel" and xPlayer.job.grade >= 1 then

    if Count(ads) > 0 then
     
      TriggerClientEvent('chatMessage', source, "", {255, 0, 0}, "^0 |====== List Tablighat Faal ======| ")
      for k,v in pairs(ads) do
        TriggerClientEvent('chatMessage', source, "", {255, 0, 0}, "^3[^1" .. k  .. "^3]^0 Owner: ^2" .. v.name)
      end

    else
      SendMessage(source, "Tablighi Baraye Namayesh Vojod NaDarad!")
    end
    
  else
    SendMessage(source, "Shoma Dastresi Kafi Baraye Estefade Az In Dastor Ra NaDarid!")
  end
end, false)

RegisterCommand("ad", function(source, args)
  local xPlayer = ESX.GetPlayerFromId(source)
  if xPlayer.job.name == "weazel" and xPlayer.job.grade >= 1 then

    if not args[1] then
      SendMessage(source, "Shoma Dar Ghesmat ID Tabligh Chizi Vared Nakardid!")
      return
    end

    if not tonumber(args[1]) then
      SendMessage(source, "Shoma Dar Ghesmat ID Tabligh Faghat Mitavanid Adad Vared Konid!")
      return
    end

    if not args[2] then
      SendMessage(source, "Shoma Dar Ghesmat Action Chizi Vared Nakardid!")
      return
    end

    local adid = tonumber(args[1])
    local action = string.lower(args[2])
    local author = string.gsub(xPlayer.name, "_", " ")

    if ads[adid] then
      
      local ad = ads[adid]
      if action == "view" then
        SendMessage(source, "^2" .. ad.name .. ":^0 " .. ad.message)
      elseif action == "accept" then
        local zPlayer = ESX.GetPlayerFromIdentifier(ad.owner)
        if zPlayer then
            if zPlayer.bank >= 50000 then
              zPlayer.removeBank(adcost)
              xPlayer.addBank(adcost)
              ads[adid] = nil
              SendMessage(zPlayer.source, "Tabligh Shoma Tavasot ^3" .. author .. "^0 Ghabol Shod Va Mablagh ^2" .. adcost .. "$^0 Az Hesab Shoma Kam Shod!")
              TriggerClientEvent('chat:addMessage', -1, {
				template = '<div style="padding: 1vw;background: linear-gradient(-90deg,#3178f9, #1935becf);border-radius: 20px;box-shadow: 0 0 10px #2464d8;max-width: 730px;"><span style="display:block; margin-bottom:20px"><span style="padding:10px;border-radius:10px;background: #0089ff;box-shadow: 0 0 10px #3178f9;"><i class="fa fa-newspaper"></i></span> <b>[ Weazle News ]</b></span>' .. ad.message .. '<p style="text-align: right; font-size: 12pt; font-style: italic;"><i class="fa fa-user"></i>   '..ad.name.."</p></div>",
				args = { "", "" }
				})
            else
              SendMessage(source, "Shakhs Mored Nazar Pol Kafi Baraye Pardakht Hazine Tabligh Ra NaDarad!")
            end
        else
          SendMessage(source, "Shakhsi ke in Tabligh ra ferestade Dar shahr nist!")
        end
      elseif action == "decline" then
 
        if not args[3] then 
          SendMessage(source, "Shoma Dar Ghesmat Dalil Baste Shodan Tabligh Chizi Vared nakardid!")
          return
        end

        local reason = table.concat(args, " ", 3)
        local zPlayer = ESX.GetPlayerFromIdentifier(ad.owner)
        ads[adid] = nil
        if zPlayer then SendMessage(zPlayer.source, "Tabligh shoma tavasot ^2" .. author .. "^0 Baste Shod be Dalile: ^3" .. reason) end
      
      else 
        SendMessage(source, "Action Vared Shode Eshtebah Ast!")
      end

    else
      SendMessage(source, "Id Tabligh Vared Shode Eshtebah Ast!")
    end

  else
    SendMessage(source, "Shoma dastresi kafi baraye estefade az in dastor ra naDarid!")
  end
end, false)

function DoesHaveAds(identifer)
  for k,v in pairs(ads) do
    if v.owner == identifer then
        return true
    end
  end

  return false
end

function Count(object)
  local count = 0
  for k,v in pairs(object) do
    count = count + 1
  end

  return count
end

function SendMessage(target, message)
  TriggerClientEvent('chatMessage', target, "[ Wazel News ] : ", {255, 0, 0}, message)
end

function CheckADS()

  for k,v in pairs(ads) do
    if os.time() - v.created >= 600 then

      local xPlayer = ESX.GetPlayerFromIdentifier(v.owner)
      if xPlayer then
        SendMessage(xPlayer.source, "Tabligh Shoma Be Elat Adam Pasokhgoyi Az Samte ^2Wazel News ^1Baste ^0 Shod!")
      end

      ads[k] = nil

    end
  end

SetTimeout(15000, CheckADS)
end

CheckADS()