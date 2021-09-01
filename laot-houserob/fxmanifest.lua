fx_version "bodacious"

game "gta5"
author "laot"

client_scripts {
    "config.lua",
    "client/items.lua",
    "client/main.lua"
}

server_scripts {
    "config.lua",
    "@async/async.lua",
    "@mysql-async/lib/MySQL.lua",
    "server/main.lua"
}