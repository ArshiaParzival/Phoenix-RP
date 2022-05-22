ESX = nil
local xPlayer = {}

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(1)
    end
    xPlayer = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(data)
    xPlayer = data
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    xPlayer.job = job
end)

local nargileObjects = {}
local nargileSingleObject = nil
local carryingNargile = false
local marpuc = nil
local sessionStarted = false
local currentHookah = nil
local carryingKoz = false
local koz = {

    obj = nil
}

Citizen.CreateThread(function()
    while true do
        local sleep = true
        Citizen.Wait(0)
        local ply = PlayerPedId()
        local coords = GetEntityCoords(ply, true)
        if #(coords - Config.nargileYap.coords) < 2.5 then
            sleep = false
            if ESX ~= nil and xPlayer.job.name == "coffee" then
                local text = '~INPUT_CONTEXT~ Ghelyoon |  ~INPUT_REPLAY_SHOWHOTKEY~ Zoghal'


                if(carryingNargile)then
                    text = '~INPUT_CONTEXT~ Gozashtan Ghelyoon | ~INPUT_REPLAY_SHOWHOTKEY~ Zoghal'
                end

                if carryingKoz then
                    text = '~INPUT_CONTEXT~ Ghelyoon | ~INPUT_REPLAY_SHOWHOTKEY~ Gozashtan Zoghal'
                end

                ESX.ShowFloatingHelpNotification(text, Config.nargileYap.coords.x, Config.nargileYap.coords.y, Config.nargileYap.coords.z)

                if IsControlJustReleased(0, 38) then
                    if  not carryingNargile then
                        if  not carryingKoz then
                            local obj = CreateObject(4037417364, 0,0,0, true, 0, true)
                            local boneIndex2 = GetPedBoneIndex(playerPed, 24818)
                            nargileSingleObject = obj
                            carryingNargile = true
                            anim()
                            AttachEntityToEntity(obj, ply, boneIndex2, -0.15, 0.2, 0.18, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
                        else
                            ESX.ShowNotification("Shoma Dar Hal Hazer Yek Ghelyan/Zoghal Dar Dast Darid!") 

                        end
                    else
                        DeleteEntity(nargileSingleObject)
                        nargileSingleObject = nil
                        carryingNargile = false   
                        ClearPedTasks(PlayerPedId())
                    end
                end
                if IsControlJustPressed(0, 311) then
                    if koz.obj == nil and not carryingKoz then
                        if  not carryingNargile then
                            carryingKoz = true
                            attachKoz()
                        else
                            ESX.ShowNotification("Shoma Dar Hal Hazer Yek Ghelyan/Zoghal Dar Dast Darid!") 
                        end
                    else

                        DeleteEntity(koz.obj)
                        koz.obj = nil
                        carryingKoz = false   
                        ClearPedTasks(PlayerPedId())
                    end
                end
            else
                ESX.ShowFloatingHelpNotification("Be Ghelyoona Dast Nazan", Config.nargileYap.coords.x, Config.nargileYap.coords.y, Config.nargileYap.coords.z)
            end
        end
        if sleep then
            Citizen.Wait(1000)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        local sleep = true
        Citizen.Wait(0)
        for k,v in pairs(Config.Masalar) do
            sleep = false
            if carryingNargile or v.alreadyHaveHookah and ESX ~= nil  then
                 local ply = PlayerPedId()
                 local coords = GetEntityCoords(ply, true)
                  if #(coords - v.coords) < 2.5 and not v.alreadyHaveHookah and xPlayer.job.name == "coffee" then 
                    ESX.ShowFloatingHelpNotification( "~INPUT_CONTEXT~ Gozashtan Ghelyan", v.coords.x, v.coords.y, v.coords.z)
                    if IsControlJustReleased(0, 38) then
                        putNargileToTable(k)
                     end
                 elseif #(coords - v.coords) < 2.5 and v.alreadyHaveHookah and xPlayer.job.name == "coffee" then 
                   ESX.ShowFloatingHelpNotification( "~INPUT_CONTEXT~ Bardashtan Ghelyan", v.coords.x, v.coords.y, v.coords.z)
                     if IsControlJustReleased(0, 38) then
                           takeNargileFromTable(k)
                     end
                end
            end
        end
        if sleep then
            Citizen.Wait(1000)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local coords = GetEntityCoords(PlayerPedId())
        local distance = #(coords - vector3(100.96, 199.75, 108.37))
        if distance < 20 then
            if xPlayer.job.name == "coffee" then
                DrawMarker(20, vector3(100.96, 199.75, 108.37), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.8, 0.8, 0.5, 255, 255, 255, 255, false, true, nil, false)
                if distance < 2.0 then
                    TriggerEvent('esx:showHelpNotification', 'Press ~INPUT_CONTEXT~ For Open ~r~Menu~s~')
                    if IsControlJustReleased(1, 38) then
                        OpenMenuAction()
                    end
                end
            else
                Citizen.Wait(5000)
            end
        else
            Citizen.Wait(2000)
        end
    end
end)

function OpenMenuAction()
    local elements = {
        {label = 'Bardashtan Item', value = 'bi'},
        {label = 'Gozashtan Item', value = 'gi'},
        {label = 'Work Wear', value = 'ww'},
        {label = 'Citizen Wear', value = 'cw'}
    }
    if xPlayer.job.grade_name == "boss" then
		table.insert(elements, {label = 'Boss Action', value = 'boss'})
	end
    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cafe_menu', {
        title = 'Cafe Action',
        align = 'top-left',
        elements = elements
    }, function(data, menu)
            if data.current.value == 'bi' then
                OpenGetStocksMenu()
            elseif data.current.value == 'gi' then
                OpenPutStocksMenu()
            elseif data.current.value == 'ww' then
                local job =  xPlayer.job.name
                local gradenum =  xPlayer.job.grade

                ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                    ESX.TriggerServerCallback('esx_society:getUniforms', function(SkinMale, SkinFemale)-- get uniform from esx_society
                        if skin.sex == 0 then
                            TriggerEvent('skinchanger:loadClothes', skin, SkinMale)
                        else
                            TriggerEvent('skinchanger:loadClothes', skin, SkinFemale)
                        end
                    end, gradenum, job)
                end)
            elseif data.current.value == 'cw' then
                ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                    TriggerEvent('skinchanger:loadSkin', skin)
                end)
            elseif data.current.value == 'boss' then
                TriggerEvent('esx_society:openBossMenu', 'coffee', function(data, menu)
                    menu.close()
                end)
            end
        end,
    function(data, menu)
        menu.close()
    end)
