client_script 'dep.lua'


fx_version 'adamant'
games {'gta5'}

client_scripts
{
	'config/shared_config.lua',
	'config/client_config.lua',	
	'client.lua',
	-- 'cmenu.lua',
}

server_scripts 
{
	'config/shared_config.lua',
	'config/server_config.lua',	
	'server.lua',
}

ui_page 'html/index.html'
files { 'html/index.html', 'html/eav.min.js', 'html/script.js', 'html/*.ogg' }