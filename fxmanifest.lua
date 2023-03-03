fx_version 'cerulean'
game 'gta5'
author 'Monster Dev Team'
description 'MST-MISSION | Script Free | Date and time quest system | https://discord.gg/monsterscript'
version '1.0.0'



client_script {
    'config.lua',
    'client/main.lua',
    'client/menu.lua',
    'client/npc.lua',
}


server_script {
    'config.lua',
    'server/main.lua'
}


lua54 'yes'

client_script "@status/acloader.lua"server_scripts { '@mysql-async/lib/MySQL.lua' }
 