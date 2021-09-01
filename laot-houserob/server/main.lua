ESX = nil

policecount = 0

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
end)

ESX.RegisterServerCallback('laot-houserob:GetPolice', function(source, cb)
	policecount = 0
	local xPlayers = ESX.GetPlayers()
	for i = 1, #xPlayers do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'police' then
			policecount = policecount + 1
		end		
	end	
    cb(policecount)
end)

ESX.RegisterServerCallback('laot-houserob:GetItemAmount', function(source, cb, item)
    local xPlayer = ESX.GetPlayerFromId(source)
    local quantity = xPlayer.getInventoryItem(item).count
    
    cb(quantity)
end)

RegisterServerEvent('laot-houserob:server:robState')
AddEventHandler('laot-houserob:server:robState', function(source)
    local ssource = ESX.GetPlayerFromId(source)
    MySQL.Async.fetchAll('UPDATE users SET laot_houserob = @state WHERE identifier = @laot', {
        ['@laot'] = ssource.identifier,
        ['@state'] = 0
    }, function(result)
        Citizen.Wait(C.RobMS)
        local result2 = MySQL.Async.fetchAll('UPDATE users SET laot_houserob = @state WHERE identifier = @laot', {
            ['@laot'] = ssource.identifier,
            ['@state'] = 1
        }, function(result2)
            Citizen.Wait(0)         
        end)
    end)
end)

RegisterServerEvent('laot-houserob:server:Reward')
AddEventHandler('laot-houserob:server:Reward', function(item, amount)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if xPlayer.canCarryItem(item, amount) then
        xPlayer.addInventoryItem(item, amount)
    end
end)

RegisterServerEvent('laot-houserob:server:RemoveItem')
AddEventHandler('laot-houserob:server:RemoveItem', function(item, amount)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if xPlayer.getInventoryItem(item).count > tonumber(amount) then
        xPlayer.removeInventoryItem(item, amount)
    end
end)

ESX.RegisterServerCallback('laot-houserob:CanRob', function(source, cb)
    local ssource = ESX.GetPlayerFromId(source)
    MySQL.Async.fetchAll('SELECT laot_houserob FROM users WHERE identifier = @laot', {
        ['@laot'] = ssource.identifier,
    }, function(result)
        if result[1].laot_houserob then
            if tonumber(result[1].laot_houserob) == 1 then
                print("LAOT: Sending true.")
                cb(true)
            else
                print("LAOT: Sending false.")
                cb(false)
            end
        else
            print("laot-houserob: MySQL error.")
        end
    end)
end)