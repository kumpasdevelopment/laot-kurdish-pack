ESX = nil

local isGathering = false
local isGatheringWhat = nil
local isGatheringMS = nil
local getStone = false

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

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		for _, info in pairs(LAOT.markers) do
			local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
			local dst = GetDistanceBetweenCoords(x, y, z, info.x, info.y, info.z, true)
			if dst <= 5 then
				DrawMarker(2, info.x, info.y, info.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.30, 0.30, 0.30, info.color.r, info.color.g, info.color.b, 200, 0.0, false, true, 0.0, nil, nil, false)
				if dst <= 1 then
					local playerPed = GetPlayerPed(-1)
					if not isGathering then
						ESX.ShowHelpNotification("~r~".. info.label .." ~y~toplamaya başlamak için ~INPUT_PICKUP~ bas.", false, true)
					elseif isGathering and not getStone then
						ESX.ShowHelpNotification("~w~İşlemi iptal etmek için ~INPUT_PICKUP~ bas.", false, true)
					end
					if IsControlJustPressed(0, 38) and not isGathering and ESX.PlayerData.job.name == info.job then
						isGathering = true
						isGatheringWhat = info.item
						isGatheringMS = info.MS
						getStone = false
						TaskStartScenarioInPlace(playerPed, "CODE_HUMAN_MEDIC_TEND_TO_DEAD", 0, false)
					elseif IsControlJustPressed(0, 38) and isGathering and ESX.PlayerData.job.name == info.job then
						isGathering = false
						isGatheringWhat = nil
						isGatheringMS = nil
						getStone = false
						ClearPedTasksImmediately(playerPed)
						ClearPedTasks(playerPed)
					end
				end
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if getStone then
			ESX.ShowHelpNotification("~w~Toplama yaparken gereksiz bir parça buldun.\n~r~Atmak için ~INPUT_DETONATE~ basın.", false, true)
			if IsControlJustPressed(0, 47) then
				getStone = false
			end
		else
			Citizen.Wait(10)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if isGathering and not getStone then
			Citizen.Wait(isGatheringMS) -- isGatheringMS
			if isGathering then
				local random = math.random(1,4)
				if random == 2 or random == 3 or random == 4 then
					--print("Şanslısın.")
					local count = math.random(1,2)
					local oyuncu = GetPlayerServerId(PlayerId())
					TriggerServerEvent("laot-recipe:addItem", isGatheringWhat, count, oyuncu)
				elseif random == 1 then
					--print("Şanslı değilsin.")
					getStone = true
				end
			end
		else
			Citizen.Wait(800)
		end
	end
end)
