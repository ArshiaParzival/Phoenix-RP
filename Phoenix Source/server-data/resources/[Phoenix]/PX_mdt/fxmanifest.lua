fx_version 'cerulean'
game 'gta5'

lua54 'yes'

server_script {
    '@async/async.lua',
	'@mysql-async/lib/MySQL.lua',
    'sv_main.lua'
}

client_script 'cl_main.lua'

shared_script 'config.lua'

ui_page 'ui/dashboard.html'

files {
    'ui/img/*.png',
    'ui/img/*.jpg',
    'ui/dashboard.html',
    'ui/dmv.html',
    'ui/bolos.html',
    'ui/incidents.html',
    'ui/penalcode.html',
    'ui/reports.html',
    'ui/warrants.html',
    'ui/app.js',
    'ui/style.css',
}