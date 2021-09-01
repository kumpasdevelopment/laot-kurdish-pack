ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
end)

RegisterServerEvent("laot-stash:CheckDiscordIdentifier")
AddEventHandler("laot-stash:CheckDiscordIdentifier", function(source)
    local src = source
    local discordIdentifier

    for k, v in ipairs(GetPlayerIdentifiers(src)) do
        if string.sub(v, 1, string.len("discord:")) == "discord:" then
            discordIdentifier = tonumber(split(v, ":")[2])
            print(discordIdentifier)
            TriggerClientEvent("laot-stash:GetDiscordIdentifier", src, discordIdentifier)
        end
    end
end)

if LAOT.discStashAuto then
    Citizen.CreateThread(function()
        TriggerEvent('disc-inventoryhud:RegisterInventory', {
            name = 'pdStash',
            label = "pdKisisel",
            slots = 100,
            weight = 100
        })
    end)


    Citizen.CreateThread(function()
        TriggerEvent('disc-inventoryhud:RegisterInventory', {
            name = 'laot',
            label = "ldepo",
            slots = 300,
            weight = 750
        })
    end)
end

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