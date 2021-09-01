ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
end)

ESX.RegisterUsableItem('hackertablet', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

    TriggerClientEvent("laot-core:HackerUse", source)
end)

RegisterNetEvent('laot:discordlog')
AddEventHandler('laot:discordlog', function(webhook, title, text, titleIsPlayerName)
    if titleIsPlayerName then
        for k, v in ipairs(GetPlayerIdentifiers(title)) do
            if string.sub(v, 1, string.len("discord:")) == "discord:" then
                discordIdentifier = tonumber(split(v, ":")[2])
                title = "".. GetPlayerName(title) .." - <@".. discordIdentifier ..">"
            end
        end
    end
    date = os.date('%m-%d-%Y %H:%M:%S', os.time())
    local connect = {
            {
                ["color"] = color,
                ["title"] = title,
                ["description"] = text,
                ["footer"] = {
                    ["text"] = "".. date .."",
                },
            }
        }
    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "", embeds = connect}), { ['Content-Type'] = 'application/json' })
end)

RegisterServerEvent("kickForAfk")
AddEventHandler("kickForAfk", function()
	DropPlayer(source, "Çok fazla süre AFK kaldın.")
end)

RegisterNetEvent('laot-core:HackAddBank')
AddEventHandler('laot-core:HackAddBank', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local random = math.random(250, 350)

    xPlayer.addBank(random)
end)

ESX.RegisterServerCallback("laot-core:GetGroup", function(source, cb)
    local _source = source
    local player = ESX.GetPlayerFromId(_source)
    MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @owner', {
        ['@owner'] = player.identifier
    }, function(results)
        if #results == 0 then
            cb(nil)
        else
            cb(results[1].group)
        end
    end)
end)

ESX.RegisterServerCallback('laot-core:GetSkin', function(source, cb)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    MySQL.Async.fetchAll('SELECT skin FROM users WHERE identifier = @identifier', {
        ['@identifier'] = xPlayer.identifier
    }, function(users)
        if users[1] ~= nil then
            local user, skin = users[1]

            if user.skin then
                skin = json.decode(user.skin)
            end

            cb(skin)
        else
            cb(nil)
        end
    end)
end)

ESX.RegisterServerCallback('laot-core:isDead', function(source, cb, target)
    local player = ESX.GetPlayerFromId(target)
    MySQL.Async.fetchAll('SELECT is_dead FROM users WHERE identifier = @identifier', {
        ['@identifier'] = player.identifier
    }, function(result)
        local isDead = result[1].is_dead
        cb(isDead)
    end)
end)

if LAOT.adminMenu then
    local discordIdentifier

    RegisterCommand("lAdmin", function(source)
        local src = source

        for k, v in ipairs(GetPlayerIdentifiers(src)) do
            if string.sub(v, 1, string.len("discord:")) == "discord:" then
                discordIdentifier = tonumber(split(v, ":")[2])
                for k,v in pairs(LAOT.admins) do
                    if discordIdentifier == v.id then
                        TriggerClientEvent("laot-core:openAdminMenu", src, v.grade)
                    end
                end
            end
        end
    end)

    RegisterNetEvent('laot-core:PlayerJoin')
    AddEventHandler('laot-core:PlayerJoin', function()
        local source = source
        local xPlayers = ESX.GetPlayers()
        for i=1, #xPlayers, 1 do

            local src = xPlayers[i]

            for k, v in ipairs(GetPlayerIdentifiers(src)) do
                if string.sub(v, 1, string.len("discord:")) == "discord:" then
                    discordIdentifier = tonumber(split(v, ":")[2])
                    for k,v in pairs(LAOT.admins) do
                        if discordIdentifier == v.id and v.grade == 2 then
                            TriggerClientEvent("laot-core:PlayerJoinClient", src, GetPlayerName(source))
                        end
                    end
                end
            end 

        end
    end)

    RegisterNetEvent('laot-core:dropPlayer')
    AddEventHandler('laot-core:dropPlayer', function(target)
        DropPlayer(target, "Kicklendiniz!")
    end)

    RegisterNetEvent('laot-core:openAdminMenuServer')
    AddEventHandler('laot-core:openAdminMenuServer', function(source)
        local src = source

        for k, v in ipairs(GetPlayerIdentifiers(src)) do
            if string.sub(v, 1, string.len("discord:")) == "discord:" then
                discordIdentifier = tonumber(split(v, ":")[2])
                for k,v in pairs(LAOT.admins) do
                    if discordIdentifier == v.id then
                        TriggerClientEvent("laot-core:openAdminMenu", src, v.grade)
                    end
                end
            end
        end
    end)

    RegisterNetEvent('laot-core:freezeServer')
    AddEventHandler('laot-core:freezeServer', function(target)
        TriggerClientEvent("laot-core:freezeToggle", target)
    end)

end


ESX.RegisterServerCallback('XGetCharacterNameLaot', function(source, cb)
    local ssource = ESX.GetPlayerFromId(source)

    local result = MySQL.Sync.fetchAll("SELECT firstname, lastname FROM users WHERE identifier = @identifier", {
        ['@identifier'] = ssource.identifier
    })

    local firstname = result[1].firstname
    local lastname  = result[1].lastname

    cb(''.. firstname .. ' ' .. lastname ..'')
end)

function split(str, pat)
    local t = {}
    local fpat = "(.-)" .. pat
    local last_end = 1
    local s, e, cap = str:find(fpat, 1)
    while s do
       if s ~= 1 or cap ~= "" then
          table.insert(t,cap)
       end
       last_end = e+1
       s, e, cap = str:find(fpat, last_end)
    end
    if last_end <= #str then
       cap = str:sub(last_end)
       table.insert(t, cap)
    end
    return t
 end
