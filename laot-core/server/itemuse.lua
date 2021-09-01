ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterUsableItem('hackertablet', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

    TriggerClientEvent("laot-core:HackerUse", source)
end)

RegisterNetEvent('laot-core:HackAddBank')
AddEventHandler('laot-core:HackAddBank', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local random = math.random(250, 350)

    xPlayer.addBank(random)
end)

RegisterServerEvent('laot-cigar:remove')
AddEventHandler('laot-cigar:remove', function(oyuncu)
    local xPlayer = ESX.GetPlayerFromId(oyuncu)

    xPlayer.removeInventoryItem('cigarett', 1)
end)

ESX.RegisterUsableItem('cigarett', function(source)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    local item1 = xPlayer.getInventoryItem('lighter').count
    if item1 >= 1 then
        print("Çakmak bulundu.")
        TriggerClientEvent("laot-cigar:smoke", _source)
    else
        TriggerClientEvent("laot-cigar:notif", _source, "Çakmağınız yok!")
    end

  end)