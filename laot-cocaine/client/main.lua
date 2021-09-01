local Keys = {["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118}

ESX = nil
PlayerData = {}

LAOT = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
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
	while true do
		local sleep = 1000
		if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), C.CocaineLocation["x"], C.CocaineLocation["y"], C.CocaineLocation["z"], true) <= 8.0 then
			sleep = 5
			DrawMarker(20, C.CocaineLocation["x"], C.CocaineLocation["y"], C.CocaineLocation["z"], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.8, 0.8, 0.8, 255, 0, 0, 200, 0.0, true, true, 0.0, nil, nil, false)
			LAOT.DrawText3D(C.CocaineLocation["x"], C.CocaineLocation["y"], C.CocaineLocation["z"]+0.35, _U("Cocaine_Text"))
		end
		for k, v in pairs(C.PickLocations) do
			if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), v.x, v.y, v.z, true) <= 5.0 then
				sleep = 5
				DrawMarker(20, v.x, v.y, v.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.8, 0.8, 0.8, 255, 0, 0, 100, 0.0, true, true, 0.0, nil, nil, false)
				LAOT.DrawText3D(v.x, v.y, v.z+0.45, _U("Pick"))
				if IsControlJustPressed(0, 38) then
					PickCocaine()
				end
			end
		end
		Citizen.Wait(sleep)
	end
end)

PickCocaine = function()
	LAOT.Utils.LoadAnimDict(C.Anim["dict"])
	TaskPlayAnim(PlayerPedId(), C.Anim["dict"], C.Anim["name"], 8.0, 1.0, -1, 16, 0, 0, 0, 0 )
	exports["t0sic_loadingbar"]:StartDelayedFunction("Kokaini ezerek çıkartıyorsun", 5000, function()
		ClearPedTasksImmediately(PlayerPedId())
	end)
end