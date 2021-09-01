local Keys = {["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118}

ESX = nil
LAOT = nil

MenuPos = {x = 1450, y = 10}

P = {}
P.SelectedPlayer = {}
P.Grade = nil

P.Noclip = false
P.noclipEntity = nil

P.Player_Blips = false
P.Player_Names = false

Editor = {}

CheckPermission = function(perm)
	if P.Grade then
		if C.AdminGrades[P.Grade] then
			if C.AdminGrades[P.Grade][perm] then
				return true
			else
				--LAOT.Notification("error", "#0000: Bunun için yetkiniz yok!")
				return false
			end
		else
			LAOT.Notification("error", "#0002: Çok zararlı bir hata!")
		end
	else
		LAOT.Notification("error", "#0001: Çok zararlı bir hata!")
	end
end

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

function GetNeareastPlayers()
	local playerPed = PlayerPedId()
	local players, _ = ESX.Game.GetPlayersInArea(GetEntityCoords(playerPed), 50)

	local players_clean = {}
	local found_players = false

	for i = 1, #players, 1 do
		found_players = true
		table.insert(players_clean, { playerName = GetPlayerName(players[i]), playerId = GetPlayerServerId(players[i]), coords = GetEntityCoords(GetPlayerPed(players[i])) })
	end
	return players_clean
end

Citizen.CreateThread(function()
	local blips = {}
	local currentPlayer = PlayerId()
	while true do
		Citizen.Wait(2000)
		if P.Player_Blips then
			local players = ESX.Game.GetPlayers()
	
			for k, player in pairs(players) do
				if player ~= currentPlayer and NetworkIsPlayerActive(player) then
					local playerPed = GetPlayerPed(player)
					local playerName = GetPlayerName(player)
	
					RemoveBlip(blips[player])
	
					local new_blip = AddBlipForEntity(playerPed)

					if IsPedInAnyVehicle(playerPed, true) then
						SetBlipSprite(new_blip, 326)
					elseif IsPedInAnyHeli(playerPed) then
						SetBlipSprite(new_blip, 64)
					else
						SetBlipSprite(new_blip, 1)
					end
	
					
					SetBlipNameToPlayerName(new_blip, player)
	
					SetBlipColour(new_blip, 0)
					
					SetBlipCategory(new_blip, 7)
	
					SetBlipScale(new_blip, 0.9)

					SetBlipDisplay(new_blip, 2)
	
					-- Record blip so we don't keep recreating it
					blips[player] = new_blip
				end
			end
		else
			local players = ESX.Game.GetPlayers()
	
			for k, player in pairs(players) do
				if player ~= currentPlayer then
					local playerPed = GetPlayerPed(player)
					local playerName = GetPlayerName(player)
	
					RemoveBlip(blips[player])
				end
			end
			Citizen.Wait(2000)
		end
	end
end)

function Draw3DText1(x, y, z, text)
	-- Check if coords are visible and get 2D screen coords
	local onScreen, _x, _y = World3dToScreen2d(x, y, z)
	if onScreen then
		-- Calculate text scale to use
		local dist = GetDistanceBetweenCoords(GetGameplayCamCoords(), x, y, z, 1)
		local scale = 1.4 * (1 / dist) * (1 / GetGameplayCamFov()) * 100

		-- Draw text on screen
		SetTextScale(scale, scale)
		SetTextFont(4)
		SetTextProportional(1)
		SetTextColour(255, 255, 255, 255)
		SetTextDropShadow(0, 0, 0, 0, 255)
		SetTextDropShadow()
		SetTextEdge(4, 0, 0, 0, 255)
		SetTextOutline()
		SetTextEntry("STRING")
		SetTextCentre(1)
		AddTextComponentString(text)
		DrawText(_x, _y)
	end
end


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if P.Player_Names then
			local nearbyPlayers = GetNeareastPlayers()
			for k, v in pairs(nearbyPlayers) do
				local x, y, z = table.unpack(v.coords)
				Draw3DText1(x, y, z + 1.1, '['.. v.playerId ..'] '.. v.playerName ..'')
			end
		else
			Citizen.Wait(3000)
		end
	end
end)

Citizen.CreateThread(function()

	while LAOT == nil do
		Citizen.Wait(10)
	end

	while ESX == nil do
		Citizen.Wait(10)
	end

	Citizen.Wait(300)

	local discord = LAOT.Utils.GetDiscordID()
	--print(discord)
	for k, v in pairs(C.Admins) do
		if discord == v.id then
			P.Grade = v.grade
			WarMenu.CreateMenu('laot', _U("Menu_Title"), _U("Menu_SubTitle"))
			WarMenu.SetMenuX('laot', 0.77)
			WarMenu.SetMenuY('laot', 0.025)
			WarMenu.SetMenuWidth('laot', 0.22)
			Citizen.Wait(10)
			if CheckPermission("admin") then
				WarMenu.CreateSubMenu('admin_menu', 'laot', 'Admin Menüsü')
				WarMenu.SetMenuX('admin_menu', 0.77)
				WarMenu.SetMenuY('admin_menu', 0.025)
				WarMenu.SetMenuWidth('admin_menu', 0.22)
			end
			if CheckPermission("spectate") then
				WarMenu.CreateSubMenu('players_menu', 'laot', 'Oyuncu Menüsü')
				WarMenu.SetMenuX('players_menu', 0.77)
				WarMenu.SetMenuY('players_menu', 0.025)
				WarMenu.SetMenuWidth('players_menu', 0.22)

				WarMenu.CreateSubMenu('selected_player', 'laot', 'Seçilen Oyuncu')
				WarMenu.SetMenuX('selected_player', 0.77)
				WarMenu.SetMenuY('selected_player', 0.025)
				WarMenu.SetMenuWidth('selected_player', 0.22)
			end
			if CheckPermission("repair") then
				WarMenu.CreateSubMenu('arac_menu', 'laot', 'Araç Menüsü')
				WarMenu.SetMenuX('arac_menu', 0.77)
				WarMenu.SetMenuY('arac_menu', 0.025)
				WarMenu.SetMenuWidth('arac_menu', 0.22)
			end
		end
	end
	

end)

noclipOn = function()
	P.Noclip = true
	local yoff = 0
	local zoff = 0
	local xPed = GetPlayerPed(-1)

	if IsPedInAnyVehicle(xPed, true) then
		P.noclipEntity = GetVehiclePedIsIn(xPed, false)
		SetVehicleEngineOn(P.noclipEntity, false, true, false)
	else
		P.noclipEntity = PlayerPedId()
	end

	SetEntityVelocity(P.noclipEntity, 0, 0, 0)
	
	SetEntityCollision(P.noclipEntity, false, false)
	FreezeEntityPosition(P.noclipEntity, true)
	SetEntityInvincible(P.noclipEntity, true)

	SetEveryoneIgnorePlayer(P.noclipEntity, true)
	SetPoliceIgnorePlayer(P.noclipEntity, true)

	SetEntityVisible(P.noclipEntity, false, false)

	local playerPed = GetPlayerPed(-1)

	if not DoesCamExist(Editor.Cam) then
	  Editor.Cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
	end

	SetCamActive(Editor.Cam, true)
	RenderScriptCams(true, false, 0, true, true)

	local coords = GetEntityCoords(playerPed)

		SetCamCoord(Editor.Cam, coords.x, coords.y, coords.z)
		SetCamRot(Editor.Cam, 0.0, 0.0, 0.0)

		SetEntityCollision(playerPed, false, false)
	  SetEntityVisible(playerPed, false)

	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(0)
			if P.Noclip then
				ESX.ShowHelpNotification("~b~~INPUT_SPRINT~ Hızlandır\n~r~~INPUT_CHARACTER_WHEEL~ Yavaşla")
				SetEntityVisible(P.noclipEntity, false, false)

				local camCoords              = GetCamCoord(Editor.Cam)
				local right, forward, up, at = GetCamMatrix(Editor.Cam)
				local speedMultiplier        = nil
			
				if IsControlPressed(0, Keys['LEFTSHIFT']) then
					speedMultiplier = 8.0
				elseif IsControlPressed(0, Keys['LEFTALT']) then
					speedMultiplier = 0.025
				else
					speedMultiplier = 0.25
				end
			
				if IsControlPressed(0, Keys['W']) then
					local newCamPos = camCoords + forward * speedMultiplier
					SetCamCoord(Editor.Cam, newCamPos.x, newCamPos.y, newCamPos.z)
					SetEntityCoords(P.noclipEntity, newCamPos.x, newCamPos.y, newCamPos.z, 0.0,0.0,0.0, false)
				end
			
				if IsControlPressed(0, Keys['S']) then
					local newCamPos = camCoords + forward * -speedMultiplier
					SetCamCoord(Editor.Cam, newCamPos.x, newCamPos.y, newCamPos.z)
					SetEntityCoords(P.noclipEntity, newCamPos.x, newCamPos.y, newCamPos.z, 0.0,0.0,0.0, false)
				end
			
				if IsControlPressed(0, Keys['A']) then
					local newCamPos = camCoords + right * -speedMultiplier
					SetCamCoord(Editor.Cam, newCamPos.x, newCamPos.y, newCamPos.z)
					SetEntityCoords(P.noclipEntity, newCamPos.x, newCamPos.y, newCamPos.z, 0.0,0.0,0.0, false)
				end
			
				if IsControlPressed(0, Keys['D']) then
					local newCamPos = camCoords + right * speedMultiplier
					SetCamCoord(Editor.Cam, newCamPos.x, newCamPos.y, newCamPos.z)
					SetEntityCoords(P.noclipEntity, newCamPos.x, newCamPos.y, newCamPos.z, 0.0,0.0,0.0, false)
				end
			
				local xMagnitude = GetDisabledControlNormal(0,  1);
				local yMagnitude = GetDisabledControlNormal(0,  2);
				local camRot     = GetCamRot(Editor.Cam)
			
				local x = camRot.x - yMagnitude * 10
				local y = camRot.y
				local z = camRot.z - xMagnitude * 10
			
				if x < -75.0 then
					x = -75.0
				end
			
				if x > 100.0 then
					x = 100.0
				end
			
				SetCamRot(Editor.Cam, x, y, z)
			else
				Citizen.Wait(1000)
			end
		end
	end)
