ESX = nil
Citizen.CreateThread(function ()
	while ESX == nil do
	  TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
	  Citizen.Wait(0)
	end
end)

RegisterNetEvent('sendProximityMessage')
AddEventHandler('sendProximityMessage', function(id, name, message)
  if not ESX then return end
  if ESX.Game.DoesPlayerExistInArea(id) then
    local pid = GetPlayerFromServerId(id)
    if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), GetEntityCoords(GetPlayerPed(pid)), true) < 39.999 then
      TriggerEvent('chat:addMessage', {
        template = '<div class="chat-message advert"><b>{0}</b> {1}</div>',
        args = { "OOC - " .. name, message }
      })
    end
  end
end)