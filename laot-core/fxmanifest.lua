fx_version "bodacious"

game "gta5"
author "laot"

files {
    'weapons.meta',
}

--data_file 'WEAPONINFO_FILE_PATCH' 'weapons.meta'

client_scripts {
    "config.lua",
    "utils.lua",
    "client/spectate.lua",
    "client/sigara.lua",
    "client/hacker.lua",
    "client/main.lua",
}

server_scripts {
    "@mysql-async/lib/MySQL.lua",
    "config.lua",
    "utils.lua",
    "server/itemuse.lua",
    "server/main.lua"
}