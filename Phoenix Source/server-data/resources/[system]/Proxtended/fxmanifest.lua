fx_version 'bodacious'
game 'gta5'

author 'Phoenix Development Team'

server_scripts {
	'@async/async.lua',
	'@oxmysql/lib/MySQL.lua',

	'locale.lua',
	'locales/fr.lua',
	'locales/en.lua',

	'config.lua',

	'server/util.lua',
	'server/common.lua',
	'server/functions.lua',
	'server/paycheck.lua',
	'server/main.lua',
	'server/db.lua',
	'server/classes/player.lua',
	'server/classes/addonaccount.lua',
	'server/player/login.lua',
	'server/commands.lua',
	'server/license.lua',
	'server/account.lua',

	'shared/modules/math.lua',
	'shared/functions.lua',
	'shared/shared.lua'
}

client_scripts {
	'locale.lua',
	'locales/fr.lua',
	'locales/en.lua',

	'config.lua',

	'client/common.lua',
	'client/entityiter.lua',
	'client/functions.lua',
	'client/wrapper.lua',
	'client/main.lua',
	'client/paycheck.lua',

	'client/modules/death.lua',
	'client/modules/scaleform.lua',
	'client/modules/streaming.lua',

	'shared/modules/math.lua',
	'shared/functions.lua',
	'shared/shared.lua'
}

exports {
	'getUser'
}

server_exports {
	'log',
	'debugMsg',
	'GetPlayerICName',
}