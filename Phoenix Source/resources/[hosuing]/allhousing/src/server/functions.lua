function _print(...)
  if Config.Debug then
    print("    [Allhousing]",...)
  end
end

function _error(...)
  print("    [Allhousing]","[ERROR]",...)
end

-- Callbacks
_ServerCallbacks = {}
function RegisterCallback(event,cb)
  _ServerCallbacks[event] = cb
end

function _Callback(id,event,...)
  local _source = source
  while not _ServerCallbacks[event] do Wait(0); end
  local ret = _ServerCallbacks[event](_source,...)
  TriggerClientEvent("Allhousing:Calledback",_source,id,ret)
end  

RegisterNetEvent("Allhousing:Callback")
AddEventHandler("Allhousing:Callback",_Callback)