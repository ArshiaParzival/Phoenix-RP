fx_version 'bodacious'
game 'gta5'

description 'ESX Gang'
author 'Phoenix Development Team'
version '2.0.0'

server_scripts {
  '@mysql-async/lib/MySQL.lua',
  '@Proxtended/locale.lua',
  'locales/en.lua',
  '@mysql-async/lib/MySQL.lua',
  'config.lua',
  'server/main.lua',
	'handler/server/main.lua',
  'account/classes/addonaccount.lua',
	'account/main.lua',
  'tracker/server.lua'
}

client_scripts {
  '@Proxtended/locale.lua',
  'locales/en.lua',
  'config.lua',
  'client/main.lua',
  'handler/client/main.lua',
  'tracker/client.lua'
}