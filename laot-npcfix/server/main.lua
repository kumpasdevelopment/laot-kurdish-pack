ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
end)

ESX.RegisterServerCallback('laot-npcfix:PlateCar', function(plate, cb)

    local result = MySQL.Sync.fetchAll("SELECT plate FROM owned_vehicles", {
        ['@identifier'] = plate
    })

    if result[1] then
        for k, v in pairs(result[1].plate) do
            if plate == v then
                cb(true)
            else
                cb(false)
            end
        end
    end
end)