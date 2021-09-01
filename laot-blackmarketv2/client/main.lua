local Keys = {["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118}
function DrawText3D(x, y, z, text, scale) local onScreen, _x, _y = World3dToScreen2d(x, y, z) local pX, pY, pZ = table.unpack(GetGameplayCamCoords()) SetTextScale(scale, scale) SetTextFont(4) SetTextProportional(1) SetTextEntry("STRING") SetTextCentre(true) SetTextColour(255, 255, 255, 215) AddTextComponentString(text) DrawText(_x, _y) end

ESX = nil

local inHouse = false
local currentID = nil
local waitMS = nil
local currentCount = nil

local item
local waitTime

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
	Citizen.Wait(1000)
	createPeds()
end)

createPeds = function()
	local playerPed = PlayerPedId()
	npcHash = GetHashKey(LAOT.Home.NPC.hash)
	RequestModel(npcHash)
	while not HasModelLoaded(npcHash) do
		Wait(1)
	end
	Wait(1)
	driverhash = GetHashKey(LAOT.Home.DriveTo.pedHash)
	RequestModel(driverhash)
	while not HasModelLoaded(driverhash) do
		Wait(1)
	end
	Wait(1)
	vehhash = GetHashKey(LAOT.Home.DriveTo.carHash)
	RequestModel(vehhash)
	while not HasModelLoaded(vehhash) do
		Wait(1)
	end
	Wait(1)
	AddRelationshipGroup('laotblackmarketv2x')
	NPC = CreatePed(0, npcHash, LAOT.Home.NPC.coords.x, LAOT.Home.NPC.coords.y, LAOT.Home.NPC.coords.z, LAOT.Home.NPC.coords.h, false)
    FreezeEntityPosition(NPC, true)
    SetEntityInvincible(NPC, true)
    GiveWeaponToPed(
        NPC --[[ Ped ]], 
        0xBFE256D4 --[[ Hash ]], -- 0xBFE256D4
        160 --[[ integer ]], 
        false --[[ boolean ]], 
        true --[[ boolean ]]
	)
	SetPedRelationshipGroupHash(NPC, 'laotblackmarketv2x')
	-- RequestAnimDict("timetable@ron@ig_3_couch")
    -- while not HasAnimDictLoaded("timetable@ron@ig_3_couch") do Citizen.Wait(10) end
	-- TaskPlayAnim(NPC, "timetable@ron@ig_3_couch", "base", 2.0, 2.0, -1, 1, 0, false, false, false)
	--print("Creating bodyguards")
	--Citizen.Wait(250)
	--guardHash = GetHashKey(LAOT.Home.bodyguardModel)
	--RequestModel(guardHash)
	--while not HasModelLoaded(guardHash) do
	--	Wait(1)
	--end
	--for _, info in pairs(LAOT.Home.bodyguards) do
	--	Citizen.Wait(100)
	--	info.id = CreatePed(0, guardHash, info.x, info.y, info.z, info.h, false)
	--	FreezeEntityPosition(info.id, true)
	--	SetEntityInvincible(info.id, true)
	--	GiveWeaponToPed(
	--		info.id --[[ Ped ]], 
	--		0xBFE256D4 --[[ Hash ]], 
	--		160 --[[ integer ]], 
	--		false --[[ boolean ]], 
	--		true --[[ boolean ]]
	--	)
	--	SetPedRelationshipGroupHash(info.id, 'laotblackmarketv2x')
	--	TaskStartScenarioInPlace(info.id, "WORLD_HUMAN_GUARD_STAND", 0, false)
	--	GiveWeaponToPed(
    --        info.id --[[ Ped ]], 
    --        0x78A97CD0 --[[ Hash ]], 
    --        160 --[[ integer ]], 
    --        false --[[ boolean ]], 
    --        true --[[ boolean ]]
    --    )
	--end
end
--[[
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
		local dst = GetDistanceBetweenCoords(x, y, z, LAOT.Home.loc.x, LAOT.Home.loc.y, LAOT.Home.loc.z, true)
		if dst <= 4 then
			DrawMarker(27, LAOT.Home.loc.x, LAOT.Home.loc.y, LAOT.Home.loc.z-1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 0, 40, 200, 0.0, false, true, 0.0, nil, nil, false)
			DrawText3D(LAOT.Home.loc.x, LAOT.Home.loc.y, LAOT.Home.loc.z, l.enter, 0.50)
			if dst <= 2 then
				if IsControlJustReleased(0, 38) then
					enterHome()
				end
			end
		else
			Citizen.Wait(1000)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
		local dst = GetDistanceBetweenCoords(x, y, z, LAOT.Home.exitLoc.x, LAOT.Home.exitLoc.y, LAOT.Home.exitLoc.z, true)
		if dst <= 5 then
			DrawMarker(LAOT.Home.markerType, LAOT.Home.exitLoc.x, LAOT.Home.exitLoc.y, LAOT.Home.exitLoc.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 255, 50, 40, 200, 1.0, true, true, 0.0, nil, nil, false)
			if dst <= 2 then
				if IsControlJustPressed(0, 38) then
					leaveHome()
				end
			end
		else
			Citizen.Wait(1100)
		end
	end
end)]]

