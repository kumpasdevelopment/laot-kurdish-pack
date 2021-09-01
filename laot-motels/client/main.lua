local Keys = {["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118}

ESX = nil
LAOT = nil
MOTELAOT = {}

MOTELAOT.GetClosestMotelRoom = function()
	local currentRoomID = nil
	local lowestDistance = nil
	local motelID = nil
	for k, Motel in pairs(C.LAOTMotels) do
		for _, v in pairs(Motel["Rooms"]) do
			local dst = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), v["menuCoords"].x, v["menuCoords"].y, v["menuCoords"].z, true)
			if lowestDistance then
				if dst < lowestDistance then
					lowestDistance = dst
					currentRoomID = v["ID"]
					motelID = Motel["motelID"]
				end
			else
				lowestDistance = dst
				currentRoomID = v["ID"]
				motelID = Motel["motelID"]
			end
		end
	end

	return motelID, currentRoomID, lowestDistance
end

MOTELAOT.GetClosestManager = function()
	local currentRoomID = nil
	local lowestDistance = nil
	local motelID = nil
	for k, Motel in pairs(C.LAOTMotels) do
		for _, v in pairs(Motel["Rooms"]) do
			local coords = GetOffsetFromInteriorInWorldCoords(cachedData["interiorId"][v.ID], Motel["manager"])
			local dst = #(GetEntityCoords(PlayerPedId()) - coords)
			if lowestDistance then
				if dst < lowestDistance then
					lowestDistance = dst
					currentRoomID = v["ID"]
					motelID = Motel["motelID"]
				end
			else
				lowestDistance = dst
				currentRoomID = v["ID"]
				motelID = Motel["motelID"]
			end
		end
	end

	return motelID, currentRoomID, lowestDistance
end

MOTELAOT.GetClosestMotelRoomExit = function()
	local currentRoomID = nil
	local lowestDistance = nil
	local motelID = nil
	for k, Motel in pairs(C.LAOTMotels) do
		for _, v in pairs(Motel["Rooms"]) do
			local dst = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), v["inside"].x, v["inside"].y, v["inside"].z, true)
			if lowestDistance then
				if dst < lowestDistance then
					lowestDistance = dst
					currentRoomID = v["ID"]
					motelID = Motel["motelID"]
				end
			else
				lowestDistance = dst
				currentRoomID = v["ID"]
				motelID = Motel["motelID"]
			end
		end
	end

	return motelID, currentRoomID, lowestDistance
end

MOTELAOT.GetClosestStash = function()
	local currentRoomID = nil
	local lowestDistance = nil
	local motelID = nil
	for k, Motel in pairs(C.LAOTMotels) do
		for _, v in pairs(Motel["Rooms"]) do
			local coords = GetOffsetFromInteriorInWorldCoords(cachedData["interiorId"][v.ID], Motel["stashCoords"])
			local dst = #(GetEntityCoords(PlayerPedId()) - coords)
			if lowestDistance then
				if dst < lowestDistance then
					lowestDistance = dst
					currentRoomID = v["ID"]
					motelID = Motel["motelID"]
				end
			else
				lowestDistance = dst
				currentRoomID = v["ID"]
				motelID = Motel["motelID"]
			end
		end
	end

	return motelID, currentRoomID, lowestDistance
end


motelData = {}
cachedData = {
	["motelRooms"] = {},
	["interiorId"] = {}
}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
	while LAOT == nil do
		TriggerEvent('laot:getSharedObject', function(obj) LAOT = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
	Citizen.Wait(500)
	CacheLoad()
end)

Citizen.CreateThread(function()
	motelData = C.LAOTMotels

	Citizen.Wait(500)
	CacheLoad()
end)

Citizen.CreateThread(function()
	for k, v in pairs(C.LAOTMotels) do
		motelBlip = AddBlipForCoord(v["position"])
		SetBlipSprite(motelBlip, 475)
		SetBlipDisplay(motelBlip, 2)
		SetBlipScale(motelBlip, 1.0)
		SetBlipColour(motelBlip, v["blipColor"] or 0)
		SetBlipAsShortRange(motelBlip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(v["name"])
		EndTextCommandSetBlipName(motelBlip)
	end
end)

openRentMenu = function(motelID, ID)

	local v = C.LAOTMotels[motelID]

	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'rentMenu',
	{
		title    = (ID .. " ".. _U('Rent_Menu')),
		align = 'top-right', -- Menu position
		elements = {
			{ label = (_U('Rent_This_Motel') .. ' - '.. v["rent"] ..'$/gün'), value = "rent" }
		}
	},
	function(data, menu)
		if data.current.value then
			if data.current.value == 'rent' then
				ESX.TriggerServerCallback('laot-motels:RentMotel', function(retval)
					if retval then
						menu.close()
						LAOT.Notification("inform", "Moteli kiraladın!")
						ESX.ShowHelpNotification("~g~Motel her gün 20:00'da bankandan tahsilat yapacaktır.\n~r~Yapılamaz ise atılırsın ve eşyaların kalır.")
					else
						menu.close()
						LAOT.Notification("error", "Moteli kiralayamadın!")
					end
				end, ID)
			end
			menu.close()
		end
	end,
	function(data, menu)
	menu.close()
	end)
