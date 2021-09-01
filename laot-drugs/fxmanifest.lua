fx_version "bodacious"

game "gta5"

ui_page "ui/index.html"
files {
    "ui/vue.min.js",
    "ui/style.css",
    "ui/index.html",
    "ui/script.js"
}

client_scripts {
    "locales/tr.lua",
    "config.lua",
    "client/main.lua",
    --"client/ped.lua"
}

server_scripts {
    "locales/tr.lua",
    "config.lua",
    "server/main.lua"
}

dependencies {
    "es_extended",
    "bob74_ipl"
}