resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

author "Phoenix Development Team"

server_scripts {
	"@mysql-async/lib/MySQL.lua",
	"config.lua",
	"server/server.lua",
	'comserv/server/main.lua'
}

client_scripts {
	"config.lua",
	"client/client.lua",
	'comserv/client/main.lua',
}