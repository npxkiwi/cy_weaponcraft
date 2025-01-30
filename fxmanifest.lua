fx_version 'cerulean'
lua54 'yes'
games {'gta5'}

ui_page "web/build/index.html"

shared_scripts {
    '@ox_lib/init.lua',
    'Config.lua',
}


client_script 'client/**/*'

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/**/*'
} 

files {
    "web/build/index.html",
    "web/build/**/*"
}