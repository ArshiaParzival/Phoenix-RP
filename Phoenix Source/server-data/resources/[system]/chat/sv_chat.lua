RegisterServerEvent('chat:init')

RegisterServerEvent('chat:addTemplate')

RegisterServerEvent('chat:addMessage')

RegisterServerEvent('chat:addSuggestion')

RegisterServerEvent('chat:removeSuggestion')

RegisterServerEvent('_chat:messageEntirpixelered')

RegisterServerEvent('chat:clear')

RegisterServerEvent('__cfx_internal:commandFallback')



RegisterServerEvent('chat:logMessage')

AddEventHandler('chat:logMessage', function(message)



    TriggerEvent('DiscordBot:ToDiscord', 'chat', GetPlayerName(source) .. ' [ID: ' .. source .. ']', message, 'user', source, true, false)
	

end)


AddEventHandler('_chat:messageEntirpixelered', function(author, color, message)

    if not message or not author then
	
        return
		
    end
	


    TriggerEvent('chatMessage', source, author, message)
	
	

    if not WasEventCanceled() then
	
        TriggerClientEvent('chatMessage', source, "SYSTEM ", { 255, 0, 0 }, 'Az ^1(/) ^0Estefade Konid') 
		
    end
	
end)



AddEventHandler('__cfx_internal:commandFallback', function(command)

    local name = GetPlayerName(source)
	
	

    TriggerEvent('chatMessage', source, name, '/' .. command)
	
	

    if not WasEventCanceled() then
	
        TriggerClientEvent('chatMessage', source, "SYSTEM ", { 255, 0, 0 }, 'Command Vared Shodeh ^1Eshtebah ^0 Ast!') 
		
    end



    CancelEvent()
	
end)

-- player join messages
AddEventHandler('playerConnecting', function()

   -- TriggerClientEvent('chatMessage', -1, '', { 255, 255, 255 }, '^2* ' .. GetPlayerName(source) .. ' Vared shod.')
end)



--AddEventHandler('playerDropped', function(reason)

--	TriggerClientEvent('chatMessage', -1,"^8[^3Disconnect Massage^8] ^2("..GetPlayerName(source)..") ^9Server Ro Tark Kard Be Dalil :^3("..reason..")")
--end)



-- RegisterCommand('say', function(source, args, rawCommand)
--     TriggerClientEvent('chatMessage', -1, (source == 0) and 'console' or GetPlayerName(source), { 255, 255, 255 }, rawCommand:sub(5))
-- end)