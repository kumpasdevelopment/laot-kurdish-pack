ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
end)

RegisterNetEvent("laot-jail:ServerJail")
AddEventHandler("laot-jail:ServerJail", function(player, amount)
    local src = player

    local identifier = GetPlayerIdentifiers(src)[1]

    MySQL.Async.fetchAll('SELECT * FROM jail WHERE identifier = @identifier', {
		['@identifier'] = identifier
	}, function(result)
		if result[1] then
			MySQL.Async.execute('UPDATE jail SET jail_time = @jail_time WHERE identifier = @identifier', {
				['@identifier'] = identifier,
				['@jail_time'] = amount
			})
		else
			MySQL.Async.execute('INSERT INTO jail (identifier, jail_time) VALUES (@identifier, @jail_time)', {
				['@identifier'] = identifier,
				['@jail_time'] = amount
            })
            TriggerClientEvent("laot-jail:ClientJail", src, amount)
		end
	end)
end)


RegisterNetEvent("laot-jail:RemoveFromJail")
AddEventHandler("laot-jail:RemoveFromJail", function(player)
    local src = player

    local identifier = GetPlayerIdentifiers(src)[1]

    MySQL.Async.fetchAll('SELECT * FROM jail WHERE identifier = @identifier', {
		['@identifier'] = identifier
	}, function(result)
		if result[1] then
			MySQL.Async.execute('DELETE FROM `jail` WHERE `identifier` = @identifier', {
				['@identifier'] = identifier,
			})
        end
	end)
end)

RegisterNetEvent("laot-jail:CheckJail")
AddEventHandler("laot-jail:CheckJail", function(player)
    local src = player

    local identifier = GetPlayerIdentifiers(src)[1]

    MySQL.Async.fetchAll('SELECT * FROM jail WHERE identifier = @identifier', {
		['@identifier'] = identifier
    }, function(result)
        if result[1] then
            TriggerClientEvent("laot-jail:ClientJail", src, result[1].jail_time)
		end
    end)
end)