ESX = nil
local isInsideNCZ = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

-- Variables
local directions = {
  N = 360, 0,
  NE = 315,
  E = 270,
  SE = 225,
  S = 180,
  SW = 135,
  W = 90,
  NW = 45
  --  N = 0, <= will result in the HUD breaking above 315deg
}

local streetHash1, streetHash2, playerDirection;
local isLoaded, isGpsOn
local isHide = false
local stampData = {currentTime = 0, firstTrigger = false}
local id = GetPlayerServerId(PlayerId())

RegisterNetEvent("streetlabel:changeLoadStatus")
AddEventHandler("streetlabel:changeLoadStatus", function(status)
	if type(status) ~= "boolean" then
		return
	end

	isLoaded = status
end)

AddEventHandler("loading:Loaded", function()
	isLoaded = true
end)

function changeGpsStatus(status)
	isGpsOn = status
	SendNUIMessage({
		type = 'displayaddress',
		active = isGpsOn
	});
end

Citizen.CreateThread(function()

	while not isLoaded do
		Wait(500)
	end

	while true do
		local ped = PlayerPedId();

		local paused = IsPauseMenuActive();
		local coords = GetEntityCoords(ped);
		local zone = GetNameOfZone(coords.x, coords.y, coords.z);
		local zoneLabel = GetLabelText(zone);

		if isLoaded and not paused and not isHide then 
			if isGpsOn then
				local var1, var2 = GetStreetNameAtCoord(coords.x, coords.y, coords.z, Citizen.ResultAsInteger(), Citizen.ResultAsInteger())
				streetHash1 = GetStreetNameFromHashKey(var1);
				streetHash2 = GetStreetNameFromHashKey(var2);
				playerDirection = GetEntityHeading(ped);
				
				for k, v in pairs(directions) do
					if (math.abs(playerDirection - v) < 22.5) then
						playerDirection = k;
			
						if (playerDirection == 1) then
							playerDirection = 'N';
							break;
						end

						break;
					end
				end

				street2 = '';
				if (streetHash2 == '') then
					street2 = zoneLabel;
				else
					street2 = streetHash2..', '..zoneLabel;
				end
			end
			
			SendNUIMessage({
				type = 'streetLabel:MSG',
				active = true,
				direction = playerDirection,
				zone = streetHash1,
				ncz = isGpsOn and isInsideNCZ,
				street = street2,
				time = id
			});

			local mData = ESX.Game.MiniMapPos()
			SendNUIMessage({action = "minimap", data = {width = mData.width, x = mData.x}})
		else
			if not isLoaded or paused or isHide then
				SendNUIMessage({
					type = 'streetLabel:MSG',
					active = false
				});
			end
		end
		-- Wait for half a second.
		Citizen.Wait(1000)
	end
end)

-- [[ GPS Section ]]
AddEventHandler('onClientMapStart', function()
    TriggerEvent('PX_streetlabel:removeGPS')
end)

RegisterNetEvent('PX_streetlabel:addGPS')
AddEventHandler('PX_streetlabel:addGPS', function()
	DisplayRadar(true)
	changeGpsStatus(true)
end)

RegisterNetEvent('PX_streetlabel:removeGPS')
AddEventHandler('PX_streetlabel:removeGPS', function()
	DisplayRadar(false)
	changeGpsStatus(false)
end)

function Hide(status)
	isHide = status
end

AddEventHandler('PX_streetlabel:inNCZ', function(state)
	isInsideNCZ = state
end)