RegisterNetEvent("laot-blackmarketv2:success")
AddEventHandler("laot-blackmarketv2:success", function()
	ESX.ShowHelpNotification(l.success)
	--leaveHome()
	--prepareOrder()
	local item = LAOT.items[currentID]
	Citizen.Wait(math.random(1000, 3500))
	TriggerServerEvent("laot-blackmarketv2:addItem", item.item, currentCount, GetPlayerServerId(PlayerId()))
	Citizen.Wait(100)
	currentID = nil
	currentCount = nil
end)

RegisterNetEvent("laot-blackmarketv2:failure")
AddEventHandler("laot-blackmarketv2:failure", function()
	ESX.ShowHelpNotification(l.failure)
	currentID = nil
	waitMS = nil
	local random = math.random(1,2)
	if random == 1 then
		attackToPlayer()
	end
end)

attackToPlayer = function()
	local playerPed = GetPlayerPed(-1)
	TaskCombatPed(NPC, playerPed, 0, 16)
end

function SpawnVehicle(x, y, z, vehhash, driverhash)                                                     --Spawning Function
    local found, spawnPos, spawnHeading = GetClosestVehicleNodeWithHeading(x + math.random(-100, 100), y + math.random(-100, 100), z, 0, 3, 0)

    ESX.Game.SpawnVehicle(vehhash, spawnPos, spawnHeading, function(callback_vehicle)
        SetVehicleHasBeenOwnedByPlayer(callback_vehicle, true)
        
        SetEntityAsMissionEntity(callback_vehicle, true, true)
        ClearAreaOfVehicles(GetEntityCoords(callback_vehicle), 5000, false, false, false, false, false);  
        SetVehicleOnGroundProperly(callback_vehicle)
        
        mechPed = CreatePedInsideVehicle(callback_vehicle, 26, driverhash, -1, true, false)              		--Driver Spawning.
        
        mechBlip = AddBlipForEntity(callback_vehicle)                                                        	--Blip Spawning.
        SetBlipFlashes(mechBlip, true)  
		SetBlipSprite(mechBlip, 103)
		SetBlipScale(mechBlip, 1.2)
		SetBlipColour(mechBlip, 59)
		SetBlipAsShortRange(mechBlip, false)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("X Sipariş")
		EndTextCommandSetBlipName(mechBlip)

        GoToTarget(x, y, z, callback_vehicle, mechPed, vehhash)
    end)                          --Car Spawning.
end

function GoToTarget(x, y, z, vehicle, driver, vehhash, target)
    enroute = true
    while enroute do
        Citizen.Wait(500)
        local player = PlayerPedId()
        local playerPos = GetEntityCoords(player)
        SetDriverAbility(driver, 1.0)        -- values between 0.0 and 1.0 are allowed.
        SetDriverAggressiveness(driver, 0.0)
        TaskVehicleDriveToCoord(driver, vehicle, playerPos.x, playerPos.y, playerPos.z, 20.0, 0, vehhash, 4457279, 1, true)
        local distanceToTarget = #(playerPos - GetEntityCoords(vehicle))
        if distanceToTarget < 15 or distanceToTarget > 150 then
            RemoveBlip(mechBlip)
            TaskVehicleTempAction(driver, vehicle, 27, 6000)
            --SetVehicleUndriveable(vehicle, true)
            SetEntityHealth(mechPed, 200)
            SetPedDropsWeaponsWhenDead(mechPed, false)
            SetPedAccuracy(mechPed, 100)
            SetPedCanRagdoll(mechPed, false)
			enroute = false
			ESX.ShowHelpNotification(l["order_rised"])
		end
		Citizen.CreateThread(function()
			while true do
				Citizen.Wait(0)

				local tx, ty, tz = table.unpack(GetOffsetFromEntityInWorldCoords(vehicle, 0.0, -2.9, 0.0 + 0.2))
				local x1,y1,z1 = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
				local dst = GetDistanceBetweenCoords(x1, y1, z1, GetEntityCoords(vehicle), true)

				if dst <= 5 then
					DrawText3D(tx, ty, tz+0.50, "~w~[~r~E~w~] Teslim Al", 0.50)
					DrawMarker(LAOT.Home.markerType, tx, ty, tz, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 255, 50, 40, 200, 1.0, true, true, 0.0, nil, nil, false)
					if IsControlJustPressed(0, 38) then
						currentID = nil
						waitMS = nil
						item = nil
						vehicleCamed = false
						SetEntityAsMissionEntity(vehicle, true, true)
						SetEntityAsMissionEntity(driver, true, true)
						SetEntityAsNoLongerNeeded(vehicle)
						SetEntityAsNoLongerNeeded(driver)
						DeleteBlip()
					end
				else
					Citizen.Wait(1000)
				end

			end
		end)
    end
