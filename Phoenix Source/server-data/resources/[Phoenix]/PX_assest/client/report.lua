ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('Phoenixsgreport:openreportsmenu')
AddEventHandler('Phoenixsgreport:openreportsmenu', function()
	OpenReportsList()
end)

function OpenReportsList()

	ESX.TriggerServerCallback('Phoenixfstreport:reports', function(reports)

		local elements = {
			head = {"Reporter", "Report ID", "Matn", "Status", "Gozine"},
			rows = {}
		}

		for i=1, #reports, 1 do

			table.insert(elements.rows, {
				data = reports[i],
				cols = {
					reports[i].name,
					reports[i].reportid,
					reports[i].reason,
					reports[i].status,
					'{{' .. "Answer" .. '|answer}} {{' .. "Close" .. '|close}}'
				}
			})
		end

		ESX.UI.Menu.Open('list', GetCurrentResourceName(), "reports_list_admins", elements, function(data, menu)
			local rep = data.data

			if data.value == 'answer' then
				TriggerServerEvent('Phoenixsgreport:arreport', rep.reportid)
				menu.close()
			elseif data.value == 'close' then
				TriggerServerEvent('Phoenixlksgreport:crreport', rep.reportid)
			end
		end, function(data, menu)
			menu.close()
		end)

	end)

end