end

RegisterCommand("mgir", function()
	local motelID, closestMotel, closestDistance = MOTELAOT.GetClosestMotelRoom()
	if motelID and closestMotel and closestDistance <= 0.8 then
		print("Yakınsın : ".. closestMotel)
		local v = C.LAOTMotels[motelID]["Rooms"][closestMotel]
		ESX.TriggerServerCallback('laot-motels:CheckOwnership', function(motelData)
			print(motelData.doorOpen)
			local doorLocked = true
			if motelData.doorOpen == "0" then
				doorLocked = true
			elseif motelData.doorOpen == "1" then
				doorLocked = false
			end
			if motelData ~= nil then
				if motelData.owner then
					if not doorLocked then
						local ply = GetPlayerServerId(PlayerId())
						local entity = GetPlayerFromServerId(ply)

						DoScreenFadeOut(100)
						StartPlayerTeleport(entity, v["inside"].x, v["inside"].y, v["inside"].z, v["inside"].h, false, true, false)
						Citizen.Wait(100)
						DoScreenFadeIn(100)
					else
						LAOT.Notification("error", "Oda kilitli!")
					end
				else
					openRentMenu(motelID, motelData.ID)
				end
			else
				LAOT.Notification("error", "#0001: Lütfen bir yetkili ile görüşün.")
			end
		end, closestMotel)
	end
end)

RegisterCommand("mkilit", function()
	local motelID, closestMotel, closestDistance = MOTELAOT.GetClosestMotelRoom()
	if motelID and closestMotel and closestDistance <= 1.5 then
		print("Kilit : ".. closestMotel)
		local v = C.LAOTMotels[motelID]["Rooms"][closestMotel]
		ESX.TriggerServerCallback('laot-motels:CheckOwnership', function(motelData)
			if motelData ~= nil then
				local doorLocked = true
				if motelData.doorOpen == "0" then
					doorLocked = true
				elseif motelData.doorOpen == "1" then
					doorLocked = false
				end

				if motelData.owner and motelData.owner == ESX.GetPlayerData().identifier then
					if doorLocked then
						RequestAnimDict("anim@heists@keycard@")
						while not HasAnimDictLoaded("anim@heists@keycard@") do
							Citizen.Wait(1)
						end
						local ped = PlayerPedId()
					
						TaskPlayAnim(ped, "anim@heists@keycard@", "exit", 8.0, 8.0, 1000, 1, 1, 0, 0, 0)
						TriggerEvent("InteractSound_CL:PlayOnOne", "fob_click_fp", 1.0)
						Citizen.Wait(1000)
						ClearPedTasks(ped)
						TriggerServerEvent("laot-motels:SetDoorState", closestMotel, 1)
						LAOT.Notification("success", "Kapı açıldı.")
					elseif not doorLocked then
						RequestAnimDict("anim@heists@keycard@")
						while not HasAnimDictLoaded("anim@heists@keycard@") do
							Citizen.Wait(1)
						end
						local ped = PlayerPedId()
					
						TaskPlayAnim(ped, "anim@heists@keycard@", "exit", 8.0, 8.0, 1000, 1, 1, 0, 0, 0)
						TriggerEvent("InteractSound_CL:PlayOnOne", "fob_click_fp", 1.0)
						Citizen.Wait(1000)
						ClearPedTasks(ped)
						TriggerServerEvent("laot-motels:SetDoorState", closestMotel, 0)
						LAOT.Notification("error", "Kapı kilitlendi.")
					end
				else
					LAOT.Notification("error", "Odanın sahibi değilsiniz.")
				end
			else
				LAOT.Notification("error", "#0001: Lütfen bir yetkili ile görüşün.")
			end
		end, closestMotel)
	end
end)

