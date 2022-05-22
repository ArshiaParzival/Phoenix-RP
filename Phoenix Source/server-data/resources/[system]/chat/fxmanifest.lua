
fx_version 'bodacious'
game 'gta5'

description 'chat management stuff'

ui_page 'html/index.html'

client_scripts {
  'cl_chat.lua',
  'modules/rpchat/client.lua'
}
server_scripts {
  'sv_chat.lua',
  'modules/rpchat/server.lua'
}

server_exports {
  'logToDiscord'
}

files {
    'html/index.html',
    'html/index.css',
    'html/config.default.js',
    'html/App.js',
    'html/Message.js',
    'html/Suggestions.js',
    'html/vendor/vue.2.3.3.min.js',
    'html/vendor/flexboxgrid.6.3.1.min.css',
    'html/vendor/animate.min.css',
    'html/vendor/fonts.css',
    'html/vendor/fonts/*.woff2',
    'html/vendor/fonts/*.ttf',
  }

  chat_theme 'gtao' {
    styleSheet = 'style.css',
    msgTemplates = {
        default = '<b>{0}</b><span>{1}</span>'
    }
}