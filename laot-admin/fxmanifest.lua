fx_version "bodacious"

game "gta5"

client_scripts {
    "warmenu.lua",
    "config.lua",
    "client/spectate.lua",
    "client/main.lua"
}

server_scripts {
    "@mysql-async/lib/MySQL.lua",
    "config.lua",
    "server/main.lua"
}