local res = GetCurrentResourceName()
Awake = function(...)
  if not Config.Receipt or Config.Receipt == "CHANGEME" then print('\27[31m['..res.."]\27[0m You need to set your receipt number in the config."); return
  elseif not res then print('\27[31m['..res.."]\27[0m Error getting resource name."); return
  else TriggerEvent(res..":Awake",Config.Receipt); return
  end
end 

Start = function(...)
  local ret = utils.perf(...)
  if not ret then print('\27[31m['..res.."]\27[0m Unauthorized usage.")
  else 
    print('\27[32m['..res.."]\27[0m Authorized.")
    if furni.__VERSION then
      if Config.__VERSION then
        if furni.__VERSION ~= Config.__VERSION then
          print('\27[32m['..res.."]\27[0m You aren't using the latest update. [\27[31m"..Config.__VERSION.."\27[0m / \27[32m"..motels.__VERSION.."\27[0m]")
        end
      else
        print('\27[32m['..res.."]\27[0m You aren't using the latest update. [\27[31mUNKNOWN\27[0m / \27[32m"..furni.__VERSION.."\27[0m]")
      end
    else
      print('\27[32m['..res.."]\27[0m You aren't using the latest update. [\27[31m"..Config.__VERSION.."\27[0m / \27[32mUNKNOWN\27[0m]")
    end
  end
end  

AddEventHandler(res..":Start", Start)
Citizen.CreateThread(Awake)


