ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
	modelHash = GetHashKey(LAOT.car)
    RequestModel(modelHash)
    while not HasModelLoaded(modelHash) do
        Wait(1)
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

Citizen.CreateThread(function()
    while true do
        local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
        local dst = GetDistanceBetweenCoords(x, y, z, LAOT.markerLoc.x, LAOT.markerLoc.y, LAOT.markerLoc.z, true)

        if dst <= 2 then
            if dst <= 2 then
                ESX.ShowHelpNotification(LAOT.msg, false, true)
                DrawMarker(2, LAOT.markerLoc.x, LAOT.markerLoc.y, LAOT.markerLoc.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.40, 0.40, 0.40, 255, 255, 255, 200, 0.0, false, true, 0.0, nil, nil, false)
            end
            if dst <= 2 and IsControlJustReleased(0, 38) then
                spawnCar()
            end
            Citizen.Wait(0)
        else
            Citizen.Wait(1000)
        end
    end
end)

function spawnCar()
    if ESX.PlayerData.job.name ~= 'mechanic' then
        ESX.ShowNotification('Mekanikte çalışmıyorsunuz!')
    else
        DeleteEntity(xCar)
        local playerPed = GetPlayerPed(-1)
        xCar = CreateVehicle(modelHash, LAOT.spawnLoc.x, LAOT.spawnLoc.y, LAOT.spawnLoc.z, LAOT.spawnLoc.h, true, false)
        SetPedIntoVehicle(playerPed, xCar, -1)
    end
end

RegisterCommand("mgerikoy", function()
    print("Deleting car")
    local playerPed = GetPlayerPed(-1)
    local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
    local dst = GetDistanceBetweenCoords(x, y, z, LAOT.delLoc.x, LAOT.delLoc.y, LAOT.delLoc.z, true)

    if dst <= 30 then
        if IsPedInVehicle(playerPed, xCar, false) then
            DeleteEntity(xCar)
        else
            ESX.ShowNotification('Bu araç çekici aracı değil.')
        end
    else
        ESX.ShowNotification('Mesafe uyumlu değil!')
    end
end)