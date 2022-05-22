ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

if TaxiConfig.MaxInService ~= -1 then
	TriggerEvent('esx_service:activateService', 'taxi', TaxiConfig.MaxInService)
end

TriggerEvent('esx_society:registerSociety', 'taxi', 'Taxi', 'society_taxi', 'society_taxi', 'society_taxi', {type = 'public'})