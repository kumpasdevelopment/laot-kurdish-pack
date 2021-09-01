ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
end)



ESX.RegisterServerCallback('laot-blackmarketv2:getPhoneNumber', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer == nil then
      cb(nil)
    end
    MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier',{
      ['@identifier'] = xPlayer.identifier
    }, function(result)
      cb(result[1].phone_number)
    end)
end)

RegisterServerEvent("laot-blackmarketv2:removeItem")
AddEventHandler("laot-blackmarketv2:removeItem", function(item, count, oyuncu)
    local xPlayer = ESX.GetPlayerFromId(oyuncu)
    local newCount = tonumber(count)
    if xPlayer.getInventoryItem(item).count >= newCount then
        xPlayer.removeInventoryItem(item, newCount)
        TriggerClientEvent("laot-blackmarketv2:success", oyuncu)
    else
        TriggerClientEvent("laot-blackmarketv2:failure", oyuncu, count)
    end
end)

RegisterServerEvent("laot-blackmarketv2:addItem")
AddEventHandler("laot-blackmarketv2:addItem", function(item, count, oyuncu)
    local xPlayer = ESX.GetPlayerFromId(oyuncu)
    local newCount = tonumber(count)
    xPlayer.addInventoryItem(item, newCount)
end)