fx_version "bodacious"

game "gta5"
author "laot"

client_scripts {
    "config.lua",
    "client/main.lua"
}

server_scripts {
    "@async/async.lua",
    "@mysql-async/lib/MySQL.lua",
    "config.lua",
    "server/main.lua"
}