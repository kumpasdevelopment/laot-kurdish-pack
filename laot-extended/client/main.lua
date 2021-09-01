LAOT      			  = {}

LAOT.Player 		  = {}

LAOT.Game   		  = {}
LAOT.Utils  		  = {}

AddEventHandler('laot:getSharedObject', function(cb)
	cb(LAOT)
end)

RegisterNetEvent("laot:playerLoaded")
AddEventHandler("laot:playerLoaded", function()
	TriggerServerEvent("laot-extended:ServerDiscordID", GetPlayerServerId(PlayerId()))
end)

Citizen.CreateThread(function() -- After load
	TriggerEvent("laot:playerLoaded")
end)

function getSharedObject()
	return LAOT
end

LAOT.DebugPrint = function(text)
	TriggerServerEvent("laot-extended:DebugPrint", text)
end

LAOT.Game.Test = function()
	return "TEST SUCCESSFUL."
end

LAOT.GetPlayerData = function()
	return LAOT.Player
end

LAOT.Utils.GetDiscordID = function()
	return LAOT.Player.DiscordID
end

LAOT.Utils.LoadModel = function(hash)
	print("Hash yukleniyor: " .. hash .."")
	model = GetHashKey(hash)
	RequestModel(model)
	while not HasModelLoaded(model) do
		Wait(1)
	end

	return model
end

LAOT.Utils.LoadAnimDict = function(dict, cb)
	while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
	end
	
	if cb ~= nil then
		cb()
	end
end

LAOT.DrawText3D = function(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

LAOT.Game.GetDistance = function(x2, y2, z2)
	local dst = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), x2, y2, z2, true)
	return dst
end

LAOT.Game.Teleport = function(fadeTime, x, y, z, h, cb)
	local ply = GetPlayerServerId(PlayerId())
	local entity = GetPlayerFromServerId(ply)

	DoScreenFadeOut(fadeTime)
	Citizen.Wait(fadeTime)
	
	StartPlayerTeleport(entity, x, y, z, h, false, true, false)
	
	Citizen.Wait(fadeTime)
	DoScreenFadeIn(fadeTime)

	if cb ~= nil then
		cb()
	end
end

LAOT.Game.GetPlayers = function()
	local players = {}

	for _, player in ipairs(GetActivePlayers()) do
		local ped = GetPlayerPed(player)

		if DoesEntityExist(ped) then
			table.insert(players, player)
		end
	end

	return players
end

LAOT.DrawSub = function(msg, time)
	ClearPrints()
	BeginTextCommandPrint('STRING')
	AddTextComponentSubstringPlayerName(msg)
	EndTextCommandPrint(time, 1)
end

LAOT.Notification = function(type, text)
	if C.Use_MythicAlert then
		exports['mythic_notify']:DoHudText(type, text)
	else
		LAOT.DebugPrint("Disabling the (LAOT.Notification) function because you are not using Myhtic Notify.")
	end
end

LAOT.DefaultNotification = function(text)
	AddTextEntry('laotNotification', text)
	SetNotificationTextEntry('laotNotification')
	DrawNotification(false, true)
end

-- ## Events ## --


RegisterNetEvent("laot-extended:ClientDiscordID")
AddEventHandler("laot-extended:ClientDiscordID", function(discordID)
	LAOT.Player.DiscordID = discordID
end)

RegisterNetEvent("laot:Notification")
AddEventHandler("laot:Notification", function(type, text)
	LAOT.Notification(type, text)
end)