end

noclipOff = function()
	P.Noclip = false
	local yoff = 0
	local zoff = 0

	local camCoords = GetCamCoord(Editor.Cam)

	SetCamActive(Editor.Cam, false)
	RenderScriptCams(false, false, 0, true, true)

	SetEntityVisible(P.noclipEntity, true, 0)
	SetEntityCollision(P.noclipEntity, true, 0)

	FreezeEntityPosition(P.noclipEntity, false)
	SetEntityInvincible(P.noclipEntity, false)

	SetEntityVisible(P.noclipEntity, true, false)
	SetLocalPlayerVisibleLocally(true)
	ResetEntityAlpha(P.noclipEntity)

	SetEveryoneIgnorePlayer(P.noclipEntity, false)
	SetPoliceIgnorePlayer(P.noclipEntity, false)

	SetEntityCoords(P.noclipEntity, camCoords.x, camCoords.y, camCoords.z)

end

RegisterNetEvent('laot-admin:Kill')
AddEventHandler('laot-admin:Kill', function()
	SetEntityHealth(PlayerPedId(), 0)
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsControlJustPressed(0, C.NoclipKey) then
			local discord = LAOT.Utils.GetDiscordID()
			--print(discord)
			for k, v in pairs(C.Admins) do
				if discord == v.id and CheckPermission("noclip") then
					if not P.Noclip then
						noclipOn()
					else
						noclipOff()
					end
				end
			end
		end
	end
end)