end

function GoToTargetWalking(x, y, z, vehicle, driver)
    Citizen.Wait(500)
    TaskWanderStandard(driver, 10.0, 10)
    Citizen.Wait(35000)
    DeletePed(mechPed)
    mechPed = nil
end

prepareOrder = function()
	item = LAOT.items[currentID]
	waitTime = math.random(item.waitMSRandom, item.waitMSRandom2)
	Citizen.Wait(waitTime)

	local gameVehicles = ESX.Game.GetVehicles()
    
    local player = PlayerPedId()
    local playerPos = GetEntityCoords(player)

    while not HasModelLoaded(driverhash) and RequestModel(driverhash) or not HasModelLoaded(vehhash) and RequestModel(vehhash) do
        RequestModel(driverhash)
        RequestModel(vehhash)
        Citizen.Wait(0)
    end

    SpawnVehicle(playerPos.x, playerPos.y, playerPos.z, vehhash, driverhash)

	--[[
	local ped = CreatePed(0, driverHash, LAOT.Home.DriveTo.pedSpawnLoc.x, LAOT.Home.DriveTo.pedSpawnLoc.y, LAOT.Home.DriveTo.pedSpawnLoc.z, LAOT.Home.DriveTo.pedSpawnLoc.h, true)
	local vehicle = CreateVehicle(driverCarHash, LAOT.Home.DriveTo.spawnLoc.x, LAOT.Home.DriveTo.spawnLoc.y, LAOT.Home.DriveTo.spawnLoc.z, LAOT.Home.DriveTo.spawnLoc.h, true)

	SetPedIntoVehicle(ped, vehicle, -1)
	SetVehicleDoorsLocked(vehicle, 4)
	
	local rand = math.random(1, LAOT.Deliver.count)
	local coordsToGo = LAOT.Deliver.locs[rand]

	CreateBlip(coordsToGo)

	local stopRange = 8.0
	local speed = 30.0
	local drivingStyle = 0
	
	-- Useful functions to make the ped perform better while driving.
	SetDriverAbility(ped, 1.0)        -- values between 0.0 and 1.0 are allowed.
	SetDriverAggressiveness(ped, 0.0) -- values between 0.0 and 1.0 are allowed.
	
	-- Example 1
	-- Give the player a wander driving task.
	TaskVehicleDriveWander(ped, vehicle, speed, drivingStyle)
	
	-- Example 2
	-- Manually set/override the driving style (after giving the ped a driving task).
	SetDriveTaskDrivingStyle(ped, drivingStyle)
	
	-- Example 3
	-- Drive to a location (far away).
	local c = TaskVehicleDriveToCoordLongrange(ped, vehicle, coordsToGo, speed, drivingStyle, stopRange);

	if c then
		local vehicleCamed = nil
		Citizen.CreateThread(function()
			while true do
				Citizen.Wait(0)
				vehicleCamed = checkVehicleCamed(coordsToGo, vehicle)
				if vehicleCamed then
					local tx, ty, tz = table.unpack(GetOffsetFromEntityInWorldCoords(vehicle, 0.0, -2.9, 0.0 + 0.5))
					local x1,y1,z1 = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
					local dst = GetDistanceBetweenCoords(x1, y1, z1, GetEntityCoords(vehicle), true)

					if dst <= 5 then
						SetVehicleDoorOpen(vehicle, 7, false, false)
						DrawText3D(tx, ty, tz+0.50, "~w~[~r~E~w~] Teslim Al", 0.50)
						DrawMarker(LAOT.Home.markerType, tx, ty, tz, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 255, 50, 40, 200, 1.0, true, true, 0.0, nil, nil, false)
						if IsControlJustPressed(0, 38) then
							TriggerServerEvent("laot-blackmarketv2:addItem", item.item, currentCount, GetPlayerServerId(PlayerId()))
							currentID = nil
							waitMS = nil
							item = nil
							vehicleCamed = false
							SetEntityAsMissionEntity(vehicle, true, true)
							SetEntityAsMissionEntity(ped, true, true)
							SetEntityAsNoLongerNeeded(vehicle)
							SetEntityAsNoLongerNeeded(ped)
							DeleteBlip()
						end
					else
						Citizen.Wait(1000)
					end

				else
					Citizen.Wait(1000)
				end
			end
		end)
		Citizen.Wait(300 * 1000) -- 300 saniye
	end--]]