RegisterCommand("mçık", function()
	local motelID, closestMotel, closestDistance = MOTELAOT.GetClosestMotelRoomExit()
	if motelID and closestMotel and closestDistance <= 0.8 then
		print("Çıkıyorsun : ".. closestMotel)
		local v = C.LAOTMotels[motelID]["Rooms"][closestMotel]
		ESX.TriggerServerCallback('laot-motels:CheckOwnership', function(motelData)
			if motelData ~= nil then
				print(motelData.doorOpen)
				local doorLocked = true
				if motelData.doorOpen == "0" then
					doorLocked = true
				elseif motelData.doorOpen == "1" then
					doorLocked = false
				end
				if doorLocked then
					LAOT.Notification("error", "Bu oda kilitli.")
				else
					local ply = GetPlayerServerId(PlayerId())
					local entity = GetPlayerFromServerId(ply)

					DoScreenFadeOut(100)
					StartPlayerTeleport(entity, v["menuCoords"].x, v["menuCoords"].y, v["menuCoords"].z, v["menuCoords"].h+360, false, true, false)
					Citizen.Wait(100)
					DoScreenFadeIn(100)
				end
			else
				LAOT.Notification("error", "#0001: Lütfen bir yetkili ile görüşün.")
			end
		end, closestMotel)
	end
end)

DrawScriptText = function(coords, text)
	
	local onScreen, _x, _y = World3dToScreen2d(coords.x, coords.y, coords.z)
	local px, py, pz = table.unpack(GetGameplayCamCoords())
	SetTextScale(0.35, 0.35)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextColour(255, 255, 255, 215)
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(_x, _y)
	local factor = (string.len(text)) / 370
	DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 0, 0, 0, 68)
end

CacheLoad = function()
	cachedData["interiorId"] = {}
	for _, Motel in pairs(C.LAOTMotels) do
		for _, v in pairs(Motel["Rooms"]) do 
			cachedData["interiorId"][v.ID] = GetInteriorAtCoords(v["doorCoords"].x,v["doorCoords"].y,v["doorCoords"].z)
		end
	end
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(60 * 1000)
		CacheLoad()
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(300)
		for k, v in pairs(C.LAOTMotels) do
			if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), v["position"], true) <= 50 then
				local doorHandle = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 10.0, v["doorHash"])
				FreezeEntityPosition(doorHandle, true)
			end
		end
	end
end)

Citizen.CreateThread(function()
	Citizen.Wait(300)
	while true do

		local sleepThread = 1
		for k, Motel in pairs(C.LAOTMotels) do
			if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), Motel["position"], true) <= 50 then

				for _, Room in pairs(Motel["Rooms"]) do
					local furnitureCoords = GetOffsetFromInteriorInWorldCoords(cachedData["interiorId"][Room.ID], Motel["stashCoords"])
					local furnitureDistance = #(GetEntityCoords(PlayerPedId()) - furnitureCoords)

					local managerCoords = GetOffsetFromInteriorInWorldCoords(cachedData["interiorId"][Room.ID], Motel["manager"])
					local managerDistance = #(GetEntityCoords(PlayerPedId()) - managerCoords)

					local dst1 = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), Room["menuCoords"].x, Room["menuCoords"].y, Room["menuCoords"].z, true)
					if furnitureDistance <= 3.0 then
						DrawScriptText(furnitureCoords, _U('Stash_Text'))
					end
					if managerDistance <= 2.0 then
						DrawScriptText(managerCoords, _U('Manager_Text'))
					end
					if dst1 <= 4 then
						DrawScriptText(Room["menuCoords"], _U('Menu_Text'))
					end
				end

			end
		end
		Citizen.Wait(sleepThread)
	end
end)


RegisterCommand("mdepo", function()
	local motelID, closestMotel, closestDistance = MOTELAOT.GetClosestStash()
	if motelID and closestMotel and closestDistance <= 0.8 then
		print("Depo : ".. closestMotel)
		local v = C.LAOTMotels[motelID]["Rooms"][closestMotel]
		ESX.TriggerServerCallback('laot-motels:CheckOwnership', function(motelData)
			if motelData ~= nil then
				local stashLocked = true
				if motelData.stashOpen == "0" then
					stashLocked = true
				elseif motelData.stashOpen == "1" then
					stashLocked = false
				end

				if stashLocked then
					LAOT.Notification("error", "Bu depo kilitli.")
				else
					if C.UseDinamicStash then
						OpenStash("lmotel", v["ID"])
					else
						OpenStash("lmotel", ESX.GetPlayerData().identifier)
					end
				end
			else
				LAOT.Notification("error", "#0001: Lütfen bir yetkili ile görüşün.")
			end
		end, closestMotel)
	end
end)

