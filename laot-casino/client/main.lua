local Keys = {["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118}

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

RegisterNetEvent('laot-casino:notify')
AddEventHandler('laot-casino:notify', function(notify)
    ESX.ShowNotification(notify)
end)

-- made by laot#0101

Citizen.CreateThread(function()
    createPed()
end)

createPed = function()
	for k, v in pairs(CASINO["NPC"]) do
		modelHash = GetHashKey(v.hash)
		RequestModel(modelHash)
		while not HasModelLoaded(modelHash) do
			Wait(1)
		end
		created_ped = CreatePed(0, modelHash, v.coords.x, v.coords.y, v.coords.z, v.coords.h, false)
		FreezeEntityPosition(created_ped, true)
		SetEntityInvincible(created_ped, true)
	end
end

buyChip = function()
	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'buyChips',
	{
	  title = ('Ne kadar çip almak istediğiniz girin')
	},
	function(data, menu)
	  local amount = tonumber(data.value)
	  if amount == nil then
		ESX.ShowNotification('Geçersiz sayı.')
	  else
		menu.close()
		local oyuncu = GetPlayerServerId(PlayerId())
		TriggerServerEvent("laot-casino:buyChip", oyuncu, amount)
	  end
	end,
	function(data, menu)
	  menu.close()
	end)
end

sellChip = function()
	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'sellChips',
	{
	  title = ('Ne kadar çip satmak istediğiniz girin')
	},
	function(data, menu)
	  local amount = tonumber(data.value)
	  if amount == nil then
		ESX.ShowNotification('Geçersiz sayı.')
	  else
		menu.close()
		local oyuncu = GetPlayerServerId(PlayerId())
		TriggerServerEvent("laot-casino:sellChip", oyuncu, amount)
	  end
	end,
	function(data, menu)
	  menu.close()
	end)
end

Citizen.CreateThread(function()
	while true do
		local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))

		local dst = GetDistanceBetweenCoords(x, y, z, CASINO["Markers"]["buy"]["coords"].x, CASINO["Markers"]["buy"]["coords"].y, CASINO["Markers"]["buy"]["coords"].z, true)

		if dst <= 4 then
			if dst <= 4 then
				DrawMarker(20, CASINO["Markers"]["buy"]["coords"], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 10, 50, 200, 200, 1.0, true, true, 0.0, nil, nil, false)
				DrawText3D(CASINO["Markers"]["buy"]["coords"].x, CASINO["Markers"]["buy"]["coords"].y, CASINO["Markers"]["buy"]["coords"].z+0.5, CASINO["Markers"]["buy"]["text"], 0.50)
			end
			if dst <= 1 and IsControlJustReleased(0, Keys["E"]) then
				buyChip()
			end
			Citizen.Wait(0)
		else
			Citizen.Wait(1000)
		end

    end
end)

Citizen.CreateThread(function()
	while true do
		local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))

		local dst = GetDistanceBetweenCoords(x, y, z, CASINO["Markers"]["sell"]["coords"], true)

		if dst <= 4 then
			if dst <= 4 then
				DrawMarker(20, CASINO["Markers"]["sell"]["coords"], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 255, 50, 40, 200, 1.0, true, true, 0.0, nil, nil, false)
				DrawText3D(CASINO["Markers"]["sell"]["coords"].x, CASINO["Markers"]["sell"]["coords"].y, CASINO["Markers"]["sell"]["coords"].z+0.5, CASINO["Markers"]["sell"]["text"], 0.50)
			end
			if dst <= 1 and IsControlJustReleased(0, Keys["E"]) then
				sellChip()
			end
			Citizen.Wait(0)
		else
			Citizen.Wait(1000)
		end

    end
end)


function DrawText3D(x, y, z, text, scale) local onScreen, _x, _y = World3dToScreen2d(x, y, z) local pX, pY, pZ = table.unpack(GetGameplayCamCoords()) SetTextScale(scale, scale) SetTextFont(4) SetTextProportional(1) SetTextEntry("STRING") SetTextCentre(true) SetTextColour(255, 255, 255, 215) AddTextComponentString(text) DrawText(_x, _y) end