local registeredKeys = {}

local keysHolding = {}

local KeysWhiteList = {["g"] = true, ["t"] = true}

local currentKeysHolding = {}



RegisterNetEvent("onKeyDown")

RegisterNetEvent("onKeyUP")

RegisterNetEvent("onMultiplePress")



function registerKey(key, type)

	local command = key .. "donttouch"



	if not registeredKeys[key] then

		registeredKeys[key] = true

		RegisterKeyMapping('+' .. command, "Edit Nakonid | Key : "..key.." | No Edit !", type, key)

	end

        

	RegisterCommand('+' .. command, function()

		if not IsPauseMenuActive() then

			if shouldSendTheKey(key) then

				TriggerEvent("onKeyDown", key)

			end

			

			table.insert(keysHolding, key)

			currentKeysHolding[key] = true



			if #keysHolding > 1 then

				TriggerEvent("onMultiplePress", currentKeysHolding)

			end



		end

	end)

	

	RegisterCommand('-' .. command, function()

		if not IsPauseMenuActive() then

			TriggerEvent("onKeyUP", key)

		end



		if currentKeysHolding[key] then

			removeKey(key)

			currentKeysHolding[key] = nil

		end

	end)

end



function removeKey(key)

	for index, currentKey in ipairs(keysHolding) do

		if currentKey == key then

			table.remove(keysHolding, index)

		end

	end

end



function shouldSendTheKey(key)

	if KeysWhiteList[key] then

		return true

	else
		return true

	end

end



local haveToRegister = {

	["e"] = "keyboard",

	["k"] = "keyboard",

	["numpad4"] = "keyboard",

	["numpad5"] = "keyboard",

	["numpad6"] = "keyboard",

	["numpad7"] = "keyboard",

	["numpad8"] = "keyboard",

	["numpad9"] = "keyboard",

	["u"] = "keyboard",

	["x"] = "keyboard",

	["l"] = "keyboard",

	["f"] = "keyboard",

	["r"] = "keyboard",

	["lmenu"] = "keyboard",

	["f1"] = "keyboard",

	["f2"] = "keyboard",

	["f3"] = "keyboard",
	
	["f4"] = "keyboard",

	["f5"] = "keyboard",

	["f6"] = "keyboard",

	["f7"] = "keyboard",

	["f10"] = "keyboard",

	["escape"] = "keyboard",

	["t"] = "keyboard",

	["y"] = "keyboard",

	["g"] = "keyboard",

	["9"] = "keyboard",

	["b"] = "keyboard",

	['oem_3'] = "keyboard",

	["lcontrol"] = "keyboard",

	["lshift"] = "keyboard",

	["return"] = "keyboard",

	["back"] = "keyboard",

	["up" ] = "keyboard",

	["right"] = "keyboard",

	["left" ] = "keyboard",

	["down"] = "keyboard",

	["mouse_left"] = "mouse_button",

	["mouse_right"] = "mouse_button",

	["delete"] = "keyboard",

	["z"] = "keyboard",

	["home"] = "keyboard",

	["end"] = "keyboard"

}



for key, type in pairs(haveToRegister) do

	registerKey(key, type)

end

exports("DisableControl", function(status)
	isControlsDisabled = status
end)