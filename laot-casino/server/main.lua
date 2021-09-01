ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- made by laot#0101

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
end)

RegisterNetEvent('laot-casino:buyChip')
AddEventHandler('laot-casino:buyChip', function(oyuncu, amount)
    local xPlayer = ESX.GetPlayerFromId(oyuncu)

    if xPlayer.getInventoryItem('cash').count >= amount then
        xPlayer.removeInventoryItem('cash', amount * CASINO["price"])
        xPlayer.addInventoryItem('cchip', amount)
    else
        TriggerClientEvent("laot-casino:notify", oyuncu, "Yeterli paranız yok!")
    end
end)

RegisterNetEvent('laot-casino:sellChip')
AddEventHandler('laot-casino:sellChip', function(oyuncu, amount)
    local xPlayer = ESX.GetPlayerFromId(oyuncu)

    if xPlayer.getInventoryItem('cchip').count >= amount then
        xPlayer.removeInventoryItem('cchip', amount)
        xPlayer.addInventoryItem('cash', amount * CASINO["price"])
    else
        TriggerClientEvent("laot-casino:notify", oyuncu, "Yeterli çipiniz yok!")
    end
end)