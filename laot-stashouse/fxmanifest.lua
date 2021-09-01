fx_version "bodacious"

game "gta5"
author "laot"

ui_page "ui/index.html"
files {
    "ui/index.html",
    "ui/vue.min.js",
    "ui/script.js",
    "ui/main.css"
}  

client_scripts {
    "config.lua",
    "client/house.lua",
    "client/main.lua"
}

server_scripts {
    "@async/async.lua",
    "@mysql-async/lib/MySQL.lua",
    "config.lua",
    "server/main.lua"
}