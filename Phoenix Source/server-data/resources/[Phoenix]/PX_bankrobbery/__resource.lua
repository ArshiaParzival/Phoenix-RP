resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'language.lua',
	'config.lua',
	'server/server.lua',
	'server/protection_sv.lua',
}

client_scripts {
	'language.lua',
	'config.lua',
	'client/client.lua',
	'client/utils.lua',
	'client/protection_cl.lua'
}

