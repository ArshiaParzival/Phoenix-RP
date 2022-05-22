ESX = nil
inMenu = true
local showblips = true
local atbank = false
local bankMenu = true

Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(0)
  end
end)

-- draw marker and check distance for chip purchase
Citizen.CreateThread(function()
    while true do
        local InRange = false
        local PlayerPed = GetPlayerPed(-1)
        local PlayerPos = GetEntityCoords(PlayerPed)

            local dist = GetDistanceBetweenCoords(PlayerPos, 1116.1, 220.02, -49.44)
            if dist < 20 then
                InRange = true
				DrawMarker(29, 1116.1, 220.02, -49.44, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.00, 1.00, 1.00, 0, 250, 0, 200, false, true, 2, true, false, false, false)
                if dist < 2 then
                    DisplayHelpText("Press ~INPUT_PICKUP~ to access casino account ~b~")
                    if IsControlJustPressed(1, 38) then
						inMenu = true
						SetNuiFocus(true, true)
						SendNUIMessage({type = 'openGeneral'})
						TriggerServerEvent('casino:balance')
						local ped = GetPlayerPed(-1)
					end
                end
				if IsControlJustPressed(1, 322) then
					inMenu = false
					SetNuiFocus(false, false)
					SendNUIMessage({type = 'close'})
				end
            end

        if not InRange then
            Citizen.Wait(0)
        end
        Citizen.Wait(0)
    end
end)

-- hud info
RegisterNetEvent('chips_currentbalance1')
AddEventHandler('chips_currentbalance1', function(balance)
	local id = PlayerId()
	local playerName = GetPlayerName(id)
	
	SendNUIMessage({
		type = "balanceHUD",
		balance = balance,
		player = playerName
		})
end)

-- sell chips
RegisterNUICallback('casino_deposit', function(data)
	TriggerServerEvent('casino:deposit', tonumber(data.amount))
end)

-- buy chips
RegisterNUICallback('casino_withdrawl', function(data)
	TriggerServerEvent('casino:withdraw', tonumber(data.amountw))
end)

-- buy ticket
RegisterNUICallback('casino_ticket', function(data)
	TriggerServerEvent('casino:ticket', tonumber(data.amountt))
end)

-- balance
RegisterNUICallback('casino_balance', function()
	TriggerServerEvent('casino:balance')
end)

-- return ballance
RegisterNetEvent('casino_balance:back')
AddEventHandler('casino_balance:back', function(balance)
	SendNUIMessage({type = 'balanceReturn', bal = balance})
end)

RegisterNUICallback('NUIFocusOff', function()
  inMenu = false
  SetNuiFocus(false, false)
  SendNUIMessage({type = 'closeAll'})
end)

-- help text
function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end