end

function OpenPutStocksMenu()
    ESX.TriggerServerCallback('PX_Cafe:getPlayerInventory', function(inventory)
      local elements = {}
      for i=1, #inventory.items, 1 do
        local item = inventory.items[i]
        if item.count > 0 then
          table.insert(elements, {label = item.label .. ' x' .. item.count, type = 'item_standard', value = item.name})
        end
      end
      ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'stocks_menu',
        {
          title    = 'inventory',
          align    = 'top-left',
          elements = elements
        },
        function(data, menu)
          local itemName = data.current.value
          ESX.UI.Menu.Open(
            'dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count',
            {
              title = 'Tedad Ra Vared Konid'
            },
            function(data2, menu2)
              local count = tonumber(data2.value)
              if count == nil then
                ESX.ShowNotification("Meghdar Eshtebah Ast")
              else
                menu2.close()
                menu.close()
                TriggerServerEvent('PX_Cafe:putStockItems', itemName, count)
                Citizen.Wait(1000)
                OpenPutStocksMenu()
              end
            end,
            function(data2, menu2)
              menu2.close()
            end
          )
        end,
        function(data, menu)
          menu.close()
        end)
    end)
end

function OpenGetStocksMenu()
    local grade = xPlayer.job.grade
	local job = xPlayer.job.name
    ESX.TriggerServerCallback('PX_Cafe:getStockItems', function(items)
        ESX.TriggerServerCallback('esx_society:getItems', function(authorizedItems)
            local elements = {}
            for i=1, #items, 1 do
				for _, specialitem in ipairs(authorizedItems) do
					if specialitem.name == items[i].name and specialitem.status == true then
						table.insert(elements, {label = 'x' .. items[i].count .. ' ' .. items[i].label, value = items[i].name})
					end
				end
			end
            ESX.UI.Menu.Open(
                'default', GetCurrentResourceName(), 'stocks_menu',
                {
                title    = 'Cafe Stock',
                align    = 'top-left',
                elements = elements
                },
                function(data, menu)
                local itemName = data.current.value
                ESX.UI.Menu.Open(
                    'dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count',
                    {
                    title = "Tedad Ra Vared Konid"
                    },
                    function(data2, menu2)
                    local count = tonumber(data2.value)
                    if count == nil then
                        ESX.ShowNotification("Adad Vared Shode Eshtebahe")
                    else
                        menu2.close()
                        menu.close()
                        TriggerServerEvent('PX_Cafe:getStockItem', itemName, count)
                        Citizen.Wait(1000)
                        OpenGetStocksMenu()
                    end
                    end,
                    function(data2, menu2)
                    menu2.close()
                    end)
                end,
                function(data, menu)
                    menu.close()
                end)
        end, grade, job)
    end)
