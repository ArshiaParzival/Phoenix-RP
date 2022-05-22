ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('PX_scoreboard:getInfo', function(source, cb)
	local data = {}
	local total = #GetPlayers()
	local xPlayers = ESX.GetPlayers()
	local adminha = 0
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if tonumber(xPlayer.permission_level) >= 1 then
			adminha = adminha + 1
		end
	end
	data.admins = adminha
	data.players = total
	cb(data)
end)