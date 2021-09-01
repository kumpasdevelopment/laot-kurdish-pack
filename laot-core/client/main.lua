local Keys = {["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118}

ESX = nil

version = 1.0
selectingSpeed = false

playerLoaded = false

ADMIN = {}
TEXT = {}
user = {}

user.freeze = false

TEXT.off 		     = "<span style='color: #C42C49;'>Kapalı</span>"
TEXT.on              = "<span style='color: #13E592;'>Açık</span>"
ADMIN.grade 		 = 0
ADMIN.player_blips   = false
ADMIN.player_names   = false
ADMIN.noclip 	   	 = false
ADMIN.noclipSpeed	 = 0
ADMIN.maxNoclipSpeed = 6

Editor = {}

ADMIN.noclipEntity = nil

ADMIN.noclipSpeedS   = {
	[0] = { s = 0.01, t = "Aşırı Yavaş" },
	[1] = { s = 0.3, t = "Yavaş" },
	[2] = { s = 2.0, t = "Normal" },
	[3] = { s = 6.0, t = "Hızlı" },
	[4] = { s = 7.0, t = "Aşırı Hızlı" },
	[5] = { s = 15.0, t = "Maksimum Hız" },
	[6] = { s = 35.0, t = "NASI KALKIYO?!" },
}

ADMIN.selectedPlayer = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
	
	playerLoaded = true
	TriggerServerEvent("laot-core:PlayerJoin")
	timer = afkkick
end)

Citizen.CreateThread(function()
	TriggerServerEvent("laot-core:PlayerJoin")
end)

function ShowNotification(text)
    SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, false)
end

RegisterNetEvent('laot-core:PlayerJoinClient')
AddEventHandler('laot-core:PlayerJoinClient', function(playerName)
	ShowNotification("~g~".. playerName .." ~w~oyuna bağlandı.")
end)

RegisterNetEvent('laot-core:HackerUse')
AddEventHandler('laot-core:HackerUse', function()
    TriggerEvent("utk_fingerprint:Start", 2, 2, 5, bankAdd)
end)

bankAdd = function()
    TriggerServerEvent("laot-core:HackAddBank")
end

local mp_pointing = false
local keyPressed = false

local function startPointing()
    local ped = GetPlayerPed(-1)
    RequestAnimDict("anim@mp_point")
    while not HasAnimDictLoaded("anim@mp_point") do
        Wait(0)
    end
    SetPedCurrentWeaponVisible(ped, 0, 1, 1, 1)
    SetPedConfigFlag(ped, 36, 1)
    Citizen.InvokeNative(0x2D537BA194896636, ped, "task_mp_pointing", 0.5, 0, "anim@mp_point", 24)
    RemoveAnimDict("anim@mp_point")
end

local function stopPointing()
    local ped = GetPlayerPed(-1)
    Citizen.InvokeNative(0xD01015C7316AE176, ped, "Stop")
    if not IsPedInjured(ped) then
        ClearPedSecondaryTask(ped)
    end
    if not IsPedInAnyVehicle(ped, 1) then
        SetPedCurrentWeaponVisible(ped, 1, 1, 1, 1)
    end
    SetPedConfigFlag(ped, 36, 0)
    ClearPedSecondaryTask(PlayerPedId())
end

local once = true
local oldval = false
local oldvalped = false

