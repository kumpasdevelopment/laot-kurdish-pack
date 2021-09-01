ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
end)

RegisterNetEvent('laot-house:ReportServer')
AddEventHandler('laot-house:ReportServer', function(xPlayer)
    local DISCORD_IMAGE = "https://pbs.twimg.com/profile_images/847824193899167744/J1Teh4Di_400x400.jpg"
    local connect = {
          {
              ["color"] = 65280,
              ["title"] = "",
              ["footer"] = {
                  ["text"] = "",
              },
          }
      }
    PerformHttpRequest(C.Webhook, function(err, text, headers) end, 'POST', json.encode({username = resourceName, embeds = connect, avatar_url = DISCORD_IMAGE}), { ['Content-Type'] = 'application/json' })
end)

RegisterNetEvent("laot-house:BuzzServer")
AddEventHandler("laot-house:BuzzServer", function(discord, homeID)
    local src = source
    
    local data = {}
    data.firstname, data.lastname = GetCharacterName(src)
    TriggerClientEvent("laot-house:BuzzC", -1, src, discord, data, homeID)
end)

RegisterNetEvent("laot-house:BuzzAnswer")
AddEventHandler("laot-house:BuzzAnswer", function(player, id, answer)
    print("31 answer")
    if player and answer then
        if answer == 'yes' then
            TriggerClientEvent("laot-house:EnterHouse", player, id)
        elseif answer == 'no' then
            TriggerClientEvent("laot-house:Notification", error, "Davetin reddedildi!")
        end
    end
end)

function GetCharacterName(source)
	local result = MySQL.Sync.fetchAll('SELECT firstname, lastname FROM users WHERE identifier = @identifier', {
		['@identifier'] = GetPlayerIdentifiers(source)[1]
	})

	if result[1] and result[1].firstname and result[1].lastname then
		return ('%s %s'):format(result[1].firstname, result[1].lastname)
	end
end

ESX.RegisterServerCallback('laot-house:GetCharacterName', function(source, cb)
    local ssource = ESX.GetPlayerFromId(source)

    local result = MySQL.Sync.fetchAll("SELECT firstname, lastname FROM users WHERE identifier = @identifier", {
        ['@identifier'] = ssource.identifier
    })

    local firstname = result[1].firstname
    local lastname  = result[1].lastname

    cb(''.. firstname .. ' ' .. lastname ..'')
end)
    
Citizen.CreateThread(function()
    TriggerEvent('disc-inventoryhud:RegisterInventory', {
        name = 'houseLaot',
        label = "evdepo",
        slots = 750,
        weight = 750
    })
end)