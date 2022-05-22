fx_version 'adamant'

game 'gta5'

description 'Rexshack Gaming : Casion Cashier'

version '1.1.1'



client_scripts {
	'client/client.lua',
	'config.lua'
}

server_scripts {
	"@mysql-async/lib/MySQL.lua",
	'server/server.lua',
	'config.lua'
}

ui_page('client/html/UI.html')

files {
    'client/html/UI.html',
    'client/html/style.css',
	'client/html/img/user.png',
	'client/html/img/phone.png',
	'client/html/img/clock.png',
	'client/html/img/receipt.png',
	'client/html/img/knife.png'
}