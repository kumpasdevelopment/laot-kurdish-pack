ESX = nil
INFO = {
    robbing = false
}

RegisterNetEvent('laot-deskbankrob:Sync')
AddEventHandler('laot-deskbankrob:Sync', function()
    TriggerClientEvent("laot-deskbankrob:Sync", -1, INFO)
end)

RegisterNetEvent('laot-deskbankrob:Robbing')
AddEventHandler('laot-deskbankrob:Robbing', function(value, isTrue)
    INFO.robbing = value
    TriggerEvent("laot-deskbankrob:Sync")
    if isTrue then
        Citizen.Wait(C.WaitMS)
        INFO.robbing = false
        TriggerEvent("laot-deskbankrob:Sync")
    end
end)

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
end)

RegisterNetEvent('laot-deskbankrob:OpenVaultDoor')
AddEventHandler('laot-deskbankrob:OpenVaultDoor', function()
    TriggerClientEvent("laot-deskbankrob:OpenVaultDoorClient", -1)
end)

RegisterNetEvent('laot-deskbankrob:ResetVaultDoor')
AddEventHandler('laot-deskbankrob:ResetVaultDoor', function()
	TriggerClientEvent("laot-deskbankrob:ResetVaultDoor", -1)
end)

RegisterNetEvent('laot-deskbankrob:OpenDeskDoor')
AddEventHandler('laot-deskbankrob:OpenDeskDoor', function()
    TriggerClientEvent("laot-deskbankrob:OpenDeskDoor", -1)
end)

RegisterNetEvent('laot-deskbankrob:ResetDeskDoor')
AddEventHandler('laot-deskbankrob:ResetDeskDoor', function()
    TriggerClientEvent("laot-deskbankrob:ResetDeskDoor", -1)
end)

ESX.RegisterServerCallback('laot-deskbankrob:PoliceCount', function(source, cb)
	local xPlayers = ESX.GetPlayers()
	CopsConnected = 0

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'police' or xPlayer.job.name == 'sheriff' then
			CopsConnected = CopsConnected + 1
		end
	end
  print(CopsConnected)
	cb(CopsConnected)
end)

ESX.RegisterServerCallback('laot-deskbankrob:GetItemAmount', function(source, cb, item)
    local xPlayer = ESX.GetPlayerFromId(source)
    local quantity = xPlayer.getInventoryItem(item).count
    
    cb(quantity)
end)
