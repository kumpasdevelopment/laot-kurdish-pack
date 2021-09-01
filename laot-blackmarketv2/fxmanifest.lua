fx_version "bodacious"

game "gta5"
author "laot"

client_scripts {
    "config.lua",
    "client/utils.lua",
    "client/main.lua"
}

server_scripts {
    "@mysql-async/lib/MySQL.lua",
    "config.lua",
    "server/main.lua"
}

dependencies {
    "bob74_ipl"
}