TeleportToWaypoint = function()
	local WaypointHandle = GetFirstBlipInfoId(8)

	if DoesBlipExist(WaypointHandle) then
		local waypointCoords = GetBlipInfoIdCoord(WaypointHandle)

		for height = 1, 1000 do
			SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)

			local foundGround, zPos = GetGroundZFor_3dCoord(waypointCoords["x"], waypointCoords["y"], height + 0.0)

			if foundGround then
				SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)

				break
			end

			Citizen.Wait(5)
		end

		exports['mythic_notify']:SendAlert('inform', 'Belirtilen bölgeye ışınlandın')
	else
		exports['mythic_notify']:SendAlert('error', 'Işınlanacak yeri seçmedin')
	end
end

RegisterNetEvent('laot-admin:client:BringPlayer')
AddEventHandler('laot-admin:client:BringPlayer', function(target)
	if target then
		SetEntityCoords(PlayerPedId(), GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(target))))
    end
end)

RegisterNetEvent('laot-admin:client:DM')
AddEventHandler('laot-admin:client:DM', function(text)
	if text then
		LAOT.DrawSub(text, 2500)
		for i=1, 5 do
			PlaySoundFrontend(-1, "TIMER_STOP", "HUD_MINI_GAME_SOUNDSET", 1)
			Citizen.Wait(1000)
		end
    end
end)

