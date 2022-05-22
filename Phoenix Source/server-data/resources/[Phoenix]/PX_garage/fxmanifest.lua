fx_version 'bodacious'
game 'gta5'

client_scripts {
	"config.lua",
	"client/garageMenu.lua",
	"client/gui.lua",
	"client/functions.lua",
	"client/main.lua"
}

server_scripts {
	"@mysql-async/lib/MySQL.lua",
	"config.lua",
	"server/main.lua",
}