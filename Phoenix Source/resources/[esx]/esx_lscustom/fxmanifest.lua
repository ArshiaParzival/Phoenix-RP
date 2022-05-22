fx_version 'bodacious'
game 'gta5'

description 'ESX LS Customs'

version '2.1.0'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@Proxtended/locale.lua',
	'locales/en.lua',
	'locales/fr.lua',
	'locales/pl.lua',
	'locales/br.lua',
	'config.lua',
	'server/main.lua'
}

client_scripts {
	'@Proxtended/locale.lua',
	'locales/en.lua',
	'locales/fr.lua',
	'locales/pl.lua',
	'locales/br.lua',
	'config.lua',
	'client/main.lua'
}