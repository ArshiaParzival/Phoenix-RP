fx_version 'bodacious'
game 'gta5'

ui_page "html/index.html"

client_scripts {
    "client/main.lua",
    "client/trunk.lua",
    "client/brancard.lua",
	"config.lua",
}

files {
    'html/index.html',
    'html/css/main.css',
    'html/css/RadialMenu.css',
    'html/js/main.js',
    'html/js/RadialMenu.js',
}

export 'SetClipboard'