Citizen.CreateThread(function()
    local meta = vector3(809.89, -490.92, 30.63)
    local weed = vector3(2482.22, 3722.56, 43.92)
    local coca = vector3(1004.6, -1572.88, 30.8)

    local difrent = math.random(30, 50)

    local blip = AddBlipForRadius(meta.x - difrent, meta.y + difrent, meta.z, 100.0)
    SetBlipHighDetail(blip, true)
	SetBlipColour(blip, 1)
	SetBlipAlpha(blip, 30.0)
	SetBlipAsShortRange(blip, true)


    local blip2 = AddBlipForRadius(weed.x + difrent, weed.y - difrent, weed.z, 100.0)
    SetBlipHighDetail(blip2, true)
	SetBlipColour(blip2, 1)
	SetBlipAlpha(blip2, 30.0)
	SetBlipAsShortRange(blip2, true)

    local blip3 = AddBlipForRadius(coca.x + difrent, coca.y + difrent, coca.z, 100.0)
    SetBlipHighDetail(blip3, true)
	SetBlipColour(blip3, 1)
	SetBlipAlpha(blip3, 30.0)
	SetBlipAsShortRange(blip3, true)

end)