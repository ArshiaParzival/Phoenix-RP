fx_version 'adamant'
game 'gta5'

files {
	'handling.meta',
   }
data_file 'HANDLING_FILE' 'handling.meta'

server_scripts {
	'@async/async.lua',
	'@mysql-async/lib/MySQL.lua',
	'@Proxtended/locale.lua',
	'locales/en.lua',
	'config.lua',
	'server/*.lua'
}

client_scripts {
	'@Proxtended/locale.lua',
	'locales/en.lua',
	'config.lua',
	'client/*.lua'
}