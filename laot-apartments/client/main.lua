local Keys = {["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118}

ESX = nil
LAOT = nil

local home = {}
local houseObj = {}
local POIOffsets = {}

V = {}
V.PlayerLoaded = true
V.InApartment = false

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
end)

Citizen.CreateThread(function()
	while LAOT == nil do
		Citizen.Wait(10)
	end

	while ESX == nil do
		Citizen.Wait(10)
	end

	V.PlayerLoaded = true
	CreateApartmentBlip()
end)

CreateApartmentBlip = function()
	blip = AddBlipForCoord(C.Apartment["Location"]["x"], C.Apartment["Location"]["y"], C.Apartment["Location"]["z"])
	SetBlipSprite(blip, 476)
	SetBlipDisplay(blip, 4)
	SetBlipScale(blip, 1.15)
	SetBlipColour(blip, 0)
	SetBlipAsShortRange(blip, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(C.Apartment["Name"])
	EndTextCommandSetBlipName(blip)
end

RegisterNetEvent("laot-apartments:client:FirstSpawn")
AddEventHandler("laot-apartments:client:FirstSpawn", function()
	local coords = {x = C.Apartment["Location"]["x"], y = C.Apartment["Location"]["y"], z = C.Apartment["Location"]["z"]}
	local interiorID = GetInteriorAtCoords(151.25, -1007.74, -99.00)
	LoadInterior(interiorID)
	while not IsInteriorReady(interiorID) do
		Citizen.Wait(100)
	end
	LAOT.Notification("inform", "Devlet sana bir daire tahsis etti.")
	houseObj = {}
	POIOffsets = {}
	TriggerEvent("InteractSound_CL:PlayOnOne", "doorenter", 1.0)
	DoScreenFadeOut(100)
	exports['laot-interior']:DespawnInterior(houseObj, function()
		home = { x = (coords['x'] + math.random(15, 35)), y = (coords['y'] + math.random(15,35)), z = (coords['z'] - math.random(15, 100)) }
		data = exports['laot-interior']:CreateApartmentFurnished(home)
		Citizen.Wait(100)
		houseObj = data[1]
		POIOffsets = data[2]
		V.InApartment = true

		Citizen.Wait(1000)
	end)
end)

openApartmentMenu = function()

	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'rentMenu',
	{
		title    = (_U("Apartment_Menu")),
		align = 'top-right', -- Menu position
		elements = {
			{ label = (_U("Enter_Room")), value = "enter" }
		}
	},
	function(data, menu)
		if data.current.value then
			if data.current.value == 'enter' then
				local coords = {x = C.Apartment["Location"]["x"], y = C.Apartment["Location"]["y"], z = C.Apartment["Location"]["z"]}
				local interiorID = GetInteriorAtCoords(151.25, -1007.74, -99.00)
				LoadInterior(interiorID)
				while not IsInteriorReady(interiorID) do
					Citizen.Wait(100)
				end
			 	houseObj = {}
				POIOffsets = {}
				TriggerEvent("InteractSound_CL:PlayOnOne", "doorenter", 1.0)
				DoScreenFadeOut(100)
				exports['laot-interior']:DespawnInterior(houseObj, function()
					home = { x = (coords['x'] + math.random(15, 35)), y = (coords['y'] + math.random(15,35)), z = (coords['z'] - math.random(15, 100)) }
					data = exports['laot-interior']:CreateApartmentFurnished(home)
					Citizen.Wait(100)
					houseObj = data[1]
					POIOffsets = data[2]
					V.InApartment = true
					
					Citizen.Wait(1000)
					DoScreenFadeIn(100)
				end)
			end
			menu.close()
		end
	end,
	function(data, menu)
	menu.close()
	end)
end


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if V.PlayerLoaded then
			if V.InApartment then

				-- çıkış için | laot#0101
				exitDistance = LAOT.Game.GetDistance(home.x - POIOffsets.exit.x, home.y - POIOffsets.exit.y, home.z + POIOffsets.exit.z)
				if exitDistance < 8 and exitDistance > 2 then
					LAOT.DrawText3D(home.x - POIOffsets.exit.x, home.y - POIOffsets.exit.y, home.z + POIOffsets.exit.z, _U("Exit_No"))
				end
				if exitDistance < 2 then
					LAOT.DrawText3D(home.x - POIOffsets.exit.x, home.y - POIOffsets.exit.y, home.z + POIOffsets.exit.z, _U("Exit"))
					if IsControlJustPressed(0, Keys["E"]) then
						leaveApartment()
					end
				end

				-- stash için | laot#0101
				stashDistance = LAOT.Game.GetDistance(home.x - POIOffsets.stash.x, home.y - POIOffsets.stash.y, home.z + POIOffsets.stash.z)
				if stashDistance < 8 and stashDistance > 2 then
					LAOT.DrawText3D(home.x - POIOffsets.stash.x, home.y - POIOffsets.stash.y, home.z + POIOffsets.stash.z, _U("Stash_No"))
				end
				if stashDistance < 2 then
					LAOT.DrawText3D(home.x - POIOffsets.stash.x, home.y - POIOffsets.stash.y, home.z + POIOffsets.stash.z, _U("Stash"))
					if IsControlJustPressed(0, Keys["E"]) then
						OpenStash("laot-apartment", ESX.PlayerData.identifier)
					end
				end

			else
				Citizen.Wait(500)
			end
		else
			Citizen.Wait(10)
		end
	end
end)