end

RegisterNetEvent('codem-nargile:client:deleteMarpuc')
AddEventHandler('codem-nargile:client:deleteMarpuc', function(masa)
    local masa = Config.Masalar[masa].coords
    if sessionStarted then
        local ply = PlayerPedId()
        local coords = GetEntityCoords(ply, true)
        if #(masa - coords ) < 3.0 then

            currentHookah = nil
            SetEntityAsMissionEntity(marpuc, true, true)
            DeleteEntity(marpuc)
            marpuc = nil
            ClearPedTasks(ply)
            ESX.ShowNotification("Bardashtan Ghelyan...") 
        end
    end
end)


RegisterNetEvent('codem-nargile:client:deleteNargile')
AddEventHandler('codem-nargile:client:deleteNargile', function(masa)

    local ply = PlayerPedId()
    local coords = GetEntityCoords(ply, true)

    for k,v in pairs(nargileObjects) do
        if v.table == masa then
             SetEntityAsMissionEntity(NetworkGetEntityFromNetworkId(v.obj), true, true)
             DeleteEntity(NetworkGetEntityFromNetworkId(v.obj))

             table.remove(nargileObjects, k)

             return;
        end
    end
  
end)

RegisterNetEvent('codem-nargile:client:getConfig')
AddEventHandler('codem-nargile:client:getConfig', function(newConfig)
    Config.Masalar = newConfig
end)

function putNargileToTable(masa)
    DeleteEntity(nargileSingleObject)
    nargileSingleObject = nil
    carryingNargile = false
    local obj =  CreateObject(4037417364, Config.Masalar[masa].coords, false, 0, false)
    NetworkRegisterEntityAsNetworked(obj)
    SetNetworkIdCanMigrate(NetworkGetNetworkIdFromEntity(obj), true)
    SetNetworkIdExistsOnAllMachines(NetworkGetNetworkIdFromEntity(obj), true)
    NetworkSetNetworkIdDynamic(NetworkGetNetworkIdFromEntity(obj), false)
	FreezeEntityPosition(obj, true)
    table.insert(nargileObjects, {obj = NetworkGetNetworkIdFromEntity(obj), table = masa, koz = 100})
    TriggerServerEvent('codem-nargile:server:syncHookahTable', nargileObjects)

    TriggerServerEvent('codem-nargile:server:setAlreadyHaveHookah',masa, true)


    ClearPedTasks(PlayerPedId())
end

function takeNargileFromTable(masa)
    for k,v in pairs(nargileObjects) do
        if v.table == masa then
            TriggerServerEvent('codem-nargile:server:deleteMarpuc', v.table)

            TriggerServerEvent('codem-nargile:server:deleteNargile', v.table)

            TriggerServerEvent('codem-nargile:server:setAlreadyHaveHookah',masa, false)
        end
    end
end

RegisterNetEvent('codem-nargile:client:setHookahs')
AddEventHandler('codem-nargile:client:setHookahs', function(nargileler)
    nargileObjects = nargileler
end)

RegisterNetEvent('codem-nargile:client:syncHookahTable')
AddEventHandler('codem-nargile:client:syncHookahTable', function()
end)



RegisterNetEvent('codem-nargile:client:syncKoz')
AddEventHandler('codem-nargile:client:syncKoz', function(obj, amount)
    for k,v in pairs(nargileObjects) do
        if v.obj == obj then
            v.koz = v.koz + amount
            if v.koz > 100 then
                v.koz = 100
            elseif v.koz <= 0 then
                v.koz = 0
            end
        end
    end
end)



