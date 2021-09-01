ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer) -- 10655
    ESX.PlayerData = xPlayer
end)

RegisterNetEvent('laot-motels:PaymentAll')
AddEventHandler('laot-motels:PaymentAll', function()
    PaymentToAll()
end)

PaymentToAll = function()
    print("Payment to all..")
    MySQL.Async.fetchAll('SELECT * FROM laot_motels', {}, function(result)
        for k, v in pairs(result) do
            if v.owner then
                MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier', {
                    ["identifier"] = v.owner
                }, function(res)
                    if res[1] and res[1].bank then
                        if res[1].bank > 25 then
                            MySQL.Async.execute('UPDATE users SET bank = @bank WHERE identifier = @identifier', {
                                ['@identifier'] = v.owner,
                                ['@bank'] = res[1].bank - tonumber(v.rent),
                            })
                        else
                            MySQL.Async.execute('UPDATE laot_motels SET identifier = "" WHERE ID = @ID', {
                                ["ID"] = v.ID
                            })
                        end
                    end
                end)
            end
        end
    end)
end

MySQL.ready(function()
	LockAllMotels()
end)

LockAllMotels = function()
	MySQL.Async.execute('UPDATE laot_motels SET `doorOpen` = @false', {
        ["false"] = false,
    }, function(rowsChanged)
		if rowsChanged > 0 then
			print(('laot-motels: %s ev kilitlendi.'):format(rowsChanged))
		end
    end)
    
    MySQL.Async.execute('UPDATE laot_motels SET `stashOpen` = @false', {
        ["false"] = false,
    }, function(rowsChanged)
		if rowsChanged > 0 then
			print(('laot-motels: %s depo kilitlendi.'):format(rowsChanged))
		end
	end)
end

Citizen.CreateThread(function()
    TriggerEvent('disc-inventoryhud:RegisterInventory', {
        name = 'lmotel',
        label = "lmotel",
        slots = 150,
        weight = 150
    })
end)

ESX.RegisterServerCallback('laot-motels:CheckOwnership', function(source, cb, ID)
    local src = source

    MySQL.Async.fetchAll('SELECT * FROM laot_motels WHERE ID = @ID', {
        ["ID"] = ID
	}, function(result)
        if result[1] then
            cb(result[1])
        else
            print("".. ID.." isimli motelin datası çekilemedi.")
            cb(nil)
        end
    end)

end)

ESX.RegisterServerCallback('laot-motels:RentMotel', function(source, cb, ID)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(source)

    local count = xPlayer.getInventoryItem('cash').count

    MySQL.Async.fetchAll('SELECT * FROM laot_motels WHERE ID = @ID', {
        ["ID"] = ID
	}, function(result)
        if not result[1].owner then
            local rentPrice = tonumber(result[1].rent)
            if count >= rentPrice then

                xPlayer.removeInventoryItem('cash', rentPrice)

                MySQL.Async.execute('UPDATE laot_motels SET owner = @owner WHERE ID = @ID', {
                    ['@owner'] = xPlayer.identifier,
                    ['@ID'] = ID
                })

                cb(true)
            else
                cb(nil)
            end
        else
            cb(nil)
        end
    end)

end)

ESX.RegisterServerCallback('laot-motels:LeaveMotel', function(source, cb, ID)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(source)

    MySQL.Async.execute('DELETE FROM `laot_motels` WHERE ID = @ID', {
        ['@ID'] = ID,
    })

    Citizen.Wait(500)
    MySQL.Async.insert('INSERT INTO `laot_motels` (`ID`, `doorOpen`, `stashOpen`, `rent`) VALUES (@ID, @doorOpen, @stashOpen, @rent)', {
        ['@ID'] = ID,
        ['@doorOpen'] = false,
        ['@stashOpen'] = false,
        ['@rent'] = "250",
	}, function()
        cb(true)
	end)

end)

RegisterServerEvent("laot-motels:SetDoorState")
AddEventHandler("laot-motels:SetDoorState", function(ID, state)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(source)

    MySQL.Async.execute('UPDATE laot_motels SET doorOpen = @doorOpen WHERE ID = @ID and owner = @owner', {
        ['@owner'] = xPlayer.identifier,
        ['@ID'] = ID,
        ['@doorOpen'] = state
    })

end)

RegisterServerEvent("laot-motels:SetStashState")
AddEventHandler("laot-motels:SetStashState", function(ID, state)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(source)

    MySQL.Async.execute('UPDATE laot_motels SET stashOpen = @stashOpen WHERE ID = @ID and owner = @owner', {
        ['@owner'] = xPlayer.identifier,
        ['@ID'] = ID,
        ['@stashOpen'] = state
    })

end)

TriggerEvent('cron:runAt', 20, 0, PaymentToAll)