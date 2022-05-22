-- Settings
local color = { r = 255, g = 255, b = 255, alpha = 255 } -- Color of the text 
local font = 0 -- Font of the text
local time = 7000 -- Duration of the display of the text : 1000ms = 1sec
local background = {
    enable = true,
    color = { r = 0, g = 0, b = 0, alpha = 80 },
}
local dropShadow = false

-- Don't touch
local nbrDisplaying = 1

RegisterCommand('me', function(source, args)
    local text = nil
	for i = 1,#args do
        if text then
            text = text..' '..args[i]
        else
            text = args[i]
        end
    end
    TriggerServerEvent('3dme:shareDisplay', text)
end)

RegisterNetEvent('3dme:triggerDisplay')
AddEventHandler('3dme:triggerDisplay', function(text, source, targetped_network)
    local senderplayerPed = NetworkDoesEntityExistWithNetworkId(targetped_network) and NetworkGetEntityFromNetworkId(targetped_network) or nil
    if senderplayerPed and DoesEntityExist(senderplayerPed) then
		local offset = 1 + (nbrDisplaying*0.14)
		ShowMe(GetPlayerFromServerId(source), text, offset, targetped_network)
	end
end)

function ShowMe(mePlayer, text, offset, targetped_network)
    local displaying = true
    local targetped_network = targetped_network
    Citizen.CreateThread(function()
        Wait(time)
        displaying = false
    end)
    Citizen.CreateThread(function()
        nbrDisplaying = nbrDisplaying + 1
        while displaying do
            Wait(0)
			local senderplayerPed = NetworkDoesEntityExistWithNetworkId(targetped_network) and NetworkGetEntityFromNetworkId(targetped_network) or nil
			if senderplayerPed and DoesEntityExist(senderplayerPed) then
				local coordsMe = GetEntityCoords(GetPlayerPed(mePlayer), false)
				local coords = GetEntityCoords(PlayerPedId(), false)
				local dist = Vdist2(coordsMe, coords)
				if dist < 2500 then
					if HasEntityClearLosToEntity(GetPlayerPed(-1), GetPlayerPed(mePlayer), 17) then
						DrawMe(coordsMe['x'], coordsMe['y'], coordsMe['z']+offset, text)
					end
				end
			end
        end
        nbrDisplaying = nbrDisplaying - 1
    end)
end

function DrawMe(x,y,z, text)
    local onScreen,_x,_y = World3dToScreen2d(x,y,z)
    local px,py,pz = table.unpack(GetGameplayCamCoord())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
 
    local scale = ((1/dist)*2)*(1/GetGameplayCamFov())*100

    if onScreen then

        -- Formalize the text
        SetTextColour(color.r, color.g, color.b, color.alpha)
        SetTextScale(0.0*scale, 0.55*scale)
        SetTextFont(font)
        SetTextProportional(1)
        SetTextCentre(true)
        if dropShadow then
            SetTextDropshadow(10, 100, 100, 100, 255)
        end

        -- Calculate width and height
        BeginTextCommandWidth("STRING")
        AddTextComponentString(text)
        local height = GetTextScaleHeight(0.55*scale, font)
        local width = EndTextCommandGetWidth(font)

        -- Diplay the text
        SetTextEntry("STRING")
        AddTextComponentString(text)
        EndTextCommandDisplayText(_x, _y)

        if background.enable then
            DrawRect(_x, _y+scale/45, width, height, background.color.r, background.color.g, background.color.b , background.color.alpha)
        end
    end
end