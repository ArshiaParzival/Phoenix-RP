AddEventHandler('esx:playerLoaded', function(source)

			TriggerClientEvent('PX_bankrobbery:loadDataCL', source, Banks, Safes)

		end)

		

		RegisterServerEvent('PX_bankrobbery:loadDataSV')

		AddEventHandler('PX_bankrobbery:loadDataSV', function()

			TriggerClientEvent('PX_bankrobbery:loadDataCL', -1, Banks, Safes)

		end)

		

		-- inUse state:

		RegisterServerEvent('PX_bankrobbery:inUseSV')

		AddEventHandler('PX_bankrobbery:inUseSV', function(state)

			for i = 1, #Banks do

				Banks[i].InProgress = state

			end

			TriggerClientEvent('PX_bankrobbery:inUseCL', -1, state)

		end)

		

		RegisterServerEvent('PX_bankrobbery:KeypadStateSV')

		AddEventHandler('PX_bankrobbery:KeypadStateSV', function(type, id, state)

			local xPlayer = ESX.GetPlayerFromId(source)

			if type == "first" then

				Banks[id].keypads[1].hacked = state

			elseif type == "second" then

				Banks[id].keypads[2].hacked = state

			end	

			TriggerClientEvent('PX_bankrobbery:KeypadStateCL', -1, id, state, type)

		end)



		RegisterServerEvent('PX_bankrobbery:OpenVaultDoorSV')

		AddEventHandler('PX_bankrobbery:OpenVaultDoorSV', function(k,v,heading,amount)

			local xPlayer = ESX.GetPlayerFromId(source)

			TriggerClientEvent('PX_bankrobbery:OpenVaultDoorCL', -1, k,v,heading,amount)

		end)



		RegisterServerEvent('PX_bankrobbery:CloseVaultDoorSV')

		AddEventHandler('PX_bankrobbery:CloseVaultDoorSV', function(k,v,heading,amount)

			local xPlayer = ESX.GetPlayerFromId(source)

			TriggerClientEvent('PX_bankrobbery:CloseVaultDoorCL', -1, k,v,heading,amount)

		end)



		

		-- ## PACIFIC SAFE ## --

		RegisterServerEvent('PX_bankrobbery:pacificSafeSV')

		AddEventHandler('PX_bankrobbery:pacificSafeSV', function(id, state)

			local xPlayer = ESX.GetPlayerFromId(source)

			Banks[id].safe.cracked = state

			TriggerClientEvent('PX_bankrobbery:pacificSafeCL', -1, id, state)

		end)



		-- DeskDoor::

		RegisterServerEvent('PX_bankrobbery:deskDoorSV')

		AddEventHandler('PX_bankrobbery:deskDoorSV', function(id, state)

			local xPlayer = ESX.GetPlayerFromId(source)

			Banks[id].deskDoor.lockpicked = state

			TriggerClientEvent('PX_bankrobbery:deskDoorCL', -1, id, state)

		end)

		-- Open Door:

		RegisterServerEvent('PX_bankrobbery:OpenDeskDoorSV')

		AddEventHandler('PX_bankrobbery:OpenDeskDoorSV', function(k,v,heading,amount)

			local xPlayer = ESX.GetPlayerFromId(source)

			TriggerClientEvent('PX_bankrobbery:OpenDeskDoorCL', -1, k,v,heading,amount)

		end)

		-- Close Door:

		RegisterServerEvent('PX_bankrobbery:CloseDeskDoorSV')

		AddEventHandler('PX_bankrobbery:CloseDeskDoorSV', function(k,v,heading,amount)

			local xPlayer = ESX.GetPlayerFromId(source)

			TriggerClientEvent('PX_bankrobbery:CloseDeskDoorCL', -1, k,v,heading,amount)

		end)
		-- trigger function policeCount:

		getPoliceCount()