Citizen.CreateThread(function()
    while true do
        Wait(0)

        if once then
            once = false
        end

        if not keyPressed then
            if IsControlPressed(0, 29) and not mp_pointing and IsPedOnFoot(PlayerPedId()) then
                Wait(200)
                if not IsControlPressed(0, 29) then
                    keyPressed = true
                    startPointing()
                    mp_pointing = true
                else
                    keyPressed = true
                    while IsControlPressed(0, 29) do
                        Wait(50)
                    end
                end
            elseif (IsControlPressed(0, 29) and mp_pointing) or (not IsPedOnFoot(PlayerPedId()) and mp_pointing) then
                keyPressed = true
                mp_pointing = false
                stopPointing()
            end
        end

        if keyPressed then
            if not IsControlPressed(0, 29) then
                keyPressed = false
            end
        end
        if Citizen.InvokeNative(0x921CE12C489C4C41, PlayerPedId()) and not mp_pointing then
            stopPointing()
        end
        if Citizen.InvokeNative(0x921CE12C489C4C41, PlayerPedId()) then
            if not IsPedOnFoot(PlayerPedId()) then
                stopPointing()
            else
                local ped = GetPlayerPed(-1)
                local camPitch = GetGameplayCamRelativePitch()
                if camPitch < -70.0 then
                    camPitch = -70.0
                elseif camPitch > 42.0 then
                    camPitch = 42.0
                end
                camPitch = (camPitch + 70.0) / 112.0

                local camHeading = GetGameplayCamRelativeHeading()
                local cosCamHeading = Cos(camHeading)
                local sinCamHeading = Sin(camHeading)
                if camHeading < -180.0 then
                    camHeading = -180.0
                elseif camHeading > 180.0 then
                    camHeading = 180.0
                end
                camHeading = (camHeading + 180.0) / 360.0

                local blocked = 0
                local nn = 0

                local coords = GetOffsetFromEntityInWorldCoords(ped, (cosCamHeading * -0.2) - (sinCamHeading * (0.4 * camHeading + 0.3)), (sinCamHeading * -0.2) + (cosCamHeading * (0.4 * camHeading + 0.3)), 0.6)
                local ray = Cast_3dRayPointToPoint(coords.x, coords.y, coords.z - 0.2, coords.x, coords.y, coords.z + 0.2, 0.4, 95, ped, 7);
                nn,blocked,coords,coords = GetRaycastResult(ray)

                Citizen.InvokeNative(0xD5BB4025AE449A4E, ped, "Pitch", camPitch)
                Citizen.InvokeNative(0xD5BB4025AE449A4E, ped, "Heading", camHeading * -1.0 + 1.0)
                Citizen.InvokeNative(0xB0A6CFD2C69C1088, ped, "isBlocked", blocked)
                Citizen.InvokeNative(0xB0A6CFD2C69C1088, ped, "isFirstPerson", Citizen.InvokeNative(0xEE778F8C7E1142E2, Citizen.InvokeNative(0x19CAFA3C87F7C2FF)) == 4)

            end
        end
    end
end)


