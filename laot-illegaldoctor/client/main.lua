local Keys = {["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118}

ESX = nil
LAOT = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
	while LAOT == nil do
		TriggerEvent('laot:getSharedObject', function(obj) LAOT = obj end)
		Citizen.Wait(1000)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
end)

Citizen.CreateThread(function()
	while LAOT == nil do Citizen.Wait(100) end
	model = LAOT.Utils.LoadModel(C.settings["NPC"]["hash"])
	createPeds()
end)

createPeds = function()
	NPC = CreatePed(0, model, C.settings["NPC"]["coords"].x, C.settings["NPC"]["coords"].y, C.settings["NPC"]["coords"].z, C.settings["NPC"]["coords"].h, false)
    FreezeEntityPosition(NPC, true)
	SetEntityInvincible(NPC, true)
	SetBlockingOfNonTemporaryEvents(NPC, true)
end
--[[
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
		local retval = GetDistanceBetweenCoords(x, y, z, C.settings["outside"].x, C.settings["outside"].y, C.settings["outside"].z, true)
		
		if retval <= 3 then
			LAOT.DrawText3D(C.settings["outside"].x, C.settings["outside"].y, C.settings["outside"].z, l["enter"])
			if IsControlJustPressed(0, Keys["E"]) then
				local ply = GetPlayerServerId(PlayerId())
				local entity = GetPlayerFromServerId(ply)

				DoScreenFadeOut(2000)
				Citizen.Wait(2000)
				
				StartPlayerTeleport(entity, C.settings["inside"].x, C.settings["inside"].y, C.settings["inside"].z, C.settings["inside"].h, false, true, false)
				
				Citizen.Wait(2000)
				DoScreenFadeIn(2000)
			end
		else
			Citizen.Wait(2000)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
		local retval = GetDistanceBetweenCoords(x, y, z, C.settings["inside"].x, C.settings["inside"].y, C.settings["inside"].z, true)
		
		if retval <= 3 then
			LAOT.DrawText3D(C.settings["inside"].x, C.settings["inside"].y, C.settings["inside"].z, l["leave"])
			if IsControlJustPressed(0, Keys["E"]) then
				local ply = GetPlayerServerId(PlayerId())
				local entity = GetPlayerFromServerId(ply)

				DoScreenFadeOut(2000)
				Citizen.Wait(2000)
				
				StartPlayerTeleport(entity, C.settings["outside"].x, C.settings["outside"].y, C.settings["outside"].z, C.settings["outside"].h, false, true, false)
				
				Citizen.Wait(2000)
				DoScreenFadeIn(2000)
			end
		else
			Citizen.Wait(2000)
		end
	end
end)
]]
RegisterNetEvent('laot-illegaldoctor:cashError')
AddEventHandler('laot-illegaldoctor:cashError', function()
	LAOT.Notification("error", "Yeterli paranız yok!")
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
		local retval = GetDistanceBetweenCoords(x, y, z, C.settings["NPC"]["coords"].x, C.settings["NPC"]["coords"].y, C.settings["NPC"]["coords"].z, true)
		
		if retval <= 3 then
			ESX.ShowHelpNotification("~r~70$ ~w~ödeyerek iyileşmek için ~INPUT_PICKUP~ basın.")
			if IsControlJustPressed(0, Keys["E"]) then
				TriggerServerEvent("laot-illegaldoctor:RemoveItem")
			end
		else
			Citizen.Wait(2000)
		end
	end
end)