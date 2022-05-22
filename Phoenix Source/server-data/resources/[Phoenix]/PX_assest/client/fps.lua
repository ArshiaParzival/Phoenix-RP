ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)
 
RegisterCommand('fps', function()
    OpenFPSMenu()
end)


function OpenFPSMenu() 

    local elements = {
		  {label = 'Halat Fps Boost',		value = 'fps'},	               
		  {label = 'Halat Default',		value = 'fps2'},									          
    }
  
    ESX.UI.Menu.CloseAll()
  
    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'headbagging',
      {
        title    = 'Boost FPS Menu',
        align    = 'top-left',
        elements = elements
        },
            function(data2, menu2)
                if data2.current.value == 'fps' then
                    SetTimecycleModifier('yell_tunnel_nodirect')
                elseif data2.current.value == 'fps2' then
                    SetTimecycleModifier()
                    ClearTimecycleModifier()
                    ClearExtraTimecycleModifier()
                end
            end,
      function(data2, menu2)
        menu2.close()
      end
    )
end