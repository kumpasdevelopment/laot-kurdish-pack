ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
end)

RegisterServerEvent("laot-recipe:addItem")
AddEventHandler("laot-recipe:addItem", function(item, count, oyuncu)
    local xPlayer = ESX.GetPlayerFromId(oyuncu)
    local newCount = tonumber(count)
    xPlayer.addInventoryItem(item, newCount)
end)