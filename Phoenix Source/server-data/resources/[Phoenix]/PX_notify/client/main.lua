local colors = {
    "~w~",
    "~r~",
    "~g~",
    "~u~",
    "~b~",
    "~p~",
    "~y~",
    "~p~",
    "~c~",
    "~m~",
    "~o~",
    "~s~",
    "~h~"
}

function DoHudText(type, text)
	for i,v in ipairs(colors) do
        if string.find(text, v) then
            text = string.gsub(text, v, "")
        end
    end
	SendNUIMessage({
		type = type,
		text = text
	})
end