resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'ESX Vangelico Robbery'

version '2.0.0'

client_scripts {
	'@Proxtended/locale.lua',
	'locales/de.lua',
	'locales/br.lua',
	'locales/en.lua',
	'locales/fr.lua',
	'config.lua',
	'client/esx_vangelico_robbery_cl.lua'
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
	'@Proxtended/locale.lua',
	'locales/de.lua',
	'locales/br.lua',
	'locales/en.lua',
	'locales/fr.lua',
	'config.lua',
	'server/esx_vangelico_robbery_sv.lua'
}

dependencies {
	'Proxtended'
}
