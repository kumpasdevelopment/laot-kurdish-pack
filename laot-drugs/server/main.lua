ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
end)

RegisterServerEvent("laot-drugs:removeItem")
AddEventHandler("laot-drugs:removeItem", function(item, count, oyuncu)
    Wait(1)
    local xPlayer = ESX.GetPlayerFromId(oyuncu)
    local newCount = tonumber(count)
    if xPlayer.getInventoryItem(item).count >= newCount then
        xPlayer.removeInventoryItem(item, newCount)
        TriggerClientEvent("laot-drugs:controlX", oyuncu)
    end
end)

RegisterServerEvent("laot-drugs:removeItemX")
AddEventHandler("laot-drugs:removeItemX", function(item, count, Xdata, oyuncu)
    Wait(1)
    local xPlayer = ESX.GetPlayerFromId(oyuncu)
    local newCount = tonumber(count)
    local newData = tonumber(Xdata)
    if xPlayer.getInventoryItem(item).count >= newCount then
        xPlayer.removeInventoryItem(item, newCount)
        if newData == 1 then
            TriggerEvent("laot-drugs:addItem", 'laot_paketlenmistohum', Config.giveMath2.ito, oyuncu)
        elseif newData == 2 then
            TriggerEvent("laot-drugs:addItem", 'cash', Config.ped.price, oyuncu)
        end
    end
end)



RegisterServerEvent("laot-drugs:addItem")
AddEventHandler("laot-drugs:addItem", function(item, count, oyuncu)
    Wait(1)
    local xPlayer = ESX.GetPlayerFromId(oyuncu)
    local newCount = tonumber(count)
    xPlayer.addInventoryItem(item, newCount)
end)