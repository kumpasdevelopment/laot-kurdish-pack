local Keys = {["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118}

ESX = nil
LAOT = nil

local blipsCreated = false
local inStash = false

USER = {}
USER.data = nil

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

RegisterCommand(C.cmd, function()
	if blipsCreated then
		removeBlips()
	else
		createBlips()
	end
end)

RegisterNetEvent('laot-stashouse:Blips')
AddEventHandler('laot-stashouse:Blips', function()
	if blipsCreated then
		removeBlips()
	else
		createBlips()
	end
end)

removeBlips = function()
	for k, v in pairs(C.stashouses) do
		if DoesBlipExist(blip) then
			RemoveBlip(blip)
		end
	end
end

createBlips = function()
	for k, v in pairs(C.stashouses) do
		TriggerServerEvent("laot-stashouse:GetStashouse", v["ID"], false)
		Citizen.Wait(200)
		local randomColour = math.random(0, 25)
		local l = v["loc"]
		blip = AddBlipForCoord(l.x, l.y, l.z)
		SetBlipSprite(blip, 474)
		SetBlipCategory(blip, 10)
		SetBlipDisplay(blip, 4)
		SetBlipScale(blip, 0.7)
		SetBlipColour(blip, randomColour)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		if USER.data.owner == ESX.GetPlayerData().identifier then
			AddTextComponentString("Senin Depon")
			SetBlipScale(blip, 0.85)
		end
		if USER.data.owner and USER.data.owner ~= ESX.GetPlayerData().identifier then
			AddTextComponentString("Alınmış Depo")
		end
		if not USER.data.owner then
			AddTextComponentString("Satılık Depo")
		end
		EndTextCommandSetBlipName(blip)
		Citizen.Wait(100)
	end
	blipsCreated = true
end

RegisterNetEvent('laot-stashouse:ClientStashouse')
AddEventHandler('laot-stashouse:ClientStashouse', function(data, ui)
	local v = C.stashouses[data.houseID]
	USER.data = data

	if ui then
		ToggleGUI(true, { id = data.houseID, pass = data.pass })
	end
end)

RegisterNetEvent('laot-stashouse:Notification')
AddEventHandler('laot-stashouse:Notification', function(type, text)
	LAOT.Notification(type, text)
end)

openAdminMenu = function(data)
	local v = C.stashouses[data.houseID]
	local xData = data

	ESX.TriggerServerCallback('laot-stashouse:HEX', function(identifier)


			ESX.UI.Menu.CloseAll()
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'adminMenu',
			{
				title    = (v["label"] .. ' yönetici'),
				align = 'top-right', -- Menu position
				elements = {
					{ label = ("Şifreyi Değiştir"), name = "pass" },
				}
			},
			function(data, menu)
				if data.current.name then
					if data.current.name == 'pass' then
						menu.close()
						ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'pass',
						{
						  title = ('Şifreyi girin (maks: 4 karakter)')
						},
						function(data, menu2)
							local amount = tonumber(data.value)
							if amount == nil then
								LAOT.Notification("error", "Geçerli bir sayı girin (örn: 1540)")
							elseif amount > 999 and amount < 9999 then
								TriggerServerEvent("laot-stashouse:ChangePass", v["ID"], "pass", amount)
								menu2.close()
							end
						end,
						function(data, menu2)
						  menu2.close()
						end)
					end
				end
			end,
			function(data, menu)
			menu.close()
			openStashMenu(xData)
			end)

	end, GetPlayerServerId(PlayerId()))
end

openStashMenu = function(data)
	local v = C.stashouses[data.houseID]
	local xData = data

	local elements = {}
	ESX.TriggerServerCallback('laot-stashouse:HEX', function(identifier)

		if data.owner then
			if data.owner == identifier then
				table.insert(elements, { label = ("Yönetici Menüsü"), name = "admin" })
			end
			table.insert(elements, { label = ("Depoyu Aç"), name = "enter" })
		else
			table.insert(elements, { label = ("Satın Al - ".. v["price"] .."$"), name = "buy" })
		end

		ESX.UI.Menu.CloseAll()
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'etkilesim',
		{
			title    = (v["label"]),
			align = 'top-right', -- Menu position
			elements = elements
		},
		function(data, menu)
			if data.current.name then
				if data.current.name == 'enter' then
					TriggerServerEvent("laot-stashouse:GetStashouse", v["ID"], true)
				end
				if data.current.name == 'buy' then
					TriggerServerEvent("laot-stashouse:Buy", v["ID"])
				end
				if data.current.name == 'admin' then
					openAdminMenu(xData)
				end
				menu.close()
			end
		end,
		function(data, menu)
		menu.close()
		end)
	end, GetPlayerServerId(PlayerId()))
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if not inStash then
			for k, v in pairs(C.stashouses) do
				local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
				local dst = GetDistanceBetweenCoords(x, y, z, v["loc"].x, v["loc"].y, v["loc"].z, true)

				if dst <= 10 then
					LAOT.DrawText3D(v["loc"].x, v["loc"].y, v["loc"].z, "~b~E~w~ - Depo Etkilesimi")
					if dst <= 2 and IsControlJustPressed(0, Keys["E"]) then
						TriggerServerEvent("laot-stashouse:GetStashouse", v["ID"], false)
						Citizen.Wait(800)
						if USER.data.houseID == v["ID"] then
							openStashMenu(USER.data)
						else
							LAOT.Notification("error", "Bilinmedik hata!")
						end
					end
				end
			end
		else
			Citizen.Wait(3500)
		end
	end
end)


RegisterNUICallback("closeNUI", function(cb)
	ToggleGUI(false)
end)

RegisterNUICallback("openStash", function(data, cb)
	openStash('laot-sh', data.id)
	cb('ok')
end)

openStash = function(type, id)
	local owner = C.stashouses[id]["label"]
	TriggerEvent("disc-inventoryhud:openInventory", {
		["type"] = type,
		["owner"] = owner,
	})
end

function ToggleGUI(explicit_status, data)
    if explicit_status ~= nil then
      isVisible = explicit_status
    else
      isVisible = not isVisible
    end
    SetNuiFocus(isVisible, isVisible)
    SendNUIMessage({
      type = "enable",
      isVisible = isVisible
	})
	if data then
		SendNUIMessage({
			type = "afterEnable",
			id = data.id,
			pass = data.pass
		})
	end
end

