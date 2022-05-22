resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

author 'Phoenix Development Team'
description 'Phoenix Inventory'

ui_page {'html/ui.html'}

server_scripts {
'@mysql-async/lib/MySQL.lua',
 "config.lua",
 "server/main.lua",
}

client_scripts {
 "config.lua",
 "client/main.lua",
}

server_exports {
 'AddToStash',
}

files {
 'html/ui.html',
 'html/css/main.css',
 'html/js/app.js',
 'html/images/*.png',
 'html/images/*.jpg',
 'html/ammo_images/*.png',
 'html/attachment_images/*.png',
 'html/*.ttf',
}