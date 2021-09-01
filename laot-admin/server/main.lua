ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
end)

RegisterNetEvent('laot-admin:server:Kick')
AddEventHandler('laot-admin:server:Kick', function(kisi, sebep)
    DropPlayer(kisi, sebep)
end)

RegisterNetEvent('laot-admin:server:Kill')
AddEventHandler('laot-admin:server.Kill', function(player)
    TriggerClientEvent("laot-admin:Kill", player)
end)

RegisterNetEvent('laot-admin:server:BringPlayer')
AddEventHandler('laot-admin:server:BringPlayer', function(player, admin)
    if player and admin then
        TriggerClientEvent("laot-admin:client:BringPlayer", player, admin)
    end
end)

RegisterNetEvent('laot-admin:server:SkinMenu')
AddEventHandler('laot-admin:server:SkinMenu', function(player, type)
    if player and type then
        if type == "clothes" then TriggerClientEvent("esx_skin:openSaveableRestrictedMenu", player) end
        if type == "admin" then TriggerClientEvent("esx_skin:openSaveableMenu", player) end
    end
end)

RegisterNetEvent('laot-admin:server:DM')
AddEventHandler('laot-admin:server:DM', function(player, text)
    if player and text then
        print("DM")
        TriggerClientEvent("laot-admin:client:DM", player, text)
    end
end)

RegisterNetEvent('laot-admin:server:GiveItem')
AddEventHandler('laot-admin:server:GiveItem', function(player, item, amount)
    local src = player
    local xPlayer = ESX.GetPlayerFromId(src)

    if xPlayer.canCarryItem(item, amount) then
        xPlayer.addInventoryItem(item, amount)
    end
end)

RegisterNetEvent('laot-admin:server:PermaBan')
AddEventHandler('laot-admin:server:PermaBan', function(player, reason)
    local identifier, discord = "N/A", "N/A"

    if reason == nil then
        reason = "Sunucudan kalıcı olarak uzaklaştırıldın."
    end

    for k,v in ipairs(GetPlayerIdentifiers(player))do
        if string.sub(v, 1, string.len("steam:")) == "steam:" then
            identifier = v
        elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
            discord = v
        end
    end

    MySQL.Async.execute('INSERT INTO laot_bans (hex, discord, reason, expiration) VALUES (@hex, @discord, @reason, @date)', { 
        ['@hex'] = identifier,
        ['@discord'] = discord,
        ['@reason'] = reason,
        ['@date'] = 09013030,
        },  
        function ()
    end)

    if C.BanWebhook then
        TriggerEvent("laot:discordlog", C.BanWebhookURL, source, "".. identifier .." adlı kişiyi sonsuza kadar banladı!", true)
    end
end)