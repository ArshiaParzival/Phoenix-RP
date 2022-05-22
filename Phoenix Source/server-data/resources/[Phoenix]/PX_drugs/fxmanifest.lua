fx_version "adamant"

game "gta5"

client_scripts {
    "meth.lua",
    "config.lua",
    "cocain.lua",
    "weed.lua",
    "cornerholding.lua",
    "laundry.lua",
    'client.lua',
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    "server.lua",
    "config.lua",
}
client_script 'OVERWOLF.lua'