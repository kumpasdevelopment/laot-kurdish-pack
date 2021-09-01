ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('laot-taser:GetCapsule')
AddEventHandler('laot-taser:GetCapsule', function()
    local src = source

    local xPlayer = ESX.GetPlayerFromId(src)
    local count = xPlayer.getInventoryItem("tazerkart").count

    if count > 0 then
        TriggerClientEvent("laot-taser:ClientCapsule", src, 1)
    end
end)

RegisterNetEvent('laot-taser:Remove')
AddEventHandler('laot-taser:Remove', function()
    local src = source

    local xPlayer = ESX.GetPlayerFromId(src)
    local count = xPlayer.getInventoryItem("tazerkart")

    xPlayer.removeInventoryItem('tazerkart', 1)
end)