local visible = false
local isPaused = false
ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

AddEventHandler("onKeyDown", function(key)
	if key == "f10" and ESX.GetPlayerData()['IsDead'] ~= 1 then
		ToggleScoreBoard()
	end
end)

function ToggleScoreBoard()
	visible = not visible
	SendNUIMessage({type = 'toggle', action = visible})
	if visible then scoreBoardThread() end
end

local lastFetch = 0
function scoreBoardThread()
	while visible do

		if GetGameTimer() - lastFetch > 60000 then
			lastFetch = GetGameTimer()
			ESX.TriggerServerCallback('PX_scoreboard:getInfo', function(data)
				SendNUIMessage({type = 'updateInfo', data = data})
			end)
		end
		
		local pauseMenuActive = IsPauseMenuActive()
		if pauseMenuActive and not isPaused then
			isPaused = true
			SendNUIMessage({type = 'toggle', action = false})
		elseif not pauseMenuActive and isPaused then
			isPaused = false
			SendNUIMessage({type = 'toggle', action = true})
		end

		Citizen.Wait(500)
	end
end