function attachKoz()
	local hash = GetHashKey('v_corp_boxpaprfd')
	local ped = PlayerPedId()
    RequestModel(hash)

    while not HasModelLoaded(hash) do
        Citizen.Wait(100)
    end

	local obj = CreateObject(hash,  GetEntityCoords(PlayerPedId()),  true,  true, true)
    RequestNamedPtfxAsset("core")
    while not HasNamedPtfxAssetLoaded('core') do
        Citizen.Wait(0)
    end
    UseParticleFxAsset("core")

    StartNetworkedParticleFxLoopedOnEntity("ent_anim_cig_smoke",obj,0,0,0.1, 0,0,0, 3.0, 0,0,0)
    local anim = "amb@world_human_clipboard@male@base"
    RequestAnimDict(anim)
    while not HasAnimDictLoaded(anim) do
        Citizen.Wait(0)
    end
	local boneIndex = GetPedBoneIndex(ped, 0x67F2)
    koz.obj = obj;


    TaskPlayAnim(ped, anim, "base",2.0, 2.0, -1, 49, 0, false, false, false)


	AttachEntityToEntity(obj, ped,  boneIndex, 0.15,-0.10,0.0,  -130.0, 310.0, 0.0,  true, true, false, true, 1, true)
end


function kozle(v)
    local ped = PlayerPedId()

    RequestAnimDict("misscarsteal3pullover")
    while not HasAnimDictLoaded("misscarsteal3pullover") do
        Citizen.Wait(0)
    end
    TaskPlayAnim(ped, "misscarsteal3pullover", "pull_over_right", 2.0, 2.0, -1, 49, 0, false, false, false)
    Citizen.Wait(5500)
    local anim = "amb@world_human_clipboard@male@base"
    RequestAnimDict(anim)
    while not HasAnimDictLoaded(anim) do
        Citizen.Wait(0)
    end
    local boneIndex = GetPedBoneIndex(ped, 0x67F2)
    TaskPlayAnim(ped, anim, "base",2.0, 2.0, -1, 49, 0, false, false, false)
	AttachEntityToEntity(koz.obj, ped,  boneIndex, 0.15,-0.10,0.0,  -130.0, 310.0, 0.0,  true, true, false, true, 1, true)
    TriggerServerEvent('codem-nargile:server:syncKoz', v.obj, 50)

end


RegisterCommand('at', function()
    if xPlayer.job.name == "coffee" then
        attachKoz()
    else
        ESX.ShowNotification("Shoma ~y~Ghahve Chi ~r~Nistid!")
    end
end)

Citizen.CreateThread(function()
    while true do
        local sleep = true
        Citizen.Wait(0)
        for k,v in pairs(nargileObjects) do
            sleep = false
   
            local coords = GetEntityCoords(NetworkGetEntityFromNetworkId(v.obj), true)
            local ply = PlayerPedId()
            local coordsPly = GetEntityCoords(ply, true)
            if #(coords - coordsPly) < 3.0 then

                if IsControlJustPressed(0, 47) and v.koz < 100 and koz.obj and carryingKoz then
                    kozle(v)

                end
                if not sessionStarted then
                   DrawText3D(coords.x, coords.y,coords.z + 0.20, "K -  Keshidan | G - Avaz Kardan Zoghal | Zoghal : %".. v.koz)
                    if IsControlJustReleased(0, 311) then

                        currentHookah = v.obj
                        FreezeEntityPosition(PlayerPedId(),true)
                        nargileIc(v.table)
                
                    end  
                else
                    if IsControlJustPressed(0, 74) and v.koz >  0 then -- Normal: k
                        TriggerServerEvent("hookah_smokes", PedToNet(ply))                            
                        TriggerServerEvent('codem-nargile:server:syncKoz', v.obj,  -5)
                        TriggerEvent('InteractSound_CL:PlayOnOne', 'ghelyon', 0.3)
                        Citizen.Wait(5000)
                        TriggerServerEvent('weaponry:server:remove:stress', 5)
                    end

                    if v.koz > 0 then
                       DrawText3D(coords.x, coords.y,coords.z + 0.7, "H - Kam Gereftan |  G - Avaz Kardan Zoghal | F - NakeShidan | Zoghal : %".. v.koz)
                    else
                       DrawText3D(coords.x, coords.y,coords.z + 0.7, "F -  NakeShidan | Zoghal : %".. v.koz)
                    end
                end
            end
        end
        if sleep then
            Citizen.Wait(1000) 
        end
    end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if sessionStarted then
			local dist = #(GetEntityCoords(PlayerPedId(), true) - vector3(96.04, 198.79, 108.37))
			if dist > 15.0 or IsPedInAnyVehicle(PlayerPedId(), false) then
				sessionStarted = false
				SetEntityAsMissionEntity(marpuc, false, true)
				DeleteObject(marpuc)
				ClearPedTasks(PlayerPedId())
				ESX.ShowNotification("Shoma Nemitavanid Biron Az Cafe Az Ghelyan Estefade Konid!")
			end
		end
	end
end)

