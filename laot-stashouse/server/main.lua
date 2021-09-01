ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
end)

if C.discStashCreator then
    Citizen.CreateThread(function()
        TriggerEvent('disc-inventoryhud:RegisterInventory', {
            name = 'laot-sh',
            label = "Depo Evi",
            slots = 400,
            weight = 400
        })
    end)
end

RegisterNetEvent("laot-stashouse:GetStashouse")
AddEventHandler("laot-stashouse:GetStashouse", function(ID, ui)
    local src = source

    MySQL.Async.fetchAll('SELECT * FROM laot_stashouse WHERE houseID = @houseID', {
        ["houseID"] = ID
	}, function(result)
        if result[1] then
            if ui then
                TriggerClientEvent("laot-stashouse:ClientStashouse", src, result[1], true)
            else
                TriggerClientEvent("laot-stashouse:ClientStashouse", src, result[1], false)
            end
        else
            LAOT.DebugPrint("".. ID.." isimli stashouse datası çekilemedi.")
        end
	end)
end)

ESX.RegisterServerCallback('laot-stashouse:HEX', function(source, cb)
    local src = source
    local identifier = GetPlayerIdentifiers(src)[1]
    cb(identifier)
end)

ESX.RegisterServerCallback('laot-stashouse:GetStashouseCB', function(ID, cb)
    local src = source

    MySQL.Async.fetchAll('SELECT * FROM laot_stashouse WHERE houseID = @houseID', {
        ["houseID"] = ID
	}, function(result)
        if result[1] then
            cb(result[1])
        else
            LAOT.DebugPrint("".. ID.." isimli stashouse datası çekilemedi.")
            cb(nil)
        end
    end)

end)

RegisterNetEvent("laot-stashouse:Buy")
AddEventHandler("laot-stashouse:Buy", function(ID)
    local src = source

    local identifier = GetPlayerIdentifiers(src)[1]
    local v = C.stashouses[ID]

    local xPlayer = ESX.GetPlayerFromId(src)
    local count = xPlayer.getInventoryItem('cash').count

    if count >= tonumber(v["price"]) then

        xPlayer.removeInventoryItem('cash', tonumber(v["price"]))

        MySQL.Async.execute('UPDATE laot_stashouse SET owner = @owner WHERE houseID = @houseID', {
            ['@owner'] = identifier,
            ['@houseID'] = ID
        })

        TriggerClientEvent("laot-stashouse:Notification", src, "inform", "Bu depo evini satın aldınız!")
    
    else
        TriggerClientEvent("laot-stashouse:Notification", src, "error", "Yeteri kadar paranız yok!")
    end
end)

RegisterNetEvent("laot-stashouse:ChangePass")
AddEventHandler("laot-stashouse:ChangePass", function(ID, type, changedto)
    local src = source
    local v = C.stashouses[ID]

    if type == 'pass' then
        MySQL.Async.execute('UPDATE laot_stashouse SET pass = @pass WHERE houseID = @houseID', {
            ['@pass'] = changedto,
            ['@houseID'] = ID
        })
    elseif type == 'stashPass' then
        MySQL.Async.execute('UPDATE laot_stashouse SET stashPass = @pass WHERE houseID = @houseID', {
            ['@pass'] = changedto,
            ['@houseID'] = ID
        })
    end
    TriggerClientEvent("laot-stashouse:Notification", src, "inform", "Şifre değiştirildi!")
end)