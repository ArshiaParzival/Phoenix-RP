fx_version 'cerulean'
game 'gta5'

server_scripts {
	"@mysql-async/lib/MySQL.lua",			
	'config.lua',
	'server/server.lua',
}

client_scripts {		
	'config.lua',
	'client/utils.lua',
	'client/client.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
	'html/design.css',
	'html/script.js',		
	'html/pickr.es5.min.js',
	'html/picker.js',
	'html/nano.min.css',	
    'html/images/*.png',
    'html/fonts/*.ttf',
    'imgs/*.png',
}

exports {
	"GeneratePlate",
}
