local ultimaAccion = nil
local currentGarage = nil
local fetchedVehicles = {}
local fueravehicles = {}

function MenuGarage(action)
    if not action then action = ultimaAccion; elseif not action and not ultimaAccion then action = "menu"; end
    ped = PlayerPedId();
    MenuTitle = "Garage"
    ClearMenu()
    ultimaAccion = action
    Citizen.Wait(150)
    DeleteActualVeh()
    if action == "menu" then
        Menu.addButton("Vehcile List","ListeVehicule",nil)
        Menu.addButton("Impound","recuperar",nil)
        Menu.addButton("Close Menu","CloseMenu",nil) 
    elseif action == "vehicle" then
        PutInVehicle()
    end
end

function EnvioVehLocal(veh)
    local slots = {}
    for c,v in pairs(veh) do
        table.insert(slots,{["garage"] = v.garage, ["vehiculo"] = json.decode(v.vehicle)})
    end
    fetchedVehicles = slots
end

function EnvioVehFuera(data)
    local slots = {}
    for c,v in pairs(data) do
        if v.stored == 0 or v.stored == 2 or v.stored == false or v.garage == nil then
            table.insert(slots,{["vehiculo"] = json.decode(v.vehicle),["stored"] = v.stored})
        end
    end
    fueravehicles = slots
end

function recuperar()
    currentGarage = cachedData["currentGarage"]

    if not currentGarage then
        CloseMenu()
        return 
    end

   HandleCamera(currentGarage, true)
   ped = PlayerPedId();
   MenuTitle = "Recover :"
   ClearMenu()
   Menu.addButton("Vehicles are in impound","MenuGarage",nil)
    for c,v in pairs(fueravehicles) do
        local vehicle = v.vehiculo
        if v.stored == 0 or v.stored == false then
            Menu.addButton("KURTAR | "..GetDisplayNameFromVehicleModel(vehicle.model), "pagorecupero", vehicle, "CEKILMIS", " Motor : " .. round(vehicle.engineHealth) /10 .. "%", " Yakıt : " .. round(vehicle.fuelLevel) .. "%","SpawnLocalVehicle")
        end
    end 
end

function pagorecupero(data)
    esx.TriggerServerCallback('PX_garage:checkMoney', function(hasEnoughMoney)
        if hasEnoughMoney == true then
            SpawnVehicle({data,nil},true)
        elseif hasEnoughMoney == "deudas" then
            recuperar()
            -- TriggerEvent('notification', 'Devlete 2000 dolardan fazla borcunuz var, cezalarını ödeyene kadar aracınızı geri alamazsınız!', 2)
            esx.ShowNotification("You need to pay your bills", 'error')
        else
            recuperar()
            -- TriggerEvent('notification', 'Üzerinde hiç para yok', 2)	
            esx.ShowNotification("You need 200$ money", 'error')

        end
    end)
end


function AbrirMenuGuardar()
    currentGarage = cachedData["currentGarage"]
    if not currentGarage then
        CloseMenu()
        return 
    end
   ped = PlayerPedId();
   MenuTitle = "Save :"
   ClearMenu()
   Menu.addButton(" Vehicle Menu","CloseMenu",nil)
   Menu.addButton("Garage: "..currentGarage.." | Save", "SaveInGarage", currentGarage, "", "", "","DeleteActualVeh")
end

function ListeVehicule()
    currentGarage = cachedData["currentGarage"]

    if not currentGarage then
        CloseMenu()
        return 
    end

   HandleCamera(currentGarage, true)
   ped = PlayerPedId();
   MenuTitle = "My vehicles :"
   ClearMenu()
   Menu.addButton("Owned Vehicles","MenuGarage",nil)
    for c,v in pairs(fetchedVehicles) do
        if v then
            local vehicle = v.vehiculo
            Menu.addButton("" ..(vehicle.plate).." | "..GetDisplayNameFromVehicleModel(vehicle.model), "OptionVehicle", {vehicle,nil}, "Garage: "..currentGarage.."", " Durabilty : " .. round(vehicle.engineHealth) /10 .. "%", " Fuel : " .. round(vehicle.fuelLevel) .. "%","SpawnLocalVehicle")
        end
    end
end

function round(n)
    if not n then return 0; end
    return n % 1 >= 0.5 and math.ceil(n) or math.floor(n)
end

function OptionVehicle(data)
   MenuTitle = "Options :"
   ClearMenu()
   Menu.addButton("Take Vehicle Out", "SpawnVehicle", data)
   Menu.addButton("Return to Vehicle list", "ListeVehicule", nil)
end

function CloseMenu()
    if DoesEntityExist(cachedData["vehicle"]) then
        DeleteEntity(cachedData["vehicle"])
    end
    HandleCamera(currentGarage, false)
	TriggerEvent("inmenu",false)
    Menu.hidden = true
end

function LocalPed()
	return PlayerPedId()
end