Citizen.CreateThread(function()
	while true do
		if P.Grade then
			if IsControlJustPressed(0, C.AdminMenuKey) then
				local discord = LAOT.Utils.GetDiscordID()
				--print(discord)
				for k, v in pairs(C.Admins) do
					if discord == v.id then
						P.Grade = v.grade
						WarMenu.OpenMenu('laot')
					end
				end
			end
			if WarMenu.IsMenuOpened('laot') then
				if WarMenu.MenuButton('Admin Menüsü', 'admin_menu') then
					WarMenu.OpenMenu('admin_menu')
				end
				if WarMenu.MenuButton('Oyuncu Menüsü', 'players_menu') then
					WarMenu.OpenMenu('players_menu')
				end
				if WarMenu.MenuButton('Araç Menüsü', 'arac_menu') then
					WarMenu.OpenMenu('arac_menu')
				end
				WarMenu.Display()
			end
			if WarMenu.IsMenuOpened('admin_menu') then
				if CheckPermission("player_blips") then
					if WarMenu.CheckBox("Oyuncu Blipleri", P.Player_Blips, function(checked)
						if CheckPermission("player_blips") then
							P.Player_Blips = checked
						end
					end) then
					end
				end
				if WarMenu.CheckBox("Oyuncu İsimleri", P.Player_Names, function(checked)
					if CheckPermission("player_names") then
						P.Player_Names = checked
					end
				end) then
				end
				if WarMenu.Button("Alanı Temizle") then
					if CheckPermission("clear_area") then
						DisplayOnscreenKeyboard(1, 'FMMC_KEY_TIP8', '', '', '', '', '', 64+1)
						while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
						  Citizen.Wait(0)
						end
						local result = GetOnscreenKeyboardResult()
						if result then
							--ClearArea(result)
							local coords = GetEntityCoords(GetPlayerPed(-1), true)
							local Vehicles = ESX.Game.GetVehiclesInArea(coords, tonumber(result))
							for i=1, #Vehicles do
								ESX.Game.DeleteVehicle(Vehicles[i])
							end
						end
					end
				end
				if WarMenu.Button("Kendini Canlandır ~g~[Revive]") then
					TriggerEvent("esx_ambulancejob:revive")
				end
				if WarMenu.Button("Haritada Seçtiğin Yere Git ~g~[/tpm]") then
					TeleportToWaypoint()
				end
				WarMenu.Display()
			end
			
			if WarMenu.IsMenuOpened('players_menu') then
				local online = 0

				local players = ESX.Game.GetPlayers()
		
				for k, player in pairs(players) do
					local playerPed = GetPlayerPed(player)
					local playerName = GetPlayerName(player)
					local id = GetPlayerServerId(player)
					online = online + 1

					if WarMenu.Button("["..id.."] "..playerName) then
						P.SelectedPlayer = {ped = playerPed , id = id, playerName = playerName}
						WarMenu.OpenMenu('selected_player')
					end
				end
				WarMenu.Display()
			end

			if WarMenu.IsMenuOpened('arac_menu') then
				if WarMenu.Button("Araçı Tamir Et") then
					if IsPedInAnyVehicle(PlayerPedId(), true) then
						local vehicle = GetVehiclePedIsIn(PlayerPedId(), true)
						SetVehicleEngineHealth(vehicle, 1000)
						SetVehicleEngineOn(vehicle, true, true )
						SetVehicleFixed(vehicle)
					else
						LAOT.Notification("error", "Araçta değilsiniz.")
					end
				end
				if WarMenu.Button("Mekanik Menüsü Aç") then
					TriggerEvent("laot-admin:client:OpenLS")
					WarMenu.CloseMenu()
				end
				WarMenu.Display()
			end

			if WarMenu.IsMenuOpened('selected_player') then
				if P.SelectedPlayer.id then
					if WarMenu.Button("Oyuncuyu İzle") then
						spectate(P.SelectedPlayer.id)
					end
					if CheckPermission("envanter") then
						if WarMenu.Button("Envanterini Görüntüle") then
							TriggerEvent("laot-discinventoryhud:uzaktanara", P.SelectedPlayer.id)
						end
					end
					if CheckPermission("bring") then
						if WarMenu.Button("Yanına Çek") then
							TriggerServerEvent("laot-admin:server:BringPlayer", P.SelectedPlayer.id, GetPlayerServerId(PlayerId()))
						end
					end
					if CheckPermission("bring") then
						if WarMenu.Button("Yanına Git") then
							SetEntityCoords(PlayerPedId(), GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(P.SelectedPlayer.id))))
						end
					end
					if CheckPermission("envanter") then
						if WarMenu.Button("İtem Ver") then

							ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'item',
							{
							  title = ('İtem ismini girin')
							},
							function(data, menu)
								local item = data.value
								if item then
									menu.close()
									ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'amount',
									{
									  title = ('Adet girin')
									},
									function(data, menu2)
										local amount = tonumber(data.value)
										if amount == nil then
											LAOT.Notification("error", "Geçerli bir sayı girin (örn: 1540)")
										elseif amount then
											TriggerServerEvent("laot-admin:server:GiveItem", P.SelectedPlayer.id, item, amount)
											menu2.close()
										end
									end,
									function(data, menu2)
									  menu2.close()
									end)
								end
							end,
							function(data, menu)
							  menu.close()
							end)

						end
					end
					if WarMenu.Button("Özel Mesaj Gönder") then
						ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'ozelmesaj',
						{
							title = ('Mesajı girin')
						},
						function(data, menu)
							local text = data.value
							if text then
								TriggerServerEvent("laot-admin:server:DM", P.SelectedPlayer.id, text)
								WarMenu.OpenMenu('selected_player')
							end
							menu.close()
						end,
						function(data, menu)
							menu.close()
						end)
					end
					if CheckPermission("skinmenu") then
						if WarMenu.Button("Skin Menüsü Açtır ~o~[Kıyafet]") then
							TriggerServerEvent("laot-admin:server:SkinMenu", P.SelectedPlayer.id, "clothes")
						end
						if WarMenu.Button("Skin Menüsü Açtır ~o~[Tüm Vücut]") then
							TriggerServerEvent("laot-admin:server:SkinMenu", P.SelectedPlayer.id, "admin")
						end
					end
					if CheckPermission("slay") then
						if WarMenu.Button("Öldür") then
							TriggerServerEvent("laot-admin:server:Kill", P.SelectedPlayer.id)
						end
					end
					if CheckPermission("kick") then
						if WarMenu.Button("Kişiyi Kickle") then
							DisplayOnscreenKeyboard(1, 'FMMC_KEY_TIP8', '', '', '', '', '', 128+1)
							while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
							  Citizen.Wait(0)
							end
							local result = GetOnscreenKeyboardResult()
							if result then
								TriggerServerEvent("laot-admin:server:Kick", P.SelectedPlayer.id, result)
								WarMenu.OpenMenu('laot')
							end
						end
					end
					if CheckPermission("ban") then
						if WarMenu.Button("~r~Perma Ban") then
							DisplayOnscreenKeyboard(1, 'FMMC_KEY_TIP8', '', '', '', '', '', 128+1)
							while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
							  Citizen.Wait(0)
							end
							local result = GetOnscreenKeyboardResult()
							if result then
								TriggerServerEvent("laot-admin:server:PermaBan", P.SelectedPlayer.id, result)
								TriggerServerEvent("laot-admin:server:Kick", P.SelectedPlayer.id, result)
								WarMenu.OpenMenu('laot')
							end
						end
					end
				end
				WarMenu.Display()
			end
		else
			Citizen.Wait(1500)
		end
		Citizen.Wait(0)
	end
end)
