Open = function(header,style,cb)
  SetNuiFocus(true,true)
  SendNUIMessage({
    type = "open",
    header = (header or "Input"),
    style  = style
  })

  if cb then
    postData = false
    while not postData do Wait(0); end
    cb(postData.message)
  end
end

Posted = function(data)
  SetNuiFocus(false,false)
  postData = data
end

RegisterNUICallback('post', Posted)

AddEventHandler('Input:Open',Open)
exports("Open",Open)

Citizen.CreateThread(function() 
  SetNuiFocus(true,true)
  SetNuiFocus(false,false)
end)