function anim()
	local ped = PlayerPedId()
	local ad = "anim@heists@humane_labs@finale@keycards"
	local anim = "ped_a_enter_loop"
	while (not HasAnimDictLoaded(ad)) do
		RequestAnimDict(ad)
	  Wait(1)
	end
	TaskPlayAnim(ped, ad, anim, 8.00, -8.00, -1, (2 + 16 + 32), 0.00, 0, 0, 0)

end

function nargileIc(masa)
   TriggerServerEvent('codem-nargile:server:setSessionStarted', masa, true)
    smoke()
    anim()
    local playerPed  = PlayerPedId()
	local coords     = GetEntityCoords(playerPed)
	local boneIndex  = GetPedBoneIndex(playerPed, 12844)
	local boneIndex2 = GetPedBoneIndex(playerPed, 24818)
	local model = GetHashKey('v_corp_lngestoolfd')
	RequestModel(model)
	while not HasModelLoaded(model) do
		Citizen.Wait(100)
	end								
	local obj = CreateObject(model,  coords.x+0.5, coords.y+0.1, coords.z+0.4, true, false, true)
	marpuc = obj
	AttachEntityToEntity(obj, playerPed, boneIndex2, -0.43, 0.68, 0.18, 0.0, 90.0, 90.0, true, true, false, true, 1, true)		
	ESX.ShowNotification("Shoro Be Kam Gereftan Kardid!")
    sessionStarted = true	
end

function smoke()
    Citizen.CreateThread(function()
        while true do
        local ped = PlayerPedId()
            Citizen.Wait(0)

            
            if IsControlJustReleased(0, 23) and sessionStarted then -- Normal: F
                sessionStarted = false
                SetEntityAsMissionEntity(marpuc, false, true)
                DeleteObject(marpuc)
                currentHookah = nil

                FreezeEntityPosition(PlayerPedId(),false)
                ClearPedTasks(PlayerPedId())
    
            end
        end
    end)
end


p_smoke_location = {
	20279,
}
p_smoke_particle = "exp_grd_bzgas_smoke"
p_smoke_particle_asset = "core" 
RegisterNetEvent("c_hookah_smokes")
AddEventHandler("c_hookah_smokes", function(c_ped)
	local p_smoke_location = {
		20279,
	}
	local p_smoke_particle = "exp_grd_bzgas_smoke"
	local p_smoke_particle_asset = "core" 


	for _,bones in pairs(p_smoke_location) do
		if DoesEntityExist(NetToPed(c_ped)) and not IsEntityDead(NetToPed(c_ped)) then
            TriggerServerEvent("BlackBand:useghelyon")
            Wait(5000)
            createdSmoke = UseParticleFxAssetNextCall(p_smoke_particle_asset)
            createdPart = StartParticleFxLoopedOnEntityBone(p_smoke_particle, NetToPed(c_ped), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, GetPedBoneIndex(NetToPed(c_ped), bones), 1.0, 0.0, 0.0, 0.0)
            Wait(2000)
            createdPart = StartParticleFxLoopedOnEntityBone(p_smoke_particle, NetToPed(c_ped), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, GetPedBoneIndex(NetToPed(c_ped), bones), 0.5, 0.0, 0.0, 0.0)
            Wait(2000)
            createdPart = StartParticleFxLoopedOnEntityBone(p_smoke_particle, NetToPed(c_ped), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, GetPedBoneIndex(NetToPed(c_ped), bones), 0.3, 0.0, 0.0, 0.0)
            --Wait(250)
            StopParticleFxLooped(createdSmoke, 1)
            -- Wait(1000*2)
            RemoveParticleFxFromEntity(NetToPed(c_ped))
            TriggerEvent("PX_Cafe:used")
            break
		end
	end
end)

DrawText3D = function(x, y, z, text)
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

-- Create blips
Citizen.CreateThread(function()
    local blip = AddBlipForCoord(99.5, 203.46, 108.37)
    SetBlipSprite(blip, 93)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 1.0)
    SetBlipColour(blip, 7)
    SetBlipAsShortRange(blip, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Cafe")
    EndTextCommandSetBlipName(blip)
end)

Citizen.CreateThread(function()
    local blip = AddBlipForCoord(-714.4, 261.03, 83.14)
    SetBlipSprite(blip, 350)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 1.0)
    SetBlipColour(blip, 3)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Real State")
    EndTextCommandSetBlipName(blip)
end)