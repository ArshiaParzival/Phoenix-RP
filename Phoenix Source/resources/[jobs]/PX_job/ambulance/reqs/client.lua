ESX = nil
carblip = 0

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('parzival_ambulance:openreqs')
AddEventHandler('parzival_ambulance:openreqs', function(source)
	OpenReqsList()
end)

RegisterNetEvent('parzival_ambulance:acceptreq')
AddEventHandler('parzival_ambulance:acceptreq', function(loc)
	SetNewWaypoint(loc)
end)

RegisterNetEvent('parzival_ambulance:addblip')
AddEventHandler('parzival_ambulance:addblip', function(id, coords)
	local id = id
	if carblip ~= 0 then
		RemoveBlip(carblip)
		carblip = 0
	end
	Wait(2000)
	carblip = AddBlipForCoord(coords)
	SetBlipSprite(carblip, 56)
	SetBlipFlashes(carblip, true)
	SetBlipColour(carblip,8)
	SetBlipFlashTimer(carblip, 5000)
	BeginTextCommandSetBlipName('STRING')
	AddTextComponentSubstringPlayerName('Medical officer')
	EndTextCommandSetBlipName(carblip)
	while carblip ~= 0 do
		Wait(3000)
		ESX.TriggerServerCallback('parzival_ambulance:getcoord', function(coords)
			if coords ~= nil then
				SetBlipCoords(carblip,coords)
			else
				RemoveBlip(carblip)
				carblip = 0
			end
		end,id)
	end
end)

RegisterNetEvent('parzival_ambulance:delblip')
AddEventHandler('parzival_ambulance:delblip',function()
	if carblip ~= 0 then
		RemoveBlip(carblip)
		carblip = 0
	end
end)

function OpenReqsList()
	ESX.TriggerServerCallback('parzival_ambulance:getReqs', function(reqs)
		local elements = {}
		for i=1, #reqs, 1 do
			table.insert(elements, {
				label = "Request Id : "..reqs[i].reqid.." | Accept : "..reqs[i].status,
				icname = reqs[i].name,
				reqid = reqs[i].reqid,
				text = reqs[i].reason,
				status = reqs[i].status,
				phone = reqs[i].phone,
				id = reqs[i].id,
				coord = reqs[i].coord,
				accept = reqs[i].accept,
			})
		end
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'reqs_lists', {
			title    = "Requests",
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			local elements = {}
			local id = data.current.reqid
			ESX.TriggerServerCallback('parzival_ambulance:acceptername', function(acceptername)
				ESX.TriggerServerCallback('parzival_ambulance:icname', function(name)
					table.insert(elements,{label = "Id : ".. data.current.reqid ,value = "nil"})
					table.insert(elements,{label = "Accept status : "..data.current.status ,value = "nil"})
					if data.current.accept == "open" then
						table.insert(elements,{label = "Accept", value = "yes"})
					else
						table.insert(elements,{label = "Accepted by : ".. acceptername, value = "nil"})
					end
					if acceptername == name then
						table.insert(elements,{label = "Finish",value = "finish"})
					end
					table.insert(elements,{label = "Pin location",value = "loc"})
                    table.insert(elements,{label = "Khandam Payam",value = "matn"})
					ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'reqs_list', {
						title    = "Request",
						align    = 'top-left',
						elements = elements
						}, function(data2, menu2)
						menu2.close()
						if data2.current.value == 'yes' then
							TriggerServerEvent('parzival_ambulance:areqs', data.current.reqid)
							menu.close()
						elseif data2.current.value == 'finish' then
							TriggerServerEvent("parzival_ambulance:creqs", data.current.reqid)
							menu.close()
                        elseif data2.current.value == 'matn' then
							ESX.ShowNotification(data.current.text)
						elseif data2.current.value == 'loc' then
							local coord = data.current.coord
							SetNewWaypoint(coord.x, coord.y)
						end
					end, function(data2, menu2)
						menu2.close()
					end)
				end)
			end, id)
		end, function(data, menu)
			menu.close()
		end)
	end)
end