-- ZAR ATMA
RegisterCommand("zarat", function()
    local sans
    sans = math.random(1, 12)
    loadAnimDict("anim@mp_player_intcelebrationmale@wank")
    TaskPlayAnim(GetPlayerPed(-1), "anim@mp_player_intcelebrationmale@wank", "wank", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
    Citizen.Wait(1500)
    ClearPedTasks(GetPlayerPed(-1))
    TriggerServerEvent('3dme:shareDisplay', "Attığı zar ".. sans .." gelmiştir. (🎲)")
    TriggerServerEvent('3dme:chat', "Attığı zar ".. sans .." gelmiştir. (🎲)")
end)

RegisterCommand("tombalazarat", function()
    local sans
    sans = math.random(1, 100)
    loadAnimDict("anim@mp_player_intcelebrationmale@wank")
    TaskPlayAnim(GetPlayerPed(-1), "anim@mp_player_intcelebrationmale@wank", "wank", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
    Citizen.Wait(1500)
    ClearPedTasks(GetPlayerPed(-1))
    TriggerServerEvent('3dme:shareDisplay', "Attığı tombala zarı ".. sans .." gelmiştir. (🎲)")
    TriggerServerEvent('3dme:chat', "Attığı tombala zarı ".. sans .." gelmiştir. (🎲)")
end)

function loadAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict( dict )
        Citizen.Wait(5)
    end
end

-- Blip oluşturucu
--[[ laot#7490 ]]--

Citizen.CreateThread(function()
    for _, info in pairs(Blips) do
      info.blip = AddBlipForCoord(info.x, info.y, info.z)
      SetBlipSprite(info.blip, info.id)
      SetBlipDisplay(info.blip, 4)
      SetBlipScale(info.blip, info.scale)
      SetBlipColour(info.blip, info.colour)
      SetBlipAsShortRange(info.blip, true)
	    BeginTextCommandSetBlipName("STRING")
      AddTextComponentString(info.title)
      EndTextCommandSetBlipName(info.blip)
    end
end)

--[[

local afkkick = 500

local timer = 0

local POS1 = nil
local POS2 = nil
local HEAD1 = nil
local HEAD2 = nil

Citizen.CreateThread(function()
	timer = afkkick
	while true do
		Citizen.Wait(1000)
		--if playerLoaded then
			POS1 = GetEntityCoords(GetPlayerPed(-1))
			HEAD1 = GetEntityHeading(GetPlayerPed(-1))

			if POS1 == POS2 and HEAD1 == HEAD2 then
				if timer > 0 then
					if timer == (afkkick / 5) then
						TriggerEvent("chat:addMessage", {
					
							template = '<div class="chat-message server"> [AFK]: {0}</div>',
							args = {"AFK Kontrolü: /afk yazmalısınız."}
					
						})
					end

					timer = timer - 1
				else
					TriggerServerEvent("kickForAfk")
				end
			else
				timer = afkkick
			end

			POS2 = GetEntityCoords(GetPlayerPed(-1))
			HEAD2 = GetEntityHeading(GetPlayerPed(-1))
		--end
	end
end)


RegisterCommand("afk", function()
    timer = afkkick

    TriggerEvent("chat:addMessage", {

        template = '<div class="chat-message"> [AFK]: {0}</div>',
        args = {"Afk kontrolü başarılı!"}

    })
end) 
--]]

-- Çete blips

blips = {
    {id = "green", x= -72.41, y = -1567.95, z = 31.1, width = 300.0, height = 100.0, color = 2, rotation = 200.4},
    {id = "ballas", x= 7.95, y = -1860.03, z = 24.84, width = 100.0, height = 345.0, color = 7, rotation = 195.88},
    {id = "aztecas", x= 181.9953, y = -1676.13, z = 29.778, width = 100.0, height = 345.0, color = 3, rotation = 195.88},
	{id = "vagos", x= 327.0, y = -2033.47, z = 20.94, width = 250.0, height = 250.0, color = 5, rotation = 195.78}, -- color 46 sarı
	{id = "bloods", x = 1292.311, y = -1727.68, z = 53.601, width = 100.0, height = 150.0, color = 1, rotation = 293.99},
	{id = "marabunta", x = 1251.585, y = -1602.81, z = 53.072, width = 120.0, height = 125.0, color = 29, rotation = -43.244}
}

Citizen.CreateThread(function()
    for i = 1, #blips, 1 do
        local blip = AddBlipForArea(blips[i].x, blips[i].y, blips[i].z, blips[i].width, blips[i].height)
        SetBlipAlpha(blip, 75)
        SetBlipColour(blip, blips[i].color)
        SetBlipRotation(blip, blips[i].rotation)
        SetBlipDisplay(blip, 8)
        SetBlipAsShortRange(blip, true)
    end
end)

Citizen.CreateThread(function()
	SetPedSuffersCriticalHits(PlayerPedId(), false)
	while true do
		Citizen.Wait(5000)
		SetPedSuffersCriticalHits(PlayerPedId(), false)
	end
end)

-- Hasar ayarları

-- Ragdoll

local ragdoled = false

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(0)

        if IsControlPressed(0, Keys["U"]) then
            ragdoled = true
            if IsPedInAnyVehicle(GetPlayerPed(), false) then
                ragdoled = false
                ESX.ShowNotification("~r~HATA~w~ Sadece ayaklarının üstünde bayılabilirsin!")
                end
            end
                 
        if ragdoled == true then
            SetPedToRagdoll(GetPlayerPed(-1), 1000, 1000, 0, 0, 0, 0)
            ESX.ShowHelpNotification("Ayağa kalmak için ~INPUT_PICKUP~ basınız.")

            if IsControlJustPressed(0, Keys['E']) then
                ragdoled = false
            end
        end
    end
end)

-- El kaldırma

local canHandsUp = true

AddEventHandler('handsup:toggle', function(param)
	canHandsUp = param
end)

Citizen.CreateThread(function()
	local handsup = false

	while true do
		Citizen.Wait(0)

		if canHandsUp then
			if IsControlJustReleased(0, Keys['X']) then
				local playerPed = PlayerPedId()

				RequestAnimDict('random@mugging3')
				while not HasAnimDictLoaded('random@mugging3') do
					Citizen.Wait(100)
				end

				if handsup then
					handsup = false
					ClearPedSecondaryTask(playerPed)
					TriggerServerEvent('esx_thief:update', handsup)
				else
					handsup = true
					TaskPlayAnim(playerPed, 'random@mugging3', 'handsup_standing_base', 6.0, -6.0, -1, 49, 0, 0, 0, 0)
					TriggerServerEvent('esx_thief:update', handsup)
				end
			end
		end
	end
end)

-- LAOT ADMIN MENU --
if LAOT.adminMenu then

	Citizen.CreateThread(function()
		local blips = {}
		local currentPlayer = PlayerId()
		while true do
			Citizen.Wait(2000)
			if ADMIN.player_blips then
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
				Citizen.Wait(1000)
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
			if ADMIN.player_names then
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

	Editor.CamRayCast = function(cam, ignore)

		local ignore                 = ignore or GetPlayerPed(-1)
		local camCoords              = GetCamCoord(cam)
		local right, forward, up, at = GetCamMatrix(cam)
		local forwardCoords          = camCoords + forward * 1000.0
		local rayHandle              = CastRayPointToPoint(camCoords.x, camCoords.y, camCoords.z, forwardCoords.x, forwardCoords.y, forwardCoords.z, -1, ignore,  0)
		
		return GetRaycastResult(rayHandle)
	end

	noclipOn = function()
		ADMIN.noclip = true
		ADMIN.noclipSpeed = 0
		local yoff = 0
		local zoff = 0
		local xPed = GetPlayerPed(-1)

		if IsPedInAnyVehicle(xPed, true) then
			ADMIN.noclipEntity = GetVehiclePedIsIn(xPed, false)
			SetVehicleEngineOn(ADMIN.noclipEntity, false, true, false)
		else
			ADMIN.noclipEntity = PlayerPedId()
		end

		SetEntityVelocity(ADMIN.noclipEntity, 0, 0, 0)
		
		SetEntityCollision(ADMIN.noclipEntity, false, false)
		FreezeEntityPosition(ADMIN.noclipEntity, true)
		SetEntityInvincible(ADMIN.noclipEntity, true)

		SetEveryoneIgnorePlayer(ADMIN.noclipEntity, true)
		SetPoliceIgnorePlayer(ADMIN.noclipEntity, true)

		SetEntityVisible(ADMIN.noclipEntity, false, false)

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
				if ADMIN.noclip then
					ESX.ShowHelpNotification("~b~~INPUT_SPRINT~ Hızlandır\n~r~~INPUT_CHARACTER_WHEEL~ Yavaşla")
					SetEntityVisible(ADMIN.noclipEntity, false, false)

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
						SetEntityCoords(ADMIN.noclipEntity, newCamPos.x, newCamPos.y, newCamPos.z, 0.0,0.0,0.0, false)
					end
				
					if IsControlPressed(0, Keys['S']) then
						local newCamPos = camCoords + forward * -speedMultiplier
						SetCamCoord(Editor.Cam, newCamPos.x, newCamPos.y, newCamPos.z)
						SetEntityCoords(ADMIN.noclipEntity, newCamPos.x, newCamPos.y, newCamPos.z, 0.0,0.0,0.0, false)
					end
				
					if IsControlPressed(0, Keys['A']) then
						local newCamPos = camCoords + right * -speedMultiplier
						SetCamCoord(Editor.Cam, newCamPos.x, newCamPos.y, newCamPos.z)
						SetEntityCoords(ADMIN.noclipEntity, newCamPos.x, newCamPos.y, newCamPos.z, 0.0,0.0,0.0, false)
					end
				
					if IsControlPressed(0, Keys['D']) then
						local newCamPos = camCoords + right * speedMultiplier
						SetCamCoord(Editor.Cam, newCamPos.x, newCamPos.y, newCamPos.z)
						SetEntityCoords(ADMIN.noclipEntity, newCamPos.x, newCamPos.y, newCamPos.z, 0.0,0.0,0.0, false)
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

					--[[local yoff = 0
					local zoff = 0
					local heading = GetEntityHeading(ADMIN.noclipEntity)
					ESX.ShowHelpNotification("~INPUT_SPRINT~ Hızlandır ~b~[".. ADMIN.noclipSpeedS[ADMIN.noclipSpeed].t .."]~w~\n~INPUT_COVER~ ~INPUT_HUD_SPECIAL~ Yüksel/İn\n~INPUT_MOVE_UP_ONLY~ ~INPUT_MOVE_LEFT_ONLY~ ~INPUT_MOVE_DOWN_ONLY~ ~INPUT_MOVE_RIGHT_ONLY~ Hareket Et\n\n~INPUT_VEH_FLY_ATTACK_CAMERA~ Noclip Kapat")
					if IsDisabledControlPressed(0, 32) then
						yoff = 0.5
					end
					if IsDisabledControlPressed(0, 33) then
						yoff = -0.5
					end
					if IsDisabledControlPressed(0, 34) then
						SetEntityHeading(ADMIN.noclipEntity, heading + 2.0)
					end
					if IsDisabledControlPressed(0, 35) then
						SetEntityHeading(ADMIN.noclipEntity, heading - 2.0)
					end
					if IsDisabledControlPressed(0, 44) then
						zoff = 0.21
					end
					if IsDisabledControlPressed(0, 48) then
						zoff = -0.21
					end
					if IsDisabledControlJustPressed(0, 155) then
						if not selectingSpeed then
							selectingSpeed = true
							ADMIN.noclipSpeed = ADMIN.noclipSpeed + 1
							if ADMIN.noclipSpeed > ADMIN.maxNoclipSpeed then
								ADMIN.noclipSpeed = 0
							end
							Wait(100)
							selectingSpeed = false
						end
					end
					local newPos = GetOffsetFromEntityInWorldCoords(ADMIN.noclipEntity, 0, yoff * (ADMIN.noclipSpeedS[ADMIN.noclipSpeed].s + 0.3), zoff * (ADMIN.noclipSpeedS[ADMIN.noclipSpeed].s + 0.3))
					
					SetEntityCoordsNoOffset(ADMIN.noclipEntity, newPos.x, newPos.y, newPos.z, true, true, true)--]]
				else
					Citizen.Wait(1000)
				end
			end
		end)
	end

	noclipOff = function()
		ADMIN.noclip = false
		ADMIN.noclipSpeed = 0
		local yoff = 0
		local zoff = 0

		local camCoords = GetCamCoord(Editor.Cam)

		SetCamActive(Editor.Cam, false)
		RenderScriptCams(false, false, 0, true, true)

		SetEntityVisible(ADMIN.noclipEntity, true, 0)
		SetEntityCollision(ADMIN.noclipEntity, true, 0)

		FreezeEntityPosition(ADMIN.noclipEntity, false)
		SetEntityInvincible(ADMIN.noclipEntity, false)

		SetEntityVisible(ADMIN.noclipEntity, true, false)
		SetLocalPlayerVisibleLocally(true)
		ResetEntityAlpha(ADMIN.noclipEntity)

		SetEveryoneIgnorePlayer(ADMIN.noclipEntity, false)
		SetPoliceIgnorePlayer(ADMIN.noclipEntity, false)

		SetEntityCoords(ADMIN.noclipEntity, camCoords.x, camCoords.y, camCoords.z)

	end

	RegisterNetEvent('laot-core:freezeToggle')
	AddEventHandler('laot-core:freezeToggle', function()
		print("Donduruldun!")
		local player = PlayerId()
		local ped = PlayerPedId()

		if not user.freeze then
			user.freeze = true
			SetEntityCollision(ped, false)
			FreezeEntityPosition(ped, true)
			SetPlayerInvincible(player, true)

			if not IsPedFatallyInjured(ped) then
				ClearPedTasksImmediately(ped)
			end
		else
			SetEntityCollision(ped, true)
			if not IsEntityVisible(ped) then
				SetEntityVisible(ped, true)
			end

			if not IsPedInAnyVehicle(ped) then
				SetEntityCollision(ped, true)
			end

			FreezeEntityPosition(ped, false)
			SetPlayerInvincible(player, false)
		end
	end)

	RegisterCommand("fixnoclip", function()
		ESX.TriggerServerCallback("laot-core:GetGroup", function(group)
			if group == "superadmin" then
				noclipOff()
			end
		end, GetPlayerServerId(PlayerId()))
	end)

	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(0)
			if IsControlJustPressed(0, LAOT.adminSettings.noclipKey) then
				ESX.TriggerServerCallback("laot-core:GetGroup", function(group)
					if not ADMIN.noclip then
						if group == "superadmin" then
							noclipOn()
						end
					elseif ADMIN.noclip then
						if group == "superadmin" then
							noclipOff()
						end
					end
				end, GetPlayerServerId(PlayerId()))
			end
			if IsControlJustPressed(0, LAOT.adminSettings.menuKey) then
				TriggerServerEvent("laot-core:openAdminMenuServer", GetPlayerServerId(PlayerId()))
			end
		end
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

	RegisterNetEvent('laot-core:openSelectedPlayer')
	AddEventHandler('laot-core:openSelectedPlayer', function()
		if ADMIN.selectedPlayer.id and ADMIN.selectedPlayer.playerName then

			local currentPlayerID = GetPlayerServerId(PlayerId())

			local elements = {}

			--[[
					{ label = "".. l.spectate_player .."", name = "spectate", id = ADMIN.selectedPlayer.id },
					{ label = "".. l.kick_player .."", name = "kick", id = ADMIN.selectedPlayer.id },
					{ label = "".. l.freeze_player .."", name = "freeze", id = ADMIN.selectedPlayer.id },
			]]

			if LAOT.adminGrades[ADMIN.grade].kick then
				table.insert(elements, { label = "".. l.kick_player .."", name = "kick", id = ADMIN.selectedPlayer.id })
			end

			if LAOT.adminGrades[ADMIN.grade].freeze then
				table.insert(elements, { label = "".. l.freeze_player .."", name = "freeze", id = ADMIN.selectedPlayer.id })
			end

			if LAOT.adminGrades[ADMIN.grade].spectate then
				table.insert(elements, { label = "".. l.spectate_player .."", name = "spectate", id = ADMIN.selectedPlayer.id })
			end

			ESX.UI.Menu.CloseAll()
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'players',
			{
				title    = ('- '.. ADMIN.selectedPlayer.playerName ..' ['.. ADMIN.selectedPlayer.id ..']'),
				align = 'top-right', -- Menu position
				elements = elements
			},
			function(data, menu)
				if data.current.name then
					if data.current.name == "spectate" then
						if data.current.id ~= currentPlayerID then
							spectate(data.current.id)
						else
							ESX.ShowNotification("Kendinizi gözetleyemezsin!")
						end
					end
					if data.current.name == "kick" then
						if data.current.id ~= currentPlayerID then
							TriggerServerEvent("laot-core:dropPlayer", data.current.id)
							TriggerEvent("laot-core:openPlayersMenu")
						else
							ESX.ShowNotification("Kendinizi atamazsınız!")
						end
					end
					if data.current.name == "freeze" then
						TriggerServerEvent("laot-core:freezeServer", data.current.id)
					end
				end
			end,
			function(data, menu)
			  menu.close()
			  resetNormalCamera()
			  TriggerEvent("laot-core:openPlayersMenu")
			end)
		else
			ESX.ShowNotification("HATA #7410: Kişi bulunamadı.")
		end
	end)

	RegisterNetEvent('laot-core:openPlayersMenu')
	AddEventHandler('laot-core:openPlayersMenu', function()
		local elements = {}
		local online = 0

		local players = ESX.Game.GetPlayers()

		for k, player in pairs(players) do
			local playerPed = GetPlayerPed(player)
			local playerName = GetPlayerName(player)
			local id = GetPlayerServerId(player)
			online = online + 1
			
			table.insert(elements, { label = "".. playerName .." [".. id .."]", name = id, playerName = playerName })
		end

		local currentPlayerID = GetPlayerServerId(PlayerId())

		ESX.UI.Menu.CloseAll()
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'players',
		{
			title    = ('- ONLINE PLAYERS ['.. online ..']'),
			align = 'top-right', -- Menu position
			elements = elements
		},
		function(data, menu)
			if data.current.name and data.current.playerName then
				ADMIN.selectedPlayer.id = data.current.name
				ADMIN.selectedPlayer.playerName = data.current.playerName
				TriggerEvent("laot-core:openSelectedPlayer")
			end
		end,
		function(data, menu)
		  menu.close()
		  TriggerEvent("laot-core:openAdminMenu", ADMIN.grade)
		end)
	end)


	RegisterNetEvent('laot-core:openAdminMenu')
	AddEventHandler('laot-core:openAdminMenu', function(grade)
		local elements = {}

		ADMIN.grade = grade

		table.insert(elements, { label = (l.players), name = "players" })

		if LAOT.adminGrades[ADMIN.grade].player_blips then

			if ADMIN.player_blips then
				table.insert(elements, { label = (''.. l.player_blips ..' - '.. TEXT.on ..''), name = "player_blips" })
			else
				table.insert(elements, { label = (''.. l.player_blips ..' - '.. TEXT.off ..''), name = "player_blips" })
			end

		end

		if LAOT.adminGrades[ADMIN.grade].player_names then

			if ADMIN.player_names then
				table.insert(elements, { label = (''.. l.player_names ..' - '.. TEXT.on ..''), name = "player_names" })
			else
				table.insert(elements, { label = (''.. l.player_names ..' - '.. TEXT.off ..''), name = "player_names" })
			end

		end

		if LAOT.adminGrades[ADMIN.grade].repair then
			if IsPedInAnyVehicle(PlayerPedId(), true) then
				table.insert(elements, { label = (''.. l.repair ..''), name = "repair" })
			end
		end

		ESX.UI.Menu.CloseAll()
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menu',
		{
			title    = (' - ADMIN MENU '.. version ..''),
			align = 'top-right', -- Menu position
			elements = elements
		},
		function(data, menu)
			if data.current.name then
				if data.current.name == "players" then
					TriggerEvent("laot-core:openPlayersMenu")
				end
				if data.current.name == "player_blips" then
					if not ADMIN.player_blips then
						ADMIN.player_blips = true
					elseif ADMIN.player_blips then
						ADMIN.player_blips = false
					end	
					TriggerEvent("laot-core:openAdminMenu", grade)
				end
				if data.current.name == "player_names" then
					if not ADMIN.player_names then
						ADMIN.player_names = true
					elseif ADMIN.player_names then
						ADMIN.player_names = false
					end	
					TriggerEvent("laot-core:openAdminMenu", grade)
				end
				if data.current.name == 'repair' then
					local vehicle = GetVehiclePedIsIn(PlayerPedId(), true)
					SetVehicleEngineHealth(vehicle, 1000)
					SetVehicleEngineOn( vehicle, true, true )
					SetVehicleFixed(vehicle)
				end

			end
		end,
		function(data, menu)
		  menu.close()
		end)
	end)


