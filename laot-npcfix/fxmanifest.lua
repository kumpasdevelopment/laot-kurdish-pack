fx_version "bodacious"

game "gta5"
author "laot"

client_scripts {
    "@laot-extended/client/main.lua",
    "config.lua",
    "client/main.lua"
}

server_scripts {
    "@laot-extended/server/main.lua",
    "@async/async.lua",
    "@mysql-async/lib/MySQL.lua",
    "config.lua",
    "server/main.lua"
}