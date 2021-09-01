local Keys = {["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118}

ESX = nil
LAOT = nil

USER = {}
USER.Collecting = false

locations = {
	["domates"] = {},
	["orange"] = {}
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
end)

function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end 

RegisterNetEvent('laot-jobs:Notification')
AddEventHandler('laot-jobs:Notification', function(type, text)
	LAOT.Notification(type, text)
end)

Citizen.CreateThread(function()
	create()
end)

create = function()
	locations["orange"] = {}
	locations["domates"] = {}
	for k, v in pairs(C.Jobs) do
		for k, z in pairs(v["coords"]) do
			if v["name"] == 'domates' then
				if math.random(1,4) > 1 then
					table.insert(locations["domates"],{x=z.x, y=z.y, z=z.z});
				end
			end
			if v["name"] == 'orange' then
				table.insert(locations["orange"],{x=z.x, y=z.y, z=z.z});
			end
		end
	end
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000000)
		create()
	end
end)

collect = function(name, locID)
	if not USER.Collecting then
		FreezeEntityPosition(PlayerPedId(), true)
		local v = C.Jobs[name]
		USER.Collecting = true

		if v["anim"] and v["anim"]["dict"] ~= 'Scenario' then
			loadAnimDict(v["anim"]["dict"])
			--TaskPlayAnim(ped, animDictionary, animationName, blendInSpeed, blendOutSpeed, duration, flag, playbackRate, lockX, lockY, lockZ)
			TaskPlayAnim(PlayerPedId(), v["anim"]["dict"], v["anim"]["name"], 8.0, 1.0, -1, 16, 0, 0, 0, 0 )
		end
		exports["t0sic_loadingbar"]:StartDelayedFunction(_U('collecting'), v["stop"], function()
			TriggerServerEvent("laot-jobs:AddItem", v["name"], v["count"])

			ClearPedTasks(GetPlayerPed(-1))
			USER.Collecting = false
			FreezeEntityPosition(PlayerPedId(), false)
			create()
		end)
	else
		LAOT.Notification("error", "Daha yeni topladın. 2 saniye bekle!")
	end
end

Citizen.CreateThread(function()
	if C.Jobs ~= nil then
		print("Not nil.")
		while true do
			Citizen.Wait(1)
			for k, v in pairs(C.Jobs) do
				for k, z in pairs(locations[v["name"]]) do
					local dst = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), z.x, z.y, z.z, true)
					if dst <= 25 then
						DrawMarker(20, z.x, z.y, z.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.25, 200, 10, 40, 200, 1.0, true, true, 0.0, nil, nil, false)
						if dst <= 0.8 then
							ESX.ShowHelpNotification(('%s '.. _U('press_E_to_pickup')):format(v["label"]))
							if IsControlJustPressed(0, Keys["E"]) then
								collect(v["name"], k)
							end
						end
					end
				end
			end
		end
	else
		LAOT.DebugPrint("laot-jobs: Jobs kısmı boş!")
	end
end)
