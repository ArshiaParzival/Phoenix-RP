------------------------------------------------------------------
--                          Variables
------------------------------------------------------------------
local showHud = true                          -- Boolean to show / hide HUD
local hunger = 100                            -- Init hunger's variable. Set to 100 for development.
local thirst = 100                            -- Init thirst's variable. Set to 100 for development.
local health = 100
local armor  = 100
local ownServerID = GetPlayerServerId(PlayerId())
local vehicle, engine = false, 0
local vehData = {handler = false}

------------------------------------------------------------------
--                          Functions
------------------------------------------------------------------

function updateHUD(health, armor)
  SendNUIMessage({
    update = true,
    health = health,
    armor  = armor,
    engine = vehicle and engine
  })
end

------------------------------------------------------------------
--                          Voice events
------------------------------------------------------------------
AddEventHandler('pma-voice:setTalkingMode', function(newMode)
  SendNUIMessage({action = "voiceRange", data = newMode})
end)
--[[
  enabled = true/false
  channel = radio Channel
--]]
AddEventHandler('PX_hud:updateRadioState', function(data)
  SendNUIMessage({action = "radioFreq", data = data})
end)

--[[
  radio = talking on radio
  talking = talking on proximity
--]]
AddEventHandler('PX_hud:updateVoiceState', function(data)
  SendNUIMessage({action = "talking", data = data})
end)
------------------------------------------------------------------
--                          Events
------------------------------------------------------------------

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    handleData(xPlayer)
end)

RegisterNetEvent('PX_hud:refresh')
AddEventHandler('PX_hud:refresh', function(xPlayer)
  handleData(xPlayer)
end)

AddEventHandler("PX_hid:updateVehicleInfo", function(data)
  vehicle = data.vehicle
  engine = data.engine
end)

RegisterNetEvent("esx:setJob")
AddEventHandler('esx:setJob', function(job)
  if job.label ~= 'nojob' then
    SendNUIMessage({action = "job", value = job.label .. " | " .. job.grade_label, name = job.name})
  else
    SendNUIMessage({action = "job", value = job.label, name = job.name})
  end
end)

RegisterNetEvent('esx:setGang')
AddEventHandler('esx:setGang', function(gang)
  if gang.name ~= 'nogang' then
    SendNUIMessage({action = "gang", value = gang.name .. " | " .. gang.grade_label, name = gang.name})
  else
    SendNUIMessage({action = "hidegang"})
  end
end)

AddEventHandler("status:togglePhone", function(status)
  SendNUIMessage({action = "togglePhone", value = status})
end)

RegisterNetEvent('status:modifyShowStatus')
AddEventHandler('status:modifyShowStatus', function(status)
  showHud = status
end)
------------------------------------------------------------------
--                          Citizen
------------------------------------------------------------------
RegisterNetEvent('esx_customui:updateStatus')
AddEventHandler('esx_customui:updateStatus', function(status)
	SendNUIMessage({action = "updateStatus", status = status})
end)

local previousArmor = 0
local previousHealth = 0
local previousEngine = 0
RegisterNetEvent('showStatus')
AddEventHandler('showStatus', function()
  -- Show HUD
  Citizen.CreateThread(function()
    local showed = false
    while true do

      local pause = IsPauseMenuActive()

      if showed ~= showHud and not pause then
        SendNUIMessage({
          display = showHud
        })
        showed = showHud
      end
      if pause and showed then
        SendNUIMessage({
          display = false
        })
        showed = false
      end

      if showHud and showed then
        local ped = PlayerPedId()
        -- Health
        local pedhealth = GetEntityHealth(ped)

        if pedhealth < 100 then
          health = 0
        else
          health = pedhealth - 100
        end
        -- armor
        local armor = GetPedArmour(ped)
        if health ~= previousHealth or armor ~= previousArmor then
          previousHealth = health
          previousArmor = armor
          updateHUD(health, armor)
        end

        -- Engine
        if engine >= 0 and engine ~= previousEngine then
          previousEngine = engine
          updateHUD(health, armor)
        end

      end
      Citizen.Wait(500)
    end
  end)
end)

RegisterCommand("togglehud", function(source, args)
  showHud = not showHud
end)

-- [Function]
function updateIndicators(type, data)
  local newData = convertData(type, data)
  SendNUIMessage({action = "indicator", value = newData})
end
exports("updateIndicators", updateIndicators)

function handleData(xPlayer)
  local job = xPlayer.job
  local gang = xPlayer.gang
  if gang.name ~= 'nogang' then
    SendNUIMessage({action = "gang", value = string.gsub(gang.name, "_", " ") .. " | " .. gang.grade_label, name = gang.name})
  end
  if job.label ~= 'nojob' then  
    SendNUIMessage({action = "job", value = job.label .. " | " .. job.grade_label, name = job.name})
  end
end

function convertData(type, data)
    local newData = {}
    for id,talking in pairs(data) do
      if talking then
        table.insert(newData, {id = id, type = type})
      end
    end

    return newData
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		ped = PlayerPedId()
		local vehicle = GetVehiclePedIsIn(ped)
		if vehicle > 0 and GetPedInVehicleSeat(vehicle, -1) == ped then
			vehData = {
				handler = vehicle,
				fuel = GetVehicleFuelLevel(vehicle),
				lights = GetVehicleLightsState(vehicle),
				indicator = GetVehicleIndicatorLights(vehicle),
				pause = IsPauseMenuActive()
			}

			TriggerEvent('PX_hid:updateVehicleInfo', {vehicle = vehicle, engine = GetVehicleEngineHealth(vehicle)})
		elseif vehData.handler then
			TriggerEvent('PX_hid:updateVehicleInfo', {vehicle = false, engine = 0})
			vehData = {handler = false}
		end
	end
end)