end

checkVehicleCamed = function(coordsToGo, vehicle)
	local x, y, z = table.unpack(coordsToGo)
	local dst = GetDistanceBetweenCoords(GetEntityCoords(vehicle), x, y, z, true)
	if dst <= 10 then
		return true
	else
		return false
	end
end

leaveHome = function()
	ESX.UI.Menu.CloseAll()
	local playerPed = GetPlayerPed(-1)
	inHouse = false
	DoScreenFadeOut(2500)
	Citizen.Wait(2500)
	SetEntityCoords(PlayerPedId(), 148.1956, -1820.24, 27.711)
	SetEntityHeading(PlayerPedId(), 51.42)
	Citizen.Wait(1000)
	DoScreenFadeIn(1000)
end

DeleteBlip = function()
	if DoesBlipExist(blip) then
		RemoveBlip(blip)
	end
end

CreateBlip = function(coordsToGo)
	DeleteBlip()
	if currentID and coordsToGo then
		blip = AddBlipForCoord(coordsToGo)
	end
    
    SetBlipSprite(blip, 103)
	SetBlipScale(blip, 1.2)
	SetBlipColour(blip, 59)
    SetBlipAsShortRange(blip, false)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("X Sipariş")
    EndTextCommandSetBlipName(blip)
end

enterHome = function()
	ESX.UI.Menu.CloseAll()
	if not currentID then
		local playerPed = GetPlayerPed(-1)
		inHouse = true
		DoScreenFadeOut(2500)
		Citizen.Wait(2500)
		SetEntityCoords(PlayerPedId(), 346.7817, -1011.77, -99.19) -- Giriş
		SetEntityHeading(PlayerPedId(), 354)
		Citizen.Wait(1000)
		DoScreenFadeIn(1000)
	else
		ESX.ShowNotification("Zaten bir siparişin var!")
	end
end

Citizen.CreateThread(function()
	local playerPed = GetPlayerPed(-1)
	while true do
		Citizen.Wait(0)
		local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
		local dst = GetDistanceBetweenCoords(x, y, z, LAOT.Home.markerLoc.x, LAOT.Home.markerLoc.y, LAOT.Home.markerLoc.z, true)
		if dst <= 5 then
			DrawMarker(LAOT.Home.markerType, LAOT.Home.markerLoc.x, LAOT.Home.markerLoc.y, LAOT.Home.markerLoc.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 255, 50, 40, 200, 1.0, true, true, 0.0, nil, nil, false)
			if dst <= 2 then
				if IsControlJustPressed(0, 38) then
					--TriggerServerEvent("esx_addons_gcphone:startCall", LAOT.PhoneNumber, "Siparişini aldık aslan parçası gönlün rahat olsun!")
					local elements = {}
					for _, info in pairs(LAOT.items) do
						if info.type ~= nil then
							table.insert(elements, { id = info.id, label = ''.. info.label ..' - '.. info.price ..'$/tanesi', value = 1, type = "slider", min = info.min, max = info.max })
						else
							table.insert(elements, { id = info.id, label = ''.. info.label ..' - '.. info.price ..'$', value = 1 })
						end
					end
					ESX.UI.Menu.CloseAll()
					ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menu',
					{
						title    = ('SİPARİŞLER'),
						align = 'top-left', -- Menu position
						elements = elements
					},
					function(data, menu)
						if data.current.value and data.current.id then
							if currentID == nil then
								local item = LAOT.items[data.current.id]
								local lPlayer = GetPlayerServerId(PlayerId())
								currentID = item.id
								if data.current.max then
									currentCount = data.current.value
									TriggerServerEvent("laot-blackmarketv2:removeItem", 'cash', item.price * currentCount, lPlayer)
								else
									currentCount = 1
									TriggerServerEvent("laot-blackmarketv2:removeItem", 'cash', item.price, lPlayer)
								end
							else
								ESX.ShowNotification("Bir siparişin zaten var. Şimdi evimden çık!")
							end
							menu.close()
						end
					end,
					function(data, menu)
					  menu.close()
					end)
				end
			end
		else
			Citizen.Wait(1000)
		end
	end
end)