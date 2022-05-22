
------
-- Interaction Sounds by Scott
-- Version: v0.0.1
-- Path: server/main.lua
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('InteractSound_SV:PlayOnOne')
AddEventHandler('InteractSound_SV:PlayOnOne', function(clientNetId, soundFile, soundVolume)
    TriggerClientEvent('InteractSound_CL:PlayOnOne', clientNetId, soundFile, soundVolume)
	    SendLog(source, "Net ID", "null")
end)

------
-- Triggers -> ClientEvent InteractSound_CL:PlayOnSource
--
-- @param soundFile    - The name of the soundfile within the client/html/sounds/ folder.
--                     - Can also specify a folder/sound file.
-- @param soundVolume  - The volume at which the soundFile should be played. Nil or don't
--                     - provide it for the default of standardVolumeOutput. Should be between
--                     - 0.1 to 1.0.
--                     - Can also specify a folder/sound file.
--
-- Starts playing a sound locally on a single client, which is the source of the event.
------
RegisterServerEvent('InteractSound_SV:PlayOnSource')
AddEventHandler('InteractSound_SV:PlayOnSource', function(soundFile, soundVolume)
    TriggerClientEvent('InteractSound_CL:PlayOnOne', source, soundFile, soundVolume)
end)

------
-- RegisterServerEvent InteractSound_SV:PlayOnAll
-- Triggers -> ClientEvent InteractSound_CL:PlayOnAll
--
-- @param soundFile     - The name of the soundfile within the client/html/sounds/ folder.
--                      - Can also specify a folder/sound file.
-- @param soundVolume   - The volume at which the soundFile should be played. Nil or don't
--                      - provide it for the default of standardVolumeOutput. Should be between
--                      - 0.1 to 1.0.
--
-- Starts playing a sound on all clients who are online in the server.
------
RegisterServerEvent('InteractSound_SV:PlayOnAll')
AddEventHandler('InteractSound_SV:PlayOnAll', function(soundFile, soundVolume)
    TriggerClientEvent('InteractSound_CL:PlayOnAll', -1, soundFile, soundVolume)
    SendLog(source, "All Server", "-1")	
end)

------
-- RegisterServerEvent InteractSound_SV:PlayWithinDistance
-- Triggers -> ClientEvent InteractSound_CL:PlayWithinDistance
--
-- @param playOnEntity    - The entity network id (will be converted from net id to entity on client)
--                        - of the entity for which the max distance is to be drawn from.
-- @param maxDistance     - The maximum float distance (client uses Vdist) to allow the player to
--                        - hear the soundFile being played.
-- @param soundFile       - The name of the soundfile within the client/html/sounds/ folder.
--                        - Can also specify a folder/sound file.
-- @param soundVolume     - The volume at which the soundFile should be played. Nil or don't
--                        - provide it for the default of standardVolumeOutput. Should be between
--                        - 0.1 to 1.0.
--
-- Starts playing a sound on a client if the client is within the specificed maxDistance from the playOnEntity.
-- @TODO Change sound volume based on the distance the player is away from the playOnEntity.
------
RegisterServerEvent('InteractSound_SV:PlayWithinDistance')
AddEventHandler('InteractSound_SV:PlayWithinDistance', function(maxDistance, soundFile, soundVolume)  
	local ped = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(ped)
    local ped_NETWORK = NetworkGetNetworkIdFromEntity(ped)
    if maxDistance < 11 and maxDistance > 0 then
    TriggerClientEvent('InteractSound_CL:PlayWithinDistance', -1, source, maxDistance, soundFile, soundVolume, ped_NETWORK , playerCoords)
	elseif maxDistance < 11.0 and maxDistance > 0.0 then
    TriggerClientEvent('InteractSound_CL:PlayWithinDistance', -1, source, maxDistance, soundFile, soundVolume, ped_NETWORK , playerCoords)
    else
        SendLog(source, "Distance", maxDistance)	
    end
end)

function SendLog(source, method, range)
    local xPlayer = ESX.GetPlayerFromId(source)
    PerformHttpRequest('', function(err, text, headers)
    end, 'POST',
    json.encode({
    username = 'Interct Sound',
    embeds =  {{["color"] = 65280,
                ["author"] = {["name"] = 'Advanced Logs ',
                ["icon_url"] = 'https://cdn.probot.io/QDwVwOiMTw.gif'},
                ["description"] = "** 🌐 Anti Passion 🌐**\n```css\n[Cheater]: " ..GetPlayerName(source).. "\n" .. "[Method]: " .. method.. "\n" .. "[Range]: " .. range .."\n```",
                ["footer"] = {["text"] = "© Phoenix Logs- "..os.date("%x %X  %p"),
                ["icon_url"] = 'https://cdn.probot.io/QDwVwOiMTw.gif',},}
                },
    avatar_url = 'https://cdn.probot.io/QDwVwOiMTw.gif'
    }),
    {['Content-Type'] = 'application/json'
    })
end
