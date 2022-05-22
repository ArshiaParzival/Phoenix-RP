Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local coords = GetEntityCoords(PlayerPedId())
        local distance = #(coords - vector3(241.23, 224.98, 106.29))
        if distance < 20 then
            if distance < 8.0 then
                DrawMarker(20, vector3(241.23, 224.98, 106.29), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.3, 255, 255, 255, 255, false, true, nil, false)
                if distance < 2.0 then
                    TriggerEvent('esx:showHelpNotification', 'Press ~INPUT_CONTEXT~ For Take Salary')
                    if IsControlJustReleased(1, 38) then
                        TriggerServerEvent("Proxtended:PX_TakeSalary")
                    end
                end
            else
                Citizen.Wait(2000)
            end
        else
            Citizen.Wait(5000)
        end
    end
  end)