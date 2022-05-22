--[[ Marker loop ]]--
Citizen.CreateThread(function()
    while true do
        local wait = 750
        local coords = GetEntityCoords(PlayerPedId())
        for i=1, #Locations do
            for j=1, #Locations[i]["shelfs"] do
                local pos = Locations[i]["shelfs"][j]
                local dist = GetDistanceBetweenCoords(coords, pos["x"], pos["y"], pos["z"], true)
                if dist <= 5.0 then
                    if dist <= 1.5 then
                        local text = '~w~'..Config.Locales[pos["value"]]
                        if dist <= 1.0 then
                            text = "~g~[E] ~w~" .. text
                            if IsControlJustPressed(0, Keys["E"]) then
                                OpenShopUi(i)
                        	end
                        end
                        DrawText3D(pos["x"], pos["y"], pos["z"], text)
                    end
                    wait = 5
                    Marker(pos)
                end
            end
        end
        Citizen.Wait(wait)
    end
end)

--[[ Check what to do ]]--
function OpenShopUi(number)
    local data = {}
    ESX.TriggerServerCallback('PX_shop:getShopItemPrices', function(items)
        for k, v in pairs(items) do
            table.insert(data, {name = k, label = v.label, price = v.price, image = k})
        end
        SetNuiFocus(true, true)
        SendNUIMessage({
            type = 'open',
            data = {
                inventory = data,
                shop = number
            }
        })
    end)
end

RegisterNUICallback("close", function()
    SetNuiFocus(false, false)
end)

RegisterNUICallback("purchase", function(data)
    if tonumber(data.shop) == 0 then
        ESX.TriggerServerCallback('PX_shop:buyStock', function(success)
            if success then
                ESX.ShowNotification("~h~You have sussecfully buy ~o~x" .. success.count .. " " .. success.item .. "~w~ as price : ~g~$" .. success.price, 'success')
            end
        end, {item = data.name, count = tonumber(data.count)})
    else
        TriggerServerEvent("PX_shop:buyItem", data.name, tonumber(data.count), tonumber(data.shop))
    end
end)