RegisterCommand("mdepokilit", function()
	local motelID, closestMotel, closestDistance = MOTELAOT.GetClosestStash()
	if motelID and closestMotel and closestDistance <= 1.5 then -- laot
		print("Depo Kilit : ".. closestMotel)
		local v = C.LAOTMotels[motelID]["Rooms"][closestMotel]
		ESX.TriggerServerCallback('laot-motels:CheckOwnership', function(motelData)
			if motelData ~= nil then
				local stashLocked = true
				if motelData.stashOpen == "0" then
					stashLocked = true
				elseif motelData.stashOpen == "1" then
					stashLocked = false
				end

				if motelData.owner and motelData.owner == ESX.GetPlayerData().identifier then
					if stashLocked then
						RequestAnimDict("anim@heists@keycard@")
						while not HasAnimDictLoaded("anim@heists@keycard@") do
							Citizen.Wait(1)
						end
						local ped = PlayerPedId()
					
						TaskPlayAnim(ped, "anim@heists@keycard@", "exit", 8.0, 8.0, 1000, 1, 1, 0, 0, 0)
						TriggerEvent("InteractSound_CL:PlayOnOne", "fob_click_fp", 1.0)
						Citizen.Wait(1000)
						ClearPedTasks(ped)
						TriggerServerEvent("laot-motels:SetStashState", closestMotel, 1)
						LAOT.Notification("success", "Depo açıldı.")
					elseif not stashLocked then
						RequestAnimDict("anim@heists@keycard@")
						while not HasAnimDictLoaded("anim@heists@keycard@") do
							Citizen.Wait(1)
						end
						local ped = PlayerPedId()
					
						TaskPlayAnim(ped, "anim@heists@keycard@", "exit", 8.0, 8.0, 1000, 1, 1, 0, 0, 0)
						TriggerEvent("InteractSound_CL:PlayOnOne", "fob_click_fp", 1.0)
						Citizen.Wait(1000)
						ClearPedTasks(ped)
						TriggerServerEvent("laot-motels:SetStashState", closestMotel, 0)
						LAOT.Notification("error", "Depo kilitlendi.")
					end
				else
					LAOT.Notification("error", "Odanın sahibi değilsiniz.")
				end
			else
				LAOT.Notification("error", "#0001: Lütfen bir yetkili ile görüşün.")
			end
		end, closestMotel)
	end
end)

RegisterCommand("moda", function()
	local motelID, closestMotel, closestDistance = MOTELAOT.GetClosestManager()
	if motelID and closestMotel and closestDistance <= 1.5 then
		print("Oda l#a#o#t Yöneticisi : ".. closestMotel)
		local v = C.LAOTMotels[motelID]["Rooms"][closestMotel]
		ESX.TriggerServerCallback('laot-motels:CheckOwnership', function(motelData)
			if motelData ~= nil then
				if motelData.owner and motelData.owner == ESX.GetPlayerData().identifier then
					ESX.UI.Menu.CloseAll()
					ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'managerMenu',
					{
						title    = (closestMotel .. " ".. _U('Manager_Menu')),
						align = 'top-right', -- Menu position
						elements = {
							{ label = (_U('Cancel_Room')), value = "leave" }
						}
					},
					function(data, menu)
						if data.current.value then
							if data.current.value == 'leave' then
								ESX.TriggerServerCallback('laot-motels:LeaveMotel', function(retval)
									if retval then
										menu.close()
										LAOT.Notification("inform", "Motelinden ayrıldın!")
										local ply = GetPlayerServerId(PlayerId())
										local entity = GetPlayerFromServerId(ply)
					
										DoScreenFadeOut(100)
										StartPlayerTeleport(entity, v["menuCoords"].x, v["menuCoords"].y, v["menuCoords"].z, v["menuCoords"].h+360, false, true, false)
										Citizen.Wait(100)
										DoScreenFadeIn(100)
									else
										menu.close()
										LAOT.Notification("error", "#6000: Moteli terk edemedin!")
									end
								end, closestMotel)
							end
							menu.close()
						end
					end,
					function(data, menu)
					menu.close()
					end)
				else
					LAOT.Notification("error", "Odanın sahibi değilsiniz.")
				end
			else
				LAOT.Notification("error", "#0001: Lütfen bir yetkili ile görüşün.")
			end
		end, closestMotel)
	end
end)

OpenStash = function(type, owner)
	TriggerEvent("disc-inventoryhud:openInventory", {
		["type"] = type,
		["owner"] = owner,
	})
end