end

if LAOT.giyin then
	RegisterCommand("giyin", function()
		local playerPed = GetPlayerPed(-1)
		ESX.TriggerServerCallback('laot-core:GetSkin', function(skin)
			if skin then
				print("Skinniz var.")
				TriggerEvent('skinchanger:loadSkinToPed', playerPed, skin)
			end
		end, GetPlayerServerId(PlayerId()))
	end)
end

if LAOT.deathToVehicle then
	RegisterCommand("ölübindir", function()
		local playerPed = PlayerPedId()

		if not IsPedSittingInAnyVehicle(playerPed) then
			local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
			local closestPed = GetPlayerPed(closestPlayer)
			if closestPlayer ~= -1 and closestDistance <= 3.0 then
				print(closestPlayer.. 'bindiriliyor..')
				ESX.TriggerServerCallback('laot-core:isDead', function(isPedDead)
					if isPedDead then
						local closestVehicle, closestDistance = ESX.Game.GetClosestVehicle()
						if closestDistance <= 5.0 then
							local seat1 = IsVehicleSeatFree(closestVehicle, 0)
							if seat1 then
								SetPedIntoVehicle(closestPed, closestVehicle, 0)
							else
								local seat2 = IsVehicleSeatFree(closestVehicle, 1)
								if seat2 then
									SetPedIntoVehicle(closestPed, closestVehicle, 1)
								else
									local seat2 = IsVehicleSeatFree(closestVehicle, 2)
									if seat2 then
										SetPedIntoVehicle(closestPed, closestVehicle, 2)
									else
										ESX.ShowNotification("Boş koltuk yok!")
									end
								end
							end
						end
					else
						ESX.ShowNotification("Bu adam ölü değil.")
					end
				end, GetPlayerServerId(closestPlayer))
			end
		else
			ESX.ShowNotification("Bunun için araçtan inmen gerek!")
		end
	end)
