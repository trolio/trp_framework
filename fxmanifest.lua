fx_version 'adamant'
games { 'gta5' }

client_scripts {
    'client/main.lua'
}

server_scripts {
    'server/sqlite/SQLite.net.dll',
    'server/sqlite/sqlite.js',
    'config.lua',
    'server/util.lua',
    'server/main.lua',
    'server/db.lua',
    'server/classes/player.lua',
    'server/classes/groups.lua',
    'server/player/login.lua',
    'server/metrics.lua'
}

exports {
    'getUser'
}

server_exports {
    'getPlayerFromId',
    'addAdminCommand',
    'addCommand',
    'addGroupCommand',
    'addACECommand',
    'canGroupTarget',
    'log',
    'debugMsg',
}