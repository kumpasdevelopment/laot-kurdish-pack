ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
end)

RegisterNetEvent('laot-illegaldoctor:RemoveItem')
AddEventHandler('laot-illegaldoctor:RemoveItem', function()
    local src  = source

    local xPlayer = ESX.GetPlayerFromId(src)
    if xPlayer.getInventoryItem('cash').count >= 70 then
        xPlayer.removeInventoryItem('cash', 70)
        TriggerClientEvent('esx_ambulancejob:revive', src)
    else
        TriggerClientEvent("laot-illegaldoctor:cashError", src)
    end
end)