
fx_version 'cerulean'
games { 'gta5' }

server_script 'server.lua'

client_scripts {
	'config.lua',
	'client.lua'
}

ui_page('html/index.html')

files({
	'html/index.html',
	'html/listener.js',
	'html/style.css'
})