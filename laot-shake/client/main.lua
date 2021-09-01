ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
end)

Citizen.CreateThread(function()
	local w = "WEAPON_PetrolCan"
    local w1 = "WEAPON_FIREEXTINGUISHER"
    local w2 = "WEAPON_FLARE"
    local curw = GetSelectedPedWeapon(PlayerPedId())
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()
		local playerCoords = GetEntityCoords(playerPed)
		if IsPedShooting(playerPed) then
			if GetSelectedPedWeapon(GetPlayerPed(-1)) == GetHashKey("weapon_snowball") or GetSelectedPedWeapon(GetPlayerPed(-1)) == GetHashKey("weapon_ball") or GetSelectedPedWeapon(GetPlayerPed(-1)) == GetHashKey("WEAPON_PUMPSHOTGUN") or GetSelectedPedWeapon(GetPlayerPed(-1)) == GetHashKey("WEAPON_STUNGUN") then 
				Citizen.Wait(100)
			else
				ShakeGameplayCam('MEDIUM_EXPLOSION_SHAKE', 0.03)
			end
		end
	end
end)