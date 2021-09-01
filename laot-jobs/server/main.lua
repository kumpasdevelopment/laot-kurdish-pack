ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
end)

RegisterNetEvent('laot-jobs:AddItem')
AddEventHandler('laot-jobs:AddItem', function(item, count)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if xPlayer.canCarryItem(item, count) then
        xPlayer.addInventoryItem(item, count)
    else
        TriggerClientEvent("laot-jobs:Notification", src, "error", "Bu kadar ağırlığı kaldıramıyorsun!")
    end
end)