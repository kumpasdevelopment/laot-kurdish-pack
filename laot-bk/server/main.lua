ESX = nil
local allCodes = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
end)

Citizen.CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/pbk', 'Kod durumunu giriniz.')
end)

TriggerEvent('es:addCommand', 'pbk', function(source, args, user)
    local xPlayer = ESX.GetPlayerFromId(source)
    if tonumber(args[1]) then 
        if xPlayer.job.name == 'police' then
            --print("İlk aşama")
            if xPlayer.getInventoryItem('radio').count >= 1 then -- telsiz kontrolü
                local code = tonumber(args[1])
                if code > -1 and code < 4 then
                    TriggerClientEvent("laot-bk:kod", source, code)
                else
                    TriggerClientEvent("laot-bk:notify", source, "Geçerli bir kod durumu girin;<br><b>1, 2, 3 ve 0</b>", "info")
                end
            else
                TriggerClientEvent("laot-bk:notify", source, "Üzerinizde telsiz yok!", "error")
            end
        else
            TriggerClientEvent("laot-bk:notify", source, "Bir polis değilsiniz.", "error")
        end
    else
        TriggerClientEvent("laot-bk:notify", source, "Geçerli bir kod durumu girin;<br><b>1, 2, 3 ve 0</b>", "info")
    end
end, {help = "Test yazısı 1", params = {{name = "kod", "Test yazısı 2"}}})