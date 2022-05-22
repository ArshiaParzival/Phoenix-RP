ESX 		= nil
PlayerData 	= {}

-- Police Notify:
isCop = false
local _

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end
	PlayerData = ESX.GetPlayerData()
	isCop = IsPlayerJobCop()
	Wait(500)
	spawnPacificSafe()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
	isCop = IsPlayerJobCop()
end)

-- [[ ESX SHOW ADVANCED NOTIFICATION ]] --
RegisterNetEvent('PX_bankrobbery:ShowAdvancedNotifyESX')
AddEventHandler('PX_bankrobbery:ShowAdvancedNotifyESX', function(title, subject, msg, icon, iconType)
	ESX.ShowNotification(msg)
	-- If you want to switch ESX.ShowNotification with something else:
	-- 1) Comment out the function
	-- 2) add your own
	
end)

-- [[ ESX SHOW NOTIFICATION ]] --
RegisterNetEvent('PX_bankrobbery:ShowNotifyESX')
AddEventHandler('PX_bankrobbery:ShowNotifyESX', function(msg)
	ShowNotifyESX(msg)
end)

function ShowNotifyESX(msg)
	ESX.ShowNotification(msg)
	-- If you want to switch ESX.ShowNotification with something else:
	-- 1) Comment out the function
	-- 2) add your own
end

function NotifyPoliceFunction(name)
	local pos = GetEntityCoords(GetPlayerPed(-1), false)
	streetName,_ = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
	streetName = GetStreetNameFromHashKey(streetName)
	TriggerServerEvent("PX_bankrobbery:notiyforpolicemani", pos)
end

local blipRobbery = nil

RegisterNetEvent('Parzival_bank:setBlip')
AddEventHandler('Parzival_bank:setBlip', function(position)
	blipRobbery = AddBlipForCoord(position.x, position.y, position.z)
	SetBlipSprite(blipRobbery, 161)
	SetBlipScale(blipRobbery, 2.0)
	SetBlipColour(blipRobbery, 15)
	PulseBlip(blipRobbery)
    SetTimeout(300000, function()
        RemoveBlip(blipRobbery)
    end)
end)

RegisterNetEvent('PX_bankrobbery:PoliceNotifyCL')
AddEventHandler('PX_bankrobbery:PoliceNotifyCL', function(alert)
	print(alert)
	if isCop or PlayerData.job.name == "weazel" then
		TriggerEvent('chat:addMessage', { args = {(Lang['dispatch_name']).. alert}})
	end
end)

RegisterNetEvent('PX_bankrobbery:PoliceNotifyBlip')
AddEventHandler('PX_bankrobbery:PoliceNotifyBlip', function(targetCoords)
	if (isCop or PlayerData.job == "weazel") and Config.AlertBlipShow then 
		local alertBlip = AddBlipForCoord(targetCoords.x, targetCoords.y, targetCoords.z)

		SetBlipSprite(alertBlip, 161)
		SetBlipScale(alertBlip, 2.0)
		SetBlipColour(alertBlip, 15)
		Citizen.Wait(90000)
		RemoveBlip(alertBlip)
	end
end)

-- Bank Blips:
Citizen.CreateThread(function()
	for k,v in pairs(Config.Banks) do
		CreateMapBlip(k,v)
	end
end)

function CreateMapBlip(k,v)
	local mk = v.blip
	if mk.enable then
		local blip = AddBlipForCoord(v.keypads[1].pos[1], v.keypads[1].pos[2], v.keypads[1].pos[3])
		SetBlipSprite (blip, mk.sprite)
		SetBlipDisplay(blip, mk.display)
		SetBlipScale  (blip, mk.scale)
		SetBlipColour (blip, mk.color)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(mk.bName)
		EndTextCommandSetBlipName(blip)
	end
end

-- Is Player A cop?
function IsPlayerJobCop()	
	if not PlayerData then return false end
	if not PlayerData.job then return false end
	for k,v in pairs(Config.PoliceJobs) do
		if PlayerData.job.name == v then return true end
	end
	return false
end

-- Function for 3D text:
function DrawText3Ds(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

-- Round Fnction:
function round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end


-- Instructional Buttons:
function ButtonMessage(text)
    BeginTextCommandScaleformString("STRING")
    AddTextComponentScaleform(text)
    EndTextCommandScaleformString()
end

-- Button:
function Button(ControlButton)
    N_0xe83a3e3557a56640(ControlButton)
end