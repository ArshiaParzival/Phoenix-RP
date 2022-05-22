fx_version 'bodacious'
game 'gta5'

description 'ESX Menu Default'

version '1.0.4'

client_scripts {
	'@Proxtended/client/wrapper.lua',
	'client/main.lua'
}

ui_page {
	'html/ui.html'
}

files {
	'html/ui.html',
	'html/css/app.css',
	'html/js/mustache.min.js',
	'html/js/app.js',
	'html/fonts/AdventPro-Bold.ttf',
	'html/img/logo.png',
}

dependencies {
	'Proxtended'
}