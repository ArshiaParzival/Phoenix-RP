fx_version "adamant"
game "gta5"

ui_page "index.html"

dependencies {
	"pma-voice",
}

files {
	"index.html",
	"call.png",
	"on.ogg",
	"off.ogg",
}

client_scripts {
	"config.lua",
	"client.lua",
}

server_scripts {
	"server.lua",
}

data_file 'INTERIOR_PROXY_ORDER_FILE' 'interiorproxies.meta'

files {
    "interiorproxies.meta"
}

--map bahamas