end

if LAOT.removeCashAndBank then
	Citizen.CreateThread(function()
		RemoveMultiplayerHudCash(0x968F270E39141ECA)
		RemoveMultiplayerBankCash(0xC7C6789AA1CFEDD0)
	end)
end

if LAOT.crouch then
	local crouched = false
	Citizen.CreateThread( function()
		while true do 
			Citizen.Wait( 1 )
			local ped = GetPlayerPed( -1 )
			if ( DoesEntityExist( ped ) and not IsEntityDead( ped ) ) then 
				DisableControlAction( 0, 36, true ) -- INPUT_DUCK  
				if ( not IsPauseMenuActive() ) then 
					if ( IsDisabledControlJustPressed( 0, 36 ) ) then 
						RequestAnimSet( "move_ped_crouched" )

						while ( not HasAnimSetLoaded( "move_ped_crouched" ) ) do 
							Citizen.Wait( 200 )
						end 

						if ( crouched == true ) then 
							ResetPedMovementClipset( ped, 0 )
							crouched = false 
						elseif ( crouched == false ) then
							SetPedMovementClipset( ped, "move_ped_crouched", 0.25 )
							crouched = true 
						end 
					end
				else
					Citizen.Wait(300)
				end
			else
				Citizen.Wait(1000)
			end
		end
	end )
end