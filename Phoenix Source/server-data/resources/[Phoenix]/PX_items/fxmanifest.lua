fx_version 'bodacious'
game 'gta5'

server_scripts {
	"@mysql-async/lib/MySQL.lua",
	'server/*.lua',
	'config.lua',
}

client_scripts {
	'client/*.lua',
	'config.lua',
}

dependencies {
	'Proxtended'
}

exports {
	'GetAmmoType',
}

server_exports {
	'GetWeaponList',
}