houseanim = function()
    loadAnimDict("anim@heists@keycard@") 
    TaskPlayAnim( GetPlayerPed(-1), "anim@heists@keycard@", "exit", 5.0, 1.0, -1, 16, 0, 0, 0, 0 )
    Citizen.Wait(400)
    ClearPedTasks(GetPlayerPed(-1))
end

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end

leaveApartment = function()
	houseanim()
    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Citizen.Wait(10)
    end
    exports['laot-interior']:DespawnInterior(houseObj, function()
		SetEntityCoords(GetPlayerPed(-1), C.Apartment["Outside"]["x"], C.Apartment["Outside"]["y"], C.Apartment["Outside"]["z"]) 
		SetEntityHeading(GetPlayerPed(-1), C.Apartment["Outside"]["h"])
		TriggerEvent("InteractSound_CL:PlayOnOne", "doorexit", 1.0)
        Citizen.Wait(1000)
        V.InApartment = false
		DoScreenFadeIn(1000)
    end)
end

OpenStash = function(type, owner)	
	TriggerEvent("disc-inventoryhud:openInventory", {
		["type"] = type,
		["owner"] = owner,
	})
end

--
--AddEventHandler('onResourceStop', function(resource)
--    if resource == GetCurrentResourceName() then
--        if houseObj ~= nil then
--            exports['laot-interior']:DespawnInterior(houseObj, function()
--                DoScreenFadeIn(500)
--                while not IsScreenFadedOut() do
--                    Citizen.Wait(10)
--                end
--                SetEntityCoords(GetPlayerPed(-1), C.Apartment["Outside"]["x"], C.Apartment["Outside"]["y"], C.Apartment["Outside"]["z"])
--                SetEntityHeading(GetPlayerPed(-1), C.Apartment["Outside"]["h"])
--                Citizen.Wait(1000)
--                DoScreenFadeIn(1000)
--            end)
--        end
--    end
--end)

-- Main thread laot#0101
Citizen.CreateThread(function()
	while true do
		local sleep = 1000
		if V.PlayerLoaded then
			if Vdist2(GetEntityCoords(PlayerPedId()), C.Apartment["Location"]["x"], C.Apartment["Location"]["y"], C.Apartment["Location"]["z"]) < 10 then
				sleep = 2
				LAOT.DrawText3D(C.Apartment["Location"]["x"], C.Apartment["Location"]["y"], C.Apartment["Location"]["z"], _U("Enter_Apartment"))
				if IsControlJustPressed(0, 38) and LAOT.Game.GetDistance(C.Apartment["Location"]["x"], C.Apartment["Location"]["y"], C.Apartment["Location"]["z"]) < 3 then
					openApartmentMenu()
				end
			else
				Citizen.Wait(1500)
			end
		else
			Citizen.Wait(10)
		end
		Citizen.Wait(sleep)
	end
end)

